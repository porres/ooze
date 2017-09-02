# Makefile for mylib

lib.name = clarinet

class.sources = \
	clarinet.cpp \

datafiles = README.md

FLEXTPATH=/usr/local/include/flext # include flext header files
STKPATH=/usr/local/include/stk # include stk header files
cflags += -I"$(FLEXTPATH)" -I"$(STKPATH)"
ldlibs = -lflext

include pd-lib-builder/Makefile.pdlibbuilder

# flext stuff  ### EDIT! ###
# FLEXTPATH=/usr/local/include/flext
# FLEXTLIB=/usr/local/lib/libflext-pd_s.a

# stk stuff
# STKPATH=/usr/local/include/stk
# STKLIB=/usr/local/lib/libstk.a