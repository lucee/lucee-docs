```luceescript+trycf
writeDump(Randomize(8,'SHA1PRNG'));
writeDump(Randomize(10) GTE 0 and Randomize(10) LTE 1);
randomize(55);
loop index="i" from="1" to="3"{
	writeDump(rand());
}
```
