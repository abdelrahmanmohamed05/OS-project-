
obj/user/tst_envfree5_2:     file format elf32-i386


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
  800031:	e8 7b 02 00 00       	call   8002b1 <libmain>
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
	// Testing removing the shared variables
	// Testing scenario 5_2: Kill programs have already shared variables and they free it [include scenario 5_1]
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  800044:	83 ec 04             	sub    $0x4,%esp
  800047:	6a 01                	push   $0x1
  800049:	6a 04                	push   $0x4
  80004b:	68 e0 41 80 00       	push   $0x8041e0
  800050:	e8 09 1e 00 00       	call   801e5e <smalloc>
  800055:	83 c4 10             	add    $0x10,%esp
  800058:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	*numOfFinished = 0 ;
  80005b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80005e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	char getksbrkCmd[100] = "__getKernelSBreak__";
  800064:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  80006a:	bb e3 43 80 00       	mov    $0x8043e3,%ebx
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
  8000a1:	e8 f2 32 00 00       	call   803398 <sys_utilities>
  8000a6:	83 c4 10             	add    $0x10,%esp

	int freeFrames_before = sys_calculate_free_frames() ;
  8000a9:	e8 eb 2e 00 00       	call   802f99 <sys_calculate_free_frames>
  8000ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  8000b1:	e8 2e 2f 00 00       	call   802fe4 <sys_pf_calculate_allocated_pages>
  8000b6:	89 45 dc             	mov    %eax,-0x24(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  8000b9:	83 ec 08             	sub    $0x8,%esp
  8000bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8000bf:	68 f0 41 80 00       	push   $0x8041f0
  8000c4:	e8 66 06 00 00       	call   80072f <cprintf>
  8000c9:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr4", 3000,100, 50);
  8000cc:	6a 32                	push   $0x32
  8000ce:	6a 64                	push   $0x64
  8000d0:	68 b8 0b 00 00       	push   $0xbb8
  8000d5:	68 23 42 80 00       	push   $0x804223
  8000da:	e8 15 30 00 00       	call   8030f4 <sys_create_env>
  8000df:	83 c4 10             	add    $0x10,%esp
  8000e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int32 envIdProcessB = sys_create_env("ef_tshr5", 3000,100, 50);
  8000e5:	6a 32                	push   $0x32
  8000e7:	6a 64                	push   $0x64
  8000e9:	68 b8 0b 00 00       	push   $0xbb8
  8000ee:	68 2c 42 80 00       	push   $0x80422c
  8000f3:	e8 fc 2f 00 00       	call   8030f4 <sys_create_env>
  8000f8:	83 c4 10             	add    $0x10,%esp
  8000fb:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	sys_run_env(envIdProcessA);
  8000fe:	83 ec 0c             	sub    $0xc,%esp
  800101:	ff 75 d8             	pushl  -0x28(%ebp)
  800104:	e8 09 30 00 00       	call   803112 <sys_run_env>
  800109:	83 c4 10             	add    $0x10,%esp
	env_sleep(15000);
  80010c:	83 ec 0c             	sub    $0xc,%esp
  80010f:	68 98 3a 00 00       	push   $0x3a98
  800114:	e8 a0 3d 00 00       	call   803eb9 <env_sleep>
  800119:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  80011c:	83 ec 0c             	sub    $0xc,%esp
  80011f:	ff 75 d4             	pushl  -0x2c(%ebp)
  800122:	e8 eb 2f 00 00       	call   803112 <sys_run_env>
  800127:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  80012a:	90                   	nop
  80012b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80012e:	8b 00                	mov    (%eax),%eax
  800130:	83 f8 02             	cmp    $0x2,%eax
  800133:	75 f6                	jne    80012b <_main+0xf3>

	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  800135:	e8 5f 2e 00 00       	call   802f99 <sys_calculate_free_frames>
  80013a:	83 ec 08             	sub    $0x8,%esp
  80013d:	50                   	push   %eax
  80013e:	68 38 42 80 00       	push   $0x804238
  800143:	e8 e7 05 00 00       	call   80072f <cprintf>
  800148:	83 c4 10             	add    $0x10,%esp

	uint32 ksbrk_after ;
	sys_utilities(getksbrkCmd, (uint32)&ksbrk_after);
  80014b:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  800151:	83 ec 08             	sub    $0x8,%esp
  800154:	50                   	push   %eax
  800155:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  80015b:	50                   	push   %eax
  80015c:	e8 37 32 00 00       	call   803398 <sys_utilities>
  800161:	83 c4 10             	add    $0x10,%esp

	//DISABLE the interrupt to ensure the env_free is done as a whole without preemption
	//to avoid context switch (due to clock interrupt) while freeing the env to prevent:
	//	1. context switching to a wrong process specially in the part of temporarily switching the CPU process for freeing shared variables
	//	2. changing the # free frames
	char changeIntCmd[100] = "__changeInterruptStatus__";
  800164:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80016a:	bb 47 44 80 00       	mov    $0x804447,%ebx
  80016f:	ba 1a 00 00 00       	mov    $0x1a,%edx
  800174:	89 c7                	mov    %eax,%edi
  800176:	89 de                	mov    %ebx,%esi
  800178:	89 d1                	mov    %edx,%ecx
  80017a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80017c:	8d 95 02 ff ff ff    	lea    -0xfe(%ebp),%edx
  800182:	b9 4a 00 00 00       	mov    $0x4a,%ecx
  800187:	b0 00                	mov    $0x0,%al
  800189:	89 d7                	mov    %edx,%edi
  80018b:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(changeIntCmd, 0);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	6a 00                	push   $0x0
  800192:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  800198:	50                   	push   %eax
  800199:	e8 fa 31 00 00       	call   803398 <sys_utilities>
  80019e:	83 c4 10             	add    $0x10,%esp
	{
		sys_destroy_env(envIdProcessA);
  8001a1:	83 ec 0c             	sub    $0xc,%esp
  8001a4:	ff 75 d8             	pushl  -0x28(%ebp)
  8001a7:	e8 82 2f 00 00       	call   80312e <sys_destroy_env>
  8001ac:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(envIdProcessB);
  8001af:	83 ec 0c             	sub    $0xc,%esp
  8001b2:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001b5:	e8 74 2f 00 00       	call   80312e <sys_destroy_env>
  8001ba:	83 c4 10             	add    $0x10,%esp
	}
	sys_utilities(changeIntCmd, 1);
  8001bd:	83 ec 08             	sub    $0x8,%esp
  8001c0:	6a 01                	push   $0x1
  8001c2:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8001c8:	50                   	push   %eax
  8001c9:	e8 ca 31 00 00       	call   803398 <sys_utilities>
  8001ce:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8001d1:	e8 c3 2d 00 00       	call   802f99 <sys_calculate_free_frames>
  8001d6:	89 45 d0             	mov    %eax,-0x30(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8001d9:	e8 06 2e 00 00       	call   802fe4 <sys_pf_calculate_allocated_pages>
  8001de:	89 45 cc             	mov    %eax,-0x34(%ebp)

	int expected = (ROUNDUP((uint32)ksbrk_after, PAGE_SIZE) - ROUNDUP((uint32)ksbrk_before, PAGE_SIZE)) / PAGE_SIZE;
  8001e1:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  8001e8:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
  8001ee:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001f1:	01 d0                	add    %edx,%eax
  8001f3:	48                   	dec    %eax
  8001f4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8001f7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8001fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8001ff:	f7 75 c8             	divl   -0x38(%ebp)
  800202:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800205:	29 d0                	sub    %edx,%eax
  800207:	89 c1                	mov    %eax,%ecx
  800209:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  800210:	8b 95 50 ff ff ff    	mov    -0xb0(%ebp),%edx
  800216:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800219:	01 d0                	add    %edx,%eax
  80021b:	48                   	dec    %eax
  80021c:	89 45 bc             	mov    %eax,-0x44(%ebp)
  80021f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800222:	ba 00 00 00 00       	mov    $0x0,%edx
  800227:	f7 75 c0             	divl   -0x40(%ebp)
  80022a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80022d:	29 d0                	sub    %edx,%eax
  80022f:	29 c1                	sub    %eax,%ecx
  800231:	89 c8                	mov    %ecx,%eax
  800233:	c1 e8 0c             	shr    $0xc,%eax
  800236:	89 45 b8             	mov    %eax,-0x48(%ebp)
	cprintf("expected = %d\n",expected);
  800239:	83 ec 08             	sub    $0x8,%esp
  80023c:	ff 75 b8             	pushl  -0x48(%ebp)
  80023f:	68 6a 42 80 00       	push   $0x80426a
  800244:	e8 e6 04 00 00       	call   80072f <cprintf>
  800249:	83 c4 10             	add    $0x10,%esp
	if ((freeFrames_before - freeFrames_after) != expected) {
  80024c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80024f:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800252:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800255:	74 2e                	je     800285 <_main+0x24d>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\ndifference = %d, expected = %d\n",
  800257:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80025a:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80025d:	ff 75 b8             	pushl  -0x48(%ebp)
  800260:	50                   	push   %eax
  800261:	ff 75 d0             	pushl  -0x30(%ebp)
  800264:	68 7c 42 80 00       	push   $0x80427c
  800269:	e8 c1 04 00 00       	call   80072f <cprintf>
  80026e:	83 c4 10             	add    $0x10,%esp
				freeFrames_after, freeFrames_after - freeFrames_before, expected);
		panic("env_free() does not work correctly... check it again.");
  800271:	83 ec 04             	sub    $0x4,%esp
  800274:	68 ec 42 80 00       	push   $0x8042ec
  800279:	6a 36                	push   $0x36
  80027b:	68 22 43 80 00       	push   $0x804322
  800280:	e8 dc 01 00 00       	call   800461 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  800285:	83 ec 08             	sub    $0x8,%esp
  800288:	ff 75 d0             	pushl  -0x30(%ebp)
  80028b:	68 38 43 80 00       	push   $0x804338
  800290:	e8 9a 04 00 00       	call   80072f <cprintf>
  800295:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 5_2 for envfree completed successfully.\n");
  800298:	83 ec 0c             	sub    $0xc,%esp
  80029b:	68 98 43 80 00       	push   $0x804398
  8002a0:	e8 8a 04 00 00       	call   80072f <cprintf>
  8002a5:	83 c4 10             	add    $0x10,%esp
	return;
  8002a8:	90                   	nop
}
  8002a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ac:	5b                   	pop    %ebx
  8002ad:	5e                   	pop    %esi
  8002ae:	5f                   	pop    %edi
  8002af:	5d                   	pop    %ebp
  8002b0:	c3                   	ret    

008002b1 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002b1:	55                   	push   %ebp
  8002b2:	89 e5                	mov    %esp,%ebp
  8002b4:	57                   	push   %edi
  8002b5:	56                   	push   %esi
  8002b6:	53                   	push   %ebx
  8002b7:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8002ba:	e8 a3 2e 00 00       	call   803162 <sys_getenvindex>
  8002bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002c2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002c5:	89 d0                	mov    %edx,%eax
  8002c7:	c1 e0 03             	shl    $0x3,%eax
  8002ca:	01 d0                	add    %edx,%eax
  8002cc:	c1 e0 02             	shl    $0x2,%eax
  8002cf:	01 d0                	add    %edx,%eax
  8002d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002d8:	01 d0                	add    %edx,%eax
  8002da:	c1 e0 03             	shl    $0x3,%eax
  8002dd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002e2:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002e7:	a1 20 50 80 00       	mov    0x805020,%eax
  8002ec:	8a 40 20             	mov    0x20(%eax),%al
  8002ef:	84 c0                	test   %al,%al
  8002f1:	74 0d                	je     800300 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8002f3:	a1 20 50 80 00       	mov    0x805020,%eax
  8002f8:	83 c0 20             	add    $0x20,%eax
  8002fb:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800300:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800304:	7e 0a                	jle    800310 <libmain+0x5f>
		binaryname = argv[0];
  800306:	8b 45 0c             	mov    0xc(%ebp),%eax
  800309:	8b 00                	mov    (%eax),%eax
  80030b:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  800310:	83 ec 08             	sub    $0x8,%esp
  800313:	ff 75 0c             	pushl  0xc(%ebp)
  800316:	ff 75 08             	pushl  0x8(%ebp)
  800319:	e8 1a fd ff ff       	call   800038 <_main>
  80031e:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800321:	a1 00 50 80 00       	mov    0x805000,%eax
  800326:	85 c0                	test   %eax,%eax
  800328:	0f 84 01 01 00 00    	je     80042f <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80032e:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800334:	bb a4 45 80 00       	mov    $0x8045a4,%ebx
  800339:	ba 0e 00 00 00       	mov    $0xe,%edx
  80033e:	89 c7                	mov    %eax,%edi
  800340:	89 de                	mov    %ebx,%esi
  800342:	89 d1                	mov    %edx,%ecx
  800344:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800346:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800349:	b9 56 00 00 00       	mov    $0x56,%ecx
  80034e:	b0 00                	mov    $0x0,%al
  800350:	89 d7                	mov    %edx,%edi
  800352:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800354:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80035b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80035e:	83 ec 08             	sub    $0x8,%esp
  800361:	50                   	push   %eax
  800362:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800368:	50                   	push   %eax
  800369:	e8 2a 30 00 00       	call   803398 <sys_utilities>
  80036e:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800371:	e8 73 2b 00 00       	call   802ee9 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800376:	83 ec 0c             	sub    $0xc,%esp
  800379:	68 c4 44 80 00       	push   $0x8044c4
  80037e:	e8 ac 03 00 00       	call   80072f <cprintf>
  800383:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800386:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800389:	85 c0                	test   %eax,%eax
  80038b:	74 18                	je     8003a5 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80038d:	e8 24 30 00 00       	call   8033b6 <sys_get_optimal_num_faults>
  800392:	83 ec 08             	sub    $0x8,%esp
  800395:	50                   	push   %eax
  800396:	68 ec 44 80 00       	push   $0x8044ec
  80039b:	e8 8f 03 00 00       	call   80072f <cprintf>
  8003a0:	83 c4 10             	add    $0x10,%esp
  8003a3:	eb 59                	jmp    8003fe <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003a5:	a1 20 50 80 00       	mov    0x805020,%eax
  8003aa:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  8003b0:	a1 20 50 80 00       	mov    0x805020,%eax
  8003b5:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8003bb:	83 ec 04             	sub    $0x4,%esp
  8003be:	52                   	push   %edx
  8003bf:	50                   	push   %eax
  8003c0:	68 10 45 80 00       	push   $0x804510
  8003c5:	e8 65 03 00 00       	call   80072f <cprintf>
  8003ca:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003cd:	a1 20 50 80 00       	mov    0x805020,%eax
  8003d2:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  8003d8:	a1 20 50 80 00       	mov    0x805020,%eax
  8003dd:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  8003e3:	a1 20 50 80 00       	mov    0x805020,%eax
  8003e8:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8003ee:	51                   	push   %ecx
  8003ef:	52                   	push   %edx
  8003f0:	50                   	push   %eax
  8003f1:	68 38 45 80 00       	push   $0x804538
  8003f6:	e8 34 03 00 00       	call   80072f <cprintf>
  8003fb:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003fe:	a1 20 50 80 00       	mov    0x805020,%eax
  800403:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  800409:	83 ec 08             	sub    $0x8,%esp
  80040c:	50                   	push   %eax
  80040d:	68 90 45 80 00       	push   $0x804590
  800412:	e8 18 03 00 00       	call   80072f <cprintf>
  800417:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80041a:	83 ec 0c             	sub    $0xc,%esp
  80041d:	68 c4 44 80 00       	push   $0x8044c4
  800422:	e8 08 03 00 00       	call   80072f <cprintf>
  800427:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80042a:	e8 d4 2a 00 00       	call   802f03 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80042f:	e8 1f 00 00 00       	call   800453 <exit>
}
  800434:	90                   	nop
  800435:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800438:	5b                   	pop    %ebx
  800439:	5e                   	pop    %esi
  80043a:	5f                   	pop    %edi
  80043b:	5d                   	pop    %ebp
  80043c:	c3                   	ret    

0080043d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80043d:	55                   	push   %ebp
  80043e:	89 e5                	mov    %esp,%ebp
  800440:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800443:	83 ec 0c             	sub    $0xc,%esp
  800446:	6a 00                	push   $0x0
  800448:	e8 e1 2c 00 00       	call   80312e <sys_destroy_env>
  80044d:	83 c4 10             	add    $0x10,%esp
}
  800450:	90                   	nop
  800451:	c9                   	leave  
  800452:	c3                   	ret    

00800453 <exit>:

void
exit(void)
{
  800453:	55                   	push   %ebp
  800454:	89 e5                	mov    %esp,%ebp
  800456:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800459:	e8 36 2d 00 00       	call   803194 <sys_exit_env>
}
  80045e:	90                   	nop
  80045f:	c9                   	leave  
  800460:	c3                   	ret    

00800461 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800461:	55                   	push   %ebp
  800462:	89 e5                	mov    %esp,%ebp
  800464:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800467:	8d 45 10             	lea    0x10(%ebp),%eax
  80046a:	83 c0 04             	add    $0x4,%eax
  80046d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800470:	a1 38 51 83 00       	mov    0x835138,%eax
  800475:	85 c0                	test   %eax,%eax
  800477:	74 16                	je     80048f <_panic+0x2e>
		cprintf("%s: ", argv0);
  800479:	a1 38 51 83 00       	mov    0x835138,%eax
  80047e:	83 ec 08             	sub    $0x8,%esp
  800481:	50                   	push   %eax
  800482:	68 08 46 80 00       	push   $0x804608
  800487:	e8 a3 02 00 00       	call   80072f <cprintf>
  80048c:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80048f:	a1 04 50 80 00       	mov    0x805004,%eax
  800494:	83 ec 0c             	sub    $0xc,%esp
  800497:	ff 75 0c             	pushl  0xc(%ebp)
  80049a:	ff 75 08             	pushl  0x8(%ebp)
  80049d:	50                   	push   %eax
  80049e:	68 10 46 80 00       	push   $0x804610
  8004a3:	6a 74                	push   $0x74
  8004a5:	e8 b2 02 00 00       	call   80075c <cprintf_colored>
  8004aa:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8004b0:	83 ec 08             	sub    $0x8,%esp
  8004b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8004b6:	50                   	push   %eax
  8004b7:	e8 04 02 00 00       	call   8006c0 <vcprintf>
  8004bc:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004bf:	83 ec 08             	sub    $0x8,%esp
  8004c2:	6a 00                	push   $0x0
  8004c4:	68 38 46 80 00       	push   $0x804638
  8004c9:	e8 f2 01 00 00       	call   8006c0 <vcprintf>
  8004ce:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004d1:	e8 7d ff ff ff       	call   800453 <exit>

	// should not return here
	while (1) ;
  8004d6:	eb fe                	jmp    8004d6 <_panic+0x75>

008004d8 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004d8:	55                   	push   %ebp
  8004d9:	89 e5                	mov    %esp,%ebp
  8004db:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8004de:	a1 20 50 80 00       	mov    0x805020,%eax
  8004e3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ec:	39 c2                	cmp    %eax,%edx
  8004ee:	74 14                	je     800504 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8004f0:	83 ec 04             	sub    $0x4,%esp
  8004f3:	68 3c 46 80 00       	push   $0x80463c
  8004f8:	6a 26                	push   $0x26
  8004fa:	68 88 46 80 00       	push   $0x804688
  8004ff:	e8 5d ff ff ff       	call   800461 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800504:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80050b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800512:	e9 c5 00 00 00       	jmp    8005dc <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800517:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80051a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800521:	8b 45 08             	mov    0x8(%ebp),%eax
  800524:	01 d0                	add    %edx,%eax
  800526:	8b 00                	mov    (%eax),%eax
  800528:	85 c0                	test   %eax,%eax
  80052a:	75 08                	jne    800534 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80052c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80052f:	e9 a5 00 00 00       	jmp    8005d9 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800534:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80053b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800542:	eb 69                	jmp    8005ad <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800544:	a1 20 50 80 00       	mov    0x805020,%eax
  800549:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80054f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800552:	89 d0                	mov    %edx,%eax
  800554:	01 c0                	add    %eax,%eax
  800556:	01 d0                	add    %edx,%eax
  800558:	c1 e0 03             	shl    $0x3,%eax
  80055b:	01 c8                	add    %ecx,%eax
  80055d:	8a 40 04             	mov    0x4(%eax),%al
  800560:	84 c0                	test   %al,%al
  800562:	75 46                	jne    8005aa <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800564:	a1 20 50 80 00       	mov    0x805020,%eax
  800569:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80056f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800572:	89 d0                	mov    %edx,%eax
  800574:	01 c0                	add    %eax,%eax
  800576:	01 d0                	add    %edx,%eax
  800578:	c1 e0 03             	shl    $0x3,%eax
  80057b:	01 c8                	add    %ecx,%eax
  80057d:	8b 00                	mov    (%eax),%eax
  80057f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800582:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800585:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80058a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80058c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80058f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800596:	8b 45 08             	mov    0x8(%ebp),%eax
  800599:	01 c8                	add    %ecx,%eax
  80059b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80059d:	39 c2                	cmp    %eax,%edx
  80059f:	75 09                	jne    8005aa <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8005a1:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005a8:	eb 15                	jmp    8005bf <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005aa:	ff 45 e8             	incl   -0x18(%ebp)
  8005ad:	a1 20 50 80 00       	mov    0x805020,%eax
  8005b2:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005bb:	39 c2                	cmp    %eax,%edx
  8005bd:	77 85                	ja     800544 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005c3:	75 14                	jne    8005d9 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8005c5:	83 ec 04             	sub    $0x4,%esp
  8005c8:	68 94 46 80 00       	push   $0x804694
  8005cd:	6a 3a                	push   $0x3a
  8005cf:	68 88 46 80 00       	push   $0x804688
  8005d4:	e8 88 fe ff ff       	call   800461 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005d9:	ff 45 f0             	incl   -0x10(%ebp)
  8005dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005df:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005e2:	0f 8c 2f ff ff ff    	jl     800517 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8005e8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005ef:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8005f6:	eb 26                	jmp    80061e <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8005f8:	a1 20 50 80 00       	mov    0x805020,%eax
  8005fd:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800603:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800606:	89 d0                	mov    %edx,%eax
  800608:	01 c0                	add    %eax,%eax
  80060a:	01 d0                	add    %edx,%eax
  80060c:	c1 e0 03             	shl    $0x3,%eax
  80060f:	01 c8                	add    %ecx,%eax
  800611:	8a 40 04             	mov    0x4(%eax),%al
  800614:	3c 01                	cmp    $0x1,%al
  800616:	75 03                	jne    80061b <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800618:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80061b:	ff 45 e0             	incl   -0x20(%ebp)
  80061e:	a1 20 50 80 00       	mov    0x805020,%eax
  800623:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800629:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80062c:	39 c2                	cmp    %eax,%edx
  80062e:	77 c8                	ja     8005f8 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800633:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800636:	74 14                	je     80064c <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800638:	83 ec 04             	sub    $0x4,%esp
  80063b:	68 e8 46 80 00       	push   $0x8046e8
  800640:	6a 44                	push   $0x44
  800642:	68 88 46 80 00       	push   $0x804688
  800647:	e8 15 fe ff ff       	call   800461 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80064c:	90                   	nop
  80064d:	c9                   	leave  
  80064e:	c3                   	ret    

0080064f <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80064f:	55                   	push   %ebp
  800650:	89 e5                	mov    %esp,%ebp
  800652:	53                   	push   %ebx
  800653:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800656:	8b 45 0c             	mov    0xc(%ebp),%eax
  800659:	8b 00                	mov    (%eax),%eax
  80065b:	8d 48 01             	lea    0x1(%eax),%ecx
  80065e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800661:	89 0a                	mov    %ecx,(%edx)
  800663:	8b 55 08             	mov    0x8(%ebp),%edx
  800666:	88 d1                	mov    %dl,%cl
  800668:	8b 55 0c             	mov    0xc(%ebp),%edx
  80066b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80066f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800672:	8b 00                	mov    (%eax),%eax
  800674:	3d ff 00 00 00       	cmp    $0xff,%eax
  800679:	75 30                	jne    8006ab <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80067b:	8b 15 3c 51 83 00    	mov    0x83513c,%edx
  800681:	a0 64 d0 81 00       	mov    0x81d064,%al
  800686:	0f b6 c0             	movzbl %al,%eax
  800689:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80068c:	8b 09                	mov    (%ecx),%ecx
  80068e:	89 cb                	mov    %ecx,%ebx
  800690:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800693:	83 c1 08             	add    $0x8,%ecx
  800696:	52                   	push   %edx
  800697:	50                   	push   %eax
  800698:	53                   	push   %ebx
  800699:	51                   	push   %ecx
  80069a:	e8 06 28 00 00       	call   802ea5 <sys_cputs>
  80069f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ae:	8b 40 04             	mov    0x4(%eax),%eax
  8006b1:	8d 50 01             	lea    0x1(%eax),%edx
  8006b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006b7:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006ba:	90                   	nop
  8006bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006be:	c9                   	leave  
  8006bf:	c3                   	ret    

008006c0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006c0:	55                   	push   %ebp
  8006c1:	89 e5                	mov    %esp,%ebp
  8006c3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006c9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006d0:	00 00 00 
	b.cnt = 0;
  8006d3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006da:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006dd:	ff 75 0c             	pushl  0xc(%ebp)
  8006e0:	ff 75 08             	pushl  0x8(%ebp)
  8006e3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006e9:	50                   	push   %eax
  8006ea:	68 4f 06 80 00       	push   $0x80064f
  8006ef:	e8 5a 02 00 00       	call   80094e <vprintfmt>
  8006f4:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8006f7:	8b 15 3c 51 83 00    	mov    0x83513c,%edx
  8006fd:	a0 64 d0 81 00       	mov    0x81d064,%al
  800702:	0f b6 c0             	movzbl %al,%eax
  800705:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80070b:	52                   	push   %edx
  80070c:	50                   	push   %eax
  80070d:	51                   	push   %ecx
  80070e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800714:	83 c0 08             	add    $0x8,%eax
  800717:	50                   	push   %eax
  800718:	e8 88 27 00 00       	call   802ea5 <sys_cputs>
  80071d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800720:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
	return b.cnt;
  800727:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80072d:	c9                   	leave  
  80072e:	c3                   	ret    

0080072f <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80072f:	55                   	push   %ebp
  800730:	89 e5                	mov    %esp,%ebp
  800732:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800735:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	va_start(ap, fmt);
  80073c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80073f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800742:	8b 45 08             	mov    0x8(%ebp),%eax
  800745:	83 ec 08             	sub    $0x8,%esp
  800748:	ff 75 f4             	pushl  -0xc(%ebp)
  80074b:	50                   	push   %eax
  80074c:	e8 6f ff ff ff       	call   8006c0 <vcprintf>
  800751:	83 c4 10             	add    $0x10,%esp
  800754:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800757:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80075a:	c9                   	leave  
  80075b:	c3                   	ret    

0080075c <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80075c:	55                   	push   %ebp
  80075d:	89 e5                	mov    %esp,%ebp
  80075f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800762:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	curTextClr = (textClr << 8) ; //set text color by the given value
  800769:	8b 45 08             	mov    0x8(%ebp),%eax
  80076c:	c1 e0 08             	shl    $0x8,%eax
  80076f:	a3 3c 51 83 00       	mov    %eax,0x83513c
	va_start(ap, fmt);
  800774:	8d 45 0c             	lea    0xc(%ebp),%eax
  800777:	83 c0 04             	add    $0x4,%eax
  80077a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80077d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800780:	83 ec 08             	sub    $0x8,%esp
  800783:	ff 75 f4             	pushl  -0xc(%ebp)
  800786:	50                   	push   %eax
  800787:	e8 34 ff ff ff       	call   8006c0 <vcprintf>
  80078c:	83 c4 10             	add    $0x10,%esp
  80078f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800792:	c7 05 3c 51 83 00 00 	movl   $0x700,0x83513c
  800799:	07 00 00 

	return cnt;
  80079c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80079f:	c9                   	leave  
  8007a0:	c3                   	ret    

008007a1 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007a1:	55                   	push   %ebp
  8007a2:	89 e5                	mov    %esp,%ebp
  8007a4:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007a7:	e8 3d 27 00 00       	call   802ee9 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007ac:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007af:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b5:	83 ec 08             	sub    $0x8,%esp
  8007b8:	ff 75 f4             	pushl  -0xc(%ebp)
  8007bb:	50                   	push   %eax
  8007bc:	e8 ff fe ff ff       	call   8006c0 <vcprintf>
  8007c1:	83 c4 10             	add    $0x10,%esp
  8007c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007c7:	e8 37 27 00 00       	call   802f03 <sys_unlock_cons>
	return cnt;
  8007cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007cf:	c9                   	leave  
  8007d0:	c3                   	ret    

008007d1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007d1:	55                   	push   %ebp
  8007d2:	89 e5                	mov    %esp,%ebp
  8007d4:	53                   	push   %ebx
  8007d5:	83 ec 14             	sub    $0x14,%esp
  8007d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8007db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007de:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007e4:	8b 45 18             	mov    0x18(%ebp),%eax
  8007e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ec:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007ef:	77 55                	ja     800846 <printnum+0x75>
  8007f1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007f4:	72 05                	jb     8007fb <printnum+0x2a>
  8007f6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007f9:	77 4b                	ja     800846 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007fb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007fe:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800801:	8b 45 18             	mov    0x18(%ebp),%eax
  800804:	ba 00 00 00 00       	mov    $0x0,%edx
  800809:	52                   	push   %edx
  80080a:	50                   	push   %eax
  80080b:	ff 75 f4             	pushl  -0xc(%ebp)
  80080e:	ff 75 f0             	pushl  -0x10(%ebp)
  800811:	e8 62 37 00 00       	call   803f78 <__udivdi3>
  800816:	83 c4 10             	add    $0x10,%esp
  800819:	83 ec 04             	sub    $0x4,%esp
  80081c:	ff 75 20             	pushl  0x20(%ebp)
  80081f:	53                   	push   %ebx
  800820:	ff 75 18             	pushl  0x18(%ebp)
  800823:	52                   	push   %edx
  800824:	50                   	push   %eax
  800825:	ff 75 0c             	pushl  0xc(%ebp)
  800828:	ff 75 08             	pushl  0x8(%ebp)
  80082b:	e8 a1 ff ff ff       	call   8007d1 <printnum>
  800830:	83 c4 20             	add    $0x20,%esp
  800833:	eb 1a                	jmp    80084f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800835:	83 ec 08             	sub    $0x8,%esp
  800838:	ff 75 0c             	pushl  0xc(%ebp)
  80083b:	ff 75 20             	pushl  0x20(%ebp)
  80083e:	8b 45 08             	mov    0x8(%ebp),%eax
  800841:	ff d0                	call   *%eax
  800843:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800846:	ff 4d 1c             	decl   0x1c(%ebp)
  800849:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80084d:	7f e6                	jg     800835 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80084f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800852:	bb 00 00 00 00       	mov    $0x0,%ebx
  800857:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80085a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80085d:	53                   	push   %ebx
  80085e:	51                   	push   %ecx
  80085f:	52                   	push   %edx
  800860:	50                   	push   %eax
  800861:	e8 22 38 00 00       	call   804088 <__umoddi3>
  800866:	83 c4 10             	add    $0x10,%esp
  800869:	05 54 49 80 00       	add    $0x804954,%eax
  80086e:	8a 00                	mov    (%eax),%al
  800870:	0f be c0             	movsbl %al,%eax
  800873:	83 ec 08             	sub    $0x8,%esp
  800876:	ff 75 0c             	pushl  0xc(%ebp)
  800879:	50                   	push   %eax
  80087a:	8b 45 08             	mov    0x8(%ebp),%eax
  80087d:	ff d0                	call   *%eax
  80087f:	83 c4 10             	add    $0x10,%esp
}
  800882:	90                   	nop
  800883:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800886:	c9                   	leave  
  800887:	c3                   	ret    

00800888 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800888:	55                   	push   %ebp
  800889:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80088b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80088f:	7e 1c                	jle    8008ad <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800891:	8b 45 08             	mov    0x8(%ebp),%eax
  800894:	8b 00                	mov    (%eax),%eax
  800896:	8d 50 08             	lea    0x8(%eax),%edx
  800899:	8b 45 08             	mov    0x8(%ebp),%eax
  80089c:	89 10                	mov    %edx,(%eax)
  80089e:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a1:	8b 00                	mov    (%eax),%eax
  8008a3:	83 e8 08             	sub    $0x8,%eax
  8008a6:	8b 50 04             	mov    0x4(%eax),%edx
  8008a9:	8b 00                	mov    (%eax),%eax
  8008ab:	eb 40                	jmp    8008ed <getuint+0x65>
	else if (lflag)
  8008ad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008b1:	74 1e                	je     8008d1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b6:	8b 00                	mov    (%eax),%eax
  8008b8:	8d 50 04             	lea    0x4(%eax),%edx
  8008bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008be:	89 10                	mov    %edx,(%eax)
  8008c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c3:	8b 00                	mov    (%eax),%eax
  8008c5:	83 e8 04             	sub    $0x4,%eax
  8008c8:	8b 00                	mov    (%eax),%eax
  8008ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8008cf:	eb 1c                	jmp    8008ed <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d4:	8b 00                	mov    (%eax),%eax
  8008d6:	8d 50 04             	lea    0x4(%eax),%edx
  8008d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dc:	89 10                	mov    %edx,(%eax)
  8008de:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e1:	8b 00                	mov    (%eax),%eax
  8008e3:	83 e8 04             	sub    $0x4,%eax
  8008e6:	8b 00                	mov    (%eax),%eax
  8008e8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008ed:	5d                   	pop    %ebp
  8008ee:	c3                   	ret    

