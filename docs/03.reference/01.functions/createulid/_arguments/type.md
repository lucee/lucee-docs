Specifies the generation mode of the ULID. If not defined, a standard ULID is generated.

-  `monotonic` ensures ULIDs increase monotonically, suitable for ensuring order in rapid generation scenarios. 
- `hash` mode generates a ULID based on hashing the provided inputs, useful for creating deterministic identifiers.