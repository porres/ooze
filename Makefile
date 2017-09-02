# Makefile for Ooze Lib
#
# To build on OSX use:
# make pdincludepath=/Applications/Pd.app/Contents/Resources/include/

# library name
lib.name = clarinet

# input source file (class name == source file basename)
class.sources = \
	clarinet.cpp \

# build for 64 bit only
arch := x86_64

# add extra files
datafiles = README.md

FLEXTPATH=/usr/local/include/flext # include flext header files
STKPATH=/usr/local/include/stk # include stk header files
# include stk header files
# include stk header files
# add include paths to cflags
cflags += -I"$(FLEXTPATH)" -I"$(STKPATH)"
ldlibs = -lflext

include pd-lib-builder/Makefile.pdlibbuilder

# flext stuff  ### EDIT! ###
# FLEXTPATH=/usr/local/include/flext
# FLEXTLIB=/usr/local/lib/libflext-pd_s.a

# stk stuff
# STKPATH=/usr/local/include/stk
# STKLIB=/usr/local/lib/libstk.a