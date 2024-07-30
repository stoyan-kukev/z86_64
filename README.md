General things that would make working with x86_64 easier, safer and/or more convienient.

---
## Roadmap

1. CPU Identification and Feature Detection
  - [ ] Implement CPUID instruction wrapper
  - [ ] Create structures for various CPUID leaves
  - [ ] Detect CPU vendor, family, model, stepping
  - [ ] Identify supported CPU features (e.g., SSE, AVX, TSX, VMX)

2. Register Operations
  - [ ] Implement functions to read/write general purpose registers
  - [ ] Add support for reading/writing segment registers
  - [ ] Create functions for accessing control registers (CR0, CR2, CR3, CR4, CR8)
  - [ ] Implement EFLAGS register manipulation

3. Memory Management Structures
  - [ ] Define page table entry structures
  - [ ] Create structures for GDT (Global Descriptor Table)
  - [ ] Implement structures for LDT (Local Descriptor Table)
  - [ ] Define TSS (Task State Segment) structure

4. Interrupt and Exception Handling Structures
  - [ ] Define IDT (Interrupt Descriptor Table) structure
  - [ ] Create interrupt gate and trap gate descriptors

5. Model Specific Registers (MSRs)
  - [ ] Implement functions to read/write MSRs
  - [ ] Define constants for common MSRs
  - [ ] Create structures for complex MSRs (e.g., IA32_EFER, IA32_APIC_BASE)

6. I/O Operations
  - [ ] Implement port I/O functions (inb, outb, inw, outw, inl, outl)
    - (Maybe use comptime for generic in out functions?)
  - [ ] Add MMIO (Memory-Mapped I/O) helper functions

7. CPU State and Context
  - [ ] Define structure for complete CPU context (for context switching)
  - [ ] Implement functions to save/restore CPU state

8. Extended Instruction Set Support
  - [ ] Add inline assembly wrappers for SSE instructions
  - [ ] Implement AVX instruction wrappers
  - [ ] Create helpers for other extended instruction sets (e.g., BMI, FMA)

9. Segmentation
  - [ ] Implement functions to create segment descriptors
  - [ ] Add helpers for segment selector manipulation

10. Paging and Address Translation
  - [ ] Implement functions for address translation (virtual to physical)
  - [ ] Add support for different paging modes (32-bit, PAE, IA-32e)
  - [ ] Create helpers for page table manipulation

11. CPU Modes and Sub-modes
  - [ ] Implement functions to switch between long mode and compatibility mode
  - [ ] Add support for switching between CPL (Current Privilege Level) rings

12. APIC (Advanced Programmable Interrupt Controller) Structures
  - [ ] Define structures for xAPIC registers
  - [ ] Implement structures for x2APIC

13. Atomic Operations
  - [ ] Implement atomic compare-and-swap
  - [ ] Add support for other atomic operations (add, sub, and, or, xor)

14. System Instructions
  - [ ] Implement wrappers for SYSCALL/SYSRET instructions
  - [ ] Add support for SYSENTER/SYSEXIT instructions
  - [ ] Implement MONITOR/MWAIT instruction wrappers

15. Time and High-precision Event Management
  - [ ] Implement TSC (Time Stamp Counter) related functions
  - [ ] Add RDTSC and RDTSCP instruction wrappers

16. Virtualization Extensions
  - [ ] Define structures for VMCS (Virtual Machine Control Structure)
  - [ ] Implement basic VMX operation wrappers

17. Security Features
  - [ ] Add support for SMAP (Supervisor Mode Access Prevention)
  - [ ] Implement SMEP (Supervisor Mode Execution Prevention) helpers

18. Cache Management
  - [ ] Implement cache line flush operations
  - [ ] Add support for cache control instructions (e.g., PREFETCH)

19. Debugging and Performance Monitoring
  - [ ] Define structures for debug registers
  - [ ] Implement helpers for hardware breakpoints
  - [ ] Add support for performance monitoring counters

20. Low-level Synchronization Primitives
  - [ ] Implement PAUSE instruction wrapper
  - [ ] Add support for LOCK prefix in relevant instructions

21. SIMD and Vector Operations
  - [ ] Create helper functions for SIMD register state management
  - [ ] Implement wrappers for common SIMD operations