008008ef <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008ef:	55                   	push   %ebp
  8008f0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008f2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008f6:	7e 1c                	jle    800914 <getint+0x25>
		return va_arg(*ap, long long);
  8008f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fb:	8b 00                	mov    (%eax),%eax
  8008fd:	8d 50 08             	lea    0x8(%eax),%edx
  800900:	8b 45 08             	mov    0x8(%ebp),%eax
  800903:	89 10                	mov    %edx,(%eax)
  800905:	8b 45 08             	mov    0x8(%ebp),%eax
  800908:	8b 00                	mov    (%eax),%eax
  80090a:	83 e8 08             	sub    $0x8,%eax
  80090d:	8b 50 04             	mov    0x4(%eax),%edx
  800910:	8b 00                	mov    (%eax),%eax
  800912:	eb 38                	jmp    80094c <getint+0x5d>
	else if (lflag)
  800914:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800918:	74 1a                	je     800934 <getint+0x45>
		return va_arg(*ap, long);
  80091a:	8b 45 08             	mov    0x8(%ebp),%eax
  80091d:	8b 00                	mov    (%eax),%eax
  80091f:	8d 50 04             	lea    0x4(%eax),%edx
  800922:	8b 45 08             	mov    0x8(%ebp),%eax
  800925:	89 10                	mov    %edx,(%eax)
  800927:	8b 45 08             	mov    0x8(%ebp),%eax
  80092a:	8b 00                	mov    (%eax),%eax
  80092c:	83 e8 04             	sub    $0x4,%eax
  80092f:	8b 00                	mov    (%eax),%eax
  800931:	99                   	cltd   
  800932:	eb 18                	jmp    80094c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800934:	8b 45 08             	mov    0x8(%ebp),%eax
  800937:	8b 00                	mov    (%eax),%eax
  800939:	8d 50 04             	lea    0x4(%eax),%edx
  80093c:	8b 45 08             	mov    0x8(%ebp),%eax
  80093f:	89 10                	mov    %edx,(%eax)
  800941:	8b 45 08             	mov    0x8(%ebp),%eax
  800944:	8b 00                	mov    (%eax),%eax
  800946:	83 e8 04             	sub    $0x4,%eax
  800949:	8b 00                	mov    (%eax),%eax
  80094b:	99                   	cltd   
}
  80094c:	5d                   	pop    %ebp
  80094d:	c3                   	ret    

0080094e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80094e:	55                   	push   %ebp
  80094f:	89 e5                	mov    %esp,%ebp
  800951:	56                   	push   %esi
  800952:	53                   	push   %ebx
  800953:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800956:	eb 17                	jmp    80096f <vprintfmt+0x21>
			if (ch == '\0')
  800958:	85 db                	test   %ebx,%ebx
  80095a:	0f 84 c1 03 00 00    	je     800d21 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800960:	83 ec 08             	sub    $0x8,%esp
  800963:	ff 75 0c             	pushl  0xc(%ebp)
  800966:	53                   	push   %ebx
  800967:	8b 45 08             	mov    0x8(%ebp),%eax
  80096a:	ff d0                	call   *%eax
  80096c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80096f:	8b 45 10             	mov    0x10(%ebp),%eax
  800972:	8d 50 01             	lea    0x1(%eax),%edx
  800975:	89 55 10             	mov    %edx,0x10(%ebp)
  800978:	8a 00                	mov    (%eax),%al
  80097a:	0f b6 d8             	movzbl %al,%ebx
  80097d:	83 fb 25             	cmp    $0x25,%ebx
  800980:	75 d6                	jne    800958 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800982:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800986:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80098d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800994:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80099b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a5:	8d 50 01             	lea    0x1(%eax),%edx
  8009a8:	89 55 10             	mov    %edx,0x10(%ebp)
  8009ab:	8a 00                	mov    (%eax),%al
  8009ad:	0f b6 d8             	movzbl %al,%ebx
  8009b0:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009b3:	83 f8 5b             	cmp    $0x5b,%eax
  8009b6:	0f 87 3d 03 00 00    	ja     800cf9 <vprintfmt+0x3ab>
  8009bc:	8b 04 85 78 49 80 00 	mov    0x804978(,%eax,4),%eax
  8009c3:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009c5:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009c9:	eb d7                	jmp    8009a2 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009cb:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009cf:	eb d1                	jmp    8009a2 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009d1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009d8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009db:	89 d0                	mov    %edx,%eax
  8009dd:	c1 e0 02             	shl    $0x2,%eax
  8009e0:	01 d0                	add    %edx,%eax
  8009e2:	01 c0                	add    %eax,%eax
  8009e4:	01 d8                	add    %ebx,%eax
  8009e6:	83 e8 30             	sub    $0x30,%eax
  8009e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ef:	8a 00                	mov    (%eax),%al
  8009f1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009f4:	83 fb 2f             	cmp    $0x2f,%ebx
  8009f7:	7e 3e                	jle    800a37 <vprintfmt+0xe9>
  8009f9:	83 fb 39             	cmp    $0x39,%ebx
  8009fc:	7f 39                	jg     800a37 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009fe:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a01:	eb d5                	jmp    8009d8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a03:	8b 45 14             	mov    0x14(%ebp),%eax
  800a06:	83 c0 04             	add    $0x4,%eax
  800a09:	89 45 14             	mov    %eax,0x14(%ebp)
  800a0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0f:	83 e8 04             	sub    $0x4,%eax
  800a12:	8b 00                	mov    (%eax),%eax
  800a14:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a17:	eb 1f                	jmp    800a38 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a19:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a1d:	79 83                	jns    8009a2 <vprintfmt+0x54>
				width = 0;
  800a1f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a26:	e9 77 ff ff ff       	jmp    8009a2 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a2b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a32:	e9 6b ff ff ff       	jmp    8009a2 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a37:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a38:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a3c:	0f 89 60 ff ff ff    	jns    8009a2 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a48:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a4f:	e9 4e ff ff ff       	jmp    8009a2 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a54:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a57:	e9 46 ff ff ff       	jmp    8009a2 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a5c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5f:	83 c0 04             	add    $0x4,%eax
  800a62:	89 45 14             	mov    %eax,0x14(%ebp)
  800a65:	8b 45 14             	mov    0x14(%ebp),%eax
  800a68:	83 e8 04             	sub    $0x4,%eax
  800a6b:	8b 00                	mov    (%eax),%eax
  800a6d:	83 ec 08             	sub    $0x8,%esp
  800a70:	ff 75 0c             	pushl  0xc(%ebp)
  800a73:	50                   	push   %eax
  800a74:	8b 45 08             	mov    0x8(%ebp),%eax
  800a77:	ff d0                	call   *%eax
  800a79:	83 c4 10             	add    $0x10,%esp
			break;
  800a7c:	e9 9b 02 00 00       	jmp    800d1c <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a81:	8b 45 14             	mov    0x14(%ebp),%eax
  800a84:	83 c0 04             	add    $0x4,%eax
  800a87:	89 45 14             	mov    %eax,0x14(%ebp)
  800a8a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8d:	83 e8 04             	sub    $0x4,%eax
  800a90:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a92:	85 db                	test   %ebx,%ebx
  800a94:	79 02                	jns    800a98 <vprintfmt+0x14a>
				err = -err;
  800a96:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a98:	83 fb 64             	cmp    $0x64,%ebx
  800a9b:	7f 0b                	jg     800aa8 <vprintfmt+0x15a>
  800a9d:	8b 34 9d c0 47 80 00 	mov    0x8047c0(,%ebx,4),%esi
  800aa4:	85 f6                	test   %esi,%esi
  800aa6:	75 19                	jne    800ac1 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800aa8:	53                   	push   %ebx
  800aa9:	68 65 49 80 00       	push   $0x804965
  800aae:	ff 75 0c             	pushl  0xc(%ebp)
  800ab1:	ff 75 08             	pushl  0x8(%ebp)
  800ab4:	e8 70 02 00 00       	call   800d29 <printfmt>
  800ab9:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800abc:	e9 5b 02 00 00       	jmp    800d1c <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ac1:	56                   	push   %esi
  800ac2:	68 6e 49 80 00       	push   $0x80496e
  800ac7:	ff 75 0c             	pushl  0xc(%ebp)
  800aca:	ff 75 08             	pushl  0x8(%ebp)
  800acd:	e8 57 02 00 00       	call   800d29 <printfmt>
  800ad2:	83 c4 10             	add    $0x10,%esp
			break;
  800ad5:	e9 42 02 00 00       	jmp    800d1c <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ada:	8b 45 14             	mov    0x14(%ebp),%eax
  800add:	83 c0 04             	add    $0x4,%eax
  800ae0:	89 45 14             	mov    %eax,0x14(%ebp)
  800ae3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae6:	83 e8 04             	sub    $0x4,%eax
  800ae9:	8b 30                	mov    (%eax),%esi
  800aeb:	85 f6                	test   %esi,%esi
  800aed:	75 05                	jne    800af4 <vprintfmt+0x1a6>
				p = "(null)";
  800aef:	be 71 49 80 00       	mov    $0x804971,%esi
			if (width > 0 && padc != '-')
  800af4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800af8:	7e 6d                	jle    800b67 <vprintfmt+0x219>
  800afa:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800afe:	74 67                	je     800b67 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b00:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b03:	83 ec 08             	sub    $0x8,%esp
  800b06:	50                   	push   %eax
  800b07:	56                   	push   %esi
  800b08:	e8 1e 03 00 00       	call   800e2b <strnlen>
  800b0d:	83 c4 10             	add    $0x10,%esp
  800b10:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b13:	eb 16                	jmp    800b2b <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b15:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b19:	83 ec 08             	sub    $0x8,%esp
  800b1c:	ff 75 0c             	pushl  0xc(%ebp)
  800b1f:	50                   	push   %eax
  800b20:	8b 45 08             	mov    0x8(%ebp),%eax
  800b23:	ff d0                	call   *%eax
  800b25:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b28:	ff 4d e4             	decl   -0x1c(%ebp)
  800b2b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b2f:	7f e4                	jg     800b15 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b31:	eb 34                	jmp    800b67 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b33:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b37:	74 1c                	je     800b55 <vprintfmt+0x207>
  800b39:	83 fb 1f             	cmp    $0x1f,%ebx
  800b3c:	7e 05                	jle    800b43 <vprintfmt+0x1f5>
  800b3e:	83 fb 7e             	cmp    $0x7e,%ebx
  800b41:	7e 12                	jle    800b55 <vprintfmt+0x207>
					putch('?', putdat);
  800b43:	83 ec 08             	sub    $0x8,%esp
  800b46:	ff 75 0c             	pushl  0xc(%ebp)
  800b49:	6a 3f                	push   $0x3f
  800b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4e:	ff d0                	call   *%eax
  800b50:	83 c4 10             	add    $0x10,%esp
  800b53:	eb 0f                	jmp    800b64 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b55:	83 ec 08             	sub    $0x8,%esp
  800b58:	ff 75 0c             	pushl  0xc(%ebp)
  800b5b:	53                   	push   %ebx
  800b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5f:	ff d0                	call   *%eax
  800b61:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b64:	ff 4d e4             	decl   -0x1c(%ebp)
  800b67:	89 f0                	mov    %esi,%eax
  800b69:	8d 70 01             	lea    0x1(%eax),%esi
  800b6c:	8a 00                	mov    (%eax),%al
  800b6e:	0f be d8             	movsbl %al,%ebx
  800b71:	85 db                	test   %ebx,%ebx
  800b73:	74 24                	je     800b99 <vprintfmt+0x24b>
  800b75:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b79:	78 b8                	js     800b33 <vprintfmt+0x1e5>
  800b7b:	ff 4d e0             	decl   -0x20(%ebp)
  800b7e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b82:	79 af                	jns    800b33 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b84:	eb 13                	jmp    800b99 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b86:	83 ec 08             	sub    $0x8,%esp
  800b89:	ff 75 0c             	pushl  0xc(%ebp)
  800b8c:	6a 20                	push   $0x20
  800b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b91:	ff d0                	call   *%eax
  800b93:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b96:	ff 4d e4             	decl   -0x1c(%ebp)
  800b99:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b9d:	7f e7                	jg     800b86 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b9f:	e9 78 01 00 00       	jmp    800d1c <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ba4:	83 ec 08             	sub    $0x8,%esp
  800ba7:	ff 75 e8             	pushl  -0x18(%ebp)
  800baa:	8d 45 14             	lea    0x14(%ebp),%eax
  800bad:	50                   	push   %eax
  800bae:	e8 3c fd ff ff       	call   8008ef <getint>
  800bb3:	83 c4 10             	add    $0x10,%esp
  800bb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bc2:	85 d2                	test   %edx,%edx
  800bc4:	79 23                	jns    800be9 <vprintfmt+0x29b>
				putch('-', putdat);
  800bc6:	83 ec 08             	sub    $0x8,%esp
  800bc9:	ff 75 0c             	pushl  0xc(%ebp)
  800bcc:	6a 2d                	push   $0x2d
  800bce:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd1:	ff d0                	call   *%eax
  800bd3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bd9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bdc:	f7 d8                	neg    %eax
  800bde:	83 d2 00             	adc    $0x0,%edx
  800be1:	f7 da                	neg    %edx
  800be3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800be9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bf0:	e9 bc 00 00 00       	jmp    800cb1 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bf5:	83 ec 08             	sub    $0x8,%esp
  800bf8:	ff 75 e8             	pushl  -0x18(%ebp)
  800bfb:	8d 45 14             	lea    0x14(%ebp),%eax
  800bfe:	50                   	push   %eax
  800bff:	e8 84 fc ff ff       	call   800888 <getuint>
  800c04:	83 c4 10             	add    $0x10,%esp
  800c07:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c0a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c0d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c14:	e9 98 00 00 00       	jmp    800cb1 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c19:	83 ec 08             	sub    $0x8,%esp
  800c1c:	ff 75 0c             	pushl  0xc(%ebp)
  800c1f:	6a 58                	push   $0x58
  800c21:	8b 45 08             	mov    0x8(%ebp),%eax
  800c24:	ff d0                	call   *%eax
  800c26:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c29:	83 ec 08             	sub    $0x8,%esp
  800c2c:	ff 75 0c             	pushl  0xc(%ebp)
  800c2f:	6a 58                	push   $0x58
  800c31:	8b 45 08             	mov    0x8(%ebp),%eax
  800c34:	ff d0                	call   *%eax
  800c36:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c39:	83 ec 08             	sub    $0x8,%esp
  800c3c:	ff 75 0c             	pushl  0xc(%ebp)
  800c3f:	6a 58                	push   $0x58
  800c41:	8b 45 08             	mov    0x8(%ebp),%eax
  800c44:	ff d0                	call   *%eax
  800c46:	83 c4 10             	add    $0x10,%esp
			break;
  800c49:	e9 ce 00 00 00       	jmp    800d1c <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c4e:	83 ec 08             	sub    $0x8,%esp
  800c51:	ff 75 0c             	pushl  0xc(%ebp)
  800c54:	6a 30                	push   $0x30
  800c56:	8b 45 08             	mov    0x8(%ebp),%eax
  800c59:	ff d0                	call   *%eax
  800c5b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c5e:	83 ec 08             	sub    $0x8,%esp
  800c61:	ff 75 0c             	pushl  0xc(%ebp)
  800c64:	6a 78                	push   $0x78
  800c66:	8b 45 08             	mov    0x8(%ebp),%eax
  800c69:	ff d0                	call   *%eax
  800c6b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c6e:	8b 45 14             	mov    0x14(%ebp),%eax
  800c71:	83 c0 04             	add    $0x4,%eax
  800c74:	89 45 14             	mov    %eax,0x14(%ebp)
  800c77:	8b 45 14             	mov    0x14(%ebp),%eax
  800c7a:	83 e8 04             	sub    $0x4,%eax
  800c7d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c82:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c89:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c90:	eb 1f                	jmp    800cb1 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c92:	83 ec 08             	sub    $0x8,%esp
  800c95:	ff 75 e8             	pushl  -0x18(%ebp)
  800c98:	8d 45 14             	lea    0x14(%ebp),%eax
  800c9b:	50                   	push   %eax
  800c9c:	e8 e7 fb ff ff       	call   800888 <getuint>
  800ca1:	83 c4 10             	add    $0x10,%esp
  800ca4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800caa:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cb1:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cb8:	83 ec 04             	sub    $0x4,%esp
  800cbb:	52                   	push   %edx
  800cbc:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cbf:	50                   	push   %eax
  800cc0:	ff 75 f4             	pushl  -0xc(%ebp)
  800cc3:	ff 75 f0             	pushl  -0x10(%ebp)
  800cc6:	ff 75 0c             	pushl  0xc(%ebp)
  800cc9:	ff 75 08             	pushl  0x8(%ebp)
  800ccc:	e8 00 fb ff ff       	call   8007d1 <printnum>
  800cd1:	83 c4 20             	add    $0x20,%esp
			break;
  800cd4:	eb 46                	jmp    800d1c <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cd6:	83 ec 08             	sub    $0x8,%esp
  800cd9:	ff 75 0c             	pushl  0xc(%ebp)
  800cdc:	53                   	push   %ebx
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	ff d0                	call   *%eax
  800ce2:	83 c4 10             	add    $0x10,%esp
			break;
  800ce5:	eb 35                	jmp    800d1c <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800ce7:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
			break;
  800cee:	eb 2c                	jmp    800d1c <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800cf0:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
			break;
  800cf7:	eb 23                	jmp    800d1c <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cf9:	83 ec 08             	sub    $0x8,%esp
  800cfc:	ff 75 0c             	pushl  0xc(%ebp)
  800cff:	6a 25                	push   $0x25
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
  800d04:	ff d0                	call   *%eax
  800d06:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d09:	ff 4d 10             	decl   0x10(%ebp)
  800d0c:	eb 03                	jmp    800d11 <vprintfmt+0x3c3>
  800d0e:	ff 4d 10             	decl   0x10(%ebp)
  800d11:	8b 45 10             	mov    0x10(%ebp),%eax
  800d14:	48                   	dec    %eax
  800d15:	8a 00                	mov    (%eax),%al
  800d17:	3c 25                	cmp    $0x25,%al
  800d19:	75 f3                	jne    800d0e <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d1b:	90                   	nop
		}
	}
  800d1c:	e9 35 fc ff ff       	jmp    800956 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d21:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d22:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d25:	5b                   	pop    %ebx
  800d26:	5e                   	pop    %esi
  800d27:	5d                   	pop    %ebp
  800d28:	c3                   	ret    

00800d29 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d29:	55                   	push   %ebp
  800d2a:	89 e5                	mov    %esp,%ebp
  800d2c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d2f:	8d 45 10             	lea    0x10(%ebp),%eax
  800d32:	83 c0 04             	add    $0x4,%eax
  800d35:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d38:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3b:	ff 75 f4             	pushl  -0xc(%ebp)
  800d3e:	50                   	push   %eax
  800d3f:	ff 75 0c             	pushl  0xc(%ebp)
  800d42:	ff 75 08             	pushl  0x8(%ebp)
  800d45:	e8 04 fc ff ff       	call   80094e <vprintfmt>
  800d4a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d4d:	90                   	nop
  800d4e:	c9                   	leave  
  800d4f:	c3                   	ret    

00800d50 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d50:	55                   	push   %ebp
  800d51:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d56:	8b 40 08             	mov    0x8(%eax),%eax
  800d59:	8d 50 01             	lea    0x1(%eax),%edx
  800d5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d65:	8b 10                	mov    (%eax),%edx
  800d67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6a:	8b 40 04             	mov    0x4(%eax),%eax
  800d6d:	39 c2                	cmp    %eax,%edx
  800d6f:	73 12                	jae    800d83 <sprintputch+0x33>
		*b->buf++ = ch;
  800d71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d74:	8b 00                	mov    (%eax),%eax
  800d76:	8d 48 01             	lea    0x1(%eax),%ecx
  800d79:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d7c:	89 0a                	mov    %ecx,(%edx)
  800d7e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d81:	88 10                	mov    %dl,(%eax)
}
  800d83:	90                   	nop
  800d84:	5d                   	pop    %ebp
  800d85:	c3                   	ret    

00800d86 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d86:	55                   	push   %ebp
  800d87:	89 e5                	mov    %esp,%ebp
  800d89:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d95:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d98:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9b:	01 d0                	add    %edx,%eax
  800d9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800da0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800da7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dab:	74 06                	je     800db3 <vsnprintf+0x2d>
  800dad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800db1:	7f 07                	jg     800dba <vsnprintf+0x34>
		return -E_INVAL;
  800db3:	b8 03 00 00 00       	mov    $0x3,%eax
  800db8:	eb 20                	jmp    800dda <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dba:	ff 75 14             	pushl  0x14(%ebp)
  800dbd:	ff 75 10             	pushl  0x10(%ebp)
  800dc0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dc3:	50                   	push   %eax
  800dc4:	68 50 0d 80 00       	push   $0x800d50
  800dc9:	e8 80 fb ff ff       	call   80094e <vprintfmt>
  800dce:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dd4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dda:	c9                   	leave  
  800ddb:	c3                   	ret    

00800ddc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ddc:	55                   	push   %ebp
  800ddd:	89 e5                	mov    %esp,%ebp
  800ddf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800de2:	8d 45 10             	lea    0x10(%ebp),%eax
  800de5:	83 c0 04             	add    $0x4,%eax
  800de8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800deb:	8b 45 10             	mov    0x10(%ebp),%eax
  800dee:	ff 75 f4             	pushl  -0xc(%ebp)
  800df1:	50                   	push   %eax
  800df2:	ff 75 0c             	pushl  0xc(%ebp)
  800df5:	ff 75 08             	pushl  0x8(%ebp)
  800df8:	e8 89 ff ff ff       	call   800d86 <vsnprintf>
  800dfd:	83 c4 10             	add    $0x10,%esp
  800e00:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e03:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e06:	c9                   	leave  
  800e07:	c3                   	ret    

00800e08 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e08:	55                   	push   %ebp
  800e09:	89 e5                	mov    %esp,%ebp
  800e0b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e0e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e15:	eb 06                	jmp    800e1d <strlen+0x15>
		n++;
  800e17:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e1a:	ff 45 08             	incl   0x8(%ebp)
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	8a 00                	mov    (%eax),%al
  800e22:	84 c0                	test   %al,%al
  800e24:	75 f1                	jne    800e17 <strlen+0xf>
		n++;
	return n;
  800e26:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e29:	c9                   	leave  
  800e2a:	c3                   	ret    

00800e2b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e2b:	55                   	push   %ebp
  800e2c:	89 e5                	mov    %esp,%ebp
  800e2e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e31:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e38:	eb 09                	jmp    800e43 <strnlen+0x18>
		n++;
  800e3a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e3d:	ff 45 08             	incl   0x8(%ebp)
  800e40:	ff 4d 0c             	decl   0xc(%ebp)
  800e43:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e47:	74 09                	je     800e52 <strnlen+0x27>
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	8a 00                	mov    (%eax),%al
  800e4e:	84 c0                	test   %al,%al
  800e50:	75 e8                	jne    800e3a <strnlen+0xf>
		n++;
	return n;
  800e52:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e55:	c9                   	leave  
  800e56:	c3                   	ret    

00800e57 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e57:	55                   	push   %ebp
  800e58:	89 e5                	mov    %esp,%ebp
  800e5a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e60:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e63:	90                   	nop
  800e64:	8b 45 08             	mov    0x8(%ebp),%eax
  800e67:	8d 50 01             	lea    0x1(%eax),%edx
  800e6a:	89 55 08             	mov    %edx,0x8(%ebp)
  800e6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e70:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e73:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e76:	8a 12                	mov    (%edx),%dl
  800e78:	88 10                	mov    %dl,(%eax)
  800e7a:	8a 00                	mov    (%eax),%al
  800e7c:	84 c0                	test   %al,%al
  800e7e:	75 e4                	jne    800e64 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e80:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e83:	c9                   	leave  
  800e84:	c3                   	ret    

00800e85 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e85:	55                   	push   %ebp
  800e86:	89 e5                	mov    %esp,%ebp
  800e88:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e91:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e98:	eb 1f                	jmp    800eb9 <strncpy+0x34>
		*dst++ = *src;
  800e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9d:	8d 50 01             	lea    0x1(%eax),%edx
  800ea0:	89 55 08             	mov    %edx,0x8(%ebp)
  800ea3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea6:	8a 12                	mov    (%edx),%dl
  800ea8:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800eaa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ead:	8a 00                	mov    (%eax),%al
  800eaf:	84 c0                	test   %al,%al
  800eb1:	74 03                	je     800eb6 <strncpy+0x31>
			src++;
  800eb3:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800eb6:	ff 45 fc             	incl   -0x4(%ebp)
  800eb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ebc:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ebf:	72 d9                	jb     800e9a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ec1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ec4:	c9                   	leave  
  800ec5:	c3                   	ret    

00800ec6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ec6:	55                   	push   %ebp
  800ec7:	89 e5                	mov    %esp,%ebp
  800ec9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ed2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed6:	74 30                	je     800f08 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ed8:	eb 16                	jmp    800ef0 <strlcpy+0x2a>
			*dst++ = *src++;
  800eda:	8b 45 08             	mov    0x8(%ebp),%eax
  800edd:	8d 50 01             	lea    0x1(%eax),%edx
  800ee0:	89 55 08             	mov    %edx,0x8(%ebp)
  800ee3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ee6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ee9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800eec:	8a 12                	mov    (%edx),%dl
  800eee:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ef0:	ff 4d 10             	decl   0x10(%ebp)
  800ef3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef7:	74 09                	je     800f02 <strlcpy+0x3c>
  800ef9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efc:	8a 00                	mov    (%eax),%al
  800efe:	84 c0                	test   %al,%al
  800f00:	75 d8                	jne    800eda <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
  800f05:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f08:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0e:	29 c2                	sub    %eax,%edx
  800f10:	89 d0                	mov    %edx,%eax
}
  800f12:	c9                   	leave  
  800f13:	c3                   	ret    

00800f14 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f14:	55                   	push   %ebp
  800f15:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f17:	eb 06                	jmp    800f1f <strcmp+0xb>
		p++, q++;
  800f19:	ff 45 08             	incl   0x8(%ebp)
  800f1c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f22:	8a 00                	mov    (%eax),%al
  800f24:	84 c0                	test   %al,%al
  800f26:	74 0e                	je     800f36 <strcmp+0x22>
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2b:	8a 10                	mov    (%eax),%dl
  800f2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f30:	8a 00                	mov    (%eax),%al
  800f32:	38 c2                	cmp    %al,%dl
  800f34:	74 e3                	je     800f19 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f36:	8b 45 08             	mov    0x8(%ebp),%eax
  800f39:	8a 00                	mov    (%eax),%al
  800f3b:	0f b6 d0             	movzbl %al,%edx
  800f3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f41:	8a 00                	mov    (%eax),%al
  800f43:	0f b6 c0             	movzbl %al,%eax
  800f46:	29 c2                	sub    %eax,%edx
  800f48:	89 d0                	mov    %edx,%eax
}
  800f4a:	5d                   	pop    %ebp
  800f4b:	c3                   	ret    

00800f4c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f4c:	55                   	push   %ebp
  800f4d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f4f:	eb 09                	jmp    800f5a <strncmp+0xe>
		n--, p++, q++;
  800f51:	ff 4d 10             	decl   0x10(%ebp)
  800f54:	ff 45 08             	incl   0x8(%ebp)
  800f57:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f5a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f5e:	74 17                	je     800f77 <strncmp+0x2b>
  800f60:	8b 45 08             	mov    0x8(%ebp),%eax
  800f63:	8a 00                	mov    (%eax),%al
  800f65:	84 c0                	test   %al,%al
  800f67:	74 0e                	je     800f77 <strncmp+0x2b>
  800f69:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6c:	8a 10                	mov    (%eax),%dl
  800f6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f71:	8a 00                	mov    (%eax),%al
  800f73:	38 c2                	cmp    %al,%dl
  800f75:	74 da                	je     800f51 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f77:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7b:	75 07                	jne    800f84 <strncmp+0x38>
		return 0;
  800f7d:	b8 00 00 00 00       	mov    $0x0,%eax
  800f82:	eb 14                	jmp    800f98 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f84:	8b 45 08             	mov    0x8(%ebp),%eax
  800f87:	8a 00                	mov    (%eax),%al
  800f89:	0f b6 d0             	movzbl %al,%edx
  800f8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8f:	8a 00                	mov    (%eax),%al
  800f91:	0f b6 c0             	movzbl %al,%eax
  800f94:	29 c2                	sub    %eax,%edx
  800f96:	89 d0                	mov    %edx,%eax
}
  800f98:	5d                   	pop    %ebp
  800f99:	c3                   	ret    

00800f9a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f9a:	55                   	push   %ebp
  800f9b:	89 e5                	mov    %esp,%ebp
  800f9d:	83 ec 04             	sub    $0x4,%esp
  800fa0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fa6:	eb 12                	jmp    800fba <strchr+0x20>
		if (*s == c)
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fab:	8a 00                	mov    (%eax),%al
  800fad:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fb0:	75 05                	jne    800fb7 <strchr+0x1d>
			return (char *) s;
  800fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb5:	eb 11                	jmp    800fc8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fb7:	ff 45 08             	incl   0x8(%ebp)
  800fba:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbd:	8a 00                	mov    (%eax),%al
  800fbf:	84 c0                	test   %al,%al
  800fc1:	75 e5                	jne    800fa8 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fc3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fc8:	c9                   	leave  
  800fc9:	c3                   	ret    

00800fca <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fca:	55                   	push   %ebp
  800fcb:	89 e5                	mov    %esp,%ebp
  800fcd:	83 ec 04             	sub    $0x4,%esp
  800fd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fd6:	eb 0d                	jmp    800fe5 <strfind+0x1b>
		if (*s == c)
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	8a 00                	mov    (%eax),%al
  800fdd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fe0:	74 0e                	je     800ff0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fe2:	ff 45 08             	incl   0x8(%ebp)
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	8a 00                	mov    (%eax),%al
  800fea:	84 c0                	test   %al,%al
  800fec:	75 ea                	jne    800fd8 <strfind+0xe>
  800fee:	eb 01                	jmp    800ff1 <strfind+0x27>
		if (*s == c)
			break;
  800ff0:	90                   	nop
	return (char *) s;
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ff4:	c9                   	leave  
  800ff5:	c3                   	ret    

00800ff6 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800ff6:	55                   	push   %ebp
  800ff7:	89 e5                	mov    %esp,%ebp
  800ff9:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801002:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801006:	76 63                	jbe    80106b <memset+0x75>
		uint64 data_block = c;
  801008:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100b:	99                   	cltd   
  80100c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80100f:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801012:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801015:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801018:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80101c:	c1 e0 08             	shl    $0x8,%eax
  80101f:	09 45 f0             	or     %eax,-0x10(%ebp)
  801022:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801025:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801028:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80102b:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80102f:	c1 e0 10             	shl    $0x10,%eax
  801032:	09 45 f0             	or     %eax,-0x10(%ebp)
  801035:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801038:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80103b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80103e:	89 c2                	mov    %eax,%edx
  801040:	b8 00 00 00 00       	mov    $0x0,%eax
  801045:	09 45 f0             	or     %eax,-0x10(%ebp)
  801048:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80104b:	eb 18                	jmp    801065 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80104d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801050:	8d 41 08             	lea    0x8(%ecx),%eax
  801053:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801056:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801059:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80105c:	89 01                	mov    %eax,(%ecx)
  80105e:	89 51 04             	mov    %edx,0x4(%ecx)
  801061:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801065:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801069:	77 e2                	ja     80104d <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80106b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80106f:	74 23                	je     801094 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801071:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801074:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801077:	eb 0e                	jmp    801087 <memset+0x91>
			*p8++ = (uint8)c;
  801079:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80107c:	8d 50 01             	lea    0x1(%eax),%edx
  80107f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801082:	8b 55 0c             	mov    0xc(%ebp),%edx
  801085:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801087:	8b 45 10             	mov    0x10(%ebp),%eax
  80108a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80108d:	89 55 10             	mov    %edx,0x10(%ebp)
  801090:	85 c0                	test   %eax,%eax
  801092:	75 e5                	jne    801079 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801094:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801097:	c9                   	leave  
  801098:	c3                   	ret    

