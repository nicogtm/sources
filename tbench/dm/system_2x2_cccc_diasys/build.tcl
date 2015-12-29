optimsoc_inc_dir .
optimsoc_inc_dir $OPTIMSOC_RTL

optimsoc_add_file tb_system_2x2_cccc_diasys.sv
optimsoc_add_module system_2x2_cccc_dm
optimsoc_add_module clockmanager.sim
optimsoc_add_module debug_system
optimsoc_add_module fifo_dbg_if

optimsoc_build_define OR1200_BOOT_ADR=32'h100

optimsoc_build
