class my_driver extends uvm_driver #(apb_tr);
   `uvm_component_utils (my_driver)

   apb_tr  pkt;

   virtual apb_if    vif;

   function new (string name = "my_driver", uvm_component parent);
      super.new (name, parent);
   endfunction

   virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);
     if (! uvm_config_db#(virtual apb_if)::get (this, "*", "apb_if", vif))
         `uvm_error ("DRVR", "Did not get bus if handle")
   endfunction

   virtual task run_phase (uvm_phase phase);
      bit [31:0] data;

      vif.psel <= 0;
      vif.pen <= 0;
      vif.p_write <= 0;
      vif.paddr <= 0;
      vif.p_wdata <= 0;
     
     
      forever begin
         @(posedge vif.clk);
         seq_item_port.get_next_item (pkt);
         if (pkt.write)
            write (pkt.addr, pkt.data);
         else begin
            read (pkt.addr, data);
            pkt.data = data;
         end
         seq_item_port.item_done ();
      end
   endtask

   virtual task read (  input bit    [31:0] addr, 
                        output logic [31:0] data);
      vif.paddr <= addr;
      vif.p_write <= 0;
      vif.psel <= 1;
      @(posedge vif.clk);
      vif.pen <= 1;
      @(posedge vif.clk);
      @(posedge vif.clk);
      data = vif.prdata;
      vif.psel <= 0;
      vif.pen <= 0;
   endtask

   virtual task write ( input bit [31:0] addr,
                        input bit [31:0] data);
      vif.paddr <= addr;
      vif.p_wdata <= data;
      vif.p_write <= 1;
      vif.psel <= 1;
      @(posedge vif.clk);
      vif.pen <= 1;
      @(posedge vif.clk);
      vif.psel <= 0;
      vif.pen <= 0;
   endtask
endclass
