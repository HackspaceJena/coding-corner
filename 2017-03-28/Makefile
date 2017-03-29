#!/usr/bin/make -f

CFLAGS=-g -O2 -fPIC -fPIE -Wall -Wextra -Wformat=2 -Wunused -Wlogical-op -Wundef \
	-Wswitch-enum -Wpointer-arith -Wcast-qual -Wcast-align -Wwrite-strings \
	-Wconversion -D_FORTIFY_SOURCE=2 -fstack-protector -Wshadow -Wnested-externs

LDFLAGS=-lm

.PHONY: all

all: jo-so_euler87
