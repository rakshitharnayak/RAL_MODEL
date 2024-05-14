
class test extends uvm_test;
  `uvm_component_utils (test)
  
  //handle foe environment
  env         m_env;
  
  //handle for register sequence
  register_sequence    m_seq;
  
  //handle for write sequence
  write_sequence w_seq;

  //new constructor
   function new (string name = "test", uvm_component parent);
      super.new (name, parent);
   endfunction

  //build phase
   virtual function void build_phase (uvm_phase phase);
     super.build_phase (phase);
     m_env = env::type_id::create ("m_env", this);
     m_seq = register_sequence::type_id::create ("m_seq", this);
     w_seq = write_sequence::type_id::create ("w_seq", this);
   endfunction
  
  //run phase -> start both write and register sequence
   virtual task run_phase (uvm_phase phase);
     phase.raise_objection (this);
     fork
     m_seq.start (m_env.m_agent.m_seqr);//reg seq
     w_seq.start (m_env.w_agent.seqr); //write seq
     join
     #2000;
     phase.drop_objection (this);
//      phase.phase_done.set_drain_time(this, 100);
     

   endtask
endclass



