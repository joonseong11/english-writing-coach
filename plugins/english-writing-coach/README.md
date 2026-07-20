# English Writing Coach plugin

This cross-CLI plugin injects `behavior.md` at `SessionStart` for Claude Code
and Codex. It is intentionally a hook plugin, not a slash-command workflow.

- `hooks/hooks.json`: Claude Code hook registration
- `hooks/hooks-codex.json`: Codex hook registration
- `hooks/session-start.sh`: one shared JSON-context injector
- `scripts/migrate-global-hooks.mjs`: removes the superseded direct global hook
  after installation, keeping timestamped backups

Run `scripts/check-plugin.sh` before publishing or installing a changed version.
