#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Helper function to extract a field with jq, returning a default if null or absent
# Usage: extract_field "<jq_path>" "<default>"
extract_field() {
  local jq_path="$1"
  local default="$2"
  local value
  value=$(echo "$input" | jq -r "$jq_path // empty")
  if [ -z "$value" ]; then
    echo "$default"
  else
    echo "$value"
  fi
}

# Extract frequently used fields
MODEL=$(extract_field '.model.display_name' 'Unknown')
DIR=$(extract_field '.workspace.current_dir' '.')

# Git branch and status
BRANCH=""
GIT_STATUS=""
if git rev-parse --git-dir > /dev/null 2>&1; then
  BRANCH=$(git branch --show-current 2>/dev/null)
  STAGED=$(git diff --cached --numstat 2>/dev/null | wc -l)
  MODIFIED=$(git diff --numstat 2>/dev/null | wc -l)
  [ -n "$STAGED" ] && [ "$STAGED" -gt 0 ] && GIT_STATUS="${GIT_STATUS}+${STAGED}"
  [ -n "$MODIFIED" ] && [ "$MODIFIED" -gt 0 ] && GIT_STATUS="${GIT_STATUS}~${MODIFIED}"
fi

# Vim mode
VIM_MODE=$(extract_field '.vim.mode' '')
if [ -n "$VIM_MODE" ]; then
  VIM_MODE=" [VIM:$VIM_MODE]"
fi

# Context window
PCT=$(extract_field '.context_window.used_percentage' '0' | cut -d. -f1)
REMAINING_PCT=$(extract_field '.context_window.remaining_percentage' '0' | cut -d. -f1)
TOTAL_INPUT_TOKENS=$(extract_field '.context_window.total_input_tokens' '0')
TOTAL_OUTPUT_TOKENS=$(extract_field '.context_window.total_output_tokens' '0')
CONTEXT_WINDOW_SIZE=$(extract_field '.context_window.context_window_size' '200000')

# Cost
COST=$(extract_field '.cost.total_cost_usd' '0')
TOTAL_DURATION_MS=$(extract_field '.cost.total_duration_ms' '0')
TOTAL_API_DURATION_MS=$(extract_field '.cost.total_api_duration_ms' '0')
TOTAL_LINES_ADDED=$(extract_field '.cost.total_lines_added' '0')
TOTAL_LINES_REMOVED=$(extract_field '.cost.total_lines_removed' '0')

# Rate limits
FIVE_HOUR_USED=$(extract_field '.rate_limits.five_hour.used_percentage' '0')
SEVEN_DAY_USED=$(extract_field '.rate_limits.seven_day.used_percentage' '0')
SPEND_LIMIT_USED=$(extract_field '.rate_limits.spend_limit.used_percentage' '0')

# Prompt cache
PROMPT_CACHE_WARM=$(extract_field '.prompt_cache.warm' 'false')
PROMPT_CACHE_HIT_RATIO=$(extract_field '.prompt_cache.hit_ratio' '0')

# Agent
AGENT_NAME=$(extract_field '.agent.name' '')

# PR
PR_NUMBER=$(extract_field '.pr.number' '')
PR_REVIEW_STATE=$(extract_field '.pr.review_state' '')

# Session
SESSION_ID=$(extract_field '.session_id' '')
SESSION_NAME=$(extract_field '.session_name' '')
VERSION=$(extract_field '.version' '')

# Effort
EFFORT_LEVEL=$(extract_field '.effort.level' '')

# Thinking
THINKING_ENABLED=$(extract_field '.thinking.enabled' 'false')

# Fast mode
FAST_MODE=$(extract_field '.fast_mode' 'false')

# Output the status line with multiple lines

# Line 1: Model, directory, git branch, vim mode
echo -e "[\033[36m$MODEL\033[0m] \033[33m📁 ${DIR##*/}\033[0m${BRANCH:+ \033[32m🌿 $BRANCH\033[0m}${GIT_STATUS:+ \033[33m$GIT_STATUS\033[0m}${VIM_MODE}"

