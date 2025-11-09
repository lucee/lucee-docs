Only applicable with `action="run"`. Controls whether the thread gets its own isolated copy of the caller's scopes or shares them directly. Defaults to `true`.

* When `true` (default): The thread receives a deep copy of the caller's scopes at thread creation time. Changes made within the thread do not affect the parent context, and vice versa. This provides isolation and prevents concurrency issues.

* When `false`: The thread directly accesses the caller's scopes. Changes made in the thread are immediately visible to the parent context. Use with caution as this can lead to race conditions and thread safety issues.

This attribute is useful when you need threads to share state, but requires careful synchronization to avoid data corruption.