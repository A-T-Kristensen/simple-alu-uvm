//==================================================
// Author : Chris Le
// Email  : lehoangcuong1990@gmail.com
// Date   : July 08, 2018
//==================================================
 
`ifndef _ALU_SEQ_
`define _ALU_SEQ_
class alu_seq extends uvm_sequence;
  `uvm_object_utils(alu_seq)
  alu_seq_cfg cfg_m;

  function new(string name="alu_seq");
    super.new(name);
  endfunction : new

  virtual function bit get_trans(alu_trans trans);
    return (trans.randomize() with {
      opcode_m inside {ADD, SUB, AND, OR, XOR, NOT, SLL, SRL, RLL, RRL, CMPEQ, CMPLT, CMPGT};
    });
  endfunction : get_trans

  virtual task pre_body;
    assert(uvm_config_db#(alu_seq_cfg)::get(m_sequencer, "", "alu_seq_cfg", cfg_m))
    else begin
      `uvm_fatal("ALU_SEQ", "Unable to get alu_seq_cfg")
    end
  endtask : pre_body

  virtual task body;
    alu_trans trans;
    repeat(cfg_m.num_trans_m) begin
      trans = new;
      start_item(trans);
      if(!get_trans(trans))begin
        `uvm_fatal("ALU_SEQ", "Randomized trans failed!")
      end
      finish_item(trans);
    end
  endtask : body
endclass : alu_seq
`endif
