```luceescript+trycf
// First, let's create a simple UDF that returns a value
function getName() {
    return "John Doe";
}

// Create a reference to the getName function using ValueRef()
name = ValueRef(getName);

// Example 1: Basic Usage
writeOutput("Direct function call: " & getName() & "<br>");
writeOutput("Using ValueRef: " & name & "<br>");

// Example 2: Using ValueRef with a more complex UDF
function calculateTotal(price, quantity) {
    return price * quantity;
}

// Create a reference with preset values
fixedCalculation = ValueRef(function() {
    return calculateTotal(10, 5);
});

writeOutput("Fixed calculation result: " & fixedCalculation & "<br>");

// Example 3: Using ValueRef with a closure
counter = 0;
incrementCounter = ValueRef(function() {
    counter++;
    return counter;
});

writeOutput("Counter value: " & incrementCounter & "<br>");
writeOutput("Counter value: " & incrementCounter & "<br>");

// Example 4: Using ValueRef in a struct
person = {
    firstName: ValueRef(function() {
        return "Jane";
    }),
    lastName: ValueRef(function() {
        return "Smith";
    }),
    fullName: ValueRef(function() {
        // Note: This would need to be implemented differently in practice
        // as the ValueRef doesn't have access to the other references directly
        return "Jane Smith";
    })
};

writeOutput("Person's full name: " & person.fullName);
```
