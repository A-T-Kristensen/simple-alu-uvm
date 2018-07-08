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
class apb_read_seq extends uvm_sequence #(apb_seq_item);

// UVM Factory Registration Macro
//
`uvm_object_utils(apb_read_seq)

//------------------------------------------
// Data Members (Outputs rand, inputs non-rand)
//------------------------------------------
rand logic [31:0] addr;
logic [31:0] data;

//------------------------------------------
// Constraints
//------------------------------------------



//------------------------------------------
// Methods
//------------------------------------------

// Standard UVM Methods:
extern function new(string name = "apb_read_seq");
extern task body;

endclass:apb_read_seq

function apb_read_seq::new(string name = "apb_read_seq");
  super.new(name);
endfunction

task apb_read_seq::body;
  apb_seq_item req = apb_seq_item::type_id::create("req");;

  begin
    start_item(req);
    req.we = 0;
    req.addr = addr;
    finish_item(req);
    data = req.data;
  end

endtask:body
