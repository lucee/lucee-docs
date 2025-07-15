<!--
{
  "title": "Sending Emails",
  "id": "mail-how-to-send-a-mail",
  "related": [
    "tag-imap",
    "tag-mail",
    "tag-mailparam",
    "tag-mailpart",
    "mail-listeners"
  ],
  "description": "How to send an email using Lucee with help of the tag cfmail.",
  "keywords": [
    "Email",
    "Send mail",
    "cfmail",
    "Mail server",
    "Mail script",
    "Lucee"
  ],
  "categories": [
    "protocols",
    "core"
  ]
}
-->

# Mail - How to send an Email

The following example shows you how you can send a mail using [[tag-mail]].

In order to send and email, you need to provide the mail server configuration.

- Define a default Mail server in the Lucee Administrator / `CFConfig.json`
- Configure an application specific mail server in [[tag-application]]
- Pass the server details directly using [[tag-mail]] attributes, `server`, `port` etc

## Tags

```coldfusion
<cfmail subject="Your Order" from="whatever@lucee.org" to="whatever@gmail.com">
  Hi there,
  This mail is sent to confirm that we have received your order.
</cfmail>
```

## Script

```cfs
mail subject="Your Order" from="whatever@lucee.org" to="whatever@gmail.com" {
  writeOutput('Hi there,');
  writeOutput('This mail is sent to confirm that we have received your order.');
};
```

That is all you need to do to send a mail.

## Addressing

You can pass in a list of email addresses, either bare or with titles, use quotes if the title contains a special character

- `lucee1@example.com`
- `"Server, Lucee" <lucee2@example.com>`
- `Lucee Server <lucee3@example.com>`

```coldfusion
<cfmail subject="hello world" 
  to='lucee1@example.com,"Server, Lucee"<lucee2@example.com>,Lucee Server<lucee3@example.com>'.....>
Hello Possums
</cfmail>
```

## Spooling

By default Lucee spools mails and sends them out via a background thread, for better performance.

If you need to send the mail immediately, or need catch any SMTP errors, use `async="false"` which will send the email immediately and throw an errors encountered which will otherwise be caught and logged to the `remoteclient.log`

```cfs
mail subject="Your Order" from="whatever@lucee.org" to="whatever@gmail.com" async="false" {
  writeOutput('Hi there,');
  writeOutput('This mail is sent to confirm that we have received your order.');
};
```
