
class register_sequence extends uvm_sequence#(apb_tr);
  `uvm_object_utils (register_sequence)
  
  //new constructor
  function new (string name = "register_sequence");
      super.new (name);
   endfunction

   ral_sys_block    m_ral_model;  //ral model reg-block
 
  //task body
   virtual task body ();
     uvm_reg_data_t read_data;
     uvm_status_e status;
     
    
     if(!uvm_config_db#(ral_sys_block) :: get(uvm_root::get(), "", "m_ral_model", m_ral_model))
      `uvm_fatal(get_type_name(), "m_ral_model is not set at top level");
     
//*****************************************************************************************************  
     /*
     //reset check
     `uvm_info(get_type_name(), $sformatf("********RESET CHECK ********"), UVM_LOW)
     //m_Chip_enable
      `uvm_info(get_type_name(), $sformatf("******** chip enable ********"), UVM_LOW)
     
     `uvm_info(get_type_name(), $sformatf("******** read chip enable ********"), UVM_LOW)
     m_ral_model.cfg.m_Chip_enable.read(status,read_data);
     assert(status == UVM_IS_OK) else
       `uvm_error("MY SEQUENCE", "Failed to access register CHIP ID(read)")
       
        `uvm_info("[SEQ]:", $sformatf("Read Tx to DUT -> Desired Value: %0d & Mirrored Value: %0d & Data Read: %0d", m_ral_model.cfg.m_Chip_enable.get(), m_ral_model.cfg.m_Chip_enable.get_mirrored_value(),read_data),UVM_NONE);
     if (read_data != 'b1)
      `uvm_error( "TESTSEQ", 
                  $sformatf("Expected value = %0h, actual = %0h", 
                    'b1, read_data
                  )
                )
                */
 //**************************************************************************      
     /*
       
       `uvm_info(get_type_name(), $sformatf("******** chip ID ********"), UVM_LOW)
     
       `uvm_info(get_type_name(), $sformatf("******** read chip ID ********"), UVM_LOW) 
       
       m_ral_model.cfg.m_Chip_Id.read(status,read_data);
     assert(status == UVM_IS_OK) else
       `uvm_error("MY SEQUENCE", "Failed to access register CHIP ID(read)")
        `uvm_info("[SEQ]:", $sformatf("Read Tx to DUT -> Desired Value: %0d & Mirrored Value: %0d & Data Read: %0d", m_ral_model.cfg.m_Chip_Id.get(), m_ral_model.cfg.m_Chip_Id.get_mirrored_value(),read_data),UVM_NONE);
     if (read_data != 'hAA)
      `uvm_error( "TESTSEQ", 
                  $sformatf("Expected value = %0h, actual = %0h", 
                    'hAA, read_data
                  )
                )
       */
//**************************************************************************    
 /*      
 `uvm_info(get_type_name(), $sformatf("******** m_Output_Port_enable********"), UVM_LOW)
     
       `uvm_info(get_type_name(), $sformatf("******** read m_Output_Port_enable ********"), UVM_LOW) 
       
       m_ral_model.cfg.m_Output_Port_enable.read(status,read_data);
     assert(status == UVM_IS_OK) else
       `uvm_error("MY SEQUENCE", "Failed to access register CHIP ID(read)")
       `uvm_info("[SEQ]:", $sformatf("Read Tx to DUT -> Desired Value:0x%0h & Mirrored Value: 0x%0h & Data Read: 0x%0h", m_ral_model.cfg.m_Output_Port_enable.get(), m_ral_model.cfg.m_Output_Port_enable.get_mirrored_value(),read_data),UVM_NONE);
     if (read_data != 'b0001)
      `uvm_error( "TESTSEQ", 
                  $sformatf("Expected value = %0h, actual = %0h", 
                    'b0001, read_data
                  )
                )
                */
