
obj/user/tst_envfree6:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	mov $0, %eax
  800020:	b8 00 00 00 00       	mov    $0x0,%eax
	cmpl $USTACKTOP, %esp
  800025:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  80002b:	75 04                	jne    800031 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  80002d:	6a 00                	push   $0x0
	pushl $0
  80002f:	6a 00                	push   $0x0

00800031 <args_exist>:

args_exist:
	call libmain
  800031:	e8 a1 02 00 00       	call   8002d7 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests the usage of shared variables
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	// Testing scenario 6: Semaphores & shared variables
	// Testing removing the shared variables and semaphores
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  800044:	83 ec 04             	sub    $0x4,%esp
  800047:	6a 01                	push   $0x1
  800049:	6a 04                	push   $0x4
  80004b:	68 20 42 80 00       	push   $0x804220
  800050:	e8 2f 1e 00 00       	call   801e84 <smalloc>
  800055:	83 c4 10             	add    $0x10,%esp
  800058:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	*numOfFinished = 0 ;
  80005b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80005e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	char getksbrkCmd[100] = "__getKernelSBreak__";
  800064:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  80006a:	bb 21 44 80 00       	mov    $0x804421,%ebx
  80006f:	ba 05 00 00 00       	mov    $0x5,%edx
  800074:	89 c7                	mov    %eax,%edi
  800076:	89 de                	mov    %ebx,%esi
  800078:	89 d1                	mov    %edx,%ecx
  80007a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80007c:	8d 95 68 ff ff ff    	lea    -0x98(%ebp),%edx
  800082:	b9 14 00 00 00       	mov    $0x14,%ecx
  800087:	b8 00 00 00 00       	mov    $0x0,%eax
  80008c:	89 d7                	mov    %edx,%edi
  80008e:	f3 ab                	rep stos %eax,%es:(%edi)
	uint32 ksbrk_before ;
	sys_utilities(getksbrkCmd, (uint32)&ksbrk_before);
  800090:	8d 85 50 ff ff ff    	lea    -0xb0(%ebp),%eax
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	50                   	push   %eax
  80009a:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  8000a0:	50                   	push   %eax
  8000a1:	e8 18 33 00 00       	call   8033be <sys_utilities>
  8000a6:	83 c4 10             	add    $0x10,%esp

	int freeFrames_before = sys_calculate_free_frames() ;
  8000a9:	e8 11 2f 00 00       	call   802fbf <sys_calculate_free_frames>
  8000ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  8000b1:	e8 54 2f 00 00       	call   80300a <sys_pf_calculate_allocated_pages>
  8000b6:	89 45 dc             	mov    %eax,-0x24(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  8000b9:	83 ec 08             	sub    $0x8,%esp
  8000bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8000bf:	68 30 42 80 00       	push   $0x804230
  8000c4:	e8 8c 06 00 00       	call   800755 <cprintf>
  8000c9:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr1", myEnv->page_WS_max_size, (myEnv->SecondListSize),50);
  8000cc:	a1 20 50 80 00       	mov    0x805020,%eax
  8000d1:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  8000d7:	89 c2                	mov    %eax,%edx
  8000d9:	a1 20 50 80 00       	mov    0x805020,%eax
  8000de:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000e4:	6a 32                	push   $0x32
  8000e6:	52                   	push   %edx
  8000e7:	50                   	push   %eax
  8000e8:	68 63 42 80 00       	push   $0x804263
  8000ed:	e8 28 30 00 00       	call   80311a <sys_create_env>
  8000f2:	83 c4 10             	add    $0x10,%esp
  8000f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int32 envIdProcessB = sys_create_env("ef_midterm", myEnv->page_WS_max_size,(myEnv->SecondListSize), 50);
  8000f8:	a1 20 50 80 00       	mov    0x805020,%eax
  8000fd:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  800103:	89 c2                	mov    %eax,%edx
  800105:	a1 20 50 80 00       	mov    0x805020,%eax
  80010a:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800110:	6a 32                	push   $0x32
  800112:	52                   	push   %edx
  800113:	50                   	push   %eax
  800114:	68 6c 42 80 00       	push   $0x80426c
  800119:	e8 fc 2f 00 00       	call   80311a <sys_create_env>
  80011e:	83 c4 10             	add    $0x10,%esp
  800121:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	sys_run_env(envIdProcessA);
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	ff 75 d8             	pushl  -0x28(%ebp)
  80012a:	e8 09 30 00 00       	call   803138 <sys_run_env>
  80012f:	83 c4 10             	add    $0x10,%esp
	env_sleep(10000);
  800132:	83 ec 0c             	sub    $0xc,%esp
  800135:	68 10 27 00 00       	push   $0x2710
  80013a:	e8 a0 3d 00 00       	call   803edf <env_sleep>
  80013f:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800142:	83 ec 0c             	sub    $0xc,%esp
  800145:	ff 75 d4             	pushl  -0x2c(%ebp)
  800148:	e8 eb 2f 00 00       	call   803138 <sys_run_env>
  80014d:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  800150:	90                   	nop
  800151:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800154:	8b 00                	mov    (%eax),%eax
  800156:	83 f8 02             	cmp    $0x2,%eax
  800159:	75 f6                	jne    800151 <_main+0x119>

	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  80015b:	e8 5f 2e 00 00       	call   802fbf <sys_calculate_free_frames>
  800160:	83 ec 08             	sub    $0x8,%esp
  800163:	50                   	push   %eax
  800164:	68 78 42 80 00       	push   $0x804278
  800169:	e8 e7 05 00 00       	call   800755 <cprintf>
  80016e:	83 c4 10             	add    $0x10,%esp

	uint32 ksbrk_after ;
	sys_utilities(getksbrkCmd, (uint32)&ksbrk_after);
  800171:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  800177:	83 ec 08             	sub    $0x8,%esp
  80017a:	50                   	push   %eax
  80017b:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  800181:	50                   	push   %eax
  800182:	e8 37 32 00 00       	call   8033be <sys_utilities>
  800187:	83 c4 10             	add    $0x10,%esp

	//DISABLE the interrupt to ensure the env_free is done as a whole without preemption
	//to avoid context switch (due to clock interrupt) while freeing the env to prevent:
	//	1. context switching to a wrong process specially in the part of temporarily switching the CPU process for freeing shared variables
	//	2. changing the # free frames
	char changeIntCmd[100] = "__changeInterruptStatus__";
  80018a:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  800190:	bb 85 44 80 00       	mov    $0x804485,%ebx
  800195:	ba 1a 00 00 00       	mov    $0x1a,%edx
  80019a:	89 c7                	mov    %eax,%edi
  80019c:	89 de                	mov    %ebx,%esi
  80019e:	89 d1                	mov    %edx,%ecx
  8001a0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001a2:	8d 95 02 ff ff ff    	lea    -0xfe(%ebp),%edx
  8001a8:	b9 4a 00 00 00       	mov    $0x4a,%ecx
  8001ad:	b0 00                	mov    $0x0,%al
  8001af:	89 d7                	mov    %edx,%edi
  8001b1:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(changeIntCmd, 0);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	6a 00                	push   $0x0
  8001b8:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8001be:	50                   	push   %eax
  8001bf:	e8 fa 31 00 00       	call   8033be <sys_utilities>
  8001c4:	83 c4 10             	add    $0x10,%esp
	{
		sys_destroy_env(envIdProcessA);
  8001c7:	83 ec 0c             	sub    $0xc,%esp
  8001ca:	ff 75 d8             	pushl  -0x28(%ebp)
  8001cd:	e8 82 2f 00 00       	call   803154 <sys_destroy_env>
  8001d2:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(envIdProcessB);
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001db:	e8 74 2f 00 00       	call   803154 <sys_destroy_env>
  8001e0:	83 c4 10             	add    $0x10,%esp
	}
	sys_utilities(changeIntCmd, 1);
  8001e3:	83 ec 08             	sub    $0x8,%esp
  8001e6:	6a 01                	push   $0x1
  8001e8:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8001ee:	50                   	push   %eax
  8001ef:	e8 ca 31 00 00       	call   8033be <sys_utilities>
  8001f4:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8001f7:	e8 c3 2d 00 00       	call   802fbf <sys_calculate_free_frames>
  8001fc:	89 45 d0             	mov    %eax,-0x30(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8001ff:	e8 06 2e 00 00       	call   80300a <sys_pf_calculate_allocated_pages>
  800204:	89 45 cc             	mov    %eax,-0x34(%ebp)

	int expected = (ROUNDUP((uint32)ksbrk_after, PAGE_SIZE) - ROUNDUP((uint32)ksbrk_before, PAGE_SIZE)) / PAGE_SIZE;
  800207:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  80020e:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
  800214:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800217:	01 d0                	add    %edx,%eax
  800219:	48                   	dec    %eax
  80021a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80021d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800220:	ba 00 00 00 00       	mov    $0x0,%edx
  800225:	f7 75 c8             	divl   -0x38(%ebp)
  800228:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80022b:	29 d0                	sub    %edx,%eax
  80022d:	89 c1                	mov    %eax,%ecx
  80022f:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  800236:	8b 95 50 ff ff ff    	mov    -0xb0(%ebp),%edx
  80023c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80023f:	01 d0                	add    %edx,%eax
  800241:	48                   	dec    %eax
  800242:	89 45 bc             	mov    %eax,-0x44(%ebp)
  800245:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800248:	ba 00 00 00 00       	mov    $0x0,%edx
  80024d:	f7 75 c0             	divl   -0x40(%ebp)
  800250:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800253:	29 d0                	sub    %edx,%eax
  800255:	29 c1                	sub    %eax,%ecx
  800257:	89 c8                	mov    %ecx,%eax
  800259:	c1 e8 0c             	shr    $0xc,%eax
  80025c:	89 45 b8             	mov    %eax,-0x48(%ebp)
	cprintf("expected = %d\n",expected);
  80025f:	83 ec 08             	sub    $0x8,%esp
  800262:	ff 75 b8             	pushl  -0x48(%ebp)
  800265:	68 aa 42 80 00       	push   $0x8042aa
  80026a:	e8 e6 04 00 00       	call   800755 <cprintf>
  80026f:	83 c4 10             	add    $0x10,%esp
	if ((freeFrames_before - freeFrames_after) != expected) {
  800272:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800275:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800278:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80027b:	74 2e                	je     8002ab <_main+0x273>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\ndifference = %d, expected = %d\n",
  80027d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800280:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800283:	ff 75 b8             	pushl  -0x48(%ebp)
  800286:	50                   	push   %eax
  800287:	ff 75 d0             	pushl  -0x30(%ebp)
  80028a:	68 bc 42 80 00       	push   $0x8042bc
  80028f:	e8 c1 04 00 00       	call   800755 <cprintf>
  800294:	83 c4 10             	add    $0x10,%esp
				freeFrames_after, freeFrames_after - freeFrames_before, expected);
		panic("env_free() does not work correctly... check it again.");
  800297:	83 ec 04             	sub    $0x4,%esp
  80029a:	68 2c 43 80 00       	push   $0x80432c
  80029f:	6a 36                	push   $0x36
  8002a1:	68 62 43 80 00       	push   $0x804362
  8002a6:	e8 dc 01 00 00       	call   800487 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  8002ab:	83 ec 08             	sub    $0x8,%esp
  8002ae:	ff 75 d0             	pushl  -0x30(%ebp)
  8002b1:	68 78 43 80 00       	push   $0x804378
  8002b6:	e8 9a 04 00 00       	call   800755 <cprintf>
  8002bb:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 6 for envfree completed successfully.\n");
  8002be:	83 ec 0c             	sub    $0xc,%esp
  8002c1:	68 d8 43 80 00       	push   $0x8043d8
  8002c6:	e8 8a 04 00 00       	call   800755 <cprintf>
  8002cb:	83 c4 10             	add    $0x10,%esp
	return;
  8002ce:	90                   	nop
}
  8002cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d2:	5b                   	pop    %ebx
  8002d3:	5e                   	pop    %esi
  8002d4:	5f                   	pop    %edi
  8002d5:	5d                   	pop    %ebp
  8002d6:	c3                   	ret    

008002d7 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002d7:	55                   	push   %ebp
  8002d8:	89 e5                	mov    %esp,%ebp
  8002da:	57                   	push   %edi
  8002db:	56                   	push   %esi
  8002dc:	53                   	push   %ebx
  8002dd:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8002e0:	e8 a3 2e 00 00       	call   803188 <sys_getenvindex>
  8002e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002e8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002eb:	89 d0                	mov    %edx,%eax
  8002ed:	c1 e0 03             	shl    $0x3,%eax
  8002f0:	01 d0                	add    %edx,%eax
  8002f2:	c1 e0 02             	shl    $0x2,%eax
  8002f5:	01 d0                	add    %edx,%eax
  8002f7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002fe:	01 d0                	add    %edx,%eax
  800300:	c1 e0 03             	shl    $0x3,%eax
  800303:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800308:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80030d:	a1 20 50 80 00       	mov    0x805020,%eax
  800312:	8a 40 20             	mov    0x20(%eax),%al
  800315:	84 c0                	test   %al,%al
  800317:	74 0d                	je     800326 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800319:	a1 20 50 80 00       	mov    0x805020,%eax
  80031e:	83 c0 20             	add    $0x20,%eax
  800321:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800326:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80032a:	7e 0a                	jle    800336 <libmain+0x5f>
		binaryname = argv[0];
  80032c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80032f:	8b 00                	mov    (%eax),%eax
  800331:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  800336:	83 ec 08             	sub    $0x8,%esp
  800339:	ff 75 0c             	pushl  0xc(%ebp)
  80033c:	ff 75 08             	pushl  0x8(%ebp)
  80033f:	e8 f4 fc ff ff       	call   800038 <_main>
  800344:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800347:	a1 00 50 80 00       	mov    0x805000,%eax
  80034c:	85 c0                	test   %eax,%eax
  80034e:	0f 84 01 01 00 00    	je     800455 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800354:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80035a:	bb e4 45 80 00       	mov    $0x8045e4,%ebx
  80035f:	ba 0e 00 00 00       	mov    $0xe,%edx
  800364:	89 c7                	mov    %eax,%edi
  800366:	89 de                	mov    %ebx,%esi
  800368:	89 d1                	mov    %edx,%ecx
  80036a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80036c:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80036f:	b9 56 00 00 00       	mov    $0x56,%ecx
  800374:	b0 00                	mov    $0x0,%al
  800376:	89 d7                	mov    %edx,%edi
  800378:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80037a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800381:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800384:	83 ec 08             	sub    $0x8,%esp
  800387:	50                   	push   %eax
  800388:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80038e:	50                   	push   %eax
  80038f:	e8 2a 30 00 00       	call   8033be <sys_utilities>
  800394:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800397:	e8 73 2b 00 00       	call   802f0f <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80039c:	83 ec 0c             	sub    $0xc,%esp
  80039f:	68 04 45 80 00       	push   $0x804504
  8003a4:	e8 ac 03 00 00       	call   800755 <cprintf>
  8003a9:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8003ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003af:	85 c0                	test   %eax,%eax
  8003b1:	74 18                	je     8003cb <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8003b3:	e8 24 30 00 00       	call   8033dc <sys_get_optimal_num_faults>
  8003b8:	83 ec 08             	sub    $0x8,%esp
  8003bb:	50                   	push   %eax
  8003bc:	68 2c 45 80 00       	push   $0x80452c
  8003c1:	e8 8f 03 00 00       	call   800755 <cprintf>
  8003c6:	83 c4 10             	add    $0x10,%esp
  8003c9:	eb 59                	jmp    800424 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003cb:	a1 20 50 80 00       	mov    0x805020,%eax
  8003d0:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  8003d6:	a1 20 50 80 00       	mov    0x805020,%eax
  8003db:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8003e1:	83 ec 04             	sub    $0x4,%esp
  8003e4:	52                   	push   %edx
  8003e5:	50                   	push   %eax
  8003e6:	68 50 45 80 00       	push   $0x804550
  8003eb:	e8 65 03 00 00       	call   800755 <cprintf>
  8003f0:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003f3:	a1 20 50 80 00       	mov    0x805020,%eax
  8003f8:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  8003fe:	a1 20 50 80 00       	mov    0x805020,%eax
  800403:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  800409:	a1 20 50 80 00       	mov    0x805020,%eax
  80040e:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800414:	51                   	push   %ecx
  800415:	52                   	push   %edx
  800416:	50                   	push   %eax
  800417:	68 78 45 80 00       	push   $0x804578
  80041c:	e8 34 03 00 00       	call   800755 <cprintf>
  800421:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800424:	a1 20 50 80 00       	mov    0x805020,%eax
  800429:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  80042f:	83 ec 08             	sub    $0x8,%esp
  800432:	50                   	push   %eax
  800433:	68 d0 45 80 00       	push   $0x8045d0
  800438:	e8 18 03 00 00       	call   800755 <cprintf>
  80043d:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800440:	83 ec 0c             	sub    $0xc,%esp
  800443:	68 04 45 80 00       	push   $0x804504
  800448:	e8 08 03 00 00       	call   800755 <cprintf>
  80044d:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800450:	e8 d4 2a 00 00       	call   802f29 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800455:	e8 1f 00 00 00       	call   800479 <exit>
}
  80045a:	90                   	nop
  80045b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80045e:	5b                   	pop    %ebx
  80045f:	5e                   	pop    %esi
  800460:	5f                   	pop    %edi
  800461:	5d                   	pop    %ebp
  800462:	c3                   	ret    

00800463 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800463:	55                   	push   %ebp
  800464:	89 e5                	mov    %esp,%ebp
  800466:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800469:	83 ec 0c             	sub    $0xc,%esp
  80046c:	6a 00                	push   $0x0
  80046e:	e8 e1 2c 00 00       	call   803154 <sys_destroy_env>
  800473:	83 c4 10             	add    $0x10,%esp
}
  800476:	90                   	nop
  800477:	c9                   	leave  
  800478:	c3                   	ret    

00800479 <exit>:

void
exit(void)
{
  800479:	55                   	push   %ebp
  80047a:	89 e5                	mov    %esp,%ebp
  80047c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80047f:	e8 36 2d 00 00       	call   8031ba <sys_exit_env>
}
  800484:	90                   	nop
  800485:	c9                   	leave  
  800486:	c3                   	ret    

00800487 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800487:	55                   	push   %ebp
  800488:	89 e5                	mov    %esp,%ebp
  80048a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80048d:	8d 45 10             	lea    0x10(%ebp),%eax
  800490:	83 c0 04             	add    $0x4,%eax
  800493:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800496:	a1 38 51 83 00       	mov    0x835138,%eax
  80049b:	85 c0                	test   %eax,%eax
  80049d:	74 16                	je     8004b5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80049f:	a1 38 51 83 00       	mov    0x835138,%eax
  8004a4:	83 ec 08             	sub    $0x8,%esp
  8004a7:	50                   	push   %eax
  8004a8:	68 48 46 80 00       	push   $0x804648
  8004ad:	e8 a3 02 00 00       	call   800755 <cprintf>
  8004b2:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8004b5:	a1 04 50 80 00       	mov    0x805004,%eax
  8004ba:	83 ec 0c             	sub    $0xc,%esp
  8004bd:	ff 75 0c             	pushl  0xc(%ebp)
  8004c0:	ff 75 08             	pushl  0x8(%ebp)
  8004c3:	50                   	push   %eax
  8004c4:	68 50 46 80 00       	push   $0x804650
  8004c9:	6a 74                	push   $0x74
  8004cb:	e8 b2 02 00 00       	call   800782 <cprintf_colored>
  8004d0:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8004d6:	83 ec 08             	sub    $0x8,%esp
  8004d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8004dc:	50                   	push   %eax
  8004dd:	e8 04 02 00 00       	call   8006e6 <vcprintf>
  8004e2:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004e5:	83 ec 08             	sub    $0x8,%esp
  8004e8:	6a 00                	push   $0x0
  8004ea:	68 78 46 80 00       	push   $0x804678
  8004ef:	e8 f2 01 00 00       	call   8006e6 <vcprintf>
  8004f4:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004f7:	e8 7d ff ff ff       	call   800479 <exit>

	// should not return here
	while (1) ;
  8004fc:	eb fe                	jmp    8004fc <_panic+0x75>

008004fe <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004fe:	55                   	push   %ebp
  8004ff:	89 e5                	mov    %esp,%ebp
  800501:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800504:	a1 20 50 80 00       	mov    0x805020,%eax
  800509:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80050f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800512:	39 c2                	cmp    %eax,%edx
  800514:	74 14                	je     80052a <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800516:	83 ec 04             	sub    $0x4,%esp
  800519:	68 7c 46 80 00       	push   $0x80467c
  80051e:	6a 26                	push   $0x26
  800520:	68 c8 46 80 00       	push   $0x8046c8
  800525:	e8 5d ff ff ff       	call   800487 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80052a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800531:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800538:	e9 c5 00 00 00       	jmp    800602 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80053d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800540:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800547:	8b 45 08             	mov    0x8(%ebp),%eax
  80054a:	01 d0                	add    %edx,%eax
  80054c:	8b 00                	mov    (%eax),%eax
  80054e:	85 c0                	test   %eax,%eax
  800550:	75 08                	jne    80055a <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800552:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800555:	e9 a5 00 00 00       	jmp    8005ff <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80055a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800561:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800568:	eb 69                	jmp    8005d3 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80056a:	a1 20 50 80 00       	mov    0x805020,%eax
  80056f:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800575:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800578:	89 d0                	mov    %edx,%eax
  80057a:	01 c0                	add    %eax,%eax
  80057c:	01 d0                	add    %edx,%eax
  80057e:	c1 e0 03             	shl    $0x3,%eax
  800581:	01 c8                	add    %ecx,%eax
  800583:	8a 40 04             	mov    0x4(%eax),%al
  800586:	84 c0                	test   %al,%al
  800588:	75 46                	jne    8005d0 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80058a:	a1 20 50 80 00       	mov    0x805020,%eax
  80058f:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800595:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800598:	89 d0                	mov    %edx,%eax
  80059a:	01 c0                	add    %eax,%eax
  80059c:	01 d0                	add    %edx,%eax
  80059e:	c1 e0 03             	shl    $0x3,%eax
  8005a1:	01 c8                	add    %ecx,%eax
  8005a3:	8b 00                	mov    (%eax),%eax
  8005a5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005ab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005b0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005b5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bf:	01 c8                	add    %ecx,%eax
  8005c1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005c3:	39 c2                	cmp    %eax,%edx
  8005c5:	75 09                	jne    8005d0 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8005c7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005ce:	eb 15                	jmp    8005e5 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005d0:	ff 45 e8             	incl   -0x18(%ebp)
  8005d3:	a1 20 50 80 00       	mov    0x805020,%eax
  8005d8:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005e1:	39 c2                	cmp    %eax,%edx
  8005e3:	77 85                	ja     80056a <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005e5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005e9:	75 14                	jne    8005ff <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8005eb:	83 ec 04             	sub    $0x4,%esp
  8005ee:	68 d4 46 80 00       	push   $0x8046d4
  8005f3:	6a 3a                	push   $0x3a
  8005f5:	68 c8 46 80 00       	push   $0x8046c8
  8005fa:	e8 88 fe ff ff       	call   800487 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005ff:	ff 45 f0             	incl   -0x10(%ebp)
  800602:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800605:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800608:	0f 8c 2f ff ff ff    	jl     80053d <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80060e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800615:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80061c:	eb 26                	jmp    800644 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80061e:	a1 20 50 80 00       	mov    0x805020,%eax
  800623:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800629:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80062c:	89 d0                	mov    %edx,%eax
  80062e:	01 c0                	add    %eax,%eax
  800630:	01 d0                	add    %edx,%eax
  800632:	c1 e0 03             	shl    $0x3,%eax
  800635:	01 c8                	add    %ecx,%eax
  800637:	8a 40 04             	mov    0x4(%eax),%al
  80063a:	3c 01                	cmp    $0x1,%al
  80063c:	75 03                	jne    800641 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80063e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800641:	ff 45 e0             	incl   -0x20(%ebp)
  800644:	a1 20 50 80 00       	mov    0x805020,%eax
  800649:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80064f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800652:	39 c2                	cmp    %eax,%edx
  800654:	77 c8                	ja     80061e <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800656:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800659:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80065c:	74 14                	je     800672 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80065e:	83 ec 04             	sub    $0x4,%esp
  800661:	68 28 47 80 00       	push   $0x804728
  800666:	6a 44                	push   $0x44
  800668:	68 c8 46 80 00       	push   $0x8046c8
  80066d:	e8 15 fe ff ff       	call   800487 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800672:	90                   	nop
  800673:	c9                   	leave  
  800674:	c3                   	ret    

00800675 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800675:	55                   	push   %ebp
  800676:	89 e5                	mov    %esp,%ebp
  800678:	53                   	push   %ebx
  800679:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80067c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80067f:	8b 00                	mov    (%eax),%eax
  800681:	8d 48 01             	lea    0x1(%eax),%ecx
  800684:	8b 55 0c             	mov    0xc(%ebp),%edx
  800687:	89 0a                	mov    %ecx,(%edx)
  800689:	8b 55 08             	mov    0x8(%ebp),%edx
  80068c:	88 d1                	mov    %dl,%cl
  80068e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800691:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800695:	8b 45 0c             	mov    0xc(%ebp),%eax
  800698:	8b 00                	mov    (%eax),%eax
  80069a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80069f:	75 30                	jne    8006d1 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8006a1:	8b 15 3c 51 83 00    	mov    0x83513c,%edx
  8006a7:	a0 64 d0 81 00       	mov    0x81d064,%al
  8006ac:	0f b6 c0             	movzbl %al,%eax
  8006af:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006b2:	8b 09                	mov    (%ecx),%ecx
  8006b4:	89 cb                	mov    %ecx,%ebx
  8006b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006b9:	83 c1 08             	add    $0x8,%ecx
  8006bc:	52                   	push   %edx
  8006bd:	50                   	push   %eax
  8006be:	53                   	push   %ebx
  8006bf:	51                   	push   %ecx
  8006c0:	e8 06 28 00 00       	call   802ecb <sys_cputs>
  8006c5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d4:	8b 40 04             	mov    0x4(%eax),%eax
  8006d7:	8d 50 01             	lea    0x1(%eax),%edx
  8006da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006dd:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006e0:	90                   	nop
  8006e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006e4:	c9                   	leave  
  8006e5:	c3                   	ret    

008006e6 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006e6:	55                   	push   %ebp
  8006e7:	89 e5                	mov    %esp,%ebp
  8006e9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006ef:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006f6:	00 00 00 
	b.cnt = 0;
  8006f9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800700:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800703:	ff 75 0c             	pushl  0xc(%ebp)
  800706:	ff 75 08             	pushl  0x8(%ebp)
  800709:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80070f:	50                   	push   %eax
  800710:	68 75 06 80 00       	push   $0x800675
  800715:	e8 5a 02 00 00       	call   800974 <vprintfmt>
  80071a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80071d:	8b 15 3c 51 83 00    	mov    0x83513c,%edx
  800723:	a0 64 d0 81 00       	mov    0x81d064,%al
  800728:	0f b6 c0             	movzbl %al,%eax
  80072b:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800731:	52                   	push   %edx
  800732:	50                   	push   %eax
  800733:	51                   	push   %ecx
  800734:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80073a:	83 c0 08             	add    $0x8,%eax
  80073d:	50                   	push   %eax
  80073e:	e8 88 27 00 00       	call   802ecb <sys_cputs>
  800743:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800746:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
	return b.cnt;
  80074d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800753:	c9                   	leave  
  800754:	c3                   	ret    

00800755 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800755:	55                   	push   %ebp
  800756:	89 e5                	mov    %esp,%ebp
  800758:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80075b:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	va_start(ap, fmt);
  800762:	8d 45 0c             	lea    0xc(%ebp),%eax
  800765:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800768:	8b 45 08             	mov    0x8(%ebp),%eax
  80076b:	83 ec 08             	sub    $0x8,%esp
  80076e:	ff 75 f4             	pushl  -0xc(%ebp)
  800771:	50                   	push   %eax
  800772:	e8 6f ff ff ff       	call   8006e6 <vcprintf>
  800777:	83 c4 10             	add    $0x10,%esp
  80077a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80077d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800780:	c9                   	leave  
  800781:	c3                   	ret    

00800782 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800782:	55                   	push   %ebp
  800783:	89 e5                	mov    %esp,%ebp
  800785:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800788:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	curTextClr = (textClr << 8) ; //set text color by the given value
  80078f:	8b 45 08             	mov    0x8(%ebp),%eax
  800792:	c1 e0 08             	shl    $0x8,%eax
  800795:	a3 3c 51 83 00       	mov    %eax,0x83513c
	va_start(ap, fmt);
  80079a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80079d:	83 c0 04             	add    $0x4,%eax
  8007a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a6:	83 ec 08             	sub    $0x8,%esp
  8007a9:	ff 75 f4             	pushl  -0xc(%ebp)
  8007ac:	50                   	push   %eax
  8007ad:	e8 34 ff ff ff       	call   8006e6 <vcprintf>
  8007b2:	83 c4 10             	add    $0x10,%esp
  8007b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007b8:	c7 05 3c 51 83 00 00 	movl   $0x700,0x83513c
  8007bf:	07 00 00 

	return cnt;
  8007c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007c5:	c9                   	leave  
  8007c6:	c3                   	ret    

008007c7 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007c7:	55                   	push   %ebp
  8007c8:	89 e5                	mov    %esp,%ebp
  8007ca:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007cd:	e8 3d 27 00 00       	call   802f0f <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007d2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007db:	83 ec 08             	sub    $0x8,%esp
  8007de:	ff 75 f4             	pushl  -0xc(%ebp)
  8007e1:	50                   	push   %eax
  8007e2:	e8 ff fe ff ff       	call   8006e6 <vcprintf>
  8007e7:	83 c4 10             	add    $0x10,%esp
  8007ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007ed:	e8 37 27 00 00       	call   802f29 <sys_unlock_cons>
	return cnt;
  8007f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007f5:	c9                   	leave  
  8007f6:	c3                   	ret    

008007f7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007f7:	55                   	push   %ebp
  8007f8:	89 e5                	mov    %esp,%ebp
  8007fa:	53                   	push   %ebx
  8007fb:	83 ec 14             	sub    $0x14,%esp
  8007fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800801:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800804:	8b 45 14             	mov    0x14(%ebp),%eax
  800807:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80080a:	8b 45 18             	mov    0x18(%ebp),%eax
  80080d:	ba 00 00 00 00       	mov    $0x0,%edx
  800812:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800815:	77 55                	ja     80086c <printnum+0x75>
  800817:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80081a:	72 05                	jb     800821 <printnum+0x2a>
  80081c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80081f:	77 4b                	ja     80086c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800821:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800824:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800827:	8b 45 18             	mov    0x18(%ebp),%eax
  80082a:	ba 00 00 00 00       	mov    $0x0,%edx
  80082f:	52                   	push   %edx
  800830:	50                   	push   %eax
  800831:	ff 75 f4             	pushl  -0xc(%ebp)
  800834:	ff 75 f0             	pushl  -0x10(%ebp)
  800837:	e8 64 37 00 00       	call   803fa0 <__udivdi3>
  80083c:	83 c4 10             	add    $0x10,%esp
  80083f:	83 ec 04             	sub    $0x4,%esp
  800842:	ff 75 20             	pushl  0x20(%ebp)
  800845:	53                   	push   %ebx
  800846:	ff 75 18             	pushl  0x18(%ebp)
  800849:	52                   	push   %edx
  80084a:	50                   	push   %eax
  80084b:	ff 75 0c             	pushl  0xc(%ebp)
  80084e:	ff 75 08             	pushl  0x8(%ebp)
  800851:	e8 a1 ff ff ff       	call   8007f7 <printnum>
  800856:	83 c4 20             	add    $0x20,%esp
  800859:	eb 1a                	jmp    800875 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80085b:	83 ec 08             	sub    $0x8,%esp
  80085e:	ff 75 0c             	pushl  0xc(%ebp)
  800861:	ff 75 20             	pushl  0x20(%ebp)
  800864:	8b 45 08             	mov    0x8(%ebp),%eax
  800867:	ff d0                	call   *%eax
  800869:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80086c:	ff 4d 1c             	decl   0x1c(%ebp)
  80086f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800873:	7f e6                	jg     80085b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800875:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800878:	bb 00 00 00 00       	mov    $0x0,%ebx
  80087d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800880:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800883:	53                   	push   %ebx
  800884:	51                   	push   %ecx
  800885:	52                   	push   %edx
  800886:	50                   	push   %eax
  800887:	e8 24 38 00 00       	call   8040b0 <__umoddi3>
  80088c:	83 c4 10             	add    $0x10,%esp
  80088f:	05 94 49 80 00       	add    $0x804994,%eax
  800894:	8a 00                	mov    (%eax),%al
  800896:	0f be c0             	movsbl %al,%eax
  800899:	83 ec 08             	sub    $0x8,%esp
  80089c:	ff 75 0c             	pushl  0xc(%ebp)
  80089f:	50                   	push   %eax
  8008a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a3:	ff d0                	call   *%eax
  8008a5:	83 c4 10             	add    $0x10,%esp
}
  8008a8:	90                   	nop
  8008a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008ac:	c9                   	leave  
  8008ad:	c3                   	ret    

