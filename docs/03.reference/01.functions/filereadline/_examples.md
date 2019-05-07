```luceescript
openFile = fileopen("filepath"),"read");
  //Filepath is an should specify a path of file.
readfromFile = filereadline(openFile);
filewrite("filepath",readfromFile);
  //Above filepath, should specify a path of write file.
```