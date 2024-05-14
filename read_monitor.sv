class read_monitor extends uvm_monitor; 
  `uvm_component_utils(read_monitor)
  
  //analysis port
  uvm_analysis_port#(write_seq_item) rd_mon_ap; 
  
  //handle for virtual interface
  virtual apb_if vif;
  
  //handle for write sequence item
  write_seq_item  bus_tx; 
  
  //to collect the data coming from output ports
  bit variable;
  
  //for iteration
  int i;
  
  //new constructor
  function new(string name = "read_monitor", uvm_component parent);
    super.new(name, parent);
    rd_mon_ap = new("rd_mon_ap", this);
  endfunction
  
  //build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    bus_tx = write_seq_item::type_id::create("bus_tx");
    if(!uvm_config_db#(virtual apb_if)::get(this, "", "apb_if", vif))
      `uvm_fatal(get_full_name(),"VIRTUAL INTERFACE DIDN'T GET IN READ MONITOR")

  endfunction
  
      
   //run phase -> collect the data from dut through virtual interface
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      @(posedge vif.clk);
//       $display("inside read monitor - before valid_out high = %0d = time = %0t",vif.Valid_out ,$time);
      //check for valid out
      if(vif.Valid_out)
        begin
          `uvm_info(get_type_name(),$sformatf(" valid out=%b",vif.Valid_out),UVM_NONE)
          
          //check the output is comming from output port 1
          if(vif.paddr == 32'd8 && vif.p_wdata == 32'd1 && vif.prdata == 32'd1)
            begin
              for(i=0;i<64;i++)
                begin
                  variable=vif.out_port1;
                  bus_tx.actual_pkt= {bus_tx.actual_pkt[62:0],variable};
                  @(posedge vif.clk);
                end
            end
          
          //check the output is comming from output port 2
          else if(vif.paddr == 32'd8 && vif.p_wdata == 32'd2 && vif.prdata == 32'd2)
            begin
              for(i=0;i<64;i++)
                begin
                  variable=vif.out_port2;
                  bus_tx.actual_pkt= {bus_tx.actual_pkt[62:0],variable};
                  @(posedge vif.clk);
                end
            end
          
          //check the output is comming from output port 3
          else if(vif.paddr == 32'd8 && vif.p_wdata == 32'd4 && vif.prdata == 32'd4)
            begin
              for(i=0;i<64;i++)
                begin
                  
                  variable=vif.out_port3;
//                   $display("output monitor -> variable[%0d] = %b", i,variable);
                  bus_tx.actual_pkt= {bus_tx.actual_pkt[62:0],variable};
                  @(posedge vif.clk);
                end
            end
          
          //check the output is comming from output port 4
          else if(vif.paddr == 32'd8 && vif.p_wdata == 32'd8 && vif.prdata == 32'd8)
            begin
              for(i=0;i<64;i++)
                begin
                  variable=vif.out_port4;
                  bus_tx.actual_pkt= {bus_tx.actual_pkt[62:0],variable};
                  @(posedge vif.clk);
                end
            end
          
          //default collect teh output from output port 1
          else
            begin
              for(i=0;i<64;i++)
                begin
                  variable=vif.out_port1;
                  bus_tx.actual_pkt= {bus_tx.actual_pkt[62:0],variable};
                  @(posedge vif.clk);
                end
            end
          `uvm_info(get_type_name(),$sformatf(" actual packet=%b",bus_tx.actual_pkt),UVM_NONE)
          `uvm_info(get_type_name(),$sformatf(" actual packet=%d",bus_tx.actual_pkt),UVM_NONE)
          
        end
      
      //only after getting 64 bits = 1 packet then write is called
      if(i == 64)
        begin
          rd_mon_ap.write(bus_tx);
          i =0;
        end
    end
  endtask

endclass
