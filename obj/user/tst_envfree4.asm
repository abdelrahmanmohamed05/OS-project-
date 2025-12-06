
obj/user/tst_envfree4:     file format elf32-i386


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
  800031:	e8 9c 02 00 00       	call   8002d2 <libmain>
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
	// Testing scenario 4: Freeing the allocated shared variables [covers: smalloc (1 env) & sget (multiple envs)]
	// Testing removing the shared variables
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  800044:	83 ec 04             	sub    $0x4,%esp
  800047:	6a 01                	push   $0x1
  800049:	6a 04                	push   $0x4
  80004b:	68 40 41 80 00       	push   $0x804140
  800050:	e8 2a 1e 00 00       	call   801e7f <smalloc>
  800055:	83 c4 10             	add    $0x10,%esp
  800058:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	*numOfFinished = 0 ;
  80005b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80005e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	char getksbrkCmd[100] = "__getKernelSBreak__";
  800064:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  80006a:	bb 41 43 80 00       	mov    $0x804341,%ebx
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
  8000a1:	e8 13 33 00 00       	call   8033b9 <sys_utilities>
  8000a6:	83 c4 10             	add    $0x10,%esp

	int freeFrames_before = sys_calculate_free_frames() ;
  8000a9:	e8 0c 2f 00 00       	call   802fba <sys_calculate_free_frames>
  8000ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  8000b1:	e8 4f 2f 00 00       	call   803005 <sys_pf_calculate_allocated_pages>
  8000b6:	89 45 dc             	mov    %eax,-0x24(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  8000b9:	83 ec 08             	sub    $0x8,%esp
  8000bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8000bf:	68 50 41 80 00       	push   $0x804150
  8000c4:	e8 87 06 00 00       	call   800750 <cprintf>
  8000c9:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr1", myEnv->page_WS_max_size,(myEnv->SecondListSize), 50);
  8000cc:	a1 20 50 80 00       	mov    0x805020,%eax
  8000d1:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  8000d7:	89 c2                	mov    %eax,%edx
  8000d9:	a1 20 50 80 00       	mov    0x805020,%eax
  8000de:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000e4:	6a 32                	push   $0x32
  8000e6:	52                   	push   %edx
  8000e7:	50                   	push   %eax
  8000e8:	68 83 41 80 00       	push   $0x804183
  8000ed:	e8 23 30 00 00       	call   803115 <sys_create_env>
  8000f2:	83 c4 10             	add    $0x10,%esp
  8000f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int32 envIdProcessB = sys_create_env("ef_tshr2", myEnv->page_WS_max_size,(myEnv->SecondListSize), 50);
  8000f8:	a1 20 50 80 00       	mov    0x805020,%eax
  8000fd:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  800103:	89 c2                	mov    %eax,%edx
  800105:	a1 20 50 80 00       	mov    0x805020,%eax
  80010a:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800110:	6a 32                	push   $0x32
  800112:	52                   	push   %edx
  800113:	50                   	push   %eax
  800114:	68 8c 41 80 00       	push   $0x80418c
  800119:	e8 f7 2f 00 00       	call   803115 <sys_create_env>
  80011e:	83 c4 10             	add    $0x10,%esp
  800121:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	sys_run_env(envIdProcessA);
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	ff 75 d8             	pushl  -0x28(%ebp)
  80012a:	e8 04 30 00 00       	call   803133 <sys_run_env>
  80012f:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 1) ;
  800132:	90                   	nop
  800133:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800136:	8b 00                	mov    (%eax),%eax
  800138:	83 f8 01             	cmp    $0x1,%eax
  80013b:	75 f6                	jne    800133 <_main+0xfb>

	sys_run_env(envIdProcessB);
  80013d:	83 ec 0c             	sub    $0xc,%esp
  800140:	ff 75 d4             	pushl  -0x2c(%ebp)
  800143:	e8 eb 2f 00 00       	call   803133 <sys_run_env>
  800148:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  80014b:	90                   	nop
  80014c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80014f:	8b 00                	mov    (%eax),%eax
  800151:	83 f8 02             	cmp    $0x2,%eax
  800154:	75 f6                	jne    80014c <_main+0x114>

	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  800156:	e8 5f 2e 00 00       	call   802fba <sys_calculate_free_frames>
  80015b:	83 ec 08             	sub    $0x8,%esp
  80015e:	50                   	push   %eax
  80015f:	68 98 41 80 00       	push   $0x804198
  800164:	e8 e7 05 00 00       	call   800750 <cprintf>
  800169:	83 c4 10             	add    $0x10,%esp

	uint32 ksbrk_after ;
	sys_utilities(getksbrkCmd, (uint32)&ksbrk_after);
  80016c:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  800172:	83 ec 08             	sub    $0x8,%esp
  800175:	50                   	push   %eax
  800176:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  80017c:	50                   	push   %eax
  80017d:	e8 37 32 00 00       	call   8033b9 <sys_utilities>
  800182:	83 c4 10             	add    $0x10,%esp

	//DISABLE the interrupt to ensure the env_free is done as a whole without preemption
	//to avoid context switch (due to clock interrupt) while freeing the env to prevent:
	//	1. context switching to a wrong process specially in the part of temporarily switching the CPU process for freeing shared variables
	//	2. changing the # free frames
	char changeIntCmd[100] = "__changeInterruptStatus__";
  800185:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80018b:	bb a5 43 80 00       	mov    $0x8043a5,%ebx
  800190:	ba 1a 00 00 00       	mov    $0x1a,%edx
  800195:	89 c7                	mov    %eax,%edi
  800197:	89 de                	mov    %ebx,%esi
  800199:	89 d1                	mov    %edx,%ecx
  80019b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80019d:	8d 95 02 ff ff ff    	lea    -0xfe(%ebp),%edx
  8001a3:	b9 4a 00 00 00       	mov    $0x4a,%ecx
  8001a8:	b0 00                	mov    $0x0,%al
  8001aa:	89 d7                	mov    %edx,%edi
  8001ac:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(changeIntCmd, 0);
  8001ae:	83 ec 08             	sub    $0x8,%esp
  8001b1:	6a 00                	push   $0x0
  8001b3:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8001b9:	50                   	push   %eax
  8001ba:	e8 fa 31 00 00       	call   8033b9 <sys_utilities>
  8001bf:	83 c4 10             	add    $0x10,%esp
	{
		sys_destroy_env(envIdProcessA);
  8001c2:	83 ec 0c             	sub    $0xc,%esp
  8001c5:	ff 75 d8             	pushl  -0x28(%ebp)
  8001c8:	e8 82 2f 00 00       	call   80314f <sys_destroy_env>
  8001cd:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(envIdProcessB);
  8001d0:	83 ec 0c             	sub    $0xc,%esp
  8001d3:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001d6:	e8 74 2f 00 00       	call   80314f <sys_destroy_env>
  8001db:	83 c4 10             	add    $0x10,%esp
	}
	sys_utilities(changeIntCmd, 1);
  8001de:	83 ec 08             	sub    $0x8,%esp
  8001e1:	6a 01                	push   $0x1
  8001e3:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8001e9:	50                   	push   %eax
  8001ea:	e8 ca 31 00 00       	call   8033b9 <sys_utilities>
  8001ef:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8001f2:	e8 c3 2d 00 00       	call   802fba <sys_calculate_free_frames>
  8001f7:	89 45 d0             	mov    %eax,-0x30(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8001fa:	e8 06 2e 00 00       	call   803005 <sys_pf_calculate_allocated_pages>
  8001ff:	89 45 cc             	mov    %eax,-0x34(%ebp)

	int expected = (ROUNDUP((uint32)ksbrk_after, PAGE_SIZE) - ROUNDUP((uint32)ksbrk_before, PAGE_SIZE)) / PAGE_SIZE;
  800202:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  800209:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
  80020f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800212:	01 d0                	add    %edx,%eax
  800214:	48                   	dec    %eax
  800215:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800218:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80021b:	ba 00 00 00 00       	mov    $0x0,%edx
  800220:	f7 75 c8             	divl   -0x38(%ebp)
  800223:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800226:	29 d0                	sub    %edx,%eax
  800228:	89 c1                	mov    %eax,%ecx
  80022a:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  800231:	8b 95 50 ff ff ff    	mov    -0xb0(%ebp),%edx
  800237:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80023a:	01 d0                	add    %edx,%eax
  80023c:	48                   	dec    %eax
  80023d:	89 45 bc             	mov    %eax,-0x44(%ebp)
  800240:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800243:	ba 00 00 00 00       	mov    $0x0,%edx
  800248:	f7 75 c0             	divl   -0x40(%ebp)
  80024b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80024e:	29 d0                	sub    %edx,%eax
  800250:	29 c1                	sub    %eax,%ecx
  800252:	89 c8                	mov    %ecx,%eax
  800254:	c1 e8 0c             	shr    $0xc,%eax
  800257:	89 45 b8             	mov    %eax,-0x48(%ebp)
	cprintf("expected = %d\n",expected);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	ff 75 b8             	pushl  -0x48(%ebp)
  800260:	68 ca 41 80 00       	push   $0x8041ca
  800265:	e8 e6 04 00 00       	call   800750 <cprintf>
  80026a:	83 c4 10             	add    $0x10,%esp
	if ((freeFrames_before - freeFrames_after) != expected) {
  80026d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800270:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800273:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800276:	74 2e                	je     8002a6 <_main+0x26e>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\ndifference = %d, expected = %d\n",
  800278:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80027b:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80027e:	ff 75 b8             	pushl  -0x48(%ebp)
  800281:	50                   	push   %eax
  800282:	ff 75 d0             	pushl  -0x30(%ebp)
  800285:	68 dc 41 80 00       	push   $0x8041dc
  80028a:	e8 c1 04 00 00       	call   800750 <cprintf>
  80028f:	83 c4 10             	add    $0x10,%esp
				freeFrames_after, freeFrames_after - freeFrames_before, expected);
		panic("env_free() does not work correctly... check it again.");
  800292:	83 ec 04             	sub    $0x4,%esp
  800295:	68 4c 42 80 00       	push   $0x80424c
  80029a:	6a 38                	push   $0x38
  80029c:	68 82 42 80 00       	push   $0x804282
  8002a1:	e8 dc 01 00 00       	call   800482 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  8002a6:	83 ec 08             	sub    $0x8,%esp
  8002a9:	ff 75 d0             	pushl  -0x30(%ebp)
  8002ac:	68 98 42 80 00       	push   $0x804298
  8002b1:	e8 9a 04 00 00       	call   800750 <cprintf>
  8002b6:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 3 for envfree completed successfully.\n");
  8002b9:	83 ec 0c             	sub    $0xc,%esp
  8002bc:	68 f8 42 80 00       	push   $0x8042f8
  8002c1:	e8 8a 04 00 00       	call   800750 <cprintf>
  8002c6:	83 c4 10             	add    $0x10,%esp
	return;
  8002c9:	90                   	nop
}
  8002ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002cd:	5b                   	pop    %ebx
  8002ce:	5e                   	pop    %esi
  8002cf:	5f                   	pop    %edi
  8002d0:	5d                   	pop    %ebp
  8002d1:	c3                   	ret    

008002d2 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002d2:	55                   	push   %ebp
  8002d3:	89 e5                	mov    %esp,%ebp
  8002d5:	57                   	push   %edi
  8002d6:	56                   	push   %esi
  8002d7:	53                   	push   %ebx
  8002d8:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8002db:	e8 a3 2e 00 00       	call   803183 <sys_getenvindex>
  8002e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002e6:	89 d0                	mov    %edx,%eax
  8002e8:	c1 e0 03             	shl    $0x3,%eax
  8002eb:	01 d0                	add    %edx,%eax
  8002ed:	c1 e0 02             	shl    $0x2,%eax
  8002f0:	01 d0                	add    %edx,%eax
  8002f2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002f9:	01 d0                	add    %edx,%eax
  8002fb:	c1 e0 03             	shl    $0x3,%eax
  8002fe:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800303:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800308:	a1 20 50 80 00       	mov    0x805020,%eax
  80030d:	8a 40 20             	mov    0x20(%eax),%al
  800310:	84 c0                	test   %al,%al
  800312:	74 0d                	je     800321 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800314:	a1 20 50 80 00       	mov    0x805020,%eax
  800319:	83 c0 20             	add    $0x20,%eax
  80031c:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800321:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800325:	7e 0a                	jle    800331 <libmain+0x5f>
		binaryname = argv[0];
  800327:	8b 45 0c             	mov    0xc(%ebp),%eax
  80032a:	8b 00                	mov    (%eax),%eax
  80032c:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  800331:	83 ec 08             	sub    $0x8,%esp
  800334:	ff 75 0c             	pushl  0xc(%ebp)
  800337:	ff 75 08             	pushl  0x8(%ebp)
  80033a:	e8 f9 fc ff ff       	call   800038 <_main>
  80033f:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800342:	a1 00 50 80 00       	mov    0x805000,%eax
  800347:	85 c0                	test   %eax,%eax
  800349:	0f 84 01 01 00 00    	je     800450 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80034f:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800355:	bb 04 45 80 00       	mov    $0x804504,%ebx
  80035a:	ba 0e 00 00 00       	mov    $0xe,%edx
  80035f:	89 c7                	mov    %eax,%edi
  800361:	89 de                	mov    %ebx,%esi
  800363:	89 d1                	mov    %edx,%ecx
  800365:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800367:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80036a:	b9 56 00 00 00       	mov    $0x56,%ecx
  80036f:	b0 00                	mov    $0x0,%al
  800371:	89 d7                	mov    %edx,%edi
  800373:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800375:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80037c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80037f:	83 ec 08             	sub    $0x8,%esp
  800382:	50                   	push   %eax
  800383:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800389:	50                   	push   %eax
  80038a:	e8 2a 30 00 00       	call   8033b9 <sys_utilities>
  80038f:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800392:	e8 73 2b 00 00       	call   802f0a <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800397:	83 ec 0c             	sub    $0xc,%esp
  80039a:	68 24 44 80 00       	push   $0x804424
  80039f:	e8 ac 03 00 00       	call   800750 <cprintf>
  8003a4:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8003a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003aa:	85 c0                	test   %eax,%eax
  8003ac:	74 18                	je     8003c6 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8003ae:	e8 24 30 00 00       	call   8033d7 <sys_get_optimal_num_faults>
  8003b3:	83 ec 08             	sub    $0x8,%esp
  8003b6:	50                   	push   %eax
  8003b7:	68 4c 44 80 00       	push   $0x80444c
  8003bc:	e8 8f 03 00 00       	call   800750 <cprintf>
  8003c1:	83 c4 10             	add    $0x10,%esp
  8003c4:	eb 59                	jmp    80041f <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003c6:	a1 20 50 80 00       	mov    0x805020,%eax
  8003cb:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  8003d1:	a1 20 50 80 00       	mov    0x805020,%eax
  8003d6:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8003dc:	83 ec 04             	sub    $0x4,%esp
  8003df:	52                   	push   %edx
  8003e0:	50                   	push   %eax
  8003e1:	68 70 44 80 00       	push   $0x804470
  8003e6:	e8 65 03 00 00       	call   800750 <cprintf>
  8003eb:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003ee:	a1 20 50 80 00       	mov    0x805020,%eax
  8003f3:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  8003f9:	a1 20 50 80 00       	mov    0x805020,%eax
  8003fe:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  800404:	a1 20 50 80 00       	mov    0x805020,%eax
  800409:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80040f:	51                   	push   %ecx
  800410:	52                   	push   %edx
  800411:	50                   	push   %eax
  800412:	68 98 44 80 00       	push   $0x804498
  800417:	e8 34 03 00 00       	call   800750 <cprintf>
  80041c:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80041f:	a1 20 50 80 00       	mov    0x805020,%eax
  800424:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  80042a:	83 ec 08             	sub    $0x8,%esp
  80042d:	50                   	push   %eax
  80042e:	68 f0 44 80 00       	push   $0x8044f0
  800433:	e8 18 03 00 00       	call   800750 <cprintf>
  800438:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80043b:	83 ec 0c             	sub    $0xc,%esp
  80043e:	68 24 44 80 00       	push   $0x804424
  800443:	e8 08 03 00 00       	call   800750 <cprintf>
  800448:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80044b:	e8 d4 2a 00 00       	call   802f24 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800450:	e8 1f 00 00 00       	call   800474 <exit>
}
  800455:	90                   	nop
  800456:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800459:	5b                   	pop    %ebx
  80045a:	5e                   	pop    %esi
  80045b:	5f                   	pop    %edi
  80045c:	5d                   	pop    %ebp
  80045d:	c3                   	ret    

0080045e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80045e:	55                   	push   %ebp
  80045f:	89 e5                	mov    %esp,%ebp
  800461:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800464:	83 ec 0c             	sub    $0xc,%esp
  800467:	6a 00                	push   $0x0
  800469:	e8 e1 2c 00 00       	call   80314f <sys_destroy_env>
  80046e:	83 c4 10             	add    $0x10,%esp
}
  800471:	90                   	nop
  800472:	c9                   	leave  
  800473:	c3                   	ret    

00800474 <exit>:

void
exit(void)
{
  800474:	55                   	push   %ebp
  800475:	89 e5                	mov    %esp,%ebp
  800477:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80047a:	e8 36 2d 00 00       	call   8031b5 <sys_exit_env>
}
  80047f:	90                   	nop
  800480:	c9                   	leave  
  800481:	c3                   	ret    

00800482 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800482:	55                   	push   %ebp
  800483:	89 e5                	mov    %esp,%ebp
  800485:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800488:	8d 45 10             	lea    0x10(%ebp),%eax
  80048b:	83 c0 04             	add    $0x4,%eax
  80048e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800491:	a1 38 51 83 00       	mov    0x835138,%eax
  800496:	85 c0                	test   %eax,%eax
  800498:	74 16                	je     8004b0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80049a:	a1 38 51 83 00       	mov    0x835138,%eax
  80049f:	83 ec 08             	sub    $0x8,%esp
  8004a2:	50                   	push   %eax
  8004a3:	68 68 45 80 00       	push   $0x804568
  8004a8:	e8 a3 02 00 00       	call   800750 <cprintf>
  8004ad:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8004b0:	a1 04 50 80 00       	mov    0x805004,%eax
  8004b5:	83 ec 0c             	sub    $0xc,%esp
  8004b8:	ff 75 0c             	pushl  0xc(%ebp)
  8004bb:	ff 75 08             	pushl  0x8(%ebp)
  8004be:	50                   	push   %eax
  8004bf:	68 70 45 80 00       	push   $0x804570
  8004c4:	6a 74                	push   $0x74
  8004c6:	e8 b2 02 00 00       	call   80077d <cprintf_colored>
  8004cb:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8004d1:	83 ec 08             	sub    $0x8,%esp
  8004d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8004d7:	50                   	push   %eax
  8004d8:	e8 04 02 00 00       	call   8006e1 <vcprintf>
  8004dd:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004e0:	83 ec 08             	sub    $0x8,%esp
  8004e3:	6a 00                	push   $0x0
  8004e5:	68 98 45 80 00       	push   $0x804598
  8004ea:	e8 f2 01 00 00       	call   8006e1 <vcprintf>
  8004ef:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004f2:	e8 7d ff ff ff       	call   800474 <exit>

	// should not return here
	while (1) ;
  8004f7:	eb fe                	jmp    8004f7 <_panic+0x75>

008004f9 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004f9:	55                   	push   %ebp
  8004fa:	89 e5                	mov    %esp,%ebp
  8004fc:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8004ff:	a1 20 50 80 00       	mov    0x805020,%eax
  800504:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80050a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80050d:	39 c2                	cmp    %eax,%edx
  80050f:	74 14                	je     800525 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800511:	83 ec 04             	sub    $0x4,%esp
  800514:	68 9c 45 80 00       	push   $0x80459c
  800519:	6a 26                	push   $0x26
  80051b:	68 e8 45 80 00       	push   $0x8045e8
  800520:	e8 5d ff ff ff       	call   800482 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800525:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80052c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800533:	e9 c5 00 00 00       	jmp    8005fd <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800538:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80053b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800542:	8b 45 08             	mov    0x8(%ebp),%eax
  800545:	01 d0                	add    %edx,%eax
  800547:	8b 00                	mov    (%eax),%eax
  800549:	85 c0                	test   %eax,%eax
  80054b:	75 08                	jne    800555 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80054d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800550:	e9 a5 00 00 00       	jmp    8005fa <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800555:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80055c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800563:	eb 69                	jmp    8005ce <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800565:	a1 20 50 80 00       	mov    0x805020,%eax
  80056a:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800570:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800573:	89 d0                	mov    %edx,%eax
  800575:	01 c0                	add    %eax,%eax
  800577:	01 d0                	add    %edx,%eax
  800579:	c1 e0 03             	shl    $0x3,%eax
  80057c:	01 c8                	add    %ecx,%eax
  80057e:	8a 40 04             	mov    0x4(%eax),%al
  800581:	84 c0                	test   %al,%al
  800583:	75 46                	jne    8005cb <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800585:	a1 20 50 80 00       	mov    0x805020,%eax
  80058a:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800590:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800593:	89 d0                	mov    %edx,%eax
  800595:	01 c0                	add    %eax,%eax
  800597:	01 d0                	add    %edx,%eax
  800599:	c1 e0 03             	shl    $0x3,%eax
  80059c:	01 c8                	add    %ecx,%eax
  80059e:	8b 00                	mov    (%eax),%eax
  8005a0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005a6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005ab:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005b0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ba:	01 c8                	add    %ecx,%eax
  8005bc:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005be:	39 c2                	cmp    %eax,%edx
  8005c0:	75 09                	jne    8005cb <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8005c2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005c9:	eb 15                	jmp    8005e0 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005cb:	ff 45 e8             	incl   -0x18(%ebp)
  8005ce:	a1 20 50 80 00       	mov    0x805020,%eax
  8005d3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005dc:	39 c2                	cmp    %eax,%edx
  8005de:	77 85                	ja     800565 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005e0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005e4:	75 14                	jne    8005fa <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8005e6:	83 ec 04             	sub    $0x4,%esp
  8005e9:	68 f4 45 80 00       	push   $0x8045f4
  8005ee:	6a 3a                	push   $0x3a
  8005f0:	68 e8 45 80 00       	push   $0x8045e8
  8005f5:	e8 88 fe ff ff       	call   800482 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005fa:	ff 45 f0             	incl   -0x10(%ebp)
  8005fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800600:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800603:	0f 8c 2f ff ff ff    	jl     800538 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800609:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800610:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800617:	eb 26                	jmp    80063f <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800619:	a1 20 50 80 00       	mov    0x805020,%eax
  80061e:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800624:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800627:	89 d0                	mov    %edx,%eax
  800629:	01 c0                	add    %eax,%eax
  80062b:	01 d0                	add    %edx,%eax
  80062d:	c1 e0 03             	shl    $0x3,%eax
  800630:	01 c8                	add    %ecx,%eax
  800632:	8a 40 04             	mov    0x4(%eax),%al
  800635:	3c 01                	cmp    $0x1,%al
  800637:	75 03                	jne    80063c <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800639:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80063c:	ff 45 e0             	incl   -0x20(%ebp)
  80063f:	a1 20 50 80 00       	mov    0x805020,%eax
  800644:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80064a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80064d:	39 c2                	cmp    %eax,%edx
  80064f:	77 c8                	ja     800619 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800654:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800657:	74 14                	je     80066d <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800659:	83 ec 04             	sub    $0x4,%esp
  80065c:	68 48 46 80 00       	push   $0x804648
  800661:	6a 44                	push   $0x44
  800663:	68 e8 45 80 00       	push   $0x8045e8
  800668:	e8 15 fe ff ff       	call   800482 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80066d:	90                   	nop
  80066e:	c9                   	leave  
  80066f:	c3                   	ret    

00800670 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800670:	55                   	push   %ebp
  800671:	89 e5                	mov    %esp,%ebp
  800673:	53                   	push   %ebx
  800674:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800677:	8b 45 0c             	mov    0xc(%ebp),%eax
  80067a:	8b 00                	mov    (%eax),%eax
  80067c:	8d 48 01             	lea    0x1(%eax),%ecx
  80067f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800682:	89 0a                	mov    %ecx,(%edx)
  800684:	8b 55 08             	mov    0x8(%ebp),%edx
  800687:	88 d1                	mov    %dl,%cl
  800689:	8b 55 0c             	mov    0xc(%ebp),%edx
  80068c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800690:	8b 45 0c             	mov    0xc(%ebp),%eax
  800693:	8b 00                	mov    (%eax),%eax
  800695:	3d ff 00 00 00       	cmp    $0xff,%eax
  80069a:	75 30                	jne    8006cc <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80069c:	8b 15 3c 51 83 00    	mov    0x83513c,%edx
  8006a2:	a0 64 d0 81 00       	mov    0x81d064,%al
  8006a7:	0f b6 c0             	movzbl %al,%eax
  8006aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006ad:	8b 09                	mov    (%ecx),%ecx
  8006af:	89 cb                	mov    %ecx,%ebx
  8006b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006b4:	83 c1 08             	add    $0x8,%ecx
  8006b7:	52                   	push   %edx
  8006b8:	50                   	push   %eax
  8006b9:	53                   	push   %ebx
  8006ba:	51                   	push   %ecx
  8006bb:	e8 06 28 00 00       	call   802ec6 <sys_cputs>
  8006c0:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006cf:	8b 40 04             	mov    0x4(%eax),%eax
  8006d2:	8d 50 01             	lea    0x1(%eax),%edx
  8006d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d8:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006db:	90                   	nop
  8006dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006df:	c9                   	leave  
  8006e0:	c3                   	ret    

008006e1 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006e1:	55                   	push   %ebp
  8006e2:	89 e5                	mov    %esp,%ebp
  8006e4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006ea:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006f1:	00 00 00 
	b.cnt = 0;
  8006f4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006fb:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006fe:	ff 75 0c             	pushl  0xc(%ebp)
  800701:	ff 75 08             	pushl  0x8(%ebp)
  800704:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80070a:	50                   	push   %eax
  80070b:	68 70 06 80 00       	push   $0x800670
  800710:	e8 5a 02 00 00       	call   80096f <vprintfmt>
  800715:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800718:	8b 15 3c 51 83 00    	mov    0x83513c,%edx
  80071e:	a0 64 d0 81 00       	mov    0x81d064,%al
  800723:	0f b6 c0             	movzbl %al,%eax
  800726:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80072c:	52                   	push   %edx
  80072d:	50                   	push   %eax
  80072e:	51                   	push   %ecx
  80072f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800735:	83 c0 08             	add    $0x8,%eax
  800738:	50                   	push   %eax
  800739:	e8 88 27 00 00       	call   802ec6 <sys_cputs>
  80073e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800741:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
	return b.cnt;
  800748:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80074e:	c9                   	leave  
  80074f:	c3                   	ret    

00800750 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800750:	55                   	push   %ebp
  800751:	89 e5                	mov    %esp,%ebp
  800753:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800756:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	va_start(ap, fmt);
  80075d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800760:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800763:	8b 45 08             	mov    0x8(%ebp),%eax
  800766:	83 ec 08             	sub    $0x8,%esp
  800769:	ff 75 f4             	pushl  -0xc(%ebp)
  80076c:	50                   	push   %eax
  80076d:	e8 6f ff ff ff       	call   8006e1 <vcprintf>
  800772:	83 c4 10             	add    $0x10,%esp
  800775:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800778:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80077b:	c9                   	leave  
  80077c:	c3                   	ret    

0080077d <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80077d:	55                   	push   %ebp
  80077e:	89 e5                	mov    %esp,%ebp
  800780:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800783:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	curTextClr = (textClr << 8) ; //set text color by the given value
  80078a:	8b 45 08             	mov    0x8(%ebp),%eax
  80078d:	c1 e0 08             	shl    $0x8,%eax
  800790:	a3 3c 51 83 00       	mov    %eax,0x83513c
	va_start(ap, fmt);
  800795:	8d 45 0c             	lea    0xc(%ebp),%eax
  800798:	83 c0 04             	add    $0x4,%eax
  80079b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80079e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a1:	83 ec 08             	sub    $0x8,%esp
  8007a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8007a7:	50                   	push   %eax
  8007a8:	e8 34 ff ff ff       	call   8006e1 <vcprintf>
  8007ad:	83 c4 10             	add    $0x10,%esp
  8007b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007b3:	c7 05 3c 51 83 00 00 	movl   $0x700,0x83513c
  8007ba:	07 00 00 

	return cnt;
  8007bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007c0:	c9                   	leave  
  8007c1:	c3                   	ret    

008007c2 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007c2:	55                   	push   %ebp
  8007c3:	89 e5                	mov    %esp,%ebp
  8007c5:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007c8:	e8 3d 27 00 00       	call   802f0a <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007cd:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d6:	83 ec 08             	sub    $0x8,%esp
  8007d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8007dc:	50                   	push   %eax
  8007dd:	e8 ff fe ff ff       	call   8006e1 <vcprintf>
  8007e2:	83 c4 10             	add    $0x10,%esp
  8007e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007e8:	e8 37 27 00 00       	call   802f24 <sys_unlock_cons>
	return cnt;
  8007ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007f0:	c9                   	leave  
  8007f1:	c3                   	ret    

008007f2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007f2:	55                   	push   %ebp
  8007f3:	89 e5                	mov    %esp,%ebp
  8007f5:	53                   	push   %ebx
  8007f6:	83 ec 14             	sub    $0x14,%esp
  8007f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8007fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800802:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800805:	8b 45 18             	mov    0x18(%ebp),%eax
  800808:	ba 00 00 00 00       	mov    $0x0,%edx
  80080d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800810:	77 55                	ja     800867 <printnum+0x75>
  800812:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800815:	72 05                	jb     80081c <printnum+0x2a>
  800817:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80081a:	77 4b                	ja     800867 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80081c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80081f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800822:	8b 45 18             	mov    0x18(%ebp),%eax
  800825:	ba 00 00 00 00       	mov    $0x0,%edx
  80082a:	52                   	push   %edx
  80082b:	50                   	push   %eax
  80082c:	ff 75 f4             	pushl  -0xc(%ebp)
  80082f:	ff 75 f0             	pushl  -0x10(%ebp)
  800832:	e8 a5 36 00 00       	call   803edc <__udivdi3>
  800837:	83 c4 10             	add    $0x10,%esp
  80083a:	83 ec 04             	sub    $0x4,%esp
  80083d:	ff 75 20             	pushl  0x20(%ebp)
  800840:	53                   	push   %ebx
  800841:	ff 75 18             	pushl  0x18(%ebp)
  800844:	52                   	push   %edx
  800845:	50                   	push   %eax
  800846:	ff 75 0c             	pushl  0xc(%ebp)
  800849:	ff 75 08             	pushl  0x8(%ebp)
  80084c:	e8 a1 ff ff ff       	call   8007f2 <printnum>
  800851:	83 c4 20             	add    $0x20,%esp
  800854:	eb 1a                	jmp    800870 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800856:	83 ec 08             	sub    $0x8,%esp
  800859:	ff 75 0c             	pushl  0xc(%ebp)
  80085c:	ff 75 20             	pushl  0x20(%ebp)
  80085f:	8b 45 08             	mov    0x8(%ebp),%eax
  800862:	ff d0                	call   *%eax
  800864:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800867:	ff 4d 1c             	decl   0x1c(%ebp)
  80086a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80086e:	7f e6                	jg     800856 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800870:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800873:	bb 00 00 00 00       	mov    $0x0,%ebx
  800878:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80087b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80087e:	53                   	push   %ebx
  80087f:	51                   	push   %ecx
  800880:	52                   	push   %edx
  800881:	50                   	push   %eax
  800882:	e8 65 37 00 00       	call   803fec <__umoddi3>
  800887:	83 c4 10             	add    $0x10,%esp
  80088a:	05 b4 48 80 00       	add    $0x8048b4,%eax
  80088f:	8a 00                	mov    (%eax),%al
  800891:	0f be c0             	movsbl %al,%eax
  800894:	83 ec 08             	sub    $0x8,%esp
  800897:	ff 75 0c             	pushl  0xc(%ebp)
  80089a:	50                   	push   %eax
  80089b:	8b 45 08             	mov    0x8(%ebp),%eax
  80089e:	ff d0                	call   *%eax
  8008a0:	83 c4 10             	add    $0x10,%esp
}
  8008a3:	90                   	nop
  8008a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008a7:	c9                   	leave  
  8008a8:	c3                   	ret    

008008a9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008a9:	55                   	push   %ebp
  8008aa:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008ac:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008b0:	7e 1c                	jle    8008ce <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b5:	8b 00                	mov    (%eax),%eax
  8008b7:	8d 50 08             	lea    0x8(%eax),%edx
  8008ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bd:	89 10                	mov    %edx,(%eax)
  8008bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c2:	8b 00                	mov    (%eax),%eax
  8008c4:	83 e8 08             	sub    $0x8,%eax
  8008c7:	8b 50 04             	mov    0x4(%eax),%edx
  8008ca:	8b 00                	mov    (%eax),%eax
  8008cc:	eb 40                	jmp    80090e <getuint+0x65>
	else if (lflag)
  8008ce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008d2:	74 1e                	je     8008f2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d7:	8b 00                	mov    (%eax),%eax
  8008d9:	8d 50 04             	lea    0x4(%eax),%edx
  8008dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008df:	89 10                	mov    %edx,(%eax)
  8008e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e4:	8b 00                	mov    (%eax),%eax
  8008e6:	83 e8 04             	sub    $0x4,%eax
  8008e9:	8b 00                	mov    (%eax),%eax
  8008eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f0:	eb 1c                	jmp    80090e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f5:	8b 00                	mov    (%eax),%eax
  8008f7:	8d 50 04             	lea    0x4(%eax),%edx
  8008fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fd:	89 10                	mov    %edx,(%eax)
  8008ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800902:	8b 00                	mov    (%eax),%eax
  800904:	83 e8 04             	sub    $0x4,%eax
  800907:	8b 00                	mov    (%eax),%eax
  800909:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80090e:	5d                   	pop    %ebp
  80090f:	c3                   	ret    

