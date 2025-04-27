Specifies the maximum number of conversation exchanges to retain in the serialized output.

When specified, the function preserves the most recent exchanges up to this limit, truncating older exchanges while maintaining the session configuration.

This helps control memory usage and storage requirements for long-running conversations without losing recent context.

When used with condense=true, maxlength is applied before condensation. If not specified, all conversation history is retained.