Returns the `org.hibernate.SessionFactory` for the given datasource. The SessionFactory is built once at application start and lives for the application lifetime.

If ORM is not enabled for that datasource, an exception will be thrown.

Useful for advanced operations like inspecting entity metadata, checking the active dialect, or accessing cache regions.

See [[orm-logging]] for debugging techniques using the SessionFactory.
