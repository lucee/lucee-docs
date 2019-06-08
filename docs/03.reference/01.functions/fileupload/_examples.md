```lucee
<form name="myUpload" method="post" enctype="multipart/form-data"> 
    <input type="file" name="fileData">
    <input type="submit" name="submit"> 
</form> 
<cfscript> 
    if (structKeyExists(form, "fileData") and len(form.fileData) ){
        uploadfile = fileupload(getTempDirectory(),"form.fileData"," ","makeunique");
        writeDump(uploadfile);
    }
</cfscript>
```