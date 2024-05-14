import uvm_pkg::*;
`include "uvm_macros.svh"
`include "defines.sv"
`include "apb_if.sv"
`include "apb_tr.sv"
`include "write_seq_item.sv"
`include "ral.sv"
`include "register_sequence.sv"
`include "write_sequence.sv"
`include "write_sequencer.sv"
`include "register_driver.sv"
`include "write_driver.sv"
`include "register_monitor.sv"
`include "write_monitor.sv"
`include "register_agent.sv"
`include "write_agent.sv"
`include "read_monitor.sv"
`include "read_agent.sv"
`include "reg2apb_adapter.sv"
`include "scoreboard.sv"
`include "reg_env.sv"
`include "env.sv"
`include "test.sv"

module top;
  bit clk;
  bit rst;
  
  always #5 clk=~clk;
  
  initial begin
    rst=0;
    #9 rst=1;
  end

  apb_if vif(clk,rst);

  switch sw(.clk(vif.clk),
            .rst(vif.rst),
            .data_in(vif.Data_in),
            .valid_in(vif.Valid_in),
            .valid_out(vif.Valid_out),
            .paddr(vif.paddr),
            .psel(vif.psel),
            .pen(vif.pen),
            .p_write(vif.p_write),
            .p_wdata(vif.p_wdata),
            .prdata(vif.prdata),
            .out_port1(vif.out_port1),
            .out_port2(vif.out_port2),
            .out_port3(vif.out_port3),
            .out_port4(vif.out_port4));
  
  initial begin
    uvm_config_db #(virtual apb_if)::set(null, "","apb_if",vif);
    run_test("test");
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    #10000 $finish;
  end
  
endmodule:top
