<cfset local.args = arguments.args><!--- scope hack --->
<cfparam name="args.page"    type="page" />
<cfparam name="args.docTree" type="any" />

<cfscript>
	local.category = args.page;
	local.pages    = args.docTree.getPagesByCategory( local.category.getSlug() );
	local.pages    = args.docTree.sortPagesByType( local.pages );

	local.currentPageType = "";
	local.pageTypeTitles = {
		  "function" = "Functions"
		, tag        = "Tags"
	};
</cfscript>


<cfoutput>
	#getEditLink(path=local.category.getSourceFile(), edit=args.edit)#
	#markdownToHtml( local.category.getBody() )#

	<cfif not pages.len()>
		<p><em>There are no pages tagged with this category.</em></p>
	<cfelse>
		<cfloop array="#local.pages#" index="local.i" item="local.page">
			<cfif local.page.getPageType() != local.currentPageType>
				<cfif local.currentPageType.len()>
					</ul>
				</cfif>
				<cfset local.currentPageType = local.page.getPageType()>
				<h2>#( local.pageTypeTitles[ local.page.getPageType() ] ?: "Other articles" )#</h2>
				<ul class="list-unstyled">
			</cfif>

			<li>[[#htmleditformat(local.page.getId())#]] #htmleditformat( getMetaDescription(local.page, local.page.getBody()) )#</li>
		</cfloop>
		</ul>
	</cfif>
</cfoutput>