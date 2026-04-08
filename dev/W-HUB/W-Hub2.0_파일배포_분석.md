# W-Hub2.0 파일 배포 기능 분석

## 1. 개요

W-Hub2.0은 **Maven 멀티모듈 Spring Boot 프로젝트**(Spring Boot 1.5.19, Java 1.8)로, 관리자가 업로드한 파일을 단말에 설치된 **WGEAR 에이전트**에게 실시간으로 배포하는 시스템이다.

### 모듈 구성

| 모듈 | 패키징 | 포트 | 역할 |
|------|--------|------|------|
| `commons` | JAR | - | 공통 라이브러리 (Entity, Service, DAO) |
| `web` | WAR | 6060 | 관리자 Web UI, 파일 업로드/서빙 |
| `websocket` | WAR | 1337 | WebSocket 통신, 배포 알림/체크 |

### 배포 유형

| 유형 | 설명 |
|------|------|
| WGEAR Distribution | 일반 파일 배포 (DLL 등) |
| Update Distribution | OS/앱별 업데이트 배포 |
| BigFileDist | 대용량 파일 배포 |

---

## 2. 다운로드 주체: WGEAR 에이전트

**WGEAR는 배포 대상 모든 단말에 설치된 에이전트 프로그램**이다. 전용브라우저와는 별개의 프로그램으로, 파일 배포의 실제 다운로드 주체이다.

- 서버 코드의 `Wgear` 접두사 클래스(`WgearDistService`, `WgearUpdateCheckHandler`)는 이 에이전트 대상 배포 로직
- `appId` 예시: `Windows.SHBHTGlobal.Prod`
- `Device` 엔티티로 각 단말의 배포 상태를 추적

---

## 3. 전체 배포 흐름

```
[관리자 Web UI]                [W-Hub 서버]              [WGEAR 에이전트 (단말)]
  (포트 6060)                  (포트 1337)               모든 단말에 설치됨
      │                            │                          │
      │── 파일 업로드 ────────────→│                          │
      │   POST /deploy/fileUpload  │                          │
      │                            │                          │
      │── 배포 등록 ─────────────→│                          │
      │   POST /wgeardist/upload   │                          │
      │   (버전, scope, 대상부서)   │                          │
      │                            │                          │
      │                            │←── WebSocket 접속 ───────│
      │                            │    CL_MSG_UPDATE_CHECK    │
      │                            │    (현재버전, appId 등)    │
      │                            │                          │
      │                            │─── 업데이트 정보 응답 ──→│
      │                            │    (파일목록, 다운로드URL) │
      │                            │                          │
      │                            │←── HTTP GET 파일 다운로드 │
      │                            │    /distribution/{ver}/..│
      │                            │─── 파일 응답 ───────────→│
      │                            │                          │
      │                            │←── 결과 보고 (WebSocket) ─│
```

---

## 4. 단계별 상세

### 4.1 관리자: 파일 업로드

**엔드포인트**: `POST /deploy/fileUpload.do` (WgearDistController)

- `CommonsMultipartFile`로 파일 수신
- `target` 헤더로 대상 지정
- 저장 위치: `distFolder/{target}/{fileName}`

### 4.2 관리자: 배포 등록

**엔드포인트**: `POST /wgeardist/upload.do` (WgearDistController)

**요청 데이터 (WgearDistDTO)**:
- `appId`: 앱 식별자 (예: `Windows.SHBHTGlobal.Prod`)
- `version`: 배포 버전 (타임스탬프 기반)
- `scope`: `T`(시범) / `F`(전체)
- `targetCode`: 대상 부서/그룹 코드 목록
- `executeDate`: 배포 예정 일시
- `executor`: 실행 관리자

**서버 처리**:
1. `WgearDistService.setDeployFiles()` → `distFolder/` → `distStorage/{version}/`으로 파일 복사
2. 파일별 해시값(`compareKey`) 생성
3. DB 등록:
   - `WSQ_DISTS` — 배포 레코드 (status=`R` 예약)
   - `WSQ_DIST_FILES` — 파일 목록 (경로, 해시, 실행순서)
   - `WSQ_DIST_DEPARTMENTS` — 대상 부서
4. `scope=F`(전체)인 경우 이전 버전 모두 종료 처리

### 4.3 WGEAR 에이전트: 업데이트 체크 (WebSocket)

**메시지 타입**: `CL_MSG_UPDATE_CHECK`

**처리 핸들러**: `WgearUpdateCheckHandler`

```
1. Device 조회 (userId + osType + appId)
2. 예약 배포(advance) 확인 → checkAdvance(device)
3. 최신 배포 버전 조회 → getLatestDist(checkUpdate)
4. 클라이언트 버전과 비교:
   ├─ 동일         → UPDATE_STATUS_LATEST (이미 최신)
   ├─ executeDate 미도래 → UPDATE_STATUS_RESERVE (예약됨)
   └─ executeDate 경과   → UPDATE_STATUS_OLD (배포 대상)
5. 파일 목록 + 다운로드 URL 응답
6. Device 레코드 업데이트 (distVersion, distState)
```

**응답 데이터 (ClientUpdateCheckDTO)**:
```json
{
  "msgType": "CL_MSG_UPDATE_CHECK",
  "updateCheckStatus": "UPDATE_STATUS_OLD",
  "distVersion": "v1.2.3",
  "distType": "DISTRIBUTION",
  "domainName": "http://server:60601/distribution/",
  "filesList": [
    {
      "path": "v1.2.3/bin/app.dll",
      "compareKey": "SHA256해시값",
      "destPath": "C:\\Program Files\\App\\",
      "type": "copy",
      "orderOfExecution": 1
    }
  ]
}
```

