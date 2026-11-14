**Deprecated** since Lucee 7.1.3 ([LDEV-6919](https://luceeserver.atlassian.net/browse/LDEV-6919)). It still works, but a request timeout can only interrupt the request thread, so it does not stop a blocking query, network call or native code. Set a timeout on the operation itself instead, such as the `timeout` of [[tag-query]] / [[function-queryexecute]] (or `this.tag.cfquery.timeout`) and [[tag-http]]. See [[request-timeout]].

Number of seconds. Time limit, after which CFML processes the page as an unresponsive thread.

Overrides the timeout set in the Lucee Administrator.

If one specifies a `requesttimeout` of `0`, the request will not time out.
