---
title: ImageFilter
id: function-imagefilter
related:
categories:
    - image
---

the function ImageFilter allows to execute a filter against a image. Below you find a list of filter names supported by the function.
every filter need other parameters for the configuration, listed as well below.

average
	A filter which averages the 3x3 neighbourhood of each pixel, providing a simple blur.

	Parameters:

	- edgeAction (String)
		The action to perfomr for pixels off the image edges.
		valid values are:
		- clamp (default): Clamp pixels off the edge to the nearest edge.
		- wrap: Wrap pixels off the edge to the opposite edge.
		- zero: Treat pixels off the edge as zero
	- useAlpha (boolean)
		Set whether to convolve the alpha channel.
	- premultiplyAlpha (boolean)
		Set whether to premultiply the alpha channel.
block
	A Filter to pixellate images.

	Parameters:

	- blockSize (integer)
		The pixel block size.
		- min-value: 1
		- max-value: 100+
	- edgeAction (String)
		The action to perfomr for pixels off the image edges.
		valid values are:
		- clamp (default): Clamp pixels off the edge to the nearest edge.
		- wrap: Wrap pixels off the edge to the opposite edge.
		- zero: Treat pixels off the edge as zero
	- interpolation (String)
		The type of interpolation to perform.
		valid values are:
		- bilinear (default): Use bilinear interpolation.
		- nearest_neighbour: Use nearest-neighbour interpolation.
blur
	A simple blur filter. You should probably use BoxBlurFilter instead.

	Parameters:

	- edgeAction (String)
		The action to perfomr for pixels off the image edges.
		valid values are:
		- clamp (default): Clamp pixels off the edge to the nearest edge.
		- wrap: Wrap pixels off the edge to the opposite edge.
		- zero: Treat pixels off the edge as zero
	- useAlpha (boolean)
		Set whether to convolve the alpha channel.
	- premultiplyAlpha (boolean)
		Set whether to premultiply the alpha channel.
border
	A filter to add a border around an image using the supplied Paint, which may be null for no painting.

	Parameters:

	- left (integer)
		The border size on the left edge.
		- min-value: 0
	- right (integer)
		The border size on the right edge.
		- min-value: 0
	- top (integer)
		The border size on the top edge.
		- min-value: 0
	- bottom (integer)
		The border size on the bottom edge.
		- min-value: 0
	- color (String)
		The border color.
bump
	A simple embossing filter.

	Parameters:

	- edgeAction (String)
		The action to perfomr for pixels off the image edges.
		valid values are:
		- clamp (default): Clamp pixels off the edge to the nearest edge.
		- wrap: Wrap pixels off the edge to the opposite edge.
		- zero: Treat pixels off the edge as zero
	- useAlpha (boolean)
		Set whether to convolve the alpha channel.
	- premultiplyAlpha (boolean)
		Set whether to premultiply the alpha channel.
caustics
	A filter which simulates underwater caustics. This can be animated to get a bottom-of-the-swimming-pool effect.

	Parameters:

	- amount (numeric)
		The amount of effect.
		- min-value: 0
		- max-value: 1
	- brightness (integer)
		The brightness.
		- min-value: 0
		- max-value: 1
	- turbulence (numeric)
		Specifies the turbulence of the texture.
		- min-value: 0
		- max-value: 1
	- dispersion (numeric)
		The dispersion.
		- min-value: 0
		- max-value: 1
	- bgColor (String)
		The background color.
	- time (numeric)
		The time. Use this to animate the effect.
	- scale (numeric)
		Specifies the scale of the texture.
		- min-value: 1
		- max-value: 300+
	- samples (integer)
		The number of samples per pixel. More samples means better quality, but slower rendering.
cellular
	A filter which produces an image with a cellular texture.

	Parameters:

	- amount (numeric)
		The amount of effect.
		- min-value: 0
		- max-value: 1
	- turbulence (numeric)
		Specifies the turbulence of the texture.
		- min-value: 0
		- max-value: 1
	- stretch (numeric)
		Specifies the stretch factor of the texture.
		- min-value: 1
		- max-value: 50+
	- angle (numeric)
		Specifies the angle of the texture.
	- angleCoefficient (numeric)
	- gradientCoefficient (numeric)
	- colormap (Colormap)
		The colormap to be used for the filter. Use function ImageFilterColorMap to create.
	- randomness (numeric)
	- gridType (String)
		the grid type to set, one of the following:
		-  RANDOM
		-  SQUARE
		-  HEXAGONAL
		-  OCTAGONAL
		-  TRIANGULAR
	- distancePower (numeric)
	- scale (numeric)
		Specifies the scale of the texture.
		- min-value: 1
		- max-value: 300+
check
	A Filter to draw grids and check patterns.

	Parameters:

	- angle (numeric)
		The angle of the texture.
	- xScale (integer)
		The X scale of the texture.
	- yScale (integer)
		The Y scale of the texture.
	- fuzziness (integer)
		The fuzziness of the texture.
	- foreground (String)
		The foreground color.
	- background (String)
		The background color.
	- dimensions (Array)
chrome
	A filter which simulates chrome.

	Parameters:

	- amount (numeric)
		The amount of effect.
		- min-value: 0
		- max-value: 1
	- exposure (numeric)
		The exppsure of the effect.
		- min-value: 0
		- max-value: 1
	- colorSource (String)
	- material (String)
		 Use the following format [color,opacity]; Example: "red,0.5"
	- bumpHeight (numeric)
	- bumpSoftness (numeric)
	- bumpShape (integer)
	- viewDistance (numeric)
	- bumpSource (integer)
	- diffuseColor (String)
