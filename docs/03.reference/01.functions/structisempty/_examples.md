### Member Function

```luceescript+trycf
// Non empty struct
animals = {
	cow: "moo",
	pig: "oink"
};

// Empty struct
farm = {};

// animals.isEmpty()
echo("<p>Animals struct is empty: " & animals.isEmpty() & "</p>");

// farm.isEmpty()
echo("<p>Farm struct is empty: " & farm.isEmpty() & "</p>");
```

### Non-Member Function

```luceescript+trycf
// Non empty struct
animals = {
	cow: "moo",
	pig: "oink"
};

// Empty struct
farm = {};

// StructIsEmpty(animals)
echo("<p>Animals struct is empty: " & StructIsEmpty(animals) & "</p>");

// StructIsEmpty(farm)
echo("<p>Farm struct is empty: " & StructIsEmpty(farm) & "</p>");
```
