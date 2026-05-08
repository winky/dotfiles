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

# Pull the full plugin inventory so the AI can verify replacements
# actually exist in this repo (preventing suggestions like "use Tree-sitter
# instead" when no Tree-sitter plugin is configured).
plugins_json=$("$SCRIPT_DIR/extract-plugins.sh")

# Build a compact payload for the model.
compact=$(jq -nc \
  --argjson checks "$(printf '%s' "$input" | jq '[.checks[] | {id, title, status, findings}]')" \
  --argjson plugins "$plugins_json" \
  '{checks: $checks, plugins: $plugins}')

prompt=$(cat <<'EOS'
You are reviewing a personal dotfiles repository for staleness and modernization opportunities.

The user has run automated checks (plugin freshness, shell startup time, syntax, symlinks, etc.).
You are given (a) the raw findings JSON and (b) the COMPLETE list of plugins configured in this
repo, grouped by tool (zsh / tmux / vim / neovim).

Your job is to add value the automated checks cannot:

1. Flag outdated configuration patterns (deprecated plugin manager features, old idioms).
2. Suggest modern alternatives only when materially better (not for novelty).
3. Identify redundancies (two tools doing the same job).
4. Highlight security or correctness pitfalls in the configuration approach.

VERIFICATION RULES (strictly follow):

- Before claiming "X already covers this" or "this is redundant with X", verify X appears in the
  `plugins` list. If X is NOT in the list, frame the suggestion as "consider adopting X" or
  "would be better replaced by X if introduced". Do NOT assert coverage that may not exist.
- Vim and Neovim are SEPARATE ecosystems with separate plugin lists. A built-in or plugin in one
  does NOT mean the other has it. State which environment (vim or neovim) each suggestion applies
  to when it matters.
- Do NOT assume modern stacks (LSP, Tree-sitter, telescope.nvim, etc.) are configured unless
  plugins indicating their setup appear in the list (e.g. `nvim-treesitter/nvim-treesitter`,
  `neovim/nvim-lspconfig`).
- For any "redundant with X" claim, both the stale plugin AND the replacement X must appear in
  the plugins list. Otherwise downgrade severity and reframe as a possibility.
- When recommending a NEW plugin not currently in the list, you cannot verify its current
  activity status (your training data may be stale). Append "(verify upstream activity before
  adopting — recommendation based on training data, repo may be archived/abandoned now)" to
  any such suggestion. Past failure: recommended `Yggdroot/indentLine` which is archived.

OUTPUT FORMAT:

- Start with `## AI Review (Claude {{MODEL}})`.
- 3 to 5 bullet points, each starting with **[high|medium|low]** severity.
- Be specific. Cite plugin or config names.
- No generic advice.
- If no substantive issues, say so honestly in one sentence.

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

text=$(printf '%s' "$response" | jq -r '.content[0].text // empty' 2>/dev/null || true)
if [[ -z "$text" ]]; then
  err=$(printf '%s' "$response" | jq -r '.error.message // .' 2>/dev/null || printf '%s' "$response")
  log_error "Claude API error: $err"
  exit 0
fi

printf '\n%s\n' "$text"
