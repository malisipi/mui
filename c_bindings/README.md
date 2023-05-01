# The API is unstable and a lot of thing will be changed in future. Please don't use in real-world application before stable-release.

## Compile For Linux:

```bash
v -shared -cc gcc mui.v -o mui.so
gcc test.c mui.so -Wl,-rpath=. -o test.app
```

## Compile For Windows:

```powershell
v -shared -cc gcc mui.v -o mui.dll
gcc test.c mui.dll -o test.exe
```

## Unsupported Widgets:

* Group
* Rect
* Progress
* Radio Button
* Selectbox
* Table
* Graphs
    * Line Graph
    * Area Graph
* Menubar
* Map (Desktop Only)
* Codefield
* Frames & Nested-Frames
* List View
* Spinner (aka UpDown)
* Tabbed View
