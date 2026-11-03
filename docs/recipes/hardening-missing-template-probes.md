<!--
{
  "title": "Hardening against probing for missing templates",
  "id": "hardening-missing-template-probes",
  "description": "What web shell probes for non-existent .cfm files look like, why a missinginclude error is harmless, and how to reject them at Nginx or Apache before they reach Lucee.",
  "keywords": [
    "security",
    "hardening",
    "missinginclude",
    "web shell",
    "probe",
    "bot",
    "onMissingTemplate",
    "nginx",
    "apache",
    "try_files",
    "mod_rewrite",
    "404"
  ],
  "categories": ["security", "server"],
  "related": [
    "tag-application",
    "application-context-guide",
    "tag-header",
    "locking-down-lucee-server",
    "locking-down-your-lucee-stack",
    "admin-password"
  ]
}
-->

# Hardening against probing for missing templates

Public servers get a steady stream of automated requests for files that don't exist. Some of them look for web shells, which are small scripts an attacker leaves on a compromised server to run commands. This recipe shows what those probes look like in Lucee, why they are harmless on a clean server, and how to reject them before they reach Lucee.

## What the probes look like

A typical probe is a burst of requests, often overnight and from one IP, each for a random template name, with a command in the query string:

```
/assets/nxzqlls4r.cfm?cmd=ZWNobyBDT0xELVNIRUxMLTNqdnVyNGF1Z2Q%3D
```

The `cmd` value is Base64. Decoded, it is a harmless `echo` of a marker string. The bot isn't trying to exploit anything. It is knocking on common locations and checking whether a shell it expects answers with the marker.

In the Lucee exception log, every request shows up as a `missinginclude` error.

## Why a missinginclude is harmless

A `missinginclude` means Lucee looked for the template, didn't find it and threw an error. Nothing was compiled or executed, so the `cmd` value was never read by any code.

That is the result you want to see. The thing to worry about is the opposite: a probe for a name that does exist and answers. So check the server:

