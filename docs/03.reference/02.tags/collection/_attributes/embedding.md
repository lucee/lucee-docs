Specifies the embedding service to use for creating vector representations of documents, enabling semantic search capabilities. 

Valid options:

- `TF-IDF`: Uses Term Frequency-Inverse Document Frequency statistical method for generating document vectors
- `word2vec`: Uses pre-trained word vectors to create document embeddings with better semantic understanding
- *class-name*: Name of a custom class implementing the `org.lucee.extension.search.lucene.embedding.EmbeddingService` interface