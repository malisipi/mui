#define UNICODE

#include <windows.h>
#include <shellapi.h>
#include <winuser.h>

static void mui_popup_menu_MENUITEMINFO (HMENU hmenu, int id, bool def, bool disabled, bool checked, wchar_t* text) {
      MENUITEMINFO item;
      item.cbSize = sizeof(MENUITEMINFO);
      item.fMask = MIIM_ID | MIIM_TYPE | MIIM_STATE | MIIM_DATA;
      item.fType = 0;
      item.fState = 0;
      if (def){
        item.fState |= MFS_DEFAULT;
      }
      if (disabled) {
        item.fState |= MFS_DISABLED;
      }
      if (checked) {
        item.fState |= MFS_CHECKED;
      }
      item.wID = id;
      item.dwTypeData = text;
      InsertMenuItem(hmenu, id, true, &item);
}