# Line 2: Context usage bar, cost, duration
# Context bar
BAR_WIDTH=10
FILLED=$((PCT * BAR_WIDTH / 100))
EMPTY=$((BAR_WIDTH - FILLED))
BAR=""
[ "$FILLED" -gt 0 ] && printf -v FILL "%${FILLED}s" && BAR="${FILL// /▓}"
[ "$EMPTY" -gt 0 ] && printf -v PAD "%${EMPTY}s" && BAR="${BAR}${PAD// /░}"

# Bar color based on usage
if [ "$PCT" -ge 90 ]; then BAR_COLOR="\033[31m" # Red
elif [ "$PCT" -ge 70 ]; then BAR_COLOR="\033[33m" # Yellow
else BAR_COLOR="\033[32m" # Green
fi
RESET="\033[0m"

# Format cost and duration
COST_FMT=$(printf '$%.2f' "$COST")
DURATION_SEC=$((TOTAL_DURATION_MS / 1000))
MINS=$((DURATION_SEC / 60))
SECS=$((DURATION_SEC % 60))

echo -e "${BAR_COLOR}$BAR${RESET} ${PCT}% | ${COST_FMT} | ⏱️ ${MINS}m${SECS}s"

# Line 3: Rate limits, prompt cache, agent, PR, etc.
# We'll try to fit as much as possible without being too long
RATE_INFO=""
if [ "$FIVE_HOUR_USED" -gt 0 ] || [ "$SEVEN_DAY_USED" -gt 0 ] || [ "$SPEND_LIMIT_USED" -gt 0 ]; then
  RATE_INFO="5h:${FIVE_HOUR_USED}% 7d:${SEVEN_DAY_USED}%"
  if [ "$SPEND_LIMIT_USED" -gt 0 ]; then
    RATE_INFO="${RATE_INFO} ${SPEND_LIMIT_USED}%"
  fi
fi

CACHE_INFO=""
if [ "$PROMPT_CACHE_WARM" = "true" ]; then
  CACHE_INFO="cache:warm"
else
  CACHE_INFO="cache:cold"
fi
if [ "$PROMPT_CACHE_HIT_RATIO" != "0" ]; then
  CACHE_INFO="${CACHE_INFO} hit:${PROMPT_CACHE_HIT_RATIO}"
fi

AGENT_INFO=""
if [ -n "$AGENT_NAME" ]; then
  AGENT_INFO="agent:$AGENT_NAME"
fi

PR_INFO=""
if [ -n "$PR_NUMBER" ]; then
  PR_INFO="PR:#$PR_NUMBER"
  if [ -n "$PR_REVIEW_STATE" ]; then
    PR_INFO="${PR_INFO}(${PR_REVIEW_STATE})"
  fi
fi

SESSION_INFO=""
if [ -n "$SESSION_NAME" ]; then
  SESSION_INFO="session:$SESSION_NAME"
elif [ -n "$SESSION_ID" ]; then
  # Show first 8 chars of session ID
  SESSION_INFO="session:${SESSION_ID:0:8}"
fi

EFFORT_INFO=""
if [ -n "$EFFORT_LEVEL" ]; then
  EFFORT_INFO="effort:$EFFORT_LEVEL"
fi

THINKING_INFO=""
if [ "$THINKING_ENABLED" = "true" ]; then
  THINKING_INFO="thinking:on"
fi

FAST_INFO=""
if [ "$FAST_MODE" = "true" ]; then
  FAST_INFO="fast:on"
fi

VERSION_INFO="v$VERSION"

# Combine the info for line 3, but we don't want it too long
# We'll show a subset that fits, but for now we'll show all and let it wrap or truncate
LINE_3="$RATE_INFO $CACHE_INFO $AGENT_INFO $PR_INFO $SESSION_INFO $EFFORT_INFO $THINKING_INFO $FAST_INFO $VERSION_INFO"
echo -e "\033[2m$LINE_3\033[0m"