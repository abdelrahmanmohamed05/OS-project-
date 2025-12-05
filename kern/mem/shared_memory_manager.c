#include <inc/memlayout.h>
#include "shared_memory_manager.h"

#include <inc/mmu.h>
#include <inc/error.h>
#include <inc/string.h>
#include <inc/assert.h>
#include <inc/queue.h>
#include <inc/environment_definitions.h>

#include <kern/proc/user_environment.h>
#include <kern/trap/syscall.h>
#include "kheap.h"
#include "memory_manager.h"

//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

//===========================
// [1] INITIALIZE SHARES:
//===========================
//Initialize the list and the corresponding lock
void sharing_init()
{
#if USE_KHEAP
	LIST_INIT(&AllShares.shares_list) ;
	init_kspinlock(&AllShares.shareslock, "shares lock");
	//init_sleeplock(&AllShares.sharessleeplock, "shares sleep lock");
#else
	panic("not handled when KERN HEAP is disabled");
#endif
}

//=========================
// [2] Find Share Object:
//=========================
//Search for the given shared object in the "shares_list"
//Return:
//	a) if found: ptr to Share object
//	b) else: NULL
struct Share* find_share(int32 ownerID, char* name)
{
#if USE_KHEAP
	struct Share * ret = NULL;
	bool wasHeld = holding_kspinlock(&(AllShares.shareslock));
	if (!wasHeld)
	{
		acquire_kspinlock(&(AllShares.shareslock));
	}
	{
		struct Share * shr ;
		LIST_FOREACH(shr, &(AllShares.shares_list))
		{
			//cprintf("shared var name = %s compared with %s\n", name, shr->name);
			if(shr->ownerID == ownerID && strcmp(name, shr->name)==0)
			{
				//cprintf("%s found\n", name);
				ret = shr;
				break;
			}
		}
	}
	if (!wasHeld)
	{
		release_kspinlock(&(AllShares.shareslock));
	}
	return ret;
#else
	panic("not handled when KERN HEAP is disabled");
#endif
}

//==============================
// [3] Get Size of Share Object:
//==============================
int size_of_shared_object(int32 ownerID, char* shareName)
{
	// This function should return the size of the given shared object
	// RETURN:
	//	a) If found, return size of shared object
	//	b) Else, return E_SHARED_MEM_NOT_EXISTS
	//
	struct Share* ptr_share = find_share(ownerID, shareName);
	if (ptr_share == NULL)
		return E_SHARED_MEM_NOT_EXISTS;
	else
		return ptr_share->size;

	return 0;
}
//===========================================================


//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//

//=====================================
// [1] Alloc & Initialize Share Object:
//=====================================
//Allocates a new shared object and initialize its member
//It dynamically creates the "framesStorage"
//Return: allocatedObject (pointer to struct Share) passed by reference
struct Share* alloc_share(int32 ownerID, char* shareName, uint32 size, uint8 isWritable)
{
    #if USE_KHEAP
    uint32 rounded_size = ROUNDUP(size, PAGE_SIZE);
    uint32 n_pages = rounded_size / PAGE_SIZE;
    struct Share* shr = (struct Share*)kmalloc(sizeof(struct Share));
    if (shr == NULL) return NULL;
    memset(shr, 0, sizeof(struct Share));
    shr->ownerID = ownerID;
    strncpy(shr->name, shareName, sizeof(shr->name)-1);
    shr->name[sizeof(shr->name)-1] = '\0';
    shr->size = rounded_size;
    shr->isWritable = isWritable;
    shr->references = 0;
    shr->framesStorage = (struct FrameInfo**)kmalloc(n_pages * sizeof(struct FrameInfo*));
    if (shr->framesStorage == NULL) {
        kfree(shr);
        return NULL;
    }
    memset(shr->framesStorage, 0, n_pages * sizeof(struct FrameInfo*));
    return shr;
    #else
    panic("not handled when KERN HEAP is disabled");
    return NULL;
    #endif
}


//=========================
// [4] Create Share Object:
//=========================
int create_shared_object(int32 ownerID, char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
    struct Env* myenv = get_cpu_proc(); //The calling environment
    assert(myenv != NULL);

    if (find_share(ownerID, shareName) != NULL)
        return E_SHARED_MEM_EXISTS;

    uint32 va = ROUNDDOWN((uint32)virtual_address, PAGE_SIZE);
    uint32 rounded_size = ROUNDUP(size, PAGE_SIZE);
    uint32 n_pages = rounded_size / PAGE_SIZE;

    struct Share* shr = alloc_share(ownerID, shareName, rounded_size, isWritable);
    if (shr == NULL)
        return E_NO_SHARE;

    int perms = PERM_USER | (isWritable ? PERM_WRITEABLE : 0);
    for (uint32 i = 0; i < n_pages; ++i) {
        struct FrameInfo* fi = NULL;
        if (allocate_frame(&fi) == E_NO_MEM || fi == NULL) {
            for (uint32 j = 0; j < i; ++j) {
                if (shr->framesStorage[j] != NULL) {
                    unmap_frame(myenv->env_page_directory, va + j * PAGE_SIZE);
                    decrement_references(shr->framesStorage[j]);
                }
            }
            kfree(shr->framesStorage);
            kfree(shr);
            return E_NO_SHARE;
        }
        shr->framesStorage[i] = fi;
        map_frame(myenv->env_page_directory, fi, va + i * PAGE_SIZE, perms);
    }

    shr->ID = (int32)(va & 0x7FFFFFFF);
    shr->references = 1;

    bool wasHeld = holding_kspinlock(&(AllShares.shareslock));
    if (!wasHeld) acquire_kspinlock(&(AllShares.shareslock));
    LIST_INSERT_HEAD(&(AllShares.shares_list), shr);
    if (!wasHeld) release_kspinlock(&(AllShares.shareslock));

    return shr->ID;
}


