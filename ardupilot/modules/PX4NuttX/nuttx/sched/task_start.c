/****************************************************************************
 * sched/task_start.c
 *
 *   Copyright (C) 2007-2010, 2013 Gregory Nutt. All rights reserved.
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

#include <stdlib.h>
#include <sched.h>
#include <debug.h>

#include <nuttx/arch.h>
#include <nuttx/sched.h>

#include "os_internal.h"

/****************************************************************************
 * Pre-processor Definitions
 ****************************************************************************/

/****************************************************************************
 * Private Type Declarations
 ****************************************************************************/

/****************************************************************************
 * Global Variables
 ****************************************************************************/

/****************************************************************************
 * Private Variables
 ****************************************************************************/

/****************************************************************************
 * Private Function Prototypes
 ****************************************************************************/

/****************************************************************************
 * Private Functions
 ****************************************************************************/

/****************************************************************************
 * Public Functions
 ****************************************************************************/

/****************************************************************************
 * Name: task_start
 *
 * Description:
 *   This function is the low level entry point into the main thread of
 *   execution of a task.  It receives initial control when the task is
 *   started and calls main entry point of the newly started task.
 *
 * Inputs:
 *   None
 *
 * Return:
 *   None
 *
 ****************************************************************************/

void task_start(void)
{
  FAR struct task_tcb_s *tcb = (FAR struct task_tcb_s*)g_readytorun.head;
  int exitcode;
  int argc;

  DEBUGASSERT((tcb->cmn.flags & TCB_FLAG_TTYPE_MASK) != TCB_FLAG_TTYPE_PTHREAD);

  /* Execute the start hook if one has been registered */

#ifdef CONFIG_SCHED_STARTHOOK
  if (tcb->starthook)
    {
      tcb->starthook(tcb->starthookarg);
    }
#endif

  /* Count how many non-null arguments we are passing */

  for (argc = 1; argc <= CONFIG_MAX_TASK_ARGS; argc++)
    {
      /* The first non-null argument terminates the list */

      if (!tcb->argv[argc])
        {
          break;
        }
    }

  /* Call the 'main' entry point passing argc and argv.  In the kernel build
   * this has to be handled differently if we are starting a user-space task;
   * we have to switch to user-mode before calling the task.
   */

#ifdef CONFIG_NUTTX_KERNEL
  if ((tcb->cmn.flags & TCB_FLAG_TTYPE_MASK) != TCB_FLAG_TTYPE_KERNEL)
    {
      up_task_start(tcb->cmn.entry.main, argc, tcb->argv);
      exitcode = EXIT_FAILURE; /* Should not get here */
    }
  else
#endif
    {
      exitcode = tcb->cmn.entry.main(argc, tcb->argv);
    }

  /* Call exit() if/when the task returns */

  exit(exitcode);
}
