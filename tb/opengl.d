module tb.opengl;

private
{
	import std.string;
	import std.stdio;

	version(Windows)	
	{
		pragma(lib, "gdi32.lib");

		import std.c.windows.windows;

		HMODULE glHandle;

		template GetProc(T)
		{
			void Bind(T* t, string name)
			{
				*t = cast(T)GetProcAddress(glHandle, name.toStringz());
				if (!*t) throw new Exception("GetProc failed: " ~ name);
			}
		}

		template GetProcEx(T)
		{
			void Bind(T* t, string name)
			{
				*t = cast(T)wgl.GetProcAddress(name.toStringz());
				if (!*t) throw new Exception("GetProcEx failed: " ~ name);
			}
		}
	}
}

static this()
{
	version(Windows)
	{
		glHandle = LoadLibraryA("opengl32.dll");

		// windows specific (w)gl bindings
		GetProc!(typeof(wgl.CreateContext)).Bind(&wgl.CreateContext, "wglCreateContext");
		GetProc!(typeof(wgl.MakeCurrent)).Bind(&wgl.MakeCurrent, "wglMakeCurrent");
		GetProc!(typeof(wgl.GetProcAddress)).Bind(&wgl.GetProcAddress, "wglGetProcAddress");
		GetProc!(typeof(wgl.GetCurrentDC)).Bind(&wgl.GetCurrentDC, "wglGetCurrentDC");
		GetProc!(typeof(wgl.GetCurrentContext)).Bind(&wgl.GetCurrentContext, "wglGetCurrentContext");
		GetProc!(typeof(wgl.DeleteContext)).Bind(&wgl.DeleteContext, "wglDeleteContext");
	}
	else version(OSX)
	{

	}
	else version(Linux)	
	{
	}
}

version (Windows)
{
	enum : int
	{
		/* pixel types */
		PFD_TYPE_RGBA = 0,
		PFD_TYPE_COLORINDEX = 1,

		/* layer types */
		PFD_MAIN_PLANE = 0,
		PFD_OVERLAY_PLANE = 1,
		PFD_UNDERLAY_PLANE = -1,

		/* PIXELFORMATDESCRIPTOR flags */
		PFD_DOUBLEBUFFER = 0x00000001,
		PFD_STEREO = 0x00000002,
		PFD_DRAW_TO_WINDOW = 0x00000004,
		PFD_DRAW_TO_BITMAP = 0x00000008,
		PFD_SUPPORT_GDI = 0x00000010,
		PFD_SUPPORT_OPENGL = 0x00000020,
		PFD_GENERIC_FORMAT = 0x00000040,
		PFD_NEED_PALETTE = 0x00000080,
		PFD_NEED_SYSTEM_PALETTE = 0x00000100,
		PFD_SWAP_EXCHANGE = 0x00000200,
		PFD_SWAP_COPY = 0x00000400,
		PFD_SWAP_LAYER_BUFFERS = 0x00000800,
		PFD_GENERIC_ACCELERATED = 0x00001000,
		PFD_SUPPORT_DIRECTDRAW = 0x00002000,
		PFD_DIRECT3D_ACCELERATED = 0x00004000,
		PFD_SUPPORT_COMPOSITION = 0x00008000,

		/* PIXELFORMATDESCRIPTOR flags for use in ChoosePixelFormat only */
		PFD_DEPTH_DONTCARE = 0x20000000,
		PFD_DOUBLEBUFFER_DONTCARE = 0x40000000,
		PFD_STEREO_DONTCARE = 0x80000000
	}

	alias void*		HRC;

	extern (Windows) int ChoosePixelFormat(HDC hdc, PIXELFORMATDESCRIPTOR* ppfd);
	extern (Windows) bool SwapBuffers(HDC hdc);
}

enum ClearMask : int
{
	Depth = 0x00000100,
	Stencil = 0x00000400,
	Color = 0x00004000
}

enum DataType : int
{
	Byte = 0x1400,
	UnsignedByte = 0x1401,
	Short = 0x1402,
	UnsignedShort = 0x1403,
	Int = 0x1404,
	UnsignedInt = 0x1405,
	Float = 0x1406
}

