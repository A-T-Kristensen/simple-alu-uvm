//==================================================
// Author : Chris Le
// Email  : lehoangcuong1990@gmail.com
// Date   : July 08, 2018
//==================================================
 
`ifndef _ALU_SEQ_PKG_
`define _ALU_SEQ_PKG_
package alu_seq_pkg;
  import uvm_pkg::*;
  import alu_env_pkg::*;
  `include "alu_seq_cfg.sv"
  `include "alu_seq.sv"
  `include "alu_add_seq.sv"
  `include "alu_sub_seq.sv"
  `include "alu_and_seq.sv"
  `include "alu_or_seq.sv"
  `include "alu_xor_seq.sv"
  `include "alu_not_seq.sv"
  `include "alu_sll_seq.sv"
  `include "alu_srl_seq.sv"
  `include "alu_rll_seq.sv"
  `include "alu_rrl_seq.sv"
  `include "alu_bez_seq.sv"
  `include "alu_bnz_seq.sv"
  `include "alu_slt_seq.sv"
  `include "alu_cpseq_seq.sv"
  `include "alu_cpslt_seq.sv"
  `include "alu_cpsgt_seq.sv"
  `include "alu_nodelay_seq.sv"
  `include "alu_longdelay_seq.sv"
  `include "alu_error_seq.sv"
endpackage : alu_seq_pkg
`endif