008008ae <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008ae:	55                   	push   %ebp
  8008af:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008b1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008b5:	7e 1c                	jle    8008d3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ba:	8b 00                	mov    (%eax),%eax
  8008bc:	8d 50 08             	lea    0x8(%eax),%edx
  8008bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c2:	89 10                	mov    %edx,(%eax)
  8008c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c7:	8b 00                	mov    (%eax),%eax
  8008c9:	83 e8 08             	sub    $0x8,%eax
  8008cc:	8b 50 04             	mov    0x4(%eax),%edx
  8008cf:	8b 00                	mov    (%eax),%eax
  8008d1:	eb 40                	jmp    800913 <getuint+0x65>
	else if (lflag)
  8008d3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008d7:	74 1e                	je     8008f7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dc:	8b 00                	mov    (%eax),%eax
  8008de:	8d 50 04             	lea    0x4(%eax),%edx
  8008e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e4:	89 10                	mov    %edx,(%eax)
  8008e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e9:	8b 00                	mov    (%eax),%eax
  8008eb:	83 e8 04             	sub    $0x4,%eax
  8008ee:	8b 00                	mov    (%eax),%eax
  8008f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f5:	eb 1c                	jmp    800913 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fa:	8b 00                	mov    (%eax),%eax
  8008fc:	8d 50 04             	lea    0x4(%eax),%edx
  8008ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800902:	89 10                	mov    %edx,(%eax)
  800904:	8b 45 08             	mov    0x8(%ebp),%eax
  800907:	8b 00                	mov    (%eax),%eax
  800909:	83 e8 04             	sub    $0x4,%eax
  80090c:	8b 00                	mov    (%eax),%eax
  80090e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800913:	5d                   	pop    %ebp
  800914:	c3                   	ret    

00800915 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800915:	55                   	push   %ebp
  800916:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800918:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80091c:	7e 1c                	jle    80093a <getint+0x25>
		return va_arg(*ap, long long);
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	8b 00                	mov    (%eax),%eax
  800923:	8d 50 08             	lea    0x8(%eax),%edx
  800926:	8b 45 08             	mov    0x8(%ebp),%eax
  800929:	89 10                	mov    %edx,(%eax)
  80092b:	8b 45 08             	mov    0x8(%ebp),%eax
  80092e:	8b 00                	mov    (%eax),%eax
  800930:	83 e8 08             	sub    $0x8,%eax
  800933:	8b 50 04             	mov    0x4(%eax),%edx
  800936:	8b 00                	mov    (%eax),%eax
  800938:	eb 38                	jmp    800972 <getint+0x5d>
	else if (lflag)
  80093a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80093e:	74 1a                	je     80095a <getint+0x45>
		return va_arg(*ap, long);
  800940:	8b 45 08             	mov    0x8(%ebp),%eax
  800943:	8b 00                	mov    (%eax),%eax
  800945:	8d 50 04             	lea    0x4(%eax),%edx
  800948:	8b 45 08             	mov    0x8(%ebp),%eax
  80094b:	89 10                	mov    %edx,(%eax)
  80094d:	8b 45 08             	mov    0x8(%ebp),%eax
  800950:	8b 00                	mov    (%eax),%eax
  800952:	83 e8 04             	sub    $0x4,%eax
  800955:	8b 00                	mov    (%eax),%eax
  800957:	99                   	cltd   
  800958:	eb 18                	jmp    800972 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80095a:	8b 45 08             	mov    0x8(%ebp),%eax
  80095d:	8b 00                	mov    (%eax),%eax
  80095f:	8d 50 04             	lea    0x4(%eax),%edx
  800962:	8b 45 08             	mov    0x8(%ebp),%eax
  800965:	89 10                	mov    %edx,(%eax)
  800967:	8b 45 08             	mov    0x8(%ebp),%eax
  80096a:	8b 00                	mov    (%eax),%eax
  80096c:	83 e8 04             	sub    $0x4,%eax
  80096f:	8b 00                	mov    (%eax),%eax
  800971:	99                   	cltd   
}
  800972:	5d                   	pop    %ebp
  800973:	c3                   	ret    

00800974 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800974:	55                   	push   %ebp
  800975:	89 e5                	mov    %esp,%ebp
  800977:	56                   	push   %esi
  800978:	53                   	push   %ebx
  800979:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80097c:	eb 17                	jmp    800995 <vprintfmt+0x21>
			if (ch == '\0')
  80097e:	85 db                	test   %ebx,%ebx
  800980:	0f 84 c1 03 00 00    	je     800d47 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800986:	83 ec 08             	sub    $0x8,%esp
  800989:	ff 75 0c             	pushl  0xc(%ebp)
  80098c:	53                   	push   %ebx
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	ff d0                	call   *%eax
  800992:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800995:	8b 45 10             	mov    0x10(%ebp),%eax
  800998:	8d 50 01             	lea    0x1(%eax),%edx
  80099b:	89 55 10             	mov    %edx,0x10(%ebp)
  80099e:	8a 00                	mov    (%eax),%al
  8009a0:	0f b6 d8             	movzbl %al,%ebx
  8009a3:	83 fb 25             	cmp    $0x25,%ebx
  8009a6:	75 d6                	jne    80097e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009a8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009ac:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009b3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009ba:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009c1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8009cb:	8d 50 01             	lea    0x1(%eax),%edx
  8009ce:	89 55 10             	mov    %edx,0x10(%ebp)
  8009d1:	8a 00                	mov    (%eax),%al
  8009d3:	0f b6 d8             	movzbl %al,%ebx
  8009d6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009d9:	83 f8 5b             	cmp    $0x5b,%eax
  8009dc:	0f 87 3d 03 00 00    	ja     800d1f <vprintfmt+0x3ab>
  8009e2:	8b 04 85 b8 49 80 00 	mov    0x8049b8(,%eax,4),%eax
  8009e9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009eb:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009ef:	eb d7                	jmp    8009c8 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009f1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009f5:	eb d1                	jmp    8009c8 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009f7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009fe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a01:	89 d0                	mov    %edx,%eax
  800a03:	c1 e0 02             	shl    $0x2,%eax
  800a06:	01 d0                	add    %edx,%eax
  800a08:	01 c0                	add    %eax,%eax
  800a0a:	01 d8                	add    %ebx,%eax
  800a0c:	83 e8 30             	sub    $0x30,%eax
  800a0f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a12:	8b 45 10             	mov    0x10(%ebp),%eax
  800a15:	8a 00                	mov    (%eax),%al
  800a17:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a1a:	83 fb 2f             	cmp    $0x2f,%ebx
  800a1d:	7e 3e                	jle    800a5d <vprintfmt+0xe9>
  800a1f:	83 fb 39             	cmp    $0x39,%ebx
  800a22:	7f 39                	jg     800a5d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a24:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a27:	eb d5                	jmp    8009fe <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a29:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2c:	83 c0 04             	add    $0x4,%eax
  800a2f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a32:	8b 45 14             	mov    0x14(%ebp),%eax
  800a35:	83 e8 04             	sub    $0x4,%eax
  800a38:	8b 00                	mov    (%eax),%eax
  800a3a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a3d:	eb 1f                	jmp    800a5e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a3f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a43:	79 83                	jns    8009c8 <vprintfmt+0x54>
				width = 0;
  800a45:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a4c:	e9 77 ff ff ff       	jmp    8009c8 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a51:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a58:	e9 6b ff ff ff       	jmp    8009c8 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a5d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a5e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a62:	0f 89 60 ff ff ff    	jns    8009c8 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a68:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a6b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a6e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a75:	e9 4e ff ff ff       	jmp    8009c8 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a7a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a7d:	e9 46 ff ff ff       	jmp    8009c8 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a82:	8b 45 14             	mov    0x14(%ebp),%eax
  800a85:	83 c0 04             	add    $0x4,%eax
  800a88:	89 45 14             	mov    %eax,0x14(%ebp)
  800a8b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8e:	83 e8 04             	sub    $0x4,%eax
  800a91:	8b 00                	mov    (%eax),%eax
  800a93:	83 ec 08             	sub    $0x8,%esp
  800a96:	ff 75 0c             	pushl  0xc(%ebp)
  800a99:	50                   	push   %eax
  800a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9d:	ff d0                	call   *%eax
  800a9f:	83 c4 10             	add    $0x10,%esp
			break;
  800aa2:	e9 9b 02 00 00       	jmp    800d42 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800aa7:	8b 45 14             	mov    0x14(%ebp),%eax
  800aaa:	83 c0 04             	add    $0x4,%eax
  800aad:	89 45 14             	mov    %eax,0x14(%ebp)
  800ab0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab3:	83 e8 04             	sub    $0x4,%eax
  800ab6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ab8:	85 db                	test   %ebx,%ebx
  800aba:	79 02                	jns    800abe <vprintfmt+0x14a>
				err = -err;
  800abc:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800abe:	83 fb 64             	cmp    $0x64,%ebx
  800ac1:	7f 0b                	jg     800ace <vprintfmt+0x15a>
  800ac3:	8b 34 9d 00 48 80 00 	mov    0x804800(,%ebx,4),%esi
  800aca:	85 f6                	test   %esi,%esi
  800acc:	75 19                	jne    800ae7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ace:	53                   	push   %ebx
  800acf:	68 a5 49 80 00       	push   $0x8049a5
  800ad4:	ff 75 0c             	pushl  0xc(%ebp)
  800ad7:	ff 75 08             	pushl  0x8(%ebp)
  800ada:	e8 70 02 00 00       	call   800d4f <printfmt>
  800adf:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ae2:	e9 5b 02 00 00       	jmp    800d42 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ae7:	56                   	push   %esi
  800ae8:	68 ae 49 80 00       	push   $0x8049ae
  800aed:	ff 75 0c             	pushl  0xc(%ebp)
  800af0:	ff 75 08             	pushl  0x8(%ebp)
  800af3:	e8 57 02 00 00       	call   800d4f <printfmt>
  800af8:	83 c4 10             	add    $0x10,%esp
			break;
  800afb:	e9 42 02 00 00       	jmp    800d42 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b00:	8b 45 14             	mov    0x14(%ebp),%eax
  800b03:	83 c0 04             	add    $0x4,%eax
  800b06:	89 45 14             	mov    %eax,0x14(%ebp)
  800b09:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0c:	83 e8 04             	sub    $0x4,%eax
  800b0f:	8b 30                	mov    (%eax),%esi
  800b11:	85 f6                	test   %esi,%esi
  800b13:	75 05                	jne    800b1a <vprintfmt+0x1a6>
				p = "(null)";
  800b15:	be b1 49 80 00       	mov    $0x8049b1,%esi
			if (width > 0 && padc != '-')
  800b1a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b1e:	7e 6d                	jle    800b8d <vprintfmt+0x219>
  800b20:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b24:	74 67                	je     800b8d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b26:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b29:	83 ec 08             	sub    $0x8,%esp
  800b2c:	50                   	push   %eax
  800b2d:	56                   	push   %esi
  800b2e:	e8 1e 03 00 00       	call   800e51 <strnlen>
  800b33:	83 c4 10             	add    $0x10,%esp
  800b36:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b39:	eb 16                	jmp    800b51 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b3b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b3f:	83 ec 08             	sub    $0x8,%esp
  800b42:	ff 75 0c             	pushl  0xc(%ebp)
  800b45:	50                   	push   %eax
  800b46:	8b 45 08             	mov    0x8(%ebp),%eax
  800b49:	ff d0                	call   *%eax
  800b4b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b4e:	ff 4d e4             	decl   -0x1c(%ebp)
  800b51:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b55:	7f e4                	jg     800b3b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b57:	eb 34                	jmp    800b8d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b59:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b5d:	74 1c                	je     800b7b <vprintfmt+0x207>
  800b5f:	83 fb 1f             	cmp    $0x1f,%ebx
  800b62:	7e 05                	jle    800b69 <vprintfmt+0x1f5>
  800b64:	83 fb 7e             	cmp    $0x7e,%ebx
  800b67:	7e 12                	jle    800b7b <vprintfmt+0x207>
					putch('?', putdat);
  800b69:	83 ec 08             	sub    $0x8,%esp
  800b6c:	ff 75 0c             	pushl  0xc(%ebp)
  800b6f:	6a 3f                	push   $0x3f
  800b71:	8b 45 08             	mov    0x8(%ebp),%eax
  800b74:	ff d0                	call   *%eax
  800b76:	83 c4 10             	add    $0x10,%esp
  800b79:	eb 0f                	jmp    800b8a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b7b:	83 ec 08             	sub    $0x8,%esp
  800b7e:	ff 75 0c             	pushl  0xc(%ebp)
  800b81:	53                   	push   %ebx
  800b82:	8b 45 08             	mov    0x8(%ebp),%eax
  800b85:	ff d0                	call   *%eax
  800b87:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b8a:	ff 4d e4             	decl   -0x1c(%ebp)
  800b8d:	89 f0                	mov    %esi,%eax
  800b8f:	8d 70 01             	lea    0x1(%eax),%esi
  800b92:	8a 00                	mov    (%eax),%al
  800b94:	0f be d8             	movsbl %al,%ebx
  800b97:	85 db                	test   %ebx,%ebx
  800b99:	74 24                	je     800bbf <vprintfmt+0x24b>
  800b9b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b9f:	78 b8                	js     800b59 <vprintfmt+0x1e5>
  800ba1:	ff 4d e0             	decl   -0x20(%ebp)
  800ba4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ba8:	79 af                	jns    800b59 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800baa:	eb 13                	jmp    800bbf <vprintfmt+0x24b>
				putch(' ', putdat);
  800bac:	83 ec 08             	sub    $0x8,%esp
  800baf:	ff 75 0c             	pushl  0xc(%ebp)
  800bb2:	6a 20                	push   $0x20
  800bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb7:	ff d0                	call   *%eax
  800bb9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bbc:	ff 4d e4             	decl   -0x1c(%ebp)
  800bbf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bc3:	7f e7                	jg     800bac <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bc5:	e9 78 01 00 00       	jmp    800d42 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bca:	83 ec 08             	sub    $0x8,%esp
  800bcd:	ff 75 e8             	pushl  -0x18(%ebp)
  800bd0:	8d 45 14             	lea    0x14(%ebp),%eax
  800bd3:	50                   	push   %eax
  800bd4:	e8 3c fd ff ff       	call   800915 <getint>
  800bd9:	83 c4 10             	add    $0x10,%esp
  800bdc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bdf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800be2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800be5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800be8:	85 d2                	test   %edx,%edx
  800bea:	79 23                	jns    800c0f <vprintfmt+0x29b>
				putch('-', putdat);
  800bec:	83 ec 08             	sub    $0x8,%esp
  800bef:	ff 75 0c             	pushl  0xc(%ebp)
  800bf2:	6a 2d                	push   $0x2d
  800bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf7:	ff d0                	call   *%eax
  800bf9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c02:	f7 d8                	neg    %eax
  800c04:	83 d2 00             	adc    $0x0,%edx
  800c07:	f7 da                	neg    %edx
  800c09:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c0c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c0f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c16:	e9 bc 00 00 00       	jmp    800cd7 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c1b:	83 ec 08             	sub    $0x8,%esp
  800c1e:	ff 75 e8             	pushl  -0x18(%ebp)
  800c21:	8d 45 14             	lea    0x14(%ebp),%eax
  800c24:	50                   	push   %eax
  800c25:	e8 84 fc ff ff       	call   8008ae <getuint>
  800c2a:	83 c4 10             	add    $0x10,%esp
  800c2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c30:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c33:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c3a:	e9 98 00 00 00       	jmp    800cd7 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c3f:	83 ec 08             	sub    $0x8,%esp
  800c42:	ff 75 0c             	pushl  0xc(%ebp)
  800c45:	6a 58                	push   $0x58
  800c47:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4a:	ff d0                	call   *%eax
  800c4c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c4f:	83 ec 08             	sub    $0x8,%esp
  800c52:	ff 75 0c             	pushl  0xc(%ebp)
  800c55:	6a 58                	push   $0x58
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	ff d0                	call   *%eax
  800c5c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c5f:	83 ec 08             	sub    $0x8,%esp
  800c62:	ff 75 0c             	pushl  0xc(%ebp)
  800c65:	6a 58                	push   $0x58
  800c67:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6a:	ff d0                	call   *%eax
  800c6c:	83 c4 10             	add    $0x10,%esp
			break;
  800c6f:	e9 ce 00 00 00       	jmp    800d42 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c74:	83 ec 08             	sub    $0x8,%esp
  800c77:	ff 75 0c             	pushl  0xc(%ebp)
  800c7a:	6a 30                	push   $0x30
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	ff d0                	call   *%eax
  800c81:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c84:	83 ec 08             	sub    $0x8,%esp
  800c87:	ff 75 0c             	pushl  0xc(%ebp)
  800c8a:	6a 78                	push   $0x78
  800c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8f:	ff d0                	call   *%eax
  800c91:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c94:	8b 45 14             	mov    0x14(%ebp),%eax
  800c97:	83 c0 04             	add    $0x4,%eax
  800c9a:	89 45 14             	mov    %eax,0x14(%ebp)
  800c9d:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca0:	83 e8 04             	sub    $0x4,%eax
  800ca3:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ca5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800caf:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cb6:	eb 1f                	jmp    800cd7 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cb8:	83 ec 08             	sub    $0x8,%esp
  800cbb:	ff 75 e8             	pushl  -0x18(%ebp)
  800cbe:	8d 45 14             	lea    0x14(%ebp),%eax
  800cc1:	50                   	push   %eax
  800cc2:	e8 e7 fb ff ff       	call   8008ae <getuint>
  800cc7:	83 c4 10             	add    $0x10,%esp
  800cca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ccd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cd0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cd7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cde:	83 ec 04             	sub    $0x4,%esp
  800ce1:	52                   	push   %edx
  800ce2:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ce5:	50                   	push   %eax
  800ce6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ce9:	ff 75 f0             	pushl  -0x10(%ebp)
  800cec:	ff 75 0c             	pushl  0xc(%ebp)
  800cef:	ff 75 08             	pushl  0x8(%ebp)
  800cf2:	e8 00 fb ff ff       	call   8007f7 <printnum>
  800cf7:	83 c4 20             	add    $0x20,%esp
			break;
  800cfa:	eb 46                	jmp    800d42 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cfc:	83 ec 08             	sub    $0x8,%esp
  800cff:	ff 75 0c             	pushl  0xc(%ebp)
  800d02:	53                   	push   %ebx
  800d03:	8b 45 08             	mov    0x8(%ebp),%eax
  800d06:	ff d0                	call   *%eax
  800d08:	83 c4 10             	add    $0x10,%esp
			break;
  800d0b:	eb 35                	jmp    800d42 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d0d:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
			break;
  800d14:	eb 2c                	jmp    800d42 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d16:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
			break;
  800d1d:	eb 23                	jmp    800d42 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d1f:	83 ec 08             	sub    $0x8,%esp
  800d22:	ff 75 0c             	pushl  0xc(%ebp)
  800d25:	6a 25                	push   $0x25
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	ff d0                	call   *%eax
  800d2c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d2f:	ff 4d 10             	decl   0x10(%ebp)
  800d32:	eb 03                	jmp    800d37 <vprintfmt+0x3c3>
  800d34:	ff 4d 10             	decl   0x10(%ebp)
  800d37:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3a:	48                   	dec    %eax
  800d3b:	8a 00                	mov    (%eax),%al
  800d3d:	3c 25                	cmp    $0x25,%al
  800d3f:	75 f3                	jne    800d34 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d41:	90                   	nop
		}
	}
  800d42:	e9 35 fc ff ff       	jmp    80097c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d47:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d48:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d4b:	5b                   	pop    %ebx
  800d4c:	5e                   	pop    %esi
  800d4d:	5d                   	pop    %ebp
  800d4e:	c3                   	ret    

00800d4f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d4f:	55                   	push   %ebp
  800d50:	89 e5                	mov    %esp,%ebp
  800d52:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d55:	8d 45 10             	lea    0x10(%ebp),%eax
  800d58:	83 c0 04             	add    $0x4,%eax
  800d5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d5e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d61:	ff 75 f4             	pushl  -0xc(%ebp)
  800d64:	50                   	push   %eax
  800d65:	ff 75 0c             	pushl  0xc(%ebp)
  800d68:	ff 75 08             	pushl  0x8(%ebp)
  800d6b:	e8 04 fc ff ff       	call   800974 <vprintfmt>
  800d70:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d73:	90                   	nop
  800d74:	c9                   	leave  
  800d75:	c3                   	ret    

00800d76 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d76:	55                   	push   %ebp
  800d77:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7c:	8b 40 08             	mov    0x8(%eax),%eax
  800d7f:	8d 50 01             	lea    0x1(%eax),%edx
  800d82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d85:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8b:	8b 10                	mov    (%eax),%edx
  800d8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d90:	8b 40 04             	mov    0x4(%eax),%eax
  800d93:	39 c2                	cmp    %eax,%edx
  800d95:	73 12                	jae    800da9 <sprintputch+0x33>
		*b->buf++ = ch;
  800d97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9a:	8b 00                	mov    (%eax),%eax
  800d9c:	8d 48 01             	lea    0x1(%eax),%ecx
  800d9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da2:	89 0a                	mov    %ecx,(%edx)
  800da4:	8b 55 08             	mov    0x8(%ebp),%edx
  800da7:	88 10                	mov    %dl,(%eax)
}
  800da9:	90                   	nop
  800daa:	5d                   	pop    %ebp
  800dab:	c3                   	ret    

00800dac <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dac:	55                   	push   %ebp
  800dad:	89 e5                	mov    %esp,%ebp
  800daf:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800db2:	8b 45 08             	mov    0x8(%ebp),%eax
  800db5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800db8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc1:	01 d0                	add    %edx,%eax
  800dc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dc6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dcd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dd1:	74 06                	je     800dd9 <vsnprintf+0x2d>
  800dd3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dd7:	7f 07                	jg     800de0 <vsnprintf+0x34>
		return -E_INVAL;
  800dd9:	b8 03 00 00 00       	mov    $0x3,%eax
  800dde:	eb 20                	jmp    800e00 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800de0:	ff 75 14             	pushl  0x14(%ebp)
  800de3:	ff 75 10             	pushl  0x10(%ebp)
  800de6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800de9:	50                   	push   %eax
  800dea:	68 76 0d 80 00       	push   $0x800d76
  800def:	e8 80 fb ff ff       	call   800974 <vprintfmt>
  800df4:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800df7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dfa:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e00:	c9                   	leave  
  800e01:	c3                   	ret    

00800e02 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e02:	55                   	push   %ebp
  800e03:	89 e5                	mov    %esp,%ebp
  800e05:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e08:	8d 45 10             	lea    0x10(%ebp),%eax
  800e0b:	83 c0 04             	add    $0x4,%eax
  800e0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e11:	8b 45 10             	mov    0x10(%ebp),%eax
  800e14:	ff 75 f4             	pushl  -0xc(%ebp)
  800e17:	50                   	push   %eax
  800e18:	ff 75 0c             	pushl  0xc(%ebp)
  800e1b:	ff 75 08             	pushl  0x8(%ebp)
  800e1e:	e8 89 ff ff ff       	call   800dac <vsnprintf>
  800e23:	83 c4 10             	add    $0x10,%esp
  800e26:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e29:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e2c:	c9                   	leave  
  800e2d:	c3                   	ret    

00800e2e <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e2e:	55                   	push   %ebp
  800e2f:	89 e5                	mov    %esp,%ebp
  800e31:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e34:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e3b:	eb 06                	jmp    800e43 <strlen+0x15>
		n++;
  800e3d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e40:	ff 45 08             	incl   0x8(%ebp)
  800e43:	8b 45 08             	mov    0x8(%ebp),%eax
  800e46:	8a 00                	mov    (%eax),%al
  800e48:	84 c0                	test   %al,%al
  800e4a:	75 f1                	jne    800e3d <strlen+0xf>
		n++;
	return n;
  800e4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e4f:	c9                   	leave  
  800e50:	c3                   	ret    

00800e51 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e51:	55                   	push   %ebp
  800e52:	89 e5                	mov    %esp,%ebp
  800e54:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e57:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e5e:	eb 09                	jmp    800e69 <strnlen+0x18>
		n++;
  800e60:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e63:	ff 45 08             	incl   0x8(%ebp)
  800e66:	ff 4d 0c             	decl   0xc(%ebp)
  800e69:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e6d:	74 09                	je     800e78 <strnlen+0x27>
  800e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e72:	8a 00                	mov    (%eax),%al
  800e74:	84 c0                	test   %al,%al
  800e76:	75 e8                	jne    800e60 <strnlen+0xf>
		n++;
	return n;
  800e78:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e7b:	c9                   	leave  
  800e7c:	c3                   	ret    

00800e7d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
  800e80:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e89:	90                   	nop
  800e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8d:	8d 50 01             	lea    0x1(%eax),%edx
  800e90:	89 55 08             	mov    %edx,0x8(%ebp)
  800e93:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e96:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e99:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e9c:	8a 12                	mov    (%edx),%dl
  800e9e:	88 10                	mov    %dl,(%eax)
  800ea0:	8a 00                	mov    (%eax),%al
  800ea2:	84 c0                	test   %al,%al
  800ea4:	75 e4                	jne    800e8a <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ea6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ea9:	c9                   	leave  
  800eaa:	c3                   	ret    

00800eab <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800eab:	55                   	push   %ebp
  800eac:	89 e5                	mov    %esp,%ebp
  800eae:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800eb7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ebe:	eb 1f                	jmp    800edf <strncpy+0x34>
		*dst++ = *src;
  800ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec3:	8d 50 01             	lea    0x1(%eax),%edx
  800ec6:	89 55 08             	mov    %edx,0x8(%ebp)
  800ec9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ecc:	8a 12                	mov    (%edx),%dl
  800ece:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ed0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed3:	8a 00                	mov    (%eax),%al
  800ed5:	84 c0                	test   %al,%al
  800ed7:	74 03                	je     800edc <strncpy+0x31>
			src++;
  800ed9:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800edc:	ff 45 fc             	incl   -0x4(%ebp)
  800edf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee2:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ee5:	72 d9                	jb     800ec0 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ee7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800eea:	c9                   	leave  
  800eeb:	c3                   	ret    

00800eec <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800eec:	55                   	push   %ebp
  800eed:	89 e5                	mov    %esp,%ebp
  800eef:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ef8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800efc:	74 30                	je     800f2e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800efe:	eb 16                	jmp    800f16 <strlcpy+0x2a>
			*dst++ = *src++;
  800f00:	8b 45 08             	mov    0x8(%ebp),%eax
  800f03:	8d 50 01             	lea    0x1(%eax),%edx
  800f06:	89 55 08             	mov    %edx,0x8(%ebp)
  800f09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f0c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f0f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f12:	8a 12                	mov    (%edx),%dl
  800f14:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f16:	ff 4d 10             	decl   0x10(%ebp)
  800f19:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f1d:	74 09                	je     800f28 <strlcpy+0x3c>
  800f1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f22:	8a 00                	mov    (%eax),%al
  800f24:	84 c0                	test   %al,%al
  800f26:	75 d8                	jne    800f00 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f2e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f31:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f34:	29 c2                	sub    %eax,%edx
  800f36:	89 d0                	mov    %edx,%eax
}
  800f38:	c9                   	leave  
  800f39:	c3                   	ret    

00800f3a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f3a:	55                   	push   %ebp
  800f3b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f3d:	eb 06                	jmp    800f45 <strcmp+0xb>
		p++, q++;
  800f3f:	ff 45 08             	incl   0x8(%ebp)
  800f42:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f45:	8b 45 08             	mov    0x8(%ebp),%eax
  800f48:	8a 00                	mov    (%eax),%al
  800f4a:	84 c0                	test   %al,%al
  800f4c:	74 0e                	je     800f5c <strcmp+0x22>
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f51:	8a 10                	mov    (%eax),%dl
  800f53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f56:	8a 00                	mov    (%eax),%al
  800f58:	38 c2                	cmp    %al,%dl
  800f5a:	74 e3                	je     800f3f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5f:	8a 00                	mov    (%eax),%al
  800f61:	0f b6 d0             	movzbl %al,%edx
  800f64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f67:	8a 00                	mov    (%eax),%al
  800f69:	0f b6 c0             	movzbl %al,%eax
  800f6c:	29 c2                	sub    %eax,%edx
  800f6e:	89 d0                	mov    %edx,%eax
}
  800f70:	5d                   	pop    %ebp
  800f71:	c3                   	ret    

00800f72 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f72:	55                   	push   %ebp
  800f73:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f75:	eb 09                	jmp    800f80 <strncmp+0xe>
		n--, p++, q++;
  800f77:	ff 4d 10             	decl   0x10(%ebp)
  800f7a:	ff 45 08             	incl   0x8(%ebp)
  800f7d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f80:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f84:	74 17                	je     800f9d <strncmp+0x2b>
  800f86:	8b 45 08             	mov    0x8(%ebp),%eax
  800f89:	8a 00                	mov    (%eax),%al
  800f8b:	84 c0                	test   %al,%al
  800f8d:	74 0e                	je     800f9d <strncmp+0x2b>
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	8a 10                	mov    (%eax),%dl
  800f94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f97:	8a 00                	mov    (%eax),%al
  800f99:	38 c2                	cmp    %al,%dl
  800f9b:	74 da                	je     800f77 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f9d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa1:	75 07                	jne    800faa <strncmp+0x38>
		return 0;
  800fa3:	b8 00 00 00 00       	mov    $0x0,%eax
  800fa8:	eb 14                	jmp    800fbe <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800faa:	8b 45 08             	mov    0x8(%ebp),%eax
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	0f b6 d0             	movzbl %al,%edx
  800fb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb5:	8a 00                	mov    (%eax),%al
  800fb7:	0f b6 c0             	movzbl %al,%eax
  800fba:	29 c2                	sub    %eax,%edx
  800fbc:	89 d0                	mov    %edx,%eax
}
  800fbe:	5d                   	pop    %ebp
  800fbf:	c3                   	ret    

00800fc0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fc0:	55                   	push   %ebp
  800fc1:	89 e5                	mov    %esp,%ebp
  800fc3:	83 ec 04             	sub    $0x4,%esp
  800fc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fcc:	eb 12                	jmp    800fe0 <strchr+0x20>
		if (*s == c)
  800fce:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd1:	8a 00                	mov    (%eax),%al
  800fd3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fd6:	75 05                	jne    800fdd <strchr+0x1d>
			return (char *) s;
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	eb 11                	jmp    800fee <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fdd:	ff 45 08             	incl   0x8(%ebp)
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	8a 00                	mov    (%eax),%al
  800fe5:	84 c0                	test   %al,%al
  800fe7:	75 e5                	jne    800fce <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fe9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fee:	c9                   	leave  
  800fef:	c3                   	ret    

00800ff0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ff0:	55                   	push   %ebp
  800ff1:	89 e5                	mov    %esp,%ebp
  800ff3:	83 ec 04             	sub    $0x4,%esp
  800ff6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ffc:	eb 0d                	jmp    80100b <strfind+0x1b>
		if (*s == c)
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	8a 00                	mov    (%eax),%al
  801003:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801006:	74 0e                	je     801016 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801008:	ff 45 08             	incl   0x8(%ebp)
  80100b:	8b 45 08             	mov    0x8(%ebp),%eax
  80100e:	8a 00                	mov    (%eax),%al
  801010:	84 c0                	test   %al,%al
  801012:	75 ea                	jne    800ffe <strfind+0xe>
  801014:	eb 01                	jmp    801017 <strfind+0x27>
		if (*s == c)
			break;
  801016:	90                   	nop
	return (char *) s;
  801017:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80101a:	c9                   	leave  
  80101b:	c3                   	ret    

0080101c <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  80101c:	55                   	push   %ebp
  80101d:	89 e5                	mov    %esp,%ebp
  80101f:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801022:	8b 45 08             	mov    0x8(%ebp),%eax
  801025:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801028:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80102c:	76 63                	jbe    801091 <memset+0x75>
		uint64 data_block = c;
  80102e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801031:	99                   	cltd   
  801032:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801035:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801038:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80103b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80103e:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801042:	c1 e0 08             	shl    $0x8,%eax
  801045:	09 45 f0             	or     %eax,-0x10(%ebp)
  801048:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80104b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80104e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801051:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801055:	c1 e0 10             	shl    $0x10,%eax
  801058:	09 45 f0             	or     %eax,-0x10(%ebp)
  80105b:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  80105e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801061:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801064:	89 c2                	mov    %eax,%edx
  801066:	b8 00 00 00 00       	mov    $0x0,%eax
  80106b:	09 45 f0             	or     %eax,-0x10(%ebp)
  80106e:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801071:	eb 18                	jmp    80108b <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801073:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801076:	8d 41 08             	lea    0x8(%ecx),%eax
  801079:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80107c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80107f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801082:	89 01                	mov    %eax,(%ecx)
  801084:	89 51 04             	mov    %edx,0x4(%ecx)
  801087:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80108b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80108f:	77 e2                	ja     801073 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801091:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801095:	74 23                	je     8010ba <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801097:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80109a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80109d:	eb 0e                	jmp    8010ad <memset+0x91>
			*p8++ = (uint8)c;
  80109f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a2:	8d 50 01             	lea    0x1(%eax),%edx
  8010a5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ab:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8010ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010b3:	89 55 10             	mov    %edx,0x10(%ebp)
  8010b6:	85 c0                	test   %eax,%eax
  8010b8:	75 e5                	jne    80109f <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8010ba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010bd:	c9                   	leave  
  8010be:	c3                   	ret    

