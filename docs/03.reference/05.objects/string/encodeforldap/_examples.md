```luceescript+trycf
str = "I ** love * lucee";

encode1 = str.encodeForLDAP();
dump(encode1);

encode2 =  "I ** love * lucee".encodeForLDAP();
dump(encode2);
```