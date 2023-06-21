/****************************************************************************
 * examples/usbstorage/usbmsc_main.c
 *
 *   Copyright (C) 2008-2012 Gregory Nutt. All rights reserved.
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
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <debug.h>

#include <nuttx/usb/usbdev.h>
#include <nuttx/usb/usbdev_trace.h>

#include "usbmsc.h"

/****************************************************************************
 * Definitions
 ****************************************************************************/

#ifdef CONFIG_EXAMPLES_USBMSC_TRACEINIT
#  define TRACE_INIT_BITS       (TRACE_INIT_BIT)
#else
#  define TRACE_INIT_BITS       (0)
#endif

#define TRACE_ERROR_BITS        (TRACE_DEVERROR_BIT|TRACE_CLSERROR_BIT)

#ifdef CONFIG_EXAMPLES_USBMSC_TRACECLASS
#  define TRACE_CLASS_BITS      (TRACE_CLASS_BIT|TRACE_CLASSAPI_BIT|TRACE_CLASSSTATE_BIT)
#else
#  define TRACE_CLASS_BITS      (0)
#endif

#ifdef CONFIG_EXAMPLES_USBMSC_TRACETRANSFERS
#  define TRACE_TRANSFER_BITS   (TRACE_OUTREQQUEUED_BIT|TRACE_INREQQUEUED_BIT|TRACE_READ_BIT|\
                                 TRACE_WRITE_BIT|TRACE_COMPLETE_BIT)
#else
#  define TRACE_TRANSFER_BITS   (0)
#endif

#ifdef CONFIG_EXAMPLES_USBMSC_TRACECONTROLLER
#  define TRACE_CONTROLLER_BITS (TRACE_EP_BIT|TRACE_DEV_BIT)
#else
#  define TRACE_CONTROLLER_BITS (0)
#endif

#ifdef CONFIG_EXAMPLES_USBMSC_TRACEINTERRUPTS
#  define TRACE_INTERRUPT_BITS  (TRACE_INTENTRY_BIT|TRACE_INTDECODE_BIT|TRACE_INTEXIT_BIT)
#else
#  define TRACE_INTERRUPT_BITS  (0)
#endif

#define TRACE_BITSET            (TRACE_INIT_BITS|TRACE_ERROR_BITS|TRACE_CLASS_BITS|\
                                 TRACE_TRANSFER_BITS|TRACE_CONTROLLER_BITS|TRACE_INTERRUPT_BITS)

/****************************************************************************
 * Private Data
 ****************************************************************************/

/* All global variables used by this example are packed into a structure in
 * order to avoid name collisions.
 */

#if defined(CONFIG_NSH_BUILTIN_APPS) || defined(CONFIG_EXAMPLES_USBMSC_DEBUGMM)
struct usbmsc_state_s g_usbmsc;
#endif

/****************************************************************************
 * Private Functions
 ****************************************************************************/

/****************************************************************************
 * Name: show_memory_usage
 ****************************************************************************/

#ifdef CONFIG_EXAMPLES_USBMSC_DEBUGMM
static void show_memory_usage(struct mallinfo *mmbefore,
                              struct mallinfo *mmafter)
{
  int diff;

  message("              total       used       free    largest\n");
  message("Before:%11d%11d%11d%11d\n",
             mmbefore->arena, mmbefore->uordblks, mmbefore->fordblks, mmbefore->mxordblk);
  message("After: %11d%11d%11d%11d\n",
             mmafter->arena, mmafter->uordblks, mmafter->fordblks, mmafter->mxordblk);

  diff = mmbefore->uordblks - mmafter->uordblks;
  if (diff < 0)
    {
      message("Change:%11d allocated\n", -diff);
    }
  else if (diff > 0)
    {
      message("Change:%11d freed\n", diff);
    }
}
#else
# define show_memory_usage(mm1, mm2)
#endif

/****************************************************************************
 * Name: check_test_memory_usage
 ****************************************************************************/

#ifdef CONFIG_EXAMPLES_USBMSC_DEBUGMM
static void check_test_memory_usage(FAR const char *msg)
{
  /* Get the current memory usage */

#ifdef CONFIG_CAN_PASS_STRUCTS
  g_usbmsc.mmcurrent = mallinfo();
#else
  (void)mallinfo(&g_usbmsc.mmcurrent);
#endif

  /* Show the change from the previous time */

  message("\%s:\n", msg);
  show_memory_usage(&g_usbmsc.mmprevious, &g_usbmsc.mmcurrent);

  /* Set up for the next test */

#ifdef CONFIG_CAN_PASS_STRUCTS
  g_usbmsc.mmprevious = g_usbmsc.mmcurrent;
#else
  memcpy(&g_usbmsc.mmprevious, &g_usbmsc.mmcurrent, sizeof(struct mallinfo));
#endif
}
#else
#  define check_test_memory_usage(msg)
#endif

