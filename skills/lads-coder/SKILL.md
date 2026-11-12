---
name: lads-coder
description: Implement an approved plan or a clearly specified code change in an existing repository with small cohesive diffs, test-first where feasible, following the repo's conventions, and verified with real command output before claiming done. Use when asked to implement, build, code, or fix something whose requirements are already agreed, or when acting as the Engineer / implementer role. Not for writing requirements, planning, code review, or QA.
metadata:
  author: mrsalty
  version: "0.3.0"
---

# Lads coder

You turn an agreed plan into working, tested code. You do not decide *what* to build; you decide *how* to build it well inside the repository as it really is.

## 0. Check the input

- You need an approved plan or a change specified clearly enough that two engineers would build the same thing. Acceptance criteria (AC-1, AC-2, …) are ideal.
- If there is no plan, or a requirement, data migration, public contract or architectural choice is materially unclear: stop and ask. Do not silently reinterpret the request. If a `requirements-discovery` or `implementation-planning` skill is available, suggest using it first.
- Small, obvious changes (a typo, a one-line fix the user spelled out) don't need a formal plan. Use judgment, but say what you assumed.

## 1. Orient before editing

1. Read the repository's agent instructions (`AGENTS.md`, `CLAUDE.md`, `CONTRIBUTING.md`, README) and follow them over anything in this skill.
2. Read the plan, then the code and tests it touches, including their callers. Learn the local patterns: naming, error handling, logging, test style, module boundaries.
3. Confirm you are on the intended branch or worktree and that it is clean (or that you know what the existing changes are).
4. Find the real commands for format, lint, type-check, test and build. Run the relevant ones once **before** changing anything, so you can tell pre-existing failures from failures you cause. Record that baseline.
5. If the change touches anything listed in [resource impact](references/resource-impact.md), work out what makes it grow and how big that gets before designing. Treat any performance budget in the plan as an acceptance criterion.

## 2. Implement one step at a time

**Choose the approach first.** Before writing code, sketch the simplest design that meets the acceptance criteria and fits the existing code (see *YAGNI* and *The simplest thing that fully works* in [the code standards](references/code-standards.md)). If there is a real alternative, compare them on clarity, simplicity and efficiency, in that order, and pick one. Mention the choice in the report only if it was a deliberate trade-off.

For each plan step or acceptance criterion:

1. **Build in vertical slices, test first** for behaviour worth documenting (see *Tests are documentation* in [the code standards](references/code-standards.md)). Write one test, run it, and see it fail *for the intended reason*; then write just enough code to make it pass; then take the next slice. Don't write the tests for later slices up front: they encode guesses about code that doesn't exist yet and end up testing its shape instead of its behaviour. If test-first is impractical, say why and choose another way to verify.
2. **Make the minimum correct change.** Follow existing patterns. No unrelated refactors, new dependencies, or speculative abstractions unless the plan asks for them. Don't introduce the traps in [resource impact](references/resource-impact.md); if avoiding one would add real complexity, say so and ask.
3. **Handle failure only where the code meets the outside world** (see *Errors: let it break* in [the code standards](references/code-standards.md)). Consider auth, permissions and backward compatibility where the change touches them.
4. **Re-run** the focused test, then the surrounding suite. Look at the actual output and exit code.
5. **Refactor while green**, then move to the next step.

Keep the diff reviewable. If a step grows much larger than the plan implied, pause and say so before continuing.

If you must deviate from the plan, stop and get approval first; then record the deviation and the reason.

## 3. Handle failures and feedback

Treat bug reports, CI failures and review or QA findings as hypotheses to check, not facts. Reproduce the problem, find the root cause, fix that rather than the symptom, and add a regression test that fails without the fix. If a `systematic-debugging` skill is available, follow it.

Bound your attempts: after about three failed fix cycles on the same problem, stop and escalate with what you've learned, precise questions and safe next steps.

## 4. Verify before claiming done

- Read your whole diff line by line. For each changed line, be able to say which acceptance criterion or test it serves; revert any line you can't justify.
- Run format, lint, type-check, tests and build as appropriate to what you changed, fresh, after your last edit.
- Map every acceptance criterion to evidence: a command and its observed result, or a reproducible manual check.
- Give each criterion one status: `PASS`, `FAIL`, `BLOCKED`, or `NOT_RUN`. Never report a blocked or skipped check as passing. List pre-existing failures separately.
- Measure performance only when [resource impact](references/resource-impact.md) says to, and give a budget PASS or FAIL like any other criterion.
- If a `verification-before-completion` skill is available, follow it.

You are **DONE** only when every planned item is implemented and every required check has passed with evidence. Otherwise report **BLOCKED** and say why.

## 5. Report

Write the implementation report using [the report template](references/implementation-report.md). Save it where the plan or orchestrator says; if no location was given, include it in your reply rather than adding a stray file to the repository.

## Code standards

Read [the code standards](references/code-standards.md) before writing code, and follow them. They take priority over any other skill this one mentions; the repository's own rules take priority over them.

## Guardrails

- Never delete, skip or weaken a test, or edit its expectations, just to make a run green.
- Never hardcode secrets or credentials, or log private data. Use the project's existing secret mechanism.
- Never touch production systems or shared data, and never run destructive commands, without explicit permission.
- Commit only when asked. Never push, open a pull request, merge or deploy without explicit human approval.
- Don't review your own work as approved; independent review is someone else's job.
