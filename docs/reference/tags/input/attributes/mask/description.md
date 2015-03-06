A mask pattern that controls the character pattern that
            users can enter, or that the form sends to Lucee.
            In HTML and Flash for type=text use:
             - A = [A-Za-z]
             - X = [A-Za-z0-9]
             - 9 = [0-9]
             - ? = Any character
             - all other = the literal character
            In Flash for type=datefield use:
             - D = day; can use 0-2 mask characters.
             - M = month; can use 0-4 mask characters.
             - Y = year; can use 0, 2, or 4 characters.
             - E = day in week; can use 0-4 characters.