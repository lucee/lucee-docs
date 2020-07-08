Index value. Lucee sets it to from value and increments or decrements by step value, until it equals to value.

When looping over a Struct/Collection:

- When the Item attribute is also defined, the variable assigned to the Index attribute will contain the value of the Struct's Key/Value pair (otherwise, it will always contain the Key value)
- When only the Index or Item attribute is defined, the variable will always contain the Key value.
