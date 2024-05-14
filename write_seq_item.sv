class write_seq_item extends uvm_sequence_item;

  rand bit[15:0] src_addr;
  rand bit[15:0] dest_addr;
  rand bit[15:0] id;
  rand bit[15:0] data;
  rand bit valid_in;
  
       bit[63:0] expected_pkt;
       bit[63:0] pkt;
       bit[63:0] actual_pkt;
  
  `uvm_object_utils_begin(write_seq_item)
  `uvm_field_int(src_addr, UVM_ALL_ON)
  `uvm_field_int(dest_addr, UVM_ALL_ON)
  `uvm_field_int(id, UVM_ALL_ON)
  `uvm_field_int(data, UVM_ALL_ON)
  `uvm_field_int(expected_pkt, UVM_ALL_ON)
  `uvm_field_int(pkt, UVM_ALL_ON)
  `uvm_field_int(actual_pkt, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "write_seq_item");
    super.new(name);
  endfunction : new

 
endclass : write_seq_item
