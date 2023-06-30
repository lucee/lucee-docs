### File Upload

```lucee
<cffile action="upload" destination="destination-directory" fileField="form.fileData" nameconflict="overwrite">
```

### File Write

```lucee
<cffile action="write" file="#expandPath("./myFile.txt")#" output="Content that you need to write.">
```

### File Read

```lucee
<cffile action="read" file="#expandpath("./myfile.pdf")#" variable="myfile">
```

### File Rename

```lucee
<cffile action="rename" source="#expandPath("./myFile.pdf")#" destination="#expandPath("./myNewFileName.pdf")#" attributes="normal">
```

### File Info

```lucee
<cffile action="info" file="#expandPath("./myFile.txt")#" variable="fileInfo">
```

### File Move

```lucee
<cffile action="move" source="#expandpath("./myfile.pdf")#" destination="#expandpath("./some/moveditems/")#">
```

### File Copy

```lucee
<cffile action="copy" source="#expandpath("./myfile.pdf")#" destination="#expandpath("./some/copypath/")#">
```

### File Delete

```lucee
<cffile action="delete" file="#expandpath("./some/moveditems/")#">
```

### File ReadBinary

```lucee
<cffile action="readBinary" file="#expandPath("./myFile.txt")#" variable="fileData">
```

### File Append

```lucee
<cffile action="append" file="#expandPath("./myFile.txt")#" output="Content to append">
```

### File Touch

```lucee
<cffile action="touch" file="#expandPath("./myFile.txt")#" createpath=true>
```

### Script Examples

### File Info

```luceescript
result = fileInfo(getTempFile(getTempDirectory(),"demo"));
```

### File Upload

```luceescript
result = fileupload(getTempDirectory(),"form.fileData"," ","makeunique");
```

### File Write

```luceescript
filewrite(file="#expandPath("./myFile.txt")#" data="Content that you need to write.");
```

### File Read

```luceescript
result = fileread(file="#expandPath("./myFile.txt")#");
```

### File ReadBinary

```luceescript
binaryContent = fileReadBinary(expandPath('./image.jpg'));
```

### File Append

```luceescript
fileAppend("path/to/file", "new content to append")
```

### File Rename

```luceescript
filemove(source="#expandPath("./myFile.txt")#",destination="#expandPath("./myNewFileName.txt")#");
```

### File Move

```luceescript
filemove(source="#expandPath("./myFile.txt")#",destination="#expandPath("./myNewFileName.txt")#");
```

### File Copy

```luceescript
filecopy(source="#expandPath("./myNewFileName.txt")#",destination="#expandPath("./some/moved/")#");
```

### File Delete

```luceescript
filedelete(source="#expandPath("./myFile.txt")#");
```

### File Touch

```luceescript
fileTouch( file="#expandPath("./myFile.txt")#",createPath=true );
```
