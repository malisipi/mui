all: lib crun

lib:
	v -cc tcc -d no_backtrace . -shared -o mui.so

lib_prod:
	v -cc gcc -prod -d power_save -skip-unused -shared . -cflags "-s" -o mui.so

lib_mini:
	v -cc gcc -prod -d no_emoji -d power_save -skip-unused -shared . -cflags "-Os -s -fno-ident -fno-asynchronous-unwind-tables" -o mui.so

crun:
	clang test.c mui.so -Wl,-rpath . -o test.out
	$(MAKE) run

run:
	./test.out
