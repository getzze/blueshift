PKGCONFIG = pkg-config
OPTIMISE = -Og -g
WARN = -Wall -Wextra -pedantic
LIBS = xcb-randr python3
STD = c99

FLAGS = $$($(PKGCONFIG) --cflags --libs $(LIBS)) -std=$(STD) $(WARN) $(OPTIMISE) -fPIC


.PHONY: all
all: bin/blueshift_randr.so


bin/blueshift_randr.so: obj/blueshift_randr.o obj/blueshift_randr_c.o
	@mkdir -p bin
	$(CC) $(FLAGS) -shared -o $@ $^

obj/%.o: src/%.c
	@mkdir -p obj
	$(CC) $(FLAGS) -c -o $@ $<

obj/%.o: obj/%.c
	@mkdir -p obj
	$(CC) $(FLAGS) -c -o $@ $<

obj/blueshift_randr.c: src/blueshift_randr.pyx
	@mkdir -p obj
	if ! cython -3 -v $<; then src/blueshift_randr.c ; false ; fi
	mv src/blueshift_randr.c $@


.PHONY: all
clean:
	-rm -r bin obj src/blueshift_randr.c
