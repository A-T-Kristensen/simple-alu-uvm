//==================================================
// Author : Chris Le
// Email  : lehoangcuong1990@gmail.com
// Date   : July 08, 2018
//==================================================
 
`ifndef _ALU_SEQ_CFG_
`define _ALU_SEQ_CFG_
class alu_seq_cfg extends uvm_object;
  `uvm_object_utils(alu_seq_cfg)
  rand int num_trans_m;

  constraint c_num_trans {
    num_trans_m inside {[1:50]};
  }

  function new(string name="alu_seq_cfg");
    super.new(name);
  endfunction : new
endclass : alu_seq_cfg
`endif
