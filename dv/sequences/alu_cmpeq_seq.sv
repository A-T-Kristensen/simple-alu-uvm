//==================================================
// Author : Chris Le
// Email  : lehoangcuong1990@gmail.com
// Date   : July 08, 2018
//==================================================
 
`ifndef _ALU_CMPEQ_SEQ_
`define _ALU_CMPEQ_SEQ_
class alu_cmpeq_seq extends alu_seq;
  `uvm_object_utils(alu_cmpeq_seq)

  function new(string name="alu_cmpeq_seq");
    super.new(name);
  endfunction : new

  virtual function bit get_trans(alu_trans trans);
    bit hit;
    if(!std::randomize(hit)) begin
      `uvm_fatal("ALU_CMPEQ_SEQ", "Randomized failed")
    end
    return (trans.randomize() with {
      opcode_m == CMPEQ;
      hit == 1 -> (operand1_m == operand2_m);
      hit == 0 -> (operand1_m != operand2_m);
    });
  endfunction : get_trans

  virtual task body;
    super.body();
  endtask : body
endclass : alu_cmpeq_seq
`endif
