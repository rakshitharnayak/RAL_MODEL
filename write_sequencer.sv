class write_sequencer extends uvm_sequencer #(write_seq_item);
  `uvm_component_utils(write_sequencer)
  
  //new constructor
  function new(string name = "write_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
endclass:write_sequencer
