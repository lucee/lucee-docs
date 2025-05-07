<!--
{
  "title": "Lucene 3 Extension",
  "id": "lucene-3-extension",
  "since": "7.0",
  "categories": ["search", "extensions"],
  "description": "Documentation for the Lucene 3 Extension with vector and hybrid search capabilities",
  "keywords": [
    "Lucene",
    "Search",
    "Vector",
    "Hybrid",
    "Semantic",
    "Content Chunks",
    "Embeddings"
  ]
}
-->

# Lucene 3 Extension

The Lucene 3 Extension introduces significant enhancements to Lucee's search capabilities, including vector-based semantic search, hybrid search combining keyword and vector approaches, and improved content chunking for more relevant results.

## Overview

Lucene 3 is a major update to Lucee's search functionality, bringing modern search techniques to your applications. This version introduces:

- Vector-based semantic search using document embeddings
- Hybrid search combining traditional keyword search with vector search
- Enhanced content chunking with passage extraction
- Improved relevance scoring and result highlighting

These features enable more natural language understanding in search operations and provide better support for AI augmentation through Retrieval-Augmented Generation (RAG) patterns.

## Requirements

- Lucee 7.0 or higher
- Lucene 3 Extension (Maven-based version)

## Key Features

### Vector-Based Search

Vector search transforms text into numerical vector representations (embeddings) that capture semantic meaning, allowing searches to find conceptually similar content rather than just keyword matches.

```javascript
// Create a vector-based collection
collection action="Create" 
    collection="semantic_search" 
    path="/path/to/collection"
    mode="vector"              // Pure vector/semantic search
    embedding="word2vec";      // Using word vectors
```

When searching a vector collection, queries are converted to the same vector space, and results are ranked by vector similarity (cosine similarity or other distance metrics).

### Hybrid Search

Hybrid search combines traditional keyword (lexical) search with vector (semantic) search, providing the best of both approaches:

```javascript
// Create a hybrid collection
collection action="Create" 
    collection="hybrid_search" 
    path="/path/to/collection"
    mode="hybrid"              // Combined keyword and vector search
    embedding="TF-IDF"         // Vector embedding method
    ratio="0.5";               // Equal weight to keyword and vector components
```

The `ratio` parameter controls the balance between keyword and vector search:
- 0.5: Equal weight (default)
- >0.5: More emphasis on vector/semantic matches
- <0.5: More emphasis on keyword/exact matches

### Content Chunks and Passages

Lucene 3 introduces advanced content chunking and passage extraction capabilities, especially valuable for AI augmentation:

```javascript
// Search with enhanced content chunking
search 
    collection="my_collection"
    criteria="machine learning"
    contextpassages=5               // Number of passages to extract
    contextHighlightBegin="<mark>"  // Highlighting for matched terms
    contextHighlightEnd="</mark>"
    contextBytes=4000               // Total bytes of context
    contextpassageLength=800        // Length of each passage
    name="searchResults";
```

This feature:
- Extracts the most relevant passages from matched documents
- Provides highlighted context showing where matches occurred
- Allows fine-tuning of passage size and quantity
- Makes it easier to use search results for AI augmentation

### Embedding Methods

Lucene 3 currently supports the following embedding methods:

1. **TF-IDF (Term Frequency-Inverse Document Frequency)**
   - Statistical approach to vector creation
   - Weighs terms based on frequency in document vs. rarity across all documents
   - Computationally efficient but less effective for semantic understanding

2. **word2vec**
   - Neural network approach to create word vectors
   - Better captures semantic relationships between words
   - More effective for natural language queries

## Usage Examples

### Basic Vector Collection Creation

```javascript
// Create a vector-based collection
collection action="Create" 
    collection="articles" 
    path=expandPath("{lucee-config-dir}/collections/articles")
    mode="vector"
    embedding="word2vec";
```

### Hybrid Collection with Custom Ratio

```javascript
// Create a hybrid collection with emphasis on semantic matches
collection action="Create" 
    collection="documentation" 
    path=expandPath("{lucee-config-dir}/collections/docs")
    mode="hybrid"
    embedding="TF-IDF"
    ratio="0.7";    // 70% weight to vector search, 30% to keyword search
```

### Searching with Content Chunks

```javascript
// Search and extract relevant passages
search 
    collection="documentation"
    criteria="#form.searchTerm#"
    contextpassages=3
    contextBytes=3000
    contextpassageLength=500
    name="results";

// Display the results with passage highlights
loop query="results" {
    echo("<h3>#results.title#</h3>");
    echo("<p>Score: #results.score#</p>");
    
    // Display passages
    var passages = results.context.passages;
    loop query="passages" {
        echo("<div class='passage'>");
        echo("<p>#passages.original#</p>");
        echo("</div>");
    }
}
```

## Search Tag Enhancements

The `cfsearch` tag includes new attributes for controlling content chunking:

```javascript
search
    collection="mycollection"
    criteria="your search query"
    maxrows="10"
    
    // New content chunking attributes
    contextpassages="5"
    contextBytes="4000"
    contextpassageLength="800"
    contextHighlightBegin="<mark>"
    contextHighlightEnd="</mark>"
    
    name="results";
```

### Content Chunking Attributes

- **contextpassages**: Number of distinct passages to extract from each matching document
- **contextBytes**: Maximum total bytes of context to return across all passages
- **contextpassageLength**: Maximum length (in bytes) of each individual passage
- **contextHighlightBegin**: HTML tag or text to insert before matched terms
- **contextHighlightEnd**: HTML tag or text to insert after matched terms

## Performance Considerations

- Vector operations are more computationally intensive than traditional keyword searches
- Hybrid searches perform both keyword and vector operations, which may impact performance
- Vector index size is typically larger than keyword-only indexes
- Consider the following optimizations:
  - Regularly optimize collections with `collection action="optimize"`
  - Use appropriate `maxrows` settings to limit result count
  - Adjust `contextpassages` and `contextBytes` values based on needs
  - For large collections, implement caching for frequent searches

## Use Cases

The enhanced search capabilities in Lucene 3 are particularly valuable for:

- **Content Discovery**: Finding conceptually related content beyond keyword matches
- **Natural Language Search**: Supporting more conversational queries
- **Document Similarity**: Identifying similar documents based on meaning rather than just keywords
- **AI Integration**: Providing relevant context for AI through RAG patterns
- **Semantic Classification**: Grouping documents by meaning rather than explicit categories

## Future Enhancements

Additional embedding methods and integration options are planned for future releases to extend the capabilities of the Lucene 3 Extension.