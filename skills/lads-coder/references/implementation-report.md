# Implementation report template

Fill in every section. Write "none" rather than leaving a section out.

```markdown
# Implementation: <short title>

**Status:** DONE | BLOCKED
**Branch / worktree:** <name> @ <commit or "uncommitted">

## Summary
<2–4 sentences: what changed and why.>

## Plan items
| Plan step / AC | What was done | Files |
|---|---|---|
| AC-1 | ... | `path/to/file` |

## Deviations from the plan
<Each deviation, who approved it, and why. "none" if none.>

## Verification
Baseline before changes: <commands run and pre-existing failures, if any>

| Check / AC | Command or scenario | Observed outcome | Status |
|---|---|---|---|
| AC-1 | `...` | <actual result> | PASS / FAIL / BLOCKED / NOT_RUN |
| lint | `...` | <actual result> | PASS |

## Review / QA findings addressed
| Finding ID | Disposition | Evidence |
|---|---|---|
| R-001 | fixed / disputed / deferred | <test or command> |

## Risks, limitations and open questions
- ...
<!-- Include a resource impact here only if you accepted one: the impact, why the implementation is still right, and the evidence. -->
```
