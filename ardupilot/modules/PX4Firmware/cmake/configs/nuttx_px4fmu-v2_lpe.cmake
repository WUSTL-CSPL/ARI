include(cmake/configs/nuttx_px4fmu-v2_default.cmake)

list(REMOVE_ITEM config_module_list
	modules/ekf_att_pos_estimator
	)

list(APPEND config_module_list
	modules/local_position_estimator
	)