00800910 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800910:	55                   	push   %ebp
  800911:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800913:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800917:	7e 1c                	jle    800935 <getint+0x25>
		return va_arg(*ap, long long);
  800919:	8b 45 08             	mov    0x8(%ebp),%eax
  80091c:	8b 00                	mov    (%eax),%eax
  80091e:	8d 50 08             	lea    0x8(%eax),%edx
  800921:	8b 45 08             	mov    0x8(%ebp),%eax
  800924:	89 10                	mov    %edx,(%eax)
  800926:	8b 45 08             	mov    0x8(%ebp),%eax
  800929:	8b 00                	mov    (%eax),%eax
  80092b:	83 e8 08             	sub    $0x8,%eax
  80092e:	8b 50 04             	mov    0x4(%eax),%edx
  800931:	8b 00                	mov    (%eax),%eax
  800933:	eb 38                	jmp    80096d <getint+0x5d>
	else if (lflag)
  800935:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800939:	74 1a                	je     800955 <getint+0x45>
		return va_arg(*ap, long);
  80093b:	8b 45 08             	mov    0x8(%ebp),%eax
  80093e:	8b 00                	mov    (%eax),%eax
  800940:	8d 50 04             	lea    0x4(%eax),%edx
  800943:	8b 45 08             	mov    0x8(%ebp),%eax
  800946:	89 10                	mov    %edx,(%eax)
  800948:	8b 45 08             	mov    0x8(%ebp),%eax
  80094b:	8b 00                	mov    (%eax),%eax
  80094d:	83 e8 04             	sub    $0x4,%eax
  800950:	8b 00                	mov    (%eax),%eax
  800952:	99                   	cltd   
  800953:	eb 18                	jmp    80096d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	8b 00                	mov    (%eax),%eax
  80095a:	8d 50 04             	lea    0x4(%eax),%edx
  80095d:	8b 45 08             	mov    0x8(%ebp),%eax
  800960:	89 10                	mov    %edx,(%eax)
  800962:	8b 45 08             	mov    0x8(%ebp),%eax
  800965:	8b 00                	mov    (%eax),%eax
  800967:	83 e8 04             	sub    $0x4,%eax
  80096a:	8b 00                	mov    (%eax),%eax
  80096c:	99                   	cltd   
}
  80096d:	5d                   	pop    %ebp
  80096e:	c3                   	ret    

0080096f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80096f:	55                   	push   %ebp
  800970:	89 e5                	mov    %esp,%ebp
  800972:	56                   	push   %esi
  800973:	53                   	push   %ebx
  800974:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800977:	eb 17                	jmp    800990 <vprintfmt+0x21>
			if (ch == '\0')
  800979:	85 db                	test   %ebx,%ebx
  80097b:	0f 84 c1 03 00 00    	je     800d42 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800981:	83 ec 08             	sub    $0x8,%esp
  800984:	ff 75 0c             	pushl  0xc(%ebp)
  800987:	53                   	push   %ebx
  800988:	8b 45 08             	mov    0x8(%ebp),%eax
  80098b:	ff d0                	call   *%eax
  80098d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800990:	8b 45 10             	mov    0x10(%ebp),%eax
  800993:	8d 50 01             	lea    0x1(%eax),%edx
  800996:	89 55 10             	mov    %edx,0x10(%ebp)
  800999:	8a 00                	mov    (%eax),%al
  80099b:	0f b6 d8             	movzbl %al,%ebx
  80099e:	83 fb 25             	cmp    $0x25,%ebx
  8009a1:	75 d6                	jne    800979 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009a3:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009a7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009ae:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009b5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009bc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8009c6:	8d 50 01             	lea    0x1(%eax),%edx
  8009c9:	89 55 10             	mov    %edx,0x10(%ebp)
  8009cc:	8a 00                	mov    (%eax),%al
  8009ce:	0f b6 d8             	movzbl %al,%ebx
  8009d1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009d4:	83 f8 5b             	cmp    $0x5b,%eax
  8009d7:	0f 87 3d 03 00 00    	ja     800d1a <vprintfmt+0x3ab>
  8009dd:	8b 04 85 d8 48 80 00 	mov    0x8048d8(,%eax,4),%eax
  8009e4:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009e6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009ea:	eb d7                	jmp    8009c3 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009ec:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009f0:	eb d1                	jmp    8009c3 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009f2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009f9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009fc:	89 d0                	mov    %edx,%eax
  8009fe:	c1 e0 02             	shl    $0x2,%eax
  800a01:	01 d0                	add    %edx,%eax
  800a03:	01 c0                	add    %eax,%eax
  800a05:	01 d8                	add    %ebx,%eax
  800a07:	83 e8 30             	sub    $0x30,%eax
  800a0a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800a10:	8a 00                	mov    (%eax),%al
  800a12:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a15:	83 fb 2f             	cmp    $0x2f,%ebx
  800a18:	7e 3e                	jle    800a58 <vprintfmt+0xe9>
  800a1a:	83 fb 39             	cmp    $0x39,%ebx
  800a1d:	7f 39                	jg     800a58 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a1f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a22:	eb d5                	jmp    8009f9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a24:	8b 45 14             	mov    0x14(%ebp),%eax
  800a27:	83 c0 04             	add    $0x4,%eax
  800a2a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a30:	83 e8 04             	sub    $0x4,%eax
  800a33:	8b 00                	mov    (%eax),%eax
  800a35:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a38:	eb 1f                	jmp    800a59 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a3a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a3e:	79 83                	jns    8009c3 <vprintfmt+0x54>
				width = 0;
  800a40:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a47:	e9 77 ff ff ff       	jmp    8009c3 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a4c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a53:	e9 6b ff ff ff       	jmp    8009c3 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a58:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a59:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a5d:	0f 89 60 ff ff ff    	jns    8009c3 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a63:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a66:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a69:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a70:	e9 4e ff ff ff       	jmp    8009c3 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a75:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a78:	e9 46 ff ff ff       	jmp    8009c3 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a80:	83 c0 04             	add    $0x4,%eax
  800a83:	89 45 14             	mov    %eax,0x14(%ebp)
  800a86:	8b 45 14             	mov    0x14(%ebp),%eax
  800a89:	83 e8 04             	sub    $0x4,%eax
  800a8c:	8b 00                	mov    (%eax),%eax
  800a8e:	83 ec 08             	sub    $0x8,%esp
  800a91:	ff 75 0c             	pushl  0xc(%ebp)
  800a94:	50                   	push   %eax
  800a95:	8b 45 08             	mov    0x8(%ebp),%eax
  800a98:	ff d0                	call   *%eax
  800a9a:	83 c4 10             	add    $0x10,%esp
			break;
  800a9d:	e9 9b 02 00 00       	jmp    800d3d <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800aa2:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa5:	83 c0 04             	add    $0x4,%eax
  800aa8:	89 45 14             	mov    %eax,0x14(%ebp)
  800aab:	8b 45 14             	mov    0x14(%ebp),%eax
  800aae:	83 e8 04             	sub    $0x4,%eax
  800ab1:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ab3:	85 db                	test   %ebx,%ebx
  800ab5:	79 02                	jns    800ab9 <vprintfmt+0x14a>
				err = -err;
  800ab7:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ab9:	83 fb 64             	cmp    $0x64,%ebx
  800abc:	7f 0b                	jg     800ac9 <vprintfmt+0x15a>
  800abe:	8b 34 9d 20 47 80 00 	mov    0x804720(,%ebx,4),%esi
  800ac5:	85 f6                	test   %esi,%esi
  800ac7:	75 19                	jne    800ae2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ac9:	53                   	push   %ebx
  800aca:	68 c5 48 80 00       	push   $0x8048c5
  800acf:	ff 75 0c             	pushl  0xc(%ebp)
  800ad2:	ff 75 08             	pushl  0x8(%ebp)
  800ad5:	e8 70 02 00 00       	call   800d4a <printfmt>
  800ada:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800add:	e9 5b 02 00 00       	jmp    800d3d <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ae2:	56                   	push   %esi
  800ae3:	68 ce 48 80 00       	push   $0x8048ce
  800ae8:	ff 75 0c             	pushl  0xc(%ebp)
  800aeb:	ff 75 08             	pushl  0x8(%ebp)
  800aee:	e8 57 02 00 00       	call   800d4a <printfmt>
  800af3:	83 c4 10             	add    $0x10,%esp
			break;
  800af6:	e9 42 02 00 00       	jmp    800d3d <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800afb:	8b 45 14             	mov    0x14(%ebp),%eax
  800afe:	83 c0 04             	add    $0x4,%eax
  800b01:	89 45 14             	mov    %eax,0x14(%ebp)
  800b04:	8b 45 14             	mov    0x14(%ebp),%eax
  800b07:	83 e8 04             	sub    $0x4,%eax
  800b0a:	8b 30                	mov    (%eax),%esi
  800b0c:	85 f6                	test   %esi,%esi
  800b0e:	75 05                	jne    800b15 <vprintfmt+0x1a6>
				p = "(null)";
  800b10:	be d1 48 80 00       	mov    $0x8048d1,%esi
			if (width > 0 && padc != '-')
  800b15:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b19:	7e 6d                	jle    800b88 <vprintfmt+0x219>
  800b1b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b1f:	74 67                	je     800b88 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b21:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b24:	83 ec 08             	sub    $0x8,%esp
  800b27:	50                   	push   %eax
  800b28:	56                   	push   %esi
  800b29:	e8 1e 03 00 00       	call   800e4c <strnlen>
  800b2e:	83 c4 10             	add    $0x10,%esp
  800b31:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b34:	eb 16                	jmp    800b4c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b36:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b3a:	83 ec 08             	sub    $0x8,%esp
  800b3d:	ff 75 0c             	pushl  0xc(%ebp)
  800b40:	50                   	push   %eax
  800b41:	8b 45 08             	mov    0x8(%ebp),%eax
  800b44:	ff d0                	call   *%eax
  800b46:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b49:	ff 4d e4             	decl   -0x1c(%ebp)
  800b4c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b50:	7f e4                	jg     800b36 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b52:	eb 34                	jmp    800b88 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b54:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b58:	74 1c                	je     800b76 <vprintfmt+0x207>
  800b5a:	83 fb 1f             	cmp    $0x1f,%ebx
  800b5d:	7e 05                	jle    800b64 <vprintfmt+0x1f5>
  800b5f:	83 fb 7e             	cmp    $0x7e,%ebx
  800b62:	7e 12                	jle    800b76 <vprintfmt+0x207>
					putch('?', putdat);
  800b64:	83 ec 08             	sub    $0x8,%esp
  800b67:	ff 75 0c             	pushl  0xc(%ebp)
  800b6a:	6a 3f                	push   $0x3f
  800b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6f:	ff d0                	call   *%eax
  800b71:	83 c4 10             	add    $0x10,%esp
  800b74:	eb 0f                	jmp    800b85 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b76:	83 ec 08             	sub    $0x8,%esp
  800b79:	ff 75 0c             	pushl  0xc(%ebp)
  800b7c:	53                   	push   %ebx
  800b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b80:	ff d0                	call   *%eax
  800b82:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b85:	ff 4d e4             	decl   -0x1c(%ebp)
  800b88:	89 f0                	mov    %esi,%eax
  800b8a:	8d 70 01             	lea    0x1(%eax),%esi
  800b8d:	8a 00                	mov    (%eax),%al
  800b8f:	0f be d8             	movsbl %al,%ebx
  800b92:	85 db                	test   %ebx,%ebx
  800b94:	74 24                	je     800bba <vprintfmt+0x24b>
  800b96:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b9a:	78 b8                	js     800b54 <vprintfmt+0x1e5>
  800b9c:	ff 4d e0             	decl   -0x20(%ebp)
  800b9f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ba3:	79 af                	jns    800b54 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ba5:	eb 13                	jmp    800bba <vprintfmt+0x24b>
				putch(' ', putdat);
  800ba7:	83 ec 08             	sub    $0x8,%esp
  800baa:	ff 75 0c             	pushl  0xc(%ebp)
  800bad:	6a 20                	push   $0x20
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	ff d0                	call   *%eax
  800bb4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bb7:	ff 4d e4             	decl   -0x1c(%ebp)
  800bba:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bbe:	7f e7                	jg     800ba7 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bc0:	e9 78 01 00 00       	jmp    800d3d <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bc5:	83 ec 08             	sub    $0x8,%esp
  800bc8:	ff 75 e8             	pushl  -0x18(%ebp)
  800bcb:	8d 45 14             	lea    0x14(%ebp),%eax
  800bce:	50                   	push   %eax
  800bcf:	e8 3c fd ff ff       	call   800910 <getint>
  800bd4:	83 c4 10             	add    $0x10,%esp
  800bd7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bda:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800be0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800be3:	85 d2                	test   %edx,%edx
  800be5:	79 23                	jns    800c0a <vprintfmt+0x29b>
				putch('-', putdat);
  800be7:	83 ec 08             	sub    $0x8,%esp
  800bea:	ff 75 0c             	pushl  0xc(%ebp)
  800bed:	6a 2d                	push   $0x2d
  800bef:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf2:	ff d0                	call   *%eax
  800bf4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bfd:	f7 d8                	neg    %eax
  800bff:	83 d2 00             	adc    $0x0,%edx
  800c02:	f7 da                	neg    %edx
  800c04:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c07:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c0a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c11:	e9 bc 00 00 00       	jmp    800cd2 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c16:	83 ec 08             	sub    $0x8,%esp
  800c19:	ff 75 e8             	pushl  -0x18(%ebp)
  800c1c:	8d 45 14             	lea    0x14(%ebp),%eax
  800c1f:	50                   	push   %eax
  800c20:	e8 84 fc ff ff       	call   8008a9 <getuint>
  800c25:	83 c4 10             	add    $0x10,%esp
  800c28:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c2b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c2e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c35:	e9 98 00 00 00       	jmp    800cd2 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c3a:	83 ec 08             	sub    $0x8,%esp
  800c3d:	ff 75 0c             	pushl  0xc(%ebp)
  800c40:	6a 58                	push   $0x58
  800c42:	8b 45 08             	mov    0x8(%ebp),%eax
  800c45:	ff d0                	call   *%eax
  800c47:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c4a:	83 ec 08             	sub    $0x8,%esp
  800c4d:	ff 75 0c             	pushl  0xc(%ebp)
  800c50:	6a 58                	push   $0x58
  800c52:	8b 45 08             	mov    0x8(%ebp),%eax
  800c55:	ff d0                	call   *%eax
  800c57:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c5a:	83 ec 08             	sub    $0x8,%esp
  800c5d:	ff 75 0c             	pushl  0xc(%ebp)
  800c60:	6a 58                	push   $0x58
  800c62:	8b 45 08             	mov    0x8(%ebp),%eax
  800c65:	ff d0                	call   *%eax
  800c67:	83 c4 10             	add    $0x10,%esp
			break;
  800c6a:	e9 ce 00 00 00       	jmp    800d3d <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c6f:	83 ec 08             	sub    $0x8,%esp
  800c72:	ff 75 0c             	pushl  0xc(%ebp)
  800c75:	6a 30                	push   $0x30
  800c77:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7a:	ff d0                	call   *%eax
  800c7c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c7f:	83 ec 08             	sub    $0x8,%esp
  800c82:	ff 75 0c             	pushl  0xc(%ebp)
  800c85:	6a 78                	push   $0x78
  800c87:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8a:	ff d0                	call   *%eax
  800c8c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c92:	83 c0 04             	add    $0x4,%eax
  800c95:	89 45 14             	mov    %eax,0x14(%ebp)
  800c98:	8b 45 14             	mov    0x14(%ebp),%eax
  800c9b:	83 e8 04             	sub    $0x4,%eax
  800c9e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ca0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800caa:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cb1:	eb 1f                	jmp    800cd2 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cb3:	83 ec 08             	sub    $0x8,%esp
  800cb6:	ff 75 e8             	pushl  -0x18(%ebp)
  800cb9:	8d 45 14             	lea    0x14(%ebp),%eax
  800cbc:	50                   	push   %eax
  800cbd:	e8 e7 fb ff ff       	call   8008a9 <getuint>
  800cc2:	83 c4 10             	add    $0x10,%esp
  800cc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ccb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cd2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cd9:	83 ec 04             	sub    $0x4,%esp
  800cdc:	52                   	push   %edx
  800cdd:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ce0:	50                   	push   %eax
  800ce1:	ff 75 f4             	pushl  -0xc(%ebp)
  800ce4:	ff 75 f0             	pushl  -0x10(%ebp)
  800ce7:	ff 75 0c             	pushl  0xc(%ebp)
  800cea:	ff 75 08             	pushl  0x8(%ebp)
  800ced:	e8 00 fb ff ff       	call   8007f2 <printnum>
  800cf2:	83 c4 20             	add    $0x20,%esp
			break;
  800cf5:	eb 46                	jmp    800d3d <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cf7:	83 ec 08             	sub    $0x8,%esp
  800cfa:	ff 75 0c             	pushl  0xc(%ebp)
  800cfd:	53                   	push   %ebx
  800cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800d01:	ff d0                	call   *%eax
  800d03:	83 c4 10             	add    $0x10,%esp
			break;
  800d06:	eb 35                	jmp    800d3d <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d08:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
			break;
  800d0f:	eb 2c                	jmp    800d3d <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d11:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
			break;
  800d18:	eb 23                	jmp    800d3d <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d1a:	83 ec 08             	sub    $0x8,%esp
  800d1d:	ff 75 0c             	pushl  0xc(%ebp)
  800d20:	6a 25                	push   $0x25
  800d22:	8b 45 08             	mov    0x8(%ebp),%eax
  800d25:	ff d0                	call   *%eax
  800d27:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d2a:	ff 4d 10             	decl   0x10(%ebp)
  800d2d:	eb 03                	jmp    800d32 <vprintfmt+0x3c3>
  800d2f:	ff 4d 10             	decl   0x10(%ebp)
  800d32:	8b 45 10             	mov    0x10(%ebp),%eax
  800d35:	48                   	dec    %eax
  800d36:	8a 00                	mov    (%eax),%al
  800d38:	3c 25                	cmp    $0x25,%al
  800d3a:	75 f3                	jne    800d2f <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d3c:	90                   	nop
		}
	}
  800d3d:	e9 35 fc ff ff       	jmp    800977 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d42:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d43:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d46:	5b                   	pop    %ebx
  800d47:	5e                   	pop    %esi
  800d48:	5d                   	pop    %ebp
  800d49:	c3                   	ret    

00800d4a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d50:	8d 45 10             	lea    0x10(%ebp),%eax
  800d53:	83 c0 04             	add    $0x4,%eax
  800d56:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d59:	8b 45 10             	mov    0x10(%ebp),%eax
  800d5c:	ff 75 f4             	pushl  -0xc(%ebp)
  800d5f:	50                   	push   %eax
  800d60:	ff 75 0c             	pushl  0xc(%ebp)
  800d63:	ff 75 08             	pushl  0x8(%ebp)
  800d66:	e8 04 fc ff ff       	call   80096f <vprintfmt>
  800d6b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d6e:	90                   	nop
  800d6f:	c9                   	leave  
  800d70:	c3                   	ret    

00800d71 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d71:	55                   	push   %ebp
  800d72:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d77:	8b 40 08             	mov    0x8(%eax),%eax
  800d7a:	8d 50 01             	lea    0x1(%eax),%edx
  800d7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d80:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d86:	8b 10                	mov    (%eax),%edx
  800d88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8b:	8b 40 04             	mov    0x4(%eax),%eax
  800d8e:	39 c2                	cmp    %eax,%edx
  800d90:	73 12                	jae    800da4 <sprintputch+0x33>
		*b->buf++ = ch;
  800d92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d95:	8b 00                	mov    (%eax),%eax
  800d97:	8d 48 01             	lea    0x1(%eax),%ecx
  800d9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9d:	89 0a                	mov    %ecx,(%edx)
  800d9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800da2:	88 10                	mov    %dl,(%eax)
}
  800da4:	90                   	nop
  800da5:	5d                   	pop    %ebp
  800da6:	c3                   	ret    

00800da7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800da7:	55                   	push   %ebp
  800da8:	89 e5                	mov    %esp,%ebp
  800daa:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dad:	8b 45 08             	mov    0x8(%ebp),%eax
  800db0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800db3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800db9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbc:	01 d0                	add    %edx,%eax
  800dbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dc1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dc8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dcc:	74 06                	je     800dd4 <vsnprintf+0x2d>
  800dce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dd2:	7f 07                	jg     800ddb <vsnprintf+0x34>
		return -E_INVAL;
  800dd4:	b8 03 00 00 00       	mov    $0x3,%eax
  800dd9:	eb 20                	jmp    800dfb <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ddb:	ff 75 14             	pushl  0x14(%ebp)
  800dde:	ff 75 10             	pushl  0x10(%ebp)
  800de1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800de4:	50                   	push   %eax
  800de5:	68 71 0d 80 00       	push   $0x800d71
  800dea:	e8 80 fb ff ff       	call   80096f <vprintfmt>
  800def:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800df2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800df5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800df8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dfb:	c9                   	leave  
  800dfc:	c3                   	ret    

00800dfd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dfd:	55                   	push   %ebp
  800dfe:	89 e5                	mov    %esp,%ebp
  800e00:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e03:	8d 45 10             	lea    0x10(%ebp),%eax
  800e06:	83 c0 04             	add    $0x4,%eax
  800e09:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e0c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0f:	ff 75 f4             	pushl  -0xc(%ebp)
  800e12:	50                   	push   %eax
  800e13:	ff 75 0c             	pushl  0xc(%ebp)
  800e16:	ff 75 08             	pushl  0x8(%ebp)
  800e19:	e8 89 ff ff ff       	call   800da7 <vsnprintf>
  800e1e:	83 c4 10             	add    $0x10,%esp
  800e21:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e24:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e27:	c9                   	leave  
  800e28:	c3                   	ret    

00800e29 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e29:	55                   	push   %ebp
  800e2a:	89 e5                	mov    %esp,%ebp
  800e2c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e2f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e36:	eb 06                	jmp    800e3e <strlen+0x15>
		n++;
  800e38:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e3b:	ff 45 08             	incl   0x8(%ebp)
  800e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e41:	8a 00                	mov    (%eax),%al
  800e43:	84 c0                	test   %al,%al
  800e45:	75 f1                	jne    800e38 <strlen+0xf>
		n++;
	return n;
  800e47:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e4a:	c9                   	leave  
  800e4b:	c3                   	ret    

00800e4c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e4c:	55                   	push   %ebp
  800e4d:	89 e5                	mov    %esp,%ebp
  800e4f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e52:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e59:	eb 09                	jmp    800e64 <strnlen+0x18>
		n++;
  800e5b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e5e:	ff 45 08             	incl   0x8(%ebp)
  800e61:	ff 4d 0c             	decl   0xc(%ebp)
  800e64:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e68:	74 09                	je     800e73 <strnlen+0x27>
  800e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6d:	8a 00                	mov    (%eax),%al
  800e6f:	84 c0                	test   %al,%al
  800e71:	75 e8                	jne    800e5b <strnlen+0xf>
		n++;
	return n;
  800e73:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e76:	c9                   	leave  
  800e77:	c3                   	ret    

00800e78 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e78:	55                   	push   %ebp
  800e79:	89 e5                	mov    %esp,%ebp
  800e7b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e81:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e84:	90                   	nop
  800e85:	8b 45 08             	mov    0x8(%ebp),%eax
  800e88:	8d 50 01             	lea    0x1(%eax),%edx
  800e8b:	89 55 08             	mov    %edx,0x8(%ebp)
  800e8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e91:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e94:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e97:	8a 12                	mov    (%edx),%dl
  800e99:	88 10                	mov    %dl,(%eax)
  800e9b:	8a 00                	mov    (%eax),%al
  800e9d:	84 c0                	test   %al,%al
  800e9f:	75 e4                	jne    800e85 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ea1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ea4:	c9                   	leave  
  800ea5:	c3                   	ret    

00800ea6 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ea6:	55                   	push   %ebp
  800ea7:	89 e5                	mov    %esp,%ebp
  800ea9:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800eac:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800eb2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eb9:	eb 1f                	jmp    800eda <strncpy+0x34>
		*dst++ = *src;
  800ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebe:	8d 50 01             	lea    0x1(%eax),%edx
  800ec1:	89 55 08             	mov    %edx,0x8(%ebp)
  800ec4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec7:	8a 12                	mov    (%edx),%dl
  800ec9:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ece:	8a 00                	mov    (%eax),%al
  800ed0:	84 c0                	test   %al,%al
  800ed2:	74 03                	je     800ed7 <strncpy+0x31>
			src++;
  800ed4:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ed7:	ff 45 fc             	incl   -0x4(%ebp)
  800eda:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800edd:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ee0:	72 d9                	jb     800ebb <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ee2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ee5:	c9                   	leave  
  800ee6:	c3                   	ret    

00800ee7 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ee7:	55                   	push   %ebp
  800ee8:	89 e5                	mov    %esp,%ebp
  800eea:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800eed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ef3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef7:	74 30                	je     800f29 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ef9:	eb 16                	jmp    800f11 <strlcpy+0x2a>
			*dst++ = *src++;
  800efb:	8b 45 08             	mov    0x8(%ebp),%eax
  800efe:	8d 50 01             	lea    0x1(%eax),%edx
  800f01:	89 55 08             	mov    %edx,0x8(%ebp)
  800f04:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f07:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f0a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f0d:	8a 12                	mov    (%edx),%dl
  800f0f:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f11:	ff 4d 10             	decl   0x10(%ebp)
  800f14:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f18:	74 09                	je     800f23 <strlcpy+0x3c>
  800f1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1d:	8a 00                	mov    (%eax),%al
  800f1f:	84 c0                	test   %al,%al
  800f21:	75 d8                	jne    800efb <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f29:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f2f:	29 c2                	sub    %eax,%edx
  800f31:	89 d0                	mov    %edx,%eax
}
  800f33:	c9                   	leave  
  800f34:	c3                   	ret    

00800f35 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f35:	55                   	push   %ebp
  800f36:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f38:	eb 06                	jmp    800f40 <strcmp+0xb>
		p++, q++;
  800f3a:	ff 45 08             	incl   0x8(%ebp)
  800f3d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f40:	8b 45 08             	mov    0x8(%ebp),%eax
  800f43:	8a 00                	mov    (%eax),%al
  800f45:	84 c0                	test   %al,%al
  800f47:	74 0e                	je     800f57 <strcmp+0x22>
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	8a 10                	mov    (%eax),%dl
  800f4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f51:	8a 00                	mov    (%eax),%al
  800f53:	38 c2                	cmp    %al,%dl
  800f55:	74 e3                	je     800f3a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f57:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5a:	8a 00                	mov    (%eax),%al
  800f5c:	0f b6 d0             	movzbl %al,%edx
  800f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f62:	8a 00                	mov    (%eax),%al
  800f64:	0f b6 c0             	movzbl %al,%eax
  800f67:	29 c2                	sub    %eax,%edx
  800f69:	89 d0                	mov    %edx,%eax
}
  800f6b:	5d                   	pop    %ebp
  800f6c:	c3                   	ret    

00800f6d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f6d:	55                   	push   %ebp
  800f6e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f70:	eb 09                	jmp    800f7b <strncmp+0xe>
		n--, p++, q++;
  800f72:	ff 4d 10             	decl   0x10(%ebp)
  800f75:	ff 45 08             	incl   0x8(%ebp)
  800f78:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f7b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7f:	74 17                	je     800f98 <strncmp+0x2b>
  800f81:	8b 45 08             	mov    0x8(%ebp),%eax
  800f84:	8a 00                	mov    (%eax),%al
  800f86:	84 c0                	test   %al,%al
  800f88:	74 0e                	je     800f98 <strncmp+0x2b>
  800f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8d:	8a 10                	mov    (%eax),%dl
  800f8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f92:	8a 00                	mov    (%eax),%al
  800f94:	38 c2                	cmp    %al,%dl
  800f96:	74 da                	je     800f72 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f98:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9c:	75 07                	jne    800fa5 <strncmp+0x38>
		return 0;
  800f9e:	b8 00 00 00 00       	mov    $0x0,%eax
  800fa3:	eb 14                	jmp    800fb9 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	8a 00                	mov    (%eax),%al
  800faa:	0f b6 d0             	movzbl %al,%edx
  800fad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb0:	8a 00                	mov    (%eax),%al
  800fb2:	0f b6 c0             	movzbl %al,%eax
  800fb5:	29 c2                	sub    %eax,%edx
  800fb7:	89 d0                	mov    %edx,%eax
}
  800fb9:	5d                   	pop    %ebp
  800fba:	c3                   	ret    

00800fbb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fbb:	55                   	push   %ebp
  800fbc:	89 e5                	mov    %esp,%ebp
  800fbe:	83 ec 04             	sub    $0x4,%esp
  800fc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fc7:	eb 12                	jmp    800fdb <strchr+0x20>
		if (*s == c)
  800fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcc:	8a 00                	mov    (%eax),%al
  800fce:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fd1:	75 05                	jne    800fd8 <strchr+0x1d>
			return (char *) s;
  800fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd6:	eb 11                	jmp    800fe9 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fd8:	ff 45 08             	incl   0x8(%ebp)
  800fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fde:	8a 00                	mov    (%eax),%al
  800fe0:	84 c0                	test   %al,%al
  800fe2:	75 e5                	jne    800fc9 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fe4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fe9:	c9                   	leave  
  800fea:	c3                   	ret    

00800feb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800feb:	55                   	push   %ebp
  800fec:	89 e5                	mov    %esp,%ebp
  800fee:	83 ec 04             	sub    $0x4,%esp
  800ff1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ff7:	eb 0d                	jmp    801006 <strfind+0x1b>
		if (*s == c)
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	8a 00                	mov    (%eax),%al
  800ffe:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801001:	74 0e                	je     801011 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801003:	ff 45 08             	incl   0x8(%ebp)
  801006:	8b 45 08             	mov    0x8(%ebp),%eax
  801009:	8a 00                	mov    (%eax),%al
  80100b:	84 c0                	test   %al,%al
  80100d:	75 ea                	jne    800ff9 <strfind+0xe>
  80100f:	eb 01                	jmp    801012 <strfind+0x27>
		if (*s == c)
			break;
  801011:	90                   	nop
	return (char *) s;
  801012:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801015:	c9                   	leave  
  801016:	c3                   	ret    

00801017 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801017:	55                   	push   %ebp
  801018:	89 e5                	mov    %esp,%ebp
  80101a:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801023:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801027:	76 63                	jbe    80108c <memset+0x75>
		uint64 data_block = c;
  801029:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102c:	99                   	cltd   
  80102d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801030:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801033:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801036:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801039:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80103d:	c1 e0 08             	shl    $0x8,%eax
  801040:	09 45 f0             	or     %eax,-0x10(%ebp)
  801043:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801046:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801049:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80104c:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801050:	c1 e0 10             	shl    $0x10,%eax
  801053:	09 45 f0             	or     %eax,-0x10(%ebp)
  801056:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801059:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80105c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80105f:	89 c2                	mov    %eax,%edx
  801061:	b8 00 00 00 00       	mov    $0x0,%eax
  801066:	09 45 f0             	or     %eax,-0x10(%ebp)
  801069:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80106c:	eb 18                	jmp    801086 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80106e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801071:	8d 41 08             	lea    0x8(%ecx),%eax
  801074:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801077:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80107a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80107d:	89 01                	mov    %eax,(%ecx)
  80107f:	89 51 04             	mov    %edx,0x4(%ecx)
  801082:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801086:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80108a:	77 e2                	ja     80106e <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80108c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801090:	74 23                	je     8010b5 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801092:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801095:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801098:	eb 0e                	jmp    8010a8 <memset+0x91>
			*p8++ = (uint8)c;
  80109a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80109d:	8d 50 01             	lea    0x1(%eax),%edx
  8010a0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010a6:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8010a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ab:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010ae:	89 55 10             	mov    %edx,0x10(%ebp)
  8010b1:	85 c0                	test   %eax,%eax
  8010b3:	75 e5                	jne    80109a <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8010b5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010b8:	c9                   	leave  
  8010b9:	c3                   	ret    