008010bf <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010bf:	55                   	push   %ebp
  8010c0:	89 e5                	mov    %esp,%ebp
  8010c2:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8010c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8010cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ce:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8010d1:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010d5:	76 24                	jbe    8010fb <memcpy+0x3c>
		while(n >= 8){
  8010d7:	eb 1c                	jmp    8010f5 <memcpy+0x36>
			*d64 = *s64;
  8010d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010dc:	8b 50 04             	mov    0x4(%eax),%edx
  8010df:	8b 00                	mov    (%eax),%eax
  8010e1:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010e4:	89 01                	mov    %eax,(%ecx)
  8010e6:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8010e9:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8010ed:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8010f1:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8010f5:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010f9:	77 de                	ja     8010d9 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8010fb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ff:	74 31                	je     801132 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801101:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801104:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801107:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80110a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80110d:	eb 16                	jmp    801125 <memcpy+0x66>
			*d8++ = *s8++;
  80110f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801112:	8d 50 01             	lea    0x1(%eax),%edx
  801115:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801118:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80111b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80111e:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801121:	8a 12                	mov    (%edx),%dl
  801123:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801125:	8b 45 10             	mov    0x10(%ebp),%eax
  801128:	8d 50 ff             	lea    -0x1(%eax),%edx
  80112b:	89 55 10             	mov    %edx,0x10(%ebp)
  80112e:	85 c0                	test   %eax,%eax
  801130:	75 dd                	jne    80110f <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801132:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801135:	c9                   	leave  
  801136:	c3                   	ret    

00801137 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801137:	55                   	push   %ebp
  801138:	89 e5                	mov    %esp,%ebp
  80113a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80113d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801140:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801143:	8b 45 08             	mov    0x8(%ebp),%eax
  801146:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801149:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80114c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80114f:	73 50                	jae    8011a1 <memmove+0x6a>
  801151:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801154:	8b 45 10             	mov    0x10(%ebp),%eax
  801157:	01 d0                	add    %edx,%eax
  801159:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80115c:	76 43                	jbe    8011a1 <memmove+0x6a>
		s += n;
  80115e:	8b 45 10             	mov    0x10(%ebp),%eax
  801161:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801164:	8b 45 10             	mov    0x10(%ebp),%eax
  801167:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80116a:	eb 10                	jmp    80117c <memmove+0x45>
			*--d = *--s;
  80116c:	ff 4d f8             	decl   -0x8(%ebp)
  80116f:	ff 4d fc             	decl   -0x4(%ebp)
  801172:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801175:	8a 10                	mov    (%eax),%dl
  801177:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80117a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80117c:	8b 45 10             	mov    0x10(%ebp),%eax
  80117f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801182:	89 55 10             	mov    %edx,0x10(%ebp)
  801185:	85 c0                	test   %eax,%eax
  801187:	75 e3                	jne    80116c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801189:	eb 23                	jmp    8011ae <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80118b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80118e:	8d 50 01             	lea    0x1(%eax),%edx
  801191:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801194:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801197:	8d 4a 01             	lea    0x1(%edx),%ecx
  80119a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80119d:	8a 12                	mov    (%edx),%dl
  80119f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011a7:	89 55 10             	mov    %edx,0x10(%ebp)
  8011aa:	85 c0                	test   %eax,%eax
  8011ac:	75 dd                	jne    80118b <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011ae:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011b1:	c9                   	leave  
  8011b2:	c3                   	ret    

008011b3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011b3:	55                   	push   %ebp
  8011b4:	89 e5                	mov    %esp,%ebp
  8011b6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011c5:	eb 2a                	jmp    8011f1 <memcmp+0x3e>
		if (*s1 != *s2)
  8011c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ca:	8a 10                	mov    (%eax),%dl
  8011cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011cf:	8a 00                	mov    (%eax),%al
  8011d1:	38 c2                	cmp    %al,%dl
  8011d3:	74 16                	je     8011eb <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d8:	8a 00                	mov    (%eax),%al
  8011da:	0f b6 d0             	movzbl %al,%edx
  8011dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e0:	8a 00                	mov    (%eax),%al
  8011e2:	0f b6 c0             	movzbl %al,%eax
  8011e5:	29 c2                	sub    %eax,%edx
  8011e7:	89 d0                	mov    %edx,%eax
  8011e9:	eb 18                	jmp    801203 <memcmp+0x50>
		s1++, s2++;
  8011eb:	ff 45 fc             	incl   -0x4(%ebp)
  8011ee:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011f7:	89 55 10             	mov    %edx,0x10(%ebp)
  8011fa:	85 c0                	test   %eax,%eax
  8011fc:	75 c9                	jne    8011c7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801203:	c9                   	leave  
  801204:	c3                   	ret    

00801205 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801205:	55                   	push   %ebp
  801206:	89 e5                	mov    %esp,%ebp
  801208:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80120b:	8b 55 08             	mov    0x8(%ebp),%edx
  80120e:	8b 45 10             	mov    0x10(%ebp),%eax
  801211:	01 d0                	add    %edx,%eax
  801213:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801216:	eb 15                	jmp    80122d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801218:	8b 45 08             	mov    0x8(%ebp),%eax
  80121b:	8a 00                	mov    (%eax),%al
  80121d:	0f b6 d0             	movzbl %al,%edx
  801220:	8b 45 0c             	mov    0xc(%ebp),%eax
  801223:	0f b6 c0             	movzbl %al,%eax
  801226:	39 c2                	cmp    %eax,%edx
  801228:	74 0d                	je     801237 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80122a:	ff 45 08             	incl   0x8(%ebp)
  80122d:	8b 45 08             	mov    0x8(%ebp),%eax
  801230:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801233:	72 e3                	jb     801218 <memfind+0x13>
  801235:	eb 01                	jmp    801238 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801237:	90                   	nop
	return (void *) s;
  801238:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80123b:	c9                   	leave  
  80123c:	c3                   	ret    

0080123d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80123d:	55                   	push   %ebp
  80123e:	89 e5                	mov    %esp,%ebp
  801240:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801243:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80124a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801251:	eb 03                	jmp    801256 <strtol+0x19>
		s++;
  801253:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801256:	8b 45 08             	mov    0x8(%ebp),%eax
  801259:	8a 00                	mov    (%eax),%al
  80125b:	3c 20                	cmp    $0x20,%al
  80125d:	74 f4                	je     801253 <strtol+0x16>
  80125f:	8b 45 08             	mov    0x8(%ebp),%eax
  801262:	8a 00                	mov    (%eax),%al
  801264:	3c 09                	cmp    $0x9,%al
  801266:	74 eb                	je     801253 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801268:	8b 45 08             	mov    0x8(%ebp),%eax
  80126b:	8a 00                	mov    (%eax),%al
  80126d:	3c 2b                	cmp    $0x2b,%al
  80126f:	75 05                	jne    801276 <strtol+0x39>
		s++;
  801271:	ff 45 08             	incl   0x8(%ebp)
  801274:	eb 13                	jmp    801289 <strtol+0x4c>
	else if (*s == '-')
  801276:	8b 45 08             	mov    0x8(%ebp),%eax
  801279:	8a 00                	mov    (%eax),%al
  80127b:	3c 2d                	cmp    $0x2d,%al
  80127d:	75 0a                	jne    801289 <strtol+0x4c>
		s++, neg = 1;
  80127f:	ff 45 08             	incl   0x8(%ebp)
  801282:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801289:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80128d:	74 06                	je     801295 <strtol+0x58>
  80128f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801293:	75 20                	jne    8012b5 <strtol+0x78>
  801295:	8b 45 08             	mov    0x8(%ebp),%eax
  801298:	8a 00                	mov    (%eax),%al
  80129a:	3c 30                	cmp    $0x30,%al
  80129c:	75 17                	jne    8012b5 <strtol+0x78>
  80129e:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a1:	40                   	inc    %eax
  8012a2:	8a 00                	mov    (%eax),%al
  8012a4:	3c 78                	cmp    $0x78,%al
  8012a6:	75 0d                	jne    8012b5 <strtol+0x78>
		s += 2, base = 16;
  8012a8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012ac:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012b3:	eb 28                	jmp    8012dd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012b5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012b9:	75 15                	jne    8012d0 <strtol+0x93>
  8012bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012be:	8a 00                	mov    (%eax),%al
  8012c0:	3c 30                	cmp    $0x30,%al
  8012c2:	75 0c                	jne    8012d0 <strtol+0x93>
		s++, base = 8;
  8012c4:	ff 45 08             	incl   0x8(%ebp)
  8012c7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012ce:	eb 0d                	jmp    8012dd <strtol+0xa0>
	else if (base == 0)
  8012d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012d4:	75 07                	jne    8012dd <strtol+0xa0>
		base = 10;
  8012d6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e0:	8a 00                	mov    (%eax),%al
  8012e2:	3c 2f                	cmp    $0x2f,%al
  8012e4:	7e 19                	jle    8012ff <strtol+0xc2>
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e9:	8a 00                	mov    (%eax),%al
  8012eb:	3c 39                	cmp    $0x39,%al
  8012ed:	7f 10                	jg     8012ff <strtol+0xc2>
			dig = *s - '0';
  8012ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f2:	8a 00                	mov    (%eax),%al
  8012f4:	0f be c0             	movsbl %al,%eax
  8012f7:	83 e8 30             	sub    $0x30,%eax
  8012fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012fd:	eb 42                	jmp    801341 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801302:	8a 00                	mov    (%eax),%al
  801304:	3c 60                	cmp    $0x60,%al
  801306:	7e 19                	jle    801321 <strtol+0xe4>
  801308:	8b 45 08             	mov    0x8(%ebp),%eax
  80130b:	8a 00                	mov    (%eax),%al
  80130d:	3c 7a                	cmp    $0x7a,%al
  80130f:	7f 10                	jg     801321 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801311:	8b 45 08             	mov    0x8(%ebp),%eax
  801314:	8a 00                	mov    (%eax),%al
  801316:	0f be c0             	movsbl %al,%eax
  801319:	83 e8 57             	sub    $0x57,%eax
  80131c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80131f:	eb 20                	jmp    801341 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801321:	8b 45 08             	mov    0x8(%ebp),%eax
  801324:	8a 00                	mov    (%eax),%al
  801326:	3c 40                	cmp    $0x40,%al
  801328:	7e 39                	jle    801363 <strtol+0x126>
  80132a:	8b 45 08             	mov    0x8(%ebp),%eax
  80132d:	8a 00                	mov    (%eax),%al
  80132f:	3c 5a                	cmp    $0x5a,%al
  801331:	7f 30                	jg     801363 <strtol+0x126>
			dig = *s - 'A' + 10;
  801333:	8b 45 08             	mov    0x8(%ebp),%eax
  801336:	8a 00                	mov    (%eax),%al
  801338:	0f be c0             	movsbl %al,%eax
  80133b:	83 e8 37             	sub    $0x37,%eax
  80133e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801341:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801344:	3b 45 10             	cmp    0x10(%ebp),%eax
  801347:	7d 19                	jge    801362 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801349:	ff 45 08             	incl   0x8(%ebp)
  80134c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80134f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801353:	89 c2                	mov    %eax,%edx
  801355:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801358:	01 d0                	add    %edx,%eax
  80135a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80135d:	e9 7b ff ff ff       	jmp    8012dd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801362:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801363:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801367:	74 08                	je     801371 <strtol+0x134>
		*endptr = (char *) s;
  801369:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136c:	8b 55 08             	mov    0x8(%ebp),%edx
  80136f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801371:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801375:	74 07                	je     80137e <strtol+0x141>
  801377:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80137a:	f7 d8                	neg    %eax
  80137c:	eb 03                	jmp    801381 <strtol+0x144>
  80137e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801381:	c9                   	leave  
  801382:	c3                   	ret    

00801383 <ltostr>:

void
ltostr(long value, char *str)
{
  801383:	55                   	push   %ebp
  801384:	89 e5                	mov    %esp,%ebp
  801386:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801389:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801390:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801397:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80139b:	79 13                	jns    8013b0 <ltostr+0x2d>
	{
		neg = 1;
  80139d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a7:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013aa:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013ad:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013b8:	99                   	cltd   
  8013b9:	f7 f9                	idiv   %ecx
  8013bb:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013c1:	8d 50 01             	lea    0x1(%eax),%edx
  8013c4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013c7:	89 c2                	mov    %eax,%edx
  8013c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cc:	01 d0                	add    %edx,%eax
  8013ce:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013d1:	83 c2 30             	add    $0x30,%edx
  8013d4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013d9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013de:	f7 e9                	imul   %ecx
  8013e0:	c1 fa 02             	sar    $0x2,%edx
  8013e3:	89 c8                	mov    %ecx,%eax
  8013e5:	c1 f8 1f             	sar    $0x1f,%eax
  8013e8:	29 c2                	sub    %eax,%edx
  8013ea:	89 d0                	mov    %edx,%eax
  8013ec:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013f3:	75 bb                	jne    8013b0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013ff:	48                   	dec    %eax
  801400:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801403:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801407:	74 3d                	je     801446 <ltostr+0xc3>
		start = 1 ;
  801409:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801410:	eb 34                	jmp    801446 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801412:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801415:	8b 45 0c             	mov    0xc(%ebp),%eax
  801418:	01 d0                	add    %edx,%eax
  80141a:	8a 00                	mov    (%eax),%al
  80141c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80141f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801422:	8b 45 0c             	mov    0xc(%ebp),%eax
  801425:	01 c2                	add    %eax,%edx
  801427:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80142a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142d:	01 c8                	add    %ecx,%eax
  80142f:	8a 00                	mov    (%eax),%al
  801431:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801433:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801436:	8b 45 0c             	mov    0xc(%ebp),%eax
  801439:	01 c2                	add    %eax,%edx
  80143b:	8a 45 eb             	mov    -0x15(%ebp),%al
  80143e:	88 02                	mov    %al,(%edx)
		start++ ;
  801440:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801443:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801446:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801449:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80144c:	7c c4                	jl     801412 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80144e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801451:	8b 45 0c             	mov    0xc(%ebp),%eax
  801454:	01 d0                	add    %edx,%eax
  801456:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801459:	90                   	nop
  80145a:	c9                   	leave  
  80145b:	c3                   	ret    

0080145c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
  80145f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801462:	ff 75 08             	pushl  0x8(%ebp)
  801465:	e8 c4 f9 ff ff       	call   800e2e <strlen>
  80146a:	83 c4 04             	add    $0x4,%esp
  80146d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801470:	ff 75 0c             	pushl  0xc(%ebp)
  801473:	e8 b6 f9 ff ff       	call   800e2e <strlen>
  801478:	83 c4 04             	add    $0x4,%esp
  80147b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80147e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801485:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80148c:	eb 17                	jmp    8014a5 <strcconcat+0x49>
		final[s] = str1[s] ;
  80148e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801491:	8b 45 10             	mov    0x10(%ebp),%eax
  801494:	01 c2                	add    %eax,%edx
  801496:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	01 c8                	add    %ecx,%eax
  80149e:	8a 00                	mov    (%eax),%al
  8014a0:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014a2:	ff 45 fc             	incl   -0x4(%ebp)
  8014a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014a8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014ab:	7c e1                	jl     80148e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014ad:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014b4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014bb:	eb 1f                	jmp    8014dc <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c0:	8d 50 01             	lea    0x1(%eax),%edx
  8014c3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014c6:	89 c2                	mov    %eax,%edx
  8014c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8014cb:	01 c2                	add    %eax,%edx
  8014cd:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d3:	01 c8                	add    %ecx,%eax
  8014d5:	8a 00                	mov    (%eax),%al
  8014d7:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014d9:	ff 45 f8             	incl   -0x8(%ebp)
  8014dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014e2:	7c d9                	jl     8014bd <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014e4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ea:	01 d0                	add    %edx,%eax
  8014ec:	c6 00 00             	movb   $0x0,(%eax)
}
  8014ef:	90                   	nop
  8014f0:	c9                   	leave  
  8014f1:	c3                   	ret    

008014f2 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014f2:	55                   	push   %ebp
  8014f3:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014fe:	8b 45 14             	mov    0x14(%ebp),%eax
  801501:	8b 00                	mov    (%eax),%eax
  801503:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80150a:	8b 45 10             	mov    0x10(%ebp),%eax
  80150d:	01 d0                	add    %edx,%eax
  80150f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801515:	eb 0c                	jmp    801523 <strsplit+0x31>
			*string++ = 0;
  801517:	8b 45 08             	mov    0x8(%ebp),%eax
  80151a:	8d 50 01             	lea    0x1(%eax),%edx
  80151d:	89 55 08             	mov    %edx,0x8(%ebp)
  801520:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801523:	8b 45 08             	mov    0x8(%ebp),%eax
  801526:	8a 00                	mov    (%eax),%al
  801528:	84 c0                	test   %al,%al
  80152a:	74 18                	je     801544 <strsplit+0x52>
  80152c:	8b 45 08             	mov    0x8(%ebp),%eax
  80152f:	8a 00                	mov    (%eax),%al
  801531:	0f be c0             	movsbl %al,%eax
  801534:	50                   	push   %eax
  801535:	ff 75 0c             	pushl  0xc(%ebp)
  801538:	e8 83 fa ff ff       	call   800fc0 <strchr>
  80153d:	83 c4 08             	add    $0x8,%esp
  801540:	85 c0                	test   %eax,%eax
  801542:	75 d3                	jne    801517 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801544:	8b 45 08             	mov    0x8(%ebp),%eax
  801547:	8a 00                	mov    (%eax),%al
  801549:	84 c0                	test   %al,%al
  80154b:	74 5a                	je     8015a7 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80154d:	8b 45 14             	mov    0x14(%ebp),%eax
  801550:	8b 00                	mov    (%eax),%eax
  801552:	83 f8 0f             	cmp    $0xf,%eax
  801555:	75 07                	jne    80155e <strsplit+0x6c>
		{
			return 0;
  801557:	b8 00 00 00 00       	mov    $0x0,%eax
  80155c:	eb 66                	jmp    8015c4 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80155e:	8b 45 14             	mov    0x14(%ebp),%eax
  801561:	8b 00                	mov    (%eax),%eax
  801563:	8d 48 01             	lea    0x1(%eax),%ecx
  801566:	8b 55 14             	mov    0x14(%ebp),%edx
  801569:	89 0a                	mov    %ecx,(%edx)
  80156b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801572:	8b 45 10             	mov    0x10(%ebp),%eax
  801575:	01 c2                	add    %eax,%edx
  801577:	8b 45 08             	mov    0x8(%ebp),%eax
  80157a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80157c:	eb 03                	jmp    801581 <strsplit+0x8f>
			string++;
  80157e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801581:	8b 45 08             	mov    0x8(%ebp),%eax
  801584:	8a 00                	mov    (%eax),%al
  801586:	84 c0                	test   %al,%al
  801588:	74 8b                	je     801515 <strsplit+0x23>
  80158a:	8b 45 08             	mov    0x8(%ebp),%eax
  80158d:	8a 00                	mov    (%eax),%al
  80158f:	0f be c0             	movsbl %al,%eax
  801592:	50                   	push   %eax
  801593:	ff 75 0c             	pushl  0xc(%ebp)
  801596:	e8 25 fa ff ff       	call   800fc0 <strchr>
  80159b:	83 c4 08             	add    $0x8,%esp
  80159e:	85 c0                	test   %eax,%eax
  8015a0:	74 dc                	je     80157e <strsplit+0x8c>
			string++;
	}
  8015a2:	e9 6e ff ff ff       	jmp    801515 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015a7:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ab:	8b 00                	mov    (%eax),%eax
  8015ad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b7:	01 d0                	add    %edx,%eax
  8015b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015bf:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015c4:	c9                   	leave  
  8015c5:	c3                   	ret    

008015c6 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015c6:	55                   	push   %ebp
  8015c7:	89 e5                	mov    %esp,%ebp
  8015c9:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8015cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8015d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015d9:	eb 4a                	jmp    801625 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8015db:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015de:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e1:	01 c2                	add    %eax,%edx
  8015e3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e9:	01 c8                	add    %ecx,%eax
  8015eb:	8a 00                	mov    (%eax),%al
  8015ed:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8015ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f5:	01 d0                	add    %edx,%eax
  8015f7:	8a 00                	mov    (%eax),%al
  8015f9:	3c 40                	cmp    $0x40,%al
  8015fb:	7e 25                	jle    801622 <str2lower+0x5c>
  8015fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801600:	8b 45 0c             	mov    0xc(%ebp),%eax
  801603:	01 d0                	add    %edx,%eax
  801605:	8a 00                	mov    (%eax),%al
  801607:	3c 5a                	cmp    $0x5a,%al
  801609:	7f 17                	jg     801622 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80160b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80160e:	8b 45 08             	mov    0x8(%ebp),%eax
  801611:	01 d0                	add    %edx,%eax
  801613:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801616:	8b 55 08             	mov    0x8(%ebp),%edx
  801619:	01 ca                	add    %ecx,%edx
  80161b:	8a 12                	mov    (%edx),%dl
  80161d:	83 c2 20             	add    $0x20,%edx
  801620:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801622:	ff 45 fc             	incl   -0x4(%ebp)
  801625:	ff 75 0c             	pushl  0xc(%ebp)
  801628:	e8 01 f8 ff ff       	call   800e2e <strlen>
  80162d:	83 c4 04             	add    $0x4,%esp
  801630:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801633:	7f a6                	jg     8015db <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801635:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801638:	c9                   	leave  
  801639:	c3                   	ret    

0080163a <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  80163a:	55                   	push   %ebp
  80163b:	89 e5                	mov    %esp,%ebp
  80163d:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801640:	a1 08 50 80 00       	mov    0x805008,%eax
  801645:	85 c0                	test   %eax,%eax
  801647:	74 42                	je     80168b <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801649:	83 ec 08             	sub    $0x8,%esp
  80164c:	68 00 00 00 82       	push   $0x82000000
  801651:	68 00 00 00 80       	push   $0x80000000
  801656:	e8 b0 1e 00 00       	call   80350b <initialize_dynamic_allocator>
  80165b:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  80165e:	e8 96 1c 00 00       	call   8032f9 <sys_get_uheap_strategy>
  801663:	a3 80 50 83 00       	mov    %eax,0x835080
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801668:	a1 60 d0 81 00       	mov    0x81d060,%eax
  80166d:	05 00 10 00 00       	add    $0x1000,%eax
  801672:	a3 30 51 83 00       	mov    %eax,0x835130
		uheapPageAllocBreak = uheapPageAllocStart;
  801677:	a1 30 51 83 00       	mov    0x835130,%eax
  80167c:	a3 88 50 83 00       	mov    %eax,0x835088

		__firstTimeFlag = 0;
  801681:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  801688:	00 00 00 
	}
}
  80168b:	90                   	nop
  80168c:	c9                   	leave  
  80168d:	c3                   	ret    

0080168e <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
  801691:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801694:	8b 45 08             	mov    0x8(%ebp),%eax
  801697:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80169a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80169d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016a2:	83 ec 08             	sub    $0x8,%esp
  8016a5:	68 06 04 00 00       	push   $0x406
  8016aa:	50                   	push   %eax
  8016ab:	e8 93 18 00 00       	call   802f43 <__sys_allocate_page>
  8016b0:	83 c4 10             	add    $0x10,%esp
  8016b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8016b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016ba:	79 14                	jns    8016d0 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8016bc:	83 ec 04             	sub    $0x4,%esp
  8016bf:	68 28 4b 80 00       	push   $0x804b28
  8016c4:	6a 1f                	push   $0x1f
  8016c6:	68 64 4b 80 00       	push   $0x804b64
  8016cb:	e8 b7 ed ff ff       	call   800487 <_panic>
	return 0;
  8016d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016d5:	c9                   	leave  
  8016d6:	c3                   	ret    

008016d7 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
  8016da:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8016dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016eb:	83 ec 0c             	sub    $0xc,%esp
  8016ee:	50                   	push   %eax
  8016ef:	e8 96 18 00 00       	call   802f8a <__sys_unmap_frame>
  8016f4:	83 c4 10             	add    $0x10,%esp
  8016f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8016fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016fe:	79 14                	jns    801714 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801700:	83 ec 04             	sub    $0x4,%esp
  801703:	68 70 4b 80 00       	push   $0x804b70
  801708:	6a 2a                	push   $0x2a
  80170a:	68 64 4b 80 00       	push   $0x804b64
  80170f:	e8 73 ed ff ff       	call   800487 <_panic>
}
  801714:	90                   	nop
  801715:	c9                   	leave  
  801716:	c3                   	ret    

