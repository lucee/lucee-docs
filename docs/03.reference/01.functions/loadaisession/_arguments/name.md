Specifies which AI endpoint configuration to use. Can be provided in two formats:

1. Direct endpoint name:

The name of an endpoint as defined in the Lucee Administrator (similar to how datasource names work)

2. Default reference:

Using the format "default:category" to use the endpoint configured as the default for that specific category in the Lucee Administrator.

Currently supported default categories:

- exception: For exception analysis
- documentation: For documentation tasks

The endpoint configurations and their default category assignments are managed in the Lucee Administrator.