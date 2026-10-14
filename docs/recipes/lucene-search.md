<!--
{
  "title": "Lucene 3 Extension",
  "id": "lucene-3-extension",
  "since": "7.0",
  "categories": ["search", "extensions"],
  "description": "Install and use the Lucene 3 Extension for keyword, vector, and hybrid search in Lucee",
  "keywords": [
    "Lucene",
    "Search",
    "Vector",
    "Hybrid",
    "Semantic",
    "Content Chunks",
    "Embeddings",
    "cfcollection",
    "cfindex",
    "cfsearch",
    "RAG",
    "extension"
  ],
  "related": [
    "search-recipe",
    "ai-augmentation-lucene",
    "extension-installation",
    "tag-collection",
    "tag-search",
    "tag-index"
  ]
}
-->

# Lucene 3 Extension

The Lucene Search Extension adds full-text search to Lucee using Apache Lucene — no external search service, API keys, or monthly bill.

Version 3.0+ (the Maven-based extension) works with **Lucee 6.2+** for traditional keyword search. **Lucee 7.0+** unlocks vector and hybrid search, content passage extraction for RAG, and tighter integration with Lucee's AI features.

> **Getting started with search?** The [[search-recipe]] walks through creating collections, indexing files and database content, and running searches. This recipe covers what is new in version 3 — collection modes, embeddings, context passages, and how Lucee itself uses the extension.

## Installation

Install via the Lucee Administrator under **Services > Search**, or see [[extension-installation]] for all options (Dockerfile, deploy directory, env var, `.CFConfig.json`).

