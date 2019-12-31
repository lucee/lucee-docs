```luceescript+trycf
	fruitArray = [{fruit='apple', rating=4}, {fruit='banana', rating=1}, {fruit='orange', rating=5}, {fruit='mango', rating=2}, {fruit='kiwi', rating=3}];

	favoriteFruits = fruitArray.filter(function(item){
	    return item.rating >= 3;
	});
	dump(favoriteFruits);
```