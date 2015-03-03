when the second argument is a id then this argument defines the boolean "unique" otherwise it defines the order.
		
- unique:
If unique is set to true, then the entity is returned.
If you are sure that only one record exists that matches this filtercriteria, then you can specify unique=true, so that a single entity is returned instead of an array.
If you set unique=true and multiple records are returned, then an exception occurs.

- order:
String used to specify the sortorder of the entities that are returned.If specified, loads and returns an array of entities that satisfy the filtercriteria sorted as specified by the sortorder.
		
		