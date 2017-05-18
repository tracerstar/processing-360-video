# Processing 360 video output

A series of examples showing how to use a cubemap and GLSL shader to output an equirectangular image that can be captured to create mono & 3D 360 videos.

### UPDATE:

Adding in an example of top/bottom 3D sterescoping rendering. This is largely a port of Kite & Lightning's Unreal Engine plugin, modified to work with Processing. Also, read [Paul Bourke's writings][pbLink] on the subject. It's invaluable information. I wouldn't have gotten this far without it. 

### Source

Taking the Dome Sphere Projection example code from the Processing app, it was modified to render the Cube Map to have 6 textures. The dome projection shaders were removed, and an [equirectangular shader][shader] by [user BeRo][berolink] added to convert the cubemap to an equirectangular image suitable for use in 360 video.

### Example videos
- [https://www.youtube.com/watch?v=7HEyj7Mjoq4]
- [https://www.youtube.com/watch?v=EbMCDnFhE_w]
- [https://www.youtube.com/watch?v=AHRJxdK-obA]

### Usage
- Place all objects that are to be drawn to screen in the drawScene() method
- Put any animation update variables in the animationPreUpdate() or animationPostUpdate() methods
- Render the sketch as a sequence of png / tif frames
- Import the frames into Premier (or similar video editor) to create a video sequence
- Export the video
- Use the [YouTube 360][YT360] meta injector to add the 360 meta to your video
- Ensure the resulting video has "_360" at the end of the filename for it to work with Gear VR, 'filename_360.mp4' for example. 

### To do
- Add settings for NEAREST/LINEAR/LINEAR_MIPMAP_LINEAR texture filter
- Add camera control

### Know issues

When saving frames, these sketches run slow. Between 2 and 5 fps slow. The goal isn't really to get it running in realtime, but having a way to export Procesing sketches as frames for a 360 video. That said, when not saving frames, it runs fine depending on hardware and how much you're drawing to the screen (anywhere between 30 and 60 fps in tests I've done).

[YT360]: <https://support.google.com/youtube/answer/6178631?hl=en>
[shader]: <https://www.shadertoy.com/view/XsBSDR#>
[berolink]: <https://www.shadertoy.com/user/BeRo>
[pbLink]: <http://paulbourke.net/stereographics/stereopanoramic/>