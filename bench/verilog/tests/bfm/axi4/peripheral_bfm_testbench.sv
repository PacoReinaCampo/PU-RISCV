module peripheral_bfm_testbench;

  // Free running clock
  reg aclk;

  initial begin
    aclk <= 0;
    forever #5 aclk <= ~aclk;
  end

  // Reset
  reg aresetn;

  initial begin
    aresetn <= 1;
    #11;
    aresetn <= 0;
    repeat (10) @(posedge aclk);
    aresetn <= 1;
  end

  // Write Address Channel
  wire [ 3:0] awid;
  wire [31:0] awadr;
  wire [ 3:0] awlen;
  wire [ 2:0] awsize;
  wire [ 1:0] awburst;
  wire [ 1:0] awlock;
  wire [ 3:0] awcache;
  wire [ 2:0] awprot;
  wire        awvalid;
  wire        awready;

  // Write Data Channel
  wire [ 3:0] wid;
  wire [31:0] wrdata;
  wire [ 3:0] wstrb;
  wire        wlast;
  wire        wvalid;
  wire        wready;

  // Write Response Channel
  wire [ 3:0] bid;
  wire [ 1:0] bresp;
  wire        bvalid;
  wire        bready;

  // Read Address Channel
  wire [ 3:0] arid;
  wire [31:0] araddr;
  wire [ 3:0] arlen;
  wire [ 2:0] arsize;
  wire [ 1:0] arlock;
  wire [ 3:0] arcache;
  wire [ 2:0] arprot;
  wire        arvalid;
  wire        arready;

  // Read Data Channel
  wire [ 3:0] rid;
  wire [31:0] rdata;
  wire [ 1:0] rresp;
  wire        rlast;
  wire        rvalid;
  wire        rready;

  // Test Signals
  reg         test_passed;
  wire        test_fail;

  peripheral_bfm_master_generic_axi4 master (
    // Global Signals
    .aclk   (aclk),
    .aresetn(aresetn),

    // Write Address Channel
    .awid   (awid[3:0]),
    .awadr  (awadr[31:0]),
    .awlen  (awlen[3:0]),
    .awsize (awsize[2:0]),
    .awburst(awburst[1:0]),
    .awlock (awlock[1:0]),
    .awcache(awcache[3:0]),
    .awprot (awprot[2:0]),
    .awvalid(awvalid),
    .awready(awready),

    // Write Data Channel
    .wid   (wid[3:0]),
    .wrdata(wrdata[31:0]),
    .wstrb (wstrb[3:0]),
    .wlast (wlast),
    .wvalid(wvalid),
    .wready(wready),

    // Write Response Channel
    .bid   (bid[3:0]),
    .bresp (bresp[1:0]),
    .bvalid(bvalid),
    .bready(bready),

    // Read Address Channel
    .arid   (arid[3:0]),
    .araddr (araddr[31:0]),
    .arlen  (arlen[3:0]),
    .arsize (arsize[2:0]),
    .arlock (arlock[1:0]),
    .arcache(arcache[3:0]),
    .arprot (arprot[2:0]),
    .arvalid(arvalid),
    .arready(arready),

    // Read Data Channel
    .rid   (rid[3:0]),
    .rdata (rdata[31:0]),
    .rresp (rresp[1:0]),
    .rlast (rlast),
    .rvalid(rvalid),
    .rready(rready),

    // Test Signals
    .test_fail(test_fail)
  );

  peripheral_bfm_slave_generic_axi4 slave (
    // Global Signals
    .aclk   (aclk),
    .aresetn(aresetn),

    // Write Address Channel
    .awid   (awid[3:0]),
    .awadr  (awadr[31:0]),
    .awlen  (awlen[3:0]),
    .awsize (awsize[2:0]),
    .awburst(awburst[1:0]),
    .awlock (awlock[1:0]),
    .awcache(awcache[3:0]),
    .awprot (awprot[2:0]),
    .awvalid(awvalid),
    .awready(awready),

    // Write Data Channel
    .wid   (wid[3:0]),
    .wrdata(wrdata[31:0]),
    .wstrb (wstrb[3:0]),
    .wlast (wlast),
    .wvalid(wvalid),
    .wready(wready),

    // Write Response Channel
    .bid   (bid[3:0]),
    .bresp (bresp[1:0]),
    .bvalid(bvalid),
    .bready(bready),

    // Read Address Channel
    .arid   (arid[3:0]),
    .araddr (araddr[31:0]),
    .arlen  (arlen[3:0]),
    .arsize (arsize[2:0]),
    .arlock (arlock[1:0]),
    .arcache(arcache[3:0]),
    .arprot (arprot[2:0]),
    .arvalid(arvalid),
    .arready(arready),

    // Read Data Channel
    .rid   (rid[3:0]),
    .rdata (rdata[31:0]),
    .rresp (rresp[1:0]),
    .rlast (rlast),
    .rvalid(rvalid),
    .rready(rready)
  );

  peripheral_bfm_basic test ();
  initial begin
    @(posedge test_fail);
    $display("TEST FAIL @ %d", $time);
    repeat (10) @(posedge aclk);
    $finish;
  end

  initial begin
    test_passed <= 0;
    @(posedge test_passed);
    $display("TEST PASSED: @ %d", $time);
    repeat (10) @(posedge aclk);
    $finish;
  end
endmodule  // peripheral_bfm_testbench
