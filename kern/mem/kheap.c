#include "kheap.h"

#include <inc/memlayout.h>
#include <inc/dynamic_allocator.h>
#include <kern/conc/sleeplock.h>
#include <kern/proc/user_environment.h>
#include <kern/mem/memory_manager.h>
#include "../conc/kspinlock.h"

//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

//==============================================
// [1] INITIALIZE KERNEL HEAP:
//==============================================
//Remember to initialize locks (if any)
void kheap_init()
{
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		initialize_dynamic_allocator(KERNEL_HEAP_START, KERNEL_HEAP_START + DYN_ALLOC_MAX_SIZE);
		set_kheap_strategy(KHP_PLACE_CUSTOMFIT);
		kheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
		kheapPageAllocBreak = kheapPageAllocStart;
	}
	//==================================================================================
	//==================================================================================
}

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
	int ret = alloc_page(ptr_page_directory, ROUNDDOWN((uint32)va, PAGE_SIZE), PERM_WRITEABLE, 1);
	if (ret < 0)
		panic("get_page() in kern: failed to allocate page from the kernel");
	return 0;
}

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
	unmap_frame(ptr_page_directory, ROUNDDOWN((uint32)va, PAGE_SIZE));
}

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
//===================================
// [1] ALLOCATE SPACE IN KERNEL HEAP:
//===================================
void* kmalloc(unsigned int size)
{
#if USE_KHEAP
	// [1] Block Allocator (sizes <= 2KB)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
	{
		return alloc_block(size);
	}

	// [2] Page Allocator (sizes > 2KB)
	// Align size to page boundary
	uint32 rounded_size = ROUNDUP(size, PAGE_SIZE);
	uint32 num_pages_needed = rounded_size / PAGE_SIZE;

	// Search for contiguous free pages (First Fit)
	// Start searching from kheapPageAllocStart
	uint32 found_va = 0;
	uint32 free_pages_count = 0;
	uint32* ptr_page_table = NULL;

	for (uint32 va = kheapPageAllocStart; va < KERNEL_HEAP_MAX; va += PAGE_SIZE)
	{
		// Use get_page_table from Appendix VIII to check existence
		int ret = get_page_table(ptr_page_directory, va, &ptr_page_table);

		// If table exists and entry is present, the page is used
		if (ret == TABLE_IN_MEMORY && (ptr_page_table[PTX(va)] & PERM_PRESENT))
		{
			free_pages_count = 0; // Reset counter, sequence broken
		}
		else
		{
			// Page is free
			if (free_pages_count == 0) found_va = va;

			free_pages_count++;

			if (free_pages_count == num_pages_needed) break; // Found range
		}
	}

	if (free_pages_count < num_pages_needed) return NULL; // Not enough space

	// [3] Allocation: Use helper get_page() from Appendix VIII / Given Functions
	for (uint32 i = 0; i < num_pages_needed; i++)
	{
		uint32 curr_va = found_va + (i * PAGE_SIZE);

		// get_page allocates frame and maps it.
		// Returns 0 on success, or error code.
		int ret = get_page((void*)curr_va);

		if (ret < 0) return NULL; // Allocation failed
	}

	// Update the break pointer
	if (found_va + rounded_size > kheapPageAllocBreak)
	{
		kheapPageAllocBreak = found_va + rounded_size;
	}

	return (void*)found_va;
#else
	panic("kmalloc requires USE_KHEAP");
	return NULL;
#endif
}
//=================================
// [2] FREE SPACE FROM KERNEL HEAP:
//=================================
void kfree(void* virtual_address)
{
#if USE_KHEAP
	uint32 va = (uint32)virtual_address;

	// [1] Check if address is inside Block Allocator range
	if (va >= KERNEL_HEAP_START && va < dynAllocEnd)
	{
		free_block(virtual_address);
		return;
	}

	// [2] Check if address is inside Page Allocator range
	if (va >= kheapPageAllocStart && va < KERNEL_HEAP_MAX)
	{
		uint32 curr_va = va;
		uint32* ptr_page_table = NULL;

		// Free contiguous pages until we hit a non-present page
		while (curr_va < KERNEL_HEAP_MAX)
		{
			int ret = get_page_table(ptr_page_directory, curr_va, &ptr_page_table);

			// Stop if page is not present (end of allocation)
			if (ret != TABLE_IN_MEMORY || !(ptr_page_table[PTX(curr_va)] & PERM_PRESENT))
			{
				break;
			}

			// Use helper return_page() from Appendix VIII / Given Functions
			return_page((void*)curr_va);

			curr_va += PAGE_SIZE;
		}
		return;
	}

	panic("kfree() called with invalid virtual address");
#else
	panic("kfree requires USE_KHEAP");
#endif
}
//=================================
// [3] FIND VA OF GIVEN PA:
//=================================
unsigned int kheap_virtual_address(unsigned int physical_address)
{

#if USE_KHEAP
	struct FrameInfo* ptr_frame_info = to_frame_info(physical_address);
	if (ptr_frame_info->references == 0) return 0;

	if (physical_address < (KERNEL_HEAP_START - KERNEL_BASE))
	{
		return (uint32)STATIC_KERNEL_VIRTUAL_ADDRESS(physical_address);
	}

	return 0;
#else
	panic("kheap_virtual_address requires USE_KHEAP");
	return 0;
#endif
}
//=================================
// [4] FIND PA OF GIVEN VA:
//=================================
unsigned int kheap_physical_address(unsigned int virtual_address)
{

#if USE_KHEAP
	uint32* ptr_page_table = NULL;
	int ret = get_page_table(ptr_page_directory, virtual_address, &ptr_page_table);

	if (ret == TABLE_IN_MEMORY && (ptr_page_table[PTX(virtual_address)] & PERM_PRESENT))
	{
		uint32 frame_num = ptr_page_table[PTX(virtual_address)] >> 12;
		uint32 physical_addr = (frame_num * PAGE_SIZE) + (virtual_address & 0xFFF);
		return physical_addr;
	}

	return 0;
#else
	panic("kheap_physical_address requires USE_KHEAP");
	return 0;
#endif
}
//=================================================================================//
//============================== BONUS FUNCTION ===================================//
//=================================================================================//
// krealloc():

//	Attempts to resize the allocated space at "virtual_address" to "new_size" bytes,
//	possibly moving it in the heap.
//	If successful, returns the new virtual_address, in which case the old virtual_address must no longer be accessed.
//	On failure, returns a null pointer, and the old virtual_address remains valid.

//	A call with virtual_address = null is equivalent to kmalloc().
//	A call with new_size = zero is equivalent to kfree().

extern __inline__ uint32 get_block_size(void* va);

void* krealloc(void* virtual_address, uint32 new_size)
{
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - krealloc
	//Your code is here
	//Comment the following line
	panic("krealloc() is not implemented yet...!!");
}
