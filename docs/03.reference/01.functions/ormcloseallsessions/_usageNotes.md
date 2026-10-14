Closes all ORM sessions across all datasources for the current request and releases their database connections back to the pool.

Equivalent to calling [[function-ormclosesession]] for each active datasource.

In most cases you don't need to call this — sessions are automatically closed at the end of every request.
