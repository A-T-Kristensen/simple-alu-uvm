//==================================================
// Author : Chris Le
// Email  : lehoangcuong1990@gmail.com
// Date   : July 08, 2018
//==================================================

module alu(
  /* Inputs */
  clk,          // clock
  reset_n,      // reset
  alu_enable,   // enable
  alu_in1,      // input1
  alu_in2,      // input2
  alu_op,       // opcode

  /* Outputs */
  alu_out,      // result
  alu_status,   // [carry, zero, equal, less than, great than]
  alu_ready     // ready
);

  output [7:0]  alu_out;
  output [4:0]  alu_status;
  output        alu_ready;

  input         clk;
  input         reset_n;
  input [7:0]   alu_in1;
  input [7:0]   alu_in2;
  input [4:0]   alu_op;
  input         alu_enable;

  reg [7:0]     alu_out;
  reg [4:0]     alu_status;
  reg           alu_ready;
  reg [7:0]     alu_out_r;
  reg           alu_carry_r, alu_zero_r, alu_eq_r, alu_lt_r, alu_gt_r;
  wire [4:0]    alu_status_i;
  integer       alu_count; 

  assign alu_status_i = {alu_carry_r, alu_zero_r, alu_eq_r, alu_lt_r, alu_gt_r};
  always @(posedge clk or negedge reset_n) begin
    if(!reset_n || !alu_enable) begin
      alu_out <= 8'b0;
      alu_status <= 4'b0;
      alu_ready <= 1'b0;
    end
    else begin
      alu_out <= alu_out_r;
      alu_status <= alu_status_i;
      alu_ready <= 1'b1;
    end
  end

  always @(*) begin
    alu_out_r = 8'd0;
    {alu_carry_r, alu_zero_r, alu_eq_r, alu_lt_r, alu_gt_r} = 5'd0; 
    alu_count = 0;
    if(alu_enable) begin
      case (alu_op)
        5'b00001: begin //add
          {alu_carry_r, alu_out_r} = alu_in1 + alu_in2;
        end
        5'b00010: begin  //sub
          {alu_carry_r, alu_out_r} = alu_in1 - alu_in2;
        end
        5'b00011: begin  //and
          alu_out_r = alu_in1 & alu_in2;
        end
        5'b00100: begin  //or
          alu_out_r = alu_in1 | alu_in2;
        end     
        5'b00101: begin  //xor
          alu_out_r = alu_in1 ^ alu_in2;
        end
        5'b00110: begin  //not
          alu_out_r = ~alu_in1;
        end     
        5'b00111: begin  //sll
          alu_out_r = alu_in1 << (alu_in2[2:0]);
        end
        5'b01000: begin  //srl
          alu_out_r = alu_in1 >> (alu_in2[2:0]); 
        end 
        5'b01001: begin  //rll
          alu_out_r = alu_in1;
          for(alu_count = 0; alu_count < alu_in2[2:0]; alu_count = alu_count + 1)
          begin
            alu_out_r = {alu_out_r[6:0], alu_out_r[7]};
          end   
        end 
        5'b01010: begin  //rrl
          alu_out_r = alu_in1;
          for(alu_count = 0; alu_count < alu_in2[2:0]; alu_count = alu_count + 1) begin
            alu_out_r = {alu_out_r[0], alu_out_r[7:1]};
          end
        end   
        5'b01011: begin  //bez
          alu_zero_r = (alu_in1 == 8'd0) ? 1'b1: 1'b0;
        end 
        5'b01100: begin  //bnz
          alu_zero_r = (alu_in1 == 8'd0) ? 1'b1: 1'b0;
        end 
        5'b01101: begin  //slt
          alu_lt_r   =  (alu_in1 < alu_in2)? 1'b1:1'b0;
        end 
        5'b01110: begin  //cpseq
          alu_eq_r = (alu_in1 == alu_in2)? 1'b1:1'b0;
        end 
        5'b01111: begin  //cpslt
          alu_lt_r = (alu_in1 < alu_in2)? 1'b1:1'b0;
        end   
        5'b10000: begin  //cpsgt
          alu_gt_r = (alu_in1 > alu_in2)? 1'b1:1'b0;
        end                                             
        default: begin
          alu_out_r = 8'd0;
          {alu_carry_r, alu_zero_r, alu_eq_r, alu_lt_r, alu_gt_r} = 5'd0; 
        end
      endcase
    end
  end
endmodule 
