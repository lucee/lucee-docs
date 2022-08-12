---
title: File Upload Operation Result
id: file-upload-result
related:
- tag-file
- function-fileupload
- function-fileuploadall
categories:
- files
---

Return a struct with the information about the file uploaded operations as the result of [[tag-file|cffile action="upload"]]/[[function-fileupload]]/[[function-fileuploadall]].

### General information ###

Key | Description
-------------- | -----------------
attemptedServerFile | Name of the file that Lucee attempted to save
clientDirectory | Directory of the uploaded file in the client's system
clientFile | File name of the uploaded file in the client's system
clientFileExt | Extension of the uploaded file in the client's system
clientFileName | File name of the uploaded file without extension in the client's system
contentSubtype | MIME content subType of the file (i.e png is subType of the mimetype image/png)
contentType | MIME content type of the file (i.e image is type of the mimetype image/png)
dateLastAccessed | The date and time of the uploaded file accessed in the client's system
fileExisted | Boolean value to indicate file already exists in the destination or not
fileSize | Size of the uploaded file
fileWasAppended | Boolean value to indicate the saved file was appened or not
fileWasOverWritten |  Boolean value to indicate the saved file was overwritten or not
fileWasRenamed | Boolean value to indicate the saved file name was renamed or not
fileWasSaved | Boolean value to indicate the uploaded file was saved to destination location or not
oldFileSize | Size of the overwritten file
serverDirectory | The directory of the file saved
serverFile | The filename of the saved file
serverFileExt | The extension of the saved file
serverFileName |	The filename of the saved file without extension
timeCreated | The date and time of the saved file created
timeLastModified | The date and time of the last modification done in the saved file
