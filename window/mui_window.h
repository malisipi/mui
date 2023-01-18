#include <windows.h>
#define DWMWA_USE_IMMERSIVE_DARK_MODE 20

// <dwmapi.h>
HRESULT DwmSetWindowAttribute(HWND hWnd, int attr, int* isDarkMode, int size);

void prefer_dark_titlebar (HWND hWnd){
	BOOL dark = TRUE;
	DwmSetWindowAttribute(hWnd, DWMWA_USE_IMMERSIVE_DARK_MODE, &dark, sizeof(dark));
}
