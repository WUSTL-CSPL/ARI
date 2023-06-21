/*****************************************************************************
 * sched/group_create.c
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
 *****************************************************************************/

/*****************************************************************************
 * Included Files
 *****************************************************************************/

#include <nuttx/config.h>

#include <sched.h>
#include <assert.h>
#include <errno.h>
#include <debug.h>

#include <nuttx/kmalloc.h>

#include "group_internal.h"
#include "env_internal.h"

#ifdef HAVE_TASK_GROUP

/*****************************************************************************
 * Pre-processor Definitions
 *****************************************************************************/
/* Is this worth making a configuration option? */

#define GROUP_INITIAL_MEMBERS 4

/*****************************************************************************
 * Private Types
 *****************************************************************************/

/*****************************************************************************
 * Private Data
 *****************************************************************************/
/* This is counter that is used to generate unique task group IDs */

#ifdef HAVE_GROUP_MEMBERS
static gid_t g_gidcounter;
#endif

/*****************************************************************************
 * Public Data
 *****************************************************************************/
/* This is the head of a list of all group members */

#ifdef HAVE_GROUP_MEMBERS
FAR struct task_group_s *g_grouphead;
#endif

/*****************************************************************************
 * Private Functions
 *****************************************************************************/

/*****************************************************************************
 * Name: group_assigngid
 *
 * Description:
 *   Create a unique group ID.
 *
 * Parameters:
 *   tcb - The tcb in need of the task group.
 *
 * Return Value:
 *   None
 *
 * Assumptions:
 *   Called during task creation in a safe context.  No special precautions
 *   are required here.
 *
 *****************************************************************************/

#ifdef HAVE_GROUP_MEMBERS
void group_assigngid(FAR struct task_group_s *group)
{
  irqstate_t flags;
  gid_t gid;

  /* Pre-emption should already be enabled, but lets be paranoid careful */

  sched_lock();

  /* Loop until we create a unique ID */

  for (;;)
    {
      /* Increment the ID counter.  This is global data so be extra paraoid. */

      flags = irqsave();
      gid = ++g_gidcounter;

      /* Check for overflow */

      if (gid <= 0)
        {
          g_gidcounter = 1;
          irqrestore(flags);
        }
      else
        {
          /* Does a task group with this ID already exist? */

          irqrestore(flags);
          if (group_findbygid(gid) == NULL)
            {
              /* Now assign this ID to the group and return */

              group->tg_gid = gid;
              sched_unlock();
              return;
            }
        }
    }
}
#endif /* HAVE_GROUP_MEMBERS */

/*****************************************************************************
 * Public Functions
 *****************************************************************************/

/*****************************************************************************
 * Name: group_allocate
 *
 * Description:
 *   Create and a new task group structure for the specified TCB. This
 *   function is called as part of the task creation sequence.  The structure
 *   allocated and zered, but otherwise uninitialized.  The full creation
 *   of the group of a two step process:  (1) First, this function allocates
 *   group structure early in the task creation sequence in order to provide a
 *   group container, then (2) group_initialize() is called to set up the
 *   group membership.
 *
 * Parameters:
 *   tcb - The tcb in need of the task group.
 *
 * Return Value:
 *   0 (OK) on success; a negated errno value on failure.
 *
 * Assumptions:
 *   Called during task creation in a safe context.  No special precautions
 *   are required here.
 *
 *****************************************************************************/

int group_allocate(FAR struct task_tcb_s *tcb)
{
  FAR struct task_group_s *group;
  int ret;

  DEBUGASSERT(tcb && !tcb->cmn.group);

  /* Allocate the group structure and assign it to the TCB */

  group = (FAR struct task_group_s *)kzalloc(sizeof(struct task_group_s));
  if (!group)
    {
      return -ENOMEM;
    }

#if CONFIG_NFILE_STREAMS > 0 && defined(CONFIG_NUTTX_KERNEL) && \
    defined(CONFIG_MM_KERNEL_HEAP)

  /* In a flat, single-heap build.  The stream list is allocated with the
   * group structure.  But in a kernel build with a kernel allocator, it
   * must be separately allocated using a user-space allocator.
   */

  group->tg_streamlist = (FAR struct streamlist *)
    kuzalloc(sizeof(struct streamlist));

  if (!group->tg_streamlist)
    {
      kfree(group);
      return -ENOMEM;
    }

#endif

  /* Attach the group to the TCB */

  tcb->cmn.group = group;

  /* Assign the group a unique ID.  If g_gidcounter were to wrap before we
   * finish with task creation, that would be a problem.
   */

#ifdef HAVE_GROUP_MEMBERS
  group_assigngid(group);
#endif

  /* Duplicate the parent tasks envionment */

  ret = env_dup(group);
  if (ret < 0)
    {
#if CONFIG_NFILE_STREAMS > 0 && defined(CONFIG_NUTTX_KERNEL) && \
    defined(CONFIG_MM_KERNEL_HEAP)
      kufree(group->tg_streamlist);
#endif
      kfree(group);
      tcb->cmn.group = NULL;
      return ret;
    }

  /* Initialize the pthread join semaphore */

#ifndef CONFIG_DISABLE_PTHREAD
  (void)sem_init(&group->tg_joinsem, 0, 1);
#endif

  return OK;
}

/*****************************************************************************
 * Name: group_initialize
 *
 * Description:
 *   Add the task as the initial member of the group.  The full creation of
 *   the group of a two step process:  (1) First, this group structure is
 *   allocated by group_allocate() early in the task creation sequence, then
 *   (2) this function  is called to set up the initial group membership.
 *
 * Parameters:
 *   tcb - The tcb in need of the task group.
 *
 * Return Value:
 *   0 (OK) on success; a negated errno value on failure.
 *
 * Assumptions:
 *   Called during task creation in a safe context.  No special precautions
 *   are required here.
 *
 *****************************************************************************/

int group_initialize(FAR struct task_tcb_s *tcb)
{
  FAR struct task_group_s *group;
#ifdef HAVE_GROUP_MEMBERS
  irqstate_t flags;
#endif

  DEBUGASSERT(tcb && tcb->cmn.group);
  group = tcb->cmn.group;

#ifdef HAVE_GROUP_MEMBERS
  /* Allocate space to hold GROUP_INITIAL_MEMBERS members of the group */

  group->tg_members = (FAR pid_t *)kmalloc(GROUP_INITIAL_MEMBERS*sizeof(pid_t));
  if (!group->tg_members)
    {
      kfree(group);
      return -ENOMEM;
    }

  /* Assign the PID of this new task as a member of the group. */

  group->tg_members[0] = tcb->cmn.pid;

  /* Initialize the non-zero elements of group structure and assign it to
   * the tcb.
   */

  group->tg_mxmembers  = GROUP_INITIAL_MEMBERS; /* Number of members in allocation */

  /* Add the initialized entry to the list of groups */

  flags = irqsave();
  group->flink = g_grouphead;
  g_grouphead = group;
  irqrestore(flags);

#endif

  /* Save the ID of the main task within the group of threads.  This needed
   * for things like SIGCHILD.  It ID is also saved in the TCB of the main
   * task but is also retained in the group which may persist after the main
   * task has exited.
   */

#if !defined(CONFIG_DISABLE_PTHREAD) && defined(CONFIG_SCHED_HAVE_PARENT)
  group->tg_task = tcb->cmn.pid;
#endif

  /* Mark that there is one member in the group, the main task */

  group->tg_nmembers = 1;
  return OK;
}

#endif /* HAVE_TASK_GROUP */

