SRCDIR      := src
INCLUDEDIR  := include

CXX := g++
LINKER := g++

# All CXX files grouped by sub-namespace
SRC_SUBDIRS     := $(shell find $(SRCDIR) -type d -print)
INCLUDE_SUBDIRS := $(shell find $(INCLUDEDIR) -type d -print)

CXXFILES           := $(foreach dir,$(SRC_SUBDIRS),$(wildcard $(dir)/*.cpp))
HEADERS            := $(foreach dir,$(INCLUDE_SUBDIRS),$(wildcard $(dir)/*.h))
ALLFILES                := $(CXXFILES) $(HEADERS)

CFLAGS      := -W -Wall -I -pthread -g
INCLUDE := -I$(INCLUDEDIR)/ -Ilib/
CXXFLAGS := -g -Wall -O3 -fmessage-length=0 $(INCLUDE)
LDFLAGS := 
LIBS :=

#Rules -----------------------------------------------------------------
.SUFFIX:
CXXOBJS  := $(CXXFILES:.cpp=.o)

%.o : %.cpp
	$(CXX) -c $< -o $@ $(CXXFLAGS)

adjapp: $(CXXFILES) $(HEADERS) $(LIBS)
	$(LINKER) -o server $(CXXOBJS) $(SYLVESTER_CXXOBJS) $(JSON_CXXOBJS) $(LDFLAGS) $(LIBS)

list:
	@echo $(CXXFILES)
	@echo "..."
	@echo $(HEADERS)

LINTFILTERS := -whitespace,-legal/copyright,-build/header_guard
lint:
	$(foreach myfile,$(filter-out src/json/%.cpp include/json/%.h,$(ALLFILES)),python cpplint.py --filter=$(LINTFILTERS) $(myfile);)

clean:
	rm -f server $(CXXOBJS)

.DEFAULT_GOAL := adjapp

#Libraries -----------------------------------------------------------------

lib/mongoose.o: 
	$(CC) $(CFLAGS) -c lib/mongoose/mongoose.c -o lib/mongoose.o
