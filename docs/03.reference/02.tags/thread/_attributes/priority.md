Sets the execution priority level for the thread when using `action="run"`. Valid values are:
 				
* **HIGH**: Thread receives more CPU time, suitable for critical operations
* **NORMAL**: Standard priority level (default)
* **LOW**: Thread receives less CPU time, suitable for background operations

Priority affects thread scheduling by the JVM but does not guarantee execution order. Higher priority threads generally get more processing time than lower priority ones, but this depends on the JVM implementation and system load.

Note that page-level code (outside of `cfthread` tags) always executes at `NORMAL` priority.