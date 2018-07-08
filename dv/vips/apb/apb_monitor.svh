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
class apb_monitor extends uvm_component;

// UVM Factory Registration Macro
//
`uvm_component_utils(apb_monitor);

// Virtual Interface
virtual apb_if APB;

//------------------------------------------
// Data Members
//------------------------------------------
int apb_index = 0; // Which PSEL line is this monitor connected to
//------------------------------------------
// Component Members
//------------------------------------------
uvm_analysis_port #(apb_seq_item) ap;

//------------------------------------------
// Methods
//------------------------------------------

// Standard UVM Methods:

extern function new(string name = "apb_monitor", uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern function void report_phase(uvm_phase phase);

endclass: apb_monitor

function apb_monitor::new(string name = "apb_monitor", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void apb_monitor::build_phase(uvm_phase phase);
  ap = new("ap", this);
endfunction: build_phase

task apb_monitor::run_phase(uvm_phase phase);
  apb_seq_item item;
  apb_seq_item cloned_item;

  item = apb_seq_item::type_id::create("item");

  forever begin
    // Detect the protocol event on the TBAI virtual interface
    @(posedge APB.PCLK);
    if(APB.PREADY && APB.PSEL[apb_index])
    // Assign the relevant values to the analysis item fields
      begin
        item.addr = APB.PADDR;
        item.we = APB.PWRITE;
        if(APB.PWRITE)
          begin
            item.data = APB.PWDATA;
          end
        else
          begin
            item.data = APB.PRDATA;
          end
        // Clone and publish the cloned item to the subscribers
        $cast(cloned_item, item.clone());
        ap.write(cloned_item);
      end
  end
endtask: run_phase

function void apb_monitor::report_phase(uvm_phase phase);
// Might be a good place to do some reporting on no of analysis transactions sent etc

endfunction: report_phase
