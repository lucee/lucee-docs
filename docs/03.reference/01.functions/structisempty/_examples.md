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