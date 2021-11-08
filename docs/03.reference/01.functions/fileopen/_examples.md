```luceescript
myFile = fileOpen("filepath/filename.ext");
writeDump(myfile);
```

```luceescript
// how to access the underlying resource provider info
f = "ram://demo.txt";
fileWrite(f, "demo");
dump(f.getResource().getResourceProvider().getScheme()); // ram ( i.e. the resource provider type)
```