#include "stdio.h"
#include "stdlib.h"
#include <stdatomic.h>
#include <stdint.h>
#include <stdbool.h>


#define BUFFER_SIZE 10000000


#define BUFFER_SIZE 10000000  // Change this according to your requirements

#define DBG


typedef struct {
    uint32_t srcAddr;
    uint32_t destAddr;
    uint32_t cond;
    uint8_t Type;
} Element;

typedef struct {
    Element buffer[BUFFER_SIZE];
    _Atomic size_t head;
    _Atomic size_t tail;
} RingBuffer;

RingBuffer ringBuffer;


bool push(RingBuffer* ringBuffer, Element value) {
    size_t next_head = (ringBuffer->head + 1) % BUFFER_SIZE;
    if (next_head != atomic_load(&ringBuffer->tail)) {
        ringBuffer->buffer[ringBuffer->head] = value;
        atomic_store(&ringBuffer->head, next_head);
        return true;
    } else {
        // Buffer is full
        return false;
    }
}

bool pop(RingBuffer* ringBuffer, Element* value) {
    if (atomic_load(&ringBuffer->head) == atomic_load(&ringBuffer->tail)) {
        // Buffer is empty
        return false;
    } else {
        *value = ringBuffer->buffer[ringBuffer->tail];
        atomic_store(&ringBuffer->tail, (ringBuffer->tail + 1) % BUFFER_SIZE);
        return true;
    }
}


bool is_empty(RingBuffer* ringBuffer) {
    return ringBuffer->head == ringBuffer->tail;
}


bool ringbuffer_init(RingBuffer* ringBuffer){

	atomic_init(&ringBuffer->head, 0);
	atomic_init(&ringBuffer->tail, 0);
	return true;
}


uint32_t read_r8() {
    uint32_t value;
    __asm__("mov %0, r8" : "=r" (value));
    return value;
}


extern int recording_flag;
extern int recording_cnt;
// extern int ret_recording_finish;

int ringbuffer_init_flag = 0;





void c_direct_tsf_recording(uint32_t next_ist_to_source){
	
	if(!ringbuffer_init_flag){
		ringbuffer_init_flag = 1;
		// atomic_init(&ringBuffer.head, 0);
		// atomic_init(&ringBuffer.tail, 0);
		ringbuffer_init(&ringBuffer);
	}

	//read value in r8
	uint32_t r8_value = read_r8();
	//store the value in the ring buffer

	Element elem;
	elem.srcAddr = next_ist_to_source + 8;
	elem.destAddr = r8_value;
	elem.Type = 10;

	//jinwen write this for debug
	if(recording_flag){

		//jinwenTODO: modify this to check whether source and destination
		//is in critical compartment memory space
		if(r8_value >= 0x4000000 || next_ist_to_source >= 0x4000000){
			#ifdef DBG
			printf("c_direct_tsf_recording---dest:0x%x--src:0x%x---\n", r8_value, next_ist_to_source);
			#endif
			if(!push(&ringBuffer, elem)){
				printf("buffer is full\n");
			}
		}
	}	

	//jinwen write this for debug
	return;

	if(!push(&ringBuffer, elem)){
		printf("buffer is full\n");
	}

	return;
}


#define CPSR_N_FLAG (1U << 31)
#define CPSR_Z_FLAG (1U << 30)
#define CPSR_C_FLAG (1U << 29)
#define CPSR_V_FLAG (1U << 28)

enum CondCodes {
    EQ, NE, HS, LO, MI, PL, VS, VC, HI, LS, GE, LT, GT, LE, AL
};

