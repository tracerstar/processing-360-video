# Processing 360 video output

A series of examples showing how to use a cubemap and GLSL shader to output an equirectangular image that can be captured to create 360 videos.

### Source

Taking the Dome Sphere Projection example code from the Processing app, it was modified to render the Cube Map to have 6 textures. The dome projection shaders were removed, and an [equirectangular shader] [shader] by [user BeRo] [berolink] added to convert the cubemap to an equirectangular image suitable for use in 360 video.

### Usage
- Place all objects that are to be drawn to screen in the drawScene() method
- Put any animation update variables in the animationPreUpdate() or animationPostUpdate() methods
- Render the sketch as a sequence of png / tif frames
- Import the frames into Premier (or similar video editor) to create a video sequence
- Export the video
- Use the [YouTube 360] [YT360] meta injector to add the 360 meta to your video
- Ensure the resulting video has "_360" at the end of the filename for it to work with Gear VR, 'filename_360.mp4' for example. 

### To do
- Add settings for NEAREST/LINEAR/LINEAR_MIPMAP_LINEAR texture filter
- Add camera control

[YT360]: <https://support.google.com/youtube/answer/6178631?hl=en>
[shader]: <https://www.shadertoy.com/view/XsBSDR#>
[berolink]: <https://www.shadertoy.com/user/BeRo>