00801717 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
  80171a:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80171d:	e8 18 ff ff ff       	call   80163a <uheap_init>
	if (size == 0) return NULL ;
  801722:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801726:	75 0a                	jne    801732 <malloc+0x1b>
  801728:	b8 00 00 00 00       	mov    $0x0,%eax
  80172d:	e9 43 03 00 00       	jmp    801a75 <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801732:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801739:	77 13                	ja     80174e <malloc+0x37>
    {
        return alloc_block(size);
  80173b:	83 ec 0c             	sub    $0xc,%esp
  80173e:	ff 75 08             	pushl  0x8(%ebp)
  801741:	e8 78 20 00 00       	call   8037be <alloc_block>
  801746:	83 c4 10             	add    $0x10,%esp
  801749:	e9 27 03 00 00       	jmp    801a75 <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  80174e:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801755:	8b 55 08             	mov    0x8(%ebp),%edx
  801758:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80175b:	01 d0                	add    %edx,%eax
  80175d:	48                   	dec    %eax
  80175e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801761:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801764:	ba 00 00 00 00       	mov    $0x0,%edx
  801769:	f7 75 dc             	divl   -0x24(%ebp)
  80176c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80176f:	29 d0                	sub    %edx,%eax
  801771:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  801774:	a1 40 d0 81 00       	mov    0x81d040,%eax
  801779:	85 c0                	test   %eax,%eax
  80177b:	75 0a                	jne    801787 <malloc+0x70>
    {
        uhp_inited = 1;
  80177d:	c7 05 40 d0 81 00 01 	movl   $0x1,0x81d040
  801784:	00 00 00 
    }

    int exactIdx = -1;
  801787:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  80178e:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801795:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80179c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8017a3:	e9 85 00 00 00       	jmp    80182d <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  8017a8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017ab:	89 d0                	mov    %edx,%eax
  8017ad:	01 c0                	add    %eax,%eax
  8017af:	01 d0                	add    %edx,%eax
  8017b1:	c1 e0 02             	shl    $0x2,%eax
  8017b4:	05 48 10 81 00       	add    $0x811048,%eax
  8017b9:	8a 00                	mov    (%eax),%al
  8017bb:	84 c0                	test   %al,%al
  8017bd:	74 20                	je     8017df <malloc+0xc8>
  8017bf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017c2:	89 d0                	mov    %edx,%eax
  8017c4:	01 c0                	add    %eax,%eax
  8017c6:	01 d0                	add    %edx,%eax
  8017c8:	c1 e0 02             	shl    $0x2,%eax
  8017cb:	05 44 10 81 00       	add    $0x811044,%eax
  8017d0:	8b 00                	mov    (%eax),%eax
  8017d2:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8017d5:	75 08                	jne    8017df <malloc+0xc8>
        {
            exactIdx = i;
  8017d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017da:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  8017dd:	eb 5b                	jmp    80183a <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  8017df:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017e2:	89 d0                	mov    %edx,%eax
  8017e4:	01 c0                	add    %eax,%eax
  8017e6:	01 d0                	add    %edx,%eax
  8017e8:	c1 e0 02             	shl    $0x2,%eax
  8017eb:	05 48 10 81 00       	add    $0x811048,%eax
  8017f0:	8a 00                	mov    (%eax),%al
  8017f2:	84 c0                	test   %al,%al
  8017f4:	74 34                	je     80182a <malloc+0x113>
  8017f6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017f9:	89 d0                	mov    %edx,%eax
  8017fb:	01 c0                	add    %eax,%eax
  8017fd:	01 d0                	add    %edx,%eax
  8017ff:	c1 e0 02             	shl    $0x2,%eax
  801802:	05 44 10 81 00       	add    $0x811044,%eax
  801807:	8b 00                	mov    (%eax),%eax
  801809:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80180c:	76 1c                	jbe    80182a <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  80180e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801811:	89 d0                	mov    %edx,%eax
  801813:	01 c0                	add    %eax,%eax
  801815:	01 d0                	add    %edx,%eax
  801817:	c1 e0 02             	shl    $0x2,%eax
  80181a:	05 44 10 81 00       	add    $0x811044,%eax
  80181f:	8b 00                	mov    (%eax),%eax
  801821:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801824:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801827:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80182a:	ff 45 e8             	incl   -0x18(%ebp)
  80182d:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801834:	0f 8e 6e ff ff ff    	jle    8017a8 <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  80183a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801841:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801845:	74 7d                	je     8018c4 <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801847:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  80184e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801851:	89 d0                	mov    %edx,%eax
  801853:	01 c0                	add    %eax,%eax
  801855:	01 d0                	add    %edx,%eax
  801857:	c1 e0 02             	shl    $0x2,%eax
  80185a:	05 40 10 81 00       	add    $0x811040,%eax
  80185f:	8b 10                	mov    (%eax),%edx
  801861:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801864:	01 d0                	add    %edx,%eax
  801866:	48                   	dec    %eax
  801867:	89 45 b8             	mov    %eax,-0x48(%ebp)
  80186a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80186d:	ba 00 00 00 00       	mov    $0x0,%edx
  801872:	f7 75 bc             	divl   -0x44(%ebp)
  801875:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801878:	29 d0                	sub    %edx,%eax
  80187a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  80187d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801880:	89 d0                	mov    %edx,%eax
  801882:	01 c0                	add    %eax,%eax
  801884:	01 d0                	add    %edx,%eax
  801886:	c1 e0 02             	shl    $0x2,%eax
  801889:	05 48 10 81 00       	add    $0x811048,%eax
  80188e:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801891:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801894:	89 d0                	mov    %edx,%eax
  801896:	01 c0                	add    %eax,%eax
  801898:	01 d0                	add    %edx,%eax
  80189a:	c1 e0 02             	shl    $0x2,%eax
  80189d:	05 44 10 81 00       	add    $0x811044,%eax
  8018a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  8018a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018ab:	89 d0                	mov    %edx,%eax
  8018ad:	01 c0                	add    %eax,%eax
  8018af:	01 d0                	add    %edx,%eax
  8018b1:	c1 e0 02             	shl    $0x2,%eax
  8018b4:	05 40 10 81 00       	add    $0x811040,%eax
  8018b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8018bf:	e9 2d 01 00 00       	jmp    8019f1 <malloc+0x2da>
    }
    else if (worstIdx != -1)
  8018c4:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8018c8:	0f 84 ce 00 00 00    	je     80199c <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  8018ce:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8018d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018d8:	89 d0                	mov    %edx,%eax
  8018da:	01 c0                	add    %eax,%eax
  8018dc:	01 d0                	add    %edx,%eax
  8018de:	c1 e0 02             	shl    $0x2,%eax
  8018e1:	05 40 10 81 00       	add    $0x811040,%eax
  8018e6:	8b 10                	mov    (%eax),%edx
  8018e8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8018eb:	01 d0                	add    %edx,%eax
  8018ed:	48                   	dec    %eax
  8018ee:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8018f1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8018f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f9:	f7 75 c4             	divl   -0x3c(%ebp)
  8018fc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8018ff:	29 d0                	sub    %edx,%eax
  801901:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  801904:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801907:	89 d0                	mov    %edx,%eax
  801909:	01 c0                	add    %eax,%eax
  80190b:	01 d0                	add    %edx,%eax
  80190d:	c1 e0 02             	shl    $0x2,%eax
  801910:	05 44 10 81 00       	add    $0x811044,%eax
  801915:	8b 00                	mov    (%eax),%eax
  801917:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80191a:	75 47                	jne    801963 <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  80191c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80191f:	89 d0                	mov    %edx,%eax
  801921:	01 c0                	add    %eax,%eax
  801923:	01 d0                	add    %edx,%eax
  801925:	c1 e0 02             	shl    $0x2,%eax
  801928:	05 48 10 81 00       	add    $0x811048,%eax
  80192d:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  801930:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801933:	89 d0                	mov    %edx,%eax
  801935:	01 c0                	add    %eax,%eax
  801937:	01 d0                	add    %edx,%eax
  801939:	c1 e0 02             	shl    $0x2,%eax
  80193c:	05 44 10 81 00       	add    $0x811044,%eax
  801941:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  801947:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80194a:	89 d0                	mov    %edx,%eax
  80194c:	01 c0                	add    %eax,%eax
  80194e:	01 d0                	add    %edx,%eax
  801950:	c1 e0 02             	shl    $0x2,%eax
  801953:	05 40 10 81 00       	add    $0x811040,%eax
  801958:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80195e:	e9 8e 00 00 00       	jmp    8019f1 <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  801963:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801966:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801969:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80196c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80196f:	89 d0                	mov    %edx,%eax
  801971:	01 c0                	add    %eax,%eax
  801973:	01 d0                	add    %edx,%eax
  801975:	c1 e0 02             	shl    $0x2,%eax
  801978:	05 40 10 81 00       	add    $0x811040,%eax
  80197d:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  80197f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801982:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801985:	89 c2                	mov    %eax,%edx
  801987:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80198a:	89 c8                	mov    %ecx,%eax
  80198c:	01 c0                	add    %eax,%eax
  80198e:	01 c8                	add    %ecx,%eax
  801990:	c1 e0 02             	shl    $0x2,%eax
  801993:	05 44 10 81 00       	add    $0x811044,%eax
  801998:	89 10                	mov    %edx,(%eax)
  80199a:	eb 55                	jmp    8019f1 <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  80199c:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  8019a3:	8b 15 88 50 83 00    	mov    0x835088,%edx
  8019a9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8019ac:	01 d0                	add    %edx,%eax
  8019ae:	48                   	dec    %eax
  8019af:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8019b2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8019b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ba:	f7 75 d0             	divl   -0x30(%ebp)
  8019bd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8019c0:	29 d0                	sub    %edx,%eax
  8019c2:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  8019c5:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8019c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019cb:	01 d0                	add    %edx,%eax
  8019cd:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8019d2:	76 0a                	jbe    8019de <malloc+0x2c7>
            return NULL;
  8019d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8019d9:	e9 97 00 00 00       	jmp    801a75 <malloc+0x35e>
        va = start;
  8019de:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8019e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  8019e4:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8019e7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019ea:	01 d0                	add    %edx,%eax
  8019ec:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8019f1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8019f8:	eb 5e                	jmp    801a58 <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  8019fa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019fd:	89 d0                	mov    %edx,%eax
  8019ff:	01 c0                	add    %eax,%eax
  801a01:	01 d0                	add    %edx,%eax
  801a03:	c1 e0 02             	shl    $0x2,%eax
  801a06:	05 48 50 80 00       	add    $0x805048,%eax
  801a0b:	8a 00                	mov    (%eax),%al
  801a0d:	84 c0                	test   %al,%al
  801a0f:	75 44                	jne    801a55 <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  801a11:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a14:	89 d0                	mov    %edx,%eax
  801a16:	01 c0                	add    %eax,%eax
  801a18:	01 d0                	add    %edx,%eax
  801a1a:	c1 e0 02             	shl    $0x2,%eax
  801a1d:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  801a23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a26:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  801a28:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a2b:	89 d0                	mov    %edx,%eax
  801a2d:	01 c0                	add    %eax,%eax
  801a2f:	01 d0                	add    %edx,%eax
  801a31:	c1 e0 02             	shl    $0x2,%eax
  801a34:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  801a3a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a3d:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  801a3f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a42:	89 d0                	mov    %edx,%eax
  801a44:	01 c0                	add    %eax,%eax
  801a46:	01 d0                	add    %edx,%eax
  801a48:	c1 e0 02             	shl    $0x2,%eax
  801a4b:	05 48 50 80 00       	add    $0x805048,%eax
  801a50:	c6 00 01             	movb   $0x1,(%eax)
            break;
  801a53:	eb 0c                	jmp    801a61 <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801a55:	ff 45 e0             	incl   -0x20(%ebp)
  801a58:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801a5f:	7e 99                	jle    8019fa <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  801a61:	83 ec 08             	sub    $0x8,%esp
  801a64:	ff 75 d4             	pushl  -0x2c(%ebp)
  801a67:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a6a:	e8 a2 19 00 00       	call   803411 <sys_allocate_user_mem>
  801a6f:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  801a72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801a75:	c9                   	leave  
  801a76:	c3                   	ret    

00801a77 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801a77:	55                   	push   %ebp
  801a78:	89 e5                	mov    %esp,%ebp
  801a7a:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  801a7d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a81:	0f 84 fa 03 00 00    	je     801e81 <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  801a87:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  801a8d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a90:	85 c0                	test   %eax,%eax
  801a92:	79 1c                	jns    801ab0 <free+0x39>
  801a94:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  801a9b:	77 13                	ja     801ab0 <free+0x39>
    {
        free_block(virtual_address);
  801a9d:	83 ec 0c             	sub    $0xc,%esp
  801aa0:	ff 75 08             	pushl  0x8(%ebp)
  801aa3:	e8 09 21 00 00       	call   803bb1 <free_block>
  801aa8:	83 c4 10             	add    $0x10,%esp
        return;
  801aab:	e9 d2 03 00 00       	jmp    801e82 <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  801ab0:	a1 30 51 83 00       	mov    0x835130,%eax
  801ab5:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  801ab8:	72 09                	jb     801ac3 <free+0x4c>
  801aba:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  801ac1:	76 17                	jbe    801ada <free+0x63>
        panic("free: invalid address");
  801ac3:	83 ec 04             	sub    $0x4,%esp
  801ac6:	68 ad 4b 80 00       	push   $0x804bad
  801acb:	68 9b 00 00 00       	push   $0x9b
  801ad0:	68 64 4b 80 00       	push   $0x804b64
  801ad5:	e8 ad e9 ff ff       	call   800487 <_panic>

    uint32 size = 0;
  801ada:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  801ae1:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801ae8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801aef:	eb 50                	jmp    801b41 <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  801af1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801af4:	89 d0                	mov    %edx,%eax
  801af6:	01 c0                	add    %eax,%eax
  801af8:	01 d0                	add    %edx,%eax
  801afa:	c1 e0 02             	shl    $0x2,%eax
  801afd:	05 48 50 80 00       	add    $0x805048,%eax
  801b02:	8a 00                	mov    (%eax),%al
  801b04:	84 c0                	test   %al,%al
  801b06:	74 36                	je     801b3e <free+0xc7>
  801b08:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b0b:	89 d0                	mov    %edx,%eax
  801b0d:	01 c0                	add    %eax,%eax
  801b0f:	01 d0                	add    %edx,%eax
  801b11:	c1 e0 02             	shl    $0x2,%eax
  801b14:	05 40 50 80 00       	add    $0x805040,%eax
  801b19:	8b 00                	mov    (%eax),%eax
  801b1b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801b1e:	75 1e                	jne    801b3e <free+0xc7>
        {
            size = uhp_allocs[i].size;
  801b20:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b23:	89 d0                	mov    %edx,%eax
  801b25:	01 c0                	add    %eax,%eax
  801b27:	01 d0                	add    %edx,%eax
  801b29:	c1 e0 02             	shl    $0x2,%eax
  801b2c:	05 44 50 80 00       	add    $0x805044,%eax
  801b31:	8b 00                	mov    (%eax),%eax
  801b33:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  801b36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b39:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  801b3c:	eb 0c                	jmp    801b4a <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801b3e:	ff 45 ec             	incl   -0x14(%ebp)
  801b41:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  801b48:	7e a7                	jle    801af1 <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  801b4a:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801b4e:	74 06                	je     801b56 <free+0xdf>
  801b50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b54:	75 17                	jne    801b6d <free+0xf6>
        panic("free: unknown block");
  801b56:	83 ec 04             	sub    $0x4,%esp
  801b59:	68 c3 4b 80 00       	push   $0x804bc3
  801b5e:	68 a9 00 00 00       	push   $0xa9
  801b63:	68 64 4b 80 00       	push   $0x804b64
  801b68:	e8 1a e9 ff ff       	call   800487 <_panic>

    uhp_allocs[idx].used = 0;
  801b6d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b70:	89 d0                	mov    %edx,%eax
  801b72:	01 c0                	add    %eax,%eax
  801b74:	01 d0                	add    %edx,%eax
  801b76:	c1 e0 02             	shl    $0x2,%eax
  801b79:	05 48 50 80 00       	add    $0x805048,%eax
  801b7e:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  801b81:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801b88:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801b8f:	eb 64                	jmp    801bf5 <free+0x17e>
    {
        if (!uhp_frees[i].free)
  801b91:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b94:	89 d0                	mov    %edx,%eax
  801b96:	01 c0                	add    %eax,%eax
  801b98:	01 d0                	add    %edx,%eax
  801b9a:	c1 e0 02             	shl    $0x2,%eax
  801b9d:	05 48 10 81 00       	add    $0x811048,%eax
  801ba2:	8a 00                	mov    (%eax),%al
  801ba4:	84 c0                	test   %al,%al
  801ba6:	75 4a                	jne    801bf2 <free+0x17b>
        {
            uhp_frees[i].va = va;
  801ba8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801bab:	89 d0                	mov    %edx,%eax
  801bad:	01 c0                	add    %eax,%eax
  801baf:	01 d0                	add    %edx,%eax
  801bb1:	c1 e0 02             	shl    $0x2,%eax
  801bb4:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  801bba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801bbd:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  801bbf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801bc2:	89 d0                	mov    %edx,%eax
  801bc4:	01 c0                	add    %eax,%eax
  801bc6:	01 d0                	add    %edx,%eax
  801bc8:	c1 e0 02             	shl    $0x2,%eax
  801bcb:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  801bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd4:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  801bd6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801bd9:	89 d0                	mov    %edx,%eax
  801bdb:	01 c0                	add    %eax,%eax
  801bdd:	01 d0                	add    %edx,%eax
  801bdf:	c1 e0 02             	shl    $0x2,%eax
  801be2:	05 48 10 81 00       	add    $0x811048,%eax
  801be7:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  801bea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bed:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  801bf0:	eb 0c                	jmp    801bfe <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801bf2:	ff 45 e4             	incl   -0x1c(%ebp)
  801bf5:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  801bfc:	7e 93                	jle    801b91 <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  801bfe:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  801c02:	0f 84 f1 01 00 00    	je     801df9 <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801c08:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801c0f:	e9 d8 01 00 00       	jmp    801dec <free+0x375>
        {
            if (i == fidx) continue;
  801c14:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c17:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801c1a:	0f 84 c8 01 00 00    	je     801de8 <free+0x371>
            if (uhp_frees[i].free)
  801c20:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c23:	89 d0                	mov    %edx,%eax
  801c25:	01 c0                	add    %eax,%eax
  801c27:	01 d0                	add    %edx,%eax
  801c29:	c1 e0 02             	shl    $0x2,%eax
  801c2c:	05 48 10 81 00       	add    $0x811048,%eax
  801c31:	8a 00                	mov    (%eax),%al
  801c33:	84 c0                	test   %al,%al
  801c35:	0f 84 ae 01 00 00    	je     801de9 <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  801c3b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c3e:	89 d0                	mov    %edx,%eax
  801c40:	01 c0                	add    %eax,%eax
  801c42:	01 d0                	add    %edx,%eax
  801c44:	c1 e0 02             	shl    $0x2,%eax
  801c47:	05 40 10 81 00       	add    $0x811040,%eax
  801c4c:	8b 08                	mov    (%eax),%ecx
  801c4e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c51:	89 d0                	mov    %edx,%eax
  801c53:	01 c0                	add    %eax,%eax
  801c55:	01 d0                	add    %edx,%eax
  801c57:	c1 e0 02             	shl    $0x2,%eax
  801c5a:	05 44 10 81 00       	add    $0x811044,%eax
  801c5f:	8b 00                	mov    (%eax),%eax
  801c61:	01 c1                	add    %eax,%ecx
  801c63:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c66:	89 d0                	mov    %edx,%eax
  801c68:	01 c0                	add    %eax,%eax
  801c6a:	01 d0                	add    %edx,%eax
  801c6c:	c1 e0 02             	shl    $0x2,%eax
  801c6f:	05 40 10 81 00       	add    $0x811040,%eax
  801c74:	8b 00                	mov    (%eax),%eax
  801c76:	39 c1                	cmp    %eax,%ecx
  801c78:	0f 85 a8 00 00 00    	jne    801d26 <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  801c7e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c81:	89 d0                	mov    %edx,%eax
  801c83:	01 c0                	add    %eax,%eax
  801c85:	01 d0                	add    %edx,%eax
  801c87:	c1 e0 02             	shl    $0x2,%eax
  801c8a:	05 40 10 81 00       	add    $0x811040,%eax
  801c8f:	8b 10                	mov    (%eax),%edx
  801c91:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  801c94:	89 c8                	mov    %ecx,%eax
  801c96:	01 c0                	add    %eax,%eax
  801c98:	01 c8                	add    %ecx,%eax
  801c9a:	c1 e0 02             	shl    $0x2,%eax
  801c9d:	05 40 10 81 00       	add    $0x811040,%eax
  801ca2:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801ca4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ca7:	89 d0                	mov    %edx,%eax
  801ca9:	01 c0                	add    %eax,%eax
  801cab:	01 d0                	add    %edx,%eax
  801cad:	c1 e0 02             	shl    $0x2,%eax
  801cb0:	05 44 10 81 00       	add    $0x811044,%eax
  801cb5:	8b 08                	mov    (%eax),%ecx
  801cb7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801cba:	89 d0                	mov    %edx,%eax
  801cbc:	01 c0                	add    %eax,%eax
  801cbe:	01 d0                	add    %edx,%eax
  801cc0:	c1 e0 02             	shl    $0x2,%eax
  801cc3:	05 44 10 81 00       	add    $0x811044,%eax
  801cc8:	8b 00                	mov    (%eax),%eax
  801cca:	01 c1                	add    %eax,%ecx
  801ccc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ccf:	89 d0                	mov    %edx,%eax
  801cd1:	01 c0                	add    %eax,%eax
  801cd3:	01 d0                	add    %edx,%eax
  801cd5:	c1 e0 02             	shl    $0x2,%eax
  801cd8:	05 44 10 81 00       	add    $0x811044,%eax
  801cdd:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801cdf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ce2:	89 d0                	mov    %edx,%eax
  801ce4:	01 c0                	add    %eax,%eax
  801ce6:	01 d0                	add    %edx,%eax
  801ce8:	c1 e0 02             	shl    $0x2,%eax
  801ceb:	05 48 10 81 00       	add    $0x811048,%eax
  801cf0:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801cf3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801cf6:	89 d0                	mov    %edx,%eax
  801cf8:	01 c0                	add    %eax,%eax
  801cfa:	01 d0                	add    %edx,%eax
  801cfc:	c1 e0 02             	shl    $0x2,%eax
  801cff:	05 40 10 81 00       	add    $0x811040,%eax
  801d04:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801d0a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d0d:	89 d0                	mov    %edx,%eax
  801d0f:	01 c0                	add    %eax,%eax
  801d11:	01 d0                	add    %edx,%eax
  801d13:	c1 e0 02             	shl    $0x2,%eax
  801d16:	05 44 10 81 00       	add    $0x811044,%eax
  801d1b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801d21:	e9 c3 00 00 00       	jmp    801de9 <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  801d26:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d29:	89 d0                	mov    %edx,%eax
  801d2b:	01 c0                	add    %eax,%eax
  801d2d:	01 d0                	add    %edx,%eax
  801d2f:	c1 e0 02             	shl    $0x2,%eax
  801d32:	05 40 10 81 00       	add    $0x811040,%eax
  801d37:	8b 08                	mov    (%eax),%ecx
  801d39:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d3c:	89 d0                	mov    %edx,%eax
  801d3e:	01 c0                	add    %eax,%eax
  801d40:	01 d0                	add    %edx,%eax
  801d42:	c1 e0 02             	shl    $0x2,%eax
  801d45:	05 44 10 81 00       	add    $0x811044,%eax
  801d4a:	8b 00                	mov    (%eax),%eax
  801d4c:	01 c1                	add    %eax,%ecx
  801d4e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d51:	89 d0                	mov    %edx,%eax
  801d53:	01 c0                	add    %eax,%eax
  801d55:	01 d0                	add    %edx,%eax
  801d57:	c1 e0 02             	shl    $0x2,%eax
  801d5a:	05 40 10 81 00       	add    $0x811040,%eax
  801d5f:	8b 00                	mov    (%eax),%eax
  801d61:	39 c1                	cmp    %eax,%ecx
  801d63:	0f 85 80 00 00 00    	jne    801de9 <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801d69:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d6c:	89 d0                	mov    %edx,%eax
  801d6e:	01 c0                	add    %eax,%eax
  801d70:	01 d0                	add    %edx,%eax
  801d72:	c1 e0 02             	shl    $0x2,%eax
  801d75:	05 44 10 81 00       	add    $0x811044,%eax
  801d7a:	8b 08                	mov    (%eax),%ecx
  801d7c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d7f:	89 d0                	mov    %edx,%eax
  801d81:	01 c0                	add    %eax,%eax
  801d83:	01 d0                	add    %edx,%eax
  801d85:	c1 e0 02             	shl    $0x2,%eax
  801d88:	05 44 10 81 00       	add    $0x811044,%eax
  801d8d:	8b 00                	mov    (%eax),%eax
  801d8f:	01 c1                	add    %eax,%ecx
  801d91:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d94:	89 d0                	mov    %edx,%eax
  801d96:	01 c0                	add    %eax,%eax
  801d98:	01 d0                	add    %edx,%eax
  801d9a:	c1 e0 02             	shl    $0x2,%eax
  801d9d:	05 44 10 81 00       	add    $0x811044,%eax
  801da2:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801da4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801da7:	89 d0                	mov    %edx,%eax
  801da9:	01 c0                	add    %eax,%eax
  801dab:	01 d0                	add    %edx,%eax
  801dad:	c1 e0 02             	shl    $0x2,%eax
  801db0:	05 48 10 81 00       	add    $0x811048,%eax
  801db5:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801db8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801dbb:	89 d0                	mov    %edx,%eax
  801dbd:	01 c0                	add    %eax,%eax
  801dbf:	01 d0                	add    %edx,%eax
  801dc1:	c1 e0 02             	shl    $0x2,%eax
  801dc4:	05 40 10 81 00       	add    $0x811040,%eax
  801dc9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801dcf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801dd2:	89 d0                	mov    %edx,%eax
  801dd4:	01 c0                	add    %eax,%eax
  801dd6:	01 d0                	add    %edx,%eax
  801dd8:	c1 e0 02             	shl    $0x2,%eax
  801ddb:	05 44 10 81 00       	add    $0x811044,%eax
  801de0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801de6:	eb 01                	jmp    801de9 <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  801de8:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801de9:	ff 45 e0             	incl   -0x20(%ebp)
  801dec:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801df3:	0f 8e 1b fe ff ff    	jle    801c14 <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  801df9:	a1 30 51 83 00       	mov    0x835130,%eax
  801dfe:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801e01:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801e08:	eb 53                	jmp    801e5d <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  801e0a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e0d:	89 d0                	mov    %edx,%eax
  801e0f:	01 c0                	add    %eax,%eax
  801e11:	01 d0                	add    %edx,%eax
  801e13:	c1 e0 02             	shl    $0x2,%eax
  801e16:	05 48 50 80 00       	add    $0x805048,%eax
  801e1b:	8a 00                	mov    (%eax),%al
  801e1d:	84 c0                	test   %al,%al
  801e1f:	74 39                	je     801e5a <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  801e21:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e24:	89 d0                	mov    %edx,%eax
  801e26:	01 c0                	add    %eax,%eax
  801e28:	01 d0                	add    %edx,%eax
  801e2a:	c1 e0 02             	shl    $0x2,%eax
  801e2d:	05 40 50 80 00       	add    $0x805040,%eax
  801e32:	8b 08                	mov    (%eax),%ecx
  801e34:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e37:	89 d0                	mov    %edx,%eax
  801e39:	01 c0                	add    %eax,%eax
  801e3b:	01 d0                	add    %edx,%eax
  801e3d:	c1 e0 02             	shl    $0x2,%eax
  801e40:	05 44 50 80 00       	add    $0x805044,%eax
  801e45:	8b 00                	mov    (%eax),%eax
  801e47:	01 c8                	add    %ecx,%eax
  801e49:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  801e4c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e4f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801e52:	76 06                	jbe    801e5a <free+0x3e3>
  801e54:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e57:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801e5a:	ff 45 d8             	incl   -0x28(%ebp)
  801e5d:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  801e64:	7e a4                	jle    801e0a <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  801e66:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e69:	a3 88 50 83 00       	mov    %eax,0x835088

    sys_free_user_mem(va, size);
  801e6e:	83 ec 08             	sub    $0x8,%esp
  801e71:	ff 75 f4             	pushl  -0xc(%ebp)
  801e74:	ff 75 d4             	pushl  -0x2c(%ebp)
  801e77:	e8 79 15 00 00       	call   8033f5 <sys_free_user_mem>
  801e7c:	83 c4 10             	add    $0x10,%esp
  801e7f:	eb 01                	jmp    801e82 <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  801e81:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  801e82:	c9                   	leave  
  801e83:	c3                   	ret    

00801e84 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801e84:	55                   	push   %ebp
  801e85:	89 e5                	mov    %esp,%ebp
  801e87:	83 ec 68             	sub    $0x68,%esp
  801e8a:	8b 45 10             	mov    0x10(%ebp),%eax
  801e8d:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801e90:	e8 a5 f7 ff ff       	call   80163a <uheap_init>
	if (size == 0) return NULL ;
  801e95:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e99:	75 0a                	jne    801ea5 <smalloc+0x21>
  801e9b:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea0:	e9 37 03 00 00       	jmp    8021dc <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801ea5:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801eac:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eaf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801eb2:	01 d0                	add    %edx,%eax
  801eb4:	48                   	dec    %eax
  801eb5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801eb8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ebb:	ba 00 00 00 00       	mov    $0x0,%edx
  801ec0:	f7 75 dc             	divl   -0x24(%ebp)
  801ec3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ec6:	29 d0                	sub    %edx,%eax
  801ec8:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  801ecb:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801ed2:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801ed9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801ee0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801ee7:	e9 85 00 00 00       	jmp    801f71 <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801eec:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801eef:	89 d0                	mov    %edx,%eax
  801ef1:	01 c0                	add    %eax,%eax
  801ef3:	01 d0                	add    %edx,%eax
  801ef5:	c1 e0 02             	shl    $0x2,%eax
  801ef8:	05 48 10 81 00       	add    $0x811048,%eax
  801efd:	8a 00                	mov    (%eax),%al
  801eff:	84 c0                	test   %al,%al
  801f01:	74 20                	je     801f23 <smalloc+0x9f>
  801f03:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f06:	89 d0                	mov    %edx,%eax
  801f08:	01 c0                	add    %eax,%eax
  801f0a:	01 d0                	add    %edx,%eax
  801f0c:	c1 e0 02             	shl    $0x2,%eax
  801f0f:	05 44 10 81 00       	add    $0x811044,%eax
  801f14:	8b 00                	mov    (%eax),%eax
  801f16:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801f19:	75 08                	jne    801f23 <smalloc+0x9f>
        {
            exactIdx = i;
  801f1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801f21:	eb 5b                	jmp    801f7e <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801f23:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f26:	89 d0                	mov    %edx,%eax
  801f28:	01 c0                	add    %eax,%eax
  801f2a:	01 d0                	add    %edx,%eax
  801f2c:	c1 e0 02             	shl    $0x2,%eax
  801f2f:	05 48 10 81 00       	add    $0x811048,%eax
  801f34:	8a 00                	mov    (%eax),%al
  801f36:	84 c0                	test   %al,%al
  801f38:	74 34                	je     801f6e <smalloc+0xea>
  801f3a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f3d:	89 d0                	mov    %edx,%eax
  801f3f:	01 c0                	add    %eax,%eax
  801f41:	01 d0                	add    %edx,%eax
  801f43:	c1 e0 02             	shl    $0x2,%eax
  801f46:	05 44 10 81 00       	add    $0x811044,%eax
  801f4b:	8b 00                	mov    (%eax),%eax
  801f4d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801f50:	76 1c                	jbe    801f6e <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  801f52:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f55:	89 d0                	mov    %edx,%eax
  801f57:	01 c0                	add    %eax,%eax
  801f59:	01 d0                	add    %edx,%eax
  801f5b:	c1 e0 02             	shl    $0x2,%eax
  801f5e:	05 44 10 81 00       	add    $0x811044,%eax
  801f63:	8b 00                	mov    (%eax),%eax
  801f65:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801f68:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f6b:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801f6e:	ff 45 e8             	incl   -0x18(%ebp)
  801f71:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801f78:	0f 8e 6e ff ff ff    	jle    801eec <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  801f7e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801f85:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801f89:	74 7d                	je     802008 <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801f8b:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801f92:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f95:	89 d0                	mov    %edx,%eax
  801f97:	01 c0                	add    %eax,%eax
  801f99:	01 d0                	add    %edx,%eax
  801f9b:	c1 e0 02             	shl    $0x2,%eax
  801f9e:	05 40 10 81 00       	add    $0x811040,%eax
  801fa3:	8b 10                	mov    (%eax),%edx
  801fa5:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801fa8:	01 d0                	add    %edx,%eax
  801faa:	48                   	dec    %eax
  801fab:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801fae:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801fb1:	ba 00 00 00 00       	mov    $0x0,%edx
  801fb6:	f7 75 bc             	divl   -0x44(%ebp)
  801fb9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801fbc:	29 d0                	sub    %edx,%eax
  801fbe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801fc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fc4:	89 d0                	mov    %edx,%eax
  801fc6:	01 c0                	add    %eax,%eax
  801fc8:	01 d0                	add    %edx,%eax
  801fca:	c1 e0 02             	shl    $0x2,%eax
  801fcd:	05 48 10 81 00       	add    $0x811048,%eax
  801fd2:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801fd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fd8:	89 d0                	mov    %edx,%eax
  801fda:	01 c0                	add    %eax,%eax
  801fdc:	01 d0                	add    %edx,%eax
  801fde:	c1 e0 02             	shl    $0x2,%eax
  801fe1:	05 44 10 81 00       	add    $0x811044,%eax
  801fe6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801fec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fef:	89 d0                	mov    %edx,%eax
  801ff1:	01 c0                	add    %eax,%eax
  801ff3:	01 d0                	add    %edx,%eax
  801ff5:	c1 e0 02             	shl    $0x2,%eax
  801ff8:	05 40 10 81 00       	add    $0x811040,%eax
  801ffd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802003:	e9 2d 01 00 00       	jmp    802135 <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  802008:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80200c:	0f 84 ce 00 00 00    	je     8020e0 <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  802012:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802019:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80201c:	89 d0                	mov    %edx,%eax
  80201e:	01 c0                	add    %eax,%eax
  802020:	01 d0                	add    %edx,%eax
  802022:	c1 e0 02             	shl    $0x2,%eax
  802025:	05 40 10 81 00       	add    $0x811040,%eax
  80202a:	8b 10                	mov    (%eax),%edx
  80202c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80202f:	01 d0                	add    %edx,%eax
  802031:	48                   	dec    %eax
  802032:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802035:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802038:	ba 00 00 00 00       	mov    $0x0,%edx
  80203d:	f7 75 c4             	divl   -0x3c(%ebp)
  802040:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802043:	29 d0                	sub    %edx,%eax
  802045:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  802048:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80204b:	89 d0                	mov    %edx,%eax
  80204d:	01 c0                	add    %eax,%eax
  80204f:	01 d0                	add    %edx,%eax
  802051:	c1 e0 02             	shl    $0x2,%eax
  802054:	05 44 10 81 00       	add    $0x811044,%eax
  802059:	8b 00                	mov    (%eax),%eax
  80205b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80205e:	75 47                	jne    8020a7 <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  802060:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802063:	89 d0                	mov    %edx,%eax
  802065:	01 c0                	add    %eax,%eax
  802067:	01 d0                	add    %edx,%eax
  802069:	c1 e0 02             	shl    $0x2,%eax
  80206c:	05 48 10 81 00       	add    $0x811048,%eax
  802071:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  802074:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802077:	89 d0                	mov    %edx,%eax
  802079:	01 c0                	add    %eax,%eax
  80207b:	01 d0                	add    %edx,%eax
  80207d:	c1 e0 02             	shl    $0x2,%eax
  802080:	05 44 10 81 00       	add    $0x811044,%eax
  802085:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  80208b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80208e:	89 d0                	mov    %edx,%eax
  802090:	01 c0                	add    %eax,%eax
  802092:	01 d0                	add    %edx,%eax
  802094:	c1 e0 02             	shl    $0x2,%eax
  802097:	05 40 10 81 00       	add    $0x811040,%eax
  80209c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020a2:	e9 8e 00 00 00       	jmp    802135 <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  8020a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8020aa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020ad:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8020b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020b3:	89 d0                	mov    %edx,%eax
  8020b5:	01 c0                	add    %eax,%eax
  8020b7:	01 d0                	add    %edx,%eax
  8020b9:	c1 e0 02             	shl    $0x2,%eax
  8020bc:	05 40 10 81 00       	add    $0x811040,%eax
  8020c1:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  8020c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020c6:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8020c9:	89 c2                	mov    %eax,%edx
  8020cb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8020ce:	89 c8                	mov    %ecx,%eax
  8020d0:	01 c0                	add    %eax,%eax
  8020d2:	01 c8                	add    %ecx,%eax
  8020d4:	c1 e0 02             	shl    $0x2,%eax
  8020d7:	05 44 10 81 00       	add    $0x811044,%eax
  8020dc:	89 10                	mov    %edx,(%eax)
  8020de:	eb 55                	jmp    802135 <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  8020e0:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  8020e7:	8b 15 88 50 83 00    	mov    0x835088,%edx
  8020ed:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8020f0:	01 d0                	add    %edx,%eax
  8020f2:	48                   	dec    %eax
  8020f3:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8020f6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8020f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8020fe:	f7 75 d0             	divl   -0x30(%ebp)
  802101:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802104:	29 d0                	sub    %edx,%eax
  802106:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  802109:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80210c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80210f:	01 d0                	add    %edx,%eax
  802111:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802116:	76 0a                	jbe    802122 <smalloc+0x29e>
            return NULL;
  802118:	b8 00 00 00 00       	mov    $0x0,%eax
  80211d:	e9 ba 00 00 00       	jmp    8021dc <smalloc+0x358>
        va = start;
  802122:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802125:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  802128:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80212b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80212e:	01 d0                	add    %edx,%eax
  802130:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802135:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80213c:	eb 5e                	jmp    80219c <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  80213e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802141:	89 d0                	mov    %edx,%eax
  802143:	01 c0                	add    %eax,%eax
  802145:	01 d0                	add    %edx,%eax
  802147:	c1 e0 02             	shl    $0x2,%eax
  80214a:	05 48 50 80 00       	add    $0x805048,%eax
  80214f:	8a 00                	mov    (%eax),%al
  802151:	84 c0                	test   %al,%al
  802153:	75 44                	jne    802199 <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  802155:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802158:	89 d0                	mov    %edx,%eax
  80215a:	01 c0                	add    %eax,%eax
  80215c:	01 d0                	add    %edx,%eax
  80215e:	c1 e0 02             	shl    $0x2,%eax
  802161:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  802167:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80216a:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  80216c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80216f:	89 d0                	mov    %edx,%eax
  802171:	01 c0                	add    %eax,%eax
  802173:	01 d0                	add    %edx,%eax
  802175:	c1 e0 02             	shl    $0x2,%eax
  802178:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  80217e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802181:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  802183:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802186:	89 d0                	mov    %edx,%eax
  802188:	01 c0                	add    %eax,%eax
  80218a:	01 d0                	add    %edx,%eax
  80218c:	c1 e0 02             	shl    $0x2,%eax
  80218f:	05 48 50 80 00       	add    $0x805048,%eax
  802194:	c6 00 01             	movb   $0x1,(%eax)
            break;
  802197:	eb 0c                	jmp    8021a5 <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802199:	ff 45 e0             	incl   -0x20(%ebp)
  80219c:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8021a3:	7e 99                	jle    80213e <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  8021a5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8021a8:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  8021ac:	52                   	push   %edx
  8021ad:	50                   	push   %eax
  8021ae:	ff 75 d4             	pushl  -0x2c(%ebp)
  8021b1:	ff 75 08             	pushl  0x8(%ebp)
  8021b4:	e8 de 0e 00 00       	call   803097 <sys_create_shared_object>
  8021b9:	83 c4 10             	add    $0x10,%esp
  8021bc:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  8021bf:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  8021c3:	75 07                	jne    8021cc <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  8021c5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8021ca:	eb 10                	jmp    8021dc <smalloc+0x358>
    if (r < 0)
  8021cc:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  8021d0:	79 07                	jns    8021d9 <smalloc+0x355>
        return NULL;
  8021d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d7:	eb 03                	jmp    8021dc <smalloc+0x358>
    return (void*)va;
  8021d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8021dc:	c9                   	leave  
  8021dd:	c3                   	ret    

008021de <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8021de:	55                   	push   %ebp
  8021df:	89 e5                	mov    %esp,%ebp
  8021e1:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8021e4:	e8 51 f4 ff ff       	call   80163a <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  8021e9:	83 ec 08             	sub    $0x8,%esp
  8021ec:	ff 75 0c             	pushl  0xc(%ebp)
  8021ef:	ff 75 08             	pushl  0x8(%ebp)
  8021f2:	e8 ca 0e 00 00       	call   8030c1 <sys_size_of_shared_object>
  8021f7:	83 c4 10             	add    $0x10,%esp
  8021fa:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  8021fd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802201:	7f 0a                	jg     80220d <sget+0x2f>
        return NULL;
  802203:	b8 00 00 00 00       	mov    $0x0,%eax
  802208:	e9 28 03 00 00       	jmp    802535 <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  80220d:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802214:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802217:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80221a:	01 d0                	add    %edx,%eax
  80221c:	48                   	dec    %eax
  80221d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802220:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802223:	ba 00 00 00 00       	mov    $0x0,%edx
  802228:	f7 75 d8             	divl   -0x28(%ebp)
  80222b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80222e:	29 d0                	sub    %edx,%eax
  802230:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  802233:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  80223a:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  802241:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802248:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80224f:	e9 85 00 00 00       	jmp    8022d9 <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  802254:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802257:	89 d0                	mov    %edx,%eax
  802259:	01 c0                	add    %eax,%eax
  80225b:	01 d0                	add    %edx,%eax
  80225d:	c1 e0 02             	shl    $0x2,%eax
  802260:	05 48 10 81 00       	add    $0x811048,%eax
  802265:	8a 00                	mov    (%eax),%al
  802267:	84 c0                	test   %al,%al
  802269:	74 20                	je     80228b <sget+0xad>
  80226b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80226e:	89 d0                	mov    %edx,%eax
  802270:	01 c0                	add    %eax,%eax
  802272:	01 d0                	add    %edx,%eax
  802274:	c1 e0 02             	shl    $0x2,%eax
  802277:	05 44 10 81 00       	add    $0x811044,%eax
  80227c:	8b 00                	mov    (%eax),%eax
  80227e:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802281:	75 08                	jne    80228b <sget+0xad>
        {
            exactIdx = i;
  802283:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802286:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  802289:	eb 5b                	jmp    8022e6 <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  80228b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80228e:	89 d0                	mov    %edx,%eax
  802290:	01 c0                	add    %eax,%eax
  802292:	01 d0                	add    %edx,%eax
  802294:	c1 e0 02             	shl    $0x2,%eax
  802297:	05 48 10 81 00       	add    $0x811048,%eax
  80229c:	8a 00                	mov    (%eax),%al
  80229e:	84 c0                	test   %al,%al
  8022a0:	74 34                	je     8022d6 <sget+0xf8>
  8022a2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8022a5:	89 d0                	mov    %edx,%eax
  8022a7:	01 c0                	add    %eax,%eax
  8022a9:	01 d0                	add    %edx,%eax
  8022ab:	c1 e0 02             	shl    $0x2,%eax
  8022ae:	05 44 10 81 00       	add    $0x811044,%eax
  8022b3:	8b 00                	mov    (%eax),%eax
  8022b5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8022b8:	76 1c                	jbe    8022d6 <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  8022ba:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8022bd:	89 d0                	mov    %edx,%eax
  8022bf:	01 c0                	add    %eax,%eax
  8022c1:	01 d0                	add    %edx,%eax
  8022c3:	c1 e0 02             	shl    $0x2,%eax
  8022c6:	05 44 10 81 00       	add    $0x811044,%eax
  8022cb:	8b 00                	mov    (%eax),%eax
  8022cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  8022d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8022d6:	ff 45 e8             	incl   -0x18(%ebp)
  8022d9:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8022e0:	0f 8e 6e ff ff ff    	jle    802254 <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  8022e6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  8022ed:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8022f1:	74 7d                	je     802370 <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  8022f3:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8022fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022fd:	89 d0                	mov    %edx,%eax
  8022ff:	01 c0                	add    %eax,%eax
  802301:	01 d0                	add    %edx,%eax
  802303:	c1 e0 02             	shl    $0x2,%eax
  802306:	05 40 10 81 00       	add    $0x811040,%eax
  80230b:	8b 10                	mov    (%eax),%edx
  80230d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802310:	01 d0                	add    %edx,%eax
  802312:	48                   	dec    %eax
  802313:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802316:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802319:	ba 00 00 00 00       	mov    $0x0,%edx
  80231e:	f7 75 b8             	divl   -0x48(%ebp)
  802321:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802324:	29 d0                	sub    %edx,%eax
  802326:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  802329:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80232c:	89 d0                	mov    %edx,%eax
  80232e:	01 c0                	add    %eax,%eax
  802330:	01 d0                	add    %edx,%eax
  802332:	c1 e0 02             	shl    $0x2,%eax
  802335:	05 48 10 81 00       	add    $0x811048,%eax
  80233a:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  80233d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802340:	89 d0                	mov    %edx,%eax
  802342:	01 c0                	add    %eax,%eax
  802344:	01 d0                	add    %edx,%eax
  802346:	c1 e0 02             	shl    $0x2,%eax
  802349:	05 44 10 81 00       	add    $0x811044,%eax
  80234e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  802354:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802357:	89 d0                	mov    %edx,%eax
  802359:	01 c0                	add    %eax,%eax
  80235b:	01 d0                	add    %edx,%eax
  80235d:	c1 e0 02             	shl    $0x2,%eax
  802360:	05 40 10 81 00       	add    $0x811040,%eax
  802365:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80236b:	e9 2d 01 00 00       	jmp    80249d <sget+0x2bf>
    }
    else if (worstIdx != -1)
  802370:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802374:	0f 84 ce 00 00 00    	je     802448 <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  80237a:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  802381:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802384:	89 d0                	mov    %edx,%eax
  802386:	01 c0                	add    %eax,%eax
  802388:	01 d0                	add    %edx,%eax
  80238a:	c1 e0 02             	shl    $0x2,%eax
  80238d:	05 40 10 81 00       	add    $0x811040,%eax
  802392:	8b 10                	mov    (%eax),%edx
  802394:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802397:	01 d0                	add    %edx,%eax
  802399:	48                   	dec    %eax
  80239a:	89 45 bc             	mov    %eax,-0x44(%ebp)
  80239d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8023a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8023a5:	f7 75 c0             	divl   -0x40(%ebp)
  8023a8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8023ab:	29 d0                	sub    %edx,%eax
  8023ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  8023b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023b3:	89 d0                	mov    %edx,%eax
  8023b5:	01 c0                	add    %eax,%eax
  8023b7:	01 d0                	add    %edx,%eax
  8023b9:	c1 e0 02             	shl    $0x2,%eax
  8023bc:	05 44 10 81 00       	add    $0x811044,%eax
  8023c1:	8b 00                	mov    (%eax),%eax
  8023c3:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8023c6:	75 47                	jne    80240f <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  8023c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023cb:	89 d0                	mov    %edx,%eax
  8023cd:	01 c0                	add    %eax,%eax
  8023cf:	01 d0                	add    %edx,%eax
  8023d1:	c1 e0 02             	shl    $0x2,%eax
  8023d4:	05 48 10 81 00       	add    $0x811048,%eax
  8023d9:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  8023dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023df:	89 d0                	mov    %edx,%eax
  8023e1:	01 c0                	add    %eax,%eax
  8023e3:	01 d0                	add    %edx,%eax
  8023e5:	c1 e0 02             	shl    $0x2,%eax
  8023e8:	05 44 10 81 00       	add    $0x811044,%eax
  8023ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  8023f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023f6:	89 d0                	mov    %edx,%eax
  8023f8:	01 c0                	add    %eax,%eax
  8023fa:	01 d0                	add    %edx,%eax
  8023fc:	c1 e0 02             	shl    $0x2,%eax
  8023ff:	05 40 10 81 00       	add    $0x811040,%eax
  802404:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80240a:	e9 8e 00 00 00       	jmp    80249d <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  80240f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802412:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802415:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802418:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80241b:	89 d0                	mov    %edx,%eax
  80241d:	01 c0                	add    %eax,%eax
  80241f:	01 d0                	add    %edx,%eax
  802421:	c1 e0 02             	shl    $0x2,%eax
  802424:	05 40 10 81 00       	add    $0x811040,%eax
  802429:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  80242b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80242e:	2b 45 d0             	sub    -0x30(%ebp),%eax
  802431:	89 c2                	mov    %eax,%edx
  802433:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802436:	89 c8                	mov    %ecx,%eax
  802438:	01 c0                	add    %eax,%eax
  80243a:	01 c8                	add    %ecx,%eax
  80243c:	c1 e0 02             	shl    $0x2,%eax
  80243f:	05 44 10 81 00       	add    $0x811044,%eax
  802444:	89 10                	mov    %edx,(%eax)
  802446:	eb 55                	jmp    80249d <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  802448:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80244f:	8b 15 88 50 83 00    	mov    0x835088,%edx
  802455:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802458:	01 d0                	add    %edx,%eax
  80245a:	48                   	dec    %eax
  80245b:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80245e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802461:	ba 00 00 00 00       	mov    $0x0,%edx
  802466:	f7 75 cc             	divl   -0x34(%ebp)
  802469:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80246c:	29 d0                	sub    %edx,%eax
  80246e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  802471:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802474:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802477:	01 d0                	add    %edx,%eax
  802479:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  80247e:	76 0a                	jbe    80248a <sget+0x2ac>
            return NULL;
  802480:	b8 00 00 00 00       	mov    $0x0,%eax
  802485:	e9 ab 00 00 00       	jmp    802535 <sget+0x357>
        va = start;
  80248a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80248d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  802490:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802493:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802496:	01 d0                	add    %edx,%eax
  802498:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80249d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8024a4:	eb 5e                	jmp    802504 <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  8024a6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024a9:	89 d0                	mov    %edx,%eax
  8024ab:	01 c0                	add    %eax,%eax
  8024ad:	01 d0                	add    %edx,%eax
  8024af:	c1 e0 02             	shl    $0x2,%eax
  8024b2:	05 48 50 80 00       	add    $0x805048,%eax
  8024b7:	8a 00                	mov    (%eax),%al
  8024b9:	84 c0                	test   %al,%al
  8024bb:	75 44                	jne    802501 <sget+0x323>
        {
            uhp_allocs[i].va = va;
  8024bd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024c0:	89 d0                	mov    %edx,%eax
  8024c2:	01 c0                	add    %eax,%eax
  8024c4:	01 d0                	add    %edx,%eax
  8024c6:	c1 e0 02             	shl    $0x2,%eax
  8024c9:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  8024cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024d2:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  8024d4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024d7:	89 d0                	mov    %edx,%eax
  8024d9:	01 c0                	add    %eax,%eax
  8024db:	01 d0                	add    %edx,%eax
  8024dd:	c1 e0 02             	shl    $0x2,%eax
  8024e0:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8024e6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8024e9:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  8024eb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024ee:	89 d0                	mov    %edx,%eax
  8024f0:	01 c0                	add    %eax,%eax
  8024f2:	01 d0                	add    %edx,%eax
  8024f4:	c1 e0 02             	shl    $0x2,%eax
  8024f7:	05 48 50 80 00       	add    $0x805048,%eax
  8024fc:	c6 00 01             	movb   $0x1,(%eax)
            break;
  8024ff:	eb 0c                	jmp    80250d <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802501:	ff 45 e0             	incl   -0x20(%ebp)
  802504:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80250b:	7e 99                	jle    8024a6 <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  80250d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802510:	83 ec 04             	sub    $0x4,%esp
  802513:	50                   	push   %eax
  802514:	ff 75 0c             	pushl  0xc(%ebp)
  802517:	ff 75 08             	pushl  0x8(%ebp)
  80251a:	e8 bf 0b 00 00       	call   8030de <sys_get_shared_object>
  80251f:	83 c4 10             	add    $0x10,%esp
  802522:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  802525:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802529:	79 07                	jns    802532 <sget+0x354>
        return NULL;
  80252b:	b8 00 00 00 00       	mov    $0x0,%eax
  802530:	eb 03                	jmp    802535 <sget+0x357>
    return (void*)va;
  802532:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  802535:	c9                   	leave  
  802536:	c3                   	ret    

00802537 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802537:	55                   	push   %ebp
  802538:	89 e5                	mov    %esp,%ebp
  80253a:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80253d:	e8 f8 f0 ff ff       	call   80163a <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  802542:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802546:	75 13                	jne    80255b <realloc+0x24>
		return malloc(new_size);
  802548:	83 ec 0c             	sub    $0xc,%esp
  80254b:	ff 75 0c             	pushl  0xc(%ebp)
  80254e:	e8 c4 f1 ff ff       	call   801717 <malloc>
  802553:	83 c4 10             	add    $0x10,%esp
  802556:	e9 f4 05 00 00       	jmp    802b4f <realloc+0x618>
	if (new_size == 0)
  80255b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80255f:	75 18                	jne    802579 <realloc+0x42>
	{
		free(virtual_address);
  802561:	83 ec 0c             	sub    $0xc,%esp
  802564:	ff 75 08             	pushl  0x8(%ebp)
  802567:	e8 0b f5 ff ff       	call   801a77 <free>
  80256c:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80256f:	b8 00 00 00 00       	mov    $0x0,%eax
  802574:	e9 d6 05 00 00       	jmp    802b4f <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  802579:	8b 45 08             	mov    0x8(%ebp),%eax
  80257c:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  80257f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802582:	85 c0                	test   %eax,%eax
  802584:	79 74                	jns    8025fa <realloc+0xc3>
  802586:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  80258d:	77 6b                	ja     8025fa <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  80258f:	83 ec 0c             	sub    $0xc,%esp
  802592:	ff 75 0c             	pushl  0xc(%ebp)
  802595:	e8 7d f1 ff ff       	call   801717 <malloc>
  80259a:	83 c4 10             	add    $0x10,%esp
  80259d:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  8025a0:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8025a4:	75 0a                	jne    8025b0 <realloc+0x79>
			return NULL;
  8025a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ab:	e9 9f 05 00 00       	jmp    802b4f <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  8025b0:	83 ec 0c             	sub    $0xc,%esp
  8025b3:	ff 75 08             	pushl  0x8(%ebp)
  8025b6:	e8 e0 11 00 00       	call   80379b <get_block_size>
  8025bb:	83 c4 10             	add    $0x10,%esp
  8025be:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  8025c1:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8025c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025c7:	39 d0                	cmp    %edx,%eax
  8025c9:	76 02                	jbe    8025cd <realloc+0x96>
  8025cb:	89 d0                	mov    %edx,%eax
  8025cd:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  8025d0:	83 ec 04             	sub    $0x4,%esp
  8025d3:	ff 75 c0             	pushl  -0x40(%ebp)
  8025d6:	ff 75 08             	pushl  0x8(%ebp)
  8025d9:	ff 75 c8             	pushl  -0x38(%ebp)
  8025dc:	e8 56 eb ff ff       	call   801137 <memmove>
  8025e1:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  8025e4:	83 ec 0c             	sub    $0xc,%esp
  8025e7:	ff 75 08             	pushl  0x8(%ebp)
  8025ea:	e8 88 f4 ff ff       	call   801a77 <free>
  8025ef:	83 c4 10             	add    $0x10,%esp
		return newptr;
  8025f2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8025f5:	e9 55 05 00 00       	jmp    802b4f <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  8025fa:	a1 30 51 83 00       	mov    0x835130,%eax
  8025ff:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  802602:	72 09                	jb     80260d <realloc+0xd6>
  802604:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  80260b:	76 0a                	jbe    802617 <realloc+0xe0>
		return NULL;
  80260d:	b8 00 00 00 00       	mov    $0x0,%eax
  802612:	e9 38 05 00 00       	jmp    802b4f <realloc+0x618>
	uint32 oldsz = 0;
  802617:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  80261e:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802625:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80262c:	eb 50                	jmp    80267e <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  80262e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802631:	89 d0                	mov    %edx,%eax
  802633:	01 c0                	add    %eax,%eax
  802635:	01 d0                	add    %edx,%eax
  802637:	c1 e0 02             	shl    $0x2,%eax
  80263a:	05 48 50 80 00       	add    $0x805048,%eax
  80263f:	8a 00                	mov    (%eax),%al
  802641:	84 c0                	test   %al,%al
  802643:	74 36                	je     80267b <realloc+0x144>
  802645:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802648:	89 d0                	mov    %edx,%eax
  80264a:	01 c0                	add    %eax,%eax
  80264c:	01 d0                	add    %edx,%eax
  80264e:	c1 e0 02             	shl    $0x2,%eax
  802651:	05 40 50 80 00       	add    $0x805040,%eax
  802656:	8b 00                	mov    (%eax),%eax
  802658:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  80265b:	75 1e                	jne    80267b <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  80265d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802660:	89 d0                	mov    %edx,%eax
  802662:	01 c0                	add    %eax,%eax
  802664:	01 d0                	add    %edx,%eax
  802666:	c1 e0 02             	shl    $0x2,%eax
  802669:	05 44 50 80 00       	add    $0x805044,%eax
  80266e:	8b 00                	mov    (%eax),%eax
  802670:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  802673:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802676:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802679:	eb 0c                	jmp    802687 <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80267b:	ff 45 ec             	incl   -0x14(%ebp)
  80267e:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802685:	7e a7                	jle    80262e <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  802687:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80268b:	75 0a                	jne    802697 <realloc+0x160>
		return NULL;
  80268d:	b8 00 00 00 00       	mov    $0x0,%eax
  802692:	e9 b8 04 00 00       	jmp    802b4f <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  802697:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  80269e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026a1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8026a4:	01 d0                	add    %edx,%eax
  8026a6:	48                   	dec    %eax
  8026a7:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8026aa:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8026ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8026b2:	f7 75 bc             	divl   -0x44(%ebp)
  8026b5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8026b8:	29 d0                	sub    %edx,%eax
  8026ba:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  8026bd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8026c0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8026c3:	75 08                	jne    8026cd <realloc+0x196>
		return virtual_address;
  8026c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c8:	e9 82 04 00 00       	jmp    802b4f <realloc+0x618>
	if (req < oldsz)
  8026cd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8026d0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8026d3:	0f 83 cd 02 00 00    	jae    8029a6 <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  8026d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026dc:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  8026df:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  8026e2:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8026e5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8026e8:	01 d0                	add    %edx,%eax
  8026ea:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  8026ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026f0:	89 d0                	mov    %edx,%eax
  8026f2:	01 c0                	add    %eax,%eax
  8026f4:	01 d0                	add    %edx,%eax
  8026f6:	c1 e0 02             	shl    $0x2,%eax
  8026f9:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8026ff:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802702:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  802704:	83 ec 08             	sub    $0x8,%esp
  802707:	ff 75 b0             	pushl  -0x50(%ebp)
  80270a:	ff 75 ac             	pushl  -0x54(%ebp)
  80270d:	e8 e3 0c 00 00       	call   8033f5 <sys_free_user_mem>
  802712:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  802715:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  80271c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  802723:	eb 64                	jmp    802789 <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  802725:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802728:	89 d0                	mov    %edx,%eax
  80272a:	01 c0                	add    %eax,%eax
  80272c:	01 d0                	add    %edx,%eax
  80272e:	c1 e0 02             	shl    $0x2,%eax
  802731:	05 48 10 81 00       	add    $0x811048,%eax
  802736:	8a 00                	mov    (%eax),%al
  802738:	84 c0                	test   %al,%al
  80273a:	75 4a                	jne    802786 <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  80273c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80273f:	89 d0                	mov    %edx,%eax
  802741:	01 c0                	add    %eax,%eax
  802743:	01 d0                	add    %edx,%eax
  802745:	c1 e0 02             	shl    $0x2,%eax
  802748:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  80274e:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802751:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  802753:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802756:	89 d0                	mov    %edx,%eax
  802758:	01 c0                	add    %eax,%eax
  80275a:	01 d0                	add    %edx,%eax
  80275c:	c1 e0 02             	shl    $0x2,%eax
  80275f:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  802765:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802768:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  80276a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80276d:	89 d0                	mov    %edx,%eax
  80276f:	01 c0                	add    %eax,%eax
  802771:	01 d0                	add    %edx,%eax
  802773:	c1 e0 02             	shl    $0x2,%eax
  802776:	05 48 10 81 00       	add    $0x811048,%eax
  80277b:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  80277e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802781:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  802784:	eb 0c                	jmp    802792 <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802786:	ff 45 e4             	incl   -0x1c(%ebp)
  802789:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  802790:	7e 93                	jle    802725 <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  802792:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802796:	0f 84 8d 01 00 00    	je     802929 <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  80279c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8027a3:	e9 74 01 00 00       	jmp    80291c <realloc+0x3e5>
			{
				if (k == fidx) continue;
  8027a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027ab:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8027ae:	0f 84 64 01 00 00    	je     802918 <realloc+0x3e1>
				if (uhp_frees[k].free)
  8027b4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027b7:	89 d0                	mov    %edx,%eax
  8027b9:	01 c0                	add    %eax,%eax
  8027bb:	01 d0                	add    %edx,%eax
  8027bd:	c1 e0 02             	shl    $0x2,%eax
  8027c0:	05 48 10 81 00       	add    $0x811048,%eax
  8027c5:	8a 00                	mov    (%eax),%al
  8027c7:	84 c0                	test   %al,%al
  8027c9:	0f 84 4a 01 00 00    	je     802919 <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  8027cf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027d2:	89 d0                	mov    %edx,%eax
  8027d4:	01 c0                	add    %eax,%eax
  8027d6:	01 d0                	add    %edx,%eax
  8027d8:	c1 e0 02             	shl    $0x2,%eax
  8027db:	05 40 10 81 00       	add    $0x811040,%eax
  8027e0:	8b 08                	mov    (%eax),%ecx
  8027e2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027e5:	89 d0                	mov    %edx,%eax
  8027e7:	01 c0                	add    %eax,%eax
  8027e9:	01 d0                	add    %edx,%eax
  8027eb:	c1 e0 02             	shl    $0x2,%eax
  8027ee:	05 44 10 81 00       	add    $0x811044,%eax
  8027f3:	8b 00                	mov    (%eax),%eax
  8027f5:	01 c1                	add    %eax,%ecx
  8027f7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027fa:	89 d0                	mov    %edx,%eax
  8027fc:	01 c0                	add    %eax,%eax
  8027fe:	01 d0                	add    %edx,%eax
  802800:	c1 e0 02             	shl    $0x2,%eax
  802803:	05 40 10 81 00       	add    $0x811040,%eax
  802808:	8b 00                	mov    (%eax),%eax
  80280a:	39 c1                	cmp    %eax,%ecx
  80280c:	75 7a                	jne    802888 <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  80280e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802811:	89 d0                	mov    %edx,%eax
  802813:	01 c0                	add    %eax,%eax
  802815:	01 d0                	add    %edx,%eax
  802817:	c1 e0 02             	shl    $0x2,%eax
  80281a:	05 40 10 81 00       	add    $0x811040,%eax
  80281f:	8b 10                	mov    (%eax),%edx
  802821:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  802824:	89 c8                	mov    %ecx,%eax
  802826:	01 c0                	add    %eax,%eax
  802828:	01 c8                	add    %ecx,%eax
  80282a:	c1 e0 02             	shl    $0x2,%eax
  80282d:	05 40 10 81 00       	add    $0x811040,%eax
  802832:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  802834:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802837:	89 d0                	mov    %edx,%eax
  802839:	01 c0                	add    %eax,%eax
  80283b:	01 d0                	add    %edx,%eax
  80283d:	c1 e0 02             	shl    $0x2,%eax
  802840:	05 44 10 81 00       	add    $0x811044,%eax
  802845:	8b 08                	mov    (%eax),%ecx
  802847:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80284a:	89 d0                	mov    %edx,%eax
  80284c:	01 c0                	add    %eax,%eax
  80284e:	01 d0                	add    %edx,%eax
  802850:	c1 e0 02             	shl    $0x2,%eax
  802853:	05 44 10 81 00       	add    $0x811044,%eax
  802858:	8b 00                	mov    (%eax),%eax
  80285a:	01 c1                	add    %eax,%ecx
  80285c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80285f:	89 d0                	mov    %edx,%eax
  802861:	01 c0                	add    %eax,%eax
  802863:	01 d0                	add    %edx,%eax
  802865:	c1 e0 02             	shl    $0x2,%eax
  802868:	05 44 10 81 00       	add    $0x811044,%eax
  80286d:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  80286f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802872:	89 d0                	mov    %edx,%eax
  802874:	01 c0                	add    %eax,%eax
  802876:	01 d0                	add    %edx,%eax
  802878:	c1 e0 02             	shl    $0x2,%eax
  80287b:	05 48 10 81 00       	add    $0x811048,%eax
  802880:	c6 00 00             	movb   $0x0,(%eax)
  802883:	e9 91 00 00 00       	jmp    802919 <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802888:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80288b:	89 d0                	mov    %edx,%eax
  80288d:	01 c0                	add    %eax,%eax
  80288f:	01 d0                	add    %edx,%eax
  802891:	c1 e0 02             	shl    $0x2,%eax
  802894:	05 40 10 81 00       	add    $0x811040,%eax
  802899:	8b 08                	mov    (%eax),%ecx
  80289b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80289e:	89 d0                	mov    %edx,%eax
  8028a0:	01 c0                	add    %eax,%eax
  8028a2:	01 d0                	add    %edx,%eax
  8028a4:	c1 e0 02             	shl    $0x2,%eax
  8028a7:	05 44 10 81 00       	add    $0x811044,%eax
  8028ac:	8b 00                	mov    (%eax),%eax
  8028ae:	01 c1                	add    %eax,%ecx
  8028b0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028b3:	89 d0                	mov    %edx,%eax
  8028b5:	01 c0                	add    %eax,%eax
  8028b7:	01 d0                	add    %edx,%eax
  8028b9:	c1 e0 02             	shl    $0x2,%eax
  8028bc:	05 40 10 81 00       	add    $0x811040,%eax
  8028c1:	8b 00                	mov    (%eax),%eax
  8028c3:	39 c1                	cmp    %eax,%ecx
  8028c5:	75 52                	jne    802919 <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  8028c7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028ca:	89 d0                	mov    %edx,%eax
  8028cc:	01 c0                	add    %eax,%eax
  8028ce:	01 d0                	add    %edx,%eax
  8028d0:	c1 e0 02             	shl    $0x2,%eax
  8028d3:	05 44 10 81 00       	add    $0x811044,%eax
  8028d8:	8b 08                	mov    (%eax),%ecx
  8028da:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028dd:	89 d0                	mov    %edx,%eax
  8028df:	01 c0                	add    %eax,%eax
  8028e1:	01 d0                	add    %edx,%eax
  8028e3:	c1 e0 02             	shl    $0x2,%eax
  8028e6:	05 44 10 81 00       	add    $0x811044,%eax
  8028eb:	8b 00                	mov    (%eax),%eax
  8028ed:	01 c1                	add    %eax,%ecx
  8028ef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028f2:	89 d0                	mov    %edx,%eax
  8028f4:	01 c0                	add    %eax,%eax
  8028f6:	01 d0                	add    %edx,%eax
  8028f8:	c1 e0 02             	shl    $0x2,%eax
  8028fb:	05 44 10 81 00       	add    $0x811044,%eax
  802900:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802902:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802905:	89 d0                	mov    %edx,%eax
  802907:	01 c0                	add    %eax,%eax
  802909:	01 d0                	add    %edx,%eax
  80290b:	c1 e0 02             	shl    $0x2,%eax
  80290e:	05 48 10 81 00       	add    $0x811048,%eax
  802913:	c6 00 00             	movb   $0x0,(%eax)
  802916:	eb 01                	jmp    802919 <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  802918:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802919:	ff 45 e0             	incl   -0x20(%ebp)
  80291c:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802923:	0f 8e 7f fe ff ff    	jle    8027a8 <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  802929:	a1 30 51 83 00       	mov    0x835130,%eax
  80292e:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802931:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  802938:	eb 53                	jmp    80298d <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  80293a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80293d:	89 d0                	mov    %edx,%eax
  80293f:	01 c0                	add    %eax,%eax
  802941:	01 d0                	add    %edx,%eax
  802943:	c1 e0 02             	shl    $0x2,%eax
  802946:	05 48 50 80 00       	add    $0x805048,%eax
  80294b:	8a 00                	mov    (%eax),%al
  80294d:	84 c0                	test   %al,%al
  80294f:	74 39                	je     80298a <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802951:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802954:	89 d0                	mov    %edx,%eax
  802956:	01 c0                	add    %eax,%eax
  802958:	01 d0                	add    %edx,%eax
  80295a:	c1 e0 02             	shl    $0x2,%eax
  80295d:	05 40 50 80 00       	add    $0x805040,%eax
  802962:	8b 08                	mov    (%eax),%ecx
  802964:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802967:	89 d0                	mov    %edx,%eax
  802969:	01 c0                	add    %eax,%eax
  80296b:	01 d0                	add    %edx,%eax
  80296d:	c1 e0 02             	shl    $0x2,%eax
  802970:	05 44 50 80 00       	add    $0x805044,%eax
  802975:	8b 00                	mov    (%eax),%eax
  802977:	01 c8                	add    %ecx,%eax
  802979:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  80297c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80297f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802982:	76 06                	jbe    80298a <realloc+0x453>
  802984:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802987:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  80298a:	ff 45 d8             	incl   -0x28(%ebp)
  80298d:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  802994:	7e a4                	jle    80293a <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  802996:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802999:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  80299e:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a1:	e9 a9 01 00 00       	jmp    802b4f <realloc+0x618>
	}
	uint32 end = va + oldsz;
  8029a6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ac:	01 d0                	add    %edx,%eax
  8029ae:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  8029b1:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8029b8:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  8029bf:	eb 57                	jmp    802a18 <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  8029c1:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8029c4:	89 d0                	mov    %edx,%eax
  8029c6:	01 c0                	add    %eax,%eax
  8029c8:	01 d0                	add    %edx,%eax
  8029ca:	c1 e0 02             	shl    $0x2,%eax
  8029cd:	05 48 10 81 00       	add    $0x811048,%eax
  8029d2:	8a 00                	mov    (%eax),%al
  8029d4:	84 c0                	test   %al,%al
  8029d6:	74 3d                	je     802a15 <realloc+0x4de>
  8029d8:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8029db:	89 d0                	mov    %edx,%eax
  8029dd:	01 c0                	add    %eax,%eax
  8029df:	01 d0                	add    %edx,%eax
  8029e1:	c1 e0 02             	shl    $0x2,%eax
  8029e4:	05 40 10 81 00       	add    $0x811040,%eax
  8029e9:	8b 00                	mov    (%eax),%eax
  8029eb:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029ee:	75 25                	jne    802a15 <realloc+0x4de>
  8029f0:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8029f3:	89 d0                	mov    %edx,%eax
  8029f5:	01 c0                	add    %eax,%eax
  8029f7:	01 d0                	add    %edx,%eax
  8029f9:	c1 e0 02             	shl    $0x2,%eax
  8029fc:	05 44 10 81 00       	add    $0x811044,%eax
  802a01:	8b 10                	mov    (%eax),%edx
  802a03:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a06:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802a09:	39 c2                	cmp    %eax,%edx
  802a0b:	72 08                	jb     802a15 <realloc+0x4de>
		{
			adjIdx = j; break;
  802a0d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802a10:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802a13:	eb 0c                	jmp    802a21 <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802a15:	ff 45 d0             	incl   -0x30(%ebp)
  802a18:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  802a1f:	7e a0                	jle    8029c1 <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  802a21:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  802a25:	0f 84 d6 00 00 00    	je     802b01 <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  802a2b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a2e:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802a31:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  802a34:	83 ec 08             	sub    $0x8,%esp
  802a37:	ff 75 a0             	pushl  -0x60(%ebp)
  802a3a:	ff 75 a4             	pushl  -0x5c(%ebp)
  802a3d:	e8 cf 09 00 00       	call   803411 <sys_allocate_user_mem>
  802a42:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  802a45:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a48:	89 d0                	mov    %edx,%eax
  802a4a:	01 c0                	add    %eax,%eax
  802a4c:	01 d0                	add    %edx,%eax
  802a4e:	c1 e0 02             	shl    $0x2,%eax
  802a51:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802a57:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a5a:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  802a5c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a5f:	89 d0                	mov    %edx,%eax
  802a61:	01 c0                	add    %eax,%eax
  802a63:	01 d0                	add    %edx,%eax
  802a65:	c1 e0 02             	shl    $0x2,%eax
  802a68:	05 40 10 81 00       	add    $0x811040,%eax
  802a6d:	8b 10                	mov    (%eax),%edx
  802a6f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802a72:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802a75:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a78:	89 d0                	mov    %edx,%eax
  802a7a:	01 c0                	add    %eax,%eax
  802a7c:	01 d0                	add    %edx,%eax
  802a7e:	c1 e0 02             	shl    $0x2,%eax
  802a81:	05 40 10 81 00       	add    $0x811040,%eax
  802a86:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  802a88:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a8b:	89 d0                	mov    %edx,%eax
  802a8d:	01 c0                	add    %eax,%eax
  802a8f:	01 d0                	add    %edx,%eax
  802a91:	c1 e0 02             	shl    $0x2,%eax
  802a94:	05 44 10 81 00       	add    $0x811044,%eax
  802a99:	8b 00                	mov    (%eax),%eax
  802a9b:	2b 45 a0             	sub    -0x60(%ebp),%eax
  802a9e:	89 c2                	mov    %eax,%edx
  802aa0:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  802aa3:	89 c8                	mov    %ecx,%eax
  802aa5:	01 c0                	add    %eax,%eax
  802aa7:	01 c8                	add    %ecx,%eax
  802aa9:	c1 e0 02             	shl    $0x2,%eax
  802aac:	05 44 10 81 00       	add    $0x811044,%eax
  802ab1:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  802ab3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802ab6:	89 d0                	mov    %edx,%eax
  802ab8:	01 c0                	add    %eax,%eax
  802aba:	01 d0                	add    %edx,%eax
  802abc:	c1 e0 02             	shl    $0x2,%eax
  802abf:	05 44 10 81 00       	add    $0x811044,%eax
  802ac4:	8b 00                	mov    (%eax),%eax
  802ac6:	85 c0                	test   %eax,%eax
  802ac8:	75 14                	jne    802ade <realloc+0x5a7>
  802aca:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802acd:	89 d0                	mov    %edx,%eax
  802acf:	01 c0                	add    %eax,%eax
  802ad1:	01 d0                	add    %edx,%eax
  802ad3:	c1 e0 02             	shl    $0x2,%eax
  802ad6:	05 48 10 81 00       	add    $0x811048,%eax
  802adb:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  802ade:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ae1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ae4:	01 c2                	add    %eax,%edx
  802ae6:	a1 88 50 83 00       	mov    0x835088,%eax
  802aeb:	39 c2                	cmp    %eax,%edx
  802aed:	76 0d                	jbe    802afc <realloc+0x5c5>
  802aef:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802af2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802af5:	01 d0                	add    %edx,%eax
  802af7:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  802afc:	8b 45 08             	mov    0x8(%ebp),%eax
  802aff:	eb 4e                	jmp    802b4f <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  802b01:	83 ec 0c             	sub    $0xc,%esp
  802b04:	ff 75 0c             	pushl  0xc(%ebp)
  802b07:	e8 0b ec ff ff       	call   801717 <malloc>
  802b0c:	83 c4 10             	add    $0x10,%esp
  802b0f:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  802b12:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  802b16:	75 07                	jne    802b1f <realloc+0x5e8>
		return NULL;
  802b18:	b8 00 00 00 00       	mov    $0x0,%eax
  802b1d:	eb 30                	jmp    802b4f <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  802b1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b22:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b25:	39 d0                	cmp    %edx,%eax
  802b27:	76 02                	jbe    802b2b <realloc+0x5f4>
  802b29:	89 d0                	mov    %edx,%eax
  802b2b:	8b 55 9c             	mov    -0x64(%ebp),%edx
  802b2e:	83 ec 04             	sub    $0x4,%esp
  802b31:	50                   	push   %eax
  802b32:	52                   	push   %edx
  802b33:	ff 75 cc             	pushl  -0x34(%ebp)
  802b36:	e8 cf 06 00 00       	call   80320a <sys_move_user_mem>
  802b3b:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  802b3e:	83 ec 0c             	sub    $0xc,%esp
  802b41:	ff 75 08             	pushl  0x8(%ebp)
  802b44:	e8 2e ef ff ff       	call   801a77 <free>
  802b49:	83 c4 10             	add    $0x10,%esp
	return newptr;
  802b4c:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  802b4f:	c9                   	leave  
  802b50:	c3                   	ret    

00802b51 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802b51:	55                   	push   %ebp
  802b52:	89 e5                	mov    %esp,%ebp
  802b54:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  802b57:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5a:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  802b5d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802b61:	0f 84 33 03 00 00    	je     802e9a <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  802b67:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b6a:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  802b6f:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  802b72:	83 ec 08             	sub    $0x8,%esp
  802b75:	ff 75 08             	pushl  0x8(%ebp)
  802b78:	ff 75 d8             	pushl  -0x28(%ebp)
  802b7b:	e8 7d 05 00 00       	call   8030fd <sys_delete_shared_object>
  802b80:	83 c4 10             	add    $0x10,%esp
  802b83:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  802b86:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802b8a:	0f 88 0d 03 00 00    	js     802e9d <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802b90:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802b97:	e9 ef 02 00 00       	jmp    802e8b <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802b9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b9f:	89 d0                	mov    %edx,%eax
  802ba1:	01 c0                	add    %eax,%eax
  802ba3:	01 d0                	add    %edx,%eax
  802ba5:	c1 e0 02             	shl    $0x2,%eax
  802ba8:	05 48 50 80 00       	add    $0x805048,%eax
  802bad:	8a 00                	mov    (%eax),%al
  802baf:	84 c0                	test   %al,%al
  802bb1:	0f 84 d1 02 00 00    	je     802e88 <sfree+0x337>
  802bb7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bba:	89 d0                	mov    %edx,%eax
  802bbc:	01 c0                	add    %eax,%eax
  802bbe:	01 d0                	add    %edx,%eax
  802bc0:	c1 e0 02             	shl    $0x2,%eax
  802bc3:	05 40 50 80 00       	add    $0x805040,%eax
  802bc8:	8b 00                	mov    (%eax),%eax
  802bca:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802bcd:	0f 85 b5 02 00 00    	jne    802e88 <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  802bd3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bd6:	89 d0                	mov    %edx,%eax
  802bd8:	01 c0                	add    %eax,%eax
  802bda:	01 d0                	add    %edx,%eax
  802bdc:	c1 e0 02             	shl    $0x2,%eax
  802bdf:	05 44 50 80 00       	add    $0x805044,%eax
  802be4:	8b 00                	mov    (%eax),%eax
  802be6:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  802be9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bec:	89 d0                	mov    %edx,%eax
  802bee:	01 c0                	add    %eax,%eax
  802bf0:	01 d0                	add    %edx,%eax
  802bf2:	c1 e0 02             	shl    $0x2,%eax
  802bf5:	05 48 50 80 00       	add    $0x805048,%eax
  802bfa:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  802bfd:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802c04:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802c0b:	eb 64                	jmp    802c71 <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  802c0d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c10:	89 d0                	mov    %edx,%eax
  802c12:	01 c0                	add    %eax,%eax
  802c14:	01 d0                	add    %edx,%eax
  802c16:	c1 e0 02             	shl    $0x2,%eax
  802c19:	05 48 10 81 00       	add    $0x811048,%eax
  802c1e:	8a 00                	mov    (%eax),%al
  802c20:	84 c0                	test   %al,%al
  802c22:	75 4a                	jne    802c6e <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  802c24:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c27:	89 d0                	mov    %edx,%eax
  802c29:	01 c0                	add    %eax,%eax
  802c2b:	01 d0                	add    %edx,%eax
  802c2d:	c1 e0 02             	shl    $0x2,%eax
  802c30:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  802c36:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c39:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  802c3b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c3e:	89 d0                	mov    %edx,%eax
  802c40:	01 c0                	add    %eax,%eax
  802c42:	01 d0                	add    %edx,%eax
  802c44:	c1 e0 02             	shl    $0x2,%eax
  802c47:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  802c4d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c50:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  802c52:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c55:	89 d0                	mov    %edx,%eax
  802c57:	01 c0                	add    %eax,%eax
  802c59:	01 d0                	add    %edx,%eax
  802c5b:	c1 e0 02             	shl    $0x2,%eax
  802c5e:	05 48 10 81 00       	add    $0x811048,%eax
  802c63:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  802c66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c69:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  802c6c:	eb 0c                	jmp    802c7a <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802c6e:	ff 45 ec             	incl   -0x14(%ebp)
  802c71:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802c78:	7e 93                	jle    802c0d <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  802c7a:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802c7e:	0f 84 8d 01 00 00    	je     802e11 <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802c84:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802c8b:	e9 74 01 00 00       	jmp    802e04 <sfree+0x2b3>
				{
					if (k == fidx) continue;
  802c90:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c93:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c96:	0f 84 64 01 00 00    	je     802e00 <sfree+0x2af>
					if (uhp_frees[k].free)
  802c9c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c9f:	89 d0                	mov    %edx,%eax
  802ca1:	01 c0                	add    %eax,%eax
  802ca3:	01 d0                	add    %edx,%eax
  802ca5:	c1 e0 02             	shl    $0x2,%eax
  802ca8:	05 48 10 81 00       	add    $0x811048,%eax
  802cad:	8a 00                	mov    (%eax),%al
  802caf:	84 c0                	test   %al,%al
  802cb1:	0f 84 4a 01 00 00    	je     802e01 <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802cb7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cba:	89 d0                	mov    %edx,%eax
  802cbc:	01 c0                	add    %eax,%eax
  802cbe:	01 d0                	add    %edx,%eax
  802cc0:	c1 e0 02             	shl    $0x2,%eax
  802cc3:	05 40 10 81 00       	add    $0x811040,%eax
  802cc8:	8b 08                	mov    (%eax),%ecx
  802cca:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ccd:	89 d0                	mov    %edx,%eax
  802ccf:	01 c0                	add    %eax,%eax
  802cd1:	01 d0                	add    %edx,%eax
  802cd3:	c1 e0 02             	shl    $0x2,%eax
  802cd6:	05 44 10 81 00       	add    $0x811044,%eax
  802cdb:	8b 00                	mov    (%eax),%eax
  802cdd:	01 c1                	add    %eax,%ecx
  802cdf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ce2:	89 d0                	mov    %edx,%eax
  802ce4:	01 c0                	add    %eax,%eax
  802ce6:	01 d0                	add    %edx,%eax
  802ce8:	c1 e0 02             	shl    $0x2,%eax
  802ceb:	05 40 10 81 00       	add    $0x811040,%eax
  802cf0:	8b 00                	mov    (%eax),%eax
  802cf2:	39 c1                	cmp    %eax,%ecx
  802cf4:	75 7a                	jne    802d70 <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  802cf6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cf9:	89 d0                	mov    %edx,%eax
  802cfb:	01 c0                	add    %eax,%eax
  802cfd:	01 d0                	add    %edx,%eax
  802cff:	c1 e0 02             	shl    $0x2,%eax
  802d02:	05 40 10 81 00       	add    $0x811040,%eax
  802d07:	8b 10                	mov    (%eax),%edx
  802d09:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802d0c:	89 c8                	mov    %ecx,%eax
  802d0e:	01 c0                	add    %eax,%eax
  802d10:	01 c8                	add    %ecx,%eax
  802d12:	c1 e0 02             	shl    $0x2,%eax
  802d15:	05 40 10 81 00       	add    $0x811040,%eax
  802d1a:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  802d1c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d1f:	89 d0                	mov    %edx,%eax
  802d21:	01 c0                	add    %eax,%eax
  802d23:	01 d0                	add    %edx,%eax
  802d25:	c1 e0 02             	shl    $0x2,%eax
  802d28:	05 44 10 81 00       	add    $0x811044,%eax
  802d2d:	8b 08                	mov    (%eax),%ecx
  802d2f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d32:	89 d0                	mov    %edx,%eax
  802d34:	01 c0                	add    %eax,%eax
  802d36:	01 d0                	add    %edx,%eax
  802d38:	c1 e0 02             	shl    $0x2,%eax
  802d3b:	05 44 10 81 00       	add    $0x811044,%eax
  802d40:	8b 00                	mov    (%eax),%eax
  802d42:	01 c1                	add    %eax,%ecx
  802d44:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d47:	89 d0                	mov    %edx,%eax
  802d49:	01 c0                	add    %eax,%eax
  802d4b:	01 d0                	add    %edx,%eax
  802d4d:	c1 e0 02             	shl    $0x2,%eax
  802d50:	05 44 10 81 00       	add    $0x811044,%eax
  802d55:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802d57:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d5a:	89 d0                	mov    %edx,%eax
  802d5c:	01 c0                	add    %eax,%eax
  802d5e:	01 d0                	add    %edx,%eax
  802d60:	c1 e0 02             	shl    $0x2,%eax
  802d63:	05 48 10 81 00       	add    $0x811048,%eax
  802d68:	c6 00 00             	movb   $0x0,(%eax)
  802d6b:	e9 91 00 00 00       	jmp    802e01 <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802d70:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d73:	89 d0                	mov    %edx,%eax
  802d75:	01 c0                	add    %eax,%eax
  802d77:	01 d0                	add    %edx,%eax
  802d79:	c1 e0 02             	shl    $0x2,%eax
  802d7c:	05 40 10 81 00       	add    $0x811040,%eax
  802d81:	8b 08                	mov    (%eax),%ecx
  802d83:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d86:	89 d0                	mov    %edx,%eax
  802d88:	01 c0                	add    %eax,%eax
  802d8a:	01 d0                	add    %edx,%eax
  802d8c:	c1 e0 02             	shl    $0x2,%eax
  802d8f:	05 44 10 81 00       	add    $0x811044,%eax
  802d94:	8b 00                	mov    (%eax),%eax
  802d96:	01 c1                	add    %eax,%ecx
  802d98:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d9b:	89 d0                	mov    %edx,%eax
  802d9d:	01 c0                	add    %eax,%eax
  802d9f:	01 d0                	add    %edx,%eax
  802da1:	c1 e0 02             	shl    $0x2,%eax
  802da4:	05 40 10 81 00       	add    $0x811040,%eax
  802da9:	8b 00                	mov    (%eax),%eax
  802dab:	39 c1                	cmp    %eax,%ecx
  802dad:	75 52                	jne    802e01 <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  802daf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802db2:	89 d0                	mov    %edx,%eax
  802db4:	01 c0                	add    %eax,%eax
  802db6:	01 d0                	add    %edx,%eax
  802db8:	c1 e0 02             	shl    $0x2,%eax
  802dbb:	05 44 10 81 00       	add    $0x811044,%eax
  802dc0:	8b 08                	mov    (%eax),%ecx
  802dc2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802dc5:	89 d0                	mov    %edx,%eax
  802dc7:	01 c0                	add    %eax,%eax
  802dc9:	01 d0                	add    %edx,%eax
  802dcb:	c1 e0 02             	shl    $0x2,%eax
  802dce:	05 44 10 81 00       	add    $0x811044,%eax
  802dd3:	8b 00                	mov    (%eax),%eax
  802dd5:	01 c1                	add    %eax,%ecx
  802dd7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dda:	89 d0                	mov    %edx,%eax
  802ddc:	01 c0                	add    %eax,%eax
  802dde:	01 d0                	add    %edx,%eax
  802de0:	c1 e0 02             	shl    $0x2,%eax
  802de3:	05 44 10 81 00       	add    $0x811044,%eax
  802de8:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802dea:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ded:	89 d0                	mov    %edx,%eax
  802def:	01 c0                	add    %eax,%eax
  802df1:	01 d0                	add    %edx,%eax
  802df3:	c1 e0 02             	shl    $0x2,%eax
  802df6:	05 48 10 81 00       	add    $0x811048,%eax
  802dfb:	c6 00 00             	movb   $0x0,(%eax)
  802dfe:	eb 01                	jmp    802e01 <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  802e00:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802e01:	ff 45 e8             	incl   -0x18(%ebp)
  802e04:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802e0b:	0f 8e 7f fe ff ff    	jle    802c90 <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  802e11:	a1 30 51 83 00       	mov    0x835130,%eax
  802e16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802e19:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802e20:	eb 53                	jmp    802e75 <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  802e22:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e25:	89 d0                	mov    %edx,%eax
  802e27:	01 c0                	add    %eax,%eax
  802e29:	01 d0                	add    %edx,%eax
  802e2b:	c1 e0 02             	shl    $0x2,%eax
  802e2e:	05 48 50 80 00       	add    $0x805048,%eax
  802e33:	8a 00                	mov    (%eax),%al
  802e35:	84 c0                	test   %al,%al
  802e37:	74 39                	je     802e72 <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802e39:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e3c:	89 d0                	mov    %edx,%eax
  802e3e:	01 c0                	add    %eax,%eax
  802e40:	01 d0                	add    %edx,%eax
  802e42:	c1 e0 02             	shl    $0x2,%eax
  802e45:	05 40 50 80 00       	add    $0x805040,%eax
  802e4a:	8b 08                	mov    (%eax),%ecx
  802e4c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e4f:	89 d0                	mov    %edx,%eax
  802e51:	01 c0                	add    %eax,%eax
  802e53:	01 d0                	add    %edx,%eax
  802e55:	c1 e0 02             	shl    $0x2,%eax
  802e58:	05 44 50 80 00       	add    $0x805044,%eax
  802e5d:	8b 00                	mov    (%eax),%eax
  802e5f:	01 c8                	add    %ecx,%eax
  802e61:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  802e64:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e67:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802e6a:	76 06                	jbe    802e72 <sfree+0x321>
  802e6c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e6f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802e72:	ff 45 e0             	incl   -0x20(%ebp)
  802e75:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802e7c:	7e a4                	jle    802e22 <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  802e7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e81:	a3 88 50 83 00       	mov    %eax,0x835088
			break;
  802e86:	eb 16                	jmp    802e9e <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802e88:	ff 45 f4             	incl   -0xc(%ebp)
  802e8b:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  802e92:	0f 8e 04 fd ff ff    	jle    802b9c <sfree+0x4b>
  802e98:	eb 04                	jmp    802e9e <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  802e9a:	90                   	nop
  802e9b:	eb 01                	jmp    802e9e <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  802e9d:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  802e9e:	c9                   	leave  
  802e9f:	c3                   	ret    

00802ea0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802ea0:	55                   	push   %ebp
  802ea1:	89 e5                	mov    %esp,%ebp
  802ea3:	57                   	push   %edi
  802ea4:	56                   	push   %esi
  802ea5:	53                   	push   %ebx
  802ea6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  802eac:	8b 55 0c             	mov    0xc(%ebp),%edx
  802eaf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802eb2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802eb5:	8b 7d 18             	mov    0x18(%ebp),%edi
  802eb8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802ebb:	cd 30                	int    $0x30
  802ebd:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802ec0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802ec3:	83 c4 10             	add    $0x10,%esp
  802ec6:	5b                   	pop    %ebx
  802ec7:	5e                   	pop    %esi
  802ec8:	5f                   	pop    %edi
  802ec9:	5d                   	pop    %ebp
  802eca:	c3                   	ret    

00802ecb <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802ecb:	55                   	push   %ebp
  802ecc:	89 e5                	mov    %esp,%ebp
  802ece:	83 ec 04             	sub    $0x4,%esp
  802ed1:	8b 45 10             	mov    0x10(%ebp),%eax
  802ed4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802ed7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802eda:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802ede:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee1:	6a 00                	push   $0x0
  802ee3:	51                   	push   %ecx
  802ee4:	52                   	push   %edx
  802ee5:	ff 75 0c             	pushl  0xc(%ebp)
  802ee8:	50                   	push   %eax
  802ee9:	6a 00                	push   $0x0
  802eeb:	e8 b0 ff ff ff       	call   802ea0 <syscall>
  802ef0:	83 c4 18             	add    $0x18,%esp
}
  802ef3:	90                   	nop
  802ef4:	c9                   	leave  
  802ef5:	c3                   	ret    

00802ef6 <sys_cgetc>:

int
sys_cgetc(void)
{
  802ef6:	55                   	push   %ebp
  802ef7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802ef9:	6a 00                	push   $0x0
  802efb:	6a 00                	push   $0x0
  802efd:	6a 00                	push   $0x0
  802eff:	6a 00                	push   $0x0
  802f01:	6a 00                	push   $0x0
  802f03:	6a 02                	push   $0x2
  802f05:	e8 96 ff ff ff       	call   802ea0 <syscall>
  802f0a:	83 c4 18             	add    $0x18,%esp
}
  802f0d:	c9                   	leave  
  802f0e:	c3                   	ret    

00802f0f <sys_lock_cons>:

void sys_lock_cons(void)
{
  802f0f:	55                   	push   %ebp
  802f10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802f12:	6a 00                	push   $0x0
  802f14:	6a 00                	push   $0x0
  802f16:	6a 00                	push   $0x0
  802f18:	6a 00                	push   $0x0
  802f1a:	6a 00                	push   $0x0
  802f1c:	6a 03                	push   $0x3
  802f1e:	e8 7d ff ff ff       	call   802ea0 <syscall>
  802f23:	83 c4 18             	add    $0x18,%esp
}
  802f26:	90                   	nop
  802f27:	c9                   	leave  
  802f28:	c3                   	ret    

00802f29 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802f29:	55                   	push   %ebp
  802f2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802f2c:	6a 00                	push   $0x0
  802f2e:	6a 00                	push   $0x0
  802f30:	6a 00                	push   $0x0
  802f32:	6a 00                	push   $0x0
  802f34:	6a 00                	push   $0x0
  802f36:	6a 04                	push   $0x4
  802f38:	e8 63 ff ff ff       	call   802ea0 <syscall>
  802f3d:	83 c4 18             	add    $0x18,%esp
}
  802f40:	90                   	nop
  802f41:	c9                   	leave  
  802f42:	c3                   	ret    

00802f43 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802f43:	55                   	push   %ebp
  802f44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802f46:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f49:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4c:	6a 00                	push   $0x0
  802f4e:	6a 00                	push   $0x0
  802f50:	6a 00                	push   $0x0
  802f52:	52                   	push   %edx
  802f53:	50                   	push   %eax
  802f54:	6a 08                	push   $0x8
  802f56:	e8 45 ff ff ff       	call   802ea0 <syscall>
  802f5b:	83 c4 18             	add    $0x18,%esp
}
  802f5e:	c9                   	leave  
  802f5f:	c3                   	ret    

00802f60 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802f60:	55                   	push   %ebp
  802f61:	89 e5                	mov    %esp,%ebp
  802f63:	56                   	push   %esi
  802f64:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802f65:	8b 75 18             	mov    0x18(%ebp),%esi
  802f68:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802f6b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802f6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f71:	8b 45 08             	mov    0x8(%ebp),%eax
  802f74:	56                   	push   %esi
  802f75:	53                   	push   %ebx
  802f76:	51                   	push   %ecx
  802f77:	52                   	push   %edx
  802f78:	50                   	push   %eax
  802f79:	6a 09                	push   $0x9
  802f7b:	e8 20 ff ff ff       	call   802ea0 <syscall>
  802f80:	83 c4 18             	add    $0x18,%esp
}
  802f83:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802f86:	5b                   	pop    %ebx
  802f87:	5e                   	pop    %esi
  802f88:	5d                   	pop    %ebp
  802f89:	c3                   	ret    

00802f8a <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802f8a:	55                   	push   %ebp
  802f8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802f8d:	6a 00                	push   $0x0
  802f8f:	6a 00                	push   $0x0
  802f91:	6a 00                	push   $0x0
  802f93:	6a 00                	push   $0x0
  802f95:	ff 75 08             	pushl  0x8(%ebp)
  802f98:	6a 0a                	push   $0xa
  802f9a:	e8 01 ff ff ff       	call   802ea0 <syscall>
  802f9f:	83 c4 18             	add    $0x18,%esp
}
  802fa2:	c9                   	leave  
  802fa3:	c3                   	ret    

00802fa4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802fa4:	55                   	push   %ebp
  802fa5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802fa7:	6a 00                	push   $0x0
  802fa9:	6a 00                	push   $0x0
  802fab:	6a 00                	push   $0x0
  802fad:	ff 75 0c             	pushl  0xc(%ebp)
  802fb0:	ff 75 08             	pushl  0x8(%ebp)
  802fb3:	6a 0b                	push   $0xb
  802fb5:	e8 e6 fe ff ff       	call   802ea0 <syscall>
  802fba:	83 c4 18             	add    $0x18,%esp
}
  802fbd:	c9                   	leave  
  802fbe:	c3                   	ret    

00802fbf <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802fbf:	55                   	push   %ebp
  802fc0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802fc2:	6a 00                	push   $0x0
  802fc4:	6a 00                	push   $0x0
  802fc6:	6a 00                	push   $0x0
  802fc8:	6a 00                	push   $0x0
  802fca:	6a 00                	push   $0x0
  802fcc:	6a 0c                	push   $0xc
  802fce:	e8 cd fe ff ff       	call   802ea0 <syscall>
  802fd3:	83 c4 18             	add    $0x18,%esp
}
  802fd6:	c9                   	leave  
  802fd7:	c3                   	ret    

00802fd8 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802fd8:	55                   	push   %ebp
  802fd9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802fdb:	6a 00                	push   $0x0
  802fdd:	6a 00                	push   $0x0
  802fdf:	6a 00                	push   $0x0
  802fe1:	6a 00                	push   $0x0
  802fe3:	6a 00                	push   $0x0
  802fe5:	6a 0d                	push   $0xd
  802fe7:	e8 b4 fe ff ff       	call   802ea0 <syscall>
  802fec:	83 c4 18             	add    $0x18,%esp
}
  802fef:	c9                   	leave  
  802ff0:	c3                   	ret    

00802ff1 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802ff1:	55                   	push   %ebp
  802ff2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802ff4:	6a 00                	push   $0x0
  802ff6:	6a 00                	push   $0x0
  802ff8:	6a 00                	push   $0x0
  802ffa:	6a 00                	push   $0x0
  802ffc:	6a 00                	push   $0x0
  802ffe:	6a 0e                	push   $0xe
  803000:	e8 9b fe ff ff       	call   802ea0 <syscall>
  803005:	83 c4 18             	add    $0x18,%esp
}
  803008:	c9                   	leave  
  803009:	c3                   	ret    

0080300a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80300a:	55                   	push   %ebp
  80300b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80300d:	6a 00                	push   $0x0
  80300f:	6a 00                	push   $0x0
  803011:	6a 00                	push   $0x0
  803013:	6a 00                	push   $0x0
  803015:	6a 00                	push   $0x0
  803017:	6a 0f                	push   $0xf
  803019:	e8 82 fe ff ff       	call   802ea0 <syscall>
  80301e:	83 c4 18             	add    $0x18,%esp
}
  803021:	c9                   	leave  
  803022:	c3                   	ret    

00803023 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  803023:	55                   	push   %ebp
  803024:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  803026:	6a 00                	push   $0x0
  803028:	6a 00                	push   $0x0
  80302a:	6a 00                	push   $0x0
  80302c:	6a 00                	push   $0x0
  80302e:	ff 75 08             	pushl  0x8(%ebp)
  803031:	6a 10                	push   $0x10
  803033:	e8 68 fe ff ff       	call   802ea0 <syscall>
  803038:	83 c4 18             	add    $0x18,%esp
}
  80303b:	c9                   	leave  
  80303c:	c3                   	ret    

