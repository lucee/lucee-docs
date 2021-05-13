
```luceescript+trycf
list = "apple,mango-papaya,lemon,,,,grapes,mango-Apple,Mango-apple,mango";
//This is the list value
writeDump(list);
//This is after converting into ListtoArray
writeDump(list.ListtoArray());
writeDump(list.ListtoArray("-",true));
writeDump(list.ListtoArray(",-",false,true));
```
