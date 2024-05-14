class write_driver extends uvm_driver#(write_seq_item);
  `uvm_component_utils(write_driver)
  
  //handle for write sequence item
  write_seq_item bus_tx;
  
  //handle for virtual sequence
  virtual apb_if vif;
  
  //new constructor
  function new(string name="write_driver",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  //build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    bus_tx = write_seq_item::type_id::create("bus_tx");
    if(! uvm_config_db#(virtual apb_if)::get(this,"","apb_if",vif))
      `uvm_fatal("Write agent driver","Failed to get interface")
  endfunction
  
      //run phase
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);

    @(posedge vif.clk) //5
      vif.rst<=1'b0;
    @(posedge vif.clk) //15
      vif.rst<=1'b1;
     
    //driver sequenced handshaking mechanism
      forever begin
        @(posedge vif.clk) //25
      seq_item_port.get_next_item(bus_tx);
      drive_packet_dut();
      seq_item_port.item_done();
      end
    
  endtask
    
    
  //task drive_packet_dut -> driving the packet to dut through interface 
  task drive_packet_dut();
    `uvm_info(get_type_name(),$sformatf("src_addr=%b",bus_tx.src_addr),UVM_NONE)
    `uvm_info(get_type_name(),$sformatf("dest_addr=%b",bus_tx.dest_addr),UVM_NONE)
    `uvm_info(get_type_name(),$sformatf("id=%b",bus_tx.id),UVM_NONE)
    `uvm_info(get_type_name(),$sformatf("data=%b",bus_tx.data),UVM_NONE)
    
    bus_tx.pkt = {bus_tx.src_addr,bus_tx.dest_addr,bus_tx.id,bus_tx.data}; //concatenate
    
    `uvm_info(get_type_name(),$sformatf(" packet=%b",bus_tx.pkt),UVM_NONE)
    `uvm_info(get_type_name(),$sformatf(" packet=%h",bus_tx.pkt),UVM_NONE)
    `uvm_info(get_type_name(),$sformatf(" packet=%d",bus_tx.pkt),UVM_NONE)
   
    
    @(posedge vif.clk);//35
    vif.Valid_in <= 1'b1;  //make valid in high
    
    //send each bit of packet into data_in  for each edge
    foreach(bus_tx.pkt[i])
      begin
        vif.Data_in <= bus_tx.pkt[i];
//             `uvm_info(get_type_name(),$sformatf(" vif.Data_in= %b, packet[%0d] =%b, vif.valid_in = %0h",vif.Data_in,i,bus_tx.pkt[i], vif.Valid_in),UVM_NONE)
        @(posedge vif.clk);  //35-675ns
      end

      vif.Valid_in <= 0;
      bus_tx.pkt <= 0;
   endtask
endclass
