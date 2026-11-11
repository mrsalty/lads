# Resource impact

How to judge what a change costs in CPU, memory, I/O and scalability. This is a way of thinking while you build or review, not a report to fill in, and not an invitation to optimise: **readable > simple > consistent > performant** still holds.

## When to think about it
When the change touches any of: request or handler paths, loops over data that grows with users, tenants or time, database queries or schema, caches or in-memory state, background jobs, queues or batch work, concurrency (threads, async, locks, pools), calls to external services, or a new dependency on a hot path. Otherwise, move on.

## What to ask
1. **Growth driver.** What input makes the work grow (rows, items per request, tenants, file size, events per second), and roughly how big does it get, realistically and at worst?
2. **CPU.** Work that grows faster than linearly over unbounded data, repeated work inside loops, heavy work (parsing, serialisation, crypto, regex) on a hot path.
3. **Memory.** Whole datasets loaded where streaming or pagination would do, collections or caches that only grow (no bound, eviction or expiry), large objects held longer than needed.
4. **I/O.** Queries or network calls per item (N+1, fan-out), large payloads, queries with no supporting index or that scan whole tables.
5. **Scalability and concurrency.** In-process state that breaks with more than one replica, locks, long transactions or migrations that block other work (e.g. altering a large table), exhausting connection or thread pools, external rate limits, retries without backoff, queues or streams with no backpressure.
6. **Unbounded input.** Anything that comes from outside (page size, upload, batch) has a limit, or having none is a deliberate choice.

## Evidence
- Reasoning from the code is enough by default.
- Measure only when the plan sets a budget (latency, memory, throughput: treat it as an acceptance criterion), when the change is meant to improve performance, or when reasoning can't settle whether a hot path is acceptable. Use the project's existing tools (benchmarks, profilers, query plans such as `EXPLAIN`). Record the command and the numbers you saw; never estimate numbers and present them as measured.

## What to write down
Nothing, by default. Only:
- **Coder:** when the change has a real impact you chose to accept (for example a full scan that's fine at today's sizes, or an unbounded list because the source caps it), say so in one or two lines in the report's risks section: the impact, why the implementation is still right, and the evidence.
- **Reviewer:** when the code under review has a resource problem, raise it as a finding like any other. No finding, no mention.
