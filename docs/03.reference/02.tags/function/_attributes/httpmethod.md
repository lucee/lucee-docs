Specifies the HTTP method to use when calling the function as part of a RESTful service. Accepted values include:

- `GET`: Requests information from the server.
- `POST`: Sends information to the server for processing.
- `PUT`: Requests the server to store the message body at the specified URL.
- `DELETE`: Requests the server to delete the specified URL.
- `HEAD`: Similar to GET but without a response body.
- `OPTIONS`: Requests information about the communication options available for the server or the specified URL.

If not specified, the `GET` method is used by default.