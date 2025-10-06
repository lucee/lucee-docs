<cfscript>
	local.args = arguments.args;
	param name="args.page" type="page";
	param name="args.docTree" type="any";

	local.category = args.page;
	local.pages = args.docTree.getPagesByCategory( local.category.getSlug() );
	local.pages = args.docTree.sortPagesByType( local.pages );

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
		if ( !structKeyExists( local.pageTypeTitles, local.page.getPageType() ) ) {
			request.logger( text="Unknown page type: [ #local.page.getPageType()# ] page [#local.page.getSourceFile()#] defaulting to [page.md]", type="WARN" );
			local.page.setPageType( "page" );
		}
		local.pageTypeTitles[ local.page.getPageType() ].pages++;
	}

	// Title
	echo( "## " & local.category.getTitle() & chr(10) & chr(10) );

	// Body
	echo( local.category.getBody() & chr(10) & chr(10) );

	// Pages
	if ( !local.pages.len() ) {
		echo( "*There are no pages tagged with this category.*" & chr(10) );
	} else {
		loop collection="#local.pageTypeTitles#" key="local.pageTypeKey" value="local.pageType" {
			if ( local.pageType.pages gt 0 ) {
				echo( "## " & local.pageType.title & chr(10) & chr(10) );

				loop array="#local.pages#" index="local.i" item="local.page" {
					if ( local.pageTypeKey eq local.page.getPageType() ) {
						local.desc = reReplace( getMetaDescription( local.page, local.page.getBody() ), "\s*" & chr(35) & "{1,6}\s*", " ", "all" );
						echo( "- **" & htmleditformat( local.page.getId() ) & "** - " & htmleditformat( local.desc ) & chr(10) );
					}
				}
				echo( chr(10) );
			}
		}
	}

	// Categories and related
	echo( renderCategoriesAndRelated( local.category, args.docTree, true ) );
</cfscript>
