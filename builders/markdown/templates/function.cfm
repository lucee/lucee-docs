<cfscript>
	param name="arguments.args.page" type="page";
	local.args = arguments.args;
	local.fn = args.page;
	local.argumentsHaveDefaultValues = local.fn.argumentsHaveDefaultValues();

	// Title
	echo( "## " & local.fn.getTitle() & chr(10) & chr(10) );

	// Body
	echo( local.fn.getBody() & chr(10) );

	// Status
	if ( len( local.fn.getStatus() ) gt 0 and ( local.fn.getStatus() neq "implemented" and local.fn.getStatus() neq "implemeted" ) ) {
		echo( chr(10) & "**Status:** " & local.fn.getStatus() & chr(10) );
	}

	// Alias
	if ( len( local.fn.getAlias() ) gt 0 ) {
		echo( chr(10) & "**Alias:** " & local.fn.getAlias() & chr(10) );
	}

	// Introduced
	if ( len( local.fn.getIntroduced() ) gt 0 ) {
		echo( chr(10) & "**Introduced:** " & local.fn.getIntroduced() & chr(10) );
	}

	// Extension
	if ( len( local.fn.getSrcExtension() ) gt 0 ) {
		echo( chr(10) & "**Requires Extension:** [" & local.fn.getSrcExtension().name & "](https://download.lucee.org/##" & local.fn.getSrcExtension().id & ")" & chr(10) );
	}

	// Usage signature
	echo( chr(10) & "```" & chr(10) );
	echo( local.fn.getUsageSignature( plainText=true ) );
	echo( chr(10) & "```" & chr(10) & chr(10) );

	// Returns
	echo( "**Returns:** " & local.fn.getReturnType() & chr(10) );
	if ( len( trim( local.fn.getReturnTypeDesc() ) ) ) {
		echo( chr(10) & trim( local.fn.getReturnTypeDesc() ) & chr(10) );
	}

	// Arguments
	if ( !local.fn.getArguments().len() ) {
		if ( local.fn.getArgumentType() == "dynamic" ) {
			echo( chr(10) & "*This function takes zero or more dynamic arguments. See examples for details.*" & chr(10) );
		} else {
			echo( chr(10) & "*This function does not take any arguments.*" & chr(10) );
		}
	} else {
		echo( chr(10) & "## Arguments" & chr(10) & chr(10) );
		echo( "| Argument | Type | Required | Description | Default |" & chr(10) );
		echo( "|----------|------|----------|-------------|---------|" & chr(10) );

		for ( local.arg in local.fn.getArguments() ) {
			if ( local.arg.status neq "implemented" ) {
				continue;
			}
			echo( "| " & markdownTableCell( local.arg.name ) );
			echo( " | " & markdownTableCell( local.arg.type ) );
			echo( " | " & ( local.arg.required ? 'Yes' : 'No' ) );
			echo( " | " & markdownTableCell( trim( local.arg.description ) & ( len( local.arg.alias ) gt 0 ? " *Alias: " & ListChangeDelims( local.arg.alias, ", ", "," ) & "*" : "" ) ) );
			echo( " | " & markdownTableCell( local.arg.default ?: "" ) );
			echo( " |" & chr(10) );
		}
	}

	// Usage notes
	if ( len( trim( local.fn.getUsageNotes() ) ) ) {
		echo( chr(10) & "## Usage Notes" & chr(10) & chr(10) );
		echo( trim( local.fn.getUsageNotes() ) & chr(10) );
	}

	// Examples
	echo( chr(10) & "## Examples" & chr(10) );
	if ( len( trim( local.fn.getExamples() ) ) ) {
		echo( chr(10) & trim( local.fn.getExamples() ) & chr(10) );
	} else {
		echo( chr(10) & "*There are currently no examples for this function*" & chr(10) );
	}

	// Categories and related
	echo( renderCategoriesAndRelated( local.fn, args.docTree, true ) );
</cfscript>