bool isBranchTaken(enum CondCodes cond, uint32_t cpsr) {
    bool N = cpsr & CPSR_N_FLAG;
    bool Z = cpsr & CPSR_Z_FLAG;
    bool C = cpsr & CPSR_C_FLAG;
    bool V = cpsr & CPSR_V_FLAG;

    switch (cond) {
        case EQ: return Z;
        case NE: return !Z;
        case HS: return C;
        case LO: return !C;
        case MI: return N;
        case PL: return !N;
        case VS: return V;
        case VC: return !V;
        case HI: return C && !Z;
        case LS: return !C || Z;
        case GE: return N == V;
        case LT: return N != V;
        case GT: return !Z && (N == V);
        case LE: return Z || (N != V);
        case AL: return true;
        default: return false;
    }
}


//blc
void c_direct_tsf_cc_recording(uint32_t next_ist_to_source, uint32_t cpsr, uint32_t cond_type){

	if(!ringbuffer_init_flag){
		ringbuffer_init_flag = 1;
		// atomic_init(&ringBuffer.head, 0);
		// atomic_init(&ringBuffer.tail, 0);
		ringbuffer_init(&ringBuffer);
	}	

	//decide whether conditional cpt tsf direct jump is taken
	bool branch_taken = isBranchTaken(cond_type, cpsr);



	//read value in r8
	uint32_t r8_value = read_r8();




	//if branch instruction is in the critical compartment
	if(next_ist_to_source >= 0x4000000){


		Element elem1;
		elem1.srcAddr = next_ist_to_source;
		elem1.destAddr = r8_value;
		elem1.cond = branch_taken;
		elem1.Type = 4;	
		if(recording_flag){
			#ifdef DBG
			printf("c_direct_tsf_cc_recording crit barnch---decision:%d\n", branch_taken);
			#endif
			if(!push(&ringBuffer, elem1)){
				printf("buffer is full\n");
			}
			//jinwenTODO, there should be a return to avoid redoring direct jump in critical compartment

		}

	}
	//if the branch is not taken, just return
	else if(!branch_taken){
		// printf("not taken\n");
		return;
	}
	// printf("taken\n");




	//store the value in the ring buffer

	Element elem;
	elem.srcAddr = next_ist_to_source;
	elem.destAddr = r8_value;
	elem.cond = cpsr;
	elem.Type = 10;		

	//jinwen write this for debug
	if(recording_flag){

		//jinwenTODO: modify this to check whether source and destination
		//is in critical compartment memory space
		if(r8_value >= 0x4000000 || next_ist_to_source >= 0x4000000){
			#ifdef DBG
			printf("c_direct_tsf_cc_recording---dest:0x%x--src:0x%x---\n", r8_value, next_ist_to_source);
			#endif
			if(!push(&ringBuffer, elem)){
				printf("buffer is full\n");
			}
		}
	}	

	return;
}


void c_direct_tsf_bcc_recording(uint32_t next_ist_to_source, uint32_t cpsr, uint32_t cond_type){

	if(!ringbuffer_init_flag){
		ringbuffer_init_flag = 1;
		// atomic_init(&ringBuffer.head, 0);
		// atomic_init(&ringBuffer.tail, 0);
		ringbuffer_init(&ringBuffer);
	}	

	//decide whether conditional cpt tsf direct jump is taken
	bool branch_taken = isBranchTaken(cond_type, cpsr);


	//read value in r8
	uint32_t r8_value = read_r8();


	//if branch instruction is in the critical compartment
	if(next_ist_to_source >= 0x4000000 && r8_value == 100){


		Element elem1;
		elem1.srcAddr = next_ist_to_source;
		elem1.destAddr = r8_value;
		elem1.cond = branch_taken;
		elem1.Type = 4;	
		if(recording_flag){
			#ifdef DBG
			printf("c_direct_tsf_cc_recording crit barnch---decision:%d\n", branch_taken);
			#endif
			if(!push(&ringBuffer, elem1)){
				printf("buffer is full\n");
			}
			//jinwenTODO, there should be a return to avoid redoring direct jump in critical compartment
			// return;
		}

	}
	//if the branch is not taken, just return
	else if(!branch_taken){
		// printf("not taken\n");
		return;
	}
	// printf("taken\n");


	//store the value in the ring buffer

	Element elem;
	elem.srcAddr = next_ist_to_source;
	elem.destAddr = r8_value;
	elem.cond = cpsr;
	elem.Type = 10;		

	//jinwen write this for debug
	if(recording_flag){

		//jinwenTODO: modify this to check whether source and destination
		//is in critical compartment memory space
		if(r8_value >= 0x4000000 || next_ist_to_source >= 0x4000000){
			#ifdef DBG
			printf("c_direct_tsf_cc_recording---dest:0x%x--src:0x%x---\n", r8_value, next_ist_to_source);
			#endif
			if(!push(&ringBuffer, elem)){
				printf("buffer is full\n");
			}
		}
	}	

	return;
}



