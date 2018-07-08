//==================================================
// Author : Chris Le
// Email  : lehoangcuong1990@gmail.com
// Date   : July 08, 2018
//==================================================
 
`ifndef _ALU_TEST_PKG_
`define _ALU_TEST_PKG_
package alu_test_pkg;
  import uvm_pkg::*;
  import alu_env_pkg::*;
  import alu_seq_pkg::*;
  `include "alu_test.sv"
  `include "alu_add_test.sv"
  `include "alu_sub_test.sv"
  `include "alu_and_test.sv"
  `include "alu_or_test.sv"
  `include "alu_xor_test.sv"
  `include "alu_not_test.sv"
  `include "alu_sll_test.sv"
  `include "alu_srl_test.sv"
  `include "alu_rll_test.sv"
  `include "alu_rrl_test.sv"
  `include "alu_bez_test.sv"
  `include "alu_bnz_test.sv"
  `include "alu_slt_test.sv"
  `include "alu_cpseq_test.sv"
  `include "alu_cpslt_test.sv"
  `include "alu_cpsgt_test.sv"
  `include "alu_reg_reset_test.sv"
  `include "alu_reg_bitbash_test.sv"
  `include "alu_nodelay_test.sv"
  `include "alu_longdelay_test.sv"
  `include "alu_error_test.sv"
endpackage : alu_test_pkg
`endif

