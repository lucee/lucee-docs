<cfscript>
	param name="arguments.args.page" type="page";
	local.args = arguments.args;
	local.meth = args.page;
	local.argumentsHaveDefaultValues = local.meth.argumentsHaveDefaultValues();

	// Title
	echo( "## " & local.meth.getTitle() & chr(10) & chr(10) );

	// Body
	echo( local.meth.getBody() & chr(10) & chr(10) );

	// Introduced
	if ( len( local.meth.getIntroduced() ) gt 0 ) {
		echo( "**Introduced:** " & local.meth.getIntroduced() & chr(10) & chr(10) );
	}

	// Usage signature
	echo( "```" & chr(10) );
	echo( local.meth.getUsageSignature( plainText=true ) );
	echo( chr(10) & "```" & chr(10) & chr(10) );

	// Returns
	echo( "**Returns:** " & local.meth.getReturnType() & chr(10) & chr(10) );

	// Arguments
	if ( !local.meth.getArguments().len() ) {
		if ( local.meth.getArgumentType() == "dynamic" ) {
			echo( "*This function takes zero or more dynamic arguments. See examples for details.*" & chr(10) & chr(10) );
		} else {
			echo( "*This function does not take any arguments.*" & chr(10) & chr(10) );
		}
	} else {
		echo( "## Arguments" & chr(10) & chr(10) );
		echo( "| Argument | Type | Required | Description | Default |" & chr(10) );
		echo( "|----------|------|----------|-------------|---------|" & chr(10) );

		for ( local.arg in local.meth.getArguments() ) {
			if ( local.arg.status eq "hidden" ) {
				continue;
			}
			echo( "| " & markdownTableCell( local.arg.name ) );
			echo( " | " & markdownTableCell( local.arg.type ) );
			echo( " | " & ( local.arg.required ? 'Yes' : 'No' ) );
			echo( " | " & markdownTableCell( trim( local.arg.description ) & ( local.arg.keyExists( "alias" ) and len( local.arg.alias ) gt 0 ? " *Alias: " & ListChangeDelims( local.arg.alias, ", ", "," ) & "*" : "" ) ) );
			echo( " | " & markdownTableCell( local.arg.default ?: "" ) );
			echo( " |" & chr(10) );
		}
		echo( chr(10) );
	}

	// Examples
	echo( "## Examples" & chr(10) & chr(10) );
	if ( len( trim( local.meth.getExamples() ) ) ) {
		echo( trim( local.meth.getExamples() ) & chr(10) );
	} else {
		echo( "*There are currently no examples for this function*" & chr(10) );
	}

	// Categories and related
	echo( renderCategoriesAndRelated( local.meth, args.docTree, true ) );
</cfscript>