/****************************************************************************
 * Name: check_test_memory_usage
 ****************************************************************************/

#ifdef CONFIG_EXAMPLES_USBMSC_DEBUGMM
static void final_memory_usage(FAR const char *msg)
{
  /* Get the current memory usage */

#ifdef CONFIG_CAN_PASS_STRUCTS
  g_usbmsc.mmcurrent = mallinfo();
#else
  (void)mallinfo(&g_usbmsc.mmcurrent);
#endif

  /* Show the change from the previous time */

  message("\n%s:\n", msg);
  show_memory_usage(&g_usbmsc.mmstart, &g_usbmsc.mmcurrent);
}
#else
#  define final_memory_usage(msg)
#endif

/****************************************************************************
 * Name: usbmsc_enumerate
 ****************************************************************************/

#ifdef CONFIG_USBDEV_TRACE
static int usbmsc_enumerate(struct usbtrace_s *trace, void *arg)
{
  switch (trace->event)
    {
    case TRACE_DEVINIT:
      message("USB controller initialization: %04x\n", trace->value);
      break;

    case TRACE_DEVUNINIT:
      message("USB controller un-initialization: %04x\n", trace->value);
      break;

    case TRACE_DEVREGISTER:
      message("usbdev_register(): %04x\n", trace->value);
      break;

    case TRACE_DEVUNREGISTER:
      message("usbdev_unregister(): %04x\n", trace->value);
      break;

    case TRACE_EPCONFIGURE:
      message("Endpoint configure(): %04x\n", trace->value);
      break;

    case TRACE_EPDISABLE:
      message("Endpoint disable(): %04x\n", trace->value);
      break;

    case TRACE_EPALLOCREQ:
      message("Endpoint allocreq(): %04x\n", trace->value);
      break;

    case TRACE_EPFREEREQ:
      message("Endpoint freereq(): %04x\n", trace->value);
      break;

    case TRACE_EPALLOCBUFFER:
      message("Endpoint allocbuffer(): %04x\n", trace->value);
      break;

    case TRACE_EPFREEBUFFER:
      message("Endpoint freebuffer(): %04x\n", trace->value);
      break;

    case TRACE_EPSUBMIT:
      message("Endpoint submit(): %04x\n", trace->value);
      break;

    case TRACE_EPCANCEL:
      message("Endpoint cancel(): %04x\n", trace->value);
      break;

    case TRACE_EPSTALL:
      message("Endpoint stall(true): %04x\n", trace->value);
      break;

    case TRACE_EPRESUME:
      message("Endpoint stall(false): %04x\n", trace->value);
      break;

    case TRACE_DEVALLOCEP:
      message("Device allocep(): %04x\n", trace->value);
      break;

    case TRACE_DEVFREEEP:
      message("Device freeep(): %04x\n", trace->value);
      break;

    case TRACE_DEVGETFRAME:
      message("Device getframe(): %04x\n", trace->value);
      break;

    case TRACE_DEVWAKEUP:
      message("Device wakeup(): %04x\n", trace->value);
      break;

    case TRACE_DEVSELFPOWERED:
      message("Device selfpowered(): %04x\n", trace->value);
      break;

    case TRACE_DEVPULLUP:
      message("Device pullup(): %04x\n", trace->value);
      break;

    case TRACE_CLASSBIND:
      message("Class bind(): %04x\n", trace->value);
      break;

    case TRACE_CLASSUNBIND:
      message("Class unbind(): %04x\n", trace->value);
      break;

    case TRACE_CLASSDISCONNECT:
      message("Class disconnect(): %04x\n", trace->value);
      break;

    case TRACE_CLASSSETUP:
      message("Class setup(): %04x\n", trace->value);
      break;

    case TRACE_CLASSSUSPEND:
      message("Class suspend(): %04x\n", trace->value);
      break;

    case TRACE_CLASSRESUME:
      message("Class resume(): %04x\n", trace->value);
      break;

    case TRACE_CLASSRDCOMPLETE:
      message("Class RD request complete: %04x\n", trace->value);
      break;

    case TRACE_CLASSWRCOMPLETE:
      message("Class WR request complete: %04x\n", trace->value);
      break;

    default:
      switch (TRACE_ID(trace->event))
        {
        case TRACE_CLASSAPI_ID:        /* Other class driver system API calls */
          message("Class API call %d: %04x\n", TRACE_DATA(trace->event), trace->value);
          break;

        case TRACE_CLASSSTATE_ID:      /* Track class driver state changes */
          message("Class state %d: %04x\n", TRACE_DATA(trace->event), trace->value);
          break;

        case TRACE_INTENTRY_ID:        /* Interrupt handler entry */
          message("Interrrupt %d entry: %04x\n", TRACE_DATA(trace->event), trace->value);
          break;

        case TRACE_INTDECODE_ID:       /* Decoded interrupt trace->event */
          message("Interrrupt decode %d: %04x\n", TRACE_DATA(trace->event), trace->value);
          break;

        case TRACE_INTEXIT_ID:         /* Interrupt handler exit */
          message("Interrrupt %d exit: %04x\n", TRACE_DATA(trace->event), trace->value);
          break;

        case TRACE_OUTREQQUEUED_ID:    /* Request queued for OUT endpoint */
          message("EP%d OUT request queued: %04x\n", TRACE_DATA(trace->event), trace->value);
          break;

        case TRACE_INREQQUEUED_ID:     /* Request queued for IN endpoint */
          message("EP%d IN request queued: %04x\n", TRACE_DATA(trace->event), trace->value);
          break;

        case TRACE_READ_ID:            /* Read (OUT) action */
          message("EP%d OUT read: %04x\n", TRACE_DATA(trace->event), trace->value);
          break;

        case TRACE_WRITE_ID:           /* Write (IN) action */
          message("EP%d IN write: %04x\n", TRACE_DATA(trace->event), trace->value);
          break;

        case TRACE_COMPLETE_ID:        /* Request completed */
          message("EP%d request complete: %04x\n", TRACE_DATA(trace->event), trace->value);
          break;

        case TRACE_DEVERROR_ID:        /* USB controller driver error event */
          message("Controller error: %02x:%04x\n", TRACE_DATA(trace->event), trace->value);
          break;

        case TRACE_CLSERROR_ID:        /* USB class driver error event */
          message("Class error: %02x:%04x\n", TRACE_DATA(trace->event), trace->value);
          break;

        default:
          message("Unrecognized event: %02x:%02x:%04x\n",
                  TRACE_ID(trace->event) >> 8, TRACE_DATA(trace->event), trace->value);
          break;
        }
    }
  return OK;
}
#endif

