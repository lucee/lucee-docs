```luceescript+trycf
thresholds = [1, 3, 4, 5];

score = CollectionReduce(thresholds, function(a, b) {
  return a + b^2;
}, 0);

dump(score); // 51

score = thresholds.reduce(function(a, b) {
  return a + b^2;
}, 0);

dump(score); // 51
```
