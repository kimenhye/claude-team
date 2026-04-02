# 주간보고 (2026.03.27 ~ 2026.04.02)

---

## 금주 실적

### 내부 업무

#### 1. [ESQ-97] 다국어 지원(i18n) 적용 (완료)

- **다국어 리소스 파일 대규모 확장**: en.js 약 970줄 추가, ko.js 93줄 정비
- **mode-manager 다국어 적용**: edgeList, notice_versionUp, popup_sender, propSetting, user_management 등 11개 파일의 하드코딩 문자열을 다국어 키로 치환
- **변경 파일**: en.js, ko.js, edgeList.xml/js, notice_versionUp.xml/js, popup_sender.xml/js, propSetting.xml/js, user_management.xml

#### 2. [ESQ-511] 구버전 관련 테이블 삭제 및 메뉴 정리 (완료)

- **6개 DB 벤더 DDL 일괄 정리**: MariaDB, Oracle, H2, PostgreSQL, SQLServer, NHBank 전용 DDL에서 구버전 테이블 삭제 (약 187줄 제거)
- **DML 데이터 정리**: manager_lite_DML, DDL_manager_oracle_data 등 연관 데이터 정리
- **변경 파일**: DDL.sql(5개 벤더), DDL_manager_mariaDB.sql, DDL_manager_oracle.sql, DDL_manager_oracle_data.sql, schema-h2.sql

#### 3. 공지사항 / 라이선스 / 사이드메뉴 개선 (진행 중, 미커밋)

- **공지사항 팝업 UI 개선**: popup_notice.xml 대폭 개선 (156줄+ 추가), marked.min.js 라이브러리 추가
- **라이선스 API DTO 생성**: LicenseDataResponseDTO, LicenseTrackingResponseDTO 신규 생성
- **NoticeController 리팩토링**: NoticeApiController 삭제, NoticeController로 통합
- **사이드 메뉴 개선**: side.xml, side.js 수정
- **기타**: account.js, power.js, dept_management.js, user_management_popup.js, common.js, contents.css, index.xml, application.yml, hazelcast.yaml 등 수정
- **변경 규모**: 19개 파일, 약 738줄 추가

### 기술지원

- 없음

---

## 차주 계획

### 내부 업무
- 미커밋 작업(공지사항 UI, 라이선스 API, 사이드메뉴) 마무리 및 커밋
- 추가 다국어 페이지 적용 확대
- 라이선스 트래킹 API 동작 검증

---

## Issue / 미결사항
- 공지사항 팝업 UI, 라이선스 DTO, 사이드메뉴 등 19개 파일 미커밋 상태 — 테스트 후 커밋 예정

---

## Claude Code 활용 내역

### 다국어 리소스 일괄 생성 (ESQ-97)
- **과정**: XML/JS 파일에서 하드코딩된 한글 문자열 자동 추출 → en.js/ko.js 키-값 쌍 일괄 생성 → 11개 파일 자동 치환
- **기여도**: 다국어 키 추출, 리소스 파일 생성, 문자열 치환 코드 전량 Claude 작성
- **효과**: 약 4~5시간 예상 작업을 약 1시간에 완료 (약 75~80% 절감 추정)

### 구버전 테이블 일괄 삭제 (ESQ-511)
- **과정**: 6개 벤더 DDL 파일 스캔 → 구버전 테이블 자동 식별 → 일괄 삭제
- **기여도**: DDL/DML 분석 및 삭제 코드 전량 Claude 작성
- **효과**: 약 1~2시간 예상 작업을 약 15분에 완료 (약 80% 절감 추정)
