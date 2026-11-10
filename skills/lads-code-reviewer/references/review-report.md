# Review report template

Fill in every section. Write "none" rather than leaving a section out.

```markdown
# Review: <short title>

**Verdict:** APPROVED | APPROVED_WITH_NOTES | CHANGES_REQUESTED
**Base:** <base ref> (merge base <short sha>) · **Head:** <branch> @ <short sha or "uncommitted">

## Summary
<2–4 sentences: what the change does and the main reasons for the verdict.>

## Findings
| ID | Severity | Location | Problem and evidence | Why it matters | Suggested fix |
|---|---|---|---|---|---|
| CR-1 | blocking | `path/to/file:42` | ... | ... | ... |

## Acceptance criteria
| AC | Implemented | Tested | Notes |
|---|---|---|---|
| AC-1 | yes / no / partly | yes / no | ... |

## Checks re-run
| Check | Command | Observed outcome | Status |
|---|---|---|---|
| tests | `...` | <actual result> | PASS / FAIL / NOT_RUN |

## Pre-existing problems
- ...

## Open questions
- ...
```
