if set to **false**, no exception is thrown when the directory does not exist and nothing is deleted, with or without **recurse** ( since Lucee 9.0.0.564 ).

Default is **true**, a missing directory throws an exception, as before.

- with **false** every other error still throws, for example a directory that is not empty when **recurse** is not set, or a path that is a file
- also when another thread or process removes the directory at the same time, no exception is thrown
