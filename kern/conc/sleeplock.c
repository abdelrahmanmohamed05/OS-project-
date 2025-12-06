// Sleeping locks

#include "inc/types.h"
#include "inc/x86.h"
#include "inc/memlayout.h"
#include "inc/mmu.h"
#include "inc/environment_definitions.h"
#include "inc/assert.h"
#include "inc/string.h"
#include "sleeplock.h"
#include "channel.h"
#include "../cpu/cpu.h"
#include "../proc/user_environment.h"

void init_sleeplock(struct sleeplock* lk, char* name)
{
	init_channel(&(lk->chan), "sleep lock channel");
	char prefix[30] = "lock of sleeplock - ";
	char guardName[30 + NAMELEN];
	strcconcat(prefix, name, guardName);
	init_kspinlock(&(lk->lk), guardName);
	strcpy(lk->name, name);
	lk->locked = 0;
	lk->pid = 0;
}

void acquire_sleeplock(struct sleeplock* lk)
{
		//Acquire the internal spinlock to protect the 'locked' flag
	acquire_kspinlock(&(lk->lk));

	//Loop while the lock is already held by another process
	while (lk->locked)
	{
		sleep(&(lk->chan), &(lk->lk));
	}

	lk->locked = 1;
	lk->pid = get_cpu_proc()->env_id;

	//Release the internal spinlock
	release_kspinlock(&(lk->lk));
}

void release_sleeplock(struct sleeplock* lk)
{
		//Acquire the internal spinlock
	acquire_kspinlock(&(lk->lk));

	//Wake up all processes waiting on this lock (if any)
	wakeup_all(&(lk->chan));

	//Mark the lock as free
	lk->locked = 0;
	lk->pid = 0;

	//Release the internal spinlock
	release_kspinlock(&(lk->lk));
}

int holding_sleeplock(struct sleeplock* lk)
{
	int r;
	acquire_kspinlock(&(lk->lk));
	r = lk->locked && (lk->pid == get_cpu_proc()->env_id);
	release_kspinlock(&(lk->lk));
	return r;
}