void c_indirect_tsf_recording(uint32_t next_ist_to_source){
	
	if(!ringbuffer_init_flag){
		ringbuffer_init_flag = 1;
		// atomic_init(&ringBuffer.head, 0);
		// atomic_init(&ringBuffer.tail, 0);
		ringbuffer_init(&ringBuffer);
	}

	//read value in r8
	uint32_t r8_value = read_r8();
	//store the value in the ring buffer

	Element elem;
	elem.srcAddr = next_ist_to_source;
	elem.destAddr = r8_value;
	elem.Type = 10;

	//jinwen write this for debug
	if(recording_flag){

		//jinwenTODO: modify this to check whether source and destination
		//is in critical compartment memory space
		if((r8_value >= 0x4000000 && next_ist_to_source < 0x4000000)|| \
		(r8_value < 0x4000000 && next_ist_to_source >= 0x4000000)){
			#ifdef DBG			
			printf("c_indirect_tsf_recording---dest:0x%x--src:0x%x---\n", r8_value, next_ist_to_source);
			#endif
			if(!push(&ringBuffer, elem)){
				printf("buffer is full\n");
			}

		}

	}

	//jinwen write this for debug
	return;

	if(!push(&ringBuffer, elem)){
		printf("buffer is full\n");
	}

	return;

}

//cpt tsf using bx lr
//jinwenTODO this code is not called conditional branch
void c_tsf_bx_lr_recording(uint32_t next_ist_to_source){
	// return;

	if(!ringbuffer_init_flag){
		ringbuffer_init_flag = 1;
		// atomic_init(&ringBuffer.head, 0);
		// atomic_init(&ringBuffer.tail, 0);
		ringbuffer_init(&ringBuffer);
	}

	//read value in r8, this is destintaion
	uint32_t r8_value = read_r8();
	//store the value in the ring buffer

	Element elem;
	elem.srcAddr = next_ist_to_source;
	elem.destAddr = r8_value;
	// elem.Type = 3;

	//jinwen write this for debug
	if(recording_flag){

		//jinwenTODO: modify this to check whether source and destination
		//is in critical compartment memory space
		//return from critical compartment to non critical compartment
		if(r8_value < 0x4000000 && next_ist_to_source >= 0x4000000){			
			elem.Type = 3;
			#ifdef DBG
			printf("c_tsf_bx_lr_recording inter---dest:0x%x--src:0x%x---\n", r8_value, next_ist_to_source);
			#endif
			if(!push(&ringBuffer, elem)){
				printf("buffer is full\n");
			}
		}

		//return from non critical compartment to critical compartment
		if(r8_value >= 0x4000000 && next_ist_to_source < 0x4000000){			
			elem.Type = 10;	
			#ifdef DBG		
			printf("c_tsf_bx_lr_recording intra---dest:0x%x--src:0x%x---\n", r8_value, next_ist_to_source);
			#endif
			if(!push(&ringBuffer, elem)){
				printf("buffer is full\n");
			}
		}		

	}
	return;
}


