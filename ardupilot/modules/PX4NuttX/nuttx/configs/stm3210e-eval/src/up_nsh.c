/****************************************************************************
 * config/stm3210e_eval/src/up_nsh.c
 * arch/arm/src/board/up_nsh.c
 *
 *   Copyright (C) 2009, 2011 Gregory Nutt. All rights reserved.
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

#include <stdbool.h>
#include <stdio.h>
#include <debug.h>
#include <errno.h>

#ifdef CONFIG_STM32_SPI1
#  include <nuttx/spi.h>
#  include <nuttx/mtd.h>
#endif

#ifdef CONFIG_STM32_SDIO
#  include <nuttx/sdio.h>
#  include <nuttx/mmcsd.h>
#endif

#include "stm32.h"

/****************************************************************************
 * Pre-Processor Definitions
 ****************************************************************************/

/* Configuration ************************************************************/

/* For now, don't build in any SPI1 support -- NSH is not using it */

#undef CONFIG_STM32_SPI1

/* PORT and SLOT number probably depend on the board configuration */

#ifdef CONFIG_ARCH_BOARD_STM3210E_EVAL
#  define NSH_HAVEUSBDEV 1
#  define NSH_HAVEMMCSD  1
#  if defined(CONFIG_NSH_MMCSDSLOTNO) && CONFIG_NSH_MMCSDSLOTNO != 0
#    error "Only one MMC/SD slot"
#    undef CONFIG_NSH_MMCSDSLOTNO
#  endif
#  ifndef CONFIG_NSH_MMCSDSLOTNO
#    define CONFIG_NSH_MMCSDSLOTNO 0
#  endif
#else
   /* Add configuration for new STM32 boards here */
#  error "Unrecognized STM32 board"
#  undef NSH_HAVEUSBDEV
#  undef NSH_HAVEMMCSD
#endif

/* Can't support USB features if USB is not enabled */

#ifndef CONFIG_USBDEV
#  undef NSH_HAVEUSBDEV
#endif

/* Can't support MMC/SD features if mountpoints are disabled or if SDIO support
 * is not enabled.
 */

#if defined(CONFIG_DISABLE_MOUNTPOINT) || !defined(CONFIG_STM32_SDIO)
#  undef NSH_HAVEMMCSD
#endif

#ifndef CONFIG_NSH_MMCSDMINOR
#  define CONFIG_NSH_MMCSDMINOR 0
#endif

/* Debug ********************************************************************/

#ifdef CONFIG_CPP_HAVE_VARARGS
#  ifdef CONFIG_DEBUG
#    define message(...) lowsyslog(__VA_ARGS__)
#  else
#    define message(...) printf(__VA_ARGS__)
#  endif
#else
#  ifdef CONFIG_DEBUG
#    define message lowsyslog
#  else
#    define message printf
#  endif
#endif

/****************************************************************************
 * Public Functions
 ****************************************************************************/

/****************************************************************************
 * Name: nsh_archinitialize
 *
 * Description:
 *   Perform architecture specific initialization
 *
 ****************************************************************************/

int nsh_archinitialize(void)
{
#ifdef CONFIG_STM32_SPI1
  FAR struct spi_dev_s *spi;
  FAR struct mtd_dev_s *mtd;
#endif
#ifdef NSH_HAVEMMCSD
  FAR struct sdio_dev_s *sdio;
  int ret;
#endif

  /* Configure SPI-based devices */

#ifdef CONFIG_STM32_SPI1
  /* Get the SPI port */

  message("nsh_archinitialize: Initializing SPI port 1\n");
  spi = up_spiinitialize(1);
  if (!spi)
    {
      message("nsh_archinitialize: Failed to initialize SPI port 0\n");
      return -ENODEV;
    }
  message("nsh_archinitialize: Successfully initialized SPI port 0\n");

  /* Now bind the SPI interface to the M25P64/128 SPI FLASH driver */

  message("nsh_archinitialize: Bind SPI to the SPI flash driver\n");
  mtd = m25p_initialize(spi);
  if (!mtd)
    {
      message("nsh_archinitialize: Failed to bind SPI port 0 to the SPI FLASH driver\n");
      return -ENODEV;
    }
  message("nsh_archinitialize: Successfully bound SPI port 0 to the SPI FLASH driver\n");
#warning "Now what are we going to do with this SPI FLASH driver?"
#endif

  /* Create the SPI FLASH MTD instance */
  /* The M25Pxx is not a give media to implement a file system..
   * its block sizes are too large
   */

  /* Mount the SDIO-based MMC/SD block driver */

#ifdef NSH_HAVEMMCSD
  /* First, get an instance of the SDIO interface */

  message("nsh_archinitialize: Initializing SDIO slot %d\n",
          CONFIG_NSH_MMCSDSLOTNO);
  sdio = sdio_initialize(CONFIG_NSH_MMCSDSLOTNO);
  if (!sdio)
    {
      message("nsh_archinitialize: Failed to initialize SDIO slot %d\n",
              CONFIG_NSH_MMCSDSLOTNO);
      return -ENODEV;
    }

  /* Now bind the SDIO interface to the MMC/SD driver */

  message("nsh_archinitialize: Bind SDIO to the MMC/SD driver, minor=%d\n",
          CONFIG_NSH_MMCSDMINOR);
  ret = mmcsd_slotinitialize(CONFIG_NSH_MMCSDMINOR, sdio);
  if (ret != OK)
    {
      message("nsh_archinitialize: Failed to bind SDIO to the MMC/SD driver: %d\n", ret);
      return ret;
    }
  message("nsh_archinitialize: Successfully bound SDIO to the MMC/SD driver\n");
  
  /* Then let's guess and say that there is a card in the slot.  I need to check to
   * see if the STM3210E-EVAL board supports a GPIO to detect if there is a card in
   * the slot.
   */

   sdio_mediachange(sdio, true);
#endif
  return OK;
}
