# EdgeSquare 라이선스 발급 기준

| 항목 | 내용 |
|------|------|
| 문서 버전 | v1.0 |
| 작성일 | 2026-04-03 |
| 대상 시스템 | EdgeSquare (W-EdgeManager) |

---

## 1. 라이선스 구성 요소

### 1.1 라이선스 파일

| 항목 | 설명 |
|------|------|
| 파일명 | `license_EdgeSquare` |
| 형식 | Base64 + DES 암호화 JSON |
| 위치 | `${application.path.home}/license/` |

### 1.2 라이선스 필드 정의

| 필드 | 설명 | 값 범위 | 비고 |
|------|------|---------|------|
| sLicenseTrgtCd | 제품 코드 | 콤마 구분 코드 | 필수 |
| sMaxAdmin | 최대 관리자 수 | 양수 또는 -1 | -1 = 무제한 |
| sMaxUser | 최대 Agent(Edge) 수 | 양수 또는 -1 | -1 = 무제한 |
| sMaxServer | 최대 클러스터 서버 수 | 양수 또는 -1 | -1 = 무제한 |
| sExpiredDt | 만료일 | yyyyMMdd | 정보성 표시 |

---

## 2. 제품 코드 (sLicenseTrgtCd)

| 코드 | 제품명 | 설명 |
|------|--------|------|
| 32 | Manager | Edge 디바이스 관리 (배포, 공지, 정책 등) |
| 33 | Monitor | 모니터링/로깅 (대시보드, APM, 로그 수집) |
| 34 | Deploy | 배포 전용 |
| 0 | - | 미등록 |

### 2.1 제품 조합별 동작 모드

| 조합 | edgesquare.mode | 활성화 모듈 |
|------|----------------|-------------|
| 32 | manager | Edge 관리 기능만 |
| 33 | monitor | 모니터링 기능만 |
| 32,33 | monitor | Edge 관리 + 모니터링 (풀 패키지) |
| 32,34 | manager | Edge 관리 + 배포 |
| 32,33,34 | monitor | 전체 기능 |
| 미등록 | monitor (기본값) | 모니터링 기본 |

> **주의**: sLicenseTrgtCd에 "33"이 포함되면 monitor 모드, 미포함이면 manager 모드

---

## 3. 수량 제한 기준

### 3.1 sMaxAdmin (관리자 수)

| 등급 | 값 | 설명 |
|------|------|------|
| 소규모 | 3 | 관리자 3명 |
| 중규모 | 10 | 관리자 10명 |
| 대규모 | 30 | 관리자 30명 |
| 무제한 | -1 | 제한 없음 |

- **현행 동작**: 초과 시 경고만 표시, 강제 차단 없음
- **확인 화면**: 설정 > 계정 관리 (`/setting/account.xml`)

### 3.2 sMaxUser (Agent/Edge 수)

| 등급 | 값 | 설명 |
|------|------|------|
| 소규모 | 50 | Edge 50대 |
| 중규모 | 100 | Edge 100대 |
| 대규모 | 500 | Edge 500대 |
| 엔터프라이즈 | 1000+ | Edge 1000대 이상 |
| 무제한 | -1 | 제한 없음 |

- **현행 동작**: 초과 시 신규 Agent 접속 차단 (빈 토큰 반환)
- **확인**: Agent 접속 시 `EdgeRegisterController.verify()`에서 검증

### 3.3 sMaxServer (클러스터 서버 수)

| 등급 | 값 | 설명 |
|------|------|------|
| 단일 | 1 | 단독 서버 |
| 이중화 | 2 | Active-Standby |
| 클러스터 | 3+ | Hazelcast 클러스터 |
| 무제한 | -1 | 제한 없음 |

---

## 4. Feature Flag (기능 라이선스)

Feature Flag는 라이선스 파일과 별도로 `em_preference` 테이블에서 관리된다.

### 4.1 Feature Flag 목록

| Flag | 기본값 | 설명 | 영향 범위 |
|------|--------|------|-----------|
| license.feature.organization | true | 조직/부서 기능 | 공지 대상 선택, 배포 대상 선택 |
| license.feature.group | true | 그룹 기능 | 공지 대상 선택, 그룹 관리 |
| license.feature.distribute.apply | false | 배포 승인 워크플로우 | 파일 배포 시 승인 절차 |
| license.feature.mobileAppDist | true | 모바일 앱 배포 | 모바일 앱 배포 메뉴 |

