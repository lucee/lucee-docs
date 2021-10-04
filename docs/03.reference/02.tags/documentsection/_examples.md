### Simple Examples

```lucee
<cfdocument format="pdf">
    <cfdocumentsection>
        <cfdocumentitem type="header">
            <h2><i>Example section-1 Header</i></h2>
        </cfdocumentitem>
        <h1>Welcome to Lucee</h1>
        <p>Example for <b>CfdocumentSection</b></p>
        <h2><i>Example section-1 body</i></h2>
        <cfdocumentitem type="footer">
            <h2><i>Example section-1 footer</i></h2>
        </cfdocumentitem>
    </cfdocumentsection>
    <cfdocumentsection>
        <cfdocumentitem type="header">
            <h2><i>Example section-2 Header</i></h2>
        </cfdocumentitem>
        <h2><i>Example section-2 body</i></h2>
        <cfdocumentitem type="footer">
            <h2><i>Example section-2 footer</i></h2>
        </cfdocumentitem>
    </cfdocumentsection>
</cfdocument>

```