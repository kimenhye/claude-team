[100407/김은혜] - 부서/팀: 엣지솔루션팀

# AI 업무 혁신 5회차 주간보고

## 1) AI 적용 업무

### 업무1: EdgeSquare 라이선스 모드 시스템 설계 및 구현 (ESQ-342)

**기존:** 라이선스 검증 로직이 단순 유효성 체크만 수행. 정식 라이선스 없으면 시스템 기동 불가. 라이선스 상태와 제품 모드(Manager/Monitor) 간 연동 없음. 메뉴 필터링도 하드코딩 방식.

**AI 적용:**
- Claude Code를 활용하여 **분석→설계→구현→테스트→코드리뷰→문서화** 전 과정을 AI와 협업
- 설계 문서(SDD-13) 작성부터 AI가 기존 코드 분석 → AS-IS/TO-BE 설계 → 코드 생성 → 리뷰까지 수행
- 백엔드 7개 파일(LicenseService, AdminUserController, StartManagerSpringApplication, ConfigKey, LicenseController 등) + 프론트엔드 4개 파일(login.xml, login.js, infoall.xml, infoall.js) + DDL 4개 벤더 일괄 수정
- GitHub 설계 문서(SDD-13) v1.0→v3.1까지 AI가 코드 변경에 맞춰 자동 갱신

**결과:**
- 데모 라이선스 폴백 체계 구현 완료 (정식 → 데모 → 기본값 3단계 폴백)
- 로그인 차단 없는 경고 팝업 방식 (만료/만료임박/미등록 3가지 시나리오)
- 제품 모드 기반 메뉴 필터링 (데모/정식 동일 동작) — buildMenuInfo() 리팩토링
- 설계 문서 GitHub 자동 관리: https://github.com/kimenhye/claude-team/blob/main/.claude/docs/SDD_13_license.md

### 업무2: 프로세스 현황 필터 검색 기능 구현 (ESQ-540)

**기존:** 프로세스 현황 화면의 checkcombobox 필터에 항목이 611개까지 존재. 스크롤로만 탐색 가능하여 원하는 항목 찾기 어려움.

**AI 적용:**
- Claude Code로 WebSquare checkcombobox 컴포넌트 DOM 구조 분석
- MutationObserver 기반 드롭다운 감지 + 검색 input 자동 삽입 패턴을 AI가 설계
- 한글 IME 이슈(input 이벤트 간섭)를 AI가 진단 → keyup + 50ms 디바운스 해결책 제시

**결과:**
- 5개 checkcombobox 필터에 드롭다운 내 실시간 검색 기능 추가
- process_list.xml + _wpack_/process_list.js 양쪽 동시 수정 완료
- 다른 화면의 checkcombobox에도 재사용 가능한 공통 패턴 확보

### 업무3: 공지사항 예약발송 시간 동기화

**기존:** 공지사항 예약발송 시 서버 시간과 DB 시간 불일치로 발송 타이밍 오차 발생 가능.

**AI 적용:**
- Claude Code로 NoticeService 코드 분석 → 시간 동기화 로직 설계 및 구현

**결과:**
- NoticeService에 서버 시간 기준 동기화 로직 추가 (22줄 변경)

### 업무4: DB 벤더별 마이그레이션 DDL 분리

**기존:** 단일 migration_rename_tables.sql 파일에 모든 DB 벤더 DDL이 혼재 (263줄). 벤더별 적용 시 수동 분리 필요.

**AI 적용:**
- Claude Code로 기존 통합 SQL을 4개 벤더(MariaDB/MySQL, Oracle/Tibero, PostgreSQL, SQLServer)별로 자동 분리

**결과:**
- 벤더별 독립 migration_table.sql 생성 (4파일, +293줄)
- 기존 통합 파일 제거 (-263줄)
- 벤더별 DDL 문법 차이 자동 반영

### 업무5: Gmail MCP 연동으로 업무 메일 자동 조회

**기존:** 메일 확인을 위해 브라우저에서 Gmail 접속 → 검색 → 내용 확인 → 다시 개발 환경으로 전환. 컨텍스트 스위칭 발생.

