Returns the native `org.hibernate.Session` object for the current request. Lucee returns the Hibernate session directly — unlike ACF which wraps it in `coldfusion.orm.hibernate.SessionWrapper`.

If you're migrating from ACF code that calls `.getActualSession()`, remove that call on Lucee.

Do **not** assign the result to a variable named `session` — that is a reserved scope in CFML. Use `ormSess`, `hibernateSession`, or similar.

The session is created lazily on first ORM operation and closed at the end of the request.

See [[orm-session-and-transactions]] for session lifecycle details.
