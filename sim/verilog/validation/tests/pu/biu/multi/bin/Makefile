###################################################################################
##                                            __ _      _     _                  ##
##                                           / _(_)    | |   | |                 ##
##                __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |                 ##
##               / _` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |                 ##
##              | (_| | |_| |  __/  __/ | | | | | |  __/ | (_| |                 ##
##               \__, |\__,_|\___|\___|_| |_|_| |_|\___|_|\__,_|                 ##
##                  | |                                                          ##
##                  |_|                                                          ##
##                                                                               ##
##                                                                               ##
##              MPSoC-RV64 CPU                                                   ##
##              Regression Test Makefile                                         ##
##                                                                               ##
###################################################################################

###################################################################################
##                                                                               ##
## Copyright (c) 2017-2018 by the author(s)                                      ##
##                                                                               ##
## Permission is hereby granted, free of charge, to any person obtaining a copy  ##
## of this software and associated documentation files (the "Software"), to deal ##
## in the Software without restriction, including without limitation the rights  ##
## to use, copy, modify, merge, publish, distribute, sublicense, and/or sell     ##
## copies of the Software, and to permit persons to whom the Software is         ##
## furnished to do so, subject to the following conditions:                      ##
##                                                                               ##
## The above copyright notice and this permission notice shall be included in    ##
## all copies or substantial portions of the Software.                           ##
##                                                                               ##
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR    ##
## IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,      ##
## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE   ##
## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER        ##
## LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, ##
## OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN     ##
## THE SOFTWARE.                                                                 ##
##                                                                               ##
## ============================================================================= ##
## Author(s):                                                                    ##
##   Francisco Javier Reina Campo <pacoreinacampo@queenfield.tech>               ##
##                                                                               ##
###################################################################################

all: regression

SIMULATORS = iverilog msim vivado
SIM        = msim

MS     = -s

ROOT_DIR=../../../../../../../..
TST_SRC_DIR=$(ROOT_DIR)/../software/tests/hex


##########################################################################
# Regression variables
##########################################################################
REGRESSION_MEM_LATENCY      = 0 1 3 8 
REGRESSION_XLEN             = 32
REGRESSION_WRITEBUFFER_SIZE = 0 
REGRESSION_ICACHE_SIZE      = 0 4
REGRESSION_DCACHE_SIZE      = 0 4
REGRESSION_MULT_LATENCY     = 3 2 1 0


##########################################################################
# Tests
##########################################################################
XLEN = 32

HAS_RVI = 1
HAS_RVA = 1
HAS_RVM = 1
HAS_RVF = 1
HAS_RVD = 1
HAS_RVC = 1

HAS_U = 1
HAS_S = 1
HAS_H = 1
HAS_M = 1

# user mode tests
USER_RVI_TESTS = \
add \
addi \
and \
andi \
auipc \
beq \
bge \
bgeu \
blt \
bltu \
bne \
fence_i \
jal \
jalr \
lb \
lbu \
lh \
lhu \
lui \
lw \
or \
ori \
sb \
sh \
simple \
sll \
slli \
slt \
slti \
sltiu \
sltu \
sra \
srai \
srl \
srli \
sub \
sw \
xor \
xori \

$(if $(filter 64, $(XLEN)), \
addiw \
addw \
ld \
lwu \
sd \
slliw \
slliw \
sllw \
sllw \
sltiu \
sltu \
sraiw \
sraw \
srliw \
srlw \
subw \
)

USER_RVC_TESTS = \
rvc

USER_RVA_TESTS = \
amoadd_w \
amoand_w \
amomaxu_w \
amomax_w \
amominu_w \
amomin_w \
amoor_w \
amoswap_w \
amoxor_w \
lrsc \

$(if $(filter 64, $(XLEN)), \
amoadd_d \
amoand_d \
amomax_d \
amomaxu_d \
amomin_d \
amominu_d \
amoor_d \
amoswap_d \
amoxor_d \
)

USER_RVM_TESTS = \
div \
divu \
mul \
mulh \
mulhsu \
mulhu \
rem \
remu \

$(if $(filter 64, $(XLEN)), \
divuw \
divw \
mulw \
remuw \
remw \
)

USER_RVF_TESTS = \
fadd \
fclass \
fcmp \
fcvt \
fcvt_w \
fdiv \
fmadd \
fmin \
ldst \
recoding \

