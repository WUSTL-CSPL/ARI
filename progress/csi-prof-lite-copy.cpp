#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "csi.h"
#include <err.h>
#include <tee_client_api.h>
#include <ta_hello_world.h>
#include <time.h>
#include <chrono>


#define PTA_INVOKE_TESTS_UUID \
    { 0xd96a5b40, 0xc3e5, 0x21e3, \
      { 0x87, 0x94, 0x10, 0x02, 0xa5, 0xd5, 0xc6, 0x1b } }
#define PTA_INVOKE_TESTS_CMD_TRACE    0

namespace {
uint64_t global_time_used = 0;
uint64_t count = 0;
uint64_t last_time;
bool init = false;
uint64_t rd_count_enter =0;
uint64_t rd_count_exit =0;
TEEC_Result res;
TEEC_Context ctx;
TEEC_Session sess;
TEEC_Operation op;
TEEC_UUID uuid = PTA_INVOKE_TESTS_UUID;
uint32_t err_origin;
bool rd_optee_init = false;
bool rd_optee_end = false;
uint64_t rd_count_loop =0;
uint64_t rd_bb_exit =0;
std::chrono::high_resolution_clock::time_point t1;
std::chrono::high_resolution_clock::time_point t2;

void report() {
    fprintf(stderr, "global time used: %llu, count: %llu\n", global_time_used, count);
}
}

extern "C" {
void __csi_init() {
    atexit(report);
}

void __csi_bb_entry(const csi_id_t bb_id, const bb_prop_t prop){
    if (!rd_optee_init){
      rd_optee_init=true;
      //printf("Initialize a context from user space! \n");
      res = TEEC_InitializeContext(NULL, &ctx);
      if (res != TEEC_SUCCESS)
        errx(1, "TEEC_InitializeContext failed with code 0x%x", res);

      printf("Open session from user space! \n");
      res = TEEC_OpenSession(&ctx, &sess, &uuid,
               TEEC_LOGIN_PUBLIC, NULL, NULL, &err_origin);
      if (res != TEEC_SUCCESS)
        errx(1, "TEEC_Opensession failed with code 0x%x origin 0x%x",
        res, err_origin);

      //printf("Setting op.params[0].value.a to fffd in user space \n");
      memset(&op, 0, sizeof(op));
      op.paramTypes = TEEC_PARAM_TYPES(TEEC_VALUE_INOUT, TEEC_NONE,
               TEEC_NONE, TEEC_NONE);
      //op.params[0].value.a = 0xfffa;
      t1 = std::chrono::high_resolution_clock::now();
    }
    if (rd_bb_exit<100000){
      //printf("__csi_bb_entry number %llu! bb_id is %llu!\n", rd_count_exit, bb_id);
      rd_bb_exit++;
      
      rd_count_loop++;
      if (rd_count_loop==10000){
        //printf("still running and looping! current bb_count is %llu!\n", rd_bb_exit);
	t2 = std::chrono::high_resolution_clock::now();
	auto duration = std::chrono::duration_cast<std::chrono::microseconds>(t2-t1).count();
	printf("measure time microseconds is %llu, for loop is %llu!\n",duration,rd_count_loop);
	rd_count_loop=0;
      }
      
    }
    else{
      if(!rd_optee_end){
        rd_optee_end=true;
        printf("Close session from user space! \n");
        TEEC_CloseSession(&sess);
        printf("Finalize context from user space! \n");
        TEEC_FinalizeContext(&ctx);
      }
  }
}

}