enum ArrayType : int
{
	VertexArray = 0x8074,
	NormalArray = 0x8075,
	ColorArray = 0x8076,
	IndexArray = 0x8077,
	TextureCoordArray = 0x8078,
	EdgeFlagArray = 0x8079
}

enum BeginMode : int
{
	Points = 0,
	Lines = 1,
	LineLoop = 2,
	LineStrip = 3,
	Triangles = 4,
	TriangleStrip = 5,
	TriangleFan = 6
}

enum HintMode : int
{
	DontCare = 0x1100,
	Fastest = 0x1101,
	Nicest = 0x1102
}

enum HintTarget : int
{
	PerspectiveCorrection = 0x0C50,
	PointSmooth = 0x0C51,
	LineSmooth = 0x0C52,
	PolygonSmooth = 0x0C53,
	Fog = 0x0C54
}

enum EnableCap : int
{
	Blend = 0x0BE2,
	ColorLogicOp = 0x0BF2,
	CullFace = 0x0B44,
	DepthClamp = 0x864F,
	DepthTest = 0x0B71,
	Dither = 0x0BD0,
	FramebufferSrgb = 0x8DB9,
	LineSmooth = 0x0B20,
	Multisample = 0x809D,
	PolygonOffsetFill = 0x8037,
	PolygonOffsetLine = 0x2A02,
	PolygonOffsetPoint = 0x2A01,
	PolygonSmooth = 0x0B41,
	PrimitiveRestart = 0x8F9D,
	SampleMask = 0x8E51,
	ScissorTest = 0x0C11,
	StencilTest = 0x0B90,
	TextureCubeMapSeamless = 0x884F,
	ProgramPointSize = 0x8642,
	Lighting = 0x0B50,
	Texture2D = 0x0DE1
}

enum CompareFunction : int
{
	Never = 0x0200,
	Less = 0x0201,
	Equal = 0x0202,
	LEqual = 0x0203,
	Greater = 0x0204,
	NotEqual = 0x0205,
	GEqual = 0x0206,
	Always = 0x0207,
}

enum MatrixMode : int
{
	Model = 0x1700,
	Projection = 0x1701,
	Texture = 0x1702
}

enum BlendFunc : int
{
	Zero = 0,
	One = 1,
	SrcColor = 0x0300,
	OneMinusSrcColor = 0x0301,
	SrcAlpha = 0x0302,
	OneMinusSrcAlpha = 0x0303,
	DstAlpha = 0x0304,
	OneMinusDstAlpha = 0x0305,
	DstColor = 0x0306,
	OneMinusDstColor = 0x0307,
	SrcAlphaSaturate = 0x0308,
	ConstantColor = 0x8001
}

enum TextureName : int
{
	WrapS = 0x2802,
	WrapT = 0x2803,
	MagFilter = 0x2800,
	MinFilter = 0x2801
}

enum TextureTarget : int
{
	Texture1D = 0x0DE0,
	Texture2D = 0x0DE1
}

enum TextureParam : int
{
	Clamp = 0x2900,
	Repeat = 0x2901,
	Nearest = 0x2600,
	Linear = 0x2601
}

enum InternalFormat : int
{
	RGB = 0x1907,
	RGBA = 0x1908,
	BGR = 0x80E0,
	BGRA = 0x80E1
}

enum BufferTarget : int
{
	ArrayBuffer = 34962,
	ElementArrayBuffer = 34963
}

enum BufferUsageHint : int
{
	StaticDraw = 35044
}

version (Windows)
static struct wgl
{
	extern (Windows) nothrow
	{
		static HRC function(in void*) CreateContext;
		static void* function(in LPCSTR) GetProcAddress;
		static bool function(in HDC, in HRC) MakeCurrent;
		static HDC function() GetCurrentDC;
		static HRC function() GetCurrentContext;
		static bool function(in HRC) DeleteContext;
	}
}

