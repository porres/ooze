# Makefile for mylib

lib.name = clarinet

class.sources = \
	clarinet.cpp \
	
common.sources = /usr/local/include/flext

datafiles = README.md

include pd-lib-builder/Makefile.pdlibbuilder

# flext stuff  ### EDIT! ###
# FLEXTPATH=/usr/local/include/flext
# FLEXTLIB=/usr/local/lib/libflext-pd_s.a

# stk stuff
# STKPATH=/usr/local/include/stk
# STKLIB=/usr/local/lib/libstk.a