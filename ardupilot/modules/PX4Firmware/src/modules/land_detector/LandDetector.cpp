/****************************************************************************
 *
 *   Copyright (c) 2013-2015 PX4 Development Team. All rights reserved.
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
 * 3. Neither the name PX4 nor the names of its contributors may be
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

/**
 * @file LandDetector.cpp
 * Land detection algorithm
 *
 * @author Johan Jansen <jnsn.johan@gmail.com>
 * @author Morten Lysgaard <morten@lysgaard.no>
 */

#include "LandDetector.h"
#include <unistd.h>                 //usleep
#include <drivers/drv_hrt.h>
#include <px4_config.h>
#include <px4_defines.h>

LandDetector::LandDetector() :
	_landDetectedPub(0),
	_landDetected( {0, false}),
	       _arming_time(0),
	       _taskShouldExit(false),
	       _taskIsRunning(false),
_work{} {
	// ctor
}

LandDetector::~LandDetector()
{
	work_cancel(HPWORK, &_work);
	_taskShouldExit = true;
}

int LandDetector::start()
{
	/* schedule a cycle to start things */
	work_queue(HPWORK, &_work, (worker_t)&LandDetector::cycle_trampoline, this, 0);

	return 0;
}

void LandDetector::shutdown()
{
	_taskShouldExit = true;
}

void
LandDetector::cycle_trampoline(void *arg)
{
	LandDetector *dev = reinterpret_cast<LandDetector *>(arg);

	dev->cycle();
}

void LandDetector::cycle()
{
	if (!_taskIsRunning) {
		// advertise the first land detected uORB
		_landDetected.timestamp = hrt_absolute_time();
		_landDetected.landed = false;
		_landDetectedPub = orb_advertise(ORB_ID(vehicle_land_detected), &_landDetected);

		// initialize land detection algorithm
		initialize();

		// task is now running, keep doing so until shutdown() has been called
		_taskIsRunning = true;
		_taskShouldExit = false;
	}

	bool landDetected = update();

	// publish if land detection state has changed
	if (_landDetected.landed != landDetected) {
		_landDetected.timestamp = hrt_absolute_time();
		_landDetected.landed = landDetected;

		// publish the land detected broadcast
		orb_publish(ORB_ID(vehicle_land_detected), (orb_advert_t)_landDetectedPub, &_landDetected);
		//warnx("in air status changed: %s", (_landDetected.landed) ? "LANDED" : "TAKEOFF");
	}

	if (!_taskShouldExit) {
		work_queue(HPWORK, &_work, (worker_t)&LandDetector::cycle_trampoline, this,
			   USEC2TICK(1000000 / LAND_DETECTOR_UPDATE_RATE));
	}
}

bool LandDetector::orb_update(const struct orb_metadata *meta, int handle, void *buffer)
{
	bool newData = false;

	// check if there is new data to grab
	if (orb_check(handle, &newData) != OK) {
		return false;
	}

	if (!newData) {
		return false;
	}

	if (orb_copy(meta, handle, buffer) != OK) {
		return false;
	}

	return true;
}
