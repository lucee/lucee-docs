Lucee Docs Importer (a demonstrative example)
---------------------------------------------

This repository demonstrates some ideas around how I think we can move the Lucee documentation system forward in terms of building a core data set that can then be exported to multiple endpoints. I created a separate repository because there was too much of a shift in methodolgy to create a pull request to Mark's [Lucee Docs](https://github.com/cybersonic/luceedocs). I hope to persuade that this approach, or parts of it are suitable for inclusion in that project rather than continuing an unhelpful fork.

## Explanation and layout

The system works much the same as what is in the Lucee Docs project in terms of the importer. The /build folder contains a build.cfm file that can be run in a browser or with CommandBox or using the build.sh file with CommandBox.

Right now, its brutal and will simply do a "build all", importing doc specification from the Lucee source. That's it.

The imported data is built into two folders, `/data/imported` and `/data/editorial`. Editorial files and folders are the only places in which contributers would maintain the documentation. The import process will never overwrite the editorial files, but it will create new ones when importing from source and coming across new functions that will need their editorial space stubbing.

I have opted to keep only the descriptions of tags, functions and their attributes and arguments editable. I have also chosen individual markdown files for each of those descriptions. In an HTML rendering of a function / tag, "Edit me" links could be added to all descriptions to take you directly to source.

Other features such as cross referencing, gists, sub-contexts (think cffile action="write", cffile action="delete"), etc. can be built in this editorial space without needing to reimport and without needing changes to the core engine files.

## Versioning

Versioning of imported doc metadata is handled in the BuildProperties.cfc file. Each version is imported into its own directory. Editorial content however is not versioned (would probably need some figuring out) so that edits are not lost to new versions.

## How I see a full implementation working

Ideally, the build script would have build arguments such as target environment, and different outputs (HTML, PDF, and just about anything else). The target environments would control things like how cross reference links were built, etc.

Output builds, as opposed to the current import build, would be able to use a Lucee API for getting at the documentation data in /data/editorial and /data/imported to create the finalized documentation.

I like the idea of a flat HTML documentation site served off a static CDN such as S3 - super reliable and as fast as can be. This would be easily achieved with much the same code as Mark has already developed.

## Final thoughts

I don't think this is a massive departure from what Mark has already achieved and think that, if liked, elements of it could be merged with a little effort.

Thoughts?