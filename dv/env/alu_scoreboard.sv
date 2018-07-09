//==================================================
// Author : Chris Le
// Email  : lehoangcuong1990@gmail.com
// Date   : July 08, 2018
//==================================================
 
`ifndef _ALU_SCOREBOARD_
`define _ALU_SCOREBOARD_
`uvm_analysis_imp_decl(_legacy)
`uvm_analysis_imp_decl(_request)
`uvm_analysis_imp_decl(_apb)
class alu_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(alu_scoreboard)
  uvm_analysis_imp_legacy#(alu_trans, alu_scoreboard) legacy_export_m;
  uvm_analysis_imp_request#(alu_trans, alu_scoreboard) request_export_m;
  uvm_analysis_imp_apb#(apb_seq_item, alu_scoreboard) apb_export_m;

  alu_trans exp_trans_q_m[$];
  alu_trans act_trans_q_m[$];

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    apb_export_m = new("apb_export_m", this);
    legacy_export_m = new("legacy_export_m", this);
    request_export_m = new("request_export_m", this);
  endfunction : build_phase 

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction : connect_phase 

  function void write_apb(apb_seq_item trans);
    `uvm_info("ALU_SB", "Received APB transaction", UVM_NONE)
  endfunction : write_apb

  function void write_legacy(alu_trans trans);
    `uvm_info("ALU_SB", "Received legacy transaction", UVM_NONE)
    trans.print();
    act_trans_q_m.push_back(trans); 
  endfunction : write_legacy

  function void write_request(alu_trans trans);
    `uvm_info("ALU_SB", "Received request transaction", UVM_NONE)
    trans.print();
    case(trans.opcode_m)
      ADD: begin
        bit[8:0] result = (trans.operand1_m + trans.operand2_m);
        trans.result_m = result[7:0];
        trans.status_m = {result[8], 4'b0};
      end
      SUB: begin
        bit[8:0] result = (trans.operand1_m - trans.operand2_m);
        trans.result_m = result[7:0];
        trans.status_m = {1'b0, result[8], 3'b0};
      end
      AND: begin
        trans.result_m = (trans.operand1_m & trans.operand2_m);
        trans.status_m = 5'b0;
      end
      OR: begin
        trans.result_m = (trans.operand1_m | trans.operand2_m);
        trans.status_m = 5'b0;
      end
      XOR: begin
        trans.result_m = (trans.operand1_m ^ trans.operand2_m);
        trans.status_m = 5'b0;
      end
      NOT: begin
        trans.result_m = ~trans.operand1_m;
        trans.status_m = 5'b0;
      end
      SLL: begin
        trans.result_m = trans.operand1_m << (trans.operand2_m % 8);
        trans.status_m = 5'b0;
      end
      SRL: begin
        trans.result_m = trans.operand1_m >> (trans.operand2_m % 8);
        trans.status_m = 5'b0;
      end
      RLL: begin
        trans.result_m = trans.operand1_m;
        trans.status_m = 5'b0;
        repeat(trans.operand2_m % 8) begin
          trans.result_m = {trans.result_m[6:0], trans.result_m[7]};
        end
      end
      RRL: begin
        trans.result_m = trans.operand1_m;
        trans.status_m = 5'b0;
        repeat(trans.operand2_m % 8) begin
          trans.result_m = {trans.result_m[0], trans.result_m[7:1]};
        end
      end
      CMPEQ: begin
        trans.result_m = 8'b0;
        trans.status_m = {2'b0, (trans.operand1_m == trans.operand2_m), 2'b0};
      end
      CMPLT: begin
        trans.result_m = 8'b0;
        trans.status_m = {3'b0, (trans.operand1_m < trans.operand2_m), 1'b0};
      end
      CMPGT: begin
        trans.result_m = 8'b0;
        trans.status_m = {4'b0, (trans.operand1_m > trans.operand2_m)};
      end
      default: begin
        trans.result_m = 8'b0;
        trans.status_m = 5'b0;
      end
    endcase
    exp_trans_q_m.push_back(trans);
  endfunction : write_request

  virtual task run_phase(uvm_phase phase);
    fork
      compare_trans();
    join_none
  endtask : run_phase

  task compare_trans();
    alu_trans act_trans;
    alu_trans exp_trans;
    forever begin
      wait((exp_trans_q_m.size() > 0) && (act_trans_q_m.size() > 0));
      act_trans = act_trans_q_m.pop_front();
      exp_trans = exp_trans_q_m.pop_front();

      // TODO: act_trans.compare(exp_trans));;
      
      if(act_trans.opcode_m != exp_trans.opcode_m) begin
        `uvm_error("ALU_SB", $psprintf("Mismatched opcode, expected = 0x%0x, actual = 0x%0x", exp_trans.opcode_m, act_trans.opcode_m))
      end
      if(act_trans.operand1_m != exp_trans.operand1_m) begin
        `uvm_error("ALU_SB", $psprintf("Mismatched operand1, expected = 0x%0x, actual = 0x%0x", exp_trans.operand1_m, act_trans.operand1_m))
      end
      if(act_trans.operand2_m != exp_trans.operand2_m) begin
        `uvm_error("ALU_SB", $psprintf("Mismatched operand2, expected = 0x%0x, actual = 0x%0x", exp_trans.operand2_m, act_trans.operand2_m))
      end
      if(act_trans.result_m != exp_trans.result_m) begin
        `uvm_error("ALU_SB", $psprintf("Mismatched result, expected = 0x%0x, actual = 0x%0x", exp_trans.result_m, act_trans.result_m))
      end
      if(act_trans.status_m != exp_trans.status_m) begin
        `uvm_error("ALU_SB", $psprintf("Mismatched status, expected = 0x%0x, actual = 0x%0x", exp_trans.status_m, act_trans.status_m))
      end
    end
  endtask : compare_trans

  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    if(act_trans_q_m.size()) begin
      `uvm_error("ALU_SB", $psprintf("The actual trans queue hasn't completed %0d", act_trans_q_m.size()))
    end
    if(exp_trans_q_m.size()) begin
      `uvm_error("ALU_SB", $psprintf("The expected trans queue hasn't completed %0d", exp_trans_q_m.size()))
    end
  endfunction : report_phase
endclass : alu_scoreboard
`endif
