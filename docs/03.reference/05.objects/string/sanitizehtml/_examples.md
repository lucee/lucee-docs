```luceescript+trycf
    html = '<!DOCTYPE html><html><body><h2>HTML Forms</h2><form action="/action_page.cfm"><label for="fname">First name:</label><br><input type="text" id="fname" name="fname"value="Pothys"><br><br><br><input type="submit" value="Submit">
    </form><p>If you click the "Submit" button, the form-data will be sent to a page called "/action_page.cfm".</p></body></html>';
    writeDump(var=html, label='html');
    test = html.sanitizeHTML();
    writeDump(var=test, label='string.SanitizeHtml');
```