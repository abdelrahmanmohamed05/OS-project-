/*
 * fault_handler.c
 *
 *  Created on: Oct 12, 2022
 *      Author: HP
 */

#include "trap.h"
#include <kern/proc/user_environment.h>
#include <kern/cpu/sched.h>
#include <kern/cpu/cpu.h>
#include <kern/disk/pagefile_manager.h>
#include <kern/mem/memory_manager.h>
#include <kern/mem/kheap.h>

//2014 Test Free(): Set it to bypass the PAGE FAULT on an instruction with this length and continue executing the next one
// 0 means don't bypass the PAGE FAULT
uint8 bypassInstrLength = 0;

//===============================
// REPLACEMENT STRATEGIES
//===============================
//2020
void setPageReplacmentAlgorithmLRU(int LRU_TYPE)
{
	assert(LRU_TYPE == PG_REP_LRU_TIME_APPROX || LRU_TYPE == PG_REP_LRU_LISTS_APPROX);
	_PageRepAlgoType = LRU_TYPE ;
}
void setPageReplacmentAlgorithmCLOCK(){_PageRepAlgoType = PG_REP_CLOCK;}
void setPageReplacmentAlgorithmFIFO(){_PageRepAlgoType = PG_REP_FIFO;}
void setPageReplacmentAlgorithmModifiedCLOCK(){_PageRepAlgoType = PG_REP_MODIFIEDCLOCK;}
/*2018*/ void setPageReplacmentAlgorithmDynamicLocal(){_PageRepAlgoType = PG_REP_DYNAMIC_LOCAL;}
/*2021*/ void setPageReplacmentAlgorithmNchanceCLOCK(int PageWSMaxSweeps){_PageRepAlgoType = PG_REP_NchanceCLOCK;  page_WS_max_sweeps = PageWSMaxSweeps;}
/*2024*/ void setFASTNchanceCLOCK(bool fast){ FASTNchanceCLOCK = fast; };
/*2025*/ void setPageReplacmentAlgorithmOPTIMAL(){ _PageRepAlgoType = PG_REP_OPTIMAL; };

//2020
uint32 isPageReplacmentAlgorithmLRU(int LRU_TYPE){return _PageRepAlgoType == LRU_TYPE ? 1 : 0;}
uint32 isPageReplacmentAlgorithmCLOCK(){if(_PageRepAlgoType == PG_REP_CLOCK) return 1; return 0;}
uint32 isPageReplacmentAlgorithmFIFO(){if(_PageRepAlgoType == PG_REP_FIFO) return 1; return 0;}
uint32 isPageReplacmentAlgorithmModifiedCLOCK(){if(_PageRepAlgoType == PG_REP_MODIFIEDCLOCK) return 1; return 0;}
/*2018*/ uint32 isPageReplacmentAlgorithmDynamicLocal(){if(_PageRepAlgoType == PG_REP_DYNAMIC_LOCAL) return 1; return 0;}
/*2021*/ uint32 isPageReplacmentAlgorithmNchanceCLOCK(){if(_PageRepAlgoType == PG_REP_NchanceCLOCK) return 1; return 0;}
/*2021*/ uint32 isPageReplacmentAlgorithmOPTIMAL(){if(_PageRepAlgoType == PG_REP_OPTIMAL) return 1; return 0;}

//===============================
// PAGE BUFFERING
//===============================
void enableModifiedBuffer(uint32 enableIt){_EnableModifiedBuffer = enableIt;}
uint8 isModifiedBufferEnabled(){  return _EnableModifiedBuffer ; }

void enableBuffering(uint32 enableIt){_EnableBuffering = enableIt;}
uint8 isBufferingEnabled(){  return _EnableBuffering ; }

void setModifiedBufferLength(uint32 length) { _ModifiedBufferLength = length;}
uint32 getModifiedBufferLength() { return _ModifiedBufferLength;}

//===============================
// FAULT HANDLERS
//===============================

