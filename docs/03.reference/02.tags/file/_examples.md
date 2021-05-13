### Tag examples

### File Upload

```lucee
<cffile action="upload" filefield="FORM.fileFieldName" destination="#expandPath("./myNewFileName.pdf")#">

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

### Script Examples

### File Upload

```luceescript
fileupload(getTempDirectory(),"form.fileData"," ","makeunique");
```

### File Write

```luceescript
filewrite(file="#expandPath("./myFile.txt")#" data="Content that you need to write.");
```

### File Read

```luceescript
fileread(file="#expandPath("./myFile.txt")#");
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