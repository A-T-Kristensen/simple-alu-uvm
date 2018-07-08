//==================================================
// Author : Chris Le
// Email  : lehoangcuong1990@gmail.com
// Date   : July 08, 2018
//==================================================
 
`ifndef _ALU_COVERAGE_
`define _ALU_COVERAGE_
class alu_coverage extends uvm_subscriber#(alu_trans);
  `uvm_component_utils(alu_coverage)
  alu_trans trans_m;

  covergroup cg_alu_format;
    cp_alu_opcode: coverpoint trans_m.opcode_m {
      bins opcode_add   = {5'b00001};
      bins opcode_sub   = {5'b00010};
      bins opcode_and   = {5'b00011};
      bins opcode_or    = {5'b00100};
      bins opcode_xor   = {5'b00101};
      bins opcode_not   = {5'b00110};
      bins opcode_sll   = {5'b00111};
      bins opcode_srl   = {5'b01000};
      bins opcode_rll   = {5'b01001};
      bins opcode_rrl   = {5'b01010};
      bins opcode_bez   = {5'b01011};
      bins opcode_bnz   = {5'b01100};
      bins opcode_slt   = {5'b01101};
      bins opcode_cpseq = {5'b01110};
      bins opcode_cpslt = {5'b01111};
      bins opcode_cpsgt = {5'b10000};
      bins opcode_error = {5'b00000, [5'b10001:5'b11111]};
    }
    cp_alu_operand1: coverpoint trans_m.operand1_m {
      bins operand1_0 = {8'h00};
      bins operand1_1 = {8'h01};
      bins operand1_2 = {[8'h02:8'hfd]};
      bins operand1_3 = {8'hfe};
      bins operand1_4 = {8'hff};
    }
    cp_alu_operand2: coverpoint trans_m.operand2_m {
      bins operand2_0 = {8'h00};
      bins operand2_1 = {8'h01};
      bins operand2_2 = {[8'h02:8'hfd]};
      bins operand2_3 = {8'hfe};
      bins operand2_4 = {8'hff};
    }
    cc_alu_format: cross cp_alu_opcode, cp_alu_operand1, cp_alu_operand2;
  endgroup: cg_alu_format

  covergroup cg_alu_status;
    cp_alu_status: coverpoint trans_m.status_m {
      bins status_carry = {5'b10000};
      bins status_zero  = {5'b01000};
      bins status_eq    = {5'b00100};
      bins status_lt    = {5'b00010};
      bins status_gt    = {5'b00001};
    }
  endgroup : cg_alu_status

  covergroup cg_alu_result;
    cp_alu_result: coverpoint trans_m.result_m {
      bins result_0 = {8'h00};
      bins result_1 = {8'h01};
      bins result_2 = {[8'h02:8'hfd]};
      bins result_3 = {8'hfe};
      bins result_4 = {8'hff};
    }
  endgroup : cg_alu_result

  function new(string name, uvm_component parent);
    super.new(name, parent);
    cg_alu_format = new();
    cg_alu_status = new();
    cg_alu_result = new();
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction : build_phase 

  function void write(T t);
    $cast(trans_m, t);
    cg_alu_format.sample();
    cg_alu_status.sample();
    cg_alu_result.sample();
  endfunction : write
endclass : alu_coverage
`endif
