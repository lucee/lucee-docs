Specifies the target thread identifier(s). The usage depends on the `action` attribute:
 				
* With `action="run"`: Defines the name to identify the new thread being created. This name becomes the key in the `thread` scope and must be unique within the application.

* With `action="join"`: Specifies which thread(s) the current thread should wait for. To join multiple threads, provide a comma-delimited list of thread names.

* With `action="terminate"` or `action="interrupt"`: Identifies the thread(s) to stop or interrupt.

Thread names should be descriptive of their purpose and follow a consistent naming convention for maintainability.