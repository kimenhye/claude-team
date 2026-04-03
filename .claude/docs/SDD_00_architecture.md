# SDD - 시스템 아키텍처 (전체 개요)

| 항목 | 내용 |
|------|------|
| 문서 버전 | v1.0 |
| 작성일 | 2026-04-03 |
| 대상 시스템 | EdgeSquare (W-EdgeManager) |

---

## 1. 개요

### 1.1 목적
EdgeSquare는 엔터프라이즈 환경에서 Edge 디바이스를 중앙 관리하는 통합 플랫폼이다.

### 1.2 용어 정의

| 용어 | 설명 |
|------|------|
| Edge | 관리 대상 디바이스 |
| EdgeSquare | 제품명 |
| Manager Server | 중앙 관리 서버 (Spring Boot) |
| Agent | Edge에 설치되는 클라이언트 |
| WebSquare | 프론트엔드 UI 프레임워크 |
| AppId | 관리 대상 앱 식별자 |

### 1.3 모듈별 SDD 문서

| No | 문서 | 모듈 |
|----|------|------|
| 01 | SDD_01_edge_device.md | Edge 디바이스 관리 |
| 02 | SDD_02_file_distribution.md | 파일 배포 |
| 03 | SDD_03_mobile_app_dist.md | 모바일 앱 배포 |
| 04 | SDD_04_monitoring.md | 모니터링/로깅 |
| 05 | SDD_05_notice.md | 공지 관리 |
| 06 | SDD_06_policy.md | 정책 관리 |
| 07 | SDD_07_matrix.md | Matrix 관리 |
| 08 | SDD_08_deployer.md | 배포(Deployer) |
| 09 | SDD_09_organization.md | 조직/부서 관리 |
| 10 | SDD_10_audit_log.md | 감사 로그 |
| 11 | SDD_11_relay_proxy.md | 릴레이/프록시 |
| 12 | SDD_12_terminal.md | 터미널 지원 |
| 13 | SDD_13_license.md | 라이선스 관리 |

---

## 2. 시스템 아키텍처

### 2.1 전체 구성도

```
[Client UI] --REST API--> [Manager Server :8081/esq] ---> [Edge Agent]
(WebSquare)               (Spring Boot 3.0.13)            (Windows/etc)
                          [Hazelcast] [Nitrite]
                          [RDBMS: Oracle/MariaDB/PostgreSQL/MSSQL/DB2/Tibero/H2/SQLite]
```

### 2.2 기술 스택

| 구분 | 기술 |
|------|------|
| Frontend | WebSquare 5 SP5, XML UI, JavaScript, Webpack |
| Backend | Spring Boot 3.0.13, Java 17, Spring Security, JPA |
| Database | Oracle, MariaDB, PostgreSQL, MSSQL, DB2, Tibero, H2, SQLite, Nitrite |
| 클러스터링 | Hazelcast 4.2.8 |
| 빌드 | Gradle 8.14 |
| API 문서 | Swagger/OpenAPI 3.0 |
| 인증 | JWT, Spring Security |
| 실시간 | WebRTC, SSE |

### 2.3 주요 설정
- Port: 8081, Context: /esq
- Main Class: StartManagerSpringApplication
- Product: EdgeSquare v2.2

---

## 3. 변경 이력

| 버전 | 일자 | 변경 내용 |
|------|------|-----------|
| v1.0 | 2026-04-03 | 최초 작성 |
