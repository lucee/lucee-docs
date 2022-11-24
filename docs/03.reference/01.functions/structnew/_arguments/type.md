the type of structure created:

  - **normal** (default): a regular struct ( thread safe )
  - **ordered**: a struct with linked or ordered keys that maintain their insertion order ( alias **linked** )  
  - **soft**: a struct with soft reference values, which are cleared at the discretion of the garbage collector in response to memory demand.
  - **weak**: a struct containing weakly referenced values, which do not prevent their referents from being garbage collected. Weak references are most often used to implement simple caches.

  _Note, the older type "synchronized" is now same as the default, **normal**; all struct/scopes are "thread safe" since version 4.1._
