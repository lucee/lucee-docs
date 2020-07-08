---
title: Threads
id: thread_usage
categories:
- thread
description: How to use threads in Lucee
---

## Thread Scope ##

This document explains how to use threads in Lucee. Threads are mainly used for executing code in parallel.

### Example 1 ###

The below example shows normal execution, waiting for all code to resolve. Here it takes 1000 milliseconds to complete the execution.

```lucee
<cfscript>
function napASecond() localmode=true {
	sleep(1000);
}
start=getTickCount();
napASecond();
dump("done in #getTickCount()-start#ms");
</cfscript>
```

The below example shows thread execution. Code within the thread tag runs in parallel with the execution of the other code in the cfscript. Here execution does not wait for sleep.

```lucee
<cfscript>
function napASecond() localmode=true {
	thread {
		sleep(1000);
	}
}
start=getTickCount();
napASecond();
dump("done in #getTickCount()-start#ms");
</cfscript>
```
Threads run independently of other threads or code in Lucee. Lucee does not the thread first and then the following code.

Threads are mainly used to retrieve data from the database, cfhttp, or webservice. Threads are used when it does not matter how much time it takes to execute.

### Example 2 ###

Here we see an example using multiple threads in Lucee. All threads run in parallel.

```lucee
<cfscript>
function napASecond(index) localmode=true {
	thread  {
		thread.start=now();
		sleep(1000)
		thread.end=now();
	}
}

start=getTickCount();
loop from=1 to=5 index="index" {
	napASecond(index);
}

// show threads
dump(var:cfthread,expand:false);
// wait for all threads to finish
thread action="join" name=cfthread.keyList();
// show threads
dump(var:cfthread,expand:false);

dump("done in #getTickCount()-start#ms");
</cfscript>
```

The above example shows five threads running in parallel. The thread action= "join" line waits for all threads to finish ```cfthread``` returns struct info of all thread status.

Same example within tag

```lucee
<cffunction name="napASecond">
	<cfargument name="index">
	<cfthread index="#index#" action="run" name="t#index#">
		<cfset thread.start=now()>
		<cfset sleep(1000+(index*10))>
		<cfset thread.end=now()>
	</cfthread>
</cffunction>

<cfset start=getTickCount()>

<cfloop from="1" to="5" index="index">
	<cfset napASecond(index)>
</cfloop>

<!-- show threads -->
<cfdump var="#cfthread#" expand="false">

<!-- wait for all threads to finish -->
<cfthread action="join" name="t1,t2,t3">

<!-- show threads -->
<cfdump var="#cfthread#" expand="false">

<cfdump var="done in #getTickCount()-start#ms">

```

Here the code joins three threads "t1,t2,t3". We can join threads by name.

### Example 3 ###

Example 3 shows threads running in parallel using the each function.

```lucee
<cfscript>
tasks = ["Susi","Sorglos"];
start=getTickCount();
tasks.each(
	function(value, index, array){
		systemOutput(value,true);
		sleep(1000);
	}
	,true
);
dump("done in #getTickCount()-start#ms");
</cfscript>
```

The ```each``` function has an optional attribute called parallel. When we set the parallel attribute as true, it runs each element in parallel. By default, this attribute is false.

Since the two array elements run in parallel, this code executes in 1 second.

```lucee
<cfscript>
tasks = [];
loop from=1 to=100 index="i" {
	arrayAppend(tasks,"t"&i)
}
start=getTickCount();
tasks.each(
	function(value, index, array){
		systemOutput(value,true);
		sleep(1000);
	}
	,true
	//,100
);
dump("done in #getTickCount()-start#ms");
</cfscript>
```

Here we have 100 array elements. Setting the optional attribute parallel as true, it executes in 5 seconds - not in 1 second - because by default, Lucee runs 20 threads at a time and after that, it waits for free threads. So, it takes 5 seconds to complete.

But we have the option to set the maximum threads open at a time. If it set to 100, Lucee can open 100 threads at a time to run in parallel. Then this code only takes 1 second to complete.

The ```each``` function is not only used for an array. It can also be used for struct and query. The below example explains each type.

```lucee
<cfscript>
// ARRAY
tasks = ["a","b"];
tasks.each(
	function(value, key, struct){
		systemOutput(arguments,true);
	}
	,true
);
arrayEach(
	tasks
	,function(value, key, struct){
		systemOutput(arguments,true);
	}
	,true
);
// STRUCT
tasks = {a:1,b:2};
structEach(
	tasks
	,function(value, key, struct){
		systemOutput(arguments,true);
	}
	,true
);
tasks.each(
	function(value, key, struct){
		systemOutput(arguments,true);
	}
	,true
);
// QUERY
persons = query(
	'firstName':['Susi','Harry']
	,'lastName':['Sorglos','Hirsch']
);
queryEach(
	persons
	,function(value, row, query){
		systemOutput(arguments,true);
	}
	,true
);
persons.each(
	function(value, row, query){
		systemOutput(arguments,true);
	}
	,true
);
dump("done");
</cfscript>
```

### Example 4 ###

Lucee members often discuss how to extend functionality to make Lucee easier to use or adding other new functionality.

This example shows a future implementation of threads in Lucee.

```lucee
<cfscript>
// Thread Pool
tasks.each(
	function(value, key, struct){
		systemOutput(arguments,true);
	}
	,true
	,20 // ATM default for max threads is 20, instead we plan to use a smart thread pool in the future (Java ExecutorService)
);
</cfscript>
```
Currently, the default max threads is 20. In the future, we plan to use a smart thread pool based on your JVM(Java ExecutorService). So you will not have to take care how many threads are being used. The system will do that, and provide the best choice for your code.

```lucee
<cfscript>
thread /* action="thread" name="whatever" */ {
	sleep();
}
</cfscript>
```

In the future we will make threads smarter by also using a pool for threads.

This feature is something we are planning. Changes will be implemented on the backend so that nothing changes on the front end.

```lucee
<cfscript>
// Extend parallel
loop from=1 to=10 index="i" parallel=true {
	...
}
// ???
for(i=0;i<10;i++;true) {
}
</cfscript>
```

Another planned enhancement is to extend parallel to the loop by simply adding ```parallel=true``` . It will execute the body of the loop in parallel.

### Footnotes ###

Here you can see above details in video

[Lucee Threads](https://www.youtube.com/watch?v=oGUZRrcg9KE)