008010ba <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010ba:	55                   	push   %ebp
  8010bb:	89 e5                	mov    %esp,%ebp
  8010bd:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8010c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8010cc:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010d0:	76 24                	jbe    8010f6 <memcpy+0x3c>
		while(n >= 8){
  8010d2:	eb 1c                	jmp    8010f0 <memcpy+0x36>
			*d64 = *s64;
  8010d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d7:	8b 50 04             	mov    0x4(%eax),%edx
  8010da:	8b 00                	mov    (%eax),%eax
  8010dc:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010df:	89 01                	mov    %eax,(%ecx)
  8010e1:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8010e4:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8010e8:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8010ec:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8010f0:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010f4:	77 de                	ja     8010d4 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8010f6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010fa:	74 31                	je     80112d <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8010fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801102:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801105:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801108:	eb 16                	jmp    801120 <memcpy+0x66>
			*d8++ = *s8++;
  80110a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80110d:	8d 50 01             	lea    0x1(%eax),%edx
  801110:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801113:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801116:	8d 4a 01             	lea    0x1(%edx),%ecx
  801119:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80111c:	8a 12                	mov    (%edx),%dl
  80111e:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801120:	8b 45 10             	mov    0x10(%ebp),%eax
  801123:	8d 50 ff             	lea    -0x1(%eax),%edx
  801126:	89 55 10             	mov    %edx,0x10(%ebp)
  801129:	85 c0                	test   %eax,%eax
  80112b:	75 dd                	jne    80110a <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80112d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801130:	c9                   	leave  
  801131:	c3                   	ret    

00801132 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801132:	55                   	push   %ebp
  801133:	89 e5                	mov    %esp,%ebp
  801135:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801138:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80113e:	8b 45 08             	mov    0x8(%ebp),%eax
  801141:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801144:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801147:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80114a:	73 50                	jae    80119c <memmove+0x6a>
  80114c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80114f:	8b 45 10             	mov    0x10(%ebp),%eax
  801152:	01 d0                	add    %edx,%eax
  801154:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801157:	76 43                	jbe    80119c <memmove+0x6a>
		s += n;
  801159:	8b 45 10             	mov    0x10(%ebp),%eax
  80115c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80115f:	8b 45 10             	mov    0x10(%ebp),%eax
  801162:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801165:	eb 10                	jmp    801177 <memmove+0x45>
			*--d = *--s;
  801167:	ff 4d f8             	decl   -0x8(%ebp)
  80116a:	ff 4d fc             	decl   -0x4(%ebp)
  80116d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801170:	8a 10                	mov    (%eax),%dl
  801172:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801175:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801177:	8b 45 10             	mov    0x10(%ebp),%eax
  80117a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80117d:	89 55 10             	mov    %edx,0x10(%ebp)
  801180:	85 c0                	test   %eax,%eax
  801182:	75 e3                	jne    801167 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801184:	eb 23                	jmp    8011a9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801186:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801189:	8d 50 01             	lea    0x1(%eax),%edx
  80118c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80118f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801192:	8d 4a 01             	lea    0x1(%edx),%ecx
  801195:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801198:	8a 12                	mov    (%edx),%dl
  80119a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80119c:	8b 45 10             	mov    0x10(%ebp),%eax
  80119f:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011a2:	89 55 10             	mov    %edx,0x10(%ebp)
  8011a5:	85 c0                	test   %eax,%eax
  8011a7:	75 dd                	jne    801186 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011ac:	c9                   	leave  
  8011ad:	c3                   	ret    

008011ae <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011ae:	55                   	push   %ebp
  8011af:	89 e5                	mov    %esp,%ebp
  8011b1:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bd:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011c0:	eb 2a                	jmp    8011ec <memcmp+0x3e>
		if (*s1 != *s2)
  8011c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011c5:	8a 10                	mov    (%eax),%dl
  8011c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ca:	8a 00                	mov    (%eax),%al
  8011cc:	38 c2                	cmp    %al,%dl
  8011ce:	74 16                	je     8011e6 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d3:	8a 00                	mov    (%eax),%al
  8011d5:	0f b6 d0             	movzbl %al,%edx
  8011d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011db:	8a 00                	mov    (%eax),%al
  8011dd:	0f b6 c0             	movzbl %al,%eax
  8011e0:	29 c2                	sub    %eax,%edx
  8011e2:	89 d0                	mov    %edx,%eax
  8011e4:	eb 18                	jmp    8011fe <memcmp+0x50>
		s1++, s2++;
  8011e6:	ff 45 fc             	incl   -0x4(%ebp)
  8011e9:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ef:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011f2:	89 55 10             	mov    %edx,0x10(%ebp)
  8011f5:	85 c0                	test   %eax,%eax
  8011f7:	75 c9                	jne    8011c2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011fe:	c9                   	leave  
  8011ff:	c3                   	ret    

00801200 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801200:	55                   	push   %ebp
  801201:	89 e5                	mov    %esp,%ebp
  801203:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801206:	8b 55 08             	mov    0x8(%ebp),%edx
  801209:	8b 45 10             	mov    0x10(%ebp),%eax
  80120c:	01 d0                	add    %edx,%eax
  80120e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801211:	eb 15                	jmp    801228 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801213:	8b 45 08             	mov    0x8(%ebp),%eax
  801216:	8a 00                	mov    (%eax),%al
  801218:	0f b6 d0             	movzbl %al,%edx
  80121b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121e:	0f b6 c0             	movzbl %al,%eax
  801221:	39 c2                	cmp    %eax,%edx
  801223:	74 0d                	je     801232 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801225:	ff 45 08             	incl   0x8(%ebp)
  801228:	8b 45 08             	mov    0x8(%ebp),%eax
  80122b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80122e:	72 e3                	jb     801213 <memfind+0x13>
  801230:	eb 01                	jmp    801233 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801232:	90                   	nop
	return (void *) s;
  801233:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801236:	c9                   	leave  
  801237:	c3                   	ret    

00801238 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801238:	55                   	push   %ebp
  801239:	89 e5                	mov    %esp,%ebp
  80123b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80123e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801245:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80124c:	eb 03                	jmp    801251 <strtol+0x19>
		s++;
  80124e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801251:	8b 45 08             	mov    0x8(%ebp),%eax
  801254:	8a 00                	mov    (%eax),%al
  801256:	3c 20                	cmp    $0x20,%al
  801258:	74 f4                	je     80124e <strtol+0x16>
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
  80125d:	8a 00                	mov    (%eax),%al
  80125f:	3c 09                	cmp    $0x9,%al
  801261:	74 eb                	je     80124e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801263:	8b 45 08             	mov    0x8(%ebp),%eax
  801266:	8a 00                	mov    (%eax),%al
  801268:	3c 2b                	cmp    $0x2b,%al
  80126a:	75 05                	jne    801271 <strtol+0x39>
		s++;
  80126c:	ff 45 08             	incl   0x8(%ebp)
  80126f:	eb 13                	jmp    801284 <strtol+0x4c>
	else if (*s == '-')
  801271:	8b 45 08             	mov    0x8(%ebp),%eax
  801274:	8a 00                	mov    (%eax),%al
  801276:	3c 2d                	cmp    $0x2d,%al
  801278:	75 0a                	jne    801284 <strtol+0x4c>
		s++, neg = 1;
  80127a:	ff 45 08             	incl   0x8(%ebp)
  80127d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801284:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801288:	74 06                	je     801290 <strtol+0x58>
  80128a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80128e:	75 20                	jne    8012b0 <strtol+0x78>
  801290:	8b 45 08             	mov    0x8(%ebp),%eax
  801293:	8a 00                	mov    (%eax),%al
  801295:	3c 30                	cmp    $0x30,%al
  801297:	75 17                	jne    8012b0 <strtol+0x78>
  801299:	8b 45 08             	mov    0x8(%ebp),%eax
  80129c:	40                   	inc    %eax
  80129d:	8a 00                	mov    (%eax),%al
  80129f:	3c 78                	cmp    $0x78,%al
  8012a1:	75 0d                	jne    8012b0 <strtol+0x78>
		s += 2, base = 16;
  8012a3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012a7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012ae:	eb 28                	jmp    8012d8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012b0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012b4:	75 15                	jne    8012cb <strtol+0x93>
  8012b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b9:	8a 00                	mov    (%eax),%al
  8012bb:	3c 30                	cmp    $0x30,%al
  8012bd:	75 0c                	jne    8012cb <strtol+0x93>
		s++, base = 8;
  8012bf:	ff 45 08             	incl   0x8(%ebp)
  8012c2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012c9:	eb 0d                	jmp    8012d8 <strtol+0xa0>
	else if (base == 0)
  8012cb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012cf:	75 07                	jne    8012d8 <strtol+0xa0>
		base = 10;
  8012d1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012db:	8a 00                	mov    (%eax),%al
  8012dd:	3c 2f                	cmp    $0x2f,%al
  8012df:	7e 19                	jle    8012fa <strtol+0xc2>
  8012e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e4:	8a 00                	mov    (%eax),%al
  8012e6:	3c 39                	cmp    $0x39,%al
  8012e8:	7f 10                	jg     8012fa <strtol+0xc2>
			dig = *s - '0';
  8012ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ed:	8a 00                	mov    (%eax),%al
  8012ef:	0f be c0             	movsbl %al,%eax
  8012f2:	83 e8 30             	sub    $0x30,%eax
  8012f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012f8:	eb 42                	jmp    80133c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fd:	8a 00                	mov    (%eax),%al
  8012ff:	3c 60                	cmp    $0x60,%al
  801301:	7e 19                	jle    80131c <strtol+0xe4>
  801303:	8b 45 08             	mov    0x8(%ebp),%eax
  801306:	8a 00                	mov    (%eax),%al
  801308:	3c 7a                	cmp    $0x7a,%al
  80130a:	7f 10                	jg     80131c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80130c:	8b 45 08             	mov    0x8(%ebp),%eax
  80130f:	8a 00                	mov    (%eax),%al
  801311:	0f be c0             	movsbl %al,%eax
  801314:	83 e8 57             	sub    $0x57,%eax
  801317:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80131a:	eb 20                	jmp    80133c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80131c:	8b 45 08             	mov    0x8(%ebp),%eax
  80131f:	8a 00                	mov    (%eax),%al
  801321:	3c 40                	cmp    $0x40,%al
  801323:	7e 39                	jle    80135e <strtol+0x126>
  801325:	8b 45 08             	mov    0x8(%ebp),%eax
  801328:	8a 00                	mov    (%eax),%al
  80132a:	3c 5a                	cmp    $0x5a,%al
  80132c:	7f 30                	jg     80135e <strtol+0x126>
			dig = *s - 'A' + 10;
  80132e:	8b 45 08             	mov    0x8(%ebp),%eax
  801331:	8a 00                	mov    (%eax),%al
  801333:	0f be c0             	movsbl %al,%eax
  801336:	83 e8 37             	sub    $0x37,%eax
  801339:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80133c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80133f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801342:	7d 19                	jge    80135d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801344:	ff 45 08             	incl   0x8(%ebp)
  801347:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80134a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80134e:	89 c2                	mov    %eax,%edx
  801350:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801353:	01 d0                	add    %edx,%eax
  801355:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801358:	e9 7b ff ff ff       	jmp    8012d8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80135d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80135e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801362:	74 08                	je     80136c <strtol+0x134>
		*endptr = (char *) s;
  801364:	8b 45 0c             	mov    0xc(%ebp),%eax
  801367:	8b 55 08             	mov    0x8(%ebp),%edx
  80136a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80136c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801370:	74 07                	je     801379 <strtol+0x141>
  801372:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801375:	f7 d8                	neg    %eax
  801377:	eb 03                	jmp    80137c <strtol+0x144>
  801379:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80137c:	c9                   	leave  
  80137d:	c3                   	ret    

0080137e <ltostr>:

void
ltostr(long value, char *str)
{
  80137e:	55                   	push   %ebp
  80137f:	89 e5                	mov    %esp,%ebp
  801381:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801384:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80138b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801392:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801396:	79 13                	jns    8013ab <ltostr+0x2d>
	{
		neg = 1;
  801398:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80139f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013a5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013a8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ae:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013b3:	99                   	cltd   
  8013b4:	f7 f9                	idiv   %ecx
  8013b6:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013bc:	8d 50 01             	lea    0x1(%eax),%edx
  8013bf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013c2:	89 c2                	mov    %eax,%edx
  8013c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c7:	01 d0                	add    %edx,%eax
  8013c9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013cc:	83 c2 30             	add    $0x30,%edx
  8013cf:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013d4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013d9:	f7 e9                	imul   %ecx
  8013db:	c1 fa 02             	sar    $0x2,%edx
  8013de:	89 c8                	mov    %ecx,%eax
  8013e0:	c1 f8 1f             	sar    $0x1f,%eax
  8013e3:	29 c2                	sub    %eax,%edx
  8013e5:	89 d0                	mov    %edx,%eax
  8013e7:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013ee:	75 bb                	jne    8013ab <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013fa:	48                   	dec    %eax
  8013fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801402:	74 3d                	je     801441 <ltostr+0xc3>
		start = 1 ;
  801404:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80140b:	eb 34                	jmp    801441 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80140d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801410:	8b 45 0c             	mov    0xc(%ebp),%eax
  801413:	01 d0                	add    %edx,%eax
  801415:	8a 00                	mov    (%eax),%al
  801417:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80141a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80141d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801420:	01 c2                	add    %eax,%edx
  801422:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801425:	8b 45 0c             	mov    0xc(%ebp),%eax
  801428:	01 c8                	add    %ecx,%eax
  80142a:	8a 00                	mov    (%eax),%al
  80142c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80142e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801431:	8b 45 0c             	mov    0xc(%ebp),%eax
  801434:	01 c2                	add    %eax,%edx
  801436:	8a 45 eb             	mov    -0x15(%ebp),%al
  801439:	88 02                	mov    %al,(%edx)
		start++ ;
  80143b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80143e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801441:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801444:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801447:	7c c4                	jl     80140d <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801449:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80144c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144f:	01 d0                	add    %edx,%eax
  801451:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801454:	90                   	nop
  801455:	c9                   	leave  
  801456:	c3                   	ret    

00801457 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801457:	55                   	push   %ebp
  801458:	89 e5                	mov    %esp,%ebp
  80145a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80145d:	ff 75 08             	pushl  0x8(%ebp)
  801460:	e8 c4 f9 ff ff       	call   800e29 <strlen>
  801465:	83 c4 04             	add    $0x4,%esp
  801468:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80146b:	ff 75 0c             	pushl  0xc(%ebp)
  80146e:	e8 b6 f9 ff ff       	call   800e29 <strlen>
  801473:	83 c4 04             	add    $0x4,%esp
  801476:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801479:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801480:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801487:	eb 17                	jmp    8014a0 <strcconcat+0x49>
		final[s] = str1[s] ;
  801489:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80148c:	8b 45 10             	mov    0x10(%ebp),%eax
  80148f:	01 c2                	add    %eax,%edx
  801491:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801494:	8b 45 08             	mov    0x8(%ebp),%eax
  801497:	01 c8                	add    %ecx,%eax
  801499:	8a 00                	mov    (%eax),%al
  80149b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80149d:	ff 45 fc             	incl   -0x4(%ebp)
  8014a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014a3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014a6:	7c e1                	jl     801489 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014a8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014af:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014b6:	eb 1f                	jmp    8014d7 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014bb:	8d 50 01             	lea    0x1(%eax),%edx
  8014be:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014c1:	89 c2                	mov    %eax,%edx
  8014c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c6:	01 c2                	add    %eax,%edx
  8014c8:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ce:	01 c8                	add    %ecx,%eax
  8014d0:	8a 00                	mov    (%eax),%al
  8014d2:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014d4:	ff 45 f8             	incl   -0x8(%ebp)
  8014d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014da:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014dd:	7c d9                	jl     8014b8 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014df:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e5:	01 d0                	add    %edx,%eax
  8014e7:	c6 00 00             	movb   $0x0,(%eax)
}
  8014ea:	90                   	nop
  8014eb:	c9                   	leave  
  8014ec:	c3                   	ret    

008014ed <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014ed:	55                   	push   %ebp
  8014ee:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8014fc:	8b 00                	mov    (%eax),%eax
  8014fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801505:	8b 45 10             	mov    0x10(%ebp),%eax
  801508:	01 d0                	add    %edx,%eax
  80150a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801510:	eb 0c                	jmp    80151e <strsplit+0x31>
			*string++ = 0;
  801512:	8b 45 08             	mov    0x8(%ebp),%eax
  801515:	8d 50 01             	lea    0x1(%eax),%edx
  801518:	89 55 08             	mov    %edx,0x8(%ebp)
  80151b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80151e:	8b 45 08             	mov    0x8(%ebp),%eax
  801521:	8a 00                	mov    (%eax),%al
  801523:	84 c0                	test   %al,%al
  801525:	74 18                	je     80153f <strsplit+0x52>
  801527:	8b 45 08             	mov    0x8(%ebp),%eax
  80152a:	8a 00                	mov    (%eax),%al
  80152c:	0f be c0             	movsbl %al,%eax
  80152f:	50                   	push   %eax
  801530:	ff 75 0c             	pushl  0xc(%ebp)
  801533:	e8 83 fa ff ff       	call   800fbb <strchr>
  801538:	83 c4 08             	add    $0x8,%esp
  80153b:	85 c0                	test   %eax,%eax
  80153d:	75 d3                	jne    801512 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80153f:	8b 45 08             	mov    0x8(%ebp),%eax
  801542:	8a 00                	mov    (%eax),%al
  801544:	84 c0                	test   %al,%al
  801546:	74 5a                	je     8015a2 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801548:	8b 45 14             	mov    0x14(%ebp),%eax
  80154b:	8b 00                	mov    (%eax),%eax
  80154d:	83 f8 0f             	cmp    $0xf,%eax
  801550:	75 07                	jne    801559 <strsplit+0x6c>
		{
			return 0;
  801552:	b8 00 00 00 00       	mov    $0x0,%eax
  801557:	eb 66                	jmp    8015bf <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801559:	8b 45 14             	mov    0x14(%ebp),%eax
  80155c:	8b 00                	mov    (%eax),%eax
  80155e:	8d 48 01             	lea    0x1(%eax),%ecx
  801561:	8b 55 14             	mov    0x14(%ebp),%edx
  801564:	89 0a                	mov    %ecx,(%edx)
  801566:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80156d:	8b 45 10             	mov    0x10(%ebp),%eax
  801570:	01 c2                	add    %eax,%edx
  801572:	8b 45 08             	mov    0x8(%ebp),%eax
  801575:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801577:	eb 03                	jmp    80157c <strsplit+0x8f>
			string++;
  801579:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80157c:	8b 45 08             	mov    0x8(%ebp),%eax
  80157f:	8a 00                	mov    (%eax),%al
  801581:	84 c0                	test   %al,%al
  801583:	74 8b                	je     801510 <strsplit+0x23>
  801585:	8b 45 08             	mov    0x8(%ebp),%eax
  801588:	8a 00                	mov    (%eax),%al
  80158a:	0f be c0             	movsbl %al,%eax
  80158d:	50                   	push   %eax
  80158e:	ff 75 0c             	pushl  0xc(%ebp)
  801591:	e8 25 fa ff ff       	call   800fbb <strchr>
  801596:	83 c4 08             	add    $0x8,%esp
  801599:	85 c0                	test   %eax,%eax
  80159b:	74 dc                	je     801579 <strsplit+0x8c>
			string++;
	}
  80159d:	e9 6e ff ff ff       	jmp    801510 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015a2:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8015a6:	8b 00                	mov    (%eax),%eax
  8015a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015af:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b2:	01 d0                	add    %edx,%eax
  8015b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015ba:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015bf:	c9                   	leave  
  8015c0:	c3                   	ret    

008015c1 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015c1:	55                   	push   %ebp
  8015c2:	89 e5                	mov    %esp,%ebp
  8015c4:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8015c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ca:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8015cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015d4:	eb 4a                	jmp    801620 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8015d6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015dc:	01 c2                	add    %eax,%edx
  8015de:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e4:	01 c8                	add    %ecx,%eax
  8015e6:	8a 00                	mov    (%eax),%al
  8015e8:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8015ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f0:	01 d0                	add    %edx,%eax
  8015f2:	8a 00                	mov    (%eax),%al
  8015f4:	3c 40                	cmp    $0x40,%al
  8015f6:	7e 25                	jle    80161d <str2lower+0x5c>
  8015f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015fe:	01 d0                	add    %edx,%eax
  801600:	8a 00                	mov    (%eax),%al
  801602:	3c 5a                	cmp    $0x5a,%al
  801604:	7f 17                	jg     80161d <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801606:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801609:	8b 45 08             	mov    0x8(%ebp),%eax
  80160c:	01 d0                	add    %edx,%eax
  80160e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801611:	8b 55 08             	mov    0x8(%ebp),%edx
  801614:	01 ca                	add    %ecx,%edx
  801616:	8a 12                	mov    (%edx),%dl
  801618:	83 c2 20             	add    $0x20,%edx
  80161b:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80161d:	ff 45 fc             	incl   -0x4(%ebp)
  801620:	ff 75 0c             	pushl  0xc(%ebp)
  801623:	e8 01 f8 ff ff       	call   800e29 <strlen>
  801628:	83 c4 04             	add    $0x4,%esp
  80162b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80162e:	7f a6                	jg     8015d6 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801630:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801633:	c9                   	leave  
  801634:	c3                   	ret    

00801635 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801635:	55                   	push   %ebp
  801636:	89 e5                	mov    %esp,%ebp
  801638:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  80163b:	a1 08 50 80 00       	mov    0x805008,%eax
  801640:	85 c0                	test   %eax,%eax
  801642:	74 42                	je     801686 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801644:	83 ec 08             	sub    $0x8,%esp
  801647:	68 00 00 00 82       	push   $0x82000000
  80164c:	68 00 00 00 80       	push   $0x80000000
  801651:	e8 b0 1e 00 00       	call   803506 <initialize_dynamic_allocator>
  801656:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801659:	e8 96 1c 00 00       	call   8032f4 <sys_get_uheap_strategy>
  80165e:	a3 80 50 83 00       	mov    %eax,0x835080
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801663:	a1 60 d0 81 00       	mov    0x81d060,%eax
  801668:	05 00 10 00 00       	add    $0x1000,%eax
  80166d:	a3 30 51 83 00       	mov    %eax,0x835130
		uheapPageAllocBreak = uheapPageAllocStart;
  801672:	a1 30 51 83 00       	mov    0x835130,%eax
  801677:	a3 88 50 83 00       	mov    %eax,0x835088

		__firstTimeFlag = 0;
  80167c:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  801683:	00 00 00 
	}
}
  801686:	90                   	nop
  801687:	c9                   	leave  
  801688:	c3                   	ret    

00801689 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801689:	55                   	push   %ebp
  80168a:	89 e5                	mov    %esp,%ebp
  80168c:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  80168f:	8b 45 08             	mov    0x8(%ebp),%eax
  801692:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801698:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80169d:	83 ec 08             	sub    $0x8,%esp
  8016a0:	68 06 04 00 00       	push   $0x406
  8016a5:	50                   	push   %eax
  8016a6:	e8 93 18 00 00       	call   802f3e <__sys_allocate_page>
  8016ab:	83 c4 10             	add    $0x10,%esp
  8016ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8016b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016b5:	79 14                	jns    8016cb <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8016b7:	83 ec 04             	sub    $0x4,%esp
  8016ba:	68 48 4a 80 00       	push   $0x804a48
  8016bf:	6a 1f                	push   $0x1f
  8016c1:	68 84 4a 80 00       	push   $0x804a84
  8016c6:	e8 b7 ed ff ff       	call   800482 <_panic>
	return 0;
  8016cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016d0:	c9                   	leave  
  8016d1:	c3                   	ret    

008016d2 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8016d2:	55                   	push   %ebp
  8016d3:	89 e5                	mov    %esp,%ebp
  8016d5:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8016d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016e6:	83 ec 0c             	sub    $0xc,%esp
  8016e9:	50                   	push   %eax
  8016ea:	e8 96 18 00 00       	call   802f85 <__sys_unmap_frame>
  8016ef:	83 c4 10             	add    $0x10,%esp
  8016f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8016f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016f9:	79 14                	jns    80170f <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8016fb:	83 ec 04             	sub    $0x4,%esp
  8016fe:	68 90 4a 80 00       	push   $0x804a90
  801703:	6a 2a                	push   $0x2a
  801705:	68 84 4a 80 00       	push   $0x804a84
  80170a:	e8 73 ed ff ff       	call   800482 <_panic>
}
  80170f:	90                   	nop
  801710:	c9                   	leave  
  801711:	c3                   	ret    

