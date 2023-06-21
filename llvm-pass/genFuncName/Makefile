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

run:
	llvm-link -o Mavlink.bc $(ASRC)/libraries/GCS_MAVLink/GCS_Param.cpp.0.o $(ASRC)/libraries/GCS_MAVLink/GCS_serial_control.cpp.0.o $(ASRC)/libraries/GCS_MAVLink/GCS.cpp.0.o $(ASRC)/libraries/GCS_MAVLink/GCS_DeviceOp.cpp.0.o $(ASRC)/libraries/GCS_MAVLink/GCS_MAVLink.cpp.0.o $(ASRC)/libraries/GCS_MAVLink/GCS_Signing.cpp.0.o $(ASRC)/libraries/GCS_MAVLink/GCS_Common.cpp.0.o $(ASRC)/libraries/GCS_MAVLink/GCS_ServoRelay.cpp.0.o $(ASRC)/libraries/GCS_MAVLink/GCS_Rally.cpp.0.o $(ASRC)/libraries/GCS_MAVLink/MAVLink_routing.cpp.0.o 
	opt -load=./rddep.so -rddep ./Mavlink.bc -rddep-analysis-results test.json
# > /dev/null is for stderr. 
