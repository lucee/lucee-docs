```luceescript+trycf
dump(var=CallStackGet(type="json"), label="json ");
dump(var=CallStackGet(type="json", offset=2), label="json with offset");
dump(var=CallStackGet(type="json", maxframes=2), label="json with maxFrames");

dump(var=CallStackGet("string"), label="string");
dump(var=CallStackGet("array"), label="array");
dump(var=CallStackGet("html"), label="html");
```
