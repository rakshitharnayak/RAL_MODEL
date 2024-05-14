class read_agent extends uvm_agent;
  `uvm_component_utils(read_agent)
  
  read_monitor read_mon; //Handle for read monitor

  //new constructor
  function new(string name = "read_agent", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  //build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(get_is_active() == UVM_PASSIVE)
      begin
        read_mon = read_monitor::type_id::create("read_mon", this);
        `uvm_info(get_type_name(), "This is READ agent", UVM_LOW);
      end
  endfunction

endclass
