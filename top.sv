


   import uvm_pkg::*;
`include "uvm_macros.svh"

`include "apb_if.sv"
`include "apb_tr.sv"
`include "ral.sv"
`include "my_sequence.sv"
`include "my_driver.sv"
`include "my_monitor.sv"
`include "my_agent.sv"
`include "reg2apb_adapter.sv"
`include "reg_env.sv"
`include "my_env.sv"
`include "test.sv"
`include "switch.v"

module top;
bit clk;
bit rst;
always #5 clk=~clk;

initial begin
rst=0;
#10 rst=1;
end

  apb_if apb_if(clk,rst);

  switch sw(.clk(apb_if.clk),
            .rst(apb_if.rst),.data_in(apb_if.Data_in),
            .valid_in(apb_if.Valid_in),
            .valid_out(apb_if.Valid_out),
            .paddr(apb_if.paddr),
            .psel(apb_if.psel),
            .pen(apb_if.pen),
            .p_write(apb_if.p_write),
            .p_wdata(apb_if.p_wdata),
            .prdata(apb_if.prdata),
            .out_port1(apb_if.out_port1),
            .out_port2(apb_if.out_port2),
            .out_port3(apb_if.out_port3),
            .out_port4(apb_if.out_port4));

initial begin
uvm_config_db #(virtual apb_if)::set(null, "uvm_test_top.*","apb_if",apb_if);
  run_test("base_test");
end

initial begin
$dumpfile("dump.vcd");
$dumpvars;
   #500 $finish;
end
endmodule:top
