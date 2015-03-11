/**
 * Helper class for rendering a cfm template. This may be to produce an HTML
 * layout, or some other output of the docs.
 *
 * Provides a simple interface for consistency and helpers
 * for common functionality within the templates.
 *
 */
component {

// CONSTRUCTOR
	public any function init( required string rootTemplatesPath ) {
		_setRootTemplatesPath( arguments.rootTemplatesPath );

		return this;
	}

// PUBLIC API
	public string function render( required string template, struct args={} ) {
		var rendered = "";

		savecontent variable="rendered" {
			include template=_getRootTemplatesPath() & arguments.template;
		}

		return Trim( rendered );
	}

// PRIVATE GETTERS AND SETTERS
	private string function _getRootTemplatesPath() output=false {
		return _rootTemplatesPath;
	}
	private void function _setRootTemplatesPath( required string rootTemplatesPath ) output=false {
		_rootTemplatesPath = arguments.rootTemplatesPath;
	}
}