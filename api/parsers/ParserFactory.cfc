component {

	public any function getYamlParser() {
		return _getFromRequestCache( "yamlParser", function(){
			return new YamlParser();
		} );
	}

	public any function getMarkdownParser() {
		return _getFromRequestCache( "markdownParser", function(){
			return new MarkdownParser();
		} );
	}

// PRIVATE
	private any function _getFromRequestCache( required string cacheKey, required any generator ) {
		request.parserFactoryCache = request.parserFactoryCache ?: {};

		if ( !request.parserFactoryCache.keyExists( arguments.cacheKey ) ) {
			lock name="docsParserFactoryCache_#arguments.cacheKey#" timeout=10 {
				if ( !request.parserFactoryCache.keyExists( arguments.cacheKey ) ) {
					request.parserFactoryCache[ arguments.cacheKey ] = arguments.generator();
				}
			}
		}

		return request.parserFactoryCache[ arguments.cacheKey ];
	}

}