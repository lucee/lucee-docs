
			the type the struct created:
  - normal (default): a regular struct
  - weak: a struct containing weak referenced values, which do not prevent their referents from being made garbage collected. Weak references are most often used to implement simple caches.
  - soft: a struct with soft reference values, which are cleared at the discretion of the garbage collector in response to memory demand.
  - linked: a struct with linked keys, maintain their creation order
  the type "synchronized" is no longer supported and get ignored, because since version 4.1 all struct/scopes are "thread safe"
			