#define UNICODE

#include <windows.h>
#include <wchar.h>

#ifndef __TINYC__
#include <TlHelp32.h>
#endif

static BOOL mui_does_narrator_alive(){
#ifndef __TINYC__
    BOOL found = FALSE;
    HANDLE snapshot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    PROCESSENTRY32 process;

    process.dwSize = sizeof(PROCESSENTRY32);

    if (Process32First(snapshot, &process)){
        do {
            if (wcscmp(process.szExeFile, L"Narrator.exe") == 0){
                found = TRUE;
                break;
            }
        } while (Process32Next(snapshot, &process));
        CloseHandle(snapshot);
        return found;
    }
#endif
    return FALSE;
}

static wchar_t* mui_get_regedit_dword(wchar_t* path, wchar_t* key){
    HKEY hKey;
    DWORD dwType = REG_DWORD;
    DWORD dwValue = 0;
    DWORD dwBufSize = sizeof(dwValue);

    if (RegOpenKeyEx(HKEY_CURRENT_USER, path, 0, KEY_QUERY_VALUE, &hKey) != ERROR_SUCCESS){
        return L"";
    }

    if (RegQueryValueEx(hKey, key, NULL, &dwType, (LPBYTE)&dwValue, &dwBufSize) != ERROR_SUCCESS){
        RegCloseKey(hKey);
        return L"";
    }

#ifndef __TINYC__
    wchar_t* szHexString;
    szHexString = (wchar_t*)malloc(8 * sizeof(*szHexString));
    swprintf(szHexString, 10, L"%X", dwValue);
#else
    wchar_t* szHexString;
    szHexString = (wchar_t*)malloc(sizeof(*szHexString));
    swprintf(szHexString, L"%X", dwValue);
#endif
    RegCloseKey(hKey);

    return szHexString;
}