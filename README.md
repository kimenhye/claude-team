# claude-team

**Claude Code 기반 풀스택 웹 개발 팀** 프로젝트입니다.

## 개요

이 리포지토리는 Claude Code(Anthropic)를 활용한 개발 작업의 설정, 문서, 로그를 관리합니다.
클론 후 Claude Code를 실행하면 **10명의 전문 서브에이전트 팀이 즉시 가동**됩니다.

## 주요 기능

- **자동 부트스트랩** — `CLAUDE.md`를 통해 세션 프로토콜, 팀 구성, 사용자 선호가 자동 로드
- **10명 서브에이전트 팀** — 팀장이 요청을 분석하여 적합한 담당자에게 자동 분배
- **데일리 로그 시스템** — `daily/INDEX.md` + 날짜별 상세 로그로 세션 간 맥락 유지
- **3파일 패턴** — 장기 작업의 계획/결정/진행을 `dev/active/`에서 관리
- **세션 연속성** — `memory/session_state.md`로 작업 상태 자동 저장/복원
- **슬래시 커맨드** — `/dev-docs`, `/dev-docs-update`로 작업 문서 관리

## 서브에이전트 팀 (10명)

| 역할 | ID | 전문 |
|------|----|------|
| 팀장 | team-lead | 업무 분배, 프로젝트 조율 |
| 기획자 | planner | 기획서, 요구사항, 플로우차트 |
| 프론트엔드 | frontend-dev | HTML/CSS/JS, React/Vue, 성능 최적화 |
| 백엔드 | backend-dev | Spring Boot 3.x, Java 17+, REST API |
| DB 아키텍트 | db-architect | DB 설계, 쿼리 튜닝, Flyway |
| UI/UX 디자이너 | ui-designer | UX 설계, 디자인 시스템, 접근성 |
| DevOps | devops-engineer | CI/CD, Docker, K8s, 클라우드 |
| 보안 전문가 | security-expert | OWASP, 인증/인가, 취약점 분석 |
| QA 테스터 | qa-tester | 기능/예외/성능 테스트 |
| 리서처 | researcher | 공식문서 기반 기술 조사 |

## 기술 스택

- **Backend:** Java 17+ / Spring Boot 3.x / Spring Security / JPA
- **Frontend:** HTML/CSS/JS / Thymeleaf / React or Vue
- **DB:** PostgreSQL / MySQL / Redis
- **Infra:** Docker / GitHub Actions / Nginx
- **Test:** JUnit 5 / Mockito / RestAssured

## 리포지토리 구조

```
claude-team/
├── CLAUDE.md              # 부트스트랩 (자동 로드)
├── TEAM.md                # 10명 서브에이전트 정의
├── README.md              # 이 파일
├── .claude/
│   ├── settings.json      # 권한 설정
│   └── commands/           # /dev-docs, /dev-docs-update
├── daily/
│   ├── INDEX.md            # 데일리 로그 인덱스
│   └── YYYY-MM-DD.md       # 날짜별 상세 로그
├── memory/
│   └── session_state.md    # 세션 연속성 저장
├── team/
│   └── {persona-id}/       # 페르소나별 산출물
├── output/
│   ├── dev/                # 개발 산출물
│   └── docs/               # 문서 산출물
└── dev/
    └── active/             # 진행 중 작업 (3파일 패턴)
```

## 시작하기

```bash
cd ~/claude-team
# Claude Code 실행 -> CLAUDE.md 자동 로드 -> 팀 가동
```