0080303d <sys_scarce_memory>:

void sys_scarce_memory()
{
  80303d:	55                   	push   %ebp
  80303e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  803040:	6a 00                	push   $0x0
  803042:	6a 00                	push   $0x0
  803044:	6a 00                	push   $0x0
  803046:	6a 00                	push   $0x0
  803048:	6a 00                	push   $0x0
  80304a:	6a 11                	push   $0x11
  80304c:	e8 4f fe ff ff       	call   802ea0 <syscall>
  803051:	83 c4 18             	add    $0x18,%esp
}
  803054:	90                   	nop
  803055:	c9                   	leave  
  803056:	c3                   	ret    

00803057 <sys_cputc>:

void
sys_cputc(const char c)
{
  803057:	55                   	push   %ebp
  803058:	89 e5                	mov    %esp,%ebp
  80305a:	83 ec 04             	sub    $0x4,%esp
  80305d:	8b 45 08             	mov    0x8(%ebp),%eax
  803060:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  803063:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803067:	6a 00                	push   $0x0
  803069:	6a 00                	push   $0x0
  80306b:	6a 00                	push   $0x0
  80306d:	6a 00                	push   $0x0
  80306f:	50                   	push   %eax
  803070:	6a 01                	push   $0x1
  803072:	e8 29 fe ff ff       	call   802ea0 <syscall>
  803077:	83 c4 18             	add    $0x18,%esp
}
  80307a:	90                   	nop
  80307b:	c9                   	leave  
  80307c:	c3                   	ret    

