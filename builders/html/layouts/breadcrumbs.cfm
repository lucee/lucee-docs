<cfparam name="args.crumbs" type="array" />
<cfparam name="args.page"   type="any" />
<cfparam name="args.baseHref"   type="string" default=""/>


<cfif args.page.getId() neq "/home">
	<cfoutput>
		<ul class="breadcrumb margin-no-top margin-right margin-no-bottom margin-left" itemscope itemtype="http://schema.org/BreadcrumbList">
			<li itemprop="itemListElement" itemscope itemtype="http://schema.org/ListItem">
				<a href="#args.baseHref#index.html">Home</a>
			</li>
			<cfloop array="#args.crumbs#" item="pageSlug" index="i">
				<li itemprop="itemListElement" itemscope itemtype="http://schema.org/ListItem">[[#pageSlug#]]</li>
			</cfloop>
			<li itemprop="itemListElement" itemscope itemtype="http://schema.org/ListItem" class="active">#HtmlEditFormat( args.page.getTitle() )#</li>
		</ul>
	</cfoutput>
</cfif>