void c_tsf_pop_pc_recording(uint32_t next_ist_to_source){

	if(!ringbuffer_init_flag){
		ringbuffer_init_flag = 1;
		// atomic_init(&ringBuffer.head, 0);
		// atomic_init(&ringBuffer.tail, 0);
		ringbuffer_init(&ringBuffer);
	}

	//read value in r8, this is destintaion
	uint32_t r8_value = read_r8();
	//store the value in the ring buffer

	Element elem;
	elem.srcAddr = next_ist_to_source;
	elem.destAddr = r8_value;
	// elem.Type = 3;	

	//jinwen write this for debug
	if(recording_flag){

		//jinwenTODO: modify this to check whether source and destination
		//is in critical compartment memory space
		//return from critical compartment to non critical compartment
		if(r8_value < 0x4000000 && next_ist_to_source >= 0x4000000){			
			elem.Type = 3;
			#ifdef DBG
			printf("pop_pc inter c->nc---dest:0x%x--src:0x%x---\n", r8_value, next_ist_to_source);
			#endif
			if(!push(&ringBuffer, elem)){
				printf("buffer is full\n");
			}

			// ele.Type
			//jinwenTODO, redording c->nc return

		}

		//return from non critical compartment to critical compartment
		if(r8_value >= 0x4000000 && next_ist_to_source < 0x4000000){			
			elem.Type = 10;	
			#ifdef DBG		
			printf("pop pc inter nc->c---dest:0x%x--src:0x%x---\n", r8_value, next_ist_to_source);
			#endif
			if(!push(&ringBuffer, elem)){
				printf("buffer is full\n");
			}
		}

		//return from  critical compartment to critical compartment
		if(r8_value >= 0x4000000 && next_ist_to_source >= 0x4000000){			
			elem.Type = 3;	
			#ifdef DBG		
			printf("pop pc intra---dest:0x%x--src:0x%x---\n", r8_value, next_ist_to_source);
			#endif
			if(!push(&ringBuffer, elem)){
				printf("buffer is full\n");
			}
		}


	}

	return;
}

//blx in critical compartment
void cfv_icall_blx(uint32_t next_ist_to_source){


	if(!ringbuffer_init_flag){
		ringbuffer_init_flag = 1;
		// atomic_init(&ringBuffer.head, 0);
		// atomic_init(&ringBuffer.tail, 0);
		ringbuffer_init(&ringBuffer);
	}

	//read value in r8, this is destintaion
	uint32_t r8_value = read_r8();
	//store the value in the ring buffer

	Element elem;
	elem.srcAddr = next_ist_to_source;
	elem.destAddr = r8_value;


	//jinwen write this for debug
	if(recording_flag){

	// printf("0000000000000000000\n");

		//check whether blx is compartment transfer
		if(r8_value < 0x4000000 && next_ist_to_source >= 0x4000000){			
			//storing cpt tsf info
			elem.Type = 10;
			#ifdef DBG
			printf("cfv_icall_blx inter ---dest:0x%x--src:0x%x-type:%d--\n", r8_value, next_ist_to_source, elem.Type);
			#endif
		}
		else{
			//storing intra compartmsnt tsf info
			elem.Type = 1;	
			#ifdef DBG
			printf("cfv_icall_blx intra ---dest:0x%x--src:0x%x---\n", r8_value, next_ist_to_source);
			#endif
		}

		if(!push(&ringBuffer, elem)){
			printf("buffer is full\n");
		}
	}

	return;
}