0080307d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80307d:	55                   	push   %ebp
  80307e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  803080:	6a 00                	push   $0x0
  803082:	6a 00                	push   $0x0
  803084:	6a 00                	push   $0x0
  803086:	6a 00                	push   $0x0
  803088:	6a 00                	push   $0x0
  80308a:	6a 14                	push   $0x14
  80308c:	e8 0f fe ff ff       	call   802ea0 <syscall>
  803091:	83 c4 18             	add    $0x18,%esp
}
  803094:	90                   	nop
  803095:	c9                   	leave  
  803096:	c3                   	ret    

00803097 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  803097:	55                   	push   %ebp
  803098:	89 e5                	mov    %esp,%ebp
  80309a:	83 ec 04             	sub    $0x4,%esp
  80309d:	8b 45 10             	mov    0x10(%ebp),%eax
  8030a0:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8030a3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8030a6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8030aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ad:	6a 00                	push   $0x0
  8030af:	51                   	push   %ecx
  8030b0:	52                   	push   %edx
  8030b1:	ff 75 0c             	pushl  0xc(%ebp)
  8030b4:	50                   	push   %eax
  8030b5:	6a 15                	push   $0x15
  8030b7:	e8 e4 fd ff ff       	call   802ea0 <syscall>
  8030bc:	83 c4 18             	add    $0x18,%esp
}
  8030bf:	c9                   	leave  
  8030c0:	c3                   	ret    

008030c1 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8030c1:	55                   	push   %ebp
  8030c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8030c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ca:	6a 00                	push   $0x0
  8030cc:	6a 00                	push   $0x0
  8030ce:	6a 00                	push   $0x0
  8030d0:	52                   	push   %edx
  8030d1:	50                   	push   %eax
  8030d2:	6a 16                	push   $0x16
  8030d4:	e8 c7 fd ff ff       	call   802ea0 <syscall>
  8030d9:	83 c4 18             	add    $0x18,%esp
}
  8030dc:	c9                   	leave  
  8030dd:	c3                   	ret    

008030de <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8030de:	55                   	push   %ebp
  8030df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8030e1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8030e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ea:	6a 00                	push   $0x0
  8030ec:	6a 00                	push   $0x0
  8030ee:	51                   	push   %ecx
  8030ef:	52                   	push   %edx
  8030f0:	50                   	push   %eax
  8030f1:	6a 17                	push   $0x17
  8030f3:	e8 a8 fd ff ff       	call   802ea0 <syscall>
  8030f8:	83 c4 18             	add    $0x18,%esp
}
  8030fb:	c9                   	leave  
  8030fc:	c3                   	ret    

008030fd <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8030fd:	55                   	push   %ebp
  8030fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  803100:	8b 55 0c             	mov    0xc(%ebp),%edx
  803103:	8b 45 08             	mov    0x8(%ebp),%eax
  803106:	6a 00                	push   $0x0
  803108:	6a 00                	push   $0x0
  80310a:	6a 00                	push   $0x0
  80310c:	52                   	push   %edx
  80310d:	50                   	push   %eax
  80310e:	6a 18                	push   $0x18
  803110:	e8 8b fd ff ff       	call   802ea0 <syscall>
  803115:	83 c4 18             	add    $0x18,%esp
}
  803118:	c9                   	leave  
  803119:	c3                   	ret    

0080311a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80311a:	55                   	push   %ebp
  80311b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80311d:	8b 45 08             	mov    0x8(%ebp),%eax
  803120:	6a 00                	push   $0x0
  803122:	ff 75 14             	pushl  0x14(%ebp)
  803125:	ff 75 10             	pushl  0x10(%ebp)
  803128:	ff 75 0c             	pushl  0xc(%ebp)
  80312b:	50                   	push   %eax
  80312c:	6a 19                	push   $0x19
  80312e:	e8 6d fd ff ff       	call   802ea0 <syscall>
  803133:	83 c4 18             	add    $0x18,%esp
}
  803136:	c9                   	leave  
  803137:	c3                   	ret    

00803138 <sys_run_env>:

void sys_run_env(int32 envId)
{
  803138:	55                   	push   %ebp
  803139:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80313b:	8b 45 08             	mov    0x8(%ebp),%eax
  80313e:	6a 00                	push   $0x0
  803140:	6a 00                	push   $0x0
  803142:	6a 00                	push   $0x0
  803144:	6a 00                	push   $0x0
  803146:	50                   	push   %eax
  803147:	6a 1a                	push   $0x1a
  803149:	e8 52 fd ff ff       	call   802ea0 <syscall>
  80314e:	83 c4 18             	add    $0x18,%esp
}
  803151:	90                   	nop
  803152:	c9                   	leave  
  803153:	c3                   	ret    

00803154 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  803154:	55                   	push   %ebp
  803155:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  803157:	8b 45 08             	mov    0x8(%ebp),%eax
  80315a:	6a 00                	push   $0x0
  80315c:	6a 00                	push   $0x0
  80315e:	6a 00                	push   $0x0
  803160:	6a 00                	push   $0x0
  803162:	50                   	push   %eax
  803163:	6a 1b                	push   $0x1b
  803165:	e8 36 fd ff ff       	call   802ea0 <syscall>
  80316a:	83 c4 18             	add    $0x18,%esp
}
  80316d:	c9                   	leave  
  80316e:	c3                   	ret    

0080316f <sys_getenvid>:

int32 sys_getenvid(void)
{
  80316f:	55                   	push   %ebp
  803170:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  803172:	6a 00                	push   $0x0
  803174:	6a 00                	push   $0x0
  803176:	6a 00                	push   $0x0
  803178:	6a 00                	push   $0x0
  80317a:	6a 00                	push   $0x0
  80317c:	6a 05                	push   $0x5
  80317e:	e8 1d fd ff ff       	call   802ea0 <syscall>
  803183:	83 c4 18             	add    $0x18,%esp
}
  803186:	c9                   	leave  
  803187:	c3                   	ret    

00803188 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  803188:	55                   	push   %ebp
  803189:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80318b:	6a 00                	push   $0x0
  80318d:	6a 00                	push   $0x0
  80318f:	6a 00                	push   $0x0
  803191:	6a 00                	push   $0x0
  803193:	6a 00                	push   $0x0
  803195:	6a 06                	push   $0x6
  803197:	e8 04 fd ff ff       	call   802ea0 <syscall>
  80319c:	83 c4 18             	add    $0x18,%esp
}
  80319f:	c9                   	leave  
  8031a0:	c3                   	ret    

008031a1 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8031a1:	55                   	push   %ebp
  8031a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8031a4:	6a 00                	push   $0x0
  8031a6:	6a 00                	push   $0x0
  8031a8:	6a 00                	push   $0x0
  8031aa:	6a 00                	push   $0x0
  8031ac:	6a 00                	push   $0x0
  8031ae:	6a 07                	push   $0x7
  8031b0:	e8 eb fc ff ff       	call   802ea0 <syscall>
  8031b5:	83 c4 18             	add    $0x18,%esp
}
  8031b8:	c9                   	leave  
  8031b9:	c3                   	ret    

008031ba <sys_exit_env>:


void sys_exit_env(void)
{
  8031ba:	55                   	push   %ebp
  8031bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8031bd:	6a 00                	push   $0x0
  8031bf:	6a 00                	push   $0x0
  8031c1:	6a 00                	push   $0x0
  8031c3:	6a 00                	push   $0x0
  8031c5:	6a 00                	push   $0x0
  8031c7:	6a 1c                	push   $0x1c
  8031c9:	e8 d2 fc ff ff       	call   802ea0 <syscall>
  8031ce:	83 c4 18             	add    $0x18,%esp
}
  8031d1:	90                   	nop
  8031d2:	c9                   	leave  
  8031d3:	c3                   	ret    

008031d4 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8031d4:	55                   	push   %ebp
  8031d5:	89 e5                	mov    %esp,%ebp
  8031d7:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8031da:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8031dd:	8d 50 04             	lea    0x4(%eax),%edx
  8031e0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8031e3:	6a 00                	push   $0x0
  8031e5:	6a 00                	push   $0x0
  8031e7:	6a 00                	push   $0x0
  8031e9:	52                   	push   %edx
  8031ea:	50                   	push   %eax
  8031eb:	6a 1d                	push   $0x1d
  8031ed:	e8 ae fc ff ff       	call   802ea0 <syscall>
  8031f2:	83 c4 18             	add    $0x18,%esp
	return result;
  8031f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8031f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8031fb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8031fe:	89 01                	mov    %eax,(%ecx)
  803200:	89 51 04             	mov    %edx,0x4(%ecx)
}
  803203:	8b 45 08             	mov    0x8(%ebp),%eax
  803206:	c9                   	leave  
  803207:	c2 04 00             	ret    $0x4

0080320a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80320a:	55                   	push   %ebp
  80320b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80320d:	6a 00                	push   $0x0
  80320f:	6a 00                	push   $0x0
  803211:	ff 75 10             	pushl  0x10(%ebp)
  803214:	ff 75 0c             	pushl  0xc(%ebp)
  803217:	ff 75 08             	pushl  0x8(%ebp)
  80321a:	6a 13                	push   $0x13
  80321c:	e8 7f fc ff ff       	call   802ea0 <syscall>
  803221:	83 c4 18             	add    $0x18,%esp
	return ;
  803224:	90                   	nop
}
  803225:	c9                   	leave  
  803226:	c3                   	ret    

