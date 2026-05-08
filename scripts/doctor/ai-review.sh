#!/usr/bin/env bash
# Send the aggregated report to Claude Haiku 4.5 for modernization suggestions.
# Input: aggregated JSON on stdin.
# Output: a Markdown section appended to stdout (or empty if API key absent).

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

input=$(cat)

if [[ -z "${ANTHROPIC_API_KEY:-}" ]]; then
  log_warn "ANTHROPIC_API_KEY not set; skipping AI review"
  exit 0
fi

MODEL="${ANTHROPIC_MODEL:-claude-haiku-4-5-20251001}"

# Compact the input — we send only what the model needs.
compact=$(printf '%s' "$input" | jq -c '{
  checks: [.checks[] | {id, title, status, findings}],
  plugins: (.plugins // [])
}')

prompt=$(cat <<'EOS'
You are reviewing a personal dotfiles repository for staleness and modernization opportunities.

The user has run automated checks (plugin freshness, shell startup time, syntax, symlinks, etc.).
You are given the raw findings JSON. Your job is to add value the automated checks cannot:

1. Flag outdated configuration patterns (deprecated plugin manager features, old idioms).
2. Suggest modern alternatives only when materially better (not for novelty).
3. Identify redundancies (two tools doing the same job).
4. Highlight security or correctness pitfalls in the configuration approach.

Output a Markdown section starting with `## AI Review (Claude {{MODEL}})`.
Format: 3 to 5 bullet points, each starting with **[high|medium|low]** severity.
Be specific. Cite plugin or config names. No generic advice.
If you cannot find substantive issues, say so honestly in one sentence.

Input JSON follows.
EOS
)
prompt="${prompt//\{\{MODEL\}\}/$MODEL}"

# Build the JSON request body.
body=$(jq -nc \
  --arg model "$MODEL" \
  --arg sys "$prompt" \
  --arg user "$compact" \
  '{
    model: $model,
    max_tokens: 1024,
    system: $sys,
    messages: [{ role: "user", content: $user }]
  }')

response=$(curl -sS https://api.anthropic.com/v1/messages \
  -H "x-api-key: $ANTHROPIC_API_KEY" \
  -H "anthropic-version: 2023-06-01" \
  -H "content-type: application/json" \
  --data "$body" || true)

if [[ -z "$response" ]]; then
  log_error "Empty response from Claude API"
  exit 0
fi

# Extract text from the standard response shape.
text=$(printf '%s' "$response" | jq -r '.content[0].text // empty' 2>/dev/null || true)
if [[ -z "$text" ]]; then
  err=$(printf '%s' "$response" | jq -r '.error.message // .' 2>/dev/null || printf '%s' "$response")
  log_error "Claude API error: $err"
  exit 0
fi

printf '\n%s\n' "$text"
