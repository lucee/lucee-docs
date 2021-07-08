###Struct map

```luceescript+trycf

original = {
    "one": {
        1: "tahi"
    },
    "two": {
        2: "rua"
    },
    "three": {
        3: "toru"
    },
    "four": { 
        4: "wha"
    }
};
function mapOriginal(k,v) {
    return v[ListFirst(v.keyList())];
}
fixed = structMap(original,mapOriginal);
writeDump([original, fixed]);
```