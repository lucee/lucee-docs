---
title: FileUploadAll
id: function-fileuploadall
related:
- tag-file
- function-fileupload
categories:
- files
---

Saves files from all the form fields in a request to a specified directory/resource.

Also supports processing multiple file uploads from a single form field, i.e. &lt;input type="file" name="file" multiple&gt;

it return the [[file-upload-result|status of the upload operation]] as array of struct after all files upload.
