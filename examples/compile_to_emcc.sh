#!/bin/bash
export V_LOC=$(dirname $(readlink -e $(whereis v | sed "s|v: ||g")))

echo %% Compiling     \"$1\"
echo %% - V flags:    \"$2\"
echo %% - EMCC flags: \"$3\"

echo "%% Modifying the V compiler"
mv $V_LOC/vlib/os/password_nix.c.v $V_LOC/vlib/os/password_nix.c.v.null

echo "%% Creating C output of V code"
v -d emscripten -d power_save -gc none -os wasm32_emscripten "$1" $2 -o emscripten_.c

echo "%% Modifying the C output of V"
cat emscripten_.c | sed 's/waitpid(p->pid, &cstatus, 0);/-1;/g' | sed 's/waitpid(p->pid, &cstatus, WNOHANG);/-1;/g' | sed 's/wait(0);/-1;/g' &> emscripten.c

echo "%% Attemping the emscripten to compile"
emcc -fPIC -Wimplicit-function-declaration -w $V_LOC/thirdparty/stb_image/stbi.c -I/usr/include/gc/ -I$V_LOC/thirdparty/stb_image -I$V_LOC/thirdparty/fontstash -I$V_LOC/thirdparty/sokol -I$V_LOC/thirdparty/sokol/util -DSOKOL_GLES2 -DSOKOL_NO_ENTRY -DNDEBUG -O3 -s ERROR_ON_UNDEFINED_SYMBOLS=0 -s ALLOW_MEMORY_GROWTH -s MODULARIZE -s ASSERTIONS=1 -s FILESYSTEM=1 -s EXPORTED_RUNTIME_METHODS=FS -s EXPORT_ES6 ./emscripten.c -o ./app.js -DSOKOL_LOG=printf --embed-file ~/.vmodules/malisipi/mui/assets/noto.ttf@/noto.ttf $3

echo "%% Unmodifying the V compiler"
mv $V_LOC/vlib/os/password_nix.c.v.null $V_LOC/vlib/os/password_nix.c.v

echo "%% Removing temp files"
rm emscripten_.c emscripten.c

echo %% Compilied