00803227 <sys_rcr2>:
uint32 sys_rcr2()
{
  803227:	55                   	push   %ebp
  803228:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80322a:	6a 00                	push   $0x0
  80322c:	6a 00                	push   $0x0
  80322e:	6a 00                	push   $0x0
  803230:	6a 00                	push   $0x0
  803232:	6a 00                	push   $0x0
  803234:	6a 1e                	push   $0x1e
  803236:	e8 65 fc ff ff       	call   802ea0 <syscall>
  80323b:	83 c4 18             	add    $0x18,%esp
}
  80323e:	c9                   	leave  
  80323f:	c3                   	ret    

00803240 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  803240:	55                   	push   %ebp
  803241:	89 e5                	mov    %esp,%ebp
  803243:	83 ec 04             	sub    $0x4,%esp
  803246:	8b 45 08             	mov    0x8(%ebp),%eax
  803249:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80324c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  803250:	6a 00                	push   $0x0
  803252:	6a 00                	push   $0x0
  803254:	6a 00                	push   $0x0
  803256:	6a 00                	push   $0x0
  803258:	50                   	push   %eax
  803259:	6a 1f                	push   $0x1f
  80325b:	e8 40 fc ff ff       	call   802ea0 <syscall>
  803260:	83 c4 18             	add    $0x18,%esp
	return ;
  803263:	90                   	nop
}
  803264:	c9                   	leave  
  803265:	c3                   	ret    

00803266 <rsttst>:
void rsttst()
{
  803266:	55                   	push   %ebp
  803267:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803269:	6a 00                	push   $0x0
  80326b:	6a 00                	push   $0x0
  80326d:	6a 00                	push   $0x0
  80326f:	6a 00                	push   $0x0
  803271:	6a 00                	push   $0x0
  803273:	6a 21                	push   $0x21
  803275:	e8 26 fc ff ff       	call   802ea0 <syscall>
  80327a:	83 c4 18             	add    $0x18,%esp
	return ;
  80327d:	90                   	nop
}
  80327e:	c9                   	leave  
  80327f:	c3                   	ret    

00803280 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  803280:	55                   	push   %ebp
  803281:	89 e5                	mov    %esp,%ebp
  803283:	83 ec 04             	sub    $0x4,%esp
  803286:	8b 45 14             	mov    0x14(%ebp),%eax
  803289:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80328c:	8b 55 18             	mov    0x18(%ebp),%edx
  80328f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803293:	52                   	push   %edx
  803294:	50                   	push   %eax
  803295:	ff 75 10             	pushl  0x10(%ebp)
  803298:	ff 75 0c             	pushl  0xc(%ebp)
  80329b:	ff 75 08             	pushl  0x8(%ebp)
  80329e:	6a 20                	push   $0x20
  8032a0:	e8 fb fb ff ff       	call   802ea0 <syscall>
  8032a5:	83 c4 18             	add    $0x18,%esp
	return ;
  8032a8:	90                   	nop
}
  8032a9:	c9                   	leave  
  8032aa:	c3                   	ret    

008032ab <chktst>:
void chktst(uint32 n)
{
  8032ab:	55                   	push   %ebp
  8032ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8032ae:	6a 00                	push   $0x0
  8032b0:	6a 00                	push   $0x0
  8032b2:	6a 00                	push   $0x0
  8032b4:	6a 00                	push   $0x0
  8032b6:	ff 75 08             	pushl  0x8(%ebp)
  8032b9:	6a 22                	push   $0x22
  8032bb:	e8 e0 fb ff ff       	call   802ea0 <syscall>
  8032c0:	83 c4 18             	add    $0x18,%esp
	return ;
  8032c3:	90                   	nop
}
  8032c4:	c9                   	leave  
  8032c5:	c3                   	ret    

008032c6 <inctst>:

void inctst()
{
  8032c6:	55                   	push   %ebp
  8032c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8032c9:	6a 00                	push   $0x0
  8032cb:	6a 00                	push   $0x0
  8032cd:	6a 00                	push   $0x0
  8032cf:	6a 00                	push   $0x0
  8032d1:	6a 00                	push   $0x0
  8032d3:	6a 23                	push   $0x23
  8032d5:	e8 c6 fb ff ff       	call   802ea0 <syscall>
  8032da:	83 c4 18             	add    $0x18,%esp
	return ;
  8032dd:	90                   	nop
}
  8032de:	c9                   	leave  
  8032df:	c3                   	ret    

008032e0 <gettst>:
uint32 gettst()
{
  8032e0:	55                   	push   %ebp
  8032e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8032e3:	6a 00                	push   $0x0
  8032e5:	6a 00                	push   $0x0
  8032e7:	6a 00                	push   $0x0
  8032e9:	6a 00                	push   $0x0
  8032eb:	6a 00                	push   $0x0
  8032ed:	6a 24                	push   $0x24
  8032ef:	e8 ac fb ff ff       	call   802ea0 <syscall>
  8032f4:	83 c4 18             	add    $0x18,%esp
}
  8032f7:	c9                   	leave  
  8032f8:	c3                   	ret    

008032f9 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8032f9:	55                   	push   %ebp
  8032fa:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8032fc:	6a 00                	push   $0x0
  8032fe:	6a 00                	push   $0x0
  803300:	6a 00                	push   $0x0
  803302:	6a 00                	push   $0x0
  803304:	6a 00                	push   $0x0
  803306:	6a 25                	push   $0x25
  803308:	e8 93 fb ff ff       	call   802ea0 <syscall>
  80330d:	83 c4 18             	add    $0x18,%esp
  803310:	a3 80 50 83 00       	mov    %eax,0x835080
	return uheapPlaceStrategy ;
  803315:	a1 80 50 83 00       	mov    0x835080,%eax
}
  80331a:	c9                   	leave  
  80331b:	c3                   	ret    

0080331c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80331c:	55                   	push   %ebp
  80331d:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80331f:	8b 45 08             	mov    0x8(%ebp),%eax
  803322:	a3 80 50 83 00       	mov    %eax,0x835080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803327:	6a 00                	push   $0x0
  803329:	6a 00                	push   $0x0
  80332b:	6a 00                	push   $0x0
  80332d:	6a 00                	push   $0x0
  80332f:	ff 75 08             	pushl  0x8(%ebp)
  803332:	6a 26                	push   $0x26
  803334:	e8 67 fb ff ff       	call   802ea0 <syscall>
  803339:	83 c4 18             	add    $0x18,%esp
	return ;
  80333c:	90                   	nop
}
  80333d:	c9                   	leave  
  80333e:	c3                   	ret    

0080333f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80333f:	55                   	push   %ebp
  803340:	89 e5                	mov    %esp,%ebp
  803342:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  803343:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803346:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803349:	8b 55 0c             	mov    0xc(%ebp),%edx
  80334c:	8b 45 08             	mov    0x8(%ebp),%eax
  80334f:	6a 00                	push   $0x0
  803351:	53                   	push   %ebx
  803352:	51                   	push   %ecx
  803353:	52                   	push   %edx
  803354:	50                   	push   %eax
  803355:	6a 27                	push   $0x27
  803357:	e8 44 fb ff ff       	call   802ea0 <syscall>
  80335c:	83 c4 18             	add    $0x18,%esp
}
  80335f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803362:	c9                   	leave  
  803363:	c3                   	ret    

00803364 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803364:	55                   	push   %ebp
  803365:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803367:	8b 55 0c             	mov    0xc(%ebp),%edx
  80336a:	8b 45 08             	mov    0x8(%ebp),%eax
  80336d:	6a 00                	push   $0x0
  80336f:	6a 00                	push   $0x0
  803371:	6a 00                	push   $0x0
  803373:	52                   	push   %edx
  803374:	50                   	push   %eax
  803375:	6a 28                	push   $0x28
  803377:	e8 24 fb ff ff       	call   802ea0 <syscall>
  80337c:	83 c4 18             	add    $0x18,%esp
}
  80337f:	c9                   	leave  
  803380:	c3                   	ret    

00803381 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  803381:	55                   	push   %ebp
  803382:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  803384:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803387:	8b 55 0c             	mov    0xc(%ebp),%edx
  80338a:	8b 45 08             	mov    0x8(%ebp),%eax
  80338d:	6a 00                	push   $0x0
  80338f:	51                   	push   %ecx
  803390:	ff 75 10             	pushl  0x10(%ebp)
  803393:	52                   	push   %edx
  803394:	50                   	push   %eax
  803395:	6a 29                	push   $0x29
  803397:	e8 04 fb ff ff       	call   802ea0 <syscall>
  80339c:	83 c4 18             	add    $0x18,%esp
}
  80339f:	c9                   	leave  
  8033a0:	c3                   	ret    

008033a1 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8033a1:	55                   	push   %ebp
  8033a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8033a4:	6a 00                	push   $0x0
  8033a6:	6a 00                	push   $0x0
  8033a8:	ff 75 10             	pushl  0x10(%ebp)
  8033ab:	ff 75 0c             	pushl  0xc(%ebp)
  8033ae:	ff 75 08             	pushl  0x8(%ebp)
  8033b1:	6a 12                	push   $0x12
  8033b3:	e8 e8 fa ff ff       	call   802ea0 <syscall>
  8033b8:	83 c4 18             	add    $0x18,%esp
	return ;
  8033bb:	90                   	nop
}
  8033bc:	c9                   	leave  
  8033bd:	c3                   	ret    

008033be <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8033be:	55                   	push   %ebp
  8033bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8033c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c7:	6a 00                	push   $0x0
  8033c9:	6a 00                	push   $0x0
  8033cb:	6a 00                	push   $0x0
  8033cd:	52                   	push   %edx
  8033ce:	50                   	push   %eax
  8033cf:	6a 2a                	push   $0x2a
  8033d1:	e8 ca fa ff ff       	call   802ea0 <syscall>
  8033d6:	83 c4 18             	add    $0x18,%esp
	return;
  8033d9:	90                   	nop
}
  8033da:	c9                   	leave  
  8033db:	c3                   	ret    

008033dc <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8033dc:	55                   	push   %ebp
  8033dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8033df:	6a 00                	push   $0x0
  8033e1:	6a 00                	push   $0x0
  8033e3:	6a 00                	push   $0x0
  8033e5:	6a 00                	push   $0x0
  8033e7:	6a 00                	push   $0x0
  8033e9:	6a 2b                	push   $0x2b
  8033eb:	e8 b0 fa ff ff       	call   802ea0 <syscall>
  8033f0:	83 c4 18             	add    $0x18,%esp
}
  8033f3:	c9                   	leave  
  8033f4:	c3                   	ret    

008033f5 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8033f5:	55                   	push   %ebp
  8033f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8033f8:	6a 00                	push   $0x0
  8033fa:	6a 00                	push   $0x0
  8033fc:	6a 00                	push   $0x0
  8033fe:	ff 75 0c             	pushl  0xc(%ebp)
  803401:	ff 75 08             	pushl  0x8(%ebp)
  803404:	6a 2d                	push   $0x2d
  803406:	e8 95 fa ff ff       	call   802ea0 <syscall>
  80340b:	83 c4 18             	add    $0x18,%esp
	return;
  80340e:	90                   	nop
}
  80340f:	c9                   	leave  
  803410:	c3                   	ret    

00803411 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  803411:	55                   	push   %ebp
  803412:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  803414:	6a 00                	push   $0x0
  803416:	6a 00                	push   $0x0
  803418:	6a 00                	push   $0x0
  80341a:	ff 75 0c             	pushl  0xc(%ebp)
  80341d:	ff 75 08             	pushl  0x8(%ebp)
  803420:	6a 2c                	push   $0x2c
  803422:	e8 79 fa ff ff       	call   802ea0 <syscall>
  803427:	83 c4 18             	add    $0x18,%esp
	return ;
  80342a:	90                   	nop
}
  80342b:	c9                   	leave  
  80342c:	c3                   	ret    

0080342d <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  80342d:	55                   	push   %ebp
  80342e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  803430:	8b 55 0c             	mov    0xc(%ebp),%edx
  803433:	8b 45 08             	mov    0x8(%ebp),%eax
  803436:	6a 00                	push   $0x0
  803438:	6a 00                	push   $0x0
  80343a:	6a 00                	push   $0x0
  80343c:	52                   	push   %edx
  80343d:	50                   	push   %eax
  80343e:	6a 2e                	push   $0x2e
  803440:	e8 5b fa ff ff       	call   802ea0 <syscall>
  803445:	83 c4 18             	add    $0x18,%esp
}
  803448:	90                   	nop
  803449:	c9                   	leave  
  80344a:	c3                   	ret    

0080344b <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  80344b:	55                   	push   %ebp
  80344c:	89 e5                	mov    %esp,%ebp
  80344e:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  803451:	81 7d 08 80 d0 81 00 	cmpl   $0x81d080,0x8(%ebp)
  803458:	72 09                	jb     803463 <to_page_va+0x18>
  80345a:	81 7d 08 80 50 83 00 	cmpl   $0x835080,0x8(%ebp)
  803461:	72 14                	jb     803477 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  803463:	83 ec 04             	sub    $0x4,%esp
  803466:	68 d8 4b 80 00       	push   $0x804bd8
  80346b:	6a 15                	push   $0x15
  80346d:	68 03 4c 80 00       	push   $0x804c03
  803472:	e8 10 d0 ff ff       	call   800487 <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803477:	8b 45 08             	mov    0x8(%ebp),%eax
  80347a:	ba 80 d0 81 00       	mov    $0x81d080,%edx
  80347f:	29 d0                	sub    %edx,%eax
  803481:	c1 f8 02             	sar    $0x2,%eax
  803484:	89 c2                	mov    %eax,%edx
  803486:	89 d0                	mov    %edx,%eax
  803488:	c1 e0 02             	shl    $0x2,%eax
  80348b:	01 d0                	add    %edx,%eax
  80348d:	c1 e0 02             	shl    $0x2,%eax
  803490:	01 d0                	add    %edx,%eax
  803492:	c1 e0 02             	shl    $0x2,%eax
  803495:	01 d0                	add    %edx,%eax
  803497:	89 c1                	mov    %eax,%ecx
  803499:	c1 e1 08             	shl    $0x8,%ecx
  80349c:	01 c8                	add    %ecx,%eax
  80349e:	89 c1                	mov    %eax,%ecx
  8034a0:	c1 e1 10             	shl    $0x10,%ecx
  8034a3:	01 c8                	add    %ecx,%eax
  8034a5:	01 c0                	add    %eax,%eax
  8034a7:	01 d0                	add    %edx,%eax
  8034a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8034ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034af:	c1 e0 0c             	shl    $0xc,%eax
  8034b2:	89 c2                	mov    %eax,%edx
  8034b4:	a1 84 50 83 00       	mov    0x835084,%eax
  8034b9:	01 d0                	add    %edx,%eax
}
  8034bb:	c9                   	leave  
  8034bc:	c3                   	ret    

008034bd <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  8034bd:	55                   	push   %ebp
  8034be:	89 e5                	mov    %esp,%ebp
  8034c0:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  8034c3:	a1 84 50 83 00       	mov    0x835084,%eax
  8034c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8034cb:	29 c2                	sub    %eax,%edx
  8034cd:	89 d0                	mov    %edx,%eax
  8034cf:	c1 e8 0c             	shr    $0xc,%eax
  8034d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  8034d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034d9:	78 09                	js     8034e4 <to_page_info+0x27>
  8034db:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  8034e2:	7e 14                	jle    8034f8 <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  8034e4:	83 ec 04             	sub    $0x4,%esp
  8034e7:	68 1c 4c 80 00       	push   $0x804c1c
  8034ec:	6a 21                	push   $0x21
  8034ee:	68 03 4c 80 00       	push   $0x804c03
  8034f3:	e8 8f cf ff ff       	call   800487 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  8034f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034fb:	89 d0                	mov    %edx,%eax
  8034fd:	01 c0                	add    %eax,%eax
  8034ff:	01 d0                	add    %edx,%eax
  803501:	c1 e0 02             	shl    $0x2,%eax
  803504:	05 80 d0 81 00       	add    $0x81d080,%eax
}
  803509:	c9                   	leave  
  80350a:	c3                   	ret    

0080350b <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  80350b:	55                   	push   %ebp
  80350c:	89 e5                	mov    %esp,%ebp
  80350e:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  803511:	8b 45 08             	mov    0x8(%ebp),%eax
  803514:	05 00 00 00 02       	add    $0x2000000,%eax
  803519:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80351c:	73 16                	jae    803534 <initialize_dynamic_allocator+0x29>
  80351e:	68 40 4c 80 00       	push   $0x804c40
  803523:	68 66 4c 80 00       	push   $0x804c66
  803528:	6a 2f                	push   $0x2f
  80352a:	68 03 4c 80 00       	push   $0x804c03
  80352f:	e8 53 cf ff ff       	call   800487 <_panic>
	dynAllocStart = daStart;
  803534:	8b 45 08             	mov    0x8(%ebp),%eax
  803537:	a3 84 50 83 00       	mov    %eax,0x835084
	dynAllocEnd = daEnd;
  80353c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80353f:	a3 60 d0 81 00       	mov    %eax,0x81d060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803544:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80354b:	eb 36                	jmp    803583 <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  80354d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803550:	c1 e0 04             	shl    $0x4,%eax
  803553:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803558:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80355e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803561:	c1 e0 04             	shl    $0x4,%eax
  803564:	05 a4 50 83 00       	add    $0x8350a4,%eax
  803569:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80356f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803572:	c1 e0 04             	shl    $0x4,%eax
  803575:	05 ac 50 83 00       	add    $0x8350ac,%eax
  80357a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803580:	ff 45 f4             	incl   -0xc(%ebp)
  803583:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  803587:	7e c4                	jle    80354d <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  803589:	c7 05 68 d0 81 00 00 	movl   $0x0,0x81d068
  803590:	00 00 00 
  803593:	c7 05 6c d0 81 00 00 	movl   $0x0,0x81d06c
  80359a:	00 00 00 
  80359d:	c7 05 74 d0 81 00 00 	movl   $0x0,0x81d074
  8035a4:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  8035a7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8035ae:	e9 1b 01 00 00       	jmp    8036ce <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  8035b3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035b6:	89 d0                	mov    %edx,%eax
  8035b8:	01 c0                	add    %eax,%eax
  8035ba:	01 d0                	add    %edx,%eax
  8035bc:	c1 e0 02             	shl    $0x2,%eax
  8035bf:	05 88 d0 81 00       	add    $0x81d088,%eax
  8035c4:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  8035c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035cc:	89 d0                	mov    %edx,%eax
  8035ce:	01 c0                	add    %eax,%eax
  8035d0:	01 d0                	add    %edx,%eax
  8035d2:	c1 e0 02             	shl    $0x2,%eax
  8035d5:	05 8a d0 81 00       	add    $0x81d08a,%eax
  8035da:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  8035df:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035e2:	89 d0                	mov    %edx,%eax
  8035e4:	01 c0                	add    %eax,%eax
  8035e6:	01 d0                	add    %edx,%eax
  8035e8:	c1 e0 02             	shl    $0x2,%eax
  8035eb:	05 80 d0 81 00       	add    $0x81d080,%eax
  8035f0:	8b 00                	mov    (%eax),%eax
  8035f2:	85 c0                	test   %eax,%eax
  8035f4:	74 2b                	je     803621 <initialize_dynamic_allocator+0x116>
  8035f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035f9:	89 d0                	mov    %edx,%eax
  8035fb:	01 c0                	add    %eax,%eax
  8035fd:	01 d0                	add    %edx,%eax
  8035ff:	c1 e0 02             	shl    $0x2,%eax
  803602:	05 80 d0 81 00       	add    $0x81d080,%eax
  803607:	8b 10                	mov    (%eax),%edx
  803609:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80360c:	89 c8                	mov    %ecx,%eax
  80360e:	01 c0                	add    %eax,%eax
  803610:	01 c8                	add    %ecx,%eax
  803612:	c1 e0 02             	shl    $0x2,%eax
  803615:	05 84 d0 81 00       	add    $0x81d084,%eax
  80361a:	8b 00                	mov    (%eax),%eax
  80361c:	89 42 04             	mov    %eax,0x4(%edx)
  80361f:	eb 18                	jmp    803639 <initialize_dynamic_allocator+0x12e>
  803621:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803624:	89 d0                	mov    %edx,%eax
  803626:	01 c0                	add    %eax,%eax
  803628:	01 d0                	add    %edx,%eax
  80362a:	c1 e0 02             	shl    $0x2,%eax
  80362d:	05 84 d0 81 00       	add    $0x81d084,%eax
  803632:	8b 00                	mov    (%eax),%eax
  803634:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803639:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80363c:	89 d0                	mov    %edx,%eax
  80363e:	01 c0                	add    %eax,%eax
  803640:	01 d0                	add    %edx,%eax
  803642:	c1 e0 02             	shl    $0x2,%eax
  803645:	05 84 d0 81 00       	add    $0x81d084,%eax
  80364a:	8b 00                	mov    (%eax),%eax
  80364c:	85 c0                	test   %eax,%eax
  80364e:	74 2a                	je     80367a <initialize_dynamic_allocator+0x16f>
  803650:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803653:	89 d0                	mov    %edx,%eax
  803655:	01 c0                	add    %eax,%eax
  803657:	01 d0                	add    %edx,%eax
  803659:	c1 e0 02             	shl    $0x2,%eax
  80365c:	05 84 d0 81 00       	add    $0x81d084,%eax
  803661:	8b 10                	mov    (%eax),%edx
  803663:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803666:	89 c8                	mov    %ecx,%eax
  803668:	01 c0                	add    %eax,%eax
  80366a:	01 c8                	add    %ecx,%eax
  80366c:	c1 e0 02             	shl    $0x2,%eax
  80366f:	05 80 d0 81 00       	add    $0x81d080,%eax
  803674:	8b 00                	mov    (%eax),%eax
  803676:	89 02                	mov    %eax,(%edx)
  803678:	eb 18                	jmp    803692 <initialize_dynamic_allocator+0x187>
  80367a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80367d:	89 d0                	mov    %edx,%eax
  80367f:	01 c0                	add    %eax,%eax
  803681:	01 d0                	add    %edx,%eax
  803683:	c1 e0 02             	shl    $0x2,%eax
  803686:	05 80 d0 81 00       	add    $0x81d080,%eax
  80368b:	8b 00                	mov    (%eax),%eax
  80368d:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803692:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803695:	89 d0                	mov    %edx,%eax
  803697:	01 c0                	add    %eax,%eax
  803699:	01 d0                	add    %edx,%eax
  80369b:	c1 e0 02             	shl    $0x2,%eax
  80369e:	05 80 d0 81 00       	add    $0x81d080,%eax
  8036a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036ac:	89 d0                	mov    %edx,%eax
  8036ae:	01 c0                	add    %eax,%eax
  8036b0:	01 d0                	add    %edx,%eax
  8036b2:	c1 e0 02             	shl    $0x2,%eax
  8036b5:	05 84 d0 81 00       	add    $0x81d084,%eax
  8036ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036c0:	a1 74 d0 81 00       	mov    0x81d074,%eax
  8036c5:	48                   	dec    %eax
  8036c6:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  8036cb:	ff 45 f0             	incl   -0x10(%ebp)
  8036ce:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  8036d5:	0f 8e d8 fe ff ff    	jle    8035b3 <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  8036db:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  8036e2:	e9 9d 00 00 00       	jmp    803784 <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  8036e7:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8036ed:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  8036f0:	89 c8                	mov    %ecx,%eax
  8036f2:	01 c0                	add    %eax,%eax
  8036f4:	01 c8                	add    %ecx,%eax
  8036f6:	c1 e0 02             	shl    $0x2,%eax
  8036f9:	05 80 d0 81 00       	add    $0x81d080,%eax
  8036fe:	89 10                	mov    %edx,(%eax)
  803700:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803703:	89 d0                	mov    %edx,%eax
  803705:	01 c0                	add    %eax,%eax
  803707:	01 d0                	add    %edx,%eax
  803709:	c1 e0 02             	shl    $0x2,%eax
  80370c:	05 80 d0 81 00       	add    $0x81d080,%eax
  803711:	8b 00                	mov    (%eax),%eax
  803713:	85 c0                	test   %eax,%eax
  803715:	74 1c                	je     803733 <initialize_dynamic_allocator+0x228>
  803717:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80371d:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803720:	89 c8                	mov    %ecx,%eax
  803722:	01 c0                	add    %eax,%eax
  803724:	01 c8                	add    %ecx,%eax
  803726:	c1 e0 02             	shl    $0x2,%eax
  803729:	05 80 d0 81 00       	add    $0x81d080,%eax
  80372e:	89 42 04             	mov    %eax,0x4(%edx)
  803731:	eb 16                	jmp    803749 <initialize_dynamic_allocator+0x23e>
  803733:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803736:	89 d0                	mov    %edx,%eax
  803738:	01 c0                	add    %eax,%eax
  80373a:	01 d0                	add    %edx,%eax
  80373c:	c1 e0 02             	shl    $0x2,%eax
  80373f:	05 80 d0 81 00       	add    $0x81d080,%eax
  803744:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803749:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80374c:	89 d0                	mov    %edx,%eax
  80374e:	01 c0                	add    %eax,%eax
  803750:	01 d0                	add    %edx,%eax
  803752:	c1 e0 02             	shl    $0x2,%eax
  803755:	05 80 d0 81 00       	add    $0x81d080,%eax
  80375a:	a3 68 d0 81 00       	mov    %eax,0x81d068
  80375f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803762:	89 d0                	mov    %edx,%eax
  803764:	01 c0                	add    %eax,%eax
  803766:	01 d0                	add    %edx,%eax
  803768:	c1 e0 02             	shl    $0x2,%eax
  80376b:	05 84 d0 81 00       	add    $0x81d084,%eax
  803770:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803776:	a1 74 d0 81 00       	mov    0x81d074,%eax
  80377b:	40                   	inc    %eax
  80377c:	a3 74 d0 81 00       	mov    %eax,0x81d074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803781:	ff 4d ec             	decl   -0x14(%ebp)
  803784:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803788:	0f 89 59 ff ff ff    	jns    8036e7 <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  80378e:	c7 05 44 d0 81 00 01 	movl   $0x1,0x81d044
  803795:	00 00 00 
}
  803798:	90                   	nop
  803799:	c9                   	leave  
  80379a:	c3                   	ret    

0080379b <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  80379b:	55                   	push   %ebp
  80379c:	89 e5                	mov    %esp,%ebp
  80379e:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  8037a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a4:	83 ec 0c             	sub    $0xc,%esp
  8037a7:	50                   	push   %eax
  8037a8:	e8 10 fd ff ff       	call   8034bd <to_page_info>
  8037ad:	83 c4 10             	add    $0x10,%esp
  8037b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  8037b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b6:	8b 40 08             	mov    0x8(%eax),%eax
  8037b9:	0f b7 c0             	movzwl %ax,%eax
}
  8037bc:	c9                   	leave  
  8037bd:	c3                   	ret    

008037be <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8037be:	55                   	push   %ebp
  8037bf:	89 e5                	mov    %esp,%ebp
  8037c1:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8037c4:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8037cb:	76 16                	jbe    8037e3 <alloc_block+0x25>
  8037cd:	68 7c 4c 80 00       	push   $0x804c7c
  8037d2:	68 66 4c 80 00       	push   $0x804c66
  8037d7:	6a 59                	push   $0x59
  8037d9:	68 03 4c 80 00       	push   $0x804c03
  8037de:	e8 a4 cc ff ff       	call   800487 <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  8037e3:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  8037ea:	eb 08                	jmp    8037f4 <alloc_block+0x36>
		allocSize <<= 1;
  8037ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ef:	01 c0                	add    %eax,%eax
  8037f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  8037f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037fa:	73 09                	jae    803805 <alloc_block+0x47>
  8037fc:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  803803:	76 e7                	jbe    8037ec <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  803805:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  80380c:	eb 03                	jmp    803811 <alloc_block+0x53>
		listIndex++;
  80380e:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803811:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803814:	ba 08 00 00 00       	mov    $0x8,%edx
  803819:	88 c1                	mov    %al,%cl
  80381b:	d3 e2                	shl    %cl,%edx
  80381d:	89 d0                	mov    %edx,%eax
  80381f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803822:	72 ea                	jb     80380e <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803824:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803827:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80382a:	e9 f4 00 00 00       	jmp    803923 <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  80382f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803832:	c1 e0 04             	shl    $0x4,%eax
  803835:	05 a0 50 83 00       	add    $0x8350a0,%eax
  80383a:	8b 00                	mov    (%eax),%eax
  80383c:	85 c0                	test   %eax,%eax
  80383e:	0f 84 dc 00 00 00    	je     803920 <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  803844:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803847:	c1 e0 04             	shl    $0x4,%eax
  80384a:	05 a0 50 83 00       	add    $0x8350a0,%eax
  80384f:	8b 00                	mov    (%eax),%eax
  803851:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  803854:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803858:	75 14                	jne    80386e <alloc_block+0xb0>
  80385a:	83 ec 04             	sub    $0x4,%esp
  80385d:	68 9d 4c 80 00       	push   $0x804c9d
  803862:	6a 6b                	push   $0x6b
  803864:	68 03 4c 80 00       	push   $0x804c03
  803869:	e8 19 cc ff ff       	call   800487 <_panic>
  80386e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803871:	8b 00                	mov    (%eax),%eax
  803873:	85 c0                	test   %eax,%eax
  803875:	74 10                	je     803887 <alloc_block+0xc9>
  803877:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80387a:	8b 00                	mov    (%eax),%eax
  80387c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80387f:	8b 52 04             	mov    0x4(%edx),%edx
  803882:	89 50 04             	mov    %edx,0x4(%eax)
  803885:	eb 14                	jmp    80389b <alloc_block+0xdd>
  803887:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80388a:	8b 40 04             	mov    0x4(%eax),%eax
  80388d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803890:	c1 e2 04             	shl    $0x4,%edx
  803893:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803899:	89 02                	mov    %eax,(%edx)
  80389b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80389e:	8b 40 04             	mov    0x4(%eax),%eax
  8038a1:	85 c0                	test   %eax,%eax
  8038a3:	74 0f                	je     8038b4 <alloc_block+0xf6>
  8038a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038a8:	8b 40 04             	mov    0x4(%eax),%eax
  8038ab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038ae:	8b 12                	mov    (%edx),%edx
  8038b0:	89 10                	mov    %edx,(%eax)
  8038b2:	eb 13                	jmp    8038c7 <alloc_block+0x109>
  8038b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038b7:	8b 00                	mov    (%eax),%eax
  8038b9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038bc:	c1 e2 04             	shl    $0x4,%edx
  8038bf:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  8038c5:	89 02                	mov    %eax,(%edx)
  8038c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038dd:	c1 e0 04             	shl    $0x4,%eax
  8038e0:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8038e5:	8b 00                	mov    (%eax),%eax
  8038e7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8038ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038ed:	c1 e0 04             	shl    $0x4,%eax
  8038f0:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8038f5:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  8038f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038fa:	83 ec 0c             	sub    $0xc,%esp
  8038fd:	50                   	push   %eax
  8038fe:	e8 ba fb ff ff       	call   8034bd <to_page_info>
  803903:	83 c4 10             	add    $0x10,%esp
  803906:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  803909:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80390c:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803910:	48                   	dec    %eax
  803911:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803914:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  803918:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80391b:	e9 8f 02 00 00       	jmp    803baf <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803920:	ff 45 ec             	incl   -0x14(%ebp)
  803923:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803927:	0f 8e 02 ff ff ff    	jle    80382f <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  80392d:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803932:	85 c0                	test   %eax,%eax
  803934:	75 14                	jne    80394a <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  803936:	83 ec 04             	sub    $0x4,%esp
  803939:	68 bc 4c 80 00       	push   $0x804cbc
  80393e:	6a 77                	push   $0x77
  803940:	68 03 4c 80 00       	push   $0x804c03
  803945:	e8 3d cb ff ff       	call   800487 <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  80394a:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80394f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  803952:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803956:	75 14                	jne    80396c <alloc_block+0x1ae>
  803958:	83 ec 04             	sub    $0x4,%esp
  80395b:	68 9d 4c 80 00       	push   $0x804c9d
  803960:	6a 7a                	push   $0x7a
  803962:	68 03 4c 80 00       	push   $0x804c03
  803967:	e8 1b cb ff ff       	call   800487 <_panic>
  80396c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80396f:	8b 00                	mov    (%eax),%eax
  803971:	85 c0                	test   %eax,%eax
  803973:	74 10                	je     803985 <alloc_block+0x1c7>
  803975:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803978:	8b 00                	mov    (%eax),%eax
  80397a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80397d:	8b 52 04             	mov    0x4(%edx),%edx
  803980:	89 50 04             	mov    %edx,0x4(%eax)
  803983:	eb 0b                	jmp    803990 <alloc_block+0x1d2>
  803985:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803988:	8b 40 04             	mov    0x4(%eax),%eax
  80398b:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803990:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803993:	8b 40 04             	mov    0x4(%eax),%eax
  803996:	85 c0                	test   %eax,%eax
  803998:	74 0f                	je     8039a9 <alloc_block+0x1eb>
  80399a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80399d:	8b 40 04             	mov    0x4(%eax),%eax
  8039a0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8039a3:	8b 12                	mov    (%edx),%edx
  8039a5:	89 10                	mov    %edx,(%eax)
  8039a7:	eb 0a                	jmp    8039b3 <alloc_block+0x1f5>
  8039a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039ac:	8b 00                	mov    (%eax),%eax
  8039ae:	a3 68 d0 81 00       	mov    %eax,0x81d068
  8039b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039bf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039c6:	a1 74 d0 81 00       	mov    0x81d074,%eax
  8039cb:	48                   	dec    %eax
  8039cc:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  8039d1:	83 ec 0c             	sub    $0xc,%esp
  8039d4:	ff 75 dc             	pushl  -0x24(%ebp)
  8039d7:	e8 6f fa ff ff       	call   80344b <to_page_va>
  8039dc:	83 c4 10             	add    $0x10,%esp
  8039df:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  8039e2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8039e5:	83 ec 0c             	sub    $0xc,%esp
  8039e8:	50                   	push   %eax
  8039e9:	e8 a0 dc ff ff       	call   80168e <get_page>
  8039ee:	83 c4 10             	add    $0x10,%esp
  8039f1:	85 c0                	test   %eax,%eax
  8039f3:	74 14                	je     803a09 <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  8039f5:	83 ec 04             	sub    $0x4,%esp
  8039f8:	68 e4 4c 80 00       	push   $0x804ce4
  8039fd:	6a 7f                	push   $0x7f
  8039ff:	68 03 4c 80 00       	push   $0x804c03
  803a04:	e8 7e ca ff ff       	call   800487 <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  803a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803a0f:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  803a13:	b8 00 10 00 00       	mov    $0x1000,%eax
  803a18:	ba 00 00 00 00       	mov    $0x0,%edx
  803a1d:	f7 75 f4             	divl   -0xc(%ebp)
  803a20:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803a23:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803a27:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803a2e:	e9 a7 00 00 00       	jmp    803ada <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  803a33:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803a36:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a39:	01 d0                	add    %edx,%eax
  803a3b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  803a3e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803a42:	75 17                	jne    803a5b <alloc_block+0x29d>
  803a44:	83 ec 04             	sub    $0x4,%esp
  803a47:	68 0c 4d 80 00       	push   $0x804d0c
  803a4c:	68 88 00 00 00       	push   $0x88
  803a51:	68 03 4c 80 00       	push   $0x804c03
  803a56:	e8 2c ca ff ff       	call   800487 <_panic>
  803a5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a5e:	c1 e0 04             	shl    $0x4,%eax
  803a61:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803a66:	8b 10                	mov    (%eax),%edx
  803a68:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a6b:	89 10                	mov    %edx,(%eax)
  803a6d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a70:	8b 00                	mov    (%eax),%eax
  803a72:	85 c0                	test   %eax,%eax
  803a74:	74 15                	je     803a8b <alloc_block+0x2cd>
  803a76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a79:	c1 e0 04             	shl    $0x4,%eax
  803a7c:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803a81:	8b 00                	mov    (%eax),%eax
  803a83:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a86:	89 50 04             	mov    %edx,0x4(%eax)
  803a89:	eb 11                	jmp    803a9c <alloc_block+0x2de>
  803a8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a8e:	c1 e0 04             	shl    $0x4,%eax
  803a91:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803a97:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a9a:	89 02                	mov    %eax,(%edx)
  803a9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a9f:	c1 e0 04             	shl    $0x4,%eax
  803aa2:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803aa8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803aab:	89 02                	mov    %eax,(%edx)
  803aad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ab0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ab7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803aba:	c1 e0 04             	shl    $0x4,%eax
  803abd:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803ac2:	8b 00                	mov    (%eax),%eax
  803ac4:	8d 50 01             	lea    0x1(%eax),%edx
  803ac7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803aca:	c1 e0 04             	shl    $0x4,%eax
  803acd:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803ad2:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ad7:	01 45 e8             	add    %eax,-0x18(%ebp)
  803ada:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  803ae1:	0f 86 4c ff ff ff    	jbe    803a33 <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  803ae7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803aea:	c1 e0 04             	shl    $0x4,%eax
  803aed:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803af2:	8b 00                	mov    (%eax),%eax
  803af4:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  803af7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803afb:	75 17                	jne    803b14 <alloc_block+0x356>
  803afd:	83 ec 04             	sub    $0x4,%esp
  803b00:	68 9d 4c 80 00       	push   $0x804c9d
  803b05:	68 8d 00 00 00       	push   $0x8d
  803b0a:	68 03 4c 80 00       	push   $0x804c03
  803b0f:	e8 73 c9 ff ff       	call   800487 <_panic>
  803b14:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b17:	8b 00                	mov    (%eax),%eax
  803b19:	85 c0                	test   %eax,%eax
  803b1b:	74 10                	je     803b2d <alloc_block+0x36f>
  803b1d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b20:	8b 00                	mov    (%eax),%eax
  803b22:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803b25:	8b 52 04             	mov    0x4(%edx),%edx
  803b28:	89 50 04             	mov    %edx,0x4(%eax)
  803b2b:	eb 14                	jmp    803b41 <alloc_block+0x383>
  803b2d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b30:	8b 40 04             	mov    0x4(%eax),%eax
  803b33:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b36:	c1 e2 04             	shl    $0x4,%edx
  803b39:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803b3f:	89 02                	mov    %eax,(%edx)
  803b41:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b44:	8b 40 04             	mov    0x4(%eax),%eax
  803b47:	85 c0                	test   %eax,%eax
  803b49:	74 0f                	je     803b5a <alloc_block+0x39c>
  803b4b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b4e:	8b 40 04             	mov    0x4(%eax),%eax
  803b51:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803b54:	8b 12                	mov    (%edx),%edx
  803b56:	89 10                	mov    %edx,(%eax)
  803b58:	eb 13                	jmp    803b6d <alloc_block+0x3af>
  803b5a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b5d:	8b 00                	mov    (%eax),%eax
  803b5f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b62:	c1 e2 04             	shl    $0x4,%edx
  803b65:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803b6b:	89 02                	mov    %eax,(%edx)
  803b6d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b70:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b76:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b79:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b83:	c1 e0 04             	shl    $0x4,%eax
  803b86:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803b8b:	8b 00                	mov    (%eax),%eax
  803b8d:	8d 50 ff             	lea    -0x1(%eax),%edx
  803b90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b93:	c1 e0 04             	shl    $0x4,%eax
  803b96:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803b9b:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  803b9d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ba0:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803ba4:	48                   	dec    %eax
  803ba5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803ba8:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  803bac:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  803baf:	c9                   	leave  
  803bb0:	c3                   	ret    

