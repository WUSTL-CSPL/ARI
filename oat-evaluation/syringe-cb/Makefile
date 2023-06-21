TEST ?= test_combo
# CC = aarch64-linux-gnu-gcc
NUC_PC ?= your-pc-ip 
objdump ?= aarch64-linux-gnu-objdump 
hikey ?= your-hikey-board-ip 
TEEC_EXPORT ?=../../optee_client-master/out/export
TA ?= /your/path/to/work/tee_workspace/devel/optee_hikey_debian/hello_world/ta
GCC = arm-linux-gnueabihf-gcc
RESERVE_R8 = -ffixed-r8



# CFLAGS += -Wall -I$(TA)/include -I$(TEEC_EXPORT)/include -I./include
#Add/link other required libraries here
LDADD += -lteec -L$(TEEC_EXPORT)/lib -I$(TEEC_EXPORT)/include -mfloat-abi=hard -O0 -g -c -gdwarf-5 -fPIC



NOVA_PATH = ~/work/llvm-env/build/lib/
LLC_ARM = llc
LLVM_DIS = llvm-dis
OPT = ~/work/llvm-env/build/bin/opt

VM = your-server-for-llvm:~/work/ra-project/evaluation/syringe-cb/

TARGET = --target=arm-linux-gnueabihf

RPI3_GCC_CONFIG = -I/media/rpi/usr/include/arm-linux-gnueabihf -mfloat-abi=hard -O0 -g -gdwarf-5 -fverbose-asm
RPI3_GCC_CONFIG += -Wall
# RPI3_CONFIG = -I/media/rpi/usr/include/arm-linux-gnueabihf
RPI3_LLC_CONFIG = -float-abi=hard -filetype=obj 
# RPI3_LLC_CONFIG = -float-abi=hard
RPI3_LLC_CONFIG_ASM = -float-abi=hard
TRAMPOLINE_GCC_CONFIG = -mfloat-abi=hard -O0 -fPIC -g -c -Wall
TRAMPOLINE_PATH =../../trampoline_lib

ta_trampoline:
	$(GCC) $(LDADD)  ta_trampoline.c -o ta_trampoline.o -lc

trampoline:
	$(GCC) $(TRAMPOLINE_GCC_CONFIG) $(TRAMPOLINE_PATH)/trampoline_fw.S -o $(TRAMPOLINE_PATH)/trampoline_fw.o
	$(GCC) $(TRAMPOLINE_GCC_CONFIG) $(TRAMPOLINE_PATH)/shared_data_sections.S -o $(TRAMPOLINE_PATH)/shared_data_sections.o
	$(GCC) $(TRAMPOLINE_GCC_CONFIG) $(TRAMPOLINE_PATH)/trampoline.S -o $(TRAMPOLINE_PATH)/trampoline.o

ict_checking:
	clang $(TARGET) $(RPI3_GCC_CONFIG) -S -emit-llvm $(TRAMPOLINE_PATH)/ict_checking.c -o $(TRAMPOLINE_PATH)/ict_checking.bc

util:
	clang $(TARGET) $(RPI3_GCC_CONFIG) -S -emit-llvm util.c -o util.bc

lcd:
	clang $(TARGET) $(RPI3_GCC_CONFIG) -S -emit-llvm LiquidCrystal.c -o LiquidCrystal.bc

led:
	clang $(TARGET) $(RPI3_GCC_CONFIG) -S -emit-llvm led.c -o led.bc

syringe:
	clang $(TARGET) $(RPI3_GCC_CONFIG) -S -emit-llvm syringePump.c -o syringePump.bc

test-combo: syringe led lcd util trampoline ict_checking
	llvm-link syringePump.bc util.bc led.bc LiquidCrystal.bc $(TRAMPOLINE_PATH)/ict_checking.bc -o test_combo.bc

cit_checking_obj:
	$(GCC) $(TRAMPOLINE_GCC_CONFIG) $(RESERVE_R8) $(TRAMPOLINE_PATH)/ict_checking.c -o $(TRAMPOLINE_PATH)/ict_checking.o



