module tb.opengl;

private
{
	import std.string;
	import std.stdio;

	version(Windows)	
	{
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
		PFD_SUPPORT_COMPOSITION = 0x00008000
	}

	alias void*		HRC;

	extern (Windows) int ChoosePixelFormat(HDC hdc, PIXELFORMATDESCRIPTOR* ppfd);
	extern (Windows) bool SwapBuffers(HDC hdc);
}

static struct ClearMask
{
	enum : int
	{
		Depth = 0x00000100,
		Stencil = 0x00000400,
		Color = 0x00004000
	}
}

static struct DataType
{
	enum : int
	{
		Byte = 0x1400,
		UnsignedByte = 0x1401,
		Short = 0x1402,
		UnsignedShort = 0x1403,
		Int = 0x1404,
		UnsignedInt = 0x1405,
		Float = 0x1406
	}
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

		// ext
		static void function(int n, uint* buffers) GenBuffers;
		static void function(int n, uint* buffers) DeleteBuffers;

		static void function(int size, int dataType, int stride, void* pointer) VertexPointer;
		static void function(int dataType, int stride, void* pointer) NormalPointer;
		static void function(int size, int dataType, int stride, void* pointer) TexCoordPointer;
		static void function(int size, int dataType, int stride, void* pointer) ColorPointer;
		static void function(int dataType, int stride, void* pointer) IndexPointer;
	}

	static void Init()
	{
		GetProc!(typeof(gl.GenTextures)).Bind(&gl.GenTextures, "glGenTextures");
		GetProc!(typeof(gl.ClearColor)).Bind(&gl.ClearColor, "glClearColor");
		GetProc!(typeof(gl.Clear)).Bind(&gl.Clear, "glClear");

		GetProcEx!(typeof(gl.GenBuffers)).Bind(&gl.GenBuffers, "glGenBuffers");
		GetProcEx!(typeof(gl.DeleteBuffers)).Bind(&gl.DeleteBuffers, "glDeleteBuffers");
		GetProcEx!(typeof(gl.VertexPointer)).Bind(&gl.VertexPointer, "glVertexPointer");
		GetProcEx!(typeof(gl.NormalPointer)).Bind(&gl.NormalPointer, "glNormalPointer");
		GetProcEx!(typeof(gl.TexCoordPointer)).Bind(&gl.TexCoordPointer, "glTexCoordPointer");
		GetProcEx!(typeof(gl.ColorPointer)).Bind(&gl.ColorPointer, "glColorPointer");
		GetProcEx!(typeof(gl.IndexPointer)).Bind(&gl.IndexPointer, "glIndexPointer");
	}
}
