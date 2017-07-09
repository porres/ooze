# idelay~ - interpolating delay using flext layer
# Copyright (c) 2002 Thomas Grill (xovo@gmx.net)
#
# Makefile for gcc 
#
# usage: make
#
# ---------------------------------------------

NAME=clarinet

# where to build
TARGDIR=./pd-linux

# where to install	### EDIT! ###
INSTDIR=/usr/lib/pd/extra

# flext stuff  ### EDIT! ###
FLEXTPATH=/usr/local/include/flext
FLEXTLIB=/usr/local/lib/libflext-pd_s.a

# compiler+linker stuff	### EDIT! ###
INCLUDES=/usr/lib/pd/include
FLAGS=-DPD
CFLAGS=-O3 -DPD -DUNIX -DMACOSX -O3 \
    -Wall -W -Wstrict-prototypes \
    -Wno-unused -Wno-parentheses -Wno-switch
LIBS=m

# stk stuff
STKPATH=/usr/local/include/stk
STKLIB=/usr/local/lib/libstk.a

# the rest can stay untouched
# ----------------------------------------------

# all the source files from the package
SRCS=clarinet.cpp

TARGET=$(TARGDIR)/$(NAME)~.pd_darwin

# default target
all: $(TARGDIR) $(TARGET)

$(SRCS): $(HDRS)
	touch $@

$(TARGDIR):
	mkdir $(TARGDIR)

$(TARGDIR)/%.o : %.cpp
	$(CXX) -c $(CFLAGS) $(FLAGS) $(patsubst %,-I%,$(INCLUDES) $(STKPATH) $(FLEXTPATH)) $< -o $@

$(TARGET) : $(patsubst %.cpp,$(TARGDIR)/%.o,$(SRCS)) $(FLEXTLIB) $(STKLIB) 
	$(CXX) $(LDFLAGS) -shared $^ $(patsubst %,-l%,$(LIBS)) -o $@ 
	chmod 755 $@

$(INSTDIR):
	mkdir $(INSTDIR)

install:: $(INSTDIR)

install:: $(TARGET)  
	cp $^ $(INSTDIR)
	chown root.root $(patsubst %,$(INSTDIR)/%,$(notdir $^))

.PHONY: clean
clean:
	rm -f $(TARGDIR)/*.o $(TARGET)


