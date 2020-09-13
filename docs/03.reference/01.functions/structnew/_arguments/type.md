the type of structure created:

  - **linked**: a struct with linked or ordered keys that maintain their insertion order
  - **normal** (default): a regular struct
  - **soft**: a struct with soft reference values, which are cleared at the discretion of the garbage collector in response to memory demand.
  - **weak**: a struct containing weakly referenced values, which do not prevent their referents from being garbage collected. Weak references are most often used to implement simple caches.

  _Note, the type "synchronized" is no longer supported and will be ignored; all struct/scopes are "thread safe" since version 4.1._
