Specifies whether Lucene returns spelling suggestions for possibly misspelled words.
Results are returned in the `status` structure when the `status` attribute is specified.

- **always**: always return spelling suggestions
- **never**: never return spelling suggestions (default)
- *positive number*: return suggestions when the result count is below this threshold
