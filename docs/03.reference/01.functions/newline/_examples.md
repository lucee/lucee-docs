```luceescript+trycf
fruits = [
    {
        en = "apple",
        de = "Apfel"
    },
    {
        en = "orange",
        de = "Orange"
    },
    {
        en = "strawberry",
        de = "Erdbeere"
    }
]
echo("
    <select>
    #(
        fruits.map(function(fruit) {
            return "<option value='#fruit.en#'>#fruit.de#</option>"
        }).toList(NewLine())
    )#
    </select>
");
```
