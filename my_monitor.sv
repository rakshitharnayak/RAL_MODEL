class my_monitor extends uvm_monitor;
   `uvm_component_utils (my_monitor)
  uvm_analysis_port #(apb_tr)  mon_ap;
  
   function new (string name="my_monitor", uvm_component parent);
      super.new (name, parent);
     mon_ap = new ("mon_ap", this);
   endfunction

   virtual apb_if vif;

   virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);
     uvm_config_db #(virtual apb_if)::get (null, "uvm_test_top.*", "apb_if", vif);
   endfunction
   
   virtual task run_phase (uvm_phase phase);
      fork
         forever begin
            @(posedge vif.clk);
           if (vif.psel & vif.pen & vif.rst) begin
               apb_tr pkt = apb_tr::type_id::create ("pkt");
               pkt.addr = vif.paddr;
             if (vif.p_write)
               begin
                  pkt.data = vif.p_wdata;
                 $display("in monitor: write value: vif.pw_data = %0d, data = %0d",vif.p_wdata, pkt.data);
               end
               else
                 begin
                  pkt.data = vif.prdata;
                   $display("in monitor:  read value: vif.p_rdata = %0d, data = %0d",vif.prdata, pkt.data);
                 end
               pkt.write = vif.p_write;
;
               mon_ap.write (pkt);
            end 
         end
      join_none
   endtask
endclass
