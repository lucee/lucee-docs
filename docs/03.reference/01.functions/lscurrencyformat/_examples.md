```luceescript+trycf
  amount = 100;

  locale = 'en_US';
  writeoutput(LSCurrencyFormat( amount, 'local', locale )); // $100.00
  writeoutput(LSCurrencyFormat( amount, 'international', locale )); // USD 100.00
  writeoutput(LSCurrencyFormat( amount, 'none', locale )); // 100.00

  locale = 'ja_JP';
  writeoutput(LSCurrencyFormat( amount, 'local', locale )); // ￥100
  writeoutput(LSCurrencyFormat( amount, 'international', locale )); // JPY 100
  writeoutput(LSCurrencyFormat( amount, 'none', locale )); // 100
```