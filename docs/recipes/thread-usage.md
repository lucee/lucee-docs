<!--
{
  "title": "Complete Guide to Threading in Lucee",
  "id": "thread-usage",
  "categories": ["thread", "performance", "core"],
  "description": "Complete guide to using threads and parallel execution in Lucee",
  "keywords": [
    "threads",
    "parallel",
    "async",
    "concurrent",
    "performance",
    "cfthread"
  ],
  "related": [
    "tag-thread",
    "function-arrayeach",
    "function-arraymap",
    "function-arrayreduce"
  ]
}
-->

# Complete Guide to Threading in Lucee

This document explains all the ways to use threads and parallel execution in Lucee. Threads allow you to execute code in parallel, improving performance for tasks like database queries, HTTP requests, or any long-running operations.

## Threading Approaches Overview

Lucee offers several approaches to threading, from simple high-level functions to full manual control:

1. **Collection Parallel Processing** - Simplest approach using `.each()` with parallel flag
2. **Function Listeners** - Modern async syntax for function calls (Lucee 6.1+)
3. **Basic Thread Blocks** - Simple cfthread usage for fire-and-forget operations
4. **Advanced Thread Management** - Full control with thread joining, monitoring, and coordination

## Collection Parallel Processing

The simplest way to execute code in parallel is using the `.each()` function with the parallel flag. This automatically manages thread creation and cleanup.

### Parallel Array Processing

```javascript
// Process array items in parallel
items = ["item1", "item2", "item3", "item4", "item5"];
items.each(
    function(value, index) {
        // Simulate some work
        sleep(1000);
        systemOutput("Processed: #value# at #now()#", true);
    },
    true, // parallel execution
    3     // maxThreads: limit to 3 concurrent threads
);
dump("All items processed");
```

### Large Dataset with Thread Control

```javascript
// Process large dataset with controlled thread count
largeDataset = [];
loop from=1 to=100 index="i" {
    arrayAppend(largeDataset, "task_#i#");
}

largeDataset.each(
    function(task, index) {
        sleep(100);
        systemOutput("Completed: #task#", true);
    },
    true, // parallel execution
    10    // maxThreads: prevent system overload
);
dump("100 tasks completed with max 10 threads");
```

### Parallel Struct Processing

```javascript
// Process struct values in parallel with thread limit
userData = {
    "user1": "john@example.com",
    "user2": "jane@example.com", 
    "user3": "bob@example.com",
    "user4": "alice@example.com",
    "user5": "charlie@example.com"
};

userData.each(
    function(email, userId) {
        // Simulate sending email
        sleep(500);
        systemOutput("Email sent to #email# for user #userId#", true);
    },
    true, // parallel execution
    2     // maxThreads: process max 2 emails simultaneously
);
```

### Parallel Query Processing

```javascript
// Process query rows in parallel
users = query(
    'id': [1, 2, 3, 4, 5, 6, 7, 8],
    'name': ['John', 'Jane', 'Bob', 'Alice', 'Charlie', 'David', 'Eve', 'Frank'],
    'email': ['john@test.com', 'jane@test.com', 'bob@test.com', 'alice@test.com', 
              'charlie@test.com', 'david@test.com', 'eve@test.com', 'frank@test.com']
);

users.each(
    function(row, rowNumber) {
        // Process each user record
        sleep(200);
        systemOutput("Processed user: #row.name# (#row.email#)", true);
    },
    true, // parallel execution
    4     // maxThreads: process max 4 users concurrently
);
```

### Thread Limit Control

All collection functions (`.each()`, `.every()`, `.filter()`, `.map()`, `.some()`) support the `maxThreads` parameter to control resource usage:

```javascript
// Syntax: collection.function(function, parallel, maxThreads)
// Default maxThreads = 20 when parallel = true
tasks = [];
loop from=1 to=50 index="i" {
    arrayAppend(tasks, "heavy_task_#i#");
}

tasks.each(
    function(task) {
        // CPU/memory intensive operation
        sleep(randRange(100, 500));
        systemOutput("Completed: #task#", true);
    },
    true, // parallel = true
    5     // maxThreads = 5 (overrides default of 20)
);

// Without maxThreads limit, this would use default of 20 threads!
// With maxThreads=5, only 5 threads run at once, others queue
```

