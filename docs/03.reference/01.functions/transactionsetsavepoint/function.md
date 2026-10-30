---
title: TransactionSetSavePoint
id: function-transactionsetsavepoint
categories:
- orm
- query
---

Saves a specific state within a transaction

When ORM code ran in the transaction, the ORM session is flushed so pending changes are covered by the savepoint. After a rollback to the savepoint with [[function-transactionrollback]] the ORM session is cleared and entities that were loaded or saved earlier in the transaction become detached.
