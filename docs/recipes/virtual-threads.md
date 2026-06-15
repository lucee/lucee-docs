<!--
{
  "title": "Virtual Threads",
  "id": "virtual-threads",
  "categories": ["thread", "performance", "core"],
  "since": "8.0",
  "description": "Use Java virtual threads in Lucee for high-concurrency, I/O-bound workloads via cfthread and parallel collection functions. Experimental in Lucee 7, official in Lucee 8.",
  "keywords": [
    "virtual threads",
    "threads",
    "parallel",
    "async",
    "concurrent",
    "performance",
    "cfthread",
    "arrayMap",
    "I/O"
  ],
  "related": [
    "thread-usage",
    "thread-task",
    "tag-thread",
    "function-arraymap",
    "function-arrayeach"
  ]
}
-->

# Virtual Threads

Virtual threads were introduced as an **experimental** feature in **Lucee 7** and became **official** in **Lucee 8**.

## What Are Virtual Threads?

Java virtual threads (Project Loom, Java 21+) are lightweight threads managed by the JVM instead of the operating system. A platform thread maps to an OS thread and is relatively expensive to create and hold. A virtual thread is cheap — you can run thousands or millions of them concurrently without exhausting the thread pool.

Lucee exposes virtual threads in two places you already use:

- `<cfthread>` / `thread` — opt in per thread with `virtual=true`
- Parallel collection functions — opt in with `parallel="virtual"`

Both require **Java 21 or newer**. On older JVMs Lucee falls back to regular platform threads and logs a warning once.

> On **Lucee 7**, virtual threads are experimental — the API may change. From **Lucee 8** onward they are a supported, production-ready feature.

## Why and When to Use Them

Virtual threads shine for **I/O-bound** work: HTTP calls, database queries, file reads, waiting on external APIs. The pattern is “many tasks, each spends most of its time waiting.”

| Use virtual threads | Stick with platform threads (`parallel="thread"`) |
|---------------------|--------------------------------------------------|
| Fan-out HTTP requests to hundreds of endpoints | CPU-heavy computation (image processing, crypto) |
| Parallel database lookups across many IDs | Work that holds locks for long periods |
| High-concurrency integration/sync jobs | When you need a small, fixed thread pool |

### I/O and interruption

This is one of the practical wins for CFML code.

When a virtual thread hits a **blocking I/O call** (for example `cfhttp`, `queryExecute`, or `sleep`), the JVM **unmounts** it from its carrier platform thread. That carrier is free to run other virtual threads while the first one waits.

That matters when you need to **stop** work:

- A platform thread blocked deep in native I/O may not respond to `interrupt` or `terminate` until the blocking call returns.
- A virtual thread waiting on I/O can be **interrupted or terminated** much more reliably — the JVM can unblock the wait and tear down the task.

`<cfthread>` supports `action="interrupt"` and `action="terminate"` on virtual threads the same way as on platform threads, but you will see the difference most clearly when the thread body is waiting on I/O rather than burning CPU.

## `<cfthread>` / `thread`

Add `virtual=true` when creating a daemon thread (`action="run"`, `type="daemon"` — the default).

```cfml
// Fire-and-forget on a virtual thread
thread name="worker" virtual=true {
	sleep(500);
	thread.data = "done";
}

thread action="join" name="worker";
writeOutput(cfthread.worker.data); // done
```

Inside the thread body, `thread.virtual` tells you whether the thread actually runs on a virtual thread (`true` on Java 21+, `false` when Lucee fell back to a platform thread).

### Interrupt and terminate

```cfml
thread name="fetch" virtual=true {
	// long-running I/O — virtual thread releases its carrier while waiting
	http url="https://httpbin.org/delay/30" result="rsp" timeout=60;
}

sleep(100); // let the thread start

thread action="interrupt" name="fetch";
thread action="join" name="fetch";
```

`priority` has **no effect** on virtual threads — the JVM does not apply thread priorities to them.

Task threads (`type="task"`) do not support the `virtual` attribute.

## Parallel Functions

Iteration functions accept a `parallel` argument with three modes:

| Value | Behaviour |
|-------|-----------|
| `"none"` | Sequential — runs on the calling thread (default) |
| `"thread"` | Parallel on platform threads (bounded pool) |
| `"virtual"` | Parallel on virtual threads (unbounded by default) |

Applies to `arrayMap`, `arrayEach`, `arrayFilter`, `arrayReduce`, `arraySome`, `arrayEvery`, and the equivalent `list*`, `struct*`, and `query*` functions. Collection member syntax works too: `ids.each(callback, "virtual")`.

### HTTP fan-out example

```cfml
ids = [101, 102, 103, 104, 105];

// Each closure runs on its own virtual thread
results = arrayMap(ids, function(id) {
	http url="https://httpbin.org/get?id=#id#" result="rsp" timeout=10;
	return deserializeJSON(rsp.fileContent).args.id;
}, "virtual");

writeDump(results);
```

### Concurrency limit

By default, `parallel="virtual"` is **unbounded** — every element gets its own virtual thread. That is usually fine for I/O-bound work, but you can cap it:

```cfml
// At most 10 virtual threads running closures at once
arrayEach(ids, function(id) {
	queryExecute("SELECT * FROM items WHERE id = :id", { id: id });
}, "virtual", 10);
```

With `parallel="thread"`, omitting `maxConcurrency` uses a bounded pool. With `parallel="virtual"`, `maxConcurrency=0` (the default) means unbounded.

### Deprecated boolean syntax

Older code may pass `true`/`false` as the parallel argument. This still works but is deprecated — prefer the string modes:

- `false` → `"none"`
- `true` → `"thread"`, or `"virtual"` when the global default is enabled (see below)

## Global Default

You can make virtual threads the default without changing every call site.

**System property / environment variable:**

```
lucee.thread.virtual=true
```

```
LUCEE_THREAD_VIRTUAL=true
```

When enabled:

- `<cfthread>` without an explicit `virtual` attribute runs on virtual threads
- `parallel=true` (deprecated boolean) uses virtual threads instead of platform threads

Per-call overrides always win: `virtual=false` on a thread tag, or `parallel="thread"` on a function, forces platform threads even when the global default is `true`.

## See Also

- [Complete Guide to Threading in Lucee](thread-usage.md) — platform threads, thread pools, coordination
- [Thread Tasks](thread-task.md) — daemon vs task threads
- [`<cfthread>`](../reference/tags/thread.md) — full tag reference