//==================
// [0] INIT HANDLER:
//==================
void fault_handler_init()
{
	//setPageReplacmentAlgorithmLRU(PG_REP_LRU_TIME_APPROX);
	//setPageReplacmentAlgorithmOPTIMAL();
	setPageReplacmentAlgorithmCLOCK();
	//setPageReplacmentAlgorithmModifiedCLOCK();
	enableBuffering(0);
	enableModifiedBuffer(0) ;
	setModifiedBufferLength(1000);
}
//==================
// [1] MAIN HANDLER:
//==================
/*2022*/
uint32 last_eip = 0;
uint32 before_last_eip = 0;
uint32 last_fault_va = 0;
uint32 before_last_fault_va = 0;
int8 num_repeated_fault  = 0;
extern uint32 sys_calculate_free_frames() ;

struct Env* last_faulted_env = NULL;
void fault_handler(struct Trapframe *tf)
{
	/******************************************************/
	// Read processor's CR2 register to find the faulting address
	uint32 fault_va = rcr2();
	//cprintf("************Faulted VA = %x************\n", fault_va);
	//	print_trapframe(tf);
	/******************************************************/

	//If same fault va for 3 times, then panic
	//UPDATE: 3 FAULTS MUST come from the same environment (or the kernel)
	struct Env* cur_env = get_cpu_proc();
	if (last_fault_va == fault_va && last_faulted_env == cur_env)
	{
		num_repeated_fault++ ;
		if (num_repeated_fault == 3)
		{
			print_trapframe(tf);
			panic("Failed to handle fault! fault @ at va = %x from eip = %x causes va (%x) to be faulted for 3 successive times\n", before_last_fault_va, before_last_eip, fault_va);
		}
	}
	else
	{
		before_last_fault_va = last_fault_va;
		before_last_eip = last_eip;
		num_repeated_fault = 0;
	}
	last_eip = (uint32)tf->tf_eip;
	last_fault_va = fault_va ;
	last_faulted_env = cur_env;
	/******************************************************/
	//2017: Check stack overflow for Kernel
	int userTrap = 0;
	if ((tf->tf_cs & 3) == 3) {
		userTrap = 1;
	}
	if (!userTrap)
	{
		struct cpu* c = mycpu();
		//cprintf("trap from KERNEL\n");
		if (cur_env && fault_va >= (uint32)cur_env->kstack && fault_va < (uint32)cur_env->kstack + PAGE_SIZE)
			panic("User Kernel Stack: overflow exception!");
		else if (fault_va >= (uint32)c->stack && fault_va < (uint32)c->stack + PAGE_SIZE)
			panic("Sched Kernel Stack of CPU #%d: overflow exception!", c - CPUS);
#if USE_KHEAP
		if (fault_va >= KERNEL_HEAP_MAX)
			panic("Kernel: heap overflow exception!");
#endif
	}
	//2017: Check stack underflow for User
	else
	{
		//cprintf("trap from USER\n");
		if (fault_va >= USTACKTOP && fault_va < USER_TOP)
			panic("User: stack underflow exception!");
	}

	//get a pointer to the environment that caused the fault at runtime
	//cprintf("curenv = %x\n", curenv);
	struct Env* faulted_env = cur_env;
	if (faulted_env == NULL)
	{
		cprintf("\nFaulted VA = %x\n", fault_va);
		print_trapframe(tf);
		panic("faulted env == NULL!");
	}
	//check the faulted address, is it a table or not ?
	//If the directory entry of the faulted address is NOT PRESENT then
	if ( (faulted_env->env_page_directory[PDX(fault_va)] & PERM_PRESENT) != PERM_PRESENT)
	{
		faulted_env->tableFaultsCounter ++ ;
		table_fault_handler(faulted_env, fault_va);
	}
	else
	{
		if (userTrap)
		{
			/*============================================================================================*/
			//TODO: [PROJECT'25.GM#3] FAULT HANDLER I - #2 Check for invalid pointers
			//(e.g. pointing to unmarked user heap page, kernel or wrong access rights),
			//your code is here
			// 1. Check if pointing to kernel space
			if (fault_va >= KERNEL_BASE) {
			    env_exit(faulted_env);
			    return;
			}

			// 2. Check if pointing to unmarked user heap page
			if (fault_va >= USER_HEAP_START) {
			    uint32* pte = get_pte(faulted_env->env_page_directory, (void*)fault_va, 0);
			    if (pte == NULL || (*pte & PERM_UHPAGE) == 0) {
			        env_exit(faulted_env);
			        return;
			    }
			}

			// 3. Check for wrong access rights (write to read-only page)
			uint32 error_code = tf->tf_err;
			if (error_code & FEC_WR) {
			    uint32* pte = get_pte(faulted_env->env_page_directory, (void*)fault_va, 0);
			    if (pte != NULL && (*pte & PERM_WRITEABLE) == 0) {
			        env_exit(faulted_env);
			        return;
			    }
			}

			/*============================================================================================*/
		}

		/*2022: Check if fault due to Access Rights */
		int perms = pt_get_page_permissions(faulted_env->env_page_directory, fault_va);
		if (perms & PERM_PRESENT)
			panic("Page @va=%x is exist! page fault due to violation of ACCESS RIGHTS\n", fault_va) ;
		/*============================================================================================*/


		// we have normal page fault =============================================================
		faulted_env->pageFaultsCounter ++ ;

//				cprintf("[%08s] user PAGE fault va %08x\n", faulted_env->prog_name, fault_va);
//				cprintf("\nPage working set BEFORE fault handler...\n");
//				env_page_ws_print(faulted_env);
		//int ffb = sys_calculate_free_frames();

		if(isBufferingEnabled())
		{
			__page_fault_handler_with_buffering(faulted_env, fault_va);
		}
		else
		{
			page_fault_handler(faulted_env, fault_va);
		}

		//		cprintf("\nPage working set AFTER fault handler...\n");
		//		env_page_ws_print(faulted_env);
		//		int ffa = sys_calculate_free_frames();
		//		cprintf("fault handling @%x: difference in free frames (after - before = %d)\n", fault_va, ffa - ffb);
	}

	/*************************************************************/
	//Refresh the TLB cache
	tlbflush();
	/*************************************************************/
}


