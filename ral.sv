// chip_enable register class:

class Chip_enable extends uvm_reg;
  rand uvm_reg_field En;
  `uvm_object_utils(Chip_enable)
  
  function new(string name="Chip_enable");
    super.new(name,1,UVM_NO_COVERAGE); //register size -> 1
  endfunction:new
  
  // Build all register field objects
  virtual function void build();
    this.En = uvm_reg_field::type_id::create ("En"); 
    this.En.configure (this,1,0,"RW",0,1'h1,1,1,1);
  endfunction:build
  
//   En.configure(this, 1(no of bits),0(lsb starting from),RW, 0(bit is volatile-> getting changed in between), 1’h0(uVm reg data- reset data), 1(it has  a reset so 1), 1(is the bit is randomized? yes so 1), 1(individually accessible?yes so 1);
endclass:Chip_enable

// Chip Id register class:

class Chip_Id extends uvm_reg;
  rand uvm_reg_field Id;
  `uvm_object_utils(Chip_Id)
  
  function new(string name="chip_Id");
    super.new(name,8,UVM_NO_COVERAGE);
  endfunction:new

  // Build all register field objects
  virtual function void build();
    this.Id = uvm_reg_field::type_id::create("Id");
    this.Id.configure(this,8,0,"RO",0,8'hAA,1,1,1);
  endfunction:build

endclass:Chip_Id


// 3) Output port enable register class

class Output_Port_enable extends uvm_reg;

  rand uvm_reg_field out;

  `uvm_object_utils(Output_Port_enable)

  function new(string name="Output_Port_enable");
    super.new(name,4,UVM_NO_COVERAGE);
  endfunction:new

  // Build all register field objects
  virtual function void build();
    this.out = uvm_reg_field::type_id::create ("out");
    this.out.configure(this,4,0,"RW",0,4'b0001,1,1,1);
  endfunction:build

endclass:Output_Port_enable


//  reg block

class reg_block extends uvm_reg_block;
  `uvm_object_utils(reg_block);

  rand Chip_enable m_Chip_enable;
  rand Chip_Id m_Chip_Id;
  rand Output_Port_enable m_Output_Port_enable;

  function new(string name="reg_block");
    super.new(name,UVM_NO_COVERAGE);
  endfunction:new

  virtual function void build();
    this.default_map=create_map("",0,4,UVM_LITTLE_ENDIAN,0);
    
    //create
    this.m_Chip_enable=Chip_enable::type_id::create("m_Chip_enable",,get_full_name());
    this.m_Chip_Id=Chip_Id::type_id::create("m_Chip_Id",,get_full_name()); this.m_Output_Port_enable=Output_Port_enable::type_id::create("m_Output_Port_enable",,get_full_name());
    
    //configure
    this.m_Chip_enable.configure(this,null,"");
    this.m_Chip_Id.configure(this,null,"");
    this.m_Output_Port_enable.configure(this,null,"");
    
    //build
    this.m_Chip_enable.build();
    this.m_Chip_Id.build();
    this.m_Output_Port_enable.build();
    
    //mapping
    this.default_map.add_reg(this.m_Chip_enable,`UVM_REG_ADDR_WIDTH'h0,"RW",0);
    this.default_map.add_reg(this.m_Chip_Id,`UVM_REG_ADDR_WIDTH'h4,"RO",0);
    this.default_map.add_reg(this.m_Output_Port_enable,`UVM_REG_ADDR_WIDTH'h8,"RW",0);
    
    lock_model();
  endfunction:build

endclass:reg_block


//whole reg block considered as class ral_sys_block
class ral_sys_block extends uvm_reg_block;
  rand reg_block cfg;

  `uvm_object_utils(ral_sys_block)
  
  function new(string name = "ral_sys_block");
		super.new(name);
	endfunction

	function void build();
      this.default_map = create_map("", 0, 4, UVM_LITTLE_ENDIAN, 0);
      this.cfg = reg_block ::type_id::create("cfg",,get_full_name());
      this.cfg.configure(this, "tb_top.pB0");
      this.cfg.build();
      this.default_map.add_submap(this.cfg.default_map, `UVM_REG_ADDR_WIDTH'h0); //multiple register block the n u nedd add_submap
	endfunction

endclass

