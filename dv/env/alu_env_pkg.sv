//==================================================
// Author : Chris Le
// Email  : lehoangcuong1990@gmail.com
// Date   : July 08, 2018
//==================================================

`ifndef _ALU_ENV_PKG_
`define _ALU_ENV_PKG_
package alu_env_pkg;
  import uvm_pkg::*;
  import apb_agent_pkg::*;
  `include "alu_trans.sv"
  `include "alu_seqr.sv"
  `include "alu_driver.sv"
  `include "alu_monitor.sv"
  `include "alu_agent.sv"
  `include "alu_scoreboard.sv"
  `include "alu_coverage.sv"
  `include "alu_ral.sv"
  `include "alu_reg_adapter.sv"
  `include "alu_reg_predictor.sv"
  `include "alu_env.sv"
endpackage : alu_env_pkg
`endif
