/****************************************************************************
 * arch/arm/src/lpc43xx/lpc43_allocateheap.c
 *
 *   Copyright (C) 2012-2013 Gregory Nutt. All rights reserved.
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

#include <sys/types.h>
#include <stdint.h>
#include <assert.h>
#include <debug.h>

#include <nuttx/arch.h>
#include <nuttx/kmalloc.h>
#include <nuttx/userspace.h>

#include <arch/board/board.h>

#include "chip.h"
#include "up_arch.h"
#include "up_internal.h"

#include "lpc43_emacram.h"
#include "lpc43_usbram.h"

/****************************************************************************
 * Private Definitions
 ****************************************************************************/
/* Get customizations for each supported chip.
 *
 * SRAM Resources
 * --------------------- -------- ------- ------- ------- ------- -------
 * Local SRAM            LPC4310  LPC4320 LPC4330 LPC4350 LPC4353 LPC4357
 * --------------------- -------- ------- ------- ------- ------- -------
 * BANK 0 (0x1000 0000)     96Kb    96Kb   128Kb   128Kb    32Kb    32Kb
 * BANK 1 (0x1008 0000)     40Kb    40Kb    72Kb    72Kb    40Kb    40Kb
 * --------------------- -------- ------- ------- ------- ------- -------
 * SUBTOTAL                136Kb   136Kb   200Kb   200Kb    72Kb    72Kb
 * --------------------- -------- ------- ------- ------- ------- -------
 * AHB SRAM              LPC4310  LPC4320 LPC4330 LPC4350 LPC4353 LPC4357
 * --------------------- -------- ------- ------- ------- ------- -------
 * BANK 0 (0x2000 0000)     16Kb    48Kb   48Kb    48Kb     48Kb    48Kb
 * BANK 1 (0x2000 8000)             NOTE 1 NOTE 1  NOTE 1  NOTE 1  NOTE 1
 * BANK 2 (0x2000 c000)     16Kb    16Kb   16Kb    16Kb    16Kb    16Kb
 * --------------------- -------- ------- ------- ------- ------- -------
 * SUBTOTAL                 32Kb    64Kb   64Kb    64Kb     64Kb    64Kb
 * --------------------- -------- ------- ------- ------- ------- -------
 * TOTAL                   168Kb   200Kb  264Kb   264Kb    136Kb   136Kb
 * --------------------- -------- ------- ------- ------- ------- -------
 *
 * --------------------- -------- ------- ------- ------- ------- -------
 * FLASH                 LPC4310  LPC4320 LPC4330 LPC4350 LPC4353 LPC4357
 * --------------------- -------- ------- ------- ------- ------- -------
 * BANK A (0x1a00 0000)                                    256Kb   512Kb
 * BANK B (0x1b00 8000)                                    256Kb   512Kb
 * --------------------- -------- ------- ------- ------- ------- -------
 * TOTAL                   None    None    None    None    512Kb  1024Kb
 * --------------------- -------- ------- ------- ------- ------- -------
 *
 * NOTE 1: The 64Kb of AHB of SRAM on the LPC4350/30/20 span all AHB SRAM
 * banks but are treated as two banks of 48 an 16Kb by the NuttX memory
 * manager.  This gives some symmetry to all of the members of the family.
 */

/* Configuration ************************************************************/

