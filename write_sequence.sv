class write_sequence extends uvm_sequence#(write_seq_item);
  `uvm_object_utils(write_sequence)
  
  //new constructor
  function new(string name="write_sequence");
    super.new(name);
  endfunction
  
  //body task -> driver sequench handshaking mechanism
  virtual task body();
    repeat(`N)
      begin
        req= write_seq_item::type_id::create("req");
        start_item(req);
        req.randomize();
        finish_item(req);
      end
  endtask

endclass: write_sequence
