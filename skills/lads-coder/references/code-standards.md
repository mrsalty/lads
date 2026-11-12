# Code standards

When these goals conflict, earlier ones win:
**readable > simple > consistent with the existing architecture > performant**.

The repository's own rules and linter override these standards. These standards override any other skill or guide that disagrees with them.

## Design
- Write code a new teammate can follow without help: clear names, small functions with one job each, no clever tricks.
- Match the existing architecture and conventions.
- **YAGNI: build for the requirements you have.** No options, flags, parameters, config, generic types, layers or extension points for needs that aren't in the plan. Duplication is cheaper than the wrong abstraction: extract on the third use, not the first.
- **The simplest thing that fully works.** The fewest moving parts that meet every acceptance criterion without a resource-impact problem. Simple is not hacky: no special cases bolted on, no copy-paste where existing code fits. Prefer the change that fits the existing model, and one that removes code over one that adds it.
- Change only what the task needs. No drive-by renames, reformatting or "while I'm here" fixes.
- **Every changed line must have a reason.** Each added, edited or deleted line traces back to an acceptance criterion, a test, or something those directly require (a caller update, an import, a migration). If you can't say why a line changed, revert it.
- **Refactoring:** if the task would be better served by a refactor that makes the code more ergonomic, modular or readable, describe it and why, then **wait for approval** before doing it. If the task itself is a refactor, go ahead.
- Performance: avoid obvious traps (N+1 queries, quadratic loops over data that can grow without bound, loading everything into memory), but don't optimise without evidence. How to judge the impact: [resource impact](resource-impact.md).
- Leave no dead code, commented-out code or unused imports behind.

## Use what already exists
- Before adding a parameter, type, helper or constant, check whether the code already carries it: a field on an object you already pass, an existing model, the project's settings. Configuration goes through the settings mechanism, never hard-coded in modules.
- Prefer the language's standard library and the libraries the project already uses over hand-written code.
- If a widely adopted library would do the job clearly better, **propose it** before adding the dependency.

## Ship it complete
In the same change:
- Public docs (README, setup and usage guides, API docs) that the change makes stale are updated.
- A new infrastructure dependency (database, queue, service) ships with local development support, so others can run the code without extra setup.
- A change that tightens a schema constraint or changes a stored or rendered format handles the data that already exists (existing rows, seed and fixture data) and states what happens to it.
- A new required input on an existing interface (endpoint, function, message) is a breaking change: make it optional, or coordinate the callers' release.

## Errors: let it break
- Validate only at system boundaries: user input, external APIs, files, environment, anything untrusted.
- Inside the code, trust your own types and invariants. Don't add:
  - try/catch blocks that swallow, log-and-continue or re-wrap errors without adding meaning;
  - null or type checks for states that cannot happen;
  - silent default or fallback values that hide a bug;
  - retries or timeouts nobody asked for.
- A loud, early failure is better than a quiet wrong result.

## Secrets and CI
- Credentials never reach logs or error messages, including inside connection strings.
- Local services aren't exposed beyond the local machine.
- CI jobs get only the secrets they need, and third-party CI actions are pinned to a fixed revision.

## Tests are documentation
- Test core behaviour only: the happy path and the main failure path. Each test should read like an example of how the code is meant to be used.
- **Test what the code does, not how it does it.** Go through the public interface and assert only on what a caller can observe: the return value, the raised error, or state read back through that same interface. Don't call private functions, assert on which internal function was called or how often, or inspect storage behind the interface's back. Rule of thumb: a refactor that keeps the behaviour must not break any test.
- **Expected values come from outside the code.** Write them as literals worked out independently: by hand, from the spec, or from a known-good example. Never derive them with the same logic as the code under test; such a test agrees with the code by construction and cannot catch a bug.
- **A test must be able to fail.** A fake that returns the same value for any input proves nothing: assert what reached the boundary, and for deletes or updates assert that neighbouring data is untouched.
- One behaviour per test, with a name that states it (`rejects_expired_token`, not `test_auth_3`). Arrange, act, assert; no loops or conditionals in tests.
- Mock only at boundaries you don't own (network, third-party services, clock, randomness, environment variables, local files). Never mock your own modules: a test that needs to is coupled to the implementation.
- Every bug fix gets one regression test that fails without the fix.
- Scratch checks (did this run, what does this return) go in the terminal or a throwaway script and are **not committed** as tests.
- Examples of good and bad tests: [tests.md](tests.md).

## Comments
- First make the code readable enough not to need one: rename, extract a function, simplify.
- Write a comment only to explain *why*: a non-obvious algorithm, a constraint, a workaround, or something surprising about the situation.
- Comments describe the code as it is now. Never write what changed compared to before ("now uses X", "fixed Y"); that belongs in the commit message.
