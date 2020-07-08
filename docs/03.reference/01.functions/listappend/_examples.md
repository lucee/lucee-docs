Example without delimiter argument:

```luceescript+trycf
mylist = "one,two,three";
mynewlist = listAppend(mylist, "four");
// Note that listAppend creates a new list. It doesn't update the existing list:
writeDump(mylist);
writeDump(mynewlist);
```

Expected result: `one,two,three,four`

Example with delimiter argument:

```luceescript+trycf
mylist = "foo";
mynewlist = listAppend(mylist, "bar", "|");
writeDump(mynewlist);
```

Expected result: `foo|bar`
