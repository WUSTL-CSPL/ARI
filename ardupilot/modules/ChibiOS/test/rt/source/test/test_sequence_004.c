/*
    ChibiOS - Copyright (C) 2006..2016 Giovanni Di Sirio

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/

#include "hal.h"
#include "ch_test.h"
#include "test_root.h"

/**
 * @file    test_sequence_004.c
 * @brief   Test Sequence 004 code.
 *
 * @page test_sequence_004 [4] Counter and Binary Semaphores
 *
 * File: @ref test_sequence_004.c
 *
 * <h2>Description</h2>
 * This sequence tests the ChibiOS/RT functionalities related to
 * counter semaphores.
 *
 * <h2>Conditions</h2>
 * This sequence is only executed if the following preprocessor condition
 * evaluates to true:
 * - CH_CFG_USE_SEMAPHORES
 * .
 *
 * <h2>Test Cases</h2>
 * - @subpage test_004_001
 * - @subpage test_004_002
 * - @subpage test_004_003
 * - @subpage test_004_004
 * - @subpage test_004_005
 * - @subpage test_004_006
 * .
 */

#if (CH_CFG_USE_SEMAPHORES) || defined(__DOXYGEN__)

/****************************************************************************
 * Shared code.
 ****************************************************************************/

#include "ch.h"

static semaphore_t sem1;

static THD_FUNCTION(thread1, p) {

  chSemWait(&sem1);
  test_emit_token(*(char *)p);
}

static THD_FUNCTION(thread2, p) {

  (void)p;
  chThdSleepMilliseconds(50);
  chSysLock();
  chSemSignalI(&sem1); /* For coverage reasons */
  chSchRescheduleS();
  chSysUnlock();
}

static THD_FUNCTION(thread3, p) {

  (void)p;
  chSemWait(&sem1);
  chSemSignal(&sem1);
}

static THD_FUNCTION(thread4, p) {

  chBSemSignal((binary_semaphore_t *)p);
}

/****************************************************************************
 * Test cases.
 ****************************************************************************/

/**
 * @page test_004_001 [4.1] Semaphore primitives, no state change
 *
 * <h2>Description</h2>
 * Wait, Signal and Reset primitives are tested. The testing thread
 * does not trigger a state change.
 *
 * <h2>Test Steps</h2>
 * - [4.1.1] The function chSemWait() is invoked, after return the
 *   counter and the returned message are tested.
 * - [4.1.2] The function chSemSignal() is invoked, after return the
 *   counter is tested.
 * - [4.1.3] The function chSemReset() is invoked, after return the
 *   counter is tested.
 * .
 */

static void test_004_001_setup(void) {
  chSemObjectInit(&sem1, 1);
}

static void test_004_001_teardown(void) {
  chSemReset(&sem1, 0);
}

static void test_004_001_execute(void) {

  /* [4.1.1] The function chSemWait() is invoked, after return the
     counter and the returned message are tested.*/
  test_set_step(1);
  {
    msg_t msg;

    msg = chSemWait(&sem1);
    test_assert_lock(chSemGetCounterI(&sem1) == 0, "wrong counter value");
    test_assert(MSG_OK == msg, "wrong returned message");
  }

  /* [4.1.2] The function chSemSignal() is invoked, after return the
     counter is tested.*/
  test_set_step(2);
  {
    chSemSignal(&sem1);
    test_assert_lock(chSemGetCounterI(&sem1) == 1, "wrong counter value");
  }

  /* [4.1.3] The function chSemReset() is invoked, after return the
     counter is tested.*/
  test_set_step(3);
  {
    chSemReset(&sem1, 2);
    test_assert_lock(chSemGetCounterI(&sem1) == 2, "wrong counter value");
  }
}

static const testcase_t test_004_001 = {
  "Semaphore primitives, no state change",
  test_004_001_setup,
  test_004_001_teardown,
  test_004_001_execute
};

