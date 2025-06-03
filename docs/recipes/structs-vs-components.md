Based on testing with 100,000 iterations:

### Execution Time Comparison
- **Struct creation**: 19ms
- **Bean factory creation**: 319ms
- **Inline<!--
{
  "title": "Best Practices: Structs vs Inline Components",
  "id": "structs-vs-components",
  "since": "5.0",
  "categories": ["performance", "best-practices", "components"],
  "description": "Performance analysis and best practices for choosing between structs and inline components in Lucee",
  "keywords": [
    "struct",
    "component",
    "inline component",
    "performance",
    "memory",
    "best practices",
    "CFC",
    "bean"
  ]
}
-->

# Best Practices: Structs vs Inline Components

This document provides guidance on when to use structs versus inline components in Lucee, based on performance analysis and practical considerations. Understanding the trade-offs between these approaches helps developers make informed decisions about data structures and object creation patterns.

**Note**: The performance characteristics and recommendations in this document apply equally to regular components (CFCs), sub-components, and inline components. All component types involve class creation and instantiation overhead compared to structs.

## Basic Examples

### Struct Approach
```javascript
// Simple data container
personData = {
    personId: 123,
    firstName: "Susi",
    lastName: "Sorglos",
    email: "susi.sorglos@lucee.org"
};

// Access data directly
fullName = personData.firstName & " " & personData.lastName;
```

### Inline Component Approach
```javascript
// Type-safe data container
personBean = new component accessors=true {
    property name="personId" type="numeric";
    property name="firstName" type="string";
    property name="lastName" type="string";
    property name="email" type="string";
    
    function getFullName() {
        return getFirstName() & " " & getLastName();
    }
};

personBean.setPersonId(123);
personBean.setFirstName("Susi");
personBean.setLastName("Sorglos");
```

### Bean Factory Approach
```javascript
// Custom bean structure with getters/setters
function createBean(boolean readOnly=false) {
    var bean = [:];
    var args = arguments;
    
    // Remove readOnly from arguments
    var readOnly = arguments.readOnly;
    structDelete(arguments, "readOnly");
    
    loop struct=arguments index="local.k" item="local.v" {
        // Create "private" value
        bean["_" & k] = v;
        
        // Getter - uses function name to determine property
        bean["get" & ucFirst(k)] = function() {
            var key = mid(getPageContext().getActiveUDFCalledName(), 4);
            return bean["_" & key];
        };
        
        // Setter (if not read-only) - uses function name to determine property
        if (!readOnly) {
            bean["set" & ucFirst(k)] = function(val) {
                var key = mid(getPageContext().getActiveUDFCalledName(), 4);
                bean["_" & key] = val;
            };
        }
    }
    return bean;
}

// Usage
personBean = createBean(
    readOnly: false,
    personId: 123,
    firstName: "Susi",
    lastName: "Sorglos",
    email: "susi.sorglos@lucee.org"
);

dump(personBean.getFirstName());
dump(personBean.getLastName());
```

## Common Use Cases

### High-Frequency Object Creation
```javascript
// Recommended: Structs for query loops and bulk processing
loop query=qryPersons {
    personRecord = {
        id: qryPersons.id,
        fullName: qryPersons.firstName & " " & qryPersons.lastName,
        email: qryPersons.email,
        status: "active"
    };
    processPerson(personRecord);
}

// Bean factory approach: Better performance than components, no metaspace overhead
loop query=qryPersons {
    personBean = createBean(
        readOnly: true,
        id: qryPersons.id,
        firstName: qryPersons.firstName,
        lastName: qryPersons.lastName,
        email: qryPersons.email
    );
    processPerson(personBean);
}

// Component approach: Slower and uses more memory
loop query=qryPersons {
    personRecord = new component accessors=true {
        property name="id" type="numeric";
        property name="firstName" type="string";
        property name="lastName" type="string";
        property name="email" type="string";
    };
    // Set values and process
}

// Avoid: Components in high-frequency scenarios
loop query=qryPersons {
    personRecord = new component accessors=true {
        property name="id" type="numeric";
        property name="fullName" type="string";
        property name="email" type="string";
        property name="status" type="string";
    };
}
```

### Configuration Objects
```javascript
// Appropriate: Components for configuration with validation
config = new component accessors=true {
    property name="host" type="string" required=true;
    property name="port" type="numeric" default=3306;
    property name="timeout" type="numeric" default=30000;
    
    function validate() {
        if (!len(trim(getHost()))) {
            throw("Host is required");
        }
        return true;
    }
};
```

### Simple Data Transfer
```javascript
// Recommended: Structs for API responses and data transfer
function getPersonData(personId) {
    return {
        personId: personId,
        firstName: getFirstName(personId),
        lastName: getLastName(personId),
        email: getEmail(personId),
        lastLogin: getLastLogin(personId)
    };
}
```

