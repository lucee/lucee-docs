Specifies how Lucee stores session variables:

- **memory (default):** the session is only kept in memory
- **cookie:** the session is stored in the client cookie
- **file:** the session is stored in a local file
- **"datasource-name"|"cache-name":** when you select a name of an available datasource or cache, the session scope will be stored in there