00801099 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801099:	55                   	push   %ebp
  80109a:	89 e5                	mov    %esp,%ebp
  80109c:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80109f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8010ab:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010af:	76 24                	jbe    8010d5 <memcpy+0x3c>
		while(n >= 8){
  8010b1:	eb 1c                	jmp    8010cf <memcpy+0x36>
			*d64 = *s64;
  8010b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010b6:	8b 50 04             	mov    0x4(%eax),%edx
  8010b9:	8b 00                	mov    (%eax),%eax
  8010bb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010be:	89 01                	mov    %eax,(%ecx)
  8010c0:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8010c3:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8010c7:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8010cb:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8010cf:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010d3:	77 de                	ja     8010b3 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8010d5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d9:	74 31                	je     80110c <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8010db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010de:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8010e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8010e7:	eb 16                	jmp    8010ff <memcpy+0x66>
			*d8++ = *s8++;
  8010e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010ec:	8d 50 01             	lea    0x1(%eax),%edx
  8010ef:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8010f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010f5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010f8:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8010fb:	8a 12                	mov    (%edx),%dl
  8010fd:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8010ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801102:	8d 50 ff             	lea    -0x1(%eax),%edx
  801105:	89 55 10             	mov    %edx,0x10(%ebp)
  801108:	85 c0                	test   %eax,%eax
  80110a:	75 dd                	jne    8010e9 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80110c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80110f:	c9                   	leave  
  801110:	c3                   	ret    

00801111 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801111:	55                   	push   %ebp
  801112:	89 e5                	mov    %esp,%ebp
  801114:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801117:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80111d:	8b 45 08             	mov    0x8(%ebp),%eax
  801120:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801123:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801126:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801129:	73 50                	jae    80117b <memmove+0x6a>
  80112b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80112e:	8b 45 10             	mov    0x10(%ebp),%eax
  801131:	01 d0                	add    %edx,%eax
  801133:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801136:	76 43                	jbe    80117b <memmove+0x6a>
		s += n;
  801138:	8b 45 10             	mov    0x10(%ebp),%eax
  80113b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80113e:	8b 45 10             	mov    0x10(%ebp),%eax
  801141:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801144:	eb 10                	jmp    801156 <memmove+0x45>
			*--d = *--s;
  801146:	ff 4d f8             	decl   -0x8(%ebp)
  801149:	ff 4d fc             	decl   -0x4(%ebp)
  80114c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80114f:	8a 10                	mov    (%eax),%dl
  801151:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801154:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801156:	8b 45 10             	mov    0x10(%ebp),%eax
  801159:	8d 50 ff             	lea    -0x1(%eax),%edx
  80115c:	89 55 10             	mov    %edx,0x10(%ebp)
  80115f:	85 c0                	test   %eax,%eax
  801161:	75 e3                	jne    801146 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801163:	eb 23                	jmp    801188 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801165:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801168:	8d 50 01             	lea    0x1(%eax),%edx
  80116b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80116e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801171:	8d 4a 01             	lea    0x1(%edx),%ecx
  801174:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801177:	8a 12                	mov    (%edx),%dl
  801179:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80117b:	8b 45 10             	mov    0x10(%ebp),%eax
  80117e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801181:	89 55 10             	mov    %edx,0x10(%ebp)
  801184:	85 c0                	test   %eax,%eax
  801186:	75 dd                	jne    801165 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801188:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80118b:	c9                   	leave  
  80118c:	c3                   	ret    

0080118d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80118d:	55                   	push   %ebp
  80118e:	89 e5                	mov    %esp,%ebp
  801190:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801199:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80119f:	eb 2a                	jmp    8011cb <memcmp+0x3e>
		if (*s1 != *s2)
  8011a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a4:	8a 10                	mov    (%eax),%dl
  8011a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a9:	8a 00                	mov    (%eax),%al
  8011ab:	38 c2                	cmp    %al,%dl
  8011ad:	74 16                	je     8011c5 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011b2:	8a 00                	mov    (%eax),%al
  8011b4:	0f b6 d0             	movzbl %al,%edx
  8011b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ba:	8a 00                	mov    (%eax),%al
  8011bc:	0f b6 c0             	movzbl %al,%eax
  8011bf:	29 c2                	sub    %eax,%edx
  8011c1:	89 d0                	mov    %edx,%eax
  8011c3:	eb 18                	jmp    8011dd <memcmp+0x50>
		s1++, s2++;
  8011c5:	ff 45 fc             	incl   -0x4(%ebp)
  8011c8:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ce:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011d1:	89 55 10             	mov    %edx,0x10(%ebp)
  8011d4:	85 c0                	test   %eax,%eax
  8011d6:	75 c9                	jne    8011a1 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011dd:	c9                   	leave  
  8011de:	c3                   	ret    

008011df <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011df:	55                   	push   %ebp
  8011e0:	89 e5                	mov    %esp,%ebp
  8011e2:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8011eb:	01 d0                	add    %edx,%eax
  8011ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011f0:	eb 15                	jmp    801207 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f5:	8a 00                	mov    (%eax),%al
  8011f7:	0f b6 d0             	movzbl %al,%edx
  8011fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fd:	0f b6 c0             	movzbl %al,%eax
  801200:	39 c2                	cmp    %eax,%edx
  801202:	74 0d                	je     801211 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801204:	ff 45 08             	incl   0x8(%ebp)
  801207:	8b 45 08             	mov    0x8(%ebp),%eax
  80120a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80120d:	72 e3                	jb     8011f2 <memfind+0x13>
  80120f:	eb 01                	jmp    801212 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801211:	90                   	nop
	return (void *) s;
  801212:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801215:	c9                   	leave  
  801216:	c3                   	ret    

00801217 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801217:	55                   	push   %ebp
  801218:	89 e5                	mov    %esp,%ebp
  80121a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80121d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801224:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80122b:	eb 03                	jmp    801230 <strtol+0x19>
		s++;
  80122d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801230:	8b 45 08             	mov    0x8(%ebp),%eax
  801233:	8a 00                	mov    (%eax),%al
  801235:	3c 20                	cmp    $0x20,%al
  801237:	74 f4                	je     80122d <strtol+0x16>
  801239:	8b 45 08             	mov    0x8(%ebp),%eax
  80123c:	8a 00                	mov    (%eax),%al
  80123e:	3c 09                	cmp    $0x9,%al
  801240:	74 eb                	je     80122d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801242:	8b 45 08             	mov    0x8(%ebp),%eax
  801245:	8a 00                	mov    (%eax),%al
  801247:	3c 2b                	cmp    $0x2b,%al
  801249:	75 05                	jne    801250 <strtol+0x39>
		s++;
  80124b:	ff 45 08             	incl   0x8(%ebp)
  80124e:	eb 13                	jmp    801263 <strtol+0x4c>
	else if (*s == '-')
  801250:	8b 45 08             	mov    0x8(%ebp),%eax
  801253:	8a 00                	mov    (%eax),%al
  801255:	3c 2d                	cmp    $0x2d,%al
  801257:	75 0a                	jne    801263 <strtol+0x4c>
		s++, neg = 1;
  801259:	ff 45 08             	incl   0x8(%ebp)
  80125c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801263:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801267:	74 06                	je     80126f <strtol+0x58>
  801269:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80126d:	75 20                	jne    80128f <strtol+0x78>
  80126f:	8b 45 08             	mov    0x8(%ebp),%eax
  801272:	8a 00                	mov    (%eax),%al
  801274:	3c 30                	cmp    $0x30,%al
  801276:	75 17                	jne    80128f <strtol+0x78>
  801278:	8b 45 08             	mov    0x8(%ebp),%eax
  80127b:	40                   	inc    %eax
  80127c:	8a 00                	mov    (%eax),%al
  80127e:	3c 78                	cmp    $0x78,%al
  801280:	75 0d                	jne    80128f <strtol+0x78>
		s += 2, base = 16;
  801282:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801286:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80128d:	eb 28                	jmp    8012b7 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80128f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801293:	75 15                	jne    8012aa <strtol+0x93>
  801295:	8b 45 08             	mov    0x8(%ebp),%eax
  801298:	8a 00                	mov    (%eax),%al
  80129a:	3c 30                	cmp    $0x30,%al
  80129c:	75 0c                	jne    8012aa <strtol+0x93>
		s++, base = 8;
  80129e:	ff 45 08             	incl   0x8(%ebp)
  8012a1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012a8:	eb 0d                	jmp    8012b7 <strtol+0xa0>
	else if (base == 0)
  8012aa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012ae:	75 07                	jne    8012b7 <strtol+0xa0>
		base = 10;
  8012b0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ba:	8a 00                	mov    (%eax),%al
  8012bc:	3c 2f                	cmp    $0x2f,%al
  8012be:	7e 19                	jle    8012d9 <strtol+0xc2>
  8012c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c3:	8a 00                	mov    (%eax),%al
  8012c5:	3c 39                	cmp    $0x39,%al
  8012c7:	7f 10                	jg     8012d9 <strtol+0xc2>
			dig = *s - '0';
  8012c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cc:	8a 00                	mov    (%eax),%al
  8012ce:	0f be c0             	movsbl %al,%eax
  8012d1:	83 e8 30             	sub    $0x30,%eax
  8012d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012d7:	eb 42                	jmp    80131b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dc:	8a 00                	mov    (%eax),%al
  8012de:	3c 60                	cmp    $0x60,%al
  8012e0:	7e 19                	jle    8012fb <strtol+0xe4>
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	8a 00                	mov    (%eax),%al
  8012e7:	3c 7a                	cmp    $0x7a,%al
  8012e9:	7f 10                	jg     8012fb <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ee:	8a 00                	mov    (%eax),%al
  8012f0:	0f be c0             	movsbl %al,%eax
  8012f3:	83 e8 57             	sub    $0x57,%eax
  8012f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012f9:	eb 20                	jmp    80131b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	8a 00                	mov    (%eax),%al
  801300:	3c 40                	cmp    $0x40,%al
  801302:	7e 39                	jle    80133d <strtol+0x126>
  801304:	8b 45 08             	mov    0x8(%ebp),%eax
  801307:	8a 00                	mov    (%eax),%al
  801309:	3c 5a                	cmp    $0x5a,%al
  80130b:	7f 30                	jg     80133d <strtol+0x126>
			dig = *s - 'A' + 10;
  80130d:	8b 45 08             	mov    0x8(%ebp),%eax
  801310:	8a 00                	mov    (%eax),%al
  801312:	0f be c0             	movsbl %al,%eax
  801315:	83 e8 37             	sub    $0x37,%eax
  801318:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80131b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80131e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801321:	7d 19                	jge    80133c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801323:	ff 45 08             	incl   0x8(%ebp)
  801326:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801329:	0f af 45 10          	imul   0x10(%ebp),%eax
  80132d:	89 c2                	mov    %eax,%edx
  80132f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801332:	01 d0                	add    %edx,%eax
  801334:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801337:	e9 7b ff ff ff       	jmp    8012b7 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80133c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80133d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801341:	74 08                	je     80134b <strtol+0x134>
		*endptr = (char *) s;
  801343:	8b 45 0c             	mov    0xc(%ebp),%eax
  801346:	8b 55 08             	mov    0x8(%ebp),%edx
  801349:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80134b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80134f:	74 07                	je     801358 <strtol+0x141>
  801351:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801354:	f7 d8                	neg    %eax
  801356:	eb 03                	jmp    80135b <strtol+0x144>
  801358:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80135b:	c9                   	leave  
  80135c:	c3                   	ret    

0080135d <ltostr>:

void
ltostr(long value, char *str)
{
  80135d:	55                   	push   %ebp
  80135e:	89 e5                	mov    %esp,%ebp
  801360:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801363:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80136a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801371:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801375:	79 13                	jns    80138a <ltostr+0x2d>
	{
		neg = 1;
  801377:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80137e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801381:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801384:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801387:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80138a:	8b 45 08             	mov    0x8(%ebp),%eax
  80138d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801392:	99                   	cltd   
  801393:	f7 f9                	idiv   %ecx
  801395:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801398:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80139b:	8d 50 01             	lea    0x1(%eax),%edx
  80139e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013a1:	89 c2                	mov    %eax,%edx
  8013a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a6:	01 d0                	add    %edx,%eax
  8013a8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013ab:	83 c2 30             	add    $0x30,%edx
  8013ae:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013b3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013b8:	f7 e9                	imul   %ecx
  8013ba:	c1 fa 02             	sar    $0x2,%edx
  8013bd:	89 c8                	mov    %ecx,%eax
  8013bf:	c1 f8 1f             	sar    $0x1f,%eax
  8013c2:	29 c2                	sub    %eax,%edx
  8013c4:	89 d0                	mov    %edx,%eax
  8013c6:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013cd:	75 bb                	jne    80138a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013d9:	48                   	dec    %eax
  8013da:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013e1:	74 3d                	je     801420 <ltostr+0xc3>
		start = 1 ;
  8013e3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013ea:	eb 34                	jmp    801420 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8013ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f2:	01 d0                	add    %edx,%eax
  8013f4:	8a 00                	mov    (%eax),%al
  8013f6:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ff:	01 c2                	add    %eax,%edx
  801401:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801404:	8b 45 0c             	mov    0xc(%ebp),%eax
  801407:	01 c8                	add    %ecx,%eax
  801409:	8a 00                	mov    (%eax),%al
  80140b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80140d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801410:	8b 45 0c             	mov    0xc(%ebp),%eax
  801413:	01 c2                	add    %eax,%edx
  801415:	8a 45 eb             	mov    -0x15(%ebp),%al
  801418:	88 02                	mov    %al,(%edx)
		start++ ;
  80141a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80141d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801420:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801423:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801426:	7c c4                	jl     8013ec <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801428:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80142b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142e:	01 d0                	add    %edx,%eax
  801430:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801433:	90                   	nop
  801434:	c9                   	leave  
  801435:	c3                   	ret    

00801436 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801436:	55                   	push   %ebp
  801437:	89 e5                	mov    %esp,%ebp
  801439:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80143c:	ff 75 08             	pushl  0x8(%ebp)
  80143f:	e8 c4 f9 ff ff       	call   800e08 <strlen>
  801444:	83 c4 04             	add    $0x4,%esp
  801447:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80144a:	ff 75 0c             	pushl  0xc(%ebp)
  80144d:	e8 b6 f9 ff ff       	call   800e08 <strlen>
  801452:	83 c4 04             	add    $0x4,%esp
  801455:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801458:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80145f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801466:	eb 17                	jmp    80147f <strcconcat+0x49>
		final[s] = str1[s] ;
  801468:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80146b:	8b 45 10             	mov    0x10(%ebp),%eax
  80146e:	01 c2                	add    %eax,%edx
  801470:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801473:	8b 45 08             	mov    0x8(%ebp),%eax
  801476:	01 c8                	add    %ecx,%eax
  801478:	8a 00                	mov    (%eax),%al
  80147a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80147c:	ff 45 fc             	incl   -0x4(%ebp)
  80147f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801482:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801485:	7c e1                	jl     801468 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801487:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80148e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801495:	eb 1f                	jmp    8014b6 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801497:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80149a:	8d 50 01             	lea    0x1(%eax),%edx
  80149d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014a0:	89 c2                	mov    %eax,%edx
  8014a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a5:	01 c2                	add    %eax,%edx
  8014a7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ad:	01 c8                	add    %ecx,%eax
  8014af:	8a 00                	mov    (%eax),%al
  8014b1:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014b3:	ff 45 f8             	incl   -0x8(%ebp)
  8014b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014b9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014bc:	7c d9                	jl     801497 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014be:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c4:	01 d0                	add    %edx,%eax
  8014c6:	c6 00 00             	movb   $0x0,(%eax)
}
  8014c9:	90                   	nop
  8014ca:	c9                   	leave  
  8014cb:	c3                   	ret    

008014cc <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014cc:	55                   	push   %ebp
  8014cd:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8014d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8014db:	8b 00                	mov    (%eax),%eax
  8014dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e7:	01 d0                	add    %edx,%eax
  8014e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014ef:	eb 0c                	jmp    8014fd <strsplit+0x31>
			*string++ = 0;
  8014f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f4:	8d 50 01             	lea    0x1(%eax),%edx
  8014f7:	89 55 08             	mov    %edx,0x8(%ebp)
  8014fa:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801500:	8a 00                	mov    (%eax),%al
  801502:	84 c0                	test   %al,%al
  801504:	74 18                	je     80151e <strsplit+0x52>
  801506:	8b 45 08             	mov    0x8(%ebp),%eax
  801509:	8a 00                	mov    (%eax),%al
  80150b:	0f be c0             	movsbl %al,%eax
  80150e:	50                   	push   %eax
  80150f:	ff 75 0c             	pushl  0xc(%ebp)
  801512:	e8 83 fa ff ff       	call   800f9a <strchr>
  801517:	83 c4 08             	add    $0x8,%esp
  80151a:	85 c0                	test   %eax,%eax
  80151c:	75 d3                	jne    8014f1 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80151e:	8b 45 08             	mov    0x8(%ebp),%eax
  801521:	8a 00                	mov    (%eax),%al
  801523:	84 c0                	test   %al,%al
  801525:	74 5a                	je     801581 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801527:	8b 45 14             	mov    0x14(%ebp),%eax
  80152a:	8b 00                	mov    (%eax),%eax
  80152c:	83 f8 0f             	cmp    $0xf,%eax
  80152f:	75 07                	jne    801538 <strsplit+0x6c>
		{
			return 0;
  801531:	b8 00 00 00 00       	mov    $0x0,%eax
  801536:	eb 66                	jmp    80159e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801538:	8b 45 14             	mov    0x14(%ebp),%eax
  80153b:	8b 00                	mov    (%eax),%eax
  80153d:	8d 48 01             	lea    0x1(%eax),%ecx
  801540:	8b 55 14             	mov    0x14(%ebp),%edx
  801543:	89 0a                	mov    %ecx,(%edx)
  801545:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80154c:	8b 45 10             	mov    0x10(%ebp),%eax
  80154f:	01 c2                	add    %eax,%edx
  801551:	8b 45 08             	mov    0x8(%ebp),%eax
  801554:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801556:	eb 03                	jmp    80155b <strsplit+0x8f>
			string++;
  801558:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80155b:	8b 45 08             	mov    0x8(%ebp),%eax
  80155e:	8a 00                	mov    (%eax),%al
  801560:	84 c0                	test   %al,%al
  801562:	74 8b                	je     8014ef <strsplit+0x23>
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	8a 00                	mov    (%eax),%al
  801569:	0f be c0             	movsbl %al,%eax
  80156c:	50                   	push   %eax
  80156d:	ff 75 0c             	pushl  0xc(%ebp)
  801570:	e8 25 fa ff ff       	call   800f9a <strchr>
  801575:	83 c4 08             	add    $0x8,%esp
  801578:	85 c0                	test   %eax,%eax
  80157a:	74 dc                	je     801558 <strsplit+0x8c>
			string++;
	}
  80157c:	e9 6e ff ff ff       	jmp    8014ef <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801581:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801582:	8b 45 14             	mov    0x14(%ebp),%eax
  801585:	8b 00                	mov    (%eax),%eax
  801587:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80158e:	8b 45 10             	mov    0x10(%ebp),%eax
  801591:	01 d0                	add    %edx,%eax
  801593:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801599:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80159e:	c9                   	leave  
  80159f:	c3                   	ret    

008015a0 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
  8015a3:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8015a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8015ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015b3:	eb 4a                	jmp    8015ff <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8015b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bb:	01 c2                	add    %eax,%edx
  8015bd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c3:	01 c8                	add    %ecx,%eax
  8015c5:	8a 00                	mov    (%eax),%al
  8015c7:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8015c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015cf:	01 d0                	add    %edx,%eax
  8015d1:	8a 00                	mov    (%eax),%al
  8015d3:	3c 40                	cmp    $0x40,%al
  8015d5:	7e 25                	jle    8015fc <str2lower+0x5c>
  8015d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015dd:	01 d0                	add    %edx,%eax
  8015df:	8a 00                	mov    (%eax),%al
  8015e1:	3c 5a                	cmp    $0x5a,%al
  8015e3:	7f 17                	jg     8015fc <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8015e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015eb:	01 d0                	add    %edx,%eax
  8015ed:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8015f3:	01 ca                	add    %ecx,%edx
  8015f5:	8a 12                	mov    (%edx),%dl
  8015f7:	83 c2 20             	add    $0x20,%edx
  8015fa:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8015fc:	ff 45 fc             	incl   -0x4(%ebp)
  8015ff:	ff 75 0c             	pushl  0xc(%ebp)
  801602:	e8 01 f8 ff ff       	call   800e08 <strlen>
  801607:	83 c4 04             	add    $0x4,%esp
  80160a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80160d:	7f a6                	jg     8015b5 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80160f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801612:	c9                   	leave  
  801613:	c3                   	ret    

00801614 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801614:	55                   	push   %ebp
  801615:	89 e5                	mov    %esp,%ebp
  801617:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  80161a:	a1 08 50 80 00       	mov    0x805008,%eax
  80161f:	85 c0                	test   %eax,%eax
  801621:	74 42                	je     801665 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801623:	83 ec 08             	sub    $0x8,%esp
  801626:	68 00 00 00 82       	push   $0x82000000
  80162b:	68 00 00 00 80       	push   $0x80000000
  801630:	e8 b0 1e 00 00       	call   8034e5 <initialize_dynamic_allocator>
  801635:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801638:	e8 96 1c 00 00       	call   8032d3 <sys_get_uheap_strategy>
  80163d:	a3 80 50 83 00       	mov    %eax,0x835080
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801642:	a1 60 d0 81 00       	mov    0x81d060,%eax
  801647:	05 00 10 00 00       	add    $0x1000,%eax
  80164c:	a3 30 51 83 00       	mov    %eax,0x835130
		uheapPageAllocBreak = uheapPageAllocStart;
  801651:	a1 30 51 83 00       	mov    0x835130,%eax
  801656:	a3 88 50 83 00       	mov    %eax,0x835088

		__firstTimeFlag = 0;
  80165b:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  801662:	00 00 00 
	}
}
  801665:	90                   	nop
  801666:	c9                   	leave  
  801667:	c3                   	ret    

00801668 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801668:	55                   	push   %ebp
  801669:	89 e5                	mov    %esp,%ebp
  80166b:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  80166e:	8b 45 08             	mov    0x8(%ebp),%eax
  801671:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801677:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80167c:	83 ec 08             	sub    $0x8,%esp
  80167f:	68 06 04 00 00       	push   $0x406
  801684:	50                   	push   %eax
  801685:	e8 93 18 00 00       	call   802f1d <__sys_allocate_page>
  80168a:	83 c4 10             	add    $0x10,%esp
  80168d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801690:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801694:	79 14                	jns    8016aa <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801696:	83 ec 04             	sub    $0x4,%esp
  801699:	68 e8 4a 80 00       	push   $0x804ae8
  80169e:	6a 1f                	push   $0x1f
  8016a0:	68 24 4b 80 00       	push   $0x804b24
  8016a5:	e8 b7 ed ff ff       	call   800461 <_panic>
	return 0;
  8016aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016af:	c9                   	leave  
  8016b0:	c3                   	ret    

008016b1 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8016b1:	55                   	push   %ebp
  8016b2:	89 e5                	mov    %esp,%ebp
  8016b4:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8016b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016c5:	83 ec 0c             	sub    $0xc,%esp
  8016c8:	50                   	push   %eax
  8016c9:	e8 96 18 00 00       	call   802f64 <__sys_unmap_frame>
  8016ce:	83 c4 10             	add    $0x10,%esp
  8016d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8016d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016d8:	79 14                	jns    8016ee <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8016da:	83 ec 04             	sub    $0x4,%esp
  8016dd:	68 30 4b 80 00       	push   $0x804b30
  8016e2:	6a 2a                	push   $0x2a
  8016e4:	68 24 4b 80 00       	push   $0x804b24
  8016e9:	e8 73 ed ff ff       	call   800461 <_panic>
}
  8016ee:	90                   	nop
  8016ef:	c9                   	leave  
  8016f0:	c3                   	ret    

