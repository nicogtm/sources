optimsoc_inc_dir $OPTIMSOC_RTL
optimsoc_inc_dir $LISNOC_RTL

optimsoc_add_file system_2x2_cccm_dm.v

optimsoc_add_module compute_tile_dm
optimsoc_add_module memory_tile_dm
optimsoc_add_module lisnoc.mesh2x2
