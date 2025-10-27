```luceescript

excelApp = CreateObject("com", "Excel.Application"); // Created Excel Application COM object
workbook = excelApp.Workbooks.Add();
ReleaseComObject(workbook); //released excelApp to prevent memory leak

```