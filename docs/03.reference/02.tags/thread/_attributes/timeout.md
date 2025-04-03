When using `action="join"`, specifies the maximum time in milliseconds that the current thread will wait for the joined thread(s) to complete.
            
* If set to `0` (default): The current thread will wait indefinitely until all joining threads finish.
* If set to any positive number: The current thread will resume after the specified timeout, even if joined threads haven't completed.

This attribute prevents deadlocks and allows for graceful timeout handling in multi-threaded operations. When the current thread is the page thread, the page continues waiting until either the threads complete or the timeout expires, regardless of page timeout settings.