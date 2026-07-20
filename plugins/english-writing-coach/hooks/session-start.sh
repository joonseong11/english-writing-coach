#!/usr/bin/env bash
# Inject the shared English-writing policy for both Claude Code and Codex.
set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BEHAVIOR_FILE="${PLUGIN_DIR}/behavior.md"

# Disable for one command/session with ENGLISH_LAYER=off, or persistently with
# ~/.english-layer-off. The latter keeps the legacy opt-out working after the
# plugin migration.
if [ "${ENGLISH_LAYER:-on}" = "off" ] || [ -f "${HOME}/.english-layer-off" ]; then
  exit 0
fi

[ -f "${BEHAVIOR_FILE}" ] || exit 0
prompt="$(cat "${BEHAVIOR_FILE}")"

escape_for_json() {
  local value="$1"
  value="${value//\\/\\\\}"
  value="${value//\"/\\\"}"
  value="${value//$'\n'/\\n}"
  value="${value//$'\r'/\\r}"
  value="${value//$'\t'/\\t}"
  printf '%s' "${value}"
}

escaped="$(escape_for_json "${prompt}")"
printf '{\n  "hookSpecificOutput": {\n    "hookEventName": "SessionStart",\n    "additionalContext": "%s"\n  }\n}\n' "${escaped}"
