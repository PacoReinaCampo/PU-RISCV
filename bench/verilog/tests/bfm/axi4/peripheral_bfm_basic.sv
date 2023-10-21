import peripheral_axi4_verilog_pkg::*;

module peripheral_bfm_basic;

  initial begin
    $dumpfile("basic.vcd");
    $dumpvars(0, peripheral_bfm_testbench);
  end

  integer        i;

  reg     [31:0] read_data;

  initial begin
    repeat (100) @(posedge peripheral_bfm_testbench.aclk);
    $display("BASIC: Timeout Failure! @ %d", $time);
    $finish;
  end

  initial begin
    $display("AXI Master BFM Test: Basic");

    @(negedge peripheral_bfm_testbench.aresetn);
    @(posedge peripheral_bfm_testbench.aresetn);
    repeat (10) @(posedge peripheral_bfm_testbench.aclk);
    peripheral_bfm_testbench.master.write_single(32'h0000_0004, 32'hdead_beef, AXI_BURST_SIZE_WORD, 4'hF);
    peripheral_bfm_testbench.master.write_single(32'h0000_0008, 32'h1234_5678, AXI_BURST_SIZE_WORD, 4'hF);
    peripheral_bfm_testbench.master.write_single(32'h0000_000C, 32'hABCD_EF00, AXI_BURST_SIZE_WORD, 4'hF);
    peripheral_bfm_testbench.master.write_single(32'h0000_0010, 32'hAA55_66BB, AXI_BURST_SIZE_WORD, 4'hF);
    repeat (10) @(posedge peripheral_bfm_testbench.aclk);

    peripheral_bfm_testbench.master.read_single_and_check(32'h0000_0004, 32'hdead_beef, AXI_BURST_SIZE_WORD, 4'hF);
    peripheral_bfm_testbench.master.read_single_and_check(32'h0000_0008, 32'h1234_5678, AXI_BURST_SIZE_WORD, 4'hF);
    peripheral_bfm_testbench.master.read_single_and_check(32'h0000_000C, 32'hABCD_EF00, AXI_BURST_SIZE_WORD, 4'hF);
    peripheral_bfm_testbench.master.read_single_and_check(32'h0000_0010, 32'hAA55_66BB, AXI_BURST_SIZE_WORD, 4'hF);

    for (i = 0; i < 5; i = i + 1) begin
      $display("MEMORY[%d] = 0x%04x", i, peripheral_bfm_testbench.slave.memory[i]);
    end

    peripheral_bfm_testbench.test_passed <= 1;
  end
endmodule  // peripheral_bfm_basic
