// Kernel-level Semaphore

#include "inc/types.h"
#include "inc/x86.h"
#include "inc/memlayout.h"
#include "inc/mmu.h"
#include "inc/environment_definitions.h"
#include "inc/assert.h"
#include "inc/string.h"
#include "ksemaphore.h"
#include "channel.h"
#include "../cpu/cpu.h"
#include "../proc/user_environment.h"

void init_ksemaphore(struct ksemaphore* ksem, int value, char* name)
{
	init_channel(&(ksem->chan), "ksemaphore channel");
	init_kspinlock(&(ksem->lk), "lock of ksemaphore");
	strcpy(ksem->name, name);
	ksem->count = value;
}

void wait_ksemaphore(struct ksemaphore* ksem)
{
		//Acquire the spinlock to protect the count
	acquire_kspinlock(&(ksem->lk));

	ksem->count--;

	if (ksem->count < 0)
	{
		sleep(&(ksem->chan), &(ksem->lk));
	}

	//Release the spinlock
	release_kspinlock(&(ksem->lk));

}

void signal_ksemaphore(struct ksemaphore* ksem)
{
		//Acquire the spinlock
	acquire_kspinlock(&(ksem->lk));

	ksem->count++;

	if (ksem->count <= 0)
	{
		// Wake up exactly one blocked process
		wakeup_one(&(ksem->chan));
	}

	//Release the spinlock
	release_kspinlock(&(ksem->lk));
}


