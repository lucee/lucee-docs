<cfscript>
	param name="args.page" type="page";
	param name="args.docTree" type="any";

	local.pg = args.page;
	local.status = arguments.args.docTree.getReferenceByStatus( arguments.args.page.getStatusFilter() );

	// Title
	echo( "## " & local.pg.getTitle() & chr(10) & chr(10) );

	// Body
	echo( local.pg.getBody() & chr(10) & chr(10) );

	// Functions
	if ( structCount( local.status.function ) gt 0 ) {
		echo( "## Functions" & chr(10) & chr(10) );
		loop collection="#local.status.function#" index="local.i" item="local.child" {
			echo( "- [[" & local.child.getId() & "]] - " & local.child.getDescription() & chr(10) );
		}
		echo( chr(10) );
	}

	// Tags
	if ( structCount( local.status.tag ) gt 0 ) {
		echo( "## Tags" & chr(10) & chr(10) );
		loop collection="#local.status.tag#" index="local.i" item="local.child" {
			echo( "- [[" & local.child.getId() & "]] - " & local.child.getDescription() & chr(10) );
		}
		echo( chr(10) );
	}
</cfscript>
