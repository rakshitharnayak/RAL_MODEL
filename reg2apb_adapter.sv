class reg2apb_adapter extends uvm_reg_adapter;
   `uvm_object_utils (reg2apb_adapter)

  //new constructor
   function new (string name = "reg2apb_adapter");
      super.new (name);
   endfunction

  //convert register to bus
   virtual function uvm_sequence_item reg2bus (const ref uvm_reg_bus_op rw);
      apb_tr pkt = apb_tr::type_id::create ("pkt");
      pkt.write = (rw.kind == UVM_WRITE) ? 1: 0;
      pkt.addr  = rw.addr;
      pkt.data  = rw.data;
      `uvm_info ("adapter", $sformatf ("reg2bus addr=0x%0h data=0x%0h kind=%s", pkt.addr, pkt.data, rw.kind.name), UVM_HIGH) 
      return pkt; 
   endfunction

  //convert bus to register
   virtual function void bus2reg (uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
      apb_tr pkt;
      if (! $cast (pkt, bus_item)) begin
         `uvm_fatal ("reg2apb_adapter", "Failed to cast bus_item to pkt")
      end
   
      rw.kind = pkt.write ? UVM_WRITE : UVM_READ;
      rw.addr = pkt.addr;
      rw.data = pkt.data;
      `uvm_info ("adapter", $sformatf("bus2reg : addr=0x%0h data=0x%0h kind=%s status=%s", rw.addr, rw.data, rw.kind.name(), rw.status.name()), UVM_HIGH)
   endfunction
  
endclass
