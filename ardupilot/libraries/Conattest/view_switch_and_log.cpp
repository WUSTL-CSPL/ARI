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
#include <ta_hello_world.h>
#include <time.h>
#include <chrono>
#include <pthread.h>
#include <stdint.h>
#include "view_switch_and_log.h"
#include <cstdint>
#include <vector>

extern "C" {
#include "blake2.h"
}


#define PTA_INVOKE_TESTS_UUID \
    { 0xd96a5b40, 0xc3e5, 0x21e3, \
      { 0x87, 0x94, 0x10, 0x02, 0xa5, 0xd5, 0xc6, 0x1b} }
#define PTA_INVOKE_TESTS_CMD_TRACE    0



#define handle_error(msg) \
	do { perror(msg); exit(EXIT_FAILURE); } while (0)

// #define PROT_READ        0x1                /* Page can be read.  */
// #define PROT_WRITE       0x2                /* Page can be written.  */
// #define PROT_EXEC        0x4                /* Page can be executed.  */
// #define PROT_NONE        0x0                /* Page can not be accessed.  */

namespace {

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

}



// class Blake2sHasher {
// public:
//     Blake2sHasher() {
//         if (blake2s_init(&state_, BLAKE2S_OUTBYTES) != 0) {
//             // throw std::runtime_error("Failed to initialize BLAKE2s");

//         }
//     }

//     void update(uint32_t address) {
//         if (blake2s_update(&state_, &address, sizeof(address)) != 0) {
//             // throw std::runtime_error("Failed to update BLAKE2s hash");
        
//         }
//     }

//     std::vector<uint8_t> finalize() {
//         std::vector<uint8_t> hash(BLAKE2S_OUTBYTES);
//         if (blake2s_final(&state_, hash.data(), BLAKE2S_OUTBYTES) != 0) {
//             // throw std::runtime_error("Failed to finalize BLAKE2s hash");
        
//         }
//         return hash;
//     }

// private:
//     blake2s_state state_;
// };


// Blake2sHasher hasher;

// void hash_update(uint32_t rt_addr, Blake2sHasher &hasher){
// 	hasher.update(rt_addr);
// 	return;
// }




