#
# Makefile for the px4fmu_default configuration
#

#
# Use the configuration's ROMFS.
#
ROMFS_ROOT	 = $(PX4_BASE)/ROMFS/px4fmu_test
ROMFS_OPTIONAL_FILES = $(PX4_BASE)/Images/px4io-v2_default.bin

#
# Board support modules
#
MODULES		+= drivers/device
MODULES		+= drivers/stm32
MODULES		+= drivers/stm32/adc
MODULES		+= drivers/stm32/tone_alarm
MODULES		+= drivers/led
MODULES		+= drivers/boards/px4fmu-v2
MODULES		+= drivers/px4io
MODULES		+= drivers/rgbled
MODULES		+= drivers/mpu6000
MODULES		+= drivers/lsm303d
MODULES		+= drivers/l3gd20
MODULES		+= drivers/hmc5883
MODULES		+= drivers/ms5611
MODULES		+= drivers/pca8574
MODULES		+= drivers/roboclaw
MODULES		+= drivers/airspeed
MODULES		+= drivers/ets_airspeed
MODULES		+= drivers/meas_airspeed
MODULES		+= systemcmds/perf
MODULES		+= systemcmds/reboot
MODULES		+= systemcmds/tests
MODULES		+= systemcmds/nshterm
MODULES		+= systemcmds/mtd
MODULES		+= systemcmds/ver
MODULES		+= systemcmds/top
MODULES		+= modules/sensors

#
# System commands
#
MODULES		+= systemcmds/bl_update
MODULES		+= systemcmds/mixer
MODULES		+= systemcmds/param
MODULES		+= systemcmds/perf
MODULES		+= systemcmds/pwm
MODULES		+= systemcmds/esc_calib
MODULES		+= systemcmds/reboot
MODULES		+= systemcmds/top
MODULES		+= systemcmds/config
MODULES		+= systemcmds/nshterm
MODULES		+= systemcmds/mtd
MODULES		+= systemcmds/dumpfile
MODULES		+= systemcmds/ver

#
# Example modules
#
MODULES		+= examples/matlab_csv_serial
MODULES		+= examples/subscriber
MODULES		+= examples/publisher

#
# Library modules
#
MODULES		+= modules/systemlib
MODULES		+= modules/systemlib/mixer
MODULES		+= modules/uORB
LIBRARIES	+= lib/mathlib/CMSIS
MODULES		+= lib/mathlib
MODULES		+= lib/mathlib/math/filter
MODULES		+= lib/conversion
MODULES		+= platforms/nuttx

#
# Example modules to test-build
#
MODULES		+= examples/flow_position_estimator
MODULES		+= examples/fixedwing_control
MODULES		+= examples/hwtest
MODULES		+= examples/matlab_csv_serial
MODULES		+= examples/px4_daemon_app
MODULES		+= examples/px4_mavlink_debug
MODULES		+= examples/px4_simple_app

#
# Drivers / modules to test build, but not useful for test environment
#
MODULES		+= modules/attitude_estimator_so3
MODULES		+= drivers/pca8574

#
# Tests
#

MODULES 	+= modules/unit_test
MODULES		+= modules/mavlink/mavlink_tests
MODULES 	+= modules/commander/commander_tests

#
# Transitional support - add commands from the NuttX export archive.
#
# In general, these should move to modules over time.
#
# Each entry here is <command>.<priority>.<stacksize>.<entrypoint> but we use a helper macro
# to make the table a bit more readable.
#
define _B
	$(strip $1).$(or $(strip $2),SCHED_PRIORITY_DEFAULT).$(or $(strip $3),CONFIG_PTHREAD_STACK_DEFAULT).$(strip $4)
endef

#                  command                 priority                   stack  entrypoint
BUILTIN_COMMANDS := \
	$(call _B, sercon,                 ,                          2048,  sercon_main                ) \
	$(call _B, serdis,                 ,                          2048,  serdis_main                )