/**
 * @page test_004_002 [4.2] Semaphore enqueuing test
 *
 * <h2>Description</h2>
 * Five threads with randomized priorities are enqueued to a semaphore
 * then awakened one at time. The test expects that the threads reach
 * their goal in FIFO order or priority order depending on the @p
 * CH_CFG_USE_SEMAPHORES_PRIORITY configuration setting.
 *
 * <h2>Test Steps</h2>
 * - [4.2.1] Five threads are created with mixed priority levels (not
 *   increasing nor decreasing). Threads enqueue on a semaphore
 *   initialized to zero.
 * - [4.2.2] The semaphore is signaled 5 times. The thread activation
 *   sequence is tested.
 * .
 */

static void test_004_002_setup(void) {
  chSemObjectInit(&sem1, 0);
}

static void test_004_002_execute(void) {

  /* [4.2.1] Five threads are created with mixed priority levels (not
     increasing nor decreasing). Threads enqueue on a semaphore
     initialized to zero.*/
  test_set_step(1);
  {
    threads[0] = chThdCreateStatic(wa[0], WA_SIZE, chThdGetPriorityX()+5, thread1, "A");
    threads[1] = chThdCreateStatic(wa[1], WA_SIZE, chThdGetPriorityX()+1, thread1, "B");
    threads[2] = chThdCreateStatic(wa[2], WA_SIZE, chThdGetPriorityX()+3, thread1, "C");
    threads[3] = chThdCreateStatic(wa[3], WA_SIZE, chThdGetPriorityX()+4, thread1, "D");
    threads[4] = chThdCreateStatic(wa[4], WA_SIZE, chThdGetPriorityX()+2, thread1, "E");
  }

  /* [4.2.2] The semaphore is signaled 5 times. The thread activation
     sequence is tested.*/
  test_set_step(2);
  {
    chSemSignal(&sem1);
    chSemSignal(&sem1);
    chSemSignal(&sem1);
    chSemSignal(&sem1);
    chSemSignal(&sem1);
    test_wait_threads();
#if CH_CFG_USE_SEMAPHORES_PRIORITY
    test_assert_sequence("ADCEB", "invalid sequence");
#else
    test_assert_sequence("ABCDE", "invalid sequence");
#endif
  }
}

static const testcase_t test_004_002 = {
  "Semaphore enqueuing test",
  test_004_002_setup,
  NULL,
  test_004_002_execute
};

/**
 * @page test_004_003 [4.3] Semaphore timeout test
 *
 * <h2>Description</h2>
 * The three possible semaphore waiting modes (do not wait, wait with
 * timeout, wait without timeout) are explored. The test expects that
 * the semaphore wait function returns the correct value in each of the
 * above scenario and that the semaphore structure status is correct
 * after each operation.
 *
 * <h2>Test Steps</h2>
 * - [4.3.1] Testing special case TIME_IMMEDIATE.
 * - [4.3.2] Testing non-timeout condition.
 * - [4.3.3] Testing timeout condition.
 * .
 */

static void test_004_003_setup(void) {
  chSemObjectInit(&sem1, 0);
}

static void test_004_003_execute(void) {
  unsigned i;
  systime_t target_time;
  msg_t msg;

  /* [4.3.1] Testing special case TIME_IMMEDIATE.*/
  test_set_step(1);
  {
    msg = chSemWaitTimeout(&sem1, TIME_IMMEDIATE);
    test_assert(msg == MSG_TIMEOUT, "wrong wake-up message");
    test_assert(queue_isempty(&sem1.queue), "queue not empty");
    test_assert(sem1.cnt == 0, "counter not zero");
  }

  /* [4.3.2] Testing non-timeout condition.*/
  test_set_step(2);
  {
    threads[0] = chThdCreateStatic(wa[0], WA_SIZE, chThdGetPriorityX() - 1,
                                   thread2, 0);
    msg = chSemWaitTimeout(&sem1, MS2ST(500));
    test_wait_threads();
    test_assert(msg == MSG_OK, "wrong wake-up message");
    test_assert(queue_isempty(&sem1.queue), "queue not empty");
    test_assert(sem1.cnt == 0, "counter not zero");
  }

  /* [4.3.3] Testing timeout condition.*/
  test_set_step(3);
  {
    target_time = test_wait_tick() + MS2ST(5 * 50);
    for (i = 0; i < 5; i++) {
      test_emit_token('A' + i);
      msg = chSemWaitTimeout(&sem1, MS2ST(50));
      test_assert(msg == MSG_TIMEOUT, "wrong wake-up message");
      test_assert(queue_isempty(&sem1.queue), "queue not empty");
      test_assert(sem1.cnt == 0, "counter not zero");
    }
    test_assert_sequence("ABCDE", "invalid sequence");
    test_assert_time_window(target_time, target_time + ALLOWED_DELAY,
                            "out of time window");
  }
}

