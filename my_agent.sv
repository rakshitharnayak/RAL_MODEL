class my_agent extends uvm_agent;
   `uvm_component_utils (my_agent)
   function new (string name="my_agent", uvm_component parent);
      super.new (name, parent);
   endfunction

   my_driver                  m_drvr;
   my_monitor                 m_mon;
  uvm_sequencer #(apb_tr)   m_seqr; 
  
    virtual apb_if vif;

   virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);
     if(is_active == UVM_ACTIVE) begin
       m_drvr = my_driver::type_id::create ("m_drvr", this);
       m_seqr = uvm_sequencer#(apb_tr)::type_id::create ("m_seqr", this);
     end
     m_mon = my_monitor::type_id::create ("m_mon", this);
     
//      if(!uvm_config_db#(virtual apb_if)::get(this,"","vif",vif))
//       begin
//         `uvm_error("build_phase","agent virtual interface failed");
//       end
   endfunction

   virtual function void connect_phase (uvm_phase phase);
      super.connect_phase (phase);
      m_drvr.seq_item_port.connect (m_seqr.seq_item_export);
     uvm_report_info("MY_AGENT", "connect_phase, Connected driver to sequencer");
   endfunction
endclass