00801712 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
  801715:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801718:	e8 18 ff ff ff       	call   801635 <uheap_init>
	if (size == 0) return NULL ;
  80171d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801721:	75 0a                	jne    80172d <malloc+0x1b>
  801723:	b8 00 00 00 00       	mov    $0x0,%eax
  801728:	e9 43 03 00 00       	jmp    801a70 <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  80172d:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801734:	77 13                	ja     801749 <malloc+0x37>
    {
        return alloc_block(size);
  801736:	83 ec 0c             	sub    $0xc,%esp
  801739:	ff 75 08             	pushl  0x8(%ebp)
  80173c:	e8 78 20 00 00       	call   8037b9 <alloc_block>
  801741:	83 c4 10             	add    $0x10,%esp
  801744:	e9 27 03 00 00       	jmp    801a70 <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801749:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801750:	8b 55 08             	mov    0x8(%ebp),%edx
  801753:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801756:	01 d0                	add    %edx,%eax
  801758:	48                   	dec    %eax
  801759:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80175c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80175f:	ba 00 00 00 00       	mov    $0x0,%edx
  801764:	f7 75 dc             	divl   -0x24(%ebp)
  801767:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80176a:	29 d0                	sub    %edx,%eax
  80176c:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  80176f:	a1 40 d0 81 00       	mov    0x81d040,%eax
  801774:	85 c0                	test   %eax,%eax
  801776:	75 0a                	jne    801782 <malloc+0x70>
    {
        uhp_inited = 1;
  801778:	c7 05 40 d0 81 00 01 	movl   $0x1,0x81d040
  80177f:	00 00 00 
    }

    int exactIdx = -1;
  801782:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801789:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801790:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801797:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80179e:	e9 85 00 00 00       	jmp    801828 <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  8017a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017a6:	89 d0                	mov    %edx,%eax
  8017a8:	01 c0                	add    %eax,%eax
  8017aa:	01 d0                	add    %edx,%eax
  8017ac:	c1 e0 02             	shl    $0x2,%eax
  8017af:	05 48 10 81 00       	add    $0x811048,%eax
  8017b4:	8a 00                	mov    (%eax),%al
  8017b6:	84 c0                	test   %al,%al
  8017b8:	74 20                	je     8017da <malloc+0xc8>
  8017ba:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017bd:	89 d0                	mov    %edx,%eax
  8017bf:	01 c0                	add    %eax,%eax
  8017c1:	01 d0                	add    %edx,%eax
  8017c3:	c1 e0 02             	shl    $0x2,%eax
  8017c6:	05 44 10 81 00       	add    $0x811044,%eax
  8017cb:	8b 00                	mov    (%eax),%eax
  8017cd:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8017d0:	75 08                	jne    8017da <malloc+0xc8>
        {
            exactIdx = i;
  8017d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  8017d8:	eb 5b                	jmp    801835 <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  8017da:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017dd:	89 d0                	mov    %edx,%eax
  8017df:	01 c0                	add    %eax,%eax
  8017e1:	01 d0                	add    %edx,%eax
  8017e3:	c1 e0 02             	shl    $0x2,%eax
  8017e6:	05 48 10 81 00       	add    $0x811048,%eax
  8017eb:	8a 00                	mov    (%eax),%al
  8017ed:	84 c0                	test   %al,%al
  8017ef:	74 34                	je     801825 <malloc+0x113>
  8017f1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017f4:	89 d0                	mov    %edx,%eax
  8017f6:	01 c0                	add    %eax,%eax
  8017f8:	01 d0                	add    %edx,%eax
  8017fa:	c1 e0 02             	shl    $0x2,%eax
  8017fd:	05 44 10 81 00       	add    $0x811044,%eax
  801802:	8b 00                	mov    (%eax),%eax
  801804:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801807:	76 1c                	jbe    801825 <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  801809:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80180c:	89 d0                	mov    %edx,%eax
  80180e:	01 c0                	add    %eax,%eax
  801810:	01 d0                	add    %edx,%eax
  801812:	c1 e0 02             	shl    $0x2,%eax
  801815:	05 44 10 81 00       	add    $0x811044,%eax
  80181a:	8b 00                	mov    (%eax),%eax
  80181c:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  80181f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801822:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801825:	ff 45 e8             	incl   -0x18(%ebp)
  801828:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  80182f:	0f 8e 6e ff ff ff    	jle    8017a3 <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  801835:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  80183c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801840:	74 7d                	je     8018bf <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801842:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801849:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80184c:	89 d0                	mov    %edx,%eax
  80184e:	01 c0                	add    %eax,%eax
  801850:	01 d0                	add    %edx,%eax
  801852:	c1 e0 02             	shl    $0x2,%eax
  801855:	05 40 10 81 00       	add    $0x811040,%eax
  80185a:	8b 10                	mov    (%eax),%edx
  80185c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80185f:	01 d0                	add    %edx,%eax
  801861:	48                   	dec    %eax
  801862:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801865:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801868:	ba 00 00 00 00       	mov    $0x0,%edx
  80186d:	f7 75 bc             	divl   -0x44(%ebp)
  801870:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801873:	29 d0                	sub    %edx,%eax
  801875:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801878:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80187b:	89 d0                	mov    %edx,%eax
  80187d:	01 c0                	add    %eax,%eax
  80187f:	01 d0                	add    %edx,%eax
  801881:	c1 e0 02             	shl    $0x2,%eax
  801884:	05 48 10 81 00       	add    $0x811048,%eax
  801889:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  80188c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80188f:	89 d0                	mov    %edx,%eax
  801891:	01 c0                	add    %eax,%eax
  801893:	01 d0                	add    %edx,%eax
  801895:	c1 e0 02             	shl    $0x2,%eax
  801898:	05 44 10 81 00       	add    $0x811044,%eax
  80189d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  8018a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018a6:	89 d0                	mov    %edx,%eax
  8018a8:	01 c0                	add    %eax,%eax
  8018aa:	01 d0                	add    %edx,%eax
  8018ac:	c1 e0 02             	shl    $0x2,%eax
  8018af:	05 40 10 81 00       	add    $0x811040,%eax
  8018b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8018ba:	e9 2d 01 00 00       	jmp    8019ec <malloc+0x2da>
    }
    else if (worstIdx != -1)
  8018bf:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8018c3:	0f 84 ce 00 00 00    	je     801997 <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  8018c9:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8018d0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018d3:	89 d0                	mov    %edx,%eax
  8018d5:	01 c0                	add    %eax,%eax
  8018d7:	01 d0                	add    %edx,%eax
  8018d9:	c1 e0 02             	shl    $0x2,%eax
  8018dc:	05 40 10 81 00       	add    $0x811040,%eax
  8018e1:	8b 10                	mov    (%eax),%edx
  8018e3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8018e6:	01 d0                	add    %edx,%eax
  8018e8:	48                   	dec    %eax
  8018e9:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8018ec:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8018ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f4:	f7 75 c4             	divl   -0x3c(%ebp)
  8018f7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8018fa:	29 d0                	sub    %edx,%eax
  8018fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  8018ff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801902:	89 d0                	mov    %edx,%eax
  801904:	01 c0                	add    %eax,%eax
  801906:	01 d0                	add    %edx,%eax
  801908:	c1 e0 02             	shl    $0x2,%eax
  80190b:	05 44 10 81 00       	add    $0x811044,%eax
  801910:	8b 00                	mov    (%eax),%eax
  801912:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801915:	75 47                	jne    80195e <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  801917:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80191a:	89 d0                	mov    %edx,%eax
  80191c:	01 c0                	add    %eax,%eax
  80191e:	01 d0                	add    %edx,%eax
  801920:	c1 e0 02             	shl    $0x2,%eax
  801923:	05 48 10 81 00       	add    $0x811048,%eax
  801928:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  80192b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80192e:	89 d0                	mov    %edx,%eax
  801930:	01 c0                	add    %eax,%eax
  801932:	01 d0                	add    %edx,%eax
  801934:	c1 e0 02             	shl    $0x2,%eax
  801937:	05 44 10 81 00       	add    $0x811044,%eax
  80193c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  801942:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801945:	89 d0                	mov    %edx,%eax
  801947:	01 c0                	add    %eax,%eax
  801949:	01 d0                	add    %edx,%eax
  80194b:	c1 e0 02             	shl    $0x2,%eax
  80194e:	05 40 10 81 00       	add    $0x811040,%eax
  801953:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801959:	e9 8e 00 00 00       	jmp    8019ec <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  80195e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801961:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801964:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801967:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80196a:	89 d0                	mov    %edx,%eax
  80196c:	01 c0                	add    %eax,%eax
  80196e:	01 d0                	add    %edx,%eax
  801970:	c1 e0 02             	shl    $0x2,%eax
  801973:	05 40 10 81 00       	add    $0x811040,%eax
  801978:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  80197a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80197d:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801980:	89 c2                	mov    %eax,%edx
  801982:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801985:	89 c8                	mov    %ecx,%eax
  801987:	01 c0                	add    %eax,%eax
  801989:	01 c8                	add    %ecx,%eax
  80198b:	c1 e0 02             	shl    $0x2,%eax
  80198e:	05 44 10 81 00       	add    $0x811044,%eax
  801993:	89 10                	mov    %edx,(%eax)
  801995:	eb 55                	jmp    8019ec <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  801997:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  80199e:	8b 15 88 50 83 00    	mov    0x835088,%edx
  8019a4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8019a7:	01 d0                	add    %edx,%eax
  8019a9:	48                   	dec    %eax
  8019aa:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8019ad:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8019b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b5:	f7 75 d0             	divl   -0x30(%ebp)
  8019b8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8019bb:	29 d0                	sub    %edx,%eax
  8019bd:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  8019c0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8019c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019c6:	01 d0                	add    %edx,%eax
  8019c8:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8019cd:	76 0a                	jbe    8019d9 <malloc+0x2c7>
            return NULL;
  8019cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8019d4:	e9 97 00 00 00       	jmp    801a70 <malloc+0x35e>
        va = start;
  8019d9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8019dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  8019df:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8019e2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019e5:	01 d0                	add    %edx,%eax
  8019e7:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8019ec:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8019f3:	eb 5e                	jmp    801a53 <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  8019f5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019f8:	89 d0                	mov    %edx,%eax
  8019fa:	01 c0                	add    %eax,%eax
  8019fc:	01 d0                	add    %edx,%eax
  8019fe:	c1 e0 02             	shl    $0x2,%eax
  801a01:	05 48 50 80 00       	add    $0x805048,%eax
  801a06:	8a 00                	mov    (%eax),%al
  801a08:	84 c0                	test   %al,%al
  801a0a:	75 44                	jne    801a50 <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  801a0c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a0f:	89 d0                	mov    %edx,%eax
  801a11:	01 c0                	add    %eax,%eax
  801a13:	01 d0                	add    %edx,%eax
  801a15:	c1 e0 02             	shl    $0x2,%eax
  801a18:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  801a1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a21:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  801a23:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a26:	89 d0                	mov    %edx,%eax
  801a28:	01 c0                	add    %eax,%eax
  801a2a:	01 d0                	add    %edx,%eax
  801a2c:	c1 e0 02             	shl    $0x2,%eax
  801a2f:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  801a35:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a38:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  801a3a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a3d:	89 d0                	mov    %edx,%eax
  801a3f:	01 c0                	add    %eax,%eax
  801a41:	01 d0                	add    %edx,%eax
  801a43:	c1 e0 02             	shl    $0x2,%eax
  801a46:	05 48 50 80 00       	add    $0x805048,%eax
  801a4b:	c6 00 01             	movb   $0x1,(%eax)
            break;
  801a4e:	eb 0c                	jmp    801a5c <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801a50:	ff 45 e0             	incl   -0x20(%ebp)
  801a53:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801a5a:	7e 99                	jle    8019f5 <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  801a5c:	83 ec 08             	sub    $0x8,%esp
  801a5f:	ff 75 d4             	pushl  -0x2c(%ebp)
  801a62:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a65:	e8 a2 19 00 00       	call   80340c <sys_allocate_user_mem>
  801a6a:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  801a6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801a70:	c9                   	leave  
  801a71:	c3                   	ret    

00801a72 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
  801a75:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  801a78:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a7c:	0f 84 fa 03 00 00    	je     801e7c <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  801a82:	8b 45 08             	mov    0x8(%ebp),%eax
  801a85:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  801a88:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a8b:	85 c0                	test   %eax,%eax
  801a8d:	79 1c                	jns    801aab <free+0x39>
  801a8f:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  801a96:	77 13                	ja     801aab <free+0x39>
    {
        free_block(virtual_address);
  801a98:	83 ec 0c             	sub    $0xc,%esp
  801a9b:	ff 75 08             	pushl  0x8(%ebp)
  801a9e:	e8 09 21 00 00       	call   803bac <free_block>
  801aa3:	83 c4 10             	add    $0x10,%esp
        return;
  801aa6:	e9 d2 03 00 00       	jmp    801e7d <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  801aab:	a1 30 51 83 00       	mov    0x835130,%eax
  801ab0:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  801ab3:	72 09                	jb     801abe <free+0x4c>
  801ab5:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  801abc:	76 17                	jbe    801ad5 <free+0x63>
        panic("free: invalid address");
  801abe:	83 ec 04             	sub    $0x4,%esp
  801ac1:	68 cd 4a 80 00       	push   $0x804acd
  801ac6:	68 9b 00 00 00       	push   $0x9b
  801acb:	68 84 4a 80 00       	push   $0x804a84
  801ad0:	e8 ad e9 ff ff       	call   800482 <_panic>

    uint32 size = 0;
  801ad5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  801adc:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801ae3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801aea:	eb 50                	jmp    801b3c <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  801aec:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801aef:	89 d0                	mov    %edx,%eax
  801af1:	01 c0                	add    %eax,%eax
  801af3:	01 d0                	add    %edx,%eax
  801af5:	c1 e0 02             	shl    $0x2,%eax
  801af8:	05 48 50 80 00       	add    $0x805048,%eax
  801afd:	8a 00                	mov    (%eax),%al
  801aff:	84 c0                	test   %al,%al
  801b01:	74 36                	je     801b39 <free+0xc7>
  801b03:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b06:	89 d0                	mov    %edx,%eax
  801b08:	01 c0                	add    %eax,%eax
  801b0a:	01 d0                	add    %edx,%eax
  801b0c:	c1 e0 02             	shl    $0x2,%eax
  801b0f:	05 40 50 80 00       	add    $0x805040,%eax
  801b14:	8b 00                	mov    (%eax),%eax
  801b16:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801b19:	75 1e                	jne    801b39 <free+0xc7>
        {
            size = uhp_allocs[i].size;
  801b1b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b1e:	89 d0                	mov    %edx,%eax
  801b20:	01 c0                	add    %eax,%eax
  801b22:	01 d0                	add    %edx,%eax
  801b24:	c1 e0 02             	shl    $0x2,%eax
  801b27:	05 44 50 80 00       	add    $0x805044,%eax
  801b2c:	8b 00                	mov    (%eax),%eax
  801b2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  801b31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b34:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  801b37:	eb 0c                	jmp    801b45 <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801b39:	ff 45 ec             	incl   -0x14(%ebp)
  801b3c:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  801b43:	7e a7                	jle    801aec <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  801b45:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801b49:	74 06                	je     801b51 <free+0xdf>
  801b4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b4f:	75 17                	jne    801b68 <free+0xf6>
        panic("free: unknown block");
  801b51:	83 ec 04             	sub    $0x4,%esp
  801b54:	68 e3 4a 80 00       	push   $0x804ae3
  801b59:	68 a9 00 00 00       	push   $0xa9
  801b5e:	68 84 4a 80 00       	push   $0x804a84
  801b63:	e8 1a e9 ff ff       	call   800482 <_panic>

    uhp_allocs[idx].used = 0;
  801b68:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b6b:	89 d0                	mov    %edx,%eax
  801b6d:	01 c0                	add    %eax,%eax
  801b6f:	01 d0                	add    %edx,%eax
  801b71:	c1 e0 02             	shl    $0x2,%eax
  801b74:	05 48 50 80 00       	add    $0x805048,%eax
  801b79:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  801b7c:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801b83:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801b8a:	eb 64                	jmp    801bf0 <free+0x17e>
    {
        if (!uhp_frees[i].free)
  801b8c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b8f:	89 d0                	mov    %edx,%eax
  801b91:	01 c0                	add    %eax,%eax
  801b93:	01 d0                	add    %edx,%eax
  801b95:	c1 e0 02             	shl    $0x2,%eax
  801b98:	05 48 10 81 00       	add    $0x811048,%eax
  801b9d:	8a 00                	mov    (%eax),%al
  801b9f:	84 c0                	test   %al,%al
  801ba1:	75 4a                	jne    801bed <free+0x17b>
        {
            uhp_frees[i].va = va;
  801ba3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801ba6:	89 d0                	mov    %edx,%eax
  801ba8:	01 c0                	add    %eax,%eax
  801baa:	01 d0                	add    %edx,%eax
  801bac:	c1 e0 02             	shl    $0x2,%eax
  801baf:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  801bb5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801bb8:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  801bba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801bbd:	89 d0                	mov    %edx,%eax
  801bbf:	01 c0                	add    %eax,%eax
  801bc1:	01 d0                	add    %edx,%eax
  801bc3:	c1 e0 02             	shl    $0x2,%eax
  801bc6:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  801bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bcf:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  801bd1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801bd4:	89 d0                	mov    %edx,%eax
  801bd6:	01 c0                	add    %eax,%eax
  801bd8:	01 d0                	add    %edx,%eax
  801bda:	c1 e0 02             	shl    $0x2,%eax
  801bdd:	05 48 10 81 00       	add    $0x811048,%eax
  801be2:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  801be5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801be8:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  801beb:	eb 0c                	jmp    801bf9 <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801bed:	ff 45 e4             	incl   -0x1c(%ebp)
  801bf0:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  801bf7:	7e 93                	jle    801b8c <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  801bf9:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  801bfd:	0f 84 f1 01 00 00    	je     801df4 <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801c03:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801c0a:	e9 d8 01 00 00       	jmp    801de7 <free+0x375>
        {
            if (i == fidx) continue;
  801c0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c12:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801c15:	0f 84 c8 01 00 00    	je     801de3 <free+0x371>
            if (uhp_frees[i].free)
  801c1b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c1e:	89 d0                	mov    %edx,%eax
  801c20:	01 c0                	add    %eax,%eax
  801c22:	01 d0                	add    %edx,%eax
  801c24:	c1 e0 02             	shl    $0x2,%eax
  801c27:	05 48 10 81 00       	add    $0x811048,%eax
  801c2c:	8a 00                	mov    (%eax),%al
  801c2e:	84 c0                	test   %al,%al
  801c30:	0f 84 ae 01 00 00    	je     801de4 <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  801c36:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c39:	89 d0                	mov    %edx,%eax
  801c3b:	01 c0                	add    %eax,%eax
  801c3d:	01 d0                	add    %edx,%eax
  801c3f:	c1 e0 02             	shl    $0x2,%eax
  801c42:	05 40 10 81 00       	add    $0x811040,%eax
  801c47:	8b 08                	mov    (%eax),%ecx
  801c49:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c4c:	89 d0                	mov    %edx,%eax
  801c4e:	01 c0                	add    %eax,%eax
  801c50:	01 d0                	add    %edx,%eax
  801c52:	c1 e0 02             	shl    $0x2,%eax
  801c55:	05 44 10 81 00       	add    $0x811044,%eax
  801c5a:	8b 00                	mov    (%eax),%eax
  801c5c:	01 c1                	add    %eax,%ecx
  801c5e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c61:	89 d0                	mov    %edx,%eax
  801c63:	01 c0                	add    %eax,%eax
  801c65:	01 d0                	add    %edx,%eax
  801c67:	c1 e0 02             	shl    $0x2,%eax
  801c6a:	05 40 10 81 00       	add    $0x811040,%eax
  801c6f:	8b 00                	mov    (%eax),%eax
  801c71:	39 c1                	cmp    %eax,%ecx
  801c73:	0f 85 a8 00 00 00    	jne    801d21 <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  801c79:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c7c:	89 d0                	mov    %edx,%eax
  801c7e:	01 c0                	add    %eax,%eax
  801c80:	01 d0                	add    %edx,%eax
  801c82:	c1 e0 02             	shl    $0x2,%eax
  801c85:	05 40 10 81 00       	add    $0x811040,%eax
  801c8a:	8b 10                	mov    (%eax),%edx
  801c8c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  801c8f:	89 c8                	mov    %ecx,%eax
  801c91:	01 c0                	add    %eax,%eax
  801c93:	01 c8                	add    %ecx,%eax
  801c95:	c1 e0 02             	shl    $0x2,%eax
  801c98:	05 40 10 81 00       	add    $0x811040,%eax
  801c9d:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801c9f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ca2:	89 d0                	mov    %edx,%eax
  801ca4:	01 c0                	add    %eax,%eax
  801ca6:	01 d0                	add    %edx,%eax
  801ca8:	c1 e0 02             	shl    $0x2,%eax
  801cab:	05 44 10 81 00       	add    $0x811044,%eax
  801cb0:	8b 08                	mov    (%eax),%ecx
  801cb2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801cb5:	89 d0                	mov    %edx,%eax
  801cb7:	01 c0                	add    %eax,%eax
  801cb9:	01 d0                	add    %edx,%eax
  801cbb:	c1 e0 02             	shl    $0x2,%eax
  801cbe:	05 44 10 81 00       	add    $0x811044,%eax
  801cc3:	8b 00                	mov    (%eax),%eax
  801cc5:	01 c1                	add    %eax,%ecx
  801cc7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801cca:	89 d0                	mov    %edx,%eax
  801ccc:	01 c0                	add    %eax,%eax
  801cce:	01 d0                	add    %edx,%eax
  801cd0:	c1 e0 02             	shl    $0x2,%eax
  801cd3:	05 44 10 81 00       	add    $0x811044,%eax
  801cd8:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801cda:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801cdd:	89 d0                	mov    %edx,%eax
  801cdf:	01 c0                	add    %eax,%eax
  801ce1:	01 d0                	add    %edx,%eax
  801ce3:	c1 e0 02             	shl    $0x2,%eax
  801ce6:	05 48 10 81 00       	add    $0x811048,%eax
  801ceb:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801cee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801cf1:	89 d0                	mov    %edx,%eax
  801cf3:	01 c0                	add    %eax,%eax
  801cf5:	01 d0                	add    %edx,%eax
  801cf7:	c1 e0 02             	shl    $0x2,%eax
  801cfa:	05 40 10 81 00       	add    $0x811040,%eax
  801cff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801d05:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d08:	89 d0                	mov    %edx,%eax
  801d0a:	01 c0                	add    %eax,%eax
  801d0c:	01 d0                	add    %edx,%eax
  801d0e:	c1 e0 02             	shl    $0x2,%eax
  801d11:	05 44 10 81 00       	add    $0x811044,%eax
  801d16:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801d1c:	e9 c3 00 00 00       	jmp    801de4 <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  801d21:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d24:	89 d0                	mov    %edx,%eax
  801d26:	01 c0                	add    %eax,%eax
  801d28:	01 d0                	add    %edx,%eax
  801d2a:	c1 e0 02             	shl    $0x2,%eax
  801d2d:	05 40 10 81 00       	add    $0x811040,%eax
  801d32:	8b 08                	mov    (%eax),%ecx
  801d34:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d37:	89 d0                	mov    %edx,%eax
  801d39:	01 c0                	add    %eax,%eax
  801d3b:	01 d0                	add    %edx,%eax
  801d3d:	c1 e0 02             	shl    $0x2,%eax
  801d40:	05 44 10 81 00       	add    $0x811044,%eax
  801d45:	8b 00                	mov    (%eax),%eax
  801d47:	01 c1                	add    %eax,%ecx
  801d49:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d4c:	89 d0                	mov    %edx,%eax
  801d4e:	01 c0                	add    %eax,%eax
  801d50:	01 d0                	add    %edx,%eax
  801d52:	c1 e0 02             	shl    $0x2,%eax
  801d55:	05 40 10 81 00       	add    $0x811040,%eax
  801d5a:	8b 00                	mov    (%eax),%eax
  801d5c:	39 c1                	cmp    %eax,%ecx
  801d5e:	0f 85 80 00 00 00    	jne    801de4 <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801d64:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d67:	89 d0                	mov    %edx,%eax
  801d69:	01 c0                	add    %eax,%eax
  801d6b:	01 d0                	add    %edx,%eax
  801d6d:	c1 e0 02             	shl    $0x2,%eax
  801d70:	05 44 10 81 00       	add    $0x811044,%eax
  801d75:	8b 08                	mov    (%eax),%ecx
  801d77:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d7a:	89 d0                	mov    %edx,%eax
  801d7c:	01 c0                	add    %eax,%eax
  801d7e:	01 d0                	add    %edx,%eax
  801d80:	c1 e0 02             	shl    $0x2,%eax
  801d83:	05 44 10 81 00       	add    $0x811044,%eax
  801d88:	8b 00                	mov    (%eax),%eax
  801d8a:	01 c1                	add    %eax,%ecx
  801d8c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d8f:	89 d0                	mov    %edx,%eax
  801d91:	01 c0                	add    %eax,%eax
  801d93:	01 d0                	add    %edx,%eax
  801d95:	c1 e0 02             	shl    $0x2,%eax
  801d98:	05 44 10 81 00       	add    $0x811044,%eax
  801d9d:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801d9f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801da2:	89 d0                	mov    %edx,%eax
  801da4:	01 c0                	add    %eax,%eax
  801da6:	01 d0                	add    %edx,%eax
  801da8:	c1 e0 02             	shl    $0x2,%eax
  801dab:	05 48 10 81 00       	add    $0x811048,%eax
  801db0:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801db3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801db6:	89 d0                	mov    %edx,%eax
  801db8:	01 c0                	add    %eax,%eax
  801dba:	01 d0                	add    %edx,%eax
  801dbc:	c1 e0 02             	shl    $0x2,%eax
  801dbf:	05 40 10 81 00       	add    $0x811040,%eax
  801dc4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801dca:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801dcd:	89 d0                	mov    %edx,%eax
  801dcf:	01 c0                	add    %eax,%eax
  801dd1:	01 d0                	add    %edx,%eax
  801dd3:	c1 e0 02             	shl    $0x2,%eax
  801dd6:	05 44 10 81 00       	add    $0x811044,%eax
  801ddb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801de1:	eb 01                	jmp    801de4 <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  801de3:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801de4:	ff 45 e0             	incl   -0x20(%ebp)
  801de7:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801dee:	0f 8e 1b fe ff ff    	jle    801c0f <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  801df4:	a1 30 51 83 00       	mov    0x835130,%eax
  801df9:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801dfc:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801e03:	eb 53                	jmp    801e58 <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  801e05:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e08:	89 d0                	mov    %edx,%eax
  801e0a:	01 c0                	add    %eax,%eax
  801e0c:	01 d0                	add    %edx,%eax
  801e0e:	c1 e0 02             	shl    $0x2,%eax
  801e11:	05 48 50 80 00       	add    $0x805048,%eax
  801e16:	8a 00                	mov    (%eax),%al
  801e18:	84 c0                	test   %al,%al
  801e1a:	74 39                	je     801e55 <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  801e1c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e1f:	89 d0                	mov    %edx,%eax
  801e21:	01 c0                	add    %eax,%eax
  801e23:	01 d0                	add    %edx,%eax
  801e25:	c1 e0 02             	shl    $0x2,%eax
  801e28:	05 40 50 80 00       	add    $0x805040,%eax
  801e2d:	8b 08                	mov    (%eax),%ecx
  801e2f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e32:	89 d0                	mov    %edx,%eax
  801e34:	01 c0                	add    %eax,%eax
  801e36:	01 d0                	add    %edx,%eax
  801e38:	c1 e0 02             	shl    $0x2,%eax
  801e3b:	05 44 50 80 00       	add    $0x805044,%eax
  801e40:	8b 00                	mov    (%eax),%eax
  801e42:	01 c8                	add    %ecx,%eax
  801e44:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  801e47:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e4a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801e4d:	76 06                	jbe    801e55 <free+0x3e3>
  801e4f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e52:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801e55:	ff 45 d8             	incl   -0x28(%ebp)
  801e58:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  801e5f:	7e a4                	jle    801e05 <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  801e61:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e64:	a3 88 50 83 00       	mov    %eax,0x835088

    sys_free_user_mem(va, size);
  801e69:	83 ec 08             	sub    $0x8,%esp
  801e6c:	ff 75 f4             	pushl  -0xc(%ebp)
  801e6f:	ff 75 d4             	pushl  -0x2c(%ebp)
  801e72:	e8 79 15 00 00       	call   8033f0 <sys_free_user_mem>
  801e77:	83 c4 10             	add    $0x10,%esp
  801e7a:	eb 01                	jmp    801e7d <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  801e7c:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  801e7d:	c9                   	leave  
  801e7e:	c3                   	ret    

00801e7f <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801e7f:	55                   	push   %ebp
  801e80:	89 e5                	mov    %esp,%ebp
  801e82:	83 ec 68             	sub    $0x68,%esp
  801e85:	8b 45 10             	mov    0x10(%ebp),%eax
  801e88:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801e8b:	e8 a5 f7 ff ff       	call   801635 <uheap_init>
	if (size == 0) return NULL ;
  801e90:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e94:	75 0a                	jne    801ea0 <smalloc+0x21>
  801e96:	b8 00 00 00 00       	mov    $0x0,%eax
  801e9b:	e9 37 03 00 00       	jmp    8021d7 <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801ea0:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801ea7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eaa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ead:	01 d0                	add    %edx,%eax
  801eaf:	48                   	dec    %eax
  801eb0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801eb3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801eb6:	ba 00 00 00 00       	mov    $0x0,%edx
  801ebb:	f7 75 dc             	divl   -0x24(%ebp)
  801ebe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ec1:	29 d0                	sub    %edx,%eax
  801ec3:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  801ec6:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801ecd:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801ed4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801edb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801ee2:	e9 85 00 00 00       	jmp    801f6c <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801ee7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801eea:	89 d0                	mov    %edx,%eax
  801eec:	01 c0                	add    %eax,%eax
  801eee:	01 d0                	add    %edx,%eax
  801ef0:	c1 e0 02             	shl    $0x2,%eax
  801ef3:	05 48 10 81 00       	add    $0x811048,%eax
  801ef8:	8a 00                	mov    (%eax),%al
  801efa:	84 c0                	test   %al,%al
  801efc:	74 20                	je     801f1e <smalloc+0x9f>
  801efe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f01:	89 d0                	mov    %edx,%eax
  801f03:	01 c0                	add    %eax,%eax
  801f05:	01 d0                	add    %edx,%eax
  801f07:	c1 e0 02             	shl    $0x2,%eax
  801f0a:	05 44 10 81 00       	add    $0x811044,%eax
  801f0f:	8b 00                	mov    (%eax),%eax
  801f11:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801f14:	75 08                	jne    801f1e <smalloc+0x9f>
        {
            exactIdx = i;
  801f16:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f19:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801f1c:	eb 5b                	jmp    801f79 <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801f1e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f21:	89 d0                	mov    %edx,%eax
  801f23:	01 c0                	add    %eax,%eax
  801f25:	01 d0                	add    %edx,%eax
  801f27:	c1 e0 02             	shl    $0x2,%eax
  801f2a:	05 48 10 81 00       	add    $0x811048,%eax
  801f2f:	8a 00                	mov    (%eax),%al
  801f31:	84 c0                	test   %al,%al
  801f33:	74 34                	je     801f69 <smalloc+0xea>
  801f35:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f38:	89 d0                	mov    %edx,%eax
  801f3a:	01 c0                	add    %eax,%eax
  801f3c:	01 d0                	add    %edx,%eax
  801f3e:	c1 e0 02             	shl    $0x2,%eax
  801f41:	05 44 10 81 00       	add    $0x811044,%eax
  801f46:	8b 00                	mov    (%eax),%eax
  801f48:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801f4b:	76 1c                	jbe    801f69 <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  801f4d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f50:	89 d0                	mov    %edx,%eax
  801f52:	01 c0                	add    %eax,%eax
  801f54:	01 d0                	add    %edx,%eax
  801f56:	c1 e0 02             	shl    $0x2,%eax
  801f59:	05 44 10 81 00       	add    $0x811044,%eax
  801f5e:	8b 00                	mov    (%eax),%eax
  801f60:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801f63:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f66:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801f69:	ff 45 e8             	incl   -0x18(%ebp)
  801f6c:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801f73:	0f 8e 6e ff ff ff    	jle    801ee7 <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  801f79:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801f80:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801f84:	74 7d                	je     802003 <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801f86:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801f8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f90:	89 d0                	mov    %edx,%eax
  801f92:	01 c0                	add    %eax,%eax
  801f94:	01 d0                	add    %edx,%eax
  801f96:	c1 e0 02             	shl    $0x2,%eax
  801f99:	05 40 10 81 00       	add    $0x811040,%eax
  801f9e:	8b 10                	mov    (%eax),%edx
  801fa0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801fa3:	01 d0                	add    %edx,%eax
  801fa5:	48                   	dec    %eax
  801fa6:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801fa9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801fac:	ba 00 00 00 00       	mov    $0x0,%edx
  801fb1:	f7 75 bc             	divl   -0x44(%ebp)
  801fb4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801fb7:	29 d0                	sub    %edx,%eax
  801fb9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801fbc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fbf:	89 d0                	mov    %edx,%eax
  801fc1:	01 c0                	add    %eax,%eax
  801fc3:	01 d0                	add    %edx,%eax
  801fc5:	c1 e0 02             	shl    $0x2,%eax
  801fc8:	05 48 10 81 00       	add    $0x811048,%eax
  801fcd:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801fd0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fd3:	89 d0                	mov    %edx,%eax
  801fd5:	01 c0                	add    %eax,%eax
  801fd7:	01 d0                	add    %edx,%eax
  801fd9:	c1 e0 02             	shl    $0x2,%eax
  801fdc:	05 44 10 81 00       	add    $0x811044,%eax
  801fe1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801fe7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fea:	89 d0                	mov    %edx,%eax
  801fec:	01 c0                	add    %eax,%eax
  801fee:	01 d0                	add    %edx,%eax
  801ff0:	c1 e0 02             	shl    $0x2,%eax
  801ff3:	05 40 10 81 00       	add    $0x811040,%eax
  801ff8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ffe:	e9 2d 01 00 00       	jmp    802130 <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  802003:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802007:	0f 84 ce 00 00 00    	je     8020db <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  80200d:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802014:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802017:	89 d0                	mov    %edx,%eax
  802019:	01 c0                	add    %eax,%eax
  80201b:	01 d0                	add    %edx,%eax
  80201d:	c1 e0 02             	shl    $0x2,%eax
  802020:	05 40 10 81 00       	add    $0x811040,%eax
  802025:	8b 10                	mov    (%eax),%edx
  802027:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80202a:	01 d0                	add    %edx,%eax
  80202c:	48                   	dec    %eax
  80202d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802030:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802033:	ba 00 00 00 00       	mov    $0x0,%edx
  802038:	f7 75 c4             	divl   -0x3c(%ebp)
  80203b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80203e:	29 d0                	sub    %edx,%eax
  802040:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  802043:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802046:	89 d0                	mov    %edx,%eax
  802048:	01 c0                	add    %eax,%eax
  80204a:	01 d0                	add    %edx,%eax
  80204c:	c1 e0 02             	shl    $0x2,%eax
  80204f:	05 44 10 81 00       	add    $0x811044,%eax
  802054:	8b 00                	mov    (%eax),%eax
  802056:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802059:	75 47                	jne    8020a2 <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  80205b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80205e:	89 d0                	mov    %edx,%eax
  802060:	01 c0                	add    %eax,%eax
  802062:	01 d0                	add    %edx,%eax
  802064:	c1 e0 02             	shl    $0x2,%eax
  802067:	05 48 10 81 00       	add    $0x811048,%eax
  80206c:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  80206f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802072:	89 d0                	mov    %edx,%eax
  802074:	01 c0                	add    %eax,%eax
  802076:	01 d0                	add    %edx,%eax
  802078:	c1 e0 02             	shl    $0x2,%eax
  80207b:	05 44 10 81 00       	add    $0x811044,%eax
  802080:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  802086:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802089:	89 d0                	mov    %edx,%eax
  80208b:	01 c0                	add    %eax,%eax
  80208d:	01 d0                	add    %edx,%eax
  80208f:	c1 e0 02             	shl    $0x2,%eax
  802092:	05 40 10 81 00       	add    $0x811040,%eax
  802097:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80209d:	e9 8e 00 00 00       	jmp    802130 <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  8020a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8020a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020a8:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8020ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020ae:	89 d0                	mov    %edx,%eax
  8020b0:	01 c0                	add    %eax,%eax
  8020b2:	01 d0                	add    %edx,%eax
  8020b4:	c1 e0 02             	shl    $0x2,%eax
  8020b7:	05 40 10 81 00       	add    $0x811040,%eax
  8020bc:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  8020be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020c1:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8020c4:	89 c2                	mov    %eax,%edx
  8020c6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8020c9:	89 c8                	mov    %ecx,%eax
  8020cb:	01 c0                	add    %eax,%eax
  8020cd:	01 c8                	add    %ecx,%eax
  8020cf:	c1 e0 02             	shl    $0x2,%eax
  8020d2:	05 44 10 81 00       	add    $0x811044,%eax
  8020d7:	89 10                	mov    %edx,(%eax)
  8020d9:	eb 55                	jmp    802130 <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  8020db:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  8020e2:	8b 15 88 50 83 00    	mov    0x835088,%edx
  8020e8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8020eb:	01 d0                	add    %edx,%eax
  8020ed:	48                   	dec    %eax
  8020ee:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8020f1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8020f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8020f9:	f7 75 d0             	divl   -0x30(%ebp)
  8020fc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8020ff:	29 d0                	sub    %edx,%eax
  802101:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  802104:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802107:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80210a:	01 d0                	add    %edx,%eax
  80210c:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802111:	76 0a                	jbe    80211d <smalloc+0x29e>
            return NULL;
  802113:	b8 00 00 00 00       	mov    $0x0,%eax
  802118:	e9 ba 00 00 00       	jmp    8021d7 <smalloc+0x358>
        va = start;
  80211d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802120:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  802123:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802126:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802129:	01 d0                	add    %edx,%eax
  80212b:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802130:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802137:	eb 5e                	jmp    802197 <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  802139:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80213c:	89 d0                	mov    %edx,%eax
  80213e:	01 c0                	add    %eax,%eax
  802140:	01 d0                	add    %edx,%eax
  802142:	c1 e0 02             	shl    $0x2,%eax
  802145:	05 48 50 80 00       	add    $0x805048,%eax
  80214a:	8a 00                	mov    (%eax),%al
  80214c:	84 c0                	test   %al,%al
  80214e:	75 44                	jne    802194 <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  802150:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802153:	89 d0                	mov    %edx,%eax
  802155:	01 c0                	add    %eax,%eax
  802157:	01 d0                	add    %edx,%eax
  802159:	c1 e0 02             	shl    $0x2,%eax
  80215c:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  802162:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802165:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  802167:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80216a:	89 d0                	mov    %edx,%eax
  80216c:	01 c0                	add    %eax,%eax
  80216e:	01 d0                	add    %edx,%eax
  802170:	c1 e0 02             	shl    $0x2,%eax
  802173:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802179:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80217c:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  80217e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802181:	89 d0                	mov    %edx,%eax
  802183:	01 c0                	add    %eax,%eax
  802185:	01 d0                	add    %edx,%eax
  802187:	c1 e0 02             	shl    $0x2,%eax
  80218a:	05 48 50 80 00       	add    $0x805048,%eax
  80218f:	c6 00 01             	movb   $0x1,(%eax)
            break;
  802192:	eb 0c                	jmp    8021a0 <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802194:	ff 45 e0             	incl   -0x20(%ebp)
  802197:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80219e:	7e 99                	jle    802139 <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  8021a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8021a3:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  8021a7:	52                   	push   %edx
  8021a8:	50                   	push   %eax
  8021a9:	ff 75 d4             	pushl  -0x2c(%ebp)
  8021ac:	ff 75 08             	pushl  0x8(%ebp)
  8021af:	e8 de 0e 00 00       	call   803092 <sys_create_shared_object>
  8021b4:	83 c4 10             	add    $0x10,%esp
  8021b7:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  8021ba:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  8021be:	75 07                	jne    8021c7 <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  8021c0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8021c5:	eb 10                	jmp    8021d7 <smalloc+0x358>
    if (r < 0)
  8021c7:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  8021cb:	79 07                	jns    8021d4 <smalloc+0x355>
        return NULL;
  8021cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d2:	eb 03                	jmp    8021d7 <smalloc+0x358>
    return (void*)va;
  8021d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8021d7:	c9                   	leave  
  8021d8:	c3                   	ret    

008021d9 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8021d9:	55                   	push   %ebp
  8021da:	89 e5                	mov    %esp,%ebp
  8021dc:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8021df:	e8 51 f4 ff ff       	call   801635 <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  8021e4:	83 ec 08             	sub    $0x8,%esp
  8021e7:	ff 75 0c             	pushl  0xc(%ebp)
  8021ea:	ff 75 08             	pushl  0x8(%ebp)
  8021ed:	e8 ca 0e 00 00       	call   8030bc <sys_size_of_shared_object>
  8021f2:	83 c4 10             	add    $0x10,%esp
  8021f5:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  8021f8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8021fc:	7f 0a                	jg     802208 <sget+0x2f>
        return NULL;
  8021fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802203:	e9 28 03 00 00       	jmp    802530 <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  802208:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80220f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802212:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802215:	01 d0                	add    %edx,%eax
  802217:	48                   	dec    %eax
  802218:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80221b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80221e:	ba 00 00 00 00       	mov    $0x0,%edx
  802223:	f7 75 d8             	divl   -0x28(%ebp)
  802226:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802229:	29 d0                	sub    %edx,%eax
  80222b:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  80222e:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  802235:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  80223c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802243:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80224a:	e9 85 00 00 00       	jmp    8022d4 <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  80224f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802252:	89 d0                	mov    %edx,%eax
  802254:	01 c0                	add    %eax,%eax
  802256:	01 d0                	add    %edx,%eax
  802258:	c1 e0 02             	shl    $0x2,%eax
  80225b:	05 48 10 81 00       	add    $0x811048,%eax
  802260:	8a 00                	mov    (%eax),%al
  802262:	84 c0                	test   %al,%al
  802264:	74 20                	je     802286 <sget+0xad>
  802266:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802269:	89 d0                	mov    %edx,%eax
  80226b:	01 c0                	add    %eax,%eax
  80226d:	01 d0                	add    %edx,%eax
  80226f:	c1 e0 02             	shl    $0x2,%eax
  802272:	05 44 10 81 00       	add    $0x811044,%eax
  802277:	8b 00                	mov    (%eax),%eax
  802279:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80227c:	75 08                	jne    802286 <sget+0xad>
        {
            exactIdx = i;
  80227e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802281:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  802284:	eb 5b                	jmp    8022e1 <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  802286:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802289:	89 d0                	mov    %edx,%eax
  80228b:	01 c0                	add    %eax,%eax
  80228d:	01 d0                	add    %edx,%eax
  80228f:	c1 e0 02             	shl    $0x2,%eax
  802292:	05 48 10 81 00       	add    $0x811048,%eax
  802297:	8a 00                	mov    (%eax),%al
  802299:	84 c0                	test   %al,%al
  80229b:	74 34                	je     8022d1 <sget+0xf8>
  80229d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8022a0:	89 d0                	mov    %edx,%eax
  8022a2:	01 c0                	add    %eax,%eax
  8022a4:	01 d0                	add    %edx,%eax
  8022a6:	c1 e0 02             	shl    $0x2,%eax
  8022a9:	05 44 10 81 00       	add    $0x811044,%eax
  8022ae:	8b 00                	mov    (%eax),%eax
  8022b0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8022b3:	76 1c                	jbe    8022d1 <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  8022b5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8022b8:	89 d0                	mov    %edx,%eax
  8022ba:	01 c0                	add    %eax,%eax
  8022bc:	01 d0                	add    %edx,%eax
  8022be:	c1 e0 02             	shl    $0x2,%eax
  8022c1:	05 44 10 81 00       	add    $0x811044,%eax
  8022c6:	8b 00                	mov    (%eax),%eax
  8022c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  8022cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8022d1:	ff 45 e8             	incl   -0x18(%ebp)
  8022d4:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8022db:	0f 8e 6e ff ff ff    	jle    80224f <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  8022e1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  8022e8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8022ec:	74 7d                	je     80236b <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  8022ee:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8022f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022f8:	89 d0                	mov    %edx,%eax
  8022fa:	01 c0                	add    %eax,%eax
  8022fc:	01 d0                	add    %edx,%eax
  8022fe:	c1 e0 02             	shl    $0x2,%eax
  802301:	05 40 10 81 00       	add    $0x811040,%eax
  802306:	8b 10                	mov    (%eax),%edx
  802308:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80230b:	01 d0                	add    %edx,%eax
  80230d:	48                   	dec    %eax
  80230e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802311:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802314:	ba 00 00 00 00       	mov    $0x0,%edx
  802319:	f7 75 b8             	divl   -0x48(%ebp)
  80231c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80231f:	29 d0                	sub    %edx,%eax
  802321:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  802324:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802327:	89 d0                	mov    %edx,%eax
  802329:	01 c0                	add    %eax,%eax
  80232b:	01 d0                	add    %edx,%eax
  80232d:	c1 e0 02             	shl    $0x2,%eax
  802330:	05 48 10 81 00       	add    $0x811048,%eax
  802335:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  802338:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80233b:	89 d0                	mov    %edx,%eax
  80233d:	01 c0                	add    %eax,%eax
  80233f:	01 d0                	add    %edx,%eax
  802341:	c1 e0 02             	shl    $0x2,%eax
  802344:	05 44 10 81 00       	add    $0x811044,%eax
  802349:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  80234f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802352:	89 d0                	mov    %edx,%eax
  802354:	01 c0                	add    %eax,%eax
  802356:	01 d0                	add    %edx,%eax
  802358:	c1 e0 02             	shl    $0x2,%eax
  80235b:	05 40 10 81 00       	add    $0x811040,%eax
  802360:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802366:	e9 2d 01 00 00       	jmp    802498 <sget+0x2bf>
    }
    else if (worstIdx != -1)
  80236b:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80236f:	0f 84 ce 00 00 00    	je     802443 <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  802375:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  80237c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80237f:	89 d0                	mov    %edx,%eax
  802381:	01 c0                	add    %eax,%eax
  802383:	01 d0                	add    %edx,%eax
  802385:	c1 e0 02             	shl    $0x2,%eax
  802388:	05 40 10 81 00       	add    $0x811040,%eax
  80238d:	8b 10                	mov    (%eax),%edx
  80238f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802392:	01 d0                	add    %edx,%eax
  802394:	48                   	dec    %eax
  802395:	89 45 bc             	mov    %eax,-0x44(%ebp)
  802398:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80239b:	ba 00 00 00 00       	mov    $0x0,%edx
  8023a0:	f7 75 c0             	divl   -0x40(%ebp)
  8023a3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8023a6:	29 d0                	sub    %edx,%eax
  8023a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  8023ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023ae:	89 d0                	mov    %edx,%eax
  8023b0:	01 c0                	add    %eax,%eax
  8023b2:	01 d0                	add    %edx,%eax
  8023b4:	c1 e0 02             	shl    $0x2,%eax
  8023b7:	05 44 10 81 00       	add    $0x811044,%eax
  8023bc:	8b 00                	mov    (%eax),%eax
  8023be:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8023c1:	75 47                	jne    80240a <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  8023c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023c6:	89 d0                	mov    %edx,%eax
  8023c8:	01 c0                	add    %eax,%eax
  8023ca:	01 d0                	add    %edx,%eax
  8023cc:	c1 e0 02             	shl    $0x2,%eax
  8023cf:	05 48 10 81 00       	add    $0x811048,%eax
  8023d4:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  8023d7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023da:	89 d0                	mov    %edx,%eax
  8023dc:	01 c0                	add    %eax,%eax
  8023de:	01 d0                	add    %edx,%eax
  8023e0:	c1 e0 02             	shl    $0x2,%eax
  8023e3:	05 44 10 81 00       	add    $0x811044,%eax
  8023e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  8023ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023f1:	89 d0                	mov    %edx,%eax
  8023f3:	01 c0                	add    %eax,%eax
  8023f5:	01 d0                	add    %edx,%eax
  8023f7:	c1 e0 02             	shl    $0x2,%eax
  8023fa:	05 40 10 81 00       	add    $0x811040,%eax
  8023ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802405:	e9 8e 00 00 00       	jmp    802498 <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  80240a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80240d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802410:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802413:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802416:	89 d0                	mov    %edx,%eax
  802418:	01 c0                	add    %eax,%eax
  80241a:	01 d0                	add    %edx,%eax
  80241c:	c1 e0 02             	shl    $0x2,%eax
  80241f:	05 40 10 81 00       	add    $0x811040,%eax
  802424:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  802426:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802429:	2b 45 d0             	sub    -0x30(%ebp),%eax
  80242c:	89 c2                	mov    %eax,%edx
  80242e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802431:	89 c8                	mov    %ecx,%eax
  802433:	01 c0                	add    %eax,%eax
  802435:	01 c8                	add    %ecx,%eax
  802437:	c1 e0 02             	shl    $0x2,%eax
  80243a:	05 44 10 81 00       	add    $0x811044,%eax
  80243f:	89 10                	mov    %edx,(%eax)
  802441:	eb 55                	jmp    802498 <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  802443:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80244a:	8b 15 88 50 83 00    	mov    0x835088,%edx
  802450:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802453:	01 d0                	add    %edx,%eax
  802455:	48                   	dec    %eax
  802456:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802459:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80245c:	ba 00 00 00 00       	mov    $0x0,%edx
  802461:	f7 75 cc             	divl   -0x34(%ebp)
  802464:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802467:	29 d0                	sub    %edx,%eax
  802469:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  80246c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80246f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802472:	01 d0                	add    %edx,%eax
  802474:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802479:	76 0a                	jbe    802485 <sget+0x2ac>
            return NULL;
  80247b:	b8 00 00 00 00       	mov    $0x0,%eax
  802480:	e9 ab 00 00 00       	jmp    802530 <sget+0x357>
        va = start;
  802485:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802488:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  80248b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80248e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802491:	01 d0                	add    %edx,%eax
  802493:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802498:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80249f:	eb 5e                	jmp    8024ff <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  8024a1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024a4:	89 d0                	mov    %edx,%eax
  8024a6:	01 c0                	add    %eax,%eax
  8024a8:	01 d0                	add    %edx,%eax
  8024aa:	c1 e0 02             	shl    $0x2,%eax
  8024ad:	05 48 50 80 00       	add    $0x805048,%eax
  8024b2:	8a 00                	mov    (%eax),%al
  8024b4:	84 c0                	test   %al,%al
  8024b6:	75 44                	jne    8024fc <sget+0x323>
        {
            uhp_allocs[i].va = va;
  8024b8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024bb:	89 d0                	mov    %edx,%eax
  8024bd:	01 c0                	add    %eax,%eax
  8024bf:	01 d0                	add    %edx,%eax
  8024c1:	c1 e0 02             	shl    $0x2,%eax
  8024c4:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  8024ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024cd:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  8024cf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024d2:	89 d0                	mov    %edx,%eax
  8024d4:	01 c0                	add    %eax,%eax
  8024d6:	01 d0                	add    %edx,%eax
  8024d8:	c1 e0 02             	shl    $0x2,%eax
  8024db:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8024e1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8024e4:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  8024e6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024e9:	89 d0                	mov    %edx,%eax
  8024eb:	01 c0                	add    %eax,%eax
  8024ed:	01 d0                	add    %edx,%eax
  8024ef:	c1 e0 02             	shl    $0x2,%eax
  8024f2:	05 48 50 80 00       	add    $0x805048,%eax
  8024f7:	c6 00 01             	movb   $0x1,(%eax)
            break;
  8024fa:	eb 0c                	jmp    802508 <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8024fc:	ff 45 e0             	incl   -0x20(%ebp)
  8024ff:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802506:	7e 99                	jle    8024a1 <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  802508:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80250b:	83 ec 04             	sub    $0x4,%esp
  80250e:	50                   	push   %eax
  80250f:	ff 75 0c             	pushl  0xc(%ebp)
  802512:	ff 75 08             	pushl  0x8(%ebp)
  802515:	e8 bf 0b 00 00       	call   8030d9 <sys_get_shared_object>
  80251a:	83 c4 10             	add    $0x10,%esp
  80251d:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  802520:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802524:	79 07                	jns    80252d <sget+0x354>
        return NULL;
  802526:	b8 00 00 00 00       	mov    $0x0,%eax
  80252b:	eb 03                	jmp    802530 <sget+0x357>
    return (void*)va;
  80252d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  802530:	c9                   	leave  
  802531:	c3                   	ret    

00802532 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802532:	55                   	push   %ebp
  802533:	89 e5                	mov    %esp,%ebp
  802535:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802538:	e8 f8 f0 ff ff       	call   801635 <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  80253d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802541:	75 13                	jne    802556 <realloc+0x24>
		return malloc(new_size);
  802543:	83 ec 0c             	sub    $0xc,%esp
  802546:	ff 75 0c             	pushl  0xc(%ebp)
  802549:	e8 c4 f1 ff ff       	call   801712 <malloc>
  80254e:	83 c4 10             	add    $0x10,%esp
  802551:	e9 f4 05 00 00       	jmp    802b4a <realloc+0x618>
	if (new_size == 0)
  802556:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80255a:	75 18                	jne    802574 <realloc+0x42>
	{
		free(virtual_address);
  80255c:	83 ec 0c             	sub    $0xc,%esp
  80255f:	ff 75 08             	pushl  0x8(%ebp)
  802562:	e8 0b f5 ff ff       	call   801a72 <free>
  802567:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80256a:	b8 00 00 00 00       	mov    $0x0,%eax
  80256f:	e9 d6 05 00 00       	jmp    802b4a <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  802574:	8b 45 08             	mov    0x8(%ebp),%eax
  802577:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  80257a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80257d:	85 c0                	test   %eax,%eax
  80257f:	79 74                	jns    8025f5 <realloc+0xc3>
  802581:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  802588:	77 6b                	ja     8025f5 <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  80258a:	83 ec 0c             	sub    $0xc,%esp
  80258d:	ff 75 0c             	pushl  0xc(%ebp)
  802590:	e8 7d f1 ff ff       	call   801712 <malloc>
  802595:	83 c4 10             	add    $0x10,%esp
  802598:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  80259b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80259f:	75 0a                	jne    8025ab <realloc+0x79>
			return NULL;
  8025a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a6:	e9 9f 05 00 00       	jmp    802b4a <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  8025ab:	83 ec 0c             	sub    $0xc,%esp
  8025ae:	ff 75 08             	pushl  0x8(%ebp)
  8025b1:	e8 e0 11 00 00       	call   803796 <get_block_size>
  8025b6:	83 c4 10             	add    $0x10,%esp
  8025b9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  8025bc:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8025bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025c2:	39 d0                	cmp    %edx,%eax
  8025c4:	76 02                	jbe    8025c8 <realloc+0x96>
  8025c6:	89 d0                	mov    %edx,%eax
  8025c8:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  8025cb:	83 ec 04             	sub    $0x4,%esp
  8025ce:	ff 75 c0             	pushl  -0x40(%ebp)
  8025d1:	ff 75 08             	pushl  0x8(%ebp)
  8025d4:	ff 75 c8             	pushl  -0x38(%ebp)
  8025d7:	e8 56 eb ff ff       	call   801132 <memmove>
  8025dc:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  8025df:	83 ec 0c             	sub    $0xc,%esp
  8025e2:	ff 75 08             	pushl  0x8(%ebp)
  8025e5:	e8 88 f4 ff ff       	call   801a72 <free>
  8025ea:	83 c4 10             	add    $0x10,%esp
		return newptr;
  8025ed:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8025f0:	e9 55 05 00 00       	jmp    802b4a <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  8025f5:	a1 30 51 83 00       	mov    0x835130,%eax
  8025fa:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  8025fd:	72 09                	jb     802608 <realloc+0xd6>
  8025ff:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  802606:	76 0a                	jbe    802612 <realloc+0xe0>
		return NULL;
  802608:	b8 00 00 00 00       	mov    $0x0,%eax
  80260d:	e9 38 05 00 00       	jmp    802b4a <realloc+0x618>
	uint32 oldsz = 0;
  802612:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  802619:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802620:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802627:	eb 50                	jmp    802679 <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802629:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80262c:	89 d0                	mov    %edx,%eax
  80262e:	01 c0                	add    %eax,%eax
  802630:	01 d0                	add    %edx,%eax
  802632:	c1 e0 02             	shl    $0x2,%eax
  802635:	05 48 50 80 00       	add    $0x805048,%eax
  80263a:	8a 00                	mov    (%eax),%al
  80263c:	84 c0                	test   %al,%al
  80263e:	74 36                	je     802676 <realloc+0x144>
  802640:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802643:	89 d0                	mov    %edx,%eax
  802645:	01 c0                	add    %eax,%eax
  802647:	01 d0                	add    %edx,%eax
  802649:	c1 e0 02             	shl    $0x2,%eax
  80264c:	05 40 50 80 00       	add    $0x805040,%eax
  802651:	8b 00                	mov    (%eax),%eax
  802653:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  802656:	75 1e                	jne    802676 <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  802658:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80265b:	89 d0                	mov    %edx,%eax
  80265d:	01 c0                	add    %eax,%eax
  80265f:	01 d0                	add    %edx,%eax
  802661:	c1 e0 02             	shl    $0x2,%eax
  802664:	05 44 50 80 00       	add    $0x805044,%eax
  802669:	8b 00                	mov    (%eax),%eax
  80266b:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  80266e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802671:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802674:	eb 0c                	jmp    802682 <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802676:	ff 45 ec             	incl   -0x14(%ebp)
  802679:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802680:	7e a7                	jle    802629 <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  802682:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802686:	75 0a                	jne    802692 <realloc+0x160>
		return NULL;
  802688:	b8 00 00 00 00       	mov    $0x0,%eax
  80268d:	e9 b8 04 00 00       	jmp    802b4a <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  802692:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  802699:	8b 55 0c             	mov    0xc(%ebp),%edx
  80269c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80269f:	01 d0                	add    %edx,%eax
  8026a1:	48                   	dec    %eax
  8026a2:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8026a5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8026a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8026ad:	f7 75 bc             	divl   -0x44(%ebp)
  8026b0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8026b3:	29 d0                	sub    %edx,%eax
  8026b5:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  8026b8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8026bb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8026be:	75 08                	jne    8026c8 <realloc+0x196>
		return virtual_address;
  8026c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c3:	e9 82 04 00 00       	jmp    802b4a <realloc+0x618>
	if (req < oldsz)
  8026c8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8026cb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8026ce:	0f 83 cd 02 00 00    	jae    8029a1 <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  8026d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d7:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  8026da:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  8026dd:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8026e0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8026e3:	01 d0                	add    %edx,%eax
  8026e5:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  8026e8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026eb:	89 d0                	mov    %edx,%eax
  8026ed:	01 c0                	add    %eax,%eax
  8026ef:	01 d0                	add    %edx,%eax
  8026f1:	c1 e0 02             	shl    $0x2,%eax
  8026f4:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8026fa:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8026fd:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  8026ff:	83 ec 08             	sub    $0x8,%esp
  802702:	ff 75 b0             	pushl  -0x50(%ebp)
  802705:	ff 75 ac             	pushl  -0x54(%ebp)
  802708:	e8 e3 0c 00 00       	call   8033f0 <sys_free_user_mem>
  80270d:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  802710:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802717:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80271e:	eb 64                	jmp    802784 <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  802720:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802723:	89 d0                	mov    %edx,%eax
  802725:	01 c0                	add    %eax,%eax
  802727:	01 d0                	add    %edx,%eax
  802729:	c1 e0 02             	shl    $0x2,%eax
  80272c:	05 48 10 81 00       	add    $0x811048,%eax
  802731:	8a 00                	mov    (%eax),%al
  802733:	84 c0                	test   %al,%al
  802735:	75 4a                	jne    802781 <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  802737:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80273a:	89 d0                	mov    %edx,%eax
  80273c:	01 c0                	add    %eax,%eax
  80273e:	01 d0                	add    %edx,%eax
  802740:	c1 e0 02             	shl    $0x2,%eax
  802743:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  802749:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80274c:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  80274e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802751:	89 d0                	mov    %edx,%eax
  802753:	01 c0                	add    %eax,%eax
  802755:	01 d0                	add    %edx,%eax
  802757:	c1 e0 02             	shl    $0x2,%eax
  80275a:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  802760:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802763:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  802765:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802768:	89 d0                	mov    %edx,%eax
  80276a:	01 c0                	add    %eax,%eax
  80276c:	01 d0                	add    %edx,%eax
  80276e:	c1 e0 02             	shl    $0x2,%eax
  802771:	05 48 10 81 00       	add    $0x811048,%eax
  802776:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  802779:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80277c:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  80277f:	eb 0c                	jmp    80278d <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802781:	ff 45 e4             	incl   -0x1c(%ebp)
  802784:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  80278b:	7e 93                	jle    802720 <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  80278d:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802791:	0f 84 8d 01 00 00    	je     802924 <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802797:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80279e:	e9 74 01 00 00       	jmp    802917 <realloc+0x3e5>
			{
				if (k == fidx) continue;
  8027a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027a6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8027a9:	0f 84 64 01 00 00    	je     802913 <realloc+0x3e1>
				if (uhp_frees[k].free)
  8027af:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027b2:	89 d0                	mov    %edx,%eax
  8027b4:	01 c0                	add    %eax,%eax
  8027b6:	01 d0                	add    %edx,%eax
  8027b8:	c1 e0 02             	shl    $0x2,%eax
  8027bb:	05 48 10 81 00       	add    $0x811048,%eax
  8027c0:	8a 00                	mov    (%eax),%al
  8027c2:	84 c0                	test   %al,%al
  8027c4:	0f 84 4a 01 00 00    	je     802914 <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  8027ca:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027cd:	89 d0                	mov    %edx,%eax
  8027cf:	01 c0                	add    %eax,%eax
  8027d1:	01 d0                	add    %edx,%eax
  8027d3:	c1 e0 02             	shl    $0x2,%eax
  8027d6:	05 40 10 81 00       	add    $0x811040,%eax
  8027db:	8b 08                	mov    (%eax),%ecx
  8027dd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027e0:	89 d0                	mov    %edx,%eax
  8027e2:	01 c0                	add    %eax,%eax
  8027e4:	01 d0                	add    %edx,%eax
  8027e6:	c1 e0 02             	shl    $0x2,%eax
  8027e9:	05 44 10 81 00       	add    $0x811044,%eax
  8027ee:	8b 00                	mov    (%eax),%eax
  8027f0:	01 c1                	add    %eax,%ecx
  8027f2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027f5:	89 d0                	mov    %edx,%eax
  8027f7:	01 c0                	add    %eax,%eax
  8027f9:	01 d0                	add    %edx,%eax
  8027fb:	c1 e0 02             	shl    $0x2,%eax
  8027fe:	05 40 10 81 00       	add    $0x811040,%eax
  802803:	8b 00                	mov    (%eax),%eax
  802805:	39 c1                	cmp    %eax,%ecx
  802807:	75 7a                	jne    802883 <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  802809:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80280c:	89 d0                	mov    %edx,%eax
  80280e:	01 c0                	add    %eax,%eax
  802810:	01 d0                	add    %edx,%eax
  802812:	c1 e0 02             	shl    $0x2,%eax
  802815:	05 40 10 81 00       	add    $0x811040,%eax
  80281a:	8b 10                	mov    (%eax),%edx
  80281c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  80281f:	89 c8                	mov    %ecx,%eax
  802821:	01 c0                	add    %eax,%eax
  802823:	01 c8                	add    %ecx,%eax
  802825:	c1 e0 02             	shl    $0x2,%eax
  802828:	05 40 10 81 00       	add    $0x811040,%eax
  80282d:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  80282f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802832:	89 d0                	mov    %edx,%eax
  802834:	01 c0                	add    %eax,%eax
  802836:	01 d0                	add    %edx,%eax
  802838:	c1 e0 02             	shl    $0x2,%eax
  80283b:	05 44 10 81 00       	add    $0x811044,%eax
  802840:	8b 08                	mov    (%eax),%ecx
  802842:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802845:	89 d0                	mov    %edx,%eax
  802847:	01 c0                	add    %eax,%eax
  802849:	01 d0                	add    %edx,%eax
  80284b:	c1 e0 02             	shl    $0x2,%eax
  80284e:	05 44 10 81 00       	add    $0x811044,%eax
  802853:	8b 00                	mov    (%eax),%eax
  802855:	01 c1                	add    %eax,%ecx
  802857:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80285a:	89 d0                	mov    %edx,%eax
  80285c:	01 c0                	add    %eax,%eax
  80285e:	01 d0                	add    %edx,%eax
  802860:	c1 e0 02             	shl    $0x2,%eax
  802863:	05 44 10 81 00       	add    $0x811044,%eax
  802868:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  80286a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80286d:	89 d0                	mov    %edx,%eax
  80286f:	01 c0                	add    %eax,%eax
  802871:	01 d0                	add    %edx,%eax
  802873:	c1 e0 02             	shl    $0x2,%eax
  802876:	05 48 10 81 00       	add    $0x811048,%eax
  80287b:	c6 00 00             	movb   $0x0,(%eax)
  80287e:	e9 91 00 00 00       	jmp    802914 <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802883:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802886:	89 d0                	mov    %edx,%eax
  802888:	01 c0                	add    %eax,%eax
  80288a:	01 d0                	add    %edx,%eax
  80288c:	c1 e0 02             	shl    $0x2,%eax
  80288f:	05 40 10 81 00       	add    $0x811040,%eax
  802894:	8b 08                	mov    (%eax),%ecx
  802896:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802899:	89 d0                	mov    %edx,%eax
  80289b:	01 c0                	add    %eax,%eax
  80289d:	01 d0                	add    %edx,%eax
  80289f:	c1 e0 02             	shl    $0x2,%eax
  8028a2:	05 44 10 81 00       	add    $0x811044,%eax
  8028a7:	8b 00                	mov    (%eax),%eax
  8028a9:	01 c1                	add    %eax,%ecx
  8028ab:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028ae:	89 d0                	mov    %edx,%eax
  8028b0:	01 c0                	add    %eax,%eax
  8028b2:	01 d0                	add    %edx,%eax
  8028b4:	c1 e0 02             	shl    $0x2,%eax
  8028b7:	05 40 10 81 00       	add    $0x811040,%eax
  8028bc:	8b 00                	mov    (%eax),%eax
  8028be:	39 c1                	cmp    %eax,%ecx
  8028c0:	75 52                	jne    802914 <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  8028c2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028c5:	89 d0                	mov    %edx,%eax
  8028c7:	01 c0                	add    %eax,%eax
  8028c9:	01 d0                	add    %edx,%eax
  8028cb:	c1 e0 02             	shl    $0x2,%eax
  8028ce:	05 44 10 81 00       	add    $0x811044,%eax
  8028d3:	8b 08                	mov    (%eax),%ecx
  8028d5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028d8:	89 d0                	mov    %edx,%eax
  8028da:	01 c0                	add    %eax,%eax
  8028dc:	01 d0                	add    %edx,%eax
  8028de:	c1 e0 02             	shl    $0x2,%eax
  8028e1:	05 44 10 81 00       	add    $0x811044,%eax
  8028e6:	8b 00                	mov    (%eax),%eax
  8028e8:	01 c1                	add    %eax,%ecx
  8028ea:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028ed:	89 d0                	mov    %edx,%eax
  8028ef:	01 c0                	add    %eax,%eax
  8028f1:	01 d0                	add    %edx,%eax
  8028f3:	c1 e0 02             	shl    $0x2,%eax
  8028f6:	05 44 10 81 00       	add    $0x811044,%eax
  8028fb:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  8028fd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802900:	89 d0                	mov    %edx,%eax
  802902:	01 c0                	add    %eax,%eax
  802904:	01 d0                	add    %edx,%eax
  802906:	c1 e0 02             	shl    $0x2,%eax
  802909:	05 48 10 81 00       	add    $0x811048,%eax
  80290e:	c6 00 00             	movb   $0x0,(%eax)
  802911:	eb 01                	jmp    802914 <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  802913:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802914:	ff 45 e0             	incl   -0x20(%ebp)
  802917:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80291e:	0f 8e 7f fe ff ff    	jle    8027a3 <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  802924:	a1 30 51 83 00       	mov    0x835130,%eax
  802929:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  80292c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  802933:	eb 53                	jmp    802988 <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  802935:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802938:	89 d0                	mov    %edx,%eax
  80293a:	01 c0                	add    %eax,%eax
  80293c:	01 d0                	add    %edx,%eax
  80293e:	c1 e0 02             	shl    $0x2,%eax
  802941:	05 48 50 80 00       	add    $0x805048,%eax
  802946:	8a 00                	mov    (%eax),%al
  802948:	84 c0                	test   %al,%al
  80294a:	74 39                	je     802985 <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  80294c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80294f:	89 d0                	mov    %edx,%eax
  802951:	01 c0                	add    %eax,%eax
  802953:	01 d0                	add    %edx,%eax
  802955:	c1 e0 02             	shl    $0x2,%eax
  802958:	05 40 50 80 00       	add    $0x805040,%eax
  80295d:	8b 08                	mov    (%eax),%ecx
  80295f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802962:	89 d0                	mov    %edx,%eax
  802964:	01 c0                	add    %eax,%eax
  802966:	01 d0                	add    %edx,%eax
  802968:	c1 e0 02             	shl    $0x2,%eax
  80296b:	05 44 50 80 00       	add    $0x805044,%eax
  802970:	8b 00                	mov    (%eax),%eax
  802972:	01 c8                	add    %ecx,%eax
  802974:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  802977:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80297a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80297d:	76 06                	jbe    802985 <realloc+0x453>
  80297f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802982:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802985:	ff 45 d8             	incl   -0x28(%ebp)
  802988:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  80298f:	7e a4                	jle    802935 <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  802991:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802994:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  802999:	8b 45 08             	mov    0x8(%ebp),%eax
  80299c:	e9 a9 01 00 00       	jmp    802b4a <realloc+0x618>
	}
	uint32 end = va + oldsz;
  8029a1:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a7:	01 d0                	add    %edx,%eax
  8029a9:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  8029ac:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8029b3:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  8029ba:	eb 57                	jmp    802a13 <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  8029bc:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8029bf:	89 d0                	mov    %edx,%eax
  8029c1:	01 c0                	add    %eax,%eax
  8029c3:	01 d0                	add    %edx,%eax
  8029c5:	c1 e0 02             	shl    $0x2,%eax
  8029c8:	05 48 10 81 00       	add    $0x811048,%eax
  8029cd:	8a 00                	mov    (%eax),%al
  8029cf:	84 c0                	test   %al,%al
  8029d1:	74 3d                	je     802a10 <realloc+0x4de>
  8029d3:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8029d6:	89 d0                	mov    %edx,%eax
  8029d8:	01 c0                	add    %eax,%eax
  8029da:	01 d0                	add    %edx,%eax
  8029dc:	c1 e0 02             	shl    $0x2,%eax
  8029df:	05 40 10 81 00       	add    $0x811040,%eax
  8029e4:	8b 00                	mov    (%eax),%eax
  8029e6:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029e9:	75 25                	jne    802a10 <realloc+0x4de>
  8029eb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8029ee:	89 d0                	mov    %edx,%eax
  8029f0:	01 c0                	add    %eax,%eax
  8029f2:	01 d0                	add    %edx,%eax
  8029f4:	c1 e0 02             	shl    $0x2,%eax
  8029f7:	05 44 10 81 00       	add    $0x811044,%eax
  8029fc:	8b 10                	mov    (%eax),%edx
  8029fe:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a01:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802a04:	39 c2                	cmp    %eax,%edx
  802a06:	72 08                	jb     802a10 <realloc+0x4de>
		{
			adjIdx = j; break;
  802a08:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802a0b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802a0e:	eb 0c                	jmp    802a1c <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802a10:	ff 45 d0             	incl   -0x30(%ebp)
  802a13:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  802a1a:	7e a0                	jle    8029bc <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  802a1c:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  802a20:	0f 84 d6 00 00 00    	je     802afc <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  802a26:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a29:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802a2c:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  802a2f:	83 ec 08             	sub    $0x8,%esp
  802a32:	ff 75 a0             	pushl  -0x60(%ebp)
  802a35:	ff 75 a4             	pushl  -0x5c(%ebp)
  802a38:	e8 cf 09 00 00       	call   80340c <sys_allocate_user_mem>
  802a3d:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  802a40:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a43:	89 d0                	mov    %edx,%eax
  802a45:	01 c0                	add    %eax,%eax
  802a47:	01 d0                	add    %edx,%eax
  802a49:	c1 e0 02             	shl    $0x2,%eax
  802a4c:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802a52:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a55:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  802a57:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a5a:	89 d0                	mov    %edx,%eax
  802a5c:	01 c0                	add    %eax,%eax
  802a5e:	01 d0                	add    %edx,%eax
  802a60:	c1 e0 02             	shl    $0x2,%eax
  802a63:	05 40 10 81 00       	add    $0x811040,%eax
  802a68:	8b 10                	mov    (%eax),%edx
  802a6a:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802a6d:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802a70:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a73:	89 d0                	mov    %edx,%eax
  802a75:	01 c0                	add    %eax,%eax
  802a77:	01 d0                	add    %edx,%eax
  802a79:	c1 e0 02             	shl    $0x2,%eax
  802a7c:	05 40 10 81 00       	add    $0x811040,%eax
  802a81:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  802a83:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a86:	89 d0                	mov    %edx,%eax
  802a88:	01 c0                	add    %eax,%eax
  802a8a:	01 d0                	add    %edx,%eax
  802a8c:	c1 e0 02             	shl    $0x2,%eax
  802a8f:	05 44 10 81 00       	add    $0x811044,%eax
  802a94:	8b 00                	mov    (%eax),%eax
  802a96:	2b 45 a0             	sub    -0x60(%ebp),%eax
  802a99:	89 c2                	mov    %eax,%edx
  802a9b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  802a9e:	89 c8                	mov    %ecx,%eax
  802aa0:	01 c0                	add    %eax,%eax
  802aa2:	01 c8                	add    %ecx,%eax
  802aa4:	c1 e0 02             	shl    $0x2,%eax
  802aa7:	05 44 10 81 00       	add    $0x811044,%eax
  802aac:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  802aae:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802ab1:	89 d0                	mov    %edx,%eax
  802ab3:	01 c0                	add    %eax,%eax
  802ab5:	01 d0                	add    %edx,%eax
  802ab7:	c1 e0 02             	shl    $0x2,%eax
  802aba:	05 44 10 81 00       	add    $0x811044,%eax
  802abf:	8b 00                	mov    (%eax),%eax
  802ac1:	85 c0                	test   %eax,%eax
  802ac3:	75 14                	jne    802ad9 <realloc+0x5a7>
  802ac5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802ac8:	89 d0                	mov    %edx,%eax
  802aca:	01 c0                	add    %eax,%eax
  802acc:	01 d0                	add    %edx,%eax
  802ace:	c1 e0 02             	shl    $0x2,%eax
  802ad1:	05 48 10 81 00       	add    $0x811048,%eax
  802ad6:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  802ad9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802adc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802adf:	01 c2                	add    %eax,%edx
  802ae1:	a1 88 50 83 00       	mov    0x835088,%eax
  802ae6:	39 c2                	cmp    %eax,%edx
  802ae8:	76 0d                	jbe    802af7 <realloc+0x5c5>
  802aea:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802aed:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802af0:	01 d0                	add    %edx,%eax
  802af2:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  802af7:	8b 45 08             	mov    0x8(%ebp),%eax
  802afa:	eb 4e                	jmp    802b4a <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  802afc:	83 ec 0c             	sub    $0xc,%esp
  802aff:	ff 75 0c             	pushl  0xc(%ebp)
  802b02:	e8 0b ec ff ff       	call   801712 <malloc>
  802b07:	83 c4 10             	add    $0x10,%esp
  802b0a:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  802b0d:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  802b11:	75 07                	jne    802b1a <realloc+0x5e8>
		return NULL;
  802b13:	b8 00 00 00 00       	mov    $0x0,%eax
  802b18:	eb 30                	jmp    802b4a <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  802b1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b1d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b20:	39 d0                	cmp    %edx,%eax
  802b22:	76 02                	jbe    802b26 <realloc+0x5f4>
  802b24:	89 d0                	mov    %edx,%eax
  802b26:	8b 55 9c             	mov    -0x64(%ebp),%edx
  802b29:	83 ec 04             	sub    $0x4,%esp
  802b2c:	50                   	push   %eax
  802b2d:	52                   	push   %edx
  802b2e:	ff 75 cc             	pushl  -0x34(%ebp)
  802b31:	e8 cf 06 00 00       	call   803205 <sys_move_user_mem>
  802b36:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  802b39:	83 ec 0c             	sub    $0xc,%esp
  802b3c:	ff 75 08             	pushl  0x8(%ebp)
  802b3f:	e8 2e ef ff ff       	call   801a72 <free>
  802b44:	83 c4 10             	add    $0x10,%esp
	return newptr;
  802b47:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  802b4a:	c9                   	leave  
  802b4b:	c3                   	ret    

00802b4c <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802b4c:	55                   	push   %ebp
  802b4d:	89 e5                	mov    %esp,%ebp
  802b4f:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  802b52:	8b 45 08             	mov    0x8(%ebp),%eax
  802b55:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  802b58:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802b5c:	0f 84 33 03 00 00    	je     802e95 <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  802b62:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b65:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  802b6a:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  802b6d:	83 ec 08             	sub    $0x8,%esp
  802b70:	ff 75 08             	pushl  0x8(%ebp)
  802b73:	ff 75 d8             	pushl  -0x28(%ebp)
  802b76:	e8 7d 05 00 00       	call   8030f8 <sys_delete_shared_object>
  802b7b:	83 c4 10             	add    $0x10,%esp
  802b7e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  802b81:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802b85:	0f 88 0d 03 00 00    	js     802e98 <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802b8b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802b92:	e9 ef 02 00 00       	jmp    802e86 <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802b97:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b9a:	89 d0                	mov    %edx,%eax
  802b9c:	01 c0                	add    %eax,%eax
  802b9e:	01 d0                	add    %edx,%eax
  802ba0:	c1 e0 02             	shl    $0x2,%eax
  802ba3:	05 48 50 80 00       	add    $0x805048,%eax
  802ba8:	8a 00                	mov    (%eax),%al
  802baa:	84 c0                	test   %al,%al
  802bac:	0f 84 d1 02 00 00    	je     802e83 <sfree+0x337>
  802bb2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bb5:	89 d0                	mov    %edx,%eax
  802bb7:	01 c0                	add    %eax,%eax
  802bb9:	01 d0                	add    %edx,%eax
  802bbb:	c1 e0 02             	shl    $0x2,%eax
  802bbe:	05 40 50 80 00       	add    $0x805040,%eax
  802bc3:	8b 00                	mov    (%eax),%eax
  802bc5:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802bc8:	0f 85 b5 02 00 00    	jne    802e83 <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  802bce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bd1:	89 d0                	mov    %edx,%eax
  802bd3:	01 c0                	add    %eax,%eax
  802bd5:	01 d0                	add    %edx,%eax
  802bd7:	c1 e0 02             	shl    $0x2,%eax
  802bda:	05 44 50 80 00       	add    $0x805044,%eax
  802bdf:	8b 00                	mov    (%eax),%eax
  802be1:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  802be4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802be7:	89 d0                	mov    %edx,%eax
  802be9:	01 c0                	add    %eax,%eax
  802beb:	01 d0                	add    %edx,%eax
  802bed:	c1 e0 02             	shl    $0x2,%eax
  802bf0:	05 48 50 80 00       	add    $0x805048,%eax
  802bf5:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  802bf8:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802bff:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802c06:	eb 64                	jmp    802c6c <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  802c08:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c0b:	89 d0                	mov    %edx,%eax
  802c0d:	01 c0                	add    %eax,%eax
  802c0f:	01 d0                	add    %edx,%eax
  802c11:	c1 e0 02             	shl    $0x2,%eax
  802c14:	05 48 10 81 00       	add    $0x811048,%eax
  802c19:	8a 00                	mov    (%eax),%al
  802c1b:	84 c0                	test   %al,%al
  802c1d:	75 4a                	jne    802c69 <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  802c1f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c22:	89 d0                	mov    %edx,%eax
  802c24:	01 c0                	add    %eax,%eax
  802c26:	01 d0                	add    %edx,%eax
  802c28:	c1 e0 02             	shl    $0x2,%eax
  802c2b:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  802c31:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c34:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  802c36:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c39:	89 d0                	mov    %edx,%eax
  802c3b:	01 c0                	add    %eax,%eax
  802c3d:	01 d0                	add    %edx,%eax
  802c3f:	c1 e0 02             	shl    $0x2,%eax
  802c42:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  802c48:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c4b:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  802c4d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c50:	89 d0                	mov    %edx,%eax
  802c52:	01 c0                	add    %eax,%eax
  802c54:	01 d0                	add    %edx,%eax
  802c56:	c1 e0 02             	shl    $0x2,%eax
  802c59:	05 48 10 81 00       	add    $0x811048,%eax
  802c5e:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  802c61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c64:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  802c67:	eb 0c                	jmp    802c75 <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802c69:	ff 45 ec             	incl   -0x14(%ebp)
  802c6c:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802c73:	7e 93                	jle    802c08 <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  802c75:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802c79:	0f 84 8d 01 00 00    	je     802e0c <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802c7f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802c86:	e9 74 01 00 00       	jmp    802dff <sfree+0x2b3>
				{
					if (k == fidx) continue;
  802c8b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c8e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c91:	0f 84 64 01 00 00    	je     802dfb <sfree+0x2af>
					if (uhp_frees[k].free)
  802c97:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c9a:	89 d0                	mov    %edx,%eax
  802c9c:	01 c0                	add    %eax,%eax
  802c9e:	01 d0                	add    %edx,%eax
  802ca0:	c1 e0 02             	shl    $0x2,%eax
  802ca3:	05 48 10 81 00       	add    $0x811048,%eax
  802ca8:	8a 00                	mov    (%eax),%al
  802caa:	84 c0                	test   %al,%al
  802cac:	0f 84 4a 01 00 00    	je     802dfc <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802cb2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cb5:	89 d0                	mov    %edx,%eax
  802cb7:	01 c0                	add    %eax,%eax
  802cb9:	01 d0                	add    %edx,%eax
  802cbb:	c1 e0 02             	shl    $0x2,%eax
  802cbe:	05 40 10 81 00       	add    $0x811040,%eax
  802cc3:	8b 08                	mov    (%eax),%ecx
  802cc5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cc8:	89 d0                	mov    %edx,%eax
  802cca:	01 c0                	add    %eax,%eax
  802ccc:	01 d0                	add    %edx,%eax
  802cce:	c1 e0 02             	shl    $0x2,%eax
  802cd1:	05 44 10 81 00       	add    $0x811044,%eax
  802cd6:	8b 00                	mov    (%eax),%eax
  802cd8:	01 c1                	add    %eax,%ecx
  802cda:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cdd:	89 d0                	mov    %edx,%eax
  802cdf:	01 c0                	add    %eax,%eax
  802ce1:	01 d0                	add    %edx,%eax
  802ce3:	c1 e0 02             	shl    $0x2,%eax
  802ce6:	05 40 10 81 00       	add    $0x811040,%eax
  802ceb:	8b 00                	mov    (%eax),%eax
  802ced:	39 c1                	cmp    %eax,%ecx
  802cef:	75 7a                	jne    802d6b <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  802cf1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cf4:	89 d0                	mov    %edx,%eax
  802cf6:	01 c0                	add    %eax,%eax
  802cf8:	01 d0                	add    %edx,%eax
  802cfa:	c1 e0 02             	shl    $0x2,%eax
  802cfd:	05 40 10 81 00       	add    $0x811040,%eax
  802d02:	8b 10                	mov    (%eax),%edx
  802d04:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802d07:	89 c8                	mov    %ecx,%eax
  802d09:	01 c0                	add    %eax,%eax
  802d0b:	01 c8                	add    %ecx,%eax
  802d0d:	c1 e0 02             	shl    $0x2,%eax
  802d10:	05 40 10 81 00       	add    $0x811040,%eax
  802d15:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  802d17:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d1a:	89 d0                	mov    %edx,%eax
  802d1c:	01 c0                	add    %eax,%eax
  802d1e:	01 d0                	add    %edx,%eax
  802d20:	c1 e0 02             	shl    $0x2,%eax
  802d23:	05 44 10 81 00       	add    $0x811044,%eax
  802d28:	8b 08                	mov    (%eax),%ecx
  802d2a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d2d:	89 d0                	mov    %edx,%eax
  802d2f:	01 c0                	add    %eax,%eax
  802d31:	01 d0                	add    %edx,%eax
  802d33:	c1 e0 02             	shl    $0x2,%eax
  802d36:	05 44 10 81 00       	add    $0x811044,%eax
  802d3b:	8b 00                	mov    (%eax),%eax
  802d3d:	01 c1                	add    %eax,%ecx
  802d3f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d42:	89 d0                	mov    %edx,%eax
  802d44:	01 c0                	add    %eax,%eax
  802d46:	01 d0                	add    %edx,%eax
  802d48:	c1 e0 02             	shl    $0x2,%eax
  802d4b:	05 44 10 81 00       	add    $0x811044,%eax
  802d50:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802d52:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d55:	89 d0                	mov    %edx,%eax
  802d57:	01 c0                	add    %eax,%eax
  802d59:	01 d0                	add    %edx,%eax
  802d5b:	c1 e0 02             	shl    $0x2,%eax
  802d5e:	05 48 10 81 00       	add    $0x811048,%eax
  802d63:	c6 00 00             	movb   $0x0,(%eax)
  802d66:	e9 91 00 00 00       	jmp    802dfc <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802d6b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d6e:	89 d0                	mov    %edx,%eax
  802d70:	01 c0                	add    %eax,%eax
  802d72:	01 d0                	add    %edx,%eax
  802d74:	c1 e0 02             	shl    $0x2,%eax
  802d77:	05 40 10 81 00       	add    $0x811040,%eax
  802d7c:	8b 08                	mov    (%eax),%ecx
  802d7e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d81:	89 d0                	mov    %edx,%eax
  802d83:	01 c0                	add    %eax,%eax
  802d85:	01 d0                	add    %edx,%eax
  802d87:	c1 e0 02             	shl    $0x2,%eax
  802d8a:	05 44 10 81 00       	add    $0x811044,%eax
  802d8f:	8b 00                	mov    (%eax),%eax
  802d91:	01 c1                	add    %eax,%ecx
  802d93:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d96:	89 d0                	mov    %edx,%eax
  802d98:	01 c0                	add    %eax,%eax
  802d9a:	01 d0                	add    %edx,%eax
  802d9c:	c1 e0 02             	shl    $0x2,%eax
  802d9f:	05 40 10 81 00       	add    $0x811040,%eax
  802da4:	8b 00                	mov    (%eax),%eax
  802da6:	39 c1                	cmp    %eax,%ecx
  802da8:	75 52                	jne    802dfc <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  802daa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dad:	89 d0                	mov    %edx,%eax
  802daf:	01 c0                	add    %eax,%eax
  802db1:	01 d0                	add    %edx,%eax
  802db3:	c1 e0 02             	shl    $0x2,%eax
  802db6:	05 44 10 81 00       	add    $0x811044,%eax
  802dbb:	8b 08                	mov    (%eax),%ecx
  802dbd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802dc0:	89 d0                	mov    %edx,%eax
  802dc2:	01 c0                	add    %eax,%eax
  802dc4:	01 d0                	add    %edx,%eax
  802dc6:	c1 e0 02             	shl    $0x2,%eax
  802dc9:	05 44 10 81 00       	add    $0x811044,%eax
  802dce:	8b 00                	mov    (%eax),%eax
  802dd0:	01 c1                	add    %eax,%ecx
  802dd2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dd5:	89 d0                	mov    %edx,%eax
  802dd7:	01 c0                	add    %eax,%eax
  802dd9:	01 d0                	add    %edx,%eax
  802ddb:	c1 e0 02             	shl    $0x2,%eax
  802dde:	05 44 10 81 00       	add    $0x811044,%eax
  802de3:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802de5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802de8:	89 d0                	mov    %edx,%eax
  802dea:	01 c0                	add    %eax,%eax
  802dec:	01 d0                	add    %edx,%eax
  802dee:	c1 e0 02             	shl    $0x2,%eax
  802df1:	05 48 10 81 00       	add    $0x811048,%eax
  802df6:	c6 00 00             	movb   $0x0,(%eax)
  802df9:	eb 01                	jmp    802dfc <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  802dfb:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802dfc:	ff 45 e8             	incl   -0x18(%ebp)
  802dff:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802e06:	0f 8e 7f fe ff ff    	jle    802c8b <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  802e0c:	a1 30 51 83 00       	mov    0x835130,%eax
  802e11:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802e14:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802e1b:	eb 53                	jmp    802e70 <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  802e1d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e20:	89 d0                	mov    %edx,%eax
  802e22:	01 c0                	add    %eax,%eax
  802e24:	01 d0                	add    %edx,%eax
  802e26:	c1 e0 02             	shl    $0x2,%eax
  802e29:	05 48 50 80 00       	add    $0x805048,%eax
  802e2e:	8a 00                	mov    (%eax),%al
  802e30:	84 c0                	test   %al,%al
  802e32:	74 39                	je     802e6d <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802e34:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e37:	89 d0                	mov    %edx,%eax
  802e39:	01 c0                	add    %eax,%eax
  802e3b:	01 d0                	add    %edx,%eax
  802e3d:	c1 e0 02             	shl    $0x2,%eax
  802e40:	05 40 50 80 00       	add    $0x805040,%eax
  802e45:	8b 08                	mov    (%eax),%ecx
  802e47:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e4a:	89 d0                	mov    %edx,%eax
  802e4c:	01 c0                	add    %eax,%eax
  802e4e:	01 d0                	add    %edx,%eax
  802e50:	c1 e0 02             	shl    $0x2,%eax
  802e53:	05 44 50 80 00       	add    $0x805044,%eax
  802e58:	8b 00                	mov    (%eax),%eax
  802e5a:	01 c8                	add    %ecx,%eax
  802e5c:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  802e5f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e62:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802e65:	76 06                	jbe    802e6d <sfree+0x321>
  802e67:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e6a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802e6d:	ff 45 e0             	incl   -0x20(%ebp)
  802e70:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802e77:	7e a4                	jle    802e1d <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  802e79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e7c:	a3 88 50 83 00       	mov    %eax,0x835088
			break;
  802e81:	eb 16                	jmp    802e99 <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802e83:	ff 45 f4             	incl   -0xc(%ebp)
  802e86:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  802e8d:	0f 8e 04 fd ff ff    	jle    802b97 <sfree+0x4b>
  802e93:	eb 04                	jmp    802e99 <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  802e95:	90                   	nop
  802e96:	eb 01                	jmp    802e99 <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  802e98:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  802e99:	c9                   	leave  
  802e9a:	c3                   	ret    

00802e9b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802e9b:	55                   	push   %ebp
  802e9c:	89 e5                	mov    %esp,%ebp
  802e9e:	57                   	push   %edi
  802e9f:	56                   	push   %esi
  802ea0:	53                   	push   %ebx
  802ea1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea7:	8b 55 0c             	mov    0xc(%ebp),%edx
  802eaa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802ead:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802eb0:	8b 7d 18             	mov    0x18(%ebp),%edi
  802eb3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802eb6:	cd 30                	int    $0x30
  802eb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802ebb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802ebe:	83 c4 10             	add    $0x10,%esp
  802ec1:	5b                   	pop    %ebx
  802ec2:	5e                   	pop    %esi
  802ec3:	5f                   	pop    %edi
  802ec4:	5d                   	pop    %ebp
  802ec5:	c3                   	ret    

00802ec6 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802ec6:	55                   	push   %ebp
  802ec7:	89 e5                	mov    %esp,%ebp
  802ec9:	83 ec 04             	sub    $0x4,%esp
  802ecc:	8b 45 10             	mov    0x10(%ebp),%eax
  802ecf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802ed2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802ed5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  802edc:	6a 00                	push   $0x0
  802ede:	51                   	push   %ecx
  802edf:	52                   	push   %edx
  802ee0:	ff 75 0c             	pushl  0xc(%ebp)
  802ee3:	50                   	push   %eax
  802ee4:	6a 00                	push   $0x0
  802ee6:	e8 b0 ff ff ff       	call   802e9b <syscall>
  802eeb:	83 c4 18             	add    $0x18,%esp
}
  802eee:	90                   	nop
  802eef:	c9                   	leave  
  802ef0:	c3                   	ret    

00802ef1 <sys_cgetc>:

int
sys_cgetc(void)
{
  802ef1:	55                   	push   %ebp
  802ef2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802ef4:	6a 00                	push   $0x0
  802ef6:	6a 00                	push   $0x0
  802ef8:	6a 00                	push   $0x0
  802efa:	6a 00                	push   $0x0
  802efc:	6a 00                	push   $0x0
  802efe:	6a 02                	push   $0x2
  802f00:	e8 96 ff ff ff       	call   802e9b <syscall>
  802f05:	83 c4 18             	add    $0x18,%esp
}
  802f08:	c9                   	leave  
  802f09:	c3                   	ret    

00802f0a <sys_lock_cons>:

void sys_lock_cons(void)
{
  802f0a:	55                   	push   %ebp
  802f0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802f0d:	6a 00                	push   $0x0
  802f0f:	6a 00                	push   $0x0
  802f11:	6a 00                	push   $0x0
  802f13:	6a 00                	push   $0x0
  802f15:	6a 00                	push   $0x0
  802f17:	6a 03                	push   $0x3
  802f19:	e8 7d ff ff ff       	call   802e9b <syscall>
  802f1e:	83 c4 18             	add    $0x18,%esp
}
  802f21:	90                   	nop
  802f22:	c9                   	leave  
  802f23:	c3                   	ret    

00802f24 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802f24:	55                   	push   %ebp
  802f25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802f27:	6a 00                	push   $0x0
  802f29:	6a 00                	push   $0x0
  802f2b:	6a 00                	push   $0x0
  802f2d:	6a 00                	push   $0x0
  802f2f:	6a 00                	push   $0x0
  802f31:	6a 04                	push   $0x4
  802f33:	e8 63 ff ff ff       	call   802e9b <syscall>
  802f38:	83 c4 18             	add    $0x18,%esp
}
  802f3b:	90                   	nop
  802f3c:	c9                   	leave  
  802f3d:	c3                   	ret    

00802f3e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802f3e:	55                   	push   %ebp
  802f3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802f41:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f44:	8b 45 08             	mov    0x8(%ebp),%eax
  802f47:	6a 00                	push   $0x0
  802f49:	6a 00                	push   $0x0
  802f4b:	6a 00                	push   $0x0
  802f4d:	52                   	push   %edx
  802f4e:	50                   	push   %eax
  802f4f:	6a 08                	push   $0x8
  802f51:	e8 45 ff ff ff       	call   802e9b <syscall>
  802f56:	83 c4 18             	add    $0x18,%esp
}
  802f59:	c9                   	leave  
  802f5a:	c3                   	ret    

00802f5b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802f5b:	55                   	push   %ebp
  802f5c:	89 e5                	mov    %esp,%ebp
  802f5e:	56                   	push   %esi
  802f5f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802f60:	8b 75 18             	mov    0x18(%ebp),%esi
  802f63:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802f66:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802f69:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6f:	56                   	push   %esi
  802f70:	53                   	push   %ebx
  802f71:	51                   	push   %ecx
  802f72:	52                   	push   %edx
  802f73:	50                   	push   %eax
  802f74:	6a 09                	push   $0x9
  802f76:	e8 20 ff ff ff       	call   802e9b <syscall>
  802f7b:	83 c4 18             	add    $0x18,%esp
}
  802f7e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802f81:	5b                   	pop    %ebx
  802f82:	5e                   	pop    %esi
  802f83:	5d                   	pop    %ebp
  802f84:	c3                   	ret    

00802f85 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802f85:	55                   	push   %ebp
  802f86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802f88:	6a 00                	push   $0x0
  802f8a:	6a 00                	push   $0x0
  802f8c:	6a 00                	push   $0x0
  802f8e:	6a 00                	push   $0x0
  802f90:	ff 75 08             	pushl  0x8(%ebp)
  802f93:	6a 0a                	push   $0xa
  802f95:	e8 01 ff ff ff       	call   802e9b <syscall>
  802f9a:	83 c4 18             	add    $0x18,%esp
}
  802f9d:	c9                   	leave  
  802f9e:	c3                   	ret    

00802f9f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802f9f:	55                   	push   %ebp
  802fa0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802fa2:	6a 00                	push   $0x0
  802fa4:	6a 00                	push   $0x0
  802fa6:	6a 00                	push   $0x0
  802fa8:	ff 75 0c             	pushl  0xc(%ebp)
  802fab:	ff 75 08             	pushl  0x8(%ebp)
  802fae:	6a 0b                	push   $0xb
  802fb0:	e8 e6 fe ff ff       	call   802e9b <syscall>
  802fb5:	83 c4 18             	add    $0x18,%esp
}
  802fb8:	c9                   	leave  
  802fb9:	c3                   	ret    

00802fba <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802fba:	55                   	push   %ebp
  802fbb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802fbd:	6a 00                	push   $0x0
  802fbf:	6a 00                	push   $0x0
  802fc1:	6a 00                	push   $0x0
  802fc3:	6a 00                	push   $0x0
  802fc5:	6a 00                	push   $0x0
  802fc7:	6a 0c                	push   $0xc
  802fc9:	e8 cd fe ff ff       	call   802e9b <syscall>
  802fce:	83 c4 18             	add    $0x18,%esp
}
  802fd1:	c9                   	leave  
  802fd2:	c3                   	ret    

00802fd3 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802fd3:	55                   	push   %ebp
  802fd4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802fd6:	6a 00                	push   $0x0
  802fd8:	6a 00                	push   $0x0
  802fda:	6a 00                	push   $0x0
  802fdc:	6a 00                	push   $0x0
  802fde:	6a 00                	push   $0x0
  802fe0:	6a 0d                	push   $0xd
  802fe2:	e8 b4 fe ff ff       	call   802e9b <syscall>
  802fe7:	83 c4 18             	add    $0x18,%esp
}
  802fea:	c9                   	leave  
  802feb:	c3                   	ret    

00802fec <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802fec:	55                   	push   %ebp
  802fed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802fef:	6a 00                	push   $0x0
  802ff1:	6a 00                	push   $0x0
  802ff3:	6a 00                	push   $0x0
  802ff5:	6a 00                	push   $0x0
  802ff7:	6a 00                	push   $0x0
  802ff9:	6a 0e                	push   $0xe
  802ffb:	e8 9b fe ff ff       	call   802e9b <syscall>
  803000:	83 c4 18             	add    $0x18,%esp
}
  803003:	c9                   	leave  
  803004:	c3                   	ret    

00803005 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  803005:	55                   	push   %ebp
  803006:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  803008:	6a 00                	push   $0x0
  80300a:	6a 00                	push   $0x0
  80300c:	6a 00                	push   $0x0
  80300e:	6a 00                	push   $0x0
  803010:	6a 00                	push   $0x0
  803012:	6a 0f                	push   $0xf
  803014:	e8 82 fe ff ff       	call   802e9b <syscall>
  803019:	83 c4 18             	add    $0x18,%esp
}
  80301c:	c9                   	leave  
  80301d:	c3                   	ret    

0080301e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80301e:	55                   	push   %ebp
  80301f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  803021:	6a 00                	push   $0x0
  803023:	6a 00                	push   $0x0
  803025:	6a 00                	push   $0x0
  803027:	6a 00                	push   $0x0
  803029:	ff 75 08             	pushl  0x8(%ebp)
  80302c:	6a 10                	push   $0x10
  80302e:	e8 68 fe ff ff       	call   802e9b <syscall>
  803033:	83 c4 18             	add    $0x18,%esp
}
  803036:	c9                   	leave  
  803037:	c3                   	ret    

