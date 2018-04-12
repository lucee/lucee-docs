---
title: ImageFilterKernel
id: function-imagefilterkernel
related:
- function-imagefilter
categories:
- image
description: 'These are passed to the function ImageFilters '
---

These are passed to the function ImageFilters (see [[function-ImageFilter]] documentation).

The ImageFilterKernel function defines a matrix that describes how a specified pixel and its surrounding pixels affect the value computed for the pixel's position in the output image of a filtering operation.

The X origin and Y origin indicate the kernel matrix element that corresponds to the pixel position for which an output value is being computed.
