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

# include stk header files
FLEXTPATH=/usr/local/include/flext
# include stk header files
STKPATH=/usr/local/include/stk
# add include paths to cflags
cflags += -I"$(FLEXTPATH)" -I"$(STKPATH)"
# link to libs
# FLEXTLIB=/usr/local/lib/libflext-pd_s.a
# STKLIB=/usr/local/lib/libstk.a
# ldlibs = -lflext

include pd-lib-builder/Makefile.pdlibbuilder

# PDINCLUDEDIR:
# Directory where Pd API m_pd.h should be found, and other Pd header files.
# Overrides the default search path.
PDINCLUDEDIR =/Applications/Pd.app/Contents/Resources/include