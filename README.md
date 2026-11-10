# lads

Personal, portable [Agent Skills](https://agentskills.io/specification) (`SKILL.md`) that work in any agent that supports the standard: Claude Code, Codex, Antigravity, Gemini CLI, Cursor, Copilot and others.

## Skills

| Skill | Use it for |
|---|---|
| [`lads-coder`](skills/lads-coder/SKILL.md) | Implementing an approved plan or a clearly specified change: test-first, small diffs, verified before done. |
| [`lads-code-reviewer`](skills/lads-code-reviewer/SKILL.md) | Read-only review of a change against its plan and the code standards, compared with the main branch unless another base is given. |

## Install

With the cross-agent installer ([vercel-labs/skills](https://github.com/vercel-labs/skills)):

```bash
npx skills add mrsalty/lads -g -a claude-code -a codex -a antigravity   # all skills, user-wide
npx skills add mrsalty/lads -g --skill lads-coder                           # one skill
```

Or symlink manually:

```bash
for skill in lads-coder lads-code-reviewer; do
  ln -s ~/repos/lads/skills/$skill ~/.claude/skills/$skill   # Claude Code
  ln -s ~/repos/lads/skills/$skill ~/.agents/skills/$skill   # Codex and most others
done
```

## Shared files

Files used by more than one skill live once in `shared/` (for example `code-standards.md` and `tests.md`). Each skill keeps a copy in its own `references/` folder, so it still works when installed on its own.

- Edit only the file in `shared/`, then run `scripts/sync-shared.sh` to update every copy.
- `scripts/sync-shared.sh --check` changes nothing and exits with an error if any copy is out of date.
- To give a skill a shared file, copy it into that skill's `references/` once; the script keeps it updated from then on.

## Writing a skill

- Every skill name starts with `lads-` (e.g. `lads-coder`), so it never clashes with skills from other sources.
- One folder per skill under `skills/`. The folder name must equal the `name` in the frontmatter (lowercase, digits and hyphens, at most 64 characters).
- `description` (at most 1024 characters) says what the skill does **and** when to use it. Agents only see this until they open the skill.
- Keep `SKILL.md` under about 500 lines. Put detail in `references/` and code in `scripts/`.
- Stay portable: describe actions in plain language ("search the codebase", not a specific agent's tool name).
