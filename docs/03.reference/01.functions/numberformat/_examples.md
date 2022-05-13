```luceescript+trycf
dump(numberFormat(1.234,'__.00')); // 1.23
dump(numberFormat(1234,'__.00')); // 1234.00
// 0 and 9 mask
dump(numberFormat(123,'00000'));
dump(numberFormat(123,'99999'));
dump(numberFormat(123.12,'99.99999'));
// _ mask
dump(numberFormat(123,'_____'));
dump(numberFormat(123,'_.___'));
dump(numberFormat(11.10,'__.000'));
// + & - mask
dump(numberFormat(123,'+'));
dump(numberFormat(-123,'-'));
 // , comma
dump(numberFormat(123,','))
dump(numberFormat(123456,','))
// L,C mask
dump(NumberFormat( 1, "L999" ));
dump(NumberFormat( 1, "C000" ));
```