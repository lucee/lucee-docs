- True: if the regular expression is found, the first array element contains the length and position, respectively, of the first match.
                If the regular expression contains parentheses that group subexpressions, each subsequent array element contains the length and position, respectively, of the first occurrence of each group.
                If the regular expression is not found, the arrays each contain one element with the value 0.
- False: the function returns the position in the string where the match begins. Default.