//**************************************************************************    
      
       //write and read chip enable
       
       `uvm_info(get_type_name(), $sformatf("******** write and read chip enable ********"), UVM_LOW)
     
          m_ral_model.cfg.m_Chip_enable.write(status,1'b1);
     `uvm_info(get_type_name(), $sformatf("WRITE: desired=0x%0h mirrored=0x%0h", m_ral_model.cfg.m_Chip_enable.get(), m_ral_model.cfg.m_Chip_enable.get_mirrored_value()), UVM_NONE)
     
     m_ral_model.cfg.m_Chip_enable.read(status,read_data);
     `uvm_info(get_type_name(), $sformatf("READ: desired=0x%0h mirrored=0x%0h", m_ral_model.cfg.m_Chip_enable.get(), m_ral_model.cfg.m_Chip_enable.get_mirrored_value()), UVM_NONE)
    
     /*
     `uvm_info(get_type_name(), $sformatf("******** set and update chip enable ********"), UVM_LOW)
     
     m_ral_model.cfg.m_Chip_enable.set(1'b0);
     `uvm_info(get_type_name(), $sformatf("SET: desired=0x%0h mirrored=0x%0h", m_ral_model.cfg.m_Chip_enable.get(), m_ral_model.cfg.m_Chip_enable.get_mirrored_value()), UVM_NONE)
     
     m_ral_model.cfg.m_Chip_enable.update(status);
     `uvm_info(get_type_name(), $sformatf("UPDATE: desired=0x%0h mirrored=0x%0h", m_ral_model.cfg.m_Chip_enable.get(), m_ral_model.cfg.m_Chip_enable.get_mirrored_value()), UVM_NONE)
     
     `uvm_info(get_type_name(), $sformatf("******** PREDICT and MIRROR chip enable ********"), UVM_LOW)
     
     m_ral_model.cfg.m_Chip_enable.predict(1'b1);
     `uvm_info(get_type_name(), $sformatf(" PREDICT : desired=0x%0h mirrored=0x%0h", m_ral_model.cfg.m_Chip_enable.get(), m_ral_model.cfg.m_Chip_enable.get_mirrored_value()), UVM_NONE)
//       m_ral_model.cfg.m_Chip_enable.read (status, rdata);
      m_ral_model.cfg.m_Chip_enable.mirror(status, UVM_CHECK);
     `uvm_info(get_type_name(), $sformatf("MIRROR: desired=0x%0h mirrored=0x%0h", m_ral_model.cfg.m_Chip_enable.get(), m_ral_model.cfg.m_Chip_enable.get_mirrored_value()), UVM_NONE)

*/
 //**************************************************************************    
     /*
     //try to write in chip id register
     //m_Chip_id - Read Only
     `uvm_info(get_type_name(), $sformatf("******** chip id********"), UVM_LOW)
     `uvm_info(get_type_name(), $sformatf("******** write and read chip id ********"), UVM_LOW)
     m_ral_model.cfg.m_Chip_Id.write(status,8'b11111111);
//         rdata_d = m_ral_model.cfg.m_Chip_Id.get();
//         rdata_m = m_ral_model.cfg.m_Chip_Id.get_mirrored_value();
        `uvm_info("[SEQ]:", $sformatf("Write Tx to DUT -> Desired Value: %0d & Mirrored Value: %0d",m_ral_model.cfg.m_Chip_Id.get(), m_ral_model.cfg.m_Chip_Id.get_mirrored_value()),UVM_NONE);
     
     m_ral_model.cfg.m_Chip_Id.read(status,read_data);
     assert(status == UVM_IS_OK) else
       `uvm_error("MY SEQUENCE", "Failed to access register CHIP ID(read)")
        `uvm_info("[SEQ]:", $sformatf("Read Tx to DUT -> Desired Value: %0d & Mirrored Value: %0d & Data Read: %0d",m_ral_model.cfg.m_Chip_Id.get(), m_ral_model.cfg.m_Chip_Id.get_mirrored_value(),read_data),UVM_NONE);
     if (read_data != 'hAA)
      `uvm_error( "TESTSEQ", 
                  $sformatf("Expected value = %0h, actual = %0h", 
                    'hAA, read_data
                  )
                )
        
      */ 
 //**************************************************************************    
     
     //m_Chip_output enable - Read and write 
       `uvm_info(get_type_name(), $sformatf("******** chip output port enable ********"), UVM_LOW)
       `uvm_info(get_type_name(), $sformatf("******** write and read chip output port enable ********"), UVM_LOW)
     
     m_ral_model.cfg.m_Output_Port_enable.write(status,4'b0100);//check_on_read
        `uvm_info("[SEQ]:", $sformatf("Write Tx to DUT -> Desired Value: %0d & Mirrored Value: %0d",m_ral_model.cfg.m_Output_Port_enable.get(), m_ral_model.cfg.m_Output_Port_enable.get_mirrored_value()),UVM_NONE);
        
        m_ral_model.cfg.m_Output_Port_enable.read(status,read_data);
        `uvm_info("[SEQ]:", $sformatf("Read Tx to DUT -> Desired Value: %0d & Mirrored Value: %0d & Data Read: %0d",m_ral_model.cfg.m_Output_Port_enable.get(), m_ral_model.cfg.m_Output_Port_enable.get_mirrored_value(),read_data),UVM_NONE);
        

        $display("------------------------------------------------------------------------");
        
   endtask
endclass
