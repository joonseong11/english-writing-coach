# English Writing Coach

A tiny, code-free repo that turns an AI coding agent — **Claude Code** or
**Codex** — into your personal **English writing coach**.

- Write in Korean → it translates your text into natural English and does not
  run the request it describes.
- Write in English → it gives full writing coaching, then handles the request.
- Start a message with **`//`** → it handles the request with only a tiny
  English coaching block.

The English sentence stays English; all coaching explanations are Korean. This
keeps English prompts from producing a wall of English feedback.

> Built for native Korean speakers who want to get comfortable writing English
> prompts — but it works for any English learner.

## How it works

Open this repo with Claude Code or Codex and just start typing:

- **Korean message** → translation coaching only:
  - Korean (한글) → 🇬🇧 natural translation · 🗣️ Alternatives · 📝 Tip
- **English or mixed message** → full writing coaching, then the agent executes
  the request:
  - English → ✅ Corrected · 🔧 Changes · 💡 More natural · 📝 Tip
  - Mixed → one combined natural version · fixes for English parts
- **A message starting with `//`** → the agent executes the request, with a
  1–3 line English block on top and the actual response in Korean.

Korean translation-only replies end with a reminder to write in English or add
`//` when you want the agent to act. A `//` marker is recognized only at the
start of the message.

## Automation and agent-to-agent calls

Translation-only mode applies to Korean messages you type. It is not meant to
block scripts, scheduled agents, or one agent delegating to another. If you
drive this repository — or any session with the plugin installed — from
automation:

- prefix the brief with `//`, or
- set `ENGLISH_LAYER=off` for that process (`~/.english-layer-off` disables it
  persistently).

An agent that receives an unprefixed brief it believes is automated will run it
without a coaching block rather than return a correction, and will ask when the
call is unclear. It will never answer a delegated brief with coaching alone.

## Migration to v0.4.0

Writing in English now runs the request after full coaching. Only Korean without
`//` stays translation-only; `//` still forces execution in every language with
the smaller coaching block.

## What's inside

| File | Purpose |
|------|---------|
| `CLAUDE.md` | The coaching rules (read automatically by Claude Code) |
| `AGENTS.md` | Symlink → `CLAUDE.md` (read automatically by Codex) |
| `.coach/intro.md` | The welcome-banner text |
| `.coach/session-start.sh` | Session-start hook that shows the banner |
| `.claude/settings.json` | Registers the banner hook for Claude Code |
| `.codex/hooks.json` | Registers the banner hook for Codex |
| `plugins/english-writing-coach/` | Installable Claude Code + Codex plugin |
| `.agents/plugins/marketplace.json` | Local Codex marketplace entry |

`CLAUDE.md` and `AGENTS.md` are one file (a symlink), so editing `CLAUDE.md`
keeps both tools in sync.

## Use in this repository

1. Clone the repo.
2. Open it with Claude Code (`claude`) or Codex from this directory.
3. A welcome banner greets you at the start of each session.
   - **Codex** asks once to trust `.codex/hooks.json` — approve it.
   - In Claude Code the banner shows immediately; in Codex it appears at the top
     of the agent's first reply (a Codex platform limitation).

That's it — start writing.

## Install the global plugin

The installable plugin is separate from the repository-only welcome banner. It
injects the same coaching policy at every session start in both CLIs.

```bash
# Codex
codex plugin marketplace add /Users/jujeon/dev/use-english
codex plugin add english-writing-coach@use-english

# Claude Code
claude plugin marketplace add /Users/jujeon/dev/use-english/plugins/english-writing-coach
claude plugin install english-writing-coach@use-english --scope user
```

Restart each CLI in a new thread after installation. If this computer still has
the older direct global hook, run the plugin's migration after both installs:

```bash
node plugins/english-writing-coach/scripts/migrate-global-hooks.mjs --apply
```

The migration creates a timestamped backup of each edited global settings file
and removes only the legacy `/Users/jujeon/dev/english-layer/inject.sh` entry.

## Example

**You:** `please explain what this plugin do`

> **✅ 교정문**
> Please explain what this plugin does.
>
> **🔧 수정 사항**
> - `do` → `does` — 주어가 3인칭 단수이므로 동사에 **-s**를 붙입니다.

---

The plugin explanation is then given in Korean — your English receives full
coaching, and the request still runs.

## License

[MIT](LICENSE)
