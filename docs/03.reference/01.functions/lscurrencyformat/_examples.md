```luceescript+trycf
  amount = 100;

  locale = 'en_US';
  LSCurrencyFormat( amount, 'local', locale ); // $100.00
  LSCurrencyFormat( amount, 'international', locale ); // USD 100.00
  LSCurrencyFormat( amount, 'none', locale ); // 100.00

  locale = 'ja_JP';
  LSCurrencyFormat( amount, 'local', locale ); // ￥100
  LSCurrencyFormat( amount, 'international', locale ); // JPY 100
  LSCurrencyFormat( amount, 'none', locale ); // 100
```