//=========================
// [2] TABLE FAULT HANDLER:
//=========================
void table_fault_handler(struct Env * curenv, uint32 fault_va)
{
	//panic("table_fault_handler() is not implemented yet...!!");
	//Check if it's a stack page
	uint32* ptr_table;
#if USE_KHEAP
	{
		ptr_table = create_page_table(curenv->env_page_directory, (uint32)fault_va);
	}
#else
	{
		__static_cpt(curenv->env_page_directory, (uint32)fault_va, &ptr_table);
	}
#endif
}

//=========================
// [3] PAGE FAULT HANDLER:
//=========================
/* Calculate the number of page faults according th the OPTIMAL replacement strategy
 * Given:
 * 	1. Initial Working Set List (that the process started with)
 * 	2. Max Working Set Size
 * 	3. Page References List (contains the stream of referenced VAs till the process finished)
 *
 * 	IMPORTANT: This function SHOULD NOT change any of the given lists
 */
int get_optimal_num_faults(struct WS_List *initWorkingSet, int maxWSSize, struct PageRef_List *pageReferences)
{
	//TODO: [PROJECT'25.IM#1] FAULT HANDLER II - #2 get_optimal_num_faults
	// IMPORTANT: This function SHOULD NOT change any of the given lists
#if !USE_KHEAP
	panic("get_optimal_num_faults(): requires USE_KHEAP");
	return 0;
#else
	if (LIST_SIZE(pageReferences) == 0)
		return 0;
	uint32 numRefs = LIST_SIZE(pageReferences);
	uint32 *refs = (uint32 *)kmalloc(numRefs * sizeof(uint32));
	if (refs == NULL)
		panic("get_optimal_num_faults(): can't allocate refs array");

	uint32 r = 0;
	struct PageRefElement *refElm = NULL;
	LIST_FOREACH(refElm, pageReferences)
	{
		if (r >= numRefs)
			break;
		refs[r++] = ROUNDDOWN(refElm->virtual_address, PAGE_SIZE);
	}
	numRefs = r;
	uint32 *ws_pages = (uint32 *)kmalloc(maxWSSize * sizeof(uint32));
	uint8 *ws_valid = (uint8 *)kmalloc(maxWSSize * sizeof(uint8));
	if (ws_pages == NULL || ws_valid == NULL)
		panic("get_optimal_num_faults(): can't allocate WS arrays");
	for (int i = 0; i < maxWSSize; i++)
	{
		ws_pages[i] = 0;
		ws_valid[i] = 0;
	}
	int curSize = 0;
	struct WorkingSetElement *wse = NULL;
	LIST_FOREACH(wse, initWorkingSet)
	{
		if (curSize >= maxWSSize)
			break;
		ws_pages[curSize] = ROUNDDOWN(wse->virtual_address, PAGE_SIZE);
		ws_valid[curSize] = 1;
		curSize++;
	}
	int faults = 0;
	for (uint32 i = 0; i < numRefs; i++)
	{
		uint32 va = refs[i];
		int hit = 0;
		for (int j = 0; j < maxWSSize; j++)
		{
			if (ws_valid[j] && ws_pages[j] == va)
			{
				hit = 1;
				break;
			}
		}
		if (hit)
			continue;
		faults++;
		if (curSize < maxWSSize)
		{
			for (int j = 0; j < maxWSSize; j++)
			{
				if (!ws_valid[j])
				{
					ws_valid[j] = 1;
					ws_pages[j] = va;
					curSize++;
					break;
				}
			}
		}
		else
		{
			int victimIndex = -1;
			int farthestUse = -1;

			for (int j = 0; j < maxWSSize; j++)
			{
				uint32 pageVa = ws_pages[j];
				int nextUse = -1;
				// search for next use of this page in remaining references
				for (uint32 k = i + 1; k < numRefs; k++)
				{
					if (refs[k] == pageVa)
					{
						nextUse = (int)k;
						break;
					}
				}
				// If page is never used again, it is the best victim
				if (nextUse == -1)
				{
					victimIndex = j;
					break;
				}
	// Else, choose the one with the farthest next use
				if (nextUse > farthestUse)
				{
					farthestUse = nextUse;
					victimIndex = j;
				}
			}
			if (victimIndex < 0)
				victimIndex = 0;
			// Replace victim with the new page
			ws_pages[victimIndex] = va;
			ws_valid[victimIndex] = 1;
		}
	}
	// 4) Free temporary arrays
	kfree(refs);
	kfree(ws_pages);
	kfree(ws_valid);
	return faults;
#endif
}

