#!/usr/bin/env bash
# Measure interactive zsh startup time.

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib.sh"

if ! command -v zsh >/dev/null 2>&1; then
  emit_result "03-shell-startup" "Shell startup time" "warn" \
    "$(finding low "zsh not found, skipping benchmark")"
  exit 0
fi

have_time_hires() {
  command -v python3 >/dev/null 2>&1 || command -v perl >/dev/null 2>&1
}

now_ms() {
  if command -v python3 >/dev/null 2>&1; then
    python3 -c 'import time; print(int(time.time()*1000))'
  elif command -v perl >/dev/null 2>&1; then
    perl -MTime::HiRes=time -e 'printf "%d\n", time*1000'
  else
    # Fallback: second precision only
    printf '%s000' "$(date +%s)"
  fi
}

if ! have_time_hires; then
  emit_result "03-shell-startup" "Shell startup time" "warn" \
    "$(finding low "neither python3 nor perl available; cannot measure with sub-second precision")"
  exit 0
fi

# Run 3 trials and take the median in milliseconds.
trials=()
for _ in 1 2 3; do
  start=$(now_ms)
  zsh -i -c exit >/dev/null 2>&1 || true
  end=$(now_ms)
  ms=$((end - start))
  trials+=("$ms")
done

# Sort and pick the middle
sorted=$(printf '%s\n' "${trials[@]}" | sort -n)
median=$(printf '%s\n' "$sorted" | awk 'NR==2')

if (( median > 1000 )); then
  status="fail"
  msg="Shell startup is slow: ${median}ms (median of 3 runs)"
elif (( median > 500 )); then
  status="warn"
  msg="Shell startup is a bit slow: ${median}ms (median of 3 runs)"
else
  status="ok"
  msg="Shell startup OK: ${median}ms (median of 3 runs)"
fi

if [[ "$status" == "ok" ]]; then
  emit_result "03-shell-startup" "Shell startup time" "ok" \
    "$(finding low "$msg" "$(printf 'trials: %s' "${trials[*]}")ms")"
else
  emit_result "03-shell-startup" "Shell startup time" "$status" \
    "$(finding medium "$msg" "Trials: ${trials[*]}ms. Consider lazy-loading plugins or removing unused ones.")"
fi
