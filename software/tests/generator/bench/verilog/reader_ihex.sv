module reader_ihex;

  //////////////////////////////////////////////////////////////////////////////
  // Constants
  //////////////////////////////////////////////////////////////////////////////

  localparam XLEN = 64;
  localparam PLEN = 64;

  // Start here after reset
  parameter PC_INIT = 'h8000_0000;

  // Offset where to load program in memory
  parameter BASE = PC_INIT;

  //////////////////////////////////////////////////////////////////////////////
  // Types
  //////////////////////////////////////////////////////////////////////////////

  typedef logic [PLEN-1:0] addr_type;

  //////////////////////////////////////////////////////////////////////////////
  // Variables
  //////////////////////////////////////////////////////////////////////////////

  logic [XLEN-1:0] memory_array[addr_type];

  //////////////////////////////////////////////////////////////////////////////
  // Tasks
  //////////////////////////////////////////////////////////////////////////////

  // Read Intel HEX
  task automatic read_ihex (
    input string READ_FILE
  );
    integer              m;
    integer              fd;

    bit                  eof;

    bit            [7:0] byte_cnt;
    bit     [  1:0][7:0] address;
    bit            [7:0] record_type;
    bit     [255:0][7:0] data;
    bit            [7:0] checksum;
    bit            [7:0] crc;

    logic [PLEN-1:0] base_addr = BASE;

    // 1: start code
    // 2: byte count  (2 hex digits)
    // 3: address     (4 hex digits)
    // 4: record type (2 hex digits)
    //    00: data
    //    01: end of file
    //    02: extended segment address
    //    03: start segment address
    //    04: extended linear address (16-lsbs of 32-bit address)
    //    05: start linear address
    // 5: data
    // 6: checksum    (2 hex digits)

    // open file
    fd = $fopen(READ_FILE, "r");

    if (fd < 32'h8000_0000) begin
      $display("ERROR : Skip reading file %s. Reason file not found", READ_FILE);
      $finish();
    end

    eof = 1'b0;

    while (eof == 1'b0) begin
      if ($fscanf(fd, ":%2h%4h%2h", byte_cnt, address, record_type) != 3) begin
        $display("ERROR : Read error while processing %s", READ_FILE);
      end

      // initial CRC value
      crc = byte_cnt + address[1] + address[0] + record_type;

      for (m = 0; m < byte_cnt; m = m + 1) begin
        if ($fscanf(fd, "%2h", data[m]) != 1) begin
          $display("ERROR : Read error while processing %s", READ_FILE);
        end

        // update CRC
        crc = crc + data[m];
      end

      if ($fscanf(fd, "%2h", checksum) != 1) begin
        $display("ERROR : Read error while processing %s", READ_FILE);
      end

      if (checksum + crc) begin
        $display("ERROR : CRC error while processing %s", READ_FILE);
      end

      case (record_type)
        8'h00: begin
          for (m = 0; m < byte_cnt; m = m + 1) begin
            memory_array[(base_addr + address + m) & ~(XLEN/8 - 1)][((base_addr + address + m) % (XLEN/8))*8+:8] = data[m];
          end
        end
        8'h01:   eof = 1'b1;
        8'h02:   base_addr = {data[0], data[1]} << 4;
        8'h03:   $display("INFO : Ignored record type %0d while processing %s", record_type, READ_FILE);
        8'h04:   base_addr = {data[0], data[1]} << 16;
        8'h05:   base_addr = {data[0], data[1], data[2], data[3]};
        default: $display("ERROR : Unknown record type while processing %s", READ_FILE);
      endcase
    end

    // close file
    $fclose(fd);
  endtask

  // Write Memory
  task automatic write_memory (
    input string WRITE_FILE
  );
    $writememh(WRITE_FILE, memory_array);
  endtask

  //////////////////////////////////////////////////////////////////////////////
  // Body
  //////////////////////////////////////////////////////////////////////////////

  // Read Intel HEX
  initial begin
    read_ihex("test.hex");
  end

  // Write Memory
  initial begin
    write_memory("test.txt");
  end

endmodule
