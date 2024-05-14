class write_agent extends uvm_agent;
  `uvm_component_utils(write_agent)
  
  write_driver dri;                    //Handle for write driver
  write_sequencer seqr;               //Handle for write sequencer
  write_monitor write_mon;            //Handle for write monitor
  
  
  //new constructor
  function new(string name="write_agent", uvm_component parent);
    super.new(name,parent);
  endfunction
  
  //build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(get_is_active() == UVM_ACTIVE)
      begin
        dri=write_driver::type_id::create("dri",this);
        seqr=write_sequencer::type_id::create("seqr",this);
        `uvm_info(get_name(), "This is Active agent", UVM_LOW);
      end
    write_mon=write_monitor::type_id::create("write_mon",this);
  endfunction
  
  //connect phase
  virtual function void connect_phase(uvm_phase phase);
   super.connect_phase(phase);
   if(get_is_active()==UVM_ACTIVE)
     begin
       dri.seq_item_port.connect(seqr.seq_item_export);
       uvm_report_info("WRITE_AGENT", "connect_phase, Connected driver to sequencer");
     end
 endfunction
      
endclass: write_agent
