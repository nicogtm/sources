# Copyright (c) 2013 by the author(s)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
# Author(s):
#   Stefan Wallentowitz <stefan@wallentowitz.de>

lib_LTLIBRARIES = liboptimsocsim.la

liboptimsocsim_ladir = $(includedir)/optimsoc-sim

liboptimsocsim_la_SOURCES =\
    OptionsParser.cpp \
    VerilatedControl.cpp

liboptimsocsim_la_HEADERS =\
    OptionsParser.h \
    VerilatedToplevel.h \
    VerilatedControl.h

liboptimsocsim_la_LDFLAGS = $(AM_LDFLAGS) $(LTLDFLAGS)
liboptimsocsim_la_CPPFLAGS = $(AM_CPPFLAGS) $(verilator_CFLAGS)

makefilesdir = $(datadir)/optimsoc-sim
makefiles_DATA = share/Makefile.verilator.inc

