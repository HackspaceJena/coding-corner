#!/usr/bin/make -f

CFLAGS=-g -O2 -fPIC -fPIE -Wall -Wextra -Wformat=2 -Wunused -Wlogical-op -Wundef \
	-Wswitch-enum -Wpointer-arith -Wcast-qual -Wcast-align -Wwrite-strings \
	-Wconversion -D_FORTIFY_SOURCE=2 -fstack-protector -Wshadow -Wnested-externs \
	-Wmissing-prototypes

LDFLAGS=-lm

RFLAGS=-O -g

.PHONY: all

all: jo-so_euler87-c jo-so_euler87-rust

%-rust: %.rs
	rustc $(RFLAGS) --crate-type bin -o $@ $^

%-c: %.c
	$(LINK.c) $^ $(LOADLIBES) $(LDLIBS) -o $@