- Look for unexpected `.cfm` or `.cfc` files that changed recently, see [Checking for unexpected files](#checking-for-unexpected-files).
- Check that no template you don't recognise answers requests.

## Reject missing .cfm files at the web server

If Nginx or Apache sits in front of Lucee, it can check that the file exists and answer 404 itself. These requests then never reach Lucee, and don't fill your logs with errors.

**Both snippets only work if the web server can see the same webroot as Lucee.** If the web server runs in a separate container or on another host without your files, every `.cfm` request would get a 404. Don't use this approach in that setup.

### Nginx

Add `try_files $uri =404;` to the location that proxies CFML requests, before `proxy_pass`:

```nginx
server {
	root /var/www/mysite;

	location ~ \.(cfm|cfml|cfc)$ {
		try_files $uri =404;
		proxy_pass http://127.0.0.1:8888;
	}

	location / {
		proxy_pass http://127.0.0.1:8888;
	}
}
```

If the file exists, Nginx passes the request on. If it doesn't, Nginx returns 404 without contacting Lucee.

### Apache

With `mod_proxy` and `mod_rewrite`, add a rewrite rule above your `ProxyPass` lines:

```apache
RewriteEngine On
RewriteCond %{DOCUMENT_ROOT}%{REQUEST_URI} !-f
RewriteRule \.(cfm|cfml|cfc)$ - [R=404,L]

ProxyPass / http://127.0.0.1:8888/
ProxyPassReverse / http://127.0.0.1:8888/
```

In a virtual host or server config, use `%{DOCUMENT_ROOT}%{REQUEST_URI}` in the condition. Don't use `%{REQUEST_FILENAME}` there. At that stage Apache hasn't mapped the URL to a file yet, so the condition also fails for files that do exist, and you get a 404 for the whole site. `REQUEST_FILENAME` is fine in `.htaccess` or a `<Directory>` block.

### What this breaks

The web server now answers for missing templates, so Lucee never sees them. That means:

- `onMissingTemplate` in your `Application.cfc` is never called for these URLs.
- Front-controller and SES-style URLs break if the URL ends in `.cfm` but no such file exists, for example `/api/users/42.cfm` that your application routes itself.

Neither is a problem for URLs like `/index.cfm/users/42`, because they don't end in `.cfm` and so skip the check, and Lucee already maps `/index.cfm/*` to the servlet.

To exempt the paths that depend on `onMissingTemplate`, give them their own rule ahead of the check.

In Nginx, add a more specific location above the general one. Nginx uses the first matching regular-expression location:

```nginx
location ~ ^/api/.*\.cfm$ {
	proxy_pass http://127.0.0.1:8888;
}

location ~ \.(cfm|cfml|cfc)$ {
	try_files $uri =404;
	proxy_pass http://127.0.0.1:8888;
}
```

In Apache, add a condition that skips those paths:

```apache
RewriteCond %{REQUEST_URI} !^/api/
RewriteCond %{DOCUMENT_ROOT}%{REQUEST_URI} !-f
RewriteRule \.(cfm|cfml|cfc)$ - [R=404,L]
```

Test your own URLs after the change. A quick check is one request for a real template (expect 200) and one for a random name (expect 404):

```bash
curl -s -o /dev/null -w "%{http_code}\n" https://example.com/index.cfm
curl -s -o /dev/null -w "%{http_code}\n" https://example.com/assets/doesnotexist.cfm
```

## Return a cheap 404 from onMissingTemplate

If you can't check files at the web server, or you don't want to, `onMissingTemplate` in `Application.cfc` can answer missing templates with a plain 404. This avoids Lucee's detailed error page, and the request is cheap to serve:

```cfml
component {

	this.name = "myapp";

	function onMissingTemplate( targetPage ) {
		header statuscode=404 statustext="Not Found";
		content type="text/plain";
		echo( "Not found" );
		return true;
	}

}
```

Things to know:

- `onMissingTemplate` runs after Lucee has started the request, so the application is still involved. It is lighter than an error page, but it is not the same as stopping the request at the web server.
- Set the status with [[tag-header]]. If you only write output and return, the response is `200 OK`, which tells the bot nothing is wrong.
- Return `true` to say the request is handled. Returning `false` falls back to the normal missing-template error.

See [[application-context-guide]] for the other `Application.cfc` event methods.

## Other hardening pointers

These are short pointers. The linked guides go into detail.

- **Don't expose the Lucee Administrator publicly.** Restrict `/lucee` to trusted IPs at the web server, or disable the Admin on servers where you don't need it with `LUCEE_ADMIN_ENABLED=false`. See [[admin-password]] and [[locking-down-lucee-server]].
- **Hide detailed errors from visitors.** Set the general and missing-template error pages to `/lucee/templates/error/error-public.cfm`, as described in [[locking-down-lucee-server]].
- **Keep Tomcat's ports private.** Only the web server needs to reach the HTTP, AJP and shutdown ports. See [[locking-down-your-lucee-stack]].
- **Keep Lucee, Tomcat and the JVM updated.** Security fixes are only useful once they are installed.
- **Block abusive IPs in the firewall, not in the application.** A ban inside the application never sees these requests, because the template doesn't exist.

### Checking for unexpected files

On a server you suspect, look for templates that changed recently outside your own deployment folders, and for templates that can run programs:

```bash
# CFML files changed in the last 14 days
find /path/to/your/site \( -name "*.cfm" -o -name "*.cfc" \) -mtime -14

# templates that can run programs (most applications have none)
grep -rlE --include=*.cfm --include=*.cfc "cfexecute|getRuntime\(\)|ProcessBuilder" /path/to/your/site
```

Neither check proves a server is clean, but an unexpected hit is a reason to look closer. A deployment pipeline that rebuilds the site from version control makes unexpected files much easier to spot.
