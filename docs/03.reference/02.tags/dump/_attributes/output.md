Where to send the results:

- **browser:** the result is written to the browser response stream (default).
- **console:** the result is written to the console (System.out).
- **debug:** the result is written to the debugging logs, when debug is enabled.
- **false:** output will not be written, effectively disabling the dump (**this is currently not implemented**, use `enabled=false` instead)

Otherwise, this is value is treated as filename to write/append the dump outputs into, unless left blank.
