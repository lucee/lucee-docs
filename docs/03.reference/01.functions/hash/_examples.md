```luceescript+trycf
// Variable-length strings produce fixed-length hashes.
input = 'Hello World';
dump( hash( input ) ); // B10A8DB164E0754105B7A99BE72E3FE5

input = 'Mary had a little lamb.';
dump( hash( input ) ); // CA964B1677D5476EA11EED1E1837C342
```

```luceescript+trycf
// Different algorithms are supported.
input = 'Hello World';
dump( hash( input ) ); // B10A8DB164E0754105B7A99BE72E3FE5
dump( hash( input, 'QUICK' ) ); // 6b736ba1c9a95606
dump( hash( input, 'MD5' ) ); // B10A8DB164E0754105B7A99BE72E3FE5
dump( hash( input, 'CFMX_COMPAT' ) ); // B10A8DB164E0754105B7A99BE72E3FE5
dump( hash( input, 'SHA' ) ); // 0A4D55A8D778E5022FAB701977C5D840BBC486D0
dump( hash( input, 'SHA-256' ) ); // A591A6D40BF420404A011733CFB7B190D62C65BF0BCDA32B57B277D9AD9F146E
dump( hash( input, 'SHA-384' ) ); // 99514329186B2F6AE4A1329E7EE6C610A729636335174AC6B740F9028396FCC803D0E93863A7C3D90F86BEEE782F4F3F
dump( hash( input, 'SHA-512' ) ); // 2C74FD17EDAFD80E8447B0D46741EE243B7EB74DD2149A0AB1B9246FB30382F27E853D8585719E0E67CBDA0DAA8F51671064615D645AE27ACB15BFB1447F459B

// The default, MD5 and CFMX_COMPAT algorithms are all MD5.
dump( hash( input ) == hash( input, 'MD5' ) && hash( input, 'MD5' ) == hash( input, 'CFMX_COMPAT' ) ); // true
```

```luceescript+trycf
// The number of iterations change the hash
dump( hash( input = input, numIterations = 1 ) ); // B10A8DB164E0754105B7A99BE72E3FE5
dump( hash( input = input, numIterations = 9 ) ); // 5E1C304FD939BBE1378ED977E2AD26B5

// numIterations less than 1 are set to 1
dump( hash( input = input, numIterations = 0 ) == hash( input = input, numIterations = 1 ) ); // true

// More iterations take more time
timer type='inline' label='1000 SHA-512s, 1 iteration each' {
    for ( i = 0; i < 1000; i++ ) {
        hash( input = input, algorithm = 'SHA-512', numIterations = 1 );
    }
    // 1000 SHA-512s, 1 iteration each: 5ms
};

writeOutput('<br>');

timer type='inline' label='1000 SHA-512s, 10 iterations each' {
    for ( i = 0; i < 1000; i++ ) {
        hash( input = input, algorithm = 'SHA-512', numIterations = 10 );
    }
    // 1000 SHA-512s, 10 iterations each: 21ms
};
```
