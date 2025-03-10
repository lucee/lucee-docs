### Function example

```luceescript+trycf
 writeDump(var=isflushed(),label="Before flush");
 writeOutput( "<div>foo</div>" ); 
 cfflush(); 
 sleep( 1000 ); 
 writeOutput( "<div>bar</div>" );
 writeDump(var=isflushed(),label="After flush");
```
