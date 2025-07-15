Controls how response content is handled:

- **false** (default): Auto-detect content type - convert to CFML object if not recognized as text
- **auto**: Convert unrecognized content to binary data  
- **true**: Always return content as binary data, even for text responses

Affects the `filecontent` key in the result struct.