component javasettings='{maven: ["org.jsoup:jsoup:1.21.2"]}'{

	import org.jsoup.parser.Parser;
	import org.jsoup.nodes.Document;
	
	function parseHtml(required string html) {
		return Parser::parse(arguments.html, "");
	}
	/**
	 * Select elements using CSS selector
	 */
	public array function select(required any document, required string cssSelector) {
		var elements = arguments.document.select(arguments.cssSelector);
		var result = [];

		// Convert Java collection to CFML array
		var iterator = elements.iterator();
		while (iterator.hasNext()) {
			arrayAppend(result, iterator.next());
		}

		return result;
	}

	/**
	 * Get text content from an element
	 */
	public string function getText(required any element) {
		return arguments.element.text();
	}

	/**
	 * Get attribute value from an element
	 */
	public string function getAttr(required any element, required string attributeName) {
		return arguments.element.attr(arguments.attributeName);
	}

	/**
	 * Check if element has an attribute
	 */
	public boolean function hasAttr(required any element, required string attributeName) {
		return arguments.element.hasAttr(arguments.attributeName);
	}

	/**
	 * Get the node name (tag name) of an element
	 */
	public string function getNodeName(required any element) {
		return arguments.element.nodeName();
	}
}