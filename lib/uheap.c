#include <inc/lib.h>

//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
	if(__firstTimeFlag)
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
		uheapPlaceStrategy = sys_get_uheap_strategy();
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
		uheapPageAllocBreak = uheapPageAllocStart;

		__firstTimeFlag = 0;
	}
}

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
	if (ret < 0)
		panic("get_page() in user: failed to allocate page from the kernel");
	return 0;
}

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
	if (ret < 0)
		panic("return_page() in user: failed to return a page to the kernel");
}

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//

static struct {uint32 va; uint32 size; uint8 used;} uhp_allocs[4096];
static struct {uint32 va; uint32 size; uint8 free;} uhp_frees[4096];
static int uhp_inited = 0;

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
	if (size == 0) return NULL ;
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
    {
        return alloc_block(size);
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);

    if (!uhp_inited)
    {
        uhp_inited = 1;
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
        {
            exactIdx = i;
            break;
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
    if (exactIdx != -1)
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
        uhp_frees[exactIdx].free = 0;
        uhp_frees[exactIdx].size = 0;
        uhp_frees[exactIdx].va = 0;
    }
    else if (worstIdx != -1)
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
        if (uhp_frees[worstIdx].size == req)
        {
            uhp_frees[worstIdx].free = 0;
            uhp_frees[worstIdx].size = 0;
            uhp_frees[worstIdx].va = 0;
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
            uhp_frees[worstIdx].size = worstSize - req;
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
        if (start + req > USER_HEAP_MAX)
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
    {
        if (!uhp_allocs[i].used)
        {
            uhp_allocs[i].va = va;
            uhp_allocs[i].size = req;
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
    return (void*)va;
}

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;

    uint32 va = (uint32)virtual_address;
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
    {
        free_block(virtual_address);
        return;
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
        {
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
    {
        if (!uhp_frees[i].free)
        {
            uhp_frees[i].va = va;
            uhp_frees[i].size = size;
            uhp_frees[i].free = 1;
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
            if (uhp_frees[i].free)
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
                    uhp_frees[fidx].size += uhp_frees[i].size;
                    uhp_frees[i].free = 0;
                    uhp_frees[i].va = 0;
                    uhp_frees[i].size = 0;
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
                    uhp_frees[i].free = 0;
                    uhp_frees[i].va = 0;
                    uhp_frees[i].size = 0;
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
    {
        if (uhp_allocs[i].used)
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
	if (size == 0) return NULL ;
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);

    
    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
        {
            exactIdx = i;
            break;
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
    if (exactIdx != -1)
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
        uhp_frees[exactIdx].free = 0;
        uhp_frees[exactIdx].size = 0;
        uhp_frees[exactIdx].va = 0;
    }
    else if (worstIdx != -1)
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
        if (uhp_frees[worstIdx].size == req)
        {
            uhp_frees[worstIdx].free = 0;
            uhp_frees[worstIdx].size = 0;
            uhp_frees[worstIdx].va = 0;
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
            uhp_frees[worstIdx].size = worstSize - req;
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
        if (start + req > USER_HEAP_MAX)
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
    {
        if (!uhp_allocs[i].used)
        {
            uhp_allocs[i].va = va;
            uhp_allocs[i].size = req;
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
    if (r == E_SHARED_MEM_EXISTS)
        return (void*)E_SHARED_MEM_EXISTS;
    if (r < 0)
        return NULL;
    return (void*)va;
}

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
    if (sz <= 0)
        return NULL;
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
        {
            exactIdx = i;
            break;
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
    if (exactIdx != -1)
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
        uhp_frees[exactIdx].free = 0;
        uhp_frees[exactIdx].size = 0;
        uhp_frees[exactIdx].va = 0;
    }
    else if (worstIdx != -1)
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
        if (uhp_frees[worstIdx].size == req)
        {
            uhp_frees[worstIdx].free = 0;
            uhp_frees[worstIdx].size = 0;
            uhp_frees[worstIdx].va = 0;
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
            uhp_frees[worstIdx].size = worstSize - req;
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
        if (start + req > USER_HEAP_MAX)
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
    {
        if (!uhp_allocs[i].used)
        {
            uhp_allocs[i].va = va;
            uhp_allocs[i].size = req;
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
    if (r < 0)
        return NULL;
    return (void*)va;
}


//==================================================================================//
//============================== BONUS FUNCTIONS ===================================//
//==================================================================================//


//=================================
// REALLOC USER SPACE:
//=================================
//	Attempts to resize the allocated space at "virtual_address" to "new_size" bytes,
//	possibly moving it in the heap.
//	If successful, returns the new virtual_address, in which case the old virtual_address must no longer be accessed.
//	On failure, returns a null pointer, and the old virtual_address remains valid.

//	A call with virtual_address = null is equivalent to malloc().
//	A call with new_size = zero is equivalent to free().

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
	//==============================================================
	if (virtual_address == NULL)
		return malloc(new_size);
	if (new_size == 0)
	{
		free(virtual_address);
		return NULL;
	}
	uint32 va = (uint32)virtual_address;
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
	{
		void* newptr = malloc(new_size);
		if (newptr == NULL)
			return NULL;
		uint32 oldsz = get_block_size(virtual_address);
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
		memmove(newptr, virtual_address, cpsz);
		free(virtual_address);
		return newptr;
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
		return NULL;
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
	if (req == oldsz)
		return virtual_address;
	if (req < oldsz)
	{
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
		{
			if (!uhp_frees[j].free)
			{
				uhp_frees[j].va = tail;
				uhp_frees[j].size = shrink;
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
				if (uhp_frees[k].free)
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
						uhp_frees[fidx].size += uhp_frees[k].size;
						uhp_frees[k].free = 0;
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
		{
			if (uhp_allocs[m].used)
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
	{
		uint32 add = req - oldsz;
		sys_allocate_user_mem(end, add);
		uhp_allocs[idx].size = req;
		uhp_frees[adjIdx].va += add;
		uhp_frees[adjIdx].size -= add;
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
		return virtual_address;
	}
	void* newptr = malloc(new_size);
	if (newptr == NULL)
		return NULL;
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
	free(virtual_address);
	return newptr;
}


//=================================
// FREE SHARED VARIABLE:
//=================================
//	This function frees the shared variable at the given virtual_address
//	To do this, we need to switch to the kernel, free the pages AND "EMPTY" PAGE TABLES
//	from main memory then switch back to the user again.
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
			{
				if (!uhp_frees[j].free)
				{
					uhp_frees[j].va = va;
					uhp_frees[j].size = size;
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
					if (uhp_frees[k].free)
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
							uhp_frees[fidx].size += uhp_frees[k].size;
							uhp_frees[k].free = 0;
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
			{
				if (uhp_allocs[m].used)
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
			break;
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}


//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
