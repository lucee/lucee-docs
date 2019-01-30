```luceescript+trycf
writeDump(rereplace("xxabcxxabcxx","ABC","def"));
writeDump(REReplace("CABARET","C|B","G","ALL"));
writeDump(REReplace("CABARET","[A-Z]","G","ALL"));
writeDump(REReplace("I love jellies","jell(y|ies)","cookies"));
writeDump(REReplace("I love jelly","jell(y|ies)","cookies"));
writeDump(REReplace("hello john how are you:", "[[:space:]]+", "_", "ALL"));
```
