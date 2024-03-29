Jan. 2020 workshop on the architecture of GlowScript VPython: 

[![Jan. 2020 Workshop](https://img.youtube.com/vi/lV_q3UqjsGA/0.jpg)](https://www.youtube.com/watch?v=lV_q3UqjsGA)

[A pdf of the slides including the tasks carried out by the participants](https://github.com/vpython/glowscript/blob/master/docs/GlowScriptArchitecture%20.pdf)

[A case study video: adding a new feature to VPython](https://www.youtube.com/watch?v=9igLky5crY8) presented by Bruce Sherwood to his colleagues Aaron Titus and Steve Spicklemire. It should have been mentioned that "attach_light" needed to be included in the exports at the end of the file primitives.js.
   
[How to install the GlowScript software locally](https://www.glowscript.org/docs/GlowScriptDocs/local.html) so as to be able to experiment with changing the code, as did the participants in the workshop.
   
## THE ELEMENTS OF THE GLOWSCRIPT LIBRARY

See www.glowscript.org/docs/GlowScriptDocs/local.html for instructions on
how to install software to be able to make and test changes to GlowScript VPython.

When testing locally, you may need to change the port number 8080 in
      `ide/api.py` and `untrusted/run.js`.

If you will upload to a site other than glowscript.org, you need to change the name of 
the application in `app.yaml`, and at the start of `ide/ide.js`, `ide/api.py`, and `untrusted/run.js`


### COMPILATION

The main compilation program is `lib/compiling/GScompiler.js`. Additional comments
on GScompiler.js are included in the file itself. Also, at the start of the file
are instructions on how to obtain others' libraries, such as RapydScript-NG.

Triggered by a "Run" event in `ide/index.html`, the sandboxed `untrusted/run.js` calls
the appropriate compiler and run-time package corresponding to the version number
specified in the first line of the user program (e.g. GlowScript 2.7 VPython).

#### FIRST PASS
- Parse each line into indent plus substance plus inline comment, removing trailing spaces.
- During first pass accumulate a list of functions, fcts.
- Watch for and report location of unbalanced `()`, `[]`, `{}`, `'`, `"`, `'''`, `"""`.
- Replace `delete` with `remove`, as `delete` is a JavaScript reserved word.
- Parse import statements, including making list of objects imported.
    - Except for vpython, the Python `random` library is currently the only Python library 
    that can be imported thanks to a JavaScript implementation by RapydScript-NG.
    The `random` library is not complete but contains `seed_state`, `get_random_byte`, `seed`,
    `random`, `randrange`, `randint`, `uniform`, `choice`, `shuffle`, and `sample`.
- Look for function declarations and function calls that are outside strings.
    - If inside a string, change the name to name+'~!#' so that this mention will
    not be found in a later search for "name(".
- Insert original line number as a statement of the form `RS_ls = "line number"\n`.
- Such a statement survives later compile operations, which makes it possible (in Chrome)
    to report the original line number of an error.

#### SECOND PASS
- Pass preprocessed Python to RapydScript-NG transpiler, which produces JavaScript.
- Check for 3D text statement, in which case insert code to acquire fonts.
- Replace `.delete` with `.remove`.
- Make various other small adjustments.
- Insert preamble to transpiled JavaScript code.
- Insert statements to deal with various kinds of import statements.
- Insert statements such as `box = vp_box` so that box invokes the VPython version of a box.
- Add some `Array.prototype` functionality to mimic Python lists.
- `papercompile()` calls a library that converts `A+B` to `A['+'](B)`, which makes possible
    "operator overloading": that is, `2+3` evaluates to `5`, but `vec(1,2,3)+vec(10,20,30)`
    evaluates to `vec(11,22,33)`. In `lib/glow/vectors.js` is a set of `Number` and `vec`
    prototype methods that alter the behavior of the arithmetic operators.
- Search program for functions (listed in fcts) and prepend `async `. Change the function
    name to name+'~!#' so that this `name()` won't be found in the next step.
- Search program for function calls, prepend `await `, and put `await name()` in parens.
- Finally all occurrences of '~!#' are replaced by ''.

Now the program is ready to run. It is instructive to make a one-line program `box()` at
glowscript.org and then click "Share or export this program" to see the JavaScript program,
which includes references to run-time libraries stored at Amazon S3, which is an https site,
which makes the libraries accessible to https sites containing embedded GlowScript programs.
(Originally, glowscript.org was an http site, which an https site could not access.)
Note the sizable amount of code that comes from RapydScript-NG, as well as the preamble
generated by `GScompiler.js`. It is interesting to see the changes that result in this case:
    ```GlowScript X.Y VPython
    from vpython import box
    box()```
Also observe what is generated in these cases:
    ```GlowScript X.Y VPython
    import vpython  # or import vpython as vp
    vpython.box()   # or vp.box()```

If using (say) version 2.7, you can see the generated JavaScript program by choosing
"Share or export this program" from the edit page. However, if using an experimental
version such as 2.8dev, to see the code you need to uncomment console.log(program)
at the end of `GScompiler.js`, and when running use shift-ctrl-j to see console output.

---------------------------------------------
### EXECUTION

- `untrusted/run.js` starts the compiled-to-JavaScript program.
- A timeout of 2 seconds is set to capture a screenshot if one doesn't already exist.
- The resulting thumbnail image is displayed in the user folder display.
- This file also contains the error reporting machinery.


#### The Canvas

At the start of execution, a 3D canvas named "scene" is set up by code in `lib/glow/canvas.js`
but not yet activated, with a transparent 2D canvas superimposed for use by the label object.
The canvas is not immediately activated; activation is triggered by adding an object to the canvas.

When a box or other object is made visible, either in the creation process or by changing
`obj.visible` from `false` to `true`, the handling of the visible attribute in the Primitive object,
which is in `lib/glow/primitives.js`, adds this object to `scene.__changed`, a dictionary
of objects that have been changed.

About 60 times per second, the scene is re-rendered with the current attributes of the
current objects. The main attributes (`pos`, `size`, `axis`, `color`, `up`) are maintained as 64-bit
floats because they may be used in computations. However, WebGL only accepts 32-bit floats,
so every object includes an array `__data` that contains 32-bit versions of the attributes and
which is transmitted to WebGL for every render. When rendering the scene, `scene.__changed`
dictionary is consulted to identify objects whose 32-bit `__data` array needs to be updated
from the 64-bit object data.


#### The 3D Objects

`lib/glow/primitives.js` contains the implementation of almost all of the 3D objects.
(Exceptions are the closely related text and extrusion, mostly in `lib/glow/extrude.js`.)
Search for function `box`. About 35 lines further on you'll see function `vp_box`. When
GlowScript was new, in 2011, the user language was JavaScript, which is still supported
but far less often used than Python. The box and other "JavaScript" objects have no
connection between size and axis, but the VPython definition of a box, implemented as
`vp_box`, links size and axis, in that changing the axis changes the length; there is no
such linkage with the box object. In the VPython compilation process, `box = vp_box` is
inserted at the start of the user program.

`lib/glow/property.js` contains a "property" dictionary (object literal) due to David
Scherer that states the following at the start of the file:
    
    GlowScript uses lots of javascript properties (`Object.defineProperty`) with getters and setters.
    This is an attempt to create a more declarative syntax for declaring an object with lots of properties.
    
In `primitives.js` you will see many examples of `property.declare` followed by a list of attribute
getters and setters.

Consider the (JavaScript) box object. Following `function box(args)`, `subclass(box, Primitive)`
calls a function at the top of the `primitives.js` file, which establishes a new `box` object
as inheriting from the `Primitive` class. Search for `function Primitive()` and you'll see
that it contains a large number of attributes and methods that are common to most 3D objects.
When the user program creates a `box(args)`, the `box` function returns `initObject(this, box, args)`.
The `initObject` function establishes some minimal attributes and calls `init(obj, args)`, which
processes the rest of the attributes. The `vp_box` object inherits from the `box` object. It
overrides the `size` attribute and adds some VPython-specific attributes (e.g `height` and `red`).


#### Rendering the 3D Scene

The file `lib/glow/canvas.js` contains the machinery for creating a 3D canvas in which
the browser-based WebGL graphics library displays the 3D objects.

When a canvas is activated, it calls the function `WebGLRenderer()` in `lib/glow/WebGLRenderer.js`,
which returns an object that includes a `render()` function. The first part of `WebGLRenderer()`
initializes GPU (Graphic Processor Unit) memory to contain "models" of the primitives
(box, sphere, etc.). For example, a model box consists of a 1x1x1 white cube, located with its
center at the origin, rendered as a "mesh" of 12 triangles (2 per side), with normals to these
triangles, which are used in lighting. The creation of the models is in `lib/glow/mesh.js`. 

Near the end of `WebGLRenderer.js`, calling `trigger_render()` performs a rendering of the scene. 
It also executes `window.requestAnimationFrame(trigger_render)` which asks the browser to call
`trigger_render()` again about 1/60 second from now, to render the scene again, with some
objects in the scene possibly having changed during that interval. The essentially
autonomous, repetitive rendering is what makes it possible for the scene, including
mouse interactions to rotate or zoom or pan, remains active after the end of the user
program has been reached.

The render function itself (search for `this.render`) sets up various WebGL buffers,
deals with extending trails and moving attached arrows, calls `obj.__update()` for any
objects whose attributes have changed, determines whether there any transparent objects
(which requires special treatment), and sets up the camera position and the lighting.
It then transfers to the GPU the attribute data for all the objects. It does all
of the objects of one kind (box, say) before rendering another kind of object, because
there is a lot of setup for each kind of object. In the case of scenes that contain
transparent objects, the render process involves multiple passes, called "depth peeling".

Also in `WebGLRenderer.js` is the mechanism for loading a file to be used as a texture.

At the end of `WebGLRenderer.js` is the `rate()` function that plays an essential role in
animations.


#### Vectors

The file `lib/glow/vectors.js` contains attributes and methods of vectors. Two unusual
features should be mentioned, how changes to a component of a vector are detected,
and how the operator overloading works.

Near the start of the file are defined various kinds of vectors. Attribute vectors
are associated with the vector attributes of 3D objects (their "parent"), and when
an attribute vector is changed, the parent object is marked as changed, which will
trigger at render time calling the object's `__update()` function. `axis`, `size`, and `up`
attribute vectors deal with connections among these attributes, due to the VPython
definition that axis and size affect each other, and under rotation axis and up
must be forced always to be perpendicular to each other. There is also special
treatment of individual vector components, to make sure that changing only one
component of a vector is noticed as a change.

Near the end of the file are modifications to the `Number` class and the `vector` class.
As a result of these prototype changes, `2+3`, which compiles to `2['+'](3)`, yields `5` at
run time, but `vec(1,2,3)+vec(10,20,30)`, which compiles to `vec(1,2,3)['+'](vec(10,20,30)`,
yields `vec(11,22,33)` at run time.


#### The Role of the GPU

In the shaders folder is a large number of GPU programs that are invoked in different
situations. They are of two kinds. The "vertex" shaders have the task of mapping a vertex
in 3D to a point projected onto the 2D screen. A hidden component of the GPU, the "rasterizer",
determines the location of all pixels that are inside a triangle defined by three vertex
locations projected onto the 2D screen. The "fragment" shaders set the color of each pixel, based
on the color of the object and the locations and colors of lights. The key to GPU rendering speed
is that the a large number of vertex shaders can work in parallel, and a large number of
fragment shaders can work in parallel. Also, the non-display of hidden objects is assured
because when the fragment shader stores a color into a pixel location, the "z-depth" of the
pixel is also stored in the memory. When another fragment shader attempts to store a
color into that same pixel location, the hardware ignores the attempt if the associated
z-depth is greater than that of the pixel already stored there. The shader programs are
written in a special language, OpenGL Shading Language or GLSL, somewhat similar to C++.

For the details of how transparency and mouse picking are handled in the GPU, see
    www.glowscript.org/docs/GlowScriptDocs/technical.html


### Other Matters

- Basic mouse handling is in `lib/glow/orbital_camera.js`, with additional components
and keyboard handling found in `lib/glow/canvas.js`.

- Autoscaling is implemented in `lib/glow/autoscale.js`, which includes a function to
determine the bounding box ("extent") of an object.

- `lib/glow/api_misc.js` contains `get_library()`, `read_local_file()`, `sleep()`,
string/print functions, and `fontloading()` (for the 3D text object).

- `lib/glow/graph.js` supports making 2D graphs with either the Flot library
or the Plotly library. Flot is faster than Plotly (`fast=True`, the default), but
Plotly has more features.

- `ide/ide.html` with `ide/ide.js` provide the initial and user-specific editing displays.

- `untrusted/run.html` is invoked when running a program, which runs in a separate
sandbox.glowscript.org, to prevent possible problems with malicious code.

---------------------------------------------
### THE PYTHON SERVER

glowscript.org is a Google App Engine application. It includes a Python program that
acts as the server, with the responsibility of maintaining and accessing a datastore that
contains user programs. Upon request it sends programs to the user's browser, where they
can be edited and executed. This Python program is `ide/api.py`. Also in the ide folder
is the program `index.html` and associated JavaScript program `ide.js` that constitute the
user interface. Currently Python 2.7 is used, but it will be possible in the future to
use Python 3. There is also Google work going on to permit the use of the same "ndb"
datastore methods that were used with Python 2.7, which is important for preserving
existing user data.

---------------------------------------------
### TESTING CHANGES

Until July 30, 2020, it is possible to run a test program locally by using the
graphical-interface Google App Engine launcher, but after that date it will be
necessary to launch from a terminal (command-line interface or "CLI"). The
following link describes both schemes:

    https://www.glowscript.org/docs/GlowScriptDocs/local.html

To test a new version of GlowScript, change a program header from `X.Y` to `X.Ydev` and
run the program, which will use the latest, modified code. Make another change in the code
and reload the web page to run the program with the latest changes.

To build an updated or new version, see `docs/MakingNewVersion.txt`.

Making the change from http to https for glowscript.org was sufficiently difficult that
a "maintenance" period when glowscript.org would be down was announced several days
in advance. Also, in `ide/ide.js` the variable `disable_writes` was set to `true` during
maintenance, which meant that one could still view and run programs but not change
anything. This wasn't a complete block on changes because someone currently editing a
program wasn't blocked (unless they left the editing page and returned to it).
In retrospect, this hole could be blocked in section `pages.edit` of `ide.js` by checking
`disable_writes` on every call to the `save` function instead of just at the start
of the `pages.edit` section. 

---------------------------------------------
### GLOWSCRIPT.ORG WEBSITE ISSUES

- For historical reasons, although glowscript.org currently runs on Google servers,
the domain authority is godaddy.com. It would be simpler for Google to be the
domain authority, and migrating there is worth looking into.

- The main administration of the glowscript.org Google App Engine application is
provided by Google Cloud Platform (console.cloud.google.com) and Google APIs
(console.developers.google.com). Here among much else are usage reports.

- At console.cloud.google.com, in "App Engine" click "Go to the App Engine
dashboard" to see various kinds of data about glowscript.org operation.
Again at console.cloud.google.com, click the 3 bars at the upper left
and beside "Datastore" are various options to investigate the cloud data.
For example, choose "Entities" and you can examine glowscript.org records.
Choose "User" for the Kind of record, then click `FILTER ENTITIE` and enter
`key(User,'GlowScriptDemos')`, then click `APPLY FILTERS`. You will see information
about the GlowScriptDemos login that is used for maintaining the Example
programs at glowscript.org. Note that some very old logins may contain
`%20`, which displays at glowscript.org as a space but must be entered
as `%20` when specifying a user key.

- Some rarely used aspects of administration are associated with Google Admin
(admin.google.com/glowscript.org), with access by glowscript.org administrators.
In particular, making glowscript.org and www.glowscript.org
be equivalent must be set up here, in the Domains section. Click "Domains",
then click Add/remove domains. Here you will see glowscript.org listed with
the information that glowscript.org is redirected to www.glowscript.org.

- Both Bruce Sherwood (bruce.sherwood@gmail.com) and Aaron Titus (hpuphysics.gmail.com)
are administrators of these Google and GoDaddy entities.

- At GoDaddy clicking on DNS on the main page shows you the Domain Name Server
information for glowscript.org. A screen capture of the settings is included
in the GitHub docs folder. The TXT record resulted from Google asking for that
particular record to be set up, which Google then read to verify our ownership
of glowscript.org.

- There is one more web entity. In Amazon S3 is a glowscript bucket that contains
the libraries, fonts, and textures used by exported GlowScript programs. They are
stored there in part because it wasn't clear how to deal with CORS-enabling these
files within the original http://glowscript.org web site, whereas at Amazon S3 it's a
one-click action (click a file listing in glowscript/package, then click "Make Public").
Also, https://s3.amazonaws.com/glowscript is an https site, whereas glowscript.org
was until Feb. 2019 an http site, so references to S3 from a program exported to an
https site would work, but not to http://glowscript.org. 

