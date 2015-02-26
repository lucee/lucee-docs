- inline: displays timing information inline, following the
              resulting HTML.
            - outline: displays timing information and also displays a line
              around the output produced by the timed code. The browser
              must support the FIELDSET tag to display the outline.
            - comment: displays timing information in an HTML comment
              in the format <!-- label: elapsed-time ms -->. The default label
              is cftimer.
            - debug: displays timing information in the debug output
              under the heading CFTimer Times.
            Default: debug