/****************************************************************************
 * Public Functions
 ****************************************************************************/

/****************************************************************************
 * msconn_main
 *
 * Description:
 *   This is the main program that configures the USB mass storage device
 *   and exports the LUN(s).  If CONFIG_NSH_BUILTIN_APPS is defined
 *   in the NuttX configuration, then this program can be executed by
 *   entering the "msconn" command at the NSH console.
 *
 ****************************************************************************/

int msconn_main(int argc, char *argv[])
{
  FAR void *handle;
  int ret;

  /* If this program is implemented as the NSH 'msconn' command, then we need to
   * do a little error checking to assure that we are not being called re-entrantly.
   */

#ifdef CONFIG_NSH_BUILTIN_APPS

   /* Check if there is a non-NULL USB mass storage device handle (meaning that the
    * USB mass storage device is already configured).
    */

   if (g_usbmsc.mshandle)
     {
       message("msconn_main: ERROR: Already connected\n");
       return 1;
     }
#endif

#ifdef CONFIG_EXAMPLES_USBMSC_DEBUGMM
#  ifdef CONFIG_CAN_PASS_STRUCTS
  g_usbmsc.mmstart    = mallinfo();
  g_usbmsc.mmprevious = g_usbmsc.mmstart;
#  else
  (void)mallinfo(&g_usbmsc.mmstart);
  memcpy(&g_usbmsc.mmprevious, &g_usbmsc.mmstart, sizeof(struct mallinfo));
#  endif
#endif

  /* Initialize USB trace output IDs */

  usbtrace_enable(TRACE_BITSET);
  check_test_memory_usage("After usbtrace_enable()");

  /* Register block drivers (architecture-specific) */

  message("msconn_main: Creating block drivers\n");
  ret = usbmsc_archinitialize();
  if (ret < 0)
    {
      message("msconn_main: usbmsc_archinitialize failed: %d\n", -ret);
      return 2;
    }
  check_test_memory_usage("After usbmsc_archinitialize()");

  /* Then exports the LUN(s) */

  message("msconn_main: Configuring with NLUNS=%d\n", CONFIG_EXAMPLES_USBMSC_NLUNS);
  ret = usbmsc_configure(CONFIG_EXAMPLES_USBMSC_NLUNS, &handle);
  if (ret < 0)
    {
      message("msconn_main: usbmsc_configure failed: %d\n", -ret);
      usbmsc_uninitialize(handle);
      return 3;
    }
  message("msconn_main: handle=%p\n", handle);
  check_test_memory_usage("After usbmsc_configure()");

  message("msconn_main: Bind LUN=0 to %s\n", CONFIG_EXAMPLES_USBMSC_DEVPATH1);
  ret = usbmsc_bindlun(handle, CONFIG_EXAMPLES_USBMSC_DEVPATH1, 0, 0, 0, false);
  if (ret < 0)
    {
      message("msconn_main: usbmsc_bindlun failed for LUN 1 using %s: %d\n",
               CONFIG_EXAMPLES_USBMSC_DEVPATH1, -ret);
      usbmsc_uninitialize(handle);
      return 4;
    }
  check_test_memory_usage("After usbmsc_bindlun()");

#if CONFIG_EXAMPLES_USBMSC_NLUNS > 1

  message("msconn_main: Bind LUN=1 to %s\n", CONFIG_EXAMPLES_USBMSC_DEVPATH2);
  ret = usbmsc_bindlun(handle, CONFIG_EXAMPLES_USBMSC_DEVPATH2, 1, 0, 0, false);
  if (ret < 0)
    {
      message("msconn_main: usbmsc_bindlun failed for LUN 2 using %s: %d\n",
               CONFIG_EXAMPLES_USBMSC_DEVPATH2, -ret);
      usbmsc_uninitialize(handle);
      return 5;
    }
  check_test_memory_usage("After usbmsc_bindlun() #2");

#if CONFIG_EXAMPLES_USBMSC_NLUNS > 2

  message("msconn_main: Bind LUN=2 to %s\n", CONFIG_EXAMPLES_USBMSC_DEVPATH3);
  ret = usbmsc_bindlun(handle, CONFIG_EXAMPLES_USBMSC_DEVPATH3, 2, 0, 0, false);
  if (ret < 0)
    {
      message("msconn_main: usbmsc_bindlun failed for LUN 3 using %s: %d\n",
               CONFIG_EXAMPLES_USBMSC_DEVPATH3, -ret);
      usbmsc_uninitialize(handle);
      return 6;
    }
  check_test_memory_usage("After usbmsc_bindlun() #3");

#endif
#endif

  ret = usbmsc_exportluns(handle);
  if (ret < 0)
    {
      message("msconn_main: usbmsc_exportluns failed: %d\n", -ret);
      usbmsc_uninitialize(handle);
      return 7;
    }
  check_test_memory_usage("After usbmsc_exportluns()");

  /* It this program was configued as an NSH command, then just exit now.
   * Also, if signals are not enabled (and, hence, sleep() is not supported.
   * then we have not real option but to exit now.
   */

#if !defined(CONFIG_NSH_BUILTIN_APPS) && !defined(CONFIG_DISABLE_SIGNALS)

  /* Otherwise, this thread will hang around and monitor the USB storage activity */

  for (;;)
    {
      msgflush();
      sleep(5);

#  ifdef CONFIG_USBDEV_TRACE
      message("\nmsconn_main: USB TRACE DATA:\n");
      ret =  usbtrace_enumerate(usbmsc_enumerate, NULL);
      if (ret < 0)
        {
          message("msconn_main: usbtrace_enumerate failed: %d\n", -ret);
          usbmsc_uninitialize(handle);
          return 8;
        }
      check_test_memory_usage("After usbtrace_enumerate()");
#  else
      message("msconn_main: Still alive\n");
#  endif
    }
#elif defined(CONFIG_NSH_BUILTIN_APPS)

   /* Return the USB mass storage device handle so it can be used by the 'misconn'
    * command.
    */

   message("msconn_main: Connected\n");
   g_usbmsc.mshandle = handle;
   check_test_memory_usage("After MS connection");

#else /* defined(CONFIG_DISABLE_SIGNALS) */

  /* Just exit */
 
   message("msconn_main: Exiting\n");

   /* Dump debug memory usage */
 
   final_memory_usage("Final memory usage");
#endif
   return 0;
}

/****************************************************************************
 * msdis_main
 *
 * Description:
 *   This is a program entry point that will disconnet the USB mass storage
 *   device.  This program is only available if CONFIG_NSH_BUILTIN_APPS
 *   is defined in the NuttX configuration.  In that case, this program can
 *   be executed by entering the "msdis" command at the NSH console.
 *
 ****************************************************************************/

#ifdef CONFIG_NSH_BUILTIN_APPS
int msdis_main(int argc, char *argv[])
{
  /* First check if the USB mass storage device is already connected */

  if (!g_usbmsc.mshandle)
    {
      message("msdis: ERROR: Not connected\n");
      return 1;
    }
   check_test_memory_usage("Since MS connection");

  /* Then disconnect the device and uninitialize the USB mass storage driver */

   usbmsc_uninitialize(g_usbmsc.mshandle);
   g_usbmsc.mshandle = NULL;
   message("msdis: Disconnected\n");
   check_test_memory_usage("After usbmsc_uninitialize()");

   /* Dump debug memory usage */

   final_memory_usage("Final memory usage");
   return 0;
}
#endif
