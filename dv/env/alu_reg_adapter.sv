//==================================================
// Author : Chris Le
// Email  : lehoangcuong1990@gmail.com
// Date   : July 08, 2018
//==================================================
 
`ifndef _ALU_REG_ADAPTER_
`define _ALU_REG_ADAPTER_
class alu_reg_adapter extends uvm_reg_adapter;
  `uvm_object_utils(alu_reg_adapter)

  function new(string name = "alu_reg_adapter");
     super.new(name);
  endfunction : new

  virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    apb_seq_item apb = apb_seq_item::type_id::create("apb");
    apb.we = (rw.kind == UVM_READ) ? 0 : 1;
    apb.addr = rw.addr;
    apb.data = rw.data;
    return apb;
  endfunction: reg2bus
  
  virtual function void bus2reg(uvm_sequence_item bus_item,
                                ref uvm_reg_bus_op rw);
    apb_seq_item apb;
    if (!$cast(apb, bus_item)) begin
      `uvm_fatal("ALU_REG_ADAPTER","bus_item is not of the correct type")
      return;
    end
    rw.kind = apb.we ? UVM_WRITE : UVM_READ;
    rw.addr = apb.addr;
    rw.data = apb.data;
    rw.status = UVM_IS_OK;
  endfunction: bus2reg
endclass: alu_reg_adapter
`endif
