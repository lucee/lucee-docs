Indicates how long, in seconds, the executing thread waits for the spawned process.
		A timeout of 0 is equivalent to the non-blocking mode of executing. A very high timeout value is
		equivalent to a blocking mode of execution. The default is 0; therefore, the thread spawns
		a process and returns without waiting for the process to terminate.If no output file is specified,
		and the timeout value is 0, the program output is discarded.