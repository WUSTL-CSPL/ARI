/****************************************************************************
 * sched/task_vfork
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

/****************************************************************************
 * Included Files
 ****************************************************************************/

#include <nuttx/config.h>

#include <sys/wait.h>
#include <stdint.h>
#include <assert.h>
#include <queue.h>
#include <errno.h>
#include <debug.h>

#include <nuttx/sched.h>

#include "os_internal.h"
#include "group_internal.h"

/****************************************************************************
 * Pre-processor Definitions
 ****************************************************************************/
/* vfork() requires architecture-specific support as well as waipid(). */

#if defined(CONFIG_ARCH_HAVE_VFORK) && defined(CONFIG_SCHED_WAITPID)

/****************************************************************************
 * Private Functions
 ****************************************************************************/

/****************************************************************************
 * Public Functions
 ****************************************************************************/

/****************************************************************************
 * Name: task_vforksetup
 *
 * Description:
 *   The vfork() function has the same effect as fork(), except that the
 *   behavior is undefined if the process created by vfork() either modifies
 *   any data other than a variable of type pid_t used to store the return
 *   value from vfork(), or returns from the function in which vfork() was
 *   called, or calls any other function before successfully calling _exit()
 *   or one of the exec family of functions. 
 *
 *   This functin provides one step in the overall vfork() sequence:  It
 *   Allocates and initializes the child task's TCB.  The overall sequence is:
 *
 *   1) User code calls vfork().  vfork() is provided in architecture-specific
 *      code.
 *   2) vfork()and calls task_vforksetup().
 *   3) task_vforksetup() allocates and configures the child task's TCB.  This
 *      consists of:
 *      - Allocation of the child task's TCB.
 *      - Initialization of file descriptors and streams
 *      - Configuration of environment variables
 *      - Setup the intput parameters for the task.
 *      - Initialization of the TCB (including call to up_initial_state()
 *   4) up_vfork() provides any additional operating context. up_vfork must:
 *      - Allocate and initialize the stack
 *      - Initialize special values in any CPU registers that were not
 *        already configured by up_initial_state()
 *   5) up_vfork() then calls task_vforkstart()
 *   6) task_vforkstart() then executes the child thread.
 *
 * Input Paremeters:
 *   retaddr - The return address from vfork() where the child task
 *     will be started.
 *
 * Returned Value:
 *   Upon successful completion, task_vforksetup() returns a pointer to
 *   newly allocated and initalized child task's TCB.  NULL is returned
 *   on any failure and the errno is set appropriately.
 *
 ****************************************************************************/

FAR struct task_tcb_s *task_vforksetup(start_t retaddr)
{
  struct tcb_s *parent = (FAR struct tcb_s *)g_readytorun.head;
  struct task_tcb_s *child;
  uint8_t ttype;
  int priority;
  int ret;

  DEBUGASSERT(retaddr);

  /* Get the type of the fork'ed task (kernel or user) */

  if ((parent->flags & TCB_FLAG_TTYPE_MASK) == TCB_FLAG_TTYPE_KERNEL)
    {
      /* Fork'ed from a kernel thread */

      ttype = TCB_FLAG_TTYPE_KERNEL;
    }
  else
    {
      /* Fork'ed from a user task or pthread */

      ttype = TCB_FLAG_TTYPE_TASK;
    }

  /* Allocate a TCB for the child task. */

  child = (FAR struct task_tcb_s *)kzalloc(sizeof(struct task_tcb_s));
  if (!child)
    {
      sdbg("ERROR: Failed to allocate TCB\n");
      set_errno(ENOMEM);
      return NULL;
    }

  /* Allocate a new task group */

#ifdef HAVE_TASK_GROUP
  ret = group_allocate(child);
  if (ret < 0)
    {
      goto errout_with_tcb;
    }
#endif

  /* Associate file descriptors with the new task */

#if CONFIG_NFILE_DESCRIPTORS > 0 || CONFIG_NSOCKET_DESCRIPTORS > 0
  ret = group_setuptaskfiles(child);
  if (ret < OK)
    {
      goto errout_with_tcb;
    }
#endif

  /* Get the priority of the parent task */

#ifdef CONFIG_PRIORITY_INHERITANCE
  priority = parent->base_priority;  /* "Normal," unboosted priority */
#else
  priority = parent->sched_priority;  /* Current priority */
#endif

  /* Initialize the task control block.  This calls up_initial_state() */

  svdbg("Child priority=%d start=%p\n", priority, retaddr);
  ret = task_schedsetup(child, priority, retaddr, parent->entry.main, ttype);
  if (ret < OK)
    {
      goto errout_with_tcb;
    }

  svdbg("parent=%p, returning child=%p\n", parent, child);
  return child;

errout_with_tcb:
  sched_releasetcb((FAR struct tcb_s *)child, ttype);
  set_errno(-ret);
  return NULL;
}