**AI 적용:**
- Claude Code에 Gmail MCP(Model Context Protocol) 서버 연동
- 터미널에서 바로 발신자/날짜 기준 메일 검색 및 본문 조회 가능
- 주간보고 마감 안내, 4회차 결과 공유 등 업무 메일을 개발 환경 내에서 즉시 확인

**결과:**
- 개발 작업 중 브라우저 전환 없이 메일 확인 → **컨텍스트 스위칭 제거**
- 메일 내용을 AI가 요약/정리하여 바로 업무에 활용 (예: 주간보고 양식 추출 → 보고서 초안 자동 작성)
- 검색~확인~정리까지 기존 5~10분 → 30초 = **약 90% 절감**

### 업무6: 데일리 리포트 자동화 (Remote Trigger)

**기존:** 매일 퇴근 전 수동으로 당일 작업 내역 정리.

**AI 적용:**
- Claude Code Remote Trigger로 **평일 16:50 KST** 자동 실행 스케줄 구성
- EdgeSquare git log 수집 → claude-team/daily/{날짜}.md 자동 생성 → INDEX.md 갱신 → git push

**결과:**
- Trigger ID: trig_015L1e5Taycceo8jivJB1kEg
- 매일 자동으로 데일리 리포트 생성/커밋/푸시 — **수동 정리 시간 0분** (기존 15~20분)
- cron: `50 7 * * 1-5` (UTC) = 평일 16:50 KST

---

## 2) 정량 성과

- **커밋 수:** EdgeSquare 10커밋 + claude-team 1커밋 = **11커밋**
- **코드 변경량:** +1,326줄 / -776줄 = **총 2,102줄**
- **수정 파일:** 백엔드 Java 7개 + 프론트엔드 XML/JS 6개 + DDL 8개 + 설계문서 1개 = **22개 파일**
- **시간 절감:**
  - 라이선스 시스템 설계+구현+문서화: 기존 예상 3일 → AI 협업 1일 = **약 66% 절감**
  - DDL 벤더 분리: 기존 수동 2시간 → AI 10분 = **약 92% 절감**
  - 데일리 리포트: 매일 15~20분 → 0분 (자동화) = **100% 자동화**
- **자동화율:** 데일리 리포트 Remote Trigger 상시 운영 (평일 매일 자동 실행)

---

## 3) 지원 필요사항

- agmon 실행 시 Claude Code Remote Trigger 사용량이 별도로 잡히는지 확인 필요 (현재 웹 기반 트리거라 로컬 agmon에 미집계 가능성)

---

## 4) 다음 주 적용 계획

- 신한투자증권 WGear SSL 이슈 해결 후 배포 검증에 AI 활용
- EdgeSquare 라이선스 관련 추가 요건(RUM/Publish UI 라이선스 경고 적용) AI 협업 구현
- 주간보고 자동 생성 스케줄 추가 검토 (데일리 리포트 → 주간 집계 파이프라인)

---

## 5) 증적 링크

| 항목 | 링크 |
|------|------|
| 설계 문서 (SDD-13 v3.1) | https://github.com/kimenhye/claude-team/blob/main/.claude/docs/SDD_13_license.md |
| 데일리 리포트 Trigger | https://claude.ai/code/scheduled/trig_015L1e5Taycceo8jivJB1kEg |
| AI 개발 워크플로우 | https://github.com/kimenhye/claude-team/blob/main/workflow/ai-dev-workflow.md |

---

## 자동화 파이프라인 요약

```
[Claude Code CLI] ─── 분석→설계→구현→테스트→코드리뷰→PR (6 Phase 워크플로우)
       │
       ├── /dev-docs 커맨드 ─── 장기 작업 3파일 패턴 자동 생성
       ├── /dev-docs-update 커맨드 ─── 세션 종료 시 상태 자동 갱신
       ├── Gmail MCP 연동 ─── 터미널에서 메일 검색/조회/요약 (컨텍스트 스위칭 제거)
       └── Remote Trigger (cron) ─── 평일 16:50 데일리 리포트 자동 생성/푸시
```
