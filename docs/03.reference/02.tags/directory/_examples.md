### Simple format for cfdirectory

### Directory Create

```lucee
<cfdirectory action="create" directory="path of directory">
```

### Directory List

```lucee
<cfdirectory action = "list" directory = "pathOfDirectory" name = "list">
```

### Directory Copy

```lucee
<cfdirectory action = "copy" directory = "/pathOfDirectory" destination = "/pathOfDirector" nameconflict = "Overwrite" recurse = "true">
```

### Directory Rename

```lucee
<cfdirectory action = "rename" directory = "pathOfDirectory" newDirectory = "renameOfDirectory">
```

### Directory Delete

```lucee
<cfdirectory action = "Delete" directory = "pathOfDirectory" >
```

### Directory Forcedelete

```lucee
<cfdirectory action = "forcedelete" directory = "pathOfDirectory" >
```
