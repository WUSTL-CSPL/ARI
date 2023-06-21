# input = "update_GPS"
input = raw_input()
print("Part I:")
print('    ' + input + '_t1 = std::chrono::high_resolution_clock::now();')

print("Part II:")
print('    ' + input + '_t2 = std::chrono::high_resolution_clock::now();')
print('    auto duration = std::chrono::duration_cast<std::chrono::microseconds>(' + input + '_t2 -' + input + '_t1).count();')
print('    ' + input + '_total += duration;')
print('    ' + input + '_count += 1;')
print('    if (' + input + '_count % 1000 == 0){' )
print('        printf("average ' + input + ' measure time microseconds is %llu!\\n",' + input + '_total/1000);')
print('        ' + input + '_total = 0;')
print('    }')

print("Part III:")
print('unsigned long long ' + input + '_total = 0;')
print('unsigned long long ' + input + '_count = 0;')
print('std::chrono::high_resolution_clock::time_point ' + input + '_t1;')
print('std::chrono::high_resolution_clock::time_point ' + input + '_t2;')

print("Part IV:")
print('#include <time.h>')
print('#include <chrono>')
