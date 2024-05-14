class env extends uvm_env;
   `uvm_component_utils (env)
  
  //handle for register agent
  register_agent    m_agent;
  
  //handle for write agent
  write_agent w_agent;
  
  //handle for read agent
  read_agent  r_agent;
  
  //handle for register environment
  reg_env     m_reg_env;
  
  //handle for scoreboard
  scoreboard scb;
   
  //new constructor
   function new (string name = "env", uvm_component parent);
      super.new (name, parent);
   endfunction
   
  //build phase
   virtual function void build_phase (uvm_phase phase);
     super.build_phase (phase);
     m_agent = register_agent::type_id::create ("m_agent", this);
     w_agent = write_agent::type_id::create ("w_agent", this);
     r_agent = read_agent::type_id::create ("r_agent", this);
     m_reg_env = reg_env::type_id::create ("m_reg_env", this);
     scb = scoreboard::type_id::create ("scb", this);
     
     set_config_int("r_agent", "is_active", UVM_PASSIVE); // Configure p_agent as passive agent
   endfunction

  //connect phase
   virtual function void connect_phase (uvm_phase phase);
     super.connect_phase (phase);
     m_reg_env.m_agent = m_agent;   //register env- agent = register agent
     m_agent.m_mon.mon_ap.connect (m_reg_env.m_apb2reg_predictor.bus_in); //analysis port
     m_reg_env.m_ral_model.default_map.set_sequencer(m_agent.m_seqr, m_reg_env.m_reg2apb);
     
     //write monitor to scoreboard connection
     w_agent.write_mon.wr_mon_ap.connect(scb.w_agt_mon2scb);
     uvm_report_info("MY_ENVIRONMENT", "connect_phase, Connected write agent monitor to scoreboard");
     //read monitor to scoreboard connection
     r_agent.read_mon.rd_mon_ap.connect(scb.r_agt_mon2scb);
     uvm_report_info("MY_ENVIRONMENT", "connect_phase, Connected read agent monitor to scoreboard");
   endfunction

endclass
