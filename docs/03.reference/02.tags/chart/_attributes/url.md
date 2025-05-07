URL to open if the user clicks item in a data series; the onClick destination page. 

The following variables will be substituted [ $SERIESLABEL$, $ITEMLABEL$, $VALUE$ ] 

If the url does not contain a `?` the following is appended 

`?series=$SERIESLABEL$&category=$ITEMLABEL$&value=$VALUE$`

Otherwise, you will need to specify the query string manually

If the url starts with `javascript:` only variable substitution is done (since 1.20.1)