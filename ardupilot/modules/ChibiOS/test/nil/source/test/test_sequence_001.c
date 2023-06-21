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
 * @file    test_sequence_001.c
 * @brief   Test Sequence 001 code.
 *
 * @page test_sequence_001 [1] Threads Functionality
 *
 * File: @ref test_sequence_001.c
 *
 * <h2>Description</h2>
 * This sequence tests the ChibiOS/NIL functionalities related to
 * threading.
 *
 * <h2>Test Cases</h2>
 * - @subpage test_001_001
 * - @subpage test_001_002
 * .
 */

/****************************************************************************
 * Shared code.
 ****************************************************************************/

#include "ch.h"

/****************************************************************************
 * Test cases.
 ****************************************************************************/

/**
 * @page test_001_001 [1.1] System Tick Counter functionality
 *
 * <h2>Description</h2>
 * The functionality of the API @p chVTGetSystemTimeX() is tested.
 *
 * <h2>Test Steps</h2>
 * - [1.1.1] A System Tick Counter increment is expected, the test
 *   simply hangs if it does not happen.
 * .
 */

static void test_001_001_execute(void) {

  /* [1.1.1] A System Tick Counter increment is expected, the test
     simply hangs if it does not happen.*/
  test_set_step(1);
  {
    systime_t time = chVTGetSystemTimeX();
    while (time == chVTGetSystemTimeX()) {
    }
  }
}

static const testcase_t test_001_001 = {
  "System Tick Counter functionality",
  NULL,
  NULL,
  test_001_001_execute
};

/**
 * @page test_001_002 [1.2] Thread Sleep functionality
 *
 * <h2>Description</h2>
 * The functionality of @p chThdSleep() and derivatives is tested.
 *
 * <h2>Test Steps</h2>
 * - [1.2.1] The current system time is read then a sleep is performed
 *   for 100 system ticks and on exit the system time is verified
 *   again.
 * - [1.2.2] The current system time is read then a sleep is performed
 *   for 100000 microseconds and on exit the system time is verified
 *   again.
 * - [1.2.3] The current system time is read then a sleep is performed
 *   for 100 milliseconds and on exit the system time is verified
 *   again.
 * - [1.2.4] The current system time is read then a sleep is performed
 *   for 1 second and on exit the system time is verified again.
 * - [1.2.5] Function chThdSleepUntil() is tested with a timeline of
 *   "now" + 100 ticks.
 * .
 */

static void test_001_002_execute(void) {
  systime_t time;

  /* [1.2.1] The current system time is read then a sleep is performed
     for 100 system ticks and on exit the system time is verified
     again.*/
  test_set_step(1);
  {
    time = chVTGetSystemTimeX();
    chThdSleep(100);
    test_assert_time_window(time + 100,
                            time + 100 + 1,
                            "out of time window");
  }

  /* [1.2.2] The current system time is read then a sleep is performed
     for 100000 microseconds and on exit the system time is verified
     again.*/
  test_set_step(2);
  {
    time = chVTGetSystemTimeX();
    chThdSleepMicroseconds(100000);
    test_assert_time_window(time + US2ST(100000),
                            time + US2ST(100000) + 1,
                            "out of time window");
  }

  /* [1.2.3] The current system time is read then a sleep is performed
     for 100 milliseconds and on exit the system time is verified
     again.*/
  test_set_step(3);
  {
    time = chVTGetSystemTimeX();
    chThdSleepMilliseconds(100);
    test_assert_time_window(time + MS2ST(100),
                            time + MS2ST(100) + 1,
                            "out of time window");
  }

  /* [1.2.4] The current system time is read then a sleep is performed
     for 1 second and on exit the system time is verified again.*/
  test_set_step(4);
  {
    time = chVTGetSystemTimeX();
    chThdSleepSeconds(1);
    test_assert_time_window(time + S2ST(1),
                            time + S2ST(1) + 1,
                            "out of time window");
  }

  /* [1.2.5] Function chThdSleepUntil() is tested with a timeline of
     "now" + 100 ticks.*/
  test_set_step(5);
  {
    time = chVTGetSystemTimeX();
    chThdSleepUntil(time + 100);
    test_assert_time_window(time + 100,
                            time + 100 + 1,
                            "out of time window");
  }
}

static const testcase_t test_001_002 = {
  "Thread Sleep functionality",
  NULL,
  NULL,
  test_001_002_execute
};

/****************************************************************************
 * Exported data.
 ****************************************************************************/

/**
 * @brief   Threads Functionality.
 */
const testcase_t * const test_sequence_001[] = {
  &test_001_001,
  &test_001_002,
  NULL
};
