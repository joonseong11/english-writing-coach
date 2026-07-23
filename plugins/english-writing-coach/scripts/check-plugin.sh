#!/usr/bin/env bash
# Small, dependency-free checks for the cross-CLI plugin surface.
set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "$0")/.." && pwd)"

jq -e '.name == "english-writing-coach" and .hooks == "./hooks/hooks-codex.json"' \
  "${PLUGIN_DIR}/.codex-plugin/plugin.json" >/dev/null
jq -e '.name == "english-writing-coach" and .version == "0.4.0"' \
  "${PLUGIN_DIR}/.claude-plugin/plugin.json" >/dev/null
jq -e '.name == "use-english" and .plugins[0].name == "english-writing-coach"' \
  "${PLUGIN_DIR}/.claude-plugin/marketplace.json" >/dev/null
jq -e '.hooks.SessionStart[0].hooks[0].command | contains("CLAUDE_PLUGIN_ROOT")' \
  "${PLUGIN_DIR}/hooks/hooks.json" >/dev/null
jq -e '.hooks.SessionStart[0].hooks[0].command | contains("PLUGIN_ROOT")' \
  "${PLUGIN_DIR}/hooks/hooks-codex.json" >/dev/null
bash -n "${PLUGIN_DIR}/hooks/session-start.sh"

hook_output="$(PLUGIN_ROOT="${PLUGIN_DIR}" bash "${PLUGIN_DIR}/hooks/session-start.sh")"

jq -e '.hookSpecificOutput.hookEventName == "SessionStart"' \
  <<<"${hook_output}" >/dev/null
jq -e '.hookSpecificOutput.additionalContext | contains("Execute mode") and contains("`//`")' \
  <<<"${hook_output}" >/dev/null
jq -e '.hookSpecificOutput.additionalContext | contains("do the actual task")' \
  <<<"${hook_output}" >/dev/null
jq -e '.hookSpecificOutput.additionalContext | contains("internal reasoning in English")' \
  <<<"${hook_output}" >/dev/null
jq -e '.hookSpecificOutput.additionalContext | contains("English input — coach fully, then execute")' \
  <<<"${hook_output}" >/dev/null
jq -e '.hookSpecificOutput.additionalContext | contains("Korean input — translate only")' \
  <<<"${hook_output}" >/dev/null
jq -e '.hookSpecificOutput.additionalContext | contains("Requests that are not from the human user")' \
  <<<"${hook_output}" >/dev/null
jq -e '.hookSpecificOutput.additionalContext | contains("When the message starts with `//`, do **not** carry out") | not' \
  <<<"${hook_output}" >/dev/null
jq -e '.hookSpecificOutput.additionalContext | contains("provide full writing coaching only") | not' \
  <<<"${hook_output}" >/dev/null

if ENGLISH_LAYER=off PLUGIN_ROOT="${PLUGIN_DIR}" bash "${PLUGIN_DIR}/hooks/session-start.sh" | grep -q .; then
  echo "expected ENGLISH_LAYER=off to suppress hook output" >&2
  exit 1
fi

echo "english-writing-coach plugin checks passed"
