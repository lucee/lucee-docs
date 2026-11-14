**Deprecated** since Lucee 7.1.3 ([LDEV-6919](https://luceeserver.atlassian.net/browse/LDEV-6919)). It still works, but a request timeout can only interrupt the request thread, so it does not stop a blocking query, network call or native code. Set a timeout on the operation itself instead, such as the `timeout` of [[tag-query]] / [[function-queryexecute]] (or `this.tag.cfquery.timeout`) and [[tag-http]]. See [[request-timeout]].

Sets the amount of time Lucee will wait for a request to finish before a request timeout will be raised.
