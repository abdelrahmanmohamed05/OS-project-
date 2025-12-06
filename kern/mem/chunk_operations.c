/*
 * chunk_operations.c
 *
 *  Created on: Oct 12, 2022
 *      Author: HP
 */

#include <kern/trap/fault_handler.h>
#include <kern/disk/pagefile_manager.h>
#include <kern/proc/user_environment.h>
#include "working_set_manager.h"
#include "kheap.h"
#include "memory_manager.h"
#include <inc/queue.h>

//extern void inctst();

/******************************/
/*[1] RAM CHUNKS MANIPULATION */
/******************************/

//===============================
// 1) CUT-PASTE PAGES IN RAM:
//===============================
//This function should cut-paste the given number of pages from source_va to dest_va on the given page_directory
//	If the page table at any destination page in the range is not exist, it should create it
//	If ANY of the destination pages exists, deny the entire process and return -1. Otherwise, cut-paste the number of pages and return 0
//	ALL 12 permission bits of the destination should be TYPICAL to those of the source
//	The given addresses may be not aligned on 4 KB
int cut_paste_pages(uint32* page_directory, uint32 source_va, uint32 dest_va, uint32 num_of_pages)
{
	uint32 src = ROUNDDOWN(source_va, PAGE_SIZE);
	uint32 dst = ROUNDDOWN(dest_va, PAGE_SIZE);
	for (uint32 i = 0; i < num_of_pages; ++i)
	{
		uint32 dva = dst + i*PAGE_SIZE;
		uint32* dpt = NULL;
		int dr = get_page_table(page_directory, dva, &dpt);
		if (dr == TABLE_IN_MEMORY && dpt != NULL)
		{
			if ((dpt[PTX(dva)] & PERM_PRESENT) == PERM_PRESENT)
				return -1;
		}
	}
	for (uint32 i = 0; i < num_of_pages; ++i)
	{
		uint32 sva = src + i*PAGE_SIZE;
		uint32 dva = dst + i*PAGE_SIZE;
		uint32* spt = NULL;
		if (get_page_table(page_directory, sva, &spt) != TABLE_IN_MEMORY || spt == NULL)
			return -1;
		uint32 spte = spt[PTX(sva)];
		if ((spte & PERM_PRESENT) != PERM_PRESENT)
			return -1;
        struct FrameInfo* fi = get_frame_info(page_directory, sva, &spt);
		if (fi == NULL)
			return -1;
		uint32 perms = spte & 0xFFF;
		uint32* dpt = NULL;
		if (get_page_table(page_directory, dva, &dpt) == TABLE_NOT_EXIST)
			dpt = create_page_table(page_directory, dva);
		map_frame(page_directory, fi, dva, perms);
		unmap_frame(page_directory, sva);
	}
	tlbflush();
	return 0;
}

//===============================
// 2) COPY-PASTE RANGE IN RAM:
//===============================
//This function should copy-paste the given size from source_va to dest_va on the given page_directory
//	Ranges DO NOT overlapped.
//	If ANY of the destination pages exists with READ ONLY permission, deny the entire process and return -1.
//	If the page table at any destination page in the range is not exist, it should create it
//	If ANY of the destination pages doesn't exist, create it with the following permissions then copy.
//	Otherwise, just copy!
//		1. WRITABLE permission
//		2. USER/SUPERVISOR permission must be SAME as the one of the source
//	The given range(s) may be not aligned on 4 KB
int copy_paste_chunk(uint32* page_directory, uint32 source_va, uint32 dest_va, uint32 size)
{
	uint32 sva = ROUNDDOWN(source_va, PAGE_SIZE);
	uint32 eva = ROUNDUP(source_va + size, PAGE_SIZE);
	uint32 dva = ROUNDDOWN(dest_va, PAGE_SIZE);
	uint32 pages = (eva - sva) / PAGE_SIZE;
	for (uint32 i = 0; i < pages; ++i)
	{
		uint32 daddr = dva + i*PAGE_SIZE;
		uint32* dpt = NULL;
		int dr = get_page_table(page_directory, daddr, &dpt);
		if (dr == TABLE_IN_MEMORY && dpt != NULL)
		{
			uint32 dpte = dpt[PTX(daddr)];
			if ((dpte & PERM_PRESENT) == PERM_PRESENT && (dpte & PERM_WRITEABLE) == 0)
				return -1;
		}
	}
	for (uint32 i = 0; i < pages; ++i)
	{
		uint32 saddr = sva + i*PAGE_SIZE;
		uint32 daddr = dva + i*PAGE_SIZE;
		uint32* spt = NULL; get_page_table(page_directory, saddr, &spt);
		uint32* dpt = NULL; if (get_page_table(page_directory, daddr, &dpt) == TABLE_NOT_EXIST) dpt = create_page_table(page_directory, daddr);
        struct FrameInfo* sfi = get_frame_info(page_directory, saddr, &spt);
		if (sfi == NULL)
			return -1;
		uint32 spermsUser = spt ? (spt[PTX(saddr)] & PERM_USER) : PERM_USER;
        struct FrameInfo* dfi = get_frame_info(page_directory, daddr, &dpt);
		if (dfi == NULL)
		{
			if (allocate_frame(&dfi) == E_NO_MEM || dfi == NULL)
				return -1;
			map_frame(page_directory, dfi, daddr, PERM_WRITEABLE | spermsUser);
		}
		memcpy((void*)daddr, (void*)saddr, PAGE_SIZE);
	}
	return 0;
}

