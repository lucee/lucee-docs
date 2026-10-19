A query with one row per AI connection and the columns:

- `name`: The name of the connection, as used for example with `CreateAISession(name)`
- `label`: The display label of the connection
- `default`: The default category the connection is used for (for example "exception"), empty when it is not a default
- `model`: The model the connection uses
- `class`: The class of the AI engine
- `bundleName`: The OSGi bundle of the AI engine, if any
- `bundleVersion`: The OSGi bundle version of the AI engine, if any
- `temperature`: The configured temperature, empty when not set
- `connectionTimeout`: Connection timeout in milliseconds
- `socketTimeout`: Socket timeout in milliseconds
- `conversationSizeLimit`: Maximum conversation history size
- `source`: "application" for connections defined in the application, "server" for connections configured in the Lucee Administrator
