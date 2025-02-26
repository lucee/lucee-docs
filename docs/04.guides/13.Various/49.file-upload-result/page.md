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

Return a struct with the information about the file upload operations as the result of [[tag-file|cffile action="upload"]], [[function-fileupload]], or [[function-fileuploadall]].

### General Information

| Key                  | Description |
|----------------------|-------------|
| attemptedServerFile  | Name of the file that Lucee attempted to save |
| clientDirectory      | Directory of the uploaded file in the client's system |
| clientFile          | File name of the uploaded file in the client's system |
| clientFileExt       | Extension of the uploaded file in the client's system |
| clientFileName      | File name of the uploaded file without extension in the client's system |
| contentSubtype      | MIME content subtype of the file (e.g., `png` is the subtype of the MIME type `image/png`) |
| contentType         | MIME content type of the file (e.g., `image` is the type of the MIME type `image/png`) |
| dateLastAccessed    | The date and time when the uploaded file was last accessed on the client's system |
| fileExisted         | Boolean value indicating whether the file already existed in the destination |
| fileSize            | Size of the uploaded file (in bytes) |
| fileWasAppended     | Boolean value indicating whether the saved file was appended |
| fileWasOverWritten  | Boolean value indicating whether the saved file was overwritten |
| fileWasRenamed      | Boolean value indicating whether the saved file was renamed |
| fileWasSaved        | Boolean value indicating whether the uploaded file was saved to the destination location |
| oldFileSize         | Size of the overwritten file (if applicable) |
| serverDirectory     | The directory where the file was saved on the server |
| serverFile          | The filename of the saved file |
| serverFileExt       | The extension of the saved file |
| serverFileName      | The filename of the saved file without extension |
| timeCreated         | The date and time when the saved file was created |
| timeLastModified    | The date and time of the last modification of the saved file |