00803038 <sys_scarce_memory>:

void sys_scarce_memory()
{
  803038:	55                   	push   %ebp
  803039:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80303b:	6a 00                	push   $0x0
  80303d:	6a 00                	push   $0x0
  80303f:	6a 00                	push   $0x0
  803041:	6a 00                	push   $0x0
  803043:	6a 00                	push   $0x0
  803045:	6a 11                	push   $0x11
  803047:	e8 4f fe ff ff       	call   802e9b <syscall>
  80304c:	83 c4 18             	add    $0x18,%esp
}
  80304f:	90                   	nop
  803050:	c9                   	leave  
  803051:	c3                   	ret    

00803052 <sys_cputc>:

void
sys_cputc(const char c)
{
  803052:	55                   	push   %ebp
  803053:	89 e5                	mov    %esp,%ebp
  803055:	83 ec 04             	sub    $0x4,%esp
  803058:	8b 45 08             	mov    0x8(%ebp),%eax
  80305b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80305e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803062:	6a 00                	push   $0x0
  803064:	6a 00                	push   $0x0
  803066:	6a 00                	push   $0x0
  803068:	6a 00                	push   $0x0
  80306a:	50                   	push   %eax
  80306b:	6a 01                	push   $0x1
  80306d:	e8 29 fe ff ff       	call   802e9b <syscall>
  803072:	83 c4 18             	add    $0x18,%esp
}
  803075:	90                   	nop
  803076:	c9                   	leave  
  803077:	c3                   	ret    

