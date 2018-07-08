//==================================================
// Author : Chris Le
// Email  : lehoangcuong1990@gmail.com
// Date   : July 08, 2018
//==================================================
 
`ifndef _ALU_SLL_TEST_
`define _ALU_SLL_TEST_
class alu_sll_test extends alu_test;
  `uvm_component_utils(alu_sll_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    alu_seq::type_id::set_type_override(alu_sll_seq::type_id::get());
    super.build_phase(phase);
  endfunction : build_phase 
endclass : alu_sll_test
`endif
