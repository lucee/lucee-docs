<!--
{
  "title": "Adding Full Text Search to Your Application",
  "id": "search-recipe",
  "since": "6.2",
  "categories": ["search", "extensions"],
  "description": "A practical guide to adding full-text search to your Lucee application using collections, indexing, and search",
  "keywords": [
    "search",
    "cfcollection",
    "cfindex",
    "cfsearch",
    "Lucene",
    "full-text",
    "indexing",
    "collections"
  ],
  "related": [
    "tag-collection",
    "tag-index",
    "tag-search",
    "lucene-3-extension",
    "ai-augmentation-lucene"
  ]
}
-->

# Adding Full Text Search to Your Application

You've built a help desk app. There's a knowledge base full of articles, FAQs in the database, and a growing pile of PDF manuals.
Users are complaining — they can't find anything.
Time to add search.

The Lucene Extension gives you full-text search without external services, API keys, or a monthly bill.
Install it from the Lucee Administrator under Extensions, or add it to your `.CFConfig.json` — then create a collection, index your content, and search it.

> **Note:** This recipe covers the Lucene Extension version 3.0+, which works with Lucee 6.2 and higher.
> Vector and hybrid search features require Lucee 7.0 — see the [Lucene Extension](lucene-3-extension) recipe for details.

## Creating a Collection

A collection is where your search index lives on disk.
Think of it as a database for searchable content.

```luceescript
// Create a collection for our knowledge base
cfcollection(
	action="create",
	collection="helpdesk",
	path=expandPath( "{lucee-config-dir}/collections/helpdesk" )
);
```

That's it. You've got an empty collection ready to be filled.

## Indexing Content from Files

Let's say your knowledge base articles live as HTML files on disk.
You can index an entire directory in one go:

```luceescript
// Index all HTML files in the knowledge base directory
cfindex(
	action="update",
	collection="helpdesk",
	type="path",
	key=expandPath( "/knowledgebase/articles" ),
	urlpath="/knowledgebase/articles",
	extensions=".html,.htm,.pdf,.txt",
	recurse="yes"
);
```

The `type="path"` tells Lucene to crawl a directory.
The `urlpath` is prepended to each filename in search results, so you can link straight to the original file.
The `extensions` attribute controls which files get indexed — no point indexing your `.css` files.

You can also index a single file:

```luceescript
// Index one specific document
cfindex(
	action="update",
	collection="helpdesk",
	type="file",
	key=expandPath( "/knowledgebase/articles/getting-started.html" ),
	urlpath="/knowledgebase/articles"
);
```

## Indexing Content from a Database

Files are easy, but what about your FAQ table sitting in a database?
Use `type="custom"` to index query results:

```luceescript
// Pull FAQs from the database
cfquery( name="faqs", datasource="helpdesk" ) {
	echo( "SELECT id, question, answer, department FROM faqs WHERE active = 1" );
}

// Index the query results
cfindex(
	action="update",
	collection="helpdesk",
	type="custom",
	query="faqs",
	key="id",
	title="question",
	body="answer",
	custom1="department"
);
```

The `key` is a unique identifier for each record — typically your primary key.
The `title` and `body` map query columns to searchable fields.
The `custom1` through `custom4` fields let you store extra metadata alongside the index entry.

## Searching

Now the good bit. Let's search:

```luceescript
cfsearch(
	collection="helpdesk",
	criteria="password reset",
	name="results",
	maxrows=20
);

loop query="results" {
	echo( "<h3><a href='#results.url#'>#results.title#</a></h3>" );
	echo( "<p>#results.context#</p>" );
	echo( "<p class='score'>Relevance: #numberFormat( results.score, '0.00' )#</p>" );
}
```

The `context` column returns a snippet of the matching content with your search terms in context — handy for showing users *why* a result matched.

### Highlighting Search Terms

You can control how search terms are highlighted in the context:

```luceescript
cfsearch(
	collection="helpdesk",
	criteria="password reset",
	name="results",
	contextHighlightBegin="<mark>",
	contextHighlightEnd="</mark>",
	contextBytes=500,
	contextPassages=3
);
```

This wraps matched terms in `<mark>` tags and returns up to 3 passages totalling 500 bytes of context.

### Pagination

For large result sets, use `startRow` and `maxRows`:

```luceescript
// Page 3, 10 results per page
cfsearch(
	collection="helpdesk",
	criteria=form.searchTerm,
	name="results",
	startRow=21,
	maxRows=10
);
```

### Spelling Suggestions

Users can't spell. Lucene can help:

```luceescript
cfsearch(
	collection="helpdesk",
	criteria="pasword reeset",
	name="results",
	suggestions="always",
	status="searchStatus"
);

if ( results.recordCount == 0 && structKeyExists( searchStatus, "suggestedQuery" ) ) {
	echo( "Did you mean: <em>#searchStatus.suggestedQuery#</em>?" );
}
```

## Using Categories

As your knowledge base grows, users want to filter by topic.
Enable categories when you create the collection:

```luceescript
// Create a collection with category support
cfcollection(
	action="create",
	collection="helpdesk_v2",
	path=expandPath( "{lucee-config-dir}/collections/helpdesk_v2" ),
	categories="yes"
);
```

