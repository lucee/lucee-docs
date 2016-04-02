---
title: Lambda Expressions
id: lucee-5-lambda
---

# Lambda Expressions

**Lucee 5 supports lambda expressions which are shorthand for defining anonymous functions.**

Lambda expressions reduce much of the syntax around creating anonymous functions. In its simplest form, you can eliminate the `function` keyword, curly braces and `return` statement. Lambda expressions implicitly return the results of the expression body.

A simple lambda expression with no arguments:

```luceescript
// Using a traditional function
makeSix = function() { return 5 + 1; }

// Using a lambda expression
makeSix = () => 5 + 1;

// returns 6
dump(makeSix());
```

A simple lambda expression with multiple arguments:

```luceescript
// Takes two numeric values and adds them
add = (numeric x, numeric y) => x + y;

// returns 4
dump(add(1, 3));
```

A complex lambda expression with an argument:

```luceescript
// Takes a numeric value and returns a string
isOdd = (numeric n) => {
  if ( n % 2 == 0 ) {
    return 'even';
  } else {
    return 'odd';
  }
};

// returns 'odd'
dump(isOdd(1));

// returns 'even'
dump(isOdd(10));
```