static struct gl
{
	extern (System) nothrow
	{
		static void function(float r, float g, float b, float a) ClearColor;
		static void function(int mask) Clear;
		static void function(int n, uint* textures) GenTextures;
		static void function(int n, uint* buffers) GenBuffers;
		static void function(int n, uint* buffers) DeleteBuffers;
		static void function(BufferTarget target, uint buffer) BindBuffer;
		static void function(BufferTarget target, long size, void* data, BufferUsageHint usage) BufferData;

		static void function(int n, uint* buffers) GenVertexArrays;
		static void function(uint id) BindVertexArray;
		static void function(int n, uint* buffers) DeleteVertexArrays;

		static void function(int size, DataType dataType, int stride, void* pointer) VertexPointer;
		static void function(DataType dataType, int stride, void* pointer) NormalPointer;
		static void function(int size, DataType dataType, int stride, void* pointer) TexCoordPointer;
		static void function(int size, DataType dataType, int stride, void* pointer) ColorPointer;
		static void function(DataType dataType, int stride, void* pointer) IndexPointer;

		static void function(ArrayType arrayType) EnableClientState;
		static void function(ArrayType arrayType) DisableClientState;

		static void function(BeginMode mode, int first, int count) DrawArrays;
		static void function(BeginMode mode, int count, DataType type, void* indices) DrawElements;

		static void function(HintTarget target, HintMode mode) Hint;

		static void function(CompareFunction func) DepthFunc;
		static void function(EnableCap enable) Enable;
		static void function(EnableCap enable) Disable;

		static void function(float r, float g, float b, float a) Color;
		static void function(.MatrixMode mode) MatrixMode;
		static void function() LoadIdentity;

		static void function(float x, float y, float z) Translate;
		static void function(float x, float y, float z) Scale;
		static void function(float angle, float x, float y, float z) Rotate;

		static int function() Flush;

		static void function(int x, int y, int width, int height) Viewport;
		static void function(double left, double right, double bottom, double top, double znear, double zfar) Ortho;
		static void function(double left, double right, double bottom, double top, double znear, double zfar) Frustum;

		static void function(float* m) LoadMatrix;
		static void function(float* m) MultMatrix;
		static void function() PushMatrix;
		static void function() PopMatrix;

		static void function(.BlendFunc sfunc, .BlendFunc dfunc) BlendFunc;
		static int function() GetError;

		static void function(TextureTarget target, TextureName name, TextureParam param) TexParameter;
		static void function(int x, int y, int width, int height) Scissor;

		static void function(TextureTarget target, uint texture) BindTexture;
		static void function(TextureTarget target, int level, InternalFormat iformat, int width, int height, int border, InternalFormat format, DataType type, void* pixels) TexImage2D;
		static void function(TextureTarget target, int level, int x, int y, int width, int height, InternalFormat format, DataType type, void* pixels) TexSubImage2D;
		static void function(int n, uint* textures) DeleteTextures;

		static void function(int idx, int size, DataType type, int normalized, int stride, void* data) VertexAttribPointer;
		static void function(int idx) EnableVertexAttribArray;
	}

