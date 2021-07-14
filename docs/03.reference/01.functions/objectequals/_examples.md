```luceescript+trycf
object1 = { id: 1, name: 'Lucee' };
object2 = { id: 1, name: 'Lucee' };
object3 = { id: 1, name: 'Lucee', type: "language" };
dump(ObjectEquals(left = object1, right = object2)); // true
dump(ObjectEquals(left = object1, right = object3)); // false
```