//===============================
// 3) SHARE RANGE IN RAM:
//===============================
//This function should share the given size from source_va to dest_va on the given page_directory
//	Ranges DO NOT overlapped.
//	It should set the permissions of the second range by the given perms
//	If ANY of the destination pages exists, deny the entire process and return -1.
//	Otherwise, share the required range and return 0
//	During the share process:
//		1. If the page table at any destination page in the range is not exist, it should create it
//	The given range(s) may be not aligned on 4 KB
int share_chunk(uint32* page_directory, uint32 source_va,uint32 dest_va, uint32 size, uint32 perms)
{
	uint32 sva = ROUNDDOWN(source_va, PAGE_SIZE);
	uint32 eva = ROUNDUP(source_va + size, PAGE_SIZE);
	uint32 dva = ROUNDDOWN(dest_va, PAGE_SIZE);
	uint32 pages = (eva - sva) / PAGE_SIZE;
	for (uint32 i = 0; i < pages; ++i)
	{
		uint32 daddr = dva + i*PAGE_SIZE;
		uint32* dpt = NULL;
		int dr = get_page_table(page_directory, daddr, &dpt);
		if (dr == TABLE_IN_MEMORY && dpt != NULL)
		{
			if ((dpt[PTX(daddr)] & PERM_PRESENT) == PERM_PRESENT)
				return -1;
		}
	}
	for (uint32 i = 0; i < pages; ++i)
	{
		uint32 saddr = sva + i*PAGE_SIZE;
		uint32 daddr = dva + i*PAGE_SIZE;
        uint32* spt = NULL;
        struct FrameInfo* fi = get_frame_info(page_directory, saddr, &spt);
		if (fi == NULL)
			return -1;
		uint32* dpt = NULL; if (get_page_table(page_directory, daddr, &dpt) == TABLE_NOT_EXIST) dpt = create_page_table(page_directory, daddr);
		map_frame(page_directory, fi, daddr, perms);
	}
	return 0;
}

//===============================
// 4) ALLOCATE CHUNK IN RAM:
//===============================
//This function should allocate the given virtual range [<va>, <va> + <size>) in the given address space  <page_directory> with the given permissions <perms>.
//	If ANY of the destination pages exists, deny the entire process and return -1. Otherwise, allocate the required range and return 0
//	If the page table at any destination page in the range is not exist, it should create it
//	Allocation should be aligned on page boundary. However, the given range may be not aligned.
int allocate_chunk(uint32* page_directory, uint32 va, uint32 size, uint32 perms)
{
	uint32 sva = ROUNDDOWN(va, PAGE_SIZE);
	uint32 eva = ROUNDUP(va + size, PAGE_SIZE);
	for (uint32 addr = sva; addr < eva; addr += PAGE_SIZE)
	{
		uint32* pt = NULL;
		int r = get_page_table(page_directory, addr, &pt);
		if (r == TABLE_IN_MEMORY && pt != NULL)
		{
			if ((pt[PTX(addr)] & PERM_PRESENT) == PERM_PRESENT)
				return -1;
		}
	}
	for (uint32 addr = sva; addr < eva; addr += PAGE_SIZE)
	{
		uint32* pt = NULL; if (get_page_table(page_directory, addr, &pt) == TABLE_NOT_EXIST) pt = create_page_table(page_directory, addr);
		struct FrameInfo* fi = NULL;
		if (allocate_frame(&fi) == E_NO_MEM || fi == NULL)
			return -1;
		map_frame(page_directory, fi, addr, perms);
	}
	return 0;
}