/* Two configurations are supported:
 *
 * Configuration A:
 *   Program memory     = FLASH
 *   Data memory        = Local RAM Bank 0
 *   Additional regions = Local RAM Bank 1 + AHB SRAM (exluding DMA buffers)
 *
 * Configuration B:
 *   Program memory     = Local RAM Bank 0
 *   Data memory        = Local RAM Bank 1
 *   Additional regions = AHB SRAM (exluding DMA buffers)
 *
 * This file supports only memory configuration A.
 *
 * These should be defined in the memory map header file:
 *
 *    LPC43_LOCSRAM_BANK0_BASE   0x10000000
 *    LPC43_LOCSRAM_BANK1_BASE   0x10080000
 *    LPC43_AHBSRAM_BANK0_BASE   0x20000000
 *    LPC43_AHBSRAM_BANK1_BASE   0x20008000
 *    LPC43_AHBSRAM_BANK2_BASE   0x2000c000
 *
 * These should be defined for the specific chip in the chip.h header file.
 * The value will be defined to be zero in size of the bank does not exist.
 * If two banks are contiguous, the combined size will be added to the
 * first bank and the size of the second bank will be defined to be zero.
 *
 *    LPC43_LOCSRAM_BANK0_SIZE
 *    LPC43_LOCSRAM_BANK1_SIZE
 *    LPC43_AHBSRAM_BANK0_SIZE
 *    LPC43_AHBSRAM_BANK1_SIZE
 *    LPC43_AHBSRAM_BANK2_SIZE
 *
 * The config.h file will define only:
 *
 *    CONFIG_DRAM_START = The start of the data RAM region which may be
 *      either local SRAM bank 0 (Configuration A) or 1 (Configuration B).
 *    CONFIG_DRAM_START = The size of the data RAM region.
 *    CONFIG_DRAM_END   = The sum of the above
 */

/* Check for Configuration A. */

#ifndef CONFIG_BOOT_SRAM

/* Configuration A */
/* CONFIG_DRAM_START should be set to the base of AHB SRAM, local 0. */

#  if CONFIG_DRAM_START != LPC43_LOCSRAM_BANK0_BASE
#    error "CONFIG_DRAM_START must be set to the base address of AHB SRAM Bank 0"
#  endif

/* The configured RAM size should be equal to the size of local SRAM Bank 0 */

#  if CONFIG_DRAM_SIZE != LPC43_LOCSRAM_BANK0_SIZE
#    error "CONFIG_DRAM_SIZE must be set to size of AHB SRAM Bank 0"
#  endif

/* Now we can assign all of the memory regions for configuration A */

#  define MM_REGION1_BASE  LPC43_LOCSRAM_BANK0_BASE
#  define MM_REGION1_SIZE  LPC43_LOCSRAM_BANK0_SIZE
#  define MM_REGION2_BASE  LPC43_LOCSRAM_BANK1_BASE
#  define MM_REGION2_SIZE  LPC43_LOCSRAM_BANK1_SIZE
#  define MM_REGION3_BASE  LPC43_AHBSRAM_BANK0_BASE
#  define MM_REGION3_SIZE  LPC43_AHBSRAM_BANK0_SIZE
#else

/* Configuration B */
/* CONFIG_DRAM_START should be set to the base of local SRAM, bank 1. */

#  if CONFIG_DRAM_START != LPC43_LOCSRAM_BANK1_BASE
#    error "CONFIG_DRAM_START must be set to the base address of AHB SRAM Bank 0"
#  endif

/* The configured RAM size should be equal to the size of local SRAM Bank 1 */

#  if CONFIG_DRAM_SIZE != LPC43_LOCSRAM_BANK1_SIZE
#    error "CONFIG_DRAM_SIZE must be set to size of AHB SRAM Bank 0"
#  endif

/* Now we can assign all of the memory regions for configuration B */

#  define MM_REGION1_BASE  LPC43_LOCSRAM_BANK1_BASE
#  define MM_REGION1_SIZE  LPC43_LOCSRAM_BANK1_SIZE
#  define MM_REGION2_BASE  LPC43_AHBSRAM_BANK0_BASE
#  define MM_REGION2_SIZE  LPC43_AHBSRAM_BANK0_SIZE
#  undef  MM_REGION3_BASE
#  undef  MM_REGION3_SIZE
#endif

#define MM_DMAREGION_BASE  LPC43_AHBSRAM_BANK2_BASE
#define MM_DMAREGION_SIZE  LPC43_AHBSRAM_BANK2_SIZE