00803078 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  803078:	55                   	push   %ebp
  803079:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80307b:	6a 00                	push   $0x0
  80307d:	6a 00                	push   $0x0
  80307f:	6a 00                	push   $0x0
  803081:	6a 00                	push   $0x0
  803083:	6a 00                	push   $0x0
  803085:	6a 14                	push   $0x14
  803087:	e8 0f fe ff ff       	call   802e9b <syscall>
  80308c:	83 c4 18             	add    $0x18,%esp
}
  80308f:	90                   	nop
  803090:	c9                   	leave  
  803091:	c3                   	ret    

00803092 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  803092:	55                   	push   %ebp
  803093:	89 e5                	mov    %esp,%ebp
  803095:	83 ec 04             	sub    $0x4,%esp
  803098:	8b 45 10             	mov    0x10(%ebp),%eax
  80309b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80309e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8030a1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8030a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a8:	6a 00                	push   $0x0
  8030aa:	51                   	push   %ecx
  8030ab:	52                   	push   %edx
  8030ac:	ff 75 0c             	pushl  0xc(%ebp)
  8030af:	50                   	push   %eax
  8030b0:	6a 15                	push   $0x15
  8030b2:	e8 e4 fd ff ff       	call   802e9b <syscall>
  8030b7:	83 c4 18             	add    $0x18,%esp
}
  8030ba:	c9                   	leave  
  8030bb:	c3                   	ret    

008030bc <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8030bc:	55                   	push   %ebp
  8030bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8030bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c5:	6a 00                	push   $0x0
  8030c7:	6a 00                	push   $0x0
  8030c9:	6a 00                	push   $0x0
  8030cb:	52                   	push   %edx
  8030cc:	50                   	push   %eax
  8030cd:	6a 16                	push   $0x16
  8030cf:	e8 c7 fd ff ff       	call   802e9b <syscall>
  8030d4:	83 c4 18             	add    $0x18,%esp
}
  8030d7:	c9                   	leave  
  8030d8:	c3                   	ret    

008030d9 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8030d9:	55                   	push   %ebp
  8030da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8030dc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8030df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e5:	6a 00                	push   $0x0
  8030e7:	6a 00                	push   $0x0
  8030e9:	51                   	push   %ecx
  8030ea:	52                   	push   %edx
  8030eb:	50                   	push   %eax
  8030ec:	6a 17                	push   $0x17
  8030ee:	e8 a8 fd ff ff       	call   802e9b <syscall>
  8030f3:	83 c4 18             	add    $0x18,%esp
}
  8030f6:	c9                   	leave  
  8030f7:	c3                   	ret    

008030f8 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8030f8:	55                   	push   %ebp
  8030f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8030fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803101:	6a 00                	push   $0x0
  803103:	6a 00                	push   $0x0
  803105:	6a 00                	push   $0x0
  803107:	52                   	push   %edx
  803108:	50                   	push   %eax
  803109:	6a 18                	push   $0x18
  80310b:	e8 8b fd ff ff       	call   802e9b <syscall>
  803110:	83 c4 18             	add    $0x18,%esp
}
  803113:	c9                   	leave  
  803114:	c3                   	ret    

00803115 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  803115:	55                   	push   %ebp
  803116:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  803118:	8b 45 08             	mov    0x8(%ebp),%eax
  80311b:	6a 00                	push   $0x0
  80311d:	ff 75 14             	pushl  0x14(%ebp)
  803120:	ff 75 10             	pushl  0x10(%ebp)
  803123:	ff 75 0c             	pushl  0xc(%ebp)
  803126:	50                   	push   %eax
  803127:	6a 19                	push   $0x19
  803129:	e8 6d fd ff ff       	call   802e9b <syscall>
  80312e:	83 c4 18             	add    $0x18,%esp
}
  803131:	c9                   	leave  
  803132:	c3                   	ret    

00803133 <sys_run_env>:

void sys_run_env(int32 envId)
{
  803133:	55                   	push   %ebp
  803134:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  803136:	8b 45 08             	mov    0x8(%ebp),%eax
  803139:	6a 00                	push   $0x0
  80313b:	6a 00                	push   $0x0
  80313d:	6a 00                	push   $0x0
  80313f:	6a 00                	push   $0x0
  803141:	50                   	push   %eax
  803142:	6a 1a                	push   $0x1a
  803144:	e8 52 fd ff ff       	call   802e9b <syscall>
  803149:	83 c4 18             	add    $0x18,%esp
}
  80314c:	90                   	nop
  80314d:	c9                   	leave  
  80314e:	c3                   	ret    

0080314f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80314f:	55                   	push   %ebp
  803150:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  803152:	8b 45 08             	mov    0x8(%ebp),%eax
  803155:	6a 00                	push   $0x0
  803157:	6a 00                	push   $0x0
  803159:	6a 00                	push   $0x0
  80315b:	6a 00                	push   $0x0
  80315d:	50                   	push   %eax
  80315e:	6a 1b                	push   $0x1b
  803160:	e8 36 fd ff ff       	call   802e9b <syscall>
  803165:	83 c4 18             	add    $0x18,%esp
}
  803168:	c9                   	leave  
  803169:	c3                   	ret    

0080316a <sys_getenvid>:

int32 sys_getenvid(void)
{
  80316a:	55                   	push   %ebp
  80316b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80316d:	6a 00                	push   $0x0
  80316f:	6a 00                	push   $0x0
  803171:	6a 00                	push   $0x0
  803173:	6a 00                	push   $0x0
  803175:	6a 00                	push   $0x0
  803177:	6a 05                	push   $0x5
  803179:	e8 1d fd ff ff       	call   802e9b <syscall>
  80317e:	83 c4 18             	add    $0x18,%esp
}
  803181:	c9                   	leave  
  803182:	c3                   	ret    

00803183 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  803183:	55                   	push   %ebp
  803184:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  803186:	6a 00                	push   $0x0
  803188:	6a 00                	push   $0x0
  80318a:	6a 00                	push   $0x0
  80318c:	6a 00                	push   $0x0
  80318e:	6a 00                	push   $0x0
  803190:	6a 06                	push   $0x6
  803192:	e8 04 fd ff ff       	call   802e9b <syscall>
  803197:	83 c4 18             	add    $0x18,%esp
}
  80319a:	c9                   	leave  
  80319b:	c3                   	ret    

0080319c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80319c:	55                   	push   %ebp
  80319d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80319f:	6a 00                	push   $0x0
  8031a1:	6a 00                	push   $0x0
  8031a3:	6a 00                	push   $0x0
  8031a5:	6a 00                	push   $0x0
  8031a7:	6a 00                	push   $0x0
  8031a9:	6a 07                	push   $0x7
  8031ab:	e8 eb fc ff ff       	call   802e9b <syscall>
  8031b0:	83 c4 18             	add    $0x18,%esp
}
  8031b3:	c9                   	leave  
  8031b4:	c3                   	ret    

008031b5 <sys_exit_env>:


