*New in 5.6.* Replaces the need for Java hacks like ACF's `TransactionTag.getCurrent()` reflection pattern.

Safe to call at any time — returns `false` if ORM is not enabled or no transaction is active.

See [[orm-session-and-transactions]] for transaction details.
