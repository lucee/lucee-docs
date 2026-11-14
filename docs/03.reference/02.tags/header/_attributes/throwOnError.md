Whether to throw an exception when the header can't be set because the response is already committed, for example after a [[tag-flush]].

When **true** (default): Throws an exception.

When **false**: The header and status code are not set, no exception is thrown and a warning is written to the application log.
