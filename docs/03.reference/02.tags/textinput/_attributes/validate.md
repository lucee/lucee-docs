date: verifies format mm/dd/yy.

eurodate: verifies date format dd/mm/yyyy.

time: verifies time format hh:mm:ss.

float: verifies floating point format.

integer: verifies integer format.

telephone: verifies telephone format ###-###-####. The
separator can be a blank. Area code and exchange must
begin with digit 1 - 9.

zipcode: verifies, in U.S. formats only, 5- or 9-digit
format #####-####. The separator can be a blank.

creditcard: strips blanks and dashes; verifies number using
mod10 algorithm. Number must have 13-16 digits.

social_security_number: verifies format ###-##-####. The
separator can be a blank.

regular_expression: matches input against pattern
attribute.