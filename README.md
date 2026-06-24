# English Writing Coach

A tiny, code-free repo that turns an AI coding agent — **Claude Code** or
**Codex** — into your personal **English writing coach**.

- Write in **English** → it corrects you.
- Write in **Korean (한글)** → it translates to natural English.

Either way you get a short explanation, so you actually learn instead of just
copy-pasting a fix.

> Built for native Korean speakers who want to get comfortable writing English
> prompts — but it works for any English learner.

## How it works

Open this repo with Claude Code or Codex and just start typing:

- **You write English** → ✅ Corrected · 🔧 Changes · 💡 More natural · 📝 Tip
- **You write Korean (한글)** → 🇬🇧 natural translation · 🗣️ Alternatives · 📝 Tip
- **A line starting with `//`** → a direct instruction to the agent
  (e.g. `// make your tips shorter`), not practice text

The agent never *executes* what your message describes — even
`build a function…` is treated as a sentence to fix, not a task to run.

## What's inside

| File | Purpose |
|------|---------|
| `CLAUDE.md` | The coaching rules (read automatically by Claude Code) |
| `AGENTS.md` | Symlink → `CLAUDE.md` (read automatically by Codex) |
| `.coach/intro.md` | The welcome-banner text |
| `.coach/session-start.sh` | Session-start hook that shows the banner |
| `.claude/settings.json` | Registers the banner hook for Claude Code |
| `.codex/hooks.json` | Registers the banner hook for Codex |

`CLAUDE.md` and `AGENTS.md` are one file (a symlink), so editing `CLAUDE.md`
keeps both tools in sync.

## Setup

1. Clone the repo.
2. Open it with Claude Code (`claude`) or Codex from this directory.
3. A welcome banner greets you at the start of each session.
   - **Codex** asks once to trust `.codex/hooks.json` — approve it.
   - In Claude Code the banner shows immediately; in Codex it appears at the top
     of the agent's first reply (a Codex platform limitation).

That's it — start writing.

## Example

**You:** `i wanna make a function that get user data`

> **✅ Corrected**
> I want to make a function that gets user data.
>
> **🔧 Changes**
> - `i wanna` → `I want to` — "I" is always capitalized; "wanna" is casual slang.
> - `get` → `gets` — a singular subject takes **-s**.
>
> **💡 More natural**
> I want to write a function that fetches user data.

The function is **not** written — only your sentence is.

## License

[MIT](LICENSE)
