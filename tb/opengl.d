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

		GetProc!(typeof(gl.ClearColor)).Bind(&gl.ClearColor, "glClearColor");
		GetProc!(typeof(gl.Clear)).Bind(&gl.Clear, "glClear");
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

	extern (Windows) int ChoosePixelFormat(in HDC hdc, in PIXELFORMATDESCRIPTOR* ppfd);
	extern (Windows) bool SwapBuffers(in HDC hdc);
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

version (Windows)
static struct wgl
{
	extern (Windows) nothrow
	{
		static HRC function(void*) CreateContext;
		static void* function(LPCSTR) GetProcAddress;
		static bool function(HDC, HRC) MakeCurrent;
		static HDC function() GetCurrentDC;
		static HRC function() GetCurrentContext;
		static bool function(HRC) DeleteContext;
	}
}

static struct gl
{
	extern (System) nothrow
	{
		static void function(float r, float g, float b, float a) ClearColor;
		static void function(int mask) Clear;
	}
}
