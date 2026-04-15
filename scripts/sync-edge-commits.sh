#!/bin/bash
# EdgeSquare 커밋 요약을 claude-team에 동기화하는 스크립트
# 로컬 crontab: 45 7 * * 1-5 (평일 16:45 KST)
# Remote Trigger(16:50 KST)가 이 데이터를 참조하여 데일리 리포트 생성

set -euo pipefail

EDGE_DIR="/home/user2/EdgeSquare"
TEAM_DIR="/home/user2/claude-team"
TODAY=$(TZ=Asia/Seoul date +%Y-%m-%d)
COMMIT_FILE="${TEAM_DIR}/daily/.edge-commits-${TODAY}.md"

# EdgeSquare 최신화
cd "$EDGE_DIR"
git fetch --all --quiet 2>/dev/null || true

# 오늘 커밋 수집 (kimeh 작성자 기준)
COMMITS=$(git log --since="$TODAY 00:00" --until="$TODAY 23:59" \
  --all --author="kimeh" \
  --pretty=format:"%ad|%h|%s" --date=format:"%H:%M" 2>/dev/null || true)

if [ -z "$COMMITS" ]; then
  # 전체 작성자 커밋도 수집
  COMMITS=$(git log --since="$TODAY 00:00" --until="$TODAY 23:59" \
    --all --pretty=format:"%ad|%h|%an|%s" --date=format:"%H:%M" 2>/dev/null || true)
fi

# 커밋 요약 파일 생성
mkdir -p "${TEAM_DIR}/daily"

if [ -z "$COMMITS" ]; then
  cat > "$COMMIT_FILE" << EOF
# EdgeSquare 커밋 요약 - ${TODAY}
오늘 커밋 없음
EOF
else
  {
    echo "# EdgeSquare 커밋 요약 - ${TODAY}"
    echo ""
    echo "| 시간 | 커밋 | 설명 |"
    echo "|------|------|------|"
    echo "$COMMITS" | while IFS='|' read -r time hash rest; do
      echo "| ${time} | ${hash} | ${rest} |"
    done
    echo ""
    # stat 정보
    echo "## 변경 통계"
    git log --since="$TODAY 00:00" --until="$TODAY 23:59" \
      --all --author="kimeh" --shortstat --pretty="" 2>/dev/null | tail -1 || true
  } > "$COMMIT_FILE"
fi

# claude-team에 커밋 & 푸시
cd "$TEAM_DIR"
git pull --rebase origin main --quiet 2>/dev/null || true
git add "daily/.edge-commits-${TODAY}.md"
if git diff --cached --quiet; then
  exit 0
fi
git commit -m "sync: ${TODAY} EdgeSquare 커밋 요약 자동 동기화" --quiet
git push origin main --quiet
