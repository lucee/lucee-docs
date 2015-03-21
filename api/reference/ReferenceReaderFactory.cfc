component {

	public any function getFunctionReferenceReader() {
		var args = arguments;
		return _getFromRequestCache( "functionReferenceReader", function(){
			return new FunctionReferenceReader( argumentCollection=args );
		} );
	}

	public any function getTagReferenceReader() {
		var args = arguments;
		return _getFromRequestCache( "tagReferenceReader", function(){
			return new TagReferenceReader( argumentCollection=args );
		} );
	}

// PRIVATE
	private any function _getFromRequestCache( required string cacheKey, required any generator ) {
		request.parserFactoryCache = request.parserFactoryCache ?: {};

		if ( !request.parserFactoryCache.keyExists( arguments.cacheKey ) ) {
			request.parserFactoryCache[ arguments.cacheKey ] = arguments.generator();
		}

		return request.parserFactoryCache[ arguments.cacheKey ];
	}

}