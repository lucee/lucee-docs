
```luceescript+trycf
fruits = "apple,mango-papaya,lemon,grapes,mango-Apple,Mango-apple,mango";
res = fruits.replacelist("mango-papaya","Mango-Apple");
writeDump(res);
res = fruits.replacelist("apple","Mango@Apple");
writeDump(res);
res = fruits.replacelist("mango-papaya","Mango@Apple","@","-");
writeDump(res);
```