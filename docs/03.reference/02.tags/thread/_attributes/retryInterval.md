when type task, this attribute define a execution plan for additional tries of execution.
			you can define a single rule or multiple rules as array

			Example single rule:
			#{interval:createTimeSpan(0,0,0,5),tries:5}#

			in this case Lucee replay the thread for a maximum of 5 times, when the execution fails, Lucee waits for 5 seconds before doing the next try.

			Example multiple rules:
			#[{interval:createTimeSpan(0,0,0,5),tries:5},{interval:createTimeSpan(0,0,0,10),tries:5}]#

			in this case Lucee replay the thread for maximum of 10 times, when the execution fails, 5 times every 5 seconds, then 5 times every 10 seconds.