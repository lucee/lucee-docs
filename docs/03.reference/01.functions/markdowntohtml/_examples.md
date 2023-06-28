```luceescript+trycf
nl= chr(10);
dNL= nl & nl;

markdownString="" & 
"## Heading1"  & dNL &
"###### Simple Paragraph"  & dNL &
"Some simple paragraph with a simple text"  & dNL &
"###### Ordered List"  & dNL &
"- First item" & nl &
"- Second item" & nl &
"- Third item" & dNL &
"###### Some Blockquotes"  & dNL &
"> This is some blockquoted text" & nl &
">> Blockquoted text with identation" & dNL;

echo( markdownToHtml( markdownString) );
```
