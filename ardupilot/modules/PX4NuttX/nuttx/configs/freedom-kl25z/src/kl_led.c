/****************************************************************************
 * configs/freedom-kl25z/src/kl_led.c
 * arch/arm/src/board/kl_led.c
 *
 *   Copyright (C) 2013 Gregory Nutt. All rights reserved.
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
/* The Freedom KL25Z has a single RGB LED driven by the KL25Z as follows:
 *
 *   ------------- --------
 *   RGB LED       KL25Z128
 *   ------------- --------
 *   Red Cathode   PTB18
 *   Green Cathode PTB19
 *   Blue Cathode  PTD1
 *
 * If CONFIG_ARCH_LEDs is defined, then NuttX will control the LED on board the
 * Freedom KL25Z.  The following definitions describe how NuttX controls the LEDs:
 *
 *   SYMBOL                Meaning                 LED state
 *                                                 Initially all LED is OFF
 *   -------------------  -----------------------  --------------------------
 *   LED_STARTED          NuttX has been started   R=OFF G=OFF B=OFF
 *   LED_HEAPALLOCATE     Heap has been allocated  (no change)
 *   LED_IRQSENABLED      Interrupts enabled       (no change)
 *   LED_STACKCREATED     Idle stack created       R=OFF G=OFF B=ON
 *   LED_INIRQ            In an interrupt          (no change)
 *   LED_SIGNAL           In a signal handler      (no change)
 *   LED_ASSERTION        An assertion failed      (no change)
 *   LED_PANIC            The system has crashed   R=FLASHING G=OFF B=OFF
 *   LED_IDLE             K25Z1XX is in sleep mode (Optional, not used)
 */

/****************************************************************************
 * Included Files
 ****************************************************************************/

#include <nuttx/config.h>

#include <stdint.h>
#include <stdbool.h>
#include <debug.h>

#include <arch/board/board.h>

#include "chip.h"
#include "kl_gpio.h"
#include "freedom-kl25z.h"

#ifdef CONFIG_ARCH_LEDS

/****************************************************************************
 * Definitions
 ****************************************************************************/

/* CONFIG_DEBUG_LEDS enables debug output from this file (needs CONFIG_DEBUG
 * with CONFIG_DEBUG_VERBOSE too)
 */

#ifdef CONFIG_DEBUG_LEDS
#  define leddbg  lldbg
#  ifdef CONFIG_DEBUG_VERBOSE
#    define ledvdbg lldbg
#  else
#    define ledvdbg(x...)
#  endif
#else
#  define leddbg(x...)
#  define ledvdbg(x...)
#endif

/* Dump GPIO registers */

#if defined(CONFIG_DEBUG_VERBOSE) && defined(CONFIG_DEBUG_LEDS)
#  define led_dumpgpio(m) kl_dumpgpio(GPIO_LED_B, m)
#else
#  define led_dumpgpio(m)
#endif

/****************************************************************************
 * Private Data
 ****************************************************************************/

/****************************************************************************
 * Private Functions
 ****************************************************************************/

/****************************************************************************
 * Public Functions
 ****************************************************************************/

/****************************************************************************
 * Name: kl_ledinit
 *
 * Description:
 *   Initialize the on-board LED
 *
 ****************************************************************************/

void kl_ledinit(void)
{
  kl_configgpio(GPIO_LED_R);
  kl_configgpio(GPIO_LED_G);
  kl_configgpio(GPIO_LED_B);
}

/****************************************************************************
 * Name: up_ledon
 ****************************************************************************/

void up_ledon(int led)
{
  if (led == LED_STACKCREATED)
    {
      kl_gpiowrite(GPIO_LED_R, true);
      kl_gpiowrite(GPIO_LED_G, true);
      kl_gpiowrite(GPIO_LED_B, false);
    }
  else if (led == LED_PANIC)
    {
      kl_gpiowrite(GPIO_LED_R, false);
      kl_gpiowrite(GPIO_LED_G, true);
      kl_gpiowrite(GPIO_LED_B, true);
    }
}

/****************************************************************************
 * Name: up_ledoff
 ****************************************************************************/

void up_ledoff(int led)
{
  if (led == LED_PANIC)
    {
      kl_gpiowrite(GPIO_LED_R, true);
      kl_gpiowrite(GPIO_LED_G, true);
      kl_gpiowrite(GPIO_LED_B, true);
    }
}

#endif /* CONFIG_ARCH_LEDS */
