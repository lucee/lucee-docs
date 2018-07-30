```luceescript+trycf
writeDump(REReplaceNoCase("xxabcxxabcxx","ABC","def"));
writeDump(REReplaceNoCase("CABARET","C|B","G","ALL"));
writeDump(REReplaceNoCase("cabaret","[A-Z]","G","ALL"));
writeDump(REReplaceNoCase("I love jeLLies","jell(y|ies)","cookies"));
writeDump(REReplaceNoCase("I love Jelly","jell(y|ies)","cookies"));
```
