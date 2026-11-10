# Code standards

When these goals conflict, earlier ones win:
**readable > simple > consistent with the existing architecture > performant**.

The repository's own rules and linter override these standards. These standards override any other skill or guide that disagrees with them.

## Design
- Write code a new teammate can follow without help: clear names, small functions with one job each, no clever tricks.
- Match the existing architecture and conventions. Don't add a layer, interface or abstraction that has only one user.
- Change only what the task needs. No drive-by renames, reformatting or "while I'm here" fixes.
- **Refactoring:** if the task would be better served by a refactor that makes the code more ergonomic, modular or readable, describe it and why, then **wait for approval** before doing it. If the task itself is a refactor, go ahead.
- Performance: avoid obvious traps (N+1 queries, quadratic loops over data that can grow without bound, loading everything into memory), but don't optimise without evidence.
- Leave no dead code, commented-out code or unused imports behind.

## Use what already exists
- Prefer the language's standard library and the libraries the project already uses over hand-written code.
- If a widely adopted library would do the job clearly better, **propose it** before adding the dependency.

## Errors: let it break
- Validate only at system boundaries: user input, external APIs, files, environment, anything untrusted.
- Inside the code, trust your own types and invariants. Don't add:
  - try/catch blocks that swallow, log-and-continue or re-wrap errors without adding meaning;
  - null or type checks for states that cannot happen;
  - silent default or fallback values that hide a bug;
  - retries or timeouts nobody asked for.
- A loud, early failure is better than a quiet wrong result.

## Tests are documentation
- Test core behaviour only: the happy path and the main failure path. Each test should read like an example of how the code is meant to be used.
- **Test what the code does, not how it does it.** Go through the public interface and assert only on what a caller can observe: the return value, the raised error, or state read back through that same interface. Don't call private functions, assert on which internal function was called or how often, or inspect storage behind the interface's back. Rule of thumb: a refactor that keeps the behaviour must not break any test.
- **Expected values come from outside the code.** Write them as literals worked out independently: by hand, from the spec, or from a known-good example. Never derive them with the same logic as the code under test; such a test agrees with the code by construction and cannot catch a bug.
- One behaviour per test, with a name that states it (`rejects_expired_token`, not `test_auth_3`). Arrange, act, assert; no loops or conditionals in tests.
- Mock only at boundaries you don't own (network, third-party services, clock, randomness). Never mock your own modules: a test that needs to is coupled to the implementation.
- Every bug fix gets one regression test that fails without the fix.
- Scratch checks (did this run, what does this return) go in the terminal or a throwaway script and are **not committed** as tests.
- Examples of good and bad tests: [tests.md](tests.md).

## Comments
- First make the code readable enough not to need one: rename, extract a function, simplify.
- Write a comment only to explain *why*: a non-obvious algorithm, a constraint, a workaround, or something surprising about the situation.
- Comments describe the code as it is now. Never write what changed compared to before ("now uses X", "fixed Y"); that belongs in the commit message.
