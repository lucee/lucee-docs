    ### Simple Array
    ```luceescript+trycf
    arr = ['a','b','c','d','e','f','g'];
    converted = arrayToStruct(arr);
    dump(converted);
    ```

    ### Array of Structs
    ```luceescript+trycf
    arr2 = [
        {name:'a'},
        {name:'b'},
        {name:'c'},
        {name:'d'},
        {name:'e'}
    ];
    converted2 = arrayToStruct(arr2);
    dump(converted2);
    ```
