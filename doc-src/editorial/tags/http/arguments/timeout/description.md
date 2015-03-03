A value, in seconds. When a URL timeout is specified in the browser, the timeout attribute setting
		takes precedence over the Lucee Administrator timeout. The server then uses the lesser
		of the URL timeout and the timeout passed in the timeout attribute, so that the request always times
		out before or at the same time as the page times out. If there is no URL timeout specified, Lucee
		takes the lesser of the Lucee Administrator timeout and the timeout passed in the timeout attribute.
		If there is no timeout set on the URL in the browser, no timeout set in the Lucee Administrator,
		and no timeout set with the timeout attribute, Lucee waits indefinitely for the cfhttp request to
		process.