circle
	A filter which wraps an image around a circular arc.

	Parameters:

	- radius (numeric)
		The radius of the effect.
		- min-value: 0
	- angle (numeric)
		The angle of the arc.
	- spreadAngle (numeric)
		The spread angle of the arc.
	- centreX (numeric)
		The centre of the effect in the Y direction as a proportion of the image size.
	- centreY (numeric)
		The centre of the effect in the Y direction as a proportion of the image size.
	- height (numeric)
		The height of the arc.
	- edgeAction (String)
		The action to perfomr for pixels off the image edges.
		valid values are:
		- clamp (default): Clamp pixels off the edge to the nearest edge.
		- wrap: Wrap pixels off the edge to the opposite edge.
		- zero: Treat pixels off the edge as zero
	- interpolation (String)
		The type of interpolation to perform.
		valid values are:
		- bilinear (default): Use bilinear interpolation.
		- nearest_neighbour: Use nearest-neighbour interpolation.
contour
	A filter which draws contours on an image at given brightness levels.

	Parameters:

	- levels (numeric)
	- contourColor (String)
	- offset (numeric)
	- scale (numeric)
		Specifies the scale of the contours.
		- min-value: 0
		- max-value: 1
contrast
	A filter to change the brightness and contrast of an image.

	Parameters:

	- brightness (numeric)
		The filter brightness.
		- min-value: 0
		- max-value: 0
	- contrast (numeric)
		The filter contrast.
		- min-value: 0
		- max-value: 0
	- dimensions (Array)
crop
	A filter which crops an image to a given rectangle.

	Parameters:

	- x (integer)
		The left edge of the crop rectangle.
	- y (integer)
		The top edge of the crop rectangle.
	- width (integer)
		The width of the crop rectangle.
	- height (integer)
		The height of the crop rectangle.
crystallize
	A filter which applies a crystallizing effect to an image, by producing Voronoi cells filled with colours from the image.

	Parameters:

	- edgeThickness (numeric)
	- fadeEdges (boolean)
	- edgeColor (String)
	- amount (numeric)
		The amount of effect.
		- min-value: 0
		- max-value: 1
	- turbulence (numeric)
		Specifies the turbulence of the texture.
		- min-value: 0
		- max-value: 1
	- stretch (numeric)
		Specifies the stretch factor of the texture.
		- min-value: 1
		- max-value: 50+
	- angle (numeric)
		Specifies the angle of the texture.
	- angleCoefficient (numeric)
	- gradientCoefficient (numeric)
	- colormap (Colormap)
		The colormap to be used for the filter. Use function ImageFilterColorMap to create.
	- randomness (numeric)
	- gridType (String)
		the grid type to set, one of the following:
		-  RANDOM
		-  SQUARE
		-  HEXAGONAL
		-  OCTAGONAL
		-  TRIANGULAR
	- distancePower (numeric)
	- scale (numeric)
		Specifies the scale of the texture.
		- min-value: 1
		- max-value: 300+
curl
	A page curl effect.

	Parameters:

	- radius (numeric)
	- angle (numeric)
	- transition (numeric)
	- edgeAction (String)
		The action to perfomr for pixels off the image edges.
		valid values are:
		- clamp (default): Clamp pixels off the edge to the nearest edge.
		- wrap: Wrap pixels off the edge to the opposite edge.
		- zero: Treat pixels off the edge as zero
	- interpolation (String)
		The type of interpolation to perform.
		valid values are:
		- bilinear (default): Use bilinear interpolation.
		- nearest_neighbour: Use nearest-neighbour interpolation.
despeckle
	A filter which removes noise from an image using a "pepper and salt" algorithm.

	Parameters:
diffuse
	This filter diffuses an image by moving its pixels in random directions.

	Parameters:

	- scale (numeric)
		Specifies the scale of the texture.
		- min-value: 1
		- max-value: 100+
	- edgeAction (String)
		The action to perfomr for pixels off the image edges.
		valid values are:
		- clamp (default): Clamp pixels off the edge to the nearest edge.
		- wrap: Wrap pixels off the edge to the opposite edge.
		- zero: Treat pixels off the edge as zero
	- interpolation (String)
		The type of interpolation to perform.
		valid values are:
		- bilinear (default): Use bilinear interpolation.
		- nearest_neighbour: Use nearest-neighbour interpolation.
diffusion
	A filter which uses Floyd-Steinberg error diffusion dithering to halftone an image.

	Parameters:

	- levels (integer)
		The number of dither levels.
	- serpentine (boolean)
		Set whether to use a serpentine pattern for return or not. This can reduce 'avalanche' artifacts in the output.
	- colorDither (boolean)
		Set whether to use a color dither.
dilate
	Given a binary image, this filter performs binary dilation, setting all added pixels to the given 'new' color.

	Parameters:

	- threshold (integer)
		The threshold - the number of neighbouring pixels for dilation to occur.
	- iterations (integer)
		The number of iterations the effect is performed.
		- min-value: 0
	- colormap (Colormap)
		The colormap to be used for the filter. Use function ImageFilterColorMap to create.
	- newColor (String)
displace
	A filter which simulates the appearance of looking through glass. A separate grayscale displacement image is provided and
	pixels in the source image are displaced according to the gradient of the displacement map.

	Parameters:

	- amount (numeric)
		The amount of distortion.
		- min-value: 0
		- max-value: 1
	- displacementMap (Image)
		The displacement map.
	- edgeAction (String)
		The action to perfomr for pixels off the image edges.
		valid values are:
		- clamp (default): Clamp pixels off the edge to the nearest edge.
		- wrap: Wrap pixels off the edge to the opposite edge.
		- zero: Treat pixels off the edge as zero
	- interpolation (String)
		The type of interpolation to perform.
		valid values are:
		- bilinear (default): Use bilinear interpolation.
		- nearest_neighbour: Use nearest-neighbour interpolation.
