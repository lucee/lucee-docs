valid values are:
- header: specifies an HTTP header.
- CGI: specifies an HTTP header. encodes the value depending on the attribute "encoded
- body: specifies the body of the HTTP request.
- XML: identifies the request as having a content-type of text/xml. Specifies that the value attribute contains the body of the HTTP request. Used to send XML to the destination URL.
- file: tells Lucee to send the contents of the specified file.
- URL: specifies a URL query string name-value pair to append to the cfhttp url attribute.
- form,formField: specifies a form field to send.
- cookie: specifies a cookie to send as an HTTP header.