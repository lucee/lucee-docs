The priority level at which to run the thread.
            The following values are valid:
            HIGH, LOW, NORMAL
            Higher priority threads get more processing time than lower priority
            threads. Page-level code, the code that is outside of cfthread tags,
            always has NORMAL priority. (optional, default=NORMAL)