dissolve
	A filter which "dissolves" an image by thresholding the alpha channel with random numbers.

	Parameters:

	- density (numeric)
		The density of the image in the range 0..1.
		- min-value: 0
		- max-value: 1
	- softness (numeric)
		The softness of the dissolve in the range 0..1.
		- min-value: 0
		- max-value: 1
	- dimensions (Array)
dither
	A filter which performs ordered dithering on an image.

	Parameters:

	- levels (integer)
		The number of dither levels.
	- colorDither (boolean)
		Set whether to use a color dither.
	- dimensions (Array)
edge
	An edge-detection filter.

	Parameters:
emboss
	A class to emboss an image.

	Parameters:

	- bumpHeight (numeric)
	- azimuth (numeric)
	- elevation (numeric)
	- emboss (boolean)
equalize
	A filter to perform auto-equalization on an image.

	Parameters:
erode
	Given a binary image, this filter performs binary erosion, setting all removed pixels to the given 'new' color.

	Parameters:

	- threshold (integer)
		The threshold - the number of neighbouring pixels for dilation to occur.
	- iterations (integer)
		The number of iterations the effect is performed.
		- min-value: 0
	- colormap (Colormap)
		The colormap to be used for the filter. Use function ImageFilterColorMap to create.
	- newColor (String)
exposure
	A filter which changes the exposure of an image.

	Parameters:

	- exposure (numeric)
		The exposure level.
		- min-value: 0
		- max-value: 5+
	- dimensions (Array)
fade
	An abstract superclass for point filters. The interface is the same as the old RGBImageFilter.

	Parameters:

	- angle (numeric)
		Specifies the angle of the texture.
	- sides (integer)
	- fadeStart (numeric)
	- fadeWidth (numeric)
	- invert (boolean)
	- dimensions (Array)
feedback
	A filter which priduces a video feedback effect by repeated transformations.

	Parameters:

	- iterations (integer)
		The number of iterations.
		- min-value: 0
	- angle (numeric)
		Specifies the angle of each iteration.
	- centreX (numeric)
		The centre of the effect in the X direction as a proportion of the image size.
	- centreY (numeric)
		The centre of the effect in the Y direction as a proportion of the image size.
	- distance (numeric)
		Specifies the distance to move on each iteration.
	- rotation (numeric)
		Specifies the amount of rotation on each iteration.
	- zoom (numeric)
		Specifies the amount to scale on each iteration.
	- startAlpha (numeric)
		The alpha value at the first iteration.
		- min-value: 0
		- max-value: 1
	- endAlpha (numeric)
		The alpha value at the last iteration.
		- min-value: 0
		- max-value: 1
fill
	A filter which fills an image with a given color. Normally you would just call Graphics.fillRect but it can sometimes be useful
	to go via a filter to fit in with an existing API.

	Parameters:

	- fillColor (String)
		The fill color.
	- dimensions (Array)
flare
	An experimental filter for rendering lens flares.

	Parameters:

	- radius (numeric)
		The radius of the effect.
		- min-value: 0
	- centreX (numeric)
	- centreY (numeric)
	- ringWidth (numeric)
	- baseAmount (numeric)
	- ringAmount (numeric)
	- rayAmount (numeric)
	- color (String)
	- dimensions (Array)
flip
	A filter which flips images or rotates by multiples of 90 degrees.

	Parameters:

	- operation (integer)
		The filter operation.
gain
	A filter which changes the gain and bias of an image - similar to ContrastFilter.

	Parameters:

	- gain (numeric)
		The gain.
		- min-value:: 0
		- max-value:: 1
	- bias (numeric)
		The bias.
		- min-value:: 0
		- max-value:: 1
	- dimensions (Array)
gamma
	A filter for changing the gamma of an image.

	Parameters:

	- gamma (numeric)
		The gamma levels.
	- dimensions (Array)
gaussian
	A filter which applies Gaussian blur to an image. This is a subclass of ConvolveFilter
	which simply creates a kernel with a Gaussian distribution for blurring.

	Parameters:

	- radius (numeric)
		The radius of the kernel, and hence the amount of blur. The bigger the radius, the longer this filter will take.
		- min-value: 0
		- max-value: 100+
	- edgeAction (String)
		The action to perfomr for pixels off the image edges.
		valid values are:
		- clamp (default): Clamp pixels off the edge to the nearest edge.
		- wrap: Wrap pixels off the edge to the opposite edge.
		- zero: Treat pixels off the edge as zero
	- useAlpha (boolean)
		Set whether to convolve the alpha channel.
	- premultiplyAlpha (boolean)
		Set whether to premultiply the alpha channel.
glint
	A filter which renders "glints" on bright parts of the image.

	Parameters:

	- amount (numeric)
		The amount of glint.
		- min-value: 0
		- max-value: 1
	- colormap (Colormap)
		The colormap to be used for the filter. Use function ImageFilterColorMap to create.
	- blur (numeric)
		The blur that is applied before thresholding.
	- glintOnly (boolean)
		Set whether to render the stars and the image or only the stars.
	- length (integer)
		The length of the stars.
	- threshold (numeric)
		The threshold value.
glow
	A filter which adds Gaussian blur to an image, producing a glowing effect.

	Parameters:

	- amount (numeric)
		The amount of glow.
		- min-value: 0
		- max-value: 1
	- radius (numeric)
		The radius of the kernel, and hence the amount of blur. The bigger the radius, the longer this filter will take.
		- min-value: 0
		- max-value: 100+
	- edgeAction (String)
		The action to perfomr for pixels off the image edges.
		valid values are:
		- clamp (default): Clamp pixels off the edge to the nearest edge.
		- wrap: Wrap pixels off the edge to the opposite edge.
		- zero: Treat pixels off the edge as zero
	- useAlpha (boolean)
		Set whether to convolve the alpha channel.
	- premultiplyAlpha (boolean)
		Set whether to premultiply the alpha channel.
