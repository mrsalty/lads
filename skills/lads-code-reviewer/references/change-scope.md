# Change scope

How to pin down exactly which change you are working on: a **head** compared with a **base**.

## The head

- The branch the user names, or the current branch if they name none.
- For a named branch, use the local branch if it exists, otherwise its remote copy (e.g. `origin/<branch>`). Don't check it out or switch branches in the user's working tree.

## The base

- The base branch the user names. If none is named, use `main`; if the repository has no `main`, use the remote's default branch (`git symbolic-ref refs/remotes/origin/HEAD`), and if that is unclear, ask.
- If the head already has an open pull request and the user named no base, its target branch is the base (e.g. `gh pr view <head> --json baseRefName`).
- With stacked pull requests, the base is the parent branch in the stack, not main.
- Fetch first and compare against the remote copy (e.g. `origin/main`), so a stale local branch doesn't hide or add changes.

## The change

1. Find the merge base: `git merge-base <base> <head>`.
2. The change is everything since the merge base: `git diff <merge-base> <head>`, with the commits from `git log --oneline <merge-base>..<head>`.
3. Only when the head is the current branch, also include uncommitted work (`git diff <merge-base>`) and untracked files (`git status --short`).
4. If the base or head does not resolve, or the change is empty, stop and say so.
