
//--------------------------------------------------------------------------------------------
// Class: apb_tr.
//  This class holds the data items required to drive stimulus to dut 
//  and also holds methods that manipulate those data items
//--------------------------------------------------------------------------------------------
class apb_tr extends uvm_sequence_item;
  
  //Variable: addr
  //Address selected in slave
  rand bit[31:0] addr;
  
  //Variable: wdata
  //Used to store the p_wdata
  rand bit[31:0] data;
  
  //Variable: write
  //Write when write is 1 and read is 0
  rand bit write;

  `uvm_object_utils_begin(apb_tr)
  `uvm_field_int (addr,UVM_ALL_ON)
  `uvm_field_int (data,UVM_ALL_ON)
  `uvm_field_int (write,UVM_ALL_ON)
  `uvm_object_utils_end

  //new constructor
  function new(string name ="apb_tr");
    super.new(name);
  endfunction:new

  //constraint for an address to select only 0 , 4 and 8th address 
  constraint c_addr{addr inside {0,4,8};}
  

endclass:apb_tr

