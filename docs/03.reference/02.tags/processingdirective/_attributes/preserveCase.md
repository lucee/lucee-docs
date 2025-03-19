Controls how variable keys defined using dot notation are handled:
	
	When preserveCase="false" (default): All struct keys defined with dot notation are converted to uppercase.
	Example: sct.dotNotation becomes key "DOTNOTATION" while sct["bracketNotation"] remains "bracketNotation"
	
	When preserveCase="true": Struct keys defined with dot notation maintain their original case.
	Example: sct.dotNotation remains key "dotNotation" and sct["bracketNotation"] remains "bracketNotation"
	
	This setting affects all dot notation usage throughout the template.