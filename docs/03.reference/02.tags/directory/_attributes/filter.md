Optional for action = "list". Ignored by all other actions.

Can be either:

- a wildcard filter,e.g. "m*"
- or a UDF/Closure which accepts the file/directory name and returns a Boolean value to indicate
whether that item should be included in the result or not.
