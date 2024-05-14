class write_monitor extends uvm_monitor;
  `uvm_component_utils (write_monitor)
  
  //handle for write sequence item
  write_seq_item bus_tx;
  
  //handle for virtual interface
  virtual apb_if vif;
  
  //to collect the data coming from data_in
  bit variable;
  
  //analysis port
  uvm_analysis_port#(write_seq_item) wr_mon_ap;
  
  //new constructor
  function new (string name="write_monitor", uvm_component parent);
    super.new (name, parent);
    wr_mon_ap = new ("wr_mon_ap", this);
  endfunction
  
  //build phase
   virtual function void build_phase (uvm_phase phase);
     super.build_phase (phase);
     bus_tx = write_seq_item::type_id::create ("bus_tx");
     if(!uvm_config_db#(virtual apb_if)::get(this, "", "apb_if", vif))
       `uvm_fatal(get_full_name(),"VIRTUAL INTERFACE DIDN'T GET IN WRITE MONITOR")
   endfunction
   
  //run phase -> collect the data from dut through virtual interface
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      @(posedge vif.clk);
      
      //check for valid_in
      if(vif.Valid_in) //15  ->25
        begin
          //iterate 64 times to get 64 bits 
          for(int i=0;i<64;i++)
            begin
              variable = vif.Data_in;
              bus_tx.expected_pkt={bus_tx.expected_pkt[62:0], variable};
//               `uvm_info(get_type_name(),$sformatf("variable : %b, vif.Data_in = %b",variable,vif.Data_in),UVM_NONE)
//               $display("inisde forver write monitor insided repeat -> time = %0t", $time);
              @(posedge vif.clk);
            end
          `uvm_info(get_type_name(),$sformatf(" expected packet: %b",bus_tx.expected_pkt),UVM_NONE)
          `uvm_info(get_type_name(),$sformatf(" expected packet: %d",bus_tx.expected_pkt),UVM_NONE)
          wr_mon_ap.write(bus_tx);

        end
    end
      
  endtask
  
endclass
