# 주간보고 (2026.03.13 ~ 2026.03.19)

---

## 금주 실적

### 내부 업무

#### 1. [ESQ-229] 공지 기능 수정 — 예약 로직 변경 (완료)

- **Controller → Service 분리**: NoticeController의 비즈니스 로직을 NoticeService로 이관 (Controller 166줄 → 52줄으로 경량화)
- **DTO 신규 생성** (6개):
  - `NoticeDeleteRequestDTO` / `NoticeDeleteResponseDTO`
  - `NoticeGetRequestDTO` / `NoticeGetResponseDTO`
  - `NoticeStorageRequestDTO` / `NoticeStorageResponseDTO`
  - `NoticeUpdateRequestDTO` / `NoticeUpdateResponseDTO`
- **Repository 정비**: NoticeRepository에 복합조건 쿼리 메서드 추가
- **Service 계층 기능 구현**:
  - 공지 저장/수정/삭제/조회/임시저장 서비스 로직 구현
  - 예약 공지 배치 처리 (`@Scheduled`, 10초 간격)
  - SSE 실시간 알림 발송 로직 분리
  - 페이징 처리 적용
- **UI 수정**: notice_versionUp.xml, popup_notice.xml 발송/예약/임시저장 탭 기능 연동
- **변경 규모**: 15개 파일, +506줄 / -248줄

#### 2. [ESQ-448] 공지 웹 에디터 (진행 중)

- `popup_notice.xml` 내용 작성 영역에 **편집/미리보기 탭 전환** 방식 마크다운 에디터 구현
- **marked.js** 라이브러리 추가 (마크다운 → HTML 파싱)
- **GitHub Markdown Light CSS** 적용 (`contents.css`에 통합)
- 마크다운 문법(제목, 굵게, 목록, 코드블록, 테이블 등) 실시간 미리보기 지원

#### 3. 기술지원 문서 양식 작성 (manager 버전)

### 기술지원

#### 미래등기
- 로그 분석 결과 전달 (3/17)

---

## 차주 계획

### 내부 업무
- [ESQ-448] 공지 웹 에디터 계속 진행
- 산업은행 오픈 지원 (3/23)

---

## Issue / 미결사항
- 미래등기 이슈

---

## Claude Code 활용 내역

이번 주 업무에서 Claude Code를 활용하여 다음 작업을 수행했습니다.

### 서버 기동 오류 진단 및 해결
- **문제**: H2 MVStore 포맷 호환성 오류로 서버 기동 실패 (`The write format 1 is smaller than the supported format 2`)
- **분석**: 스택트레이스 분석 → `NitriteRepository.postConstruct()` 에서 이전 포맷(format 1)의 `.mvstore` 파일을 새 버전 H2(format 2)가 읽지 못하는 것이 원인임을 파악
- **해결**: `C:\home\dev\.db`, `C:\home\.fq` 등 산재된 mvstore 파일 463개를 검색·삭제하여 서버 정상 기동 확인
- **소요 시간 절감**: 수동으로 원인을 파악하고 파일을 찾아 삭제하는 작업 대비 약 30분 이상 절감

### 마크다운 에디터 구현 (ESQ-448)
- **CSS 작성**: GitHub Markdown Light 스타일을 참고하여 `contents.css`에 마크다운 렌더링 스타일 약 60줄 추가 (헤딩, 코드블록, 테이블, 리스트, blockquote, alert 등)
- **UI 구현**: `popup_notice.xml`에 편집/미리보기 탭 전환 구조 및 `marked.js` 연동 JS 로직 작성
- **기여도**: CSS + XML + JS 변경 코드 전량 Claude가 작성

### application.yml 변경 분석
- 기존(MariaDB) → 현재(Oracle) 변경 사항 diff 분석
- `edgesquare.mode` 설정 누락, `devtools.restart.enabled` 제거 등 잠재적 이슈 사전 식별
- IntelliJ Tomcat 기동을 위해 확인·복원해야 할 항목 정리

### 주간보고 문서화 및 배포
- git 커밋 로그 기반 주간 작업 내역 자동 수집 및 문서 작성
- GitHub 개인 저장소(`claude-team/daily/`)에 업로드 및 Confluence 내용 통합
