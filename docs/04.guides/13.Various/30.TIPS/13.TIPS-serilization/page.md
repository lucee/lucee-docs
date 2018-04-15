---
title: Serialize all types of data by using serialize(data)
id: tips-serialize-data
related:
- function-evaluate
- function-serialize
- function-unserializejava
---

### Serialize (anything) ###

Lucee has this great extra function: serialize(). What it does, is converting (almost) any data to a string. Now if you use the evaluate() function with that string, then the original data is rebuilt again!

So, let's say you have a structure with multiple nested queries and structures, and you want to save this data for debugging. Then you only have to serialize() it:

	<cfset myDataAsString = serialize(myComplexDataObject) />

Not only can you use this on structures, arrays, and query objects, but you can even serialize CFCs. The variables scope inside the cfc is also serialized, so you will get a completely accurate object back.

### Some examples of serialized data ###

This is the component test.cfc, which has 2 variables inside, test and test2:

	evaluateComponent('test','6ad49215baf34832c9c00177d97ef513',struct(),struct('TEST':1,'TEST2':2))

This is a structure with 2 queries inside (added some spacing for readability):

```lucee
{
	'OTHERKEY':query(
	'othercol':['pete','philip','paul']
	, 'othercol2':[3,6,2]
	)
, 'MYKEY':query('col1':['abc','xzx','dfdf'],'col2':[6,23,59])
}
```

As you can see, it doesn't take much space, and is even human-readable. Did you also notice the functions struct() and query() inside the serialized data? Those are actually Lucee built-in functions.

Now, if you want to use this data again, you can just simply call evaluate() to get the original data back:

```lucee
<cfset myData = evaluate(mySerializedData) />
```
