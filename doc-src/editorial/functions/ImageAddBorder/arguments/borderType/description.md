The type of border:
- zero: Sets the border color to black.
- constant: Sets the border to the specified color (default).
- copy: Sets sample values to copies of the nearest valid pixel. For example, pixels to the left of the valid rectangle assume the value of the valid edge pixel in the same row. Pixels both above and to the left of the valid rectangle assume the value of the upper-left pixel.
- reflect: Mirrors the edges of the source image. For example, if the left edge of the valid rectangle is located at x = 10, pixel (9, y) is a copy of pixel (10, y) and pixel (6, y) is a copy of pixel (13, y).
- wrap: Tiles the source image in the plane.