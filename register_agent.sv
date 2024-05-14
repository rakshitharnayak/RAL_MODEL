class register_agent extends uvm_agent;
  `uvm_component_utils (register_agent)
  
  //new constructor
  function new (string name="register_agent", uvm_component parent);
    super.new (name, parent);
  endfunction
  
   register_driver                  m_drvr;   //Handle for register driver
   register_monitor                 m_mon;    //Handle for register monitor
  uvm_sequencer #(apb_tr)   m_seqr;           //Handle for register sequencer
  
  //handle for virtual interface
  virtual apb_if vif;
  
  //build phase
  virtual function void build_phase (uvm_phase phase);
    super.build_phase (phase);
    if(is_active == UVM_ACTIVE)
      begin
        m_drvr = register_driver::type_id::create ("m_drvr", this);
        m_seqr = uvm_sequencer#(apb_tr)::type_id::create ("m_seqr", this);
     end
    m_mon = register_monitor::type_id::create ("m_mon", this);
    
    if(!uvm_config_db#(virtual apb_if)::get(this,"","apb_if",vif))
      begin
        `uvm_error("build_phase","agent virtual interface failed");
      end
   endfunction

  //connect phase
   virtual function void connect_phase (uvm_phase phase);
      super.connect_phase (phase);
      m_drvr.seq_item_port.connect (m_seqr.seq_item_export);
     uvm_report_info("REG_MY_AGENT", "connect_phase, Connected driver to sequencer");
   endfunction
  
endclass
