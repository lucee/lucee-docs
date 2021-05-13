```luceescript+trycf
list1 = ",a,b,c,d,e"
Dump(listSetAt(list1,"2", "Z"));
list2 = ",a||b||c||d||e"
Dump(listSetAt(list2,"2", "Z", "||"));
list3 = ",a,b,c,d,e"
Dump(listSetAt(list3,"2", "Z", ",",true)); //Because it includes empty field value ,Z,b,c,d,e
// MemberFunction

dump(list1.listSetAt("4", "Y")); //,a,b,c,Y,e
```
