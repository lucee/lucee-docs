---
title: LogAllThreads
id: function-logallthreads
categories:
- debugging
- server
- system
- thread
---

Creates detailed thread stack trace logs in JSONL format for performance analysis and debugging.

This function captures stack traces from all running threads at specified intervals for a given duration.

It executes asynchronously, returning immediately after starting the logging process, making it ideal
for analyzing specific code segments by initiating logging just before the target code execution.

The output format is JSONL (JSON Lines), where each line represents a separate JSON object containing:

- Timestamp offset in milliseconds from 1/1/1970 00:00:00 UTC (Unix 0)
- Complete stack trace of each thread's current location

This data can be used for:

- Performance bottleneck identification
- Thread behavior analysis
- Deadlock detection
- Resource usage patterns