void sys_exit_env(void)
{
  8031b5:	55                   	push   %ebp
  8031b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8031b8:	6a 00                	push   $0x0
  8031ba:	6a 00                	push   $0x0
  8031bc:	6a 00                	push   $0x0
  8031be:	6a 00                	push   $0x0
  8031c0:	6a 00                	push   $0x0
  8031c2:	6a 1c                	push   $0x1c
  8031c4:	e8 d2 fc ff ff       	call   802e9b <syscall>
  8031c9:	83 c4 18             	add    $0x18,%esp
}
  8031cc:	90                   	nop
  8031cd:	c9                   	leave  
  8031ce:	c3                   	ret    

008031cf <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8031cf:	55                   	push   %ebp
  8031d0:	89 e5                	mov    %esp,%ebp
  8031d2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8031d5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8031d8:	8d 50 04             	lea    0x4(%eax),%edx
  8031db:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8031de:	6a 00                	push   $0x0
  8031e0:	6a 00                	push   $0x0
  8031e2:	6a 00                	push   $0x0
  8031e4:	52                   	push   %edx
  8031e5:	50                   	push   %eax
  8031e6:	6a 1d                	push   $0x1d
  8031e8:	e8 ae fc ff ff       	call   802e9b <syscall>
  8031ed:	83 c4 18             	add    $0x18,%esp
	return result;
  8031f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8031f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8031f6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8031f9:	89 01                	mov    %eax,(%ecx)
  8031fb:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8031fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803201:	c9                   	leave  
  803202:	c2 04 00             	ret    $0x4

00803205 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  803205:	55                   	push   %ebp
  803206:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  803208:	6a 00                	push   $0x0
  80320a:	6a 00                	push   $0x0
  80320c:	ff 75 10             	pushl  0x10(%ebp)
  80320f:	ff 75 0c             	pushl  0xc(%ebp)
  803212:	ff 75 08             	pushl  0x8(%ebp)
  803215:	6a 13                	push   $0x13
  803217:	e8 7f fc ff ff       	call   802e9b <syscall>
  80321c:	83 c4 18             	add    $0x18,%esp
	return ;
  80321f:	90                   	nop
}
  803220:	c9                   	leave  
  803221:	c3                   	ret    

00803222 <sys_rcr2>:
uint32 sys_rcr2()
{
  803222:	55                   	push   %ebp
  803223:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  803225:	6a 00                	push   $0x0
  803227:	6a 00                	push   $0x0
  803229:	6a 00                	push   $0x0
  80322b:	6a 00                	push   $0x0
  80322d:	6a 00                	push   $0x0
  80322f:	6a 1e                	push   $0x1e
  803231:	e8 65 fc ff ff       	call   802e9b <syscall>
  803236:	83 c4 18             	add    $0x18,%esp
}
  803239:	c9                   	leave  
  80323a:	c3                   	ret    

0080323b <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80323b:	55                   	push   %ebp
  80323c:	89 e5                	mov    %esp,%ebp
  80323e:	83 ec 04             	sub    $0x4,%esp
  803241:	8b 45 08             	mov    0x8(%ebp),%eax
  803244:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803247:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80324b:	6a 00                	push   $0x0
  80324d:	6a 00                	push   $0x0
  80324f:	6a 00                	push   $0x0
  803251:	6a 00                	push   $0x0
  803253:	50                   	push   %eax
  803254:	6a 1f                	push   $0x1f
  803256:	e8 40 fc ff ff       	call   802e9b <syscall>
  80325b:	83 c4 18             	add    $0x18,%esp
	return ;
  80325e:	90                   	nop
}
  80325f:	c9                   	leave  
  803260:	c3                   	ret    

00803261 <rsttst>:
void rsttst()
{
  803261:	55                   	push   %ebp
  803262:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803264:	6a 00                	push   $0x0
  803266:	6a 00                	push   $0x0
  803268:	6a 00                	push   $0x0
  80326a:	6a 00                	push   $0x0
  80326c:	6a 00                	push   $0x0
  80326e:	6a 21                	push   $0x21
  803270:	e8 26 fc ff ff       	call   802e9b <syscall>
  803275:	83 c4 18             	add    $0x18,%esp
	return ;
  803278:	90                   	nop
}
  803279:	c9                   	leave  
  80327a:	c3                   	ret    

0080327b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80327b:	55                   	push   %ebp
  80327c:	89 e5                	mov    %esp,%ebp
  80327e:	83 ec 04             	sub    $0x4,%esp
  803281:	8b 45 14             	mov    0x14(%ebp),%eax
  803284:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803287:	8b 55 18             	mov    0x18(%ebp),%edx
  80328a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80328e:	52                   	push   %edx
  80328f:	50                   	push   %eax
  803290:	ff 75 10             	pushl  0x10(%ebp)
  803293:	ff 75 0c             	pushl  0xc(%ebp)
  803296:	ff 75 08             	pushl  0x8(%ebp)
  803299:	6a 20                	push   $0x20
  80329b:	e8 fb fb ff ff       	call   802e9b <syscall>
  8032a0:	83 c4 18             	add    $0x18,%esp
	return ;
  8032a3:	90                   	nop
}
  8032a4:	c9                   	leave  
  8032a5:	c3                   	ret    

008032a6 <chktst>:
void chktst(uint32 n)
{
  8032a6:	55                   	push   %ebp
  8032a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8032a9:	6a 00                	push   $0x0
  8032ab:	6a 00                	push   $0x0
  8032ad:	6a 00                	push   $0x0
  8032af:	6a 00                	push   $0x0
  8032b1:	ff 75 08             	pushl  0x8(%ebp)
  8032b4:	6a 22                	push   $0x22
  8032b6:	e8 e0 fb ff ff       	call   802e9b <syscall>
  8032bb:	83 c4 18             	add    $0x18,%esp
	return ;
  8032be:	90                   	nop
}
  8032bf:	c9                   	leave  
  8032c0:	c3                   	ret    

008032c1 <inctst>:

void inctst()
{
  8032c1:	55                   	push   %ebp
  8032c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8032c4:	6a 00                	push   $0x0
  8032c6:	6a 00                	push   $0x0
  8032c8:	6a 00                	push   $0x0
  8032ca:	6a 00                	push   $0x0
  8032cc:	6a 00                	push   $0x0
  8032ce:	6a 23                	push   $0x23
  8032d0:	e8 c6 fb ff ff       	call   802e9b <syscall>
  8032d5:	83 c4 18             	add    $0x18,%esp
	return ;
  8032d8:	90                   	nop
}
  8032d9:	c9                   	leave  
  8032da:	c3                   	ret    

008032db <gettst>:
uint32 gettst()
{
  8032db:	55                   	push   %ebp
  8032dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8032de:	6a 00                	push   $0x0
  8032e0:	6a 00                	push   $0x0
  8032e2:	6a 00                	push   $0x0
  8032e4:	6a 00                	push   $0x0
  8032e6:	6a 00                	push   $0x0
  8032e8:	6a 24                	push   $0x24
  8032ea:	e8 ac fb ff ff       	call   802e9b <syscall>
  8032ef:	83 c4 18             	add    $0x18,%esp
}
  8032f2:	c9                   	leave  
  8032f3:	c3                   	ret    

008032f4 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8032f4:	55                   	push   %ebp
  8032f5:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8032f7:	6a 00                	push   $0x0
  8032f9:	6a 00                	push   $0x0
  8032fb:	6a 00                	push   $0x0
  8032fd:	6a 00                	push   $0x0
  8032ff:	6a 00                	push   $0x0
  803301:	6a 25                	push   $0x25
  803303:	e8 93 fb ff ff       	call   802e9b <syscall>
  803308:	83 c4 18             	add    $0x18,%esp
  80330b:	a3 80 50 83 00       	mov    %eax,0x835080
	return uheapPlaceStrategy ;
  803310:	a1 80 50 83 00       	mov    0x835080,%eax
}
  803315:	c9                   	leave  
  803316:	c3                   	ret    

00803317 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803317:	55                   	push   %ebp
  803318:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80331a:	8b 45 08             	mov    0x8(%ebp),%eax
  80331d:	a3 80 50 83 00       	mov    %eax,0x835080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803322:	6a 00                	push   $0x0
  803324:	6a 00                	push   $0x0
  803326:	6a 00                	push   $0x0
  803328:	6a 00                	push   $0x0
  80332a:	ff 75 08             	pushl  0x8(%ebp)
  80332d:	6a 26                	push   $0x26
  80332f:	e8 67 fb ff ff       	call   802e9b <syscall>
  803334:	83 c4 18             	add    $0x18,%esp
	return ;
  803337:	90                   	nop
}
  803338:	c9                   	leave  
  803339:	c3                   	ret    

0080333a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80333a:	55                   	push   %ebp
  80333b:	89 e5                	mov    %esp,%ebp
  80333d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80333e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803341:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803344:	8b 55 0c             	mov    0xc(%ebp),%edx
  803347:	8b 45 08             	mov    0x8(%ebp),%eax
  80334a:	6a 00                	push   $0x0
  80334c:	53                   	push   %ebx
  80334d:	51                   	push   %ecx
  80334e:	52                   	push   %edx
  80334f:	50                   	push   %eax
  803350:	6a 27                	push   $0x27
  803352:	e8 44 fb ff ff       	call   802e9b <syscall>
  803357:	83 c4 18             	add    $0x18,%esp
}
  80335a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80335d:	c9                   	leave  
  80335e:	c3                   	ret    

0080335f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80335f:	55                   	push   %ebp
  803360:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803362:	8b 55 0c             	mov    0xc(%ebp),%edx
  803365:	8b 45 08             	mov    0x8(%ebp),%eax
  803368:	6a 00                	push   $0x0
  80336a:	6a 00                	push   $0x0
  80336c:	6a 00                	push   $0x0
  80336e:	52                   	push   %edx
  80336f:	50                   	push   %eax
  803370:	6a 28                	push   $0x28
  803372:	e8 24 fb ff ff       	call   802e9b <syscall>
  803377:	83 c4 18             	add    $0x18,%esp
}
  80337a:	c9                   	leave  
  80337b:	c3                   	ret    

0080337c <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80337c:	55                   	push   %ebp
  80337d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80337f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803382:	8b 55 0c             	mov    0xc(%ebp),%edx
  803385:	8b 45 08             	mov    0x8(%ebp),%eax
  803388:	6a 00                	push   $0x0
  80338a:	51                   	push   %ecx
  80338b:	ff 75 10             	pushl  0x10(%ebp)
  80338e:	52                   	push   %edx
  80338f:	50                   	push   %eax
  803390:	6a 29                	push   $0x29
  803392:	e8 04 fb ff ff       	call   802e9b <syscall>
  803397:	83 c4 18             	add    $0x18,%esp
}
  80339a:	c9                   	leave  
  80339b:	c3                   	ret    

0080339c <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80339c:	55                   	push   %ebp
  80339d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80339f:	6a 00                	push   $0x0
  8033a1:	6a 00                	push   $0x0
  8033a3:	ff 75 10             	pushl  0x10(%ebp)
  8033a6:	ff 75 0c             	pushl  0xc(%ebp)
  8033a9:	ff 75 08             	pushl  0x8(%ebp)
  8033ac:	6a 12                	push   $0x12
  8033ae:	e8 e8 fa ff ff       	call   802e9b <syscall>
  8033b3:	83 c4 18             	add    $0x18,%esp
	return ;
  8033b6:	90                   	nop
}
  8033b7:	c9                   	leave  
  8033b8:	c3                   	ret    

008033b9 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8033b9:	55                   	push   %ebp
  8033ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8033bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c2:	6a 00                	push   $0x0
  8033c4:	6a 00                	push   $0x0
  8033c6:	6a 00                	push   $0x0
  8033c8:	52                   	push   %edx
  8033c9:	50                   	push   %eax
  8033ca:	6a 2a                	push   $0x2a
  8033cc:	e8 ca fa ff ff       	call   802e9b <syscall>
  8033d1:	83 c4 18             	add    $0x18,%esp
	return;
  8033d4:	90                   	nop
}
  8033d5:	c9                   	leave  
  8033d6:	c3                   	ret    

008033d7 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8033d7:	55                   	push   %ebp
  8033d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8033da:	6a 00                	push   $0x0
  8033dc:	6a 00                	push   $0x0
  8033de:	6a 00                	push   $0x0
  8033e0:	6a 00                	push   $0x0
  8033e2:	6a 00                	push   $0x0
  8033e4:	6a 2b                	push   $0x2b
  8033e6:	e8 b0 fa ff ff       	call   802e9b <syscall>
  8033eb:	83 c4 18             	add    $0x18,%esp
}
  8033ee:	c9                   	leave  
  8033ef:	c3                   	ret    

008033f0 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8033f0:	55                   	push   %ebp
  8033f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8033f3:	6a 00                	push   $0x0
  8033f5:	6a 00                	push   $0x0
  8033f7:	6a 00                	push   $0x0
  8033f9:	ff 75 0c             	pushl  0xc(%ebp)
  8033fc:	ff 75 08             	pushl  0x8(%ebp)
  8033ff:	6a 2d                	push   $0x2d
  803401:	e8 95 fa ff ff       	call   802e9b <syscall>
  803406:	83 c4 18             	add    $0x18,%esp
	return;
  803409:	90                   	nop
}
  80340a:	c9                   	leave  
  80340b:	c3                   	ret    

0080340c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80340c:	55                   	push   %ebp
  80340d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80340f:	6a 00                	push   $0x0
  803411:	6a 00                	push   $0x0
  803413:	6a 00                	push   $0x0
  803415:	ff 75 0c             	pushl  0xc(%ebp)
  803418:	ff 75 08             	pushl  0x8(%ebp)
  80341b:	6a 2c                	push   $0x2c
  80341d:	e8 79 fa ff ff       	call   802e9b <syscall>
  803422:	83 c4 18             	add    $0x18,%esp
	return ;
  803425:	90                   	nop
}
  803426:	c9                   	leave  
  803427:	c3                   	ret    

00803428 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  803428:	55                   	push   %ebp
  803429:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80342b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80342e:	8b 45 08             	mov    0x8(%ebp),%eax
  803431:	6a 00                	push   $0x0
  803433:	6a 00                	push   $0x0
  803435:	6a 00                	push   $0x0
  803437:	52                   	push   %edx
  803438:	50                   	push   %eax
  803439:	6a 2e                	push   $0x2e
  80343b:	e8 5b fa ff ff       	call   802e9b <syscall>
  803440:	83 c4 18             	add    $0x18,%esp
}
  803443:	90                   	nop
  803444:	c9                   	leave  
  803445:	c3                   	ret    

00803446 <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  803446:	55                   	push   %ebp
  803447:	89 e5                	mov    %esp,%ebp
  803449:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  80344c:	81 7d 08 80 d0 81 00 	cmpl   $0x81d080,0x8(%ebp)
  803453:	72 09                	jb     80345e <to_page_va+0x18>
  803455:	81 7d 08 80 50 83 00 	cmpl   $0x835080,0x8(%ebp)
  80345c:	72 14                	jb     803472 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  80345e:	83 ec 04             	sub    $0x4,%esp
  803461:	68 f8 4a 80 00       	push   $0x804af8
  803466:	6a 15                	push   $0x15
  803468:	68 23 4b 80 00       	push   $0x804b23
  80346d:	e8 10 d0 ff ff       	call   800482 <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803472:	8b 45 08             	mov    0x8(%ebp),%eax
  803475:	ba 80 d0 81 00       	mov    $0x81d080,%edx
  80347a:	29 d0                	sub    %edx,%eax
  80347c:	c1 f8 02             	sar    $0x2,%eax
  80347f:	89 c2                	mov    %eax,%edx
  803481:	89 d0                	mov    %edx,%eax
  803483:	c1 e0 02             	shl    $0x2,%eax
  803486:	01 d0                	add    %edx,%eax
  803488:	c1 e0 02             	shl    $0x2,%eax
  80348b:	01 d0                	add    %edx,%eax
  80348d:	c1 e0 02             	shl    $0x2,%eax
  803490:	01 d0                	add    %edx,%eax
  803492:	89 c1                	mov    %eax,%ecx
  803494:	c1 e1 08             	shl    $0x8,%ecx
  803497:	01 c8                	add    %ecx,%eax
  803499:	89 c1                	mov    %eax,%ecx
  80349b:	c1 e1 10             	shl    $0x10,%ecx
  80349e:	01 c8                	add    %ecx,%eax
  8034a0:	01 c0                	add    %eax,%eax
  8034a2:	01 d0                	add    %edx,%eax
  8034a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8034a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034aa:	c1 e0 0c             	shl    $0xc,%eax
  8034ad:	89 c2                	mov    %eax,%edx
  8034af:	a1 84 50 83 00       	mov    0x835084,%eax
  8034b4:	01 d0                	add    %edx,%eax
}
  8034b6:	c9                   	leave  
  8034b7:	c3                   	ret    

008034b8 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  8034b8:	55                   	push   %ebp
  8034b9:	89 e5                	mov    %esp,%ebp
  8034bb:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  8034be:	a1 84 50 83 00       	mov    0x835084,%eax
  8034c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8034c6:	29 c2                	sub    %eax,%edx
  8034c8:	89 d0                	mov    %edx,%eax
  8034ca:	c1 e8 0c             	shr    $0xc,%eax
  8034cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  8034d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034d4:	78 09                	js     8034df <to_page_info+0x27>
  8034d6:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  8034dd:	7e 14                	jle    8034f3 <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  8034df:	83 ec 04             	sub    $0x4,%esp
  8034e2:	68 3c 4b 80 00       	push   $0x804b3c
  8034e7:	6a 21                	push   $0x21
  8034e9:	68 23 4b 80 00       	push   $0x804b23
  8034ee:	e8 8f cf ff ff       	call   800482 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  8034f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034f6:	89 d0                	mov    %edx,%eax
  8034f8:	01 c0                	add    %eax,%eax
  8034fa:	01 d0                	add    %edx,%eax
  8034fc:	c1 e0 02             	shl    $0x2,%eax
  8034ff:	05 80 d0 81 00       	add    $0x81d080,%eax
}
  803504:	c9                   	leave  
  803505:	c3                   	ret    

00803506 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803506:	55                   	push   %ebp
  803507:	89 e5                	mov    %esp,%ebp
  803509:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  80350c:	8b 45 08             	mov    0x8(%ebp),%eax
  80350f:	05 00 00 00 02       	add    $0x2000000,%eax
  803514:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803517:	73 16                	jae    80352f <initialize_dynamic_allocator+0x29>
  803519:	68 60 4b 80 00       	push   $0x804b60
  80351e:	68 86 4b 80 00       	push   $0x804b86
  803523:	6a 2f                	push   $0x2f
  803525:	68 23 4b 80 00       	push   $0x804b23
  80352a:	e8 53 cf ff ff       	call   800482 <_panic>
	dynAllocStart = daStart;
  80352f:	8b 45 08             	mov    0x8(%ebp),%eax
  803532:	a3 84 50 83 00       	mov    %eax,0x835084
	dynAllocEnd = daEnd;
  803537:	8b 45 0c             	mov    0xc(%ebp),%eax
  80353a:	a3 60 d0 81 00       	mov    %eax,0x81d060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  80353f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803546:	eb 36                	jmp    80357e <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  803548:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354b:	c1 e0 04             	shl    $0x4,%eax
  80354e:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803553:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355c:	c1 e0 04             	shl    $0x4,%eax
  80355f:	05 a4 50 83 00       	add    $0x8350a4,%eax
  803564:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80356a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356d:	c1 e0 04             	shl    $0x4,%eax
  803570:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803575:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  80357b:	ff 45 f4             	incl   -0xc(%ebp)
  80357e:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  803582:	7e c4                	jle    803548 <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  803584:	c7 05 68 d0 81 00 00 	movl   $0x0,0x81d068
  80358b:	00 00 00 
  80358e:	c7 05 6c d0 81 00 00 	movl   $0x0,0x81d06c
  803595:	00 00 00 
  803598:	c7 05 74 d0 81 00 00 	movl   $0x0,0x81d074
  80359f:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  8035a2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8035a9:	e9 1b 01 00 00       	jmp    8036c9 <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  8035ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035b1:	89 d0                	mov    %edx,%eax
  8035b3:	01 c0                	add    %eax,%eax
  8035b5:	01 d0                	add    %edx,%eax
  8035b7:	c1 e0 02             	shl    $0x2,%eax
  8035ba:	05 88 d0 81 00       	add    $0x81d088,%eax
  8035bf:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  8035c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035c7:	89 d0                	mov    %edx,%eax
  8035c9:	01 c0                	add    %eax,%eax
  8035cb:	01 d0                	add    %edx,%eax
  8035cd:	c1 e0 02             	shl    $0x2,%eax
  8035d0:	05 8a d0 81 00       	add    $0x81d08a,%eax
  8035d5:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  8035da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035dd:	89 d0                	mov    %edx,%eax
  8035df:	01 c0                	add    %eax,%eax
  8035e1:	01 d0                	add    %edx,%eax
  8035e3:	c1 e0 02             	shl    $0x2,%eax
  8035e6:	05 80 d0 81 00       	add    $0x81d080,%eax
  8035eb:	8b 00                	mov    (%eax),%eax
  8035ed:	85 c0                	test   %eax,%eax
  8035ef:	74 2b                	je     80361c <initialize_dynamic_allocator+0x116>
  8035f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035f4:	89 d0                	mov    %edx,%eax
  8035f6:	01 c0                	add    %eax,%eax
  8035f8:	01 d0                	add    %edx,%eax
  8035fa:	c1 e0 02             	shl    $0x2,%eax
  8035fd:	05 80 d0 81 00       	add    $0x81d080,%eax
  803602:	8b 10                	mov    (%eax),%edx
  803604:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803607:	89 c8                	mov    %ecx,%eax
  803609:	01 c0                	add    %eax,%eax
  80360b:	01 c8                	add    %ecx,%eax
  80360d:	c1 e0 02             	shl    $0x2,%eax
  803610:	05 84 d0 81 00       	add    $0x81d084,%eax
  803615:	8b 00                	mov    (%eax),%eax
  803617:	89 42 04             	mov    %eax,0x4(%edx)
  80361a:	eb 18                	jmp    803634 <initialize_dynamic_allocator+0x12e>
  80361c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80361f:	89 d0                	mov    %edx,%eax
  803621:	01 c0                	add    %eax,%eax
  803623:	01 d0                	add    %edx,%eax
  803625:	c1 e0 02             	shl    $0x2,%eax
  803628:	05 84 d0 81 00       	add    $0x81d084,%eax
  80362d:	8b 00                	mov    (%eax),%eax
  80362f:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803634:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803637:	89 d0                	mov    %edx,%eax
  803639:	01 c0                	add    %eax,%eax
  80363b:	01 d0                	add    %edx,%eax
  80363d:	c1 e0 02             	shl    $0x2,%eax
  803640:	05 84 d0 81 00       	add    $0x81d084,%eax
  803645:	8b 00                	mov    (%eax),%eax
  803647:	85 c0                	test   %eax,%eax
  803649:	74 2a                	je     803675 <initialize_dynamic_allocator+0x16f>
  80364b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80364e:	89 d0                	mov    %edx,%eax
  803650:	01 c0                	add    %eax,%eax
  803652:	01 d0                	add    %edx,%eax
  803654:	c1 e0 02             	shl    $0x2,%eax
  803657:	05 84 d0 81 00       	add    $0x81d084,%eax
  80365c:	8b 10                	mov    (%eax),%edx
  80365e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803661:	89 c8                	mov    %ecx,%eax
  803663:	01 c0                	add    %eax,%eax
  803665:	01 c8                	add    %ecx,%eax
  803667:	c1 e0 02             	shl    $0x2,%eax
  80366a:	05 80 d0 81 00       	add    $0x81d080,%eax
  80366f:	8b 00                	mov    (%eax),%eax
  803671:	89 02                	mov    %eax,(%edx)
  803673:	eb 18                	jmp    80368d <initialize_dynamic_allocator+0x187>
  803675:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803678:	89 d0                	mov    %edx,%eax
  80367a:	01 c0                	add    %eax,%eax
  80367c:	01 d0                	add    %edx,%eax
  80367e:	c1 e0 02             	shl    $0x2,%eax
  803681:	05 80 d0 81 00       	add    $0x81d080,%eax
  803686:	8b 00                	mov    (%eax),%eax
  803688:	a3 68 d0 81 00       	mov    %eax,0x81d068
  80368d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803690:	89 d0                	mov    %edx,%eax
  803692:	01 c0                	add    %eax,%eax
  803694:	01 d0                	add    %edx,%eax
  803696:	c1 e0 02             	shl    $0x2,%eax
  803699:	05 80 d0 81 00       	add    $0x81d080,%eax
  80369e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036a7:	89 d0                	mov    %edx,%eax
  8036a9:	01 c0                	add    %eax,%eax
  8036ab:	01 d0                	add    %edx,%eax
  8036ad:	c1 e0 02             	shl    $0x2,%eax
  8036b0:	05 84 d0 81 00       	add    $0x81d084,%eax
  8036b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036bb:	a1 74 d0 81 00       	mov    0x81d074,%eax
  8036c0:	48                   	dec    %eax
  8036c1:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  8036c6:	ff 45 f0             	incl   -0x10(%ebp)
  8036c9:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  8036d0:	0f 8e d8 fe ff ff    	jle    8035ae <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  8036d6:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  8036dd:	e9 9d 00 00 00       	jmp    80377f <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  8036e2:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8036e8:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  8036eb:	89 c8                	mov    %ecx,%eax
  8036ed:	01 c0                	add    %eax,%eax
  8036ef:	01 c8                	add    %ecx,%eax
  8036f1:	c1 e0 02             	shl    $0x2,%eax
  8036f4:	05 80 d0 81 00       	add    $0x81d080,%eax
  8036f9:	89 10                	mov    %edx,(%eax)
  8036fb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036fe:	89 d0                	mov    %edx,%eax
  803700:	01 c0                	add    %eax,%eax
  803702:	01 d0                	add    %edx,%eax
  803704:	c1 e0 02             	shl    $0x2,%eax
  803707:	05 80 d0 81 00       	add    $0x81d080,%eax
  80370c:	8b 00                	mov    (%eax),%eax
  80370e:	85 c0                	test   %eax,%eax
  803710:	74 1c                	je     80372e <initialize_dynamic_allocator+0x228>
  803712:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803718:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  80371b:	89 c8                	mov    %ecx,%eax
  80371d:	01 c0                	add    %eax,%eax
  80371f:	01 c8                	add    %ecx,%eax
  803721:	c1 e0 02             	shl    $0x2,%eax
  803724:	05 80 d0 81 00       	add    $0x81d080,%eax
  803729:	89 42 04             	mov    %eax,0x4(%edx)
  80372c:	eb 16                	jmp    803744 <initialize_dynamic_allocator+0x23e>
  80372e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803731:	89 d0                	mov    %edx,%eax
  803733:	01 c0                	add    %eax,%eax
  803735:	01 d0                	add    %edx,%eax
  803737:	c1 e0 02             	shl    $0x2,%eax
  80373a:	05 80 d0 81 00       	add    $0x81d080,%eax
  80373f:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803744:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803747:	89 d0                	mov    %edx,%eax
  803749:	01 c0                	add    %eax,%eax
  80374b:	01 d0                	add    %edx,%eax
  80374d:	c1 e0 02             	shl    $0x2,%eax
  803750:	05 80 d0 81 00       	add    $0x81d080,%eax
  803755:	a3 68 d0 81 00       	mov    %eax,0x81d068
  80375a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80375d:	89 d0                	mov    %edx,%eax
  80375f:	01 c0                	add    %eax,%eax
  803761:	01 d0                	add    %edx,%eax
  803763:	c1 e0 02             	shl    $0x2,%eax
  803766:	05 84 d0 81 00       	add    $0x81d084,%eax
  80376b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803771:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803776:	40                   	inc    %eax
  803777:	a3 74 d0 81 00       	mov    %eax,0x81d074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  80377c:	ff 4d ec             	decl   -0x14(%ebp)
  80377f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803783:	0f 89 59 ff ff ff    	jns    8036e2 <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  803789:	c7 05 44 d0 81 00 01 	movl   $0x1,0x81d044
  803790:	00 00 00 
}
  803793:	90                   	nop
  803794:	c9                   	leave  
  803795:	c3                   	ret    

00803796 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  803796:	55                   	push   %ebp
  803797:	89 e5                	mov    %esp,%ebp
  803799:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  80379c:	8b 45 08             	mov    0x8(%ebp),%eax
  80379f:	83 ec 0c             	sub    $0xc,%esp
  8037a2:	50                   	push   %eax
  8037a3:	e8 10 fd ff ff       	call   8034b8 <to_page_info>
  8037a8:	83 c4 10             	add    $0x10,%esp
  8037ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  8037ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b1:	8b 40 08             	mov    0x8(%eax),%eax
  8037b4:	0f b7 c0             	movzwl %ax,%eax
}
  8037b7:	c9                   	leave  
  8037b8:	c3                   	ret    

