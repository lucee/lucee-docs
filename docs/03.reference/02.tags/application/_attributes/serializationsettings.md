```
{
preserveCaseForStructKey: boolean,
preserveCaseForQueryColumn: boolean,
serializeQueryAs: "column|struct|row",
dateFormat: "cf|iso|isoms|custom mask"
}
```

`dateFormat` (Lucee 9.0 and later) defines how [[function-serializejson]] formats dates, the default is `cf` (the traditional Lucee format). Use `iso` for ISO 8601, for example `2021-01-29T11:45:26+01:00`, `isoms` for ISO 8601 including milliseconds or a custom date/time mask like `yyyy-MM-dd HH:mm:ss`. It can also be defined for all applications in the configuration (`serialization.dateFormat` in `.CFConfig.json`), a value in the `Application.cfc` overrides the configuration.