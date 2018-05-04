---
title: Threads
id: thread_usage
---
## Thread Scope ##

This document explains how to use the threads. Threads mainly used for execute the code parallel.

### Example 1 ###

This below example shows waiting normal execution waiting for all code to resolve. Here it waits for 1000 mili seconds after the it complete the execution.

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

This below example shows thread execution. Code with in the thread tag run parallel to execution. Here execution doesn't wait for sleep.

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
Threads were independent form current running thread on lucee. Lucee doesn't wait for end of thread.

Threads were mainly used to retrieve the data form DB, cfhttp, webservice it doesn't care about how much time it takes to execute.

### Example 2 ###

Here we can see about multiple threads in lucee. Lucee can also used to create multiple threads running parallel at that time.

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

Above example shows currently five threads were running parallel, Thread action join wait for all threads to finish.

```cfthread``` returns struct info of all thread status.


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

Here it join three threads "t1,t2,t3". We can join threads by its name.


### Example 3 ###

Here we can see about threads running parallel using ```each``` function.

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

```each``` function has a option parallel, when we set parallel attribute as true. It runs each element parallel. In default it should be false.

So that two array elements runs parallel done in 1second.


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

Here we have 100 array elements, setting option parallel as true it execute for 5 seconds not at 1 second because in default lucee runs 20 threads at the time after that it wait for free threads so only it take 5 seconds to complete.

But we have option to set maximum threads open at that time. If it set to 100, it can open 100 threads at that time run parallel it take 1 second to complete.


```each``` function is used not only for array, it used for struct & query also. Below example explain all the types.


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

We are discussing for a long time how to extend functionality to make it easier to use or other new functionality.

Here we explained about the future implementation of thread in lucee


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
ATM we are using default max threads is 20, instead we plan to use a smart thread pool in the future it's based on your JVM(Java ExecutorService). So you don't want to take care how many threads were using system will do that and give best choice for you.


```lucee
<cfscript>
thread /* action="thread" name="whatever" */ {
	sleep();
}
</cfscript>
```

make thread smarter by also use a pool for threads.


That the something we are planning it will come without changes in functionality on backend. That changes nothing in front end.


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

something we are planning to Extend parallel on the loop by simply adding ```parallel=true```. It will execute body of the loop parallel.


### Footnotes ###

Here you can see above details in video

[Lucee Threads ](https://www.youtube.com/watch?v=oGUZRrcg9KE)

