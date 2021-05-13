
```luceescript+trycf
	testOne = "100 MAIN ST.";
	dump(testOne.CompareNoCase("675 EAST AVENUE")); // -1
	writeoutput("<br>");
	testTwo = "I Love lucee";
	dump(testTwo.CompareNoCase("I Love Lucee")); // 0
	writeoutput("<br>");
	testThree = "Lucee";
	dump(testThree.CompareNoCase("developer")); // 1
```
