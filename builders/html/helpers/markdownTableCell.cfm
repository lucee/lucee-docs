<cfscript>
function markdownTableCell( required string content ) {
	var cleaned = arguments.content;
	// Remove newlines and replace with spaces
	cleaned = reReplace( cleaned, "\r?\n", " ", "all" );
	// Remove pipes that would break the table
	cleaned = replace( cleaned, "|", "\|", "all" );
	// Collapse multiple spaces
	cleaned = reReplace( cleaned, "\s+", " ", "all" );
	// Trim
	cleaned = trim( cleaned );
	return cleaned;
}
</cfscript>
