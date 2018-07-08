//==================================================
// Author : Chris Le
// Email  : lehoangcuong1990@gmail.com
// Date   : July 08, 2018
//==================================================
 
`ifndef _ALU_BNZ_SEQ_
`define _ALU_BNZ_SEQ_
class alu_bnz_seq extends alu_seq;
  `uvm_object_utils(alu_bnz_seq)

  function new(string name="alu_bnz_seq");
    super.new(name);
  endfunction : new

  virtual function bit get_trans(alu_trans trans);
    bit hit;
    if(!std::randomize(hit)) begin
      `uvm_fatal("ALU_BNZ_SEQ", "Randomized failed")
    end
    return (trans.randomize() with {
      opcode_m == BNZ;
      hit == 1 -> (operand1_m == 8'h0);
      hit == 0 -> (operand1_m != 8'h0);
    });
  endfunction : get_trans

  virtual task body;
    super.body();
  endtask : body
endclass : alu_bnz_seq
`endif
