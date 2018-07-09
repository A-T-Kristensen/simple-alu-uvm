# Simple ALU

This is a full tutorial to verify simple ALU design using UVM (Univeral Verification Medothology) and SystemVerilog. 


## 1. Directories:
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



## 2. Supported tests:
| Test                  | Description                           |
| --------------------- | ------------------------------------- |
| alu_add_test          | ADD operation test                    |
| alu_sub_test          | SUB operation test                    |
| alu_and_test          | AND operation test                    |
| alu_or_test           | OR operation test                     |
| alu_xor_test          | XOR operation test                    |
| alu_not_test          | Invert (NOT) operation test           |
| alu_sll_test          | Shift Left operation test             |
| alu_srl_test          | Shift Right operation test            |
| alu_rll_test          | Rotate Left operation test            |
| alu_rrl_test          | Rotate Right operation left           |
| alu_cmpeq_test        | Compare Equal operation test          |
| alu_cmplt_test        | Compare Less Than operation test      |
| alu_cmpgt_test        | Compare Greater Than operation test   |
| alu_reg_reset_test    | Reset/Initial register value test     |
| alu_reg_bitbash_test  | Bitbash register value test           |
| alu_nodelay_test      | Back2back (no delay) trans test       |
| alu_longdelay_test    | Backpressure (long delay) trans test  |
| alu_error_test        | Invalid operation test                |



## 3. How to run:
- Go to dir: `cd dv/sim`
- Compile: `make compile`
- Simulate: `make simulation TEST=test_to_run SEED=optional`
- Open waveform: `make waveform`
- Generate coverage report: `make coverage`

**NOTE:** 
Change *PLI_PATH* in Makefile depending on your environment



## 4. Regression:
- Go to: `cd dv/sim`
- Execute: `perl regression.pl [-options] regression.f`

### 4.1. Input format:
| Test                  | Number Loop |
| --------------------- | :----------:|
| alu_test              |       5     |
| alu_add_test          |       5     |
| alu_sub_test          |       5     |
| alu_and_test          |       5     |
| alu_or_test           |       5     |
| alu_xor_test          |       5     |
| alu_not_test          |       5     |
| alu_sll_test          |       5     |
| alu_srl_test          |       5     |
| alu_rll_test          |       5     |
| alu_rrl_test          |       5     |
| alu_bez_test          |       5     |
| alu_bnz_test          |       5     |
| alu_slt_test          |       5     |
| alu_cpseq_test        |       5     |
| alu_cpslt_test        |       5     |
| alu_cpsgt_test        |       5     |
| alu_reg_reset_test    |       5     |
| alu_reg_bitbash_test  |       5     |
| alu_nodelay_test      |       5     |
| alu_longdelay_test    |       5     |

It means every test will be executed 5 times

### 4.2. Script options:
- coverage : Generate coverage report
- simulate : Run simulation only (assume already compiled before)
- compile  : Run complation only 
- option   : Pass the option to Makefile for submiting server of EDA tools (vcs, vsim, urg, etc.)



## 5. Design specs:
Simple ALU design supports the following operation:

**ADD (opcode = 5'b00001):**
Description: Add 2 inputs. If the operation is overflow, the carry bit (status[4]) will be asserted
Implementation: {status[4], out[7:0]} = in1[7:0] + in2[7:0]

**SUB (opcode = 5'b00010):**
Description: Subtract 2 8-bit inputs. The negative bit will asserted if the operation overflow.
Implementation: {status[3], out[7:0]} = in1[7:0] - in2[7:0]

**AND (opcode = 5'b00011):**
Description: And bitwise 2 8-bit inputs
Implementation: out[7:0] = in1[7:0] & in2[7:0]

**OR  (opcode = 5'b00100):**
Description: Or bitwise 2 8-bit inputs
Implementation: out[7:0] = in1[7:0] | in2[7:0]

**XOR (opcode = 5'b00101):**
Description: Xor 2 8-bit inputs
Implementation: out[7:0] = in1[7:0] ^ in2[7:0]

**NOT (opcode = 5'b00110):**
Description: Invert the the first 8-bit input (operand 1)
Implementation: out[7:0] = ~in1[7:0]

**SLL (opcode = 5'b00111):**
Description: Shift left the first 8-bit input with the second input
Implementation: out[7:0] = in1[7:0] << in2[2:0]

**SRL (opcode = 5'b01000):**
Description: Shift right the first 8-bit input with the second input
Implementation: out[7:0] = in1[7:0] >> in2[2:0]

**RLL (opcode = 5'b01001):**
Description: Rotate left the first 8-bit input with the second input
Implementation: out[7:0] = in1[7:0]; repeat(in2[2:0]): out[7:0] = {[out[6:0], out[7]}

**RRL (opcode = 5'b01010):**
Description: Shift right the first 8-bit input with the second input
Implementation: out[7:0] = in1[7:0]; repeat(in2[2:0]): out[7:0] = {[out[0], out[7:1]}

**CPSEQ (opcode = 5'b01011):**
Description: Compare If Equal. This operation compares 2 8-bit inputs, set status[2] if they are equal
Implementation: status[2] = (in1 == in2) ? 1'b1 : 1'b0

**CPSLT (opcode = 5'b1100):**
Description: Compare If Less Than. This operation compares 2 8-bit inputs, set status[1] if the first smaller than the second
Implementation: status[2] = (in1 < in2) ? 1'b1 : 1'b0

**CPSGT (opcode = 5'b1101):**
Description: Compare If Greater Than. This operation compares 2 8-bit inputs, set status[0] if the first larger than the second
Implementation: status[0] = (in1 > in2) ? 1'b1 : 1'b0