### 4.2 Feature Flag 조합 시나리오

| 시나리오 | organization | group | distribute.apply | mobileAppDist |
|----------|-------------|-------|-----------------|---------------|
| 기본 구성 | true | true | false | true |
| 최소 구성 | false | false | false | false |
| 보안 강화 | true | true | true | true |
| 조직 전용 | true | false | false | true |
| 그룹 전용 | false | true | false | true |

### 4.3 Feature Flag 비활성 시 동작

| Flag 비활성 | UI 동작 |
|------------|---------|
| organization=false, group=false | 수신 대상 선택 UI 숨김, 전체 발송만 가능 |
| organization=false | 조직 선택 selectbox에서 제거 |
| group=false | 그룹 선택 selectbox에서 제거 |
| distribute.apply=false | 승인 워크플로우 UI 숨김, 직접 배포 |
| mobileAppDist=false | 모바일 앱 배포 메뉴 비활성화 |

---

## 5. 라이선스 발급 등급 (예시)

### 5.1 등급 정의

| 등급 | 제품 코드 | Admin | Agent | Server | Feature Flag |
|------|----------|-------|-------|--------|-------------|
| Trial | 32,33 | 3 | 10 | 1 | 기본 구성 |
| Standard | 32,33 | 10 | 100 | 2 | 기본 구성 |
| Professional | 32,33,34 | 10 | 500 | 3 | 보안 강화 |
| Enterprise | 32,33,34 | -1 | -1 | -1 | 전체 활성화 |

### 5.2 등급별 라이선스 파일 예시

**Standard**
```json
{
  "sMaxAdmin": "10",
  "sMaxUser": "100",
  "sMaxServer": "2",
  "sLicenseTrgtCd": "32,33",
  "sExpiredDt": "20271231"
}
```

**Enterprise**
```json
{
  "sMaxAdmin": "-1",
  "sMaxUser": "-1",
  "sMaxServer": "-1",
  "sLicenseTrgtCd": "32,33,34",
  "sExpiredDt": "20271231"
}
```

---

## 6. 만료일 정책

| 항목 | 현행 |
|------|------|
| 형식 | yyyyMMdd (예: 20261231) |
| 표시 | yyyy-MM-dd 변환 후 UI 표시 |
| 강제 적용 | 없음 (정보성 표시만) |
| 만료 알림 | 없음 |

### 6.1 만료일 관련 고려사항
- 현재 만료일 초과 시 시스템 동작에 영향 없음
- 라이선스 정보 화면(`/xml/licenseInfo.xml`)에서 만료일 확인 가능
- 만료 전 알림 기능 없음 (개선 필요)

---

## 7. 발급 절차

```
1. 고객 요구사항 확인
   - 제품 범위 (Manager/Monitor/Deploy)
   - 관리 대상 Edge 수
   - 관리자 수
   - 클러스터 구성
   - 필요 기능 (Feature Flag)

2. 라이선스 파일 생성
   - JSON 작성 (sMaxAdmin, sMaxUser, sMaxServer, sLicenseTrgtCd, sExpiredDt)
   - DES 암호화 + Base64 인코딩

3. 라이선스 파일 배포
   - ${application.path.home}/license/ 에 license_EdgeSquare 파일 배치
   - 서버 재시작

4. Feature Flag 설정
   - em_preference 테이블에 license.feature.* 값 설정
   - (라이선스 파일과 별도 설정 필요)

5. 검증
   - /api/license/info API로 라이선스 정보 확인
   - /api/license/tracking API로 사용량 확인
   - UI에서 기능 활성화 상태 확인
```

---

## 8. 주의사항

| 항목 | 설명 |
|------|------|
| 서버 재시작 | 라이선스 파일 변경 후 반드시 서버 재시작 필요 |
| Feature Flag | 라이선스 파일과 별도 DB 설정 (자동 연동 안 됨) |
| 클러스터 | 모든 노드에 동일 라이선스 파일 배치 필요 |
| 암호화 키 | 라이선스 파일 내 포함 (자체 포함 구조) |
| 백업 | 라이선스 파일 분실 시 재발급 필요 |

---

## 변경 이력

| 버전 | 일자 | 변경 내용 |
|------|------|-----------|
| v1.0 | 2026-04-03 | 최초 작성 |
