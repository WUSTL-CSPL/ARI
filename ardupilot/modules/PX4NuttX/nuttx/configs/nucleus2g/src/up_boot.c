/************************************************************************************
 * configs/nucleus2g/src/up_boot.c
 * arch/arm/src/board/up_boot.c
 *
 *   Copyright (C) 2010, 2012 Gregory Nutt. All rights reserved.
 *   Author: Gregory Nutt <gnutt@nuttx.org>
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
 * 3. Neither the name NuttX nor the names of its contributors may be
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
 ************************************************************************************/

/************************************************************************************
 * Included Files
 ************************************************************************************/

#include <nuttx/config.h>

#include <debug.h>

#include <arch/board/board.h>

#include "up_arch.h"
#include "up_internal.h"

#include "lpc17_ssp.h"
#include "lpc17_gpio.h"

#include "nucleus2g_internal.h"

/************************************************************************************
 * Definitions
 ************************************************************************************/

/************************************************************************************
 * Private Functions
 ************************************************************************************/

/************************************************************************************
 * Public Functions
 ************************************************************************************/

/************************************************************************************
 * Name: lpc17_boardinitialize
 *
 * Description:
 *   All LPC17xx architectures must provide the following entry point.  This entry point
 *   is called early in the initialization -- after all memory has been configured
 *   and mapped but before any devices have been initialized.
 *
 ************************************************************************************/

void lpc17_boardinitialize(void)
{
  /* Enable +5V needed for CAN */

#if defined(CONFIG_LPC17_CAN1) || defined(CONFIG_LPC17_CAN2)
  lpc17_configgpio(NUCLEUS2G_5V_ENABLE);
#else
  lpc17_configgpio(NUCLEUS2G_5V_DISABLE);
#endif

  /* If UART0 is used, enabled the MAX232 driver */

#ifdef CONFIG_LPC17_UART0
  lpc17_configgpio(NUCLEUS2G_232_ENABLE);
#else
  lpc17_configgpio(NUCLEUS2G_232_POWERSAVE);
#endif

  /* Configure SSP chip selects if 1) at least one SSP is enabled, and 2) the weak
   * function nucleus2g_sspinitialize() has been brought into the link.
   */

#if defined(CONFIG_LPC17_SSP0) || defined(CONFIG_LPC17_SSP1)
  if (nucleus2g_sspinitialize)
    {
      nucleus2g_sspinitialize();
    }
#endif

  /* Configure on-board LEDs if LED support has been selected. */

#ifdef CONFIG_ARCH_LEDS
  up_ledinit();
#endif

  /* Configure the relay outptus for use on the BMS master board */

#ifdef CONFIG_ARCH_BOARD_NUCLEUS2G_BMS
  up_relayinit();
#endif
}
