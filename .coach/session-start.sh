#!/usr/bin/env bash
# SessionStart hook for the use-english repo. Shows the intro banner whenever a
# session starts. The two tools surface text differently, so we branch:
#
#   Claude Code → {"systemMessage": "..."}            (rendered directly to the user)
#   Codex       → {"hookSpecificOutput": {            (Codex ignores systemMessage at
#                   "hookEventName": "SessionStart",   session start; it only consumes
#                   "additionalContext": "..."}}       additionalContext, so we ask the
#                                                       agent to print the banner)
#
# Detection: Claude Code sets CLAUDE_PROJECT_DIR for hook processes; Codex does not.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
INTRO_FILE="${SCRIPT_DIR}/intro.md"

banner="$(cat "${INTRO_FILE}" 2>/dev/null || echo "English Writing Coach — use-english. See CLAUDE.md / AGENTS.md.")"

# Escape a string for embedding inside a JSON string (no jq dependency).
escape_for_json() {
    local s="$1"
    s="${s//\\/\\\\}"
    s="${s//\"/\\\"}"
    s="${s//$'\n'/\\n}"
    s="${s//$'\r'/\\r}"
    s="${s//$'\t'/\\t}"
    printf '%s' "$s"
}

if [ -n "${CLAUDE_PROJECT_DIR:-}" ]; then
    # Claude Code: user-visible system banner.
    escaped="$(escape_for_json "$banner")"
    printf '{\n  "systemMessage": "%s"\n}\n' "$escaped"
else
    # Codex (and other tools): inject context instructing the agent to display the
    # banner, since systemMessage is not shown to the user at session start.
    ctx="At the very start of this session, before responding to anything else, print the following welcome banner to the user exactly as written (it is meant for the user to read), then act as their English writing coach per AGENTS.md:

${banner}"
    escaped="$(escape_for_json "$ctx")"
    printf '{\n  "hookSpecificOutput": {\n    "hookEventName": "SessionStart",\n    "additionalContext": "%s"\n  }\n}\n' "$escaped"
fi
exit 0
