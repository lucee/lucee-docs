---
title: Lucee uses Apache Lucene for full text indexing
id: tips-search-engine
related:
- tag-index
- tag-search
---

### What engine does CFSEARCH use? ###

Lucee uses Apache Lucene v2.3.2 as the default search engine. You are free to use your preferred search engine or write your own search and register in the lucee-(web|server).xml(.cfm) with the following lines:

```lucee
<search directory="{lucee-web}/search/" engine-class="lucee.runtime.search.lucene2.LuceneSearchEngine"/>
```

Our javadoc of interface SearchEngine. We have different implementation for SearchEngines

* lucee.runtime.search.lucene.LuceneSearchEngine alias for lucee.runtime.search.lucene2.LuceneSearchEngine
* DummySearchEngine -> throws only exception that search is disabled.
* lucee.runtime.search.lucene1.LuceneSearchEngine implementation for lucene 1.4.3 (lucee 2.0)

Return to [[faq-s]] or [[tips-and-tricks]]
