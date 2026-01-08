Component with the callback listener functions.

| Callback | Arguments | Description |
|----------|-----------|-------------|
| `onMessage` | `message` | Text message received |
| `onBinaryMessage` | `binary` | Binary data received |
| `onClose` | (none) | Connection closed |
| `onError` | `type, cause, [data]` | Error occurred |
| `onPing` | (none) | Ping frame received |
| `onPong` | (none) | Pong frame received |