008016f1 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8016f1:	55                   	push   %ebp
  8016f2:	89 e5                	mov    %esp,%ebp
  8016f4:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8016f7:	e8 18 ff ff ff       	call   801614 <uheap_init>
	if (size == 0) return NULL ;
  8016fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801700:	75 0a                	jne    80170c <malloc+0x1b>
  801702:	b8 00 00 00 00       	mov    $0x0,%eax
  801707:	e9 43 03 00 00       	jmp    801a4f <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  80170c:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801713:	77 13                	ja     801728 <malloc+0x37>
    {
        return alloc_block(size);
  801715:	83 ec 0c             	sub    $0xc,%esp
  801718:	ff 75 08             	pushl  0x8(%ebp)
  80171b:	e8 78 20 00 00       	call   803798 <alloc_block>
  801720:	83 c4 10             	add    $0x10,%esp
  801723:	e9 27 03 00 00       	jmp    801a4f <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801728:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  80172f:	8b 55 08             	mov    0x8(%ebp),%edx
  801732:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801735:	01 d0                	add    %edx,%eax
  801737:	48                   	dec    %eax
  801738:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80173b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80173e:	ba 00 00 00 00       	mov    $0x0,%edx
  801743:	f7 75 dc             	divl   -0x24(%ebp)
  801746:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801749:	29 d0                	sub    %edx,%eax
  80174b:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  80174e:	a1 40 d0 81 00       	mov    0x81d040,%eax
  801753:	85 c0                	test   %eax,%eax
  801755:	75 0a                	jne    801761 <malloc+0x70>
    {
        uhp_inited = 1;
  801757:	c7 05 40 d0 81 00 01 	movl   $0x1,0x81d040
  80175e:	00 00 00 
    }

    int exactIdx = -1;
  801761:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801768:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  80176f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801776:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80177d:	e9 85 00 00 00       	jmp    801807 <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801782:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801785:	89 d0                	mov    %edx,%eax
  801787:	01 c0                	add    %eax,%eax
  801789:	01 d0                	add    %edx,%eax
  80178b:	c1 e0 02             	shl    $0x2,%eax
  80178e:	05 48 10 81 00       	add    $0x811048,%eax
  801793:	8a 00                	mov    (%eax),%al
  801795:	84 c0                	test   %al,%al
  801797:	74 20                	je     8017b9 <malloc+0xc8>
  801799:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80179c:	89 d0                	mov    %edx,%eax
  80179e:	01 c0                	add    %eax,%eax
  8017a0:	01 d0                	add    %edx,%eax
  8017a2:	c1 e0 02             	shl    $0x2,%eax
  8017a5:	05 44 10 81 00       	add    $0x811044,%eax
  8017aa:	8b 00                	mov    (%eax),%eax
  8017ac:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8017af:	75 08                	jne    8017b9 <malloc+0xc8>
        {
            exactIdx = i;
  8017b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  8017b7:	eb 5b                	jmp    801814 <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  8017b9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017bc:	89 d0                	mov    %edx,%eax
  8017be:	01 c0                	add    %eax,%eax
  8017c0:	01 d0                	add    %edx,%eax
  8017c2:	c1 e0 02             	shl    $0x2,%eax
  8017c5:	05 48 10 81 00       	add    $0x811048,%eax
  8017ca:	8a 00                	mov    (%eax),%al
  8017cc:	84 c0                	test   %al,%al
  8017ce:	74 34                	je     801804 <malloc+0x113>
  8017d0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017d3:	89 d0                	mov    %edx,%eax
  8017d5:	01 c0                	add    %eax,%eax
  8017d7:	01 d0                	add    %edx,%eax
  8017d9:	c1 e0 02             	shl    $0x2,%eax
  8017dc:	05 44 10 81 00       	add    $0x811044,%eax
  8017e1:	8b 00                	mov    (%eax),%eax
  8017e3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8017e6:	76 1c                	jbe    801804 <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  8017e8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017eb:	89 d0                	mov    %edx,%eax
  8017ed:	01 c0                	add    %eax,%eax
  8017ef:	01 d0                	add    %edx,%eax
  8017f1:	c1 e0 02             	shl    $0x2,%eax
  8017f4:	05 44 10 81 00       	add    $0x811044,%eax
  8017f9:	8b 00                	mov    (%eax),%eax
  8017fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  8017fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801801:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801804:	ff 45 e8             	incl   -0x18(%ebp)
  801807:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  80180e:	0f 8e 6e ff ff ff    	jle    801782 <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  801814:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  80181b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  80181f:	74 7d                	je     80189e <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801821:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801828:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80182b:	89 d0                	mov    %edx,%eax
  80182d:	01 c0                	add    %eax,%eax
  80182f:	01 d0                	add    %edx,%eax
  801831:	c1 e0 02             	shl    $0x2,%eax
  801834:	05 40 10 81 00       	add    $0x811040,%eax
  801839:	8b 10                	mov    (%eax),%edx
  80183b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80183e:	01 d0                	add    %edx,%eax
  801840:	48                   	dec    %eax
  801841:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801844:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801847:	ba 00 00 00 00       	mov    $0x0,%edx
  80184c:	f7 75 bc             	divl   -0x44(%ebp)
  80184f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801852:	29 d0                	sub    %edx,%eax
  801854:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801857:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80185a:	89 d0                	mov    %edx,%eax
  80185c:	01 c0                	add    %eax,%eax
  80185e:	01 d0                	add    %edx,%eax
  801860:	c1 e0 02             	shl    $0x2,%eax
  801863:	05 48 10 81 00       	add    $0x811048,%eax
  801868:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  80186b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80186e:	89 d0                	mov    %edx,%eax
  801870:	01 c0                	add    %eax,%eax
  801872:	01 d0                	add    %edx,%eax
  801874:	c1 e0 02             	shl    $0x2,%eax
  801877:	05 44 10 81 00       	add    $0x811044,%eax
  80187c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801882:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801885:	89 d0                	mov    %edx,%eax
  801887:	01 c0                	add    %eax,%eax
  801889:	01 d0                	add    %edx,%eax
  80188b:	c1 e0 02             	shl    $0x2,%eax
  80188e:	05 40 10 81 00       	add    $0x811040,%eax
  801893:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801899:	e9 2d 01 00 00       	jmp    8019cb <malloc+0x2da>
    }
    else if (worstIdx != -1)
  80189e:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8018a2:	0f 84 ce 00 00 00    	je     801976 <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  8018a8:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8018af:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018b2:	89 d0                	mov    %edx,%eax
  8018b4:	01 c0                	add    %eax,%eax
  8018b6:	01 d0                	add    %edx,%eax
  8018b8:	c1 e0 02             	shl    $0x2,%eax
  8018bb:	05 40 10 81 00       	add    $0x811040,%eax
  8018c0:	8b 10                	mov    (%eax),%edx
  8018c2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8018c5:	01 d0                	add    %edx,%eax
  8018c7:	48                   	dec    %eax
  8018c8:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8018cb:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8018ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d3:	f7 75 c4             	divl   -0x3c(%ebp)
  8018d6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8018d9:	29 d0                	sub    %edx,%eax
  8018db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  8018de:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018e1:	89 d0                	mov    %edx,%eax
  8018e3:	01 c0                	add    %eax,%eax
  8018e5:	01 d0                	add    %edx,%eax
  8018e7:	c1 e0 02             	shl    $0x2,%eax
  8018ea:	05 44 10 81 00       	add    $0x811044,%eax
  8018ef:	8b 00                	mov    (%eax),%eax
  8018f1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8018f4:	75 47                	jne    80193d <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  8018f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018f9:	89 d0                	mov    %edx,%eax
  8018fb:	01 c0                	add    %eax,%eax
  8018fd:	01 d0                	add    %edx,%eax
  8018ff:	c1 e0 02             	shl    $0x2,%eax
  801902:	05 48 10 81 00       	add    $0x811048,%eax
  801907:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  80190a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80190d:	89 d0                	mov    %edx,%eax
  80190f:	01 c0                	add    %eax,%eax
  801911:	01 d0                	add    %edx,%eax
  801913:	c1 e0 02             	shl    $0x2,%eax
  801916:	05 44 10 81 00       	add    $0x811044,%eax
  80191b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  801921:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801924:	89 d0                	mov    %edx,%eax
  801926:	01 c0                	add    %eax,%eax
  801928:	01 d0                	add    %edx,%eax
  80192a:	c1 e0 02             	shl    $0x2,%eax
  80192d:	05 40 10 81 00       	add    $0x811040,%eax
  801932:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801938:	e9 8e 00 00 00       	jmp    8019cb <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  80193d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801940:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801943:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801946:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801949:	89 d0                	mov    %edx,%eax
  80194b:	01 c0                	add    %eax,%eax
  80194d:	01 d0                	add    %edx,%eax
  80194f:	c1 e0 02             	shl    $0x2,%eax
  801952:	05 40 10 81 00       	add    $0x811040,%eax
  801957:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  801959:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80195c:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80195f:	89 c2                	mov    %eax,%edx
  801961:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801964:	89 c8                	mov    %ecx,%eax
  801966:	01 c0                	add    %eax,%eax
  801968:	01 c8                	add    %ecx,%eax
  80196a:	c1 e0 02             	shl    $0x2,%eax
  80196d:	05 44 10 81 00       	add    $0x811044,%eax
  801972:	89 10                	mov    %edx,(%eax)
  801974:	eb 55                	jmp    8019cb <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  801976:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  80197d:	8b 15 88 50 83 00    	mov    0x835088,%edx
  801983:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801986:	01 d0                	add    %edx,%eax
  801988:	48                   	dec    %eax
  801989:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80198c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80198f:	ba 00 00 00 00       	mov    $0x0,%edx
  801994:	f7 75 d0             	divl   -0x30(%ebp)
  801997:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80199a:	29 d0                	sub    %edx,%eax
  80199c:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  80199f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8019a2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019a5:	01 d0                	add    %edx,%eax
  8019a7:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8019ac:	76 0a                	jbe    8019b8 <malloc+0x2c7>
            return NULL;
  8019ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b3:	e9 97 00 00 00       	jmp    801a4f <malloc+0x35e>
        va = start;
  8019b8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8019bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  8019be:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8019c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019c4:	01 d0                	add    %edx,%eax
  8019c6:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8019cb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8019d2:	eb 5e                	jmp    801a32 <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  8019d4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019d7:	89 d0                	mov    %edx,%eax
  8019d9:	01 c0                	add    %eax,%eax
  8019db:	01 d0                	add    %edx,%eax
  8019dd:	c1 e0 02             	shl    $0x2,%eax
  8019e0:	05 48 50 80 00       	add    $0x805048,%eax
  8019e5:	8a 00                	mov    (%eax),%al
  8019e7:	84 c0                	test   %al,%al
  8019e9:	75 44                	jne    801a2f <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  8019eb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019ee:	89 d0                	mov    %edx,%eax
  8019f0:	01 c0                	add    %eax,%eax
  8019f2:	01 d0                	add    %edx,%eax
  8019f4:	c1 e0 02             	shl    $0x2,%eax
  8019f7:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  8019fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a00:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  801a02:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a05:	89 d0                	mov    %edx,%eax
  801a07:	01 c0                	add    %eax,%eax
  801a09:	01 d0                	add    %edx,%eax
  801a0b:	c1 e0 02             	shl    $0x2,%eax
  801a0e:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  801a14:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a17:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  801a19:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a1c:	89 d0                	mov    %edx,%eax
  801a1e:	01 c0                	add    %eax,%eax
  801a20:	01 d0                	add    %edx,%eax
  801a22:	c1 e0 02             	shl    $0x2,%eax
  801a25:	05 48 50 80 00       	add    $0x805048,%eax
  801a2a:	c6 00 01             	movb   $0x1,(%eax)
            break;
  801a2d:	eb 0c                	jmp    801a3b <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801a2f:	ff 45 e0             	incl   -0x20(%ebp)
  801a32:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801a39:	7e 99                	jle    8019d4 <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  801a3b:	83 ec 08             	sub    $0x8,%esp
  801a3e:	ff 75 d4             	pushl  -0x2c(%ebp)
  801a41:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a44:	e8 a2 19 00 00       	call   8033eb <sys_allocate_user_mem>
  801a49:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  801a4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801a4f:	c9                   	leave  
  801a50:	c3                   	ret    

00801a51 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
  801a54:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  801a57:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a5b:	0f 84 fa 03 00 00    	je     801e5b <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  801a61:	8b 45 08             	mov    0x8(%ebp),%eax
  801a64:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  801a67:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a6a:	85 c0                	test   %eax,%eax
  801a6c:	79 1c                	jns    801a8a <free+0x39>
  801a6e:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  801a75:	77 13                	ja     801a8a <free+0x39>
    {
        free_block(virtual_address);
  801a77:	83 ec 0c             	sub    $0xc,%esp
  801a7a:	ff 75 08             	pushl  0x8(%ebp)
  801a7d:	e8 09 21 00 00       	call   803b8b <free_block>
  801a82:	83 c4 10             	add    $0x10,%esp
        return;
  801a85:	e9 d2 03 00 00       	jmp    801e5c <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  801a8a:	a1 30 51 83 00       	mov    0x835130,%eax
  801a8f:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  801a92:	72 09                	jb     801a9d <free+0x4c>
  801a94:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  801a9b:	76 17                	jbe    801ab4 <free+0x63>
        panic("free: invalid address");
  801a9d:	83 ec 04             	sub    $0x4,%esp
  801aa0:	68 6d 4b 80 00       	push   $0x804b6d
  801aa5:	68 9b 00 00 00       	push   $0x9b
  801aaa:	68 24 4b 80 00       	push   $0x804b24
  801aaf:	e8 ad e9 ff ff       	call   800461 <_panic>

    uint32 size = 0;
  801ab4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  801abb:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801ac2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801ac9:	eb 50                	jmp    801b1b <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  801acb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ace:	89 d0                	mov    %edx,%eax
  801ad0:	01 c0                	add    %eax,%eax
  801ad2:	01 d0                	add    %edx,%eax
  801ad4:	c1 e0 02             	shl    $0x2,%eax
  801ad7:	05 48 50 80 00       	add    $0x805048,%eax
  801adc:	8a 00                	mov    (%eax),%al
  801ade:	84 c0                	test   %al,%al
  801ae0:	74 36                	je     801b18 <free+0xc7>
  801ae2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ae5:	89 d0                	mov    %edx,%eax
  801ae7:	01 c0                	add    %eax,%eax
  801ae9:	01 d0                	add    %edx,%eax
  801aeb:	c1 e0 02             	shl    $0x2,%eax
  801aee:	05 40 50 80 00       	add    $0x805040,%eax
  801af3:	8b 00                	mov    (%eax),%eax
  801af5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801af8:	75 1e                	jne    801b18 <free+0xc7>
        {
            size = uhp_allocs[i].size;
  801afa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801afd:	89 d0                	mov    %edx,%eax
  801aff:	01 c0                	add    %eax,%eax
  801b01:	01 d0                	add    %edx,%eax
  801b03:	c1 e0 02             	shl    $0x2,%eax
  801b06:	05 44 50 80 00       	add    $0x805044,%eax
  801b0b:	8b 00                	mov    (%eax),%eax
  801b0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  801b10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b13:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  801b16:	eb 0c                	jmp    801b24 <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801b18:	ff 45 ec             	incl   -0x14(%ebp)
  801b1b:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  801b22:	7e a7                	jle    801acb <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  801b24:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801b28:	74 06                	je     801b30 <free+0xdf>
  801b2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b2e:	75 17                	jne    801b47 <free+0xf6>
        panic("free: unknown block");
  801b30:	83 ec 04             	sub    $0x4,%esp
  801b33:	68 83 4b 80 00       	push   $0x804b83
  801b38:	68 a9 00 00 00       	push   $0xa9
  801b3d:	68 24 4b 80 00       	push   $0x804b24
  801b42:	e8 1a e9 ff ff       	call   800461 <_panic>

    uhp_allocs[idx].used = 0;
  801b47:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b4a:	89 d0                	mov    %edx,%eax
  801b4c:	01 c0                	add    %eax,%eax
  801b4e:	01 d0                	add    %edx,%eax
  801b50:	c1 e0 02             	shl    $0x2,%eax
  801b53:	05 48 50 80 00       	add    $0x805048,%eax
  801b58:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  801b5b:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801b62:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801b69:	eb 64                	jmp    801bcf <free+0x17e>
    {
        if (!uhp_frees[i].free)
  801b6b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b6e:	89 d0                	mov    %edx,%eax
  801b70:	01 c0                	add    %eax,%eax
  801b72:	01 d0                	add    %edx,%eax
  801b74:	c1 e0 02             	shl    $0x2,%eax
  801b77:	05 48 10 81 00       	add    $0x811048,%eax
  801b7c:	8a 00                	mov    (%eax),%al
  801b7e:	84 c0                	test   %al,%al
  801b80:	75 4a                	jne    801bcc <free+0x17b>
        {
            uhp_frees[i].va = va;
  801b82:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b85:	89 d0                	mov    %edx,%eax
  801b87:	01 c0                	add    %eax,%eax
  801b89:	01 d0                	add    %edx,%eax
  801b8b:	c1 e0 02             	shl    $0x2,%eax
  801b8e:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  801b94:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b97:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  801b99:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b9c:	89 d0                	mov    %edx,%eax
  801b9e:	01 c0                	add    %eax,%eax
  801ba0:	01 d0                	add    %edx,%eax
  801ba2:	c1 e0 02             	shl    $0x2,%eax
  801ba5:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  801bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bae:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  801bb0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801bb3:	89 d0                	mov    %edx,%eax
  801bb5:	01 c0                	add    %eax,%eax
  801bb7:	01 d0                	add    %edx,%eax
  801bb9:	c1 e0 02             	shl    $0x2,%eax
  801bbc:	05 48 10 81 00       	add    $0x811048,%eax
  801bc1:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  801bc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bc7:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  801bca:	eb 0c                	jmp    801bd8 <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801bcc:	ff 45 e4             	incl   -0x1c(%ebp)
  801bcf:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  801bd6:	7e 93                	jle    801b6b <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  801bd8:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  801bdc:	0f 84 f1 01 00 00    	je     801dd3 <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801be2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801be9:	e9 d8 01 00 00       	jmp    801dc6 <free+0x375>
        {
            if (i == fidx) continue;
  801bee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bf1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801bf4:	0f 84 c8 01 00 00    	je     801dc2 <free+0x371>
            if (uhp_frees[i].free)
  801bfa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bfd:	89 d0                	mov    %edx,%eax
  801bff:	01 c0                	add    %eax,%eax
  801c01:	01 d0                	add    %edx,%eax
  801c03:	c1 e0 02             	shl    $0x2,%eax
  801c06:	05 48 10 81 00       	add    $0x811048,%eax
  801c0b:	8a 00                	mov    (%eax),%al
  801c0d:	84 c0                	test   %al,%al
  801c0f:	0f 84 ae 01 00 00    	je     801dc3 <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  801c15:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c18:	89 d0                	mov    %edx,%eax
  801c1a:	01 c0                	add    %eax,%eax
  801c1c:	01 d0                	add    %edx,%eax
  801c1e:	c1 e0 02             	shl    $0x2,%eax
  801c21:	05 40 10 81 00       	add    $0x811040,%eax
  801c26:	8b 08                	mov    (%eax),%ecx
  801c28:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c2b:	89 d0                	mov    %edx,%eax
  801c2d:	01 c0                	add    %eax,%eax
  801c2f:	01 d0                	add    %edx,%eax
  801c31:	c1 e0 02             	shl    $0x2,%eax
  801c34:	05 44 10 81 00       	add    $0x811044,%eax
  801c39:	8b 00                	mov    (%eax),%eax
  801c3b:	01 c1                	add    %eax,%ecx
  801c3d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c40:	89 d0                	mov    %edx,%eax
  801c42:	01 c0                	add    %eax,%eax
  801c44:	01 d0                	add    %edx,%eax
  801c46:	c1 e0 02             	shl    $0x2,%eax
  801c49:	05 40 10 81 00       	add    $0x811040,%eax
  801c4e:	8b 00                	mov    (%eax),%eax
  801c50:	39 c1                	cmp    %eax,%ecx
  801c52:	0f 85 a8 00 00 00    	jne    801d00 <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  801c58:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c5b:	89 d0                	mov    %edx,%eax
  801c5d:	01 c0                	add    %eax,%eax
  801c5f:	01 d0                	add    %edx,%eax
  801c61:	c1 e0 02             	shl    $0x2,%eax
  801c64:	05 40 10 81 00       	add    $0x811040,%eax
  801c69:	8b 10                	mov    (%eax),%edx
  801c6b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  801c6e:	89 c8                	mov    %ecx,%eax
  801c70:	01 c0                	add    %eax,%eax
  801c72:	01 c8                	add    %ecx,%eax
  801c74:	c1 e0 02             	shl    $0x2,%eax
  801c77:	05 40 10 81 00       	add    $0x811040,%eax
  801c7c:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801c7e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c81:	89 d0                	mov    %edx,%eax
  801c83:	01 c0                	add    %eax,%eax
  801c85:	01 d0                	add    %edx,%eax
  801c87:	c1 e0 02             	shl    $0x2,%eax
  801c8a:	05 44 10 81 00       	add    $0x811044,%eax
  801c8f:	8b 08                	mov    (%eax),%ecx
  801c91:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c94:	89 d0                	mov    %edx,%eax
  801c96:	01 c0                	add    %eax,%eax
  801c98:	01 d0                	add    %edx,%eax
  801c9a:	c1 e0 02             	shl    $0x2,%eax
  801c9d:	05 44 10 81 00       	add    $0x811044,%eax
  801ca2:	8b 00                	mov    (%eax),%eax
  801ca4:	01 c1                	add    %eax,%ecx
  801ca6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ca9:	89 d0                	mov    %edx,%eax
  801cab:	01 c0                	add    %eax,%eax
  801cad:	01 d0                	add    %edx,%eax
  801caf:	c1 e0 02             	shl    $0x2,%eax
  801cb2:	05 44 10 81 00       	add    $0x811044,%eax
  801cb7:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801cb9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801cbc:	89 d0                	mov    %edx,%eax
  801cbe:	01 c0                	add    %eax,%eax
  801cc0:	01 d0                	add    %edx,%eax
  801cc2:	c1 e0 02             	shl    $0x2,%eax
  801cc5:	05 48 10 81 00       	add    $0x811048,%eax
  801cca:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801ccd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801cd0:	89 d0                	mov    %edx,%eax
  801cd2:	01 c0                	add    %eax,%eax
  801cd4:	01 d0                	add    %edx,%eax
  801cd6:	c1 e0 02             	shl    $0x2,%eax
  801cd9:	05 40 10 81 00       	add    $0x811040,%eax
  801cde:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801ce4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ce7:	89 d0                	mov    %edx,%eax
  801ce9:	01 c0                	add    %eax,%eax
  801ceb:	01 d0                	add    %edx,%eax
  801ced:	c1 e0 02             	shl    $0x2,%eax
  801cf0:	05 44 10 81 00       	add    $0x811044,%eax
  801cf5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801cfb:	e9 c3 00 00 00       	jmp    801dc3 <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  801d00:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d03:	89 d0                	mov    %edx,%eax
  801d05:	01 c0                	add    %eax,%eax
  801d07:	01 d0                	add    %edx,%eax
  801d09:	c1 e0 02             	shl    $0x2,%eax
  801d0c:	05 40 10 81 00       	add    $0x811040,%eax
  801d11:	8b 08                	mov    (%eax),%ecx
  801d13:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d16:	89 d0                	mov    %edx,%eax
  801d18:	01 c0                	add    %eax,%eax
  801d1a:	01 d0                	add    %edx,%eax
  801d1c:	c1 e0 02             	shl    $0x2,%eax
  801d1f:	05 44 10 81 00       	add    $0x811044,%eax
  801d24:	8b 00                	mov    (%eax),%eax
  801d26:	01 c1                	add    %eax,%ecx
  801d28:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d2b:	89 d0                	mov    %edx,%eax
  801d2d:	01 c0                	add    %eax,%eax
  801d2f:	01 d0                	add    %edx,%eax
  801d31:	c1 e0 02             	shl    $0x2,%eax
  801d34:	05 40 10 81 00       	add    $0x811040,%eax
  801d39:	8b 00                	mov    (%eax),%eax
  801d3b:	39 c1                	cmp    %eax,%ecx
  801d3d:	0f 85 80 00 00 00    	jne    801dc3 <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801d43:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d46:	89 d0                	mov    %edx,%eax
  801d48:	01 c0                	add    %eax,%eax
  801d4a:	01 d0                	add    %edx,%eax
  801d4c:	c1 e0 02             	shl    $0x2,%eax
  801d4f:	05 44 10 81 00       	add    $0x811044,%eax
  801d54:	8b 08                	mov    (%eax),%ecx
  801d56:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d59:	89 d0                	mov    %edx,%eax
  801d5b:	01 c0                	add    %eax,%eax
  801d5d:	01 d0                	add    %edx,%eax
  801d5f:	c1 e0 02             	shl    $0x2,%eax
  801d62:	05 44 10 81 00       	add    $0x811044,%eax
  801d67:	8b 00                	mov    (%eax),%eax
  801d69:	01 c1                	add    %eax,%ecx
  801d6b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d6e:	89 d0                	mov    %edx,%eax
  801d70:	01 c0                	add    %eax,%eax
  801d72:	01 d0                	add    %edx,%eax
  801d74:	c1 e0 02             	shl    $0x2,%eax
  801d77:	05 44 10 81 00       	add    $0x811044,%eax
  801d7c:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801d7e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d81:	89 d0                	mov    %edx,%eax
  801d83:	01 c0                	add    %eax,%eax
  801d85:	01 d0                	add    %edx,%eax
  801d87:	c1 e0 02             	shl    $0x2,%eax
  801d8a:	05 48 10 81 00       	add    $0x811048,%eax
  801d8f:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801d92:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d95:	89 d0                	mov    %edx,%eax
  801d97:	01 c0                	add    %eax,%eax
  801d99:	01 d0                	add    %edx,%eax
  801d9b:	c1 e0 02             	shl    $0x2,%eax
  801d9e:	05 40 10 81 00       	add    $0x811040,%eax
  801da3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801da9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801dac:	89 d0                	mov    %edx,%eax
  801dae:	01 c0                	add    %eax,%eax
  801db0:	01 d0                	add    %edx,%eax
  801db2:	c1 e0 02             	shl    $0x2,%eax
  801db5:	05 44 10 81 00       	add    $0x811044,%eax
  801dba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801dc0:	eb 01                	jmp    801dc3 <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  801dc2:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801dc3:	ff 45 e0             	incl   -0x20(%ebp)
  801dc6:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801dcd:	0f 8e 1b fe ff ff    	jle    801bee <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  801dd3:	a1 30 51 83 00       	mov    0x835130,%eax
  801dd8:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801ddb:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801de2:	eb 53                	jmp    801e37 <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  801de4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801de7:	89 d0                	mov    %edx,%eax
  801de9:	01 c0                	add    %eax,%eax
  801deb:	01 d0                	add    %edx,%eax
  801ded:	c1 e0 02             	shl    $0x2,%eax
  801df0:	05 48 50 80 00       	add    $0x805048,%eax
  801df5:	8a 00                	mov    (%eax),%al
  801df7:	84 c0                	test   %al,%al
  801df9:	74 39                	je     801e34 <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  801dfb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801dfe:	89 d0                	mov    %edx,%eax
  801e00:	01 c0                	add    %eax,%eax
  801e02:	01 d0                	add    %edx,%eax
  801e04:	c1 e0 02             	shl    $0x2,%eax
  801e07:	05 40 50 80 00       	add    $0x805040,%eax
  801e0c:	8b 08                	mov    (%eax),%ecx
  801e0e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e11:	89 d0                	mov    %edx,%eax
  801e13:	01 c0                	add    %eax,%eax
  801e15:	01 d0                	add    %edx,%eax
  801e17:	c1 e0 02             	shl    $0x2,%eax
  801e1a:	05 44 50 80 00       	add    $0x805044,%eax
  801e1f:	8b 00                	mov    (%eax),%eax
  801e21:	01 c8                	add    %ecx,%eax
  801e23:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  801e26:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e29:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801e2c:	76 06                	jbe    801e34 <free+0x3e3>
  801e2e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e31:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801e34:	ff 45 d8             	incl   -0x28(%ebp)
  801e37:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  801e3e:	7e a4                	jle    801de4 <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  801e40:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e43:	a3 88 50 83 00       	mov    %eax,0x835088

    sys_free_user_mem(va, size);
  801e48:	83 ec 08             	sub    $0x8,%esp
  801e4b:	ff 75 f4             	pushl  -0xc(%ebp)
  801e4e:	ff 75 d4             	pushl  -0x2c(%ebp)
  801e51:	e8 79 15 00 00       	call   8033cf <sys_free_user_mem>
  801e56:	83 c4 10             	add    $0x10,%esp
  801e59:	eb 01                	jmp    801e5c <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  801e5b:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  801e5c:	c9                   	leave  
  801e5d:	c3                   	ret    

00801e5e <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801e5e:	55                   	push   %ebp
  801e5f:	89 e5                	mov    %esp,%ebp
  801e61:	83 ec 68             	sub    $0x68,%esp
  801e64:	8b 45 10             	mov    0x10(%ebp),%eax
  801e67:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801e6a:	e8 a5 f7 ff ff       	call   801614 <uheap_init>
	if (size == 0) return NULL ;
  801e6f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e73:	75 0a                	jne    801e7f <smalloc+0x21>
  801e75:	b8 00 00 00 00       	mov    $0x0,%eax
  801e7a:	e9 37 03 00 00       	jmp    8021b6 <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801e7f:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801e86:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e89:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e8c:	01 d0                	add    %edx,%eax
  801e8e:	48                   	dec    %eax
  801e8f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801e92:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e95:	ba 00 00 00 00       	mov    $0x0,%edx
  801e9a:	f7 75 dc             	divl   -0x24(%ebp)
  801e9d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ea0:	29 d0                	sub    %edx,%eax
  801ea2:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  801ea5:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801eac:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801eb3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801eba:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801ec1:	e9 85 00 00 00       	jmp    801f4b <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801ec6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ec9:	89 d0                	mov    %edx,%eax
  801ecb:	01 c0                	add    %eax,%eax
  801ecd:	01 d0                	add    %edx,%eax
  801ecf:	c1 e0 02             	shl    $0x2,%eax
  801ed2:	05 48 10 81 00       	add    $0x811048,%eax
  801ed7:	8a 00                	mov    (%eax),%al
  801ed9:	84 c0                	test   %al,%al
  801edb:	74 20                	je     801efd <smalloc+0x9f>
  801edd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ee0:	89 d0                	mov    %edx,%eax
  801ee2:	01 c0                	add    %eax,%eax
  801ee4:	01 d0                	add    %edx,%eax
  801ee6:	c1 e0 02             	shl    $0x2,%eax
  801ee9:	05 44 10 81 00       	add    $0x811044,%eax
  801eee:	8b 00                	mov    (%eax),%eax
  801ef0:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801ef3:	75 08                	jne    801efd <smalloc+0x9f>
        {
            exactIdx = i;
  801ef5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ef8:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801efb:	eb 5b                	jmp    801f58 <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801efd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f00:	89 d0                	mov    %edx,%eax
  801f02:	01 c0                	add    %eax,%eax
  801f04:	01 d0                	add    %edx,%eax
  801f06:	c1 e0 02             	shl    $0x2,%eax
  801f09:	05 48 10 81 00       	add    $0x811048,%eax
  801f0e:	8a 00                	mov    (%eax),%al
  801f10:	84 c0                	test   %al,%al
  801f12:	74 34                	je     801f48 <smalloc+0xea>
  801f14:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f17:	89 d0                	mov    %edx,%eax
  801f19:	01 c0                	add    %eax,%eax
  801f1b:	01 d0                	add    %edx,%eax
  801f1d:	c1 e0 02             	shl    $0x2,%eax
  801f20:	05 44 10 81 00       	add    $0x811044,%eax
  801f25:	8b 00                	mov    (%eax),%eax
  801f27:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801f2a:	76 1c                	jbe    801f48 <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  801f2c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f2f:	89 d0                	mov    %edx,%eax
  801f31:	01 c0                	add    %eax,%eax
  801f33:	01 d0                	add    %edx,%eax
  801f35:	c1 e0 02             	shl    $0x2,%eax
  801f38:	05 44 10 81 00       	add    $0x811044,%eax
  801f3d:	8b 00                	mov    (%eax),%eax
  801f3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801f42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f45:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801f48:	ff 45 e8             	incl   -0x18(%ebp)
  801f4b:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801f52:	0f 8e 6e ff ff ff    	jle    801ec6 <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  801f58:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801f5f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801f63:	74 7d                	je     801fe2 <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801f65:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801f6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f6f:	89 d0                	mov    %edx,%eax
  801f71:	01 c0                	add    %eax,%eax
  801f73:	01 d0                	add    %edx,%eax
  801f75:	c1 e0 02             	shl    $0x2,%eax
  801f78:	05 40 10 81 00       	add    $0x811040,%eax
  801f7d:	8b 10                	mov    (%eax),%edx
  801f7f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801f82:	01 d0                	add    %edx,%eax
  801f84:	48                   	dec    %eax
  801f85:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801f88:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801f8b:	ba 00 00 00 00       	mov    $0x0,%edx
  801f90:	f7 75 bc             	divl   -0x44(%ebp)
  801f93:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801f96:	29 d0                	sub    %edx,%eax
  801f98:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801f9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f9e:	89 d0                	mov    %edx,%eax
  801fa0:	01 c0                	add    %eax,%eax
  801fa2:	01 d0                	add    %edx,%eax
  801fa4:	c1 e0 02             	shl    $0x2,%eax
  801fa7:	05 48 10 81 00       	add    $0x811048,%eax
  801fac:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801faf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fb2:	89 d0                	mov    %edx,%eax
  801fb4:	01 c0                	add    %eax,%eax
  801fb6:	01 d0                	add    %edx,%eax
  801fb8:	c1 e0 02             	shl    $0x2,%eax
  801fbb:	05 44 10 81 00       	add    $0x811044,%eax
  801fc0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801fc6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fc9:	89 d0                	mov    %edx,%eax
  801fcb:	01 c0                	add    %eax,%eax
  801fcd:	01 d0                	add    %edx,%eax
  801fcf:	c1 e0 02             	shl    $0x2,%eax
  801fd2:	05 40 10 81 00       	add    $0x811040,%eax
  801fd7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fdd:	e9 2d 01 00 00       	jmp    80210f <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  801fe2:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801fe6:	0f 84 ce 00 00 00    	je     8020ba <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  801fec:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  801ff3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ff6:	89 d0                	mov    %edx,%eax
  801ff8:	01 c0                	add    %eax,%eax
  801ffa:	01 d0                	add    %edx,%eax
  801ffc:	c1 e0 02             	shl    $0x2,%eax
  801fff:	05 40 10 81 00       	add    $0x811040,%eax
  802004:	8b 10                	mov    (%eax),%edx
  802006:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802009:	01 d0                	add    %edx,%eax
  80200b:	48                   	dec    %eax
  80200c:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80200f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802012:	ba 00 00 00 00       	mov    $0x0,%edx
  802017:	f7 75 c4             	divl   -0x3c(%ebp)
  80201a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80201d:	29 d0                	sub    %edx,%eax
  80201f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  802022:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802025:	89 d0                	mov    %edx,%eax
  802027:	01 c0                	add    %eax,%eax
  802029:	01 d0                	add    %edx,%eax
  80202b:	c1 e0 02             	shl    $0x2,%eax
  80202e:	05 44 10 81 00       	add    $0x811044,%eax
  802033:	8b 00                	mov    (%eax),%eax
  802035:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802038:	75 47                	jne    802081 <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  80203a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80203d:	89 d0                	mov    %edx,%eax
  80203f:	01 c0                	add    %eax,%eax
  802041:	01 d0                	add    %edx,%eax
  802043:	c1 e0 02             	shl    $0x2,%eax
  802046:	05 48 10 81 00       	add    $0x811048,%eax
  80204b:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  80204e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802051:	89 d0                	mov    %edx,%eax
  802053:	01 c0                	add    %eax,%eax
  802055:	01 d0                	add    %edx,%eax
  802057:	c1 e0 02             	shl    $0x2,%eax
  80205a:	05 44 10 81 00       	add    $0x811044,%eax
  80205f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  802065:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802068:	89 d0                	mov    %edx,%eax
  80206a:	01 c0                	add    %eax,%eax
  80206c:	01 d0                	add    %edx,%eax
  80206e:	c1 e0 02             	shl    $0x2,%eax
  802071:	05 40 10 81 00       	add    $0x811040,%eax
  802076:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80207c:	e9 8e 00 00 00       	jmp    80210f <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  802081:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802084:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802087:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80208a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80208d:	89 d0                	mov    %edx,%eax
  80208f:	01 c0                	add    %eax,%eax
  802091:	01 d0                	add    %edx,%eax
  802093:	c1 e0 02             	shl    $0x2,%eax
  802096:	05 40 10 81 00       	add    $0x811040,%eax
  80209b:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  80209d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020a0:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8020a3:	89 c2                	mov    %eax,%edx
  8020a5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8020a8:	89 c8                	mov    %ecx,%eax
  8020aa:	01 c0                	add    %eax,%eax
  8020ac:	01 c8                	add    %ecx,%eax
  8020ae:	c1 e0 02             	shl    $0x2,%eax
  8020b1:	05 44 10 81 00       	add    $0x811044,%eax
  8020b6:	89 10                	mov    %edx,(%eax)
  8020b8:	eb 55                	jmp    80210f <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  8020ba:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  8020c1:	8b 15 88 50 83 00    	mov    0x835088,%edx
  8020c7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8020ca:	01 d0                	add    %edx,%eax
  8020cc:	48                   	dec    %eax
  8020cd:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8020d0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8020d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8020d8:	f7 75 d0             	divl   -0x30(%ebp)
  8020db:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8020de:	29 d0                	sub    %edx,%eax
  8020e0:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  8020e3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8020e6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020e9:	01 d0                	add    %edx,%eax
  8020eb:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8020f0:	76 0a                	jbe    8020fc <smalloc+0x29e>
            return NULL;
  8020f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f7:	e9 ba 00 00 00       	jmp    8021b6 <smalloc+0x358>
        va = start;
  8020fc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8020ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  802102:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802105:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802108:	01 d0                	add    %edx,%eax
  80210a:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80210f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802116:	eb 5e                	jmp    802176 <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  802118:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80211b:	89 d0                	mov    %edx,%eax
  80211d:	01 c0                	add    %eax,%eax
  80211f:	01 d0                	add    %edx,%eax
  802121:	c1 e0 02             	shl    $0x2,%eax
  802124:	05 48 50 80 00       	add    $0x805048,%eax
  802129:	8a 00                	mov    (%eax),%al
  80212b:	84 c0                	test   %al,%al
  80212d:	75 44                	jne    802173 <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  80212f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802132:	89 d0                	mov    %edx,%eax
  802134:	01 c0                	add    %eax,%eax
  802136:	01 d0                	add    %edx,%eax
  802138:	c1 e0 02             	shl    $0x2,%eax
  80213b:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  802141:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802144:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  802146:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802149:	89 d0                	mov    %edx,%eax
  80214b:	01 c0                	add    %eax,%eax
  80214d:	01 d0                	add    %edx,%eax
  80214f:	c1 e0 02             	shl    $0x2,%eax
  802152:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802158:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80215b:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  80215d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802160:	89 d0                	mov    %edx,%eax
  802162:	01 c0                	add    %eax,%eax
  802164:	01 d0                	add    %edx,%eax
  802166:	c1 e0 02             	shl    $0x2,%eax
  802169:	05 48 50 80 00       	add    $0x805048,%eax
  80216e:	c6 00 01             	movb   $0x1,(%eax)
            break;
  802171:	eb 0c                	jmp    80217f <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802173:	ff 45 e0             	incl   -0x20(%ebp)
  802176:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80217d:	7e 99                	jle    802118 <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  80217f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802182:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  802186:	52                   	push   %edx
  802187:	50                   	push   %eax
  802188:	ff 75 d4             	pushl  -0x2c(%ebp)
  80218b:	ff 75 08             	pushl  0x8(%ebp)
  80218e:	e8 de 0e 00 00       	call   803071 <sys_create_shared_object>
  802193:	83 c4 10             	add    $0x10,%esp
  802196:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  802199:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  80219d:	75 07                	jne    8021a6 <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  80219f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8021a4:	eb 10                	jmp    8021b6 <smalloc+0x358>
    if (r < 0)
  8021a6:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  8021aa:	79 07                	jns    8021b3 <smalloc+0x355>
        return NULL;
  8021ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b1:	eb 03                	jmp    8021b6 <smalloc+0x358>
    return (void*)va;
  8021b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8021b6:	c9                   	leave  
  8021b7:	c3                   	ret    

008021b8 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8021b8:	55                   	push   %ebp
  8021b9:	89 e5                	mov    %esp,%ebp
  8021bb:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8021be:	e8 51 f4 ff ff       	call   801614 <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  8021c3:	83 ec 08             	sub    $0x8,%esp
  8021c6:	ff 75 0c             	pushl  0xc(%ebp)
  8021c9:	ff 75 08             	pushl  0x8(%ebp)
  8021cc:	e8 ca 0e 00 00       	call   80309b <sys_size_of_shared_object>
  8021d1:	83 c4 10             	add    $0x10,%esp
  8021d4:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  8021d7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8021db:	7f 0a                	jg     8021e7 <sget+0x2f>
        return NULL;
  8021dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e2:	e9 28 03 00 00       	jmp    80250f <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  8021e7:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8021ee:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8021f1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8021f4:	01 d0                	add    %edx,%eax
  8021f6:	48                   	dec    %eax
  8021f7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8021fa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8021fd:	ba 00 00 00 00       	mov    $0x0,%edx
  802202:	f7 75 d8             	divl   -0x28(%ebp)
  802205:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802208:	29 d0                	sub    %edx,%eax
  80220a:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  80220d:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  802214:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  80221b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802222:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802229:	e9 85 00 00 00       	jmp    8022b3 <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  80222e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802231:	89 d0                	mov    %edx,%eax
  802233:	01 c0                	add    %eax,%eax
  802235:	01 d0                	add    %edx,%eax
  802237:	c1 e0 02             	shl    $0x2,%eax
  80223a:	05 48 10 81 00       	add    $0x811048,%eax
  80223f:	8a 00                	mov    (%eax),%al
  802241:	84 c0                	test   %al,%al
  802243:	74 20                	je     802265 <sget+0xad>
  802245:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802248:	89 d0                	mov    %edx,%eax
  80224a:	01 c0                	add    %eax,%eax
  80224c:	01 d0                	add    %edx,%eax
  80224e:	c1 e0 02             	shl    $0x2,%eax
  802251:	05 44 10 81 00       	add    $0x811044,%eax
  802256:	8b 00                	mov    (%eax),%eax
  802258:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80225b:	75 08                	jne    802265 <sget+0xad>
        {
            exactIdx = i;
  80225d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802260:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  802263:	eb 5b                	jmp    8022c0 <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  802265:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802268:	89 d0                	mov    %edx,%eax
  80226a:	01 c0                	add    %eax,%eax
  80226c:	01 d0                	add    %edx,%eax
  80226e:	c1 e0 02             	shl    $0x2,%eax
  802271:	05 48 10 81 00       	add    $0x811048,%eax
  802276:	8a 00                	mov    (%eax),%al
  802278:	84 c0                	test   %al,%al
  80227a:	74 34                	je     8022b0 <sget+0xf8>
  80227c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80227f:	89 d0                	mov    %edx,%eax
  802281:	01 c0                	add    %eax,%eax
  802283:	01 d0                	add    %edx,%eax
  802285:	c1 e0 02             	shl    $0x2,%eax
  802288:	05 44 10 81 00       	add    $0x811044,%eax
  80228d:	8b 00                	mov    (%eax),%eax
  80228f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802292:	76 1c                	jbe    8022b0 <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  802294:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802297:	89 d0                	mov    %edx,%eax
  802299:	01 c0                	add    %eax,%eax
  80229b:	01 d0                	add    %edx,%eax
  80229d:	c1 e0 02             	shl    $0x2,%eax
  8022a0:	05 44 10 81 00       	add    $0x811044,%eax
  8022a5:	8b 00                	mov    (%eax),%eax
  8022a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  8022aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8022b0:	ff 45 e8             	incl   -0x18(%ebp)
  8022b3:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8022ba:	0f 8e 6e ff ff ff    	jle    80222e <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  8022c0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  8022c7:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8022cb:	74 7d                	je     80234a <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  8022cd:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8022d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022d7:	89 d0                	mov    %edx,%eax
  8022d9:	01 c0                	add    %eax,%eax
  8022db:	01 d0                	add    %edx,%eax
  8022dd:	c1 e0 02             	shl    $0x2,%eax
  8022e0:	05 40 10 81 00       	add    $0x811040,%eax
  8022e5:	8b 10                	mov    (%eax),%edx
  8022e7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8022ea:	01 d0                	add    %edx,%eax
  8022ec:	48                   	dec    %eax
  8022ed:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8022f0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8022f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8022f8:	f7 75 b8             	divl   -0x48(%ebp)
  8022fb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8022fe:	29 d0                	sub    %edx,%eax
  802300:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  802303:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802306:	89 d0                	mov    %edx,%eax
  802308:	01 c0                	add    %eax,%eax
  80230a:	01 d0                	add    %edx,%eax
  80230c:	c1 e0 02             	shl    $0x2,%eax
  80230f:	05 48 10 81 00       	add    $0x811048,%eax
  802314:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  802317:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80231a:	89 d0                	mov    %edx,%eax
  80231c:	01 c0                	add    %eax,%eax
  80231e:	01 d0                	add    %edx,%eax
  802320:	c1 e0 02             	shl    $0x2,%eax
  802323:	05 44 10 81 00       	add    $0x811044,%eax
  802328:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  80232e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802331:	89 d0                	mov    %edx,%eax
  802333:	01 c0                	add    %eax,%eax
  802335:	01 d0                	add    %edx,%eax
  802337:	c1 e0 02             	shl    $0x2,%eax
  80233a:	05 40 10 81 00       	add    $0x811040,%eax
  80233f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802345:	e9 2d 01 00 00       	jmp    802477 <sget+0x2bf>
    }
    else if (worstIdx != -1)
  80234a:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80234e:	0f 84 ce 00 00 00    	je     802422 <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  802354:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  80235b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80235e:	89 d0                	mov    %edx,%eax
  802360:	01 c0                	add    %eax,%eax
  802362:	01 d0                	add    %edx,%eax
  802364:	c1 e0 02             	shl    $0x2,%eax
  802367:	05 40 10 81 00       	add    $0x811040,%eax
  80236c:	8b 10                	mov    (%eax),%edx
  80236e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802371:	01 d0                	add    %edx,%eax
  802373:	48                   	dec    %eax
  802374:	89 45 bc             	mov    %eax,-0x44(%ebp)
  802377:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80237a:	ba 00 00 00 00       	mov    $0x0,%edx
  80237f:	f7 75 c0             	divl   -0x40(%ebp)
  802382:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802385:	29 d0                	sub    %edx,%eax
  802387:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  80238a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80238d:	89 d0                	mov    %edx,%eax
  80238f:	01 c0                	add    %eax,%eax
  802391:	01 d0                	add    %edx,%eax
  802393:	c1 e0 02             	shl    $0x2,%eax
  802396:	05 44 10 81 00       	add    $0x811044,%eax
  80239b:	8b 00                	mov    (%eax),%eax
  80239d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8023a0:	75 47                	jne    8023e9 <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  8023a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023a5:	89 d0                	mov    %edx,%eax
  8023a7:	01 c0                	add    %eax,%eax
  8023a9:	01 d0                	add    %edx,%eax
  8023ab:	c1 e0 02             	shl    $0x2,%eax
  8023ae:	05 48 10 81 00       	add    $0x811048,%eax
  8023b3:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  8023b6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023b9:	89 d0                	mov    %edx,%eax
  8023bb:	01 c0                	add    %eax,%eax
  8023bd:	01 d0                	add    %edx,%eax
  8023bf:	c1 e0 02             	shl    $0x2,%eax
  8023c2:	05 44 10 81 00       	add    $0x811044,%eax
  8023c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  8023cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023d0:	89 d0                	mov    %edx,%eax
  8023d2:	01 c0                	add    %eax,%eax
  8023d4:	01 d0                	add    %edx,%eax
  8023d6:	c1 e0 02             	shl    $0x2,%eax
  8023d9:	05 40 10 81 00       	add    $0x811040,%eax
  8023de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023e4:	e9 8e 00 00 00       	jmp    802477 <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  8023e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8023ec:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8023ef:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8023f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023f5:	89 d0                	mov    %edx,%eax
  8023f7:	01 c0                	add    %eax,%eax
  8023f9:	01 d0                	add    %edx,%eax
  8023fb:	c1 e0 02             	shl    $0x2,%eax
  8023fe:	05 40 10 81 00       	add    $0x811040,%eax
  802403:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  802405:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802408:	2b 45 d0             	sub    -0x30(%ebp),%eax
  80240b:	89 c2                	mov    %eax,%edx
  80240d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802410:	89 c8                	mov    %ecx,%eax
  802412:	01 c0                	add    %eax,%eax
  802414:	01 c8                	add    %ecx,%eax
  802416:	c1 e0 02             	shl    $0x2,%eax
  802419:	05 44 10 81 00       	add    $0x811044,%eax
  80241e:	89 10                	mov    %edx,(%eax)
  802420:	eb 55                	jmp    802477 <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  802422:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802429:	8b 15 88 50 83 00    	mov    0x835088,%edx
  80242f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802432:	01 d0                	add    %edx,%eax
  802434:	48                   	dec    %eax
  802435:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802438:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80243b:	ba 00 00 00 00       	mov    $0x0,%edx
  802440:	f7 75 cc             	divl   -0x34(%ebp)
  802443:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802446:	29 d0                	sub    %edx,%eax
  802448:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  80244b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80244e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802451:	01 d0                	add    %edx,%eax
  802453:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802458:	76 0a                	jbe    802464 <sget+0x2ac>
            return NULL;
  80245a:	b8 00 00 00 00       	mov    $0x0,%eax
  80245f:	e9 ab 00 00 00       	jmp    80250f <sget+0x357>
        va = start;
  802464:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802467:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  80246a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80246d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802470:	01 d0                	add    %edx,%eax
  802472:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802477:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80247e:	eb 5e                	jmp    8024de <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  802480:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802483:	89 d0                	mov    %edx,%eax
  802485:	01 c0                	add    %eax,%eax
  802487:	01 d0                	add    %edx,%eax
  802489:	c1 e0 02             	shl    $0x2,%eax
  80248c:	05 48 50 80 00       	add    $0x805048,%eax
  802491:	8a 00                	mov    (%eax),%al
  802493:	84 c0                	test   %al,%al
  802495:	75 44                	jne    8024db <sget+0x323>
        {
            uhp_allocs[i].va = va;
  802497:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80249a:	89 d0                	mov    %edx,%eax
  80249c:	01 c0                	add    %eax,%eax
  80249e:	01 d0                	add    %edx,%eax
  8024a0:	c1 e0 02             	shl    $0x2,%eax
  8024a3:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  8024a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024ac:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  8024ae:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024b1:	89 d0                	mov    %edx,%eax
  8024b3:	01 c0                	add    %eax,%eax
  8024b5:	01 d0                	add    %edx,%eax
  8024b7:	c1 e0 02             	shl    $0x2,%eax
  8024ba:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8024c0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8024c3:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  8024c5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024c8:	89 d0                	mov    %edx,%eax
  8024ca:	01 c0                	add    %eax,%eax
  8024cc:	01 d0                	add    %edx,%eax
  8024ce:	c1 e0 02             	shl    $0x2,%eax
  8024d1:	05 48 50 80 00       	add    $0x805048,%eax
  8024d6:	c6 00 01             	movb   $0x1,(%eax)
            break;
  8024d9:	eb 0c                	jmp    8024e7 <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8024db:	ff 45 e0             	incl   -0x20(%ebp)
  8024de:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8024e5:	7e 99                	jle    802480 <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  8024e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024ea:	83 ec 04             	sub    $0x4,%esp
  8024ed:	50                   	push   %eax
  8024ee:	ff 75 0c             	pushl  0xc(%ebp)
  8024f1:	ff 75 08             	pushl  0x8(%ebp)
  8024f4:	e8 bf 0b 00 00       	call   8030b8 <sys_get_shared_object>
  8024f9:	83 c4 10             	add    $0x10,%esp
  8024fc:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  8024ff:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802503:	79 07                	jns    80250c <sget+0x354>
        return NULL;
  802505:	b8 00 00 00 00       	mov    $0x0,%eax
  80250a:	eb 03                	jmp    80250f <sget+0x357>
    return (void*)va;
  80250c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  80250f:	c9                   	leave  
  802510:	c3                   	ret    

00802511 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802511:	55                   	push   %ebp
  802512:	89 e5                	mov    %esp,%ebp
  802514:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802517:	e8 f8 f0 ff ff       	call   801614 <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  80251c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802520:	75 13                	jne    802535 <realloc+0x24>
		return malloc(new_size);
  802522:	83 ec 0c             	sub    $0xc,%esp
  802525:	ff 75 0c             	pushl  0xc(%ebp)
  802528:	e8 c4 f1 ff ff       	call   8016f1 <malloc>
  80252d:	83 c4 10             	add    $0x10,%esp
  802530:	e9 f4 05 00 00       	jmp    802b29 <realloc+0x618>
	if (new_size == 0)
  802535:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802539:	75 18                	jne    802553 <realloc+0x42>
	{
		free(virtual_address);
  80253b:	83 ec 0c             	sub    $0xc,%esp
  80253e:	ff 75 08             	pushl  0x8(%ebp)
  802541:	e8 0b f5 ff ff       	call   801a51 <free>
  802546:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802549:	b8 00 00 00 00       	mov    $0x0,%eax
  80254e:	e9 d6 05 00 00       	jmp    802b29 <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  802553:	8b 45 08             	mov    0x8(%ebp),%eax
  802556:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  802559:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80255c:	85 c0                	test   %eax,%eax
  80255e:	79 74                	jns    8025d4 <realloc+0xc3>
  802560:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  802567:	77 6b                	ja     8025d4 <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  802569:	83 ec 0c             	sub    $0xc,%esp
  80256c:	ff 75 0c             	pushl  0xc(%ebp)
  80256f:	e8 7d f1 ff ff       	call   8016f1 <malloc>
  802574:	83 c4 10             	add    $0x10,%esp
  802577:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  80257a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80257e:	75 0a                	jne    80258a <realloc+0x79>
			return NULL;
  802580:	b8 00 00 00 00       	mov    $0x0,%eax
  802585:	e9 9f 05 00 00       	jmp    802b29 <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  80258a:	83 ec 0c             	sub    $0xc,%esp
  80258d:	ff 75 08             	pushl  0x8(%ebp)
  802590:	e8 e0 11 00 00       	call   803775 <get_block_size>
  802595:	83 c4 10             	add    $0x10,%esp
  802598:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  80259b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80259e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025a1:	39 d0                	cmp    %edx,%eax
  8025a3:	76 02                	jbe    8025a7 <realloc+0x96>
  8025a5:	89 d0                	mov    %edx,%eax
  8025a7:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  8025aa:	83 ec 04             	sub    $0x4,%esp
  8025ad:	ff 75 c0             	pushl  -0x40(%ebp)
  8025b0:	ff 75 08             	pushl  0x8(%ebp)
  8025b3:	ff 75 c8             	pushl  -0x38(%ebp)
  8025b6:	e8 56 eb ff ff       	call   801111 <memmove>
  8025bb:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  8025be:	83 ec 0c             	sub    $0xc,%esp
  8025c1:	ff 75 08             	pushl  0x8(%ebp)
  8025c4:	e8 88 f4 ff ff       	call   801a51 <free>
  8025c9:	83 c4 10             	add    $0x10,%esp
		return newptr;
  8025cc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8025cf:	e9 55 05 00 00       	jmp    802b29 <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  8025d4:	a1 30 51 83 00       	mov    0x835130,%eax
  8025d9:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  8025dc:	72 09                	jb     8025e7 <realloc+0xd6>
  8025de:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  8025e5:	76 0a                	jbe    8025f1 <realloc+0xe0>
		return NULL;
  8025e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ec:	e9 38 05 00 00       	jmp    802b29 <realloc+0x618>
	uint32 oldsz = 0;
  8025f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  8025f8:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8025ff:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802606:	eb 50                	jmp    802658 <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802608:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80260b:	89 d0                	mov    %edx,%eax
  80260d:	01 c0                	add    %eax,%eax
  80260f:	01 d0                	add    %edx,%eax
  802611:	c1 e0 02             	shl    $0x2,%eax
  802614:	05 48 50 80 00       	add    $0x805048,%eax
  802619:	8a 00                	mov    (%eax),%al
  80261b:	84 c0                	test   %al,%al
  80261d:	74 36                	je     802655 <realloc+0x144>
  80261f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802622:	89 d0                	mov    %edx,%eax
  802624:	01 c0                	add    %eax,%eax
  802626:	01 d0                	add    %edx,%eax
  802628:	c1 e0 02             	shl    $0x2,%eax
  80262b:	05 40 50 80 00       	add    $0x805040,%eax
  802630:	8b 00                	mov    (%eax),%eax
  802632:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  802635:	75 1e                	jne    802655 <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  802637:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80263a:	89 d0                	mov    %edx,%eax
  80263c:	01 c0                	add    %eax,%eax
  80263e:	01 d0                	add    %edx,%eax
  802640:	c1 e0 02             	shl    $0x2,%eax
  802643:	05 44 50 80 00       	add    $0x805044,%eax
  802648:	8b 00                	mov    (%eax),%eax
  80264a:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  80264d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802650:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802653:	eb 0c                	jmp    802661 <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802655:	ff 45 ec             	incl   -0x14(%ebp)
  802658:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  80265f:	7e a7                	jle    802608 <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  802661:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802665:	75 0a                	jne    802671 <realloc+0x160>
		return NULL;
  802667:	b8 00 00 00 00       	mov    $0x0,%eax
  80266c:	e9 b8 04 00 00       	jmp    802b29 <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  802671:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  802678:	8b 55 0c             	mov    0xc(%ebp),%edx
  80267b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80267e:	01 d0                	add    %edx,%eax
  802680:	48                   	dec    %eax
  802681:	89 45 b8             	mov    %eax,-0x48(%ebp)
  802684:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802687:	ba 00 00 00 00       	mov    $0x0,%edx
  80268c:	f7 75 bc             	divl   -0x44(%ebp)
  80268f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802692:	29 d0                	sub    %edx,%eax
  802694:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  802697:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80269a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80269d:	75 08                	jne    8026a7 <realloc+0x196>
		return virtual_address;
  80269f:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a2:	e9 82 04 00 00       	jmp    802b29 <realloc+0x618>
	if (req < oldsz)
  8026a7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8026aa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8026ad:	0f 83 cd 02 00 00    	jae    802980 <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  8026b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b6:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  8026b9:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  8026bc:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8026bf:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8026c2:	01 d0                	add    %edx,%eax
  8026c4:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  8026c7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026ca:	89 d0                	mov    %edx,%eax
  8026cc:	01 c0                	add    %eax,%eax
  8026ce:	01 d0                	add    %edx,%eax
  8026d0:	c1 e0 02             	shl    $0x2,%eax
  8026d3:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8026d9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8026dc:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  8026de:	83 ec 08             	sub    $0x8,%esp
  8026e1:	ff 75 b0             	pushl  -0x50(%ebp)
  8026e4:	ff 75 ac             	pushl  -0x54(%ebp)
  8026e7:	e8 e3 0c 00 00       	call   8033cf <sys_free_user_mem>
  8026ec:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  8026ef:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8026f6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8026fd:	eb 64                	jmp    802763 <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  8026ff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802702:	89 d0                	mov    %edx,%eax
  802704:	01 c0                	add    %eax,%eax
  802706:	01 d0                	add    %edx,%eax
  802708:	c1 e0 02             	shl    $0x2,%eax
  80270b:	05 48 10 81 00       	add    $0x811048,%eax
  802710:	8a 00                	mov    (%eax),%al
  802712:	84 c0                	test   %al,%al
  802714:	75 4a                	jne    802760 <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  802716:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802719:	89 d0                	mov    %edx,%eax
  80271b:	01 c0                	add    %eax,%eax
  80271d:	01 d0                	add    %edx,%eax
  80271f:	c1 e0 02             	shl    $0x2,%eax
  802722:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  802728:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80272b:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  80272d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802730:	89 d0                	mov    %edx,%eax
  802732:	01 c0                	add    %eax,%eax
  802734:	01 d0                	add    %edx,%eax
  802736:	c1 e0 02             	shl    $0x2,%eax
  802739:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  80273f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802742:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  802744:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802747:	89 d0                	mov    %edx,%eax
  802749:	01 c0                	add    %eax,%eax
  80274b:	01 d0                	add    %edx,%eax
  80274d:	c1 e0 02             	shl    $0x2,%eax
  802750:	05 48 10 81 00       	add    $0x811048,%eax
  802755:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  802758:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80275b:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  80275e:	eb 0c                	jmp    80276c <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802760:	ff 45 e4             	incl   -0x1c(%ebp)
  802763:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  80276a:	7e 93                	jle    8026ff <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  80276c:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802770:	0f 84 8d 01 00 00    	je     802903 <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802776:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80277d:	e9 74 01 00 00       	jmp    8028f6 <realloc+0x3e5>
			{
				if (k == fidx) continue;
  802782:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802785:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802788:	0f 84 64 01 00 00    	je     8028f2 <realloc+0x3e1>
				if (uhp_frees[k].free)
  80278e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802791:	89 d0                	mov    %edx,%eax
  802793:	01 c0                	add    %eax,%eax
  802795:	01 d0                	add    %edx,%eax
  802797:	c1 e0 02             	shl    $0x2,%eax
  80279a:	05 48 10 81 00       	add    $0x811048,%eax
  80279f:	8a 00                	mov    (%eax),%al
  8027a1:	84 c0                	test   %al,%al
  8027a3:	0f 84 4a 01 00 00    	je     8028f3 <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  8027a9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027ac:	89 d0                	mov    %edx,%eax
  8027ae:	01 c0                	add    %eax,%eax
  8027b0:	01 d0                	add    %edx,%eax
  8027b2:	c1 e0 02             	shl    $0x2,%eax
  8027b5:	05 40 10 81 00       	add    $0x811040,%eax
  8027ba:	8b 08                	mov    (%eax),%ecx
  8027bc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027bf:	89 d0                	mov    %edx,%eax
  8027c1:	01 c0                	add    %eax,%eax
  8027c3:	01 d0                	add    %edx,%eax
  8027c5:	c1 e0 02             	shl    $0x2,%eax
  8027c8:	05 44 10 81 00       	add    $0x811044,%eax
  8027cd:	8b 00                	mov    (%eax),%eax
  8027cf:	01 c1                	add    %eax,%ecx
  8027d1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027d4:	89 d0                	mov    %edx,%eax
  8027d6:	01 c0                	add    %eax,%eax
  8027d8:	01 d0                	add    %edx,%eax
  8027da:	c1 e0 02             	shl    $0x2,%eax
  8027dd:	05 40 10 81 00       	add    $0x811040,%eax
  8027e2:	8b 00                	mov    (%eax),%eax
  8027e4:	39 c1                	cmp    %eax,%ecx
  8027e6:	75 7a                	jne    802862 <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  8027e8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027eb:	89 d0                	mov    %edx,%eax
  8027ed:	01 c0                	add    %eax,%eax
  8027ef:	01 d0                	add    %edx,%eax
  8027f1:	c1 e0 02             	shl    $0x2,%eax
  8027f4:	05 40 10 81 00       	add    $0x811040,%eax
  8027f9:	8b 10                	mov    (%eax),%edx
  8027fb:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  8027fe:	89 c8                	mov    %ecx,%eax
  802800:	01 c0                	add    %eax,%eax
  802802:	01 c8                	add    %ecx,%eax
  802804:	c1 e0 02             	shl    $0x2,%eax
  802807:	05 40 10 81 00       	add    $0x811040,%eax
  80280c:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  80280e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802811:	89 d0                	mov    %edx,%eax
  802813:	01 c0                	add    %eax,%eax
  802815:	01 d0                	add    %edx,%eax
  802817:	c1 e0 02             	shl    $0x2,%eax
  80281a:	05 44 10 81 00       	add    $0x811044,%eax
  80281f:	8b 08                	mov    (%eax),%ecx
  802821:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802824:	89 d0                	mov    %edx,%eax
  802826:	01 c0                	add    %eax,%eax
  802828:	01 d0                	add    %edx,%eax
  80282a:	c1 e0 02             	shl    $0x2,%eax
  80282d:	05 44 10 81 00       	add    $0x811044,%eax
  802832:	8b 00                	mov    (%eax),%eax
  802834:	01 c1                	add    %eax,%ecx
  802836:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802839:	89 d0                	mov    %edx,%eax
  80283b:	01 c0                	add    %eax,%eax
  80283d:	01 d0                	add    %edx,%eax
  80283f:	c1 e0 02             	shl    $0x2,%eax
  802842:	05 44 10 81 00       	add    $0x811044,%eax
  802847:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802849:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80284c:	89 d0                	mov    %edx,%eax
  80284e:	01 c0                	add    %eax,%eax
  802850:	01 d0                	add    %edx,%eax
  802852:	c1 e0 02             	shl    $0x2,%eax
  802855:	05 48 10 81 00       	add    $0x811048,%eax
  80285a:	c6 00 00             	movb   $0x0,(%eax)
  80285d:	e9 91 00 00 00       	jmp    8028f3 <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802862:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802865:	89 d0                	mov    %edx,%eax
  802867:	01 c0                	add    %eax,%eax
  802869:	01 d0                	add    %edx,%eax
  80286b:	c1 e0 02             	shl    $0x2,%eax
  80286e:	05 40 10 81 00       	add    $0x811040,%eax
  802873:	8b 08                	mov    (%eax),%ecx
  802875:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802878:	89 d0                	mov    %edx,%eax
  80287a:	01 c0                	add    %eax,%eax
  80287c:	01 d0                	add    %edx,%eax
  80287e:	c1 e0 02             	shl    $0x2,%eax
  802881:	05 44 10 81 00       	add    $0x811044,%eax
  802886:	8b 00                	mov    (%eax),%eax
  802888:	01 c1                	add    %eax,%ecx
  80288a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80288d:	89 d0                	mov    %edx,%eax
  80288f:	01 c0                	add    %eax,%eax
  802891:	01 d0                	add    %edx,%eax
  802893:	c1 e0 02             	shl    $0x2,%eax
  802896:	05 40 10 81 00       	add    $0x811040,%eax
  80289b:	8b 00                	mov    (%eax),%eax
  80289d:	39 c1                	cmp    %eax,%ecx
  80289f:	75 52                	jne    8028f3 <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  8028a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028a4:	89 d0                	mov    %edx,%eax
  8028a6:	01 c0                	add    %eax,%eax
  8028a8:	01 d0                	add    %edx,%eax
  8028aa:	c1 e0 02             	shl    $0x2,%eax
  8028ad:	05 44 10 81 00       	add    $0x811044,%eax
  8028b2:	8b 08                	mov    (%eax),%ecx
  8028b4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028b7:	89 d0                	mov    %edx,%eax
  8028b9:	01 c0                	add    %eax,%eax
  8028bb:	01 d0                	add    %edx,%eax
  8028bd:	c1 e0 02             	shl    $0x2,%eax
  8028c0:	05 44 10 81 00       	add    $0x811044,%eax
  8028c5:	8b 00                	mov    (%eax),%eax
  8028c7:	01 c1                	add    %eax,%ecx
  8028c9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028cc:	89 d0                	mov    %edx,%eax
  8028ce:	01 c0                	add    %eax,%eax
  8028d0:	01 d0                	add    %edx,%eax
  8028d2:	c1 e0 02             	shl    $0x2,%eax
  8028d5:	05 44 10 81 00       	add    $0x811044,%eax
  8028da:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  8028dc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028df:	89 d0                	mov    %edx,%eax
  8028e1:	01 c0                	add    %eax,%eax
  8028e3:	01 d0                	add    %edx,%eax
  8028e5:	c1 e0 02             	shl    $0x2,%eax
  8028e8:	05 48 10 81 00       	add    $0x811048,%eax
  8028ed:	c6 00 00             	movb   $0x0,(%eax)
  8028f0:	eb 01                	jmp    8028f3 <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  8028f2:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  8028f3:	ff 45 e0             	incl   -0x20(%ebp)
  8028f6:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8028fd:	0f 8e 7f fe ff ff    	jle    802782 <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  802903:	a1 30 51 83 00       	mov    0x835130,%eax
  802908:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  80290b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  802912:	eb 53                	jmp    802967 <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  802914:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802917:	89 d0                	mov    %edx,%eax
  802919:	01 c0                	add    %eax,%eax
  80291b:	01 d0                	add    %edx,%eax
  80291d:	c1 e0 02             	shl    $0x2,%eax
  802920:	05 48 50 80 00       	add    $0x805048,%eax
  802925:	8a 00                	mov    (%eax),%al
  802927:	84 c0                	test   %al,%al
  802929:	74 39                	je     802964 <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  80292b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80292e:	89 d0                	mov    %edx,%eax
  802930:	01 c0                	add    %eax,%eax
  802932:	01 d0                	add    %edx,%eax
  802934:	c1 e0 02             	shl    $0x2,%eax
  802937:	05 40 50 80 00       	add    $0x805040,%eax
  80293c:	8b 08                	mov    (%eax),%ecx
  80293e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802941:	89 d0                	mov    %edx,%eax
  802943:	01 c0                	add    %eax,%eax
  802945:	01 d0                	add    %edx,%eax
  802947:	c1 e0 02             	shl    $0x2,%eax
  80294a:	05 44 50 80 00       	add    $0x805044,%eax
  80294f:	8b 00                	mov    (%eax),%eax
  802951:	01 c8                	add    %ecx,%eax
  802953:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  802956:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802959:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80295c:	76 06                	jbe    802964 <realloc+0x453>
  80295e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802961:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802964:	ff 45 d8             	incl   -0x28(%ebp)
  802967:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  80296e:	7e a4                	jle    802914 <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  802970:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802973:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  802978:	8b 45 08             	mov    0x8(%ebp),%eax
  80297b:	e9 a9 01 00 00       	jmp    802b29 <realloc+0x618>
	}
	uint32 end = va + oldsz;
  802980:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802983:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802986:	01 d0                	add    %edx,%eax
  802988:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  80298b:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802992:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  802999:	eb 57                	jmp    8029f2 <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  80299b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80299e:	89 d0                	mov    %edx,%eax
  8029a0:	01 c0                	add    %eax,%eax
  8029a2:	01 d0                	add    %edx,%eax
  8029a4:	c1 e0 02             	shl    $0x2,%eax
  8029a7:	05 48 10 81 00       	add    $0x811048,%eax
  8029ac:	8a 00                	mov    (%eax),%al
  8029ae:	84 c0                	test   %al,%al
  8029b0:	74 3d                	je     8029ef <realloc+0x4de>
  8029b2:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8029b5:	89 d0                	mov    %edx,%eax
  8029b7:	01 c0                	add    %eax,%eax
  8029b9:	01 d0                	add    %edx,%eax
  8029bb:	c1 e0 02             	shl    $0x2,%eax
  8029be:	05 40 10 81 00       	add    $0x811040,%eax
  8029c3:	8b 00                	mov    (%eax),%eax
  8029c5:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029c8:	75 25                	jne    8029ef <realloc+0x4de>
  8029ca:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8029cd:	89 d0                	mov    %edx,%eax
  8029cf:	01 c0                	add    %eax,%eax
  8029d1:	01 d0                	add    %edx,%eax
  8029d3:	c1 e0 02             	shl    $0x2,%eax
  8029d6:	05 44 10 81 00       	add    $0x811044,%eax
  8029db:	8b 10                	mov    (%eax),%edx
  8029dd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8029e0:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8029e3:	39 c2                	cmp    %eax,%edx
  8029e5:	72 08                	jb     8029ef <realloc+0x4de>
		{
			adjIdx = j; break;
  8029e7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8029ea:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8029ed:	eb 0c                	jmp    8029fb <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8029ef:	ff 45 d0             	incl   -0x30(%ebp)
  8029f2:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  8029f9:	7e a0                	jle    80299b <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  8029fb:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  8029ff:	0f 84 d6 00 00 00    	je     802adb <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  802a05:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a08:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802a0b:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  802a0e:	83 ec 08             	sub    $0x8,%esp
  802a11:	ff 75 a0             	pushl  -0x60(%ebp)
  802a14:	ff 75 a4             	pushl  -0x5c(%ebp)
  802a17:	e8 cf 09 00 00       	call   8033eb <sys_allocate_user_mem>
  802a1c:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  802a1f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a22:	89 d0                	mov    %edx,%eax
  802a24:	01 c0                	add    %eax,%eax
  802a26:	01 d0                	add    %edx,%eax
  802a28:	c1 e0 02             	shl    $0x2,%eax
  802a2b:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802a31:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a34:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  802a36:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a39:	89 d0                	mov    %edx,%eax
  802a3b:	01 c0                	add    %eax,%eax
  802a3d:	01 d0                	add    %edx,%eax
  802a3f:	c1 e0 02             	shl    $0x2,%eax
  802a42:	05 40 10 81 00       	add    $0x811040,%eax
  802a47:	8b 10                	mov    (%eax),%edx
  802a49:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802a4c:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802a4f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a52:	89 d0                	mov    %edx,%eax
  802a54:	01 c0                	add    %eax,%eax
  802a56:	01 d0                	add    %edx,%eax
  802a58:	c1 e0 02             	shl    $0x2,%eax
  802a5b:	05 40 10 81 00       	add    $0x811040,%eax
  802a60:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  802a62:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a65:	89 d0                	mov    %edx,%eax
  802a67:	01 c0                	add    %eax,%eax
  802a69:	01 d0                	add    %edx,%eax
  802a6b:	c1 e0 02             	shl    $0x2,%eax
  802a6e:	05 44 10 81 00       	add    $0x811044,%eax
  802a73:	8b 00                	mov    (%eax),%eax
  802a75:	2b 45 a0             	sub    -0x60(%ebp),%eax
  802a78:	89 c2                	mov    %eax,%edx
  802a7a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  802a7d:	89 c8                	mov    %ecx,%eax
  802a7f:	01 c0                	add    %eax,%eax
  802a81:	01 c8                	add    %ecx,%eax
  802a83:	c1 e0 02             	shl    $0x2,%eax
  802a86:	05 44 10 81 00       	add    $0x811044,%eax
  802a8b:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  802a8d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a90:	89 d0                	mov    %edx,%eax
  802a92:	01 c0                	add    %eax,%eax
  802a94:	01 d0                	add    %edx,%eax
  802a96:	c1 e0 02             	shl    $0x2,%eax
  802a99:	05 44 10 81 00       	add    $0x811044,%eax
  802a9e:	8b 00                	mov    (%eax),%eax
  802aa0:	85 c0                	test   %eax,%eax
  802aa2:	75 14                	jne    802ab8 <realloc+0x5a7>
  802aa4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802aa7:	89 d0                	mov    %edx,%eax
  802aa9:	01 c0                	add    %eax,%eax
  802aab:	01 d0                	add    %edx,%eax
  802aad:	c1 e0 02             	shl    $0x2,%eax
  802ab0:	05 48 10 81 00       	add    $0x811048,%eax
  802ab5:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  802ab8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802abb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802abe:	01 c2                	add    %eax,%edx
  802ac0:	a1 88 50 83 00       	mov    0x835088,%eax
  802ac5:	39 c2                	cmp    %eax,%edx
  802ac7:	76 0d                	jbe    802ad6 <realloc+0x5c5>
  802ac9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802acc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802acf:	01 d0                	add    %edx,%eax
  802ad1:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  802ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad9:	eb 4e                	jmp    802b29 <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  802adb:	83 ec 0c             	sub    $0xc,%esp
  802ade:	ff 75 0c             	pushl  0xc(%ebp)
  802ae1:	e8 0b ec ff ff       	call   8016f1 <malloc>
  802ae6:	83 c4 10             	add    $0x10,%esp
  802ae9:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  802aec:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  802af0:	75 07                	jne    802af9 <realloc+0x5e8>
		return NULL;
  802af2:	b8 00 00 00 00       	mov    $0x0,%eax
  802af7:	eb 30                	jmp    802b29 <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  802af9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802afc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802aff:	39 d0                	cmp    %edx,%eax
  802b01:	76 02                	jbe    802b05 <realloc+0x5f4>
  802b03:	89 d0                	mov    %edx,%eax
  802b05:	8b 55 9c             	mov    -0x64(%ebp),%edx
  802b08:	83 ec 04             	sub    $0x4,%esp
  802b0b:	50                   	push   %eax
  802b0c:	52                   	push   %edx
  802b0d:	ff 75 cc             	pushl  -0x34(%ebp)
  802b10:	e8 cf 06 00 00       	call   8031e4 <sys_move_user_mem>
  802b15:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  802b18:	83 ec 0c             	sub    $0xc,%esp
  802b1b:	ff 75 08             	pushl  0x8(%ebp)
  802b1e:	e8 2e ef ff ff       	call   801a51 <free>
  802b23:	83 c4 10             	add    $0x10,%esp
	return newptr;
  802b26:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  802b29:	c9                   	leave  
  802b2a:	c3                   	ret    

00802b2b <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802b2b:	55                   	push   %ebp
  802b2c:	89 e5                	mov    %esp,%ebp
  802b2e:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  802b31:	8b 45 08             	mov    0x8(%ebp),%eax
  802b34:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  802b37:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802b3b:	0f 84 33 03 00 00    	je     802e74 <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  802b41:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b44:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  802b49:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  802b4c:	83 ec 08             	sub    $0x8,%esp
  802b4f:	ff 75 08             	pushl  0x8(%ebp)
  802b52:	ff 75 d8             	pushl  -0x28(%ebp)
  802b55:	e8 7d 05 00 00       	call   8030d7 <sys_delete_shared_object>
  802b5a:	83 c4 10             	add    $0x10,%esp
  802b5d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  802b60:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802b64:	0f 88 0d 03 00 00    	js     802e77 <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802b6a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802b71:	e9 ef 02 00 00       	jmp    802e65 <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802b76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b79:	89 d0                	mov    %edx,%eax
  802b7b:	01 c0                	add    %eax,%eax
  802b7d:	01 d0                	add    %edx,%eax
  802b7f:	c1 e0 02             	shl    $0x2,%eax
  802b82:	05 48 50 80 00       	add    $0x805048,%eax
  802b87:	8a 00                	mov    (%eax),%al
  802b89:	84 c0                	test   %al,%al
  802b8b:	0f 84 d1 02 00 00    	je     802e62 <sfree+0x337>
  802b91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b94:	89 d0                	mov    %edx,%eax
  802b96:	01 c0                	add    %eax,%eax
  802b98:	01 d0                	add    %edx,%eax
  802b9a:	c1 e0 02             	shl    $0x2,%eax
  802b9d:	05 40 50 80 00       	add    $0x805040,%eax
  802ba2:	8b 00                	mov    (%eax),%eax
  802ba4:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802ba7:	0f 85 b5 02 00 00    	jne    802e62 <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  802bad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bb0:	89 d0                	mov    %edx,%eax
  802bb2:	01 c0                	add    %eax,%eax
  802bb4:	01 d0                	add    %edx,%eax
  802bb6:	c1 e0 02             	shl    $0x2,%eax
  802bb9:	05 44 50 80 00       	add    $0x805044,%eax
  802bbe:	8b 00                	mov    (%eax),%eax
  802bc0:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  802bc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bc6:	89 d0                	mov    %edx,%eax
  802bc8:	01 c0                	add    %eax,%eax
  802bca:	01 d0                	add    %edx,%eax
  802bcc:	c1 e0 02             	shl    $0x2,%eax
  802bcf:	05 48 50 80 00       	add    $0x805048,%eax
  802bd4:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  802bd7:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802bde:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802be5:	eb 64                	jmp    802c4b <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  802be7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bea:	89 d0                	mov    %edx,%eax
  802bec:	01 c0                	add    %eax,%eax
  802bee:	01 d0                	add    %edx,%eax
  802bf0:	c1 e0 02             	shl    $0x2,%eax
  802bf3:	05 48 10 81 00       	add    $0x811048,%eax
  802bf8:	8a 00                	mov    (%eax),%al
  802bfa:	84 c0                	test   %al,%al
  802bfc:	75 4a                	jne    802c48 <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  802bfe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c01:	89 d0                	mov    %edx,%eax
  802c03:	01 c0                	add    %eax,%eax
  802c05:	01 d0                	add    %edx,%eax
  802c07:	c1 e0 02             	shl    $0x2,%eax
  802c0a:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  802c10:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c13:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  802c15:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c18:	89 d0                	mov    %edx,%eax
  802c1a:	01 c0                	add    %eax,%eax
  802c1c:	01 d0                	add    %edx,%eax
  802c1e:	c1 e0 02             	shl    $0x2,%eax
  802c21:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  802c27:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c2a:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  802c2c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c2f:	89 d0                	mov    %edx,%eax
  802c31:	01 c0                	add    %eax,%eax
  802c33:	01 d0                	add    %edx,%eax
  802c35:	c1 e0 02             	shl    $0x2,%eax
  802c38:	05 48 10 81 00       	add    $0x811048,%eax
  802c3d:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  802c40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c43:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  802c46:	eb 0c                	jmp    802c54 <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802c48:	ff 45 ec             	incl   -0x14(%ebp)
  802c4b:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802c52:	7e 93                	jle    802be7 <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  802c54:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802c58:	0f 84 8d 01 00 00    	je     802deb <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802c5e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802c65:	e9 74 01 00 00       	jmp    802dde <sfree+0x2b3>
				{
					if (k == fidx) continue;
  802c6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c6d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c70:	0f 84 64 01 00 00    	je     802dda <sfree+0x2af>
					if (uhp_frees[k].free)
  802c76:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c79:	89 d0                	mov    %edx,%eax
  802c7b:	01 c0                	add    %eax,%eax
  802c7d:	01 d0                	add    %edx,%eax
  802c7f:	c1 e0 02             	shl    $0x2,%eax
  802c82:	05 48 10 81 00       	add    $0x811048,%eax
  802c87:	8a 00                	mov    (%eax),%al
  802c89:	84 c0                	test   %al,%al
  802c8b:	0f 84 4a 01 00 00    	je     802ddb <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802c91:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c94:	89 d0                	mov    %edx,%eax
  802c96:	01 c0                	add    %eax,%eax
  802c98:	01 d0                	add    %edx,%eax
  802c9a:	c1 e0 02             	shl    $0x2,%eax
  802c9d:	05 40 10 81 00       	add    $0x811040,%eax
  802ca2:	8b 08                	mov    (%eax),%ecx
  802ca4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ca7:	89 d0                	mov    %edx,%eax
  802ca9:	01 c0                	add    %eax,%eax
  802cab:	01 d0                	add    %edx,%eax
  802cad:	c1 e0 02             	shl    $0x2,%eax
  802cb0:	05 44 10 81 00       	add    $0x811044,%eax
  802cb5:	8b 00                	mov    (%eax),%eax
  802cb7:	01 c1                	add    %eax,%ecx
  802cb9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cbc:	89 d0                	mov    %edx,%eax
  802cbe:	01 c0                	add    %eax,%eax
  802cc0:	01 d0                	add    %edx,%eax
  802cc2:	c1 e0 02             	shl    $0x2,%eax
  802cc5:	05 40 10 81 00       	add    $0x811040,%eax
  802cca:	8b 00                	mov    (%eax),%eax
  802ccc:	39 c1                	cmp    %eax,%ecx
  802cce:	75 7a                	jne    802d4a <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  802cd0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cd3:	89 d0                	mov    %edx,%eax
  802cd5:	01 c0                	add    %eax,%eax
  802cd7:	01 d0                	add    %edx,%eax
  802cd9:	c1 e0 02             	shl    $0x2,%eax
  802cdc:	05 40 10 81 00       	add    $0x811040,%eax
  802ce1:	8b 10                	mov    (%eax),%edx
  802ce3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802ce6:	89 c8                	mov    %ecx,%eax
  802ce8:	01 c0                	add    %eax,%eax
  802cea:	01 c8                	add    %ecx,%eax
  802cec:	c1 e0 02             	shl    $0x2,%eax
  802cef:	05 40 10 81 00       	add    $0x811040,%eax
  802cf4:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  802cf6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cf9:	89 d0                	mov    %edx,%eax
  802cfb:	01 c0                	add    %eax,%eax
  802cfd:	01 d0                	add    %edx,%eax
  802cff:	c1 e0 02             	shl    $0x2,%eax
  802d02:	05 44 10 81 00       	add    $0x811044,%eax
  802d07:	8b 08                	mov    (%eax),%ecx
  802d09:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d0c:	89 d0                	mov    %edx,%eax
  802d0e:	01 c0                	add    %eax,%eax
  802d10:	01 d0                	add    %edx,%eax
  802d12:	c1 e0 02             	shl    $0x2,%eax
  802d15:	05 44 10 81 00       	add    $0x811044,%eax
  802d1a:	8b 00                	mov    (%eax),%eax
  802d1c:	01 c1                	add    %eax,%ecx
  802d1e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d21:	89 d0                	mov    %edx,%eax
  802d23:	01 c0                	add    %eax,%eax
  802d25:	01 d0                	add    %edx,%eax
  802d27:	c1 e0 02             	shl    $0x2,%eax
  802d2a:	05 44 10 81 00       	add    $0x811044,%eax
  802d2f:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802d31:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d34:	89 d0                	mov    %edx,%eax
  802d36:	01 c0                	add    %eax,%eax
  802d38:	01 d0                	add    %edx,%eax
  802d3a:	c1 e0 02             	shl    $0x2,%eax
  802d3d:	05 48 10 81 00       	add    $0x811048,%eax
  802d42:	c6 00 00             	movb   $0x0,(%eax)
  802d45:	e9 91 00 00 00       	jmp    802ddb <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802d4a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d4d:	89 d0                	mov    %edx,%eax
  802d4f:	01 c0                	add    %eax,%eax
  802d51:	01 d0                	add    %edx,%eax
  802d53:	c1 e0 02             	shl    $0x2,%eax
  802d56:	05 40 10 81 00       	add    $0x811040,%eax
  802d5b:	8b 08                	mov    (%eax),%ecx
  802d5d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d60:	89 d0                	mov    %edx,%eax
  802d62:	01 c0                	add    %eax,%eax
  802d64:	01 d0                	add    %edx,%eax
  802d66:	c1 e0 02             	shl    $0x2,%eax
  802d69:	05 44 10 81 00       	add    $0x811044,%eax
  802d6e:	8b 00                	mov    (%eax),%eax
  802d70:	01 c1                	add    %eax,%ecx
  802d72:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d75:	89 d0                	mov    %edx,%eax
  802d77:	01 c0                	add    %eax,%eax
  802d79:	01 d0                	add    %edx,%eax
  802d7b:	c1 e0 02             	shl    $0x2,%eax
  802d7e:	05 40 10 81 00       	add    $0x811040,%eax
  802d83:	8b 00                	mov    (%eax),%eax
  802d85:	39 c1                	cmp    %eax,%ecx
  802d87:	75 52                	jne    802ddb <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  802d89:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d8c:	89 d0                	mov    %edx,%eax
  802d8e:	01 c0                	add    %eax,%eax
  802d90:	01 d0                	add    %edx,%eax
  802d92:	c1 e0 02             	shl    $0x2,%eax
  802d95:	05 44 10 81 00       	add    $0x811044,%eax
  802d9a:	8b 08                	mov    (%eax),%ecx
  802d9c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d9f:	89 d0                	mov    %edx,%eax
  802da1:	01 c0                	add    %eax,%eax
  802da3:	01 d0                	add    %edx,%eax
  802da5:	c1 e0 02             	shl    $0x2,%eax
  802da8:	05 44 10 81 00       	add    $0x811044,%eax
  802dad:	8b 00                	mov    (%eax),%eax
  802daf:	01 c1                	add    %eax,%ecx
  802db1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802db4:	89 d0                	mov    %edx,%eax
  802db6:	01 c0                	add    %eax,%eax
  802db8:	01 d0                	add    %edx,%eax
  802dba:	c1 e0 02             	shl    $0x2,%eax
  802dbd:	05 44 10 81 00       	add    $0x811044,%eax
  802dc2:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802dc4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802dc7:	89 d0                	mov    %edx,%eax
  802dc9:	01 c0                	add    %eax,%eax
  802dcb:	01 d0                	add    %edx,%eax
  802dcd:	c1 e0 02             	shl    $0x2,%eax
  802dd0:	05 48 10 81 00       	add    $0x811048,%eax
  802dd5:	c6 00 00             	movb   $0x0,(%eax)
  802dd8:	eb 01                	jmp    802ddb <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  802dda:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802ddb:	ff 45 e8             	incl   -0x18(%ebp)
  802dde:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802de5:	0f 8e 7f fe ff ff    	jle    802c6a <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  802deb:	a1 30 51 83 00       	mov    0x835130,%eax
  802df0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802df3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802dfa:	eb 53                	jmp    802e4f <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  802dfc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802dff:	89 d0                	mov    %edx,%eax
  802e01:	01 c0                	add    %eax,%eax
  802e03:	01 d0                	add    %edx,%eax
  802e05:	c1 e0 02             	shl    $0x2,%eax
  802e08:	05 48 50 80 00       	add    $0x805048,%eax
  802e0d:	8a 00                	mov    (%eax),%al
  802e0f:	84 c0                	test   %al,%al
  802e11:	74 39                	je     802e4c <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802e13:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e16:	89 d0                	mov    %edx,%eax
  802e18:	01 c0                	add    %eax,%eax
  802e1a:	01 d0                	add    %edx,%eax
  802e1c:	c1 e0 02             	shl    $0x2,%eax
  802e1f:	05 40 50 80 00       	add    $0x805040,%eax
  802e24:	8b 08                	mov    (%eax),%ecx
  802e26:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e29:	89 d0                	mov    %edx,%eax
  802e2b:	01 c0                	add    %eax,%eax
  802e2d:	01 d0                	add    %edx,%eax
  802e2f:	c1 e0 02             	shl    $0x2,%eax
  802e32:	05 44 50 80 00       	add    $0x805044,%eax
  802e37:	8b 00                	mov    (%eax),%eax
  802e39:	01 c8                	add    %ecx,%eax
  802e3b:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  802e3e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e41:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802e44:	76 06                	jbe    802e4c <sfree+0x321>
  802e46:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e49:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802e4c:	ff 45 e0             	incl   -0x20(%ebp)
  802e4f:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802e56:	7e a4                	jle    802dfc <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  802e58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e5b:	a3 88 50 83 00       	mov    %eax,0x835088
			break;
  802e60:	eb 16                	jmp    802e78 <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802e62:	ff 45 f4             	incl   -0xc(%ebp)
  802e65:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  802e6c:	0f 8e 04 fd ff ff    	jle    802b76 <sfree+0x4b>
  802e72:	eb 04                	jmp    802e78 <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  802e74:	90                   	nop
  802e75:	eb 01                	jmp    802e78 <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  802e77:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  802e78:	c9                   	leave  
  802e79:	c3                   	ret    

00802e7a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802e7a:	55                   	push   %ebp
  802e7b:	89 e5                	mov    %esp,%ebp
  802e7d:	57                   	push   %edi
  802e7e:	56                   	push   %esi
  802e7f:	53                   	push   %ebx
  802e80:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802e83:	8b 45 08             	mov    0x8(%ebp),%eax
  802e86:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e89:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802e8c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802e8f:	8b 7d 18             	mov    0x18(%ebp),%edi
  802e92:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802e95:	cd 30                	int    $0x30
  802e97:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802e9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802e9d:	83 c4 10             	add    $0x10,%esp
  802ea0:	5b                   	pop    %ebx
  802ea1:	5e                   	pop    %esi
  802ea2:	5f                   	pop    %edi
  802ea3:	5d                   	pop    %ebp
  802ea4:	c3                   	ret    

00802ea5 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802ea5:	55                   	push   %ebp
  802ea6:	89 e5                	mov    %esp,%ebp
  802ea8:	83 ec 04             	sub    $0x4,%esp
  802eab:	8b 45 10             	mov    0x10(%ebp),%eax
  802eae:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802eb1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802eb4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebb:	6a 00                	push   $0x0
  802ebd:	51                   	push   %ecx
  802ebe:	52                   	push   %edx
  802ebf:	ff 75 0c             	pushl  0xc(%ebp)
  802ec2:	50                   	push   %eax
  802ec3:	6a 00                	push   $0x0
  802ec5:	e8 b0 ff ff ff       	call   802e7a <syscall>
  802eca:	83 c4 18             	add    $0x18,%esp
}
  802ecd:	90                   	nop
  802ece:	c9                   	leave  
  802ecf:	c3                   	ret    

00802ed0 <sys_cgetc>:

int
sys_cgetc(void)
{
  802ed0:	55                   	push   %ebp
  802ed1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802ed3:	6a 00                	push   $0x0
  802ed5:	6a 00                	push   $0x0
  802ed7:	6a 00                	push   $0x0
  802ed9:	6a 00                	push   $0x0
  802edb:	6a 00                	push   $0x0
  802edd:	6a 02                	push   $0x2
  802edf:	e8 96 ff ff ff       	call   802e7a <syscall>
  802ee4:	83 c4 18             	add    $0x18,%esp
}
  802ee7:	c9                   	leave  
  802ee8:	c3                   	ret    

00802ee9 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802ee9:	55                   	push   %ebp
  802eea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802eec:	6a 00                	push   $0x0
  802eee:	6a 00                	push   $0x0
  802ef0:	6a 00                	push   $0x0
  802ef2:	6a 00                	push   $0x0
  802ef4:	6a 00                	push   $0x0
  802ef6:	6a 03                	push   $0x3
  802ef8:	e8 7d ff ff ff       	call   802e7a <syscall>
  802efd:	83 c4 18             	add    $0x18,%esp
}
  802f00:	90                   	nop
  802f01:	c9                   	leave  
  802f02:	c3                   	ret    

00802f03 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802f03:	55                   	push   %ebp
  802f04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802f06:	6a 00                	push   $0x0
  802f08:	6a 00                	push   $0x0
  802f0a:	6a 00                	push   $0x0
  802f0c:	6a 00                	push   $0x0
  802f0e:	6a 00                	push   $0x0
  802f10:	6a 04                	push   $0x4
  802f12:	e8 63 ff ff ff       	call   802e7a <syscall>
  802f17:	83 c4 18             	add    $0x18,%esp
}
  802f1a:	90                   	nop
  802f1b:	c9                   	leave  
  802f1c:	c3                   	ret    

00802f1d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802f1d:	55                   	push   %ebp
  802f1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802f20:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f23:	8b 45 08             	mov    0x8(%ebp),%eax
  802f26:	6a 00                	push   $0x0
  802f28:	6a 00                	push   $0x0
  802f2a:	6a 00                	push   $0x0
  802f2c:	52                   	push   %edx
  802f2d:	50                   	push   %eax
  802f2e:	6a 08                	push   $0x8
  802f30:	e8 45 ff ff ff       	call   802e7a <syscall>
  802f35:	83 c4 18             	add    $0x18,%esp
}
  802f38:	c9                   	leave  
  802f39:	c3                   	ret    

00802f3a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802f3a:	55                   	push   %ebp
  802f3b:	89 e5                	mov    %esp,%ebp
  802f3d:	56                   	push   %esi
  802f3e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802f3f:	8b 75 18             	mov    0x18(%ebp),%esi
  802f42:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802f45:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802f48:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4e:	56                   	push   %esi
  802f4f:	53                   	push   %ebx
  802f50:	51                   	push   %ecx
  802f51:	52                   	push   %edx
  802f52:	50                   	push   %eax
  802f53:	6a 09                	push   $0x9
  802f55:	e8 20 ff ff ff       	call   802e7a <syscall>
  802f5a:	83 c4 18             	add    $0x18,%esp
}
  802f5d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802f60:	5b                   	pop    %ebx
  802f61:	5e                   	pop    %esi
  802f62:	5d                   	pop    %ebp
  802f63:	c3                   	ret    

00802f64 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802f64:	55                   	push   %ebp
  802f65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802f67:	6a 00                	push   $0x0
  802f69:	6a 00                	push   $0x0
  802f6b:	6a 00                	push   $0x0
  802f6d:	6a 00                	push   $0x0
  802f6f:	ff 75 08             	pushl  0x8(%ebp)
  802f72:	6a 0a                	push   $0xa
  802f74:	e8 01 ff ff ff       	call   802e7a <syscall>
  802f79:	83 c4 18             	add    $0x18,%esp
}
  802f7c:	c9                   	leave  
  802f7d:	c3                   	ret    

00802f7e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802f7e:	55                   	push   %ebp
  802f7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802f81:	6a 00                	push   $0x0
  802f83:	6a 00                	push   $0x0
  802f85:	6a 00                	push   $0x0
  802f87:	ff 75 0c             	pushl  0xc(%ebp)
  802f8a:	ff 75 08             	pushl  0x8(%ebp)
  802f8d:	6a 0b                	push   $0xb
  802f8f:	e8 e6 fe ff ff       	call   802e7a <syscall>
  802f94:	83 c4 18             	add    $0x18,%esp
}
  802f97:	c9                   	leave  
  802f98:	c3                   	ret    

00802f99 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802f99:	55                   	push   %ebp
  802f9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802f9c:	6a 00                	push   $0x0
  802f9e:	6a 00                	push   $0x0
  802fa0:	6a 00                	push   $0x0
  802fa2:	6a 00                	push   $0x0
  802fa4:	6a 00                	push   $0x0
  802fa6:	6a 0c                	push   $0xc
  802fa8:	e8 cd fe ff ff       	call   802e7a <syscall>
  802fad:	83 c4 18             	add    $0x18,%esp
}
  802fb0:	c9                   	leave  
  802fb1:	c3                   	ret    

00802fb2 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802fb2:	55                   	push   %ebp
  802fb3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802fb5:	6a 00                	push   $0x0
  802fb7:	6a 00                	push   $0x0
  802fb9:	6a 00                	push   $0x0
  802fbb:	6a 00                	push   $0x0
  802fbd:	6a 00                	push   $0x0
  802fbf:	6a 0d                	push   $0xd
  802fc1:	e8 b4 fe ff ff       	call   802e7a <syscall>
  802fc6:	83 c4 18             	add    $0x18,%esp
}
  802fc9:	c9                   	leave  
  802fca:	c3                   	ret    

00802fcb <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802fcb:	55                   	push   %ebp
  802fcc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802fce:	6a 00                	push   $0x0
  802fd0:	6a 00                	push   $0x0
  802fd2:	6a 00                	push   $0x0
  802fd4:	6a 00                	push   $0x0
  802fd6:	6a 00                	push   $0x0
  802fd8:	6a 0e                	push   $0xe
  802fda:	e8 9b fe ff ff       	call   802e7a <syscall>
  802fdf:	83 c4 18             	add    $0x18,%esp
}
  802fe2:	c9                   	leave  
  802fe3:	c3                   	ret    

00802fe4 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802fe4:	55                   	push   %ebp
  802fe5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802fe7:	6a 00                	push   $0x0
  802fe9:	6a 00                	push   $0x0
  802feb:	6a 00                	push   $0x0
  802fed:	6a 00                	push   $0x0
  802fef:	6a 00                	push   $0x0
  802ff1:	6a 0f                	push   $0xf
  802ff3:	e8 82 fe ff ff       	call   802e7a <syscall>
  802ff8:	83 c4 18             	add    $0x18,%esp
}
  802ffb:	c9                   	leave  
  802ffc:	c3                   	ret    

