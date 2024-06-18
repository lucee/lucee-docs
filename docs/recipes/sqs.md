<!--
{
  "title": "Lucee SQS Integration Functions",
  "id": "lucee-sqs-integration-functions",
  "related": [
    "function-messageReceive",
    "function-messageSend"
  ],
  "categories": [
    "sqs",
    "messaging",
    "aws"
  ],
  "description": "Functions to integrate Amazon SQS with Lucee, including receiving and sending messages.",
  "keywords": [
    "Lucee",
    "SQS",
    "AWS",
    "Messaging",
    "Queue",
    "messageReceive",
    "messageSend",
    "Integration",
    "Cloud"
  ]
}
-->
# Lucee SQS Integration Functions

This document describes two custom functions to support Amazon SQS (Simple Queue Service) in Lucee: `messageReceive` and `messageSend`. These functions facilitate receiving and processing messages from an SQS queue and sending messages to an SQS queue.

## Functions

### `messageReceive`

This function retrieves messages from an SQS queue and processes them using a user-defined function (UDF). If the UDF executes without exceptions, the message is deleted from the queue. If an exception occurs, the message is made visible again in the queue for reprocessing.

#### Parameters

- `queue` (String): The URL of the SQS queue.
- `waitTime` (Number, optional): The wait time for long polling (in seconds). Default is 20 seconds.
- `numberOfMessages` (Number, optional): The maximum number of messages to retrieve. Default is 10.
- `executor` (Function): The user-defined function to process each message. This function receives a struct representing the message.

#### Example Usage

```lucee
messageReceive(queue="MyQueue", waitTime=20, numberOfMessages=10, executor=function(struct message) {
    handleMessage(message);
});
```

### `messageSend`

This function sends one or multiple messages to an SQS queue.

#### Parameters

- `queue` (String): The URL of the SQS queue.
- `messages` (Struct or Array): A single message or an array of messages to send. Each message is represented as a struct.

#### Example Usage

**Sending a Single Message:**

```lucee
messageSend(queue="MyQueue", {
    "Action": "create-thumbnail",
    "SourceBucket": "source-bucket-name",
    "SourceKey": "path/to/source/image.jpg",
    "DestinationBucket": "destination-bucket-name",
    "DestinationKey": "path/to/destination/thumbnail.jpg",
    "ThumbnailSize": "150x150"
});
```

**Sending Multiple Messages:**

```lucee
var msg = {
    "Action": "create-thumbnail",
    "SourceBucket": "source-bucket-name",
    "SourceKey": "path/to/source/image.jpg",
    "DestinationBucket": "destination-bucket-name",
    "DestinationKey": "path/to/destination/thumbnail.jpg",
    "ThumbnailSize": "150x150"
};
messageSend(queue="MyQueue", [msg, msg, msg]);
```