opt-combo: test-combo
# 	#$(opt) -load $(NOVA_PATH)/LLVMNova.so -nova < test_combo.bc > combo.bc 2>/dev/null
# 	$(OPT) -load $(NOVA_PATH)/LLVMNova.so -nova < test_combo.bc > combo.bc 2>clog.txt
# 	$(OPT) -load $(NOVA_PATH)/LLVMCollectCFVHints.so -collect-ibranch-hints-pass -collect-icall-hints-pass -collect-cond-branch-hints-pass < combo.bc > combo_hints.bc
# 	$(LLC_ARM) -march=aarch64  -aarch64-enable-cfv combo_hints.bc -o combo.s
	$(LLC_ARM)  $(RPI3_LLC_CONFIG) test_combo.bc -o combo.s
# 	$(GCC)  $(RPI3_GCC_CONFIG) -Wl,--verbose combo.s -o final_syringe
# 	clang  $(RPI3_CONFIG) combo.s -o syringe

llvm-dis-comp:
	$(LLVM_DIS) after_compartment_test_combo.bc -o after_compartment_test_combo.ll

llc-comp:
	$(LLC_ARM)  $(RPI3_LLC_CONFIG) after_compartment_test_combo.bc -o after_comp_combo.s	

llc-comp-asm:
	$(LLC_ARM)  $(RPI3_LLC_CONFIG_ASM) after_compartment_test_combo.bc -o after_comp_combo_asm.s	


LLVMGOLD = /home/ari-new-ae/conattestllvm/build/lib/LLVMgold.so
LD = arm-linux-gnueabihf-ld
LDFLAGS = -plugin=$(LLVMGOLD) --plugin-opt=save-temps -g --plugin-opt=-float-abi=hard -L/home/ari-new-ae/conattestllvm/build/bin/../lib -L//lib -L//usr/lib -lm -lrt
HEXBOX_ANALYSIS_FILE = llvm_pdg.json
HEXBOX_SIZE_FILE = llvm_size.json
# TARGET = syringe

pdg-generate: combo.s
	$(LD) combo.s $(LDFLAGS) \
	--plugin-opt=-info-output-file=$@.stats -o $@ -g \
	--plugin-opt=-hexbox-analysis-results=$(HEXBOX_ANALYSIS_FILE) \
	--plugin-opt=-hexbox-analysis-size=$(HEXBOX_SIZE_FILE) \
	-o $(TARGET)--baseline.elf >/dev/null 2>/dev/null	



# Run Analysis on IR
# $(HEXBOX_ANALYSIS_FILE): $(HEXBOX_IR_FILE) Makefile | $(HEXBOX_DIR)
# 	$(LD) $(ASM_OBJECTS) $(HEXBOX_IR_FILE) $(LDFLAGS) -T$(LDSCRIPT) \
# 	--plugin-opt=-info-output-file=$@.stats -o $@ -g \
# 	--plugin-opt=-hexbox-analysis-results=$(HEXBOX_ANALYSIS_FILE) \
# 	--plugin-opt=-hexbox-analysis-size=$(HEXBOX_SIZE_FILE) \
# 	-o $(BIN_DIR)/$(TARGET)--baseline.elf >/dev/null 2>/dev/null

send-combo-bc:
	scp -i vm test_combo.bc $(VM)

send-combo-s:
	scp combo.s nuc:~/tmp/hikey-relay/

fetch-combo-s:
	scp $(VM)/combo.s . 

asm-combo:
	$(LLC_ARM) -march=aarch64  -aarch64-enable-cfv=false test_combo.bc -o combo.s

opt-hello:
	$(opt) -load $(NOVA_PATH)/LLVMNova.so -nova < hello.bc > combo.bc 2>/dev/null
	$(opt) -load $(NOVA_PATH)/LLVMCollectCFVHints.so -collect-ibranch-hints-pass -collect-icall-hints-pass -collect-loop-hints-pass < combo.bc > combo_hints.bc
	$(LLC_ARM) -march=aarch64  -aarch64-enable-cfv combo_hints.bc -o combo.s

bin:
	clang combo.s -L../../data/runtime -lm -lrt  -lsoftboundcets_rt  -lnova -lteec
