
```lucee
<form name="myUpload" method="post" enctype="multipart/form-data">
    <input type="file" name="fileDataOne">
    <input type="file" name="fileDataTwo">
    <input type="file" name="fileDataThree">

    <input type="submit" name="submit">
</form>
<cfscript>
    if (structKeyExists(form, "submit")){
        uploadfile = fileuploadAll(getTempDirectory(),"","makeunique");
        writeDump(uploadfile);
    }
</cfscript>

```