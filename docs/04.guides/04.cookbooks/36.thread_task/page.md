---
title: Thread Task
id: thread_task
related:
- tag-thread
categories:
- thread
description: 'How to use Thread Tasks '
---

## Thread Task ##

This document explains about the thread tasks. It useful to know the differences between regular threads and task threads.

When a regular thread throws an exception, the default exception type is ``type='daemon'``. After an exception, the thread is dumped. If a regular thread is terminated due to an error, the information from the thread will be output with a 'terminated' status.

Regular Threads have the following characteristics:

1) **Bound to current request** : With the help of CFThread you can always see what the thread is doing. With ``action='join'`` you can wait until the thread ends and join it. You can also call "action='terminate'" and end the thread. You always have control over the thread with the various actions.

2) **Runs only once** : The thread runs only once. It ends at the end of the Cfthread tag or if there is an exception.

3) **It fails when it fails** : There is no special exception handling so when the thread fails it fails unless you have Cftry, cfcatch inside the thread and you have exception handling there.

### Example 1 : ###

In addition to daemon (regular) threads, Lucee also supports task threads. The main differences is that task threads execute completely Independent of the request that is calling the thread. We log the thread and can re-execute it.

This example shows a task thread. It is similar to the daemon thread, but we do not have the join and output of the thread because these are not allowed with a task thread.

```luceescript
thread name="test" type="daemon" {
	throw "hopala!";
}
thread action="join" name="test";
dump(cfthread.test);
```

Note that when you execute example code, you will get no output. This is expected since no output was written in the code.

However, view the Lucee _Admin --> Services --> Tasks_ and see the name of the tasks and their ``Type`` is cfthread. It could be mail or other tasks.

We see the ``Number of tries`` is 1 because we only ran it once. When we go to detailed view, we see the exception that was thrown by the task, the template where it was executes, and the state. (The state is closed in this case.)

### Example 2 : ###

This example shows how to create a retry interval. A retry interval is useful when a task fails and you want to try it again. For example if you are contacting an external service and it does not always respond.

```luceescript
thread name="test" type="task"
	retryinterval={
		tries:3,
		interval:createTimeSpan(0,0,0,1)
	} {
	throw "hopala!";
}
```

In this example:

1) It retries 3 times every 1 second when it fails.

2) It will retry 3 times at 1 second intervals every time it does not get an output. Go to _admin --> Services --> Tasks_, we see two tasks. The tasks are closed, but you can see that the new task was executed 4 times.

3) If you view the details, you can see that the ``Number of tries`` is 4,``Remaining tries`` are 0, ``State`` is closed. If we execute the thread again, the ``Number of tries`` will be increased to 5.

### Example 3 : ###

```luceescript
thread name="test" type="task"
	retryinterval=[
	{tries:3, interval:createTimeSpan(0,0,0,1)},
	{tries:5, interval:createTimeSpan(0,0,0,5)},
	{tries:10, interval:createTimeSpan(0,0,0,10)},
	{tries:10, interval:createTimeSpan(0,0,1,0)},
	{tries:20, interval:createTimeSpan(0,0,10,0)}
	] {
	throw "hopala!";
}
```

This example is similar to the previous one, but it more complex. Here We have an array of multiple retry intervals defined.

1) This example has the following retry intervals:
	tries:3, interval:createTimeSpan(0,0,0,1), this means try 3 times every one second
	{tries:5, interval:createTimeSpan(0,0,0,5)}, this means try 5 times every 5 seconds
	{tries:10, interval:createTimeSpan(0,0,0,10)}, this means try 10 times every 10 seconds
	{tries:10, interval:createTimeSpan(0,0,1,0)}, this means try 10 times every 1 minute
	{tries:20, interval:createTimeSpan(0,0,10,0) this means try 20 times every 10 minutes

2) When we execute, we again get no output. However, we see the result and it is not 'read', because it is not done retrying. We have only tried 5 times.

3) Refresh the page, we see now it has tried more times. (Go to admin _Admin --> Services --> Tasks_)

**Task thread** : Different than daemon threads, task threads can run more than once if they fail. You can schedule a later retry, and you can control it in the administrator.

Task threads are not bound to the requests starting the threads as demon threads are, but you still can control them with help of the component administrator. That component is available everywhere so we can use it in a test page.

### Example 4 : ###

```luceescript
/**/thread name="test" type="task"
	retryinterval=[
	{tries:3, interval:createTimeSpan(0,0,0,1)},
	{tries:5, interval:createTimeSpan(0,0,0,5)},
	{tries:10, interval:createTimeSpan(0,0,0,10)},
	{tries:10, interval:createTimeSpan(0,0,1,0)},
	{tries:20, interval:createTimeSpan(0,0,10,0)}
	] {
	throw "hopala!";
}
// wait for it( title="", body=any, labels=any, skip=any, data={} )
	sleep(1000);
// get admin component
	admin=new Administrator(type:"web",password:"server");
// list all tasks
	tasks=admin.getTasks();
	dump(tasks);
// reexecute
	admin.executeTask(tasks.id);
// delete a single task
	admin.removeTask(tasks.id[tasks.recordcount]);
//delete all tasks
	admin.removeAllTask();
```

This example for getting the admin component and task is physically created on the system.

1) ``admin.getTasks()`` is used to list out the all existing tasks. When executed, it returns a query that contains the information from the task.

2) ``admin.executeTask()`` is used to execute the task and we see it in the browser. It throws an exception.

3) ``admin.removeTask()`` and "admin.removeAllTask()" is used to remove tasks from administrator.

### Footnotes ###

Here you can see the details in the video:
[Thread Task](https://youtu.be/-SUbVWqJRME)
