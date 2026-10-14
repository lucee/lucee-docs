<cfscript>
	param name="arguments.args.page" type="page";
	local.pg = arguments.args.page;
	local.body = local.pg.getBody();

	// Title
	echo( "## " & local.pg.getTitle() & chr(10) );

	// Introduced
	if ( structKeyExists( local.pg, "since" ) ) {
		echo( chr(10) & "**Introduced:** " & local.pg.since & chr(10) );
	}

	// Body
	echo( chr(10) & local.body & chr(10) );

	// Categories and related
	echo( renderCategoriesAndRelated( local.pg, arguments.args.docTree, true ) );
</cfscript>