### 4.4 WGEAR 에이전트: 파일 다운로드 (HTTP)

- **WebSocket은 알림/제어 전용** — 파일 자체는 HTTP로 다운로드
- `GET http://server/distribution/{version}/{filepath}`
- 서버 측: Spring `ResourceHandler`로 정적 파일 서빙

```java
// WebConfig.java
registry.addResourceHandler("/distribution/**")
    .addResourceLocations("file:" + distFolderPath + "/");
```

- `compareKey`(해시)로 파일 무결성 검증
- `destPath`에 파일 배치
- `orderOfExecution` 순서대로 실행

---

## 5. 파일 저장 구조

```
distFolder/                    ← 관리자 업로드 원본
  └── {target}/
      └── {fileName}

distStorage/                   ← 버전별 스냅샷 (배포 시 복사)
  └── {version}/
      ├── bin/app.dll
      └── config/settings.xml

updateFolder/                  ← 업데이트 원본
updateStorage/                 ← 업데이트 버전별 스냅샷
```

**설정 경로** (application.yml):
```yaml
whub:
  distribution:
    file:
      deployResourcePath: C:/test/deploy/distFolder      # 개발
      deployStoragePath: C:/test/deploy/distStorage
    update:
      deployResourcePath: C:/test/deploy/updateFolder
      deployStoragePath: C:/test/deploy/updateStorage
  web:
    domain:
      file: http://localhost:60601/distribution/          # 다운로드 URL
      update: http://localhost:60601/update/
```

---

## 6. 배포 상태 관리

### 배포 레코드 (WgearDist)

| 필드 | 설명 |
|------|------|
| `appId` | 앱 식별자 |
| `version` | 배포 버전 |
| `scope` | `T`(시범) / `F`(전체) |
| `status` | `R`(예약) → `S`(시작) → `F`(완료) / `C`(취소) |
| `latest` | `Y` — 최신 배포만 조회 대상 |
| `executor` | 실행 관리자 |
| `executeDate` | 배포 예정 일시 |
| `targetCode` | 대상 부서/그룹 코드 |

### 디바이스 (Device)

| 필드 | 설명 |
|------|------|
| `osType` | OS 종류 (Windows, iOS, Android) |
| `appId` | 클라이언트 앱 식별자 |
| `userId` | 사용자 ID |
| `distVersion` | 현재 적용된 배포 버전 |
| `distState` | 배포 상태 (`S`=성공) |
| `updateVersion` | 현재 적용된 업데이트 버전 |

---

## 7. 주요 클래스 맵

### 컨트롤러 (REST)

| 클래스 | 모듈 | 역할 |
|--------|------|------|
| `WgearDistController` | web | 파일 업로드, 배포 등록/조회 |
| `BigFileDistController` | web | 대용량 파일 배포 관리 |
| `DeployController` | websocket | REST 업데이트 체크 (하위호환) |

### WebSocket 핸들러

| 클래스 | 메시지 타입 | 역할 |
|--------|-------------|------|
| `WgearUpdateCheckHandler` | `CL_MSG_UPDATE_CHECK` | 배포/업데이트 체크 및 응답 |
| `RequestUploadFileHandler` | `CL_MSG_REQUEST_LOG_DOWNLOAD` | 파일 업로드 요청 |
| `UploadFilePassHandler` | (Binary) | 바이너리 파일 전송 (단말→관리자) |
| `HandlerManager` | - | WebSocket 메시지 라우팅 |

### 서비스

| 클래스 | 모듈 | 역할 |
|--------|------|------|
| `WgearDistService` | commons | 파일 복사, 버전 관리, DB 등록 |
| `UpdateService` | commons | OS별 업데이트 배포 로직 |
| `BigFileDistService` | commons | 대용량 파일 배포 |
| `DeviceService` | commons | 디바이스 상태 관리 |

### DAO

| 클래스 | 역할 |
|--------|------|
| `WgearDistDao` | 배포 이력, 파일 목록, 대상 부서 CRUD |
| `UpdateDao` | 업데이트 배포 CRUD |

---

## 8. Bus 네트워크 (원격 릴레이)

직접 WebSocket 연결이 안 되는 원격 단말을 위해 **Bus 서버 중계** 구조를 지원한다.

- `BusManager`: Bus 서버 연결 관리
- `BusWebsocketHandler`: Bus 메시지 중계
- 바이너리 파일 전송 시 관리자 세션이 없으면 Bus를 통해 포워딩

```yaml
whub:
  websocket:
    address:
      # - ws://192.168.150.175:1337   # Bus 서버 주소
```

---

## 9. 요약

| 항목 | 내용 |
|------|------|
| **다운로드 주체** | WGEAR 에이전트 (단말 설치 프로그램) |
| **알림 채널** | WebSocket (포트 1337) |
| **다운로드 채널** | HTTP GET (포트 6060) |
| **파일 무결성** | compareKey (해시) 검증 |
| **배포 범위** | scope T(시범) / F(전체) |
| **배포 예약** | executeDate 기반 예약 배포 지원 |
| **DB** | Oracle (JDBC, HikariCP) |
| **WAS** | JEUS 또는 내장 Tomcat |
