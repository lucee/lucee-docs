Alternative to using nested cfqueryparam tags. Supports two parameter styles:

- Positional parameters (Array): Use question marks (?) as placeholders in SQL.

SQL example: 

        "SELECT * FROM users WHERE status = ? AND id > ? LIMIT ?"
        Params: [
        { type: "string", value: "active" },
        { type: "integer", value: 42 },
        { type: "integer", value: 100 }
        ]

- Named parameters (Struct): Use colon-prefixed names as placeholders in SQL.

SQL example: 

        "SELECT * FROM users WHERE status = :status AND id > :id LIMIT :limit"
        Params: {
        "status": { type: "string", value: "active" },
        "id": { type: "integer", value: 42 },
        "limit": { type: "integer", value: 100 }
        }

- List parameters (for IN clauses): Set list=true to expand arrays into comma-separated values.

SQL example:

        "SELECT * FROM users WHERE status IN (?)"
        Params: [
        { type: "string", value: ["active", "pending"], list: true }
        ]
(The same can be done with named parameters)