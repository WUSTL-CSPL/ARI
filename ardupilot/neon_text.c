#include <stdio.h>
#include <stdlib.h>


int main(){

	float dst = 0;
	float src1 = 1;
	float src2 = 1;

	add_float_neon3(&dst, &src1, &src2, 10);

	printf("dst: %f, src1: %f, src2: %f", dst, src1, src2);
}


void add_float_neon3(float* dst, float* src1, float* src2, int count)
{

asm volatile (
"1: \n"
"vld1.32 {d0}, [%[src1]]! \n"
"vld1.32 {d1}, [%[src2]]! \n"
// "vmov d0, r0, r1 \n"
"vadd.f32 d0, d0, d1 \n"
// "subs %[count], %[count], #4 \n"
"vst1.32 {d0}, [%[dst]]! \n"
// "bgt 1b \n"
: [dst] "+r" (dst)
: [src1] "r" (src1), [src2] "r" (src2), [count] "r" (count)
: "memory", "d0", "d1"
);

} 