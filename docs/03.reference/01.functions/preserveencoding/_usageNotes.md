`preserveEncoding` only has an effect when it is the whole expression between the hash signs, for example `#preserveEncoding( markup )#`.
An expression that merely contains a call to `preserveEncoding`, like `#preserveEncoding( markup ) & other#`, is encoded as a whole.
