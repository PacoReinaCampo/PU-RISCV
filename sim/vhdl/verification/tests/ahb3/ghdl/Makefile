all: build simulate

build:
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/pkg/peripheral_ahb3_pkg.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/pkg/peripheral_biu_pkg.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/pkg/pu_riscv_pkg.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/pkg/vhdl_pkg.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/cache/pu_riscv_dcache_core.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/cache/pu_riscv_dext.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/cache/pu_riscv_icache_core.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/cache/pu_riscv_noicache_core.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/decode/pu_riscv_id.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/execute/pu_riscv_alu.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/execute/pu_riscv_bu.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/execute/pu_riscv_div.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/execute/pu_riscv_execution.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/execute/pu_riscv_lsu.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/execute/pu_riscv_mul.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/fetch/pu_riscv_if.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/memory/pu_riscv_dmem_ctrl.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/memory/pu_riscv_imem_ctrl.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/memory/pu_riscv_membuf.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/memory/pu_riscv_memmisaligned.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/memory/pu_riscv_mmu.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/memory/pu_riscv_mux.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/memory/pu_riscv_pmachk.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/memory/pu_riscv_pmpchk.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/main/pu_riscv_bp.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/main/pu_riscv_core.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/main/pu_riscv_du.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/main/pu_riscv_memory.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/main/pu_riscv_rf.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/main/pu_riscv_state.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/core/main/pu_riscv_wb.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/memory/pu_riscv_ram_1r1w_generic.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/memory/pu_riscv_ram_1r1w.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/memory/pu_riscv_ram_1rw_generic.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/memory/pu_riscv_ram_1rw.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/memory/pu_riscv_ram_queue.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/pu/ahb3/pu_riscv_biu2ahb3.vhd
	ghdl -a --std=08 ../../../../../../../rtl/vhdl/pu/ahb3/pu_riscv_ahb3.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/pu/ahb3/pu_riscv_memory_model_ahb3.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/pu/ahb3/pu_riscv_mmio_if_ahb3.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/pu/ahb3/pu_riscv_testbench_ahb3.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/bfm/pu_riscv_dbg_bfm.vhd
	ghdl -a --std=08 ../../../../../../../bench/vhdl/tests/bfm/pu_riscv_htif.vhd

simulate:
	ghdl -e --std=08 pu_riscv_testbench_ahb3
	ghdl -r --std=08 pu_riscv_testbench_ahb3 --ieee-asserts=disable-at-0 --vcd=riscv_testbench_ahb3.vcd --wave=system.ghw --stop-time=1ms

clean:
	rm -f *.cf *.vcd *.ghw
