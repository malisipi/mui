#define UNICODE

#include <windows.h>
#include <winuser.h>
#include <stdio.h>

int mui_window_top = 0;
int mui_window_left = 0;
int mui_window_bottom = 0;
int mui_window_right = 0;

static void mui_update_window_pos (HWND hwnd) {
  RECT pos;
  GetWindowRect(hwnd, &pos);
  mui_window_top = pos.top;
  mui_window_bottom = pos.bottom;
  mui_window_right = pos.right;
  mui_window_left = pos.left;
}
