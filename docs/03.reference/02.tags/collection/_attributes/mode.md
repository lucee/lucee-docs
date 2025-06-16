Specifies the search algorithm to use when querying this collection. 

Options:

- `keyword`: Traditional term-based search using Lucene (default)
- `vector`: Pure semantic search using vector embeddings
- `hybrid`: Combines keyword and vector search for optimal results, balancing term matching with semantic understanding

When set to `keyword`, the `embedding` attribute is ignored. Vector and hybrid modes require an embedding service to be specified.