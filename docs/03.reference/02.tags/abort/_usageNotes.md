Since 5.3, by default output from [[tag-function|functions]] are no longer buffered when `output=false` is set, as a result, an abort inside a function will no longer work.

You can re-enable this application wide using `this.bufferOutput=true` in your [[tag-application|Application.cfc]], or server wide via the Lucee Administrator, via the Output settings page.