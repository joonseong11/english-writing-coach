#!/usr/bin/env bash
# Small, dependency-free checks for the cross-CLI plugin surface.
set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "$0")/.." && pwd)"

jq -e '.name == "english-writing-coach" and .hooks == "./hooks/hooks-codex.json"' \
  "${PLUGIN_DIR}/.codex-plugin/plugin.json" >/dev/null
jq -e '.name == "english-writing-coach" and .version == "0.2.0"' \
  "${PLUGIN_DIR}/.claude-plugin/plugin.json" >/dev/null
jq -e '.name == "use-english" and .plugins[0].name == "english-writing-coach"' \
  "${PLUGIN_DIR}/.claude-plugin/marketplace.json" >/dev/null
jq -e '.hooks.SessionStart[0].hooks[0].command | contains("CLAUDE_PLUGIN_ROOT")' \
  "${PLUGIN_DIR}/hooks/hooks.json" >/dev/null
jq -e '.hooks.SessionStart[0].hooks[0].command | contains("PLUGIN_ROOT")' \
  "${PLUGIN_DIR}/hooks/hooks-codex.json" >/dev/null
bash -n "${PLUGIN_DIR}/hooks/session-start.sh"

PLUGIN_ROOT="${PLUGIN_DIR}" bash "${PLUGIN_DIR}/hooks/session-start.sh" |
  jq -e '.hookSpecificOutput.hookEventName == "SessionStart" and (.hookSpecificOutput.additionalContext | contains("Answer in Korean"))' >/dev/null

if ENGLISH_LAYER=off PLUGIN_ROOT="${PLUGIN_DIR}" bash "${PLUGIN_DIR}/hooks/session-start.sh" | grep -q .; then
  echo "expected ENGLISH_LAYER=off to suppress hook output" >&2
  exit 1
fi

echo "english-writing-coach plugin checks passed"
