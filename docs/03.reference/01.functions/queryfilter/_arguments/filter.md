filter can be a function/closure that implements the following constructor

[function(struct row[, number rowNumber, query query]):boolean].

for best performance, it really helps to use scoped variables, like arguments.row, instead of just row