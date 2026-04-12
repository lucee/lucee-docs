The overriding configuration struct. Scalar values in this struct overwrite
corresponding values in the left struct. Collection types such as extension arrays
are merged by appending to the left struct's values rather than replacing them.
This struct is not modified by the function.