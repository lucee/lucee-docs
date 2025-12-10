<!--
{
  "title": "Event Gateways in Lucee",
  "id": "event-gateways",
  "related": [
    "function-sendgatewaymessage"
  ],
  "categories": [
    "gateways"
  ],
  "description": "EG's are another way how to communicate with your Lucee server and are kind of a service running on Lucee, reacting on certain events.",
  "keywords": [
    "Event Gateway",
    "Custom Gateway",
    "SMS",
    "File Change",
    "Mail Server",
    "Slack Notification",
    "Lucee"
  ]
}
-->

# Event Gateways

Event Gateways are services running on Lucee that react to events such as:

- SMS received
- File change in a directory
- Mail received
- Slack notification

In Lucee, Event Gateways can be written in CFML (not just Java), making them much more accessible.

## Components

- **Gateway driver** - CFC that manages lifecycle, always running
- **Event Gateway** - The actual event handling implementation

## Example

```lucee
<cfset sMessage = "something I need to log.">
<cfset sendGatewayMessage("logMe", {})>
```

Sanity checks prevent faulty data. With valid data:

```lucee
<cfset sMessage = "something I need to log.">
<cfset sendGatewayMessage("logMe", {message:sMessage, type:"error"})>
```

The message passes to the Gateway via `sendGatewayMessage()` and gets written to the log.

## Use Cases

- Bluesky/social media integration
- Slack channel monitoring
- Socket listeners
- Incoming email handlers