static const testcase_t test_004_003 = {
  "Semaphore timeout test",
  test_004_003_setup,
  NULL,
  test_004_003_execute
};

/**
 * @page test_004_004 [4.4] Testing chSemAddCounterI() functionality
 *
 * <h2>Description</h2>
 * The functon is tested by waking up a thread then the semaphore
 * counter value is tested.
 *
 * <h2>Test Steps</h2>
 * - [4.4.1] A thread is created, it goes to wait on the semaphore.
 * - [4.4.2] The semaphore counter is increased by two, it is then
 *   tested to be one, the thread must have completed.
 * .
 */

static void test_004_004_setup(void) {
  chSemObjectInit(&sem1, 0);
}

static void test_004_004_execute(void) {

  /* [4.4.1] A thread is created, it goes to wait on the semaphore.*/
  test_set_step(1);
  {
    threads[0] = chThdCreateStatic(wa[0], WA_SIZE, chThdGetPriorityX()+1, thread1, "A");
  }

  /* [4.4.2] The semaphore counter is increased by two, it is then
     tested to be one, the thread must have completed.*/
  test_set_step(2);
  {
    chSysLock();
    chSemAddCounterI(&sem1, 2);
    chSchRescheduleS();
    chSysUnlock();
    test_wait_threads();
    test_assert_lock(chSemGetCounterI(&sem1) == 1, "invalid counter");
    test_assert_sequence("A", "invalid sequence");
  }
}

static const testcase_t test_004_004 = {
  "Testing chSemAddCounterI() functionality",
  test_004_004_setup,
  NULL,
  test_004_004_execute
};

/**
 * @page test_004_005 [4.5] Testing chSemWaitSignal() functionality
 *
 * <h2>Description</h2>
 * This test case explicitly addresses the @p chSemWaitSignal()
 * function. A thread is created that performs a wait and a signal
 * operations. The tester thread is awakened from an atomic wait/signal
 * operation. The test expects that the semaphore wait function returns
 * the correct value in each of the above scenario and that the
 * semaphore structure status is correct after each operation.
 *
 * <h2>Test Steps</h2>
 * - [4.5.1] An higher priority thread is created that performs
 *   non-atomical wait and signal operations on a semaphore.
 * - [4.5.2] The function chSemSignalWait() is invoked by specifying
 *   the same semaphore for the wait and signal phases. The counter
 *   value must be one on exit.
 * - [4.5.3] The function chSemSignalWait() is invoked again by
 *   specifying the same semaphore for the wait and signal phases. The
 *   counter value must be one on exit.
 * .
 */

static void test_004_005_setup(void) {
  chSemObjectInit(&sem1, 0);
}

static void test_004_005_teardown(void) {
  test_wait_threads();
}

static void test_004_005_execute(void) {

  /* [4.5.1] An higher priority thread is created that performs
     non-atomical wait and signal operations on a semaphore.*/
  test_set_step(1);
  {
    threads[0] = chThdCreateStatic(wa[0], WA_SIZE, chThdGetPriorityX()+1, thread3, 0);
  }

  /* [4.5.2] The function chSemSignalWait() is invoked by specifying
     the same semaphore for the wait and signal phases. The counter
     value must be one on exit.*/
  test_set_step(2);
  {
    chSemSignalWait(&sem1, &sem1);
    test_assert(queue_isempty(&sem1.queue), "queue not empty");
    test_assert(sem1.cnt == 0, "counter not zero");
  }

  /* [4.5.3] The function chSemSignalWait() is invoked again by
     specifying the same semaphore for the wait and signal phases. The
     counter value must be one on exit.*/
  test_set_step(3);
  {
    chSemSignalWait(&sem1, &sem1);
    test_assert(queue_isempty(&sem1.queue), "queue not empty");
    test_assert(sem1.cnt == 0, "counter not zero");
  }
}

