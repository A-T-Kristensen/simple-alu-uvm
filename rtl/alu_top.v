//==================================================
// Author : Chris Le
// Email  : lehoangcuong1990@gmail.com
// Date   : July 08, 2018
//==================================================
 
module alu_top(
  clk,
  reset_n,

  alu_out,
  alu_status,
  alu_ready,
  alu_enable,
  alu_in1,
  alu_in2,
  alu_op,

  psel,
  penable,
  paddr,
  pwrite,
  pwdata,
  prdata,
  pready
);
  input         clk;
  input         reset_n;

  input [7:0]   alu_in1;
  input [7:0]   alu_in2;
  input [4:0]   alu_op;
  input         alu_enable;
  output [7:0]  alu_out;
  output [4:0]  alu_status;
  output        alu_ready;

  input         psel;
  input  [31:0] paddr;
  input         pwrite;
  input         penable;
  input  [31:0] pwdata;
  output [31:0] prdata;
  output        pready;

  alu u_alu (
    .clk(clk),
    .reset_n(reset_n),
    .alu_enable(alu_enable),
    .alu_in1(alu_in1),
    .alu_in2(alu_in2),
    .alu_op(alu_op),
    .alu_out(alu_out),
    .alu_status(alu_status),
    .alu_ready(alu_ready)
  );

  alu_reg u_alu_reg (
    .clk(clk),
    .reset_n(reset_n),
    .psel(psel),
    .penable(penable),
    .paddr(paddr),
    .pwrite(pwrite),
    .pwdata(pwdata),
    .prdata(prdata),
    .pready(pready)
  );
endmodule
