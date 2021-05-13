zip: Specifies whether pathnames are stored in the ZIP or JAR file:

- yes: pathnames of entries are stored in the ZIP or JAR file.
- no: pathnames of the entries are not stored in the ZIP or JAR file. All the files are placed at the root level. In case of a name conflict, the last file in the iteration is added.

unzip: Specifies whether files are stored at the entrypath:

- yes: the files are extracted to the entrypath.
- no: the entrypath is ignored and all the files are extracted at the root level. (optional, default= yes)
