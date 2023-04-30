all: lib crun

lib:
	v -cc tcc -d no_backtrace mui.v -shared -o mui.so

crun:
	clang test.c mui.so -o test.out
	$(MAKE) run

run:
	LD_LIBRARY_PATH=. ./test.out
