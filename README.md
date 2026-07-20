# English Writing Coach

A tiny, code-free repo that turns an AI coding agent — **Claude Code** or
**Codex** — into your personal **English writing coach**.

- Write normally → it handles your task as usual, opening the reply with a tiny
  English coaching block (your English corrected, or the natural English you
  could have written instead of Korean).
- Start a message with **`//`** → coach-only mode: it corrects or translates
  the text with full coaching, and never executes it.

The English sentence stays English; all coaching explanations are Korean. This
keeps English prompts from producing a wall of English feedback.

> Built for native Korean speakers who want to get comfortable writing English
> prompts — but it works for any English learner.

## How it works

Open this repo with Claude Code or Codex and just start typing:

- **Normal message** → the agent answers it as your working assistant, with a
  1–3 line English block on top, then the actual response in Korean.
- **A message starting with `//`** → coach-only, full coaching:
  - English → ✅ Corrected · 🔧 Changes · 💡 More natural · 📝 Tip
  - Korean (한글) → 🇬🇧 natural translation · 🗣️ Alternatives · 📝 Tip

In coach-only mode the agent never *executes* what the text describes — even
`// build a function…` is treated as a sentence to fix, not a task to run.

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

**You:** `// i wanna make a function that get user data`

> **✅ 교정문**
> I want to make a function that gets user data.
>
> **🔧 수정 사항**
> - `i wanna` → `I want to` — "I"는 대문자로 쓰고 "wanna"는 글에서는 구어체입니다.
> - `get` → `gets` — 단수 주어에는 **-s**를 붙입니다.
>
> **💡 더 자연스럽게**
> I want to write a function that fetches user data.

The function is **not** written — only your sentence is.

## License

[MIT](LICENSE)
