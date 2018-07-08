//==================================================
// Author : Chris Le
// Email  : lehoangcuong1990@gmail.com
// Date   : July 08, 2018
//==================================================
 
`ifndef _ALU_AGENT_
`define _ALU_AGENT_
class alu_agent extends uvm_agent;
  `uvm_component_utils(alu_agent)

  alu_seqr seqr_m;
  alu_driver driver_m;
  alu_monitor monitor_m;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    seqr_m = alu_seqr::type_id::create("seqr_m", this);
    driver_m = alu_driver::type_id::create("driver_m", this);
    monitor_m = alu_monitor::type_id::create("monitor_m", this);
  endfunction : build_phase 

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    driver_m.seq_item_port.connect(seqr_m.seq_item_export);
  endfunction : connect_phase 
endclass : alu_agent
`endif