- **Maven GAV:** `org.lucee:lucene-search-extension`
- **Extension ID:** `EFDEB172-F52E-4D84-9CD1A1F561B3DFC8`
- **Source:** [github.com/lucee/extension-lucene](https://github.com/lucee/extension-lucene)
- **Issues:** [Jira — `cfsearch` label](https://luceeserver.atlassian.net/issues/?jql=labels%20%3D%20cfsearch)
- **Docs category:** [docs.lucee.org/categories/search.html](https://docs.lucee.org/categories/search.html)

Check that the extension is installed and at version 3+:

```luceescript
var extId = "EFDEB172-F52E-4D84-9CD1A1F561B3DFC8";

if ( extensionExists( extId ) ) {
	var info = extensionInfo( extId );
	echo( "Lucene Search #info.version# installed" );
}
```

Pin the version in production — see [[extension-installation]] for why unpinned extensions can resolve to a different version after redeploy.

## Collection Modes

When you create a collection, the `mode` attribute controls how documents are indexed and searched:

| Mode | Since | Description |
| --- | --- | --- |
| `keyword` | 6.2 | Traditional full-text search (default). Best for exact term and phrase matching. |
| `vector` | 7.0 | Semantic search using document embeddings. Finds conceptually similar content even when keywords differ. |
| `hybrid` | 7.0 | Combines keyword and vector scoring. Usually the best choice for natural-language queries and RAG. |

Vector and hybrid collections also need an `embedding` method (see below) and optionally a `ratio` for hybrid weighting.

### Keyword collection (default)

```luceescript
cfcollection(
	action="create",
	collection="helpdesk",
	path=expandPath( "{lucee-config-dir}/collections/helpdesk" )
);
```

This is the same model described in [[search-recipe]] — index files, paths, URLs, or query results, then search with `cfsearch`.

### Hybrid collection

Lucee's own documentation search uses a hybrid collection with TF-IDF embeddings:

```luceescript
cfcollection(
	action="create",
	collection="lucee-documentation",
	path=expandPath( "{lucee-config-dir}/doc/search" ),
	mode="hybrid",
	embedding="TF-IDF",
	ratio="0.5"
);
```

The `ratio` controls how much vector vs keyword scoring contributes in hybrid mode:

- `0.5` — equal weight (default)
- `> 0.5` — more emphasis on semantic/vector matches
- `< 0.5` — more emphasis on keyword/exact matches

### Vector collection

```luceescript
cfcollection(
	action="create",
	collection="articles",
	path=expandPath( "{lucee-config-dir}/collections/articles" ),
	mode="vector",
	embedding="word2vec"
);
```

## Embedding Methods

Embeddings turn text into numeric vectors for semantic search. Lucene 3 supports:

| Value | Type | Notes |
| --- | --- | --- |
| `TF-IDF` | Statistical | Fast, no external files. Good default for hybrid collections. |
| `word2vec` | Neural (GloVe) | Better semantic relationships. Loads pre-trained vectors from disk. |
| `/path/to/vectors.txt` | Custom file | Any path containing `/` or `\` is treated as a GloVe-format vectors file. |

By default, `word2vec` looks for `.txt` files in `{lucee-server}/context/search/embedding/` and uses the largest one found. Pre-trained GloVe vectors are available from [Stanford NLP](https://nlp.stanford.edu/projects/glove/).

You can also load a custom `EmbeddingService` Java class by passing its fully qualified class name as the `embedding` value.

## Indexing Content

All indexing goes through `cfindex`. The [[search-recipe]] covers `type="path"`, `type="file"`, and `type="custom"` in detail. Two additional patterns worth highlighting:

### Index from a URL (web crawl)

Crawl a website and index linked pages:

```luceescript
cfindex(
	action="update",
	collection="website",
	type="url",
	key="https://example.com/docs/",
	extensions=".html,.htm,.cfm",
	recurse="yes"
);
```

The built-in web crawler follows links within the same host, respects the `extensions` filter, and honours the request timeout.

### Incremental indexing with content hashes

When indexing large, slowly changing datasets, avoid re-indexing everything on every request. Lucee's debug documentation reference stores a content hash in `custom4` and only re-indexes when the hash changes:

```luceescript
// Build or load your content query
var qryRecipes = queryExecute( "SELECT id, title, body, keywords FROM recipes WHERE active = 1" );
var contentHash = hash( qryRecipes.toString(), "quick" );

// Check whether this version is already indexed
cfindex( action="list", collection="lucee-documentation", name="indexes" );

var needsUpdate = true;
loop query="indexes" {
	if ( indexes.custom4 == "hash:" & contentHash ) {
		needsUpdate = false;
		break;
	}
}

if ( needsUpdate ) {
	cfindex(
		action="update",
		collection="lucee-documentation",
		type="custom",
		query="qryRecipes",
		key="id",
		title="title",
		body="body,keywords",
		custom1="keywords",
		custom4="hash:" & contentHash
	);
}
```

The same pattern works for indexing function/tag reference data, recipe files, or any other source you can represent as a query.

## Searching

Basic keyword search is covered in [[search-recipe]]. This section focuses on v3 features.

### Context passages (for RAG and AI)

Since 3.0, `cfsearch` can return multiple scored passages from each matching document — not just a single context snippet. This is what powers Lucee's documentation AI assistant and the [[ai-augmentation-lucene]] pattern.

```luceescript
cfsearch(
	collection="lucee-documentation",
	criteria=form.searchTerm,
	name="results",
	maxrows=3,
	contextPassages=3,
	contextBytes=3000,
	contextPassageLength=1000,
	contextHighlightBegin="<mark>",
	contextHighlightEnd="</mark>",
	suggestions="always"
);
```

Each result row includes a `context` struct with a `passages` query. Each passage has:

| Column | Description |
| --- | --- |
| `start` | Start position in the original document text |
| `end` | End position in the original document text |
| `score` | Lucene relevance score for this passage |
| `original` | The passage text (with highlighting if configured) |

```luceescript
loop query="results" {
	echo( "<h3>#results.title#</h3>" );

	loop query="results.context.passages" {
		echo( "<p>#results.context.passages.original#</p>" );
	}
}
```

> **Loader requirement:** Context highlighting attributes (`contextHighlightBegin`, `contextHighlightEnd`, `contextPassages`, `contextPassageLength`, `contextBytes`) require **Lucee 7.0.3.30+** (or 6.2.6.11+) with extension **3.0.0.168+**. On older loaders the extension still works, but these attributes fall back to defaults.

### Augmenting AI queries

Lucee 7's debug documentation reference combines Lucene search with `LuceeInquiryAISession()` — search first, then attach the best passages as context for the LLM:

```luceescript
function augmentSearchCriteria( required string criteria ) {
	// Escape Lucene special characters in user input
	criteria = rereplace( criteria, '([+\-&|!(){}\[\]\^"~*?:\\\/])', '\\1', 'ALL' );

	cfsearch(
		collection="lucee-documentation",
		criteria=arguments.criteria,
		name="local.searchResults",
		maxrows=3,
		contextPassages=3,
		contextBytes=3000,
		contextPassageLength=1000,
		contextHighlightBegin="<match>",
		contextHighlightEnd="</match>",
		suggestions="always"
	);

	var augmentedQuery = "User Query: #arguments.criteria#";
	var contextData = [];

	loop query="searchResults" {
		var passages = [];
		loop query="searchResults.context.passages" {
			passages.append( {
				"start": searchResults.context.passages.start,
				"end": searchResults.context.passages.end,
				"score": searchResults.context.passages.score,
				"data": searchResults.context.passages.original
			} );
		}

		contextData.append( {
			"title": searchResults.title,
			"summary": searchResults.summary,
			"keywords": searchResults.custom1,
			"source": searchResults.custom2,
			"score": searchResults.score,
			"rank": searchResults.rank,
			"content": passages
		} );
	}

	if ( contextData.len() ) {
		augmentedQuery &= chr( 10 ) & "Documentation Context: #serializeJSON( contextData )#";
	}

	return augmentedQuery;
}

// Use with an AI session
var session = LuceeCreateAISession( name: "myclaude" );
var response = LuceeInquiryAISession( session, augmentSearchCriteria( "how do I configure caching?" ) );
```

See [[ai-augmentation-lucene]] for a full RAG implementation guide, including indexing from databases, files, and remote URLs.

## Administrator UI

Once installed, the Lucee Administrator exposes search under **Services > Search** (`services.search.cfm`):

- List, create, repair, optimize, purge, and delete collections
- View collection mode, embedding, ratio, and index count
- Index a directory path with file extension filters
- Run test searches against a collection

The admin UI uses the same `cfcollection`, `cfindex`, and `cfsearch` tags under the hood.

## Real-World Use in Lucee 7

Lucee 7 itself uses the Lucene 3 extension in several places:

| Use case | Where | What it does |
| --- | --- | --- |
| Documentation AI assistant | Debug monitor `reference.cfm` | Hybrid collection indexes recipes, tags, and functions; `augmentSearchCriteria()` feeds passages to the AI session |
| Admin AI navigation | `overview.cfm`, `adminAINavigation.cfm` | Checks whether Lucene 3+ is installed before showing search-related AI features |
| MCP doc search | MCP server extension | `search_lucee_docs` queries Lucene indexes for functions, tags, and recipes |
| Search admin | `services.search.cfm` | Manage collections and run test searches from the Administrator |

These are useful reference implementations when building your own search or RAG features.

## Performance Considerations

- Vector and hybrid searches are more CPU-intensive than keyword-only search
- Hybrid mode runs both keyword and vector queries — tune `ratio` and `maxrows` for your workload
- Vector indexes are larger than keyword-only indexes
- Run `cfcollection( action="optimize", collection="..." )` after bulk updates (good candidate for a scheduled task)
- For RAG, keep `contextPassages` and `contextBytes` proportional to your LLM context window — Lucee's documentation assistant uses 3 passages and 3000 bytes as a practical default
- Cache frequent search results at the application level when the index changes infrequently

## Related Recipes

- [[search-recipe]] — collections, indexing, search syntax, categories, maintenance
- [[ai-augmentation-lucene]] — full RAG pattern with Lucene + AI sessions
- [[ai]] — configuring AI endpoints in Lucee
- [[extension-installation]] — install and pin the extension in Docker and CI