00802ffd <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802ffd:	55                   	push   %ebp
  802ffe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  803000:	6a 00                	push   $0x0
  803002:	6a 00                	push   $0x0
  803004:	6a 00                	push   $0x0
  803006:	6a 00                	push   $0x0
  803008:	ff 75 08             	pushl  0x8(%ebp)
  80300b:	6a 10                	push   $0x10
  80300d:	e8 68 fe ff ff       	call   802e7a <syscall>
  803012:	83 c4 18             	add    $0x18,%esp
}
  803015:	c9                   	leave  
  803016:	c3                   	ret    

00803017 <sys_scarce_memory>:

void sys_scarce_memory()
{
  803017:	55                   	push   %ebp
  803018:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80301a:	6a 00                	push   $0x0
  80301c:	6a 00                	push   $0x0
  80301e:	6a 00                	push   $0x0
  803020:	6a 00                	push   $0x0
  803022:	6a 00                	push   $0x0
  803024:	6a 11                	push   $0x11
  803026:	e8 4f fe ff ff       	call   802e7a <syscall>
  80302b:	83 c4 18             	add    $0x18,%esp
}
  80302e:	90                   	nop
  80302f:	c9                   	leave  
  803030:	c3                   	ret    

00803031 <sys_cputc>:

void
sys_cputc(const char c)
{
  803031:	55                   	push   %ebp
  803032:	89 e5                	mov    %esp,%ebp
  803034:	83 ec 04             	sub    $0x4,%esp
  803037:	8b 45 08             	mov    0x8(%ebp),%eax
  80303a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80303d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803041:	6a 00                	push   $0x0
  803043:	6a 00                	push   $0x0
  803045:	6a 00                	push   $0x0
  803047:	6a 00                	push   $0x0
  803049:	50                   	push   %eax
  80304a:	6a 01                	push   $0x1
  80304c:	e8 29 fe ff ff       	call   802e7a <syscall>
  803051:	83 c4 18             	add    $0x18,%esp
}
  803054:	90                   	nop
  803055:	c9                   	leave  
  803056:	c3                   	ret    

