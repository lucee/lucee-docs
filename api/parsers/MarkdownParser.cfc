component {
	property name="_markdownProcessor" type="object";
	property name="_noticeBoxRenderer" type="object";
	property name="flexmark" type="boolean" default="false";

	public any function init() {
		variables.flexmark = false; //experimental https://luceeserver.atlassian.net/browse/LD-109
		_setupMarkdownProcessor();
		_setupNoticeBoxRenderer();

		return this;
	}

	public string function _markdownToHtml( required string markdown, required boolean stripParagraph=false) {
		if (variables.flexmark){
			var processor = _getMarkdownProcessor();
			var doc = processor.parser.parse(arguments.markdown);
			var html = processor.renderer.render( doc );
		} else {
			lock name="pegDownIsntThreadSafe" timeout="5" type="exclusive" {
				var html = _getMarkdownProcessor().markdownToHtml( arguments.markdown );
			}
		}
		if  (arguments.stripParagraph ){ // used for inline content
			html = ReplaceNoCase( ReplaceNoCase( html, "<p>", "" ), "</p>", "");
		}
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
						error: "list should be preceded by a new line",
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
	public void function _setupMarkdownProcessor() {
		if (variables.flexmark) {
			var javaLib   = [
				 "../lib/flexmark-0.32.20.jar"
				,"../lib/flexmark-ext-gfm-tables-0.32.20.jar"
				,"../lib/flexmark-ext-tables-0.32.20.jar"
				,"../lib/flexmark-formatter-0.32.20.jar"
				,"../lib/flexmark-html-parser-0.32.20.jar"
				,"../lib/flexmark-profile-pegdown-0.32.20.jar"
				,"../lib/flexmark-util-0.32.20.jar"
			];

			var parser = CreateObject( "java", "com.vladsch.flexmark.parser.Parser", javaLib );
			var renderer = CreateObject( "java", "com.vladsch.flexmark.html.HtmlRenderer", javaLib );
			var options = _createOptions({}, parser, javaLib);

			/*

			// see https://github.com/vsch/flexmark-java/wiki/Pegdown-Migration
			var PegdownOptionsAdapter = CreateObject( "java", "com.vladsch.flexmark.profiles.pegdown.PegdownOptionsAdapter", javaLib );
			var pegDownExtensions = CreateObject( "java", "com.vladsch.flexmark.profiles.pegdown.Extensions", javaLib );

			// options is com.vladsch.flexmark.util.options.MutableDataSet

			var pegDownOptions = PegdownOptionsAdapter.flexmarkOptions(
				javaCast("boolean", true),
				pegDownExtensions.ALL,
				options // should be com.vladsch.flexmark.Extension[]
			);
			var parserOptions = pegDownOptions;
			dump(pegDownOptions);
			abort;

			*/
			_setMarkdownProcessor({
				parser: parser.builder(options).build(),
				renderer: renderer.builder(options).build()
			});
		} else {
			var javaLib   = [ "../lib/parboiled-core-1.1.7.jar", "../lib/parboiled-java-1.1.7.jar",  "../lib/pegdown-1.5.0.jar" ];
			var extension = CreateObject( "java", "org.pegdown.Extensions", javaLib );
			var processor = CreateObject( "java", "org.pegdown.PegDownProcessor", javaLib ).init(extension.TABLES);
			_setMarkdownProcessor( processor );
		}
	}

	private void function _setupNoticeBoxRenderer() {
		_setNoticeBoxRenderer( new api.rendering.NoticeBoxRenderer() );
	}

	private any function _getMarkdownProcessor() output=false {
		return variables._markdownProcessor;
	}
	private void function _setMarkdownProcessor( required any markdownProcessor ) {
		request.logger(text="Rendering with " & (variables.flexmark ? 'Flexmark': 'PegDown') & " markdown parser");
		variables._markdownProcessor = arguments.markdownProcessor;
	}

	private any function _getNoticeBoxRenderer() {
		return variables._noticeBoxRenderer;
	}
	private void function _setNoticeBoxRenderer( required any noticeBoxRenderer ) {
		variables._noticeBoxRenderer = arguments.noticeBoxRenderer;
	}

	// from https://github.com/coldbox-modules/cbox-markdown/blob/master/modules/cbmarkdown/models/Processor.cfc

	private function _createOptions( required struct options, required staticParser, required array javaLib ) {
		structAppend( arguments.options, defaultOptions(), false );
		var staticTableExtension = CreateObject( "java", "com.vladsch.flexmark.ext.tables.TablesExtension", javaLib );
		return CreateObject( "java", "com.vladsch.flexmark.util.options.MutableDataSet", javaLib )
			.init()
			.set(
				staticTableExtension.COLUMN_SPANS,
				javacast( "boolean", arguments.options.tableOptions.columnSpans )
			)
        	.set(
        		staticTableExtension.APPEND_MISSING_COLUMNS,
        		javacast( "boolean", arguments.options.tableOptions.appendMissingColumns )
        	)
        	.set(
        		staticTableExtension.DISCARD_EXTRA_COLUMNS,
        		javacast( "boolean", arguments.options.tableOptions.discardExtraColumns )
        	)
        	.set(
        		staticTableExtension.CLASS_NAME,
        		arguments.options.tableOptions.className
        	)
        	.set(
        		staticTableExtension.HEADER_SEPARATOR_COLUMN_MATCH,
        		javacast( "boolean", arguments.options.tableOptions.headerSeparationColumnMatch )
        	)
        	.set(
        		arguments.staticParser.EXTENSIONS,
        		[ staticTableExtension.create() ]
        	);
	}

	private struct function defaultOptions() {
		return {
			tableOptions = {
				// Treat consecutive pipes at the end of a column as defining spanning column.
				columnSpans = true,
				// Whether table body columns should be at least the number or header columns.
				appendMissingColumns = true,
				// Whether to discard body columns that are beyond what is defined in the header
				discardExtraColumns = true,
				// Class name to use on tables
				className = "table",
				// When true only tables whose header lines contain the same number of columns as the separator line will be recognized
				headerSeparationColumnMatch = true
			}
		};
	}
}
