declare how variable keys defined by dot notation are handled.
If set to false converts all struct keys defined with "dot notation" to upper case.
Example:

- sct.dotNotation --> keyname: "DOTNOTATION"
- sct["bracketNotation"] --> keyname: "bracketNotation"

If set to true keep all struct keys defined with "dot notation" in original case (according to the "bracket notation").
Example:
sct.dotNotation --> keyname: "dotNotation"
sct["bracketNotation"] --> keyname: "bracketNotation"