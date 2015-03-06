# Lucee Tag documentation contribution guide

The current folder stores reference documentation for the Lucee tag, **http**. Contributions are very welcome and hopefully the information below should help you find your way around.

The `specification.json` file contains the core information for the tag such as attributes and other technical details. It potentially also contains cross reference information such as related articles, examples and koans tutorials.

Where you see an `{{include:file}}` directive, paths will be relative to  this directory. For example, you may see `{{include:description.md}}` we should lead you to the `description.md` file in the root of this folder.

By default, long text descriptions for the tag and its attributes are stored in separate markdown files to make contributing to those descriptions easier. Each attribute has it's own folder under the `/attributes` folder.

For more information on contributing to the Lucee documentation, see [some useful article here](http://www.lucee.org/).