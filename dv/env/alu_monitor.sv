//==================================================
// Author : Chris Le
// Email  : lehoangcuong1990@gmail.com
// Date   : July 08, 2018
//==================================================
 
`ifndef _ALU_MONITOR_
`define _ALU_MONITOR_
class alu_monitor extends uvm_monitor;
  `uvm_component_utils(alu_monitor)

  virtual alu_if vif_m;
  alu_trans trans_m[$];
  uvm_analysis_port#(alu_trans) request_port_m;
  uvm_analysis_port#(alu_trans) legacy_port_m;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    assert(uvm_config_db#(virtual alu_if)::get(null, "", "alu_if", vif_m)) 
    else begin
      `uvm_fatal("ALU_MONITOR", "Unable to get alu if!")
    end
    request_port_m = new("request_port_m", this);
    legacy_port_m = new("legacy_port_m", this);
  endfunction : build_phase 

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction : connect_phase 

  virtual task run_phase(uvm_phase phase);
    fork 
      request_monitor();
      legacy_monitor();
    join
  endtask : run_phase

  virtual task request_monitor();
    alu_trans request;
    forever begin
      if(vif_m.alu_enable) begin
        request = new();
        request.opcode_m = opcode_e'(vif_m.alu_op);
        request.operand1_m = vif_m.alu_in1;
        request.operand2_m = vif_m.alu_in2;
        request_port_m.write(request);
        trans_m.push_back(request);
      end
      @(posedge vif_m.clk);
    end
  endtask : request_monitor

  virtual task legacy_monitor();
    alu_trans legacy;
    forever begin
      if(vif_m.alu_ready) begin
        if(!trans_m.size()) begin
          `uvm_fatal("ALU_MON", "Received response without any request")
        end
        legacy = new trans_m.pop_front();
        legacy.status_m = vif_m.alu_status;
        legacy.result_m = vif_m.alu_out;
        legacy_port_m.write(legacy);
      end
      @(posedge vif_m.clk);
    end
  endtask : legacy_monitor

  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    if(trans_m.size()) begin
      `uvm_error("ALU_MON", $psprintf("There are %0d requests have not processed", trans_m.size()))
    end
  endfunction : report_phase
endclass : alu_monitor
`endif
