//==================================================
// Author : Chris Le
// Email  : lehoangcuong1990@gmail.com
// Date   : July 08, 2018
//==================================================
 
`ifndef _ALU_SLL_SEQ_
`define _ALU_SLL_SEQ_
class alu_sll_seq extends alu_seq;
  `uvm_object_utils(alu_sll_seq)

  function new(string name="alu_sll_seq");
    super.new(name);
  endfunction : new

  virtual function bit get_trans(alu_trans trans);
    return (trans.randomize() with {
      opcode_m == SLL;
    });
  endfunction : get_trans

  virtual task body;
    super.body();
  endtask : body
endclass : alu_sll_seq
`endif
