 ### Deletes an array element by its value
 ```luceescript+trycf
 arr1 = [12,0,1,2,3,4,5,6];
 arr1.every(function(item,index,arr){
    dump(item & ', ' & item + 5);
    return true;
 },true,4);
 ```