Then assign categories when indexing.
The `category` attribute takes a literal category string (or comma-separated list), not a query column reference.
So you index each category separately:

```luceescript
// Index support FAQs
cfindex(
	action="update",
	collection="helpdesk_v2",
	type="custom",
	query="supportFaqs",
	key="id",
	title="question",
	body="answer",
	category="support",
	categoryTree="support/faqs"
);

// Index billing FAQs
cfindex(
	action="update",
	collection="helpdesk_v2",
	type="custom",
	query="billingFaqs",
	key="id",
	title="question",
	body="answer",
	category="billing",
	categoryTree="billing/faqs"
);
```

And filter by category when searching:

```luceescript
// Only search within the "billing" category
cfsearch(
	collection="helpdesk_v2",
	criteria="refund",
	category="billing",
	name="results"
);
```

The `categoryTree` attribute lets you build hierarchies — `support/faqs`, `support/guides`, `engineering/api` — and search at any level:

```luceescript
// Search everything under "support"
cfsearch(
	collection="helpdesk_v2",
	criteria="refund",
	categoryTree="support",
	name="results"
);
```

## Keeping It Fresh

Content changes. Your index needs to keep up.

### Refresh the Whole Index

When you've made bulk changes, rebuild everything:

```luceescript
// Wipe and re-index from scratch
cfindex(
	action="refresh",
	collection="helpdesk",
	type="path",
	key=expandPath( "/knowledgebase/articles" ),
	urlpath="/knowledgebase/articles",
	extensions=".html,.htm,.pdf,.txt",
	recurse="yes"
);
```

The `refresh` action clears the existing index before re-adding — unlike `update`, which adds or overwrites individual entries.

### Remove Specific Entries

Deleted an article? Remove it from the index:

```luceescript
cfindex(
	action="delete",
	collection="helpdesk",
	type="file",
	key=expandPath( "/knowledgebase/articles/old-article.html" )
);
```

### Purge Everything

Nuclear option — clear the index but keep the collection:

```luceescript
cfindex(
	action="purge",
	collection="helpdesk"
);
```

### Optimize for Performance

After lots of updates and deletes, the index can get fragmented.
Optimize it periodically:

```luceescript
cfcollection(
	action="optimize",
	collection="helpdesk"
);
```

This reorganises the internal structure for faster searches.
Good candidate for a scheduled task.

### List Your Collections

Check what collections exist:

```luceescript
cfcollection( action="list", name="collections" );
dump( collections );
```

## Searching Multiple Collections

You can search across multiple collections at once by passing a comma-separated list:

```luceescript
cfsearch(
	collection="helpdesk,manuals,faqs",
	criteria="password reset",
	name="results"
);
```

Results are merged and ranked by relevance across all collections.

## Search Syntax

The `type` attribute on `cfsearch` controls how the search criteria are parsed.

### Simple (default)

`type="simple"` uses a Verity-compatible syntax. This is the default and covers most use cases.

| Syntax | Meaning | Example |
| --- | --- | --- |
| word | Match a single term | `password` |
| word word | Phrase (words together) | `password reset` |
| `"quoted phrase"` | Exact phrase | `"password reset"` |
| `AND` | Both terms required | `password AND reset` |
| `OR` or `,` | Either term | `password OR email` or `password, email` |
| `NOT` | Exclude term | `password NOT expired` |
| `(...)` | Grouping | `(password OR email) AND reset` |
| `*` | Prefix wildcard | `pass*` |
| `?` | Single-character wildcard | `p?ss` |
| `~` | Fuzzy match | `pasword~` |
| `+` / `-` | Required / excluded term | `+password -expired` |

> **Note:** This is a subset of Verity syntax — operators like `STEM`, `NEAR`, `PARAGRAPH`, and `SENTENCE` are not supported.

### Explicit (since Search Extension 3.0.0.166)

`type="explicit"` passes criteria directly to the search provider's native query parser — currently [Lucene's StandardQueryParser](https://lucene.apache.org/core/9_12_1/queryparser/org/apache/lucene/queryparser/flexible/standard/StandardQueryParser.html).

This gives you access to the full Lucene query syntax:

| Syntax | Meaning | Example |
| --- | --- | --- |
| `field:term` | Search a specific field | `title:reset` |
| `field:"phrase"` | Phrase in specific field | `title:"password reset"` |
| `term^2` | Boost a term's relevance | `password^2 reset` |
| `term~2` | Fuzzy with edit distance | `pasword~1` |
| `"phrase"~3` | Proximity (words within N) | `"password reset"~5` |
| `[a TO z]` | Range query | `modified:[2024-01-01 TO 2024-12-31]` |
| `term1 && term2` | Boolean AND | `password && reset` |
| `term1 \|\| term2` | Boolean OR | `password \|\| email` |

Use `explicit` when you need field-specific queries, boosting, or range searches that the simple parser can't express.

## Going Further

This recipe covers traditional keyword search — matching words and phrases.
Since v3 the Lucene Extension also supports:

- **Vector search** — find conceptually similar content, not just keyword matches
- **Hybrid search** — combine keyword and vector approaches for best results
- **AI augmentation** — use search results to give context to AI/LLM queries (RAG)

Check the related recipes below for details.
