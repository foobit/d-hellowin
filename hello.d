import tb.core;
import tb.opengl;

import std.utf;
import std.string;
import std.conv;
import std.stdio;
import std.c.windows.windows;

pragma(lib, "gdi32.lib");

HDC hdc;

int main()
{
	const string className = "HelloWinClass";
	HWND hwnd;
	MSG  msg;
	HMODULE hInstance = GetModuleHandleA(null);

	WNDCLASSEXA wndclass;

	wndclass.cbSize			= WNDCLASSEXA.sizeof;
	wndclass.style			= CS_HREDRAW | CS_VREDRAW | CS_OWNDC | CS_DBLCLKS;
	wndclass.lpfnWndProc	= cast(WNDPROC)&WndProc;
	wndclass.cbClsExtra		= 0;
	wndclass.cbWndExtra		= 0;
	wndclass.hInstance		= hInstance;
	wndclass.hIcon			= LoadIconA(null, IDI_APPLICATION);
	wndclass.hCursor		= LoadCursorA(null, IDC_ARROW);
	wndclass.hbrBackground	= null; // cast(HBRUSH)GetStockObject(WHITE_BRUSH);
	wndclass.lpszMenuName	= null;
	wndclass.lpszClassName	= cast(char *)className;

	if (!RegisterClassExA(&wndclass))
	{
		MessageBoxA(null, "Error registering window class", cast(char *)className, MB_ICONERROR);
		return 1;
	}

	hwnd = CreateWindowA(cast(char *)className,
						"Hello World",
						WS_OVERLAPPEDWINDOW,
						100, //CW_USEDEFAULT,
						100, //0,
						320, // CW_USEDEFAULT,
						240, // 0,
						null,
						null,
						null, //hInstance,
						null);
	if (!hwnd)
	{
		MessageBoxA(null, "Error creating window", cast(char *)className, MB_ICONERROR);
		return 1;
	}

	hdc = GetDC(hwnd);

	PIXELFORMATDESCRIPTOR pfd;
	pfd.nSize = PIXELFORMATDESCRIPTOR.sizeof;
	pfd.nVersion = 1;
	pfd.dwFlags = PFD_DOUBLEBUFFER | PFD_SUPPORT_OPENGL | PFD_DRAW_TO_WINDOW;
	pfd.iPixelType = PFD_TYPE_RGBA;
	pfd.cColorBits = 32;
	pfd.cDepthBits = 16;
	pfd.iLayerType = PFD_MAIN_PLANE;

	int format = ChoosePixelFormat(hdc, &pfd);
	SetPixelFormat(hdc, format, &pfd);

//	string txt = to!string(format);
//	if (!m) MessageBoxW(null, "世界こんにちは！".toUTF16z(), "Code", MB_ICONERROR);

	ShowWindow(hwnd, SW_SHOWNORMAL);
	UpdateWindow(hwnd);

	auto hrc = wgl.CreateContext(hdc);
	wgl.MakeCurrent(hdc, hrc);
	
	while (GetMessageA(&msg, null, 0, 0))
	{
		TranslateMessage(&msg);
		DispatchMessageA(&msg);
	}

	return msg.wParam;
}

extern(Windows) LRESULT WndProc(HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	switch (message)
	{
		case WM_DESTROY:
			PostQuitMessage(0);
			return 0;

		case WM_PAINT:
			{
				gl.ClearColor(0, 0, 0.14f, 1);
				gl.Clear(ClearMask.Color | ClearMask.Depth);

				SwapBuffers(hdc);
			}
			return 0;

		default:
	}

	return DefWindowProcA(hwnd, message, wParam, lParam);
}
