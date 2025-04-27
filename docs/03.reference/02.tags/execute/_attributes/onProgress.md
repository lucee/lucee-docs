A UDF which receives two arguments, the progressive output and the java Process instance for the execution.
If defined, output to the other variables will be null.
The java Process instance can be used to interact with the executing process, i.e. via getOutputSteam().
https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/lang/Process.html 
Returning false from the Listener will cancel the process execution