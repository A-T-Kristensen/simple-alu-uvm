//==================================================
// Author : Chris Le
// Email  : lehoangcuong1990@gmail.com
// Date   : July 08, 2018
//==================================================
 
module alu_tb;
  import uvm_pkg::*;

  logic clk;
  logic reset_n;

  /* Interface */
  apb_if apb_vif(.PCLK(clk), .PRESETn(reset_n));
  alu_if alu_vif(.clk(clk), .reset_n(reset_n));

  /* Design */
  alu_top dut(
    .clk(clk),
    .reset_n(reset_n),

    .alu_out(alu_vif.alu_out), 
    .alu_status(alu_vif.alu_status), 
    .alu_ready(alu_vif.alu_ready), 
    .alu_enable(alu_vif.alu_enable),
    .alu_in1(alu_vif.alu_in1),
    .alu_in2(alu_vif.alu_in2),
    .alu_op(alu_vif.alu_op),

    .paddr(apb_vif.PADDR),
    .pwdata(apb_vif.PWDATA),
    .psel(apb_vif.PSEL[0]),
    .penable(apb_vif.PENABLE),
    .pwrite(apb_vif.PWRITE),
    .prdata(apb_vif.PRDATA),
    .pready(apb_vif.PREADY)
  );

  initial begin
    uvm_config_db#(virtual alu_if)::set(null, "", "alu_if", alu_vif);
    uvm_config_db#(virtual apb_if)::set(null, "", "apb_if", apb_vif);
    run_test();
  end
  
  initial begin
    clk = 1'b0;
    reset_n = 1'b0;
    repeat(5) begin
      @(posedge clk);
    end
    reset_n = 1'b1;
  end
  always begin 
    #1ns clk = ~clk;
  end

  /* Dump waveform */
  initial begin                                                                                                                   
    if ($test$plusargs("debussy")) begin
      $fsdbDumpfile("debussy.fsdb");
      $fsdbDumpvars;
    end
  end
endmodule : alu_tb
