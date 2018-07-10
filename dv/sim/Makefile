###################################################
# Author : Chris Le
# Email  : lehoangcuong1990@gmail.com
# Date   : July 08, 2018
###################################################

# NOTE: 
# Makefile for Simulation Tests
# Change PLI_PATH for your environment
# Change UVM_HOME for your environment

export ALU_HOME = ${PWD}/../..
export RTL_HOME = ${ALU_HOME}/rtl
export DV_HOME  = ${ALU_HOME}/dv
UVM_HOME   = ${ALU_HOME}/uvm/uvm-1.1d
PLI_PATH   = ${NOVAS_HOME}/share/PLI/VCS/LINUX
VCS        = vcs -sverilog -timescale=1ns/1ns +v2k +acc +vpi -PP -P ${PLI_PATH}/novas.tab ${PLI_PATH}/pli.a +incdir+${UVM_HOME}/src ${UVM_HOME}/src/dpi/uvm_dpi.cc -CFLAGS -DVCS ${UVM_HOME}/src/uvm_pkg.sv
SIMV       = simv
VERDI      = verdi -autoalias -nologo
URG        = urg -full64 -warn none -format both
SEED       = 1
TEST       = alu_test
COV_DB     = simv.vdb
all: compile simulate

compile:
	${VCS} -f ${DV_HOME}/tb/alu.f ${OPT}

simulate:
	${SIMV} +UVM_TESTNAME=${TEST} +seed=${SEED} +ntb_random_seed=${SEED} +debussy -l simulate.log ${OPT}

waveform: 
	${VERDI} -ssf debussy.fsdb -f ${DV_HOME}/tb/alu.f -top alu_tb ${OPT}

coverage: 
	${URG} -dir ${COV_DB} -report coverage_report ${OPT}

.PHONY: all

clean:
	@find . -maxdepth 1 \( -type f -o -type d \) \( ! -name '.' -a ! -name 'Makefile' -a ! -name '*.csh' -a ! -name '*.f' -a ! -name '*.pl' \) -exec rm -rf {} +
