---
title: Operators
id: operators
related:
- function-max
- function-min
---

## Mathematical operators ##

operators | Name           | Description                                                |
------------------------   | -----------                                                |
**+**     | Add            |                                                            |
**-**     | subtract       | 															|
*         | multiply       |                                                            |
/         | divide         | 															|
^         | exponentiate   | Raises one number to the power of another, e.g. 2 ^ 2 is 4 |
%         | modulus        | Returns the remainder of a number, e.g. 5 % 2 is 1         |
MOD       | modulus        | Returns the remainder of a number, e.g. 5 mod 2 is 1       |
\         | integer divide | Divides giving an integer result, e.g. 7 \ 2 is 3          |
++        | increment      | Increments a number. Can be used before or after an assignment, e.g. a = b++ would assign the value of b to a, then increment b. a = ++b would increment b, then assign the new value to a. In both cases, b would be incremented.|
**--**  | decrement      | Decrements a number. Can be used before or after an assignment, e.g. a = b-- would assign the value of b to a, then decrement b. a = --b would decrement b, then assign the new value to a. In both cases, b would be decremented.|
+=        | Compound add   | A shorthand operator for adding to a value, e.g.  a **+=** b is equivalent to writing a = a + b|
-=        | Compound subtract | A shorthand operator for subtracting from a value, e.g. a **-=** b is equivalent to writing a = a *-* b | 
***=**       | Compound multiply | A shorthand operator for multiplying a value, e.g. a ***=** b is equivalent to writing a = a *  b  |
**/=**        | Compound divide   | A shorthand operator for dividing a value, e.g. a /= b is equivalent to writing a = a / b|


## Logical operators ##
operators | Name           | Description |
------------------------   | ----------- 
!           |  logical inversion      |     ! true is false   |
NOT         |  logical inversion      |     not true is false |
AND         |  logical and            |  Returns true if both operands are true, e.g. 1 eq 1 and 2 eq 2 is true|
&&         |  logical and            |  Returns true if both operands are true, e.g. 1 eq 1 && 2 eq 2 is true|
OR          |  logical or             | Returns true if either or both operands are true, e.g. 1 eq 1 or 2 eq 3 is true|
**||**          |  logical or             | Returns true if either or both operand are true, e.g. 1 == 1 **||** 2 == 3 is true |
XOR         |  logical exclusive or   | Returns true if either operand is true, but not both, e.g. 1 == 1 XOR 2 == 3 is true, but 1 == 1 XOR 2 == 2 is false |


## Comparison operators ##

operators | Name           | Description |
------------------------   | ----------- 
EQ        | equals         | Returns true if operands are equal, e.g. "A" EQ "A" is true |
==        | equals         | Returns true if operands are equal, e.g. "A" == "A" is true |
===       | identical      | Returns true if operands are the same object in memory, false if they are not, (Note this is different than how JavaScript's === operator works. |
NEQ       | does not equal | Returns true if operands are not equal, e.g. "A" NEQ "B" is true|
<>        | does not equal | Returns true if operands are not equal, e.g. "A" <> "B" is true |
!=        | does not equal | Returns true if operands are not equal, e.g. "A" != "B" is true |
!==       | is not identical | Returns true if operands are not equal or not of the same type, e.g. 1 !== "1" is true, but 1 !== 1 is false|
GT        |  greater than  | Returns true if the operand on the left is has a higher value than the operand on the right, e.g. 1 GT 2 is false |
>         | greater than    |Returns true if the operand on the left is has a higher value than the operand on the right, e.g. 1 > 2 is false |
LT        |  less than     | Returns true if the operand on the left has a lower value than the operand on the right, e.g. 1 LT 2 is true |
<         | less than      | Returns true if the operand on the left has a lower value than the operand on the right, e.g. 1 < 2 is true|
GTE       | greater than or equal to  | Returns true if the operand on the left has a value higher than or equal to the operand on the right, e.g. 2 GTE 2 is true |
>=       | greater than or equal to  | Returns true if the operand on the left has a value higher than or equal to the operand on the right, e.g. 2 >= 2 is true |
LTE      |  less than or equal to   | Returns true if the operand on the left has a value lower than or equal to the operand on the right, e.g. 2 LTE 2 is true|
<=       | less than or equal to | Returns true if the operand on the left has a value lower than or equal to the operand on the right, e.g. 2 <= 2 is true |
CONTAINS | contains        | Returns true if the left operand contains the right operand, e.g. "SMILES" CONTAINS "MILE" is true |
CT       | contains        | Returns true if the left operand contains the right operand, e.g. "SMILES" CT "MILE" is true |
DOES NOT CONTAIN | does not contain | Returns true if the left operand does not contain the right operand, e.g. "SMILES" DOES NOT CONTAIN "RHUBARB" is true |
NCT | does not contain | Returns true if the left operand does not contain the right operand, e.g. "SMILES" NCT "RHUBARB" is true |


## String operators ##


operators | Name           | Description |
------------------------   | ----------- 
&         | concatenation  | Joins two strings, e.g. The result of "Hello" & "World" is "HelloWorld"|
&=        | compound concatenation |  A shorthand operator that joins two strings, e.g. a &= b would be equivalent to writing a = a & b

## Ternary operator ##

The ternary operator lets you return results conditionally, in a very compact amount of code: 

```lucee
condition ? value1 : value2
```

This would return value1 if condition is true, otherwise it would return false. It's comparable to the following logical structure:

```lucee
<cfif condition>
    #value1#
<cfelse>
    #value2#
</cfif>
```
or the function:

```lucee
iif(condition, "value1", "value2")
```

For example:

animal = "cat";
writeOutput(animal == "cat"? "Meow" : "Woof");

would output "Meow".

## Elvis operator ##

The "Elvis operator" is a shortening of the ternary operator. One instance of where this is handy is for returning a 'sensible default' value if an variable does not exist. A simple example might look like this:

```lucee
 writeOutput(rockstar?: "Elvis Presley");
```
Outputs the value of "rockstar" if the variable exists, otherwise it outputs "Elvis Presley"

## Operators not available in tags ##

You can use <> > < >= and <= in tags, as long as they don't interfere with the tag syntax. In that case you must use the equivalent GT, LT, etc. operators instead.

## Casting ##

Note that in Lucee values are cast to an appropriate type automatically, except when using the identical operators === and !==

For example:

```lucee
 <cfset a = "2">
 <cfset b = a ^ 2>
```
returns 4. It casts the string to a number as it needs to.
