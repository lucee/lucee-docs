<!--
{
  "title": "Timeout",
  "id": "timeout",
  "description": "Learn how to use the <cftimeout> tag in Lucee. This guide demonstrates how to define a timeout specific to a code block, handle timeouts with a listener, and handle errors within the timeout block.",
  "keywords": [
    "tag",
    "timeout",
    "listener",
    "Lucee",
    "cftimeout",
    "error handling"
  ],
  "related": [
    "tag-timeout"
  ]
}
-->

# Timeout

Since Lucee 6.0, [[tag-timeout]] defines a timeout for a code block.

## Basic Usage

```lucee
<cftimeout timespan="#createTimespan(0, 0, 0, 0,100)#" forcestop=true ontimeout="#function(timespan) {
    dump(timespan);
}">
    <cfset sleep(1000)>
</cftimeout>
```

The `onTimeout` listener is called when timeout is reached.

## Error Handling

Add `onError` listener for exceptions within the timeout block. Rethrow to escalate:

```lucee
<cftimeout timespan="0.1"
    onerror="#function(cfcatch){
        dump(arguments);
        throw cfcatch;
    }#"
    ontimeout="#function(timespan) {
        dump(timespan);
    }#">
    <cfthrow message="upsi dupsi">
</cftimeout>
```
