```luceescript+trycf

numbers = "1,3,5,7";
reducedVal = listReduce(numbers, function(previousValue, value)
{
return previousValue + value;
},0);
writeOutput("The sum of the digits #numbers# is #reducedVal#");

```