A structure that contains one or more log definitions.

```
{
	"classic": {
		"appender":"resource",
		"appenderArguments": {
			"path" :"{lucee-config}/logs/classic.log"
		},
		"layout":"classic",
		"level":"info"
	},
	"pattern": {
		"appender": "resource",
		"appenderArguments": {
			"path": "{lucee-config}/logs/pattern.log"
		},
		"level": "info",
		"layout": "pattern",
		"layoutArguments": {
			"pattern": "%d{yyyy-MM-dd HH:mm:ss,SSS} [%t] %-5p %c - %m%n"
		}
	}
}
```
