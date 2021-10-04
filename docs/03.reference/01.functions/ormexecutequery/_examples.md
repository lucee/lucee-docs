### Simple Examples

```luceescript
res = ormExecuteQuery(
        "SELECT id, A FROM test WHERE id = :A AND A = :B"
        ,{A:"test", B:"aaaa"}
        )

```