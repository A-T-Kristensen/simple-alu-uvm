//------------------------------------------------------------
//   Copyright 2010-2012 Mentor Graphics Corporation
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//------------------------------------------------------------

//
// Class Description:
//
//
class apb_seq_item extends uvm_sequence_item;

// UVM Factory Registration Macro
//
`uvm_object_utils(apb_seq_item)

//------------------------------------------
// Data Members (Outputs rand, inputs non-rand)
//------------------------------------------
rand logic[31:0] addr;
rand logic[31:0] data;
rand logic we;
rand int delay;

bit error;

//------------------------------------------
// Constraints
//------------------------------------------
constraint addr_alignment {
  addr[1:0] == 0;
}

constraint delay_bounds {
  delay inside {[1:20]};
}

//------------------------------------------
// Methods
//------------------------------------------

// Standard UVM Methods:
extern function new(string name = "apb_seq_item");
extern function void do_copy(uvm_object rhs);
extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
extern function string convert2string();
extern function void do_print(uvm_printer printer);
extern function void do_record(uvm_recorder recorder);

endclass:apb_seq_item

function apb_seq_item::new(string name = "apb_seq_item");
  super.new(name);
endfunction

function void apb_seq_item::do_copy(uvm_object rhs);
  apb_seq_item rhs_;

  if(!$cast(rhs_, rhs)) begin
    `uvm_fatal("do_copy", "cast of rhs object failed")
  end
  super.do_copy(rhs);
  // Copy over data members:
  addr = rhs_.addr;
  data = rhs_.data;
  we = rhs_.we;
  delay = rhs_.delay;

endfunction:do_copy

function bit apb_seq_item::do_compare(uvm_object rhs, uvm_comparer comparer);
  apb_seq_item rhs_;

  if(!$cast(rhs_, rhs)) begin
    `uvm_error("do_copy", "cast of rhs object failed")
    return 0;
  end
  return super.do_compare(rhs, comparer) &&
         addr == rhs_.addr &&
         data == rhs_.data &&
         we   == rhs_.data;
  // Delay is not relevant to the comparison
endfunction:do_compare

function string apb_seq_item::convert2string();
  string s;

  $sformat(s, "%s\n", super.convert2string());
  // Convert to string function reusing s:
  $sformat(s, "%s\n addr\t%0h\n data\t%0h\n we\t%0b\n delay\t%0d\n", s, addr, data, we, delay);
  return s;

endfunction:convert2string

function void apb_seq_item::do_print(uvm_printer printer);
  if(printer.knobs.sprint == 0) begin
    $display(convert2string());
  end
  else begin
    printer.m_string = convert2string();
  end
endfunction:do_print

function void apb_seq_item:: do_record(uvm_recorder recorder);
  super.do_record(recorder);

  // Use the record macros to record the item fields:
  `uvm_record_field("addr", addr)
  `uvm_record_field("data", data)
  `uvm_record_field("we", we)
  `uvm_record_field("delay", delay)
endfunction:do_record
