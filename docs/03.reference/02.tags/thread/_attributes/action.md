Specifies the operation to perform on the thread. Options include:
                        
* **run** (default): Creates a new thread and begins execution immediately. The thread executes the code contained within the tag body.

* **join**: Synchronizes the current thread with one or more target threads, pausing execution until the specified threads complete or a timeout occurs. This enables coordinated workflows where operations depend on the results of multiple threads.

* **sleep**: Temporarily suspends the current thread's execution for the specified duration in milliseconds. This action is useful for rate-limiting, implementing delays, or yielding processing time to other threads without creating full thread dependencies.

* **terminate**: Forcibly stops the specified thread's execution immediately. This is a non-cooperative shutdown that may leave resources in an inconsistent state. When terminated, the thread scope will include an `ERROR` metadata structure with termination details.

* **interrupt**: Sets the interrupt status flag on the specified thread, requesting cooperative termination. If the thread is blocked in a `ThreadJoin`, `sleep`, or I/O operation, it will receive an `InterruptedException` and its interrupt status will be cleared. The thread can then perform cleanup operations before stopping, making this safer than `terminate` for most scenarios.
