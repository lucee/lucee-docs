<cfparam name="args.crumbs" type="array" />
<cfparam name="args.docTree"   type="any" />
<cfparam name="args.page"   type="any" />

<cfif args.page.getId() neq "/home">
	<!--- pages may have multiple crumbs LD-112 --->
	<cfloop array="#args.crumbs#" item="local._crumbs">
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
				loop array="#local._crumbs#" item="local.pageSlug" index="local.i" {
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
				/*
				ArrayAppend(local.jsonLd.itemListElement, [
					"@type": "ListItem",
					"position": #local.i+2#,
					"item": [
						"@id": args.page.getPath() & '.html',
						"name": args.page.getTitle()
					]
				]);
				*/
			</cfscript>
		</cfsilent>

		<cfoutput>
			<script type="application/ld+json">#serializeJSON(local.jsonLd)#</script>
			<ul class="breadcrumb margin-no-top margin-right margin-no-bottom margin-left" itemscope itemtype="http://schema.org/BreadcrumbList">
				<li itemprop="itemListElement" itemscope itemtype="http://schema.org/ListItem">
					<a href="/index.html" itemprop="url">
						<span itemprop="name">Docs</span>
					</a>
					<meta itemprop="position" content="1" />
				</li>
				<cfset local.i = 1>
				<cfloop array="#local._crumbs#" item="local.pageSlug" index="local.i">
					<cfset local.crumb = args.doctree.getPage(local.pageSlug)>
					<li itemprop="itemListElement" itemscope itemtype="http://schema.org/ListItem">
						<a href="#local.crumb.getPath()#.html" itemprop="url">
							<span itemprop="name">#HtmlEditFormat(local.crumb.getTitle())#</span>
						</a>
						<meta itemprop="position" content="#local.i+1#" />
					</li>
				</cfloop>
				<!---
				<li itemprop="itemListElement" itemscope itemtype="http://schema.org/ListItem" class="active">
					<span itemprop="name">#HtmlEditFormat( args.page.getTitle() )#</span>
					<meta itemprop="position" content="#local.i+2#" />
				</li>
				--->
			</ul>
		</cfoutput>
	</cfloop>
</cfif>