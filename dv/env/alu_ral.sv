//==================================================
// Author : Chris Le
// Email  : lehoangcuong1990@gmail.com
// Date   : July 08, 2018
//==================================================
 
`ifndef _ALU_RAL_
`define _ALU_RAL_
class alu_reg1 extends uvm_reg;
  `uvm_object_utils(alu_reg1)
  rand uvm_reg_field field;
  function new(name = "alu_reg1");
    super.new(name, 32, build_coverage(UVM_NO_COVERAGE));
  endfunction : new

  function void build();
    field = uvm_reg_field::type_id::create("field");
    field.configure(this, 32, 0, "RW", 0, 32'h0, 0, 1, 0);
  endfunction : build
endclass : alu_reg1

class alu_reg2 extends uvm_reg;
  `uvm_object_utils(alu_reg2)
  rand uvm_reg_field field1;
  rand uvm_reg_field field2;
  constraint c_field1 {
    field1.value inside {1, 2, 3, 4, 5, 6};
  }
  function new(name = "alu_reg2");
    super.new(name, 32, build_coverage(UVM_NO_COVERAGE));
  endfunction : new

  function void build();
    field1 = uvm_reg_field::type_id::create("field1",,get_full_name());
    field1.configure(this, 4, 0, "RW", 0, 4'h0, 0, 1, 0);
    field2 = uvm_reg_field::type_id::create("field2",,get_full_name());
    field2.configure(this, 28, 4, "RO", 0, 28'h0, 0, 1, 0);
  endfunction : build
endclass : alu_reg2

class alu_reg3 extends uvm_reg;
  `uvm_object_utils(alu_reg3)
  rand uvm_reg_field field1;
  rand uvm_reg_field field2;
  function new(name = "alu_reg3");
    super.new(name, 32, build_coverage(UVM_NO_COVERAGE));
  endfunction : new

  function void build();
    field1 = uvm_reg_field::type_id::create("field1",,get_full_name());
    field1.configure(this, 8, 0, "RW", 0, 8'h0, 0, 1, 0);
    field2 = uvm_reg_field::type_id::create("field2",,get_full_name());
    field2.configure(this, 8, 24, "RW", 0, 8'h0, 0, 1, 0);
  endfunction : build
endclass : alu_reg3

class alu_reg4 extends uvm_reg;
  `uvm_object_utils(alu_reg4)
  rand uvm_reg_field field;
  function new(name = "alu_reg4");
    super.new(name, 32, build_coverage(UVM_NO_COVERAGE));
  endfunction : new

  function void build();
    field = uvm_reg_field::type_id::create("field",,get_full_name());
    field.configure(this, 32, 0, "WO", 0, 32'h0, 0, 1, 0);
  endfunction : build
endclass : alu_reg4


class alu_ral extends uvm_reg_block;
  `uvm_object_utils(alu_ral)
  rand alu_reg1 reg1;
  rand alu_reg2 reg2;
  rand alu_reg3 reg3;
  rand alu_reg4 reg4;
  uvm_reg_map map;

  function new(name = "alu_ral");
    super.new(name, build_coverage(UVM_NO_COVERAGE));
  endfunction : new

  function void build();
    reg1 = alu_reg1::type_id::create("reg1",,get_full_name());
    reg1.build();
    reg1.configure(this);

    reg2 = alu_reg2::type_id::create("reg2",,get_full_name());
    reg2.build();
    reg2.configure(this);

    reg3 = alu_reg3::type_id::create("reg3",,get_full_name());
    reg3.build();
    reg3.configure(this);

    reg4 = alu_reg4::type_id::create("reg4",,get_full_name());
    reg4.build();
    reg4.configure(this);

    map = create_map("map", 32'h0, 4, UVM_LITTLE_ENDIAN);
    map.add_reg(reg1, 32'h10, "RW");
    map.add_reg(reg2, 32'h14, "RW");
    map.add_reg(reg3, 32'h18, "RW");
    map.add_reg(reg4, 32'h1c, "WO");

    lock_model();
  endfunction : build
endclass : alu_ral
`endif
