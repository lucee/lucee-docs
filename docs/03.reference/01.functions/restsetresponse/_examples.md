```luceescript
RestSetResponse(
    {
        "status":"200",
        "content":"[]",
        "headers":{"Content-Type": "application/javascript"}
    }
);

RestSetResponse(
    {
        "status":"201",
        "headers":{
          "Location": "/rest/api/thisResource/001",
          "Content-Location": "/rest/api/thisResource/001"
        }
    }
);

RestSetResponse(
    {
        "status":"404",
        "content":"This resource does not exist"
);
```