00803bb1 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803bb1:	55                   	push   %ebp
  803bb2:	89 e5                	mov    %esp,%ebp
  803bb4:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803bb7:	8b 55 08             	mov    0x8(%ebp),%edx
  803bba:	a1 84 50 83 00       	mov    0x835084,%eax
  803bbf:	39 c2                	cmp    %eax,%edx
  803bc1:	72 0c                	jb     803bcf <free_block+0x1e>
  803bc3:	8b 55 08             	mov    0x8(%ebp),%edx
  803bc6:	a1 60 d0 81 00       	mov    0x81d060,%eax
  803bcb:	39 c2                	cmp    %eax,%edx
  803bcd:	72 19                	jb     803be8 <free_block+0x37>
  803bcf:	68 30 4d 80 00       	push   $0x804d30
  803bd4:	68 66 4c 80 00       	push   $0x804c66
  803bd9:	68 98 00 00 00       	push   $0x98
  803bde:	68 03 4c 80 00       	push   $0x804c03
  803be3:	e8 9f c8 ff ff       	call   800487 <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803be8:	8b 45 08             	mov    0x8(%ebp),%eax
  803beb:	83 ec 0c             	sub    $0xc,%esp
  803bee:	50                   	push   %eax
  803bef:	e8 c9 f8 ff ff       	call   8034bd <to_page_info>
  803bf4:	83 c4 10             	add    $0x10,%esp
  803bf7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  803bfa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bfd:	8b 40 08             	mov    0x8(%eax),%eax
  803c00:	0f b7 c0             	movzwl %ax,%eax
  803c03:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  803c06:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803c0d:	eb 03                	jmp    803c12 <free_block+0x61>
		listIndex++;
  803c0f:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803c12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c15:	ba 08 00 00 00       	mov    $0x8,%edx
  803c1a:	88 c1                	mov    %al,%cl
  803c1c:	d3 e2                	shl    %cl,%edx
  803c1e:	89 d0                	mov    %edx,%eax
  803c20:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803c23:	72 ea                	jb     803c0f <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  803c25:	8b 45 08             	mov    0x8(%ebp),%eax
  803c28:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  803c2b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c2f:	75 17                	jne    803c48 <free_block+0x97>
  803c31:	83 ec 04             	sub    $0x4,%esp
  803c34:	68 0c 4d 80 00       	push   $0x804d0c
  803c39:	68 a2 00 00 00       	push   $0xa2
  803c3e:	68 03 4c 80 00       	push   $0x804c03
  803c43:	e8 3f c8 ff ff       	call   800487 <_panic>
  803c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c4b:	c1 e0 04             	shl    $0x4,%eax
  803c4e:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803c53:	8b 10                	mov    (%eax),%edx
  803c55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c58:	89 10                	mov    %edx,(%eax)
  803c5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c5d:	8b 00                	mov    (%eax),%eax
  803c5f:	85 c0                	test   %eax,%eax
  803c61:	74 15                	je     803c78 <free_block+0xc7>
  803c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c66:	c1 e0 04             	shl    $0x4,%eax
  803c69:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803c6e:	8b 00                	mov    (%eax),%eax
  803c70:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c73:	89 50 04             	mov    %edx,0x4(%eax)
  803c76:	eb 11                	jmp    803c89 <free_block+0xd8>
  803c78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c7b:	c1 e0 04             	shl    $0x4,%eax
  803c7e:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803c84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c87:	89 02                	mov    %eax,(%edx)
  803c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c8c:	c1 e0 04             	shl    $0x4,%eax
  803c8f:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803c95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c98:	89 02                	mov    %eax,(%edx)
  803c9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c9d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ca7:	c1 e0 04             	shl    $0x4,%eax
  803caa:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803caf:	8b 00                	mov    (%eax),%eax
  803cb1:	8d 50 01             	lea    0x1(%eax),%edx
  803cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cb7:	c1 e0 04             	shl    $0x4,%eax
  803cba:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803cbf:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  803cc1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cc4:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803cc8:	40                   	inc    %eax
  803cc9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803ccc:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  803cd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cd3:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803cd7:	0f b7 c8             	movzwl %ax,%ecx
  803cda:	b8 00 10 00 00       	mov    $0x1000,%eax
  803cdf:	ba 00 00 00 00       	mov    $0x0,%edx
  803ce4:	f7 75 e8             	divl   -0x18(%ebp)
  803ce7:	39 c1                	cmp    %eax,%ecx
  803ce9:	0f 85 ed 01 00 00    	jne    803edc <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cf2:	c1 e0 04             	shl    $0x4,%eax
  803cf5:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803cfa:	8b 00                	mov    (%eax),%eax
  803cfc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803cff:	eb 2a                	jmp    803d2b <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  803d01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d04:	83 ec 0c             	sub    $0xc,%esp
  803d07:	50                   	push   %eax
  803d08:	e8 b0 f7 ff ff       	call   8034bd <to_page_info>
  803d0d:	83 c4 10             	add    $0x10,%esp
  803d10:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803d13:	75 06                	jne    803d1b <free_block+0x16a>
				tmp = b;
  803d15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d18:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d1e:	c1 e0 04             	shl    $0x4,%eax
  803d21:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803d26:	8b 00                	mov    (%eax),%eax
  803d28:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803d2b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d2f:	74 07                	je     803d38 <free_block+0x187>
  803d31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d34:	8b 00                	mov    (%eax),%eax
  803d36:	eb 05                	jmp    803d3d <free_block+0x18c>
  803d38:	b8 00 00 00 00       	mov    $0x0,%eax
  803d3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d40:	c1 e2 04             	shl    $0x4,%edx
  803d43:	81 c2 a8 50 83 00    	add    $0x8350a8,%edx
  803d49:	89 02                	mov    %eax,(%edx)
  803d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d4e:	c1 e0 04             	shl    $0x4,%eax
  803d51:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803d56:	8b 00                	mov    (%eax),%eax
  803d58:	85 c0                	test   %eax,%eax
  803d5a:	75 a5                	jne    803d01 <free_block+0x150>
  803d5c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d60:	75 9f                	jne    803d01 <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  803d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d65:	c1 e0 04             	shl    $0x4,%eax
  803d68:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803d6d:	8b 00                	mov    (%eax),%eax
  803d6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  803d72:	e9 cc 00 00 00       	jmp    803e43 <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  803d77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d7a:	8b 00                	mov    (%eax),%eax
  803d7c:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  803d7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d82:	83 ec 0c             	sub    $0xc,%esp
  803d85:	50                   	push   %eax
  803d86:	e8 32 f7 ff ff       	call   8034bd <to_page_info>
  803d8b:	83 c4 10             	add    $0x10,%esp
  803d8e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803d91:	0f 85 a6 00 00 00    	jne    803e3d <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  803d97:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d9b:	75 17                	jne    803db4 <free_block+0x203>
  803d9d:	83 ec 04             	sub    $0x4,%esp
  803da0:	68 9d 4c 80 00       	push   $0x804c9d
  803da5:	68 b5 00 00 00       	push   $0xb5
  803daa:	68 03 4c 80 00       	push   $0x804c03
  803daf:	e8 d3 c6 ff ff       	call   800487 <_panic>
  803db4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803db7:	8b 00                	mov    (%eax),%eax
  803db9:	85 c0                	test   %eax,%eax
  803dbb:	74 10                	je     803dcd <free_block+0x21c>
  803dbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dc0:	8b 00                	mov    (%eax),%eax
  803dc2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803dc5:	8b 52 04             	mov    0x4(%edx),%edx
  803dc8:	89 50 04             	mov    %edx,0x4(%eax)
  803dcb:	eb 14                	jmp    803de1 <free_block+0x230>
  803dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dd0:	8b 40 04             	mov    0x4(%eax),%eax
  803dd3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803dd6:	c1 e2 04             	shl    $0x4,%edx
  803dd9:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803ddf:	89 02                	mov    %eax,(%edx)
  803de1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803de4:	8b 40 04             	mov    0x4(%eax),%eax
  803de7:	85 c0                	test   %eax,%eax
  803de9:	74 0f                	je     803dfa <free_block+0x249>
  803deb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dee:	8b 40 04             	mov    0x4(%eax),%eax
  803df1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803df4:	8b 12                	mov    (%edx),%edx
  803df6:	89 10                	mov    %edx,(%eax)
  803df8:	eb 13                	jmp    803e0d <free_block+0x25c>
  803dfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dfd:	8b 00                	mov    (%eax),%eax
  803dff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e02:	c1 e2 04             	shl    $0x4,%edx
  803e05:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803e0b:	89 02                	mov    %eax,(%edx)
  803e0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e19:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e23:	c1 e0 04             	shl    $0x4,%eax
  803e26:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803e2b:	8b 00                	mov    (%eax),%eax
  803e2d:	8d 50 ff             	lea    -0x1(%eax),%edx
  803e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e33:	c1 e0 04             	shl    $0x4,%eax
  803e36:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803e3b:	89 10                	mov    %edx,(%eax)
			b = next;
  803e3d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e40:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  803e43:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803e47:	0f 85 2a ff ff ff    	jne    803d77 <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  803e4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e50:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  803e56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e59:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  803e5f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803e63:	75 17                	jne    803e7c <free_block+0x2cb>
  803e65:	83 ec 04             	sub    $0x4,%esp
  803e68:	68 0c 4d 80 00       	push   $0x804d0c
  803e6d:	68 bc 00 00 00       	push   $0xbc
  803e72:	68 03 4c 80 00       	push   $0x804c03
  803e77:	e8 0b c6 ff ff       	call   800487 <_panic>
  803e7c:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803e82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e85:	89 10                	mov    %edx,(%eax)
  803e87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e8a:	8b 00                	mov    (%eax),%eax
  803e8c:	85 c0                	test   %eax,%eax
  803e8e:	74 0d                	je     803e9d <free_block+0x2ec>
  803e90:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803e95:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e98:	89 50 04             	mov    %edx,0x4(%eax)
  803e9b:	eb 08                	jmp    803ea5 <free_block+0x2f4>
  803e9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ea0:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803ea5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ea8:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803ead:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803eb0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803eb7:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803ebc:	40                   	inc    %eax
  803ebd:	a3 74 d0 81 00       	mov    %eax,0x81d074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  803ec2:	83 ec 0c             	sub    $0xc,%esp
  803ec5:	ff 75 ec             	pushl  -0x14(%ebp)
  803ec8:	e8 7e f5 ff ff       	call   80344b <to_page_va>
  803ecd:	83 c4 10             	add    $0x10,%esp
  803ed0:	83 ec 0c             	sub    $0xc,%esp
  803ed3:	50                   	push   %eax
  803ed4:	e8 fe d7 ff ff       	call   8016d7 <return_page>
  803ed9:	83 c4 10             	add    $0x10,%esp
	}
}
  803edc:	90                   	nop
  803edd:	c9                   	leave  
  803ede:	c3                   	ret    

00803edf <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803edf:	55                   	push   %ebp
  803ee0:	89 e5                	mov    %esp,%ebp
  803ee2:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803ee5:	8b 55 08             	mov    0x8(%ebp),%edx
  803ee8:	89 d0                	mov    %edx,%eax
  803eea:	c1 e0 02             	shl    $0x2,%eax
  803eed:	01 d0                	add    %edx,%eax
  803eef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803ef6:	01 d0                	add    %edx,%eax
  803ef8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803eff:	01 d0                	add    %edx,%eax
  803f01:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803f08:	01 d0                	add    %edx,%eax
  803f0a:	c1 e0 04             	shl    $0x4,%eax
  803f0d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  803f10:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  803f17:	0f 31                	rdtsc  
  803f19:	89 45 e8             	mov    %eax,-0x18(%ebp)
  803f1c:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  803f1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f22:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803f25:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803f28:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  803f2b:	eb 46                	jmp    803f73 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  803f2d:	0f 31                	rdtsc  
  803f2f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  803f32:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  803f35:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f38:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803f3b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  803f3e:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803f41:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803f44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f47:	29 c2                	sub    %eax,%edx
  803f49:	89 d0                	mov    %edx,%eax
  803f4b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803f4e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f54:	89 d1                	mov    %edx,%ecx
  803f56:	29 c1                	sub    %eax,%ecx
  803f58:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803f5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f5e:	39 c2                	cmp    %eax,%edx
  803f60:	0f 97 c0             	seta   %al
  803f63:	0f b6 c0             	movzbl %al,%eax
  803f66:	29 c1                	sub    %eax,%ecx
  803f68:	89 c8                	mov    %ecx,%eax
  803f6a:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803f6d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803f70:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  803f73:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803f76:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803f79:	72 b2                	jb     803f2d <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803f7b:	90                   	nop
  803f7c:	c9                   	leave  
  803f7d:	c3                   	ret    

00803f7e <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803f7e:	55                   	push   %ebp
  803f7f:	89 e5                	mov    %esp,%ebp
  803f81:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803f84:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803f8b:	eb 03                	jmp    803f90 <busy_wait+0x12>
  803f8d:	ff 45 fc             	incl   -0x4(%ebp)
  803f90:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803f93:	3b 45 08             	cmp    0x8(%ebp),%eax
  803f96:	72 f5                	jb     803f8d <busy_wait+0xf>
	return i;
  803f98:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803f9b:	c9                   	leave  
  803f9c:	c3                   	ret    
  803f9d:	66 90                	xchg   %ax,%ax
  803f9f:	90                   	nop

00803fa0 <__udivdi3>:
  803fa0:	55                   	push   %ebp
  803fa1:	57                   	push   %edi
  803fa2:	56                   	push   %esi
  803fa3:	53                   	push   %ebx
  803fa4:	83 ec 1c             	sub    $0x1c,%esp
  803fa7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803fab:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803faf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803fb3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803fb7:	89 ca                	mov    %ecx,%edx
  803fb9:	89 f8                	mov    %edi,%eax
  803fbb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803fbf:	85 f6                	test   %esi,%esi
  803fc1:	75 2d                	jne    803ff0 <__udivdi3+0x50>
  803fc3:	39 cf                	cmp    %ecx,%edi
  803fc5:	77 65                	ja     80402c <__udivdi3+0x8c>
  803fc7:	89 fd                	mov    %edi,%ebp
  803fc9:	85 ff                	test   %edi,%edi
  803fcb:	75 0b                	jne    803fd8 <__udivdi3+0x38>
  803fcd:	b8 01 00 00 00       	mov    $0x1,%eax
  803fd2:	31 d2                	xor    %edx,%edx
  803fd4:	f7 f7                	div    %edi
  803fd6:	89 c5                	mov    %eax,%ebp
  803fd8:	31 d2                	xor    %edx,%edx
  803fda:	89 c8                	mov    %ecx,%eax
  803fdc:	f7 f5                	div    %ebp
  803fde:	89 c1                	mov    %eax,%ecx
  803fe0:	89 d8                	mov    %ebx,%eax
  803fe2:	f7 f5                	div    %ebp
  803fe4:	89 cf                	mov    %ecx,%edi
  803fe6:	89 fa                	mov    %edi,%edx
  803fe8:	83 c4 1c             	add    $0x1c,%esp
  803feb:	5b                   	pop    %ebx
  803fec:	5e                   	pop    %esi
  803fed:	5f                   	pop    %edi
  803fee:	5d                   	pop    %ebp
  803fef:	c3                   	ret    
  803ff0:	39 ce                	cmp    %ecx,%esi
  803ff2:	77 28                	ja     80401c <__udivdi3+0x7c>
  803ff4:	0f bd fe             	bsr    %esi,%edi
  803ff7:	83 f7 1f             	xor    $0x1f,%edi
  803ffa:	75 40                	jne    80403c <__udivdi3+0x9c>
  803ffc:	39 ce                	cmp    %ecx,%esi
  803ffe:	72 0a                	jb     80400a <__udivdi3+0x6a>
  804000:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804004:	0f 87 9e 00 00 00    	ja     8040a8 <__udivdi3+0x108>
  80400a:	b8 01 00 00 00       	mov    $0x1,%eax
  80400f:	89 fa                	mov    %edi,%edx
  804011:	83 c4 1c             	add    $0x1c,%esp
  804014:	5b                   	pop    %ebx
  804015:	5e                   	pop    %esi
  804016:	5f                   	pop    %edi
  804017:	5d                   	pop    %ebp
  804018:	c3                   	ret    
  804019:	8d 76 00             	lea    0x0(%esi),%esi
  80401c:	31 ff                	xor    %edi,%edi
  80401e:	31 c0                	xor    %eax,%eax
  804020:	89 fa                	mov    %edi,%edx
  804022:	83 c4 1c             	add    $0x1c,%esp
  804025:	5b                   	pop    %ebx
  804026:	5e                   	pop    %esi
  804027:	5f                   	pop    %edi
  804028:	5d                   	pop    %ebp
  804029:	c3                   	ret    
  80402a:	66 90                	xchg   %ax,%ax
  80402c:	89 d8                	mov    %ebx,%eax
  80402e:	f7 f7                	div    %edi
  804030:	31 ff                	xor    %edi,%edi
  804032:	89 fa                	mov    %edi,%edx
  804034:	83 c4 1c             	add    $0x1c,%esp
  804037:	5b                   	pop    %ebx
  804038:	5e                   	pop    %esi
  804039:	5f                   	pop    %edi
  80403a:	5d                   	pop    %ebp
  80403b:	c3                   	ret    
  80403c:	bd 20 00 00 00       	mov    $0x20,%ebp
  804041:	89 eb                	mov    %ebp,%ebx
  804043:	29 fb                	sub    %edi,%ebx
  804045:	89 f9                	mov    %edi,%ecx
  804047:	d3 e6                	shl    %cl,%esi
  804049:	89 c5                	mov    %eax,%ebp
  80404b:	88 d9                	mov    %bl,%cl
  80404d:	d3 ed                	shr    %cl,%ebp
  80404f:	89 e9                	mov    %ebp,%ecx
  804051:	09 f1                	or     %esi,%ecx
  804053:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804057:	89 f9                	mov    %edi,%ecx
  804059:	d3 e0                	shl    %cl,%eax
  80405b:	89 c5                	mov    %eax,%ebp
  80405d:	89 d6                	mov    %edx,%esi
  80405f:	88 d9                	mov    %bl,%cl
  804061:	d3 ee                	shr    %cl,%esi
  804063:	89 f9                	mov    %edi,%ecx
  804065:	d3 e2                	shl    %cl,%edx
  804067:	8b 44 24 08          	mov    0x8(%esp),%eax
  80406b:	88 d9                	mov    %bl,%cl
  80406d:	d3 e8                	shr    %cl,%eax
  80406f:	09 c2                	or     %eax,%edx
  804071:	89 d0                	mov    %edx,%eax
  804073:	89 f2                	mov    %esi,%edx
  804075:	f7 74 24 0c          	divl   0xc(%esp)
  804079:	89 d6                	mov    %edx,%esi
  80407b:	89 c3                	mov    %eax,%ebx
  80407d:	f7 e5                	mul    %ebp
  80407f:	39 d6                	cmp    %edx,%esi
  804081:	72 19                	jb     80409c <__udivdi3+0xfc>
  804083:	74 0b                	je     804090 <__udivdi3+0xf0>
  804085:	89 d8                	mov    %ebx,%eax
  804087:	31 ff                	xor    %edi,%edi
  804089:	e9 58 ff ff ff       	jmp    803fe6 <__udivdi3+0x46>
  80408e:	66 90                	xchg   %ax,%ax
  804090:	8b 54 24 08          	mov    0x8(%esp),%edx
  804094:	89 f9                	mov    %edi,%ecx
  804096:	d3 e2                	shl    %cl,%edx
  804098:	39 c2                	cmp    %eax,%edx
  80409a:	73 e9                	jae    804085 <__udivdi3+0xe5>
  80409c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80409f:	31 ff                	xor    %edi,%edi
  8040a1:	e9 40 ff ff ff       	jmp    803fe6 <__udivdi3+0x46>
  8040a6:	66 90                	xchg   %ax,%ax
  8040a8:	31 c0                	xor    %eax,%eax
  8040aa:	e9 37 ff ff ff       	jmp    803fe6 <__udivdi3+0x46>
  8040af:	90                   	nop

008040b0 <__umoddi3>:
  8040b0:	55                   	push   %ebp
  8040b1:	57                   	push   %edi
  8040b2:	56                   	push   %esi
  8040b3:	53                   	push   %ebx
  8040b4:	83 ec 1c             	sub    $0x1c,%esp
  8040b7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8040bb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8040bf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8040c3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8040c7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8040cb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8040cf:	89 f3                	mov    %esi,%ebx
  8040d1:	89 fa                	mov    %edi,%edx
  8040d3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8040d7:	89 34 24             	mov    %esi,(%esp)
  8040da:	85 c0                	test   %eax,%eax
  8040dc:	75 1a                	jne    8040f8 <__umoddi3+0x48>
  8040de:	39 f7                	cmp    %esi,%edi
  8040e0:	0f 86 a2 00 00 00    	jbe    804188 <__umoddi3+0xd8>
  8040e6:	89 c8                	mov    %ecx,%eax
  8040e8:	89 f2                	mov    %esi,%edx
  8040ea:	f7 f7                	div    %edi
  8040ec:	89 d0                	mov    %edx,%eax
  8040ee:	31 d2                	xor    %edx,%edx
  8040f0:	83 c4 1c             	add    $0x1c,%esp
  8040f3:	5b                   	pop    %ebx
  8040f4:	5e                   	pop    %esi
  8040f5:	5f                   	pop    %edi
  8040f6:	5d                   	pop    %ebp
  8040f7:	c3                   	ret    
  8040f8:	39 f0                	cmp    %esi,%eax
  8040fa:	0f 87 ac 00 00 00    	ja     8041ac <__umoddi3+0xfc>
  804100:	0f bd e8             	bsr    %eax,%ebp
  804103:	83 f5 1f             	xor    $0x1f,%ebp
  804106:	0f 84 ac 00 00 00    	je     8041b8 <__umoddi3+0x108>
  80410c:	bf 20 00 00 00       	mov    $0x20,%edi
  804111:	29 ef                	sub    %ebp,%edi
  804113:	89 fe                	mov    %edi,%esi
  804115:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804119:	89 e9                	mov    %ebp,%ecx
  80411b:	d3 e0                	shl    %cl,%eax
  80411d:	89 d7                	mov    %edx,%edi
  80411f:	89 f1                	mov    %esi,%ecx
  804121:	d3 ef                	shr    %cl,%edi
  804123:	09 c7                	or     %eax,%edi
  804125:	89 e9                	mov    %ebp,%ecx
  804127:	d3 e2                	shl    %cl,%edx
  804129:	89 14 24             	mov    %edx,(%esp)
  80412c:	89 d8                	mov    %ebx,%eax
  80412e:	d3 e0                	shl    %cl,%eax
  804130:	89 c2                	mov    %eax,%edx
  804132:	8b 44 24 08          	mov    0x8(%esp),%eax
  804136:	d3 e0                	shl    %cl,%eax
  804138:	89 44 24 04          	mov    %eax,0x4(%esp)
  80413c:	8b 44 24 08          	mov    0x8(%esp),%eax
  804140:	89 f1                	mov    %esi,%ecx
  804142:	d3 e8                	shr    %cl,%eax
  804144:	09 d0                	or     %edx,%eax
  804146:	d3 eb                	shr    %cl,%ebx
  804148:	89 da                	mov    %ebx,%edx
  80414a:	f7 f7                	div    %edi
  80414c:	89 d3                	mov    %edx,%ebx
  80414e:	f7 24 24             	mull   (%esp)
  804151:	89 c6                	mov    %eax,%esi
  804153:	89 d1                	mov    %edx,%ecx
  804155:	39 d3                	cmp    %edx,%ebx
  804157:	0f 82 87 00 00 00    	jb     8041e4 <__umoddi3+0x134>
  80415d:	0f 84 91 00 00 00    	je     8041f4 <__umoddi3+0x144>
  804163:	8b 54 24 04          	mov    0x4(%esp),%edx
  804167:	29 f2                	sub    %esi,%edx
  804169:	19 cb                	sbb    %ecx,%ebx
  80416b:	89 d8                	mov    %ebx,%eax
  80416d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804171:	d3 e0                	shl    %cl,%eax
  804173:	89 e9                	mov    %ebp,%ecx
  804175:	d3 ea                	shr    %cl,%edx
  804177:	09 d0                	or     %edx,%eax
  804179:	89 e9                	mov    %ebp,%ecx
  80417b:	d3 eb                	shr    %cl,%ebx
  80417d:	89 da                	mov    %ebx,%edx
  80417f:	83 c4 1c             	add    $0x1c,%esp
  804182:	5b                   	pop    %ebx
  804183:	5e                   	pop    %esi
  804184:	5f                   	pop    %edi
  804185:	5d                   	pop    %ebp
  804186:	c3                   	ret    
  804187:	90                   	nop
  804188:	89 fd                	mov    %edi,%ebp
  80418a:	85 ff                	test   %edi,%edi
  80418c:	75 0b                	jne    804199 <__umoddi3+0xe9>
  80418e:	b8 01 00 00 00       	mov    $0x1,%eax
  804193:	31 d2                	xor    %edx,%edx
  804195:	f7 f7                	div    %edi
  804197:	89 c5                	mov    %eax,%ebp
  804199:	89 f0                	mov    %esi,%eax
  80419b:	31 d2                	xor    %edx,%edx
  80419d:	f7 f5                	div    %ebp
  80419f:	89 c8                	mov    %ecx,%eax
  8041a1:	f7 f5                	div    %ebp
  8041a3:	89 d0                	mov    %edx,%eax
  8041a5:	e9 44 ff ff ff       	jmp    8040ee <__umoddi3+0x3e>
  8041aa:	66 90                	xchg   %ax,%ax
  8041ac:	89 c8                	mov    %ecx,%eax
  8041ae:	89 f2                	mov    %esi,%edx
  8041b0:	83 c4 1c             	add    $0x1c,%esp
  8041b3:	5b                   	pop    %ebx
  8041b4:	5e                   	pop    %esi
  8041b5:	5f                   	pop    %edi
  8041b6:	5d                   	pop    %ebp
  8041b7:	c3                   	ret    
  8041b8:	3b 04 24             	cmp    (%esp),%eax
  8041bb:	72 06                	jb     8041c3 <__umoddi3+0x113>
  8041bd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8041c1:	77 0f                	ja     8041d2 <__umoddi3+0x122>
  8041c3:	89 f2                	mov    %esi,%edx
  8041c5:	29 f9                	sub    %edi,%ecx
  8041c7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8041cb:	89 14 24             	mov    %edx,(%esp)
  8041ce:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8041d2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8041d6:	8b 14 24             	mov    (%esp),%edx
  8041d9:	83 c4 1c             	add    $0x1c,%esp
  8041dc:	5b                   	pop    %ebx
  8041dd:	5e                   	pop    %esi
  8041de:	5f                   	pop    %edi
  8041df:	5d                   	pop    %ebp
  8041e0:	c3                   	ret    
  8041e1:	8d 76 00             	lea    0x0(%esi),%esi
  8041e4:	2b 04 24             	sub    (%esp),%eax
  8041e7:	19 fa                	sbb    %edi,%edx
  8041e9:	89 d1                	mov    %edx,%ecx
  8041eb:	89 c6                	mov    %eax,%esi
  8041ed:	e9 71 ff ff ff       	jmp    804163 <__umoddi3+0xb3>
  8041f2:	66 90                	xchg   %ax,%ax
  8041f4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8041f8:	72 ea                	jb     8041e4 <__umoddi3+0x134>
  8041fa:	89 d9                	mov    %ebx,%ecx
  8041fc:	e9 62 ff ff ff       	jmp    804163 <__umoddi3+0xb3>
