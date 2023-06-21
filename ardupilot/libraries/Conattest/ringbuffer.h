// ringbuffer.h
#ifndef RINGBUFFER_H
#define RINGBUFFER_H

#include <atomic>

#define BUFFER_SIZE 1024  // Change this according to your requirements

typedef struct {
    uint32_t buffer[BUFFER_SIZE];
    std::atomic<size_t> head;
    std::atomic<size_t> tail;
} RingBuffer;

bool push(RingBuffer* ringBuffer, uint32_t value);
bool pop(RingBuffer* ringBuffer, uint32_t* value);

void start_new_thread();

#endif