/****************************************************************************
 * Name: task_vforkstart
 *
 * Description:
 *   The vfork() function has the same effect as fork(), except that the
 *   behavior is undefined if the process created by vfork() either modifies
 *   any data other than a variable of type pid_t used to store the return
 *   value from vfork(), or returns from the function in which vfork() was
 *   called, or calls any other function before successfully calling _exit()
 *   or one of the exec family of functions. 
 *
 *   This functin provides one step in the overall vfork() sequence:  It
 *   starts execution of the previously initialized TCB.  The overall
 *   sequence is:
 *
 *   1) User code calls vfork()
 *   2) Architecture-specific code provides vfork()and calls task_vforksetup().
 *   3) task_vforksetup() allocates and configures the child task's TCB.  This
 *      consists of:
 *      - Allocation of the child task's TCB.
 *      - Initialization of file descriptors and streams
 *      - Configuration of environment variables
 *      - Setup the intput parameters for the task.
 *      - Initialization of the TCB (including call to up_initial_state()
 *   4) vfork() provides any additional operating context. vfork must:
 *      - Allocate and initialize the stack
 *      - Initialize special values in any CPU registers that were not
 *        already configured by up_initial_state()
 *   5) vfork() then calls task_vforkstart()
 *   6) task_vforkstart() then executes the child thread.
 *
 * Input Paremeters:
 *   retaddr - The return address from vfork() where the child task
 *     will be started.
 *
 * Returned Value:
 *   Upon successful completion, vfork() returns 0 to the child process and
 *   returns the process ID of the child process to the parent process.
 *   Otherwise, -1 is returned to the parent, no child process is created,
 *   and errno is set to indicate the error. 
 *
 ****************************************************************************/

pid_t task_vforkstart(FAR struct task_tcb_s *child)
{
#if CONFIG_TASK_NAME_SIZE > 0
  struct tcb_s *parent = (FAR struct tcb_s *)g_readytorun.head;
#endif
  FAR const char *name;
  pid_t pid;
  int rc;
  int ret;

  svdbg("Starting Child TCB=%p, parent=%p\n", child, g_readytorun.head);
  DEBUGASSERT(child);

  /* Setup to pass parameters to the new task */

#if CONFIG_TASK_NAME_SIZE > 0
  name = parent->name;
#else
  name = NULL;
#endif

  (void)task_argsetup(child, name, (FAR char * const *)NULL);

  /* Now we have enough in place that we can join the group */

#ifdef HAVE_TASK_GROUP
  ret = group_initialize(child);
  if (ret < 0)
    {
      task_vforkabort(child, -ret);
      return ERROR;
    }
#endif

  /* Get the assigned pid before we start the task */

  pid = (int)child->cmn.pid;

  /* Activate the task */

  ret = task_activate((FAR struct tcb_s *)child);
  if (ret < OK)
    {
      task_vforkabort(child, -ret);
      return ERROR;
    }

  /* Since the child task has the same priority as the parent task, it is
   * now ready to run, but has not yet ran.  It is a requirement that
   * the parent enivornment be stable while vfork runs; the child thread
   * is still dependent on things in the parent thread... like the pointers
   * into parent thread's stack which will still appear in the child's
   * registers and environment.
   *
   * We do not have SIG_CHILD, so we have to do some silly things here.
   * The simplest way to make sure that the child thread runs to completion
   * is simply to yield here.  Since the child can only do exit() or
   * execv/l(), that should be all that is needed.
   *
   * Hmmm.. this is probably not sufficient.  What if we are running
   * SCHED_RR?  What if the child thread is suspeneded and rescheduled
   * after the parent thread again?
   */

  /* We can also exploit a bug in the execv() implementation:  The PID
   * of the task exec'ed by the child will not be the same as the PID of
   * the child task.  Therefore, waitpid() on the child task's PID will
   * accomplish what we need to do.
   */

  rc = 0;

#ifdef CONFIG_DEBUG
  ret = waitpid(pid, &rc, 0);
  if (ret < 0)
    {
      sdbg("ERROR: waitpid failed: %d\n", errno);
    }
#else
  (void)waitpid(pid, &rc, 0);
#endif

  return pid;
}

/****************************************************************************
 * Name: task_vforkabort
 *
 * Description:
 *   Recover from any errors after task_vforksetup() was called.
 *
 * Returned Value:
 *   None
 *
 ****************************************************************************/

void task_vforkabort(FAR struct task_tcb_s *child, int errcode)
{
  /* The TCB was added to the active task list by task_schedsetup() */

  dq_rem((FAR dq_entry_t*)child, (dq_queue_t*)&g_inactivetasks);

  /* Release the TCB */

  sched_releasetcb((FAR struct tcb_s *)child,
                   child->cmn.flags & TCB_FLAG_TTYPE_MASK);
  set_errno(errcode);
}

#endif /* CONFIG_ARCH_HAVE_VFORK && CONFIG_SCHED_WAITPID */
