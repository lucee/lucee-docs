<cfparam name="args.crumbs" type="array" />
<cfparam name="args.docTree"   type="any" />
<cfparam name="args.page"   type="any" />

<cfif args.page.getId() neq "/home">
	<cfloop array="#args.crumbs#" item="local._crumbs">
		<cfoutput>
			<ul class="breadcrumb margin-no-top margin-right margin-no-bottom margin-left">
				<li><a href="/index.html">Docs</a></li>
				<cfloop array="#local._crumbs#" item="local.pageSlug" index="i">
					<cfset local.crumb = args.doctree.getPage(local.pageSlug)>
					<li>#HtmlEditFormat(local.crumb.getTitle())#</li>
				</cfloop>
				<!---<li itemprop="itemListElement" itemscope itemtype="http://schema.org/ListItem" class="active">#HtmlEditFormat( args.page.getTitle() )#</li>--->
			</ul>
		</cfoutput>
	</cfloop>
</cfif>