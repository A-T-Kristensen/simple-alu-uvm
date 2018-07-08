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
package apb_agent_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

`include "apb_seq_item.svh"
typedef uvm_sequencer #(apb_seq_item) apb_sequencer;
`include "apb_agent_config.svh"
`include "apb_driver.svh"
`include "apb_coverage_monitor.svh"
`include "apb_monitor.svh"
`include "apb_agent.svh"

// Utility Sequences
`include "apb_seq.svh"
`include "apb_read_seq.svh"
`include "apb_write_seq.svh"

endpackage: apb_agent_pkg
