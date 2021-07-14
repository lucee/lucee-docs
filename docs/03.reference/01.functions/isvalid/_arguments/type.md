The valid format for the data; one of the following:

* **any** - any simple value. Returns false for complex values, such as query objects; equivalent to the IsSimpleValue function.
* **array** - an array; equivalent to the IsArray function.
* **binary** - a binary value; equivalent to the IsBinary function.
* **boolean** - a boolean value; equivalent to the IsBoolean function.
* **component** - a component (CFC).
* **creditcard** - a 13-16 digit number conforming to the mod10 algorithm.
* **date or time** - any date-time value, including dates or times; equivalent to the IsDate function.
* **email** - a string containing a valid email address.
* **eurodate** - this functionality is only supported for compatibility reason, we do not suggest to use this functionality. Use instead function isDate or lsIsDate. A date in the form d/m/y, d-m-y, or d.m.y. The m and d format can be 1 or 2 digits; y can be 2 or 4 digits.
* **float or numeric** - a numeric value; equivalent to the IsNumeric function.
* **guid** - a Globally Unique Identifier in the format XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX where X is a hexadecimal number.
* **integer** - an integer.
* **query** - a query object; equivalent to the IsQuery function.
* **range** - a numeric range, specified by the min and max attributes.
* **regex or regular_expression** - matches input against pattern attribute.
* **ssn or social_security_number** - A U.S. social security number.
* **string** - a string value, including single characters and numbers
* **struct** - a structure; equivalent to the IsStruct function.
* **telephone** - a standard US telephone number.
* **URL** - an http, https, ftp, file, mailto, or news URL,
* **UUID** - a Universally Unique Identifier in the format XXXXXXXX-XXXX-XXXX-XXXXXXXXXXXXXXX, where X is a hexadecimal number. See CreateUUID.
* **USdate** - this functionality is only supported for compatibility reason, we do not suggest to use this functionality. Use instead function isDate or lsIsDate. A U.S. date of the format mm/dd/yy, with 1-2 digit days and months, 1-4 digit years.
* **variableName** - a string formatted according to ColdFusion variable naming conventions.
* **zipcode** - U.S., 5- or 9-digit format ZIP codes.