gradient
	A filter which draws a coloured gradient. This is largely superceded by GradientPaint in Java1.2, but does provide a few
	more gradient options.

	Parameters:

	- interpolation (integer)
	- angle (numeric)
		Specifies the angle of the texture.
	- colormap (Colormap)
		The colormap to be used for the filter. Use function ImageFilterColorMap to create.
	- point1 (String)
		 Use the following format [X-coordinate,Y-coordinate]; Example: "13,20"
	- point2 (String)
		 Use the following format [X-coordinate,Y-coordinate]; Example: "13,20"
	- paintMode (integer)
	- type (integer)
gray
	A filter which 'grays out' an image by averaging each pixel with white.

	Parameters:

	- dimensions (Array)
grayscale
	A filter which converts an image to grayscale using the NTSC brightness calculation.

	Parameters:

	- dimensions (Array)
halftone
	A filter which can be used to produce wipes by transferring the luma of a mask image into the alpha channel of the source.

	Parameters:

	- density (numeric)
		The density of the image in the range 0..1.
		*arg density The density
	- softness (numeric)
		The softness of the effect in the range 0..1.
		- min-value: 0
		- max-value: 1
	- invert (boolean)
	- mask (Image)
interpolate
	A filter which interpolates between two images. You can set the interpolation factor outside the range 0 to 1
	to extrapolate images.

	Parameters:

	- destination (Image)
		The destination image.
	- interpolation (numeric)
		The interpolation factor.
invert
	A filter which inverts the RGB channels of an image.

	Parameters:

	- dimensions (Array)
kaleidoscope
	A Filter which produces the effect of looking into a kaleidoscope.

	Parameters:

	- radius (numeric)
		The radius of the effect.
		- min-value: 0
	- angle (numeric)
		The angle of the kaleidoscope.
	- centreX (numeric)
		The centre of the effect in the X direction as a proportion of the image size.
	- centreY (numeric)
		The centre of the effect in the Y direction as a proportion of the image size.
	- sides (integer)
		The number of sides of the kaleidoscope.
		- min-value: 2
	- angle2 (numeric)
		The secondary angle of the kaleidoscope.
	- edgeAction (String)
		The action to perfomr for pixels off the image edges.
		valid values are:
		- clamp (default): Clamp pixels off the edge to the nearest edge.
		- wrap: Wrap pixels off the edge to the opposite edge.
		- zero: Treat pixels off the edge as zero
	- interpolation (String)
		The type of interpolation to perform.
		valid values are:
		- bilinear (default): Use bilinear interpolation.
		- nearest_neighbour: Use nearest-neighbour interpolation.
levels
	A filter which allows levels adjustment on an image.

	Parameters:

	- lowLevel (numeric)
	- highLevel (numeric)
	- lowOutputLevel (numeric)
	- highOutputLevel (numeric)
life
	A filter which performs one round of the game of Life on an image.

	Parameters:

	- iterations (integer)
		The number of iterations the effect is performed.
		- min-value: 0
	- colormap (Colormap)
		The colormap to be used for the filter. Use function ImageFilterColorMap to create.
	- newColor (String)
light
	A filter which produces lighting and embossing effects.

	Parameters:

	- colorSource (String)
	- material (String)
		 Use the following format [color,opacity]; Example: "red,0.5"
	- bumpHeight (numeric)
	- bumpSoftness (numeric)
	- bumpShape (integer)
	- viewDistance (numeric)
	- bumpSource (integer)
	- diffuseColor (String)
lookup
	A filter which uses the brightness of each pixel to lookup a color from a colormap.

	Parameters:

	- colormap (Colormap)
		The colormap to be used for the filter. Use function ImageFilterColorMap to create.
	- dimensions (Array)
map
	An abstract superclass for filters which distort images in some way. The subclass only needs to override
	two methods to provide the mapping between source and destination pixels.

	Parameters:

	- edgeAction (String)
		The action to perfomr for pixels off the image edges.
		valid values are:
		- clamp (default): Clamp pixels off the edge to the nearest edge.
		- wrap: Wrap pixels off the edge to the opposite edge.
		- zero: Treat pixels off the edge as zero
	- interpolation (String)
		The type of interpolation to perform.
		valid values are:
		- bilinear (default): Use bilinear interpolation.
		- nearest_neighbour: Use nearest-neighbour interpolation.
marble
	This filter applies a marbling effect to an image, displacing pixels by random amounts.

	Parameters:

	- amount (numeric)
		The amount of effect.
		- min-value: 0
		- max-value: 1
	- turbulence (numeric)
		Specifies the turbulence of the effect.
		- min-value: 0
		- max-value: 1
	- xScale (numeric)
		The X scale of the effect.
	- yScale (numeric)
		The Y scale of the effect.
	- edgeAction (String)
		The action to perfomr for pixels off the image edges.
		valid values are:
		- clamp (default): Clamp pixels off the edge to the nearest edge.
		- wrap: Wrap pixels off the edge to the opposite edge.
		- zero: Treat pixels off the edge as zero
	- interpolation (String)
		The type of interpolation to perform.
		valid values are:
		- bilinear (default): Use bilinear interpolation.
		- nearest_neighbour: Use nearest-neighbour interpolation.
mask
	Applies a bit mask to each ARGB pixel of an image. You can use this for, say, masking out the red channel.

	Parameters:

	- mask (integer)
	- dimensions (Array)
maximum
	A filter which replcaes each pixel by the maximum of itself and its eight neightbours.

	Parameters:
median
	A filter which performs a 3x3 median operation. Useful for removing dust and noise.

	Parameters:
minimum
	A filter which replcaes each pixel by the mimimum of itself and its eight neightbours.

	Parameters:
mirror


	Parameters:

	- angle (numeric)
		Specifies the angle of the mirror.
	- centreY (numeric)
	- distance (numeric)
	- rotation (numeric)
	- gap (numeric)
	- opacity (numeric)
		The opacity of the reflection.
