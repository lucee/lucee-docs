**Development use only.** Rebuilds all entity mappings and recreates the Hibernate SessionFactory. All active sessions are closed and their connections released.

This is an expensive operation that blocks ORM access during the rebuild. Do not call in production — it causes request pile-ups while the SessionFactory is being reconstructed.

If you're calling `ormReload()` to "fix" ORM issues, you're masking a real problem. Investigate the root cause instead.
