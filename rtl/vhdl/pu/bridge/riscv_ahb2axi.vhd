-- Converted from riscv_ahb2axi.sv
-- by verilog2vhdl - QueenField

--------------------------------------------------------------------------------
--                                            __ _      _     _               --
--                                           / _(_)    | |   | |              --
--                __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |              --
--               / _` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |              --
--              | (_| | |_| |  __/  __/ | | | | | |  __/ | (_| |              --
--               \__, |\__,_|\___|\___|_| |_|_| |_|\___|_|\__,_|              --
--                  | |                                                       --
--                  |_|                                                       --
--                                                                            --
--                                                                            --
--              MPSoC-RISCV CPU                                               --
--              AMBA3 AHB-Lite Bus Interface                                  --
--              AMBA4 AXI-Lite Bus Interface                                  --
--                                                                            --
--------------------------------------------------------------------------------

-- Copyright (c) 2017-2018 by the author(s)
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
--
--------------------------------------------------------------------------------
-- Author(s):
--   Francisco Javier Reina Campo <pacoreinacampo@queenfield.tech>
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity riscv_ahb2axi is
  port (

    clk   : in std_logic;
    rst_l : in std_logic;

    scan_mode  : in std_logic;
    bus_clk_en : in std_logic;

    --AXI4 instruction
    axi4_aw_id     : out std_logic_vector(AXI_ID_WIDTH-1 downto 0);
    axi4_aw_addr   : out std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
    axi4_aw_len    : out std_logic_vector(7 downto 0);
    axi4_aw_size   : out std_logic_vector(2 downto 0);
    axi4_aw_burst  : out std_logic_vector(1 downto 0);
    axi4_aw_lock   : out std_logic;
    axi4_aw_cache  : out std_logic_vector(3 downto 0);
    axi4_aw_prot   : out std_logic_vector(2 downto 0);
    axi4_aw_qos    : out std_logic_vector(3 downto 0);
    axi4_aw_region : out std_logic_vector(3 downto 0);
    axi4_aw_user   : out std_logic_vector(AXI_USER_WIDTH-1 downto 0);
    axi4_aw_valid  : out std_logic;
    axi4_aw_ready  : in  std_logic;

    axi4_ar_id     : out std_logic_vector(AXI_ID_WIDTH-1 downto 0);
    axi4_ar_addr   : out std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
    axi4_ar_len    : out std_logic_vector(7 downto 0);
    axi4_ar_size   : out std_logic_vector(2 downto 0);
    axi4_ar_burst  : out std_logic_vector(1 downto 0);
    axi4_ar_lock   : out std_logic;
    axi4_ar_cache  : out std_logic_vector(3 downto 0);
    axi4_ar_prot   : out std_logic_vector(2 downto 0);
    axi4_ar_qos    : out std_logic_vector(3 downto 0);
    axi4_ar_region : out std_logic_vector(3 downto 0);
    axi4_ar_user   : out std_logic_vector(AXI_USER_WIDTH-1 downto 0);
    axi4_ar_valid  : out std_logic;
    axi4_ar_ready  : in  std_logic;

    axi4_w_data  : out std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
    axi4_w_strb  : out std_logic_vector(AXI_STRB_WIDTH-1 downto 0);
    axi4_w_last  : out std_logic;
    axi4_w_user  : out std_logic_vector(AXI_USER_WIDTH-1 downto 0);
    axi4_w_valid : out std_logic;
    axi4_w_ready : in  std_logic;

    axi4_r_id    : in  std_logic_vector(AXI_ID_WIDTH-1 downto 0);
    axi4_r_data  : in  std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
    axi4_r_resp  : in  std_logic_vector(1 downto 0);
    axi4_r_last  : in  std_logic;
    axi4_r_user  : in  std_logic_vector(AXI_USER_WIDTH-1 downto 0);
    axi4_r_valid : in  std_logic;
    axi4_r_ready : out std_logic;

    axi4_b_id    : in  std_logic_vector(AXI_ID_WIDTH-1 downto 0);
    axi4_b_resp  : in  std_logic_vector(1 downto 0);
    axi4_b_user  : in  std_logic_vector(AXI_USER_WIDTH-1 downto 0);
    axi4_b_valid : in  std_logic;
    axi4_b_ready : out std_logic;

    -- AHB3 signals
    ahb3_hsel      : in  std_logic;
    ahb3_haddr     : in  std_logic_vector(AHB_ADDR_WIDTH-1 downto 0);
    ahb3_hwdata    : in  std_logic_vector(AHB_DATA_WIDTH-1 downto 0);
    ahb3_hrdata    : out std_logic_vector(AHB_DATA_WIDTH-1 downto 0);
    ahb3_hwrite    : in  std_logic;
    ahb3_hsize     : in  std_logic_vector(2 downto 0);
    ahb3_hburst    : in  std_logic_vector(2 downto 0);
    ahb3_hprot     : in  std_logic_vector(3 downto 0);
    ahb3_htrans    : in  std_logic_vector(1 downto 0);
    ahb3_hmastlock : in  std_logic;
    ahb3_hreadyin  : in  std_logic;
    ahb3_hreadyout : out std_logic
    ahb3_hresp     : out std_logic
    );
  constant AXI_ID_WIDTH   : integer := 10;
  constant AXI_ADDR_WIDTH : integer := 64;
  constant AXI_DATA_WIDTH : integer := 64;
  constant AXI_STRB_WIDTH : integer := 10;
  constant AXI_USER_WIDTH : integer := 10;
  constant AHB_ADDR_WIDTH : integer := 64;
  constant AHB_DATA_WIDTH : integer := 64;
end riscv_ahb2axi;

architecture rtl of riscv_ahb2axi is

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

  constant RV_PIC_BASE_ADDR : std_logic_vector(AHB_ADDR_WIDTH-1 downto 0) := X"00000000f00c0000";
  constant RV_ICCM_SADR     : std_logic_vector(AHB_ADDR_WIDTH-1 downto 0) := X"00000000ee000000";
  constant RV_DCCM_SADR     : std_logic_vector(AHB_ADDR_WIDTH-1 downto 0) := X"00000000f0040000";

  constant RV_ICCM_SIZE : integer := 1024;
  constant RV_DCCM_SIZE : integer := 64;

  constant RV_PIC_SIZE : integer := 64;

  constant RV_ICCM_ENABLE : std_logic := '1';

  constant REGION_BITS : integer := 4;
  constant MASK_BITS   : integer := 10+(null)(RV_PIC_SIZE);

  ------------------------------------------------------------------------------
  -- Variables
  ------------------------------------------------------------------------------

  signal master_wstrb : std_logic_vector(7 downto 0);

  --state_t      buf_state, buf_nxtstate;
  signal buf_state_en : std_logic;

  -- Buffer signals (one entry buffer)
  signal buf_read_error_in : std_logic;
  signal buf_read_error    : std_logic;
  signal buf_rdata         : std_logic_vector(AHB_DATA_WIDTH-1 downto 0);

  signal ahb3_hready    : std_logic;
  signal ahb3_hready_q  : std_logic;
  signal ahb3_htrans_in : std_logic_vector(1 downto 0);
  signal ahb3_htrans_q  : std_logic_vector(1 downto 0);
  signal ahb3_hsize_q   : std_logic_vector(2 downto 0);
  signal ahb3_hwrite_q  : std_logic;
  signal ahb3_haddr_q   : std_logic_vector(AHB_ADDR_WIDTH-1 downto 0);
  signal ahb3_hwdata_q  : std_logic_vector(AHB_DATA_WIDTH-1 downto 0);
  signal ahb3_hresp_q   : std_logic;

  --Miscellaneous signals
  signal ahb3_addr_in_dccm, ahb3_addr_in_iccm, ahb3_addr_in_pic                               : std_logic;
  signal ahb3_addr_in_dccm_region_nc, ahb3_addr_in_iccm_region_nc, ahb3_addr_in_pic_region_nc : std_logic;

  -- signals needed for the read data coming back from the core and to block any further commands as AHB is a blocking bus
  signal buf_rdata_en : std_logic;

  signal ahb3_bus_addr_clk_en, buf_rdata_clk_en : std_logic;
  signal ahb3_clk, ahb3_addr_clk, buf_rdata_clk : std_logic;

  -- Command buffer is the holding station where we convert to AXI and send to core
  signal cmdbuf_wr_en : std_logic;
  signal cmdbuf_rst   : std_logic;
  signal cmdbuf_full  : std_logic;
  signal cmdbuf_vld   : std_logic;
  signal cmdbuf_write : std_logic;
  signal cmdbuf_size  : std_logic_vector(1 downto 0);
  signal cmdbuf_wstrb : std_logic_vector(AXI_STRB_WIDTH-1 downto 0);
  signal cmdbuf_addr  : std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
  signal cmdbuf_wdata : std_logic_vector(AXI_DATA_WIDTH-1 downto 0);

  signal bus_clk : std_logic;

begin
  ------------------------------------------------------------------------------
  -- Module Body
  ------------------------------------------------------------------------------

  -- FSM to control the bus states and when to block the hready and load the command buffer
  processing_0 : process
  begin
    buf_nxtstate      <= IDLE;
    buf_state_en      <= '0';
    buf_rdata_en      <= '0';  -- signal to load the buffer when the core sends read data back
    buf_read_error_in <= '0';  -- signal indicating that an error came back with the read from the core
    cmdbuf_wr_en      <= '0';  -- all clear from the gasket to load the buffer with the command for reads, command/dat for writes
    case ((buf_state)) is
      when IDLE =>
        -- No commands recieved
        buf_nxtstate <= WR
                        when ahb3_hwrite else RD;
        buf_state_en <= ahb3_hready and ahb3_htrans(1) and ahb3_hsel;  -- only transition on a valid hrtans
      when WR =>
        -- Write command recieved last cycle
        buf_nxtstate <= IDLE
                        when (ahb3_hresp or (ahb3_htrans(1 downto 0) = '0') or not ahb3_hsel) else WR
                        when ahb3_hwrite                                                      else RD;
        buf_state_en <= (not cmdbuf_full or ahb3_hresp);
        cmdbuf_wr_en <= not cmdbuf_full and not (ahb3_hresp or ((ahb3_htrans(1 downto 0) = "01") and ahb3_hsel));
      -- Dont send command to the buffer in case of an error or when the master is not ready with the data now.
      when RD =>
        -- Read command recieved last cycle.
        -- If error go to idle, else wait for read data
        buf_nxtstate <= IDLE
                        when ahb3_hresp else PEND;
        buf_state_en <= (not cmdbuf_full or ahb3_hresp);  -- only when command can go, or if its an error
        cmdbuf_wr_en <= not ahb3_hresp and not cmdbuf_full;  -- send command only when no error
      when PEND =>
        -- Read Command has been sent. Waiting on Data.
        -- go back for next command and present data next cycle
        buf_nxtstate      <= IDLE;
        buf_state_en      <= axi4_r_valid and not cmdbuf_write;  -- read data is back
        buf_rdata_en      <= buf_state_en;  -- buffer the read data coming back from core
        buf_read_error_in <= buf_state_en and or axi4_r_resp(1 downto 0);  -- buffer error flag if return has Error ( ECC )
    end case;
  end process;

  processing_1 : process (ahb3_clk, rst_l)
  begin
    if (rst_l = 0) then
      buf_state <= IDLE;
    elsif (rising_edge(ahb3_clk)) then
      buf_state <= buf_nxtstate
                   when buf_state_en else buf_state;
    end if;
  end process;

  master_wstrb(7 downto 0) <= (concatenate(8, ahb3_hsize_q = "000") and ("0000_0001" sll ahb3_haddr_q(2 downto 0))) or (concatenate(8, ahb3_hsize_q = "001") and ("0000_0011" sll ahb3_haddr_q(2 downto 0))) or (concatenate(8, ahb3_hsize_q = "010") and ("0000_1111" sll ahb3_haddr_q(2 downto 0))) or (concatenate(8, ahb3_hsize_q = "011") and ("1111_1111"));

  -- AHB signals
  ahb3_hreadyout <= (ahb3_hresp_q and not ahb3_hready_q)
                    when ahb3_hresp else ((not cmdbuf_full or (buf_state = IDLE)) and not (buf_state = RD or buf_state = PEND) and not buf_read_error);

  ahb3_hready    <= ahb3_hreadyout and ahb3_hreadyin;
  ahb3_htrans_in <= (ahb3_hsel & ahb3_hsel) and ahb3_htrans(1 downto 0);
  ahb3_hrdata    <= buf_rdata(63 downto 0);
  -- request not for ICCM or DCCM
  -- ICCM Rd/Wr OR DCCM Wr not the right size
  -- HW size but unaligned
  -- W size but unaligned
  -- DW size but unaligned
  -- Read ECC error
  -- This is for second cycle of hresp protocol
  ahb3_hresp     <= ((ahb3_htrans_q(1 downto 0) /= '0') and (buf_state /= IDLE) and ((not (ahb3_addr_in_dccm or ahb3_addr_in_iccm)) or ((ahb3_addr_in_iccm or (ahb3_addr_in_dccm and ahb3_hwrite_q)) and not ((ahb3_hsize_q(1 downto 0) = "10") or (ahb3_hsize_q(1 downto 0) = "11"))) or ((ahb3_hsize_q = X"1") and ahb3_haddr_q(0)) or ((ahb3_hsize_q = X"2") and (or ahb3_haddr_q(1 downto 0))) or ((ahb3_hsize_q = X"3") and (or ahb3_haddr_q(2 downto 0))))) or buf_read_error or (ahb3_hresp_q and not ahb3_hready_q);

  -- Buffer signals - needed for the read data and ECC error response
  processing_2 : process (buf_rdata_clk, rst_l)
  begin
    if (rst_l = 0) then
      buf_rdata <= 0;
    elsif (rising_edge(buf_rdata_clk)) then
      buf_rdata <= axi4_r_data;
    end if;
  end process;

  -- buf_read_error will be high only one cycle
  processing_3 : process (ahb3_clk, rst_l)
  begin
    if (rst_l = 0) then
      buf_read_error <= 0;
    elsif (rising_edge(ahb3_clk)) then
      buf_read_error <= buf_read_error_in;
    end if;
  end process;

  -- All the Master signals are captured before presenting it to the command buffer.
  -- We check for Hresp before sending it to the cmd buffer.
  processing_4 : process (ahb3_clk, rst_l)
  begin
    if (rst_l = 0) then
      ahb3_hresp_q <= 0;
    elsif (rising_edge(ahb3_clk)) then
      ahb3_hresp_q <= ahb3_hresp;
    end if;
  end process;

  processing_5 : process (ahb3_clk, rst_l)
  begin
    if (rst_l = 0) then
      ahb3_hready_q <= 0;
    elsif (rising_edge(ahb3_clk)) then
      ahb3_hready_q <= ahb3_hready;
    end if;
  end process;

  processing_6 : process (ahb3_clk, rst_l)
  begin
    if (rst_l = 0) then
      ahb3_htrans_q <= 0;
    elsif (rising_edge(ahb3_clk)) then
      ahb3_htrans_q <= ahb3_htrans_in;
    end if;
  end process;

  processing_7 : process (ahb3_addr_clk, rst_l)
  begin
    if (rst_l = 0) then
      ahb3_hsize_q <= 0;
    elsif (rising_edge(ahb3_addr_clk)) then
      ahb3_hsize_q <= ahb3_hsize;
    end if;
  end process;

  processing_8 : process (ahb3_addr_clk, rst_l)
  begin
    if (rst_l = 0) then
      ahb3_hwrite_q <= 0;
    elsif (rising_edge(ahb3_addr_clk)) then
      ahb3_hwrite_q <= ahb3_hwrite;
    end if;
  end process;

  processing_9 : process (ahb3_addr_clk, rst_l)
  begin
    if (rst_l = 0) then
      ahb3_haddr_q <= 0;
    elsif (rising_edge(ahb3_addr_clk)) then
      ahb3_haddr_q <= ahb3_haddr;
    end if;
  end process;

  -- Clock header logic
  ahb3_bus_addr_clk_en <= bus_clk_en and (ahb3_hready and ahb3_htrans(1));
  buf_rdata_clk_en     <= bus_clk_en and buf_rdata_en;

  processing_10 : process (clk)
  begin
    if (falling_edge(clk)) then
      ahb3_clk      <= (bus_clk_en or scan_mode);            -- clk &
      ahb3_addr_clk <= (ahb3_bus_addr_clk_en or scan_mode);  -- clk &
      buf_rdata_clk <= (buf_rdata_clk_en or scan_mode);      -- clk &
    end if;
  end process;

  -- Address check  dccm
  ahb3_addr_in_dccm_region_nc <= (ahb3_haddr_q(AHB_ADDR_WIDTH-1 downto (AHB_ADDR_WIDTH-REGION_BITS)) = RV_DCCM_SADR(AHB_ADDR_WIDTH-1 downto (AHB_ADDR_WIDTH-REGION_BITS)));

  if (RV_DCCM_SIZE = 48) generate
    ahb3_addr_in_dccm <= (ahb3_haddr_q(AHB_ADDR_WIDTH-1 downto MASK_BITS) = RV_DCCM_SADR(AHB_ADDR_WIDTH-1 downto MASK_BITS)) and not (and ahb3_haddr_q(MASK_BITS-1 downto MASK_BITS-2));
  else generate
    ahb3_addr_in_dccm <= (ahb3_haddr_q(AHB_ADDR_WIDTH-1 downto MASK_BITS) = RV_DCCM_SADR(AHB_ADDR_WIDTH-1 downto MASK_BITS));
  end generate;

  -- Address check  iccm
  RV_ICCM_ENABLE_GENERATING_0 : if (RV_ICCM_ENABLE = '1') generate
    ahb3_addr_in_iccm_region_nc <= (ahb3_haddr_q(AHB_ADDR_WIDTH-1 downto (AHB_ADDR_WIDTH-REGION_BITS)) = RV_ICCM_SADR(AHB_ADDR_WIDTH-1 downto (AHB_ADDR_WIDTH-REGION_BITS)));

    if (RV_ICCM_SIZE = 48) generate
      ahb3_addr_in_iccm <= (ahb3_haddr_q(AHB_ADDR_WIDTH-1 downto MASK_BITS) = RV_ICCM_SADR(AHB_ADDR_WIDTH-1 downto MASK_BITS)) and not (and ahb3_haddr_q(MASK_BITS-1 downto MASK_BITS-2));
    else generate
      ahb3_addr_in_iccm <= (ahb3_haddr_q(AHB_ADDR_WIDTH-1 downto MASK_BITS) = RV_ICCM_SADR(AHB_ADDR_WIDTH-1 downto MASK_BITS));
    end generate;
  elsif (RV_ICCM_ENABLE = '0') generate
    ahb3_addr_in_iccm           <= 0;
    ahb3_addr_in_iccm_region_nc <= 0;
  end generate;

  -- PIC memory address check
  ahb3_addr_in_pic_region_nc <= (ahb3_haddr_q(AHB_ADDR_WIDTH-1 downto (AHB_ADDR_WIDTH-REGION_BITS)) = RV_PIC_BASE_ADDR(AHB_ADDR_WIDTH-1 downto (AHB_ADDR_WIDTH-REGION_BITS)));

  if (RV_PIC_SIZE = 48) generate
    ahb3_addr_in_pic <= (ahb3_haddr_q(AHB_ADDR_WIDTH-1 downto MASK_BITS) = RV_PIC_BASE_ADDR(AHB_ADDR_WIDTH-1 downto MASK_BITS)) and not (and ahb3_haddr_q(MASK_BITS-1 downto MASK_BITS-2));
  else generate
    ahb3_addr_in_pic <= (ahb3_haddr_q(AHB_ADDR_WIDTH-1 downto MASK_BITS) = RV_PIC_BASE_ADDR(AHB_ADDR_WIDTH-1 downto MASK_BITS));
  end generate;

  -- Command Buffer
  -- Holding for the commands to be sent for the AXI. It will be converted to the AXI signals.
  cmdbuf_rst  <= (((axi4_aw_valid and axi4_aw_ready) or (axi4_ar_valid and axi4_ar_ready)) and not cmdbuf_wr_en) or (ahb3_hresp and not cmdbuf_write);
  cmdbuf_full <= (cmdbuf_vld and not ((axi4_aw_valid and axi4_aw_ready) or (axi4_ar_valid and axi4_ar_ready)));

  processing_11 : process (bus_clk, rst_l)
  begin
    if (rst_l = 0) then
      cmdbuf_vld <= 0;
    elsif (rising_edge(bus_clk)) then
      cmdbuf_vld <= not cmdbuf_rst and ('1'
                                        when cmdbuf_wr_en else cmdbuf_vld);
    end if;
  end process;

  processing_12 : process (bus_clk, rst_l)
  begin
    if (rst_l = 0) then
      cmdbuf_write <= 0;
    elsif (rising_edge(bus_clk)) then
      cmdbuf_write <= ahb3_hwrite_q
                      when cmdbuf_wr_en else cmdbuf_write;
    end if;
  end process;

  processing_13 : process (bus_clk, rst_l)
  begin
    if (rst_l = 0) then
      cmdbuf_size <= 0;
    elsif (rising_edge(bus_clk)) then
      cmdbuf_size <= ahb3_hsize_q(1 downto 0)
                     when cmdbuf_wr_en else cmdbuf_size;
    end if;
  end process;

  processing_14 : process (bus_clk, rst_l)
  begin
    if (rst_l = 0) then
      cmdbuf_wstrb <= 0;
    elsif (rising_edge(bus_clk)) then
      cmdbuf_wstrb <= master_wstrb
                      when cmdbuf_wr_en else cmdbuf_wstrb;
    end if;
  end process;

  processing_15 : process (bus_clk, rst_l)
  begin
    if (rst_l = 0) then
      cmdbuf_addr <= 0;
    elsif (rising_edge(bus_clk)) then
      cmdbuf_addr <= ahb3_haddr_q
                     when cmdbuf_wr_en else cmdbuf_addr;
    end if;
  end process;

  processing_16 : process (bus_clk, rst_l)
  begin
    if (rst_l = 0) then
      cmdbuf_wdata <= 0;
    elsif (rising_edge(bus_clk)) then
      cmdbuf_wdata <= ahb3_hwdata
                      when cmdbuf_wr_en else cmdbuf_wdata;
    end if;
  end process;

  -- AXI Write Command Channel
  axi4_aw_id     <= 0;
  axi4_aw_addr   <= cmdbuf_addr;
  axi4_aw_len    <= "0000_0000";
  axi4_aw_size   <= ('0' & cmdbuf_size(1 downto 0));
  axi4_aw_burst  <= "01";
  axi4_aw_lock   <= '0';
  axi4_aw_cache  <= "0000";
  axi4_aw_prot   <= "000";
  axi4_aw_qos    <= "0000";
  axi4_aw_region <= "0000";
  axi4_aw_user   <= 0;
  axi4_aw_valid  <= cmdbuf_vld and cmdbuf_write;

  -- AXI Write Data Channel
  -- This is tied to the command channel as we only write the command buffer once we have the data.
  axi4_w_data  <= cmdbuf_wdata;
  axi4_w_strb  <= cmdbuf_wstrb;
  axi4_w_last  <= '1';
  axi4_w_user  <= '0';
  axi4_w_valid <= cmdbuf_vld and cmdbuf_write;

  -- AXI Write Response
  -- Always ready. AHB does not require a write response.
  axi4_b_ready <= '1';

  -- AXI Read Channels
  axi4_ar_id     <= 0;
  axi4_ar_addr   <= cmdbuf_addr;
  axi4_ar_len    <= "0000_0000";
  axi4_ar_size   <= ('0' & cmdbuf_size);
  axi4_ar_burst  <= "01";
  axi4_ar_lock   <= '0';
  axi4_ar_cache  <= "0000";
  axi4_ar_prot   <= "000";
  axi4_ar_qos    <= "0000";
  axi4_ar_region <= "0000";
  axi4_ar_user   <= 0;
  axi4_ar_valid  <= cmdbuf_vld and not cmdbuf_write;

  -- AXI Read Response Channel
  -- Always ready as AHB reads are blocking and the the buffer is available for the read coming back always.
  axi4_r_ready <= '1';

  -- Clock header logic
  processing_17 : process (clk)
  begin
    if (falling_edge(clk)) then
      bus_clk <= (bus_clk_en or scan_mode);  -- clk &
    end if;
  end process;
end rtl;