	static void Init()
	{
		GetProc!(typeof(gl.ClearColor)).Bind(&gl.ClearColor, "glClearColor");
		GetProc!(typeof(gl.Clear)).Bind(&gl.Clear, "glClear");
		GetProc!(typeof(gl.EnableClientState)).Bind(&gl.EnableClientState, "glEnableClientState");
		GetProc!(typeof(gl.DisableClientState)).Bind(&gl.DisableClientState, "glDisableClientState");
		GetProc!(typeof(gl.DrawArrays)).Bind(&gl.DrawArrays, "glDrawArrays");
		GetProc!(typeof(gl.DrawElements)).Bind(&gl.DrawElements, "glDrawElements");
		GetProc!(typeof(gl.Hint)).Bind(&gl.Hint, "glHint");
		GetProc!(typeof(gl.DepthFunc)).Bind(&gl.DepthFunc, "glDepthFunc");
		GetProc!(typeof(gl.Enable)).Bind(&gl.Enable, "glEnable");
		GetProc!(typeof(gl.Disable)).Bind(&gl.Disable, "glDisable");
		GetProc!(typeof(gl.Color)).Bind(&gl.Color, "glColor4f");
		GetProc!(typeof(gl.MatrixMode)).Bind(&gl.MatrixMode, "glMatrixMode");
		GetProc!(typeof(gl.LoadIdentity)).Bind(&gl.LoadIdentity, "glLoadIdentity");
		GetProc!(typeof(gl.Translate)).Bind(&gl.Translate, "glTranslatef");
		GetProc!(typeof(gl.Scale)).Bind(&gl.Scale, "glScalef");
		GetProc!(typeof(gl.Rotate)).Bind(&gl.Rotate, "glRotatef");
		GetProc!(typeof(gl.Flush)).Bind(&gl.Flush, "glFlush");
		GetProc!(typeof(gl.Viewport)).Bind(&gl.Viewport, "glViewport");
		GetProc!(typeof(gl.Ortho)).Bind(&gl.Ortho, "glOrtho");
		GetProc!(typeof(gl.Frustum)).Bind(&gl.Frustum, "glFrustum");
		GetProc!(typeof(gl.LoadMatrix)).Bind(&gl.LoadMatrix, "glLoadMatrixf");
		GetProc!(typeof(gl.MultMatrix)).Bind(&gl.MultMatrix, "glMultMatrixf");
		GetProc!(typeof(gl.PushMatrix)).Bind(&gl.PushMatrix, "glPushMatrix");
		GetProc!(typeof(gl.PopMatrix)).Bind(&gl.PopMatrix, "glPopMatrix");
		GetProc!(typeof(gl.BlendFunc)).Bind(&gl.BlendFunc, "glBlendFunc");
		GetProc!(typeof(gl.GetError)).Bind(&gl.GetError, "glGetError");
		GetProc!(typeof(gl.TexParameter)).Bind(&gl.TexParameter, "glTexParameteri");
		GetProc!(typeof(gl.Scissor)).Bind(&gl.Scissor, "glScissor");
		GetProc!(typeof(gl.BindTexture)).Bind(&gl.BindTexture, "glBindTexture");
		GetProc!(typeof(gl.TexImage2D)).Bind(&gl.TexImage2D, "glTexImage2D");
		GetProc!(typeof(gl.TexSubImage2D)).Bind(&gl.TexSubImage2D, "glTexSubImage2D");
		GetProc!(typeof(gl.GenTextures)).Bind(&gl.GenTextures, "glGenTextures");
		GetProc!(typeof(gl.DeleteTextures)).Bind(&gl.DeleteTextures, "glDeleteTextures");

		GetProcEx!(typeof(gl.GenBuffers)).Bind(&gl.GenBuffers, "glGenBuffers");
		GetProcEx!(typeof(gl.BindBuffer)).Bind(&gl.BindBuffer, "glBindBuffer");
		GetProcEx!(typeof(gl.BufferData)).Bind(&gl.BufferData, "glBufferData");
		GetProcEx!(typeof(gl.VertexAttribPointer)).Bind(&gl.VertexAttribPointer, "glVertexAttribPointer");
		GetProcEx!(typeof(gl.EnableVertexAttribArray)).Bind(&gl.EnableVertexAttribArray, "glEnableVertexAttribArray");
		GetProcEx!(typeof(gl.DeleteVertexArrays)).Bind(&gl.DeleteVertexArrays, "glDeleteVertexArrays");
		GetProcEx!(typeof(gl.BindVertexArray)).Bind(&gl.BindVertexArray, "glBindVertexArray");
		GetProcEx!(typeof(gl.GenVertexArrays)).Bind(&gl.GenVertexArrays, "glGenVertexArrays");
		GetProcEx!(typeof(gl.DeleteBuffers)).Bind(&gl.DeleteBuffers, "glDeleteBuffers");
		GetProcEx!(typeof(gl.VertexPointer)).Bind(&gl.VertexPointer, "glVertexPointer");
		GetProcEx!(typeof(gl.NormalPointer)).Bind(&gl.NormalPointer, "glNormalPointer");
		GetProcEx!(typeof(gl.TexCoordPointer)).Bind(&gl.TexCoordPointer, "glTexCoordPointer");
		GetProcEx!(typeof(gl.ColorPointer)).Bind(&gl.ColorPointer, "glColorPointer");
		GetProcEx!(typeof(gl.IndexPointer)).Bind(&gl.IndexPointer, "glIndexPointer");
	}
}