### Parallel Functions

Arrays, structs, and queries support parallel execution for iteration functions. Here we focus on `.each()` examples, but other functions are available:

**Available parallel functions:**

- **`.each()`** - Execute code for every element (side effects, logging, processing)
- **`.filter()`** - Create new collection with elements matching criteria
- **`.map()`** - Transform every element and create new collection
- **`.every()`** - Test if all elements meet a condition (returns boolean)
- **`.some()`** - Test if any element meets a condition (returns boolean)

```javascript
// Array processing with .each()
items = ["item1", "item2", "item3", "item4", "item5"];
items.each(
    function(value, index, array) {
        sleep(200); // Simulate work
        systemOutput("Processed: #value# at index #index#", true);
    },
    true, // parallel
    3     // maxThreads
);

// Struct processing with .each()
userData = {
    "john": "john@example.com",
    "jane": "jane@example.com", 
    "bob": "bob@example.com",
    "alice": "alice@example.com"
};

userData.each(
    function(key, value, struct) {
        sleep(300); // Simulate email sending
        systemOutput("Email sent to #value# for user #key#", true);
    },
    true, // parallel
    2     // maxThreads
);

// Query processing with .each()
employees = query(
    'id': [1, 2, 3, 4],
    'name': ['John', 'Jane', 'Bob', 'Alice'],
    'department': ['IT', 'HR', 'Finance', 'Marketing']
);

employees.each(
    function(row, rowNumber, query) {
        sleep(150); // Simulate processing
        systemOutput("Processed employee: #row.name# in #row.department#", true);
    },
    true, // parallel
    2     // maxThreads
);
```

**Parameters:**

- `parallel` (boolean) - Enable parallel execution
- `maxThreads` (number, optional) - Maximum concurrent threads (alias: `maxThreadCount`)
- When `parallel=false`, `maxThreads` is ignored

## Function Listeners (Lucee 6.1+)

Function Listeners provide a modern, promise-like syntax for asynchronous execution. They're perfect when you want to execute a function in parallel and handle the result.

