# UVM_Tutorials

This is UVM tutoria for verifying very simple ALU design. 
1. Directories:
- rtl: RTL design
- dv/tb: Testbench and interface
- dv/tests: Testcases
- dv/sequences: Generate stimulus transaction
- dv/env: Environment, agent, scoreboard, coverage ...
- dv/vips: Questa VIP (apb)
- dv/sim: Makefile, file lists.
- uvm/uvm-1.2: Source code UVM version 1.2
- uvm/uvm-1.1d: Source code UVM version 1.1d
- docs: Specs and documents
-----------------------------------------------------

2. Test supported: Current supported the following tests:
- alu_add_test          : ADD operation test
- alu_sub_test          : SUB operation test
- alu_and_test          : AND operation test
- alu_or_test           : OR operation test
- alu_xor_test          : XOR operation test
- alu_not_test          : Invert (NOT) operation test
- alu_sll_test          : Shift Left operation test
- alu_srl_test          : Shift Right operation test
- alu_rll_test          : Rotate Left operation test
- alu_rrl_test          : Rotate Right operation left
- alu_bez_test          : Branch Equal Zero (compare with zero) test
- alu_bnz_test          : Branch Not Equal Zero (compare with zero) test
- alu_slt_test          : Set Less Than operation test
- alu_cpseq_test        : Compare Equal operation test
- alu_cpslt_test        : Compare Less Than operation test
- alu_cpsgt_test        : Compare Greater Than operation test
- alu_reg_reset_test    : Reset/Initial register value test
- alu_reg_bitbash_test  : Bitbash register value test
- alu_nodelay_test      : Back2back (no delay) multiple transactions test
- alu_longdelay_test    : Backpressure (long delay) multiple transactions test
- alu_error_test        : Invalid operation test
-----------------------------------------------------

3. How to run: 
- Compile: make compile
- Simulate: make simulation TEST=test_to_run
- Open waveform: make waveform
- Generate coverage report: make coverage

Note: 
- Change PLI_PATH in Makefile depending on your environment
- Remove 'sgq short:16m:1c' from Makefile (this command is used to submit my EDA server)
-----------------------------------------------------

4. Regression:
- Go to: cd dv/sim
- Execute: perl regression.pl [-options] regression.f

4.1. Input regresion.f format:
| test name | spaces | number of loops
| alu_test  |        | 5

It means alu_test will be executed 5 times

4.2. Script regresion.pl options:
- coverage : Generate coverage report
- simulate : Run simulation only (assume already compiled before)
- compile  : Run complation only 
- option   : Pass the option to Makefile for submiting server of EDA tools (vcs, vsim, urg, etc.)
More detail: perl regression.pl -h

-----------------------------------------------------

5. Design specs: Simple ALU design supports the following operation

5.1. ADD (opcode = 5'b0001)
- Description: Add 2 inputs. If the operation is overflow, the carry bit (status[4]) will be asserted
- Implementation: {status[4], out[7:0]} = in1[7:0] + in2[7:0]


5.2. SUB (opcode = 5'b0010)
- Description: Subtract 2 8-bit inputs. The carry bit will asserted if the operation overflow.
- Implementation: {status[4], out[7:0]} = in1[7:0] - in2[7:0]


5.3. AND (opcode = 5'b0011)
- Description: And bitwise 2 8-bit inputs
- Implementation: out[7:0] = in1[7:0] & in2[7:0]


5.4. OR  (opcode = 5'b0100)
- Description: Or bitwise 2 8-bit inputs
- Implementation: out[7:0] = in1[7:0] | in2[7:0]


5.5. XOR (opcode = 5'b0101)
- Description: Xor 2 8-bit inputs
- Implementation: out[7:0] = in1[7:0] ^ in2[7:0]


5.6. NOT (opcode = 5'b0110)
- Description: Invert the the first 8-bit input (operand 1)
- Implementation: out[7:0] = ~in1[7:0]


5.7 SLL (opcode = 5'b0111)
- Description: Shift left the first 8-bit input with the second input
- Implementation: out[7:0] = in1[7:0] << in2[7:0]


5.8 SRL (opcode = 5'b1000)
- Description: Shift right the first 8-bit input with the second input
- Implementation: out[7:0] = in1[7:0] >> in2[7:0]


5.9. RLL (opcode = 5'b1001)
- Description: Rotate left the first 8-bit input with the second input
- Implementation: out[7:0] = in1[7:0]; for(in2): out[7:0] = {[out[6:0], out[7]}


5.10. RRL (opcode = 5'b1010)
- Description: Shift right the first 8-bit input with the second input
- Implementation: out[7:0] = in1[7:0]; for(in2): out[7:0] = {[out[0], out[7:1]}


5.11. BEZ (opcode = 5'b1011)
- Description: Branch if equal zero. This operation simply compare the the first input (in1) with zero, assert status[3] if it's equal.
- Implementation: status[3] = (in1 == 7'h0) ? 1'b1 : 1'b0


5.12. BNZ (opcode = 5'b1100)
- Description: Branch if not equal zero. This operation simply compare the the first input (in1) with zero, assert status[3] if it's equal.
- Implementation: status[3] = (in1 == 7'h0) ? 1'b1 : 1'b0


5.13. SLT (opcode = 5'b1101)
- Description: Set if less than. This operation compare the the first input (in1) and second input (in2), assert status[1] if first input smaller than second.
- Implementation: status[1] = (in1 < in2) ? 1'b1 : 1'b0


5.14. CPSEQ (opcode = 5'b1110)
- Description: Compare If Equal. This operation compare the the first input (in1) and second input (in2), assert status[2] if first input equal second.
- Implementation: status[2] = (in1 == in2) ? 1'b1 : 1'b0


5.15. CPSLT (opcode = 5'b1111)
- Description: Compare If Less Than. This operation compare the the first input (in1) and second input (in2), assert status[2] if first input smaller than second.
- Implementation: status[2] = (in1 < in2) ? 1'b1 : 1'b0


5.16. CPSGT (opcode = 5'b10000)
- Description: Compare If Greater Than. This operation compare the the first input (in1) and second input (in2), assert status[2] if first input larger than second.
- Implementation: status[0] = (in1 > in2) ? 1'b1 : 1'b0
