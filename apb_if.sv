interface apb_if (input bit clk, input bit rst);
  //input
  logic Data_in, Valid_in;
  logic [31:0] paddr;
  logic [31:0] p_wdata;
  logic psel;
  logic pen;
  logic p_write;
  //output
  logic out_port1, out_port2, out_port3, out_port4, Valid_out;
  logic [31:0] prdata;
  
endinterface
