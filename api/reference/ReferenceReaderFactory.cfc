component {

	public any function getFunctionReferenceReader() {
		var args = arguments;
		return _getFromRequestCache( "functionReferenceReader", function(){
			return new FunctionReferenceReader( argumentCollection=variables.args );
		} );
	}

	public any function getTagReferenceReader() {
		var args = arguments;
		return _getFromRequestCache( "tagReferenceReader", function(){
			return new TagReferenceReader( argumentCollection=variables.args );
		} );
	}

	public any function getMethodReferenceReader() {
		var args = arguments;
		return _getFromRequestCache( "MethodReferenceReader", function(){
			return new MethodReferenceReader( argumentCollection=variables.args );
		} );
	}
	public any function getObjectReferenceReader() {
		var args = arguments;
		return _getFromRequestCache( "ObjectReferenceReader", function(){
			return new ObjectReferenceReader( argumentCollection=variables.args );
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