> **Complete Function Listeners Guide:** For detailed examples and advanced usage, see the [Function Listeners documentation](https://github.com/lucee/lucee-docs/blob/master/docs/recipes/function-listeners.md).

### Simple Async Function Execution

```javascript
function fetchUserData(userId) {
    sleep(1000);
    return {"id": userId, "name": "User #userId#"};
}

// Execute function asynchronously with listener
fetchUserData(123):function(result, error) {
    request.userData = result;
};

dump("Function called asynchronously");
```

### Joining Function Listener Threads

```javascript
function processData(data) {
    sleep(1000);
    return data.len();
}

// Get thread name for joining
threadName = processData([1,2,3,4,5]):function(result, error) {
    thread.result = result;
};

// Do other work...
dump("Processing started");

// Wait for completion
threadJoin(threadName);
dump("Result: #cfthread[threadName].result#");
```

### Error Handling with Function Listeners

```javascript
function riskyOperation() {
    if (randRange(1,2) == 1) {
        throw "Random failure occurred!";
    }
    return "Success!";
}

riskyOperation():{
    onSuccess: function(result) {
        systemOutput("Operation succeeded: #result#", true);
    },
    onFail: function(error) {
        systemOutput("Operation failed: #error.message#", true);
    }
};
```

## Basic Thread Blocks

Use `thread` blocks for simple fire-and-forget operations or when you need more control than collection processing offers.

### Fire-and-Forget Operations

```javascript
function logActivity(action) {
    thread {
        // This runs in background - doesn't block main execution
        sleep(500); // Simulate slow logging operation
        systemOutput("Logged: #action# at #now()#", true);
    }
}

start = getTickCount();
logActivity("User login");
logActivity("Page view");
logActivity("Button click");
dump("Main execution completed in #getTickCount()-start#ms");
// Logging continues in background
```

### Background Data Processing

```javascript
function processInBackground(data) {
    thread {
        // Heavy processing that shouldn't block the user
        sleep(3000);
        thread.result = "Processed #data.len()# items";
        thread.completedAt = now();
    }
}

userData = ["item1", "item2", "item3"];
processInBackground(userData);
dump("Processing started in background");
```

## Advanced Thread Management

For maximum control over thread execution, use explicit thread management with joining, monitoring, and coordination.

### Multiple Coordinated Threads

```javascript
function fetchDataFromSource(sourceName, delay) {
    thread name="fetch_#sourceName#" {
        thread.startTime = now();
        sleep(delay);
        thread.data = "Data from #sourceName#";
        thread.endTime = now();
        thread.duration = dateDiff("s", thread.startTime, thread.endTime);
    }
}

start = getTickCount();

// Start multiple data fetching operations
fetchDataFromSource("database", 1000);
fetchDataFromSource("api", 1500);
fetchDataFromSource("cache", 500);
fetchDataFromSource("file", 800);

// Show all threads status before joining
dump(var: cfthread, label: "Threads Status Before Join");

// Wait for all threads to complete
thread action="join" name=cfthread.keyList();

// Show results
dump(var: cfthread, label: "All Threads Completed");
dump("Total execution time: #getTickCount()-start#ms");
```

### Thread Pool Management

```javascript
function processWorkItem(workId) {
    thread {
        thread.workId = workId;
        thread.startTime = now();
        
        // Simulate varying work complexity
        delay = randRange(500, 2000);
        sleep(delay);
        
        thread.result = "Work #workId# completed";
        thread.endTime = now();
    }
}

// Process multiple work items
workItems = [1,2,3,4,5,6,7,8,9,10];
start = getTickCount();

// Start all work items (Lucee manages thread pool automatically)
for (workId in workItems) {
    processWorkItem(workId);
}

// Monitor progress
activeThreads = cfthread.keyArray();
dump("Started #activeThreads.len()# threads");

// Wait for completion in batches
batchSize = 3;
completedCount = 0;

while (completedCount < workItems.len()) {
    sleep(100); // Check every 100ms
    
    for (threadName in activeThreads) {
        if (cfthread[threadName].status == "COMPLETED") {
            completedCount++;
            dump("Thread #threadName# completed: #cfthread[threadName].result#");
            activeThreads.deleteAt(activeThreads.find(threadName));
        }
    }
}

dump("All work completed in #getTickCount()-start#ms");
```

### Thread Communication and Shared Data

```javascript
// Shared data structure for thread communication
request.sharedCounter = 0;
request.results = [];

function workerThread(threadId) {
    thread name="worker_#threadId#" {
        loop from=1 to=5 index="i" {
            // Simulate work
            sleep(randRange(100, 300));
            
            // Update shared counter (be careful with race conditions in real apps)
            request.sharedCounter++;
            
            // Add result
            arrayAppend(request.results, "Thread #threadId# completed task #i#");
        }
        thread.completed = true;
    }
}

// Start worker threads
loop from=1 to=3 index="i" {
    workerThread(i);
}

// Monitor progress
while (request.sharedCounter < 15) { // 3 threads × 5 tasks each
    dump("Progress: #request.sharedCounter#/15 tasks completed");
    sleep(200);
}

// Wait for all threads to finish
thread action="join" name="worker_1,worker_2,worker_3";

dump("Final results:");
dump(request.results);
dump("All threads completed");
```

## Best Practices

### Choose the Right Approach

- **Use `.each()` with parallel flag** for simple collection processing
- **Use Function Listeners** for modern async function calls with optional result handling
- **Use basic thread blocks** for fire-and-forget background operations
- **Use advanced thread management** when you need precise control over execution

## Additional Resources

- **[Function Listeners Documentation](https://github.com/lucee/lucee-docs/blob/master/docs/recipes/function-listeners.md)** - Complete guide to async function execution
- **[Lucee Threads Video Tutorial](https://www.youtube.com/watch?v=oGUZRrcg9KE)** - Visual explanation of threading concepts
- **cfthread Tag Reference** - Complete tag syntax and parameters

## Summary

Lucee provides multiple approaches to parallel execution:

1. **Start simple** with `.each()` parallel processing for collections
2. **Use Function Listeners** for modern async function calls
3. **Use thread blocks** for fire-and-forget operations  
4. **Use advanced thread management** when you need full control

Choose the approach that best fits your use case, starting with the simplest option that meets your needs.