00803057 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  803057:	55                   	push   %ebp
  803058:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80305a:	6a 00                	push   $0x0
  80305c:	6a 00                	push   $0x0
  80305e:	6a 00                	push   $0x0
  803060:	6a 00                	push   $0x0
  803062:	6a 00                	push   $0x0
  803064:	6a 14                	push   $0x14
  803066:	e8 0f fe ff ff       	call   802e7a <syscall>
  80306b:	83 c4 18             	add    $0x18,%esp
}
  80306e:	90                   	nop
  80306f:	c9                   	leave  
  803070:	c3                   	ret    

00803071 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  803071:	55                   	push   %ebp
  803072:	89 e5                	mov    %esp,%ebp
  803074:	83 ec 04             	sub    $0x4,%esp
  803077:	8b 45 10             	mov    0x10(%ebp),%eax
  80307a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80307d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803080:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803084:	8b 45 08             	mov    0x8(%ebp),%eax
  803087:	6a 00                	push   $0x0
  803089:	51                   	push   %ecx
  80308a:	52                   	push   %edx
  80308b:	ff 75 0c             	pushl  0xc(%ebp)
  80308e:	50                   	push   %eax
  80308f:	6a 15                	push   $0x15
  803091:	e8 e4 fd ff ff       	call   802e7a <syscall>
  803096:	83 c4 18             	add    $0x18,%esp
}
  803099:	c9                   	leave  
  80309a:	c3                   	ret    

0080309b <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80309b:	55                   	push   %ebp
  80309c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80309e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a4:	6a 00                	push   $0x0
  8030a6:	6a 00                	push   $0x0
  8030a8:	6a 00                	push   $0x0
  8030aa:	52                   	push   %edx
  8030ab:	50                   	push   %eax
  8030ac:	6a 16                	push   $0x16
  8030ae:	e8 c7 fd ff ff       	call   802e7a <syscall>
  8030b3:	83 c4 18             	add    $0x18,%esp
}
  8030b6:	c9                   	leave  
  8030b7:	c3                   	ret    

008030b8 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8030b8:	55                   	push   %ebp
  8030b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8030bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8030be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c4:	6a 00                	push   $0x0
  8030c6:	6a 00                	push   $0x0
  8030c8:	51                   	push   %ecx
  8030c9:	52                   	push   %edx
  8030ca:	50                   	push   %eax
  8030cb:	6a 17                	push   $0x17
  8030cd:	e8 a8 fd ff ff       	call   802e7a <syscall>
  8030d2:	83 c4 18             	add    $0x18,%esp
}
  8030d5:	c9                   	leave  
  8030d6:	c3                   	ret    

008030d7 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8030d7:	55                   	push   %ebp
  8030d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8030da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e0:	6a 00                	push   $0x0
  8030e2:	6a 00                	push   $0x0
  8030e4:	6a 00                	push   $0x0
  8030e6:	52                   	push   %edx
  8030e7:	50                   	push   %eax
  8030e8:	6a 18                	push   $0x18
  8030ea:	e8 8b fd ff ff       	call   802e7a <syscall>
  8030ef:	83 c4 18             	add    $0x18,%esp
}
  8030f2:	c9                   	leave  
  8030f3:	c3                   	ret    

008030f4 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8030f4:	55                   	push   %ebp
  8030f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8030f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fa:	6a 00                	push   $0x0
  8030fc:	ff 75 14             	pushl  0x14(%ebp)
  8030ff:	ff 75 10             	pushl  0x10(%ebp)
  803102:	ff 75 0c             	pushl  0xc(%ebp)
  803105:	50                   	push   %eax
  803106:	6a 19                	push   $0x19
  803108:	e8 6d fd ff ff       	call   802e7a <syscall>
  80310d:	83 c4 18             	add    $0x18,%esp
}
  803110:	c9                   	leave  
  803111:	c3                   	ret    

00803112 <sys_run_env>:

void sys_run_env(int32 envId)
{
  803112:	55                   	push   %ebp
  803113:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  803115:	8b 45 08             	mov    0x8(%ebp),%eax
  803118:	6a 00                	push   $0x0
  80311a:	6a 00                	push   $0x0
  80311c:	6a 00                	push   $0x0
  80311e:	6a 00                	push   $0x0
  803120:	50                   	push   %eax
  803121:	6a 1a                	push   $0x1a
  803123:	e8 52 fd ff ff       	call   802e7a <syscall>
  803128:	83 c4 18             	add    $0x18,%esp
}
  80312b:	90                   	nop
  80312c:	c9                   	leave  
  80312d:	c3                   	ret    

0080312e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80312e:	55                   	push   %ebp
  80312f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  803131:	8b 45 08             	mov    0x8(%ebp),%eax
  803134:	6a 00                	push   $0x0
  803136:	6a 00                	push   $0x0
  803138:	6a 00                	push   $0x0
  80313a:	6a 00                	push   $0x0
  80313c:	50                   	push   %eax
  80313d:	6a 1b                	push   $0x1b
  80313f:	e8 36 fd ff ff       	call   802e7a <syscall>
  803144:	83 c4 18             	add    $0x18,%esp
}
  803147:	c9                   	leave  
  803148:	c3                   	ret    

00803149 <sys_getenvid>:

int32 sys_getenvid(void)
{
  803149:	55                   	push   %ebp
  80314a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80314c:	6a 00                	push   $0x0
  80314e:	6a 00                	push   $0x0
  803150:	6a 00                	push   $0x0
  803152:	6a 00                	push   $0x0
  803154:	6a 00                	push   $0x0
  803156:	6a 05                	push   $0x5
  803158:	e8 1d fd ff ff       	call   802e7a <syscall>
  80315d:	83 c4 18             	add    $0x18,%esp
}
  803160:	c9                   	leave  
  803161:	c3                   	ret    

00803162 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  803162:	55                   	push   %ebp
  803163:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  803165:	6a 00                	push   $0x0
  803167:	6a 00                	push   $0x0
  803169:	6a 00                	push   $0x0
  80316b:	6a 00                	push   $0x0
  80316d:	6a 00                	push   $0x0
  80316f:	6a 06                	push   $0x6
  803171:	e8 04 fd ff ff       	call   802e7a <syscall>
  803176:	83 c4 18             	add    $0x18,%esp
}
  803179:	c9                   	leave  
  80317a:	c3                   	ret    

0080317b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80317b:	55                   	push   %ebp
  80317c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80317e:	6a 00                	push   $0x0
  803180:	6a 00                	push   $0x0
  803182:	6a 00                	push   $0x0
  803184:	6a 00                	push   $0x0
  803186:	6a 00                	push   $0x0
  803188:	6a 07                	push   $0x7
  80318a:	e8 eb fc ff ff       	call   802e7a <syscall>
  80318f:	83 c4 18             	add    $0x18,%esp
}
  803192:	c9                   	leave  
  803193:	c3                   	ret    

00803194 <sys_exit_env>:


void sys_exit_env(void)
{
  803194:	55                   	push   %ebp
  803195:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  803197:	6a 00                	push   $0x0
  803199:	6a 00                	push   $0x0
  80319b:	6a 00                	push   $0x0
  80319d:	6a 00                	push   $0x0
  80319f:	6a 00                	push   $0x0
  8031a1:	6a 1c                	push   $0x1c
  8031a3:	e8 d2 fc ff ff       	call   802e7a <syscall>
  8031a8:	83 c4 18             	add    $0x18,%esp
}
  8031ab:	90                   	nop
  8031ac:	c9                   	leave  
  8031ad:	c3                   	ret    

008031ae <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8031ae:	55                   	push   %ebp
  8031af:	89 e5                	mov    %esp,%ebp
  8031b1:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8031b4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8031b7:	8d 50 04             	lea    0x4(%eax),%edx
  8031ba:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8031bd:	6a 00                	push   $0x0
  8031bf:	6a 00                	push   $0x0
  8031c1:	6a 00                	push   $0x0
  8031c3:	52                   	push   %edx
  8031c4:	50                   	push   %eax
  8031c5:	6a 1d                	push   $0x1d
  8031c7:	e8 ae fc ff ff       	call   802e7a <syscall>
  8031cc:	83 c4 18             	add    $0x18,%esp
	return result;
  8031cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8031d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8031d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8031d8:	89 01                	mov    %eax,(%ecx)
  8031da:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8031dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e0:	c9                   	leave  
  8031e1:	c2 04 00             	ret    $0x4

008031e4 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8031e4:	55                   	push   %ebp
  8031e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8031e7:	6a 00                	push   $0x0
  8031e9:	6a 00                	push   $0x0
  8031eb:	ff 75 10             	pushl  0x10(%ebp)
  8031ee:	ff 75 0c             	pushl  0xc(%ebp)
  8031f1:	ff 75 08             	pushl  0x8(%ebp)
  8031f4:	6a 13                	push   $0x13
  8031f6:	e8 7f fc ff ff       	call   802e7a <syscall>
  8031fb:	83 c4 18             	add    $0x18,%esp
	return ;
  8031fe:	90                   	nop
}
  8031ff:	c9                   	leave  
  803200:	c3                   	ret    

