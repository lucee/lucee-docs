The number of milliseconds that the current thread waits for the thread or threads being joined to finish. 

If any thread does not finish by the specified time, the current thread proceeds. 

If the attribute value is 0, the default, the current thread continues waiting until all joining threads finish. 

If the current thread is thepage thread, the page continues waiting until the threads are joined, even if you specify a page timeout. (optional, default=0)