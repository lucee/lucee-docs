```lucee
<cfheader name="Content-Type" value="application/json">
```

### Ignore a header set after the response was flushed

```lucee
<cfflush>
<!--- the response is already committed, the header is skipped and a warning is logged --->
<cfheader name="X-Request-Id" value="abc" throwOnError="false">
```
