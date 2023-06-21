/****************************************************************************
 * arch/arm/src/lm/lm_dumpgpio.c
 *
 *   Copyright (C) 2009-2010 Gregory Nutt. All rights reserved.
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
 ****************************************************************************/

/****************************************************************************
 * Included Files
 ****************************************************************************/

#include <nuttx/config.h>

#include <stdint.h>
#include <stdbool.h>
#include <debug.h>

#include <nuttx/arch.h>

#include "up_arch.h"

#include "chip.h"
#include "lm_gpio.h"

/****************************************************************************
 * Pre-processor Definitions
 ****************************************************************************/

/****************************************************************************
 * Private Types
 ****************************************************************************/

/* NOTE: this is duplicated in lm_gpio.c */

static const uintptr_t g_gpiobase[LM_NPORTS] =
{
#if LM_NPORTS > 0
    LM_GPIOA_BASE
#endif
#if LM_NPORTS > 1
  , LM_GPIOB_BASE
#endif
#if LM_NPORTS > 2
  , LM_GPIOC_BASE
#endif
#if LM_NPORTS > 3
  , LM_GPIOD_BASE
#endif
#if LM_NPORTS > 4
  , LM_GPIOE_BASE
#endif
#if LM_NPORTS > 5
  , LM_GPIOF_BASE
#endif
#if LM_NPORTS > 6
  , LM_GPIOG_BASE
#endif
#if LM_NPORTS > 7
  , LM_GPIOH_BASE
#endif
#if LM_NPORTS > 8
  , LM_GPIOJ_BASE
#endif
};

static const char g_portchar[LM_NPORTS] =
{
#if LM_NPORTS > 0
    'A'
#endif
#if LM_NPORTS > 1
  , 'B'
#endif
#if LM_NPORTS > 2
  , 'C'
#endif
#if LM_NPORTS > 3
  , 'D'
#endif
#if LM_NPORTS > 4
  , 'E'
#endif
#if LM_NPORTS > 5
  , 'F'
#endif
#if LM_NPORTS > 6
  , 'G'
#endif
#if LM_NPORTS > 7
  , 'H'
#endif
#if LM_NPORTS > 8
  , 'J'
#endif
};

/****************************************************************************
 * Private Functions
 ****************************************************************************/

/****************************************************************************
 * Name: lm_gpiobaseaddress
 *
 * Description:
 *   Given a GPIO enumeration value, return the base address of the
 *   associated GPIO registers.
 *
 ****************************************************************************/

static inline uintptr_t lm_gpiobaseaddress(int port)
{
  return port < LM_NPORTS ? g_gpiobase[port] : 0;
}

/****************************************************************************
 * Name: lm_gpioport
 *
 * Description:
 *   Given a GPIO enumeration value, return the base address of the
 *   associated GPIO registers.
 *
 ****************************************************************************/

static inline uint8_t lm_gpioport(int port)
{
  return port < LM_NPORTS ? g_portchar[port] : '?';
}

/****************************************************************************
 * Global Functions
 ****************************************************************************/

/****************************************************************************
 * Function:  lm_dumpgpio
 *
 * Description:
 *   Dump all GPIO registers associated with the provided base address
 *
 ****************************************************************************/

int lm_dumpgpio(uint32_t pinset, const char *msg)
{
  irqstate_t   flags;
  unsigned int port = (pinset & GPIO_PORT_MASK) >> GPIO_PORT_SHIFT;
  uintptr_t    base;
  uint32_t     rcgc2;
  bool         enabled;

  /* Get the base address associated with the GPIO port */

  base = lm_gpiobaseaddress(port);
  DEBUGASSERT(base != 0);

  /* The following requires exclusive access to the GPIO registers */

  flags   = irqsave();
  rcgc2   = getreg32(LM_SYSCON_RCGC2);
  enabled = ((rcgc2 & SYSCON_RCGC2_GPIO(port)) != 0);

  lldbg("GPIO%c pinset: %08x base: %08x -- %s\n",
        lm_gpioport(port), pinset, base, msg);
  lldbg("  RCGC2: %08x (%s)\n",
        rcgc2, enabled ? "enabled" : "disabled" );

  /* Don't bother with the rest unless the port is enabled */

  if (enabled)
    {
      lldbg("  AFSEL: %02x DEN: %02x DIR: %02x DATA: %02x\n",
            getreg32(base + LM_GPIO_AFSEL_OFFSET), getreg32(base + LM_GPIO_DEN_OFFSET),
            getreg32(base + LM_GPIO_DIR_OFFSET), getreg32(base + LM_GPIO_DATA_OFFSET + 0x3fc));
      lldbg("  IS:    %02x IBE: %02x IEV: %02x IM:  %02x RIS: %08x MIS: %08x\n",
            getreg32(base + LM_GPIO_IEV_OFFSET), getreg32(base + LM_GPIO_IM_OFFSET),
            getreg32(base + LM_GPIO_RIS_OFFSET), getreg32(base + LM_GPIO_MIS_OFFSET));
      lldbg("  2MA:   %02x 4MA: %02x 8MA: %02x ODR: %02x PUR %02x PDR: %02x SLR: %02x\n",
            getreg32(base + LM_GPIO_DR2R_OFFSET), getreg32(base + LM_GPIO_DR4R_OFFSET),
            getreg32(base + LM_GPIO_DR8R_OFFSET), getreg32(base + LM_GPIO_ODR_OFFSET),
            getreg32(base + LM_GPIO_PUR_OFFSET), getreg32(base + LM_GPIO_PDR_OFFSET),
            getreg32(base + LM_GPIO_SLR_OFFSET));
    }
  irqrestore(flags);
  return OK;
}
