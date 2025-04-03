Defines the thread execution model:
 				
* **daemon** (default): Executes as a daemon thread of the current thread. Daemon threads do not prevent the application from shutting down when all non-daemon threads have completed.

* **task**: Executed by the Lucee task manager, which provides additional robustness features like retry mechanisms. Task threads are ideal for asynchronous operations that should continue even if the user request completes.
