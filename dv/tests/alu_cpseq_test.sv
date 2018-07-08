//==================================================
// Author : Chris Le
// Email  : lehoangcuong1990@gmail.com
// Date   : July 08, 2018
//==================================================
 
`ifndef _ALU_CPSEQ_TEST_
`define _ALU_CPSEQ_TEST_
class alu_cpseq_test extends alu_test;
  `uvm_component_utils(alu_cpseq_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    alu_seq::type_id::set_type_override(alu_cpseq_seq::type_id::get());
    super.build_phase(phase);
  endfunction : build_phase 
endclass : alu_cpseq_test
`endif
