### Non-Member Function

```luceescript+trycf
animals = {
	cow: {noise: "moo",  size: "large"},
	pig: {noise: "oink", size: "medium"},
	cat: { noise: "meow", size: "small"}
};
dump(label: "All animals", var: animals);

animalInfo = StructReduce(animals, function(result, key, value) {
	return arguments.result & "<li>" & arguments.key & "<ul><li>Noise: " & arguments.value.noise & "</li><li>Size: " & arguments.value.size & "</li></ul></li>";
}, "<ul>") & "</ul>";

// Show result
echo(animalInfo);
```