00803201 <sys_rcr2>:
uint32 sys_rcr2()
{
  803201:	55                   	push   %ebp
  803202:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  803204:	6a 00                	push   $0x0
  803206:	6a 00                	push   $0x0
  803208:	6a 00                	push   $0x0
  80320a:	6a 00                	push   $0x0
  80320c:	6a 00                	push   $0x0
  80320e:	6a 1e                	push   $0x1e
  803210:	e8 65 fc ff ff       	call   802e7a <syscall>
  803215:	83 c4 18             	add    $0x18,%esp
}
  803218:	c9                   	leave  
  803219:	c3                   	ret    

0080321a <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80321a:	55                   	push   %ebp
  80321b:	89 e5                	mov    %esp,%ebp
  80321d:	83 ec 04             	sub    $0x4,%esp
  803220:	8b 45 08             	mov    0x8(%ebp),%eax
  803223:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803226:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80322a:	6a 00                	push   $0x0
  80322c:	6a 00                	push   $0x0
  80322e:	6a 00                	push   $0x0
  803230:	6a 00                	push   $0x0
  803232:	50                   	push   %eax
  803233:	6a 1f                	push   $0x1f
  803235:	e8 40 fc ff ff       	call   802e7a <syscall>
  80323a:	83 c4 18             	add    $0x18,%esp
	return ;
  80323d:	90                   	nop
}
  80323e:	c9                   	leave  
  80323f:	c3                   	ret    

00803240 <rsttst>:
void rsttst()
{
  803240:	55                   	push   %ebp
  803241:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803243:	6a 00                	push   $0x0
  803245:	6a 00                	push   $0x0
  803247:	6a 00                	push   $0x0
  803249:	6a 00                	push   $0x0
  80324b:	6a 00                	push   $0x0
  80324d:	6a 21                	push   $0x21
  80324f:	e8 26 fc ff ff       	call   802e7a <syscall>
  803254:	83 c4 18             	add    $0x18,%esp
	return ;
  803257:	90                   	nop
}
  803258:	c9                   	leave  
  803259:	c3                   	ret    

0080325a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80325a:	55                   	push   %ebp
  80325b:	89 e5                	mov    %esp,%ebp
  80325d:	83 ec 04             	sub    $0x4,%esp
  803260:	8b 45 14             	mov    0x14(%ebp),%eax
  803263:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803266:	8b 55 18             	mov    0x18(%ebp),%edx
  803269:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80326d:	52                   	push   %edx
  80326e:	50                   	push   %eax
  80326f:	ff 75 10             	pushl  0x10(%ebp)
  803272:	ff 75 0c             	pushl  0xc(%ebp)
  803275:	ff 75 08             	pushl  0x8(%ebp)
  803278:	6a 20                	push   $0x20
  80327a:	e8 fb fb ff ff       	call   802e7a <syscall>
  80327f:	83 c4 18             	add    $0x18,%esp
	return ;
  803282:	90                   	nop
}
  803283:	c9                   	leave  
  803284:	c3                   	ret    

00803285 <chktst>:
void chktst(uint32 n)
{
  803285:	55                   	push   %ebp
  803286:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803288:	6a 00                	push   $0x0
  80328a:	6a 00                	push   $0x0
  80328c:	6a 00                	push   $0x0
  80328e:	6a 00                	push   $0x0
  803290:	ff 75 08             	pushl  0x8(%ebp)
  803293:	6a 22                	push   $0x22
  803295:	e8 e0 fb ff ff       	call   802e7a <syscall>
  80329a:	83 c4 18             	add    $0x18,%esp
	return ;
  80329d:	90                   	nop
}
  80329e:	c9                   	leave  
  80329f:	c3                   	ret    

008032a0 <inctst>:

void inctst()
{
  8032a0:	55                   	push   %ebp
  8032a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8032a3:	6a 00                	push   $0x0
  8032a5:	6a 00                	push   $0x0
  8032a7:	6a 00                	push   $0x0
  8032a9:	6a 00                	push   $0x0
  8032ab:	6a 00                	push   $0x0
  8032ad:	6a 23                	push   $0x23
  8032af:	e8 c6 fb ff ff       	call   802e7a <syscall>
  8032b4:	83 c4 18             	add    $0x18,%esp
	return ;
  8032b7:	90                   	nop
}
  8032b8:	c9                   	leave  
  8032b9:	c3                   	ret    

008032ba <gettst>:
uint32 gettst()
{
  8032ba:	55                   	push   %ebp
  8032bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8032bd:	6a 00                	push   $0x0
  8032bf:	6a 00                	push   $0x0
  8032c1:	6a 00                	push   $0x0
  8032c3:	6a 00                	push   $0x0
  8032c5:	6a 00                	push   $0x0
  8032c7:	6a 24                	push   $0x24
  8032c9:	e8 ac fb ff ff       	call   802e7a <syscall>
  8032ce:	83 c4 18             	add    $0x18,%esp
}
  8032d1:	c9                   	leave  
  8032d2:	c3                   	ret    

008032d3 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8032d3:	55                   	push   %ebp
  8032d4:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8032d6:	6a 00                	push   $0x0
  8032d8:	6a 00                	push   $0x0
  8032da:	6a 00                	push   $0x0
  8032dc:	6a 00                	push   $0x0
  8032de:	6a 00                	push   $0x0
  8032e0:	6a 25                	push   $0x25
  8032e2:	e8 93 fb ff ff       	call   802e7a <syscall>
  8032e7:	83 c4 18             	add    $0x18,%esp
  8032ea:	a3 80 50 83 00       	mov    %eax,0x835080
	return uheapPlaceStrategy ;
  8032ef:	a1 80 50 83 00       	mov    0x835080,%eax
}
  8032f4:	c9                   	leave  
  8032f5:	c3                   	ret    

008032f6 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8032f6:	55                   	push   %ebp
  8032f7:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8032f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fc:	a3 80 50 83 00       	mov    %eax,0x835080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803301:	6a 00                	push   $0x0
  803303:	6a 00                	push   $0x0
  803305:	6a 00                	push   $0x0
  803307:	6a 00                	push   $0x0
  803309:	ff 75 08             	pushl  0x8(%ebp)
  80330c:	6a 26                	push   $0x26
  80330e:	e8 67 fb ff ff       	call   802e7a <syscall>
  803313:	83 c4 18             	add    $0x18,%esp
	return ;
  803316:	90                   	nop
}
  803317:	c9                   	leave  
  803318:	c3                   	ret    

00803319 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  803319:	55                   	push   %ebp
  80331a:	89 e5                	mov    %esp,%ebp
  80331c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80331d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803320:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803323:	8b 55 0c             	mov    0xc(%ebp),%edx
  803326:	8b 45 08             	mov    0x8(%ebp),%eax
  803329:	6a 00                	push   $0x0
  80332b:	53                   	push   %ebx
  80332c:	51                   	push   %ecx
  80332d:	52                   	push   %edx
  80332e:	50                   	push   %eax
  80332f:	6a 27                	push   $0x27
  803331:	e8 44 fb ff ff       	call   802e7a <syscall>
  803336:	83 c4 18             	add    $0x18,%esp
}
  803339:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80333c:	c9                   	leave  
  80333d:	c3                   	ret    

0080333e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80333e:	55                   	push   %ebp
  80333f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803341:	8b 55 0c             	mov    0xc(%ebp),%edx
  803344:	8b 45 08             	mov    0x8(%ebp),%eax
  803347:	6a 00                	push   $0x0
  803349:	6a 00                	push   $0x0
  80334b:	6a 00                	push   $0x0
  80334d:	52                   	push   %edx
  80334e:	50                   	push   %eax
  80334f:	6a 28                	push   $0x28
  803351:	e8 24 fb ff ff       	call   802e7a <syscall>
  803356:	83 c4 18             	add    $0x18,%esp
}
  803359:	c9                   	leave  
  80335a:	c3                   	ret    

0080335b <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80335b:	55                   	push   %ebp
  80335c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80335e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803361:	8b 55 0c             	mov    0xc(%ebp),%edx
  803364:	8b 45 08             	mov    0x8(%ebp),%eax
  803367:	6a 00                	push   $0x0
  803369:	51                   	push   %ecx
  80336a:	ff 75 10             	pushl  0x10(%ebp)
  80336d:	52                   	push   %edx
  80336e:	50                   	push   %eax
  80336f:	6a 29                	push   $0x29
  803371:	e8 04 fb ff ff       	call   802e7a <syscall>
  803376:	83 c4 18             	add    $0x18,%esp
}
  803379:	c9                   	leave  
  80337a:	c3                   	ret    

0080337b <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80337b:	55                   	push   %ebp
  80337c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80337e:	6a 00                	push   $0x0
  803380:	6a 00                	push   $0x0
  803382:	ff 75 10             	pushl  0x10(%ebp)
  803385:	ff 75 0c             	pushl  0xc(%ebp)
  803388:	ff 75 08             	pushl  0x8(%ebp)
  80338b:	6a 12                	push   $0x12
  80338d:	e8 e8 fa ff ff       	call   802e7a <syscall>
  803392:	83 c4 18             	add    $0x18,%esp
	return ;
  803395:	90                   	nop
}
  803396:	c9                   	leave  
  803397:	c3                   	ret    

00803398 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  803398:	55                   	push   %ebp
  803399:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80339b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80339e:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a1:	6a 00                	push   $0x0
  8033a3:	6a 00                	push   $0x0
  8033a5:	6a 00                	push   $0x0
  8033a7:	52                   	push   %edx
  8033a8:	50                   	push   %eax
  8033a9:	6a 2a                	push   $0x2a
  8033ab:	e8 ca fa ff ff       	call   802e7a <syscall>
  8033b0:	83 c4 18             	add    $0x18,%esp
	return;
  8033b3:	90                   	nop
}
  8033b4:	c9                   	leave  
  8033b5:	c3                   	ret    

008033b6 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8033b6:	55                   	push   %ebp
  8033b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8033b9:	6a 00                	push   $0x0
  8033bb:	6a 00                	push   $0x0
  8033bd:	6a 00                	push   $0x0
  8033bf:	6a 00                	push   $0x0
  8033c1:	6a 00                	push   $0x0
  8033c3:	6a 2b                	push   $0x2b
  8033c5:	e8 b0 fa ff ff       	call   802e7a <syscall>
  8033ca:	83 c4 18             	add    $0x18,%esp
}
  8033cd:	c9                   	leave  
  8033ce:	c3                   	ret    

008033cf <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8033cf:	55                   	push   %ebp
  8033d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8033d2:	6a 00                	push   $0x0
  8033d4:	6a 00                	push   $0x0
  8033d6:	6a 00                	push   $0x0
  8033d8:	ff 75 0c             	pushl  0xc(%ebp)
  8033db:	ff 75 08             	pushl  0x8(%ebp)
  8033de:	6a 2d                	push   $0x2d
  8033e0:	e8 95 fa ff ff       	call   802e7a <syscall>
  8033e5:	83 c4 18             	add    $0x18,%esp
	return;
  8033e8:	90                   	nop
}
  8033e9:	c9                   	leave  
  8033ea:	c3                   	ret    

008033eb <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8033eb:	55                   	push   %ebp
  8033ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8033ee:	6a 00                	push   $0x0
  8033f0:	6a 00                	push   $0x0
  8033f2:	6a 00                	push   $0x0
  8033f4:	ff 75 0c             	pushl  0xc(%ebp)
  8033f7:	ff 75 08             	pushl  0x8(%ebp)
  8033fa:	6a 2c                	push   $0x2c
  8033fc:	e8 79 fa ff ff       	call   802e7a <syscall>
  803401:	83 c4 18             	add    $0x18,%esp
	return ;
  803404:	90                   	nop
}
  803405:	c9                   	leave  
  803406:	c3                   	ret    

00803407 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  803407:	55                   	push   %ebp
  803408:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80340a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80340d:	8b 45 08             	mov    0x8(%ebp),%eax
  803410:	6a 00                	push   $0x0
  803412:	6a 00                	push   $0x0
  803414:	6a 00                	push   $0x0
  803416:	52                   	push   %edx
  803417:	50                   	push   %eax
  803418:	6a 2e                	push   $0x2e
  80341a:	e8 5b fa ff ff       	call   802e7a <syscall>
  80341f:	83 c4 18             	add    $0x18,%esp
}
  803422:	90                   	nop
  803423:	c9                   	leave  
  803424:	c3                   	ret    

00803425 <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  803425:	55                   	push   %ebp
  803426:	89 e5                	mov    %esp,%ebp
  803428:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  80342b:	81 7d 08 80 d0 81 00 	cmpl   $0x81d080,0x8(%ebp)
  803432:	72 09                	jb     80343d <to_page_va+0x18>
  803434:	81 7d 08 80 50 83 00 	cmpl   $0x835080,0x8(%ebp)
  80343b:	72 14                	jb     803451 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  80343d:	83 ec 04             	sub    $0x4,%esp
  803440:	68 98 4b 80 00       	push   $0x804b98
  803445:	6a 15                	push   $0x15
  803447:	68 c3 4b 80 00       	push   $0x804bc3
  80344c:	e8 10 d0 ff ff       	call   800461 <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803451:	8b 45 08             	mov    0x8(%ebp),%eax
  803454:	ba 80 d0 81 00       	mov    $0x81d080,%edx
  803459:	29 d0                	sub    %edx,%eax
  80345b:	c1 f8 02             	sar    $0x2,%eax
  80345e:	89 c2                	mov    %eax,%edx
  803460:	89 d0                	mov    %edx,%eax
  803462:	c1 e0 02             	shl    $0x2,%eax
  803465:	01 d0                	add    %edx,%eax
  803467:	c1 e0 02             	shl    $0x2,%eax
  80346a:	01 d0                	add    %edx,%eax
  80346c:	c1 e0 02             	shl    $0x2,%eax
  80346f:	01 d0                	add    %edx,%eax
  803471:	89 c1                	mov    %eax,%ecx
  803473:	c1 e1 08             	shl    $0x8,%ecx
  803476:	01 c8                	add    %ecx,%eax
  803478:	89 c1                	mov    %eax,%ecx
  80347a:	c1 e1 10             	shl    $0x10,%ecx
  80347d:	01 c8                	add    %ecx,%eax
  80347f:	01 c0                	add    %eax,%eax
  803481:	01 d0                	add    %edx,%eax
  803483:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  803486:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803489:	c1 e0 0c             	shl    $0xc,%eax
  80348c:	89 c2                	mov    %eax,%edx
  80348e:	a1 84 50 83 00       	mov    0x835084,%eax
  803493:	01 d0                	add    %edx,%eax
}
  803495:	c9                   	leave  
  803496:	c3                   	ret    

00803497 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  803497:	55                   	push   %ebp
  803498:	89 e5                	mov    %esp,%ebp
  80349a:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  80349d:	a1 84 50 83 00       	mov    0x835084,%eax
  8034a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8034a5:	29 c2                	sub    %eax,%edx
  8034a7:	89 d0                	mov    %edx,%eax
  8034a9:	c1 e8 0c             	shr    $0xc,%eax
  8034ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  8034af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034b3:	78 09                	js     8034be <to_page_info+0x27>
  8034b5:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  8034bc:	7e 14                	jle    8034d2 <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  8034be:	83 ec 04             	sub    $0x4,%esp
  8034c1:	68 dc 4b 80 00       	push   $0x804bdc
  8034c6:	6a 21                	push   $0x21
  8034c8:	68 c3 4b 80 00       	push   $0x804bc3
  8034cd:	e8 8f cf ff ff       	call   800461 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  8034d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034d5:	89 d0                	mov    %edx,%eax
  8034d7:	01 c0                	add    %eax,%eax
  8034d9:	01 d0                	add    %edx,%eax
  8034db:	c1 e0 02             	shl    $0x2,%eax
  8034de:	05 80 d0 81 00       	add    $0x81d080,%eax
}
  8034e3:	c9                   	leave  
  8034e4:	c3                   	ret    

008034e5 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8034e5:	55                   	push   %ebp
  8034e6:	89 e5                	mov    %esp,%ebp
  8034e8:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8034eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ee:	05 00 00 00 02       	add    $0x2000000,%eax
  8034f3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8034f6:	73 16                	jae    80350e <initialize_dynamic_allocator+0x29>
  8034f8:	68 00 4c 80 00       	push   $0x804c00
  8034fd:	68 26 4c 80 00       	push   $0x804c26
  803502:	6a 2f                	push   $0x2f
  803504:	68 c3 4b 80 00       	push   $0x804bc3
  803509:	e8 53 cf ff ff       	call   800461 <_panic>
	dynAllocStart = daStart;
  80350e:	8b 45 08             	mov    0x8(%ebp),%eax
  803511:	a3 84 50 83 00       	mov    %eax,0x835084
	dynAllocEnd = daEnd;
  803516:	8b 45 0c             	mov    0xc(%ebp),%eax
  803519:	a3 60 d0 81 00       	mov    %eax,0x81d060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  80351e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803525:	eb 36                	jmp    80355d <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  803527:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80352a:	c1 e0 04             	shl    $0x4,%eax
  80352d:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803532:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803538:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80353b:	c1 e0 04             	shl    $0x4,%eax
  80353e:	05 a4 50 83 00       	add    $0x8350a4,%eax
  803543:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354c:	c1 e0 04             	shl    $0x4,%eax
  80354f:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803554:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  80355a:	ff 45 f4             	incl   -0xc(%ebp)
  80355d:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  803561:	7e c4                	jle    803527 <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  803563:	c7 05 68 d0 81 00 00 	movl   $0x0,0x81d068
  80356a:	00 00 00 
  80356d:	c7 05 6c d0 81 00 00 	movl   $0x0,0x81d06c
  803574:	00 00 00 
  803577:	c7 05 74 d0 81 00 00 	movl   $0x0,0x81d074
  80357e:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803581:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803588:	e9 1b 01 00 00       	jmp    8036a8 <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  80358d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803590:	89 d0                	mov    %edx,%eax
  803592:	01 c0                	add    %eax,%eax
  803594:	01 d0                	add    %edx,%eax
  803596:	c1 e0 02             	shl    $0x2,%eax
  803599:	05 88 d0 81 00       	add    $0x81d088,%eax
  80359e:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  8035a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035a6:	89 d0                	mov    %edx,%eax
  8035a8:	01 c0                	add    %eax,%eax
  8035aa:	01 d0                	add    %edx,%eax
  8035ac:	c1 e0 02             	shl    $0x2,%eax
  8035af:	05 8a d0 81 00       	add    $0x81d08a,%eax
  8035b4:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  8035b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035bc:	89 d0                	mov    %edx,%eax
  8035be:	01 c0                	add    %eax,%eax
  8035c0:	01 d0                	add    %edx,%eax
  8035c2:	c1 e0 02             	shl    $0x2,%eax
  8035c5:	05 80 d0 81 00       	add    $0x81d080,%eax
  8035ca:	8b 00                	mov    (%eax),%eax
  8035cc:	85 c0                	test   %eax,%eax
  8035ce:	74 2b                	je     8035fb <initialize_dynamic_allocator+0x116>
  8035d0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035d3:	89 d0                	mov    %edx,%eax
  8035d5:	01 c0                	add    %eax,%eax
  8035d7:	01 d0                	add    %edx,%eax
  8035d9:	c1 e0 02             	shl    $0x2,%eax
  8035dc:	05 80 d0 81 00       	add    $0x81d080,%eax
  8035e1:	8b 10                	mov    (%eax),%edx
  8035e3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8035e6:	89 c8                	mov    %ecx,%eax
  8035e8:	01 c0                	add    %eax,%eax
  8035ea:	01 c8                	add    %ecx,%eax
  8035ec:	c1 e0 02             	shl    $0x2,%eax
  8035ef:	05 84 d0 81 00       	add    $0x81d084,%eax
  8035f4:	8b 00                	mov    (%eax),%eax
  8035f6:	89 42 04             	mov    %eax,0x4(%edx)
  8035f9:	eb 18                	jmp    803613 <initialize_dynamic_allocator+0x12e>
  8035fb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035fe:	89 d0                	mov    %edx,%eax
  803600:	01 c0                	add    %eax,%eax
  803602:	01 d0                	add    %edx,%eax
  803604:	c1 e0 02             	shl    $0x2,%eax
  803607:	05 84 d0 81 00       	add    $0x81d084,%eax
  80360c:	8b 00                	mov    (%eax),%eax
  80360e:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803613:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803616:	89 d0                	mov    %edx,%eax
  803618:	01 c0                	add    %eax,%eax
  80361a:	01 d0                	add    %edx,%eax
  80361c:	c1 e0 02             	shl    $0x2,%eax
  80361f:	05 84 d0 81 00       	add    $0x81d084,%eax
  803624:	8b 00                	mov    (%eax),%eax
  803626:	85 c0                	test   %eax,%eax
  803628:	74 2a                	je     803654 <initialize_dynamic_allocator+0x16f>
  80362a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80362d:	89 d0                	mov    %edx,%eax
  80362f:	01 c0                	add    %eax,%eax
  803631:	01 d0                	add    %edx,%eax
  803633:	c1 e0 02             	shl    $0x2,%eax
  803636:	05 84 d0 81 00       	add    $0x81d084,%eax
  80363b:	8b 10                	mov    (%eax),%edx
  80363d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803640:	89 c8                	mov    %ecx,%eax
  803642:	01 c0                	add    %eax,%eax
  803644:	01 c8                	add    %ecx,%eax
  803646:	c1 e0 02             	shl    $0x2,%eax
  803649:	05 80 d0 81 00       	add    $0x81d080,%eax
  80364e:	8b 00                	mov    (%eax),%eax
  803650:	89 02                	mov    %eax,(%edx)
  803652:	eb 18                	jmp    80366c <initialize_dynamic_allocator+0x187>
  803654:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803657:	89 d0                	mov    %edx,%eax
  803659:	01 c0                	add    %eax,%eax
  80365b:	01 d0                	add    %edx,%eax
  80365d:	c1 e0 02             	shl    $0x2,%eax
  803660:	05 80 d0 81 00       	add    $0x81d080,%eax
  803665:	8b 00                	mov    (%eax),%eax
  803667:	a3 68 d0 81 00       	mov    %eax,0x81d068
  80366c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80366f:	89 d0                	mov    %edx,%eax
  803671:	01 c0                	add    %eax,%eax
  803673:	01 d0                	add    %edx,%eax
  803675:	c1 e0 02             	shl    $0x2,%eax
  803678:	05 80 d0 81 00       	add    $0x81d080,%eax
  80367d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803683:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803686:	89 d0                	mov    %edx,%eax
  803688:	01 c0                	add    %eax,%eax
  80368a:	01 d0                	add    %edx,%eax
  80368c:	c1 e0 02             	shl    $0x2,%eax
  80368f:	05 84 d0 81 00       	add    $0x81d084,%eax
  803694:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80369a:	a1 74 d0 81 00       	mov    0x81d074,%eax
  80369f:	48                   	dec    %eax
  8036a0:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  8036a5:	ff 45 f0             	incl   -0x10(%ebp)
  8036a8:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  8036af:	0f 8e d8 fe ff ff    	jle    80358d <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  8036b5:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  8036bc:	e9 9d 00 00 00       	jmp    80375e <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  8036c1:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8036c7:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  8036ca:	89 c8                	mov    %ecx,%eax
  8036cc:	01 c0                	add    %eax,%eax
  8036ce:	01 c8                	add    %ecx,%eax
  8036d0:	c1 e0 02             	shl    $0x2,%eax
  8036d3:	05 80 d0 81 00       	add    $0x81d080,%eax
  8036d8:	89 10                	mov    %edx,(%eax)
  8036da:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036dd:	89 d0                	mov    %edx,%eax
  8036df:	01 c0                	add    %eax,%eax
  8036e1:	01 d0                	add    %edx,%eax
  8036e3:	c1 e0 02             	shl    $0x2,%eax
  8036e6:	05 80 d0 81 00       	add    $0x81d080,%eax
  8036eb:	8b 00                	mov    (%eax),%eax
  8036ed:	85 c0                	test   %eax,%eax
  8036ef:	74 1c                	je     80370d <initialize_dynamic_allocator+0x228>
  8036f1:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8036f7:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  8036fa:	89 c8                	mov    %ecx,%eax
  8036fc:	01 c0                	add    %eax,%eax
  8036fe:	01 c8                	add    %ecx,%eax
  803700:	c1 e0 02             	shl    $0x2,%eax
  803703:	05 80 d0 81 00       	add    $0x81d080,%eax
  803708:	89 42 04             	mov    %eax,0x4(%edx)
  80370b:	eb 16                	jmp    803723 <initialize_dynamic_allocator+0x23e>
  80370d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803710:	89 d0                	mov    %edx,%eax
  803712:	01 c0                	add    %eax,%eax
  803714:	01 d0                	add    %edx,%eax
  803716:	c1 e0 02             	shl    $0x2,%eax
  803719:	05 80 d0 81 00       	add    $0x81d080,%eax
  80371e:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803723:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803726:	89 d0                	mov    %edx,%eax
  803728:	01 c0                	add    %eax,%eax
  80372a:	01 d0                	add    %edx,%eax
  80372c:	c1 e0 02             	shl    $0x2,%eax
  80372f:	05 80 d0 81 00       	add    $0x81d080,%eax
  803734:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803739:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80373c:	89 d0                	mov    %edx,%eax
  80373e:	01 c0                	add    %eax,%eax
  803740:	01 d0                	add    %edx,%eax
  803742:	c1 e0 02             	shl    $0x2,%eax
  803745:	05 84 d0 81 00       	add    $0x81d084,%eax
  80374a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803750:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803755:	40                   	inc    %eax
  803756:	a3 74 d0 81 00       	mov    %eax,0x81d074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  80375b:	ff 4d ec             	decl   -0x14(%ebp)
  80375e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803762:	0f 89 59 ff ff ff    	jns    8036c1 <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  803768:	c7 05 44 d0 81 00 01 	movl   $0x1,0x81d044
  80376f:	00 00 00 
}
  803772:	90                   	nop
  803773:	c9                   	leave  
  803774:	c3                   	ret    

00803775 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  803775:	55                   	push   %ebp
  803776:	89 e5                	mov    %esp,%ebp
  803778:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  80377b:	8b 45 08             	mov    0x8(%ebp),%eax
  80377e:	83 ec 0c             	sub    $0xc,%esp
  803781:	50                   	push   %eax
  803782:	e8 10 fd ff ff       	call   803497 <to_page_info>
  803787:	83 c4 10             	add    $0x10,%esp
  80378a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  80378d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803790:	8b 40 08             	mov    0x8(%eax),%eax
  803793:	0f b7 c0             	movzwl %ax,%eax
}
  803796:	c9                   	leave  
  803797:	c3                   	ret    

00803798 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803798:	55                   	push   %ebp
  803799:	89 e5                	mov    %esp,%ebp
  80379b:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  80379e:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8037a5:	76 16                	jbe    8037bd <alloc_block+0x25>
  8037a7:	68 3c 4c 80 00       	push   $0x804c3c
  8037ac:	68 26 4c 80 00       	push   $0x804c26
  8037b1:	6a 59                	push   $0x59
  8037b3:	68 c3 4b 80 00       	push   $0x804bc3
  8037b8:	e8 a4 cc ff ff       	call   800461 <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  8037bd:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  8037c4:	eb 08                	jmp    8037ce <alloc_block+0x36>
		allocSize <<= 1;
  8037c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c9:	01 c0                	add    %eax,%eax
  8037cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  8037ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037d4:	73 09                	jae    8037df <alloc_block+0x47>
  8037d6:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  8037dd:	76 e7                	jbe    8037c6 <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  8037df:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  8037e6:	eb 03                	jmp    8037eb <alloc_block+0x53>
		listIndex++;
  8037e8:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  8037eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037ee:	ba 08 00 00 00       	mov    $0x8,%edx
  8037f3:	88 c1                	mov    %al,%cl
  8037f5:	d3 e2                	shl    %cl,%edx
  8037f7:	89 d0                	mov    %edx,%eax
  8037f9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8037fc:	72 ea                	jb     8037e8 <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8037fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803801:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803804:	e9 f4 00 00 00       	jmp    8038fd <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  803809:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80380c:	c1 e0 04             	shl    $0x4,%eax
  80380f:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803814:	8b 00                	mov    (%eax),%eax
  803816:	85 c0                	test   %eax,%eax
  803818:	0f 84 dc 00 00 00    	je     8038fa <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  80381e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803821:	c1 e0 04             	shl    $0x4,%eax
  803824:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803829:	8b 00                	mov    (%eax),%eax
  80382b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  80382e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803832:	75 14                	jne    803848 <alloc_block+0xb0>
  803834:	83 ec 04             	sub    $0x4,%esp
  803837:	68 5d 4c 80 00       	push   $0x804c5d
  80383c:	6a 6b                	push   $0x6b
  80383e:	68 c3 4b 80 00       	push   $0x804bc3
  803843:	e8 19 cc ff ff       	call   800461 <_panic>
  803848:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80384b:	8b 00                	mov    (%eax),%eax
  80384d:	85 c0                	test   %eax,%eax
  80384f:	74 10                	je     803861 <alloc_block+0xc9>
  803851:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803854:	8b 00                	mov    (%eax),%eax
  803856:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803859:	8b 52 04             	mov    0x4(%edx),%edx
  80385c:	89 50 04             	mov    %edx,0x4(%eax)
  80385f:	eb 14                	jmp    803875 <alloc_block+0xdd>
  803861:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803864:	8b 40 04             	mov    0x4(%eax),%eax
  803867:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80386a:	c1 e2 04             	shl    $0x4,%edx
  80386d:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803873:	89 02                	mov    %eax,(%edx)
  803875:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803878:	8b 40 04             	mov    0x4(%eax),%eax
  80387b:	85 c0                	test   %eax,%eax
  80387d:	74 0f                	je     80388e <alloc_block+0xf6>
  80387f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803882:	8b 40 04             	mov    0x4(%eax),%eax
  803885:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803888:	8b 12                	mov    (%edx),%edx
  80388a:	89 10                	mov    %edx,(%eax)
  80388c:	eb 13                	jmp    8038a1 <alloc_block+0x109>
  80388e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803891:	8b 00                	mov    (%eax),%eax
  803893:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803896:	c1 e2 04             	shl    $0x4,%edx
  803899:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  80389f:	89 02                	mov    %eax,(%edx)
  8038a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038b7:	c1 e0 04             	shl    $0x4,%eax
  8038ba:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8038bf:	8b 00                	mov    (%eax),%eax
  8038c1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8038c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038c7:	c1 e0 04             	shl    $0x4,%eax
  8038ca:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8038cf:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  8038d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038d4:	83 ec 0c             	sub    $0xc,%esp
  8038d7:	50                   	push   %eax
  8038d8:	e8 ba fb ff ff       	call   803497 <to_page_info>
  8038dd:	83 c4 10             	add    $0x10,%esp
  8038e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  8038e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038e6:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8038ea:	48                   	dec    %eax
  8038eb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8038ee:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  8038f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f5:	e9 8f 02 00 00       	jmp    803b89 <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8038fa:	ff 45 ec             	incl   -0x14(%ebp)
  8038fd:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803901:	0f 8e 02 ff ff ff    	jle    803809 <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  803907:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80390c:	85 c0                	test   %eax,%eax
  80390e:	75 14                	jne    803924 <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  803910:	83 ec 04             	sub    $0x4,%esp
  803913:	68 7c 4c 80 00       	push   $0x804c7c
  803918:	6a 77                	push   $0x77
  80391a:	68 c3 4b 80 00       	push   $0x804bc3
  80391f:	e8 3d cb ff ff       	call   800461 <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  803924:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803929:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  80392c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803930:	75 14                	jne    803946 <alloc_block+0x1ae>
  803932:	83 ec 04             	sub    $0x4,%esp
  803935:	68 5d 4c 80 00       	push   $0x804c5d
  80393a:	6a 7a                	push   $0x7a
  80393c:	68 c3 4b 80 00       	push   $0x804bc3
  803941:	e8 1b cb ff ff       	call   800461 <_panic>
  803946:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803949:	8b 00                	mov    (%eax),%eax
  80394b:	85 c0                	test   %eax,%eax
  80394d:	74 10                	je     80395f <alloc_block+0x1c7>
  80394f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803952:	8b 00                	mov    (%eax),%eax
  803954:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803957:	8b 52 04             	mov    0x4(%edx),%edx
  80395a:	89 50 04             	mov    %edx,0x4(%eax)
  80395d:	eb 0b                	jmp    80396a <alloc_block+0x1d2>
  80395f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803962:	8b 40 04             	mov    0x4(%eax),%eax
  803965:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  80396a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80396d:	8b 40 04             	mov    0x4(%eax),%eax
  803970:	85 c0                	test   %eax,%eax
  803972:	74 0f                	je     803983 <alloc_block+0x1eb>
  803974:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803977:	8b 40 04             	mov    0x4(%eax),%eax
  80397a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80397d:	8b 12                	mov    (%edx),%edx
  80397f:	89 10                	mov    %edx,(%eax)
  803981:	eb 0a                	jmp    80398d <alloc_block+0x1f5>
  803983:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803986:	8b 00                	mov    (%eax),%eax
  803988:	a3 68 d0 81 00       	mov    %eax,0x81d068
  80398d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803990:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803996:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803999:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039a0:	a1 74 d0 81 00       	mov    0x81d074,%eax
  8039a5:	48                   	dec    %eax
  8039a6:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  8039ab:	83 ec 0c             	sub    $0xc,%esp
  8039ae:	ff 75 dc             	pushl  -0x24(%ebp)
  8039b1:	e8 6f fa ff ff       	call   803425 <to_page_va>
  8039b6:	83 c4 10             	add    $0x10,%esp
  8039b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  8039bc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8039bf:	83 ec 0c             	sub    $0xc,%esp
  8039c2:	50                   	push   %eax
  8039c3:	e8 a0 dc ff ff       	call   801668 <get_page>
  8039c8:	83 c4 10             	add    $0x10,%esp
  8039cb:	85 c0                	test   %eax,%eax
  8039cd:	74 14                	je     8039e3 <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  8039cf:	83 ec 04             	sub    $0x4,%esp
  8039d2:	68 a4 4c 80 00       	push   $0x804ca4
  8039d7:	6a 7f                	push   $0x7f
  8039d9:	68 c3 4b 80 00       	push   $0x804bc3
  8039de:	e8 7e ca ff ff       	call   800461 <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  8039e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039e6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8039e9:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  8039ed:	b8 00 10 00 00       	mov    $0x1000,%eax
  8039f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8039f7:	f7 75 f4             	divl   -0xc(%ebp)
  8039fa:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8039fd:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803a01:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803a08:	e9 a7 00 00 00       	jmp    803ab4 <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  803a0d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803a10:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a13:	01 d0                	add    %edx,%eax
  803a15:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  803a18:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803a1c:	75 17                	jne    803a35 <alloc_block+0x29d>
  803a1e:	83 ec 04             	sub    $0x4,%esp
  803a21:	68 cc 4c 80 00       	push   $0x804ccc
  803a26:	68 88 00 00 00       	push   $0x88
  803a2b:	68 c3 4b 80 00       	push   $0x804bc3
  803a30:	e8 2c ca ff ff       	call   800461 <_panic>
  803a35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a38:	c1 e0 04             	shl    $0x4,%eax
  803a3b:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803a40:	8b 10                	mov    (%eax),%edx
  803a42:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a45:	89 10                	mov    %edx,(%eax)
  803a47:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a4a:	8b 00                	mov    (%eax),%eax
  803a4c:	85 c0                	test   %eax,%eax
  803a4e:	74 15                	je     803a65 <alloc_block+0x2cd>
  803a50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a53:	c1 e0 04             	shl    $0x4,%eax
  803a56:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803a5b:	8b 00                	mov    (%eax),%eax
  803a5d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a60:	89 50 04             	mov    %edx,0x4(%eax)
  803a63:	eb 11                	jmp    803a76 <alloc_block+0x2de>
  803a65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a68:	c1 e0 04             	shl    $0x4,%eax
  803a6b:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803a71:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a74:	89 02                	mov    %eax,(%edx)
  803a76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a79:	c1 e0 04             	shl    $0x4,%eax
  803a7c:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803a82:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a85:	89 02                	mov    %eax,(%edx)
  803a87:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a8a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a94:	c1 e0 04             	shl    $0x4,%eax
  803a97:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803a9c:	8b 00                	mov    (%eax),%eax
  803a9e:	8d 50 01             	lea    0x1(%eax),%edx
  803aa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803aa4:	c1 e0 04             	shl    $0x4,%eax
  803aa7:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803aac:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ab1:	01 45 e8             	add    %eax,-0x18(%ebp)
  803ab4:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  803abb:	0f 86 4c ff ff ff    	jbe    803a0d <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  803ac1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ac4:	c1 e0 04             	shl    $0x4,%eax
  803ac7:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803acc:	8b 00                	mov    (%eax),%eax
  803ace:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  803ad1:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803ad5:	75 17                	jne    803aee <alloc_block+0x356>
  803ad7:	83 ec 04             	sub    $0x4,%esp
  803ada:	68 5d 4c 80 00       	push   $0x804c5d
  803adf:	68 8d 00 00 00       	push   $0x8d
  803ae4:	68 c3 4b 80 00       	push   $0x804bc3
  803ae9:	e8 73 c9 ff ff       	call   800461 <_panic>
  803aee:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803af1:	8b 00                	mov    (%eax),%eax
  803af3:	85 c0                	test   %eax,%eax
  803af5:	74 10                	je     803b07 <alloc_block+0x36f>
  803af7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803afa:	8b 00                	mov    (%eax),%eax
  803afc:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803aff:	8b 52 04             	mov    0x4(%edx),%edx
  803b02:	89 50 04             	mov    %edx,0x4(%eax)
  803b05:	eb 14                	jmp    803b1b <alloc_block+0x383>
  803b07:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b0a:	8b 40 04             	mov    0x4(%eax),%eax
  803b0d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b10:	c1 e2 04             	shl    $0x4,%edx
  803b13:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803b19:	89 02                	mov    %eax,(%edx)
  803b1b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b1e:	8b 40 04             	mov    0x4(%eax),%eax
  803b21:	85 c0                	test   %eax,%eax
  803b23:	74 0f                	je     803b34 <alloc_block+0x39c>
  803b25:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b28:	8b 40 04             	mov    0x4(%eax),%eax
  803b2b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803b2e:	8b 12                	mov    (%edx),%edx
  803b30:	89 10                	mov    %edx,(%eax)
  803b32:	eb 13                	jmp    803b47 <alloc_block+0x3af>
  803b34:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b37:	8b 00                	mov    (%eax),%eax
  803b39:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b3c:	c1 e2 04             	shl    $0x4,%edx
  803b3f:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803b45:	89 02                	mov    %eax,(%edx)
  803b47:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b4a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b50:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b53:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b5d:	c1 e0 04             	shl    $0x4,%eax
  803b60:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803b65:	8b 00                	mov    (%eax),%eax
  803b67:	8d 50 ff             	lea    -0x1(%eax),%edx
  803b6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b6d:	c1 e0 04             	shl    $0x4,%eax
  803b70:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803b75:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  803b77:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b7a:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803b7e:	48                   	dec    %eax
  803b7f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803b82:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  803b86:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  803b89:	c9                   	leave  
  803b8a:	c3                   	ret    

