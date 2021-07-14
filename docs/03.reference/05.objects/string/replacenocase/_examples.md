
```luceescript+trycf
str = "Lucee";
res = str.replacenocase("U","U","all");
writeDump(res);
res = str.replacenocase("l","Love L","all");
writeDump(res);
res = str.replacenocase("L","","all");
writeDump(res);
res = str.replacenocase("lUCEE","I Love Lucee","all");
writeDump(res);
```