//==================================================
// Author : Chris Le
// Email  : lehoangcuong1990@gmail.com
// Date   : July 08, 2018
//==================================================
 
`ifndef _ALU_SLT_TEST_
`define _ALU_SLT_TEST_
class alu_slt_test extends alu_test;
  `uvm_component_utils(alu_slt_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    alu_seq::type_id::set_type_override(alu_slt_seq::type_id::get());
    super.build_phase(phase);
  endfunction : build_phase 
endclass : alu_slt_test
`endif
