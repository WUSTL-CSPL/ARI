#include <unistd.h>
#include <signal.h>
#include <stdio.h>
#include <malloc.h>
#include <stdlib.h>
#include <errno.h>
#include <sys/mman.h>

#include <string.h>
#include <err.h>
#include <tee_client_api.h>
#include <time.h>

#include <stdint.h>


#define PTA_INVOKE_TESTS_UUID \
    { 0xd96a5b40, 0xc3e5, 0x21e3, \
      { 0x87, 0x94, 0x10, 0x02, 0xa5, 0xd5, 0xc6, 0x1b } }
#define PTA_INVOKE_TESTS_CMD_TRACE    0



#define handle_error(msg) \
	do { perror(msg); exit(EXIT_FAILURE); } while (0)

// #define PROT_READ        0x1                /* Page can be read.  */
// #define PROT_WRITE       0x2                /* Page can be written.  */
// #define PROT_EXEC        0x4                /* Page can be executed.  */
// #define PROT_NONE        0x0                /* Page can not be accessed.  */


	// uint64_t global_time_used = 0;
	// uint64_t count = 0;
	// uint64_t last_time;
	// bool init = false;
	// uint64_t rd_count_enter =0;
	// uint64_t rd_count_exit =0;
	TEEC_Result res;
	TEEC_Context ctx;
	TEEC_Session sess;
	TEEC_Operation op;
	TEEC_UUID uuid = PTA_INVOKE_TESTS_UUID;
	uint32_t err_origin;

	bool rd_optee_init = false;
	// bool rd_optee_end = false;
	// uint64_t rd_count_loop =0;
	// uint64_t rd_bb_exit =0;



	//cpsr, condition type, cfe_type
	int invoke_cnt = 0;
	void view_switch_to_rd_and_log(int destination, int pc, int cfe_type)
	{
		// printf("view_switch_to_rd_and_log dest:%x pc:%x cfe_type:%d\n", destination, pc, cfe_type);
		// return;

		invoke_cnt += 1;

		// if(invoke_cnt % 10000 == 0){
		// 	printf("^^^^^^^^^^invoke_cnt: %d^^^^^^^^^^^\n", invoke_cnt);
		// }
		
		if(invoke_cnt % 10 == 0){
			// invoke_cnt = 0;
		}
		else{
			return;
		}


		if (!rd_optee_init){

			rd_optee_init=true;

			/* Initialize a context connecting us to the TEE */
			printf("Initialize a context from user space!\n");
			res = TEEC_InitializeContext(NULL, &ctx);
			if (res != TEEC_SUCCESS)
				errx(1, "TEEC_InitializeContext failed with code 0x%x", res);

			/*
			 * Open a session to the "hello world" TA, the TA will print "hello
			 * world!" in the log when the session is created.
			 */
			// printf("Open session from user space! \n");
			res = TEEC_OpenSession(&ctx, &sess, &uuid,
					       TEEC_LOGIN_PUBLIC, NULL, NULL, &err_origin);
			if (res != TEEC_SUCCESS)
				errx(1, "TEEC_Opensession failed with code 0x%x origin 0x%x",
					res, err_origin);
		}

		// printf("Setting op.params[0].value.a to fffd in user space \n");
		memset(&op, 0, sizeof(op));
		op.paramTypes = TEEC_PARAM_TYPES(TEEC_VALUE_INOUT, TEEC_VALUE_INOUT,
						 TEEC_NONE, TEEC_NONE);
		// op.params[0].value.a = 0xfffa;
		// op.params[0].value.b = 0x0000;
		// op.params[1].value.a = 0x1111;

		op.params[0].value.a = destination;
		op.params[0].value.b = pc;
		op.params[1].value.a = cfe_type;
		op.params[1].value.b = 444;

		// printf("Invoking PTA to increment op.params[0].value.a: %x\n in user space", op.params[0].value.a);
		res = TEEC_InvokeCommand(&sess, PTA_INVOKE_TESTS_CMD_TRACE, &op,
					 &err_origin);
		if (res != TEEC_SUCCESS)
			errx(1, "TEEC_InvokeCommand failed with code 0x%x origin 0x%x",
				res, err_origin);
		// printf("PTA incremented value to %x\n in user space", op.params[0].value.a);


		// printf("pagesize is %d", pagesize);
		// 0000fa40

		// size_t pagesize = sysconf(_SC_PAGESIZE);
		// if (mprotect((uintptr_t *)0x800000, pagesize * 16, PROT_EXEC ) == -1)
		// 	handle_error("mprotect");

	}


	void view_switch_to_text_and_log()
	{
		// if (mprotect((void *)0x400000, 0x200000, PROT_READ) == -1)
		//   handle_error("mprotect");
		// printf("view_switch_to_text_and_log\n");	

		// printf("Setting op.params[0].value.a to fffd in user space \n");
		memset(&op, 0, sizeof(op));
		op.paramTypes = TEEC_PARAM_TYPES(TEEC_VALUE_INOUT, TEEC_NONE,
						 TEEC_NONE, TEEC_NONE);
		op.params[0].value.a = 0xfffa;

		// printf("Invoking PTA to increment op.params[0].value.a: %x\n in user space", op.params[0].value.a);
		res = TEEC_InvokeCommand(&sess, PTA_INVOKE_TESTS_CMD_TRACE, &op,
					 &err_origin);
		if (res != TEEC_SUCCESS)
			errx(1, "TEEC_InvokeCommand failed with code 0x%x origin 0x%x",
				res, err_origin);
		// printf("PTA incremented value to %x\n in user space", op.params[0].value.a);

	}

	void __test(uint64_t a, uint64_t b){
		// printf("load_store addr:%x val:%d\n", a, b);
	}

	void __conditional_branch_recording(bool condition){
		// printf("condition %d \n", condition);
	}

	void __tsf_recording(int source_cpt, int dest_cpt){


	}


// int main(){
// 	return 0;
// }