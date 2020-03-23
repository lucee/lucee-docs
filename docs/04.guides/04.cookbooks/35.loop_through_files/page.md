---
title: Looping Through File
id: loop_through_files
---
## Looping Through File ##

This document explains how to handle big files in Lucee in a better way. The classic way that you are familiar with uses cffile tag, fileRead, and fileReadBinary functions to read the file into memory. This is a simple solution, but it consumes a lot of memory.

Example:

Handle files with cffile tag, fileRead, and fileReadBinary functions

```luceescript
include "_getPath2BigFile.cfm";
NL="";
// read the complete file into memory
content=fileRead(path);
// no we split, again everything lands in memory as an array
arr=listToArray(content,NL);
// now we loop over every single line
loop array=arr index="i" item="line" {
	handle(line);
}
function handle(line) {}
dump(label:"String Size",var:len(content));
dump(label:"Array Size",var:len(arr));
```

In the example above,

* Read the file into the memory
* Split into array
* loop over the array

It consumes lot of memory.


### Use Loop - File ###

Use cfloop file, It allows you to read a file line by line, so you do not have to load an entire file into memory. You only load a line at a time into the memory.


```lucee
<cfloop file="...">
```


Example Using Loop

```luceesript
include "_getPath2BigFile.cfm";
// now we loop over every single line
loop file=path item="line" {
	handle(line);
}
function handle(line) {}
```

In the above example, loop through the file and get each line, so in memory there is only ever the one line. This not only faster, it also consumes less memory.


### Footnotes ###

Here you can see above details in video

[Looping through Files](https://www.youtube.com/watch?v=6w2Wr8snk50)
