
The action to take, one of the following values:
- join: Makes the current thread wait until the thread or threads specified in the name attribute complete processing,
or until the period specified in the timeout attribute passes, before continuing processing.
If you don't specify a timeout and thread you are joining to doesn't finish, the current thread also cannot finish processing.
- run: Creates a thread and starts it processing.
- sleep: Suspends the current threads processing for the time specified by the duration attribute.
This action is useful if one thread must wait for another thread to do processing without joining the threads.
- terminate: Stops processing of the thread specified in the name attribute.
If you terminate a thread, the thread scope includes an ERROR metadata structure with information about the termination.