extern "C" { // C naming instead of C++ mangling
	//cpsr, condition type, cfe_type

	#define HASH_OUTBYTES 32


	extern RingBuffer ringBuffer;

	#define DBG


	int invoke_cnt = 0;

	//jinwen write this for test verification
	extern int recording_flag;
	extern int recording_cnt;
	extern int ringbuffer_init_flag;


	int ret_recording_finish = 0;

	int ret_hash_init_flag = 0;

	blake2s_state state;
	uint8_t hash[HASH_OUTBYTES];



	void mission_control(){

	    if(recording_cnt == 0){
	        recording_flag = 1;
	    }

	    if(recording_cnt == 4){
	        ret_recording_finish = 1;        
	    }

	    if(recording_cnt == 5){
	        recording_flag = 0;
	    }
	    else 
	    if (recording_cnt < 5){
	    	printf("+++++++++cnt:%d++++++++++\n", recording_cnt);
	        recording_cnt += 1;
	    }

	    return;

	}


	void run_thread(void *(*function)(void*)){
	  pthread_t thread;
    pthread_create(&thread, nullptr, function, nullptr);
    pthread_detach(thread);  // Let the thread run independently.	
	}


	void write_number_to_file(uint32_t number, const char* filename) {
	    FILE* file = fopen(filename, "a");
	    if(file != NULL) {
	        char number_str[12];  // Buffer to hold the number as a string, 10 digits + newline + null terminator
	        sprintf(number_str, "%x\n", number);  // Convert the number to a string
	        fputs(number_str, file);  // Write the number string to the file
	        fclose(file);
	    } else {
	        printf("Failed to open the file %s\n", filename);
	    }
	}


	void write_array_to_file(uint8_t *array, size_t array_size, const char *filename) {
	    FILE *file = fopen(filename, "wb");  // Open the file in binary write mode

	    if(file != NULL){
	    	for(size_t i = 0; i < array_size; i++){
	    		fprintf(file, "%x\n", array[i]);
	    	}
	    	fclose(file);
	    }
	    else{
	    	printf("Failed to open the file %s\n", filename);
	    }

	    // if (file != NULL) {
	    //     fwrite(array, sizeof(uint8_t), array_size, file);  // Write the array to the file
	    //     fclose(file);  // Close the file after writing
	    // } else {
	    //     printf("Failed to open the file %s\n", filename);
	    // }
	}

void write_two_numbers_to_file(uint32_t number1, uint32_t number2, const char* filename) {
    FILE* file = fopen(filename, "a");
    if(file != NULL) {
        // Write the two numbers to the file, separated by a space
        fprintf(file, "%x %x\n", number1, number2);
        fclose(file);
    } else {
        printf("Failed to open the file %s\n", filename);
    }
}


	void print_hash(uint8_t* hash, size_t length) {
	    for (size_t i = 0; i < length; i++) {
	        printf("%02x", hash[i]);
	    }
	    printf("\n");
	}


	void* read_measurement(void*){

		// uint32_t read_value;
		Element poppedElem;

		//contineous read measurement from the ringbuffer
		while(true){


			if(pop(&ringBuffer, &poppedElem)){
				// printf("------type:%d----0x%d------\n", poppedElem.Type, poppedElem.destAddr);
				
				//for indirect jumps, storing the destination address
				if(poppedElem.Type < 2){
					#ifdef DBG
					printf("read01: des:0x%x, src:0x%x, type:%d\n", poppedElem.destAddr,\
					 poppedElem.srcAddr, poppedElem.Type);
					#endif
					write_number_to_file(poppedElem.destAddr, "./ARI_ind_jmp.txt");

				}
				//for returns, record the hashes
				else if(poppedElem.Type < 4){

					if(ret_hash_init_flag == 0){
						ret_hash_init_flag = 1;
						if((blake2s_init(&state, HASH_OUTBYTES)) !=0 ){
							printf("%s\n", "Failed to initalizae BLAKE2s");
						}
					}

					if(blake2s_update(&state, &poppedElem.destAddr, sizeof(poppedElem.destAddr)) != 0){
						printf("%s\n", "Failed to update BLAKE2s hash\n");
					}

					printf("return update: 0x%x\n", poppedElem.destAddr);

					#ifdef DBG
					printf("read3: des:0x%x, src:0x%x, type:%d ret_finish %d, rcd_flag %d\n", \
					poppedElem.destAddr,\
					 poppedElem.srcAddr, poppedElem.Type, ret_recording_finish, \
					 recording_flag);	
					#endif


					// if(ret_recording_finish){
					// 	if (blake2s_final(&state, hash, HASH_OUTBYTES) != 0){
					// 		printf("%s\n", "Failed to finalized BLAKE2s hash");
					// 	}

					// 	write_array_to_file(hash, sizeof(hash), "./ARI_ret_hash.txt");
					// 	print_hash(hash, sizeof(hash));

					// 	//jinwen write this for debug
					// 	// printf("%s\n", "!!!!!!!!!!!!!!!final return hash!!!!!!!!!!!!!!!\n");
					// 	// print_hash(hash, sizeof(hash));
					// }

				}
				//for branches, storing the decisions
				else if(poppedElem.Type == 4){
						#ifdef DBG
						printf("read4: des:0x%x, src:0x%x, type:%d dcs:%d\n", poppedElem.destAddr,\
						 poppedElem.srcAddr, poppedElem.Type, poppedElem.cond);
						#endif
						write_number_to_file(poppedElem.cond, "./ARI_branch.txt");

				}
				else if(poppedElem.Type == 10){
						#ifdef DBG
						printf("read10: ---src:0x%x--dest:0x%x---\n", poppedElem.srcAddr, poppedElem.destAddr);
						#endif
						write_two_numbers_to_file(poppedElem.srcAddr, poppedElem.destAddr, \
							"./ARI_tsf.txt");
				}


				if(is_empty(&ringBuffer) && !recording_flag){
						if(ret_recording_finish){
							if (blake2s_final(&state, hash, HASH_OUTBYTES) != 0){
								printf("%s\n", "Failed to finalized BLAKE2s hash");
							}
							write_array_to_file(hash, sizeof(hash), "./ARI_ret_hash.txt");
							print_hash(hash, sizeof(hash));
						}
				}

				//blc
				// else if(poppedElem.Type == 11){
				// 		printf("---src:0x%x--dest:0x%x---\n", poppedElem.srcAddr, poppedElem.destAddr);
				// 		write_number_to_file(poppedElem.cond, "./ARI_tsf_cond.txt");
				// 		write_two_numbers_to_file(poppedElem.srcAddr, poppedElem.destAddr, \
				// 			"./ARI_tsf.txt");
				// }

				// //hash the return
				// if(cfe_type == 3){
					
				// 	if(ret_hash_init_flag == 0){
				// 		ret_hash_init_flag = 1;
				// 		if((blake2s_init(&state, HASH_OUTBYTES)) !=0 ){
				// 			printf("%s\n", "Failed to initalizae BLAKE2s");
				// 		}
				// 	}

				// 	if(blake2s_update(&state, &elem.destAddr, sizeof(elem.destAddr)) != 0){
				// 		printf("%s\n", "Failed to finalize BLAKE2s hash\n");
				// 	}

				// 	if(ret_recording_finish){
				// 		if (blake2s_final(&state, hash, HASH_OUTBYTES) != 0){
				// 			printf("%s\n", "Failed to finalized BLAKE2s hash");
				// 		}
				// 		//jinwen write this for debug
				// 		// printf("%s\n", "!!!!!!!!!!!!!!!final return hash!!!!!!!!!!!!!!!\n");
				// 		// print_hash(hash, sizeof(hash));
				// 	}

				// }

			}
		}

		return nullptr;
	}


//create measurement files
void create_files(const char* filename1, const char* filename2, const char* filename3,\
	const char* filename4, const char* filename5) {
    const char* filenames[5] = {filename1, filename2, filename3, filename4, filename5};
    FILE* file;

    for(int i = 0; i < 5; ++i) {
        file = fopen(filenames[i], "r");
        if(file != NULL) {
            // The file exists, so we close it and remove it
            fclose(file);
            if(remove(filenames[i]) == 0) {
                printf("Deleted successfully the file %s\n", filenames[i]);
            } else {
                printf("Unable to delete the file %s\n", filenames[i]);
            }
        }

        // Now we create a new file
        file = fopen(filenames[i], "w");
        if(file != NULL) {
            printf("Successfully created the file %s\n", filenames[i]);
            fclose(file);
        } else {
            printf("Failed to create the file %s\n", filenames[i]);
        }
    }
}



	void start_new_thread(){
		// run_thread(my_print);

		//create measurement storage file here
		create_files("./ARI_branch.txt", "./ARI_ind_jmp.txt", "./ARI_ret_hash.txt", \
			"./ARI_tsf.txt", "./ARI_tsf_cond.txt");

		run_thread(read_measurement);
		return;
	}

	// void start_new_thread(){
	// 	return;
	// }

	void test_cpp_trampoline(){
		return;
	}



void view_switch_to_rd_and_log(int destination, int pc, int cfe_type)
	{
		// printf("view_switch_to_rd_and_log dest:%x pc:%x cfe_type:%d\n", destination, pc, cfe_type);
		// return;


		// if(recording_flag){
		// 	printf("des:0x%x, src:0x%x, type:%d\n", destination, pc, cfe_type);		
		// }

		if(!recording_flag){
			return;
		}

		// return;

		//jinwen wirte this for testing pass functionality
		// printf("des:0x%x, src:0x%x, type:%d\n", destination, pc, cfe_type);
		// return;

		//TODO: we need to record the measurement into the global ring buffer.

		//init ring buffer
		if(!ringbuffer_init_flag){
			ringbuffer_init_flag = 1;
			// atomic_init(&ringBuffer.head, 0);
			// atomic_init(&ringBuffer.tail, 0);
			ringbuffer_init(&ringBuffer);
		}

		Element elem;
		elem.srcAddr = pc;
		elem.destAddr = destination;
		elem.Type = cfe_type;

		// //hash the return
		// if(cfe_type == 3){
			
		// 	if(ret_hash_init_flag == 0){
		// 		ret_hash_init_flag = 1;
		// 		if((blake2s_init(&state, HASH_OUTBYTES)) !=0 ){
		// 			printf("%s\n", "Failed to initalizae BLAKE2s");
		// 		}
		// 	}

		// 	if(blake2s_update(&state, &elem.destAddr, sizeof(elem.destAddr)) != 0){
		// 		printf("%s\n", "Failed to finalize BLAKE2s hash\n");
		// 	}

		// 	if(ret_recording_finish){
		// 		if (blake2s_final(&state, hash, HASH_OUTBYTES) != 0){
		// 			printf("%s\n", "Failed to finalized BLAKE2s hash");
		// 		}
		// 		//jinwen write this for debug
		// 		// printf("%s\n", "!!!!!!!!!!!!!!!final return hash!!!!!!!!!!!!!!!\n");
		// 		// print_hash(hash, sizeof(hash));
		// 	}

		// }





		if(!push(&ringBuffer, elem)){
			printf("buffer is full\n");
		}

		return;

		// //jinwe add this for debug
		// printf("hhh\n");

		invoke_cnt += 1;

		// if(invoke_cnt % 10000 == 0){
		// 	printf("^^^^^^^^^^invoke_cnt: %d^^^^^^^^^^^\n", invoke_cnt);
		// }
		
		if(invoke_cnt % 30 == 0){
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


}