noise
	A filter which adds random noise into an image.

	Parameters:

	- amount (integer)
		The amount of effect.
		- min-value: 0
		- max-value: 1
	- monochrome (boolean)
		Set whether to use monochrome noise.
	- density (numeric)
		The density of the noise.
	- distribution (integer)
		The distribution of the noise.
	- dimensions (Array)
offset
	An abstract superclass for filters which distort images in some way. The subclass only needs to override
	two methods to provide the mapping between source and destination pixels.

	Parameters:

	- xOffset (integer)
	- yOffset (integer)
	- wrap (boolean)
	- edgeAction (String)
		The action to perfomr for pixels off the image edges.
		valid values are:
		- clamp (default): Clamp pixels off the edge to the nearest edge.
		- wrap: Wrap pixels off the edge to the opposite edge.
		- zero: Treat pixels off the edge as zero
	- interpolation (String)
		The type of interpolation to perform.
		valid values are:
		- bilinear (default): Use bilinear interpolation.
		- nearest_neighbour: Use nearest-neighbour interpolation.
oil
	A filter which produces a "oil-painting" effect.

	Parameters:

	- levels (integer)
		The number of levels for the effect.
	- range (integer)
		The range of the effect in pixels.
opacity
	Sets the opacity (alpha) of every pixel in an image to a constant value.

	Parameters:

	- opacity (integer)
		The opacity.
	- dimensions (Array)
outline
	Given a binary image, this filter converts it to its outline, replacing all interior pixels with the 'new' color.

	Parameters:

	- iterations (integer)
		The number of iterations the effect is performed.
		- min-value: 0
	- colormap (Colormap)
		The colormap to be used for the filter. Use function ImageFilterColorMap to create.
	- newColor (String)
perspective
	A filter which performs a perspective distortion on an image.

	Parameters:

	- xLT (numeric)
		the new horizontal position of the top left corner, negative values are translated to image-width - x.
	- yLT (numeric)
		the new vertical position of the top left corner, negative values are translated to image-height - y.
	- xRT (numeric)
		the new horizontal position of the top right corner, negative values are translated to image-width - x.
	- yRT (numeric)
		the new vertical position of the top right corner, negative values are translated to image-height - y.
	- xRB (numeric)
		the new horizontal position of the bottom right corner, negative values are translated to image-width - x.
	- yRB (numeric)
		the new vertical position of the bottom right corner, negative values are translated to image-height - y.
	- xLB (numeric)
		the new horizontal position of the bottom left corner, negative values are translated to image-width - x.
	- yLB (numeric)
		the new vertical position of the bottom left corner, negative values are translated to image-height - y.
	- edgeAction (String)
		The action to perfomr for pixels off the image edges.
		valid values are:
		- clamp (default): Clamp pixels off the edge to the nearest edge.
		- wrap: Wrap pixels off the edge to the opposite edge.
		- zero: Treat pixels off the edge as zero
	- interpolation (String)
		The type of interpolation to perform.
		valid values are:
		- bilinear (default): Use bilinear interpolation.
		- nearest_neighbour: Use nearest-neighbour interpolation.
pinch
	A filter which performs the popular whirl-and-pinch distortion effect.

	Parameters:

	- radius (numeric)
		The radius of the effect.
		- min-value: 0
	- amount (numeric)
		The amount of pinch.
		- min-value: -1
		- max-value: 1
	- angle (numeric)
		The angle of twirl in radians. 0 means no distortion.
	- centreX (numeric)
		The centre of the effect in the X direction as a proportion of the image size.
	- centreY (numeric)
		The centre of the effect in the Y direction as a proportion of the image size.
	- edgeAction (String)
		The action to perfomr for pixels off the image edges.
		valid values are:
		- clamp (default): Clamp pixels off the edge to the nearest edge.
		- wrap: Wrap pixels off the edge to the opposite edge.
		- zero: Treat pixels off the edge as zero
	- interpolation (String)
		The type of interpolation to perform.
		valid values are:
		- bilinear (default): Use bilinear interpolation.
		- nearest_neighbour: Use nearest-neighbour interpolation.
plasma
	A filter which acts as a superclass for filters which need to have the whole image in memory
	to do their stuff.

	Parameters:

	- turbulence (numeric)
		Specifies the turbulence of the texture.
		- min-value: 0
		- max-value: 10
	- colormap (Colormap)
		The colormap to be used for the filter. Use function ImageFilterColorMap to create.
	- scaling (numeric)
	- useColormap (boolean)
	- useImageColors (boolean)
	- seed (integer)
pointillize
	A filter which produces an image with a cellular texture.

	Parameters:

	- fuzziness (numeric)
	- edgeThickness (numeric)
	- fadeEdges (boolean)
	- edgeColor (String)
	- amount (numeric)
		The amount of effect.
		- min-value: 0
		- max-value: 1
	- turbulence (numeric)
		Specifies the turbulence of the texture.
		- min-value: 0
		- max-value: 1
	- stretch (numeric)
		Specifies the stretch factor of the texture.
		- min-value: 1
		- max-value: 50+
	- angle (numeric)
		Specifies the angle of the texture.
	- angleCoefficient (numeric)
	- gradientCoefficient (numeric)
	- colormap (Colormap)
		The colormap to be used for the filter. Use function ImageFilterColorMap to create.
	- randomness (numeric)
	- gridType (String)
		the grid type to set, one of the following:
		-  RANDOM
		-  SQUARE
		-  HEXAGONAL
		-  OCTAGONAL
		-  TRIANGULAR
	- distancePower (numeric)
	- scale (numeric)
		Specifies the scale of the texture.
		- min-value: 1
		- max-value: 300+
