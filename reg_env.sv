 
class reg_env extends uvm_env;
   `uvm_component_utils (reg_env)
  
  //new constructor
   function new (string name="reg_env", uvm_component parent);
      super.new (name, parent);
   endfunction

   ral_sys_block                m_ral_model;         // Register Model
   reg2apb_adapter              m_reg2apb;           // Convert Reg Tx <-> Bus-type packets
  uvm_reg_predictor #(apb_tr)   m_apb2reg_predictor; // Map APB tx to register in model
   register_agent                     m_agent;             // Agent to drive/monitor transactions

  //build phase
   virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);
      m_ral_model          = ral_sys_block::type_id::create ("m_ral_model", this);
      m_reg2apb            = reg2apb_adapter :: type_id :: create ("m_reg2apb");
      m_apb2reg_predictor  = uvm_reg_predictor #(apb_tr) :: type_id :: create ("m_apb2reg_predictor", this);

      m_ral_model.build ();
//      m_ral_model.default_map.set_check_on_read(1);
      m_ral_model.lock_model ();
     uvm_config_db #(ral_sys_block)::set (uvm_root::get(), "*", "m_ral_model", m_ral_model);
   endfunction

  //connect phase
   virtual function void connect_phase (uvm_phase phase);
      super.connect_phase (phase);
      m_apb2reg_predictor.map       = m_ral_model.default_map; //predict map = default map of ral model
      m_apb2reg_predictor.adapter   = m_reg2apb; // redictor adapter = adapter present in ral model
   endfunction   
endclass