//blxcc in critical compartment
//this code doesn't be triggerd in example
void cfv_icall_blx_pre(uint32_t next_ist_to_source, uint32_t cpsr, uint32_t cond_type){

	//decide whether conditional cpt tsf direct jump is taken
	bool branch_taken = isBranchTaken(cond_type, cpsr);

	//read value in r8
	uint32_t r8_value = read_r8();
	//store the value in the ring buffer

	Element elem;
	elem.srcAddr = next_ist_to_source;
	elem.destAddr = branch_taken;
	elem.cond = cpsr;
	elem.Type = 4;	

	if(recording_flag){

		//saving branch decision
		if(!push(&ringBuffer, elem)){
			printf("buffer is full\n");
		}

		//inter cpt tsf crit->non-crit
		if(r8_value < 0x4000000 && next_ist_to_source >= 0x4000000){			

			//recording cpt tsf if branch is taken
			if(branch_taken){
				elem.Type = 10;	
				elem.destAddr = r8_value;
				#ifdef DBG
				printf("cfv_icall_blx_pre inter---dest:0x%x--src:0x%x-type:%d--\n", r8_value, next_ist_to_source, elem.Type);
				#endif
				if(!push(&ringBuffer, elem)){
					printf("buffer is full\n");
				}
			}
			//return if branch is not taken
			else{
				return;
			}

		}

		//intra cpt tsf
		if(r8_value >= 0x4000000 || next_ist_to_source >= 0x4000000){
		
			//recording indirect jump target in critical compartment
			if(branch_taken){
				elem.Type = 1;	
				elem.destAddr = r8_value;
				#ifdef DBG
				printf("cfv_icall_blx_pre intra---dest:0x%x--src:0x%x-type:%d--\n", r8_value, next_ist_to_source, elem.Type);
				#endif
				if(!push(&ringBuffer, elem)){
					printf("buffer is full\n");
				}
			}
			else{
				return;
			}

		}
	}

}

void cfv_icall_bc_blc(uint32_t next_ist_to_source, uint32_t cpsr, uint32_t cond_type){

	if(!ringbuffer_init_flag){
		ringbuffer_init_flag = 1;
		// atomic_init(&ringBuffer.head, 0);
		// atomic_init(&ringBuffer.tail, 0);
		ringbuffer_init(&ringBuffer);
	}	

	bool branch_taken = isBranchTaken(cond_type, cpsr);

	Element elem;
	elem.srcAddr = next_ist_to_source;
	elem.destAddr = branch_taken;
	elem.cond = cpsr;
	elem.Type = 4;	

	if(recording_flag){
		#ifdef DBG
		printf("ccfv_icall_bc_blc ---branch:0x%x--src:0x%x-type:%d--\n", branch_taken, elem.Type);
		#endif
		//saving branch decision
		if(!push(&ringBuffer, elem)){
			printf("buffer is full\n");
		}


	}

	return;

}


void cfv_icall_ldmia_ret(uint32_t next_ist_to_source, uint32_t cpsr, uint32_t cond_type){

	if(!ringbuffer_init_flag){
		ringbuffer_init_flag = 1;
		// atomic_init(&ringBuffer.head, 0);
		// atomic_init(&ringBuffer.tail, 0);
		ringbuffer_init(&ringBuffer);
	}	

	uint32_t r8_value = read_r8();

	Element elem;
	elem.srcAddr = next_ist_to_source;
	elem.destAddr = r8_value;
	elem.cond = cpsr;
	elem.Type = 3;	

	if(recording_flag){
		// printf("!!!!!!!!!!!!!!!!fwd_indirect_tsf works\n");
		#ifdef DBG
		printf("cfv_icall_ldmia_ret ---des:0x%x--src:0x%x-type:%d--\n", r8_value, next_ist_to_source, elem.Type);
		#endif
		//saving branch decision
		if(!push(&ringBuffer, elem)){
			printf("buffer is full\n");
		}

	}

	return;
}


int current_cpt_id;
//return 0 if successful
int ict_checking(int target){
	//checking
	//recording
	// printf("---------input is 0x%x----------", target);
	return 0;
}

void error_found(){
	printf("!!!!!!!!!!!!!!!!PANIC!!!!!!!!!!!!!!!!\n");
	
}

int cnt = 0;


void test_fwd_indirect_tsf(){
	// printf("fwd_indirect_tsf works\n");

	if(recording_flag){
		printf("!!!!!!!!!!!!!!!!fwd_indirect_tsf works\n");

	}

}

// void __AMI_fake_direct_transfer(){
// 	return
// }