//==================================================
// Author : Chris Le
// Email  : lehoangcuong1990@gmail.com
// Date   : July 08, 2018
//==================================================
 
`ifndef _ALU_REG_RESET_TEST_
`define _ALU_REG_RESET_TEST_
class alu_reg_reset_test extends alu_test;
  `uvm_component_utils(alu_reg_reset_test)
  uvm_reg_hw_reset_seq reg_reset_seq_m;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    reg_reset_seq_m = uvm_reg_hw_reset_seq::type_id::create("reg_reset_seq_m");
    reg_reset_seq_m.model = alu_ral_m;
  endfunction : build_phase 

  virtual task configure_phase(uvm_phase phase);
    phase.raise_objection(this);
    reg_reset_seq_m.start(null);
    phase.drop_objection(this);
  endtask : configure_phase

  virtual task main_phase(uvm_phase phase);
  endtask : main_phase
endclass : alu_reg_reset_test
`endif