/* Figure out how much heap we have in the DMA region that is not being
 * used by USB and/or Ethernet (if any).
 */

#warning "Missing Logic"

#define MM_DMAHEAP_BASE MM_DMAREGION_BASE /* For now... use it all */
#define MM_DMAHEAP_SIZE MM_DMAREGION_SIZE

/****************************************************************************
 * Private Data
 ****************************************************************************/

/****************************************************************************
 * Public Data
 ****************************************************************************/

/* _sbss is the start of the BSS region (see the linker script) _ebss is the
 * end of the BSS regsion (see the linker script). The idle task stack starts
 * at the end of BSS and is of size CONFIG_IDLETHREAD_STACKSIZE.  The IDLE
 * thread is the thread that the system boots on and, eventually, becomes the
 * idle, do nothing task that runs only when there is nothing else to run.
 * The heap continues from there until the configured end of memory.
 * g_idle_topstack is the beginning of this heap region (not necessarily aligned).
 */

const uint32_t g_idle_topstack = (uint32_t)&_ebss + CONFIG_IDLETHREAD_STACKSIZE;

/****************************************************************************
 * Private Functions
 ****************************************************************************/

/****************************************************************************
 * Public Functions
 ****************************************************************************/

/****************************************************************************
 * Name: up_allocate_heap
 *
 * Description:
 *   This function will be called to dynamically set aside the heap region.
 *
 *   For the kernel build (CONFIG_NUTTX_KERNEL=y) with both kernel- and
 *   user-space heaps (CONFIG_MM_KERNEL_HEAP=y), this function provides the
 *   size of the unprotected, user-space heap.
 *
 *   If a protected kernel-space heap is provided, the kernel heap must be
 *   allocated (and protected) by an analogous up_allocate_kheap().
 *
 ****************************************************************************/

void up_allocate_heap(FAR void **heap_start, size_t *heap_size)
{
  /* Start with the first SRAM region */

  up_ledon(LED_HEAPALLOCATE);
  *heap_start = (FAR void*)g_idle_topstack;
  *heap_size = CONFIG_DRAM_END - g_idle_topstack;
}

/************************************************************************
 * Name: up_addregion
 *
 * Description:
 *   Memory may be added in non-contiguous chunks.  Additional chunks are
 *   added by calling this function.
 *
 ************************************************************************/

#if CONFIG_MM_REGIONS > 1
void up_addregion(void)
{
#if CONFIG_MM_REGIONS > 1
 /* Add the next SRAM region (which should exist) */
 
 kmm_addregion((FAR void*)MM_REGION2_BASE, MM_REGION2_SIZE);

#ifdef MM_REGION3_BASE
 /* Add the third SRAM region (which will not exist in configuration B) */

#if CONFIG_MM_REGIONS > 2
 /* Add the third SRAM region (which may not exist) */
 
 kmm_addregion((FAR void*)MM_REGION3_BASE, MM_REGION3_SIZE);

#if CONFIG_MM_REGIONS > 3 && defined(MM_DMAHEAP_BASE)
 /* Add the DMA region (which may not be available) */
 
 kmm_addregion((FAR void*)MM_DMAHEAP_BASE, MM_DMAHEAP_SIZE);

#endif /* CONFIG_MM_REGIONS > 3 && defined(MM_DMAHEAP_BASE) */
#endif /* CONFIG_MM_REGIONS > 2 */
#else  /* MM_REGION3_BASE */

#if CONFIG_MM_REGIONS > 2 && defined(MM_DMAHEAP_BASE)
 /* Add the DMA region (which may not be available) */
 
 kmm_addregion((FAR void*)MM_DMAHEAP_BASE, MM_DMAHEAP_SIZE);

#endif /* CONFIG_MM_REGIONS > 3 && defined(MM_DMAHEAP_BASE) */
#endif /* MM_REGION3_BASE */
#endif /* CONFIG_MM_REGIONS > 1 */
}
#endif
