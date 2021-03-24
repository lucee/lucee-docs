---
title: Operators
id: operators
related:
- function-max
- function-min
categories:
- core
- math
- thread
---

## Mathematical operators ##

operators | Name           | Description                                                |
------------------------   | -----------                                                |
**+**     | Add            |                                                            |
**-**     | subtract       | 															|
\*         | multiply       |                                                            |
/         | divide         | 															|
^         | exponentiate   | Raises one number to the power of another, e.g. 2 ^ 2 is 4 |
%         | modulus        | Returns the remainder of a number, e.g. 5 % 2 is 1         |
MOD       | modulus        | Returns the remainder of a number, e.g. 5 mod 2 is 1       |
\         | integer divide | Divides giving an integer result, e.g. 7 \ 2 is 3          |
++        | increment      | Increments a number. Can be used before or after an assignment, e.g. a = b++ would assign the value of b to a, then increment b. a = ++b would increment b, then assign the new value to a. In both cases, b would be incremented. **(not thread safe, see below)**|
**--**  | decrement      | Decrements a number. Can be used before or after an assignment, e.g. a = b-- would assign the value of b to a, then decrement b. a = --b would decrement b, then assign the new value to a. In both cases, b would be decremented. **(not thread safe, see below)**|
+=        | Compound add   | A shorthand operator for adding to a value, e.g.  a **+=** b is equivalent to writing a = a + b|
-=        | Compound subtract | A shorthand operator for subtracting from a value, e.g. a **-=** b is equivalent to writing a = a *-* b |
***=**       | Compound multiply | A shorthand operator for multiplying a value, e.g. a ***=** b is equivalent to writing a = a *  b  |
**/=**        | Compound divide   | A shorthand operator for dividing a value, e.g. a /= b is equivalent to writing a = a / b|

### Demonstration of unsafe threaded behavior with ++ and -- operators ###

```luceescript+trycf
   echo(server.lucee.version & "<br>");
    s = getTickCount();
    cycles = 2000;
	threads = 4;
	echo("cycles: " & cycles &" <br>");
	function test(){
        var array = [];
		for ( var x = 1; x lte cycles; x++ ) {
			array.append( x );
		}

		var ops = {
		    plusPlus: 0,
		    minusMinus: 0
		};
		array.each( ( el ) => {
			ops.plusPlus++;
			ops.minusMinus--;
		}, true, threads );

		dump( var=ops, label="values should always be 2000 or -2000, but these operators aren't thread safe");
	}

	function testSafe(){
        var array = [];
		for ( var x = 1; x lte cycles; x++ ) {
			array.append( x );
		}

		var ops = {
		    plusPlus: 0,
		    minusMinus: 0
		};
		array.each( ( el ) => {
		    lock name="loop" type="exclusive" {
		        ops.plusPlus++;
			    ops.minusMinus--;
			}
		}, true, threads );

		dump( var=ops, label="values will always be 2000 or -2000, due to locking");
	}

	cftimer(type="inline", label="not thread safe"){
        test();
    }
    cftimer(type="inline", label="thread safe"){
        testSafe();
    }
	//}
	echo ("<br>" & (getTickCount()-s) & "ms");
```

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

The "Elvis operator" in Lucee works like a [Null Coalescing operator](https://en.wikipedia.org/wiki/Null_coalescing_operator) in other languages. If the expression to the left of the operator refers to a variable that does not exist, or is null, then the expression on the right is then evaluated and is the result of the full expression. If the expression to the left of the operator refers to a variable that does exist, the right hand expression is never evaluated.

Some examples:

```luceescript+trycf
// the variable 'rockstar' does not exist, so
// "Elvis Presley" is the result of the expression
dump( var=rockstar ?: "Elvis Presley", label="rockstar ?: ""Elvis Presley""" );

// another example of variable does
// not exist - this time showing
// that the right hand side is evaluatd
i=1;
dump( var=( n ?: ++i ), label="n ?: ++i" );
dump( var=i, label="i (expect to be changed from 1 to 2)" );

// an example of the variable DOES
// exist - proving that the right
// hand side is NOT evaluatd
i=1;
n=2;
dump( var=( n ?: ++i ), label="n ?: ++i" );
dump( var=i, label="i (expect to be 1, still unchanged)" );

// the variable is declared but is null
// right hand is chosen
rockstar=NullValue();
dump( var=( rockstar ?: "Joni Mitchell" ), label="rockstar ?: ""Joni Mitchell""" );

// it can be used with complex variables
complexVar = [ { test=[ { test=2 } ] } ];
dump( var=( complexVar[ 2 ].test[ 1 ].test ?: "Default" ), label="complexVar[ 2 ].test[ 1 ].test ?: ""Default""" )
dump( var=( complexVar[ 1 ].test[ 1 ].test ?: "Default" ), label="complexVar[ 1 ].test[ 1 ].test ?: ""Default""" )

// Finally, this is not a shorthand of the
// ternary operator. The variable EXISTS
// its boolean value is not relevant to elvis
someVar=false;
dump( var=( someVar ?: true ), label="someVar ?: true" );
```

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
