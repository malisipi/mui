#!/bin/bash
g++ -c ~/.vmodules/malisipi/mui/webview/webview/webview.cc -std=c++11 $(pkg-config --cflags gtk+-3.0 webkit2gtk-4.0) -o ~/.vmodules/malisipi/mui/webview/webview.o