void page_fault_handler(struct Env * faulted_env, uint32 fault_va)
{
#if USE_KHEAP
	struct WorkingSetElement *victimWSElement = NULL;
	uint32 wsSize = LIST_SIZE(&(faulted_env->page_WS_list));
#else
	int iWS =faulted_env->page_last_WS_index;
	uint32 wsSize = env_page_ws_get_size(faulted_env);
#endif
	if(wsSize < (faulted_env->page_WS_max_size))
	{
		//TODO: [PROJECT'25.GM#3] FAULT HANDLER I - #3 placement
		//Your code is here
		//Comment the following line
		//panic("page_fault_handler().PLACEMENT is not implemented yet...!!");
		struct Env* curenv;
		// STEP 1:
		struct FrameInfo *place_ptr=NULL;
					int result=allocate_frame(&place_ptr);
					if(result !=E_NO_MEM){
						map_frame(curenv->env_page_directory,place_ptr,fault_va,PERM_USER|PERM_WRITEABLE);
					}
					else{
						cprintf("NO_MEM");
					}
					//step_2
					int ret = pf_read_env_page(curenv,(void *)fault_va);
					if(ret ==E_PAGE_NOT_EXIST_IN_PF){
						if((fault_va>=USTACKBOTTOM && fault_va<USTACKTOP) || (fault_va>=USER_HEAP_START && fault_va<USER_HEAP_MAX))
						{

						}
						else{

							cprintf("here_4");
							sched_kill_env(curenv->env_id);

						}

					 }// if ret
					  struct WorkingSetElement *add_element=env_page_ws_list_create_element(curenv,fault_va);
					  if (add_element==NULL)
						  sched_kill_env(curenv->env_id);
					  LIST_INSERT_TAIL(&curenv->page_WS_list,add_element); //add

					  if(LIST_SIZE(&curenv->page_WS_list)<curenv->page_WS_max_size)//update
						  curenv->page_last_WS_element=NULL;
					  else{
						curenv->page_last_WS_element=LIST_FIRST(&curenv->page_WS_list);
					  }

	}
	else
	{
		if (isPageReplacmentAlgorithmOPTIMAL())
		{
			//TODO: [PROJECT'25.IM#1] FAULT HANDLER II - #1 Optimal Reference Stream
          #if USE_KHEAP
			// Allocate a new reference element and append it to the stream list
			struct PageRefElement *ref_elem = kmalloc(sizeof(struct PageRefElement));
			if (ref_elem == NULL)
			{
				panic("page_fault_handler(): Failed to allocate PageRefElement");
			}
			// Store the faulting page virtual address (page-aligned)
			ref_elem->virtual_address = ROUNDDOWN(fault_va, PAGE_SIZE);

			// Append to the tail of the reference stream list of this environment
			LIST_INSERT_TAIL(&(faulted_env->referenceStreamList), ref_elem);
          #endif
		}
		else if (isPageReplacmentAlgorithmCLOCK())
		{
			//TODO: [PROJECT'25.IM#1] FAULT HANDLER II - #3 Clock Replacement
        #if USE_KHEAP
            if (faulted_env->page_last_WS_element == NULL)
			{
				faulted_env->page_last_WS_element = LIST_FIRST(&(faulted_env->page_WS_list));
			}
			struct WorkingSetElement *hand = faulted_env->page_last_WS_element;
			if (hand == NULL)
			{
				panic("CLOCK: empty working set while wsSize is full");
			}
			struct WorkingSetElement *start = hand;

			while (1)
			{
				uint32 va = hand->virtual_address;
				int perms = pt_get_page_permissions(faulted_env->env_page_directory, va);

				if ((perms & PERM_USED) == 0)
				{
					victimWSElement = hand;
					break;
				}
				else
				{
					pt_set_page_permissions(faulted_env->env_page_directory, va, 0, PERM_USED);

					hand = LIST_NEXT(hand);
					if (hand == NULL)
						hand = LIST_FIRST(&(faulted_env->page_WS_list));
					if (hand == start)
					{
						continue;
					}
				}
			}
			uint32 victim_va = victimWSElement->virtual_address;
			int victim_perms = pt_get_page_permissions(faulted_env->env_page_directory, victim_va);
			uint32 *ptr_page_table = NULL;
			struct FrameInfo *victim_frame = get_frame_info(faulted_env->env_page_directory, victim_va, &ptr_page_table);
			if (victim_frame == NULL)
			{
				panic("CLOCK: victim frame not found");
			}

			// If modified, write it back to page file
			if (victim_perms & PERM_MODIFIED)
			{
				pf_update_env_page(faulted_env, victim_va, victim_frame);
			}
			unmap_frame(faulted_env->env_page_directory, victim_va);

			// Allocate and map a frame for the faulted page
			struct FrameInfo *new_frame = NULL;
			allocate_frame(&new_frame);
			map_frame(faulted_env->env_page_directory, new_frame, ROUNDDOWN(fault_va, PAGE_SIZE), PERM_USER | PERM_WRITEABLE);

			// Read the page from page file if it exists
			int ret = pf_read_env_page(faulted_env, (void*)ROUNDDOWN(fault_va, PAGE_SIZE));
			if (ret == E_PAGE_NOT_EXIST_IN_PF)
			{
				// New stack or heap page: add empty page in page file
				if ((fault_va >= USTACKBOTTOM && fault_va < USTACKTOP) ||
					(fault_va >= USER_HEAP_START && fault_va < USER_HEAP_MAX))
				{
					pf_add_empty_env_page(faulted_env, ROUNDDOWN(fault_va, PAGE_SIZE), 1);
				}
				else
				{
					// Invalid access: kill the environment
					sched_kill_env(faulted_env->env_id);
					return;
				}
			}
			// Reuse the victim WS element for the new page
			victimWSElement->virtual_address = ROUNDDOWN(fault_va, PAGE_SIZE);
			victimWSElement->time_stamp = 0;
			victimWSElement->sweeps_counter = 0;
		    // advance the CLOCK hand to the next element
			faulted_env->page_last_WS_element = LIST_NEXT(victimWSElement);
			if (faulted_env->page_last_WS_element == NULL)
				faulted_env->page_last_WS_element = LIST_FIRST(&(faulted_env->page_WS_list));
        #else
			panic("CLOCK replacement requires USE_KHEAP");
        #endif
		}
		else if (isPageReplacmentAlgorithmLRU(PG_REP_LRU_TIME_APPROX))
		{
			//TODO: [PROJECT'25.IM#6] FAULT HANDLER II - #2 LRU Aging Replacement
			            //Your code is here
			            //Comment the following line

		#if USE_KHEAP
		    struct WorkingSetElement *we;
		    struct WorkingSetElement *victim = NULL;
		    uint32 min_ts = (uint32)-1;

		    LIST_FOREACH(we, &faulted_env->page_WS_list, prev_next_info) {
		        if (we->empty) continue;
		        if (we->time_stamp < min_ts) {
		            min_ts = we->time_stamp;
		            victim = we;
		        }
		    }

		    if (victim == NULL) {
		        panic("LRU: no victim found while WS is full");
		    }

		    uint32 victim_va = victim->virtual_address;
		    int victim_perms = pt_get_page_permissions(faulted_env->env_page_directory, victim_va);
		    uint32 *ptr_page_table = NULL;
		    struct FrameInfo *victim_frame = get_frame_info(faulted_env->env_page_directory, victim_va, &ptr_page_table);
		    if (!victim_frame) panic("LRU: victim frame not found");


		    if (victim_perms & PERM_MODIFIED) {
		        pf_update_env_page(faulted_env, victim_va, victim_frame);
		    }

		    unmap_frame(faulted_env->env_page_directory, victim_va);


		    victim->virtual_address = ROUNDDOWN(fault_va, PAGE_SIZE);
		    victim->time_stamp = 0;
		    victim->sweeps_counter = 0;


		    faulted_env->page_last_WS_element = LIST_NEXT(victim);
		    if (faulted_env->page_last_WS_element == NULL)
		        faulted_env->page_last_WS_element = LIST_FIRST(&faulted_env->page_WS_list);


		    struct FrameInfo *new_frame = NULL;
		    if (allocate_frame(&new_frame) != E_NO_MEM) panic("LRU: allocate_frame failed");
		    map_frame(faulted_env->env_page_directory, new_frame, ROUNDDOWN(fault_va, PAGE_SIZE), PERM_USER | PERM_WRITEABLE);


		    int ret = pf_read_env_page(faulted_env, (void*)ROUNDDOWN(fault_va, PAGE_SIZE));
		    if (ret == E_PAGE_NOT_EXIST_IN_PF) {
		        if ((fault_va >= USTACKBOTTOM && fault_va < USTACKTOP) ||
		            (fault_va >= USER_HEAP_START && fault_va < USER_HEAP_MAX)) {
		            pf_add_empty_env_page(faulted_env, ROUNDDOWN(fault_va, PAGE_SIZE), 1);
		        } else {
		            sched_kill_env(faulted_env->env_id);
		            return;
		        }
		    }

		#else

		    uint32 max = faulted_env->page_WS_max_size;
		    int victim_idx = -1;
		    uint32 min_ts2 = (uint32)-1;
		    for (uint32 i = 0; i < max; ++i) {
		        struct WorkingSetElement *we2 = &faulted_env->ptr_pageWorkingSet[i];
		        if (we2->empty) continue;
		        if (we2->time_stamp < min_ts2) {
		            min_ts2 = we2->time_stamp;
		            victim_idx = (int)i;
		        }
		    }
		    if (victim_idx < 0) panic("LRU: no victim found (non-kheap)");

		    struct WorkingSetElement *victim2 = &faulted_env->ptr_pageWorkingSet[victim_idx];
		    uint32 victim_va2 = victim2->virtual_address;
		    int victim_perms2 = pt_get_page_permissions(faulted_env->env_page_directory, victim_va2);
		    uint32 *ptr_page_table2 = NULL;
		    struct FrameInfo *victim_frame2 = get_frame_info(faulted_env->env_page_directory, victim_va2, &ptr_page_table2);
		    if (!victim_frame2) panic("LRU: victim frame not found (non-kheap)");

		    if (victim_perms2 & PERM_MODIFIED) {
		        pf_update_env_page(faulted_env, victim_va2, victim_frame2);
		    }

		    unmap_frame(faulted_env->env_page_directory, victim_va2);


		    victim2->virtual_address = ROUNDDOWN(fault_va, PAGE_SIZE);
		    victim2->empty = 0;
		    victim2->time_stamp = 0;
		    victim2->sweeps_counter = 0;


		    struct FrameInfo *new_frame2 = NULL;
		    if (allocate_frame(&new_frame2) != E_NO_MEM) panic("LRU: allocate_frame failed (non-kheap)");
		    map_frame(faulted_env->env_page_directory, new_frame2, ROUNDDOWN(fault_va, PAGE_SIZE), PERM_USER | PERM_WRITEABLE);

		    int ret2 = pf_read_env_page(faulted_env, (void*)ROUNDDOWN(fault_va, PAGE_SIZE));
		    if (ret2 == E_PAGE_NOT_EXIST_IN_PF) {
		        if ((fault_va >= USTACKBOTTOM && fault_va < USTACKTOP) ||
		            (fault_va >= USER_HEAP_START && fault_va < USER_HEAP_MAX)) {
		            pf_add_empty_env_page(faulted_env, ROUNDDOWN(fault_va, PAGE_SIZE), 1);
		        } else {
		            sched_kill_env(faulted_env->env_id);
		            return;
		        }
		    }

		    faulted_env->page_last_WS_index = (victim_idx + 1) % faulted_env->page_WS_max_size;
		#endif
		}

		else if (isPageReplacmentAlgorithmModifiedCLOCK())
		{
			//TODO: [PROJECT'25.IM#6] FAULT HANDLER II - #3 Modified Clock Replacement
			            //Your code is here
			            //Comment the following line
		#if USE_KHEAP

		    if (faulted_env->page_last_WS_element == NULL)
		        faulted_env->page_last_WS_element = LIST_FIRST(&faulted_env->page_WS_list);
		    struct WorkingSetElement *hand = faulted_env->page_last_WS_element;
		    if (hand == NULL) panic("Modified Clock: empty WS while full");

		    struct WorkingSetElement *start = hand;
		    struct WorkingSetElement *victim = NULL;


		    do {
		        uint32 va = hand->virtual_address;
		        int perms = pt_get_page_permissions(faulted_env->env_page_directory, va);
		        int used = (perms & PERM_USED) ? 1 : 0;
		        int mod  = (perms & PERM_MODIFIED) ? 1 : 0;
		        if (!used && !mod) { victim = hand; break; }

		        hand = LIST_NEXT(hand);
		        if (hand == NULL) hand = LIST_FIRST(&faulted_env->page_WS_list);
		    } while (hand != start);


		    if (victim == NULL) {
		        hand = faulted_env->page_last_WS_element;
		        start = hand;
		        do {
		            uint32 va = hand->virtual_address;
		            int perms = pt_get_page_permissions(faulted_env->env_page_directory, va);
		            int used = (perms & PERM_USED) ? 1 : 0;
		            if (!used) { victim = hand; break; }

		            pt_set_page_permissions(faulted_env->env_page_directory, va, 0, PERM_USED);
		            hand = LIST_NEXT(hand);
		            if (hand == NULL) hand = LIST_FIRST(&faulted_env->page_WS_list);
		        } while (hand != start);
		    }

		    if (victim == NULL) {
		        victim = faulted_env->page_last_WS_element ? faulted_env->page_last_WS_element : LIST_FIRST(&faulted_env->page_WS_list);
		    }

		    uint32 victim_va = victim->virtual_address;
		    int victim_perms = pt_get_page_permissions(faulted_env->env_page_directory, victim_va);
		    uint32 *ptr_page_table = NULL;
		    struct FrameInfo *victim_frame = get_frame_info(faulted_env->env_page_directory, victim_va, &ptr_page_table);
		    if (!victim_frame) panic("Modified Clock: victim frame not found");

		    if (victim_perms & PERM_MODIFIED) {
		        pf_update_env_page(faulted_env, victim_va, victim_frame);
		    }

		    unmap_frame(faulted_env->env_page_directory, victim_va);


		    struct FrameInfo *new_frame = NULL;
		    if (allocate_frame(&new_frame) != E_NO_MEM) panic("Modified Clock: allocate frame failed");
		    map_frame(faulted_env->env_page_directory, new_frame, ROUNDDOWN(fault_va, PAGE_SIZE), PERM_USER | PERM_WRITEABLE);

		    int ret = pf_read_env_page(faulted_env, (void*)ROUNDDOWN(fault_va, PAGE_SIZE));
		    if (ret == E_PAGE_NOT_EXIST_IN_PF) {
		        if ((fault_va >= USTACKBOTTOM && fault_va < USTACKTOP) ||
		            (fault_va >= USER_HEAP_START && fault_va < USER_HEAP_MAX)) {
		            pf_add_empty_env_page(faulted_env, ROUNDDOWN(fault_va, PAGE_SIZE), 1);
		        } else {
		            sched_kill_env(faulted_env->env_id);
		            return;
		        }
		    }


		    victim->virtual_address = ROUNDDOWN(fault_va, PAGE_SIZE);
		    victim->time_stamp = 0;
		    victim->sweeps_counter = 0;


		    faulted_env->page_last_WS_element = LIST_NEXT(victim);
		    if (faulted_env->page_last_WS_element == NULL)
		        faulted_env->page_last_WS_element = LIST_FIRST(&faulted_env->page_WS_list);

		#else

		    uint32 max = faulted_env->page_WS_max_size;
		    uint32 start = faulted_env->page_last_WS_index % max;
		    int victim_idx = -1;


		    for (uint32 i = 0; i < max; ++i) {
		        uint32 idx = (start + i) % max;
		        struct WorkingSetElement *we = &faulted_env->ptr_pageWorkingSet[idx];
		        if (we->empty) continue;
		        int perms = pt_get_page_permissions(faulted_env->env_page_directory, we->virtual_address);
		        int used = (perms & PERM_USED) ? 1 : 0;
		        int mod  = (perms & PERM_MODIFIED) ? 1 : 0;
		        if (!used && !mod) { victim_idx = (int)idx; break; }
		    }


		    if (victim_idx < 0) {
		        for (uint32 i = 0; i < max; ++i) {
		            uint32 idx = (start + i) % max;
		            struct WorkingSetElement *we = &faulted_env->ptr_pageWorkingSet[idx];
		            if (we->empty) continue;
		            int perms = pt_get_page_permissions(faulted_env->env_page_directory, we->virtual_address);
		            int used = (perms & PERM_USED) ? 1 : 0;
		            if (!used) { victim_idx = (int)idx; break; }

		            pt_set_page_permissions(faulted_env->env_page_directory, we->virtual_address, 0, PERM_USED);
		        }
		    }

		    if (victim_idx < 0) victim_idx = (int)start;

		    struct WorkingSetElement *victim2 = &faulted_env->ptr_pageWorkingSet[victim_idx];
		    uint32 victim_va2 = victim2->virtual_address;
		    int victim_perms2 = pt_get_page_permissions(faulted_env->env_page_directory, victim_va2);
		    uint32 *ptr_page_table2 = NULL;
		    struct FrameInfo *victim_frame2 = get_frame_info(faulted_env->env_page_directory, victim_va2, &ptr_page_table2);
		    if (!victim_frame2) panic("Modified Clock: victim frame not found (non-kheap)");

		    if (victim_perms2 & PERM_MODIFIED) pf_update_env_page(faulted_env, victim_va2, victim_frame2);
		    unmap_frame(faulted_env->env_page_directory, victim_va2);


		    victim2->virtual_address = ROUNDDOWN(fault_va, PAGE_SIZE);
		    victim2->empty = 0;
		    victim2->time_stamp = 0;
		    victim2->sweeps_counter = 0;


		    struct FrameInfo *new_frame3 = NULL;
		    if (allocate_frame(&new_frame3) != E_NO_MEM) panic("Modified Clock: allocate frame failed (non-kheap)");
		    map_frame(faulted_env->env_page_directory, new_frame3, ROUNDDOWN(fault_va, PAGE_SIZE), PERM_USER | PERM_WRITEABLE);

		    int ret3 = pf_read_env_page(faulted_env, (void*)ROUNDDOWN(fault_va, PAGE_SIZE));
		    if (ret3 == E_PAGE_NOT_EXIST_IN_PF) {
		        if ((fault_va >= USTACKBOTTOM && fault_va < USTACKTOP) ||
		            (fault_va >= USER_HEAP_START && fault_va < USER_HEAP_MAX)) {
		            pf_add_empty_env_page(faulted_env, ROUNDDOWN(fault_va, PAGE_SIZE), 1);
		        } else {
		            sched_kill_env(faulted_env->env_id);
		            return;
		        }
		    }


		    faulted_env->page_last_WS_index = (victim_idx + 1) % faulted_env->page_WS_max_size;
		#endif
		}

	}
}

void __page_fault_handler_with_buffering(struct Env * curenv, uint32 fault_va)
{
	panic("this function is not required...!!");
}



