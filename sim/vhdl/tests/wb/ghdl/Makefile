all: build simulate

build:
	ghdl -a --std=08 ../../../../../rtl/vhdl/pkg/peripheral_wb_pkg.vhd
	ghdl -a --std=08 ../../../../../rtl/vhdl/pkg/peripheral_biu_pkg.vhd
	ghdl -a --std=08 ../../../../../rtl/vhdl/pkg/pu_riscv_pkg.vhd
	ghdl -a --std=08 ../../../../../rtl/vhdl/pkg/vhdl_pkg.vhd
	ghdl -a --std=08 ../../../../../rtl/vhdl/core/cache/riscv_dcache_core.vhd
	ghdl -a --std=08 ../../../../../rtl/vhdl/core/cache/riscv_dext.vhd
	ghdl -a --std=08 ../../../../../rtl/vhdl/core/cache/riscv_icache_core.vhd
	ghdl -a --std=08 ../../../../../rtl/vhdl/core/cache/riscv_noicache_core.vhd
	ghdl -a --std=08 ../../../../../rtl/vhdl/core/decode/riscv_id.vhd
	ghdl -a --std=08 ../../../../../rtl/vhdl/core/decode/riscv_if.vhd
	ghdl -a --std=08 ../../../../../rtl/vhdl/core/execute/riscv_alu.vhd
	ghdl -a --std=08 ../../../../../rtl/vhdl/core/execute/riscv_bu.vhd
	ghdl -a --std=08 ../../../../../rtl/vhdl/core/execute/riscv_div.vhd
	ghdl -a --std=08 ../../../../../rtl/vhdl/core/execute/riscv_execution.vhd
	ghdl -a --std=08 ../../../../../rtl/vhdl/core/execute/riscv_lsu.vhd
	ghdl -a --std=08 ../../../../../rtl/vhdl/core/execute/riscv_mul.vhd
	ghdl -a --std=08 ../../../../../rtl/vhdl/core/memory/riscv_dmem_ctrl.vhd
	ghdl -a --std=08 ../../../../../rtl/vhdl/core/memory/riscv_imem_ctrl.vhd
	ghdl -a --std=08 ../../../../../rtl/vhdl/core/memory/riscv_membuf.vhd
	ghdl -a --std=08 ../../../../../rtl/vhdl/core/memory/riscv_memmisaligned.vhd
	ghdl -a --std=08 ../../../../../rtl/vhdl/core/memory/riscv_mmu.vhd
	ghdl -a --std=08 ../../../../../rtl/vhdl/core/memory/riscv_mux.vhd
	ghdl -a --std=08 ../../../../../rtl/vhdl/core/memory/riscv_pmachk.vhd
	ghdl -a --std=08 ../../../../../rtl/vhdl/core/memory/riscv_pmpchk.vhd
	ghdl -a --std=08 ../../../../../rtl/vhdl/core/riscv_bp.vhd
	ghdl -a --std=08 ../../../../../rtl/vhdl/core/riscv_core.vhd
	ghdl -a --std=08 ../../../../../rtl/vhdl/core/riscv_du.vhd
	ghdl -a --std=08 ../../../../../rtl/vhdl/core/riscv_memory.vhd
	ghdl -a --std=08 ../../../../../rtl/vhdl/core/riscv_rf.vhd
	ghdl -a --std=08 ../../../../../rtl/vhdl/core/riscv_state.vhd
	ghdl -a --std=08 ../../../../../rtl/vhdl/core/riscv_wb.vhd
	ghdl -a --std=08 ../../../../../rtl/vhdl/memory/riscv_ram_1r1w.vhd
	ghdl -a --std=08 ../../../../../rtl/vhdl/memory/riscv_ram_1r1w_generic.vhd
	ghdl -a --std=08 ../../../../../rtl/vhdl/memory/riscv_ram_1rw.vhd
	ghdl -a --std=08 ../../../../../rtl/vhdl/memory/riscv_ram_1rw_generic.vhd
	ghdl -a --std=08 ../../../../../rtl/vhdl/memory/riscv_ram_queue.vhd
	ghdl -a --std=08 ../../../../../rtl/vhdl/pu/wb/riscv_biu2wb.vhd
	ghdl -a --std=08 ../../../../../rtl/vhdl/pu/wb/riscv_pu_wb.vhd
	ghdl -a --std=08 ../../../../../bench/vhdl/tests/wb/riscv_memory_model_wb.vhd
	ghdl -a --std=08 ../../../../../bench/vhdl/tests/wb/riscv_mmio_if_wb.vhd
	ghdl -a --std=08 ../../../../../bench/vhdl/tests/wb/riscv_testbench_wb.vhd
	ghdl -a --std=08 ../../../../../bench/vhdl/tests/riscv_dbg_bfm.vhd
	ghdl -a --std=08 ../../../../../bench/vhdl/tests/riscv_htif.vhd

simulate:
	ghdl -m --std=08 riscv_testbench_wb
	ghdl -r --std=08 riscv_testbench_wb --ieee-asserts=disable-at-0 --disp-tree=inst > riscv_testbench_wb.tree

clean:
	rm -f *.cf *.tree
