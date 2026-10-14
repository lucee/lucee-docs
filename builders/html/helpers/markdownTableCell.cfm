<cfscript>
function markdownTableCell( required string content ) {
	var cleaned = arguments.content;
	// Remove newlines and replace with spaces
	cleaned = reReplace( cleaned, "\r?\n", " ", "all" );
	// Escape pipes that would break the table, but NOT pipes inside wiki-links [[...|...]]
	// First, temporarily replace wiki-links with placeholders
	var wikiLinks = [];
	var wikiLinkRegex = "\[\[([^\[\]]+)\]\]";
	var match = reFindNoCase( wikiLinkRegex, cleaned, 1, true );
	while ( match.pos[1] > 0 ) {
		var linkText = mid( cleaned, match.pos[1], match.len[1] );
		arrayAppend( wikiLinks, linkText );
		cleaned = replace( cleaned, linkText, "___WIKILINK_#arrayLen(wikiLinks)#___", "one" );
		match = reFindNoCase( wikiLinkRegex, cleaned, 1, true );
	}
	// Now escape remaining pipes
	cleaned = replace( cleaned, "|", "\|", "all" );
	// Restore wiki-links
	for ( var i = 1; i <= arrayLen( wikiLinks ); i++ ) {
		cleaned = replace( cleaned, "___WIKILINK_#i#___", wikiLinks[i], "one" );
	}
	// Collapse multiple spaces
	cleaned = reReplace( cleaned, "\s+", " ", "all" );
	// Trim
	cleaned = trim( cleaned );
	return cleaned;
}
</cfscript>
