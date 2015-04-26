<cfparam name="args.page"    type="page" />
<cfparam name="args.docTree" type="any" />

<cfscript>
	category = args.page;
	pages    = args.docTree.getPagesByCategory( category.getSlug() );
	pages    = args.docTree.sortPagesByType( pages );

	currentPageType = "";
	pageTypeTitles = {
		  "function" = "Functions"
		, tag        = "Tags"
	};
</cfscript>


<cfoutput>
	<h1>#category.getTitle()#</h1>

	#markdownToHtml( category.getBody() )#

	<cfif not pages.len()>
		<p><em>There are no pages tagged with this category.</em></p>
	<cfelse>
		<cfloop array="#pages#" index="i" item="page">
			<cfif page.getPageType() != currentPageType>
				<cfif currentPageType.len()>
					</ul>
				</cfif>
				<cfset currentPageType = page.getPageType()>
				<h2>#( pageTypeTitles[ page.getPageType() ] ?: "Other articles" )#</h2>
				<ul class="list-unstyled">
			</cfif>

			<li>[[#page.getId()#]]</li>
		</cfloop>
		</ul>
	</cfif>
</cfoutput>