Specifies whether to protect variables from cross-site scripting attacks. 

You may specify the string value also as a comma separated list to fine tune protection.

- **none:** disables cross-site scripting protection 
- **all (default):** applies cross-site scripting protection to cgi, url, form and cookie scope variables
- **cgi:** applies protection to cgi scope variables only
- **url:** applies protection to url scope variables only
- **form:** applies protection to form scope variables only
- **cookie:** applies protection to cookie scope variables only
