```luceescript+trycf
my_string = "backward compatibility to Lucee 4.0";
hashed_string = hash40(input = my_string, algorithm = "SHA-512", numIterations = 20);
dump(hashed_string); //550C0FB966EEDDEFD49743C5D1880239D221DC3811216515630EB6A6BAA4B0A2845C445EFDCB5B5563CDDDFE7EE13DF67AA9E8670A99EA997E306EF0F5630092
```
