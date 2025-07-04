Whether to throw an exception on HTTP errors that can be caught with `cftry`/`cfcatch`.

When **true**: Throws exceptions for connection failures, lookup errors, or non-2xx status codes.

When **false** (default): Populates the result struct with error information instead.

The result struct always contains an `ERROR` key indicating if an error occurred, regardless of this setting.