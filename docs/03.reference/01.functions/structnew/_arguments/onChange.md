listener function for the type **observable**, that gets invoked after a key was set, updated or removed ( since Lucee 9.0.0.564 ).

The function is called with the arguments `key`, `oldValue`, `newValue` and `struct`:

  - for a new key `oldValue` is null
  - for a removed key `newValue` is null
  - setting a key calls the function every time, also when the value did not change
  - removing a key calls the function once for that key, removing a key that does not exist does not call it
  - `structClear()` calls the function once for every key that was removed
  - the function is called on the thread that did the change, after the change was applied
  - only changes made directly to the observable struct are reported, not changes inside nested structs or arrays
  - an exception thrown by the function is not swallowed, the change is not rolled back
  - a copy created with `duplicate()` is a regular struct without the listener

Can not be combined with **onMissingKey**.
