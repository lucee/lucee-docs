<cfparam name="args.crumbs" type="array" />
<cfparam name="args.categories" type="array" />
<cfparam name="args.docTree"   type="any" />
<cfparam name="args.page"   type="any" />

<cfif args.edit>
	<cfset local.docs_base_url = "http://#cgi.http_host#">
<cfelse>	
	<cfset local.docs_base_url = "https://docs.lucee.org">
</cfif>

<cfif args.page.getId() neq "/home" and ArrayLen(args.crumbs)>
	<!--- pages may have multiple crumbs LD-112 --->
	<cfloop array="#args.crumbs#" item="local._crumbs">
		<cfif ArrayLen(local._crumbs)>
		<cfsilent>
			<cfscript>
				local.jsonLd = [
					"@context": "http://schema.org",
					"@type": "BreadcrumbList",
					"itemListElement" = [
							[
							"@type":"ListItem",
							"position":1,
							"name":"Docs",
							"item": local.docs_base_url
						]
					]
				];
				local.i = 1; // in case args.crumbs is empty
				loop array="#local._crumbs#" item="local.pageSlug" index="local.i" {
					local.crumb = args.doctree.getPage(local.pageSlug);
					local._crumb = [
						"@type": "ListItem",
						"position": #local.i+1#,
						"name": local.crumb.getTitle(),
						"item": local.docs_base_url & local.crumb.getPath() & '.html'
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
					<a href="#local.docs_base_url#/index.html" itemprop="item">
						<span itemprop="name">Docs</span>
					</a>
					<meta itemprop="position" content="1" />
				</li>
				<cfset local.i = 1>
				<cfloop array="#local._crumbs#" item="local.pageSlug" index="local.i">
					<cfset local.crumb = args.doctree.getPage(local.pageSlug)>
					<li itemprop="itemListElement" itemscope itemtype="http://schema.org/ListItem">
						<a href="#local.docs_base_url##local.crumb.getPath()#.html" itemprop="item">
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
		</cfif>
	</cfloop>
	<cfif ArrayLen(args.categories)>
		<ul class="breadcrumb-categories margin-no-top margin-right margin-no-bottom margin-left">
		<li><cfif args.categories.len() eq 1>Category:<cfelse>Categories:</cfif></li>
		<cfloop array="#args.categories#" item="local._cat" index="local.i">
			<cfoutput><li class="category">#local._cat#<cfif local.i lt args.categories.len()>, </cfif></li></cfoutput>
		</cfloop>
		</ul>
	</cfif>
</cfif>