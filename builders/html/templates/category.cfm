<cfset local.args = arguments.args>
<cfparam name="args.page"    type="page" />
<cfparam name="args.docTree" type="any" />

<cfscript>
	local.category = args.page;
	local.pages    = args.docTree.getPagesByCategory( local.category.getSlug() );
	local.pages    = args.docTree.sortPagesByType( local.pages );

	local.currentPageType = "";
	// this enforces the sub category order
	local.pageTypeTitles = [
		"function" = { title="Functions", pages=0 },
		"tag"      = { title="Tags", pages=0 },
		 "_method" = { title="Methods", pages=0 },
		 "_object" = { title="Objects", pages=0 },
		"category" = { title="Categories", pages=0 },
		"page"     = { title="Guides",pages=0 }
	];

	local.missingPageTypes = {};
	loop array="#local.pages#" index="local.i" item="local.page" {
		if ( !structKeyExists(local.pageTypeTitles, local.page.getPageType() ) ) {
			request.logger (text="Unknown page type: [ #local.page.getPageType()# ] page [#local.page.getSourceFile()#] defaulting to [page.md]", type="WARN");
			local.page.setPageType("page");
		}
		local.pageTypeTitles[local.page.getPageType()].pages++;
	}
</cfscript>


<cfoutput>
	#getEditLink(path=local.category.getSourceFile(), edit=args.edit)#
	#_markdownToHtml( local.category.getBody() )#

	<cfif not pages.len()>
		<p><em>There are no pages tagged with this category.</em></p>
	<cfelse>
		<cfloop collection="#local.pageTypeTitles#" key="local.pageTypeKey" value="local.pageType">
			<cfif local.pageType.pages gt 0>
				<h2>#( local.pageType.title )#</h2>
				<ul class="list-unstyled">
				<cfloop array="#local.pages#" index="local.i" item="local.page">
					<cfif local.pageTypeKey eq local.page.getPageType()>
						<cfset desc = reReplace(getMetaDescription(local.page, local.page.getBody()), "\s*##{1,6}\s*", " ", "all")>
						<li>[[#htmleditformat(local.page.getId())#]] #_markdownToHtml(htmleditformat(desc))#</li>
					</cfif>
				</cfloop>
				</ul>
			</cfif>
		</cfloop>
	</cfif>
</cfoutput>