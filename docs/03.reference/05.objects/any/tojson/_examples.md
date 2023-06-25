```luceescript+trycf
	st = structNew();
	st.id = 1;
	st.Name = "Water";
	st.DESIGNATION = "Important source for all";
	st.data = [1,2,3,4,5];
	writeDump( st );

	jsonFormat = st.toJson();
	writeDump( jsonFormat );
```
