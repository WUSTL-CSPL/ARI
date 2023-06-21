// ringbuffer.h

#ifndef RINGBUFFER_H
#define RINGBUFFER_H
#include <atomic>


#ifdef __cplusplus
extern "C" {
#endif



#define BUFFER_SIZE 10000000  // Change this according to your requirements

typedef struct {
    uint32_t srcAddr;
    uint32_t destAddr;
    uint32_t cond;
    uint8_t Type;
} Element;

typedef struct {
    Element buffer[BUFFER_SIZE];
    std::atomic<size_t> head;
    std::atomic<size_t> tail;
} RingBuffer;

bool push(RingBuffer* ringBuffer, Element value);
bool pop(RingBuffer* ringBuffer, Element* value);
bool ringbuffer_init(RingBuffer* ringBuffer);
bool is_empty(RingBuffer* ringBuffer);

void start_new_thread();

void mission_control();

#endif

#ifdef __cplusplus
}
#endif 