```luceescript+trycf
st = {
	1 : { active: true},
	2 : { active: false},
	3 : { active: false}
};

result = st.some(function(key,value){
	dump(var=value, label=key);
	return value.active;
});
dump (result);
```
