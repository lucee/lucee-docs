- debug: displays timing information in a table in the debug output under the heading "CFTimer Times". There is a column for Label, Time (in ms), and Template. The default label is an empty string.
- comment: displays timing information as an inline HTML comment following the closing `</cftimer>`. Uses the format `<!-- [label]: [elapsed time in ms] -->`. The default label is an empty string.
- inline: displays timing information as inline HTML following the closing `</cftimer>`. Uses the format `[label]: [elapsed time in ms]`. The default label is an empty string.
- outline: wraps the `<cftimer>` block with a `<fieldset>` element, then displays timing information as a `<legend>` element rendered just before the closing `</fieldset>`. Uses the format `<legend align="top">[label]: [elapsed time in ms]</legend>`. The `<fieldset>` element is given a class of `cftimer`. The default label is an empty string.

Default: debug
