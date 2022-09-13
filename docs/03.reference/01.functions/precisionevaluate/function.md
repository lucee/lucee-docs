---
title: PrecisionEvaluate
id: function-precisionevaluate
related:
categories:
    - number
    - math
---

Evaluates one or more string expressions using an increased memory size for arithmetic operations. This improves the accuracy of floating point calculations. For more details, see this video explanation: [https://www.youtube.com/watch?v=g7A8OFi1mdU](https://www.youtube.com/watch?v=g7A8OFi1mdU).

**The expression(s) must be passed as strings**, to avoid large numbers being converted to normal cfml numbers (which have limits on the their precision) before they are evaluted.
