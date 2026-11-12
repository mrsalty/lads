---
name: lads-pr-writer
description: Write a pull request title and description in plain language, so a human understands in a couple of minutes why the change exists, what its moving parts are and how they fit together, and how it was verified. Implementation details are left to code review. Works from a ticket, acceptance criteria or requirements when given, or from the branch alone: the current or a named branch compared with main or another given base. Use when asked to write, draft, update or improve a pull request (or merge request) title or description, or when acting as the PR author after lads-coder and lads-code-reviewer. Not for reviewing code, implementing changes, or writing release notes.
metadata:
  author: mrsalty
  version: "0.2.0"
---

# Lads PR writer

You write what a busy teammate reads before opening the diff. When they finish, they should know why the change exists, what its main moving parts are and how they fit together, and what to watch out for. Everything else lives in the code and in the code review.

## The rule: stay at design altitude

- **Plain language.** Short sentences, everyday words. Write for a competent engineer who doesn't know this part of the codebase. Explain any domain term you can't avoid.
- **Describe the design, not the diff.** Name the moving parts (components, responsibilities, data or control flow between them) and the key decisions with their reasons.
- **Name code only as a signpost.** Mention a module, class or endpoint only when the reader needs it to find their way. Never list changed files.
- **Leave out:** line-by-line changes, helper functions, renames and formatting, test inventories, code snippets. One exception: when the change *is* an interface (a new API, CLI command or config option), show a short usage example.
- **The cut test:** if a sentence only makes sense while looking at the diff, it belongs to code review. Delete it.
- **Self-contained.** A reader understands the change without opening other PRs or tickets; a stacked PR still explains itself. Link to others for context only.
- **Length follows the idea, not the diff.** A one-line fix gets a sentence or two. A 2,000-line change with one idea still gets a short description.

## 0. Gather the inputs

- **The change, always:** the current branch, or the one the user names, compared with the base the user names, or `main` if they name none. Follow [change scope](references/change-scope.md).
- **What the change was for, if given:** a ticket, acceptance criteria or requirements. This decides the mode:
  - **From requirements.** The requirements give the *why* and frame *what changes*. Say in plain words which requirements the change meets, and name any it doesn't fully meet. Don't paste the acceptance criteria back.
  - **From the branch alone.** Infer the purpose from the commits, branch name and code. Say only what the change visibly does; don't present a guess as the motivation. Don't stop to ask: write the description, and if the purpose is still unclear, say so in your reply (not in the description) and offer to add it.
- **Reports, if any:** the implementer's report and the review report. Use them for verification evidence and known limitations, not as text to copy.
- **Repository conventions:** `CONTRIBUTING.md`, agent instructions, and the title style of recent merged pull requests. The body template is chosen in step 2.

## 1. Understand the change

1. Read the changed code well enough to know what each piece does. You are not auditing it.
2. Group the changes into a few moving parts by purpose, usually one to four. Mechanical churn (renames, formatting, generated files, lockfiles) gets one line at most, or nothing. If part of the diff is outside the title's scope, say what it is and why in one line.
3. Find what changes for other people: behaviour users see, public contracts and existing callers, data already stored in an old format, config or environment variables, data migrations, new dependencies, rollout and rollback steps.

## 2. Write

**Choose the template.** Look for the repository's own pull request template, in this order:

1. `.github/pull_request_template.md`, then the same name in the repository root or `docs/` (any letter case, `.md` or `.txt`).
2. A folder of templates: `.github/PULL_REQUEST_TEMPLATE/` (GitHub) or `.gitlab/merge_request_templates/` (GitLab). If there are several, pick the one that fits the change, or ask if none clearly does.

If you find none, use [this skill's body template](references/pr-body.md). Either way, keep the template's headings, their order and its checklists; replace its hint comments with content; write "n/a" in a section that doesn't apply rather than deleting it; tick a checklist box only when you have evidence for it. Say in your reply which template you used.

**Title:** imperative, at most about 70 characters, says the outcome rather than the mechanism. Follow the repository's prefix convention (ticket ID, Conventional Commits) if it has one.

**Body.** Fill each section at design altitude, following its hints. Whatever the headings, the content comes from:

- **What and why:** the problem or need and what the change does about it, in a few sentences. From the branch alone, state the purpose only if the commits or code make it clear.
- **Links:** the ticket or issues you were given. Never invent them; "n/a" if there are none.
- **The design:** one short paragraph or bullet per moving part: what it is responsible for and how it connects to the others. More detail only for breaking changes, complex migrations or non-obvious workarounds, still without narrating the diff.
- **Testing:** what a reviewer needs to try the change (prerequisites, steps, expected result), plus what was already verified, only with evidence. From requirements, say which ones are covered and which aren't.
- **Notes:** breaking changes, migrations, config, dependencies, and any steps needed at release.

## 3. Check before delivering

- Could someone who hasn't seen the code explain the change back in two sentences?
- Does every sentence pass the cut test?
- Is every claim backed by something you saw: the diff, a report, a command's output?
- Is anything that affects other people (contracts, config, migrations) mentioned?

## 4. Deliver

- By default, reply with the title and body for the user to read.
- Create or update the pull request only when asked, with the hosting platform's CLI (e.g. `gh pr create --title ... --body-file ...` or `gh pr edit`).
- To create one, the branch must already be pushed with an upstream of the same name. Don't push unless asked; never force-push.
- When updating an existing description, read it first and keep what people added by hand (screenshots, linked issues, checklists) unless told otherwise.

## Guardrails

- Never claim a check passed without evidence. A check that didn't run is "not run", not "tested".
- Never invent ticket IDs, links, screenshots, numbers or people.
- Write `@name` only for a real account you mean to notify; the platform notifies them.
- This is not a review. Don't list defects. An unresolved review finding appears only if it was accepted as a known limitation, in the notes.
- Follow the repository's and user's conventions on attribution lines; add none of your own.
