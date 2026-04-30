#!/bin/sh
input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
model=$(echo "$input" | jq -r '.model.display_name // empty')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
five_hour=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
seven_day=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

# Git branch (skip optional locks)
git_branch=""
if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
  branch=$(git -C "$cwd" -c core.fsmonitor=false symbolic-ref --short HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    # Check clean/dirty
    if git -C "$cwd" -c core.fsmonitor=false diff --quiet 2>/dev/null && git -C "$cwd" -c core.fsmonitor=false diff --cached --quiet 2>/dev/null; then
      git_branch=" (${branch})"
    else
      git_branch=" (${branch}*)"
    fi
  fi
fi

# Context usage indicator
ctx_info=""
if [ -n "$used" ]; then
  ctx_info=" [ctx:$(printf '%.0f' "$used")%]"
fi

# Rate limit info (only shown when available: Claude.ai subscribers after first API response)
rate_info=""
if [ -n "$five_hour" ] || [ -n "$seven_day" ]; then
  rate_parts=""
  [ -n "$five_hour" ] && rate_parts="5h:$(printf '%.0f' "$five_hour")%"
  [ -n "$seven_day" ] && rate_parts="${rate_parts:+$rate_parts }7d:$(printf '%.0f' "$seven_day")%"
  rate_info=" [rate:$rate_parts]"
fi

# Model info
model_info=""
if [ -n "$model" ]; then
  model_info=" [$model]"
fi

printf "\033[35m%s\033[0m\033[33m%s\033[0m%s%s%s" \
  "$cwd" "$git_branch" "$ctx_info" "$rate_info" "$model_info"