//======================
// [5] Get Share Object:
//======================
int get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
    struct Env* myenv = get_cpu_proc(); //The calling environment
    assert(myenv != NULL);

    struct Share* shr = find_share(ownerID, shareName);
    if (shr == NULL)
        return E_SHARED_MEM_NOT_EXISTS;

    uint32 va = ROUNDDOWN((uint32)virtual_address, PAGE_SIZE);
    uint32 n_pages = shr->size / PAGE_SIZE;
    int perms = PERM_USER | (shr->isWritable ? PERM_WRITEABLE : 0);
    for (uint32 i = 0; i < n_pages; ++i) {
        map_frame(myenv->env_page_directory, shr->framesStorage[i], va + i * PAGE_SIZE, perms);
    }
    shr->references++;
    return shr->ID;
}

//==================================================================================//
//============================== BONUS FUNCTIONS ===================================//
//==================================================================================//
//=========================
// [1] Delete Share Object:
//=========================
//delete the given shared object from the "shares_list"
//it should free its framesStorage and the share object itself
void free_share(struct Share* ptrShare)
{
    #if USE_KHEAP
    bool wasHeld = holding_kspinlock(&(AllShares.shareslock));
    if (!wasHeld) acquire_kspinlock(&(AllShares.shareslock));
    LIST_REMOVE(&(AllShares.shares_list), ptrShare);
    if (!wasHeld) release_kspinlock(&(AllShares.shareslock));
    if (ptrShare->framesStorage) {
        kfree(ptrShare->framesStorage);
    }
    kfree(ptrShare);
    #else
    panic("not handled when KERN HEAP is disabled");
    #endif
}


//=========================
// [2] Free Share Object:
//=========================
int delete_shared_object(int32 sharedObjectID, void *startVA)
{
    struct Env* myenv = get_cpu_proc(); //The calling environment
    assert(myenv != NULL);

    uint32 va = ROUNDDOWN((uint32)startVA, PAGE_SIZE);

    struct Share *shr = NULL;
    {
        bool wasHeld = holding_kspinlock(&(AllShares.shareslock));
        if (!wasHeld) acquire_kspinlock(&(AllShares.shareslock));
        struct Share* it;
        LIST_FOREACH(it, &(AllShares.shares_list))
        {
            if (it->ID == sharedObjectID) { shr = it; break; }
        }
        if (!wasHeld) release_kspinlock(&(AllShares.shareslock));
    }
    if (shr == NULL)
        return E_SHARED_MEM_NOT_EXISTS;

    uint32 n_pages = shr->size / PAGE_SIZE;

    for (uint32 i = 0; i < n_pages; ++i) {
        unmap_frame(myenv->env_page_directory, va + i * PAGE_SIZE);
    }

    // remove empty page tables within the affected range
    {
        uint32 start = va;
        uint32 end = va + n_pages * PAGE_SIZE;
        int last_pdx = -1;
        for (uint32 addr = start; addr < end; addr += PAGE_SIZE) {
            int pdx = PDX(addr);
            if (pdx == last_pdx) continue;
            last_pdx = pdx;
            uint32 *ptr_page_table = NULL;
            if (get_page_table(myenv->env_page_directory, addr, &ptr_page_table) == TABLE_IN_MEMORY && ptr_page_table != NULL) {
                bool any_present = 0;
                for (int t = 0; t < NPTENTRIES; ++t) {
                    if ((ptr_page_table[t] & PERM_PRESENT) == PERM_PRESENT) { any_present = 1; break; }
                }
                if (!any_present) {
                #if USE_KHEAP
                    kfree(ptr_page_table);
                #else
                    uint32 table_pa = STATIC_KERNEL_PHYSICAL_ADDRESS(ptr_page_table);
                    struct FrameInfo *table_fi = to_frame_info(table_pa);
                    table_fi->references = 0;
                    free_frame(table_fi);
                #endif
                    myenv->env_page_directory[pdx] = 0;
                    tlbflush();
                }
            }
        }
    }

    shr->references--;
    if (shr->references == 0) {
        for (uint32 i = 0; i < n_pages; ++i) {
            if (shr->framesStorage[i]) {
                shr->framesStorage[i] = NULL;
            }
        }
        free_share(shr);
    }

    tlbflush();
    return 0;
}
