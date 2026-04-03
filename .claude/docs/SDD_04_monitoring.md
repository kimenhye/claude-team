# SDD-04: 모니터링/로깅

| 항목 | 내용 |
|------|------|
| 문서 버전 | v1.0 |
| 작성일 | 2026-04-03 |
| 대상 모듈 | Monitoring & Logging (edgemonitor) |

---

## 1. 개요

### 1.1 목적
Edge 디바이스의 실시간 모니터링, 로그 수집/분석, 성능 측정, 무결성 검증 기능을 설계한다.

### 1.2 범위
- 대시보드 (전체/개별 Edge)
- 로그 수집, 파싱, 조회
- 로그 정책 관리
- 성능 메트릭 수집
- 무결성 정책/검증
- 알림 메시지

---

## 2. 기능 설계

### 2.1 기능 목록

| No | 기능명 | 설명 | 우선순위 |
|----|--------|------|----------|
| 1 | 대시보드 | 전체 Edge 현황 대시보드 | 상 |
| 2 | Edge 대시보드 | 개별 Edge 상세 모니터링 | 상 |
| 3 | 로그 수집 | Edge/Browser/Server 로그 수집 | 상 |
| 4 | 로그 조회 | 수집된 로그 검색/조회 | 상 |
| 5 | 로그 정책 | 로그 수집 정책 설정 | 중 |
| 6 | 성능 메트릭 | APM, 성능 통계 | 중 |
| 7 | 무결성 검증 | 파일 무결성 정책/규칙 관리 | 중 |
| 8 | 알림 | 조건 기반 알림 메시지 | 중 |

### 2.2 로그 처리 파이프라인

```
[Edge Agent] -> [로그 수집] -> [로그 큐] -> [로그 파싱] -> [저장]
[Browser]    -> [Web Agent] ->                              -> [조회/분석]
```

---

## 3. API 설계

| No | Controller | 설명 |
|----|-----------|------|
| 1 | DashboardController | 전체 대시보드 |
| 2 | EdgeDashboardController | 개별 Edge 대시보드 |
| 3 | EdgeApmStaticController | APM 통계 |
| 4 | EdgeIndexController | Edge 인덱스 |
| 5 | EdgeLogController | 로그 관리 |

---

## 4. 데이터 설계

### 4.1 주요 서비스

| 서비스 | 설명 |
|--------|------|
| EdgeLogQueryService | 로그 조회 |
| EdgeLogQueueService | 로그 큐 관리 |
| EdgeLogParseService | 로그 파싱 |
| EdgeLogProduceService | 로그 생성 |
| EdgeLogPolicyService | 로그 정책 |
| EdgeNewLogPolicyService | 신규 로그 정책 |
| IntegrityPolicyService | 무결성 정책 |
| IntegrityPolicyRuleService | 무결성 규칙 |
| EdgeAlertMessageService | 알림 메시지 |
| PerformanceMetricService | 성능 메트릭 |

### 4.2 프론트엔드 로그 클라이언트

| 파일 | 설명 |
|------|------|
| browser-logger.js | 브라우저 로깅 클라이언트 |
| browser-logger-worker.js | 로깅 워커 |
| edgesquare_web_agent*.js | 웹 에이전트 |
| esq_web_agent_rum*.js | RUM 에이전트 |

### 4.3 로그 파서 (Node.js)

| 파일 | 설명 |
|------|------|
| parseLogFromEdgeAgent.js | Edge Agent 로그 파싱 |
| parseLogFromBrowser.js | 브라우저 로그 파싱 |
| parseLogFromEdgeServer.js | Edge Server 로그 파싱 |
| parseAlertPolicy.js | 알림 정책 파싱 |

---

## 5. 화면 설계

| 화면 ID | 파일 경로 | 설명 |
|---------|-----------|------|
| dashboard | /dashboard/ | 대시보드 (위젯 구성) |
| monitoring | /monitoring/ | 실시간 모니터링 |
| realtime | /realtime/ | 실시간 데이터 |
| statistics | /statistics/ | 통계 |
| apm_sample | /apm_sample/ | APM 샘플링 |
| integrity | /integrity/ | 무결성 검증 |
| rum | /rum/ | Real User Monitoring |

---

## 6. 현행 이슈 및 개선사항

| No | 구분 | 현행 | 개선 | 비고 |
|----|------|------|------|------|
| | | | | |

---

## 변경 이력

| 버전 | 일자 | 변경 내용 |
|------|------|-----------|
| v1.0 | 2026-04-03 | 최초 작성 |