polar
	A filter which distorts and image by performing coordinate conversions between rectangular and polar coordinates.

	Parameters:

	- type (String)
		The distortion type, valid values are
		- RECT_TO_POLAR = Convert from rectangular to polar coordinates
		- POLAR_TO_RECT = Convert from polar to rectangular coordinates
		- INVERT_IN_CIRCLE = Invert the image in a circle
	- edgeAction (String)
		The action to perfomr for pixels off the image edges.
		valid values are:
		- clamp (default): Clamp pixels off the edge to the nearest edge.
		- wrap: Wrap pixels off the edge to the opposite edge.
		- zero: Treat pixels off the edge as zero
	- interpolation (String)
		The type of interpolation to perform.
		valid values are:
		- bilinear (default): Use bilinear interpolation.
		- nearest_neighbour: Use nearest-neighbour interpolation.
posterize
	A filter to posterize an image.

	Parameters:

	- numLevels (integer)
		The number of levels in the output image.
	- dimensions (Array)
quantize
	A filter which quantizes an image to a set number of colors - useful for producing
	images which are to be encoded using an index color model. The filter can perform
	Floyd-Steinberg error-diffusion dithering if required. At present, the quantization
	is done using an octtree algorithm but I eventually hope to add more quantization
	methods such as median cut. Note: at present, the filter produces an image which
	uses the RGB color model (because the application it was written for required it).
	I hope to extend it to produce an IndexColorModel by request.

	Parameters:

	- serpentine (boolean)
		Set whether to use a serpentine pattern for return or not. This can reduce 'avalanche' artifacts in the output.
	- numColors (String)
		The number of colors to quantize to.
	- dither (boolean)
		Set whether to use dithering or not. If not, the image is posterized.
quilt
	A filter which acts as a superclass for filters which need to have the whole image in memory
	to do their stuff.

	Parameters:

	- iterations (integer)
		The number of iterations the effect is performed.
		- min-value: 0
	- colormap (Colormap)
		The colormap to be used for the filter. Use function ImageFilterColorMap to create.
	- a (numeric)
	- b (numeric)
	- c (numeric)
	- d (numeric)
	- k (integer)
rays
	A filter which produces the effect of light rays shining out of an image.

	Parameters:

	- colormap (Colormap)
		The colormap to be used for the filter. Use function ImageFilterColorMap to create.
	- strength (numeric)
		The strength of the rays.
	- opacity (numeric)
		The opacity of the rays.
	- raysOnly (boolean)
		Set whether to render only the rays.
	- threshold (numeric)
		The threshold value.
	- angle (numeric)
	- centreX (numeric)
	- centreY (numeric)
	- distance (numeric)
	- rotation (numeric)
	- zoom (numeric)
rescale
	A filter which simply multiplies pixel values by a given scale factor.

	Parameters:

	- scale (numeric)
		Specifies the scale factor.
		- min-value: 1
		- max-value: 5+
	- dimensions (Array)
ripple
	A filter which distorts an image by rippling it in the X or Y directions.
	The amplitude and wavelength of rippling can be specified as well as whether
	pixels going off the edges are wrapped or not.

	Parameters:

	- xAmplitude (numeric)
		The amplitude of ripple in the X direction.
	- xWavelength (numeric)
		The wavelength of ripple in the X direction.
	- yAmplitude (numeric)
		The amplitude of ripple in the Y direction.
	- yWavelength (numeric)
		The wavelength of ripple in the Y direction.
	- waveType (String)
		The wave type.
		valid values are:
		- sine (default):  Sine wave ripples.
		- sawtooth: Sawtooth wave ripples.
		- triangle: Triangle wave ripples.
		- noise: Noise ripples.
	- edgeAction (String)
		The action to perfomr for pixels off the image edges.
		valid values are:
		- clamp (default): Clamp pixels off the edge to the nearest edge.
		- wrap: Wrap pixels off the edge to the opposite edge.
		- zero: Treat pixels off the edge as zero
	- interpolation (String)
		The type of interpolation to perform.
		valid values are:
		- bilinear (default): Use bilinear interpolation.
		- nearest_neighbour: Use nearest-neighbour interpolation.
rotate
	A filter which rotates an image. These days this is easier done with Java2D, but this filter remains.

	Parameters:

	- angle (numeric)
		Specifies the angle of rotation.
	- edgeAction (String)
		The action to perfomr for pixels off the image edges.
		valid values are:
		- clamp (default): Clamp pixels off the edge to the nearest edge.
		- wrap: Wrap pixels off the edge to the opposite edge.
		- zero: Treat pixels off the edge as zero
	- interpolation (String)
		The type of interpolation to perform.
		valid values are:
		- bilinear (default): Use bilinear interpolation.
		- nearest_neighbour: Use nearest-neighbour interpolation.
saturation
	A filter to change the saturation of an image. This works by calculating a grayscale version of the image
	and then extrapolating away from it.

	Parameters:

	- amount (numeric)
		The amount of saturation change. 1 leaves the image unchanged, values between 0 and 1 desaturate, 0 completely
		desaturates it and values above 1 increase the saturation.
	- dimensions (Array)
scale
	Scales an image using the area-averaging algorithm, which can't be done with AffineTransformOp.

	Parameters:

	- width (integer)
	- height (integer)
scratch


	Parameters:

	- angle (numeric)
	- density (numeric)
	- angleVariation (numeric)
	- length (numeric)
	- seed (integer)
	- color (String)
	- width (numeric)
shade
	A filter which acts as a superclass for filters which need to have the whole image in memory
	to do their stuff.

	Parameters:

	- bumpHeight (numeric)
	- bumpSoftness (numeric)
	- bumpSource (integer)