//=====================================
// 5) CALCULATE FREE SPACE:
//=====================================
//It should count the number of free pages in the given range [va1, va2)
//(i.e. number of pages that are not mapped).
//Addresses may not be aligned on page boundaries
uint32 calculate_free_space(uint32* page_directory, uint32 sva, uint32 eva)
{
	uint32 start = ROUNDDOWN(sva, PAGE_SIZE);
	uint32 end = ROUNDUP(eva, PAGE_SIZE);
	uint32 cnt = 0;
	for (uint32 addr = start; addr < end; addr += PAGE_SIZE)
	{
        uint32* pt = NULL;
        struct FrameInfo* fi = get_frame_info(page_directory, addr, &pt);
		if (fi == NULL)
			cnt++;
	}
	return cnt;
}

//=====================================
// 6) CALCULATE ALLOCATED SPACE:
//=====================================
void calculate_allocated_space(uint32* page_directory, uint32 sva, uint32 eva, uint32 *num_tables, uint32 *num_pages)
{
	uint32 start = ROUNDDOWN(sva, PAGE_SIZE);
	uint32 end = ROUNDUP(eva, PAGE_SIZE);
	uint32 tables = 0;
	uint32 pages = 0;
	int seen_pdx[NPDENTRIES] = {0};
	for (uint32 addr = start; addr < end; addr += PAGE_SIZE)
	{
		uint32* pt = NULL;
		int r = get_page_table(page_directory, addr, &pt);
		if (r == TABLE_IN_MEMORY && pt != NULL)
		{
			int pdx = PDX(addr);
			if (!seen_pdx[pdx])
			{
				seen_pdx[pdx] = 1;
				tables++;
			}
			if ((pt[PTX(addr)] & PERM_PRESENT) == PERM_PRESENT)
				pages++;
		}
	}
	*num_tables = tables;
	*num_pages = pages;
}

//=====================================
// 7) CALCULATE REQUIRED FRAMES IN RAM:
//=====================================
//This function should calculate the required number of pages for allocating and mapping the given range [start va, start va + size) (either for the pages themselves or for the page tables required for mapping)
//	Pages and/or page tables that are already exist in the range SHOULD NOT be counted.
//	The given range(s) may be not aligned on 4 KB
uint32 calculate_required_frames(uint32* page_directory, uint32 sva, uint32 size)
{
	uint32 start = ROUNDDOWN(sva, PAGE_SIZE);
	uint32 end = ROUNDUP(sva + size, PAGE_SIZE);
	uint32 data_needed = 0;
	int need_table[NPDENTRIES] = {0};
	uint32 table_needed = 0;
	for (uint32 addr = start; addr < end; addr += PAGE_SIZE)
	{
		uint32* pt = NULL;
		int r = get_page_table(page_directory, addr, &pt);
		if (r == TABLE_NOT_EXIST)
		{
			int pdx = PDX(addr);
			if (!need_table[pdx])
			{
				need_table[pdx] = 1;
				table_needed++;
			}
			data_needed++;
		}
		else
		{
			if ((pt[PTX(addr)] & PERM_PRESENT) != PERM_PRESENT)
				data_needed++;
		}
	}
	return table_needed + data_needed;
}

//=================================================================================//
//===========================END RAM CHUNKS MANIPULATION ==========================//
//=================================================================================//

/*******************************/
/*[2] USER CHUNKS MANIPULATION */
/*******************************/

//======================================================
/// functions used for USER HEAP (malloc, free, ...)
//======================================================

