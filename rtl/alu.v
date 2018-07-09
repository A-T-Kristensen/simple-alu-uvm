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
  alu_status,   // [carry, neg, equal, less than, great than]
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
  reg [7:0]     alu_out_reg;
  reg           alu_carry_reg; 
  reg           alu_neg_reg;
  reg           alu_eq_reg;
  reg           alu_lt_reg;
  reg           alu_gt_reg;
  wire [4:0]    alu_status_i;
  integer       alu_count; 

  always @(posedge clk or negedge reset_n) begin
    if(!reset_n || !alu_enable) begin
      alu_out <= 8'b0;
      alu_status <= 4'b0;
      alu_ready <= 1'b0;
    end
    else begin
      alu_out <= alu_out_reg;
      alu_status <= alu_status_i;
      alu_ready <= 1'b1;
    end
  end

  assign alu_status_i = {alu_carry_reg, alu_neg_reg, alu_eq_reg, alu_lt_reg, alu_gt_reg};

  always @(*) begin
    alu_out_reg = 8'd0;
    alu_carry_reg = 1'b0;
    alu_neg_reg = 1'b0;
    alu_eq_reg = 1'b0;
    alu_lt_reg = 1'b0;
    alu_gt_reg = 1'd0; 
    alu_count = 0;
    if(alu_enable) begin
      case (alu_op)
        /* ADD */
        5'b00001: begin
          {alu_carry_reg, alu_out_reg} = alu_in1 + alu_in2;
        end
        /* SUB */
        5'b00010: begin
          {alu_neg_reg, alu_out_reg} = alu_in1 - alu_in2;
        end
        /* AND */
        5'b00011: begin
          alu_out_reg = alu_in1 & alu_in2;
        end
        /* OR */
        5'b00100: begin
          alu_out_reg = alu_in1 | alu_in2;
        end     
        /* XOR */
        5'b00101: begin
          alu_out_reg = alu_in1 ^ alu_in2;
        end
        /* NOT */
        5'b00110: begin
          alu_out_reg = ~alu_in1;
        end     
        /* SLL */
        5'b00111: begin
          alu_out_reg = alu_in1 << (alu_in2[2:0]);
        end
        /* SRL */
        5'b01000: begin
          alu_out_reg = alu_in1 >> (alu_in2[2:0]); 
        end 
        /* RLL */
        5'b01001: begin
          alu_out_reg = alu_in1;
          for(alu_count = 0; alu_count < alu_in2[2:0]; alu_count++) begin
            alu_out_reg = {alu_out_reg[6:0], alu_out_reg[7]};
          end   
        end 
        /* RRL */
        5'b01010: begin
          alu_out_reg = alu_in1;
          for(alu_count = 0; alu_count < alu_in2[2:0]; alu_count++) begin
            alu_out_reg = {alu_out_reg[0], alu_out_reg[7:1]};
          end
        end   
        /* CMPEQ */
        5'b01011: begin
          alu_eq_reg = (alu_in1 == alu_in2) ? 1'b1 : 1'b0;
        end 
        /* CMPLT */
        5'b01100: begin
          alu_lt_reg = (alu_in1 < alu_in2) ? 1'b1 : 1'b0;
        end   
        /* CMPGT */
        5'b01101: begin
          alu_gt_reg = (alu_in1 > alu_in2) ? 1'b1 : 1'b0;
        end                                             
        default: begin
          alu_out_reg = 8'd0;
          alu_carry_reg = 1'b0;
          alu_neg_reg = 1'b0;
          alu_eq_reg = 1'b0;
          alu_lt_reg = 1'b0;
          alu_gt_reg = 1'd0; 
        end
      endcase
    end
  end
endmodule 