shadow
	A filter which draws a drop shadow based on the alpha channel of the image.

	Parameters:

	- radius (numeric)
		The radius of the kernel, and hence the amount of blur. The bigger the radius, the longer this filter will take.
	- angle (numeric)
		Specifies the angle of the shadow.
	- distance (numeric)
		The distance of the shadow.
	- opacity (numeric)
		The opacity of the shadow.
	- shadowColor (String)
		The color of the shadow.
	- addMargins (boolean)
		Set whether to increase the size of the output image to accomodate the shadow.
	- shadowOnly (boolean)
		Set whether to only draw the shadow without the original image.
shape
	A filter which acts as a superclass for filters which need to have the whole image in memory
	to do their stuff.

	Parameters:

	- useAlpha (boolean)
	- colormap (Colormap)
		The colormap to be used for the filter. Use function ImageFilterColorMap to create.
	- invert (boolean)
	- factor (numeric)
	- merge (boolean)
	- type (integer)
sharpen
	A filter which performs a simple 3x3 sharpening operation.

	Parameters:

	- edgeAction (String)
		The action to perfomr for pixels off the image edges.
		valid values are:
		- clamp (default): Clamp pixels off the edge to the nearest edge.
		- wrap: Wrap pixels off the edge to the opposite edge.
		- zero: Treat pixels off the edge as zero
	- useAlpha (boolean)
		Set whether to convolve the alpha channel.
	- premultiplyAlpha (boolean)
		Set whether to premultiply the alpha channel.
shatter


	Parameters:

	- iterations (integer)
	- centreX (numeric)
	- centreY (numeric)
	- transition (numeric)
	- distance (numeric)
	- rotation (numeric)
	- zoom (numeric)
	- startAlpha (numeric)
	- endAlpha (numeric)
	- tile (integer)
shear
	An abstract superclass for filters which distort images in some way. The subclass only needs to override
	two methods to provide the mapping between source and destination pixels.

	Parameters:

	- resize (boolean)
	- xAngle (numeric)
	- yAngle (numeric)
	- edgeAction (String)
		The action to perfomr for pixels off the image edges.
		valid values are:
		- clamp (default): Clamp pixels off the edge to the nearest edge.
		- wrap: Wrap pixels off the edge to the opposite edge.
		- zero: Treat pixels off the edge as zero
	- interpolation (String)
		The type of interpolation to perform.
		valid values are:
		- bilinear (default): Use bilinear interpolation.
		- nearest_neighbour: Use nearest-neighbour interpolation.
shine
	A filter which simply multiplies pixel values by a given scale factor.

	Parameters:

	- radius (numeric)
		The radius of the kernel, and hence the amount of blur. The bigger the radius, the longer this filter will take.
	- brightness (numeric)
	- angle (numeric)
	- softness (numeric)
	- distance (numeric)
	- shadowOnly (boolean)
	- bevel (numeric)
	- shineColor (String)
skeleton
	A filter which reduces a binary image to a skeleton.
	Based on an algorithm by Zhang and Suen (CACM, March 1984, 236-239).

	Parameters:

	- iterations (integer)
		The number of iterations the effect is performed.
		- min-value: 0
	- colormap (Colormap)
		The colormap to be used for the filter. Use function ImageFilterColorMap to create.
	- newColor (String)
smear
	A filter which acts as a superclass for filters which need to have the whole image in memory
	to do their stuff.

	Parameters:

	- angle (numeric)
		Specifies the angle of the texture.
	- density (numeric)
	- distance (integer)
	- shape (integer)
	- scatter (numeric)
	- mix (numeric)
	- fadeout (integer)
	- background (boolean)
solarize
	A filter which solarizes an image.

	Parameters:

	- dimensions (Array)
sparkle
	An abstract superclass for point filters. The interface is the same as the old RGBImageFilter.

	Parameters:

	- radius (integer)
		The radius of the effect.
		- min-value: 0
	- amount (integer)
		The amount of sparkle.
		- min-value: 0
		- max-value: 1
	- randomness (integer)
	- rays (integer)
	- color (String)
	- dimensions (Array)
sphere
	A filter which simulates a lens placed over an image.

	Parameters:

	- radius (numeric)
		The radius of the effect.
		- min-value: 0
	- centreX (numeric)
		The centre of the effect in the X direction as a proportion of the image size.
	- centreY (numeric)
		The centre of the effect in the Y direction as a proportion of the image size.
	- refractionIndex (numeric)
		The index of refaction.
	- edgeAction (String)
		The action to perfomr for pixels off the image edges.
		valid values are:
		- clamp (default): Clamp pixels off the edge to the nearest edge.
		- wrap: Wrap pixels off the edge to the opposite edge.
		- zero: Treat pixels off the edge as zero
	- interpolation (String)
		The type of interpolation to perform.
		valid values are:
		- bilinear (default): Use bilinear interpolation.
		- nearest_neighbour: Use nearest-neighbour interpolation.
stamp
	A filter which produces a rubber-stamp type of effect by performing a thresholded blur.

	Parameters:

	- radius (numeric)
		The radius of the effect.
		- min-value: 0
	- softness (numeric)
		The softness of the effect in the range 0..1.
		- min-value: 0
		- max-value: 1
	- white (String)
		The color to be used for pixels above the upper threshold.
	- black (String)
		The color to be used for pixels below the lower threshold.
	- threshold (numeric)
		The threshold value.
	- dimensions (Array)
swim
	A filter which distorts an image as if it were underwater.

	Parameters:

	- amount (numeric)
		The amount of swim.
		- min-value: 0
		- max-value: 100+
	- turbulence (numeric)
		Specifies the turbulence of the texture.
		- min-value: 0
		- max-value: 1
	- stretch (numeric)
		Specifies the stretch factor of the distortion.
		- min-value: 1
		- max-value: 50+
	- angle (numeric)
		Specifies the angle of the effect.
	- time (numeric)
		Specifies the time. Use this to animate the effect.
	- scale (numeric)
		Specifies the scale of the distortion.
		- min-value: 1
		- max-value: 300+
	- edgeAction (String)
		The action to perfomr for pixels off the image edges.
		valid values are:
		- clamp (default): Clamp pixels off the edge to the nearest edge.
		- wrap: Wrap pixels off the edge to the opposite edge.
		- zero: Treat pixels off the edge as zero
	- interpolation (String)
		The type of interpolation to perform.
		valid values are:
		- bilinear (default): Use bilinear interpolation.
		- nearest_neighbour: Use nearest-neighbour interpolation.
