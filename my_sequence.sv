
class my_sequence extends uvm_sequence#(apb_tr);
   `uvm_object_utils (my_sequence)
  
   function new (string name = "my_sequence");
      super.new (name);
   endfunction

   ral_sys_block    m_ral_model;  //ral model reg-block
 
   virtual task body ();
      uvm_reg_data_t read_data;
    uvm_status_e status;
     bit [3:0] rdata_d,rdata_m;
    
      
     `uvm_info(get_type_name(), $sformatf("********  ********"), UVM_LOW)
//      `uvm_info(get_type_name(), "Reg seq: Inside Body", UVM_LOW);
    if(!uvm_config_db#(ral_sys_block) :: get(uvm_root::get(), "", "m_ral_model", m_ral_model))
      `uvm_fatal(get_type_name(), "m_ral_model is not set at top level");
     
     //m_Chip_enable
     m_ral_model.cfg.m_Chip_enable.write(status,1'b1);
        rdata_d = m_ral_model.cfg.m_Chip_enable.get();
        rdata_m = m_ral_model.cfg.m_Chip_enable.get_mirrored_value();
        `uvm_info("[SEQ]:", $sformatf("Write Tx to DUT -> Desired Value: %0d & Mirrored Value: %0d",rdata_d,rdata_m),UVM_NONE);
     
     m_ral_model.cfg.m_Output_Port_enable.read(status,read_data);
        rdata_d = m_ral_model.cfg.m_Output_Port_enable.get();
        rdata_m = m_ral_model.cfg.m_Output_Port_enable.get_mirrored_value();
        `uvm_info("[SEQ]:", $sformatf("Read Tx to DUT -> Desired Value: %0d & Mirrored Value: %0d & Data Read: %0d",rdata_d,rdata_m,read_data),UVM_NONE);
      
     //m_Output_Port_enable
      m_ral_model.cfg.m_Output_Port_enable.write(status,4'b0010);
        rdata_d = m_ral_model.cfg.m_Output_Port_enable.get();
        rdata_m = m_ral_model.cfg.m_Output_Port_enable.get_mirrored_value();
        `uvm_info("[SEQ]:", $sformatf("Write Tx to DUT -> Desired Value: %0d & Mirrored Value: %0d",rdata_d,rdata_m),UVM_NONE);
        
        m_ral_model.cfg.m_Output_Port_enable.read(status,read_data);
        rdata_d = m_ral_model.cfg.m_Output_Port_enable.get();
        rdata_m = m_ral_model.cfg.m_Output_Port_enable.get_mirrored_value();
        `uvm_info("[SEQ]:", $sformatf("Read Tx to DUT -> Desired Value: %0d & Mirrored Value: %0d & Data Read: %0d",rdata_d,rdata_m,read_data),UVM_NONE);
        
        $display("------------------------------------------------------------------------");
        
   endtask
endclass
