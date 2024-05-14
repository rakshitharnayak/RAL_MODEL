
`uvm_analysis_imp_decl(_r_agt) //READ AGENT (PASSIVE)
`uvm_analysis_imp_decl(_w_agt) //WRITE AGENT (ACTIVE)

class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  
  //read agent monitor -> analysis port
  uvm_analysis_imp_r_agt#(write_seq_item, scoreboard) r_agt_mon2scb;
  
  //write agent monitor -> analysis port
  uvm_analysis_imp_w_agt#(write_seq_item, scoreboard) w_agt_mon2scb;
  
  //creating a packet to compare
  bit[63:0] sent_pkt_check;
  bit[63:0] received_pkt_check;
  
  //creating a queue to collect all packets
  bit[63:0] sent_pkt[$];
  bit[63:0] received_pkt[$];
  
  //new constructor
  function new(string name = "scoreboard", uvm_component parent);
    super.new(name, parent);
    r_agt_mon2scb = new("r_agt_mon2scb", this);
    w_agt_mon2scb = new("w_agt_mon2scb", this);
  endfunction
  
  //build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
  // write function -> collect the data from active agent monitor
  virtual function write_w_agt( input write_seq_item w_tr );
    //push the expected pkt into sent_pkt queue
    sent_pkt.push_front( w_tr.expected_pkt) ;
  endfunction

  // write function -> collect the data from passive agent monitor
  virtual function write_r_agt( input write_seq_item r_tr );
    //push the actual pkt into received_pkt queue
    received_pkt.push_front( r_tr.actual_pkt);
  endfunction
  
  //check phase
  virtual function void check_phase(uvm_phase phase);
    super.check_phase(phase);
    
     $display("--------------------------------------------------------------------------------------------------------");
    `uvm_info(get_type_name(),$sformatf(" sent packet=%p",sent_pkt),UVM_NONE)
    `uvm_info(get_type_name(),$sformatf(" received packet=%p",received_pkt),UVM_NONE)
    $display("--------------------------------------------------------------------------------------------------------");
    //compare the packets and iterate based on parameter N 
    for(int j=0;j<`N;j++)
      begin
        sent_pkt_check = sent_pkt.pop_front(); //pop the pkt and store it in sent_pkt_check variable
        received_pkt_check = received_pkt.pop_front(); //pop the pkt and store it in received_pkt_check variable
        compare_pkt(); //compare the sent and received pkt
      end
  endfunction
  
  //compare sent and received pkt
  function void compare_pkt();
    
    `uvm_info(get_type_name(),$sformatf(" sent packet_check=%h, received packet_check=%h",sent_pkt_check, received_pkt_check),UVM_NONE)
    
    //check whether the source address has been interchanged or not
    if(sent_pkt_check[63:48] == received_pkt_check[47:32])
      `uvm_info(get_type_name(),$sformatf(" source address has been interchanged, sent packet source address = %0h and received packet source address = %0h",sent_pkt_check[63:48],received_pkt_check[47:32]),UVM_NONE)
      else
        `uvm_info(get_type_name(),$sformatf(" source address has not been interchanged, sent packet source address = %0h and received packet source address = %0h",sent_pkt_check[63:48],received_pkt_check[47:32]),UVM_NONE)
        
    //check whether the destination address has been interchanged or not
    if(sent_pkt_check[47:32] == received_pkt_check[63:48])
      `uvm_info(get_type_name(),$sformatf(" destination address has been interchanged, sent packet destination address = %0h and received packet destination address = %0h",sent_pkt_check[47:32],received_pkt_check[63:48]),UVM_NONE)
      else
        `uvm_info(get_type_name(),$sformatf(" destination address has not been interchanged, sent packet destination address = %0h and received packet destination address = %0h",sent_pkt_check[47:32],received_pkt_check[63:48]),UVM_NONE)

    
    //check whether the id is same for both the senta nd received packet  
    if(sent_pkt_check[31:16] == received_pkt_check[31:16])
      `uvm_info(get_type_name(),$sformatf(" ID is same for both actual and received packets, sent packet id = %0h and received packet id = %0h",sent_pkt_check[31:16],received_pkt_check[31:16]),UVM_NONE)
      else
        `uvm_info(get_type_name(),$sformatf(" ID is different for both actual and received packets, sent packet id = %0h and received packet id = %0h",sent_pkt_check[31:16],received_pkt_check[31:16]),UVM_NONE)

    
    //check whether the data is same for both the senta nd received packet  
    if(sent_pkt_check[15:0] == received_pkt_check[15:0])
      `uvm_info(get_type_name(),$sformatf(" data is same for both actual and received packets, sent packet data = %0h and received packet data = %0h",sent_pkt_check[15:0],received_pkt_check[15:0]),UVM_NONE)
      else
        `uvm_info(get_type_name(),$sformatf(" data is different for both actual and received packets, sent packet data = %0h and received packet data = %0h",sent_pkt_check[15:0],received_pkt_check[15:0]),UVM_NONE)
        
  $display("--------------------------------------------------------------------------------------------------------");
        endfunction

endclass
