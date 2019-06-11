
```luceescript+trycf
	testOne = "Lucee";
	dump(testOne.Compare("lucee")); // -1
	writeoutput("<br>");
	testTwo = "Lucee_Core_dev";
	dump(testTwo.Compare("Lucee_Core_dev")); // 0
	writeoutput("<br>");
	testThree = "I Love lucee";
	dump(testThree.Compare("I Love Lucee")); // 1
```