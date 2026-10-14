### Basic search

```luceescript
cfsearch(
	collection="myCollection",
	criteria="lucee cfml",
	name="results"
);

loop query="results" {
	echo( "<h3>#results.title#</h3>" );
	echo( "<p>#results.context#</p>" );
}
```

### Search with highlighted context

```luceescript
cfsearch(
	collection="myCollection",
	criteria="lucee",
	name="results",
	contextHighlightBegin="<mark>",
	contextHighlightEnd="</mark>",
	contextBytes=500,
	contextPassages=3
);
```

### Paginated search

```luceescript
cfsearch(
	collection="myCollection",
	criteria="lucee",
	name="results",
	startRow=11,
	maxRows=10
);
```

### Search with spelling suggestions

```luceescript
cfsearch(
	collection="myCollection",
	criteria="luceee",
	name="results",
	suggestions="always",
	status="searchStatus"
);

if ( results.recordCount == 0 && structKeyExists( searchStatus, "suggestedQuery" ) ) {
	echo( "Did you mean: #searchStatus.suggestedQuery#?" );
}
```

### Search across multiple collections

```luceescript
cfsearch(
	collection="articles,faqs,manuals",
	criteria="getting started",
	name="results"
);
```

### Search by category

```luceescript
cfsearch(
	collection="myCollection",
	criteria="billing",
	category="support",
	name="results"
);
```
