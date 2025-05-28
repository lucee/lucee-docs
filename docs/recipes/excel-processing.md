<!--
{
  "title": "Excel Processing in Lucee 7",
  "id": "excel-processing-lucee7",
  "categories": ["java", "maven", "data-processing"],
  "since": "7.0",
  "description": "Simple recipe for processing Excel files in Lucee 7 using Maven integration and Apache POI",
  "keywords": [
    "Excel",
    "Apache POI",
    "Maven",
    "XLSX",
    "XLS",
    "Spreadsheet"
  ]
}
-->

# Excel Processing in Lucee 7

Lucee 7's Maven integration makes it incredibly easy to work with Excel files using the powerful Apache POI library, which provides comprehensive reading and writing capabilities for both legacy (.xls) and modern (.xlsx) Excel formats.

## Maven Dependencies

Find the latest Apache POI version at [mvnrepository.com](https://mvnrepository.com/artifact/org.apache.poi/poi). Currently version 5.4.1 is available. For Excel processing, you need both `poi` and `poi-ooxml`:

```gradle
implementation("org.apache.poi:poi:5.4.1")
implementation("org.apache.poi:poi-ooxml:5.4.1")
```

## Simple Example

Create an Excel processor with this simple inline component:

```cfml
excelProcessor = new component javasettings='{"maven":["org.apache.poi:poi:5.4.1", "org.apache.poi:poi-ooxml:5.4.1"]}' {
    import org.apache.poi.xssf.usermodel.*;
    import org.apache.poi.ss.usermodel.*;
    import java.io.FileInputStream;
    
    function readExcel(filePath, maxrow=0) {
        try {
            var fileInputStream = new FileInputStream(expandPath(arguments.filePath));
            var workbook = new XSSFWorkbook(fileInputStream);
            var sheet = workbook.getSheetAt(0);
            
            // Get headers from first row
            var headerRow = sheet.getRow(0);
            var headers = [];
            for (var i = 0; i < headerRow.getLastCellNum(); i++) {
                headers.append(getCellValue(headerRow.getCell(i)));
            }
            
            // Create query with headers
            var data = queryNew(headers);
            
            // Process data rows
            for (var rowNum = 1; rowNum <= sheet.getLastRowNum(); rowNum++) {
                if (maxrow > 0 && data.recordcount == maxrow) break;
                var row = sheet.getRow(rowNum);
                if (!isNull(row)) {
                    var queryRow = queryAddRow(data);
                    for (var cellNum = 0; cellNum < headers.len(); cellNum++) {
                        var cell = row.getCell(cellNum);
                        var value = getCellValue(cell);
                        querySetCell(data, headers[cellNum + 1], value, queryRow);
                    }
                }
            }
            return data;
        }
        finally {
            fileInputStream.close();
            workbook.close();
        }
    }
    
    private function getCellValue(cell) {
        if (isNull(cell)) return "";
        
        switch(cell.getCellType()) {
            case CellType::STRING:
                return cell.getStringCellValue();
            case CellType::NUMERIC:
                if (DateUtil::isCellDateFormatted(cell)) {
                    return cell.getDateCellValue();
                } else {
                    return cell.getNumericCellValue();
                }
            case CellType::BOOLEAN:
                return cell.getBooleanCellValue();
            case CellType::FORMULA:
                return cell.getCellFormula();
            default:
                return "";
        }
    }
};

// Read Excel file (limit to first 10 rows for testing)
result = excelProcessor.readExcel("employees.xlsx", 10);
dump(result);

// Use like any CFML query
<cfoutput query="result">
    #name# - #department# - $#salary#<br>
</cfoutput>
```

This returns a proper CFML query object that you can use with all standard query functions and tags.

## Benefits Over Built-in SpreadSheet Functions

Apache POI provides several advantages:

- **Format Support** - Handles both .xls (Excel 97-2003) and .xlsx (Excel 2007+) formats
- **Advanced Features** - Access to formulas, cell formatting, styles, and charts
- **Large Files** - Better performance with large spreadsheets
- **Data Types** - Proper handling of dates, numbers, and formulas
- **Multiple Sheets** - Easy access to different worksheets
- **Cell-level Control** - Granular access to individual cells and their properties

Perfect for complex Excel processing that goes beyond basic spreadsheet operations!

## spreadsheet-cfml

There is also the very extensive [spreadsheet-cfml](https://github.com/cfsimplicity/spreadsheet-cfml) library available, which uses the same poi library and approaches, it is well maintained and has a comprehensive range of test cases.