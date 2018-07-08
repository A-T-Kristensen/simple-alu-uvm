//==================================================
// Author : Chris Le
// Email  : lehoangcuong1990@gmail.com
// Date   : July 08, 2018
//==================================================
 
`ifndef _ALU_ENV_
`define _ALU_ENV_
class alu_env extends uvm_env;
  `uvm_component_utils(alu_env)

  alu_agent         alu_agent_m;
  apb_agent         apb_agent_m;
  apb_agent_config  apb_agent_cfg_m;
  alu_coverage      alu_coverage_m;
  alu_scoreboard    alu_scoreboard_m;
  alu_ral           alu_ral_m;
  alu_reg_adapter   reg_adapter_m;
  alu_reg_predictor reg_predictor_m;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    alu_agent_m       = alu_agent::type_id::create("alu_agent_m", this);
    alu_scoreboard_m  = alu_scoreboard::type_id::create("alu_scoreboard_m", this);
    alu_coverage_m    = alu_coverage::type_id::create("alu_coverage_m", this);
    apb_agent_m       = apb_agent::type_id::create("apb_agent_m", this);
    apb_agent_cfg_m   = apb_agent_config::type_id::create("apb_agent_cfg_m", this);
    reg_adapter_m     = alu_reg_adapter::type_id::create("reg_adapter_m");
    reg_predictor_m   = alu_reg_predictor::type_id::create("reg_predictor_m", this);
    apb_agent_cfg_m.active = UVM_ACTIVE;
    apb_agent_cfg_m.range[apb_agent_cfg_m.apb_index] = 32'hffffffff;
    apb_agent_cfg_m.start_address[apb_agent_cfg_m.apb_index] = 32'h00000000;
    uvm_config_db#(virtual apb_if)::get(null, "", "apb_if", apb_agent_cfg_m.APB);
    uvm_config_db#(apb_agent_config)::set(this, "apb_agent_m*", "apb_agent_config", apb_agent_cfg_m);
    uvm_config_db#(alu_ral)::get(this, "", "alu_ral", alu_ral_m);
  endfunction : build_phase 

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    alu_ral_m.map.set_sequencer(apb_agent_m.m_sequencer, reg_adapter_m);
    reg_predictor_m.map = alu_ral_m.map;
    reg_predictor_m.adapter = reg_adapter_m;
    apb_agent_m.ap.connect(reg_predictor_m.bus_in);
    apb_agent_m.ap.connect(alu_scoreboard_m.apb_export_m);
    alu_agent_m.monitor_m.legacy_port_m.connect(alu_scoreboard_m.legacy_export_m);
    alu_agent_m.monitor_m.request_port_m.connect(alu_scoreboard_m.request_export_m);
    alu_agent_m.monitor_m.legacy_port_m.connect(alu_coverage_m.analysis_export);
  endfunction : connect_phase 
endclass : alu_env
`endif
