#include "Copter.h"
#include <time.h>
#include <chrono>

namespace {

unsigned long long landinggear_update_total = 0;
unsigned long long landinggear_update_count = 0;
std::chrono::high_resolution_clock::time_point landinggear_update_t1;
std::chrono::high_resolution_clock::time_point landinggear_update_t2;

}
// Run landing gear controller at 10Hz
void Copter::landinggear_update()
{
    landinggear_update_t1 = std::chrono::high_resolution_clock::now();


    // exit immediately if no landing gear output has been enabled
    if (!SRV_Channels::function_assigned(SRV_Channel::k_landing_gear_control)) {
        return;
    }

    // last status (deployed or retracted) used to check for changes, initialised to startup state of landing gear
    static bool last_deploy_status = landinggear.deployed();

    // if we are doing an automatic landing procedure, force the landing gear to deploy.
    // To-Do: should we pause the auto-land procedure to give time for gear to come down?
    if (flightmode->landing_gear_should_be_deployed()) {
        landinggear.set_position(AP_LandingGear::LandingGear_Deploy);
    }

    // send event message to datalog if status has changed
    if (landinggear.deployed() != last_deploy_status) {
        if (landinggear.deployed()) {
            Log_Write_Event(DATA_LANDING_GEAR_DEPLOYED);
        } else {
            Log_Write_Event(DATA_LANDING_GEAR_RETRACTED);
        }
    }

    last_deploy_status = landinggear.deployed();

    landinggear_update_t2 = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::microseconds>(landinggear_update_t2 -landinggear_update_t1).count();
    landinggear_update_total += duration;
    landinggear_update_count += 1;
    if (landinggear_update_count % 1000 == 0){
        printf("average landinggear_update measure time microseconds is %llu!\n",landinggear_update_total/1000);
        landinggear_update_total = 0;
    }

}
