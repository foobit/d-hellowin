import core.runtime;
import core.sys.windows.windows;
import core.stdc.stdio;

import tb.core;
import tb.opengl;

import std.utf;
import std.string;

pragma(lib, "gdi32.lib");

int main()
{
	auto t = "世界こんにちは！";
	MessageBoxW(null, t.toUTF16z(), "Code", MB_ICONERROR);

	auto f = Runtime.loadLibrary("opengl32.dll");
	
	const string className = "HelloWinClass";
	HWND hwnd;
	MSG  msg;

	WNDCLASSA wndclass;

	auto hInstance = GetModuleHandleW(null);

	wndclass.style			= CS_HREDRAW | CS_VREDRAW;
	wndclass.lpfnWndProc	= cast(WNDPROC)&WndProc;
	wndclass.cbClsExtra		= 0;
	wndclass.cbWndExtra		= 0;
	wndclass.hInstance		= hInstance;
	wndclass.hIcon			= LoadIconA(null, IDI_APPLICATION);
	wndclass.hCursor		= LoadCursorA(null, IDC_ARROW);
	wndclass.hbrBackground	= cast(HBRUSH)GetStockObject(WHITE_BRUSH);
	wndclass.lpszMenuName	= null;
	wndclass.lpszClassName	= cast(char *)className;

	if (!RegisterClassA(&wndclass))
	{
		MessageBoxA(null, "Error registering window class", cast(char *)className, MB_ICONERROR);
		return 1;
	}

	hwnd = CreateWindowA(cast(char *)className,
						"Hello World",
						WS_OVERLAPPEDWINDOW,
						CW_USEDEFAULT,
						0,
						CW_USEDEFAULT,
						0,
						null,
						null,
						hInstance,
						null);
	if (!hwnd)
	{
		MessageBoxA(null, "Error creating window", cast(char *)className, MB_ICONERROR);
		return 1;
	}

	ShowWindow(hwnd, SW_SHOWNORMAL);
	UpdateWindow(hwnd);

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

		default:
	}

	return DefWindowProcA(hwnd, message, wParam, lParam);
}
