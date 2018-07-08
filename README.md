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
- alu_add_test: ADD operation test
- alu_sub_test: SUB operation test
- alu_and_test: AND operation test
- alu_or_test : OR  operation test
- alu_xor_test: XOR operation test
- alu_not_test: NOT operation test
- alu_test: Full randomized test
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

4. Design specs: Simple ALU design supports the following operation

4.1. ADD (opcode = 5'b0001)
+ Description: Add 2 inputs. If the operation is overflow, the carry bit (status[4]) will be asserted
+ Implementation: {status[4], out[7:0]} = in1[7:0] + in2[7:0]


4.2. SUB (opcode = 5'b0010)
+ Description: Subtract 2 8-bit inputs. The carry bit will asserted if the operation overflow.
+ Implementation: {status[4], out[7:0]} = in1[7:0] - in2[7:0]


4.3. AND (opcode = 5'b0011)
+ Description: And bitwise 2 8-bit inputs
+ Implementation: out[7:0] = in1[7:0] & in2[7:0]


4.4. OR  (opcode = 5'b0100)
+ Description: Or bitwise 2 8-bit inputs
+ Implementation: out[7:0] = in1[7:0] | in2[7:0]


4.5. XOR (opcode = 5'b0101)
+ Description: Xor 2 8-bit inputs
+ Implementation: out[7:0] = in1[7:0] ^ in2[7:0]


4.6. NOT (opcode = 5'b0110)
+ Description: Invert the the first 8-bit input (operand 1)
+ Implementation: out[7:0] = ~in1[7:0]


4.7 SLL (opcode = 5'b0111)
+ Description: Shift left the first 8-bit input with the second input
+ Implementation: out[7:0] = in1[7:0] << in2[7:0]


4.8 SRL (opcode = 5'b1000)
+ Description: Shift right the first 8-bit input with the second input
+ Implementation: out[7:0] = in1[7:0] >> in2[7:0]


4.9. RLL (opcode = 5'b1001)
+ Description: Rotate left the first 8-bit input with the second input
+ Implementation: out[7:0] = in1[7:0]; for(in2): out[7:0] = {[out[6:0], out[7]}


4.10. RRL (opcode = 5'b1010)
+ Description: Shift right the first 8-bit input with the second input
+ Implementation: out[7:0] = in1[7:0]; for(in2): out[7:0] = {[out[0], out[7:1]}


4.11. BEZ (opcode = 5'b1011)
+ Description: Branch if equal zero. This operation simply compare the the first input (in1) with zero, assert status[3] if it's equal.
+ Implementation: status[3] = (in1 == 7'h0) ? 1'b1 : 1'b0
-----------------------------------------------------

5. Regression:
Add list testcases to regression.f file. Execute tcsh script:
source regression.csh regression.f
The result will be printed in screen. Output directory will be "regression" included list tests result.
