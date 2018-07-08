//==================================================
// Author : Chris Le
// Email  : lehoangcuong1990@gmail.com
// Date   : July 08, 2018
//==================================================
 
`ifndef _ALU_DRIVER_
`define _ALU_DRIVER_
class alu_driver extends uvm_driver#(alu_trans);
  `uvm_component_utils(alu_driver)

  virtual alu_if vif_m;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    assert(uvm_config_db#(virtual alu_if)::get(null, "", "alu_if", vif_m)) 
    else begin
      `uvm_fatal("ALU_DRIVER", "Unable to get alu if!")
    end
  endfunction : build_phase 

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction : connect_phase 

  virtual task reset_phase(uvm_phase phase);
    phase.raise_objection(this);
    @(posedge vif_m.reset_n);
    repeat(2) begin
      @(posedge vif_m.clk);
    end
    phase.drop_objection(this);
  endtask : reset_phase

  virtual task run_phase(uvm_phase phase);
    alu_trans trans;
    init_signal();
    forever begin
      seq_item_port.get_next_item(trans);
      drive_signal(trans);
      seq_item_port.item_done();
    end
  endtask : run_phase

  virtual task drive_signal(alu_trans trans);
    vif_m.alu_in1     <= trans.operand1_m;
    vif_m.alu_in2     <= trans.operand2_m;
    vif_m.alu_op      <= trans.opcode_m;
    vif_m.alu_enable  <= 1'b1;
    @(posedge vif_m.clk);
    vif_m.alu_in1     <= 7'b0;
    vif_m.alu_in2     <= 7'b0;
    vif_m.alu_op      <= 5'b0;
    vif_m.alu_enable  <= 1'b0;
    repeat(trans.delay_m) begin
      @(posedge vif_m.clk);
    end
  endtask : drive_signal

  virtual task init_signal();
    vif_m.alu_in1     <= 7'b0;
    vif_m.alu_in2     <= 7'b0;
    vif_m.alu_op      <= 5'b0;
    vif_m.alu_enable  <= 1'b0;
    while(!vif_m.reset_n) begin
      @(posedge vif_m.clk);
    end
  endtask : init_signal
endclass : alu_driver
`endif
