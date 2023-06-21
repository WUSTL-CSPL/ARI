#pragma once

#include <AP_HAL/AP_HAL_Boards.h>

#if CONFIG_HAL_BOARD == HAL_BOARD_VRBRAIN
#include "AP_HAL_VRBRAIN.h"
#include <pthread.h>

class VRBRAIN::Semaphore : public AP_HAL::Semaphore {
public:
    Semaphore() {
        pthread_mutex_init(&_lock, nullptr);
    }
    bool give();
    bool take(uint32_t timeout_ms);
    bool take_nonblocking();
private:
    pthread_mutex_t _lock;
};
#endif // CONFIG_HAL_BOARD
