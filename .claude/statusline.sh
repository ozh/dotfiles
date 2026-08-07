#!/bin/bash
input=$(cat)

MODEL=$(echo "$input" | jq -r '.model.display_name')
DIR=$(echo "$input" | jq -r '.workspace.current_dir')
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
DURATION_MS=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')

CYAN='\033[36m'; GREEN='\033[32m'; YELLOW='\033[33m'; RED='\033[31m'; RESET='\033[0m'

# Pick bar color based on context usage
if [ "$PCT" -ge 90 ]; then BAR_COLOR="$RED"
elif [ "$PCT" -ge 70 ]; then BAR_COLOR="$YELLOW"
else BAR_COLOR="$GREEN"; fi

FILLED=$((PCT / 10)); EMPTY=$((10 - FILLED))
printf -v FILL "%${FILLED}s"; printf -v PAD "%${EMPTY}s"
BAR="${FILL// /█}${PAD// /░}"

MINS=$((DURATION_MS / 60000)); SECS=$(((DURATION_MS % 60000) / 1000))

BRANCH=""; DIFFSTAT=""
if git rev-parse --git-dir > /dev/null 2>&1; then
  BRANCH=" | 🌿 $(git branch --show-current 2>/dev/null)"
  DIFFSTAT=$(git diff HEAD --numstat 2>/dev/null | awk -v c="$CYAN" -v g="$GREEN" -v r="$RED" -v x="$RESET" \
    '{n++; if ($1 != "-") {a += $1; d += $2}}
     END {if (n) printf " | %s%d file%s%s %s+%d%s %s-%d%s", c, n, (n == 1 ? "" : "s"), x, g, a+0, x, r, d+0, x}')
fi

echo -e "${CYAN}[$MODEL]${RESET} 📁 ${DIR##*/}$BRANCH$DIFFSTAT"
COST_FMT=$(LC_NUMERIC=C printf '$%.2f' "$COST")
echo -e "${BAR_COLOR}${BAR}${RESET} ${PCT}% | ${YELLOW}${COST_FMT}${RESET} | ⏱️ ${MINS}m ${SECS}s"