texture
	An abstract superclass for point filters. The interface is the same as the old RGBImageFilter.

	Parameters:

	- amount (numeric)
		The amount of texture.
		- min-value: 0
		- max-value: 1
	- turbulence (numeric)
		Specifies the turbulence of the texture.
		- min-value: 0
		- max-value: 1
	- stretch (numeric)
		Specifies the stretch factor of the texture.
		- min-value: 1
		- max-value: 50+
	- angle (numeric)
		Specifies the angle of the texture.
	- colormap (Colormap)
		The colormap to be used for the filter. Use function ImageFilterColorMap to create.
	- operation (integer)
	- scale (numeric)
		Specifies the scale of the texture.
		- min-value: 1
		- max-value: 300+
	- dimensions (Array)
threshold
	A filter which performs a threshold operation on an image.

	Parameters:

	- white (integer)
		The color to be used for pixels above the upper threshold.
	- black (integer)
		The color to be used for pixels below the lower threshold.
	- lowerThreshold (integer)
		The lower threshold value.
	- upperThreshold (integer)
		The upper threshold value.
	- dimensions (Array)
twirl
	A Filter which distorts an image by twisting it from the centre out.
	The twisting is centred at the centre of the image and extends out to the smallest of
	the width and height. Pixels outside this radius are unaffected.

	Parameters:

	- radius (numeric)
		The radius of the effect.
		- min-value: 0
	- angle (numeric)
		The angle of twirl in radians. 0 means no distortion.
	- centreX (numeric)
		The centre of the effect in the X direction as a proportion of the image size.
	- centreY (numeric)
		The centre of the effect in the Y direction as a proportion of the image size.
	- edgeAction (String)
		The action to perfomr for pixels off the image edges.
		valid values are:
		- clamp (default): Clamp pixels off the edge to the nearest edge.
		- wrap: Wrap pixels off the edge to the opposite edge.
		- zero: Treat pixels off the edge as zero
	- interpolation (String)
		The type of interpolation to perform.
		valid values are:
		- bilinear (default): Use bilinear interpolation.
		- nearest_neighbour: Use nearest-neighbour interpolation.
unsharp
	A filter which subtracts Gaussian blur from an image, sharpening it.

	Parameters:

	- amount (numeric)
		The amount of sharpening.
		- min-value: 0
		- max-value: 1
	- threshold (integer)
		The threshold value.
	- radius (numeric)
		The radius of the kernel, and hence the amount of blur. The bigger the radius, the longer this filter will take.
		- min-value: 0
		- max-value: 100+
	- edgeAction (String)
		The action to perfomr for pixels off the image edges.
		valid values are:
		- clamp (default): Clamp pixels off the edge to the nearest edge.
		- wrap: Wrap pixels off the edge to the opposite edge.
		- zero: Treat pixels off the edge as zero
	- useAlpha (boolean)
		Set whether to convolve the alpha channel.
	- premultiplyAlpha (boolean)
		Set whether to premultiply the alpha channel.
water
	A filter which produces a water ripple distortion.

	Parameters:

	- radius (numeric)
		The radius of the effect.
		- min-value: 0
	- centreX (numeric)
		The centre of the effect in the X direction as a proportion of the image size.
	- centreY (numeric)
		The centre of the effect in the Y direction as a proportion of the image size.
	- wavelength (numeric)
		The wavelength of the ripples.
	- amplitude (numeric)
		The amplitude of the ripples.
	- phase (numeric)
		The phase of the ripples.
	- edgeAction (String)
		The action to perfomr for pixels off the image edges.
		valid values are:
		- clamp (default): Clamp pixels off the edge to the nearest edge.
		- wrap: Wrap pixels off the edge to the opposite edge.
		- zero: Treat pixels off the edge as zero
	- interpolation (String)
		The type of interpolation to perform.
		valid values are:
		- bilinear (default): Use bilinear interpolation.
		- nearest_neighbour: Use nearest-neighbour interpolation.
weave
	An abstract superclass for point filters. The interface is the same as the old RGBImageFilter.

	Parameters:

	- useImageColors (boolean)
	- xGap (numeric)
	- xWidth (numeric)
	- yWidth (numeric)
	- yGap (numeric)
	- crossings ([[I)
	- roundThreads (boolean)
	- shadeCrossings (boolean)
	- dimensions (Array)
wood
	A filter which produces a simulated wood texture. This is a bit of a hack, but might be usefult to some people.

	Parameters:

	- turbulence (numeric)
		Specifies the turbulence of the texture.
		- min-value: 0
		- max-value: 1
	- stretch (numeric)
		Specifies the stretch factor of the texture.
		- min-value: 1
		- max-value: 50+
	- angle (numeric)
		Specifies the angle of the texture.
	- colormap (Colormap)
		The colormap to be used for the filter. Use function ImageFilterColorMap to create.
	- gain (numeric)
		Specifies the gain of the texture.
		- min-value: 0
		- max-value: 1
	- rings (numeric)
		Specifies the rings value.
		- min-value: 0
		- max-value: 1
	- fibres (numeric)
		Specifies the amount of fibres in the texture.
		- min-value: 0
		- max-value: 1
	- scale (numeric)
		Specifies the scale of the texture.
		- min-value: 1
		- max-value: 300+
	- dimensions (Array)