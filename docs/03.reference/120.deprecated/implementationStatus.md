---
title: Deprecated Tags & Functions
id: deprecated
statusFilter: deprecated
---

Backwards compatibility is considered super important in Lucee.

**Deprecated** means that whilst the functionality is still **supported** and **available**, Lucee offers newer, more modern way(s) to achieve the same result.

Why do we document something as deprecated? It's because there's newer functionality that offers:

- better argument order for functions, to make your code clearer
- better performance
- cleaner, clearer programming styles
- less overloaded functionality which results in complicated code signatures / documentation.

Realistically we seldom actually remove deprecated fuctionality from Lucee (eg [[function-IsDefined]] still works in Lucee 5.x), but when something is deprecated, it's a warning that it might be removed, so you should act accordingly.

Deprecation also flags that the given feature **might** possibly be removed in a future **major** release of Lucee, therefore it acts as advice to stop using the functionality.