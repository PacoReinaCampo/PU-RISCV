module generator_mem;

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
        8'h01: begin
          eof = 1'b1;
        end
        8'h02: begin
          base_addr = {data[0], data[1]} << 4;
        end
        8'h03: begin
          $display("INFO : Ignored record type %0d while processing %s", record_type, READ_FILE);
        end
        8'h04: begin
          base_addr = {data[0], data[1]} << 16;
        end
        8'h05: begin
          base_addr = {data[0], data[1], data[2], data[3]};
        end
        default: begin
          $display("ERROR : Unknown record type while processing %s", READ_FILE);
        end
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

  // Read Intel HEX and Write Memory
  initial begin
    read_ihex("../../../../hex/rv32mi-p-breakpoint.hex"); write_memory("../../../../mem/rv32mi-p-breakpoint.mem");
    read_ihex("../../../../hex/rv32mi-p-csr.hex"); write_memory("../../../../mem/rv32mi-p-csr.mem");
    read_ihex("../../../../hex/rv32mi-p-illegal.hex"); write_memory("../../../../mem/rv32mi-p-illegal.mem");
    read_ihex("../../../../hex/rv32mi-p-lh-misaligned.hex"); write_memory("../../../../mem/rv32mi-p-lh-misaligned.mem");
    read_ihex("../../../../hex/rv32mi-p-lw-misaligned.hex"); write_memory("../../../../mem/rv32mi-p-lw-misaligned.mem");
    read_ihex("../../../../hex/rv32mi-p-ma_addr.hex"); write_memory("../../../../mem/rv32mi-p-ma_addr.mem");
    read_ihex("../../../../hex/rv32mi-p-ma_fetch.hex"); write_memory("../../../../mem/rv32mi-p-ma_fetch.mem");
    read_ihex("../../../../hex/rv32mi-p-mcsr.hex"); write_memory("../../../../mem/rv32mi-p-mcsr.mem");
    read_ihex("../../../../hex/rv32mi-p-sbreak.hex"); write_memory("../../../../mem/rv32mi-p-sbreak.mem");
    read_ihex("../../../../hex/rv32mi-p-scall.hex"); write_memory("../../../../mem/rv32mi-p-scall.mem");
    read_ihex("../../../../hex/rv32mi-p-shamt.hex"); write_memory("../../../../mem/rv32mi-p-shamt.mem");
    read_ihex("../../../../hex/rv32mi-p-sh-misaligned.hex"); write_memory("../../../../mem/rv32mi-p-sh-misaligned.mem");
    read_ihex("../../../../hex/rv32mi-p-sw-misaligned.hex"); write_memory("../../../../mem/rv32mi-p-sw-misaligned.mem");
    read_ihex("../../../../hex/rv32mi-p-zicntr.hex"); write_memory("../../../../mem/rv32mi-p-zicntr.mem");
    read_ihex("../../../../hex/rv32si-p-csr.hex"); write_memory("../../../../mem/rv32si-p-csr.mem");
    read_ihex("../../../../hex/rv32si-p-dirty.hex"); write_memory("../../../../mem/rv32si-p-dirty.mem");
    read_ihex("../../../../hex/rv32si-p-ma_fetch.hex"); write_memory("../../../../mem/rv32si-p-ma_fetch.mem");
    read_ihex("../../../../hex/rv32si-p-sbreak.hex"); write_memory("../../../../mem/rv32si-p-sbreak.mem");
    read_ihex("../../../../hex/rv32si-p-scall.hex"); write_memory("../../../../mem/rv32si-p-scall.mem");
    read_ihex("../../../../hex/rv32si-p-wfi.hex"); write_memory("../../../../mem/rv32si-p-wfi.mem");
    read_ihex("../../../../hex/rv32ua-p-amoadd_w.hex"); write_memory("../../../../mem/rv32ua-p-amoadd_w.mem");
    read_ihex("../../../../hex/rv32ua-p-amoand_w.hex"); write_memory("../../../../mem/rv32ua-p-amoand_w.mem");
    read_ihex("../../../../hex/rv32ua-p-amomaxu_w.hex"); write_memory("../../../../mem/rv32ua-p-amomaxu_w.mem");
    read_ihex("../../../../hex/rv32ua-p-amomax_w.hex"); write_memory("../../../../mem/rv32ua-p-amomax_w.mem");
    read_ihex("../../../../hex/rv32ua-p-amominu_w.hex"); write_memory("../../../../mem/rv32ua-p-amominu_w.mem");
    read_ihex("../../../../hex/rv32ua-p-amomin_w.hex"); write_memory("../../../../mem/rv32ua-p-amomin_w.mem");
    read_ihex("../../../../hex/rv32ua-p-amoor_w.hex"); write_memory("../../../../mem/rv32ua-p-amoor_w.mem");
    read_ihex("../../../../hex/rv32ua-p-amoswap_w.hex"); write_memory("../../../../mem/rv32ua-p-amoswap_w.mem");
    read_ihex("../../../../hex/rv32ua-p-amoxor_w.hex"); write_memory("../../../../mem/rv32ua-p-amoxor_w.mem");
    read_ihex("../../../../hex/rv32ua-p-lrsc.hex"); write_memory("../../../../mem/rv32ua-p-lrsc.mem");
    read_ihex("../../../../hex/rv32ua-v-amoadd_w.hex"); write_memory("../../../../mem/rv32ua-v-amoadd_w.mem");
    read_ihex("../../../../hex/rv32ua-v-amoand_w.hex"); write_memory("../../../../mem/rv32ua-v-amoand_w.mem");
    read_ihex("../../../../hex/rv32ua-v-amomaxu_w.hex"); write_memory("../../../../mem/rv32ua-v-amomaxu_w.mem");
    read_ihex("../../../../hex/rv32ua-v-amomax_w.hex"); write_memory("../../../../mem/rv32ua-v-amomax_w.mem");
    read_ihex("../../../../hex/rv32ua-v-amominu_w.hex"); write_memory("../../../../mem/rv32ua-v-amominu_w.mem");
    read_ihex("../../../../hex/rv32ua-v-amomin_w.hex"); write_memory("../../../../mem/rv32ua-v-amomin_w.mem");
    read_ihex("../../../../hex/rv32ua-v-amoor_w.hex"); write_memory("../../../../mem/rv32ua-v-amoor_w.mem");
    read_ihex("../../../../hex/rv32ua-v-amoswap_w.hex"); write_memory("../../../../mem/rv32ua-v-amoswap_w.mem");
    read_ihex("../../../../hex/rv32ua-v-amoxor_w.hex"); write_memory("../../../../mem/rv32ua-v-amoxor_w.mem");
    read_ihex("../../../../hex/rv32ua-v-lrsc.hex"); write_memory("../../../../mem/rv32ua-v-lrsc.mem");
    read_ihex("../../../../hex/rv32uc-p-rvc.hex"); write_memory("../../../../mem/rv32uc-p-rvc.mem");
    read_ihex("../../../../hex/rv32uc-v-rvc.hex"); write_memory("../../../../mem/rv32uc-v-rvc.mem");
    read_ihex("../../../../hex/rv32ud-p-fadd.hex"); write_memory("../../../../mem/rv32ud-p-fadd.mem");
    read_ihex("../../../../hex/rv32ud-p-fclass.hex"); write_memory("../../../../mem/rv32ud-p-fclass.mem");
    read_ihex("../../../../hex/rv32ud-p-fcmp.hex"); write_memory("../../../../mem/rv32ud-p-fcmp.mem");
    read_ihex("../../../../hex/rv32ud-p-fcvt.hex"); write_memory("../../../../mem/rv32ud-p-fcvt.mem");
    read_ihex("../../../../hex/rv32ud-p-fcvt_w.hex"); write_memory("../../../../mem/rv32ud-p-fcvt_w.mem");
    read_ihex("../../../../hex/rv32ud-p-fdiv.hex"); write_memory("../../../../mem/rv32ud-p-fdiv.mem");
    read_ihex("../../../../hex/rv32ud-p-fmadd.hex"); write_memory("../../../../mem/rv32ud-p-fmadd.mem");
    read_ihex("../../../../hex/rv32ud-p-fmin.hex"); write_memory("../../../../mem/rv32ud-p-fmin.mem");
    read_ihex("../../../../hex/rv32ud-p-ldst.hex"); write_memory("../../../../mem/rv32ud-p-ldst.mem");
    read_ihex("../../../../hex/rv32ud-p-recoding.hex"); write_memory("../../../../mem/rv32ud-p-recoding.mem");
    read_ihex("../../../../hex/rv32ud-v-fadd.hex"); write_memory("../../../../mem/rv32ud-v-fadd.mem");
    read_ihex("../../../../hex/rv32ud-v-fclass.hex"); write_memory("../../../../mem/rv32ud-v-fclass.mem");
    read_ihex("../../../../hex/rv32ud-v-fcmp.hex"); write_memory("../../../../mem/rv32ud-v-fcmp.mem");
    read_ihex("../../../../hex/rv32ud-v-fcvt.hex"); write_memory("../../../../mem/rv32ud-v-fcvt.mem");
    read_ihex("../../../../hex/rv32ud-v-fcvt_w.hex"); write_memory("../../../../mem/rv32ud-v-fcvt_w.mem");
    read_ihex("../../../../hex/rv32ud-v-fdiv.hex"); write_memory("../../../../mem/rv32ud-v-fdiv.mem");
    read_ihex("../../../../hex/rv32ud-v-fmadd.hex"); write_memory("../../../../mem/rv32ud-v-fmadd.mem");
    read_ihex("../../../../hex/rv32ud-v-fmin.hex"); write_memory("../../../../mem/rv32ud-v-fmin.mem");
    read_ihex("../../../../hex/rv32ud-v-ldst.hex"); write_memory("../../../../mem/rv32ud-v-ldst.mem");
    read_ihex("../../../../hex/rv32ud-v-recoding.hex"); write_memory("../../../../mem/rv32ud-v-recoding.mem");
    read_ihex("../../../../hex/rv32uf-p-fadd.hex"); write_memory("../../../../mem/rv32uf-p-fadd.mem");
    read_ihex("../../../../hex/rv32uf-p-fclass.hex"); write_memory("../../../../mem/rv32uf-p-fclass.mem");
    read_ihex("../../../../hex/rv32uf-p-fcmp.hex"); write_memory("../../../../mem/rv32uf-p-fcmp.mem");
    read_ihex("../../../../hex/rv32uf-p-fcvt.hex"); write_memory("../../../../mem/rv32uf-p-fcvt.mem");
    read_ihex("../../../../hex/rv32uf-p-fcvt_w.hex"); write_memory("../../../../mem/rv32uf-p-fcvt_w.mem");
    read_ihex("../../../../hex/rv32uf-p-fdiv.hex"); write_memory("../../../../mem/rv32uf-p-fdiv.mem");
    read_ihex("../../../../hex/rv32uf-p-fmadd.hex"); write_memory("../../../../mem/rv32uf-p-fmadd.mem");
    read_ihex("../../../../hex/rv32uf-p-fmin.hex"); write_memory("../../../../mem/rv32uf-p-fmin.mem");
    read_ihex("../../../../hex/rv32uf-p-ldst.hex"); write_memory("../../../../mem/rv32uf-p-ldst.mem");
    read_ihex("../../../../hex/rv32uf-p-move.hex"); write_memory("../../../../mem/rv32uf-p-move.mem");
    read_ihex("../../../../hex/rv32uf-p-recoding.hex"); write_memory("../../../../mem/rv32uf-p-recoding.mem");
    read_ihex("../../../../hex/rv32uf-v-fadd.hex"); write_memory("../../../../mem/rv32uf-v-fadd.mem");
    read_ihex("../../../../hex/rv32uf-v-fclass.hex"); write_memory("../../../../mem/rv32uf-v-fclass.mem");
    read_ihex("../../../../hex/rv32uf-v-fcmp.hex"); write_memory("../../../../mem/rv32uf-v-fcmp.mem");
    read_ihex("../../../../hex/rv32uf-v-fcvt.hex"); write_memory("../../../../mem/rv32uf-v-fcvt.mem");
    read_ihex("../../../../hex/rv32uf-v-fcvt_w.hex"); write_memory("../../../../mem/rv32uf-v-fcvt_w.mem");
    read_ihex("../../../../hex/rv32uf-v-fdiv.hex"); write_memory("../../../../mem/rv32uf-v-fdiv.mem");
    read_ihex("../../../../hex/rv32uf-v-fmadd.hex"); write_memory("../../../../mem/rv32uf-v-fmadd.mem");
    read_ihex("../../../../hex/rv32uf-v-fmin.hex"); write_memory("../../../../mem/rv32uf-v-fmin.mem");
    read_ihex("../../../../hex/rv32uf-v-ldst.hex"); write_memory("../../../../mem/rv32uf-v-ldst.mem");
    read_ihex("../../../../hex/rv32uf-v-move.hex"); write_memory("../../../../mem/rv32uf-v-move.mem");
    read_ihex("../../../../hex/rv32uf-v-recoding.hex"); write_memory("../../../../mem/rv32uf-v-recoding.mem");
    read_ihex("../../../../hex/rv32ui-p-add.hex"); write_memory("../../../../mem/rv32ui-p-add.mem");
    read_ihex("../../../../hex/rv32ui-p-addi.hex"); write_memory("../../../../mem/rv32ui-p-addi.mem");
    read_ihex("../../../../hex/rv32ui-p-and.hex"); write_memory("../../../../mem/rv32ui-p-and.mem");
    read_ihex("../../../../hex/rv32ui-p-andi.hex"); write_memory("../../../../mem/rv32ui-p-andi.mem");
    read_ihex("../../../../hex/rv32ui-p-auipc.hex"); write_memory("../../../../mem/rv32ui-p-auipc.mem");
    read_ihex("../../../../hex/rv32ui-p-beq.hex"); write_memory("../../../../mem/rv32ui-p-beq.mem");
    read_ihex("../../../../hex/rv32ui-p-bge.hex"); write_memory("../../../../mem/rv32ui-p-bge.mem");
    read_ihex("../../../../hex/rv32ui-p-bgeu.hex"); write_memory("../../../../mem/rv32ui-p-bgeu.mem");
    read_ihex("../../../../hex/rv32ui-p-blt.hex"); write_memory("../../../../mem/rv32ui-p-blt.mem");
    read_ihex("../../../../hex/rv32ui-p-bltu.hex"); write_memory("../../../../mem/rv32ui-p-bltu.mem");
    read_ihex("../../../../hex/rv32ui-p-bne.hex"); write_memory("../../../../mem/rv32ui-p-bne.mem");
    read_ihex("../../../../hex/rv32ui-p-fence_i.hex"); write_memory("../../../../mem/rv32ui-p-fence_i.mem");
    read_ihex("../../../../hex/rv32ui-p-jal.hex"); write_memory("../../../../mem/rv32ui-p-jal.mem");
    read_ihex("../../../../hex/rv32ui-p-jalr.hex"); write_memory("../../../../mem/rv32ui-p-jalr.mem");
    read_ihex("../../../../hex/rv32ui-p-lb.hex"); write_memory("../../../../mem/rv32ui-p-lb.mem");
    read_ihex("../../../../hex/rv32ui-p-lbu.hex"); write_memory("../../../../mem/rv32ui-p-lbu.mem");
    read_ihex("../../../../hex/rv32ui-p-lh.hex"); write_memory("../../../../mem/rv32ui-p-lh.mem");
    read_ihex("../../../../hex/rv32ui-p-lhu.hex"); write_memory("../../../../mem/rv32ui-p-lhu.mem");
    read_ihex("../../../../hex/rv32ui-p-lui.hex"); write_memory("../../../../mem/rv32ui-p-lui.mem");
    read_ihex("../../../../hex/rv32ui-p-lw.hex"); write_memory("../../../../mem/rv32ui-p-lw.mem");
    read_ihex("../../../../hex/rv32ui-p-ma_data.hex"); write_memory("../../../../mem/rv32ui-p-ma_data.mem");
    read_ihex("../../../../hex/rv32ui-p-or.hex"); write_memory("../../../../mem/rv32ui-p-or.mem");
    read_ihex("../../../../hex/rv32ui-p-ori.hex"); write_memory("../../../../mem/rv32ui-p-ori.mem");
    read_ihex("../../../../hex/rv32ui-p-sb.hex"); write_memory("../../../../mem/rv32ui-p-sb.mem");
    read_ihex("../../../../hex/rv32ui-p-sh.hex"); write_memory("../../../../mem/rv32ui-p-sh.mem");
    read_ihex("../../../../hex/rv32ui-p-simple.hex"); write_memory("../../../../mem/rv32ui-p-simple.mem");
    read_ihex("../../../../hex/rv32ui-p-sll.hex"); write_memory("../../../../mem/rv32ui-p-sll.mem");
    read_ihex("../../../../hex/rv32ui-p-slli.hex"); write_memory("../../../../mem/rv32ui-p-slli.mem");
    read_ihex("../../../../hex/rv32ui-p-slt.hex"); write_memory("../../../../mem/rv32ui-p-slt.mem");
    read_ihex("../../../../hex/rv32ui-p-slti.hex"); write_memory("../../../../mem/rv32ui-p-slti.mem");
    read_ihex("../../../../hex/rv32ui-p-sltiu.hex"); write_memory("../../../../mem/rv32ui-p-sltiu.mem");
    read_ihex("../../../../hex/rv32ui-p-sltu.hex"); write_memory("../../../../mem/rv32ui-p-sltu.mem");
    read_ihex("../../../../hex/rv32ui-p-sra.hex"); write_memory("../../../../mem/rv32ui-p-sra.mem");
    read_ihex("../../../../hex/rv32ui-p-srai.hex"); write_memory("../../../../mem/rv32ui-p-srai.mem");
    read_ihex("../../../../hex/rv32ui-p-srl.hex"); write_memory("../../../../mem/rv32ui-p-srl.mem");
    read_ihex("../../../../hex/rv32ui-p-srli.hex"); write_memory("../../../../mem/rv32ui-p-srli.mem");
    read_ihex("../../../../hex/rv32ui-p-sub.hex"); write_memory("../../../../mem/rv32ui-p-sub.mem");
    read_ihex("../../../../hex/rv32ui-p-sw.hex"); write_memory("../../../../mem/rv32ui-p-sw.mem");
    read_ihex("../../../../hex/rv32ui-p-xor.hex"); write_memory("../../../../mem/rv32ui-p-xor.mem");
    read_ihex("../../../../hex/rv32ui-p-xori.hex"); write_memory("../../../../mem/rv32ui-p-xori.mem");
    read_ihex("../../../../hex/rv32ui-v-add.hex"); write_memory("../../../../mem/rv32ui-v-add.mem");
    read_ihex("../../../../hex/rv32ui-v-addi.hex"); write_memory("../../../../mem/rv32ui-v-addi.mem");
    read_ihex("../../../../hex/rv32ui-v-and.hex"); write_memory("../../../../mem/rv32ui-v-and.mem");
    read_ihex("../../../../hex/rv32ui-v-andi.hex"); write_memory("../../../../mem/rv32ui-v-andi.mem");
    read_ihex("../../../../hex/rv32ui-v-auipc.hex"); write_memory("../../../../mem/rv32ui-v-auipc.mem");
    read_ihex("../../../../hex/rv32ui-v-beq.hex"); write_memory("../../../../mem/rv32ui-v-beq.mem");
    read_ihex("../../../../hex/rv32ui-v-bge.hex"); write_memory("../../../../mem/rv32ui-v-bge.mem");
    read_ihex("../../../../hex/rv32ui-v-bgeu.hex"); write_memory("../../../../mem/rv32ui-v-bgeu.mem");
    read_ihex("../../../../hex/rv32ui-v-blt.hex"); write_memory("../../../../mem/rv32ui-v-blt.mem");
    read_ihex("../../../../hex/rv32ui-v-bltu.hex"); write_memory("../../../../mem/rv32ui-v-bltu.mem");
    read_ihex("../../../../hex/rv32ui-v-bne.hex"); write_memory("../../../../mem/rv32ui-v-bne.mem");
    read_ihex("../../../../hex/rv32ui-v-fence_i.hex"); write_memory("../../../../mem/rv32ui-v-fence_i.mem");
    read_ihex("../../../../hex/rv32ui-v-jal.hex"); write_memory("../../../../mem/rv32ui-v-jal.mem");
    read_ihex("../../../../hex/rv32ui-v-jalr.hex"); write_memory("../../../../mem/rv32ui-v-jalr.mem");
    read_ihex("../../../../hex/rv32ui-v-lb.hex"); write_memory("../../../../mem/rv32ui-v-lb.mem");
    read_ihex("../../../../hex/rv32ui-v-lbu.hex"); write_memory("../../../../mem/rv32ui-v-lbu.mem");
    read_ihex("../../../../hex/rv32ui-v-lh.hex"); write_memory("../../../../mem/rv32ui-v-lh.mem");
    read_ihex("../../../../hex/rv32ui-v-lhu.hex"); write_memory("../../../../mem/rv32ui-v-lhu.mem");
    read_ihex("../../../../hex/rv32ui-v-lui.hex"); write_memory("../../../../mem/rv32ui-v-lui.mem");
    read_ihex("../../../../hex/rv32ui-v-lw.hex"); write_memory("../../../../mem/rv32ui-v-lw.mem");
    read_ihex("../../../../hex/rv32ui-v-ma_data.hex"); write_memory("../../../../mem/rv32ui-v-ma_data.mem");
    read_ihex("../../../../hex/rv32ui-v-or.hex"); write_memory("../../../../mem/rv32ui-v-or.mem");
    read_ihex("../../../../hex/rv32ui-v-ori.hex"); write_memory("../../../../mem/rv32ui-v-ori.mem");
    read_ihex("../../../../hex/rv32ui-v-sb.hex"); write_memory("../../../../mem/rv32ui-v-sb.mem");
    read_ihex("../../../../hex/rv32ui-v-sh.hex"); write_memory("../../../../mem/rv32ui-v-sh.mem");
    read_ihex("../../../../hex/rv32ui-v-simple.hex"); write_memory("../../../../mem/rv32ui-v-simple.mem");
    read_ihex("../../../../hex/rv32ui-v-sll.hex"); write_memory("../../../../mem/rv32ui-v-sll.mem");
    read_ihex("../../../../hex/rv32ui-v-slli.hex"); write_memory("../../../../mem/rv32ui-v-slli.mem");
    read_ihex("../../../../hex/rv32ui-v-slt.hex"); write_memory("../../../../mem/rv32ui-v-slt.mem");
    read_ihex("../../../../hex/rv32ui-v-slti.hex"); write_memory("../../../../mem/rv32ui-v-slti.mem");
    read_ihex("../../../../hex/rv32ui-v-sltiu.hex"); write_memory("../../../../mem/rv32ui-v-sltiu.mem");
    read_ihex("../../../../hex/rv32ui-v-sltu.hex"); write_memory("../../../../mem/rv32ui-v-sltu.mem");
    read_ihex("../../../../hex/rv32ui-v-sra.hex"); write_memory("../../../../mem/rv32ui-v-sra.mem");
    read_ihex("../../../../hex/rv32ui-v-srai.hex"); write_memory("../../../../mem/rv32ui-v-srai.mem");
    read_ihex("../../../../hex/rv32ui-v-srl.hex"); write_memory("../../../../mem/rv32ui-v-srl.mem");
    read_ihex("../../../../hex/rv32ui-v-srli.hex"); write_memory("../../../../mem/rv32ui-v-srli.mem");
    read_ihex("../../../../hex/rv32ui-v-sub.hex"); write_memory("../../../../mem/rv32ui-v-sub.mem");
    read_ihex("../../../../hex/rv32ui-v-sw.hex"); write_memory("../../../../mem/rv32ui-v-sw.mem");
    read_ihex("../../../../hex/rv32ui-v-xor.hex"); write_memory("../../../../mem/rv32ui-v-xor.mem");
    read_ihex("../../../../hex/rv32ui-v-xori.hex"); write_memory("../../../../mem/rv32ui-v-xori.mem");
    read_ihex("../../../../hex/rv32um-p-div.hex"); write_memory("../../../../mem/rv32um-p-div.mem");
    read_ihex("../../../../hex/rv32um-p-divu.hex"); write_memory("../../../../mem/rv32um-p-divu.mem");
    read_ihex("../../../../hex/rv32um-p-mul.hex"); write_memory("../../../../mem/rv32um-p-mul.mem");
    read_ihex("../../../../hex/rv32um-p-mulh.hex"); write_memory("../../../../mem/rv32um-p-mulh.mem");
    read_ihex("../../../../hex/rv32um-p-mulhsu.hex"); write_memory("../../../../mem/rv32um-p-mulhsu.mem");
    read_ihex("../../../../hex/rv32um-p-mulhu.hex"); write_memory("../../../../mem/rv32um-p-mulhu.mem");
    read_ihex("../../../../hex/rv32um-p-rem.hex"); write_memory("../../../../mem/rv32um-p-rem.mem");
    read_ihex("../../../../hex/rv32um-p-remu.hex"); write_memory("../../../../mem/rv32um-p-remu.mem");
    read_ihex("../../../../hex/rv32um-v-div.hex"); write_memory("../../../../mem/rv32um-v-div.mem");
    read_ihex("../../../../hex/rv32um-v-divu.hex"); write_memory("../../../../mem/rv32um-v-divu.mem");
    read_ihex("../../../../hex/rv32um-v-mul.hex"); write_memory("../../../../mem/rv32um-v-mul.mem");
    read_ihex("../../../../hex/rv32um-v-mulh.hex"); write_memory("../../../../mem/rv32um-v-mulh.mem");
    read_ihex("../../../../hex/rv32um-v-mulhsu.hex"); write_memory("../../../../mem/rv32um-v-mulhsu.mem");
    read_ihex("../../../../hex/rv32um-v-mulhu.hex"); write_memory("../../../../mem/rv32um-v-mulhu.mem");
    read_ihex("../../../../hex/rv32um-v-rem.hex"); write_memory("../../../../mem/rv32um-v-rem.mem");
    read_ihex("../../../../hex/rv32um-v-remu.hex"); write_memory("../../../../mem/rv32um-v-remu.mem");
    read_ihex("../../../../hex/rv32uzfh-p-fadd.hex"); write_memory("../../../../mem/rv32uzfh-p-fadd.mem");
    read_ihex("../../../../hex/rv32uzfh-p-fclass.hex"); write_memory("../../../../mem/rv32uzfh-p-fclass.mem");
    read_ihex("../../../../hex/rv32uzfh-p-fcmp.hex"); write_memory("../../../../mem/rv32uzfh-p-fcmp.mem");
    read_ihex("../../../../hex/rv32uzfh-p-fcvt.hex"); write_memory("../../../../mem/rv32uzfh-p-fcvt.mem");
    read_ihex("../../../../hex/rv32uzfh-p-fcvt_w.hex"); write_memory("../../../../mem/rv32uzfh-p-fcvt_w.mem");
    read_ihex("../../../../hex/rv32uzfh-p-fdiv.hex"); write_memory("../../../../mem/rv32uzfh-p-fdiv.mem");
    read_ihex("../../../../hex/rv32uzfh-p-fmadd.hex"); write_memory("../../../../mem/rv32uzfh-p-fmadd.mem");
    read_ihex("../../../../hex/rv32uzfh-p-fmin.hex"); write_memory("../../../../mem/rv32uzfh-p-fmin.mem");
    read_ihex("../../../../hex/rv32uzfh-p-ldst.hex"); write_memory("../../../../mem/rv32uzfh-p-ldst.mem");
    read_ihex("../../../../hex/rv32uzfh-p-move.hex"); write_memory("../../../../mem/rv32uzfh-p-move.mem");
    read_ihex("../../../../hex/rv32uzfh-p-recoding.hex"); write_memory("../../../../mem/rv32uzfh-p-recoding.mem");
    read_ihex("../../../../hex/rv32uzfh-v-fadd.hex"); write_memory("../../../../mem/rv32uzfh-v-fadd.mem");
    read_ihex("../../../../hex/rv32uzfh-v-fclass.hex"); write_memory("../../../../mem/rv32uzfh-v-fclass.mem");
    read_ihex("../../../../hex/rv32uzfh-v-fcmp.hex"); write_memory("../../../../mem/rv32uzfh-v-fcmp.mem");
    read_ihex("../../../../hex/rv32uzfh-v-fcvt.hex"); write_memory("../../../../mem/rv32uzfh-v-fcvt.mem");
    read_ihex("../../../../hex/rv32uzfh-v-fcvt_w.hex"); write_memory("../../../../mem/rv32uzfh-v-fcvt_w.mem");
    read_ihex("../../../../hex/rv32uzfh-v-fdiv.hex"); write_memory("../../../../mem/rv32uzfh-v-fdiv.mem");
    read_ihex("../../../../hex/rv32uzfh-v-fmadd.hex"); write_memory("../../../../mem/rv32uzfh-v-fmadd.mem");
    read_ihex("../../../../hex/rv32uzfh-v-fmin.hex"); write_memory("../../../../mem/rv32uzfh-v-fmin.mem");
    read_ihex("../../../../hex/rv32uzfh-v-ldst.hex"); write_memory("../../../../mem/rv32uzfh-v-ldst.mem");
    read_ihex("../../../../hex/rv32uzfh-v-move.hex"); write_memory("../../../../mem/rv32uzfh-v-move.mem");
    read_ihex("../../../../hex/rv32uzfh-v-recoding.hex"); write_memory("../../../../mem/rv32uzfh-v-recoding.mem");
    read_ihex("../../../../hex/rv64mi-p-access.hex"); write_memory("../../../../mem/rv64mi-p-access.mem");
    read_ihex("../../../../hex/rv64mi-p-breakpoint.hex"); write_memory("../../../../mem/rv64mi-p-breakpoint.mem");
    read_ihex("../../../../hex/rv64mi-p-csr.hex"); write_memory("../../../../mem/rv64mi-p-csr.mem");
    read_ihex("../../../../hex/rv64mi-p-illegal.hex"); write_memory("../../../../mem/rv64mi-p-illegal.mem");
    read_ihex("../../../../hex/rv64mi-p-ld-misaligned.hex"); write_memory("../../../../mem/rv64mi-p-ld-misaligned.mem");
    read_ihex("../../../../hex/rv64mi-p-lh-misaligned.hex"); write_memory("../../../../mem/rv64mi-p-lh-misaligned.mem");
    read_ihex("../../../../hex/rv64mi-p-lw-misaligned.hex"); write_memory("../../../../mem/rv64mi-p-lw-misaligned.mem");
    read_ihex("../../../../hex/rv64mi-p-ma_addr.hex"); write_memory("../../../../mem/rv64mi-p-ma_addr.mem");
    read_ihex("../../../../hex/rv64mi-p-ma_fetch.hex"); write_memory("../../../../mem/rv64mi-p-ma_fetch.mem");
    read_ihex("../../../../hex/rv64mi-p-mcsr.hex"); write_memory("../../../../mem/rv64mi-p-mcsr.mem");
    read_ihex("../../../../hex/rv64mi-p-sbreak.hex"); write_memory("../../../../mem/rv64mi-p-sbreak.mem");
    read_ihex("../../../../hex/rv64mi-p-scall.hex"); write_memory("../../../../mem/rv64mi-p-scall.mem");
    read_ihex("../../../../hex/rv64mi-p-sd-misaligned.hex"); write_memory("../../../../mem/rv64mi-p-sd-misaligned.mem");
    read_ihex("../../../../hex/rv64mi-p-sh-misaligned.hex"); write_memory("../../../../mem/rv64mi-p-sh-misaligned.mem");
    read_ihex("../../../../hex/rv64mi-p-sw-misaligned.hex"); write_memory("../../../../mem/rv64mi-p-sw-misaligned.mem");
    read_ihex("../../../../hex/rv64mi-p-zicntr.hex"); write_memory("../../../../mem/rv64mi-p-zicntr.mem");
    read_ihex("../../../../hex/rv64mzicbo-p-zero.hex"); write_memory("../../../../mem/rv64mzicbo-p-zero.mem");
    read_ihex("../../../../hex/rv64si-p-csr.hex"); write_memory("../../../../mem/rv64si-p-csr.mem");
    read_ihex("../../../../hex/rv64si-p-dirty.hex"); write_memory("../../../../mem/rv64si-p-dirty.mem");
    read_ihex("../../../../hex/rv64si-p-icache-alias.hex"); write_memory("../../../../mem/rv64si-p-icache-alias.mem");
    read_ihex("../../../../hex/rv64si-p-ma_fetch.hex"); write_memory("../../../../mem/rv64si-p-ma_fetch.mem");
    read_ihex("../../../../hex/rv64si-p-sbreak.hex"); write_memory("../../../../mem/rv64si-p-sbreak.mem");
    read_ihex("../../../../hex/rv64si-p-scall.hex"); write_memory("../../../../mem/rv64si-p-scall.mem");
    read_ihex("../../../../hex/rv64si-p-wfi.hex"); write_memory("../../../../mem/rv64si-p-wfi.mem");
    read_ihex("../../../../hex/rv64ssvnapot-p-napot.hex"); write_memory("../../../../mem/rv64ssvnapot-p-napot.mem");
    read_ihex("../../../../hex/rv64ua-p-amoadd_d.hex"); write_memory("../../../../mem/rv64ua-p-amoadd_d.mem");
    read_ihex("../../../../hex/rv64ua-p-amoadd_w.hex"); write_memory("../../../../mem/rv64ua-p-amoadd_w.mem");
    read_ihex("../../../../hex/rv64ua-p-amoand_d.hex"); write_memory("../../../../mem/rv64ua-p-amoand_d.mem");
    read_ihex("../../../../hex/rv64ua-p-amoand_w.hex"); write_memory("../../../../mem/rv64ua-p-amoand_w.mem");
    read_ihex("../../../../hex/rv64ua-p-amomax_d.hex"); write_memory("../../../../mem/rv64ua-p-amomax_d.mem");
    read_ihex("../../../../hex/rv64ua-p-amomaxu_d.hex"); write_memory("../../../../mem/rv64ua-p-amomaxu_d.mem");
    read_ihex("../../../../hex/rv64ua-p-amomaxu_w.hex"); write_memory("../../../../mem/rv64ua-p-amomaxu_w.mem");
    read_ihex("../../../../hex/rv64ua-p-amomax_w.hex"); write_memory("../../../../mem/rv64ua-p-amomax_w.mem");
    read_ihex("../../../../hex/rv64ua-p-amomin_d.hex"); write_memory("../../../../mem/rv64ua-p-amomin_d.mem");
    read_ihex("../../../../hex/rv64ua-p-amominu_d.hex"); write_memory("../../../../mem/rv64ua-p-amominu_d.mem");
    read_ihex("../../../../hex/rv64ua-p-amominu_w.hex"); write_memory("../../../../mem/rv64ua-p-amominu_w.mem");
    read_ihex("../../../../hex/rv64ua-p-amomin_w.hex"); write_memory("../../../../mem/rv64ua-p-amomin_w.mem");
    read_ihex("../../../../hex/rv64ua-p-amoor_d.hex"); write_memory("../../../../mem/rv64ua-p-amoor_d.mem");
    read_ihex("../../../../hex/rv64ua-p-amoor_w.hex"); write_memory("../../../../mem/rv64ua-p-amoor_w.mem");
    read_ihex("../../../../hex/rv64ua-p-amoswap_d.hex"); write_memory("../../../../mem/rv64ua-p-amoswap_d.mem");
    read_ihex("../../../../hex/rv64ua-p-amoswap_w.hex"); write_memory("../../../../mem/rv64ua-p-amoswap_w.mem");
    read_ihex("../../../../hex/rv64ua-p-amoxor_d.hex"); write_memory("../../../../mem/rv64ua-p-amoxor_d.mem");
    read_ihex("../../../../hex/rv64ua-p-amoxor_w.hex"); write_memory("../../../../mem/rv64ua-p-amoxor_w.mem");
    read_ihex("../../../../hex/rv64ua-p-lrsc.hex"); write_memory("../../../../mem/rv64ua-p-lrsc.mem");
    read_ihex("../../../../hex/rv64ua-v-amoadd_d.hex"); write_memory("../../../../mem/rv64ua-v-amoadd_d.mem");
    read_ihex("../../../../hex/rv64ua-v-amoadd_w.hex"); write_memory("../../../../mem/rv64ua-v-amoadd_w.mem");
    read_ihex("../../../../hex/rv64ua-v-amoand_d.hex"); write_memory("../../../../mem/rv64ua-v-amoand_d.mem");
    read_ihex("../../../../hex/rv64ua-v-amoand_w.hex"); write_memory("../../../../mem/rv64ua-v-amoand_w.mem");
    read_ihex("../../../../hex/rv64ua-v-amomax_d.hex"); write_memory("../../../../mem/rv64ua-v-amomax_d.mem");
    read_ihex("../../../../hex/rv64ua-v-amomaxu_d.hex"); write_memory("../../../../mem/rv64ua-v-amomaxu_d.mem");
    read_ihex("../../../../hex/rv64ua-v-amomaxu_w.hex"); write_memory("../../../../mem/rv64ua-v-amomaxu_w.mem");
    read_ihex("../../../../hex/rv64ua-v-amomax_w.hex"); write_memory("../../../../mem/rv64ua-v-amomax_w.mem");
    read_ihex("../../../../hex/rv64ua-v-amomin_d.hex"); write_memory("../../../../mem/rv64ua-v-amomin_d.mem");
    read_ihex("../../../../hex/rv64ua-v-amominu_d.hex"); write_memory("../../../../mem/rv64ua-v-amominu_d.mem");
    read_ihex("../../../../hex/rv64ua-v-amominu_w.hex"); write_memory("../../../../mem/rv64ua-v-amominu_w.mem");
    read_ihex("../../../../hex/rv64ua-v-amomin_w.hex"); write_memory("../../../../mem/rv64ua-v-amomin_w.mem");
    read_ihex("../../../../hex/rv64ua-v-amoor_d.hex"); write_memory("../../../../mem/rv64ua-v-amoor_d.mem");
    read_ihex("../../../../hex/rv64ua-v-amoor_w.hex"); write_memory("../../../../mem/rv64ua-v-amoor_w.mem");
    read_ihex("../../../../hex/rv64ua-v-amoswap_d.hex"); write_memory("../../../../mem/rv64ua-v-amoswap_d.mem");
    read_ihex("../../../../hex/rv64ua-v-amoswap_w.hex"); write_memory("../../../../mem/rv64ua-v-amoswap_w.mem");
    read_ihex("../../../../hex/rv64ua-v-amoxor_d.hex"); write_memory("../../../../mem/rv64ua-v-amoxor_d.mem");
    read_ihex("../../../../hex/rv64ua-v-amoxor_w.hex"); write_memory("../../../../mem/rv64ua-v-amoxor_w.mem");
    read_ihex("../../../../hex/rv64ua-v-lrsc.hex"); write_memory("../../../../mem/rv64ua-v-lrsc.mem");
    read_ihex("../../../../hex/rv64uc-p-rvc.hex"); write_memory("../../../../mem/rv64uc-p-rvc.mem");
    read_ihex("../../../../hex/rv64uc-v-rvc.hex"); write_memory("../../../../mem/rv64uc-v-rvc.mem");
    read_ihex("../../../../hex/rv64ud-p-fadd.hex"); write_memory("../../../../mem/rv64ud-p-fadd.mem");
    read_ihex("../../../../hex/rv64ud-p-fclass.hex"); write_memory("../../../../mem/rv64ud-p-fclass.mem");
    read_ihex("../../../../hex/rv64ud-p-fcmp.hex"); write_memory("../../../../mem/rv64ud-p-fcmp.mem");
    read_ihex("../../../../hex/rv64ud-p-fcvt.hex"); write_memory("../../../../mem/rv64ud-p-fcvt.mem");
    read_ihex("../../../../hex/rv64ud-p-fcvt_w.hex"); write_memory("../../../../mem/rv64ud-p-fcvt_w.mem");
    read_ihex("../../../../hex/rv64ud-p-fdiv.hex"); write_memory("../../../../mem/rv64ud-p-fdiv.mem");
    read_ihex("../../../../hex/rv64ud-p-fmadd.hex"); write_memory("../../../../mem/rv64ud-p-fmadd.mem");
    read_ihex("../../../../hex/rv64ud-p-fmin.hex"); write_memory("../../../../mem/rv64ud-p-fmin.mem");
    read_ihex("../../../../hex/rv64ud-p-ldst.hex"); write_memory("../../../../mem/rv64ud-p-ldst.mem");
    read_ihex("../../../../hex/rv64ud-p-move.hex"); write_memory("../../../../mem/rv64ud-p-move.mem");
    read_ihex("../../../../hex/rv64ud-p-recoding.hex"); write_memory("../../../../mem/rv64ud-p-recoding.mem");
    read_ihex("../../../../hex/rv64ud-p-structural.hex"); write_memory("../../../../mem/rv64ud-p-structural.mem");
    read_ihex("../../../../hex/rv64ud-v-fadd.hex"); write_memory("../../../../mem/rv64ud-v-fadd.mem");
    read_ihex("../../../../hex/rv64ud-v-fclass.hex"); write_memory("../../../../mem/rv64ud-v-fclass.mem");
    read_ihex("../../../../hex/rv64ud-v-fcmp.hex"); write_memory("../../../../mem/rv64ud-v-fcmp.mem");
    read_ihex("../../../../hex/rv64ud-v-fcvt.hex"); write_memory("../../../../mem/rv64ud-v-fcvt.mem");
    read_ihex("../../../../hex/rv64ud-v-fcvt_w.hex"); write_memory("../../../../mem/rv64ud-v-fcvt_w.mem");
    read_ihex("../../../../hex/rv64ud-v-fdiv.hex"); write_memory("../../../../mem/rv64ud-v-fdiv.mem");
    read_ihex("../../../../hex/rv64ud-v-fmadd.hex"); write_memory("../../../../mem/rv64ud-v-fmadd.mem");
    read_ihex("../../../../hex/rv64ud-v-fmin.hex"); write_memory("../../../../mem/rv64ud-v-fmin.mem");
    read_ihex("../../../../hex/rv64ud-v-ldst.hex"); write_memory("../../../../mem/rv64ud-v-ldst.mem");
    read_ihex("../../../../hex/rv64ud-v-move.hex"); write_memory("../../../../mem/rv64ud-v-move.mem");
    read_ihex("../../../../hex/rv64ud-v-recoding.hex"); write_memory("../../../../mem/rv64ud-v-recoding.mem");
    read_ihex("../../../../hex/rv64ud-v-structural.hex"); write_memory("../../../../mem/rv64ud-v-structural.mem");
    read_ihex("../../../../hex/rv64uf-p-fadd.hex"); write_memory("../../../../mem/rv64uf-p-fadd.mem");
    read_ihex("../../../../hex/rv64uf-p-fclass.hex"); write_memory("../../../../mem/rv64uf-p-fclass.mem");
    read_ihex("../../../../hex/rv64uf-p-fcmp.hex"); write_memory("../../../../mem/rv64uf-p-fcmp.mem");
    read_ihex("../../../../hex/rv64uf-p-fcvt.hex"); write_memory("../../../../mem/rv64uf-p-fcvt.mem");
    read_ihex("../../../../hex/rv64uf-p-fcvt_w.hex"); write_memory("../../../../mem/rv64uf-p-fcvt_w.mem");
    read_ihex("../../../../hex/rv64uf-p-fdiv.hex"); write_memory("../../../../mem/rv64uf-p-fdiv.mem");
    read_ihex("../../../../hex/rv64uf-p-fmadd.hex"); write_memory("../../../../mem/rv64uf-p-fmadd.mem");
    read_ihex("../../../../hex/rv64uf-p-fmin.hex"); write_memory("../../../../mem/rv64uf-p-fmin.mem");
    read_ihex("../../../../hex/rv64uf-p-ldst.hex"); write_memory("../../../../mem/rv64uf-p-ldst.mem");
    read_ihex("../../../../hex/rv64uf-p-move.hex"); write_memory("../../../../mem/rv64uf-p-move.mem");
    read_ihex("../../../../hex/rv64uf-p-recoding.hex"); write_memory("../../../../mem/rv64uf-p-recoding.mem");
    read_ihex("../../../../hex/rv64uf-v-fadd.hex"); write_memory("../../../../mem/rv64uf-v-fadd.mem");
    read_ihex("../../../../hex/rv64uf-v-fclass.hex"); write_memory("../../../../mem/rv64uf-v-fclass.mem");
    read_ihex("../../../../hex/rv64uf-v-fcmp.hex"); write_memory("../../../../mem/rv64uf-v-fcmp.mem");
    read_ihex("../../../../hex/rv64uf-v-fcvt.hex"); write_memory("../../../../mem/rv64uf-v-fcvt.mem");
    read_ihex("../../../../hex/rv64uf-v-fcvt_w.hex"); write_memory("../../../../mem/rv64uf-v-fcvt_w.mem");
    read_ihex("../../../../hex/rv64uf-v-fdiv.hex"); write_memory("../../../../mem/rv64uf-v-fdiv.mem");
    read_ihex("../../../../hex/rv64uf-v-fmadd.hex"); write_memory("../../../../mem/rv64uf-v-fmadd.mem");
    read_ihex("../../../../hex/rv64uf-v-fmin.hex"); write_memory("../../../../mem/rv64uf-v-fmin.mem");
    read_ihex("../../../../hex/rv64uf-v-ldst.hex"); write_memory("../../../../mem/rv64uf-v-ldst.mem");
    read_ihex("../../../../hex/rv64uf-v-move.hex"); write_memory("../../../../mem/rv64uf-v-move.mem");
    read_ihex("../../../../hex/rv64uf-v-recoding.hex"); write_memory("../../../../mem/rv64uf-v-recoding.mem");
    read_ihex("../../../../hex/rv64ui-p-add.hex"); write_memory("../../../../mem/rv64ui-p-add.mem");
    read_ihex("../../../../hex/rv64ui-p-addi.hex"); write_memory("../../../../mem/rv64ui-p-addi.mem");
    read_ihex("../../../../hex/rv64ui-p-addiw.hex"); write_memory("../../../../mem/rv64ui-p-addiw.mem");
    read_ihex("../../../../hex/rv64ui-p-addw.hex"); write_memory("../../../../mem/rv64ui-p-addw.mem");
    read_ihex("../../../../hex/rv64ui-p-and.hex"); write_memory("../../../../mem/rv64ui-p-and.mem");
    read_ihex("../../../../hex/rv64ui-p-andi.hex"); write_memory("../../../../mem/rv64ui-p-andi.mem");
    read_ihex("../../../../hex/rv64ui-p-auipc.hex"); write_memory("../../../../mem/rv64ui-p-auipc.mem");
    read_ihex("../../../../hex/rv64ui-p-beq.hex"); write_memory("../../../../mem/rv64ui-p-beq.mem");
    read_ihex("../../../../hex/rv64ui-p-bge.hex"); write_memory("../../../../mem/rv64ui-p-bge.mem");
    read_ihex("../../../../hex/rv64ui-p-bgeu.hex"); write_memory("../../../../mem/rv64ui-p-bgeu.mem");
    read_ihex("../../../../hex/rv64ui-p-blt.hex"); write_memory("../../../../mem/rv64ui-p-blt.mem");
    read_ihex("../../../../hex/rv64ui-p-bltu.hex"); write_memory("../../../../mem/rv64ui-p-bltu.mem");
    read_ihex("../../../../hex/rv64ui-p-bne.hex"); write_memory("../../../../mem/rv64ui-p-bne.mem");
    read_ihex("../../../../hex/rv64ui-p-fence_i.hex"); write_memory("../../../../mem/rv64ui-p-fence_i.mem");
    read_ihex("../../../../hex/rv64ui-p-jal.hex"); write_memory("../../../../mem/rv64ui-p-jal.mem");
    read_ihex("../../../../hex/rv64ui-p-jalr.hex"); write_memory("../../../../mem/rv64ui-p-jalr.mem");
    read_ihex("../../../../hex/rv64ui-p-lb.hex"); write_memory("../../../../mem/rv64ui-p-lb.mem");
    read_ihex("../../../../hex/rv64ui-p-lbu.hex"); write_memory("../../../../mem/rv64ui-p-lbu.mem");
    read_ihex("../../../../hex/rv64ui-p-ld.hex"); write_memory("../../../../mem/rv64ui-p-ld.mem");
    read_ihex("../../../../hex/rv64ui-p-lh.hex"); write_memory("../../../../mem/rv64ui-p-lh.mem");
    read_ihex("../../../../hex/rv64ui-p-lhu.hex"); write_memory("../../../../mem/rv64ui-p-lhu.mem");
    read_ihex("../../../../hex/rv64ui-p-lui.hex"); write_memory("../../../../mem/rv64ui-p-lui.mem");
    read_ihex("../../../../hex/rv64ui-p-lw.hex"); write_memory("../../../../mem/rv64ui-p-lw.mem");
    read_ihex("../../../../hex/rv64ui-p-lwu.hex"); write_memory("../../../../mem/rv64ui-p-lwu.mem");
    read_ihex("../../../../hex/rv64ui-p-ma_data.hex"); write_memory("../../../../mem/rv64ui-p-ma_data.mem");
    read_ihex("../../../../hex/rv64ui-p-or.hex"); write_memory("../../../../mem/rv64ui-p-or.mem");
    read_ihex("../../../../hex/rv64ui-p-ori.hex"); write_memory("../../../../mem/rv64ui-p-ori.mem");
    read_ihex("../../../../hex/rv64ui-p-sb.hex"); write_memory("../../../../mem/rv64ui-p-sb.mem");
    read_ihex("../../../../hex/rv64ui-p-sd.hex"); write_memory("../../../../mem/rv64ui-p-sd.mem");
    read_ihex("../../../../hex/rv64ui-p-sh.hex"); write_memory("../../../../mem/rv64ui-p-sh.mem");
    read_ihex("../../../../hex/rv64ui-p-simple.hex"); write_memory("../../../../mem/rv64ui-p-simple.mem");
    read_ihex("../../../../hex/rv64ui-p-sll.hex"); write_memory("../../../../mem/rv64ui-p-sll.mem");
    read_ihex("../../../../hex/rv64ui-p-slli.hex"); write_memory("../../../../mem/rv64ui-p-slli.mem");
    read_ihex("../../../../hex/rv64ui-p-slliw.hex"); write_memory("../../../../mem/rv64ui-p-slliw.mem");
    read_ihex("../../../../hex/rv64ui-p-sllw.hex"); write_memory("../../../../mem/rv64ui-p-sllw.mem");
    read_ihex("../../../../hex/rv64ui-p-slt.hex"); write_memory("../../../../mem/rv64ui-p-slt.mem");
    read_ihex("../../../../hex/rv64ui-p-slti.hex"); write_memory("../../../../mem/rv64ui-p-slti.mem");
    read_ihex("../../../../hex/rv64ui-p-sltiu.hex"); write_memory("../../../../mem/rv64ui-p-sltiu.mem");
    read_ihex("../../../../hex/rv64ui-p-sltu.hex"); write_memory("../../../../mem/rv64ui-p-sltu.mem");
    read_ihex("../../../../hex/rv64ui-p-sra.hex"); write_memory("../../../../mem/rv64ui-p-sra.mem");
    read_ihex("../../../../hex/rv64ui-p-srai.hex"); write_memory("../../../../mem/rv64ui-p-srai.mem");
    read_ihex("../../../../hex/rv64ui-p-sraiw.hex"); write_memory("../../../../mem/rv64ui-p-sraiw.mem");
    read_ihex("../../../../hex/rv64ui-p-sraw.hex"); write_memory("../../../../mem/rv64ui-p-sraw.mem");
    read_ihex("../../../../hex/rv64ui-p-srl.hex"); write_memory("../../../../mem/rv64ui-p-srl.mem");
    read_ihex("../../../../hex/rv64ui-p-srli.hex"); write_memory("../../../../mem/rv64ui-p-srli.mem");
    read_ihex("../../../../hex/rv64ui-p-srliw.hex"); write_memory("../../../../mem/rv64ui-p-srliw.mem");
    read_ihex("../../../../hex/rv64ui-p-srlw.hex"); write_memory("../../../../mem/rv64ui-p-srlw.mem");
    read_ihex("../../../../hex/rv64ui-p-sub.hex"); write_memory("../../../../mem/rv64ui-p-sub.mem");
    read_ihex("../../../../hex/rv64ui-p-subw.hex"); write_memory("../../../../mem/rv64ui-p-subw.mem");
    read_ihex("../../../../hex/rv64ui-p-sw.hex"); write_memory("../../../../mem/rv64ui-p-sw.mem");
    read_ihex("../../../../hex/rv64ui-p-xor.hex"); write_memory("../../../../mem/rv64ui-p-xor.mem");
    read_ihex("../../../../hex/rv64ui-p-xori.hex"); write_memory("../../../../mem/rv64ui-p-xori.mem");
    read_ihex("../../../../hex/rv64ui-v-add.hex"); write_memory("../../../../mem/rv64ui-v-add.mem");
    read_ihex("../../../../hex/rv64ui-v-addi.hex"); write_memory("../../../../mem/rv64ui-v-addi.mem");
    read_ihex("../../../../hex/rv64ui-v-addiw.hex"); write_memory("../../../../mem/rv64ui-v-addiw.mem");
    read_ihex("../../../../hex/rv64ui-v-addw.hex"); write_memory("../../../../mem/rv64ui-v-addw.mem");
    read_ihex("../../../../hex/rv64ui-v-and.hex"); write_memory("../../../../mem/rv64ui-v-and.mem");
    read_ihex("../../../../hex/rv64ui-v-andi.hex"); write_memory("../../../../mem/rv64ui-v-andi.mem");
    read_ihex("../../../../hex/rv64ui-v-auipc.hex"); write_memory("../../../../mem/rv64ui-v-auipc.mem");
    read_ihex("../../../../hex/rv64ui-v-beq.hex"); write_memory("../../../../mem/rv64ui-v-beq.mem");
    read_ihex("../../../../hex/rv64ui-v-bge.hex"); write_memory("../../../../mem/rv64ui-v-bge.mem");
    read_ihex("../../../../hex/rv64ui-v-bgeu.hex"); write_memory("../../../../mem/rv64ui-v-bgeu.mem");
    read_ihex("../../../../hex/rv64ui-v-blt.hex"); write_memory("../../../../mem/rv64ui-v-blt.mem");
    read_ihex("../../../../hex/rv64ui-v-bltu.hex"); write_memory("../../../../mem/rv64ui-v-bltu.mem");
    read_ihex("../../../../hex/rv64ui-v-bne.hex"); write_memory("../../../../mem/rv64ui-v-bne.mem");
    read_ihex("../../../../hex/rv64ui-v-fence_i.hex"); write_memory("../../../../mem/rv64ui-v-fence_i.mem");
    read_ihex("../../../../hex/rv64ui-v-jal.hex"); write_memory("../../../../mem/rv64ui-v-jal.mem");
    read_ihex("../../../../hex/rv64ui-v-jalr.hex"); write_memory("../../../../mem/rv64ui-v-jalr.mem");
    read_ihex("../../../../hex/rv64ui-v-lb.hex"); write_memory("../../../../mem/rv64ui-v-lb.mem");
    read_ihex("../../../../hex/rv64ui-v-lbu.hex"); write_memory("../../../../mem/rv64ui-v-lbu.mem");
    read_ihex("../../../../hex/rv64ui-v-ld.hex"); write_memory("../../../../mem/rv64ui-v-ld.mem");
    read_ihex("../../../../hex/rv64ui-v-lh.hex"); write_memory("../../../../mem/rv64ui-v-lh.mem");
    read_ihex("../../../../hex/rv64ui-v-lhu.hex"); write_memory("../../../../mem/rv64ui-v-lhu.mem");
    read_ihex("../../../../hex/rv64ui-v-lui.hex"); write_memory("../../../../mem/rv64ui-v-lui.mem");
    read_ihex("../../../../hex/rv64ui-v-lw.hex"); write_memory("../../../../mem/rv64ui-v-lw.mem");
    read_ihex("../../../../hex/rv64ui-v-lwu.hex"); write_memory("../../../../mem/rv64ui-v-lwu.mem");
    read_ihex("../../../../hex/rv64ui-v-ma_data.hex"); write_memory("../../../../mem/rv64ui-v-ma_data.mem");
    read_ihex("../../../../hex/rv64ui-v-or.hex"); write_memory("../../../../mem/rv64ui-v-or.mem");
    read_ihex("../../../../hex/rv64ui-v-ori.hex"); write_memory("../../../../mem/rv64ui-v-ori.mem");
    read_ihex("../../../../hex/rv64ui-v-sb.hex"); write_memory("../../../../mem/rv64ui-v-sb.mem");
    read_ihex("../../../../hex/rv64ui-v-sd.hex"); write_memory("../../../../mem/rv64ui-v-sd.mem");
    read_ihex("../../../../hex/rv64ui-v-sh.hex"); write_memory("../../../../mem/rv64ui-v-sh.mem");
    read_ihex("../../../../hex/rv64ui-v-simple.hex"); write_memory("../../../../mem/rv64ui-v-simple.mem");
    read_ihex("../../../../hex/rv64ui-v-sll.hex"); write_memory("../../../../mem/rv64ui-v-sll.mem");
    read_ihex("../../../../hex/rv64ui-v-slli.hex"); write_memory("../../../../mem/rv64ui-v-slli.mem");
    read_ihex("../../../../hex/rv64ui-v-slliw.hex"); write_memory("../../../../mem/rv64ui-v-slliw.mem");
    read_ihex("../../../../hex/rv64ui-v-sllw.hex"); write_memory("../../../../mem/rv64ui-v-sllw.mem");
    read_ihex("../../../../hex/rv64ui-v-slt.hex"); write_memory("../../../../mem/rv64ui-v-slt.mem");
    read_ihex("../../../../hex/rv64ui-v-slti.hex"); write_memory("../../../../mem/rv64ui-v-slti.mem");
    read_ihex("../../../../hex/rv64ui-v-sltiu.hex"); write_memory("../../../../mem/rv64ui-v-sltiu.mem");
    read_ihex("../../../../hex/rv64ui-v-sltu.hex"); write_memory("../../../../mem/rv64ui-v-sltu.mem");
    read_ihex("../../../../hex/rv64ui-v-sra.hex"); write_memory("../../../../mem/rv64ui-v-sra.mem");
    read_ihex("../../../../hex/rv64ui-v-srai.hex"); write_memory("../../../../mem/rv64ui-v-srai.mem");
    read_ihex("../../../../hex/rv64ui-v-sraiw.hex"); write_memory("../../../../mem/rv64ui-v-sraiw.mem");
    read_ihex("../../../../hex/rv64ui-v-sraw.hex"); write_memory("../../../../mem/rv64ui-v-sraw.mem");
    read_ihex("../../../../hex/rv64ui-v-srl.hex"); write_memory("../../../../mem/rv64ui-v-srl.mem");
    read_ihex("../../../../hex/rv64ui-v-srli.hex"); write_memory("../../../../mem/rv64ui-v-srli.mem");
    read_ihex("../../../../hex/rv64ui-v-srliw.hex"); write_memory("../../../../mem/rv64ui-v-srliw.mem");
    read_ihex("../../../../hex/rv64ui-v-srlw.hex"); write_memory("../../../../mem/rv64ui-v-srlw.mem");
    read_ihex("../../../../hex/rv64ui-v-sub.hex"); write_memory("../../../../mem/rv64ui-v-sub.mem");
    read_ihex("../../../../hex/rv64ui-v-subw.hex"); write_memory("../../../../mem/rv64ui-v-subw.mem");
    read_ihex("../../../../hex/rv64ui-v-sw.hex"); write_memory("../../../../mem/rv64ui-v-sw.mem");
    read_ihex("../../../../hex/rv64ui-v-xor.hex"); write_memory("../../../../mem/rv64ui-v-xor.mem");
    read_ihex("../../../../hex/rv64ui-v-xori.hex"); write_memory("../../../../mem/rv64ui-v-xori.mem");
    read_ihex("../../../../hex/rv64um-p-div.hex"); write_memory("../../../../mem/rv64um-p-div.mem");
    read_ihex("../../../../hex/rv64um-p-divu.hex"); write_memory("../../../../mem/rv64um-p-divu.mem");
    read_ihex("../../../../hex/rv64um-p-divuw.hex"); write_memory("../../../../mem/rv64um-p-divuw.mem");
    read_ihex("../../../../hex/rv64um-p-divw.hex"); write_memory("../../../../mem/rv64um-p-divw.mem");
    read_ihex("../../../../hex/rv64um-p-mul.hex"); write_memory("../../../../mem/rv64um-p-mul.mem");
    read_ihex("../../../../hex/rv64um-p-mulh.hex"); write_memory("../../../../mem/rv64um-p-mulh.mem");
    read_ihex("../../../../hex/rv64um-p-mulhsu.hex"); write_memory("../../../../mem/rv64um-p-mulhsu.mem");
    read_ihex("../../../../hex/rv64um-p-mulhu.hex"); write_memory("../../../../mem/rv64um-p-mulhu.mem");
    read_ihex("../../../../hex/rv64um-p-mulw.hex"); write_memory("../../../../mem/rv64um-p-mulw.mem");
    read_ihex("../../../../hex/rv64um-p-rem.hex"); write_memory("../../../../mem/rv64um-p-rem.mem");
    read_ihex("../../../../hex/rv64um-p-remu.hex"); write_memory("../../../../mem/rv64um-p-remu.mem");
    read_ihex("../../../../hex/rv64um-p-remuw.hex"); write_memory("../../../../mem/rv64um-p-remuw.mem");
    read_ihex("../../../../hex/rv64um-p-remw.hex"); write_memory("../../../../mem/rv64um-p-remw.mem");
    read_ihex("../../../../hex/rv64um-v-div.hex"); write_memory("../../../../mem/rv64um-v-div.mem");
    read_ihex("../../../../hex/rv64um-v-divu.hex"); write_memory("../../../../mem/rv64um-v-divu.mem");
    read_ihex("../../../../hex/rv64um-v-divuw.hex"); write_memory("../../../../mem/rv64um-v-divuw.mem");
    read_ihex("../../../../hex/rv64um-v-divw.hex"); write_memory("../../../../mem/rv64um-v-divw.mem");
    read_ihex("../../../../hex/rv64um-v-mul.hex"); write_memory("../../../../mem/rv64um-v-mul.mem");
    read_ihex("../../../../hex/rv64um-v-mulh.hex"); write_memory("../../../../mem/rv64um-v-mulh.mem");
    read_ihex("../../../../hex/rv64um-v-mulhsu.hex"); write_memory("../../../../mem/rv64um-v-mulhsu.mem");
    read_ihex("../../../../hex/rv64um-v-mulhu.hex"); write_memory("../../../../mem/rv64um-v-mulhu.mem");
    read_ihex("../../../../hex/rv64um-v-mulw.hex"); write_memory("../../../../mem/rv64um-v-mulw.mem");
    read_ihex("../../../../hex/rv64um-v-rem.hex"); write_memory("../../../../mem/rv64um-v-rem.mem");
    read_ihex("../../../../hex/rv64um-v-remu.hex"); write_memory("../../../../mem/rv64um-v-remu.mem");
    read_ihex("../../../../hex/rv64um-v-remuw.hex"); write_memory("../../../../mem/rv64um-v-remuw.mem");
    read_ihex("../../../../hex/rv64um-v-remw.hex"); write_memory("../../../../mem/rv64um-v-remw.mem");
    read_ihex("../../../../hex/rv64uzfh-p-fadd.hex"); write_memory("../../../../mem/rv64uzfh-p-fadd.mem");
    read_ihex("../../../../hex/rv64uzfh-p-fclass.hex"); write_memory("../../../../mem/rv64uzfh-p-fclass.mem");
    read_ihex("../../../../hex/rv64uzfh-p-fcmp.hex"); write_memory("../../../../mem/rv64uzfh-p-fcmp.mem");
    read_ihex("../../../../hex/rv64uzfh-p-fcvt.hex"); write_memory("../../../../mem/rv64uzfh-p-fcvt.mem");
    read_ihex("../../../../hex/rv64uzfh-p-fcvt_w.hex"); write_memory("../../../../mem/rv64uzfh-p-fcvt_w.mem");
    read_ihex("../../../../hex/rv64uzfh-p-fdiv.hex"); write_memory("../../../../mem/rv64uzfh-p-fdiv.mem");
    read_ihex("../../../../hex/rv64uzfh-p-fmadd.hex"); write_memory("../../../../mem/rv64uzfh-p-fmadd.mem");
    read_ihex("../../../../hex/rv64uzfh-p-fmin.hex"); write_memory("../../../../mem/rv64uzfh-p-fmin.mem");
    read_ihex("../../../../hex/rv64uzfh-p-ldst.hex"); write_memory("../../../../mem/rv64uzfh-p-ldst.mem");
    read_ihex("../../../../hex/rv64uzfh-p-move.hex"); write_memory("../../../../mem/rv64uzfh-p-move.mem");
    read_ihex("../../../../hex/rv64uzfh-p-recoding.hex"); write_memory("../../../../mem/rv64uzfh-p-recoding.mem");
    read_ihex("../../../../hex/rv64uzfh-v-fadd.hex"); write_memory("../../../../mem/rv64uzfh-v-fadd.mem");
    read_ihex("../../../../hex/rv64uzfh-v-fclass.hex"); write_memory("../../../../mem/rv64uzfh-v-fclass.mem");
    read_ihex("../../../../hex/rv64uzfh-v-fcmp.hex"); write_memory("../../../../mem/rv64uzfh-v-fcmp.mem");
    read_ihex("../../../../hex/rv64uzfh-v-fcvt.hex"); write_memory("../../../../mem/rv64uzfh-v-fcvt.mem");
    read_ihex("../../../../hex/rv64uzfh-v-fcvt_w.hex"); write_memory("../../../../mem/rv64uzfh-v-fcvt_w.mem");
    read_ihex("../../../../hex/rv64uzfh-v-fdiv.hex"); write_memory("../../../../mem/rv64uzfh-v-fdiv.mem");
    read_ihex("../../../../hex/rv64uzfh-v-fmadd.hex"); write_memory("../../../../mem/rv64uzfh-v-fmadd.mem");
    read_ihex("../../../../hex/rv64uzfh-v-fmin.hex"); write_memory("../../../../mem/rv64uzfh-v-fmin.mem");
    read_ihex("../../../../hex/rv64uzfh-v-ldst.hex"); write_memory("../../../../mem/rv64uzfh-v-ldst.mem");
    read_ihex("../../../../hex/rv64uzfh-v-move.hex"); write_memory("../../../../mem/rv64uzfh-v-move.mem");
    read_ihex("../../../../hex/rv64uzfh-v-recoding.hex"); write_memory("../../../../mem/rv64uzfh-v-recoding.hex");
  end

endmodule
