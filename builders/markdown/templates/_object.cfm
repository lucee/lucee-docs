<cfscript>
	param name="arguments.args.page" type="page";
	local.pg = arguments.args.page;
	local.body = local.pg.getBody();
	if ( !len( local.body ) ) {
		local.body = "Object";
	}

	// Title
	echo( "## " & local.pg.getTitle() & chr(10) & chr(10) );

	// Body
	echo( local.body & chr(10) & chr(10) );

	// Children
	for ( local.child in local.pg.getChildren() ) {
		echo( "- [[" & local.child.getId() & "]] - " & local.child.getDescription() & chr(10) );
	}

	// Categories and related
	echo( renderCategoriesAndRelated( local.pg, arguments.args.docTree, true ) );
</cfscript>
