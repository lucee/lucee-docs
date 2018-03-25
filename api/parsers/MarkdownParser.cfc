component {
	public any function init() {
		_setupMarkdownProcessor();
		_setupNoticeBoxRenderer();

		return this;
	}

	public string function markdownToHtml( required string markdown ) {
		var html = _getMarkdownProcessor().markdownToHtml( arguments.markdown );
		return _getNoticeBoxRenderer().renderNoticeBoxes( html );
	}

	public void function validateMarkdown(required struct pageContent){
		var lines = ListToArray(arguments.pageContent.body, chr(10), true);
		var errors = [];
		local.lastLineEmpty = true;	// treat first row as empty
		local.inList = false;
		for (var l = 1; l <= lines.len();  l++){
			local.row = trim(lines[l]);
			local.empty=(len(row) eq 0);
			if (local.empty){
				local.inList = false;
				local.lastLineEmpty = true;
				continue;
			}
			local.first = left(local.row, 2);
			if (local.first eq "- "){
				if (local.lastLineEmpty){	
					local.inList = true;	
				} else if (not local.inList){	
					errors.append({
						error: "list should be preceeded by a new line",
						file: "#arguments.pageContent.sourceFile#",
						line: l,
						line: local.row
					});
					break;
				}
			} 				
			local.lastLineEmpty = local.empty;			
		}

		if (ArrayLen(errors) gt 0){
			dump(var=errors, label=arguments.pageContent.sourceFile);
			writeOutput("<pre>#arguments.pageContent.body#</pre>");			
			abort;			
		}
	}

// PRIVATE
	private void function _setupMarkdownProcessor() {
		var javaLib   = [ "../lib/parboiled-core-1.1.7.jar", "../lib/parboiled-java-1.1.7.jar",  "../lib/pegdown-1.5.0.jar" ];
		var extension = CreateObject( "java", "org.pegdown.Extensions", javaLib );
		var processor = CreateObject( "java", "org.pegdown.PegDownProcessor", javaLib ).init(extension.TABLES);

		_setMarkdownProcessor( processor );
	}

	private void function _setupNoticeBoxRenderer() {
		_setNoticeBoxRenderer( new api.rendering.NoticeBoxRenderer() );
	}

	private any function _getMarkdownProcessor() output=false {
		return _markdownProcessor;
	}
	private void function _setMarkdownProcessor( required any markdownProcessor ) output=false {
		_markdownProcessor = arguments.markdownProcessor;
	}

	private any function _getNoticeBoxRenderer() {
		return _noticeBoxRenderer;
	}
	private void function _setNoticeBoxRenderer( required any noticeBoxRenderer ) {
		_noticeBoxRenderer = arguments.noticeBoxRenderer;
	}
}
