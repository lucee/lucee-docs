```luceescript
    request.inthread = false;
    writeOutput(isInThread());
    thread action="run" name="inThread" {
    request.inthread = isInThread();
    }
    sleep(1000);
    writeOutput(request.inthread)
```