//=====================================
/* DYNAMIC ALLOCATOR SYSTEM CALLS */
//=====================================
/*2024*/
void* sys_sbrk(int numOfPages)
{
	if (numOfPages <= 0)
		return NULL;
	return kmalloc((uint32)numOfPages * PAGE_SIZE);
}

//=====================================
// 1) ALLOCATE USER MEMORY:
//=====================================
void allocate_user_mem(struct Env* e, uint32 virtual_address, uint32 size)
{
	/*====================================*/
	/*Remove this line before start coding*/
//		inctst();
//		return;
	/*====================================*/

    uint32 sva = ROUNDDOWN(virtual_address, PAGE_SIZE);
    uint32 eva = ROUNDUP(virtual_address + size, PAGE_SIZE);
    for (uint32 va = sva; va < eva; va += PAGE_SIZE)
    {
        uint32* pt = NULL;
        int r = get_page_table(e->env_page_directory, va, &pt);
        if (r == TABLE_NOT_EXIST)
        {
            pt = create_page_table(e->env_page_directory, va);
        }
        uint32 avail = pt[PTX(va)] & PERM_AVAILABLE;
        pt[PTX(va)] = avail | PERM_UHPAGE;
    }
}

//=====================================
// 2) FREE USER MEMORY:
//=====================================
void free_user_mem(struct Env* e, uint32 virtual_address, uint32 size)
{
	/*====================================*/
	/*Remove this line before start coding*/
//		inctst();
//		return;
	/*====================================*/

    uint32 sva = ROUNDDOWN(virtual_address, PAGE_SIZE);
    uint32 eva = ROUNDUP(virtual_address + size, PAGE_SIZE);
    for (uint32 va = sva; va < eva; va += PAGE_SIZE)
    {
        uint32* pt = NULL;
        int r = get_page_table(e->env_page_directory, va, &pt);
        if (r == TABLE_IN_MEMORY && pt != NULL)
        {
            uint32 pte = pt[PTX(va)];
            uint32 avail = pte & PERM_AVAILABLE;
            avail &= ~PERM_UHPAGE;
            pt[PTX(va)] = avail;
        }
        pf_remove_env_page(e, va);
        env_page_ws_invalidate(e, va);
    }
}

//=====================================
// 4) FREE USER MEMORY (BUFFERING):
//=====================================
void __free_user_mem_with_buffering(struct Env* e, uint32 virtual_address, uint32 size)
{
	uint32 sva = ROUNDDOWN(virtual_address, PAGE_SIZE);
	uint32 eva = ROUNDUP(virtual_address + size, PAGE_SIZE);
	for (uint32 va = sva; va < eva; va += PAGE_SIZE)
	{
		uint32* pt = NULL;
		if (get_page_table(e->env_page_directory, va, &pt) == TABLE_IN_MEMORY && pt != NULL)
		{
			pt[PTX(va)] &= ~PERM_UHPAGE;
		}
		pf_remove_env_page(e, va);
		env_page_ws_invalidate(e, va);
		unmap_frame(e->env_page_directory, va);
	}
}

//=====================================
// 3) MOVE USER MEMORY:
//=====================================
void move_user_mem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
	uint32 src = ROUNDDOWN(src_virtual_address, PAGE_SIZE);
	uint32 dst = ROUNDDOWN(dst_virtual_address, PAGE_SIZE);
	uint32 pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
	for (uint32 i = 0; i < pages; ++i)
	{
		uint32 dva = dst + i*PAGE_SIZE;
		uint32* dpt = NULL;
		int dr = get_page_table(e->env_page_directory, dva, &dpt);
		if (dr == TABLE_IN_MEMORY && dpt != NULL)
		{
			if ((dpt[PTX(dva)] & PERM_PRESENT) == PERM_PRESENT)
				panic("move_user_mem: dest exists");
		}
	}
	cut_paste_pages(e->env_page_directory, src, dst, pages);
	for (uint32 i = 0; i < pages; ++i)
	{
		pf_remove_env_page(e, src + i*PAGE_SIZE);
		env_page_ws_invalidate(e, src + i*PAGE_SIZE);
	}
}

//=================================================================================//
//========================== END USER CHUNKS MANIPULATION =========================//
//=================================================================================//