## Performance Testing

### Basic Benchmark
```javascript
function performanceTest() {
    iterations = 100000;
    
    // Query creation
    var qryPersons = queryNew("id,firstName,lastName,email");
    loop from=1 to=iterations index="local.idx" {
        var row = queryAddRow(qryPersons);
        querySetCell(qryPersons, "id", idx, row);
        querySetCell(qryPersons, "firstName", "Susi" & idx, row);
        querySetCell(qryPersons, "lastName", "Sorglos" & idx, row);
        querySetCell(qryPersons, "email", "Susi" & idx & "@lucee.org", row);
    }
    
    // Bean factory function
    function createBean(boolean readOnly=false) {
        var bean = [:];
        var args = arguments;
        var readOnly = arguments.readOnly;
        structDelete(arguments, "readOnly");
        
        loop struct=arguments index="local.k" item="local.v" {
            bean["_" & k] = v;
            bean["get" & ucFirst(k)] = function() {
                var key = mid(getPageContext().getActiveUDFCalledName(), 4);
                return bean["_" & key];
            };
            if (!readOnly) {
                bean["set" & ucFirst(k)] = function(val) {
                    var key = mid(getPageContext().getActiveUDFCalledName(), 4);
                    bean["_" & key] = val;
                };
            }
        }
        return bean;
    }
    
    // Test struct creation
    start = getTickCount();
    loop query=qryPersons {
        x = {
            id: qryPersons.id,
            firstName: qryPersons.firstName,
            lastName: qryPersons.lastName,
            email: qryPersons.email
        };
    }
    structTime = getTickCount() - start;
    
    // Test bean factory creation
    start = getTickCount();
    loop query=qryPersons {
        x = createBean(
            readOnly: false,
            id: qryPersons.id,
            firstName: qryPersons.firstName,
            lastName: qryPersons.lastName,
            email: qryPersons.email
        );
    }
    beanTime = getTickCount() - start;
    
    // Test component creation
    start = getTickCount();
    loop query=qryPersons {
        x = new component accessors=true {
            property name="id" type="numeric";
            property name="firstName" type="string";
            property name="lastName" type="string";
            property name="email" type="string";
        };
    }
    componentTime = getTickCount() - start;
    
    echo("Struct time: " & structTime & "ms<br>");
    echo("Bean factory time: " & beanTime & "ms<br>");
    echo("Component time: " & componentTime & "ms<br>");
    echo("Bean vs Struct ratio: " & (beanTime/structTime) & "x<br>");
    echo("Component vs Struct ratio: " & (componentTime/structTime) & "x<br>");
}
```

## Performance Analysis Results

Based on testing with 100,000 iterations (multiple runs):

### Execution Time Comparison
- **Struct creation**: ~20ms (19-23ms range)
- **Bean factory creation**: ~320ms (315-347ms range)  
- **Inline component creation**: ~335ms (328-336ms range)
- **Performance impact**: Bean factories are **~16x slower** than structs, components are **~17x slower** than structs

### Memory Usage Patterns
**Struct Approach:**
- Minimal memory overhead
- No class loading
- Lightweight objects
- Fast garbage collection

**Bean Factory Approach:**
- Moderate memory overhead (function closures only)
- No class loading required
- No metaspace allocation
- Slightly faster than components on average

**Inline Component Approach:**
- Creates physical class definitions
- Metaspace allocation for class metadata
- Component lifecycle overhead
- Highest memory consumption due to class creation

### Key Findings
1. **Performance**: Structs are dramatically faster (16-17x) than both bean factories and components
2. **Bean vs Component**: Bean factories are slightly faster than components and have less memory overhead
3. **Memory Efficiency**: Bean factories avoid class loading and metaspace allocation
4. **Closure vs Class Cost**: Function closures are less expensive than class creation overhead
5. **Universal Impact**: These performance characteristics apply to all component types in Lucee

## Recommendations

### Use Structs When:
- High-frequency object creation
- Performance is critical
- Simple data containers
- Temporary objects
- API responses
- Memory optimization needed

### Use Inline Components When:
- Type safety is important
- Complex validation required
- Long-lived objects
- Configuration management
- Code clarity is priority

**Note**: The same performance considerations apply when choosing between structs and regular components (CFCs) or sub-components. Use components of any type when the benefits of type safety, validation, and encapsulation outweigh the performance costs.

## Testing Guidelines

For accurate performance testing:
- Use fresh JVM instances when possible
- Run multiple iterations
- Consider garbage collection impact
- Test with realistic data sizes
- Monitor both time and memory usage

## Summary

Choose structs for performance-critical scenarios and simple data containers. Use inline components when type safety and validation are more important than raw performance. Consider hybrid approaches that combine the benefits of both.