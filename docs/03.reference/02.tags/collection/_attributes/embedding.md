Specifies the embedding service to use for creating vector representations of documents, enabling semantic search capabilities.

Valid options:

- `TF-IDF`: Uses Term Frequency-Inverse Document Frequency statistical method for generating document vectors
- `word2vec`: Uses pre-trained word vectors to create document embeddings with better semantic understanding
- */path/to/vectors.txt*: A file path to a GloVe/word2vec format vectors file, loaded using the word2vec service. Any value containing `/` or `\` is treated as a file path. *(since Lucene Extension 3.0.0.165)*
- *class-name*: Name of a custom class implementing the `org.lucee.extension.search.lucene.embedding.EmbeddingService` interface