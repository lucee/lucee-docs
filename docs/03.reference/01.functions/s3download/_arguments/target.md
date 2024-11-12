Optional. Defines the target where the downloaded data will be directed.

If a file path is provided, the data is saved to that path, the file path must be provided with help of the function "fileOpen" like this [fileOpen(path,"write")].

If a closure or function is given, it will be invoked with parts of the downloaded data as its argument.
The function should accept a single argument named 'line' for line-by-line processing,
'string{Number}' for string blocks of a specified size,
or 'binary{Number}' for binary blocks of a specified size.

The function should return a boolean value: returning false will stop further reading from S3,
while true will continue the process.

If this argument is omitted, the function returns the downloaded data directly.