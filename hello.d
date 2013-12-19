import core.runtime;
import core.sys.windows.windows;

pragma(lib, "gdi32.lib");

extern (Windows) int WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)
{
	const string className = "HelloWinClass";
	HWND hwnd;
	MSG  msg;

	WNDCLASSA wndclass;

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
