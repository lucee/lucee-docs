If "lazy" is set to true (default "false") Lucee does not initially load all the data from the datasource.

When "true" the data is only loaded when requested, this means the data is dependent on the datasource connection. If the datasource connection has been lost for some reason and the data has not yet been requested, Lucee throws an error if you try to access the data.

The "lazy" attribute only works if the following attributes are not used: cachewithin, cacheafter and result.
