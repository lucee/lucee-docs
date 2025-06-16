When `mode="hybrid"`, this value controls the balance between keyword and vector search components.

Value range is 0.0 to 1.0, where:

- 0.5: Equal weight given to both keyword and vector search (default)
- Values greater than 0.5: Greater emphasis on vector search (semantic matching)
- Values less than 0.5: Greater emphasis on keyword search (exact term matching)

For example, a ratio of 0.7 would give 70% weight to vector search and 30% to keyword search. This attribute is ignored when mode is not "hybrid".