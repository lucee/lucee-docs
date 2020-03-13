
```luceescript+trycf
list = "apple,mango-papaya,lemon,grapes,mango-Apple,Mango-apple,mango";
res = list.listremoveduplicates();
writeDump(res);
res = list.listremoveduplicates(",",true);
writeDump(res);
res = list.listremoveduplicates("-",true);
writeDump(res);
res = list.listremoveduplicates("-");
writeDump(res);
```