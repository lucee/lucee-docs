```luceescript+trycf
sentences="Swansea Jack was a black retriever with a longish coat. He lived in the North Dock / River Tawe area of Swansea, what gave him the name of Swansea Jack. Swansea Jack's first rescue, in June 1931, when he saved a 12-year-old boy, went unreported.";

dump( right( sentences, len( sentences )- sentences.findlastnocase( "SwAnSeA JACK" ) + 1 ) );
```
