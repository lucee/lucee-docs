Record set name in which the result of the list action is stored.
The record set columns are:

- name: filename of the entry in the JAR file. For example, if the entry is help/docs/index.htm, the name is index.htm.
- directory: directory containing the entry. For the example above, the directory is help/docs. You can obtain the full entry name by concatenating directory and name. If an entry is at the root level, the directory is empty ('').
- size: uncompressed size of the entry, in bytes.
- compressedSize: compressed size of the entry, in bytes.
- type: type of entry (directory or file).
- dateLastModified: last modified date of the entry, cfdate object.
- comment: any comment, if present, for the entry.
- crc: crc-32 checksum of the uncompressed entry data.
