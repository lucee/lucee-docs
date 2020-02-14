
```luceescript+trycf
fruits = "apple,mango-papaya,lemon,grapes,mango-Apple,Mango-apple,mango";
writeDump(fruits);
res = fruits.listprepend("jerry");
writeDump(res);
res = fruits.listprepend("tomato");
writeDump(res);
res = fruits.listprepend("tomato","-");
writeDump(res);
```