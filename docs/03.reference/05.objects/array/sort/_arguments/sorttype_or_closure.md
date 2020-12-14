value can be a string or a closure/function.

a string must be one of the following values:

- "numeric": sorts numbers
- "text": sorts text alphabetically, taking case into account (case sensitive)
- "textnocase": sorts text alphabetically, without regard to case (case insensitive)

if you define a closure/function, the closure/function must accept 2 parameters of any type and return:

- -1, if first parameter is "smaller" than second parameter
- 0, if first parameter is equal to second parameter
- 1, first parameter is "bigger" than second parameter

`function (any e1, any e2) { return -1/0/1;});`