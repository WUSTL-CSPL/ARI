#include "Copter.h"
#include <time.h>
#include <chrono>


namespace {
    
unsigned long long run_nav_updates_total = 0;
unsigned long long run_nav_updates_count = 0;
std::chrono::high_resolution_clock::time_point run_nav_updates_t1;
std::chrono::high_resolution_clock::time_point run_nav_updates_t2;


}
// run_nav_updates - top level call for the autopilot
// ensures calculations such as "distance to waypoint" are calculated before autopilot makes decisions
// To-Do - rename and move this function to make it's purpose more clear
void Copter::run_nav_updates(void)
{
    run_nav_updates_t1 = std::chrono::high_resolution_clock::now();

    update_super_simple_bearing(false);

    flightmode->update_navigation();

    run_nav_updates_t2 = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::microseconds>(run_nav_updates_t2 -run_nav_updates_t1).count();
    run_nav_updates_total += duration;
    run_nav_updates_count += 1;
    if (run_nav_updates_count % 1000 == 0){
        printf("average run_nav_updates measure time microseconds is %llu!\n",run_nav_updates_total/1000);
        run_nav_updates_total = 0;
    }

}

// distance between vehicle and home in cm
uint32_t Copter::home_distance()
{
    if (position_ok()) {
        const Vector3f home = pv_location_to_vector(ahrs.get_home());
        const Vector3f curr = inertial_nav.get_position();
        _home_distance = get_horizontal_distance_cm(curr, home);
    }
    return _home_distance;
}

// The location of home in relation to the vehicle in centi-degrees
int32_t Copter::home_bearing()
{
    if (position_ok()) {
        const Vector3f home = pv_location_to_vector(ahrs.get_home());
        const Vector3f curr = inertial_nav.get_position();
        _home_bearing = get_bearing_cd(curr,home);
    }
    return _home_bearing;
}
