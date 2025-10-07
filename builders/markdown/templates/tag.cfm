<cfscript>
	local.args = arguments.args;
	param name="args.page" type="page";

	local.tag = args.page;
	local.attributesHaveDefaultValues = tag.attributesHaveDefaultValues();

	// Title
	echo( "## " & local.tag.getTitle() & chr(10) & chr(10) );

	// Body
	echo( local.tag.getBody() & chr(10) & chr(10) );

	// Body type and script support
	if ( len( trim( local.tag.getBodyTypeDescription() ) ) ) {
		echo( trim( local.tag.getBodyTypeDescription() ) & chr(10) );
	}
	if ( len( trim( local.tag.getScriptSupportDescription() ) ) ) {
		echo( trim( local.tag.getScriptSupportDescription() ) & chr(10) );
	}

	// Status
	if ( len( local.tag.getStatus() ) gt 0 and ( local.tag.getStatus() neq "implemented" and local.tag.getStatus() neq "implemeted" ) ) {
		echo( chr(10) & "**Status:** " & local.tag.getStatus() & chr(10) );
	}

	// Introduced
	if ( len( local.tag.getIntroduced() ) gt 0 ) {
		echo( chr(10) & "**Introduced:** " & local.tag.getIntroduced() & chr(10) );
	}

	// Extension
	if ( len( local.tag.getSrcExtension() ) gt 0 ) {
		echo( chr(10) & "**Requires Extension:** [" & local.tag.getSrcExtension().name & "](https://download.lucee.org/##" & local.tag.getSrcExtension().id & ")" & chr(10) );
	}

	// Usage signature
	echo( chr(10) & "```" & chr(10) );
	echo( local.tag.getUsageSignature( plainText=true ) );
	echo( chr(10) & "```" & chr(10) & chr(10) );

	// Attributes
	if ( !local.tag.getAttributes().len() ) {
		echo( "*This tag does not use any attributes.*" & chr(10) & chr(10) );
	} else {
		echo( "## Attributes" & chr(10) & chr(10) );
		echo( "| Attribute | Type | Required | Description | Default |" & chr(10) );
		echo( "|-----------|------|----------|-------------|---------|" & chr(10) );

		for ( local.attrib in local.tag.getAttributes() ) {
			if ( local.attrib.status neq "implemented" ) {
				continue;
			}
			echo( "| " & markdownTableCell( local.attrib.name ) );
			echo( " | " & markdownTableCell( local.attrib.type ) );
			echo( " | " & ( local.attrib.required ? 'Yes' : 'No' ) );
			echo( " | " & markdownTableCell( ( local.attrib.description ?: "" ) & ( structKeyExists( local.attrib, "aliases" ) && ArrayLen( local.attrib.aliases ) gt 0 ? " *Alias: " & ArrayToList( local.attrib.aliases, ", " ) & "*" : "" ) ) );
			echo( " | " & markdownTableCell( local.attrib.defaultValue ?: "" ) );
			echo( " |" & chr(10) );
		}
		echo( chr(10) );
	}

	// Usage notes
	if ( len( trim( local.tag.getUsageNotes() ) ) ) {
		echo( chr(10) & "## Usage Notes" & chr(10) & chr(10) );
		echo( trim( local.tag.getUsageNotes() ) & chr(10) & chr(10) );
	}

	// Examples
	echo( "## Examples" & chr(10) & chr(10) );
	if ( len( trim( local.tag.getExamples() ) ) ) {
		echo( trim( local.tag.getExamples() ) & chr(10) & chr(10) );
	} else {
		echo( "*There are currently no examples for this tag.*" & chr(10) & chr(10) );
	}

	// Categories and related
	echo( renderCategoriesAndRelated( local.tag, args.docTree, true ) );
</cfscript>
