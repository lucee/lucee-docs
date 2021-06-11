### FTP action open

```lucee
<cfftp action="open"  username="#FTPusername#"  password="#FTPpassword#"  server="#FTPserver#" port="#FTPPort#"  connection="#connection_nam #"/>

```

### FTP action close

```lucee
<cfftp action="close" connection="#connection_name#"/>

```

### FTP action listDir

```lucee
<cfftp action="listDir" connection="#connection_name#" name="test" directory="/"/>

```

### FTP action createDir

```lucee
<cfftp action="createDir" connection="#connection_name#"  directory="diretoryName"/>

```

### FTP action removeDir

```lucee
<cfftp action="removeDir" username="#FTPusername#" password="#FTPpassword#" server="#FTPserver#" port="#FTPPort#"  directory="diretoryName"/>

```

### FTP action existsFile

```lucee
    <cfftp action="existsFile" username="#FTPusername#" password="#FTPpassword#" server="#FTPserver#" port="#FTPPort#"  remotefile="FileName"/>

```

### FTP action putFile

```lucee
    <cfftp action="putFile" username="#FTPusername#" password="#FTPpassword#" server="#FTPserver#" port="#FTPPort#"  remotefile="FileName" localFile="FileName"/>

```

### FTP action existsDir

```lucee
    <cfftp action="existsDir" username="#FTPusername#" password="#FTPpassword#" server="#FTPserver#" port="#FTPPort#"  directory="direcotryName" />

```
