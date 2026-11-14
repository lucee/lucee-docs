if set to **false**, no exception is thrown when the file does not exist and nothing is deleted ( since Lucee 9.0.0.564 ).

Default is **true**, a missing file throws an exception, as before.

- with **false** every other error still throws, for example when no permission to delete the file or when the path is a directory that is not empty
- also when another thread or process removes the file at the same time, no exception is thrown
