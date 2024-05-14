class register_monitor extends uvm_monitor;
  `uvm_component_utils (register_monitor)
  
  //Handle for apb transaction(apb_tr)
  apb_tr pkt;
  
  //handle for virtual interface
  virtual apb_if vif;
  
  //analysis port
  uvm_analysis_port #(apb_tr)  mon_ap;
  
  //new constructor
  function new (string name="register_monitor", uvm_component parent);
     super.new (name, parent);
     mon_ap = new ("mon_ap", this);
   endfunction

  //build phase
   virtual function void build_phase (uvm_phase phase);
     super.build_phase (phase);
     pkt = apb_tr::type_id::create ("pkt");
     uvm_config_db #(virtual apb_if)::get (this, "*", "apb_if", vif);
   endfunction
   
  //run phase -> collect the data from dut through virtual interface
   virtual task run_phase (uvm_phase phase);
      fork
         forever begin
           @(posedge vif.clk);
           if (vif.psel & vif.pen & vif.rst)
             begin 
               pkt.addr = vif.paddr;
               if (vif.p_write) //WRITE
                 begin
                   pkt.data = vif.p_wdata;
                 end
               else //READ
                 begin
//                    @(posedge vif.clk);
                   pkt.data = vif.prdata;
                 end
               pkt.write = vif.p_write;
               mon_ap.write (pkt);
            end 
         end
      join_none
   endtask
endclass