008037b9 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8037b9:	55                   	push   %ebp
  8037ba:	89 e5                	mov    %esp,%ebp
  8037bc:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8037bf:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8037c6:	76 16                	jbe    8037de <alloc_block+0x25>
  8037c8:	68 9c 4b 80 00       	push   $0x804b9c
  8037cd:	68 86 4b 80 00       	push   $0x804b86
  8037d2:	6a 59                	push   $0x59
  8037d4:	68 23 4b 80 00       	push   $0x804b23
  8037d9:	e8 a4 cc ff ff       	call   800482 <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  8037de:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  8037e5:	eb 08                	jmp    8037ef <alloc_block+0x36>
		allocSize <<= 1;
  8037e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ea:	01 c0                	add    %eax,%eax
  8037ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  8037ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037f5:	73 09                	jae    803800 <alloc_block+0x47>
  8037f7:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  8037fe:	76 e7                	jbe    8037e7 <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  803800:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803807:	eb 03                	jmp    80380c <alloc_block+0x53>
		listIndex++;
  803809:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  80380c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80380f:	ba 08 00 00 00       	mov    $0x8,%edx
  803814:	88 c1                	mov    %al,%cl
  803816:	d3 e2                	shl    %cl,%edx
  803818:	89 d0                	mov    %edx,%eax
  80381a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80381d:	72 ea                	jb     803809 <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  80381f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803822:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803825:	e9 f4 00 00 00       	jmp    80391e <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  80382a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80382d:	c1 e0 04             	shl    $0x4,%eax
  803830:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803835:	8b 00                	mov    (%eax),%eax
  803837:	85 c0                	test   %eax,%eax
  803839:	0f 84 dc 00 00 00    	je     80391b <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  80383f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803842:	c1 e0 04             	shl    $0x4,%eax
  803845:	05 a0 50 83 00       	add    $0x8350a0,%eax
  80384a:	8b 00                	mov    (%eax),%eax
  80384c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  80384f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803853:	75 14                	jne    803869 <alloc_block+0xb0>
  803855:	83 ec 04             	sub    $0x4,%esp
  803858:	68 bd 4b 80 00       	push   $0x804bbd
  80385d:	6a 6b                	push   $0x6b
  80385f:	68 23 4b 80 00       	push   $0x804b23
  803864:	e8 19 cc ff ff       	call   800482 <_panic>
  803869:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80386c:	8b 00                	mov    (%eax),%eax
  80386e:	85 c0                	test   %eax,%eax
  803870:	74 10                	je     803882 <alloc_block+0xc9>
  803872:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803875:	8b 00                	mov    (%eax),%eax
  803877:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80387a:	8b 52 04             	mov    0x4(%edx),%edx
  80387d:	89 50 04             	mov    %edx,0x4(%eax)
  803880:	eb 14                	jmp    803896 <alloc_block+0xdd>
  803882:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803885:	8b 40 04             	mov    0x4(%eax),%eax
  803888:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80388b:	c1 e2 04             	shl    $0x4,%edx
  80388e:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803894:	89 02                	mov    %eax,(%edx)
  803896:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803899:	8b 40 04             	mov    0x4(%eax),%eax
  80389c:	85 c0                	test   %eax,%eax
  80389e:	74 0f                	je     8038af <alloc_block+0xf6>
  8038a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038a3:	8b 40 04             	mov    0x4(%eax),%eax
  8038a6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038a9:	8b 12                	mov    (%edx),%edx
  8038ab:	89 10                	mov    %edx,(%eax)
  8038ad:	eb 13                	jmp    8038c2 <alloc_block+0x109>
  8038af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038b2:	8b 00                	mov    (%eax),%eax
  8038b4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038b7:	c1 e2 04             	shl    $0x4,%edx
  8038ba:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  8038c0:	89 02                	mov    %eax,(%edx)
  8038c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038d8:	c1 e0 04             	shl    $0x4,%eax
  8038db:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8038e0:	8b 00                	mov    (%eax),%eax
  8038e2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8038e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038e8:	c1 e0 04             	shl    $0x4,%eax
  8038eb:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8038f0:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  8038f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f5:	83 ec 0c             	sub    $0xc,%esp
  8038f8:	50                   	push   %eax
  8038f9:	e8 ba fb ff ff       	call   8034b8 <to_page_info>
  8038fe:	83 c4 10             	add    $0x10,%esp
  803901:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  803904:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803907:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80390b:	48                   	dec    %eax
  80390c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80390f:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  803913:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803916:	e9 8f 02 00 00       	jmp    803baa <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  80391b:	ff 45 ec             	incl   -0x14(%ebp)
  80391e:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803922:	0f 8e 02 ff ff ff    	jle    80382a <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  803928:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80392d:	85 c0                	test   %eax,%eax
  80392f:	75 14                	jne    803945 <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  803931:	83 ec 04             	sub    $0x4,%esp
  803934:	68 dc 4b 80 00       	push   $0x804bdc
  803939:	6a 77                	push   $0x77
  80393b:	68 23 4b 80 00       	push   $0x804b23
  803940:	e8 3d cb ff ff       	call   800482 <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  803945:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80394a:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  80394d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803951:	75 14                	jne    803967 <alloc_block+0x1ae>
  803953:	83 ec 04             	sub    $0x4,%esp
  803956:	68 bd 4b 80 00       	push   $0x804bbd
  80395b:	6a 7a                	push   $0x7a
  80395d:	68 23 4b 80 00       	push   $0x804b23
  803962:	e8 1b cb ff ff       	call   800482 <_panic>
  803967:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80396a:	8b 00                	mov    (%eax),%eax
  80396c:	85 c0                	test   %eax,%eax
  80396e:	74 10                	je     803980 <alloc_block+0x1c7>
  803970:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803973:	8b 00                	mov    (%eax),%eax
  803975:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803978:	8b 52 04             	mov    0x4(%edx),%edx
  80397b:	89 50 04             	mov    %edx,0x4(%eax)
  80397e:	eb 0b                	jmp    80398b <alloc_block+0x1d2>
  803980:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803983:	8b 40 04             	mov    0x4(%eax),%eax
  803986:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  80398b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80398e:	8b 40 04             	mov    0x4(%eax),%eax
  803991:	85 c0                	test   %eax,%eax
  803993:	74 0f                	je     8039a4 <alloc_block+0x1eb>
  803995:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803998:	8b 40 04             	mov    0x4(%eax),%eax
  80399b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80399e:	8b 12                	mov    (%edx),%edx
  8039a0:	89 10                	mov    %edx,(%eax)
  8039a2:	eb 0a                	jmp    8039ae <alloc_block+0x1f5>
  8039a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039a7:	8b 00                	mov    (%eax),%eax
  8039a9:	a3 68 d0 81 00       	mov    %eax,0x81d068
  8039ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039c1:	a1 74 d0 81 00       	mov    0x81d074,%eax
  8039c6:	48                   	dec    %eax
  8039c7:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  8039cc:	83 ec 0c             	sub    $0xc,%esp
  8039cf:	ff 75 dc             	pushl  -0x24(%ebp)
  8039d2:	e8 6f fa ff ff       	call   803446 <to_page_va>
  8039d7:	83 c4 10             	add    $0x10,%esp
  8039da:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  8039dd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8039e0:	83 ec 0c             	sub    $0xc,%esp
  8039e3:	50                   	push   %eax
  8039e4:	e8 a0 dc ff ff       	call   801689 <get_page>
  8039e9:	83 c4 10             	add    $0x10,%esp
  8039ec:	85 c0                	test   %eax,%eax
  8039ee:	74 14                	je     803a04 <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  8039f0:	83 ec 04             	sub    $0x4,%esp
  8039f3:	68 04 4c 80 00       	push   $0x804c04
  8039f8:	6a 7f                	push   $0x7f
  8039fa:	68 23 4b 80 00       	push   $0x804b23
  8039ff:	e8 7e ca ff ff       	call   800482 <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  803a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a07:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803a0a:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  803a0e:	b8 00 10 00 00       	mov    $0x1000,%eax
  803a13:	ba 00 00 00 00       	mov    $0x0,%edx
  803a18:	f7 75 f4             	divl   -0xc(%ebp)
  803a1b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803a1e:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803a22:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803a29:	e9 a7 00 00 00       	jmp    803ad5 <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  803a2e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803a31:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a34:	01 d0                	add    %edx,%eax
  803a36:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  803a39:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803a3d:	75 17                	jne    803a56 <alloc_block+0x29d>
  803a3f:	83 ec 04             	sub    $0x4,%esp
  803a42:	68 2c 4c 80 00       	push   $0x804c2c
  803a47:	68 88 00 00 00       	push   $0x88
  803a4c:	68 23 4b 80 00       	push   $0x804b23
  803a51:	e8 2c ca ff ff       	call   800482 <_panic>
  803a56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a59:	c1 e0 04             	shl    $0x4,%eax
  803a5c:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803a61:	8b 10                	mov    (%eax),%edx
  803a63:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a66:	89 10                	mov    %edx,(%eax)
  803a68:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a6b:	8b 00                	mov    (%eax),%eax
  803a6d:	85 c0                	test   %eax,%eax
  803a6f:	74 15                	je     803a86 <alloc_block+0x2cd>
  803a71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a74:	c1 e0 04             	shl    $0x4,%eax
  803a77:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803a7c:	8b 00                	mov    (%eax),%eax
  803a7e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a81:	89 50 04             	mov    %edx,0x4(%eax)
  803a84:	eb 11                	jmp    803a97 <alloc_block+0x2de>
  803a86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a89:	c1 e0 04             	shl    $0x4,%eax
  803a8c:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803a92:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a95:	89 02                	mov    %eax,(%edx)
  803a97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a9a:	c1 e0 04             	shl    $0x4,%eax
  803a9d:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803aa3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803aa6:	89 02                	mov    %eax,(%edx)
  803aa8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803aab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ab2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ab5:	c1 e0 04             	shl    $0x4,%eax
  803ab8:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803abd:	8b 00                	mov    (%eax),%eax
  803abf:	8d 50 01             	lea    0x1(%eax),%edx
  803ac2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ac5:	c1 e0 04             	shl    $0x4,%eax
  803ac8:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803acd:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ad2:	01 45 e8             	add    %eax,-0x18(%ebp)
  803ad5:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  803adc:	0f 86 4c ff ff ff    	jbe    803a2e <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  803ae2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ae5:	c1 e0 04             	shl    $0x4,%eax
  803ae8:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803aed:	8b 00                	mov    (%eax),%eax
  803aef:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  803af2:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803af6:	75 17                	jne    803b0f <alloc_block+0x356>
  803af8:	83 ec 04             	sub    $0x4,%esp
  803afb:	68 bd 4b 80 00       	push   $0x804bbd
  803b00:	68 8d 00 00 00       	push   $0x8d
  803b05:	68 23 4b 80 00       	push   $0x804b23
  803b0a:	e8 73 c9 ff ff       	call   800482 <_panic>
  803b0f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b12:	8b 00                	mov    (%eax),%eax
  803b14:	85 c0                	test   %eax,%eax
  803b16:	74 10                	je     803b28 <alloc_block+0x36f>
  803b18:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b1b:	8b 00                	mov    (%eax),%eax
  803b1d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803b20:	8b 52 04             	mov    0x4(%edx),%edx
  803b23:	89 50 04             	mov    %edx,0x4(%eax)
  803b26:	eb 14                	jmp    803b3c <alloc_block+0x383>
  803b28:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b2b:	8b 40 04             	mov    0x4(%eax),%eax
  803b2e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b31:	c1 e2 04             	shl    $0x4,%edx
  803b34:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803b3a:	89 02                	mov    %eax,(%edx)
  803b3c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b3f:	8b 40 04             	mov    0x4(%eax),%eax
  803b42:	85 c0                	test   %eax,%eax
  803b44:	74 0f                	je     803b55 <alloc_block+0x39c>
  803b46:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b49:	8b 40 04             	mov    0x4(%eax),%eax
  803b4c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803b4f:	8b 12                	mov    (%edx),%edx
  803b51:	89 10                	mov    %edx,(%eax)
  803b53:	eb 13                	jmp    803b68 <alloc_block+0x3af>
  803b55:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b58:	8b 00                	mov    (%eax),%eax
  803b5a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b5d:	c1 e2 04             	shl    $0x4,%edx
  803b60:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803b66:	89 02                	mov    %eax,(%edx)
  803b68:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b6b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b71:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b74:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b7e:	c1 e0 04             	shl    $0x4,%eax
  803b81:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803b86:	8b 00                	mov    (%eax),%eax
  803b88:	8d 50 ff             	lea    -0x1(%eax),%edx
  803b8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b8e:	c1 e0 04             	shl    $0x4,%eax
  803b91:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803b96:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  803b98:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b9b:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803b9f:	48                   	dec    %eax
  803ba0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803ba3:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  803ba7:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  803baa:	c9                   	leave  
  803bab:	c3                   	ret    

00803bac <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803bac:	55                   	push   %ebp
  803bad:	89 e5                	mov    %esp,%ebp
  803baf:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803bb2:	8b 55 08             	mov    0x8(%ebp),%edx
  803bb5:	a1 84 50 83 00       	mov    0x835084,%eax
  803bba:	39 c2                	cmp    %eax,%edx
  803bbc:	72 0c                	jb     803bca <free_block+0x1e>
  803bbe:	8b 55 08             	mov    0x8(%ebp),%edx
  803bc1:	a1 60 d0 81 00       	mov    0x81d060,%eax
  803bc6:	39 c2                	cmp    %eax,%edx
  803bc8:	72 19                	jb     803be3 <free_block+0x37>
  803bca:	68 50 4c 80 00       	push   $0x804c50
  803bcf:	68 86 4b 80 00       	push   $0x804b86
  803bd4:	68 98 00 00 00       	push   $0x98
  803bd9:	68 23 4b 80 00       	push   $0x804b23
  803bde:	e8 9f c8 ff ff       	call   800482 <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803be3:	8b 45 08             	mov    0x8(%ebp),%eax
  803be6:	83 ec 0c             	sub    $0xc,%esp
  803be9:	50                   	push   %eax
  803bea:	e8 c9 f8 ff ff       	call   8034b8 <to_page_info>
  803bef:	83 c4 10             	add    $0x10,%esp
  803bf2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  803bf5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bf8:	8b 40 08             	mov    0x8(%eax),%eax
  803bfb:	0f b7 c0             	movzwl %ax,%eax
  803bfe:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  803c01:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803c08:	eb 03                	jmp    803c0d <free_block+0x61>
		listIndex++;
  803c0a:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c10:	ba 08 00 00 00       	mov    $0x8,%edx
  803c15:	88 c1                	mov    %al,%cl
  803c17:	d3 e2                	shl    %cl,%edx
  803c19:	89 d0                	mov    %edx,%eax
  803c1b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803c1e:	72 ea                	jb     803c0a <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  803c20:	8b 45 08             	mov    0x8(%ebp),%eax
  803c23:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  803c26:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c2a:	75 17                	jne    803c43 <free_block+0x97>
  803c2c:	83 ec 04             	sub    $0x4,%esp
  803c2f:	68 2c 4c 80 00       	push   $0x804c2c
  803c34:	68 a2 00 00 00       	push   $0xa2
  803c39:	68 23 4b 80 00       	push   $0x804b23
  803c3e:	e8 3f c8 ff ff       	call   800482 <_panic>
  803c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c46:	c1 e0 04             	shl    $0x4,%eax
  803c49:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803c4e:	8b 10                	mov    (%eax),%edx
  803c50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c53:	89 10                	mov    %edx,(%eax)
  803c55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c58:	8b 00                	mov    (%eax),%eax
  803c5a:	85 c0                	test   %eax,%eax
  803c5c:	74 15                	je     803c73 <free_block+0xc7>
  803c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c61:	c1 e0 04             	shl    $0x4,%eax
  803c64:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803c69:	8b 00                	mov    (%eax),%eax
  803c6b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c6e:	89 50 04             	mov    %edx,0x4(%eax)
  803c71:	eb 11                	jmp    803c84 <free_block+0xd8>
  803c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c76:	c1 e0 04             	shl    $0x4,%eax
  803c79:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803c7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c82:	89 02                	mov    %eax,(%edx)
  803c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c87:	c1 e0 04             	shl    $0x4,%eax
  803c8a:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803c90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c93:	89 02                	mov    %eax,(%edx)
  803c95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c98:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ca2:	c1 e0 04             	shl    $0x4,%eax
  803ca5:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803caa:	8b 00                	mov    (%eax),%eax
  803cac:	8d 50 01             	lea    0x1(%eax),%edx
  803caf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cb2:	c1 e0 04             	shl    $0x4,%eax
  803cb5:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803cba:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  803cbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cbf:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803cc3:	40                   	inc    %eax
  803cc4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803cc7:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  803ccb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cce:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803cd2:	0f b7 c8             	movzwl %ax,%ecx
  803cd5:	b8 00 10 00 00       	mov    $0x1000,%eax
  803cda:	ba 00 00 00 00       	mov    $0x0,%edx
  803cdf:	f7 75 e8             	divl   -0x18(%ebp)
  803ce2:	39 c1                	cmp    %eax,%ecx
  803ce4:	0f 85 ed 01 00 00    	jne    803ed7 <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ced:	c1 e0 04             	shl    $0x4,%eax
  803cf0:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803cf5:	8b 00                	mov    (%eax),%eax
  803cf7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803cfa:	eb 2a                	jmp    803d26 <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  803cfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cff:	83 ec 0c             	sub    $0xc,%esp
  803d02:	50                   	push   %eax
  803d03:	e8 b0 f7 ff ff       	call   8034b8 <to_page_info>
  803d08:	83 c4 10             	add    $0x10,%esp
  803d0b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803d0e:	75 06                	jne    803d16 <free_block+0x16a>
				tmp = b;
  803d10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d13:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d19:	c1 e0 04             	shl    $0x4,%eax
  803d1c:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803d21:	8b 00                	mov    (%eax),%eax
  803d23:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803d26:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d2a:	74 07                	je     803d33 <free_block+0x187>
  803d2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d2f:	8b 00                	mov    (%eax),%eax
  803d31:	eb 05                	jmp    803d38 <free_block+0x18c>
  803d33:	b8 00 00 00 00       	mov    $0x0,%eax
  803d38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d3b:	c1 e2 04             	shl    $0x4,%edx
  803d3e:	81 c2 a8 50 83 00    	add    $0x8350a8,%edx
  803d44:	89 02                	mov    %eax,(%edx)
  803d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d49:	c1 e0 04             	shl    $0x4,%eax
  803d4c:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803d51:	8b 00                	mov    (%eax),%eax
  803d53:	85 c0                	test   %eax,%eax
  803d55:	75 a5                	jne    803cfc <free_block+0x150>
  803d57:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d5b:	75 9f                	jne    803cfc <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  803d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d60:	c1 e0 04             	shl    $0x4,%eax
  803d63:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803d68:	8b 00                	mov    (%eax),%eax
  803d6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  803d6d:	e9 cc 00 00 00       	jmp    803e3e <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  803d72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d75:	8b 00                	mov    (%eax),%eax
  803d77:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  803d7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d7d:	83 ec 0c             	sub    $0xc,%esp
  803d80:	50                   	push   %eax
  803d81:	e8 32 f7 ff ff       	call   8034b8 <to_page_info>
  803d86:	83 c4 10             	add    $0x10,%esp
  803d89:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803d8c:	0f 85 a6 00 00 00    	jne    803e38 <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  803d92:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d96:	75 17                	jne    803daf <free_block+0x203>
  803d98:	83 ec 04             	sub    $0x4,%esp
  803d9b:	68 bd 4b 80 00       	push   $0x804bbd
  803da0:	68 b5 00 00 00       	push   $0xb5
  803da5:	68 23 4b 80 00       	push   $0x804b23
  803daa:	e8 d3 c6 ff ff       	call   800482 <_panic>
  803daf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803db2:	8b 00                	mov    (%eax),%eax
  803db4:	85 c0                	test   %eax,%eax
  803db6:	74 10                	je     803dc8 <free_block+0x21c>
  803db8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dbb:	8b 00                	mov    (%eax),%eax
  803dbd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803dc0:	8b 52 04             	mov    0x4(%edx),%edx
  803dc3:	89 50 04             	mov    %edx,0x4(%eax)
  803dc6:	eb 14                	jmp    803ddc <free_block+0x230>
  803dc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dcb:	8b 40 04             	mov    0x4(%eax),%eax
  803dce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803dd1:	c1 e2 04             	shl    $0x4,%edx
  803dd4:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803dda:	89 02                	mov    %eax,(%edx)
  803ddc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ddf:	8b 40 04             	mov    0x4(%eax),%eax
  803de2:	85 c0                	test   %eax,%eax
  803de4:	74 0f                	je     803df5 <free_block+0x249>
  803de6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803de9:	8b 40 04             	mov    0x4(%eax),%eax
  803dec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803def:	8b 12                	mov    (%edx),%edx
  803df1:	89 10                	mov    %edx,(%eax)
  803df3:	eb 13                	jmp    803e08 <free_block+0x25c>
  803df5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803df8:	8b 00                	mov    (%eax),%eax
  803dfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803dfd:	c1 e2 04             	shl    $0x4,%edx
  803e00:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803e06:	89 02                	mov    %eax,(%edx)
  803e08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e0b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e14:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e1e:	c1 e0 04             	shl    $0x4,%eax
  803e21:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803e26:	8b 00                	mov    (%eax),%eax
  803e28:	8d 50 ff             	lea    -0x1(%eax),%edx
  803e2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e2e:	c1 e0 04             	shl    $0x4,%eax
  803e31:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803e36:	89 10                	mov    %edx,(%eax)
			b = next;
  803e38:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  803e3e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803e42:	0f 85 2a ff ff ff    	jne    803d72 <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  803e48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e4b:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  803e51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e54:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  803e5a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803e5e:	75 17                	jne    803e77 <free_block+0x2cb>
  803e60:	83 ec 04             	sub    $0x4,%esp
  803e63:	68 2c 4c 80 00       	push   $0x804c2c
  803e68:	68 bc 00 00 00       	push   $0xbc
  803e6d:	68 23 4b 80 00       	push   $0x804b23
  803e72:	e8 0b c6 ff ff       	call   800482 <_panic>
  803e77:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803e7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e80:	89 10                	mov    %edx,(%eax)
  803e82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e85:	8b 00                	mov    (%eax),%eax
  803e87:	85 c0                	test   %eax,%eax
  803e89:	74 0d                	je     803e98 <free_block+0x2ec>
  803e8b:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803e90:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e93:	89 50 04             	mov    %edx,0x4(%eax)
  803e96:	eb 08                	jmp    803ea0 <free_block+0x2f4>
  803e98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e9b:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803ea0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ea3:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803ea8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803eab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803eb2:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803eb7:	40                   	inc    %eax
  803eb8:	a3 74 d0 81 00       	mov    %eax,0x81d074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  803ebd:	83 ec 0c             	sub    $0xc,%esp
  803ec0:	ff 75 ec             	pushl  -0x14(%ebp)
  803ec3:	e8 7e f5 ff ff       	call   803446 <to_page_va>
  803ec8:	83 c4 10             	add    $0x10,%esp
  803ecb:	83 ec 0c             	sub    $0xc,%esp
  803ece:	50                   	push   %eax
  803ecf:	e8 fe d7 ff ff       	call   8016d2 <return_page>
  803ed4:	83 c4 10             	add    $0x10,%esp
	}
}
  803ed7:	90                   	nop
  803ed8:	c9                   	leave  
  803ed9:	c3                   	ret    
  803eda:	66 90                	xchg   %ax,%ax

00803edc <__udivdi3>:
  803edc:	55                   	push   %ebp
  803edd:	57                   	push   %edi
  803ede:	56                   	push   %esi
  803edf:	53                   	push   %ebx
  803ee0:	83 ec 1c             	sub    $0x1c,%esp
  803ee3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803ee7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803eeb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803eef:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803ef3:	89 ca                	mov    %ecx,%edx
  803ef5:	89 f8                	mov    %edi,%eax
  803ef7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803efb:	85 f6                	test   %esi,%esi
  803efd:	75 2d                	jne    803f2c <__udivdi3+0x50>
  803eff:	39 cf                	cmp    %ecx,%edi
  803f01:	77 65                	ja     803f68 <__udivdi3+0x8c>
  803f03:	89 fd                	mov    %edi,%ebp
  803f05:	85 ff                	test   %edi,%edi
  803f07:	75 0b                	jne    803f14 <__udivdi3+0x38>
  803f09:	b8 01 00 00 00       	mov    $0x1,%eax
  803f0e:	31 d2                	xor    %edx,%edx
  803f10:	f7 f7                	div    %edi
  803f12:	89 c5                	mov    %eax,%ebp
  803f14:	31 d2                	xor    %edx,%edx
  803f16:	89 c8                	mov    %ecx,%eax
  803f18:	f7 f5                	div    %ebp
  803f1a:	89 c1                	mov    %eax,%ecx
  803f1c:	89 d8                	mov    %ebx,%eax
  803f1e:	f7 f5                	div    %ebp
  803f20:	89 cf                	mov    %ecx,%edi
  803f22:	89 fa                	mov    %edi,%edx
  803f24:	83 c4 1c             	add    $0x1c,%esp
  803f27:	5b                   	pop    %ebx
  803f28:	5e                   	pop    %esi
  803f29:	5f                   	pop    %edi
  803f2a:	5d                   	pop    %ebp
  803f2b:	c3                   	ret    
  803f2c:	39 ce                	cmp    %ecx,%esi
  803f2e:	77 28                	ja     803f58 <__udivdi3+0x7c>
  803f30:	0f bd fe             	bsr    %esi,%edi
  803f33:	83 f7 1f             	xor    $0x1f,%edi
  803f36:	75 40                	jne    803f78 <__udivdi3+0x9c>
  803f38:	39 ce                	cmp    %ecx,%esi
  803f3a:	72 0a                	jb     803f46 <__udivdi3+0x6a>
  803f3c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803f40:	0f 87 9e 00 00 00    	ja     803fe4 <__udivdi3+0x108>
  803f46:	b8 01 00 00 00       	mov    $0x1,%eax
  803f4b:	89 fa                	mov    %edi,%edx
  803f4d:	83 c4 1c             	add    $0x1c,%esp
  803f50:	5b                   	pop    %ebx
  803f51:	5e                   	pop    %esi
  803f52:	5f                   	pop    %edi
  803f53:	5d                   	pop    %ebp
  803f54:	c3                   	ret    
  803f55:	8d 76 00             	lea    0x0(%esi),%esi
  803f58:	31 ff                	xor    %edi,%edi
  803f5a:	31 c0                	xor    %eax,%eax
  803f5c:	89 fa                	mov    %edi,%edx
  803f5e:	83 c4 1c             	add    $0x1c,%esp
  803f61:	5b                   	pop    %ebx
  803f62:	5e                   	pop    %esi
  803f63:	5f                   	pop    %edi
  803f64:	5d                   	pop    %ebp
  803f65:	c3                   	ret    
  803f66:	66 90                	xchg   %ax,%ax
  803f68:	89 d8                	mov    %ebx,%eax
  803f6a:	f7 f7                	div    %edi
  803f6c:	31 ff                	xor    %edi,%edi
  803f6e:	89 fa                	mov    %edi,%edx
  803f70:	83 c4 1c             	add    $0x1c,%esp
  803f73:	5b                   	pop    %ebx
  803f74:	5e                   	pop    %esi
  803f75:	5f                   	pop    %edi
  803f76:	5d                   	pop    %ebp
  803f77:	c3                   	ret    
  803f78:	bd 20 00 00 00       	mov    $0x20,%ebp
  803f7d:	89 eb                	mov    %ebp,%ebx
  803f7f:	29 fb                	sub    %edi,%ebx
  803f81:	89 f9                	mov    %edi,%ecx
  803f83:	d3 e6                	shl    %cl,%esi
  803f85:	89 c5                	mov    %eax,%ebp
  803f87:	88 d9                	mov    %bl,%cl
  803f89:	d3 ed                	shr    %cl,%ebp
  803f8b:	89 e9                	mov    %ebp,%ecx
  803f8d:	09 f1                	or     %esi,%ecx
  803f8f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803f93:	89 f9                	mov    %edi,%ecx
  803f95:	d3 e0                	shl    %cl,%eax
  803f97:	89 c5                	mov    %eax,%ebp
  803f99:	89 d6                	mov    %edx,%esi
  803f9b:	88 d9                	mov    %bl,%cl
  803f9d:	d3 ee                	shr    %cl,%esi
  803f9f:	89 f9                	mov    %edi,%ecx
  803fa1:	d3 e2                	shl    %cl,%edx
  803fa3:	8b 44 24 08          	mov    0x8(%esp),%eax
  803fa7:	88 d9                	mov    %bl,%cl
  803fa9:	d3 e8                	shr    %cl,%eax
  803fab:	09 c2                	or     %eax,%edx
  803fad:	89 d0                	mov    %edx,%eax
  803faf:	89 f2                	mov    %esi,%edx
  803fb1:	f7 74 24 0c          	divl   0xc(%esp)
  803fb5:	89 d6                	mov    %edx,%esi
  803fb7:	89 c3                	mov    %eax,%ebx
  803fb9:	f7 e5                	mul    %ebp
  803fbb:	39 d6                	cmp    %edx,%esi
  803fbd:	72 19                	jb     803fd8 <__udivdi3+0xfc>
  803fbf:	74 0b                	je     803fcc <__udivdi3+0xf0>
  803fc1:	89 d8                	mov    %ebx,%eax
  803fc3:	31 ff                	xor    %edi,%edi
  803fc5:	e9 58 ff ff ff       	jmp    803f22 <__udivdi3+0x46>
  803fca:	66 90                	xchg   %ax,%ax
  803fcc:	8b 54 24 08          	mov    0x8(%esp),%edx
  803fd0:	89 f9                	mov    %edi,%ecx
  803fd2:	d3 e2                	shl    %cl,%edx
  803fd4:	39 c2                	cmp    %eax,%edx
  803fd6:	73 e9                	jae    803fc1 <__udivdi3+0xe5>
  803fd8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803fdb:	31 ff                	xor    %edi,%edi
  803fdd:	e9 40 ff ff ff       	jmp    803f22 <__udivdi3+0x46>
  803fe2:	66 90                	xchg   %ax,%ax
  803fe4:	31 c0                	xor    %eax,%eax
  803fe6:	e9 37 ff ff ff       	jmp    803f22 <__udivdi3+0x46>
  803feb:	90                   	nop

00803fec <__umoddi3>:
  803fec:	55                   	push   %ebp
  803fed:	57                   	push   %edi
  803fee:	56                   	push   %esi
  803fef:	53                   	push   %ebx
  803ff0:	83 ec 1c             	sub    $0x1c,%esp
  803ff3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803ff7:	8b 74 24 34          	mov    0x34(%esp),%esi
  803ffb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803fff:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804003:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804007:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80400b:	89 f3                	mov    %esi,%ebx
  80400d:	89 fa                	mov    %edi,%edx
  80400f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804013:	89 34 24             	mov    %esi,(%esp)
  804016:	85 c0                	test   %eax,%eax
  804018:	75 1a                	jne    804034 <__umoddi3+0x48>
  80401a:	39 f7                	cmp    %esi,%edi
  80401c:	0f 86 a2 00 00 00    	jbe    8040c4 <__umoddi3+0xd8>
  804022:	89 c8                	mov    %ecx,%eax
  804024:	89 f2                	mov    %esi,%edx
  804026:	f7 f7                	div    %edi
  804028:	89 d0                	mov    %edx,%eax
  80402a:	31 d2                	xor    %edx,%edx
  80402c:	83 c4 1c             	add    $0x1c,%esp
  80402f:	5b                   	pop    %ebx
  804030:	5e                   	pop    %esi
  804031:	5f                   	pop    %edi
  804032:	5d                   	pop    %ebp
  804033:	c3                   	ret    
  804034:	39 f0                	cmp    %esi,%eax
  804036:	0f 87 ac 00 00 00    	ja     8040e8 <__umoddi3+0xfc>
  80403c:	0f bd e8             	bsr    %eax,%ebp
  80403f:	83 f5 1f             	xor    $0x1f,%ebp
  804042:	0f 84 ac 00 00 00    	je     8040f4 <__umoddi3+0x108>
  804048:	bf 20 00 00 00       	mov    $0x20,%edi
  80404d:	29 ef                	sub    %ebp,%edi
  80404f:	89 fe                	mov    %edi,%esi
  804051:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804055:	89 e9                	mov    %ebp,%ecx
  804057:	d3 e0                	shl    %cl,%eax
  804059:	89 d7                	mov    %edx,%edi
  80405b:	89 f1                	mov    %esi,%ecx
  80405d:	d3 ef                	shr    %cl,%edi
  80405f:	09 c7                	or     %eax,%edi
  804061:	89 e9                	mov    %ebp,%ecx
  804063:	d3 e2                	shl    %cl,%edx
  804065:	89 14 24             	mov    %edx,(%esp)
  804068:	89 d8                	mov    %ebx,%eax
  80406a:	d3 e0                	shl    %cl,%eax
  80406c:	89 c2                	mov    %eax,%edx
  80406e:	8b 44 24 08          	mov    0x8(%esp),%eax
  804072:	d3 e0                	shl    %cl,%eax
  804074:	89 44 24 04          	mov    %eax,0x4(%esp)
  804078:	8b 44 24 08          	mov    0x8(%esp),%eax
  80407c:	89 f1                	mov    %esi,%ecx
  80407e:	d3 e8                	shr    %cl,%eax
  804080:	09 d0                	or     %edx,%eax
  804082:	d3 eb                	shr    %cl,%ebx
  804084:	89 da                	mov    %ebx,%edx
  804086:	f7 f7                	div    %edi
  804088:	89 d3                	mov    %edx,%ebx
  80408a:	f7 24 24             	mull   (%esp)
  80408d:	89 c6                	mov    %eax,%esi
  80408f:	89 d1                	mov    %edx,%ecx
  804091:	39 d3                	cmp    %edx,%ebx
  804093:	0f 82 87 00 00 00    	jb     804120 <__umoddi3+0x134>
  804099:	0f 84 91 00 00 00    	je     804130 <__umoddi3+0x144>
  80409f:	8b 54 24 04          	mov    0x4(%esp),%edx
  8040a3:	29 f2                	sub    %esi,%edx
  8040a5:	19 cb                	sbb    %ecx,%ebx
  8040a7:	89 d8                	mov    %ebx,%eax
  8040a9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8040ad:	d3 e0                	shl    %cl,%eax
  8040af:	89 e9                	mov    %ebp,%ecx
  8040b1:	d3 ea                	shr    %cl,%edx
  8040b3:	09 d0                	or     %edx,%eax
  8040b5:	89 e9                	mov    %ebp,%ecx
  8040b7:	d3 eb                	shr    %cl,%ebx
  8040b9:	89 da                	mov    %ebx,%edx
  8040bb:	83 c4 1c             	add    $0x1c,%esp
  8040be:	5b                   	pop    %ebx
  8040bf:	5e                   	pop    %esi
  8040c0:	5f                   	pop    %edi
  8040c1:	5d                   	pop    %ebp
  8040c2:	c3                   	ret    
  8040c3:	90                   	nop
  8040c4:	89 fd                	mov    %edi,%ebp
  8040c6:	85 ff                	test   %edi,%edi
  8040c8:	75 0b                	jne    8040d5 <__umoddi3+0xe9>
  8040ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8040cf:	31 d2                	xor    %edx,%edx
  8040d1:	f7 f7                	div    %edi
  8040d3:	89 c5                	mov    %eax,%ebp
  8040d5:	89 f0                	mov    %esi,%eax
  8040d7:	31 d2                	xor    %edx,%edx
  8040d9:	f7 f5                	div    %ebp
  8040db:	89 c8                	mov    %ecx,%eax
  8040dd:	f7 f5                	div    %ebp
  8040df:	89 d0                	mov    %edx,%eax
  8040e1:	e9 44 ff ff ff       	jmp    80402a <__umoddi3+0x3e>
  8040e6:	66 90                	xchg   %ax,%ax
  8040e8:	89 c8                	mov    %ecx,%eax
  8040ea:	89 f2                	mov    %esi,%edx
  8040ec:	83 c4 1c             	add    $0x1c,%esp
  8040ef:	5b                   	pop    %ebx
  8040f0:	5e                   	pop    %esi
  8040f1:	5f                   	pop    %edi
  8040f2:	5d                   	pop    %ebp
  8040f3:	c3                   	ret    
  8040f4:	3b 04 24             	cmp    (%esp),%eax
  8040f7:	72 06                	jb     8040ff <__umoddi3+0x113>
  8040f9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8040fd:	77 0f                	ja     80410e <__umoddi3+0x122>
  8040ff:	89 f2                	mov    %esi,%edx
  804101:	29 f9                	sub    %edi,%ecx
  804103:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804107:	89 14 24             	mov    %edx,(%esp)
  80410a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80410e:	8b 44 24 04          	mov    0x4(%esp),%eax
  804112:	8b 14 24             	mov    (%esp),%edx
  804115:	83 c4 1c             	add    $0x1c,%esp
  804118:	5b                   	pop    %ebx
  804119:	5e                   	pop    %esi
  80411a:	5f                   	pop    %edi
  80411b:	5d                   	pop    %ebp
  80411c:	c3                   	ret    
  80411d:	8d 76 00             	lea    0x0(%esi),%esi
  804120:	2b 04 24             	sub    (%esp),%eax
  804123:	19 fa                	sbb    %edi,%edx
  804125:	89 d1                	mov    %edx,%ecx
  804127:	89 c6                	mov    %eax,%esi
  804129:	e9 71 ff ff ff       	jmp    80409f <__umoddi3+0xb3>
  80412e:	66 90                	xchg   %ax,%ax
  804130:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804134:	72 ea                	jb     804120 <__umoddi3+0x134>
  804136:	89 d9                	mov    %ebx,%ecx
  804138:	e9 62 ff ff ff       	jmp    80409f <__umoddi3+0xb3>
