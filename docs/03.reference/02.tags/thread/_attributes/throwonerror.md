Only applicable with `action="join"`. Determines whether exceptions thrown in joined threads should propagate to the joining thread.
 				
    * When `true`: If any of the joined threads have encountered errors, the first error found will be thrown as an exception in the current thread. This allows for easier error detection by propagating errors up the call stack.
    
    * When `false` (default): Errors in joined threads remain isolated in their respective thread scopes and won't affect the current thread's execution. You must explicitly check the thread status to identify errors.
    
This attribute is useful for implementing fail-fast behavior in situations where thread errors should immediately stop dependent operations.