# supervisor mode tests
SUPERVISOR_RVI_TESTS = \
csr \
dirty \
illegal \
ma_fetch \
sbreak \
scall \
wfi

# machine mode tests
MACHINE_RVI_TESTS = \
breakpoint \
csr \
illegal \
ma_addr \
ma_fetch \
mcsr \
sbreak \
scall \

$(if $(filter 64, $(XLEN)), \
shamt \
)

# User Mode RVI Tests
utst_lst += $(if $(HAS_RVI) > 0, $(foreach t, $(USER_RVI_TESTS),rv$(XLEN)ui-p-$t))

# User Mode RVM Tests
utst_lst += $(if $(HAS_RVM) > 0, $(foreach t, $(USER_RVM_TESTS),rv$(XLEN)um-p-$t))

# User Mode RVA Tests
utst_lst += $(if $(HAS_RVA) > 0, $(foreach t, $(USER_RVA_TESTS),rv$(XLEN)ua-p-$t))

# User Mode RVF Tests
utst_lst += $(if $(HAS_RVF) > 0, $(foreach t, $(USER_RVF_TESTS),rv$(XLEN)uf-p-$t))

# User Mode RVF Tests
utst_lst += $(if $(HAS_RVD) > 0, $(foreach t, $(USER_RVD_TESTS),rv$(XLEN)ud-p-$t))

# User Mode RVC Tests
#utst_lst += $(if $(HAS_RVC) > 0, $(foreach t, $(USER_RVC_TESTS),rv$(XLEN)uc-p-$t))

utests    = $(if $(HAS_U)   > 0, $(utst_lst))

# Supervisor Mode RVI Tests
sitst_lst = $(SUPERVISOR_RVI_TESTS)
sitests   = $(if $(HAS_S) > 0, $(foreach t, $(sitst_lst),rv$(XLEN)si-p-$t))

# Hypervisor Mode RVI Tests
hitst_lst = $(HYPERVISOR_RVI_TESTS)
hitests   = $(if $(HAS_H) > 0, $(foreach t, $(hitst_lst),rv$(XLEN)hi-p-$t))

# Machine Mode RVI Tests
mitst_lst = $(MACHINE_RVI_TESTS)
mitests   = $(if $(HAS_M) > 0, $(foreach t, $(mitst_lst),rv$(XLEN)mi-p-$t))

# All Tests
tests = $(utests) $(mitests)


############################################################################
# Functions
############################################################################
add_regression    = $(foreach p,$(REGRESSION_$(1)), $(addprefix $(1)$(p)@, $(2)))
add_regression_if = $(if $(filter $(2), $(subst -, , $(1))), $(call add_regression,$(3),$(4)),$(4))

logs = $(call add_regression,DCACHE_SIZE, \
       $(call add_regression,ICACHE_SIZE, \
       $(call add_regression,MEM_LATENCY, \
       $(call add_regression,WRITEBUFFER_SIZE, \
       $(call add_regression,XLEN, \
       $(foreach t,$(tests), \
         $(call add_regression_if,$t,$(U_MUL_TESTS),MULT_LATENCY, \
         $t.log \
         ) \
       ) \
       ) \
       ) \
       ) \
       ) \
       )

regression: $(logs)

%.log:
	$(MAKE) $(SIM) LOG=./log/$(@F) \
	  PARAMETERS=" HEX_FILE=\"$(TST_SRC_DIR)/$(lastword $(subst @, ,$*)).hex\" "


##########################################################################
# Includes
##########################################################################
-include Makefile.include


##########################################################################
# Make Targets
##########################################################################
.PHONY: $(SIMULATORS)
$(SIMULATORS): % : %/Makefile
	@$(MAKE) $(MS) -C $@ sim                                 \
	VLOG="$(abspath $(PACKAGE_VLOG) $(RTL_VLOG) $(TB_VLOG))" \
	VHDL="$(abspath $(PACKAGE_VHDL) $(RTL_VHDL) $(TB_VHDL))" \
	TOP=$(TB_TOP)                                            \
	LOG=$(LOG) PARAMETERS="$(PARAMETERS)"


##########################################################################
# Make simulation structure
##########################################################################
Makefile.include:
	@cp ../bin/Makefile.include .

%/Makefile:
	@mkdir -p $*
	@cp ../bin/sims/Makefile.$* $@
