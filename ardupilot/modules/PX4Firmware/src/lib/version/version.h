/****************************************************************************
 *
 *   Copyright (c) 2013 PX4 Development Team. All rights reserved.
 *   Author: Anton Babushkin <anton.babushkin@me.com>
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 * 3. Neither the name PX4 nor the names of its contributors may be
 *    used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
 * AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
 * ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *
 ****************************************************************************/

/**
 * @file version.h
 *
 * Tools for system version detection.
 *
 * @author Anton Babushkin <anton.babushkin@me.com>
 */

#ifndef VERSION_H_
#define VERSION_H_

#ifdef CONFIG_ARCH_BOARD_PX4FMU_V1
#define	HW_ARCH "PX4FMU_V1"
#endif

#ifdef CONFIG_ARCH_BOARD_PX4FMU_V2
#define	HW_ARCH "PX4FMU_V2"
#endif

#ifdef CONFIG_ARCH_BOARD_PX4FMU_V4
#define	HW_ARCH "PX4FMU_V4"
#endif

#ifdef CONFIG_ARCH_BOARD_PX4FMU_V4PRO
#define	HW_ARCH "PX4FMU_V4PRO"
#endif

#ifdef CONFIG_ARCH_BOARD_AEROCORE
#define	HW_ARCH "AEROCORE"
#endif

#ifdef CONFIG_ARCH_BOARD_MINDPX_V2
#define HW_ARCH "MINDPX_V2"
#endif

#ifdef CONFIG_ARCH_BOARD_PX4_STM32F4DISCOVERY
#define HW_ARCH "PX4_STM32F4DISCOVERY"
#endif

#ifdef CONFIG_ARCH_BOARD_SITL
#define	HW_ARCH "LINUXTEST"
#endif

#ifdef CONFIG_ARCH_BOARD_EAGLE
#define	HW_ARCH "LINUXTEST"
#endif

#ifdef CONFIG_ARCH_BOARD_RPI2
#define	HW_ARCH "LINUXTEST"
#endif

#ifdef CONFIG_ARCH_BOARD_VRBRAIN_V51
#define HW_ARCH "VRBRAIN_V51"
#endif

#ifdef CONFIG_ARCH_BOARD_VRBRAIN_V52
#define HW_ARCH "VRBRAIN_V52"
#endif

#ifdef CONFIG_ARCH_BOARD_VRBRAIN_V52E
#define HW_ARCH "VRBRAIN_V52E"
#endif

#ifdef CONFIG_ARCH_BOARD_VRBRAIN_V54
#define HW_ARCH "VRBRAIN_V54"
#endif

#ifdef CONFIG_ARCH_BOARD_VRUBRAIN_V51
#define HW_ARCH "VRUBRAIN_V51"
#endif

#ifdef CONFIG_ARCH_BOARD_VRUBRAIN_V52
#define HW_ARCH "VRUBRAIN_V52"
#endif

#ifdef CONFIG_ARCH_BOARD_VRCORE_V10
#define HW_ARCH "VRCORE_V10"
#endif

#ifdef CONFIG_ARCH_BOARD_AEROFC_V1
#define HW_ARCH "AEROFC_V1"
#endif

#endif /* VERSION_H_ */
