#ifndef HARDWARE_H
#define HARDWARE_H 1

#include <stddef.h>
#include <stdbool.h>
#include <stdint.h>

// port I/O
uint8_t ports_inb (uint16_t port);
void ports_outb (uint16_t port, uint8_t data);
uint16_t ports_inw (uint16_t port);
void ports_outw (uint16_t port, uint16_t data);
uint32_t ports_inl(uint16_t port);
void ports_outl(uint16_t port, uint32_t data);
void io_wait(void);

// this is for memory access
uint32_t farpeekl(uint16_t sel, void* off);
void farpokeb(uint16_t sel, void* off, uint8_t v);

// for cpu
void cpu_relax(void);
void cpuid(int code, uint32_t *a, uint32_t *d);
int cpu_string(int code, uint32_t where[4]);

/* the following reads the value of the 32-bit Control Registers 0-8  on a computer's CPU.
    then returns a 32-bit unsigned integer (uint32_t)
*/

// FYI: read_cr1, read_cr5, read_cr6, read_cr7 are reserved and will raise an invalid OP exception
uint64_t rdtsc(void);
uint32_t read_cr0(void);
uint32_t read_cr1(void);	
uint32_t read_cr2(void);
uint32_t read_cr3(void);
uint32_t read_cr4(void);
uint32_t read_cr5(void);
uint32_t read_cr6(void);	
uint32_t read_cr7(void);	
uint32_t read_cr8(void);
void wrmsr(uint32_t msr, uint32_t lo, uint32_t hi);
void rdmsr(uint32_t msr, uint32_t *lo, uint32_t *hi);
void invlpg(void* m);

#endif // hardware_h_included