static const testcase_t test_004_005 = {
  "Testing chSemWaitSignal() functionality",
  test_004_005_setup,
  test_004_005_teardown,
  test_004_005_execute
};

/**
 * @page test_004_006 [4.6] Testing Binary Semaphores special case
 *
 * <h2>Description</h2>
 * This test case tests the binary semaphores functionality. The test
 * both checks the binary semaphore status and the expected status of
 * the underlying counting semaphore.
 *
 * <h2>Test Steps</h2>
 * - [4.6.1] Creating a binary semaphore in "taken" state, the state is
 *   checked.
 * - [4.6.2] Resetting the binary semaphore in "taken" state, the state
 *   must not change.
 * - [4.6.3] Starting a signaler thread at a lower priority.
 * - [4.6.4] Waiting for the binary semaphore to be signaled, the
 *   semaphore is expected to be taken.
 * - [4.6.5] Signaling the binary semaphore, checking the binary
 *   semaphore state to be "not taken" and the underlying counter
 *   semaphore counter to be one.
 * - [4.6.6] Signaling the binary semaphore again, the internal state
 *   must not change from "not taken".
 * .
 */

static void test_004_006_teardown(void) {
  test_wait_threads();
}

static void test_004_006_execute(void) {
  binary_semaphore_t bsem;
  msg_t msg;

  /* [4.6.1] Creating a binary semaphore in "taken" state, the state is
     checked.*/
  test_set_step(1);
  {
    chBSemObjectInit(&bsem, true);
    test_assert_lock(chBSemGetStateI(&bsem) == true, "not taken");
  }

  /* [4.6.2] Resetting the binary semaphore in "taken" state, the state
     must not change.*/
  test_set_step(2);
  {
    chBSemReset(&bsem, true);
    test_assert_lock(chBSemGetStateI(&bsem) == true, "not taken");
  }

  /* [4.6.3] Starting a signaler thread at a lower priority.*/
  test_set_step(3);
  {
    threads[0] = chThdCreateStatic(wa[0], WA_SIZE,
                                   chThdGetPriorityX()-1, thread4, &bsem);
  }

  /* [4.6.4] Waiting for the binary semaphore to be signaled, the
     semaphore is expected to be taken.*/
  test_set_step(4);
  {
    msg = chBSemWait(&bsem);
    test_assert_lock(chBSemGetStateI(&bsem) == true, "not taken");
    test_assert(msg == MSG_OK, "unexpected message");
  }

  /* [4.6.5] Signaling the binary semaphore, checking the binary
     semaphore state to be "not taken" and the underlying counter
     semaphore counter to be one.*/
  test_set_step(5);
  {
    chBSemSignal(&bsem);
    test_assert_lock(chBSemGetStateI(&bsem) ==false, "still taken");
    test_assert_lock(chSemGetCounterI(&bsem.sem) == 1, "unexpected counter");
  }

  /* [4.6.6] Signaling the binary semaphore again, the internal state
     must not change from "not taken".*/
  test_set_step(6);
  {
    chBSemSignal(&bsem);
    test_assert_lock(chBSemGetStateI(&bsem) == false, "taken");
    test_assert_lock(chSemGetCounterI(&bsem.sem) == 1, "unexpected counter");
  }
}

static const testcase_t test_004_006 = {
  "Testing Binary Semaphores special case",
  NULL,
  test_004_006_teardown,
  test_004_006_execute
};

/****************************************************************************
 * Exported data.
 ****************************************************************************/

/**
 * @brief   Counter and Binary Semaphores.
 */
const testcase_t * const test_sequence_004[] = {
  &test_004_001,
  &test_004_002,
  &test_004_003,
  &test_004_004,
  &test_004_005,
  &test_004_006,
  NULL
};

#endif /* CH_CFG_USE_SEMAPHORES */
