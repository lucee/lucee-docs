### Simple examples for cfpdf

```lucee
<cfpdf action="extractText" 
    source="path/to/source.pdf"
    name="local.extractedText" />

<cfpdf action="extractBookmarks" 
    source="path/to/source.pdf" 
    name="local.bookmarks" />

<cfpdf action="addWaterMark"
    source="path/to/source.pdf"
    image="path/to/image.jpg"
    pages="1"
    name="local.watermarkedPDF"
    overwrite="true"
    position="0,0" 
    rotation="45" />

<cfpdf action="extractImage"
    source="path/to/withImages.pdf" 
    pages="*"
    overwrite="true" 
    format="png" 
    imageprefix="image" 
    password=""
    destination="path/to/destinationFolder" />

<cfpdf action="extractImages/extractImage"
    source="path/to/withImages.pdf" 
    pages="*"
    overwrite="true" 
    format="png" 
    imageprefix="image" 
    password=""
    destination="path/to/destinationFolder" />

<cfpdf action="addHeader" 
    source="path/to/source.pdf" 
    text="Lucee" 
    name="local.pdfObj" />

<cfpdf action="addFooter" 
    source="path/to/source.pdf" 
    destination="path/to/dest.pdf" 
    text="Lucee" 
    overwrite="true" />

<cfpdf action="merge" 
    source="path/to/source1.pdf,path/to/source2.pdf"
    destination="path/to/merged.pdf" 
    overwrite="true" />

<cfpdf action="read"
    source="path/to/source.pdf"
    name="local.res" />

<cfpdf action="setInfo" 
    source="path/to/source.pdf" 
    info="#{'author':'lucee'}#" />

<cfpdf action="getInfo" 
    source="path/to/source.pdf" 
    name="local.pdfInfo" />

<cfpdf action="protect" 
    source="path/to/source.pdf"
    newUserPassword="password" />

<cfpdf action="removePassword" 
    source="path/to/source.pdf"
    destination="path/to/destination.pdf"
    password="Password"
    overwrite="true" />

<cfpdf action="thumbnail" 
    source="path/to/source.pdf" 
    overwrite="true" 
    destination="path/to/dest.pdf" />
```
