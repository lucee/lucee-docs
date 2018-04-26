```luceescript+trycf
test_file = fileOpen("test.txt", "append");
fileWriteLine(test_file, "The Lucee project is led by the Lucee Association Switzerland a non-profit swiss association. A growing project which is committed to the success of its community by delivering quality software and a nurturing and supportive environment for developers to get involved.");
fileWriteLine(test_file, "");
fileWriteLine(test_file, "The members of the Lucee Association Switzerland are responsible for steering the direction of the association. We are proud to have members from around the world that guide the association with their in-depth skills across the board. Being a member however is not an one-way street and there are many ways you can benefit from being a member.");
fileWriteLine(test_file, "");
fileClose(test_file);

// compress the original file
Compress("gzip","test.txt","compressed_test.txt");

dump(GetFileInfo("test.txt").size);
dump(GetFileInfo("compressed_test.txt").size);

// remove the files to keep clutter down
filedelete("test.txt");
filedelete("compressed_test.txt");
```
