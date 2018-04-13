<cfparam name="args.crumbs" type="array" />
<cfparam name="args.page"   type="any" />

<cfif args.page.getId() neq "/home">
	<cfsilent>
	<cfscript>
		local.jsonLd = [
			"@context": "http://schema.org",
			"@type": "BreadcrumbList",
			"itemListElement" = [
					[
					"@type":"ListItem",
					"position":1,
					"item": [
						"@id":"http://docs.lucee.org",
						"name":"Docs"
					]
				]
			]
		];
		local.i = 1; // in case args.crumbs is empty
		loop array="#args.crumbs#" item="local.pageSlug" index="local.i" {
			local.crumb = args.doctree.getPage(local.pageSlug);
			local._crumb = [
				"@type": "ListItem",
				"position": #local.i+1#,
				"item": [
					"@id": local.crumb.getPath() & '.html',
					"name": local.crumb.getTitle()
				]
			];
			ArrayAppend(local.jsonLd.itemListElement, local._crumb);
		}

		ArrayAppend(local.jsonLd.itemListElement, [
			"@type": "ListItem",
			"position": #local.i+2#,
			"item": [
				"@id": args.page.getPath() & '.html',
				"name": args.page.getTitle()
			]
		]);
	</cfscript>
	</cfsilent>

	<cfoutput>
		<script type="application/ld+json">#serializeJSON(local.jsonLd)#</script>
		<ul class="breadcrumb margin-no-top margin-right margin-no-bottom margin-left" itemscope itemtype="http://schema.org/BreadcrumbList">
			<li itemprop="itemListElement" itemscope itemtype="http://schema.org/ListItem">
				<a href="/index.html">Docs</a>
			</li>
			<cfloop array="#args.crumbs#" item="local.pageSlug" index="i">
				<li itemprop="itemListElement" itemscope itemtype="http://schema.org/ListItem">[[#local.pageSlug#]]</li>
			</cfloop>
			<li itemprop="itemListElement" itemscope itemtype="http://schema.org/ListItem" class="active">#HtmlEditFormat( args.page.getTitle() )#</li>
		</ul>
	</cfoutput>
</cfif>