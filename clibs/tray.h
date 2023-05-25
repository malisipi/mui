// Licensed by MIT License
// Author: malisipi
// Source: https://gist.github.com/malisipi/ec70678d9b1c931130902ab97ac68938

#define UNICODE

#include <windows.h>
#include <shellapi.h>

struct tray_menu;

struct tray {
  HICON icon;
  const wchar_t *tooltip;
  const wchar_t *class_name;
  struct tray_menu *menu;
};

struct tray_menu {
  const wchar_t *text;
  bool disabled;
  bool checked;
  bool def; //default -> only 1 item -> it makes bold the item
  void (*cb)(struct tray_menu *);
  void *context;

  struct tray_menu *submenu;
};

static void tray_update(struct tray *tray);

#define WM_TRAY_CALLBACK_MESSAGE (WM_USER + 1)
#define ID_TRAY_FIRST 1000

static WNDCLASSEX wc;
static NOTIFYICONDATA nid;
static HWND hwnd;
static HMENU hmenu = NULL;

static LRESULT CALLBACK _tray_wnd_proc(HWND hwnd, UINT msg, WPARAM wparam,
                                       LPARAM lparam) {
  switch (msg) {
  case WM_CLOSE:
    DestroyWindow(hwnd);
    return 0;
  case WM_DESTROY:
    PostQuitMessage(0);
    return 0;
  case WM_TRAY_CALLBACK_MESSAGE:
    if (lparam == WM_LBUTTONUP || lparam == WM_RBUTTONUP) {
      POINT p;
      GetCursorPos(&p);
      SetForegroundWindow(hwnd);
      WORD cmd = TrackPopupMenu(hmenu, TPM_LEFTALIGN | TPM_RIGHTBUTTON |
                                           TPM_RETURNCMD | TPM_NONOTIFY,
                                p.x, p.y, 0, hwnd, NULL);
      SendMessage(hwnd, WM_COMMAND, cmd, 0);
      return 0;
    }
    break;
  case WM_COMMAND:
    if (wparam >= ID_TRAY_FIRST) {
      MENUITEMINFO item = {
          .cbSize = sizeof(MENUITEMINFO), .fMask = MIIM_ID | MIIM_DATA,
      };
      if (GetMenuItemInfo(hmenu, wparam, FALSE, &item)) {
        struct tray_menu *menu = (struct tray_menu *)item.dwItemData;
        if (menu != NULL && menu->cb != NULL) {
          menu->cb(menu);
        }
      }
      return 0;
    }
    break;
  }
  return DefWindowProc(hwnd, msg, wparam, lparam);
}

static HMENU _tray_menu(struct tray_menu *m, UINT *id) {
  HMENU hmenu = CreatePopupMenu();
  for (; m != NULL && m->text != NULL; m++, (*id)++) {
    if (wcscmp(m->text, L"-") == 0) {
      InsertMenu(hmenu, *id, MF_SEPARATOR, TRUE, L"");
    } else {
      MENUITEMINFO item;
      memset(&item, 0, sizeof(item));
      item.cbSize = sizeof(MENUITEMINFO);
      item.fMask = MIIM_ID | MIIM_TYPE | MIIM_STATE | MIIM_DATA;
      item.fType = 0;
      item.fState = 0;
      if (m->submenu != NULL) {
        item.fMask = item.fMask | MIIM_SUBMENU;
        item.hSubMenu = _tray_menu(m->submenu, id);
      }
      if (m->def){
        item.fState |= MFS_DEFAULT;
      }
      if (m->disabled) {
        item.fState |= MFS_DISABLED;
      }
      if (m->checked) {
        item.fState |= MFS_CHECKED;
      }
      item.wID = *id;
      item.dwTypeData = (LPWSTR)m->text;
      item.dwItemData = (ULONG_PTR)m;

      InsertMenuItem(hmenu, *id, TRUE, &item);
    }
  }
  return hmenu;
}

static int tray_init(struct tray *tray) {
  memset(&wc, 0, sizeof(wc));
  wc.cbSize = sizeof(WNDCLASSEX);
  wc.lpfnWndProc = _tray_wnd_proc;
  wc.hInstance = GetModuleHandle(NULL);
  wc.lpszClassName = tray->class_name;
  if (!RegisterClassEx(&wc)) {
    return -1;
  }

  hwnd = CreateWindowEx(0, tray->class_name, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  if (hwnd == NULL) {
    return -1;
  }
  UpdateWindow(hwnd);

  memset(&nid, 0, sizeof(nid));
  nid.cbSize = sizeof(NOTIFYICONDATA);
  nid.hWnd = hwnd;
  nid.uID = 0;
  nid.uFlags = NIF_ICON | NIF_MESSAGE;
  nid.uCallbackMessage = WM_TRAY_CALLBACK_MESSAGE;
  if(tray->tooltip != 0 && wcslen(tray->tooltip) > 0) {
    wcsncpy(nid.szTip, (LPCWSTR)tray->tooltip, sizeof(nid.szTip));
    nid.uFlags |= NIF_TIP;
  }
  Shell_NotifyIcon(NIM_ADD, &nid);

  tray_update(tray);
  return 0;
}

static int tray_loop(int blocking) {
  MSG msg;
  if (blocking) {
    GetMessage(&msg, hwnd, 0, 0);
  } else {
    PeekMessage(&msg, hwnd, 0, 0, PM_REMOVE);
  }
  if (msg.message == WM_QUIT) {
    return -1;
  }
  TranslateMessage(&msg);
  DispatchMessage(&msg);
  return 0;
}

static void tray_update(struct tray *tray) {
  HMENU prevmenu = hmenu;
  UINT id = ID_TRAY_FIRST;
  hmenu = _tray_menu(tray->menu, &id);
  SendMessage(hwnd, WM_INITMENUPOPUP, (WPARAM)hmenu, 0);
  if (nid.hIcon) {
    DestroyIcon(nid.hIcon);
  }
  nid.hIcon = tray->icon;
  Shell_NotifyIcon(NIM_MODIFY, &nid);

  if (prevmenu != NULL) {
    DestroyMenu(prevmenu);
  }
}

static void tray_exit(struct tray *tray) {
  Shell_NotifyIcon(NIM_DELETE, &nid);
  if (nid.hIcon != 0) {
    DestroyIcon(nid.hIcon);
  }
  if (hmenu != 0) {
    DestroyMenu(hmenu);
  }
  PostQuitMessage(0);
  UnregisterClass(tray->class_name, GetModuleHandle(NULL));
}