00803b8b <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803b8b:	55                   	push   %ebp
  803b8c:	89 e5                	mov    %esp,%ebp
  803b8e:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803b91:	8b 55 08             	mov    0x8(%ebp),%edx
  803b94:	a1 84 50 83 00       	mov    0x835084,%eax
  803b99:	39 c2                	cmp    %eax,%edx
  803b9b:	72 0c                	jb     803ba9 <free_block+0x1e>
  803b9d:	8b 55 08             	mov    0x8(%ebp),%edx
  803ba0:	a1 60 d0 81 00       	mov    0x81d060,%eax
  803ba5:	39 c2                	cmp    %eax,%edx
  803ba7:	72 19                	jb     803bc2 <free_block+0x37>
  803ba9:	68 f0 4c 80 00       	push   $0x804cf0
  803bae:	68 26 4c 80 00       	push   $0x804c26
  803bb3:	68 98 00 00 00       	push   $0x98
  803bb8:	68 c3 4b 80 00       	push   $0x804bc3
  803bbd:	e8 9f c8 ff ff       	call   800461 <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  803bc5:	83 ec 0c             	sub    $0xc,%esp
  803bc8:	50                   	push   %eax
  803bc9:	e8 c9 f8 ff ff       	call   803497 <to_page_info>
  803bce:	83 c4 10             	add    $0x10,%esp
  803bd1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  803bd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bd7:	8b 40 08             	mov    0x8(%eax),%eax
  803bda:	0f b7 c0             	movzwl %ax,%eax
  803bdd:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  803be0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803be7:	eb 03                	jmp    803bec <free_block+0x61>
		listIndex++;
  803be9:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bef:	ba 08 00 00 00       	mov    $0x8,%edx
  803bf4:	88 c1                	mov    %al,%cl
  803bf6:	d3 e2                	shl    %cl,%edx
  803bf8:	89 d0                	mov    %edx,%eax
  803bfa:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803bfd:	72 ea                	jb     803be9 <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  803bff:	8b 45 08             	mov    0x8(%ebp),%eax
  803c02:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  803c05:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c09:	75 17                	jne    803c22 <free_block+0x97>
  803c0b:	83 ec 04             	sub    $0x4,%esp
  803c0e:	68 cc 4c 80 00       	push   $0x804ccc
  803c13:	68 a2 00 00 00       	push   $0xa2
  803c18:	68 c3 4b 80 00       	push   $0x804bc3
  803c1d:	e8 3f c8 ff ff       	call   800461 <_panic>
  803c22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c25:	c1 e0 04             	shl    $0x4,%eax
  803c28:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803c2d:	8b 10                	mov    (%eax),%edx
  803c2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c32:	89 10                	mov    %edx,(%eax)
  803c34:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c37:	8b 00                	mov    (%eax),%eax
  803c39:	85 c0                	test   %eax,%eax
  803c3b:	74 15                	je     803c52 <free_block+0xc7>
  803c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c40:	c1 e0 04             	shl    $0x4,%eax
  803c43:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803c48:	8b 00                	mov    (%eax),%eax
  803c4a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c4d:	89 50 04             	mov    %edx,0x4(%eax)
  803c50:	eb 11                	jmp    803c63 <free_block+0xd8>
  803c52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c55:	c1 e0 04             	shl    $0x4,%eax
  803c58:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803c5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c61:	89 02                	mov    %eax,(%edx)
  803c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c66:	c1 e0 04             	shl    $0x4,%eax
  803c69:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803c6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c72:	89 02                	mov    %eax,(%edx)
  803c74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c77:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c81:	c1 e0 04             	shl    $0x4,%eax
  803c84:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803c89:	8b 00                	mov    (%eax),%eax
  803c8b:	8d 50 01             	lea    0x1(%eax),%edx
  803c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c91:	c1 e0 04             	shl    $0x4,%eax
  803c94:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803c99:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  803c9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c9e:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803ca2:	40                   	inc    %eax
  803ca3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803ca6:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  803caa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cad:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803cb1:	0f b7 c8             	movzwl %ax,%ecx
  803cb4:	b8 00 10 00 00       	mov    $0x1000,%eax
  803cb9:	ba 00 00 00 00       	mov    $0x0,%edx
  803cbe:	f7 75 e8             	divl   -0x18(%ebp)
  803cc1:	39 c1                	cmp    %eax,%ecx
  803cc3:	0f 85 ed 01 00 00    	jne    803eb6 <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803cc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ccc:	c1 e0 04             	shl    $0x4,%eax
  803ccf:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803cd4:	8b 00                	mov    (%eax),%eax
  803cd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803cd9:	eb 2a                	jmp    803d05 <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  803cdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cde:	83 ec 0c             	sub    $0xc,%esp
  803ce1:	50                   	push   %eax
  803ce2:	e8 b0 f7 ff ff       	call   803497 <to_page_info>
  803ce7:	83 c4 10             	add    $0x10,%esp
  803cea:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803ced:	75 06                	jne    803cf5 <free_block+0x16a>
				tmp = b;
  803cef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cf2:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cf8:	c1 e0 04             	shl    $0x4,%eax
  803cfb:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803d00:	8b 00                	mov    (%eax),%eax
  803d02:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803d05:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d09:	74 07                	je     803d12 <free_block+0x187>
  803d0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d0e:	8b 00                	mov    (%eax),%eax
  803d10:	eb 05                	jmp    803d17 <free_block+0x18c>
  803d12:	b8 00 00 00 00       	mov    $0x0,%eax
  803d17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d1a:	c1 e2 04             	shl    $0x4,%edx
  803d1d:	81 c2 a8 50 83 00    	add    $0x8350a8,%edx
  803d23:	89 02                	mov    %eax,(%edx)
  803d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d28:	c1 e0 04             	shl    $0x4,%eax
  803d2b:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803d30:	8b 00                	mov    (%eax),%eax
  803d32:	85 c0                	test   %eax,%eax
  803d34:	75 a5                	jne    803cdb <free_block+0x150>
  803d36:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d3a:	75 9f                	jne    803cdb <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  803d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d3f:	c1 e0 04             	shl    $0x4,%eax
  803d42:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803d47:	8b 00                	mov    (%eax),%eax
  803d49:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  803d4c:	e9 cc 00 00 00       	jmp    803e1d <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  803d51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d54:	8b 00                	mov    (%eax),%eax
  803d56:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  803d59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d5c:	83 ec 0c             	sub    $0xc,%esp
  803d5f:	50                   	push   %eax
  803d60:	e8 32 f7 ff ff       	call   803497 <to_page_info>
  803d65:	83 c4 10             	add    $0x10,%esp
  803d68:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803d6b:	0f 85 a6 00 00 00    	jne    803e17 <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  803d71:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d75:	75 17                	jne    803d8e <free_block+0x203>
  803d77:	83 ec 04             	sub    $0x4,%esp
  803d7a:	68 5d 4c 80 00       	push   $0x804c5d
  803d7f:	68 b5 00 00 00       	push   $0xb5
  803d84:	68 c3 4b 80 00       	push   $0x804bc3
  803d89:	e8 d3 c6 ff ff       	call   800461 <_panic>
  803d8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d91:	8b 00                	mov    (%eax),%eax
  803d93:	85 c0                	test   %eax,%eax
  803d95:	74 10                	je     803da7 <free_block+0x21c>
  803d97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d9a:	8b 00                	mov    (%eax),%eax
  803d9c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d9f:	8b 52 04             	mov    0x4(%edx),%edx
  803da2:	89 50 04             	mov    %edx,0x4(%eax)
  803da5:	eb 14                	jmp    803dbb <free_block+0x230>
  803da7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803daa:	8b 40 04             	mov    0x4(%eax),%eax
  803dad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803db0:	c1 e2 04             	shl    $0x4,%edx
  803db3:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803db9:	89 02                	mov    %eax,(%edx)
  803dbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dbe:	8b 40 04             	mov    0x4(%eax),%eax
  803dc1:	85 c0                	test   %eax,%eax
  803dc3:	74 0f                	je     803dd4 <free_block+0x249>
  803dc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dc8:	8b 40 04             	mov    0x4(%eax),%eax
  803dcb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803dce:	8b 12                	mov    (%edx),%edx
  803dd0:	89 10                	mov    %edx,(%eax)
  803dd2:	eb 13                	jmp    803de7 <free_block+0x25c>
  803dd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dd7:	8b 00                	mov    (%eax),%eax
  803dd9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ddc:	c1 e2 04             	shl    $0x4,%edx
  803ddf:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803de5:	89 02                	mov    %eax,(%edx)
  803de7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803df0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803df3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803dfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dfd:	c1 e0 04             	shl    $0x4,%eax
  803e00:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803e05:	8b 00                	mov    (%eax),%eax
  803e07:	8d 50 ff             	lea    -0x1(%eax),%edx
  803e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e0d:	c1 e0 04             	shl    $0x4,%eax
  803e10:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803e15:	89 10                	mov    %edx,(%eax)
			b = next;
  803e17:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  803e1d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803e21:	0f 85 2a ff ff ff    	jne    803d51 <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  803e27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e2a:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  803e30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e33:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  803e39:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803e3d:	75 17                	jne    803e56 <free_block+0x2cb>
  803e3f:	83 ec 04             	sub    $0x4,%esp
  803e42:	68 cc 4c 80 00       	push   $0x804ccc
  803e47:	68 bc 00 00 00       	push   $0xbc
  803e4c:	68 c3 4b 80 00       	push   $0x804bc3
  803e51:	e8 0b c6 ff ff       	call   800461 <_panic>
  803e56:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803e5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e5f:	89 10                	mov    %edx,(%eax)
  803e61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e64:	8b 00                	mov    (%eax),%eax
  803e66:	85 c0                	test   %eax,%eax
  803e68:	74 0d                	je     803e77 <free_block+0x2ec>
  803e6a:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803e6f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e72:	89 50 04             	mov    %edx,0x4(%eax)
  803e75:	eb 08                	jmp    803e7f <free_block+0x2f4>
  803e77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e7a:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803e7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e82:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803e87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e8a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e91:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803e96:	40                   	inc    %eax
  803e97:	a3 74 d0 81 00       	mov    %eax,0x81d074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  803e9c:	83 ec 0c             	sub    $0xc,%esp
  803e9f:	ff 75 ec             	pushl  -0x14(%ebp)
  803ea2:	e8 7e f5 ff ff       	call   803425 <to_page_va>
  803ea7:	83 c4 10             	add    $0x10,%esp
  803eaa:	83 ec 0c             	sub    $0xc,%esp
  803ead:	50                   	push   %eax
  803eae:	e8 fe d7 ff ff       	call   8016b1 <return_page>
  803eb3:	83 c4 10             	add    $0x10,%esp
	}
}
  803eb6:	90                   	nop
  803eb7:	c9                   	leave  
  803eb8:	c3                   	ret    

00803eb9 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803eb9:	55                   	push   %ebp
  803eba:	89 e5                	mov    %esp,%ebp
  803ebc:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803ebf:	8b 55 08             	mov    0x8(%ebp),%edx
  803ec2:	89 d0                	mov    %edx,%eax
  803ec4:	c1 e0 02             	shl    $0x2,%eax
  803ec7:	01 d0                	add    %edx,%eax
  803ec9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803ed0:	01 d0                	add    %edx,%eax
  803ed2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803ed9:	01 d0                	add    %edx,%eax
  803edb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803ee2:	01 d0                	add    %edx,%eax
  803ee4:	c1 e0 04             	shl    $0x4,%eax
  803ee7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  803eea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  803ef1:	0f 31                	rdtsc  
  803ef3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  803ef6:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  803ef9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803efc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803eff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803f02:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  803f05:	eb 46                	jmp    803f4d <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  803f07:	0f 31                	rdtsc  
  803f09:	89 45 d0             	mov    %eax,-0x30(%ebp)
  803f0c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  803f0f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f12:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803f15:	89 45 e0             	mov    %eax,-0x20(%ebp)
  803f18:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803f1b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803f1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f21:	29 c2                	sub    %eax,%edx
  803f23:	89 d0                	mov    %edx,%eax
  803f25:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803f28:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f2e:	89 d1                	mov    %edx,%ecx
  803f30:	29 c1                	sub    %eax,%ecx
  803f32:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803f35:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f38:	39 c2                	cmp    %eax,%edx
  803f3a:	0f 97 c0             	seta   %al
  803f3d:	0f b6 c0             	movzbl %al,%eax
  803f40:	29 c1                	sub    %eax,%ecx
  803f42:	89 c8                	mov    %ecx,%eax
  803f44:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803f47:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803f4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  803f4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803f50:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803f53:	72 b2                	jb     803f07 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803f55:	90                   	nop
  803f56:	c9                   	leave  
  803f57:	c3                   	ret    

00803f58 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803f58:	55                   	push   %ebp
  803f59:	89 e5                	mov    %esp,%ebp
  803f5b:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803f5e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803f65:	eb 03                	jmp    803f6a <busy_wait+0x12>
  803f67:	ff 45 fc             	incl   -0x4(%ebp)
  803f6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803f6d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803f70:	72 f5                	jb     803f67 <busy_wait+0xf>
	return i;
  803f72:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803f75:	c9                   	leave  
  803f76:	c3                   	ret    
  803f77:	90                   	nop

00803f78 <__udivdi3>:
  803f78:	55                   	push   %ebp
  803f79:	57                   	push   %edi
  803f7a:	56                   	push   %esi
  803f7b:	53                   	push   %ebx
  803f7c:	83 ec 1c             	sub    $0x1c,%esp
  803f7f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803f83:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803f87:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803f8b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803f8f:	89 ca                	mov    %ecx,%edx
  803f91:	89 f8                	mov    %edi,%eax
  803f93:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803f97:	85 f6                	test   %esi,%esi
  803f99:	75 2d                	jne    803fc8 <__udivdi3+0x50>
  803f9b:	39 cf                	cmp    %ecx,%edi
  803f9d:	77 65                	ja     804004 <__udivdi3+0x8c>
  803f9f:	89 fd                	mov    %edi,%ebp
  803fa1:	85 ff                	test   %edi,%edi
  803fa3:	75 0b                	jne    803fb0 <__udivdi3+0x38>
  803fa5:	b8 01 00 00 00       	mov    $0x1,%eax
  803faa:	31 d2                	xor    %edx,%edx
  803fac:	f7 f7                	div    %edi
  803fae:	89 c5                	mov    %eax,%ebp
  803fb0:	31 d2                	xor    %edx,%edx
  803fb2:	89 c8                	mov    %ecx,%eax
  803fb4:	f7 f5                	div    %ebp
  803fb6:	89 c1                	mov    %eax,%ecx
  803fb8:	89 d8                	mov    %ebx,%eax
  803fba:	f7 f5                	div    %ebp
  803fbc:	89 cf                	mov    %ecx,%edi
  803fbe:	89 fa                	mov    %edi,%edx
  803fc0:	83 c4 1c             	add    $0x1c,%esp
  803fc3:	5b                   	pop    %ebx
  803fc4:	5e                   	pop    %esi
  803fc5:	5f                   	pop    %edi
  803fc6:	5d                   	pop    %ebp
  803fc7:	c3                   	ret    
  803fc8:	39 ce                	cmp    %ecx,%esi
  803fca:	77 28                	ja     803ff4 <__udivdi3+0x7c>
  803fcc:	0f bd fe             	bsr    %esi,%edi
  803fcf:	83 f7 1f             	xor    $0x1f,%edi
  803fd2:	75 40                	jne    804014 <__udivdi3+0x9c>
  803fd4:	39 ce                	cmp    %ecx,%esi
  803fd6:	72 0a                	jb     803fe2 <__udivdi3+0x6a>
  803fd8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803fdc:	0f 87 9e 00 00 00    	ja     804080 <__udivdi3+0x108>
  803fe2:	b8 01 00 00 00       	mov    $0x1,%eax
  803fe7:	89 fa                	mov    %edi,%edx
  803fe9:	83 c4 1c             	add    $0x1c,%esp
  803fec:	5b                   	pop    %ebx
  803fed:	5e                   	pop    %esi
  803fee:	5f                   	pop    %edi
  803fef:	5d                   	pop    %ebp
  803ff0:	c3                   	ret    
  803ff1:	8d 76 00             	lea    0x0(%esi),%esi
  803ff4:	31 ff                	xor    %edi,%edi
  803ff6:	31 c0                	xor    %eax,%eax
  803ff8:	89 fa                	mov    %edi,%edx
  803ffa:	83 c4 1c             	add    $0x1c,%esp
  803ffd:	5b                   	pop    %ebx
  803ffe:	5e                   	pop    %esi
  803fff:	5f                   	pop    %edi
  804000:	5d                   	pop    %ebp
  804001:	c3                   	ret    
  804002:	66 90                	xchg   %ax,%ax
  804004:	89 d8                	mov    %ebx,%eax
  804006:	f7 f7                	div    %edi
  804008:	31 ff                	xor    %edi,%edi
  80400a:	89 fa                	mov    %edi,%edx
  80400c:	83 c4 1c             	add    $0x1c,%esp
  80400f:	5b                   	pop    %ebx
  804010:	5e                   	pop    %esi
  804011:	5f                   	pop    %edi
  804012:	5d                   	pop    %ebp
  804013:	c3                   	ret    
  804014:	bd 20 00 00 00       	mov    $0x20,%ebp
  804019:	89 eb                	mov    %ebp,%ebx
  80401b:	29 fb                	sub    %edi,%ebx
  80401d:	89 f9                	mov    %edi,%ecx
  80401f:	d3 e6                	shl    %cl,%esi
  804021:	89 c5                	mov    %eax,%ebp
  804023:	88 d9                	mov    %bl,%cl
  804025:	d3 ed                	shr    %cl,%ebp
  804027:	89 e9                	mov    %ebp,%ecx
  804029:	09 f1                	or     %esi,%ecx
  80402b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80402f:	89 f9                	mov    %edi,%ecx
  804031:	d3 e0                	shl    %cl,%eax
  804033:	89 c5                	mov    %eax,%ebp
  804035:	89 d6                	mov    %edx,%esi
  804037:	88 d9                	mov    %bl,%cl
  804039:	d3 ee                	shr    %cl,%esi
  80403b:	89 f9                	mov    %edi,%ecx
  80403d:	d3 e2                	shl    %cl,%edx
  80403f:	8b 44 24 08          	mov    0x8(%esp),%eax
  804043:	88 d9                	mov    %bl,%cl
  804045:	d3 e8                	shr    %cl,%eax
  804047:	09 c2                	or     %eax,%edx
  804049:	89 d0                	mov    %edx,%eax
  80404b:	89 f2                	mov    %esi,%edx
  80404d:	f7 74 24 0c          	divl   0xc(%esp)
  804051:	89 d6                	mov    %edx,%esi
  804053:	89 c3                	mov    %eax,%ebx
  804055:	f7 e5                	mul    %ebp
  804057:	39 d6                	cmp    %edx,%esi
  804059:	72 19                	jb     804074 <__udivdi3+0xfc>
  80405b:	74 0b                	je     804068 <__udivdi3+0xf0>
  80405d:	89 d8                	mov    %ebx,%eax
  80405f:	31 ff                	xor    %edi,%edi
  804061:	e9 58 ff ff ff       	jmp    803fbe <__udivdi3+0x46>
  804066:	66 90                	xchg   %ax,%ax
  804068:	8b 54 24 08          	mov    0x8(%esp),%edx
  80406c:	89 f9                	mov    %edi,%ecx
  80406e:	d3 e2                	shl    %cl,%edx
  804070:	39 c2                	cmp    %eax,%edx
  804072:	73 e9                	jae    80405d <__udivdi3+0xe5>
  804074:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804077:	31 ff                	xor    %edi,%edi
  804079:	e9 40 ff ff ff       	jmp    803fbe <__udivdi3+0x46>
  80407e:	66 90                	xchg   %ax,%ax
  804080:	31 c0                	xor    %eax,%eax
  804082:	e9 37 ff ff ff       	jmp    803fbe <__udivdi3+0x46>
  804087:	90                   	nop

00804088 <__umoddi3>:
  804088:	55                   	push   %ebp
  804089:	57                   	push   %edi
  80408a:	56                   	push   %esi
  80408b:	53                   	push   %ebx
  80408c:	83 ec 1c             	sub    $0x1c,%esp
  80408f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804093:	8b 74 24 34          	mov    0x34(%esp),%esi
  804097:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80409b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80409f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8040a3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8040a7:	89 f3                	mov    %esi,%ebx
  8040a9:	89 fa                	mov    %edi,%edx
  8040ab:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8040af:	89 34 24             	mov    %esi,(%esp)
  8040b2:	85 c0                	test   %eax,%eax
  8040b4:	75 1a                	jne    8040d0 <__umoddi3+0x48>
  8040b6:	39 f7                	cmp    %esi,%edi
  8040b8:	0f 86 a2 00 00 00    	jbe    804160 <__umoddi3+0xd8>
  8040be:	89 c8                	mov    %ecx,%eax
  8040c0:	89 f2                	mov    %esi,%edx
  8040c2:	f7 f7                	div    %edi
  8040c4:	89 d0                	mov    %edx,%eax
  8040c6:	31 d2                	xor    %edx,%edx
  8040c8:	83 c4 1c             	add    $0x1c,%esp
  8040cb:	5b                   	pop    %ebx
  8040cc:	5e                   	pop    %esi
  8040cd:	5f                   	pop    %edi
  8040ce:	5d                   	pop    %ebp
  8040cf:	c3                   	ret    
  8040d0:	39 f0                	cmp    %esi,%eax
  8040d2:	0f 87 ac 00 00 00    	ja     804184 <__umoddi3+0xfc>
  8040d8:	0f bd e8             	bsr    %eax,%ebp
  8040db:	83 f5 1f             	xor    $0x1f,%ebp
  8040de:	0f 84 ac 00 00 00    	je     804190 <__umoddi3+0x108>
  8040e4:	bf 20 00 00 00       	mov    $0x20,%edi
  8040e9:	29 ef                	sub    %ebp,%edi
  8040eb:	89 fe                	mov    %edi,%esi
  8040ed:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8040f1:	89 e9                	mov    %ebp,%ecx
  8040f3:	d3 e0                	shl    %cl,%eax
  8040f5:	89 d7                	mov    %edx,%edi
  8040f7:	89 f1                	mov    %esi,%ecx
  8040f9:	d3 ef                	shr    %cl,%edi
  8040fb:	09 c7                	or     %eax,%edi
  8040fd:	89 e9                	mov    %ebp,%ecx
  8040ff:	d3 e2                	shl    %cl,%edx
  804101:	89 14 24             	mov    %edx,(%esp)
  804104:	89 d8                	mov    %ebx,%eax
  804106:	d3 e0                	shl    %cl,%eax
  804108:	89 c2                	mov    %eax,%edx
  80410a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80410e:	d3 e0                	shl    %cl,%eax
  804110:	89 44 24 04          	mov    %eax,0x4(%esp)
  804114:	8b 44 24 08          	mov    0x8(%esp),%eax
  804118:	89 f1                	mov    %esi,%ecx
  80411a:	d3 e8                	shr    %cl,%eax
  80411c:	09 d0                	or     %edx,%eax
  80411e:	d3 eb                	shr    %cl,%ebx
  804120:	89 da                	mov    %ebx,%edx
  804122:	f7 f7                	div    %edi
  804124:	89 d3                	mov    %edx,%ebx
  804126:	f7 24 24             	mull   (%esp)
  804129:	89 c6                	mov    %eax,%esi
  80412b:	89 d1                	mov    %edx,%ecx
  80412d:	39 d3                	cmp    %edx,%ebx
  80412f:	0f 82 87 00 00 00    	jb     8041bc <__umoddi3+0x134>
  804135:	0f 84 91 00 00 00    	je     8041cc <__umoddi3+0x144>
  80413b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80413f:	29 f2                	sub    %esi,%edx
  804141:	19 cb                	sbb    %ecx,%ebx
  804143:	89 d8                	mov    %ebx,%eax
  804145:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804149:	d3 e0                	shl    %cl,%eax
  80414b:	89 e9                	mov    %ebp,%ecx
  80414d:	d3 ea                	shr    %cl,%edx
  80414f:	09 d0                	or     %edx,%eax
  804151:	89 e9                	mov    %ebp,%ecx
  804153:	d3 eb                	shr    %cl,%ebx
  804155:	89 da                	mov    %ebx,%edx
  804157:	83 c4 1c             	add    $0x1c,%esp
  80415a:	5b                   	pop    %ebx
  80415b:	5e                   	pop    %esi
  80415c:	5f                   	pop    %edi
  80415d:	5d                   	pop    %ebp
  80415e:	c3                   	ret    
  80415f:	90                   	nop
  804160:	89 fd                	mov    %edi,%ebp
  804162:	85 ff                	test   %edi,%edi
  804164:	75 0b                	jne    804171 <__umoddi3+0xe9>
  804166:	b8 01 00 00 00       	mov    $0x1,%eax
  80416b:	31 d2                	xor    %edx,%edx
  80416d:	f7 f7                	div    %edi
  80416f:	89 c5                	mov    %eax,%ebp
  804171:	89 f0                	mov    %esi,%eax
  804173:	31 d2                	xor    %edx,%edx
  804175:	f7 f5                	div    %ebp
  804177:	89 c8                	mov    %ecx,%eax
  804179:	f7 f5                	div    %ebp
  80417b:	89 d0                	mov    %edx,%eax
  80417d:	e9 44 ff ff ff       	jmp    8040c6 <__umoddi3+0x3e>
  804182:	66 90                	xchg   %ax,%ax
  804184:	89 c8                	mov    %ecx,%eax
  804186:	89 f2                	mov    %esi,%edx
  804188:	83 c4 1c             	add    $0x1c,%esp
  80418b:	5b                   	pop    %ebx
  80418c:	5e                   	pop    %esi
  80418d:	5f                   	pop    %edi
  80418e:	5d                   	pop    %ebp
  80418f:	c3                   	ret    
  804190:	3b 04 24             	cmp    (%esp),%eax
  804193:	72 06                	jb     80419b <__umoddi3+0x113>
  804195:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804199:	77 0f                	ja     8041aa <__umoddi3+0x122>
  80419b:	89 f2                	mov    %esi,%edx
  80419d:	29 f9                	sub    %edi,%ecx
  80419f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8041a3:	89 14 24             	mov    %edx,(%esp)
  8041a6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8041aa:	8b 44 24 04          	mov    0x4(%esp),%eax
  8041ae:	8b 14 24             	mov    (%esp),%edx
  8041b1:	83 c4 1c             	add    $0x1c,%esp
  8041b4:	5b                   	pop    %ebx
  8041b5:	5e                   	pop    %esi
  8041b6:	5f                   	pop    %edi
  8041b7:	5d                   	pop    %ebp
  8041b8:	c3                   	ret    
  8041b9:	8d 76 00             	lea    0x0(%esi),%esi
  8041bc:	2b 04 24             	sub    (%esp),%eax
  8041bf:	19 fa                	sbb    %edi,%edx
  8041c1:	89 d1                	mov    %edx,%ecx
  8041c3:	89 c6                	mov    %eax,%esi
  8041c5:	e9 71 ff ff ff       	jmp    80413b <__umoddi3+0xb3>
  8041ca:	66 90                	xchg   %ax,%ax
  8041cc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8041d0:	72 ea                	jb     8041bc <__umoddi3+0x134>
  8041d2:	89 d9                	mov    %ebx,%ecx
  8041d4:	e9 62 ff ff ff       	jmp    80413b <__umoddi3+0xb3>
