CFLAGS := -Iinclude -MMD -MP -Wall -Wextra -O2
CC := gcc

SRC := $(shell find src -name '*.c')
OBJ := $(sort $(SRC:src/%.c=build/%.o) build/mul.o)
DPN := $(OBJ:.o=.d)

BIN := build/prog

OBJ_DIRS := $(sort $(dir $(OBJ)))

.PHONY: all clean test

ifneq ($(filter clean,$(MAKECMDGOALS)),)
ifneq ($(filter-out clean,$(MAKECMDGOALS)),)
.NOTPARALLEL:
endif
endif

all: $(BIN)

build/genmul: tools/genmul.c | build
	$(CC) $(CFLAGS) tools/genmul.c -o $@

src/mul.c include/mul.h &: build/genmul
	./build/genmul
	
build/mul.o: src/mul.c include/mul.h

$(BIN): $(OBJ) | $(OBJ_DIRS)
	$(CC) $(OBJ) -o $@

build/%.o: src/%.c | $(OBJ_DIRS)
	$(CC) $(CFLAGS) -c $< -o $@

build $(OBJ_DIRS):
	mkdir -p $@

test: $(BIN)
	./tests/test.sh

clean:
	rm -rf build

-include $(DPN)
