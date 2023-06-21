LLVM_CONFIG?=llvm-config
# LLVM_CONFIG?=/home/osboxes/Desktop/ACES/llvm/build/bin/llvm-config

ifdef SILENT
QUIET:=@
endif

SRC_DIR?=$(PWD)
LDFLAGS += -pthread $(shell $(LLVM_CONFIG) --system-libs) $(shell $(LLVM_CONFIG) --ldflags)
COMMON_FLAGS = -g
CXXFLAGS += $(COMMON_FLAGS) $(shell ($(LLVM_CONFIG) --cxxflags)) 
CPPFLAGS += $(shell ($(LLVM_CONFIG) --cppflags)) -I$(SRC_DIR) -I$(SRC_DIR)/json
ASRC=/home/osboxes/Desktop/conattest/ardupilot/build/sitl


ifeq ($(shell uname), Darwin)
LOADABLE_MODULE_OPTIONS=-bundle -undefined dynamic_lookup
else
#-shared create a shared library. -Wl,-o1 asks the GNU linker ld to optimize symbol table
LOADABLE_MODULE_OPTIONS=-shared -Wl,-O1
endif


# GENIR=genIR
# GENIR_OBJECTS=genIR.o

RDDEP=rddep.so
RDDEP_OBJECTS=rddep.o
JSON_OBJECTS=jsoncpp.o

default: $(RDDEP)

$(JSON_OBJECTS) : $(SRC_DIR)/jsoncpp.cpp
	@echo Compiling jsoncpp.cpp
	$(QUIET)$(CXX) -c $(CPPFLAGS) $(CXXFLAGS) $<

$(RDDEP_OBJECTS) : $(SRC_DIR)/rddep.cpp $(JSON_OBJECTS)
	$(QUIET)$(CXX) -c $(CPPFLAGS) $(CXXFLAGS) $<

$(RDDEP) : $(RDDEP_OBJECTS) $(JSON_OBJECTS)
	@echo Linking $@
	$(QUIET)$(CXX) -o $@ $(LOADABLE_MODULE_OPTIONS) $(CXXFLAGS) $^ $(LDFLAGS)

clean:
	$(QUIET)rm -f $(JSON_OBJECTS) $(RDDEP) $(RDDEP_OBJECTS)

# > /dev/null is for stderr. 
local-run: default
	cp ../genFuncName/test.json ./
	opt -load=./rddep.so -rddep ../insertHook/GCS_Common.cpp.0.o -rddep-analysis-results test.json -f >> GCS_Common.cpp.0.o

dis: local-run
	llvm-dis GCS_Common.cpp.0.o
	subl ./GCS_Common.cpp.0.o.ll
