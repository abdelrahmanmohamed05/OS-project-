
obj/user/tst_envfree5_1:     file format elf32-i386


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
  800031:	e8 17 01 00 00       	call   80014d <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests the usage of shared variables
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	// Testing removing the shared variables
	// Testing scenario 5_1: Kill ONE program has shared variables and it frees them
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 c0 3f 80 00       	push   $0x803fc0
  80004a:	e8 ab 1c 00 00       	call   801cfa <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 d2 2d 00 00       	call   802e35 <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 15 2e 00 00       	call   802e80 <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 d0 3f 80 00       	push   $0x803fd0
  800079:	e8 4d 05 00 00       	call   8005cb <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr4", 3000,(myEnv->SecondListSize), 50);
  800081:	a1 20 50 80 00       	mov    0x805020,%eax
  800086:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	68 b8 0b 00 00       	push   $0xbb8
  800094:	68 03 40 80 00       	push   $0x804003
  800099:	e8 f2 2e 00 00       	call   802f90 <sys_create_env>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sys_run_env(envIdProcessA);
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8000aa:	e8 ff 2e 00 00       	call   802fae <sys_run_env>
  8000af:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 1) ;
  8000b2:	90                   	nop
  8000b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000b6:	8b 00                	mov    (%eax),%eax
  8000b8:	83 f8 01             	cmp    $0x1,%eax
  8000bb:	75 f6                	jne    8000b3 <_main+0x7b>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000bd:	e8 73 2d 00 00       	call   802e35 <sys_calculate_free_frames>
  8000c2:	83 ec 08             	sub    $0x8,%esp
  8000c5:	50                   	push   %eax
  8000c6:	68 0c 40 80 00       	push   $0x80400c
  8000cb:	e8 fb 04 00 00       	call   8005cb <cprintf>
  8000d0:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  8000d3:	83 ec 0c             	sub    $0xc,%esp
  8000d6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000d9:	e8 ec 2e 00 00       	call   802fca <sys_destroy_env>
  8000de:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8000e1:	e8 4f 2d 00 00       	call   802e35 <sys_calculate_free_frames>
  8000e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8000e9:	e8 92 2d 00 00       	call   802e80 <sys_pf_calculate_allocated_pages>
  8000ee:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  8000f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000f7:	74 2e                	je     800127 <_main+0xef>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\ndifference = %d\n",
  8000f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000fc:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8000ff:	83 ec 04             	sub    $0x4,%esp
  800102:	50                   	push   %eax
  800103:	ff 75 e4             	pushl  -0x1c(%ebp)
  800106:	68 40 40 80 00       	push   $0x804040
  80010b:	e8 bb 04 00 00       	call   8005cb <cprintf>
  800110:	83 c4 10             	add    $0x10,%esp
				freeFrames_after, freeFrames_after - freeFrames_before);
		panic("env_free() does not work correctly... check it again.");
  800113:	83 ec 04             	sub    $0x4,%esp
  800116:	68 a0 40 80 00       	push   $0x8040a0
  80011b:	6a 1f                	push   $0x1f
  80011d:	68 d6 40 80 00       	push   $0x8040d6
  800122:	e8 d6 01 00 00       	call   8002fd <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  800127:	83 ec 08             	sub    $0x8,%esp
  80012a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80012d:	68 ec 40 80 00       	push   $0x8040ec
  800132:	e8 94 04 00 00       	call   8005cb <cprintf>
  800137:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 5_1 for envfree completed successfully.\n");
  80013a:	83 ec 0c             	sub    $0xc,%esp
  80013d:	68 4c 41 80 00       	push   $0x80414c
  800142:	e8 84 04 00 00       	call   8005cb <cprintf>
  800147:	83 c4 10             	add    $0x10,%esp
	return;
  80014a:	90                   	nop
}
  80014b:	c9                   	leave  
  80014c:	c3                   	ret    

0080014d <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80014d:	55                   	push   %ebp
  80014e:	89 e5                	mov    %esp,%ebp
  800150:	57                   	push   %edi
  800151:	56                   	push   %esi
  800152:	53                   	push   %ebx
  800153:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800156:	e8 a3 2e 00 00       	call   802ffe <sys_getenvindex>
  80015b:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80015e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800161:	89 d0                	mov    %edx,%eax
  800163:	c1 e0 03             	shl    $0x3,%eax
  800166:	01 d0                	add    %edx,%eax
  800168:	c1 e0 02             	shl    $0x2,%eax
  80016b:	01 d0                	add    %edx,%eax
  80016d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800174:	01 d0                	add    %edx,%eax
  800176:	c1 e0 03             	shl    $0x3,%eax
  800179:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80017e:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800183:	a1 20 50 80 00       	mov    0x805020,%eax
  800188:	8a 40 20             	mov    0x20(%eax),%al
  80018b:	84 c0                	test   %al,%al
  80018d:	74 0d                	je     80019c <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80018f:	a1 20 50 80 00       	mov    0x805020,%eax
  800194:	83 c0 20             	add    $0x20,%eax
  800197:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80019c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001a0:	7e 0a                	jle    8001ac <libmain+0x5f>
		binaryname = argv[0];
  8001a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001a5:	8b 00                	mov    (%eax),%eax
  8001a7:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  8001ac:	83 ec 08             	sub    $0x8,%esp
  8001af:	ff 75 0c             	pushl  0xc(%ebp)
  8001b2:	ff 75 08             	pushl  0x8(%ebp)
  8001b5:	e8 7e fe ff ff       	call   800038 <_main>
  8001ba:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001bd:	a1 00 50 80 00       	mov    0x805000,%eax
  8001c2:	85 c0                	test   %eax,%eax
  8001c4:	0f 84 01 01 00 00    	je     8002cb <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8001ca:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001d0:	bb 90 42 80 00       	mov    $0x804290,%ebx
  8001d5:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001da:	89 c7                	mov    %eax,%edi
  8001dc:	89 de                	mov    %ebx,%esi
  8001de:	89 d1                	mov    %edx,%ecx
  8001e0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001e2:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8001e5:	b9 56 00 00 00       	mov    $0x56,%ecx
  8001ea:	b0 00                	mov    $0x0,%al
  8001ec:	89 d7                	mov    %edx,%edi
  8001ee:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8001f0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8001f7:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8001fa:	83 ec 08             	sub    $0x8,%esp
  8001fd:	50                   	push   %eax
  8001fe:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800204:	50                   	push   %eax
  800205:	e8 2a 30 00 00       	call   803234 <sys_utilities>
  80020a:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80020d:	e8 73 2b 00 00       	call   802d85 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800212:	83 ec 0c             	sub    $0xc,%esp
  800215:	68 b0 41 80 00       	push   $0x8041b0
  80021a:	e8 ac 03 00 00       	call   8005cb <cprintf>
  80021f:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800222:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800225:	85 c0                	test   %eax,%eax
  800227:	74 18                	je     800241 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800229:	e8 24 30 00 00       	call   803252 <sys_get_optimal_num_faults>
  80022e:	83 ec 08             	sub    $0x8,%esp
  800231:	50                   	push   %eax
  800232:	68 d8 41 80 00       	push   $0x8041d8
  800237:	e8 8f 03 00 00       	call   8005cb <cprintf>
  80023c:	83 c4 10             	add    $0x10,%esp
  80023f:	eb 59                	jmp    80029a <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800241:	a1 20 50 80 00       	mov    0x805020,%eax
  800246:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  80024c:	a1 20 50 80 00       	mov    0x805020,%eax
  800251:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800257:	83 ec 04             	sub    $0x4,%esp
  80025a:	52                   	push   %edx
  80025b:	50                   	push   %eax
  80025c:	68 fc 41 80 00       	push   $0x8041fc
  800261:	e8 65 03 00 00       	call   8005cb <cprintf>
  800266:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800269:	a1 20 50 80 00       	mov    0x805020,%eax
  80026e:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  800274:	a1 20 50 80 00       	mov    0x805020,%eax
  800279:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  80027f:	a1 20 50 80 00       	mov    0x805020,%eax
  800284:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80028a:	51                   	push   %ecx
  80028b:	52                   	push   %edx
  80028c:	50                   	push   %eax
  80028d:	68 24 42 80 00       	push   $0x804224
  800292:	e8 34 03 00 00       	call   8005cb <cprintf>
  800297:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80029a:	a1 20 50 80 00       	mov    0x805020,%eax
  80029f:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  8002a5:	83 ec 08             	sub    $0x8,%esp
  8002a8:	50                   	push   %eax
  8002a9:	68 7c 42 80 00       	push   $0x80427c
  8002ae:	e8 18 03 00 00       	call   8005cb <cprintf>
  8002b3:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8002b6:	83 ec 0c             	sub    $0xc,%esp
  8002b9:	68 b0 41 80 00       	push   $0x8041b0
  8002be:	e8 08 03 00 00       	call   8005cb <cprintf>
  8002c3:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8002c6:	e8 d4 2a 00 00       	call   802d9f <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8002cb:	e8 1f 00 00 00       	call   8002ef <exit>
}
  8002d0:	90                   	nop
  8002d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d4:	5b                   	pop    %ebx
  8002d5:	5e                   	pop    %esi
  8002d6:	5f                   	pop    %edi
  8002d7:	5d                   	pop    %ebp
  8002d8:	c3                   	ret    

008002d9 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002d9:	55                   	push   %ebp
  8002da:	89 e5                	mov    %esp,%ebp
  8002dc:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002df:	83 ec 0c             	sub    $0xc,%esp
  8002e2:	6a 00                	push   $0x0
  8002e4:	e8 e1 2c 00 00       	call   802fca <sys_destroy_env>
  8002e9:	83 c4 10             	add    $0x10,%esp
}
  8002ec:	90                   	nop
  8002ed:	c9                   	leave  
  8002ee:	c3                   	ret    

008002ef <exit>:

void
exit(void)
{
  8002ef:	55                   	push   %ebp
  8002f0:	89 e5                	mov    %esp,%ebp
  8002f2:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002f5:	e8 36 2d 00 00       	call   803030 <sys_exit_env>
}
  8002fa:	90                   	nop
  8002fb:	c9                   	leave  
  8002fc:	c3                   	ret    

008002fd <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002fd:	55                   	push   %ebp
  8002fe:	89 e5                	mov    %esp,%ebp
  800300:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800303:	8d 45 10             	lea    0x10(%ebp),%eax
  800306:	83 c0 04             	add    $0x4,%eax
  800309:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80030c:	a1 38 51 83 00       	mov    0x835138,%eax
  800311:	85 c0                	test   %eax,%eax
  800313:	74 16                	je     80032b <_panic+0x2e>
		cprintf("%s: ", argv0);
  800315:	a1 38 51 83 00       	mov    0x835138,%eax
  80031a:	83 ec 08             	sub    $0x8,%esp
  80031d:	50                   	push   %eax
  80031e:	68 f4 42 80 00       	push   $0x8042f4
  800323:	e8 a3 02 00 00       	call   8005cb <cprintf>
  800328:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80032b:	a1 04 50 80 00       	mov    0x805004,%eax
  800330:	83 ec 0c             	sub    $0xc,%esp
  800333:	ff 75 0c             	pushl  0xc(%ebp)
  800336:	ff 75 08             	pushl  0x8(%ebp)
  800339:	50                   	push   %eax
  80033a:	68 fc 42 80 00       	push   $0x8042fc
  80033f:	6a 74                	push   $0x74
  800341:	e8 b2 02 00 00       	call   8005f8 <cprintf_colored>
  800346:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800349:	8b 45 10             	mov    0x10(%ebp),%eax
  80034c:	83 ec 08             	sub    $0x8,%esp
  80034f:	ff 75 f4             	pushl  -0xc(%ebp)
  800352:	50                   	push   %eax
  800353:	e8 04 02 00 00       	call   80055c <vcprintf>
  800358:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80035b:	83 ec 08             	sub    $0x8,%esp
  80035e:	6a 00                	push   $0x0
  800360:	68 24 43 80 00       	push   $0x804324
  800365:	e8 f2 01 00 00       	call   80055c <vcprintf>
  80036a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80036d:	e8 7d ff ff ff       	call   8002ef <exit>

	// should not return here
	while (1) ;
  800372:	eb fe                	jmp    800372 <_panic+0x75>

00800374 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800374:	55                   	push   %ebp
  800375:	89 e5                	mov    %esp,%ebp
  800377:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80037a:	a1 20 50 80 00       	mov    0x805020,%eax
  80037f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800385:	8b 45 0c             	mov    0xc(%ebp),%eax
  800388:	39 c2                	cmp    %eax,%edx
  80038a:	74 14                	je     8003a0 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80038c:	83 ec 04             	sub    $0x4,%esp
  80038f:	68 28 43 80 00       	push   $0x804328
  800394:	6a 26                	push   $0x26
  800396:	68 74 43 80 00       	push   $0x804374
  80039b:	e8 5d ff ff ff       	call   8002fd <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003a7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003ae:	e9 c5 00 00 00       	jmp    800478 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8003b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c0:	01 d0                	add    %edx,%eax
  8003c2:	8b 00                	mov    (%eax),%eax
  8003c4:	85 c0                	test   %eax,%eax
  8003c6:	75 08                	jne    8003d0 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8003c8:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003cb:	e9 a5 00 00 00       	jmp    800475 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8003d0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003d7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003de:	eb 69                	jmp    800449 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003e0:	a1 20 50 80 00       	mov    0x805020,%eax
  8003e5:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8003eb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003ee:	89 d0                	mov    %edx,%eax
  8003f0:	01 c0                	add    %eax,%eax
  8003f2:	01 d0                	add    %edx,%eax
  8003f4:	c1 e0 03             	shl    $0x3,%eax
  8003f7:	01 c8                	add    %ecx,%eax
  8003f9:	8a 40 04             	mov    0x4(%eax),%al
  8003fc:	84 c0                	test   %al,%al
  8003fe:	75 46                	jne    800446 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800400:	a1 20 50 80 00       	mov    0x805020,%eax
  800405:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80040b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80040e:	89 d0                	mov    %edx,%eax
  800410:	01 c0                	add    %eax,%eax
  800412:	01 d0                	add    %edx,%eax
  800414:	c1 e0 03             	shl    $0x3,%eax
  800417:	01 c8                	add    %ecx,%eax
  800419:	8b 00                	mov    (%eax),%eax
  80041b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80041e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800421:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800426:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800428:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80042b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800432:	8b 45 08             	mov    0x8(%ebp),%eax
  800435:	01 c8                	add    %ecx,%eax
  800437:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800439:	39 c2                	cmp    %eax,%edx
  80043b:	75 09                	jne    800446 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80043d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800444:	eb 15                	jmp    80045b <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800446:	ff 45 e8             	incl   -0x18(%ebp)
  800449:	a1 20 50 80 00       	mov    0x805020,%eax
  80044e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800454:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800457:	39 c2                	cmp    %eax,%edx
  800459:	77 85                	ja     8003e0 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80045b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80045f:	75 14                	jne    800475 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800461:	83 ec 04             	sub    $0x4,%esp
  800464:	68 80 43 80 00       	push   $0x804380
  800469:	6a 3a                	push   $0x3a
  80046b:	68 74 43 80 00       	push   $0x804374
  800470:	e8 88 fe ff ff       	call   8002fd <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800475:	ff 45 f0             	incl   -0x10(%ebp)
  800478:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80047b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80047e:	0f 8c 2f ff ff ff    	jl     8003b3 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800484:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80048b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800492:	eb 26                	jmp    8004ba <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800494:	a1 20 50 80 00       	mov    0x805020,%eax
  800499:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80049f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004a2:	89 d0                	mov    %edx,%eax
  8004a4:	01 c0                	add    %eax,%eax
  8004a6:	01 d0                	add    %edx,%eax
  8004a8:	c1 e0 03             	shl    $0x3,%eax
  8004ab:	01 c8                	add    %ecx,%eax
  8004ad:	8a 40 04             	mov    0x4(%eax),%al
  8004b0:	3c 01                	cmp    $0x1,%al
  8004b2:	75 03                	jne    8004b7 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8004b4:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004b7:	ff 45 e0             	incl   -0x20(%ebp)
  8004ba:	a1 20 50 80 00       	mov    0x805020,%eax
  8004bf:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004c8:	39 c2                	cmp    %eax,%edx
  8004ca:	77 c8                	ja     800494 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004cf:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004d2:	74 14                	je     8004e8 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8004d4:	83 ec 04             	sub    $0x4,%esp
  8004d7:	68 d4 43 80 00       	push   $0x8043d4
  8004dc:	6a 44                	push   $0x44
  8004de:	68 74 43 80 00       	push   $0x804374
  8004e3:	e8 15 fe ff ff       	call   8002fd <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004e8:	90                   	nop
  8004e9:	c9                   	leave  
  8004ea:	c3                   	ret    

008004eb <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8004eb:	55                   	push   %ebp
  8004ec:	89 e5                	mov    %esp,%ebp
  8004ee:	53                   	push   %ebx
  8004ef:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8004f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f5:	8b 00                	mov    (%eax),%eax
  8004f7:	8d 48 01             	lea    0x1(%eax),%ecx
  8004fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004fd:	89 0a                	mov    %ecx,(%edx)
  8004ff:	8b 55 08             	mov    0x8(%ebp),%edx
  800502:	88 d1                	mov    %dl,%cl
  800504:	8b 55 0c             	mov    0xc(%ebp),%edx
  800507:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80050b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80050e:	8b 00                	mov    (%eax),%eax
  800510:	3d ff 00 00 00       	cmp    $0xff,%eax
  800515:	75 30                	jne    800547 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800517:	8b 15 3c 51 83 00    	mov    0x83513c,%edx
  80051d:	a0 64 d0 81 00       	mov    0x81d064,%al
  800522:	0f b6 c0             	movzbl %al,%eax
  800525:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800528:	8b 09                	mov    (%ecx),%ecx
  80052a:	89 cb                	mov    %ecx,%ebx
  80052c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80052f:	83 c1 08             	add    $0x8,%ecx
  800532:	52                   	push   %edx
  800533:	50                   	push   %eax
  800534:	53                   	push   %ebx
  800535:	51                   	push   %ecx
  800536:	e8 06 28 00 00       	call   802d41 <sys_cputs>
  80053b:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80053e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800541:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800547:	8b 45 0c             	mov    0xc(%ebp),%eax
  80054a:	8b 40 04             	mov    0x4(%eax),%eax
  80054d:	8d 50 01             	lea    0x1(%eax),%edx
  800550:	8b 45 0c             	mov    0xc(%ebp),%eax
  800553:	89 50 04             	mov    %edx,0x4(%eax)
}
  800556:	90                   	nop
  800557:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80055a:	c9                   	leave  
  80055b:	c3                   	ret    

0080055c <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80055c:	55                   	push   %ebp
  80055d:	89 e5                	mov    %esp,%ebp
  80055f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800565:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80056c:	00 00 00 
	b.cnt = 0;
  80056f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800576:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800579:	ff 75 0c             	pushl  0xc(%ebp)
  80057c:	ff 75 08             	pushl  0x8(%ebp)
  80057f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800585:	50                   	push   %eax
  800586:	68 eb 04 80 00       	push   $0x8004eb
  80058b:	e8 5a 02 00 00       	call   8007ea <vprintfmt>
  800590:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800593:	8b 15 3c 51 83 00    	mov    0x83513c,%edx
  800599:	a0 64 d0 81 00       	mov    0x81d064,%al
  80059e:	0f b6 c0             	movzbl %al,%eax
  8005a1:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8005a7:	52                   	push   %edx
  8005a8:	50                   	push   %eax
  8005a9:	51                   	push   %ecx
  8005aa:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005b0:	83 c0 08             	add    $0x8,%eax
  8005b3:	50                   	push   %eax
  8005b4:	e8 88 27 00 00       	call   802d41 <sys_cputs>
  8005b9:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005bc:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
	return b.cnt;
  8005c3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005c9:	c9                   	leave  
  8005ca:	c3                   	ret    

008005cb <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005cb:	55                   	push   %ebp
  8005cc:	89 e5                	mov    %esp,%ebp
  8005ce:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005d1:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	va_start(ap, fmt);
  8005d8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005de:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e1:	83 ec 08             	sub    $0x8,%esp
  8005e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8005e7:	50                   	push   %eax
  8005e8:	e8 6f ff ff ff       	call   80055c <vcprintf>
  8005ed:	83 c4 10             	add    $0x10,%esp
  8005f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005f6:	c9                   	leave  
  8005f7:	c3                   	ret    

008005f8 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8005f8:	55                   	push   %ebp
  8005f9:	89 e5                	mov    %esp,%ebp
  8005fb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005fe:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	curTextClr = (textClr << 8) ; //set text color by the given value
  800605:	8b 45 08             	mov    0x8(%ebp),%eax
  800608:	c1 e0 08             	shl    $0x8,%eax
  80060b:	a3 3c 51 83 00       	mov    %eax,0x83513c
	va_start(ap, fmt);
  800610:	8d 45 0c             	lea    0xc(%ebp),%eax
  800613:	83 c0 04             	add    $0x4,%eax
  800616:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800619:	8b 45 0c             	mov    0xc(%ebp),%eax
  80061c:	83 ec 08             	sub    $0x8,%esp
  80061f:	ff 75 f4             	pushl  -0xc(%ebp)
  800622:	50                   	push   %eax
  800623:	e8 34 ff ff ff       	call   80055c <vcprintf>
  800628:	83 c4 10             	add    $0x10,%esp
  80062b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80062e:	c7 05 3c 51 83 00 00 	movl   $0x700,0x83513c
  800635:	07 00 00 

	return cnt;
  800638:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80063b:	c9                   	leave  
  80063c:	c3                   	ret    

0080063d <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80063d:	55                   	push   %ebp
  80063e:	89 e5                	mov    %esp,%ebp
  800640:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800643:	e8 3d 27 00 00       	call   802d85 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800648:	8d 45 0c             	lea    0xc(%ebp),%eax
  80064b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80064e:	8b 45 08             	mov    0x8(%ebp),%eax
  800651:	83 ec 08             	sub    $0x8,%esp
  800654:	ff 75 f4             	pushl  -0xc(%ebp)
  800657:	50                   	push   %eax
  800658:	e8 ff fe ff ff       	call   80055c <vcprintf>
  80065d:	83 c4 10             	add    $0x10,%esp
  800660:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800663:	e8 37 27 00 00       	call   802d9f <sys_unlock_cons>
	return cnt;
  800668:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80066b:	c9                   	leave  
  80066c:	c3                   	ret    

0080066d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80066d:	55                   	push   %ebp
  80066e:	89 e5                	mov    %esp,%ebp
  800670:	53                   	push   %ebx
  800671:	83 ec 14             	sub    $0x14,%esp
  800674:	8b 45 10             	mov    0x10(%ebp),%eax
  800677:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80067a:	8b 45 14             	mov    0x14(%ebp),%eax
  80067d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800680:	8b 45 18             	mov    0x18(%ebp),%eax
  800683:	ba 00 00 00 00       	mov    $0x0,%edx
  800688:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80068b:	77 55                	ja     8006e2 <printnum+0x75>
  80068d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800690:	72 05                	jb     800697 <printnum+0x2a>
  800692:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800695:	77 4b                	ja     8006e2 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800697:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80069a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80069d:	8b 45 18             	mov    0x18(%ebp),%eax
  8006a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a5:	52                   	push   %edx
  8006a6:	50                   	push   %eax
  8006a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8006aa:	ff 75 f0             	pushl  -0x10(%ebp)
  8006ad:	e8 a6 36 00 00       	call   803d58 <__udivdi3>
  8006b2:	83 c4 10             	add    $0x10,%esp
  8006b5:	83 ec 04             	sub    $0x4,%esp
  8006b8:	ff 75 20             	pushl  0x20(%ebp)
  8006bb:	53                   	push   %ebx
  8006bc:	ff 75 18             	pushl  0x18(%ebp)
  8006bf:	52                   	push   %edx
  8006c0:	50                   	push   %eax
  8006c1:	ff 75 0c             	pushl  0xc(%ebp)
  8006c4:	ff 75 08             	pushl  0x8(%ebp)
  8006c7:	e8 a1 ff ff ff       	call   80066d <printnum>
  8006cc:	83 c4 20             	add    $0x20,%esp
  8006cf:	eb 1a                	jmp    8006eb <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006d1:	83 ec 08             	sub    $0x8,%esp
  8006d4:	ff 75 0c             	pushl  0xc(%ebp)
  8006d7:	ff 75 20             	pushl  0x20(%ebp)
  8006da:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dd:	ff d0                	call   *%eax
  8006df:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006e2:	ff 4d 1c             	decl   0x1c(%ebp)
  8006e5:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006e9:	7f e6                	jg     8006d1 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006eb:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006ee:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006f9:	53                   	push   %ebx
  8006fa:	51                   	push   %ecx
  8006fb:	52                   	push   %edx
  8006fc:	50                   	push   %eax
  8006fd:	e8 66 37 00 00       	call   803e68 <__umoddi3>
  800702:	83 c4 10             	add    $0x10,%esp
  800705:	05 34 46 80 00       	add    $0x804634,%eax
  80070a:	8a 00                	mov    (%eax),%al
  80070c:	0f be c0             	movsbl %al,%eax
  80070f:	83 ec 08             	sub    $0x8,%esp
  800712:	ff 75 0c             	pushl  0xc(%ebp)
  800715:	50                   	push   %eax
  800716:	8b 45 08             	mov    0x8(%ebp),%eax
  800719:	ff d0                	call   *%eax
  80071b:	83 c4 10             	add    $0x10,%esp
}
  80071e:	90                   	nop
  80071f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800722:	c9                   	leave  
  800723:	c3                   	ret    

00800724 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800724:	55                   	push   %ebp
  800725:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800727:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80072b:	7e 1c                	jle    800749 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80072d:	8b 45 08             	mov    0x8(%ebp),%eax
  800730:	8b 00                	mov    (%eax),%eax
  800732:	8d 50 08             	lea    0x8(%eax),%edx
  800735:	8b 45 08             	mov    0x8(%ebp),%eax
  800738:	89 10                	mov    %edx,(%eax)
  80073a:	8b 45 08             	mov    0x8(%ebp),%eax
  80073d:	8b 00                	mov    (%eax),%eax
  80073f:	83 e8 08             	sub    $0x8,%eax
  800742:	8b 50 04             	mov    0x4(%eax),%edx
  800745:	8b 00                	mov    (%eax),%eax
  800747:	eb 40                	jmp    800789 <getuint+0x65>
	else if (lflag)
  800749:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80074d:	74 1e                	je     80076d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80074f:	8b 45 08             	mov    0x8(%ebp),%eax
  800752:	8b 00                	mov    (%eax),%eax
  800754:	8d 50 04             	lea    0x4(%eax),%edx
  800757:	8b 45 08             	mov    0x8(%ebp),%eax
  80075a:	89 10                	mov    %edx,(%eax)
  80075c:	8b 45 08             	mov    0x8(%ebp),%eax
  80075f:	8b 00                	mov    (%eax),%eax
  800761:	83 e8 04             	sub    $0x4,%eax
  800764:	8b 00                	mov    (%eax),%eax
  800766:	ba 00 00 00 00       	mov    $0x0,%edx
  80076b:	eb 1c                	jmp    800789 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80076d:	8b 45 08             	mov    0x8(%ebp),%eax
  800770:	8b 00                	mov    (%eax),%eax
  800772:	8d 50 04             	lea    0x4(%eax),%edx
  800775:	8b 45 08             	mov    0x8(%ebp),%eax
  800778:	89 10                	mov    %edx,(%eax)
  80077a:	8b 45 08             	mov    0x8(%ebp),%eax
  80077d:	8b 00                	mov    (%eax),%eax
  80077f:	83 e8 04             	sub    $0x4,%eax
  800782:	8b 00                	mov    (%eax),%eax
  800784:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800789:	5d                   	pop    %ebp
  80078a:	c3                   	ret    

0080078b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80078b:	55                   	push   %ebp
  80078c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80078e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800792:	7e 1c                	jle    8007b0 <getint+0x25>
		return va_arg(*ap, long long);
  800794:	8b 45 08             	mov    0x8(%ebp),%eax
  800797:	8b 00                	mov    (%eax),%eax
  800799:	8d 50 08             	lea    0x8(%eax),%edx
  80079c:	8b 45 08             	mov    0x8(%ebp),%eax
  80079f:	89 10                	mov    %edx,(%eax)
  8007a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a4:	8b 00                	mov    (%eax),%eax
  8007a6:	83 e8 08             	sub    $0x8,%eax
  8007a9:	8b 50 04             	mov    0x4(%eax),%edx
  8007ac:	8b 00                	mov    (%eax),%eax
  8007ae:	eb 38                	jmp    8007e8 <getint+0x5d>
	else if (lflag)
  8007b0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007b4:	74 1a                	je     8007d0 <getint+0x45>
		return va_arg(*ap, long);
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	8b 00                	mov    (%eax),%eax
  8007bb:	8d 50 04             	lea    0x4(%eax),%edx
  8007be:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c1:	89 10                	mov    %edx,(%eax)
  8007c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c6:	8b 00                	mov    (%eax),%eax
  8007c8:	83 e8 04             	sub    $0x4,%eax
  8007cb:	8b 00                	mov    (%eax),%eax
  8007cd:	99                   	cltd   
  8007ce:	eb 18                	jmp    8007e8 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d3:	8b 00                	mov    (%eax),%eax
  8007d5:	8d 50 04             	lea    0x4(%eax),%edx
  8007d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007db:	89 10                	mov    %edx,(%eax)
  8007dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e0:	8b 00                	mov    (%eax),%eax
  8007e2:	83 e8 04             	sub    $0x4,%eax
  8007e5:	8b 00                	mov    (%eax),%eax
  8007e7:	99                   	cltd   
}
  8007e8:	5d                   	pop    %ebp
  8007e9:	c3                   	ret    

008007ea <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007ea:	55                   	push   %ebp
  8007eb:	89 e5                	mov    %esp,%ebp
  8007ed:	56                   	push   %esi
  8007ee:	53                   	push   %ebx
  8007ef:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007f2:	eb 17                	jmp    80080b <vprintfmt+0x21>
			if (ch == '\0')
  8007f4:	85 db                	test   %ebx,%ebx
  8007f6:	0f 84 c1 03 00 00    	je     800bbd <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007fc:	83 ec 08             	sub    $0x8,%esp
  8007ff:	ff 75 0c             	pushl  0xc(%ebp)
  800802:	53                   	push   %ebx
  800803:	8b 45 08             	mov    0x8(%ebp),%eax
  800806:	ff d0                	call   *%eax
  800808:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80080b:	8b 45 10             	mov    0x10(%ebp),%eax
  80080e:	8d 50 01             	lea    0x1(%eax),%edx
  800811:	89 55 10             	mov    %edx,0x10(%ebp)
  800814:	8a 00                	mov    (%eax),%al
  800816:	0f b6 d8             	movzbl %al,%ebx
  800819:	83 fb 25             	cmp    $0x25,%ebx
  80081c:	75 d6                	jne    8007f4 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80081e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800822:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800829:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800830:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800837:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80083e:	8b 45 10             	mov    0x10(%ebp),%eax
  800841:	8d 50 01             	lea    0x1(%eax),%edx
  800844:	89 55 10             	mov    %edx,0x10(%ebp)
  800847:	8a 00                	mov    (%eax),%al
  800849:	0f b6 d8             	movzbl %al,%ebx
  80084c:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80084f:	83 f8 5b             	cmp    $0x5b,%eax
  800852:	0f 87 3d 03 00 00    	ja     800b95 <vprintfmt+0x3ab>
  800858:	8b 04 85 58 46 80 00 	mov    0x804658(,%eax,4),%eax
  80085f:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800861:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800865:	eb d7                	jmp    80083e <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800867:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80086b:	eb d1                	jmp    80083e <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80086d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800874:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800877:	89 d0                	mov    %edx,%eax
  800879:	c1 e0 02             	shl    $0x2,%eax
  80087c:	01 d0                	add    %edx,%eax
  80087e:	01 c0                	add    %eax,%eax
  800880:	01 d8                	add    %ebx,%eax
  800882:	83 e8 30             	sub    $0x30,%eax
  800885:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800888:	8b 45 10             	mov    0x10(%ebp),%eax
  80088b:	8a 00                	mov    (%eax),%al
  80088d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800890:	83 fb 2f             	cmp    $0x2f,%ebx
  800893:	7e 3e                	jle    8008d3 <vprintfmt+0xe9>
  800895:	83 fb 39             	cmp    $0x39,%ebx
  800898:	7f 39                	jg     8008d3 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80089a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80089d:	eb d5                	jmp    800874 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80089f:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a2:	83 c0 04             	add    $0x4,%eax
  8008a5:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ab:	83 e8 04             	sub    $0x4,%eax
  8008ae:	8b 00                	mov    (%eax),%eax
  8008b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008b3:	eb 1f                	jmp    8008d4 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008b5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008b9:	79 83                	jns    80083e <vprintfmt+0x54>
				width = 0;
  8008bb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008c2:	e9 77 ff ff ff       	jmp    80083e <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008c7:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008ce:	e9 6b ff ff ff       	jmp    80083e <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008d3:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008d4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008d8:	0f 89 60 ff ff ff    	jns    80083e <vprintfmt+0x54>
				width = precision, precision = -1;
  8008de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008e4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008eb:	e9 4e ff ff ff       	jmp    80083e <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008f0:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008f3:	e9 46 ff ff ff       	jmp    80083e <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fb:	83 c0 04             	add    $0x4,%eax
  8008fe:	89 45 14             	mov    %eax,0x14(%ebp)
  800901:	8b 45 14             	mov    0x14(%ebp),%eax
  800904:	83 e8 04             	sub    $0x4,%eax
  800907:	8b 00                	mov    (%eax),%eax
  800909:	83 ec 08             	sub    $0x8,%esp
  80090c:	ff 75 0c             	pushl  0xc(%ebp)
  80090f:	50                   	push   %eax
  800910:	8b 45 08             	mov    0x8(%ebp),%eax
  800913:	ff d0                	call   *%eax
  800915:	83 c4 10             	add    $0x10,%esp
			break;
  800918:	e9 9b 02 00 00       	jmp    800bb8 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80091d:	8b 45 14             	mov    0x14(%ebp),%eax
  800920:	83 c0 04             	add    $0x4,%eax
  800923:	89 45 14             	mov    %eax,0x14(%ebp)
  800926:	8b 45 14             	mov    0x14(%ebp),%eax
  800929:	83 e8 04             	sub    $0x4,%eax
  80092c:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80092e:	85 db                	test   %ebx,%ebx
  800930:	79 02                	jns    800934 <vprintfmt+0x14a>
				err = -err;
  800932:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800934:	83 fb 64             	cmp    $0x64,%ebx
  800937:	7f 0b                	jg     800944 <vprintfmt+0x15a>
  800939:	8b 34 9d a0 44 80 00 	mov    0x8044a0(,%ebx,4),%esi
  800940:	85 f6                	test   %esi,%esi
  800942:	75 19                	jne    80095d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800944:	53                   	push   %ebx
  800945:	68 45 46 80 00       	push   $0x804645
  80094a:	ff 75 0c             	pushl  0xc(%ebp)
  80094d:	ff 75 08             	pushl  0x8(%ebp)
  800950:	e8 70 02 00 00       	call   800bc5 <printfmt>
  800955:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800958:	e9 5b 02 00 00       	jmp    800bb8 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80095d:	56                   	push   %esi
  80095e:	68 4e 46 80 00       	push   $0x80464e
  800963:	ff 75 0c             	pushl  0xc(%ebp)
  800966:	ff 75 08             	pushl  0x8(%ebp)
  800969:	e8 57 02 00 00       	call   800bc5 <printfmt>
  80096e:	83 c4 10             	add    $0x10,%esp
			break;
  800971:	e9 42 02 00 00       	jmp    800bb8 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800976:	8b 45 14             	mov    0x14(%ebp),%eax
  800979:	83 c0 04             	add    $0x4,%eax
  80097c:	89 45 14             	mov    %eax,0x14(%ebp)
  80097f:	8b 45 14             	mov    0x14(%ebp),%eax
  800982:	83 e8 04             	sub    $0x4,%eax
  800985:	8b 30                	mov    (%eax),%esi
  800987:	85 f6                	test   %esi,%esi
  800989:	75 05                	jne    800990 <vprintfmt+0x1a6>
				p = "(null)";
  80098b:	be 51 46 80 00       	mov    $0x804651,%esi
			if (width > 0 && padc != '-')
  800990:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800994:	7e 6d                	jle    800a03 <vprintfmt+0x219>
  800996:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80099a:	74 67                	je     800a03 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80099c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80099f:	83 ec 08             	sub    $0x8,%esp
  8009a2:	50                   	push   %eax
  8009a3:	56                   	push   %esi
  8009a4:	e8 1e 03 00 00       	call   800cc7 <strnlen>
  8009a9:	83 c4 10             	add    $0x10,%esp
  8009ac:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009af:	eb 16                	jmp    8009c7 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009b1:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009b5:	83 ec 08             	sub    $0x8,%esp
  8009b8:	ff 75 0c             	pushl  0xc(%ebp)
  8009bb:	50                   	push   %eax
  8009bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bf:	ff d0                	call   *%eax
  8009c1:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009c4:	ff 4d e4             	decl   -0x1c(%ebp)
  8009c7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009cb:	7f e4                	jg     8009b1 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009cd:	eb 34                	jmp    800a03 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009cf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009d3:	74 1c                	je     8009f1 <vprintfmt+0x207>
  8009d5:	83 fb 1f             	cmp    $0x1f,%ebx
  8009d8:	7e 05                	jle    8009df <vprintfmt+0x1f5>
  8009da:	83 fb 7e             	cmp    $0x7e,%ebx
  8009dd:	7e 12                	jle    8009f1 <vprintfmt+0x207>
					putch('?', putdat);
  8009df:	83 ec 08             	sub    $0x8,%esp
  8009e2:	ff 75 0c             	pushl  0xc(%ebp)
  8009e5:	6a 3f                	push   $0x3f
  8009e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ea:	ff d0                	call   *%eax
  8009ec:	83 c4 10             	add    $0x10,%esp
  8009ef:	eb 0f                	jmp    800a00 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009f1:	83 ec 08             	sub    $0x8,%esp
  8009f4:	ff 75 0c             	pushl  0xc(%ebp)
  8009f7:	53                   	push   %ebx
  8009f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fb:	ff d0                	call   *%eax
  8009fd:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a00:	ff 4d e4             	decl   -0x1c(%ebp)
  800a03:	89 f0                	mov    %esi,%eax
  800a05:	8d 70 01             	lea    0x1(%eax),%esi
  800a08:	8a 00                	mov    (%eax),%al
  800a0a:	0f be d8             	movsbl %al,%ebx
  800a0d:	85 db                	test   %ebx,%ebx
  800a0f:	74 24                	je     800a35 <vprintfmt+0x24b>
  800a11:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a15:	78 b8                	js     8009cf <vprintfmt+0x1e5>
  800a17:	ff 4d e0             	decl   -0x20(%ebp)
  800a1a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a1e:	79 af                	jns    8009cf <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a20:	eb 13                	jmp    800a35 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a22:	83 ec 08             	sub    $0x8,%esp
  800a25:	ff 75 0c             	pushl  0xc(%ebp)
  800a28:	6a 20                	push   $0x20
  800a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2d:	ff d0                	call   *%eax
  800a2f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a32:	ff 4d e4             	decl   -0x1c(%ebp)
  800a35:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a39:	7f e7                	jg     800a22 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a3b:	e9 78 01 00 00       	jmp    800bb8 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a40:	83 ec 08             	sub    $0x8,%esp
  800a43:	ff 75 e8             	pushl  -0x18(%ebp)
  800a46:	8d 45 14             	lea    0x14(%ebp),%eax
  800a49:	50                   	push   %eax
  800a4a:	e8 3c fd ff ff       	call   80078b <getint>
  800a4f:	83 c4 10             	add    $0x10,%esp
  800a52:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a55:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a5e:	85 d2                	test   %edx,%edx
  800a60:	79 23                	jns    800a85 <vprintfmt+0x29b>
				putch('-', putdat);
  800a62:	83 ec 08             	sub    $0x8,%esp
  800a65:	ff 75 0c             	pushl  0xc(%ebp)
  800a68:	6a 2d                	push   $0x2d
  800a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6d:	ff d0                	call   *%eax
  800a6f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a78:	f7 d8                	neg    %eax
  800a7a:	83 d2 00             	adc    $0x0,%edx
  800a7d:	f7 da                	neg    %edx
  800a7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a82:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a85:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a8c:	e9 bc 00 00 00       	jmp    800b4d <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a91:	83 ec 08             	sub    $0x8,%esp
  800a94:	ff 75 e8             	pushl  -0x18(%ebp)
  800a97:	8d 45 14             	lea    0x14(%ebp),%eax
  800a9a:	50                   	push   %eax
  800a9b:	e8 84 fc ff ff       	call   800724 <getuint>
  800aa0:	83 c4 10             	add    $0x10,%esp
  800aa3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aa6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800aa9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ab0:	e9 98 00 00 00       	jmp    800b4d <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ab5:	83 ec 08             	sub    $0x8,%esp
  800ab8:	ff 75 0c             	pushl  0xc(%ebp)
  800abb:	6a 58                	push   $0x58
  800abd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac0:	ff d0                	call   *%eax
  800ac2:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ac5:	83 ec 08             	sub    $0x8,%esp
  800ac8:	ff 75 0c             	pushl  0xc(%ebp)
  800acb:	6a 58                	push   $0x58
  800acd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad0:	ff d0                	call   *%eax
  800ad2:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ad5:	83 ec 08             	sub    $0x8,%esp
  800ad8:	ff 75 0c             	pushl  0xc(%ebp)
  800adb:	6a 58                	push   $0x58
  800add:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae0:	ff d0                	call   *%eax
  800ae2:	83 c4 10             	add    $0x10,%esp
			break;
  800ae5:	e9 ce 00 00 00       	jmp    800bb8 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800aea:	83 ec 08             	sub    $0x8,%esp
  800aed:	ff 75 0c             	pushl  0xc(%ebp)
  800af0:	6a 30                	push   $0x30
  800af2:	8b 45 08             	mov    0x8(%ebp),%eax
  800af5:	ff d0                	call   *%eax
  800af7:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800afa:	83 ec 08             	sub    $0x8,%esp
  800afd:	ff 75 0c             	pushl  0xc(%ebp)
  800b00:	6a 78                	push   $0x78
  800b02:	8b 45 08             	mov    0x8(%ebp),%eax
  800b05:	ff d0                	call   *%eax
  800b07:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b0a:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0d:	83 c0 04             	add    $0x4,%eax
  800b10:	89 45 14             	mov    %eax,0x14(%ebp)
  800b13:	8b 45 14             	mov    0x14(%ebp),%eax
  800b16:	83 e8 04             	sub    $0x4,%eax
  800b19:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b1e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b25:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b2c:	eb 1f                	jmp    800b4d <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b2e:	83 ec 08             	sub    $0x8,%esp
  800b31:	ff 75 e8             	pushl  -0x18(%ebp)
  800b34:	8d 45 14             	lea    0x14(%ebp),%eax
  800b37:	50                   	push   %eax
  800b38:	e8 e7 fb ff ff       	call   800724 <getuint>
  800b3d:	83 c4 10             	add    $0x10,%esp
  800b40:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b43:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b46:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b4d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b54:	83 ec 04             	sub    $0x4,%esp
  800b57:	52                   	push   %edx
  800b58:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b5b:	50                   	push   %eax
  800b5c:	ff 75 f4             	pushl  -0xc(%ebp)
  800b5f:	ff 75 f0             	pushl  -0x10(%ebp)
  800b62:	ff 75 0c             	pushl  0xc(%ebp)
  800b65:	ff 75 08             	pushl  0x8(%ebp)
  800b68:	e8 00 fb ff ff       	call   80066d <printnum>
  800b6d:	83 c4 20             	add    $0x20,%esp
			break;
  800b70:	eb 46                	jmp    800bb8 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b72:	83 ec 08             	sub    $0x8,%esp
  800b75:	ff 75 0c             	pushl  0xc(%ebp)
  800b78:	53                   	push   %ebx
  800b79:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7c:	ff d0                	call   *%eax
  800b7e:	83 c4 10             	add    $0x10,%esp
			break;
  800b81:	eb 35                	jmp    800bb8 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b83:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
			break;
  800b8a:	eb 2c                	jmp    800bb8 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b8c:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
			break;
  800b93:	eb 23                	jmp    800bb8 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b95:	83 ec 08             	sub    $0x8,%esp
  800b98:	ff 75 0c             	pushl  0xc(%ebp)
  800b9b:	6a 25                	push   $0x25
  800b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba0:	ff d0                	call   *%eax
  800ba2:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ba5:	ff 4d 10             	decl   0x10(%ebp)
  800ba8:	eb 03                	jmp    800bad <vprintfmt+0x3c3>
  800baa:	ff 4d 10             	decl   0x10(%ebp)
  800bad:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb0:	48                   	dec    %eax
  800bb1:	8a 00                	mov    (%eax),%al
  800bb3:	3c 25                	cmp    $0x25,%al
  800bb5:	75 f3                	jne    800baa <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800bb7:	90                   	nop
		}
	}
  800bb8:	e9 35 fc ff ff       	jmp    8007f2 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bbd:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bbe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bc1:	5b                   	pop    %ebx
  800bc2:	5e                   	pop    %esi
  800bc3:	5d                   	pop    %ebp
  800bc4:	c3                   	ret    

00800bc5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bc5:	55                   	push   %ebp
  800bc6:	89 e5                	mov    %esp,%ebp
  800bc8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bcb:	8d 45 10             	lea    0x10(%ebp),%eax
  800bce:	83 c0 04             	add    $0x4,%eax
  800bd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bd4:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd7:	ff 75 f4             	pushl  -0xc(%ebp)
  800bda:	50                   	push   %eax
  800bdb:	ff 75 0c             	pushl  0xc(%ebp)
  800bde:	ff 75 08             	pushl  0x8(%ebp)
  800be1:	e8 04 fc ff ff       	call   8007ea <vprintfmt>
  800be6:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800be9:	90                   	nop
  800bea:	c9                   	leave  
  800beb:	c3                   	ret    

00800bec <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf2:	8b 40 08             	mov    0x8(%eax),%eax
  800bf5:	8d 50 01             	lea    0x1(%eax),%edx
  800bf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfb:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c01:	8b 10                	mov    (%eax),%edx
  800c03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c06:	8b 40 04             	mov    0x4(%eax),%eax
  800c09:	39 c2                	cmp    %eax,%edx
  800c0b:	73 12                	jae    800c1f <sprintputch+0x33>
		*b->buf++ = ch;
  800c0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c10:	8b 00                	mov    (%eax),%eax
  800c12:	8d 48 01             	lea    0x1(%eax),%ecx
  800c15:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c18:	89 0a                	mov    %ecx,(%edx)
  800c1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1d:	88 10                	mov    %dl,(%eax)
}
  800c1f:	90                   	nop
  800c20:	5d                   	pop    %ebp
  800c21:	c3                   	ret    

00800c22 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c22:	55                   	push   %ebp
  800c23:	89 e5                	mov    %esp,%ebp
  800c25:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c31:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	01 d0                	add    %edx,%eax
  800c39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c3c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c43:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c47:	74 06                	je     800c4f <vsnprintf+0x2d>
  800c49:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c4d:	7f 07                	jg     800c56 <vsnprintf+0x34>
		return -E_INVAL;
  800c4f:	b8 03 00 00 00       	mov    $0x3,%eax
  800c54:	eb 20                	jmp    800c76 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c56:	ff 75 14             	pushl  0x14(%ebp)
  800c59:	ff 75 10             	pushl  0x10(%ebp)
  800c5c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c5f:	50                   	push   %eax
  800c60:	68 ec 0b 80 00       	push   $0x800bec
  800c65:	e8 80 fb ff ff       	call   8007ea <vprintfmt>
  800c6a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c70:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c76:	c9                   	leave  
  800c77:	c3                   	ret    

00800c78 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c78:	55                   	push   %ebp
  800c79:	89 e5                	mov    %esp,%ebp
  800c7b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c7e:	8d 45 10             	lea    0x10(%ebp),%eax
  800c81:	83 c0 04             	add    $0x4,%eax
  800c84:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c87:	8b 45 10             	mov    0x10(%ebp),%eax
  800c8a:	ff 75 f4             	pushl  -0xc(%ebp)
  800c8d:	50                   	push   %eax
  800c8e:	ff 75 0c             	pushl  0xc(%ebp)
  800c91:	ff 75 08             	pushl  0x8(%ebp)
  800c94:	e8 89 ff ff ff       	call   800c22 <vsnprintf>
  800c99:	83 c4 10             	add    $0x10,%esp
  800c9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ca2:	c9                   	leave  
  800ca3:	c3                   	ret    

00800ca4 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
  800ca7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800caa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cb1:	eb 06                	jmp    800cb9 <strlen+0x15>
		n++;
  800cb3:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cb6:	ff 45 08             	incl   0x8(%ebp)
  800cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbc:	8a 00                	mov    (%eax),%al
  800cbe:	84 c0                	test   %al,%al
  800cc0:	75 f1                	jne    800cb3 <strlen+0xf>
		n++;
	return n;
  800cc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cc5:	c9                   	leave  
  800cc6:	c3                   	ret    

00800cc7 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cc7:	55                   	push   %ebp
  800cc8:	89 e5                	mov    %esp,%ebp
  800cca:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ccd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cd4:	eb 09                	jmp    800cdf <strnlen+0x18>
		n++;
  800cd6:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cd9:	ff 45 08             	incl   0x8(%ebp)
  800cdc:	ff 4d 0c             	decl   0xc(%ebp)
  800cdf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ce3:	74 09                	je     800cee <strnlen+0x27>
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	8a 00                	mov    (%eax),%al
  800cea:	84 c0                	test   %al,%al
  800cec:	75 e8                	jne    800cd6 <strnlen+0xf>
		n++;
	return n;
  800cee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cf1:	c9                   	leave  
  800cf2:	c3                   	ret    

00800cf3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cf3:	55                   	push   %ebp
  800cf4:	89 e5                	mov    %esp,%ebp
  800cf6:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cff:	90                   	nop
  800d00:	8b 45 08             	mov    0x8(%ebp),%eax
  800d03:	8d 50 01             	lea    0x1(%eax),%edx
  800d06:	89 55 08             	mov    %edx,0x8(%ebp)
  800d09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d0c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d0f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d12:	8a 12                	mov    (%edx),%dl
  800d14:	88 10                	mov    %dl,(%eax)
  800d16:	8a 00                	mov    (%eax),%al
  800d18:	84 c0                	test   %al,%al
  800d1a:	75 e4                	jne    800d00 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d1f:	c9                   	leave  
  800d20:	c3                   	ret    

00800d21 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d21:	55                   	push   %ebp
  800d22:	89 e5                	mov    %esp,%ebp
  800d24:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d2d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d34:	eb 1f                	jmp    800d55 <strncpy+0x34>
		*dst++ = *src;
  800d36:	8b 45 08             	mov    0x8(%ebp),%eax
  800d39:	8d 50 01             	lea    0x1(%eax),%edx
  800d3c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d42:	8a 12                	mov    (%edx),%dl
  800d44:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d49:	8a 00                	mov    (%eax),%al
  800d4b:	84 c0                	test   %al,%al
  800d4d:	74 03                	je     800d52 <strncpy+0x31>
			src++;
  800d4f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d52:	ff 45 fc             	incl   -0x4(%ebp)
  800d55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d58:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d5b:	72 d9                	jb     800d36 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d5d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d60:	c9                   	leave  
  800d61:	c3                   	ret    

00800d62 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d62:	55                   	push   %ebp
  800d63:	89 e5                	mov    %esp,%ebp
  800d65:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d6e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d72:	74 30                	je     800da4 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d74:	eb 16                	jmp    800d8c <strlcpy+0x2a>
			*dst++ = *src++;
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
  800d79:	8d 50 01             	lea    0x1(%eax),%edx
  800d7c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d82:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d85:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d88:	8a 12                	mov    (%edx),%dl
  800d8a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d8c:	ff 4d 10             	decl   0x10(%ebp)
  800d8f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d93:	74 09                	je     800d9e <strlcpy+0x3c>
  800d95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d98:	8a 00                	mov    (%eax),%al
  800d9a:	84 c0                	test   %al,%al
  800d9c:	75 d8                	jne    800d76 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800da4:	8b 55 08             	mov    0x8(%ebp),%edx
  800da7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800daa:	29 c2                	sub    %eax,%edx
  800dac:	89 d0                	mov    %edx,%eax
}
  800dae:	c9                   	leave  
  800daf:	c3                   	ret    

00800db0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800db0:	55                   	push   %ebp
  800db1:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800db3:	eb 06                	jmp    800dbb <strcmp+0xb>
		p++, q++;
  800db5:	ff 45 08             	incl   0x8(%ebp)
  800db8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	8a 00                	mov    (%eax),%al
  800dc0:	84 c0                	test   %al,%al
  800dc2:	74 0e                	je     800dd2 <strcmp+0x22>
  800dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc7:	8a 10                	mov    (%eax),%dl
  800dc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcc:	8a 00                	mov    (%eax),%al
  800dce:	38 c2                	cmp    %al,%dl
  800dd0:	74 e3                	je     800db5 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd5:	8a 00                	mov    (%eax),%al
  800dd7:	0f b6 d0             	movzbl %al,%edx
  800dda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddd:	8a 00                	mov    (%eax),%al
  800ddf:	0f b6 c0             	movzbl %al,%eax
  800de2:	29 c2                	sub    %eax,%edx
  800de4:	89 d0                	mov    %edx,%eax
}
  800de6:	5d                   	pop    %ebp
  800de7:	c3                   	ret    

00800de8 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800de8:	55                   	push   %ebp
  800de9:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800deb:	eb 09                	jmp    800df6 <strncmp+0xe>
		n--, p++, q++;
  800ded:	ff 4d 10             	decl   0x10(%ebp)
  800df0:	ff 45 08             	incl   0x8(%ebp)
  800df3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800df6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dfa:	74 17                	je     800e13 <strncmp+0x2b>
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8a 00                	mov    (%eax),%al
  800e01:	84 c0                	test   %al,%al
  800e03:	74 0e                	je     800e13 <strncmp+0x2b>
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
  800e08:	8a 10                	mov    (%eax),%dl
  800e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0d:	8a 00                	mov    (%eax),%al
  800e0f:	38 c2                	cmp    %al,%dl
  800e11:	74 da                	je     800ded <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e17:	75 07                	jne    800e20 <strncmp+0x38>
		return 0;
  800e19:	b8 00 00 00 00       	mov    $0x0,%eax
  800e1e:	eb 14                	jmp    800e34 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
  800e23:	8a 00                	mov    (%eax),%al
  800e25:	0f b6 d0             	movzbl %al,%edx
  800e28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2b:	8a 00                	mov    (%eax),%al
  800e2d:	0f b6 c0             	movzbl %al,%eax
  800e30:	29 c2                	sub    %eax,%edx
  800e32:	89 d0                	mov    %edx,%eax
}
  800e34:	5d                   	pop    %ebp
  800e35:	c3                   	ret    

00800e36 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e36:	55                   	push   %ebp
  800e37:	89 e5                	mov    %esp,%ebp
  800e39:	83 ec 04             	sub    $0x4,%esp
  800e3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e42:	eb 12                	jmp    800e56 <strchr+0x20>
		if (*s == c)
  800e44:	8b 45 08             	mov    0x8(%ebp),%eax
  800e47:	8a 00                	mov    (%eax),%al
  800e49:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e4c:	75 05                	jne    800e53 <strchr+0x1d>
			return (char *) s;
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e51:	eb 11                	jmp    800e64 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e53:	ff 45 08             	incl   0x8(%ebp)
  800e56:	8b 45 08             	mov    0x8(%ebp),%eax
  800e59:	8a 00                	mov    (%eax),%al
  800e5b:	84 c0                	test   %al,%al
  800e5d:	75 e5                	jne    800e44 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e64:	c9                   	leave  
  800e65:	c3                   	ret    

00800e66 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e66:	55                   	push   %ebp
  800e67:	89 e5                	mov    %esp,%ebp
  800e69:	83 ec 04             	sub    $0x4,%esp
  800e6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e72:	eb 0d                	jmp    800e81 <strfind+0x1b>
		if (*s == c)
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
  800e77:	8a 00                	mov    (%eax),%al
  800e79:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e7c:	74 0e                	je     800e8c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e7e:	ff 45 08             	incl   0x8(%ebp)
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
  800e84:	8a 00                	mov    (%eax),%al
  800e86:	84 c0                	test   %al,%al
  800e88:	75 ea                	jne    800e74 <strfind+0xe>
  800e8a:	eb 01                	jmp    800e8d <strfind+0x27>
		if (*s == c)
			break;
  800e8c:	90                   	nop
	return (char *) s;
  800e8d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e90:	c9                   	leave  
  800e91:	c3                   	ret    

00800e92 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e92:	55                   	push   %ebp
  800e93:	89 e5                	mov    %esp,%ebp
  800e95:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e98:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e9e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ea2:	76 63                	jbe    800f07 <memset+0x75>
		uint64 data_block = c;
  800ea4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea7:	99                   	cltd   
  800ea8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eab:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800eae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eb1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eb4:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800eb8:	c1 e0 08             	shl    $0x8,%eax
  800ebb:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ebe:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800ec1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ec4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ec7:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800ecb:	c1 e0 10             	shl    $0x10,%eax
  800ece:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ed1:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800ed4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ed7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eda:	89 c2                	mov    %eax,%edx
  800edc:	b8 00 00 00 00       	mov    $0x0,%eax
  800ee1:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ee4:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800ee7:	eb 18                	jmp    800f01 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800ee9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800eec:	8d 41 08             	lea    0x8(%ecx),%eax
  800eef:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800ef2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ef5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ef8:	89 01                	mov    %eax,(%ecx)
  800efa:	89 51 04             	mov    %edx,0x4(%ecx)
  800efd:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800f01:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f05:	77 e2                	ja     800ee9 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800f07:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f0b:	74 23                	je     800f30 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800f0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f10:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f13:	eb 0e                	jmp    800f23 <memset+0x91>
			*p8++ = (uint8)c;
  800f15:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f18:	8d 50 01             	lea    0x1(%eax),%edx
  800f1b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f21:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800f23:	8b 45 10             	mov    0x10(%ebp),%eax
  800f26:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f29:	89 55 10             	mov    %edx,0x10(%ebp)
  800f2c:	85 c0                	test   %eax,%eax
  800f2e:	75 e5                	jne    800f15 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f30:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f33:	c9                   	leave  
  800f34:	c3                   	ret    

00800f35 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f35:	55                   	push   %ebp
  800f36:	89 e5                	mov    %esp,%ebp
  800f38:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
  800f44:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f47:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f4b:	76 24                	jbe    800f71 <memcpy+0x3c>
		while(n >= 8){
  800f4d:	eb 1c                	jmp    800f6b <memcpy+0x36>
			*d64 = *s64;
  800f4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f52:	8b 50 04             	mov    0x4(%eax),%edx
  800f55:	8b 00                	mov    (%eax),%eax
  800f57:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f5a:	89 01                	mov    %eax,(%ecx)
  800f5c:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f5f:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f63:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f67:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f6b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f6f:	77 de                	ja     800f4f <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f71:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f75:	74 31                	je     800fa8 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f80:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f83:	eb 16                	jmp    800f9b <memcpy+0x66>
			*d8++ = *s8++;
  800f85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f88:	8d 50 01             	lea    0x1(%eax),%edx
  800f8b:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f91:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f94:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f97:	8a 12                	mov    (%edx),%dl
  800f99:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fa1:	89 55 10             	mov    %edx,0x10(%ebp)
  800fa4:	85 c0                	test   %eax,%eax
  800fa6:	75 dd                	jne    800f85 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fab:	c9                   	leave  
  800fac:	c3                   	ret    

00800fad <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800fad:	55                   	push   %ebp
  800fae:	89 e5                	mov    %esp,%ebp
  800fb0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fc5:	73 50                	jae    801017 <memmove+0x6a>
  800fc7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fca:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcd:	01 d0                	add    %edx,%eax
  800fcf:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fd2:	76 43                	jbe    801017 <memmove+0x6a>
		s += n;
  800fd4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd7:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fda:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdd:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fe0:	eb 10                	jmp    800ff2 <memmove+0x45>
			*--d = *--s;
  800fe2:	ff 4d f8             	decl   -0x8(%ebp)
  800fe5:	ff 4d fc             	decl   -0x4(%ebp)
  800fe8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800feb:	8a 10                	mov    (%eax),%dl
  800fed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff0:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ff2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ff8:	89 55 10             	mov    %edx,0x10(%ebp)
  800ffb:	85 c0                	test   %eax,%eax
  800ffd:	75 e3                	jne    800fe2 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fff:	eb 23                	jmp    801024 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801001:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801004:	8d 50 01             	lea    0x1(%eax),%edx
  801007:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80100a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80100d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801010:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801013:	8a 12                	mov    (%edx),%dl
  801015:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801017:	8b 45 10             	mov    0x10(%ebp),%eax
  80101a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80101d:	89 55 10             	mov    %edx,0x10(%ebp)
  801020:	85 c0                	test   %eax,%eax
  801022:	75 dd                	jne    801001 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801024:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801027:	c9                   	leave  
  801028:	c3                   	ret    

00801029 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801029:	55                   	push   %ebp
  80102a:	89 e5                	mov    %esp,%ebp
  80102c:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801035:	8b 45 0c             	mov    0xc(%ebp),%eax
  801038:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80103b:	eb 2a                	jmp    801067 <memcmp+0x3e>
		if (*s1 != *s2)
  80103d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801040:	8a 10                	mov    (%eax),%dl
  801042:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801045:	8a 00                	mov    (%eax),%al
  801047:	38 c2                	cmp    %al,%dl
  801049:	74 16                	je     801061 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80104b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80104e:	8a 00                	mov    (%eax),%al
  801050:	0f b6 d0             	movzbl %al,%edx
  801053:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801056:	8a 00                	mov    (%eax),%al
  801058:	0f b6 c0             	movzbl %al,%eax
  80105b:	29 c2                	sub    %eax,%edx
  80105d:	89 d0                	mov    %edx,%eax
  80105f:	eb 18                	jmp    801079 <memcmp+0x50>
		s1++, s2++;
  801061:	ff 45 fc             	incl   -0x4(%ebp)
  801064:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801067:	8b 45 10             	mov    0x10(%ebp),%eax
  80106a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80106d:	89 55 10             	mov    %edx,0x10(%ebp)
  801070:	85 c0                	test   %eax,%eax
  801072:	75 c9                	jne    80103d <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801074:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801079:	c9                   	leave  
  80107a:	c3                   	ret    

0080107b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80107b:	55                   	push   %ebp
  80107c:	89 e5                	mov    %esp,%ebp
  80107e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801081:	8b 55 08             	mov    0x8(%ebp),%edx
  801084:	8b 45 10             	mov    0x10(%ebp),%eax
  801087:	01 d0                	add    %edx,%eax
  801089:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80108c:	eb 15                	jmp    8010a3 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80108e:	8b 45 08             	mov    0x8(%ebp),%eax
  801091:	8a 00                	mov    (%eax),%al
  801093:	0f b6 d0             	movzbl %al,%edx
  801096:	8b 45 0c             	mov    0xc(%ebp),%eax
  801099:	0f b6 c0             	movzbl %al,%eax
  80109c:	39 c2                	cmp    %eax,%edx
  80109e:	74 0d                	je     8010ad <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8010a0:	ff 45 08             	incl   0x8(%ebp)
  8010a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8010a9:	72 e3                	jb     80108e <memfind+0x13>
  8010ab:	eb 01                	jmp    8010ae <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8010ad:	90                   	nop
	return (void *) s;
  8010ae:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010b1:	c9                   	leave  
  8010b2:	c3                   	ret    

008010b3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010b3:	55                   	push   %ebp
  8010b4:	89 e5                	mov    %esp,%ebp
  8010b6:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010c0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010c7:	eb 03                	jmp    8010cc <strtol+0x19>
		s++;
  8010c9:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cf:	8a 00                	mov    (%eax),%al
  8010d1:	3c 20                	cmp    $0x20,%al
  8010d3:	74 f4                	je     8010c9 <strtol+0x16>
  8010d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d8:	8a 00                	mov    (%eax),%al
  8010da:	3c 09                	cmp    $0x9,%al
  8010dc:	74 eb                	je     8010c9 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010de:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e1:	8a 00                	mov    (%eax),%al
  8010e3:	3c 2b                	cmp    $0x2b,%al
  8010e5:	75 05                	jne    8010ec <strtol+0x39>
		s++;
  8010e7:	ff 45 08             	incl   0x8(%ebp)
  8010ea:	eb 13                	jmp    8010ff <strtol+0x4c>
	else if (*s == '-')
  8010ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ef:	8a 00                	mov    (%eax),%al
  8010f1:	3c 2d                	cmp    $0x2d,%al
  8010f3:	75 0a                	jne    8010ff <strtol+0x4c>
		s++, neg = 1;
  8010f5:	ff 45 08             	incl   0x8(%ebp)
  8010f8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801103:	74 06                	je     80110b <strtol+0x58>
  801105:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801109:	75 20                	jne    80112b <strtol+0x78>
  80110b:	8b 45 08             	mov    0x8(%ebp),%eax
  80110e:	8a 00                	mov    (%eax),%al
  801110:	3c 30                	cmp    $0x30,%al
  801112:	75 17                	jne    80112b <strtol+0x78>
  801114:	8b 45 08             	mov    0x8(%ebp),%eax
  801117:	40                   	inc    %eax
  801118:	8a 00                	mov    (%eax),%al
  80111a:	3c 78                	cmp    $0x78,%al
  80111c:	75 0d                	jne    80112b <strtol+0x78>
		s += 2, base = 16;
  80111e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801122:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801129:	eb 28                	jmp    801153 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80112b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80112f:	75 15                	jne    801146 <strtol+0x93>
  801131:	8b 45 08             	mov    0x8(%ebp),%eax
  801134:	8a 00                	mov    (%eax),%al
  801136:	3c 30                	cmp    $0x30,%al
  801138:	75 0c                	jne    801146 <strtol+0x93>
		s++, base = 8;
  80113a:	ff 45 08             	incl   0x8(%ebp)
  80113d:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801144:	eb 0d                	jmp    801153 <strtol+0xa0>
	else if (base == 0)
  801146:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80114a:	75 07                	jne    801153 <strtol+0xa0>
		base = 10;
  80114c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801153:	8b 45 08             	mov    0x8(%ebp),%eax
  801156:	8a 00                	mov    (%eax),%al
  801158:	3c 2f                	cmp    $0x2f,%al
  80115a:	7e 19                	jle    801175 <strtol+0xc2>
  80115c:	8b 45 08             	mov    0x8(%ebp),%eax
  80115f:	8a 00                	mov    (%eax),%al
  801161:	3c 39                	cmp    $0x39,%al
  801163:	7f 10                	jg     801175 <strtol+0xc2>
			dig = *s - '0';
  801165:	8b 45 08             	mov    0x8(%ebp),%eax
  801168:	8a 00                	mov    (%eax),%al
  80116a:	0f be c0             	movsbl %al,%eax
  80116d:	83 e8 30             	sub    $0x30,%eax
  801170:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801173:	eb 42                	jmp    8011b7 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801175:	8b 45 08             	mov    0x8(%ebp),%eax
  801178:	8a 00                	mov    (%eax),%al
  80117a:	3c 60                	cmp    $0x60,%al
  80117c:	7e 19                	jle    801197 <strtol+0xe4>
  80117e:	8b 45 08             	mov    0x8(%ebp),%eax
  801181:	8a 00                	mov    (%eax),%al
  801183:	3c 7a                	cmp    $0x7a,%al
  801185:	7f 10                	jg     801197 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801187:	8b 45 08             	mov    0x8(%ebp),%eax
  80118a:	8a 00                	mov    (%eax),%al
  80118c:	0f be c0             	movsbl %al,%eax
  80118f:	83 e8 57             	sub    $0x57,%eax
  801192:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801195:	eb 20                	jmp    8011b7 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801197:	8b 45 08             	mov    0x8(%ebp),%eax
  80119a:	8a 00                	mov    (%eax),%al
  80119c:	3c 40                	cmp    $0x40,%al
  80119e:	7e 39                	jle    8011d9 <strtol+0x126>
  8011a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a3:	8a 00                	mov    (%eax),%al
  8011a5:	3c 5a                	cmp    $0x5a,%al
  8011a7:	7f 30                	jg     8011d9 <strtol+0x126>
			dig = *s - 'A' + 10;
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ac:	8a 00                	mov    (%eax),%al
  8011ae:	0f be c0             	movsbl %al,%eax
  8011b1:	83 e8 37             	sub    $0x37,%eax
  8011b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ba:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011bd:	7d 19                	jge    8011d8 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011bf:	ff 45 08             	incl   0x8(%ebp)
  8011c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c5:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011c9:	89 c2                	mov    %eax,%edx
  8011cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ce:	01 d0                	add    %edx,%eax
  8011d0:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011d3:	e9 7b ff ff ff       	jmp    801153 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011d8:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011d9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011dd:	74 08                	je     8011e7 <strtol+0x134>
		*endptr = (char *) s;
  8011df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e5:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011eb:	74 07                	je     8011f4 <strtol+0x141>
  8011ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f0:	f7 d8                	neg    %eax
  8011f2:	eb 03                	jmp    8011f7 <strtol+0x144>
  8011f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011f7:	c9                   	leave  
  8011f8:	c3                   	ret    

008011f9 <ltostr>:

void
ltostr(long value, char *str)
{
  8011f9:	55                   	push   %ebp
  8011fa:	89 e5                	mov    %esp,%ebp
  8011fc:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801206:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80120d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801211:	79 13                	jns    801226 <ltostr+0x2d>
	{
		neg = 1;
  801213:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80121a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121d:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801220:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801223:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80122e:	99                   	cltd   
  80122f:	f7 f9                	idiv   %ecx
  801231:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801234:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801237:	8d 50 01             	lea    0x1(%eax),%edx
  80123a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80123d:	89 c2                	mov    %eax,%edx
  80123f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801242:	01 d0                	add    %edx,%eax
  801244:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801247:	83 c2 30             	add    $0x30,%edx
  80124a:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80124c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80124f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801254:	f7 e9                	imul   %ecx
  801256:	c1 fa 02             	sar    $0x2,%edx
  801259:	89 c8                	mov    %ecx,%eax
  80125b:	c1 f8 1f             	sar    $0x1f,%eax
  80125e:	29 c2                	sub    %eax,%edx
  801260:	89 d0                	mov    %edx,%eax
  801262:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801265:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801269:	75 bb                	jne    801226 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80126b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801272:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801275:	48                   	dec    %eax
  801276:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801279:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80127d:	74 3d                	je     8012bc <ltostr+0xc3>
		start = 1 ;
  80127f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801286:	eb 34                	jmp    8012bc <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801288:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80128b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128e:	01 d0                	add    %edx,%eax
  801290:	8a 00                	mov    (%eax),%al
  801292:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801295:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129b:	01 c2                	add    %eax,%edx
  80129d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8012a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a3:	01 c8                	add    %ecx,%eax
  8012a5:	8a 00                	mov    (%eax),%al
  8012a7:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012af:	01 c2                	add    %eax,%edx
  8012b1:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012b4:	88 02                	mov    %al,(%edx)
		start++ ;
  8012b6:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012b9:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012bf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012c2:	7c c4                	jl     801288 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012c4:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ca:	01 d0                	add    %edx,%eax
  8012cc:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012cf:	90                   	nop
  8012d0:	c9                   	leave  
  8012d1:	c3                   	ret    

008012d2 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012d2:	55                   	push   %ebp
  8012d3:	89 e5                	mov    %esp,%ebp
  8012d5:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012d8:	ff 75 08             	pushl  0x8(%ebp)
  8012db:	e8 c4 f9 ff ff       	call   800ca4 <strlen>
  8012e0:	83 c4 04             	add    $0x4,%esp
  8012e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012e6:	ff 75 0c             	pushl  0xc(%ebp)
  8012e9:	e8 b6 f9 ff ff       	call   800ca4 <strlen>
  8012ee:	83 c4 04             	add    $0x4,%esp
  8012f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801302:	eb 17                	jmp    80131b <strcconcat+0x49>
		final[s] = str1[s] ;
  801304:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801307:	8b 45 10             	mov    0x10(%ebp),%eax
  80130a:	01 c2                	add    %eax,%edx
  80130c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80130f:	8b 45 08             	mov    0x8(%ebp),%eax
  801312:	01 c8                	add    %ecx,%eax
  801314:	8a 00                	mov    (%eax),%al
  801316:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801318:	ff 45 fc             	incl   -0x4(%ebp)
  80131b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80131e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801321:	7c e1                	jl     801304 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801323:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80132a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801331:	eb 1f                	jmp    801352 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801333:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801336:	8d 50 01             	lea    0x1(%eax),%edx
  801339:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80133c:	89 c2                	mov    %eax,%edx
  80133e:	8b 45 10             	mov    0x10(%ebp),%eax
  801341:	01 c2                	add    %eax,%edx
  801343:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801346:	8b 45 0c             	mov    0xc(%ebp),%eax
  801349:	01 c8                	add    %ecx,%eax
  80134b:	8a 00                	mov    (%eax),%al
  80134d:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80134f:	ff 45 f8             	incl   -0x8(%ebp)
  801352:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801355:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801358:	7c d9                	jl     801333 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80135a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80135d:	8b 45 10             	mov    0x10(%ebp),%eax
  801360:	01 d0                	add    %edx,%eax
  801362:	c6 00 00             	movb   $0x0,(%eax)
}
  801365:	90                   	nop
  801366:	c9                   	leave  
  801367:	c3                   	ret    

00801368 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801368:	55                   	push   %ebp
  801369:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80136b:	8b 45 14             	mov    0x14(%ebp),%eax
  80136e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801374:	8b 45 14             	mov    0x14(%ebp),%eax
  801377:	8b 00                	mov    (%eax),%eax
  801379:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801380:	8b 45 10             	mov    0x10(%ebp),%eax
  801383:	01 d0                	add    %edx,%eax
  801385:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80138b:	eb 0c                	jmp    801399 <strsplit+0x31>
			*string++ = 0;
  80138d:	8b 45 08             	mov    0x8(%ebp),%eax
  801390:	8d 50 01             	lea    0x1(%eax),%edx
  801393:	89 55 08             	mov    %edx,0x8(%ebp)
  801396:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801399:	8b 45 08             	mov    0x8(%ebp),%eax
  80139c:	8a 00                	mov    (%eax),%al
  80139e:	84 c0                	test   %al,%al
  8013a0:	74 18                	je     8013ba <strsplit+0x52>
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a5:	8a 00                	mov    (%eax),%al
  8013a7:	0f be c0             	movsbl %al,%eax
  8013aa:	50                   	push   %eax
  8013ab:	ff 75 0c             	pushl  0xc(%ebp)
  8013ae:	e8 83 fa ff ff       	call   800e36 <strchr>
  8013b3:	83 c4 08             	add    $0x8,%esp
  8013b6:	85 c0                	test   %eax,%eax
  8013b8:	75 d3                	jne    80138d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bd:	8a 00                	mov    (%eax),%al
  8013bf:	84 c0                	test   %al,%al
  8013c1:	74 5a                	je     80141d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c6:	8b 00                	mov    (%eax),%eax
  8013c8:	83 f8 0f             	cmp    $0xf,%eax
  8013cb:	75 07                	jne    8013d4 <strsplit+0x6c>
		{
			return 0;
  8013cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8013d2:	eb 66                	jmp    80143a <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8013d7:	8b 00                	mov    (%eax),%eax
  8013d9:	8d 48 01             	lea    0x1(%eax),%ecx
  8013dc:	8b 55 14             	mov    0x14(%ebp),%edx
  8013df:	89 0a                	mov    %ecx,(%edx)
  8013e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8013eb:	01 c2                	add    %eax,%edx
  8013ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f0:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013f2:	eb 03                	jmp    8013f7 <strsplit+0x8f>
			string++;
  8013f4:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fa:	8a 00                	mov    (%eax),%al
  8013fc:	84 c0                	test   %al,%al
  8013fe:	74 8b                	je     80138b <strsplit+0x23>
  801400:	8b 45 08             	mov    0x8(%ebp),%eax
  801403:	8a 00                	mov    (%eax),%al
  801405:	0f be c0             	movsbl %al,%eax
  801408:	50                   	push   %eax
  801409:	ff 75 0c             	pushl  0xc(%ebp)
  80140c:	e8 25 fa ff ff       	call   800e36 <strchr>
  801411:	83 c4 08             	add    $0x8,%esp
  801414:	85 c0                	test   %eax,%eax
  801416:	74 dc                	je     8013f4 <strsplit+0x8c>
			string++;
	}
  801418:	e9 6e ff ff ff       	jmp    80138b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80141d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80141e:	8b 45 14             	mov    0x14(%ebp),%eax
  801421:	8b 00                	mov    (%eax),%eax
  801423:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80142a:	8b 45 10             	mov    0x10(%ebp),%eax
  80142d:	01 d0                	add    %edx,%eax
  80142f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801435:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80143a:	c9                   	leave  
  80143b:	c3                   	ret    

0080143c <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80143c:	55                   	push   %ebp
  80143d:	89 e5                	mov    %esp,%ebp
  80143f:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
  801445:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801448:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80144f:	eb 4a                	jmp    80149b <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801451:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801454:	8b 45 08             	mov    0x8(%ebp),%eax
  801457:	01 c2                	add    %eax,%edx
  801459:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80145c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145f:	01 c8                	add    %ecx,%eax
  801461:	8a 00                	mov    (%eax),%al
  801463:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801465:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801468:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146b:	01 d0                	add    %edx,%eax
  80146d:	8a 00                	mov    (%eax),%al
  80146f:	3c 40                	cmp    $0x40,%al
  801471:	7e 25                	jle    801498 <str2lower+0x5c>
  801473:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801476:	8b 45 0c             	mov    0xc(%ebp),%eax
  801479:	01 d0                	add    %edx,%eax
  80147b:	8a 00                	mov    (%eax),%al
  80147d:	3c 5a                	cmp    $0x5a,%al
  80147f:	7f 17                	jg     801498 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801481:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801484:	8b 45 08             	mov    0x8(%ebp),%eax
  801487:	01 d0                	add    %edx,%eax
  801489:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80148c:	8b 55 08             	mov    0x8(%ebp),%edx
  80148f:	01 ca                	add    %ecx,%edx
  801491:	8a 12                	mov    (%edx),%dl
  801493:	83 c2 20             	add    $0x20,%edx
  801496:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801498:	ff 45 fc             	incl   -0x4(%ebp)
  80149b:	ff 75 0c             	pushl  0xc(%ebp)
  80149e:	e8 01 f8 ff ff       	call   800ca4 <strlen>
  8014a3:	83 c4 04             	add    $0x4,%esp
  8014a6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8014a9:	7f a6                	jg     801451 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8014ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014ae:	c9                   	leave  
  8014af:	c3                   	ret    

008014b0 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8014b0:	55                   	push   %ebp
  8014b1:	89 e5                	mov    %esp,%ebp
  8014b3:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8014b6:	a1 08 50 80 00       	mov    0x805008,%eax
  8014bb:	85 c0                	test   %eax,%eax
  8014bd:	74 42                	je     801501 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8014bf:	83 ec 08             	sub    $0x8,%esp
  8014c2:	68 00 00 00 82       	push   $0x82000000
  8014c7:	68 00 00 00 80       	push   $0x80000000
  8014cc:	e8 b0 1e 00 00       	call   803381 <initialize_dynamic_allocator>
  8014d1:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  8014d4:	e8 96 1c 00 00       	call   80316f <sys_get_uheap_strategy>
  8014d9:	a3 80 50 83 00       	mov    %eax,0x835080
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  8014de:	a1 60 d0 81 00       	mov    0x81d060,%eax
  8014e3:	05 00 10 00 00       	add    $0x1000,%eax
  8014e8:	a3 30 51 83 00       	mov    %eax,0x835130
		uheapPageAllocBreak = uheapPageAllocStart;
  8014ed:	a1 30 51 83 00       	mov    0x835130,%eax
  8014f2:	a3 88 50 83 00       	mov    %eax,0x835088

		__firstTimeFlag = 0;
  8014f7:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8014fe:	00 00 00 
	}
}
  801501:	90                   	nop
  801502:	c9                   	leave  
  801503:	c3                   	ret    

00801504 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801504:	55                   	push   %ebp
  801505:	89 e5                	mov    %esp,%ebp
  801507:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  80150a:	8b 45 08             	mov    0x8(%ebp),%eax
  80150d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801510:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801513:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801518:	83 ec 08             	sub    $0x8,%esp
  80151b:	68 06 04 00 00       	push   $0x406
  801520:	50                   	push   %eax
  801521:	e8 93 18 00 00       	call   802db9 <__sys_allocate_page>
  801526:	83 c4 10             	add    $0x10,%esp
  801529:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80152c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801530:	79 14                	jns    801546 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801532:	83 ec 04             	sub    $0x4,%esp
  801535:	68 c8 47 80 00       	push   $0x8047c8
  80153a:	6a 1f                	push   $0x1f
  80153c:	68 04 48 80 00       	push   $0x804804
  801541:	e8 b7 ed ff ff       	call   8002fd <_panic>
	return 0;
  801546:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80154b:	c9                   	leave  
  80154c:	c3                   	ret    

0080154d <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  80154d:	55                   	push   %ebp
  80154e:	89 e5                	mov    %esp,%ebp
  801550:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801553:	8b 45 08             	mov    0x8(%ebp),%eax
  801556:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80155c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801561:	83 ec 0c             	sub    $0xc,%esp
  801564:	50                   	push   %eax
  801565:	e8 96 18 00 00       	call   802e00 <__sys_unmap_frame>
  80156a:	83 c4 10             	add    $0x10,%esp
  80156d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801570:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801574:	79 14                	jns    80158a <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801576:	83 ec 04             	sub    $0x4,%esp
  801579:	68 10 48 80 00       	push   $0x804810
  80157e:	6a 2a                	push   $0x2a
  801580:	68 04 48 80 00       	push   $0x804804
  801585:	e8 73 ed ff ff       	call   8002fd <_panic>
}
  80158a:	90                   	nop
  80158b:	c9                   	leave  
  80158c:	c3                   	ret    

0080158d <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  80158d:	55                   	push   %ebp
  80158e:	89 e5                	mov    %esp,%ebp
  801590:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801593:	e8 18 ff ff ff       	call   8014b0 <uheap_init>
	if (size == 0) return NULL ;
  801598:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80159c:	75 0a                	jne    8015a8 <malloc+0x1b>
  80159e:	b8 00 00 00 00       	mov    $0x0,%eax
  8015a3:	e9 43 03 00 00       	jmp    8018eb <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  8015a8:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8015af:	77 13                	ja     8015c4 <malloc+0x37>
    {
        return alloc_block(size);
  8015b1:	83 ec 0c             	sub    $0xc,%esp
  8015b4:	ff 75 08             	pushl  0x8(%ebp)
  8015b7:	e8 78 20 00 00       	call   803634 <alloc_block>
  8015bc:	83 c4 10             	add    $0x10,%esp
  8015bf:	e9 27 03 00 00       	jmp    8018eb <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  8015c4:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  8015cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8015ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015d1:	01 d0                	add    %edx,%eax
  8015d3:	48                   	dec    %eax
  8015d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8015d7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015da:	ba 00 00 00 00       	mov    $0x0,%edx
  8015df:	f7 75 dc             	divl   -0x24(%ebp)
  8015e2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015e5:	29 d0                	sub    %edx,%eax
  8015e7:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  8015ea:	a1 40 d0 81 00       	mov    0x81d040,%eax
  8015ef:	85 c0                	test   %eax,%eax
  8015f1:	75 0a                	jne    8015fd <malloc+0x70>
    {
        uhp_inited = 1;
  8015f3:	c7 05 40 d0 81 00 01 	movl   $0x1,0x81d040
  8015fa:	00 00 00 
    }

    int exactIdx = -1;
  8015fd:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801604:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  80160b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801612:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801619:	e9 85 00 00 00       	jmp    8016a3 <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  80161e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801621:	89 d0                	mov    %edx,%eax
  801623:	01 c0                	add    %eax,%eax
  801625:	01 d0                	add    %edx,%eax
  801627:	c1 e0 02             	shl    $0x2,%eax
  80162a:	05 48 10 81 00       	add    $0x811048,%eax
  80162f:	8a 00                	mov    (%eax),%al
  801631:	84 c0                	test   %al,%al
  801633:	74 20                	je     801655 <malloc+0xc8>
  801635:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801638:	89 d0                	mov    %edx,%eax
  80163a:	01 c0                	add    %eax,%eax
  80163c:	01 d0                	add    %edx,%eax
  80163e:	c1 e0 02             	shl    $0x2,%eax
  801641:	05 44 10 81 00       	add    $0x811044,%eax
  801646:	8b 00                	mov    (%eax),%eax
  801648:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80164b:	75 08                	jne    801655 <malloc+0xc8>
        {
            exactIdx = i;
  80164d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801650:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801653:	eb 5b                	jmp    8016b0 <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801655:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801658:	89 d0                	mov    %edx,%eax
  80165a:	01 c0                	add    %eax,%eax
  80165c:	01 d0                	add    %edx,%eax
  80165e:	c1 e0 02             	shl    $0x2,%eax
  801661:	05 48 10 81 00       	add    $0x811048,%eax
  801666:	8a 00                	mov    (%eax),%al
  801668:	84 c0                	test   %al,%al
  80166a:	74 34                	je     8016a0 <malloc+0x113>
  80166c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80166f:	89 d0                	mov    %edx,%eax
  801671:	01 c0                	add    %eax,%eax
  801673:	01 d0                	add    %edx,%eax
  801675:	c1 e0 02             	shl    $0x2,%eax
  801678:	05 44 10 81 00       	add    $0x811044,%eax
  80167d:	8b 00                	mov    (%eax),%eax
  80167f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801682:	76 1c                	jbe    8016a0 <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  801684:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801687:	89 d0                	mov    %edx,%eax
  801689:	01 c0                	add    %eax,%eax
  80168b:	01 d0                	add    %edx,%eax
  80168d:	c1 e0 02             	shl    $0x2,%eax
  801690:	05 44 10 81 00       	add    $0x811044,%eax
  801695:	8b 00                	mov    (%eax),%eax
  801697:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  80169a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80169d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8016a0:	ff 45 e8             	incl   -0x18(%ebp)
  8016a3:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8016aa:	0f 8e 6e ff ff ff    	jle    80161e <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  8016b0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  8016b7:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8016bb:	74 7d                	je     80173a <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  8016bd:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  8016c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016c7:	89 d0                	mov    %edx,%eax
  8016c9:	01 c0                	add    %eax,%eax
  8016cb:	01 d0                	add    %edx,%eax
  8016cd:	c1 e0 02             	shl    $0x2,%eax
  8016d0:	05 40 10 81 00       	add    $0x811040,%eax
  8016d5:	8b 10                	mov    (%eax),%edx
  8016d7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8016da:	01 d0                	add    %edx,%eax
  8016dc:	48                   	dec    %eax
  8016dd:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8016e0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8016e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e8:	f7 75 bc             	divl   -0x44(%ebp)
  8016eb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8016ee:	29 d0                	sub    %edx,%eax
  8016f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  8016f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016f6:	89 d0                	mov    %edx,%eax
  8016f8:	01 c0                	add    %eax,%eax
  8016fa:	01 d0                	add    %edx,%eax
  8016fc:	c1 e0 02             	shl    $0x2,%eax
  8016ff:	05 48 10 81 00       	add    $0x811048,%eax
  801704:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801707:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80170a:	89 d0                	mov    %edx,%eax
  80170c:	01 c0                	add    %eax,%eax
  80170e:	01 d0                	add    %edx,%eax
  801710:	c1 e0 02             	shl    $0x2,%eax
  801713:	05 44 10 81 00       	add    $0x811044,%eax
  801718:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  80171e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801721:	89 d0                	mov    %edx,%eax
  801723:	01 c0                	add    %eax,%eax
  801725:	01 d0                	add    %edx,%eax
  801727:	c1 e0 02             	shl    $0x2,%eax
  80172a:	05 40 10 81 00       	add    $0x811040,%eax
  80172f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801735:	e9 2d 01 00 00       	jmp    801867 <malloc+0x2da>
    }
    else if (worstIdx != -1)
  80173a:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80173e:	0f 84 ce 00 00 00    	je     801812 <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  801744:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80174b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80174e:	89 d0                	mov    %edx,%eax
  801750:	01 c0                	add    %eax,%eax
  801752:	01 d0                	add    %edx,%eax
  801754:	c1 e0 02             	shl    $0x2,%eax
  801757:	05 40 10 81 00       	add    $0x811040,%eax
  80175c:	8b 10                	mov    (%eax),%edx
  80175e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801761:	01 d0                	add    %edx,%eax
  801763:	48                   	dec    %eax
  801764:	89 45 c0             	mov    %eax,-0x40(%ebp)
  801767:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80176a:	ba 00 00 00 00       	mov    $0x0,%edx
  80176f:	f7 75 c4             	divl   -0x3c(%ebp)
  801772:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801775:	29 d0                	sub    %edx,%eax
  801777:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  80177a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80177d:	89 d0                	mov    %edx,%eax
  80177f:	01 c0                	add    %eax,%eax
  801781:	01 d0                	add    %edx,%eax
  801783:	c1 e0 02             	shl    $0x2,%eax
  801786:	05 44 10 81 00       	add    $0x811044,%eax
  80178b:	8b 00                	mov    (%eax),%eax
  80178d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801790:	75 47                	jne    8017d9 <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  801792:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801795:	89 d0                	mov    %edx,%eax
  801797:	01 c0                	add    %eax,%eax
  801799:	01 d0                	add    %edx,%eax
  80179b:	c1 e0 02             	shl    $0x2,%eax
  80179e:	05 48 10 81 00       	add    $0x811048,%eax
  8017a3:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  8017a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017a9:	89 d0                	mov    %edx,%eax
  8017ab:	01 c0                	add    %eax,%eax
  8017ad:	01 d0                	add    %edx,%eax
  8017af:	c1 e0 02             	shl    $0x2,%eax
  8017b2:	05 44 10 81 00       	add    $0x811044,%eax
  8017b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  8017bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017c0:	89 d0                	mov    %edx,%eax
  8017c2:	01 c0                	add    %eax,%eax
  8017c4:	01 d0                	add    %edx,%eax
  8017c6:	c1 e0 02             	shl    $0x2,%eax
  8017c9:	05 40 10 81 00       	add    $0x811040,%eax
  8017ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8017d4:	e9 8e 00 00 00       	jmp    801867 <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  8017d9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8017dc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8017df:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8017e2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017e5:	89 d0                	mov    %edx,%eax
  8017e7:	01 c0                	add    %eax,%eax
  8017e9:	01 d0                	add    %edx,%eax
  8017eb:	c1 e0 02             	shl    $0x2,%eax
  8017ee:	05 40 10 81 00       	add    $0x811040,%eax
  8017f3:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  8017f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017f8:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8017fb:	89 c2                	mov    %eax,%edx
  8017fd:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801800:	89 c8                	mov    %ecx,%eax
  801802:	01 c0                	add    %eax,%eax
  801804:	01 c8                	add    %ecx,%eax
  801806:	c1 e0 02             	shl    $0x2,%eax
  801809:	05 44 10 81 00       	add    $0x811044,%eax
  80180e:	89 10                	mov    %edx,(%eax)
  801810:	eb 55                	jmp    801867 <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  801812:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801819:	8b 15 88 50 83 00    	mov    0x835088,%edx
  80181f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801822:	01 d0                	add    %edx,%eax
  801824:	48                   	dec    %eax
  801825:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801828:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80182b:	ba 00 00 00 00       	mov    $0x0,%edx
  801830:	f7 75 d0             	divl   -0x30(%ebp)
  801833:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801836:	29 d0                	sub    %edx,%eax
  801838:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  80183b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80183e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801841:	01 d0                	add    %edx,%eax
  801843:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801848:	76 0a                	jbe    801854 <malloc+0x2c7>
            return NULL;
  80184a:	b8 00 00 00 00       	mov    $0x0,%eax
  80184f:	e9 97 00 00 00       	jmp    8018eb <malloc+0x35e>
        va = start;
  801854:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801857:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  80185a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80185d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801860:	01 d0                	add    %edx,%eax
  801862:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801867:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80186e:	eb 5e                	jmp    8018ce <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  801870:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801873:	89 d0                	mov    %edx,%eax
  801875:	01 c0                	add    %eax,%eax
  801877:	01 d0                	add    %edx,%eax
  801879:	c1 e0 02             	shl    $0x2,%eax
  80187c:	05 48 50 80 00       	add    $0x805048,%eax
  801881:	8a 00                	mov    (%eax),%al
  801883:	84 c0                	test   %al,%al
  801885:	75 44                	jne    8018cb <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  801887:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80188a:	89 d0                	mov    %edx,%eax
  80188c:	01 c0                	add    %eax,%eax
  80188e:	01 d0                	add    %edx,%eax
  801890:	c1 e0 02             	shl    $0x2,%eax
  801893:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  801899:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80189c:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  80189e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018a1:	89 d0                	mov    %edx,%eax
  8018a3:	01 c0                	add    %eax,%eax
  8018a5:	01 d0                	add    %edx,%eax
  8018a7:	c1 e0 02             	shl    $0x2,%eax
  8018aa:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8018b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8018b3:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  8018b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018b8:	89 d0                	mov    %edx,%eax
  8018ba:	01 c0                	add    %eax,%eax
  8018bc:	01 d0                	add    %edx,%eax
  8018be:	c1 e0 02             	shl    $0x2,%eax
  8018c1:	05 48 50 80 00       	add    $0x805048,%eax
  8018c6:	c6 00 01             	movb   $0x1,(%eax)
            break;
  8018c9:	eb 0c                	jmp    8018d7 <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8018cb:	ff 45 e0             	incl   -0x20(%ebp)
  8018ce:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8018d5:	7e 99                	jle    801870 <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  8018d7:	83 ec 08             	sub    $0x8,%esp
  8018da:	ff 75 d4             	pushl  -0x2c(%ebp)
  8018dd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018e0:	e8 a2 19 00 00       	call   803287 <sys_allocate_user_mem>
  8018e5:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  8018e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8018eb:	c9                   	leave  
  8018ec:	c3                   	ret    

008018ed <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
  8018f0:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  8018f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018f7:	0f 84 fa 03 00 00    	je     801cf7 <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  8018fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801900:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  801903:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801906:	85 c0                	test   %eax,%eax
  801908:	79 1c                	jns    801926 <free+0x39>
  80190a:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  801911:	77 13                	ja     801926 <free+0x39>
    {
        free_block(virtual_address);
  801913:	83 ec 0c             	sub    $0xc,%esp
  801916:	ff 75 08             	pushl  0x8(%ebp)
  801919:	e8 09 21 00 00       	call   803a27 <free_block>
  80191e:	83 c4 10             	add    $0x10,%esp
        return;
  801921:	e9 d2 03 00 00       	jmp    801cf8 <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  801926:	a1 30 51 83 00       	mov    0x835130,%eax
  80192b:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  80192e:	72 09                	jb     801939 <free+0x4c>
  801930:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  801937:	76 17                	jbe    801950 <free+0x63>
        panic("free: invalid address");
  801939:	83 ec 04             	sub    $0x4,%esp
  80193c:	68 4d 48 80 00       	push   $0x80484d
  801941:	68 9b 00 00 00       	push   $0x9b
  801946:	68 04 48 80 00       	push   $0x804804
  80194b:	e8 ad e9 ff ff       	call   8002fd <_panic>

    uint32 size = 0;
  801950:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  801957:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80195e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801965:	eb 50                	jmp    8019b7 <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  801967:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80196a:	89 d0                	mov    %edx,%eax
  80196c:	01 c0                	add    %eax,%eax
  80196e:	01 d0                	add    %edx,%eax
  801970:	c1 e0 02             	shl    $0x2,%eax
  801973:	05 48 50 80 00       	add    $0x805048,%eax
  801978:	8a 00                	mov    (%eax),%al
  80197a:	84 c0                	test   %al,%al
  80197c:	74 36                	je     8019b4 <free+0xc7>
  80197e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801981:	89 d0                	mov    %edx,%eax
  801983:	01 c0                	add    %eax,%eax
  801985:	01 d0                	add    %edx,%eax
  801987:	c1 e0 02             	shl    $0x2,%eax
  80198a:	05 40 50 80 00       	add    $0x805040,%eax
  80198f:	8b 00                	mov    (%eax),%eax
  801991:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801994:	75 1e                	jne    8019b4 <free+0xc7>
        {
            size = uhp_allocs[i].size;
  801996:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801999:	89 d0                	mov    %edx,%eax
  80199b:	01 c0                	add    %eax,%eax
  80199d:	01 d0                	add    %edx,%eax
  80199f:	c1 e0 02             	shl    $0x2,%eax
  8019a2:	05 44 50 80 00       	add    $0x805044,%eax
  8019a7:	8b 00                	mov    (%eax),%eax
  8019a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  8019ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019af:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  8019b2:	eb 0c                	jmp    8019c0 <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8019b4:	ff 45 ec             	incl   -0x14(%ebp)
  8019b7:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  8019be:	7e a7                	jle    801967 <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  8019c0:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8019c4:	74 06                	je     8019cc <free+0xdf>
  8019c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019ca:	75 17                	jne    8019e3 <free+0xf6>
        panic("free: unknown block");
  8019cc:	83 ec 04             	sub    $0x4,%esp
  8019cf:	68 63 48 80 00       	push   $0x804863
  8019d4:	68 a9 00 00 00       	push   $0xa9
  8019d9:	68 04 48 80 00       	push   $0x804804
  8019de:	e8 1a e9 ff ff       	call   8002fd <_panic>

    uhp_allocs[idx].used = 0;
  8019e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019e6:	89 d0                	mov    %edx,%eax
  8019e8:	01 c0                	add    %eax,%eax
  8019ea:	01 d0                	add    %edx,%eax
  8019ec:	c1 e0 02             	shl    $0x2,%eax
  8019ef:	05 48 50 80 00       	add    $0x805048,%eax
  8019f4:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  8019f7:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8019fe:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801a05:	eb 64                	jmp    801a6b <free+0x17e>
    {
        if (!uhp_frees[i].free)
  801a07:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a0a:	89 d0                	mov    %edx,%eax
  801a0c:	01 c0                	add    %eax,%eax
  801a0e:	01 d0                	add    %edx,%eax
  801a10:	c1 e0 02             	shl    $0x2,%eax
  801a13:	05 48 10 81 00       	add    $0x811048,%eax
  801a18:	8a 00                	mov    (%eax),%al
  801a1a:	84 c0                	test   %al,%al
  801a1c:	75 4a                	jne    801a68 <free+0x17b>
        {
            uhp_frees[i].va = va;
  801a1e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a21:	89 d0                	mov    %edx,%eax
  801a23:	01 c0                	add    %eax,%eax
  801a25:	01 d0                	add    %edx,%eax
  801a27:	c1 e0 02             	shl    $0x2,%eax
  801a2a:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  801a30:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a33:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  801a35:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a38:	89 d0                	mov    %edx,%eax
  801a3a:	01 c0                	add    %eax,%eax
  801a3c:	01 d0                	add    %edx,%eax
  801a3e:	c1 e0 02             	shl    $0x2,%eax
  801a41:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  801a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a4a:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  801a4c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a4f:	89 d0                	mov    %edx,%eax
  801a51:	01 c0                	add    %eax,%eax
  801a53:	01 d0                	add    %edx,%eax
  801a55:	c1 e0 02             	shl    $0x2,%eax
  801a58:	05 48 10 81 00       	add    $0x811048,%eax
  801a5d:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  801a60:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a63:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  801a66:	eb 0c                	jmp    801a74 <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801a68:	ff 45 e4             	incl   -0x1c(%ebp)
  801a6b:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  801a72:	7e 93                	jle    801a07 <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  801a74:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  801a78:	0f 84 f1 01 00 00    	je     801c6f <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801a7e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801a85:	e9 d8 01 00 00       	jmp    801c62 <free+0x375>
        {
            if (i == fidx) continue;
  801a8a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a8d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801a90:	0f 84 c8 01 00 00    	je     801c5e <free+0x371>
            if (uhp_frees[i].free)
  801a96:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a99:	89 d0                	mov    %edx,%eax
  801a9b:	01 c0                	add    %eax,%eax
  801a9d:	01 d0                	add    %edx,%eax
  801a9f:	c1 e0 02             	shl    $0x2,%eax
  801aa2:	05 48 10 81 00       	add    $0x811048,%eax
  801aa7:	8a 00                	mov    (%eax),%al
  801aa9:	84 c0                	test   %al,%al
  801aab:	0f 84 ae 01 00 00    	je     801c5f <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  801ab1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ab4:	89 d0                	mov    %edx,%eax
  801ab6:	01 c0                	add    %eax,%eax
  801ab8:	01 d0                	add    %edx,%eax
  801aba:	c1 e0 02             	shl    $0x2,%eax
  801abd:	05 40 10 81 00       	add    $0x811040,%eax
  801ac2:	8b 08                	mov    (%eax),%ecx
  801ac4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ac7:	89 d0                	mov    %edx,%eax
  801ac9:	01 c0                	add    %eax,%eax
  801acb:	01 d0                	add    %edx,%eax
  801acd:	c1 e0 02             	shl    $0x2,%eax
  801ad0:	05 44 10 81 00       	add    $0x811044,%eax
  801ad5:	8b 00                	mov    (%eax),%eax
  801ad7:	01 c1                	add    %eax,%ecx
  801ad9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801adc:	89 d0                	mov    %edx,%eax
  801ade:	01 c0                	add    %eax,%eax
  801ae0:	01 d0                	add    %edx,%eax
  801ae2:	c1 e0 02             	shl    $0x2,%eax
  801ae5:	05 40 10 81 00       	add    $0x811040,%eax
  801aea:	8b 00                	mov    (%eax),%eax
  801aec:	39 c1                	cmp    %eax,%ecx
  801aee:	0f 85 a8 00 00 00    	jne    801b9c <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  801af4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801af7:	89 d0                	mov    %edx,%eax
  801af9:	01 c0                	add    %eax,%eax
  801afb:	01 d0                	add    %edx,%eax
  801afd:	c1 e0 02             	shl    $0x2,%eax
  801b00:	05 40 10 81 00       	add    $0x811040,%eax
  801b05:	8b 10                	mov    (%eax),%edx
  801b07:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  801b0a:	89 c8                	mov    %ecx,%eax
  801b0c:	01 c0                	add    %eax,%eax
  801b0e:	01 c8                	add    %ecx,%eax
  801b10:	c1 e0 02             	shl    $0x2,%eax
  801b13:	05 40 10 81 00       	add    $0x811040,%eax
  801b18:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801b1a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b1d:	89 d0                	mov    %edx,%eax
  801b1f:	01 c0                	add    %eax,%eax
  801b21:	01 d0                	add    %edx,%eax
  801b23:	c1 e0 02             	shl    $0x2,%eax
  801b26:	05 44 10 81 00       	add    $0x811044,%eax
  801b2b:	8b 08                	mov    (%eax),%ecx
  801b2d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b30:	89 d0                	mov    %edx,%eax
  801b32:	01 c0                	add    %eax,%eax
  801b34:	01 d0                	add    %edx,%eax
  801b36:	c1 e0 02             	shl    $0x2,%eax
  801b39:	05 44 10 81 00       	add    $0x811044,%eax
  801b3e:	8b 00                	mov    (%eax),%eax
  801b40:	01 c1                	add    %eax,%ecx
  801b42:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b45:	89 d0                	mov    %edx,%eax
  801b47:	01 c0                	add    %eax,%eax
  801b49:	01 d0                	add    %edx,%eax
  801b4b:	c1 e0 02             	shl    $0x2,%eax
  801b4e:	05 44 10 81 00       	add    $0x811044,%eax
  801b53:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801b55:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b58:	89 d0                	mov    %edx,%eax
  801b5a:	01 c0                	add    %eax,%eax
  801b5c:	01 d0                	add    %edx,%eax
  801b5e:	c1 e0 02             	shl    $0x2,%eax
  801b61:	05 48 10 81 00       	add    $0x811048,%eax
  801b66:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801b69:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b6c:	89 d0                	mov    %edx,%eax
  801b6e:	01 c0                	add    %eax,%eax
  801b70:	01 d0                	add    %edx,%eax
  801b72:	c1 e0 02             	shl    $0x2,%eax
  801b75:	05 40 10 81 00       	add    $0x811040,%eax
  801b7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801b80:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b83:	89 d0                	mov    %edx,%eax
  801b85:	01 c0                	add    %eax,%eax
  801b87:	01 d0                	add    %edx,%eax
  801b89:	c1 e0 02             	shl    $0x2,%eax
  801b8c:	05 44 10 81 00       	add    $0x811044,%eax
  801b91:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801b97:	e9 c3 00 00 00       	jmp    801c5f <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  801b9c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b9f:	89 d0                	mov    %edx,%eax
  801ba1:	01 c0                	add    %eax,%eax
  801ba3:	01 d0                	add    %edx,%eax
  801ba5:	c1 e0 02             	shl    $0x2,%eax
  801ba8:	05 40 10 81 00       	add    $0x811040,%eax
  801bad:	8b 08                	mov    (%eax),%ecx
  801baf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801bb2:	89 d0                	mov    %edx,%eax
  801bb4:	01 c0                	add    %eax,%eax
  801bb6:	01 d0                	add    %edx,%eax
  801bb8:	c1 e0 02             	shl    $0x2,%eax
  801bbb:	05 44 10 81 00       	add    $0x811044,%eax
  801bc0:	8b 00                	mov    (%eax),%eax
  801bc2:	01 c1                	add    %eax,%ecx
  801bc4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bc7:	89 d0                	mov    %edx,%eax
  801bc9:	01 c0                	add    %eax,%eax
  801bcb:	01 d0                	add    %edx,%eax
  801bcd:	c1 e0 02             	shl    $0x2,%eax
  801bd0:	05 40 10 81 00       	add    $0x811040,%eax
  801bd5:	8b 00                	mov    (%eax),%eax
  801bd7:	39 c1                	cmp    %eax,%ecx
  801bd9:	0f 85 80 00 00 00    	jne    801c5f <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801bdf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801be2:	89 d0                	mov    %edx,%eax
  801be4:	01 c0                	add    %eax,%eax
  801be6:	01 d0                	add    %edx,%eax
  801be8:	c1 e0 02             	shl    $0x2,%eax
  801beb:	05 44 10 81 00       	add    $0x811044,%eax
  801bf0:	8b 08                	mov    (%eax),%ecx
  801bf2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bf5:	89 d0                	mov    %edx,%eax
  801bf7:	01 c0                	add    %eax,%eax
  801bf9:	01 d0                	add    %edx,%eax
  801bfb:	c1 e0 02             	shl    $0x2,%eax
  801bfe:	05 44 10 81 00       	add    $0x811044,%eax
  801c03:	8b 00                	mov    (%eax),%eax
  801c05:	01 c1                	add    %eax,%ecx
  801c07:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c0a:	89 d0                	mov    %edx,%eax
  801c0c:	01 c0                	add    %eax,%eax
  801c0e:	01 d0                	add    %edx,%eax
  801c10:	c1 e0 02             	shl    $0x2,%eax
  801c13:	05 44 10 81 00       	add    $0x811044,%eax
  801c18:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801c1a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c1d:	89 d0                	mov    %edx,%eax
  801c1f:	01 c0                	add    %eax,%eax
  801c21:	01 d0                	add    %edx,%eax
  801c23:	c1 e0 02             	shl    $0x2,%eax
  801c26:	05 48 10 81 00       	add    $0x811048,%eax
  801c2b:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801c2e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c31:	89 d0                	mov    %edx,%eax
  801c33:	01 c0                	add    %eax,%eax
  801c35:	01 d0                	add    %edx,%eax
  801c37:	c1 e0 02             	shl    $0x2,%eax
  801c3a:	05 40 10 81 00       	add    $0x811040,%eax
  801c3f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801c45:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c48:	89 d0                	mov    %edx,%eax
  801c4a:	01 c0                	add    %eax,%eax
  801c4c:	01 d0                	add    %edx,%eax
  801c4e:	c1 e0 02             	shl    $0x2,%eax
  801c51:	05 44 10 81 00       	add    $0x811044,%eax
  801c56:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c5c:	eb 01                	jmp    801c5f <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  801c5e:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801c5f:	ff 45 e0             	incl   -0x20(%ebp)
  801c62:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801c69:	0f 8e 1b fe ff ff    	jle    801a8a <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  801c6f:	a1 30 51 83 00       	mov    0x835130,%eax
  801c74:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801c77:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801c7e:	eb 53                	jmp    801cd3 <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  801c80:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801c83:	89 d0                	mov    %edx,%eax
  801c85:	01 c0                	add    %eax,%eax
  801c87:	01 d0                	add    %edx,%eax
  801c89:	c1 e0 02             	shl    $0x2,%eax
  801c8c:	05 48 50 80 00       	add    $0x805048,%eax
  801c91:	8a 00                	mov    (%eax),%al
  801c93:	84 c0                	test   %al,%al
  801c95:	74 39                	je     801cd0 <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  801c97:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801c9a:	89 d0                	mov    %edx,%eax
  801c9c:	01 c0                	add    %eax,%eax
  801c9e:	01 d0                	add    %edx,%eax
  801ca0:	c1 e0 02             	shl    $0x2,%eax
  801ca3:	05 40 50 80 00       	add    $0x805040,%eax
  801ca8:	8b 08                	mov    (%eax),%ecx
  801caa:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801cad:	89 d0                	mov    %edx,%eax
  801caf:	01 c0                	add    %eax,%eax
  801cb1:	01 d0                	add    %edx,%eax
  801cb3:	c1 e0 02             	shl    $0x2,%eax
  801cb6:	05 44 50 80 00       	add    $0x805044,%eax
  801cbb:	8b 00                	mov    (%eax),%eax
  801cbd:	01 c8                	add    %ecx,%eax
  801cbf:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  801cc2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801cc5:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801cc8:	76 06                	jbe    801cd0 <free+0x3e3>
  801cca:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801ccd:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801cd0:	ff 45 d8             	incl   -0x28(%ebp)
  801cd3:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  801cda:	7e a4                	jle    801c80 <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  801cdc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801cdf:	a3 88 50 83 00       	mov    %eax,0x835088

    sys_free_user_mem(va, size);
  801ce4:	83 ec 08             	sub    $0x8,%esp
  801ce7:	ff 75 f4             	pushl  -0xc(%ebp)
  801cea:	ff 75 d4             	pushl  -0x2c(%ebp)
  801ced:	e8 79 15 00 00       	call   80326b <sys_free_user_mem>
  801cf2:	83 c4 10             	add    $0x10,%esp
  801cf5:	eb 01                	jmp    801cf8 <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  801cf7:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  801cf8:	c9                   	leave  
  801cf9:	c3                   	ret    

00801cfa <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801cfa:	55                   	push   %ebp
  801cfb:	89 e5                	mov    %esp,%ebp
  801cfd:	83 ec 68             	sub    $0x68,%esp
  801d00:	8b 45 10             	mov    0x10(%ebp),%eax
  801d03:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801d06:	e8 a5 f7 ff ff       	call   8014b0 <uheap_init>
	if (size == 0) return NULL ;
  801d0b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d0f:	75 0a                	jne    801d1b <smalloc+0x21>
  801d11:	b8 00 00 00 00       	mov    $0x0,%eax
  801d16:	e9 37 03 00 00       	jmp    802052 <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801d1b:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801d22:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d25:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d28:	01 d0                	add    %edx,%eax
  801d2a:	48                   	dec    %eax
  801d2b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801d2e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d31:	ba 00 00 00 00       	mov    $0x0,%edx
  801d36:	f7 75 dc             	divl   -0x24(%ebp)
  801d39:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d3c:	29 d0                	sub    %edx,%eax
  801d3e:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  801d41:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801d48:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801d4f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801d56:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801d5d:	e9 85 00 00 00       	jmp    801de7 <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801d62:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d65:	89 d0                	mov    %edx,%eax
  801d67:	01 c0                	add    %eax,%eax
  801d69:	01 d0                	add    %edx,%eax
  801d6b:	c1 e0 02             	shl    $0x2,%eax
  801d6e:	05 48 10 81 00       	add    $0x811048,%eax
  801d73:	8a 00                	mov    (%eax),%al
  801d75:	84 c0                	test   %al,%al
  801d77:	74 20                	je     801d99 <smalloc+0x9f>
  801d79:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d7c:	89 d0                	mov    %edx,%eax
  801d7e:	01 c0                	add    %eax,%eax
  801d80:	01 d0                	add    %edx,%eax
  801d82:	c1 e0 02             	shl    $0x2,%eax
  801d85:	05 44 10 81 00       	add    $0x811044,%eax
  801d8a:	8b 00                	mov    (%eax),%eax
  801d8c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801d8f:	75 08                	jne    801d99 <smalloc+0x9f>
        {
            exactIdx = i;
  801d91:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d94:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801d97:	eb 5b                	jmp    801df4 <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801d99:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d9c:	89 d0                	mov    %edx,%eax
  801d9e:	01 c0                	add    %eax,%eax
  801da0:	01 d0                	add    %edx,%eax
  801da2:	c1 e0 02             	shl    $0x2,%eax
  801da5:	05 48 10 81 00       	add    $0x811048,%eax
  801daa:	8a 00                	mov    (%eax),%al
  801dac:	84 c0                	test   %al,%al
  801dae:	74 34                	je     801de4 <smalloc+0xea>
  801db0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801db3:	89 d0                	mov    %edx,%eax
  801db5:	01 c0                	add    %eax,%eax
  801db7:	01 d0                	add    %edx,%eax
  801db9:	c1 e0 02             	shl    $0x2,%eax
  801dbc:	05 44 10 81 00       	add    $0x811044,%eax
  801dc1:	8b 00                	mov    (%eax),%eax
  801dc3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801dc6:	76 1c                	jbe    801de4 <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  801dc8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801dcb:	89 d0                	mov    %edx,%eax
  801dcd:	01 c0                	add    %eax,%eax
  801dcf:	01 d0                	add    %edx,%eax
  801dd1:	c1 e0 02             	shl    $0x2,%eax
  801dd4:	05 44 10 81 00       	add    $0x811044,%eax
  801dd9:	8b 00                	mov    (%eax),%eax
  801ddb:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801dde:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801de1:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801de4:	ff 45 e8             	incl   -0x18(%ebp)
  801de7:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801dee:	0f 8e 6e ff ff ff    	jle    801d62 <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  801df4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801dfb:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801dff:	74 7d                	je     801e7e <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801e01:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801e08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e0b:	89 d0                	mov    %edx,%eax
  801e0d:	01 c0                	add    %eax,%eax
  801e0f:	01 d0                	add    %edx,%eax
  801e11:	c1 e0 02             	shl    $0x2,%eax
  801e14:	05 40 10 81 00       	add    $0x811040,%eax
  801e19:	8b 10                	mov    (%eax),%edx
  801e1b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801e1e:	01 d0                	add    %edx,%eax
  801e20:	48                   	dec    %eax
  801e21:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801e24:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801e27:	ba 00 00 00 00       	mov    $0x0,%edx
  801e2c:	f7 75 bc             	divl   -0x44(%ebp)
  801e2f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801e32:	29 d0                	sub    %edx,%eax
  801e34:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801e37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e3a:	89 d0                	mov    %edx,%eax
  801e3c:	01 c0                	add    %eax,%eax
  801e3e:	01 d0                	add    %edx,%eax
  801e40:	c1 e0 02             	shl    $0x2,%eax
  801e43:	05 48 10 81 00       	add    $0x811048,%eax
  801e48:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801e4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e4e:	89 d0                	mov    %edx,%eax
  801e50:	01 c0                	add    %eax,%eax
  801e52:	01 d0                	add    %edx,%eax
  801e54:	c1 e0 02             	shl    $0x2,%eax
  801e57:	05 44 10 81 00       	add    $0x811044,%eax
  801e5c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801e62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e65:	89 d0                	mov    %edx,%eax
  801e67:	01 c0                	add    %eax,%eax
  801e69:	01 d0                	add    %edx,%eax
  801e6b:	c1 e0 02             	shl    $0x2,%eax
  801e6e:	05 40 10 81 00       	add    $0x811040,%eax
  801e73:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e79:	e9 2d 01 00 00       	jmp    801fab <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  801e7e:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801e82:	0f 84 ce 00 00 00    	je     801f56 <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  801e88:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  801e8f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e92:	89 d0                	mov    %edx,%eax
  801e94:	01 c0                	add    %eax,%eax
  801e96:	01 d0                	add    %edx,%eax
  801e98:	c1 e0 02             	shl    $0x2,%eax
  801e9b:	05 40 10 81 00       	add    $0x811040,%eax
  801ea0:	8b 10                	mov    (%eax),%edx
  801ea2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801ea5:	01 d0                	add    %edx,%eax
  801ea7:	48                   	dec    %eax
  801ea8:	89 45 c0             	mov    %eax,-0x40(%ebp)
  801eab:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801eae:	ba 00 00 00 00       	mov    $0x0,%edx
  801eb3:	f7 75 c4             	divl   -0x3c(%ebp)
  801eb6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801eb9:	29 d0                	sub    %edx,%eax
  801ebb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  801ebe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ec1:	89 d0                	mov    %edx,%eax
  801ec3:	01 c0                	add    %eax,%eax
  801ec5:	01 d0                	add    %edx,%eax
  801ec7:	c1 e0 02             	shl    $0x2,%eax
  801eca:	05 44 10 81 00       	add    $0x811044,%eax
  801ecf:	8b 00                	mov    (%eax),%eax
  801ed1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801ed4:	75 47                	jne    801f1d <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  801ed6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ed9:	89 d0                	mov    %edx,%eax
  801edb:	01 c0                	add    %eax,%eax
  801edd:	01 d0                	add    %edx,%eax
  801edf:	c1 e0 02             	shl    $0x2,%eax
  801ee2:	05 48 10 81 00       	add    $0x811048,%eax
  801ee7:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  801eea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801eed:	89 d0                	mov    %edx,%eax
  801eef:	01 c0                	add    %eax,%eax
  801ef1:	01 d0                	add    %edx,%eax
  801ef3:	c1 e0 02             	shl    $0x2,%eax
  801ef6:	05 44 10 81 00       	add    $0x811044,%eax
  801efb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  801f01:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f04:	89 d0                	mov    %edx,%eax
  801f06:	01 c0                	add    %eax,%eax
  801f08:	01 d0                	add    %edx,%eax
  801f0a:	c1 e0 02             	shl    $0x2,%eax
  801f0d:	05 40 10 81 00       	add    $0x811040,%eax
  801f12:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f18:	e9 8e 00 00 00       	jmp    801fab <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  801f1d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801f20:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f23:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801f26:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f29:	89 d0                	mov    %edx,%eax
  801f2b:	01 c0                	add    %eax,%eax
  801f2d:	01 d0                	add    %edx,%eax
  801f2f:	c1 e0 02             	shl    $0x2,%eax
  801f32:	05 40 10 81 00       	add    $0x811040,%eax
  801f37:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  801f39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f3c:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801f3f:	89 c2                	mov    %eax,%edx
  801f41:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801f44:	89 c8                	mov    %ecx,%eax
  801f46:	01 c0                	add    %eax,%eax
  801f48:	01 c8                	add    %ecx,%eax
  801f4a:	c1 e0 02             	shl    $0x2,%eax
  801f4d:	05 44 10 81 00       	add    $0x811044,%eax
  801f52:	89 10                	mov    %edx,(%eax)
  801f54:	eb 55                	jmp    801fab <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  801f56:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801f5d:	8b 15 88 50 83 00    	mov    0x835088,%edx
  801f63:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f66:	01 d0                	add    %edx,%eax
  801f68:	48                   	dec    %eax
  801f69:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801f6c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801f6f:	ba 00 00 00 00       	mov    $0x0,%edx
  801f74:	f7 75 d0             	divl   -0x30(%ebp)
  801f77:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801f7a:	29 d0                	sub    %edx,%eax
  801f7c:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  801f7f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801f82:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f85:	01 d0                	add    %edx,%eax
  801f87:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801f8c:	76 0a                	jbe    801f98 <smalloc+0x29e>
            return NULL;
  801f8e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f93:	e9 ba 00 00 00       	jmp    802052 <smalloc+0x358>
        va = start;
  801f98:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801f9b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  801f9e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801fa1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fa4:	01 d0                	add    %edx,%eax
  801fa6:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801fab:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801fb2:	eb 5e                	jmp    802012 <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  801fb4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801fb7:	89 d0                	mov    %edx,%eax
  801fb9:	01 c0                	add    %eax,%eax
  801fbb:	01 d0                	add    %edx,%eax
  801fbd:	c1 e0 02             	shl    $0x2,%eax
  801fc0:	05 48 50 80 00       	add    $0x805048,%eax
  801fc5:	8a 00                	mov    (%eax),%al
  801fc7:	84 c0                	test   %al,%al
  801fc9:	75 44                	jne    80200f <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  801fcb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801fce:	89 d0                	mov    %edx,%eax
  801fd0:	01 c0                	add    %eax,%eax
  801fd2:	01 d0                	add    %edx,%eax
  801fd4:	c1 e0 02             	shl    $0x2,%eax
  801fd7:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  801fdd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fe0:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  801fe2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801fe5:	89 d0                	mov    %edx,%eax
  801fe7:	01 c0                	add    %eax,%eax
  801fe9:	01 d0                	add    %edx,%eax
  801feb:	c1 e0 02             	shl    $0x2,%eax
  801fee:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  801ff4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ff7:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  801ff9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ffc:	89 d0                	mov    %edx,%eax
  801ffe:	01 c0                	add    %eax,%eax
  802000:	01 d0                	add    %edx,%eax
  802002:	c1 e0 02             	shl    $0x2,%eax
  802005:	05 48 50 80 00       	add    $0x805048,%eax
  80200a:	c6 00 01             	movb   $0x1,(%eax)
            break;
  80200d:	eb 0c                	jmp    80201b <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80200f:	ff 45 e0             	incl   -0x20(%ebp)
  802012:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802019:	7e 99                	jle    801fb4 <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  80201b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80201e:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  802022:	52                   	push   %edx
  802023:	50                   	push   %eax
  802024:	ff 75 d4             	pushl  -0x2c(%ebp)
  802027:	ff 75 08             	pushl  0x8(%ebp)
  80202a:	e8 de 0e 00 00       	call   802f0d <sys_create_shared_object>
  80202f:	83 c4 10             	add    $0x10,%esp
  802032:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  802035:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  802039:	75 07                	jne    802042 <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  80203b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802040:	eb 10                	jmp    802052 <smalloc+0x358>
    if (r < 0)
  802042:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  802046:	79 07                	jns    80204f <smalloc+0x355>
        return NULL;
  802048:	b8 00 00 00 00       	mov    $0x0,%eax
  80204d:	eb 03                	jmp    802052 <smalloc+0x358>
    return (void*)va;
  80204f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  802052:	c9                   	leave  
  802053:	c3                   	ret    

00802054 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802054:	55                   	push   %ebp
  802055:	89 e5                	mov    %esp,%ebp
  802057:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80205a:	e8 51 f4 ff ff       	call   8014b0 <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  80205f:	83 ec 08             	sub    $0x8,%esp
  802062:	ff 75 0c             	pushl  0xc(%ebp)
  802065:	ff 75 08             	pushl  0x8(%ebp)
  802068:	e8 ca 0e 00 00       	call   802f37 <sys_size_of_shared_object>
  80206d:	83 c4 10             	add    $0x10,%esp
  802070:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  802073:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802077:	7f 0a                	jg     802083 <sget+0x2f>
        return NULL;
  802079:	b8 00 00 00 00       	mov    $0x0,%eax
  80207e:	e9 28 03 00 00       	jmp    8023ab <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  802083:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80208a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80208d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802090:	01 d0                	add    %edx,%eax
  802092:	48                   	dec    %eax
  802093:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802096:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802099:	ba 00 00 00 00       	mov    $0x0,%edx
  80209e:	f7 75 d8             	divl   -0x28(%ebp)
  8020a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020a4:	29 d0                	sub    %edx,%eax
  8020a6:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  8020a9:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  8020b0:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  8020b7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8020be:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8020c5:	e9 85 00 00 00       	jmp    80214f <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  8020ca:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8020cd:	89 d0                	mov    %edx,%eax
  8020cf:	01 c0                	add    %eax,%eax
  8020d1:	01 d0                	add    %edx,%eax
  8020d3:	c1 e0 02             	shl    $0x2,%eax
  8020d6:	05 48 10 81 00       	add    $0x811048,%eax
  8020db:	8a 00                	mov    (%eax),%al
  8020dd:	84 c0                	test   %al,%al
  8020df:	74 20                	je     802101 <sget+0xad>
  8020e1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8020e4:	89 d0                	mov    %edx,%eax
  8020e6:	01 c0                	add    %eax,%eax
  8020e8:	01 d0                	add    %edx,%eax
  8020ea:	c1 e0 02             	shl    $0x2,%eax
  8020ed:	05 44 10 81 00       	add    $0x811044,%eax
  8020f2:	8b 00                	mov    (%eax),%eax
  8020f4:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8020f7:	75 08                	jne    802101 <sget+0xad>
        {
            exactIdx = i;
  8020f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  8020ff:	eb 5b                	jmp    80215c <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  802101:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802104:	89 d0                	mov    %edx,%eax
  802106:	01 c0                	add    %eax,%eax
  802108:	01 d0                	add    %edx,%eax
  80210a:	c1 e0 02             	shl    $0x2,%eax
  80210d:	05 48 10 81 00       	add    $0x811048,%eax
  802112:	8a 00                	mov    (%eax),%al
  802114:	84 c0                	test   %al,%al
  802116:	74 34                	je     80214c <sget+0xf8>
  802118:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80211b:	89 d0                	mov    %edx,%eax
  80211d:	01 c0                	add    %eax,%eax
  80211f:	01 d0                	add    %edx,%eax
  802121:	c1 e0 02             	shl    $0x2,%eax
  802124:	05 44 10 81 00       	add    $0x811044,%eax
  802129:	8b 00                	mov    (%eax),%eax
  80212b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80212e:	76 1c                	jbe    80214c <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  802130:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802133:	89 d0                	mov    %edx,%eax
  802135:	01 c0                	add    %eax,%eax
  802137:	01 d0                	add    %edx,%eax
  802139:	c1 e0 02             	shl    $0x2,%eax
  80213c:	05 44 10 81 00       	add    $0x811044,%eax
  802141:	8b 00                	mov    (%eax),%eax
  802143:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  802146:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802149:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80214c:	ff 45 e8             	incl   -0x18(%ebp)
  80214f:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802156:	0f 8e 6e ff ff ff    	jle    8020ca <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  80215c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  802163:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  802167:	74 7d                	je     8021e6 <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  802169:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802170:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802173:	89 d0                	mov    %edx,%eax
  802175:	01 c0                	add    %eax,%eax
  802177:	01 d0                	add    %edx,%eax
  802179:	c1 e0 02             	shl    $0x2,%eax
  80217c:	05 40 10 81 00       	add    $0x811040,%eax
  802181:	8b 10                	mov    (%eax),%edx
  802183:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802186:	01 d0                	add    %edx,%eax
  802188:	48                   	dec    %eax
  802189:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80218c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80218f:	ba 00 00 00 00       	mov    $0x0,%edx
  802194:	f7 75 b8             	divl   -0x48(%ebp)
  802197:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80219a:	29 d0                	sub    %edx,%eax
  80219c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  80219f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021a2:	89 d0                	mov    %edx,%eax
  8021a4:	01 c0                	add    %eax,%eax
  8021a6:	01 d0                	add    %edx,%eax
  8021a8:	c1 e0 02             	shl    $0x2,%eax
  8021ab:	05 48 10 81 00       	add    $0x811048,%eax
  8021b0:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  8021b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021b6:	89 d0                	mov    %edx,%eax
  8021b8:	01 c0                	add    %eax,%eax
  8021ba:	01 d0                	add    %edx,%eax
  8021bc:	c1 e0 02             	shl    $0x2,%eax
  8021bf:	05 44 10 81 00       	add    $0x811044,%eax
  8021c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  8021ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021cd:	89 d0                	mov    %edx,%eax
  8021cf:	01 c0                	add    %eax,%eax
  8021d1:	01 d0                	add    %edx,%eax
  8021d3:	c1 e0 02             	shl    $0x2,%eax
  8021d6:	05 40 10 81 00       	add    $0x811040,%eax
  8021db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021e1:	e9 2d 01 00 00       	jmp    802313 <sget+0x2bf>
    }
    else if (worstIdx != -1)
  8021e6:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8021ea:	0f 84 ce 00 00 00    	je     8022be <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  8021f0:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  8021f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021fa:	89 d0                	mov    %edx,%eax
  8021fc:	01 c0                	add    %eax,%eax
  8021fe:	01 d0                	add    %edx,%eax
  802200:	c1 e0 02             	shl    $0x2,%eax
  802203:	05 40 10 81 00       	add    $0x811040,%eax
  802208:	8b 10                	mov    (%eax),%edx
  80220a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80220d:	01 d0                	add    %edx,%eax
  80220f:	48                   	dec    %eax
  802210:	89 45 bc             	mov    %eax,-0x44(%ebp)
  802213:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802216:	ba 00 00 00 00       	mov    $0x0,%edx
  80221b:	f7 75 c0             	divl   -0x40(%ebp)
  80221e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802221:	29 d0                	sub    %edx,%eax
  802223:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  802226:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802229:	89 d0                	mov    %edx,%eax
  80222b:	01 c0                	add    %eax,%eax
  80222d:	01 d0                	add    %edx,%eax
  80222f:	c1 e0 02             	shl    $0x2,%eax
  802232:	05 44 10 81 00       	add    $0x811044,%eax
  802237:	8b 00                	mov    (%eax),%eax
  802239:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80223c:	75 47                	jne    802285 <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  80223e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802241:	89 d0                	mov    %edx,%eax
  802243:	01 c0                	add    %eax,%eax
  802245:	01 d0                	add    %edx,%eax
  802247:	c1 e0 02             	shl    $0x2,%eax
  80224a:	05 48 10 81 00       	add    $0x811048,%eax
  80224f:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  802252:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802255:	89 d0                	mov    %edx,%eax
  802257:	01 c0                	add    %eax,%eax
  802259:	01 d0                	add    %edx,%eax
  80225b:	c1 e0 02             	shl    $0x2,%eax
  80225e:	05 44 10 81 00       	add    $0x811044,%eax
  802263:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  802269:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80226c:	89 d0                	mov    %edx,%eax
  80226e:	01 c0                	add    %eax,%eax
  802270:	01 d0                	add    %edx,%eax
  802272:	c1 e0 02             	shl    $0x2,%eax
  802275:	05 40 10 81 00       	add    $0x811040,%eax
  80227a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802280:	e9 8e 00 00 00       	jmp    802313 <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  802285:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802288:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80228b:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80228e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802291:	89 d0                	mov    %edx,%eax
  802293:	01 c0                	add    %eax,%eax
  802295:	01 d0                	add    %edx,%eax
  802297:	c1 e0 02             	shl    $0x2,%eax
  80229a:	05 40 10 81 00       	add    $0x811040,%eax
  80229f:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  8022a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022a4:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8022a7:	89 c2                	mov    %eax,%edx
  8022a9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8022ac:	89 c8                	mov    %ecx,%eax
  8022ae:	01 c0                	add    %eax,%eax
  8022b0:	01 c8                	add    %ecx,%eax
  8022b2:	c1 e0 02             	shl    $0x2,%eax
  8022b5:	05 44 10 81 00       	add    $0x811044,%eax
  8022ba:	89 10                	mov    %edx,(%eax)
  8022bc:	eb 55                	jmp    802313 <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  8022be:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8022c5:	8b 15 88 50 83 00    	mov    0x835088,%edx
  8022cb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8022ce:	01 d0                	add    %edx,%eax
  8022d0:	48                   	dec    %eax
  8022d1:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8022d4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8022d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8022dc:	f7 75 cc             	divl   -0x34(%ebp)
  8022df:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8022e2:	29 d0                	sub    %edx,%eax
  8022e4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  8022e7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8022ea:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8022ed:	01 d0                	add    %edx,%eax
  8022ef:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8022f4:	76 0a                	jbe    802300 <sget+0x2ac>
            return NULL;
  8022f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8022fb:	e9 ab 00 00 00       	jmp    8023ab <sget+0x357>
        va = start;
  802300:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802303:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  802306:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802309:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80230c:	01 d0                	add    %edx,%eax
  80230e:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802313:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80231a:	eb 5e                	jmp    80237a <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  80231c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80231f:	89 d0                	mov    %edx,%eax
  802321:	01 c0                	add    %eax,%eax
  802323:	01 d0                	add    %edx,%eax
  802325:	c1 e0 02             	shl    $0x2,%eax
  802328:	05 48 50 80 00       	add    $0x805048,%eax
  80232d:	8a 00                	mov    (%eax),%al
  80232f:	84 c0                	test   %al,%al
  802331:	75 44                	jne    802377 <sget+0x323>
        {
            uhp_allocs[i].va = va;
  802333:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802336:	89 d0                	mov    %edx,%eax
  802338:	01 c0                	add    %eax,%eax
  80233a:	01 d0                	add    %edx,%eax
  80233c:	c1 e0 02             	shl    $0x2,%eax
  80233f:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  802345:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802348:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  80234a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80234d:	89 d0                	mov    %edx,%eax
  80234f:	01 c0                	add    %eax,%eax
  802351:	01 d0                	add    %edx,%eax
  802353:	c1 e0 02             	shl    $0x2,%eax
  802356:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  80235c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80235f:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  802361:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802364:	89 d0                	mov    %edx,%eax
  802366:	01 c0                	add    %eax,%eax
  802368:	01 d0                	add    %edx,%eax
  80236a:	c1 e0 02             	shl    $0x2,%eax
  80236d:	05 48 50 80 00       	add    $0x805048,%eax
  802372:	c6 00 01             	movb   $0x1,(%eax)
            break;
  802375:	eb 0c                	jmp    802383 <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802377:	ff 45 e0             	incl   -0x20(%ebp)
  80237a:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802381:	7e 99                	jle    80231c <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  802383:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802386:	83 ec 04             	sub    $0x4,%esp
  802389:	50                   	push   %eax
  80238a:	ff 75 0c             	pushl  0xc(%ebp)
  80238d:	ff 75 08             	pushl  0x8(%ebp)
  802390:	e8 bf 0b 00 00       	call   802f54 <sys_get_shared_object>
  802395:	83 c4 10             	add    $0x10,%esp
  802398:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  80239b:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80239f:	79 07                	jns    8023a8 <sget+0x354>
        return NULL;
  8023a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8023a6:	eb 03                	jmp    8023ab <sget+0x357>
    return (void*)va;
  8023a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8023ab:	c9                   	leave  
  8023ac:	c3                   	ret    

008023ad <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8023ad:	55                   	push   %ebp
  8023ae:	89 e5                	mov    %esp,%ebp
  8023b0:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8023b3:	e8 f8 f0 ff ff       	call   8014b0 <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  8023b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023bc:	75 13                	jne    8023d1 <realloc+0x24>
		return malloc(new_size);
  8023be:	83 ec 0c             	sub    $0xc,%esp
  8023c1:	ff 75 0c             	pushl  0xc(%ebp)
  8023c4:	e8 c4 f1 ff ff       	call   80158d <malloc>
  8023c9:	83 c4 10             	add    $0x10,%esp
  8023cc:	e9 f4 05 00 00       	jmp    8029c5 <realloc+0x618>
	if (new_size == 0)
  8023d1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8023d5:	75 18                	jne    8023ef <realloc+0x42>
	{
		free(virtual_address);
  8023d7:	83 ec 0c             	sub    $0xc,%esp
  8023da:	ff 75 08             	pushl  0x8(%ebp)
  8023dd:	e8 0b f5 ff ff       	call   8018ed <free>
  8023e2:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8023e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ea:	e9 d6 05 00 00       	jmp    8029c5 <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  8023ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f2:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  8023f5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8023f8:	85 c0                	test   %eax,%eax
  8023fa:	79 74                	jns    802470 <realloc+0xc3>
  8023fc:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  802403:	77 6b                	ja     802470 <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  802405:	83 ec 0c             	sub    $0xc,%esp
  802408:	ff 75 0c             	pushl  0xc(%ebp)
  80240b:	e8 7d f1 ff ff       	call   80158d <malloc>
  802410:	83 c4 10             	add    $0x10,%esp
  802413:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  802416:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80241a:	75 0a                	jne    802426 <realloc+0x79>
			return NULL;
  80241c:	b8 00 00 00 00       	mov    $0x0,%eax
  802421:	e9 9f 05 00 00       	jmp    8029c5 <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  802426:	83 ec 0c             	sub    $0xc,%esp
  802429:	ff 75 08             	pushl  0x8(%ebp)
  80242c:	e8 e0 11 00 00       	call   803611 <get_block_size>
  802431:	83 c4 10             	add    $0x10,%esp
  802434:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  802437:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80243a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80243d:	39 d0                	cmp    %edx,%eax
  80243f:	76 02                	jbe    802443 <realloc+0x96>
  802441:	89 d0                	mov    %edx,%eax
  802443:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  802446:	83 ec 04             	sub    $0x4,%esp
  802449:	ff 75 c0             	pushl  -0x40(%ebp)
  80244c:	ff 75 08             	pushl  0x8(%ebp)
  80244f:	ff 75 c8             	pushl  -0x38(%ebp)
  802452:	e8 56 eb ff ff       	call   800fad <memmove>
  802457:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  80245a:	83 ec 0c             	sub    $0xc,%esp
  80245d:	ff 75 08             	pushl  0x8(%ebp)
  802460:	e8 88 f4 ff ff       	call   8018ed <free>
  802465:	83 c4 10             	add    $0x10,%esp
		return newptr;
  802468:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80246b:	e9 55 05 00 00       	jmp    8029c5 <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  802470:	a1 30 51 83 00       	mov    0x835130,%eax
  802475:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  802478:	72 09                	jb     802483 <realloc+0xd6>
  80247a:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  802481:	76 0a                	jbe    80248d <realloc+0xe0>
		return NULL;
  802483:	b8 00 00 00 00       	mov    $0x0,%eax
  802488:	e9 38 05 00 00       	jmp    8029c5 <realloc+0x618>
	uint32 oldsz = 0;
  80248d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  802494:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80249b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8024a2:	eb 50                	jmp    8024f4 <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  8024a4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024a7:	89 d0                	mov    %edx,%eax
  8024a9:	01 c0                	add    %eax,%eax
  8024ab:	01 d0                	add    %edx,%eax
  8024ad:	c1 e0 02             	shl    $0x2,%eax
  8024b0:	05 48 50 80 00       	add    $0x805048,%eax
  8024b5:	8a 00                	mov    (%eax),%al
  8024b7:	84 c0                	test   %al,%al
  8024b9:	74 36                	je     8024f1 <realloc+0x144>
  8024bb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024be:	89 d0                	mov    %edx,%eax
  8024c0:	01 c0                	add    %eax,%eax
  8024c2:	01 d0                	add    %edx,%eax
  8024c4:	c1 e0 02             	shl    $0x2,%eax
  8024c7:	05 40 50 80 00       	add    $0x805040,%eax
  8024cc:	8b 00                	mov    (%eax),%eax
  8024ce:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8024d1:	75 1e                	jne    8024f1 <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  8024d3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024d6:	89 d0                	mov    %edx,%eax
  8024d8:	01 c0                	add    %eax,%eax
  8024da:	01 d0                	add    %edx,%eax
  8024dc:	c1 e0 02             	shl    $0x2,%eax
  8024df:	05 44 50 80 00       	add    $0x805044,%eax
  8024e4:	8b 00                	mov    (%eax),%eax
  8024e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  8024e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  8024ef:	eb 0c                	jmp    8024fd <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8024f1:	ff 45 ec             	incl   -0x14(%ebp)
  8024f4:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  8024fb:	7e a7                	jle    8024a4 <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  8024fd:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802501:	75 0a                	jne    80250d <realloc+0x160>
		return NULL;
  802503:	b8 00 00 00 00       	mov    $0x0,%eax
  802508:	e9 b8 04 00 00       	jmp    8029c5 <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  80250d:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  802514:	8b 55 0c             	mov    0xc(%ebp),%edx
  802517:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80251a:	01 d0                	add    %edx,%eax
  80251c:	48                   	dec    %eax
  80251d:	89 45 b8             	mov    %eax,-0x48(%ebp)
  802520:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802523:	ba 00 00 00 00       	mov    $0x0,%edx
  802528:	f7 75 bc             	divl   -0x44(%ebp)
  80252b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80252e:	29 d0                	sub    %edx,%eax
  802530:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  802533:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802536:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802539:	75 08                	jne    802543 <realloc+0x196>
		return virtual_address;
  80253b:	8b 45 08             	mov    0x8(%ebp),%eax
  80253e:	e9 82 04 00 00       	jmp    8029c5 <realloc+0x618>
	if (req < oldsz)
  802543:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802546:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802549:	0f 83 cd 02 00 00    	jae    80281c <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  80254f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802552:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  802555:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  802558:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80255b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80255e:	01 d0                	add    %edx,%eax
  802560:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  802563:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802566:	89 d0                	mov    %edx,%eax
  802568:	01 c0                	add    %eax,%eax
  80256a:	01 d0                	add    %edx,%eax
  80256c:	c1 e0 02             	shl    $0x2,%eax
  80256f:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802575:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802578:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  80257a:	83 ec 08             	sub    $0x8,%esp
  80257d:	ff 75 b0             	pushl  -0x50(%ebp)
  802580:	ff 75 ac             	pushl  -0x54(%ebp)
  802583:	e8 e3 0c 00 00       	call   80326b <sys_free_user_mem>
  802588:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  80258b:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802592:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  802599:	eb 64                	jmp    8025ff <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  80259b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80259e:	89 d0                	mov    %edx,%eax
  8025a0:	01 c0                	add    %eax,%eax
  8025a2:	01 d0                	add    %edx,%eax
  8025a4:	c1 e0 02             	shl    $0x2,%eax
  8025a7:	05 48 10 81 00       	add    $0x811048,%eax
  8025ac:	8a 00                	mov    (%eax),%al
  8025ae:	84 c0                	test   %al,%al
  8025b0:	75 4a                	jne    8025fc <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  8025b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025b5:	89 d0                	mov    %edx,%eax
  8025b7:	01 c0                	add    %eax,%eax
  8025b9:	01 d0                	add    %edx,%eax
  8025bb:	c1 e0 02             	shl    $0x2,%eax
  8025be:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  8025c4:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8025c7:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  8025c9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025cc:	89 d0                	mov    %edx,%eax
  8025ce:	01 c0                	add    %eax,%eax
  8025d0:	01 d0                	add    %edx,%eax
  8025d2:	c1 e0 02             	shl    $0x2,%eax
  8025d5:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  8025db:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025de:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  8025e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025e3:	89 d0                	mov    %edx,%eax
  8025e5:	01 c0                	add    %eax,%eax
  8025e7:	01 d0                	add    %edx,%eax
  8025e9:	c1 e0 02             	shl    $0x2,%eax
  8025ec:	05 48 10 81 00       	add    $0x811048,%eax
  8025f1:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  8025f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  8025fa:	eb 0c                	jmp    802608 <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8025fc:	ff 45 e4             	incl   -0x1c(%ebp)
  8025ff:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  802606:	7e 93                	jle    80259b <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  802608:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  80260c:	0f 84 8d 01 00 00    	je     80279f <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802612:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802619:	e9 74 01 00 00       	jmp    802792 <realloc+0x3e5>
			{
				if (k == fidx) continue;
  80261e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802621:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802624:	0f 84 64 01 00 00    	je     80278e <realloc+0x3e1>
				if (uhp_frees[k].free)
  80262a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80262d:	89 d0                	mov    %edx,%eax
  80262f:	01 c0                	add    %eax,%eax
  802631:	01 d0                	add    %edx,%eax
  802633:	c1 e0 02             	shl    $0x2,%eax
  802636:	05 48 10 81 00       	add    $0x811048,%eax
  80263b:	8a 00                	mov    (%eax),%al
  80263d:	84 c0                	test   %al,%al
  80263f:	0f 84 4a 01 00 00    	je     80278f <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802645:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802648:	89 d0                	mov    %edx,%eax
  80264a:	01 c0                	add    %eax,%eax
  80264c:	01 d0                	add    %edx,%eax
  80264e:	c1 e0 02             	shl    $0x2,%eax
  802651:	05 40 10 81 00       	add    $0x811040,%eax
  802656:	8b 08                	mov    (%eax),%ecx
  802658:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80265b:	89 d0                	mov    %edx,%eax
  80265d:	01 c0                	add    %eax,%eax
  80265f:	01 d0                	add    %edx,%eax
  802661:	c1 e0 02             	shl    $0x2,%eax
  802664:	05 44 10 81 00       	add    $0x811044,%eax
  802669:	8b 00                	mov    (%eax),%eax
  80266b:	01 c1                	add    %eax,%ecx
  80266d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802670:	89 d0                	mov    %edx,%eax
  802672:	01 c0                	add    %eax,%eax
  802674:	01 d0                	add    %edx,%eax
  802676:	c1 e0 02             	shl    $0x2,%eax
  802679:	05 40 10 81 00       	add    $0x811040,%eax
  80267e:	8b 00                	mov    (%eax),%eax
  802680:	39 c1                	cmp    %eax,%ecx
  802682:	75 7a                	jne    8026fe <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  802684:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802687:	89 d0                	mov    %edx,%eax
  802689:	01 c0                	add    %eax,%eax
  80268b:	01 d0                	add    %edx,%eax
  80268d:	c1 e0 02             	shl    $0x2,%eax
  802690:	05 40 10 81 00       	add    $0x811040,%eax
  802695:	8b 10                	mov    (%eax),%edx
  802697:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  80269a:	89 c8                	mov    %ecx,%eax
  80269c:	01 c0                	add    %eax,%eax
  80269e:	01 c8                	add    %ecx,%eax
  8026a0:	c1 e0 02             	shl    $0x2,%eax
  8026a3:	05 40 10 81 00       	add    $0x811040,%eax
  8026a8:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  8026aa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026ad:	89 d0                	mov    %edx,%eax
  8026af:	01 c0                	add    %eax,%eax
  8026b1:	01 d0                	add    %edx,%eax
  8026b3:	c1 e0 02             	shl    $0x2,%eax
  8026b6:	05 44 10 81 00       	add    $0x811044,%eax
  8026bb:	8b 08                	mov    (%eax),%ecx
  8026bd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026c0:	89 d0                	mov    %edx,%eax
  8026c2:	01 c0                	add    %eax,%eax
  8026c4:	01 d0                	add    %edx,%eax
  8026c6:	c1 e0 02             	shl    $0x2,%eax
  8026c9:	05 44 10 81 00       	add    $0x811044,%eax
  8026ce:	8b 00                	mov    (%eax),%eax
  8026d0:	01 c1                	add    %eax,%ecx
  8026d2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026d5:	89 d0                	mov    %edx,%eax
  8026d7:	01 c0                	add    %eax,%eax
  8026d9:	01 d0                	add    %edx,%eax
  8026db:	c1 e0 02             	shl    $0x2,%eax
  8026de:	05 44 10 81 00       	add    $0x811044,%eax
  8026e3:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  8026e5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026e8:	89 d0                	mov    %edx,%eax
  8026ea:	01 c0                	add    %eax,%eax
  8026ec:	01 d0                	add    %edx,%eax
  8026ee:	c1 e0 02             	shl    $0x2,%eax
  8026f1:	05 48 10 81 00       	add    $0x811048,%eax
  8026f6:	c6 00 00             	movb   $0x0,(%eax)
  8026f9:	e9 91 00 00 00       	jmp    80278f <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  8026fe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802701:	89 d0                	mov    %edx,%eax
  802703:	01 c0                	add    %eax,%eax
  802705:	01 d0                	add    %edx,%eax
  802707:	c1 e0 02             	shl    $0x2,%eax
  80270a:	05 40 10 81 00       	add    $0x811040,%eax
  80270f:	8b 08                	mov    (%eax),%ecx
  802711:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802714:	89 d0                	mov    %edx,%eax
  802716:	01 c0                	add    %eax,%eax
  802718:	01 d0                	add    %edx,%eax
  80271a:	c1 e0 02             	shl    $0x2,%eax
  80271d:	05 44 10 81 00       	add    $0x811044,%eax
  802722:	8b 00                	mov    (%eax),%eax
  802724:	01 c1                	add    %eax,%ecx
  802726:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802729:	89 d0                	mov    %edx,%eax
  80272b:	01 c0                	add    %eax,%eax
  80272d:	01 d0                	add    %edx,%eax
  80272f:	c1 e0 02             	shl    $0x2,%eax
  802732:	05 40 10 81 00       	add    $0x811040,%eax
  802737:	8b 00                	mov    (%eax),%eax
  802739:	39 c1                	cmp    %eax,%ecx
  80273b:	75 52                	jne    80278f <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  80273d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802740:	89 d0                	mov    %edx,%eax
  802742:	01 c0                	add    %eax,%eax
  802744:	01 d0                	add    %edx,%eax
  802746:	c1 e0 02             	shl    $0x2,%eax
  802749:	05 44 10 81 00       	add    $0x811044,%eax
  80274e:	8b 08                	mov    (%eax),%ecx
  802750:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802753:	89 d0                	mov    %edx,%eax
  802755:	01 c0                	add    %eax,%eax
  802757:	01 d0                	add    %edx,%eax
  802759:	c1 e0 02             	shl    $0x2,%eax
  80275c:	05 44 10 81 00       	add    $0x811044,%eax
  802761:	8b 00                	mov    (%eax),%eax
  802763:	01 c1                	add    %eax,%ecx
  802765:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802768:	89 d0                	mov    %edx,%eax
  80276a:	01 c0                	add    %eax,%eax
  80276c:	01 d0                	add    %edx,%eax
  80276e:	c1 e0 02             	shl    $0x2,%eax
  802771:	05 44 10 81 00       	add    $0x811044,%eax
  802776:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802778:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80277b:	89 d0                	mov    %edx,%eax
  80277d:	01 c0                	add    %eax,%eax
  80277f:	01 d0                	add    %edx,%eax
  802781:	c1 e0 02             	shl    $0x2,%eax
  802784:	05 48 10 81 00       	add    $0x811048,%eax
  802789:	c6 00 00             	movb   $0x0,(%eax)
  80278c:	eb 01                	jmp    80278f <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  80278e:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  80278f:	ff 45 e0             	incl   -0x20(%ebp)
  802792:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802799:	0f 8e 7f fe ff ff    	jle    80261e <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  80279f:	a1 30 51 83 00       	mov    0x835130,%eax
  8027a4:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  8027a7:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8027ae:	eb 53                	jmp    802803 <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  8027b0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8027b3:	89 d0                	mov    %edx,%eax
  8027b5:	01 c0                	add    %eax,%eax
  8027b7:	01 d0                	add    %edx,%eax
  8027b9:	c1 e0 02             	shl    $0x2,%eax
  8027bc:	05 48 50 80 00       	add    $0x805048,%eax
  8027c1:	8a 00                	mov    (%eax),%al
  8027c3:	84 c0                	test   %al,%al
  8027c5:	74 39                	je     802800 <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  8027c7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8027ca:	89 d0                	mov    %edx,%eax
  8027cc:	01 c0                	add    %eax,%eax
  8027ce:	01 d0                	add    %edx,%eax
  8027d0:	c1 e0 02             	shl    $0x2,%eax
  8027d3:	05 40 50 80 00       	add    $0x805040,%eax
  8027d8:	8b 08                	mov    (%eax),%ecx
  8027da:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8027dd:	89 d0                	mov    %edx,%eax
  8027df:	01 c0                	add    %eax,%eax
  8027e1:	01 d0                	add    %edx,%eax
  8027e3:	c1 e0 02             	shl    $0x2,%eax
  8027e6:	05 44 50 80 00       	add    $0x805044,%eax
  8027eb:	8b 00                	mov    (%eax),%eax
  8027ed:	01 c8                	add    %ecx,%eax
  8027ef:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  8027f2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8027f5:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8027f8:	76 06                	jbe    802800 <realloc+0x453>
  8027fa:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8027fd:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802800:	ff 45 d8             	incl   -0x28(%ebp)
  802803:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  80280a:	7e a4                	jle    8027b0 <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  80280c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80280f:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  802814:	8b 45 08             	mov    0x8(%ebp),%eax
  802817:	e9 a9 01 00 00       	jmp    8029c5 <realloc+0x618>
	}
	uint32 end = va + oldsz;
  80281c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80281f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802822:	01 d0                	add    %edx,%eax
  802824:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  802827:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  80282e:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  802835:	eb 57                	jmp    80288e <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  802837:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80283a:	89 d0                	mov    %edx,%eax
  80283c:	01 c0                	add    %eax,%eax
  80283e:	01 d0                	add    %edx,%eax
  802840:	c1 e0 02             	shl    $0x2,%eax
  802843:	05 48 10 81 00       	add    $0x811048,%eax
  802848:	8a 00                	mov    (%eax),%al
  80284a:	84 c0                	test   %al,%al
  80284c:	74 3d                	je     80288b <realloc+0x4de>
  80284e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802851:	89 d0                	mov    %edx,%eax
  802853:	01 c0                	add    %eax,%eax
  802855:	01 d0                	add    %edx,%eax
  802857:	c1 e0 02             	shl    $0x2,%eax
  80285a:	05 40 10 81 00       	add    $0x811040,%eax
  80285f:	8b 00                	mov    (%eax),%eax
  802861:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802864:	75 25                	jne    80288b <realloc+0x4de>
  802866:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802869:	89 d0                	mov    %edx,%eax
  80286b:	01 c0                	add    %eax,%eax
  80286d:	01 d0                	add    %edx,%eax
  80286f:	c1 e0 02             	shl    $0x2,%eax
  802872:	05 44 10 81 00       	add    $0x811044,%eax
  802877:	8b 10                	mov    (%eax),%edx
  802879:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80287c:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80287f:	39 c2                	cmp    %eax,%edx
  802881:	72 08                	jb     80288b <realloc+0x4de>
		{
			adjIdx = j; break;
  802883:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802886:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802889:	eb 0c                	jmp    802897 <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  80288b:	ff 45 d0             	incl   -0x30(%ebp)
  80288e:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  802895:	7e a0                	jle    802837 <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  802897:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  80289b:	0f 84 d6 00 00 00    	je     802977 <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  8028a1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8028a4:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8028a7:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  8028aa:	83 ec 08             	sub    $0x8,%esp
  8028ad:	ff 75 a0             	pushl  -0x60(%ebp)
  8028b0:	ff 75 a4             	pushl  -0x5c(%ebp)
  8028b3:	e8 cf 09 00 00       	call   803287 <sys_allocate_user_mem>
  8028b8:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  8028bb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028be:	89 d0                	mov    %edx,%eax
  8028c0:	01 c0                	add    %eax,%eax
  8028c2:	01 d0                	add    %edx,%eax
  8028c4:	c1 e0 02             	shl    $0x2,%eax
  8028c7:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8028cd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8028d0:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  8028d2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8028d5:	89 d0                	mov    %edx,%eax
  8028d7:	01 c0                	add    %eax,%eax
  8028d9:	01 d0                	add    %edx,%eax
  8028db:	c1 e0 02             	shl    $0x2,%eax
  8028de:	05 40 10 81 00       	add    $0x811040,%eax
  8028e3:	8b 10                	mov    (%eax),%edx
  8028e5:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8028e8:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8028eb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8028ee:	89 d0                	mov    %edx,%eax
  8028f0:	01 c0                	add    %eax,%eax
  8028f2:	01 d0                	add    %edx,%eax
  8028f4:	c1 e0 02             	shl    $0x2,%eax
  8028f7:	05 40 10 81 00       	add    $0x811040,%eax
  8028fc:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  8028fe:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802901:	89 d0                	mov    %edx,%eax
  802903:	01 c0                	add    %eax,%eax
  802905:	01 d0                	add    %edx,%eax
  802907:	c1 e0 02             	shl    $0x2,%eax
  80290a:	05 44 10 81 00       	add    $0x811044,%eax
  80290f:	8b 00                	mov    (%eax),%eax
  802911:	2b 45 a0             	sub    -0x60(%ebp),%eax
  802914:	89 c2                	mov    %eax,%edx
  802916:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  802919:	89 c8                	mov    %ecx,%eax
  80291b:	01 c0                	add    %eax,%eax
  80291d:	01 c8                	add    %ecx,%eax
  80291f:	c1 e0 02             	shl    $0x2,%eax
  802922:	05 44 10 81 00       	add    $0x811044,%eax
  802927:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  802929:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80292c:	89 d0                	mov    %edx,%eax
  80292e:	01 c0                	add    %eax,%eax
  802930:	01 d0                	add    %edx,%eax
  802932:	c1 e0 02             	shl    $0x2,%eax
  802935:	05 44 10 81 00       	add    $0x811044,%eax
  80293a:	8b 00                	mov    (%eax),%eax
  80293c:	85 c0                	test   %eax,%eax
  80293e:	75 14                	jne    802954 <realloc+0x5a7>
  802940:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802943:	89 d0                	mov    %edx,%eax
  802945:	01 c0                	add    %eax,%eax
  802947:	01 d0                	add    %edx,%eax
  802949:	c1 e0 02             	shl    $0x2,%eax
  80294c:	05 48 10 81 00       	add    $0x811048,%eax
  802951:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  802954:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802957:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80295a:	01 c2                	add    %eax,%edx
  80295c:	a1 88 50 83 00       	mov    0x835088,%eax
  802961:	39 c2                	cmp    %eax,%edx
  802963:	76 0d                	jbe    802972 <realloc+0x5c5>
  802965:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802968:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80296b:	01 d0                	add    %edx,%eax
  80296d:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  802972:	8b 45 08             	mov    0x8(%ebp),%eax
  802975:	eb 4e                	jmp    8029c5 <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  802977:	83 ec 0c             	sub    $0xc,%esp
  80297a:	ff 75 0c             	pushl  0xc(%ebp)
  80297d:	e8 0b ec ff ff       	call   80158d <malloc>
  802982:	83 c4 10             	add    $0x10,%esp
  802985:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  802988:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  80298c:	75 07                	jne    802995 <realloc+0x5e8>
		return NULL;
  80298e:	b8 00 00 00 00       	mov    $0x0,%eax
  802993:	eb 30                	jmp    8029c5 <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  802995:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802998:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80299b:	39 d0                	cmp    %edx,%eax
  80299d:	76 02                	jbe    8029a1 <realloc+0x5f4>
  80299f:	89 d0                	mov    %edx,%eax
  8029a1:	8b 55 9c             	mov    -0x64(%ebp),%edx
  8029a4:	83 ec 04             	sub    $0x4,%esp
  8029a7:	50                   	push   %eax
  8029a8:	52                   	push   %edx
  8029a9:	ff 75 cc             	pushl  -0x34(%ebp)
  8029ac:	e8 cf 06 00 00       	call   803080 <sys_move_user_mem>
  8029b1:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  8029b4:	83 ec 0c             	sub    $0xc,%esp
  8029b7:	ff 75 08             	pushl  0x8(%ebp)
  8029ba:	e8 2e ef ff ff       	call   8018ed <free>
  8029bf:	83 c4 10             	add    $0x10,%esp
	return newptr;
  8029c2:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  8029c5:	c9                   	leave  
  8029c6:	c3                   	ret    

008029c7 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8029c7:	55                   	push   %ebp
  8029c8:	89 e5                	mov    %esp,%ebp
  8029ca:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  8029cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d0:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  8029d3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8029d7:	0f 84 33 03 00 00    	je     802d10 <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  8029dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8029e0:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  8029e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  8029e8:	83 ec 08             	sub    $0x8,%esp
  8029eb:	ff 75 08             	pushl  0x8(%ebp)
  8029ee:	ff 75 d8             	pushl  -0x28(%ebp)
  8029f1:	e8 7d 05 00 00       	call   802f73 <sys_delete_shared_object>
  8029f6:	83 c4 10             	add    $0x10,%esp
  8029f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  8029fc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802a00:	0f 88 0d 03 00 00    	js     802d13 <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802a06:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802a0d:	e9 ef 02 00 00       	jmp    802d01 <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802a12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a15:	89 d0                	mov    %edx,%eax
  802a17:	01 c0                	add    %eax,%eax
  802a19:	01 d0                	add    %edx,%eax
  802a1b:	c1 e0 02             	shl    $0x2,%eax
  802a1e:	05 48 50 80 00       	add    $0x805048,%eax
  802a23:	8a 00                	mov    (%eax),%al
  802a25:	84 c0                	test   %al,%al
  802a27:	0f 84 d1 02 00 00    	je     802cfe <sfree+0x337>
  802a2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a30:	89 d0                	mov    %edx,%eax
  802a32:	01 c0                	add    %eax,%eax
  802a34:	01 d0                	add    %edx,%eax
  802a36:	c1 e0 02             	shl    $0x2,%eax
  802a39:	05 40 50 80 00       	add    $0x805040,%eax
  802a3e:	8b 00                	mov    (%eax),%eax
  802a40:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802a43:	0f 85 b5 02 00 00    	jne    802cfe <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  802a49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a4c:	89 d0                	mov    %edx,%eax
  802a4e:	01 c0                	add    %eax,%eax
  802a50:	01 d0                	add    %edx,%eax
  802a52:	c1 e0 02             	shl    $0x2,%eax
  802a55:	05 44 50 80 00       	add    $0x805044,%eax
  802a5a:	8b 00                	mov    (%eax),%eax
  802a5c:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  802a5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a62:	89 d0                	mov    %edx,%eax
  802a64:	01 c0                	add    %eax,%eax
  802a66:	01 d0                	add    %edx,%eax
  802a68:	c1 e0 02             	shl    $0x2,%eax
  802a6b:	05 48 50 80 00       	add    $0x805048,%eax
  802a70:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  802a73:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802a7a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802a81:	eb 64                	jmp    802ae7 <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  802a83:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a86:	89 d0                	mov    %edx,%eax
  802a88:	01 c0                	add    %eax,%eax
  802a8a:	01 d0                	add    %edx,%eax
  802a8c:	c1 e0 02             	shl    $0x2,%eax
  802a8f:	05 48 10 81 00       	add    $0x811048,%eax
  802a94:	8a 00                	mov    (%eax),%al
  802a96:	84 c0                	test   %al,%al
  802a98:	75 4a                	jne    802ae4 <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  802a9a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a9d:	89 d0                	mov    %edx,%eax
  802a9f:	01 c0                	add    %eax,%eax
  802aa1:	01 d0                	add    %edx,%eax
  802aa3:	c1 e0 02             	shl    $0x2,%eax
  802aa6:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  802aac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802aaf:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  802ab1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ab4:	89 d0                	mov    %edx,%eax
  802ab6:	01 c0                	add    %eax,%eax
  802ab8:	01 d0                	add    %edx,%eax
  802aba:	c1 e0 02             	shl    $0x2,%eax
  802abd:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  802ac3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ac6:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  802ac8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802acb:	89 d0                	mov    %edx,%eax
  802acd:	01 c0                	add    %eax,%eax
  802acf:	01 d0                	add    %edx,%eax
  802ad1:	c1 e0 02             	shl    $0x2,%eax
  802ad4:	05 48 10 81 00       	add    $0x811048,%eax
  802ad9:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  802adc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802adf:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  802ae2:	eb 0c                	jmp    802af0 <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802ae4:	ff 45 ec             	incl   -0x14(%ebp)
  802ae7:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802aee:	7e 93                	jle    802a83 <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  802af0:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802af4:	0f 84 8d 01 00 00    	je     802c87 <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802afa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802b01:	e9 74 01 00 00       	jmp    802c7a <sfree+0x2b3>
				{
					if (k == fidx) continue;
  802b06:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b09:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802b0c:	0f 84 64 01 00 00    	je     802c76 <sfree+0x2af>
					if (uhp_frees[k].free)
  802b12:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b15:	89 d0                	mov    %edx,%eax
  802b17:	01 c0                	add    %eax,%eax
  802b19:	01 d0                	add    %edx,%eax
  802b1b:	c1 e0 02             	shl    $0x2,%eax
  802b1e:	05 48 10 81 00       	add    $0x811048,%eax
  802b23:	8a 00                	mov    (%eax),%al
  802b25:	84 c0                	test   %al,%al
  802b27:	0f 84 4a 01 00 00    	je     802c77 <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802b2d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b30:	89 d0                	mov    %edx,%eax
  802b32:	01 c0                	add    %eax,%eax
  802b34:	01 d0                	add    %edx,%eax
  802b36:	c1 e0 02             	shl    $0x2,%eax
  802b39:	05 40 10 81 00       	add    $0x811040,%eax
  802b3e:	8b 08                	mov    (%eax),%ecx
  802b40:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b43:	89 d0                	mov    %edx,%eax
  802b45:	01 c0                	add    %eax,%eax
  802b47:	01 d0                	add    %edx,%eax
  802b49:	c1 e0 02             	shl    $0x2,%eax
  802b4c:	05 44 10 81 00       	add    $0x811044,%eax
  802b51:	8b 00                	mov    (%eax),%eax
  802b53:	01 c1                	add    %eax,%ecx
  802b55:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b58:	89 d0                	mov    %edx,%eax
  802b5a:	01 c0                	add    %eax,%eax
  802b5c:	01 d0                	add    %edx,%eax
  802b5e:	c1 e0 02             	shl    $0x2,%eax
  802b61:	05 40 10 81 00       	add    $0x811040,%eax
  802b66:	8b 00                	mov    (%eax),%eax
  802b68:	39 c1                	cmp    %eax,%ecx
  802b6a:	75 7a                	jne    802be6 <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  802b6c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b6f:	89 d0                	mov    %edx,%eax
  802b71:	01 c0                	add    %eax,%eax
  802b73:	01 d0                	add    %edx,%eax
  802b75:	c1 e0 02             	shl    $0x2,%eax
  802b78:	05 40 10 81 00       	add    $0x811040,%eax
  802b7d:	8b 10                	mov    (%eax),%edx
  802b7f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802b82:	89 c8                	mov    %ecx,%eax
  802b84:	01 c0                	add    %eax,%eax
  802b86:	01 c8                	add    %ecx,%eax
  802b88:	c1 e0 02             	shl    $0x2,%eax
  802b8b:	05 40 10 81 00       	add    $0x811040,%eax
  802b90:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  802b92:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b95:	89 d0                	mov    %edx,%eax
  802b97:	01 c0                	add    %eax,%eax
  802b99:	01 d0                	add    %edx,%eax
  802b9b:	c1 e0 02             	shl    $0x2,%eax
  802b9e:	05 44 10 81 00       	add    $0x811044,%eax
  802ba3:	8b 08                	mov    (%eax),%ecx
  802ba5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ba8:	89 d0                	mov    %edx,%eax
  802baa:	01 c0                	add    %eax,%eax
  802bac:	01 d0                	add    %edx,%eax
  802bae:	c1 e0 02             	shl    $0x2,%eax
  802bb1:	05 44 10 81 00       	add    $0x811044,%eax
  802bb6:	8b 00                	mov    (%eax),%eax
  802bb8:	01 c1                	add    %eax,%ecx
  802bba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bbd:	89 d0                	mov    %edx,%eax
  802bbf:	01 c0                	add    %eax,%eax
  802bc1:	01 d0                	add    %edx,%eax
  802bc3:	c1 e0 02             	shl    $0x2,%eax
  802bc6:	05 44 10 81 00       	add    $0x811044,%eax
  802bcb:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802bcd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bd0:	89 d0                	mov    %edx,%eax
  802bd2:	01 c0                	add    %eax,%eax
  802bd4:	01 d0                	add    %edx,%eax
  802bd6:	c1 e0 02             	shl    $0x2,%eax
  802bd9:	05 48 10 81 00       	add    $0x811048,%eax
  802bde:	c6 00 00             	movb   $0x0,(%eax)
  802be1:	e9 91 00 00 00       	jmp    802c77 <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802be6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802be9:	89 d0                	mov    %edx,%eax
  802beb:	01 c0                	add    %eax,%eax
  802bed:	01 d0                	add    %edx,%eax
  802bef:	c1 e0 02             	shl    $0x2,%eax
  802bf2:	05 40 10 81 00       	add    $0x811040,%eax
  802bf7:	8b 08                	mov    (%eax),%ecx
  802bf9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bfc:	89 d0                	mov    %edx,%eax
  802bfe:	01 c0                	add    %eax,%eax
  802c00:	01 d0                	add    %edx,%eax
  802c02:	c1 e0 02             	shl    $0x2,%eax
  802c05:	05 44 10 81 00       	add    $0x811044,%eax
  802c0a:	8b 00                	mov    (%eax),%eax
  802c0c:	01 c1                	add    %eax,%ecx
  802c0e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c11:	89 d0                	mov    %edx,%eax
  802c13:	01 c0                	add    %eax,%eax
  802c15:	01 d0                	add    %edx,%eax
  802c17:	c1 e0 02             	shl    $0x2,%eax
  802c1a:	05 40 10 81 00       	add    $0x811040,%eax
  802c1f:	8b 00                	mov    (%eax),%eax
  802c21:	39 c1                	cmp    %eax,%ecx
  802c23:	75 52                	jne    802c77 <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  802c25:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c28:	89 d0                	mov    %edx,%eax
  802c2a:	01 c0                	add    %eax,%eax
  802c2c:	01 d0                	add    %edx,%eax
  802c2e:	c1 e0 02             	shl    $0x2,%eax
  802c31:	05 44 10 81 00       	add    $0x811044,%eax
  802c36:	8b 08                	mov    (%eax),%ecx
  802c38:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c3b:	89 d0                	mov    %edx,%eax
  802c3d:	01 c0                	add    %eax,%eax
  802c3f:	01 d0                	add    %edx,%eax
  802c41:	c1 e0 02             	shl    $0x2,%eax
  802c44:	05 44 10 81 00       	add    $0x811044,%eax
  802c49:	8b 00                	mov    (%eax),%eax
  802c4b:	01 c1                	add    %eax,%ecx
  802c4d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c50:	89 d0                	mov    %edx,%eax
  802c52:	01 c0                	add    %eax,%eax
  802c54:	01 d0                	add    %edx,%eax
  802c56:	c1 e0 02             	shl    $0x2,%eax
  802c59:	05 44 10 81 00       	add    $0x811044,%eax
  802c5e:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802c60:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c63:	89 d0                	mov    %edx,%eax
  802c65:	01 c0                	add    %eax,%eax
  802c67:	01 d0                	add    %edx,%eax
  802c69:	c1 e0 02             	shl    $0x2,%eax
  802c6c:	05 48 10 81 00       	add    $0x811048,%eax
  802c71:	c6 00 00             	movb   $0x0,(%eax)
  802c74:	eb 01                	jmp    802c77 <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  802c76:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802c77:	ff 45 e8             	incl   -0x18(%ebp)
  802c7a:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802c81:	0f 8e 7f fe ff ff    	jle    802b06 <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  802c87:	a1 30 51 83 00       	mov    0x835130,%eax
  802c8c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802c8f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802c96:	eb 53                	jmp    802ceb <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  802c98:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c9b:	89 d0                	mov    %edx,%eax
  802c9d:	01 c0                	add    %eax,%eax
  802c9f:	01 d0                	add    %edx,%eax
  802ca1:	c1 e0 02             	shl    $0x2,%eax
  802ca4:	05 48 50 80 00       	add    $0x805048,%eax
  802ca9:	8a 00                	mov    (%eax),%al
  802cab:	84 c0                	test   %al,%al
  802cad:	74 39                	je     802ce8 <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802caf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cb2:	89 d0                	mov    %edx,%eax
  802cb4:	01 c0                	add    %eax,%eax
  802cb6:	01 d0                	add    %edx,%eax
  802cb8:	c1 e0 02             	shl    $0x2,%eax
  802cbb:	05 40 50 80 00       	add    $0x805040,%eax
  802cc0:	8b 08                	mov    (%eax),%ecx
  802cc2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cc5:	89 d0                	mov    %edx,%eax
  802cc7:	01 c0                	add    %eax,%eax
  802cc9:	01 d0                	add    %edx,%eax
  802ccb:	c1 e0 02             	shl    $0x2,%eax
  802cce:	05 44 50 80 00       	add    $0x805044,%eax
  802cd3:	8b 00                	mov    (%eax),%eax
  802cd5:	01 c8                	add    %ecx,%eax
  802cd7:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  802cda:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cdd:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802ce0:	76 06                	jbe    802ce8 <sfree+0x321>
  802ce2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ce5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802ce8:	ff 45 e0             	incl   -0x20(%ebp)
  802ceb:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802cf2:	7e a4                	jle    802c98 <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  802cf4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cf7:	a3 88 50 83 00       	mov    %eax,0x835088
			break;
  802cfc:	eb 16                	jmp    802d14 <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802cfe:	ff 45 f4             	incl   -0xc(%ebp)
  802d01:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  802d08:	0f 8e 04 fd ff ff    	jle    802a12 <sfree+0x4b>
  802d0e:	eb 04                	jmp    802d14 <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  802d10:	90                   	nop
  802d11:	eb 01                	jmp    802d14 <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  802d13:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  802d14:	c9                   	leave  
  802d15:	c3                   	ret    

00802d16 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802d16:	55                   	push   %ebp
  802d17:	89 e5                	mov    %esp,%ebp
  802d19:	57                   	push   %edi
  802d1a:	56                   	push   %esi
  802d1b:	53                   	push   %ebx
  802d1c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d22:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d25:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802d28:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802d2b:	8b 7d 18             	mov    0x18(%ebp),%edi
  802d2e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802d31:	cd 30                	int    $0x30
  802d33:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802d36:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802d39:	83 c4 10             	add    $0x10,%esp
  802d3c:	5b                   	pop    %ebx
  802d3d:	5e                   	pop    %esi
  802d3e:	5f                   	pop    %edi
  802d3f:	5d                   	pop    %ebp
  802d40:	c3                   	ret    

00802d41 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802d41:	55                   	push   %ebp
  802d42:	89 e5                	mov    %esp,%ebp
  802d44:	83 ec 04             	sub    $0x4,%esp
  802d47:	8b 45 10             	mov    0x10(%ebp),%eax
  802d4a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802d4d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802d50:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802d54:	8b 45 08             	mov    0x8(%ebp),%eax
  802d57:	6a 00                	push   $0x0
  802d59:	51                   	push   %ecx
  802d5a:	52                   	push   %edx
  802d5b:	ff 75 0c             	pushl  0xc(%ebp)
  802d5e:	50                   	push   %eax
  802d5f:	6a 00                	push   $0x0
  802d61:	e8 b0 ff ff ff       	call   802d16 <syscall>
  802d66:	83 c4 18             	add    $0x18,%esp
}
  802d69:	90                   	nop
  802d6a:	c9                   	leave  
  802d6b:	c3                   	ret    

00802d6c <sys_cgetc>:

int
sys_cgetc(void)
{
  802d6c:	55                   	push   %ebp
  802d6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802d6f:	6a 00                	push   $0x0
  802d71:	6a 00                	push   $0x0
  802d73:	6a 00                	push   $0x0
  802d75:	6a 00                	push   $0x0
  802d77:	6a 00                	push   $0x0
  802d79:	6a 02                	push   $0x2
  802d7b:	e8 96 ff ff ff       	call   802d16 <syscall>
  802d80:	83 c4 18             	add    $0x18,%esp
}
  802d83:	c9                   	leave  
  802d84:	c3                   	ret    

00802d85 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802d85:	55                   	push   %ebp
  802d86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802d88:	6a 00                	push   $0x0
  802d8a:	6a 00                	push   $0x0
  802d8c:	6a 00                	push   $0x0
  802d8e:	6a 00                	push   $0x0
  802d90:	6a 00                	push   $0x0
  802d92:	6a 03                	push   $0x3
  802d94:	e8 7d ff ff ff       	call   802d16 <syscall>
  802d99:	83 c4 18             	add    $0x18,%esp
}
  802d9c:	90                   	nop
  802d9d:	c9                   	leave  
  802d9e:	c3                   	ret    

00802d9f <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802d9f:	55                   	push   %ebp
  802da0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802da2:	6a 00                	push   $0x0
  802da4:	6a 00                	push   $0x0
  802da6:	6a 00                	push   $0x0
  802da8:	6a 00                	push   $0x0
  802daa:	6a 00                	push   $0x0
  802dac:	6a 04                	push   $0x4
  802dae:	e8 63 ff ff ff       	call   802d16 <syscall>
  802db3:	83 c4 18             	add    $0x18,%esp
}
  802db6:	90                   	nop
  802db7:	c9                   	leave  
  802db8:	c3                   	ret    

00802db9 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802db9:	55                   	push   %ebp
  802dba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802dbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  802dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc2:	6a 00                	push   $0x0
  802dc4:	6a 00                	push   $0x0
  802dc6:	6a 00                	push   $0x0
  802dc8:	52                   	push   %edx
  802dc9:	50                   	push   %eax
  802dca:	6a 08                	push   $0x8
  802dcc:	e8 45 ff ff ff       	call   802d16 <syscall>
  802dd1:	83 c4 18             	add    $0x18,%esp
}
  802dd4:	c9                   	leave  
  802dd5:	c3                   	ret    

00802dd6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802dd6:	55                   	push   %ebp
  802dd7:	89 e5                	mov    %esp,%ebp
  802dd9:	56                   	push   %esi
  802dda:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802ddb:	8b 75 18             	mov    0x18(%ebp),%esi
  802dde:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802de1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802de4:	8b 55 0c             	mov    0xc(%ebp),%edx
  802de7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dea:	56                   	push   %esi
  802deb:	53                   	push   %ebx
  802dec:	51                   	push   %ecx
  802ded:	52                   	push   %edx
  802dee:	50                   	push   %eax
  802def:	6a 09                	push   $0x9
  802df1:	e8 20 ff ff ff       	call   802d16 <syscall>
  802df6:	83 c4 18             	add    $0x18,%esp
}
  802df9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802dfc:	5b                   	pop    %ebx
  802dfd:	5e                   	pop    %esi
  802dfe:	5d                   	pop    %ebp
  802dff:	c3                   	ret    

00802e00 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802e00:	55                   	push   %ebp
  802e01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802e03:	6a 00                	push   $0x0
  802e05:	6a 00                	push   $0x0
  802e07:	6a 00                	push   $0x0
  802e09:	6a 00                	push   $0x0
  802e0b:	ff 75 08             	pushl  0x8(%ebp)
  802e0e:	6a 0a                	push   $0xa
  802e10:	e8 01 ff ff ff       	call   802d16 <syscall>
  802e15:	83 c4 18             	add    $0x18,%esp
}
  802e18:	c9                   	leave  
  802e19:	c3                   	ret    

00802e1a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802e1a:	55                   	push   %ebp
  802e1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802e1d:	6a 00                	push   $0x0
  802e1f:	6a 00                	push   $0x0
  802e21:	6a 00                	push   $0x0
  802e23:	ff 75 0c             	pushl  0xc(%ebp)
  802e26:	ff 75 08             	pushl  0x8(%ebp)
  802e29:	6a 0b                	push   $0xb
  802e2b:	e8 e6 fe ff ff       	call   802d16 <syscall>
  802e30:	83 c4 18             	add    $0x18,%esp
}
  802e33:	c9                   	leave  
  802e34:	c3                   	ret    

00802e35 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802e35:	55                   	push   %ebp
  802e36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802e38:	6a 00                	push   $0x0
  802e3a:	6a 00                	push   $0x0
  802e3c:	6a 00                	push   $0x0
  802e3e:	6a 00                	push   $0x0
  802e40:	6a 00                	push   $0x0
  802e42:	6a 0c                	push   $0xc
  802e44:	e8 cd fe ff ff       	call   802d16 <syscall>
  802e49:	83 c4 18             	add    $0x18,%esp
}
  802e4c:	c9                   	leave  
  802e4d:	c3                   	ret    

00802e4e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802e4e:	55                   	push   %ebp
  802e4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802e51:	6a 00                	push   $0x0
  802e53:	6a 00                	push   $0x0
  802e55:	6a 00                	push   $0x0
  802e57:	6a 00                	push   $0x0
  802e59:	6a 00                	push   $0x0
  802e5b:	6a 0d                	push   $0xd
  802e5d:	e8 b4 fe ff ff       	call   802d16 <syscall>
  802e62:	83 c4 18             	add    $0x18,%esp
}
  802e65:	c9                   	leave  
  802e66:	c3                   	ret    

00802e67 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802e67:	55                   	push   %ebp
  802e68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802e6a:	6a 00                	push   $0x0
  802e6c:	6a 00                	push   $0x0
  802e6e:	6a 00                	push   $0x0
  802e70:	6a 00                	push   $0x0
  802e72:	6a 00                	push   $0x0
  802e74:	6a 0e                	push   $0xe
  802e76:	e8 9b fe ff ff       	call   802d16 <syscall>
  802e7b:	83 c4 18             	add    $0x18,%esp
}
  802e7e:	c9                   	leave  
  802e7f:	c3                   	ret    

00802e80 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802e80:	55                   	push   %ebp
  802e81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802e83:	6a 00                	push   $0x0
  802e85:	6a 00                	push   $0x0
  802e87:	6a 00                	push   $0x0
  802e89:	6a 00                	push   $0x0
  802e8b:	6a 00                	push   $0x0
  802e8d:	6a 0f                	push   $0xf
  802e8f:	e8 82 fe ff ff       	call   802d16 <syscall>
  802e94:	83 c4 18             	add    $0x18,%esp
}
  802e97:	c9                   	leave  
  802e98:	c3                   	ret    

00802e99 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802e99:	55                   	push   %ebp
  802e9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802e9c:	6a 00                	push   $0x0
  802e9e:	6a 00                	push   $0x0
  802ea0:	6a 00                	push   $0x0
  802ea2:	6a 00                	push   $0x0
  802ea4:	ff 75 08             	pushl  0x8(%ebp)
  802ea7:	6a 10                	push   $0x10
  802ea9:	e8 68 fe ff ff       	call   802d16 <syscall>
  802eae:	83 c4 18             	add    $0x18,%esp
}
  802eb1:	c9                   	leave  
  802eb2:	c3                   	ret    

00802eb3 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802eb3:	55                   	push   %ebp
  802eb4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802eb6:	6a 00                	push   $0x0
  802eb8:	6a 00                	push   $0x0
  802eba:	6a 00                	push   $0x0
  802ebc:	6a 00                	push   $0x0
  802ebe:	6a 00                	push   $0x0
  802ec0:	6a 11                	push   $0x11
  802ec2:	e8 4f fe ff ff       	call   802d16 <syscall>
  802ec7:	83 c4 18             	add    $0x18,%esp
}
  802eca:	90                   	nop
  802ecb:	c9                   	leave  
  802ecc:	c3                   	ret    

00802ecd <sys_cputc>:

void
sys_cputc(const char c)
{
  802ecd:	55                   	push   %ebp
  802ece:	89 e5                	mov    %esp,%ebp
  802ed0:	83 ec 04             	sub    $0x4,%esp
  802ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802ed9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802edd:	6a 00                	push   $0x0
  802edf:	6a 00                	push   $0x0
  802ee1:	6a 00                	push   $0x0
  802ee3:	6a 00                	push   $0x0
  802ee5:	50                   	push   %eax
  802ee6:	6a 01                	push   $0x1
  802ee8:	e8 29 fe ff ff       	call   802d16 <syscall>
  802eed:	83 c4 18             	add    $0x18,%esp
}
  802ef0:	90                   	nop
  802ef1:	c9                   	leave  
  802ef2:	c3                   	ret    

00802ef3 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802ef3:	55                   	push   %ebp
  802ef4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802ef6:	6a 00                	push   $0x0
  802ef8:	6a 00                	push   $0x0
  802efa:	6a 00                	push   $0x0
  802efc:	6a 00                	push   $0x0
  802efe:	6a 00                	push   $0x0
  802f00:	6a 14                	push   $0x14
  802f02:	e8 0f fe ff ff       	call   802d16 <syscall>
  802f07:	83 c4 18             	add    $0x18,%esp
}
  802f0a:	90                   	nop
  802f0b:	c9                   	leave  
  802f0c:	c3                   	ret    

00802f0d <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802f0d:	55                   	push   %ebp
  802f0e:	89 e5                	mov    %esp,%ebp
  802f10:	83 ec 04             	sub    $0x4,%esp
  802f13:	8b 45 10             	mov    0x10(%ebp),%eax
  802f16:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802f19:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802f1c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802f20:	8b 45 08             	mov    0x8(%ebp),%eax
  802f23:	6a 00                	push   $0x0
  802f25:	51                   	push   %ecx
  802f26:	52                   	push   %edx
  802f27:	ff 75 0c             	pushl  0xc(%ebp)
  802f2a:	50                   	push   %eax
  802f2b:	6a 15                	push   $0x15
  802f2d:	e8 e4 fd ff ff       	call   802d16 <syscall>
  802f32:	83 c4 18             	add    $0x18,%esp
}
  802f35:	c9                   	leave  
  802f36:	c3                   	ret    

00802f37 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802f37:	55                   	push   %ebp
  802f38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802f3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f40:	6a 00                	push   $0x0
  802f42:	6a 00                	push   $0x0
  802f44:	6a 00                	push   $0x0
  802f46:	52                   	push   %edx
  802f47:	50                   	push   %eax
  802f48:	6a 16                	push   $0x16
  802f4a:	e8 c7 fd ff ff       	call   802d16 <syscall>
  802f4f:	83 c4 18             	add    $0x18,%esp
}
  802f52:	c9                   	leave  
  802f53:	c3                   	ret    

00802f54 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802f54:	55                   	push   %ebp
  802f55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802f57:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802f5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f60:	6a 00                	push   $0x0
  802f62:	6a 00                	push   $0x0
  802f64:	51                   	push   %ecx
  802f65:	52                   	push   %edx
  802f66:	50                   	push   %eax
  802f67:	6a 17                	push   $0x17
  802f69:	e8 a8 fd ff ff       	call   802d16 <syscall>
  802f6e:	83 c4 18             	add    $0x18,%esp
}
  802f71:	c9                   	leave  
  802f72:	c3                   	ret    

00802f73 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802f73:	55                   	push   %ebp
  802f74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802f76:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f79:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7c:	6a 00                	push   $0x0
  802f7e:	6a 00                	push   $0x0
  802f80:	6a 00                	push   $0x0
  802f82:	52                   	push   %edx
  802f83:	50                   	push   %eax
  802f84:	6a 18                	push   $0x18
  802f86:	e8 8b fd ff ff       	call   802d16 <syscall>
  802f8b:	83 c4 18             	add    $0x18,%esp
}
  802f8e:	c9                   	leave  
  802f8f:	c3                   	ret    

00802f90 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802f90:	55                   	push   %ebp
  802f91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802f93:	8b 45 08             	mov    0x8(%ebp),%eax
  802f96:	6a 00                	push   $0x0
  802f98:	ff 75 14             	pushl  0x14(%ebp)
  802f9b:	ff 75 10             	pushl  0x10(%ebp)
  802f9e:	ff 75 0c             	pushl  0xc(%ebp)
  802fa1:	50                   	push   %eax
  802fa2:	6a 19                	push   $0x19
  802fa4:	e8 6d fd ff ff       	call   802d16 <syscall>
  802fa9:	83 c4 18             	add    $0x18,%esp
}
  802fac:	c9                   	leave  
  802fad:	c3                   	ret    

00802fae <sys_run_env>:

void sys_run_env(int32 envId)
{
  802fae:	55                   	push   %ebp
  802faf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb4:	6a 00                	push   $0x0
  802fb6:	6a 00                	push   $0x0
  802fb8:	6a 00                	push   $0x0
  802fba:	6a 00                	push   $0x0
  802fbc:	50                   	push   %eax
  802fbd:	6a 1a                	push   $0x1a
  802fbf:	e8 52 fd ff ff       	call   802d16 <syscall>
  802fc4:	83 c4 18             	add    $0x18,%esp
}
  802fc7:	90                   	nop
  802fc8:	c9                   	leave  
  802fc9:	c3                   	ret    

00802fca <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802fca:	55                   	push   %ebp
  802fcb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd0:	6a 00                	push   $0x0
  802fd2:	6a 00                	push   $0x0
  802fd4:	6a 00                	push   $0x0
  802fd6:	6a 00                	push   $0x0
  802fd8:	50                   	push   %eax
  802fd9:	6a 1b                	push   $0x1b
  802fdb:	e8 36 fd ff ff       	call   802d16 <syscall>
  802fe0:	83 c4 18             	add    $0x18,%esp
}
  802fe3:	c9                   	leave  
  802fe4:	c3                   	ret    

00802fe5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802fe5:	55                   	push   %ebp
  802fe6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802fe8:	6a 00                	push   $0x0
  802fea:	6a 00                	push   $0x0
  802fec:	6a 00                	push   $0x0
  802fee:	6a 00                	push   $0x0
  802ff0:	6a 00                	push   $0x0
  802ff2:	6a 05                	push   $0x5
  802ff4:	e8 1d fd ff ff       	call   802d16 <syscall>
  802ff9:	83 c4 18             	add    $0x18,%esp
}
  802ffc:	c9                   	leave  
  802ffd:	c3                   	ret    

00802ffe <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802ffe:	55                   	push   %ebp
  802fff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  803001:	6a 00                	push   $0x0
  803003:	6a 00                	push   $0x0
  803005:	6a 00                	push   $0x0
  803007:	6a 00                	push   $0x0
  803009:	6a 00                	push   $0x0
  80300b:	6a 06                	push   $0x6
  80300d:	e8 04 fd ff ff       	call   802d16 <syscall>
  803012:	83 c4 18             	add    $0x18,%esp
}
  803015:	c9                   	leave  
  803016:	c3                   	ret    

00803017 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  803017:	55                   	push   %ebp
  803018:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80301a:	6a 00                	push   $0x0
  80301c:	6a 00                	push   $0x0
  80301e:	6a 00                	push   $0x0
  803020:	6a 00                	push   $0x0
  803022:	6a 00                	push   $0x0
  803024:	6a 07                	push   $0x7
  803026:	e8 eb fc ff ff       	call   802d16 <syscall>
  80302b:	83 c4 18             	add    $0x18,%esp
}
  80302e:	c9                   	leave  
  80302f:	c3                   	ret    

00803030 <sys_exit_env>:


void sys_exit_env(void)
{
  803030:	55                   	push   %ebp
  803031:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  803033:	6a 00                	push   $0x0
  803035:	6a 00                	push   $0x0
  803037:	6a 00                	push   $0x0
  803039:	6a 00                	push   $0x0
  80303b:	6a 00                	push   $0x0
  80303d:	6a 1c                	push   $0x1c
  80303f:	e8 d2 fc ff ff       	call   802d16 <syscall>
  803044:	83 c4 18             	add    $0x18,%esp
}
  803047:	90                   	nop
  803048:	c9                   	leave  
  803049:	c3                   	ret    

0080304a <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80304a:	55                   	push   %ebp
  80304b:	89 e5                	mov    %esp,%ebp
  80304d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  803050:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803053:	8d 50 04             	lea    0x4(%eax),%edx
  803056:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803059:	6a 00                	push   $0x0
  80305b:	6a 00                	push   $0x0
  80305d:	6a 00                	push   $0x0
  80305f:	52                   	push   %edx
  803060:	50                   	push   %eax
  803061:	6a 1d                	push   $0x1d
  803063:	e8 ae fc ff ff       	call   802d16 <syscall>
  803068:	83 c4 18             	add    $0x18,%esp
	return result;
  80306b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80306e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803071:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803074:	89 01                	mov    %eax,(%ecx)
  803076:	89 51 04             	mov    %edx,0x4(%ecx)
}
  803079:	8b 45 08             	mov    0x8(%ebp),%eax
  80307c:	c9                   	leave  
  80307d:	c2 04 00             	ret    $0x4

00803080 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  803080:	55                   	push   %ebp
  803081:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  803083:	6a 00                	push   $0x0
  803085:	6a 00                	push   $0x0
  803087:	ff 75 10             	pushl  0x10(%ebp)
  80308a:	ff 75 0c             	pushl  0xc(%ebp)
  80308d:	ff 75 08             	pushl  0x8(%ebp)
  803090:	6a 13                	push   $0x13
  803092:	e8 7f fc ff ff       	call   802d16 <syscall>
  803097:	83 c4 18             	add    $0x18,%esp
	return ;
  80309a:	90                   	nop
}
  80309b:	c9                   	leave  
  80309c:	c3                   	ret    

0080309d <sys_rcr2>:
uint32 sys_rcr2()
{
  80309d:	55                   	push   %ebp
  80309e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8030a0:	6a 00                	push   $0x0
  8030a2:	6a 00                	push   $0x0
  8030a4:	6a 00                	push   $0x0
  8030a6:	6a 00                	push   $0x0
  8030a8:	6a 00                	push   $0x0
  8030aa:	6a 1e                	push   $0x1e
  8030ac:	e8 65 fc ff ff       	call   802d16 <syscall>
  8030b1:	83 c4 18             	add    $0x18,%esp
}
  8030b4:	c9                   	leave  
  8030b5:	c3                   	ret    

008030b6 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8030b6:	55                   	push   %ebp
  8030b7:	89 e5                	mov    %esp,%ebp
  8030b9:	83 ec 04             	sub    $0x4,%esp
  8030bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8030c2:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8030c6:	6a 00                	push   $0x0
  8030c8:	6a 00                	push   $0x0
  8030ca:	6a 00                	push   $0x0
  8030cc:	6a 00                	push   $0x0
  8030ce:	50                   	push   %eax
  8030cf:	6a 1f                	push   $0x1f
  8030d1:	e8 40 fc ff ff       	call   802d16 <syscall>
  8030d6:	83 c4 18             	add    $0x18,%esp
	return ;
  8030d9:	90                   	nop
}
  8030da:	c9                   	leave  
  8030db:	c3                   	ret    

008030dc <rsttst>:
void rsttst()
{
  8030dc:	55                   	push   %ebp
  8030dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8030df:	6a 00                	push   $0x0
  8030e1:	6a 00                	push   $0x0
  8030e3:	6a 00                	push   $0x0
  8030e5:	6a 00                	push   $0x0
  8030e7:	6a 00                	push   $0x0
  8030e9:	6a 21                	push   $0x21
  8030eb:	e8 26 fc ff ff       	call   802d16 <syscall>
  8030f0:	83 c4 18             	add    $0x18,%esp
	return ;
  8030f3:	90                   	nop
}
  8030f4:	c9                   	leave  
  8030f5:	c3                   	ret    

008030f6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8030f6:	55                   	push   %ebp
  8030f7:	89 e5                	mov    %esp,%ebp
  8030f9:	83 ec 04             	sub    $0x4,%esp
  8030fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8030ff:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803102:	8b 55 18             	mov    0x18(%ebp),%edx
  803105:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803109:	52                   	push   %edx
  80310a:	50                   	push   %eax
  80310b:	ff 75 10             	pushl  0x10(%ebp)
  80310e:	ff 75 0c             	pushl  0xc(%ebp)
  803111:	ff 75 08             	pushl  0x8(%ebp)
  803114:	6a 20                	push   $0x20
  803116:	e8 fb fb ff ff       	call   802d16 <syscall>
  80311b:	83 c4 18             	add    $0x18,%esp
	return ;
  80311e:	90                   	nop
}
  80311f:	c9                   	leave  
  803120:	c3                   	ret    

00803121 <chktst>:
void chktst(uint32 n)
{
  803121:	55                   	push   %ebp
  803122:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803124:	6a 00                	push   $0x0
  803126:	6a 00                	push   $0x0
  803128:	6a 00                	push   $0x0
  80312a:	6a 00                	push   $0x0
  80312c:	ff 75 08             	pushl  0x8(%ebp)
  80312f:	6a 22                	push   $0x22
  803131:	e8 e0 fb ff ff       	call   802d16 <syscall>
  803136:	83 c4 18             	add    $0x18,%esp
	return ;
  803139:	90                   	nop
}
  80313a:	c9                   	leave  
  80313b:	c3                   	ret    

0080313c <inctst>:

void inctst()
{
  80313c:	55                   	push   %ebp
  80313d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80313f:	6a 00                	push   $0x0
  803141:	6a 00                	push   $0x0
  803143:	6a 00                	push   $0x0
  803145:	6a 00                	push   $0x0
  803147:	6a 00                	push   $0x0
  803149:	6a 23                	push   $0x23
  80314b:	e8 c6 fb ff ff       	call   802d16 <syscall>
  803150:	83 c4 18             	add    $0x18,%esp
	return ;
  803153:	90                   	nop
}
  803154:	c9                   	leave  
  803155:	c3                   	ret    

00803156 <gettst>:
uint32 gettst()
{
  803156:	55                   	push   %ebp
  803157:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803159:	6a 00                	push   $0x0
  80315b:	6a 00                	push   $0x0
  80315d:	6a 00                	push   $0x0
  80315f:	6a 00                	push   $0x0
  803161:	6a 00                	push   $0x0
  803163:	6a 24                	push   $0x24
  803165:	e8 ac fb ff ff       	call   802d16 <syscall>
  80316a:	83 c4 18             	add    $0x18,%esp
}
  80316d:	c9                   	leave  
  80316e:	c3                   	ret    

0080316f <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80316f:	55                   	push   %ebp
  803170:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803172:	6a 00                	push   $0x0
  803174:	6a 00                	push   $0x0
  803176:	6a 00                	push   $0x0
  803178:	6a 00                	push   $0x0
  80317a:	6a 00                	push   $0x0
  80317c:	6a 25                	push   $0x25
  80317e:	e8 93 fb ff ff       	call   802d16 <syscall>
  803183:	83 c4 18             	add    $0x18,%esp
  803186:	a3 80 50 83 00       	mov    %eax,0x835080
	return uheapPlaceStrategy ;
  80318b:	a1 80 50 83 00       	mov    0x835080,%eax
}
  803190:	c9                   	leave  
  803191:	c3                   	ret    

00803192 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803192:	55                   	push   %ebp
  803193:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  803195:	8b 45 08             	mov    0x8(%ebp),%eax
  803198:	a3 80 50 83 00       	mov    %eax,0x835080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80319d:	6a 00                	push   $0x0
  80319f:	6a 00                	push   $0x0
  8031a1:	6a 00                	push   $0x0
  8031a3:	6a 00                	push   $0x0
  8031a5:	ff 75 08             	pushl  0x8(%ebp)
  8031a8:	6a 26                	push   $0x26
  8031aa:	e8 67 fb ff ff       	call   802d16 <syscall>
  8031af:	83 c4 18             	add    $0x18,%esp
	return ;
  8031b2:	90                   	nop
}
  8031b3:	c9                   	leave  
  8031b4:	c3                   	ret    

008031b5 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8031b5:	55                   	push   %ebp
  8031b6:	89 e5                	mov    %esp,%ebp
  8031b8:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8031b9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8031bc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8031bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c5:	6a 00                	push   $0x0
  8031c7:	53                   	push   %ebx
  8031c8:	51                   	push   %ecx
  8031c9:	52                   	push   %edx
  8031ca:	50                   	push   %eax
  8031cb:	6a 27                	push   $0x27
  8031cd:	e8 44 fb ff ff       	call   802d16 <syscall>
  8031d2:	83 c4 18             	add    $0x18,%esp
}
  8031d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8031d8:	c9                   	leave  
  8031d9:	c3                   	ret    

008031da <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8031da:	55                   	push   %ebp
  8031db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8031dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e3:	6a 00                	push   $0x0
  8031e5:	6a 00                	push   $0x0
  8031e7:	6a 00                	push   $0x0
  8031e9:	52                   	push   %edx
  8031ea:	50                   	push   %eax
  8031eb:	6a 28                	push   $0x28
  8031ed:	e8 24 fb ff ff       	call   802d16 <syscall>
  8031f2:	83 c4 18             	add    $0x18,%esp
}
  8031f5:	c9                   	leave  
  8031f6:	c3                   	ret    

008031f7 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8031f7:	55                   	push   %ebp
  8031f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8031fa:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8031fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  803200:	8b 45 08             	mov    0x8(%ebp),%eax
  803203:	6a 00                	push   $0x0
  803205:	51                   	push   %ecx
  803206:	ff 75 10             	pushl  0x10(%ebp)
  803209:	52                   	push   %edx
  80320a:	50                   	push   %eax
  80320b:	6a 29                	push   $0x29
  80320d:	e8 04 fb ff ff       	call   802d16 <syscall>
  803212:	83 c4 18             	add    $0x18,%esp
}
  803215:	c9                   	leave  
  803216:	c3                   	ret    

00803217 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  803217:	55                   	push   %ebp
  803218:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80321a:	6a 00                	push   $0x0
  80321c:	6a 00                	push   $0x0
  80321e:	ff 75 10             	pushl  0x10(%ebp)
  803221:	ff 75 0c             	pushl  0xc(%ebp)
  803224:	ff 75 08             	pushl  0x8(%ebp)
  803227:	6a 12                	push   $0x12
  803229:	e8 e8 fa ff ff       	call   802d16 <syscall>
  80322e:	83 c4 18             	add    $0x18,%esp
	return ;
  803231:	90                   	nop
}
  803232:	c9                   	leave  
  803233:	c3                   	ret    

00803234 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  803234:	55                   	push   %ebp
  803235:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  803237:	8b 55 0c             	mov    0xc(%ebp),%edx
  80323a:	8b 45 08             	mov    0x8(%ebp),%eax
  80323d:	6a 00                	push   $0x0
  80323f:	6a 00                	push   $0x0
  803241:	6a 00                	push   $0x0
  803243:	52                   	push   %edx
  803244:	50                   	push   %eax
  803245:	6a 2a                	push   $0x2a
  803247:	e8 ca fa ff ff       	call   802d16 <syscall>
  80324c:	83 c4 18             	add    $0x18,%esp
	return;
  80324f:	90                   	nop
}
  803250:	c9                   	leave  
  803251:	c3                   	ret    

00803252 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  803252:	55                   	push   %ebp
  803253:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  803255:	6a 00                	push   $0x0
  803257:	6a 00                	push   $0x0
  803259:	6a 00                	push   $0x0
  80325b:	6a 00                	push   $0x0
  80325d:	6a 00                	push   $0x0
  80325f:	6a 2b                	push   $0x2b
  803261:	e8 b0 fa ff ff       	call   802d16 <syscall>
  803266:	83 c4 18             	add    $0x18,%esp
}
  803269:	c9                   	leave  
  80326a:	c3                   	ret    

0080326b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80326b:	55                   	push   %ebp
  80326c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80326e:	6a 00                	push   $0x0
  803270:	6a 00                	push   $0x0
  803272:	6a 00                	push   $0x0
  803274:	ff 75 0c             	pushl  0xc(%ebp)
  803277:	ff 75 08             	pushl  0x8(%ebp)
  80327a:	6a 2d                	push   $0x2d
  80327c:	e8 95 fa ff ff       	call   802d16 <syscall>
  803281:	83 c4 18             	add    $0x18,%esp
	return;
  803284:	90                   	nop
}
  803285:	c9                   	leave  
  803286:	c3                   	ret    

00803287 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  803287:	55                   	push   %ebp
  803288:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80328a:	6a 00                	push   $0x0
  80328c:	6a 00                	push   $0x0
  80328e:	6a 00                	push   $0x0
  803290:	ff 75 0c             	pushl  0xc(%ebp)
  803293:	ff 75 08             	pushl  0x8(%ebp)
  803296:	6a 2c                	push   $0x2c
  803298:	e8 79 fa ff ff       	call   802d16 <syscall>
  80329d:	83 c4 18             	add    $0x18,%esp
	return ;
  8032a0:	90                   	nop
}
  8032a1:	c9                   	leave  
  8032a2:	c3                   	ret    

008032a3 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8032a3:	55                   	push   %ebp
  8032a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8032a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ac:	6a 00                	push   $0x0
  8032ae:	6a 00                	push   $0x0
  8032b0:	6a 00                	push   $0x0
  8032b2:	52                   	push   %edx
  8032b3:	50                   	push   %eax
  8032b4:	6a 2e                	push   $0x2e
  8032b6:	e8 5b fa ff ff       	call   802d16 <syscall>
  8032bb:	83 c4 18             	add    $0x18,%esp
}
  8032be:	90                   	nop
  8032bf:	c9                   	leave  
  8032c0:	c3                   	ret    

008032c1 <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8032c1:	55                   	push   %ebp
  8032c2:	89 e5                	mov    %esp,%ebp
  8032c4:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  8032c7:	81 7d 08 80 d0 81 00 	cmpl   $0x81d080,0x8(%ebp)
  8032ce:	72 09                	jb     8032d9 <to_page_va+0x18>
  8032d0:	81 7d 08 80 50 83 00 	cmpl   $0x835080,0x8(%ebp)
  8032d7:	72 14                	jb     8032ed <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  8032d9:	83 ec 04             	sub    $0x4,%esp
  8032dc:	68 78 48 80 00       	push   $0x804878
  8032e1:	6a 15                	push   $0x15
  8032e3:	68 a3 48 80 00       	push   $0x8048a3
  8032e8:	e8 10 d0 ff ff       	call   8002fd <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8032ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f0:	ba 80 d0 81 00       	mov    $0x81d080,%edx
  8032f5:	29 d0                	sub    %edx,%eax
  8032f7:	c1 f8 02             	sar    $0x2,%eax
  8032fa:	89 c2                	mov    %eax,%edx
  8032fc:	89 d0                	mov    %edx,%eax
  8032fe:	c1 e0 02             	shl    $0x2,%eax
  803301:	01 d0                	add    %edx,%eax
  803303:	c1 e0 02             	shl    $0x2,%eax
  803306:	01 d0                	add    %edx,%eax
  803308:	c1 e0 02             	shl    $0x2,%eax
  80330b:	01 d0                	add    %edx,%eax
  80330d:	89 c1                	mov    %eax,%ecx
  80330f:	c1 e1 08             	shl    $0x8,%ecx
  803312:	01 c8                	add    %ecx,%eax
  803314:	89 c1                	mov    %eax,%ecx
  803316:	c1 e1 10             	shl    $0x10,%ecx
  803319:	01 c8                	add    %ecx,%eax
  80331b:	01 c0                	add    %eax,%eax
  80331d:	01 d0                	add    %edx,%eax
  80331f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  803322:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803325:	c1 e0 0c             	shl    $0xc,%eax
  803328:	89 c2                	mov    %eax,%edx
  80332a:	a1 84 50 83 00       	mov    0x835084,%eax
  80332f:	01 d0                	add    %edx,%eax
}
  803331:	c9                   	leave  
  803332:	c3                   	ret    

00803333 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  803333:	55                   	push   %ebp
  803334:	89 e5                	mov    %esp,%ebp
  803336:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  803339:	a1 84 50 83 00       	mov    0x835084,%eax
  80333e:	8b 55 08             	mov    0x8(%ebp),%edx
  803341:	29 c2                	sub    %eax,%edx
  803343:	89 d0                	mov    %edx,%eax
  803345:	c1 e8 0c             	shr    $0xc,%eax
  803348:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  80334b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80334f:	78 09                	js     80335a <to_page_info+0x27>
  803351:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  803358:	7e 14                	jle    80336e <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  80335a:	83 ec 04             	sub    $0x4,%esp
  80335d:	68 bc 48 80 00       	push   $0x8048bc
  803362:	6a 21                	push   $0x21
  803364:	68 a3 48 80 00       	push   $0x8048a3
  803369:	e8 8f cf ff ff       	call   8002fd <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  80336e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803371:	89 d0                	mov    %edx,%eax
  803373:	01 c0                	add    %eax,%eax
  803375:	01 d0                	add    %edx,%eax
  803377:	c1 e0 02             	shl    $0x2,%eax
  80337a:	05 80 d0 81 00       	add    $0x81d080,%eax
}
  80337f:	c9                   	leave  
  803380:	c3                   	ret    

00803381 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803381:	55                   	push   %ebp
  803382:	89 e5                	mov    %esp,%ebp
  803384:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  803387:	8b 45 08             	mov    0x8(%ebp),%eax
  80338a:	05 00 00 00 02       	add    $0x2000000,%eax
  80338f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803392:	73 16                	jae    8033aa <initialize_dynamic_allocator+0x29>
  803394:	68 e0 48 80 00       	push   $0x8048e0
  803399:	68 06 49 80 00       	push   $0x804906
  80339e:	6a 2f                	push   $0x2f
  8033a0:	68 a3 48 80 00       	push   $0x8048a3
  8033a5:	e8 53 cf ff ff       	call   8002fd <_panic>
	dynAllocStart = daStart;
  8033aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ad:	a3 84 50 83 00       	mov    %eax,0x835084
	dynAllocEnd = daEnd;
  8033b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033b5:	a3 60 d0 81 00       	mov    %eax,0x81d060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8033ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8033c1:	eb 36                	jmp    8033f9 <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  8033c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c6:	c1 e0 04             	shl    $0x4,%eax
  8033c9:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8033ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d7:	c1 e0 04             	shl    $0x4,%eax
  8033da:	05 a4 50 83 00       	add    $0x8350a4,%eax
  8033df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e8:	c1 e0 04             	shl    $0x4,%eax
  8033eb:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8033f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8033f6:	ff 45 f4             	incl   -0xc(%ebp)
  8033f9:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  8033fd:	7e c4                	jle    8033c3 <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  8033ff:	c7 05 68 d0 81 00 00 	movl   $0x0,0x81d068
  803406:	00 00 00 
  803409:	c7 05 6c d0 81 00 00 	movl   $0x0,0x81d06c
  803410:	00 00 00 
  803413:	c7 05 74 d0 81 00 00 	movl   $0x0,0x81d074
  80341a:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  80341d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803424:	e9 1b 01 00 00       	jmp    803544 <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  803429:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80342c:	89 d0                	mov    %edx,%eax
  80342e:	01 c0                	add    %eax,%eax
  803430:	01 d0                	add    %edx,%eax
  803432:	c1 e0 02             	shl    $0x2,%eax
  803435:	05 88 d0 81 00       	add    $0x81d088,%eax
  80343a:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  80343f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803442:	89 d0                	mov    %edx,%eax
  803444:	01 c0                	add    %eax,%eax
  803446:	01 d0                	add    %edx,%eax
  803448:	c1 e0 02             	shl    $0x2,%eax
  80344b:	05 8a d0 81 00       	add    $0x81d08a,%eax
  803450:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  803455:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803458:	89 d0                	mov    %edx,%eax
  80345a:	01 c0                	add    %eax,%eax
  80345c:	01 d0                	add    %edx,%eax
  80345e:	c1 e0 02             	shl    $0x2,%eax
  803461:	05 80 d0 81 00       	add    $0x81d080,%eax
  803466:	8b 00                	mov    (%eax),%eax
  803468:	85 c0                	test   %eax,%eax
  80346a:	74 2b                	je     803497 <initialize_dynamic_allocator+0x116>
  80346c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80346f:	89 d0                	mov    %edx,%eax
  803471:	01 c0                	add    %eax,%eax
  803473:	01 d0                	add    %edx,%eax
  803475:	c1 e0 02             	shl    $0x2,%eax
  803478:	05 80 d0 81 00       	add    $0x81d080,%eax
  80347d:	8b 10                	mov    (%eax),%edx
  80347f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803482:	89 c8                	mov    %ecx,%eax
  803484:	01 c0                	add    %eax,%eax
  803486:	01 c8                	add    %ecx,%eax
  803488:	c1 e0 02             	shl    $0x2,%eax
  80348b:	05 84 d0 81 00       	add    $0x81d084,%eax
  803490:	8b 00                	mov    (%eax),%eax
  803492:	89 42 04             	mov    %eax,0x4(%edx)
  803495:	eb 18                	jmp    8034af <initialize_dynamic_allocator+0x12e>
  803497:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80349a:	89 d0                	mov    %edx,%eax
  80349c:	01 c0                	add    %eax,%eax
  80349e:	01 d0                	add    %edx,%eax
  8034a0:	c1 e0 02             	shl    $0x2,%eax
  8034a3:	05 84 d0 81 00       	add    $0x81d084,%eax
  8034a8:	8b 00                	mov    (%eax),%eax
  8034aa:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  8034af:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034b2:	89 d0                	mov    %edx,%eax
  8034b4:	01 c0                	add    %eax,%eax
  8034b6:	01 d0                	add    %edx,%eax
  8034b8:	c1 e0 02             	shl    $0x2,%eax
  8034bb:	05 84 d0 81 00       	add    $0x81d084,%eax
  8034c0:	8b 00                	mov    (%eax),%eax
  8034c2:	85 c0                	test   %eax,%eax
  8034c4:	74 2a                	je     8034f0 <initialize_dynamic_allocator+0x16f>
  8034c6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034c9:	89 d0                	mov    %edx,%eax
  8034cb:	01 c0                	add    %eax,%eax
  8034cd:	01 d0                	add    %edx,%eax
  8034cf:	c1 e0 02             	shl    $0x2,%eax
  8034d2:	05 84 d0 81 00       	add    $0x81d084,%eax
  8034d7:	8b 10                	mov    (%eax),%edx
  8034d9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8034dc:	89 c8                	mov    %ecx,%eax
  8034de:	01 c0                	add    %eax,%eax
  8034e0:	01 c8                	add    %ecx,%eax
  8034e2:	c1 e0 02             	shl    $0x2,%eax
  8034e5:	05 80 d0 81 00       	add    $0x81d080,%eax
  8034ea:	8b 00                	mov    (%eax),%eax
  8034ec:	89 02                	mov    %eax,(%edx)
  8034ee:	eb 18                	jmp    803508 <initialize_dynamic_allocator+0x187>
  8034f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034f3:	89 d0                	mov    %edx,%eax
  8034f5:	01 c0                	add    %eax,%eax
  8034f7:	01 d0                	add    %edx,%eax
  8034f9:	c1 e0 02             	shl    $0x2,%eax
  8034fc:	05 80 d0 81 00       	add    $0x81d080,%eax
  803501:	8b 00                	mov    (%eax),%eax
  803503:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803508:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80350b:	89 d0                	mov    %edx,%eax
  80350d:	01 c0                	add    %eax,%eax
  80350f:	01 d0                	add    %edx,%eax
  803511:	c1 e0 02             	shl    $0x2,%eax
  803514:	05 80 d0 81 00       	add    $0x81d080,%eax
  803519:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80351f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803522:	89 d0                	mov    %edx,%eax
  803524:	01 c0                	add    %eax,%eax
  803526:	01 d0                	add    %edx,%eax
  803528:	c1 e0 02             	shl    $0x2,%eax
  80352b:	05 84 d0 81 00       	add    $0x81d084,%eax
  803530:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803536:	a1 74 d0 81 00       	mov    0x81d074,%eax
  80353b:	48                   	dec    %eax
  80353c:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803541:	ff 45 f0             	incl   -0x10(%ebp)
  803544:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  80354b:	0f 8e d8 fe ff ff    	jle    803429 <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803551:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  803558:	e9 9d 00 00 00       	jmp    8035fa <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  80355d:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803563:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803566:	89 c8                	mov    %ecx,%eax
  803568:	01 c0                	add    %eax,%eax
  80356a:	01 c8                	add    %ecx,%eax
  80356c:	c1 e0 02             	shl    $0x2,%eax
  80356f:	05 80 d0 81 00       	add    $0x81d080,%eax
  803574:	89 10                	mov    %edx,(%eax)
  803576:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803579:	89 d0                	mov    %edx,%eax
  80357b:	01 c0                	add    %eax,%eax
  80357d:	01 d0                	add    %edx,%eax
  80357f:	c1 e0 02             	shl    $0x2,%eax
  803582:	05 80 d0 81 00       	add    $0x81d080,%eax
  803587:	8b 00                	mov    (%eax),%eax
  803589:	85 c0                	test   %eax,%eax
  80358b:	74 1c                	je     8035a9 <initialize_dynamic_allocator+0x228>
  80358d:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803593:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803596:	89 c8                	mov    %ecx,%eax
  803598:	01 c0                	add    %eax,%eax
  80359a:	01 c8                	add    %ecx,%eax
  80359c:	c1 e0 02             	shl    $0x2,%eax
  80359f:	05 80 d0 81 00       	add    $0x81d080,%eax
  8035a4:	89 42 04             	mov    %eax,0x4(%edx)
  8035a7:	eb 16                	jmp    8035bf <initialize_dynamic_allocator+0x23e>
  8035a9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8035ac:	89 d0                	mov    %edx,%eax
  8035ae:	01 c0                	add    %eax,%eax
  8035b0:	01 d0                	add    %edx,%eax
  8035b2:	c1 e0 02             	shl    $0x2,%eax
  8035b5:	05 80 d0 81 00       	add    $0x81d080,%eax
  8035ba:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  8035bf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8035c2:	89 d0                	mov    %edx,%eax
  8035c4:	01 c0                	add    %eax,%eax
  8035c6:	01 d0                	add    %edx,%eax
  8035c8:	c1 e0 02             	shl    $0x2,%eax
  8035cb:	05 80 d0 81 00       	add    $0x81d080,%eax
  8035d0:	a3 68 d0 81 00       	mov    %eax,0x81d068
  8035d5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8035d8:	89 d0                	mov    %edx,%eax
  8035da:	01 c0                	add    %eax,%eax
  8035dc:	01 d0                	add    %edx,%eax
  8035de:	c1 e0 02             	shl    $0x2,%eax
  8035e1:	05 84 d0 81 00       	add    $0x81d084,%eax
  8035e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035ec:	a1 74 d0 81 00       	mov    0x81d074,%eax
  8035f1:	40                   	inc    %eax
  8035f2:	a3 74 d0 81 00       	mov    %eax,0x81d074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  8035f7:	ff 4d ec             	decl   -0x14(%ebp)
  8035fa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8035fe:	0f 89 59 ff ff ff    	jns    80355d <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  803604:	c7 05 44 d0 81 00 01 	movl   $0x1,0x81d044
  80360b:	00 00 00 
}
  80360e:	90                   	nop
  80360f:	c9                   	leave  
  803610:	c3                   	ret    

00803611 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  803611:	55                   	push   %ebp
  803612:	89 e5                	mov    %esp,%ebp
  803614:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803617:	8b 45 08             	mov    0x8(%ebp),%eax
  80361a:	83 ec 0c             	sub    $0xc,%esp
  80361d:	50                   	push   %eax
  80361e:	e8 10 fd ff ff       	call   803333 <to_page_info>
  803623:	83 c4 10             	add    $0x10,%esp
  803626:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  803629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80362c:	8b 40 08             	mov    0x8(%eax),%eax
  80362f:	0f b7 c0             	movzwl %ax,%eax
}
  803632:	c9                   	leave  
  803633:	c3                   	ret    

00803634 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803634:	55                   	push   %ebp
  803635:	89 e5                	mov    %esp,%ebp
  803637:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  80363a:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803641:	76 16                	jbe    803659 <alloc_block+0x25>
  803643:	68 1c 49 80 00       	push   $0x80491c
  803648:	68 06 49 80 00       	push   $0x804906
  80364d:	6a 59                	push   $0x59
  80364f:	68 a3 48 80 00       	push   $0x8048a3
  803654:	e8 a4 cc ff ff       	call   8002fd <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  803659:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803660:	eb 08                	jmp    80366a <alloc_block+0x36>
		allocSize <<= 1;
  803662:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803665:	01 c0                	add    %eax,%eax
  803667:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  80366a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80366d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803670:	73 09                	jae    80367b <alloc_block+0x47>
  803672:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  803679:	76 e7                	jbe    803662 <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  80367b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803682:	eb 03                	jmp    803687 <alloc_block+0x53>
		listIndex++;
  803684:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803687:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80368a:	ba 08 00 00 00       	mov    $0x8,%edx
  80368f:	88 c1                	mov    %al,%cl
  803691:	d3 e2                	shl    %cl,%edx
  803693:	89 d0                	mov    %edx,%eax
  803695:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803698:	72 ea                	jb     803684 <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  80369a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80369d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8036a0:	e9 f4 00 00 00       	jmp    803799 <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  8036a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036a8:	c1 e0 04             	shl    $0x4,%eax
  8036ab:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8036b0:	8b 00                	mov    (%eax),%eax
  8036b2:	85 c0                	test   %eax,%eax
  8036b4:	0f 84 dc 00 00 00    	je     803796 <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  8036ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036bd:	c1 e0 04             	shl    $0x4,%eax
  8036c0:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8036c5:	8b 00                	mov    (%eax),%eax
  8036c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  8036ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036ce:	75 14                	jne    8036e4 <alloc_block+0xb0>
  8036d0:	83 ec 04             	sub    $0x4,%esp
  8036d3:	68 3d 49 80 00       	push   $0x80493d
  8036d8:	6a 6b                	push   $0x6b
  8036da:	68 a3 48 80 00       	push   $0x8048a3
  8036df:	e8 19 cc ff ff       	call   8002fd <_panic>
  8036e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036e7:	8b 00                	mov    (%eax),%eax
  8036e9:	85 c0                	test   %eax,%eax
  8036eb:	74 10                	je     8036fd <alloc_block+0xc9>
  8036ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036f0:	8b 00                	mov    (%eax),%eax
  8036f2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036f5:	8b 52 04             	mov    0x4(%edx),%edx
  8036f8:	89 50 04             	mov    %edx,0x4(%eax)
  8036fb:	eb 14                	jmp    803711 <alloc_block+0xdd>
  8036fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803700:	8b 40 04             	mov    0x4(%eax),%eax
  803703:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803706:	c1 e2 04             	shl    $0x4,%edx
  803709:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  80370f:	89 02                	mov    %eax,(%edx)
  803711:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803714:	8b 40 04             	mov    0x4(%eax),%eax
  803717:	85 c0                	test   %eax,%eax
  803719:	74 0f                	je     80372a <alloc_block+0xf6>
  80371b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80371e:	8b 40 04             	mov    0x4(%eax),%eax
  803721:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803724:	8b 12                	mov    (%edx),%edx
  803726:	89 10                	mov    %edx,(%eax)
  803728:	eb 13                	jmp    80373d <alloc_block+0x109>
  80372a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80372d:	8b 00                	mov    (%eax),%eax
  80372f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803732:	c1 e2 04             	shl    $0x4,%edx
  803735:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  80373b:	89 02                	mov    %eax,(%edx)
  80373d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803740:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803746:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803749:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803750:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803753:	c1 e0 04             	shl    $0x4,%eax
  803756:	05 ac 50 83 00       	add    $0x8350ac,%eax
  80375b:	8b 00                	mov    (%eax),%eax
  80375d:	8d 50 ff             	lea    -0x1(%eax),%edx
  803760:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803763:	c1 e0 04             	shl    $0x4,%eax
  803766:	05 ac 50 83 00       	add    $0x8350ac,%eax
  80376b:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  80376d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803770:	83 ec 0c             	sub    $0xc,%esp
  803773:	50                   	push   %eax
  803774:	e8 ba fb ff ff       	call   803333 <to_page_info>
  803779:	83 c4 10             	add    $0x10,%esp
  80377c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  80377f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803782:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803786:	48                   	dec    %eax
  803787:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80378a:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  80378e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803791:	e9 8f 02 00 00       	jmp    803a25 <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803796:	ff 45 ec             	incl   -0x14(%ebp)
  803799:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80379d:	0f 8e 02 ff ff ff    	jle    8036a5 <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  8037a3:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8037a8:	85 c0                	test   %eax,%eax
  8037aa:	75 14                	jne    8037c0 <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  8037ac:	83 ec 04             	sub    $0x4,%esp
  8037af:	68 5c 49 80 00       	push   $0x80495c
  8037b4:	6a 77                	push   $0x77
  8037b6:	68 a3 48 80 00       	push   $0x8048a3
  8037bb:	e8 3d cb ff ff       	call   8002fd <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  8037c0:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8037c5:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  8037c8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8037cc:	75 14                	jne    8037e2 <alloc_block+0x1ae>
  8037ce:	83 ec 04             	sub    $0x4,%esp
  8037d1:	68 3d 49 80 00       	push   $0x80493d
  8037d6:	6a 7a                	push   $0x7a
  8037d8:	68 a3 48 80 00       	push   $0x8048a3
  8037dd:	e8 1b cb ff ff       	call   8002fd <_panic>
  8037e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037e5:	8b 00                	mov    (%eax),%eax
  8037e7:	85 c0                	test   %eax,%eax
  8037e9:	74 10                	je     8037fb <alloc_block+0x1c7>
  8037eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037ee:	8b 00                	mov    (%eax),%eax
  8037f0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8037f3:	8b 52 04             	mov    0x4(%edx),%edx
  8037f6:	89 50 04             	mov    %edx,0x4(%eax)
  8037f9:	eb 0b                	jmp    803806 <alloc_block+0x1d2>
  8037fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037fe:	8b 40 04             	mov    0x4(%eax),%eax
  803801:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803806:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803809:	8b 40 04             	mov    0x4(%eax),%eax
  80380c:	85 c0                	test   %eax,%eax
  80380e:	74 0f                	je     80381f <alloc_block+0x1eb>
  803810:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803813:	8b 40 04             	mov    0x4(%eax),%eax
  803816:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803819:	8b 12                	mov    (%edx),%edx
  80381b:	89 10                	mov    %edx,(%eax)
  80381d:	eb 0a                	jmp    803829 <alloc_block+0x1f5>
  80381f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803822:	8b 00                	mov    (%eax),%eax
  803824:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803829:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80382c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803832:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803835:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80383c:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803841:	48                   	dec    %eax
  803842:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  803847:	83 ec 0c             	sub    $0xc,%esp
  80384a:	ff 75 dc             	pushl  -0x24(%ebp)
  80384d:	e8 6f fa ff ff       	call   8032c1 <to_page_va>
  803852:	83 c4 10             	add    $0x10,%esp
  803855:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  803858:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80385b:	83 ec 0c             	sub    $0xc,%esp
  80385e:	50                   	push   %eax
  80385f:	e8 a0 dc ff ff       	call   801504 <get_page>
  803864:	83 c4 10             	add    $0x10,%esp
  803867:	85 c0                	test   %eax,%eax
  803869:	74 14                	je     80387f <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  80386b:	83 ec 04             	sub    $0x4,%esp
  80386e:	68 84 49 80 00       	push   $0x804984
  803873:	6a 7f                	push   $0x7f
  803875:	68 a3 48 80 00       	push   $0x8048a3
  80387a:	e8 7e ca ff ff       	call   8002fd <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  80387f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803882:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803885:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  803889:	b8 00 10 00 00       	mov    $0x1000,%eax
  80388e:	ba 00 00 00 00       	mov    $0x0,%edx
  803893:	f7 75 f4             	divl   -0xc(%ebp)
  803896:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803899:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  80389d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8038a4:	e9 a7 00 00 00       	jmp    803950 <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  8038a9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8038ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038af:	01 d0                	add    %edx,%eax
  8038b1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  8038b4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8038b8:	75 17                	jne    8038d1 <alloc_block+0x29d>
  8038ba:	83 ec 04             	sub    $0x4,%esp
  8038bd:	68 ac 49 80 00       	push   $0x8049ac
  8038c2:	68 88 00 00 00       	push   $0x88
  8038c7:	68 a3 48 80 00       	push   $0x8048a3
  8038cc:	e8 2c ca ff ff       	call   8002fd <_panic>
  8038d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038d4:	c1 e0 04             	shl    $0x4,%eax
  8038d7:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8038dc:	8b 10                	mov    (%eax),%edx
  8038de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038e1:	89 10                	mov    %edx,(%eax)
  8038e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038e6:	8b 00                	mov    (%eax),%eax
  8038e8:	85 c0                	test   %eax,%eax
  8038ea:	74 15                	je     803901 <alloc_block+0x2cd>
  8038ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038ef:	c1 e0 04             	shl    $0x4,%eax
  8038f2:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8038f7:	8b 00                	mov    (%eax),%eax
  8038f9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8038fc:	89 50 04             	mov    %edx,0x4(%eax)
  8038ff:	eb 11                	jmp    803912 <alloc_block+0x2de>
  803901:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803904:	c1 e0 04             	shl    $0x4,%eax
  803907:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  80390d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803910:	89 02                	mov    %eax,(%edx)
  803912:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803915:	c1 e0 04             	shl    $0x4,%eax
  803918:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  80391e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803921:	89 02                	mov    %eax,(%edx)
  803923:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803926:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80392d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803930:	c1 e0 04             	shl    $0x4,%eax
  803933:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803938:	8b 00                	mov    (%eax),%eax
  80393a:	8d 50 01             	lea    0x1(%eax),%edx
  80393d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803940:	c1 e0 04             	shl    $0x4,%eax
  803943:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803948:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  80394a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80394d:	01 45 e8             	add    %eax,-0x18(%ebp)
  803950:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  803957:	0f 86 4c ff ff ff    	jbe    8038a9 <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  80395d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803960:	c1 e0 04             	shl    $0x4,%eax
  803963:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803968:	8b 00                	mov    (%eax),%eax
  80396a:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  80396d:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803971:	75 17                	jne    80398a <alloc_block+0x356>
  803973:	83 ec 04             	sub    $0x4,%esp
  803976:	68 3d 49 80 00       	push   $0x80493d
  80397b:	68 8d 00 00 00       	push   $0x8d
  803980:	68 a3 48 80 00       	push   $0x8048a3
  803985:	e8 73 c9 ff ff       	call   8002fd <_panic>
  80398a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80398d:	8b 00                	mov    (%eax),%eax
  80398f:	85 c0                	test   %eax,%eax
  803991:	74 10                	je     8039a3 <alloc_block+0x36f>
  803993:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803996:	8b 00                	mov    (%eax),%eax
  803998:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80399b:	8b 52 04             	mov    0x4(%edx),%edx
  80399e:	89 50 04             	mov    %edx,0x4(%eax)
  8039a1:	eb 14                	jmp    8039b7 <alloc_block+0x383>
  8039a3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8039a6:	8b 40 04             	mov    0x4(%eax),%eax
  8039a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039ac:	c1 e2 04             	shl    $0x4,%edx
  8039af:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  8039b5:	89 02                	mov    %eax,(%edx)
  8039b7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8039ba:	8b 40 04             	mov    0x4(%eax),%eax
  8039bd:	85 c0                	test   %eax,%eax
  8039bf:	74 0f                	je     8039d0 <alloc_block+0x39c>
  8039c1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8039c4:	8b 40 04             	mov    0x4(%eax),%eax
  8039c7:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8039ca:	8b 12                	mov    (%edx),%edx
  8039cc:	89 10                	mov    %edx,(%eax)
  8039ce:	eb 13                	jmp    8039e3 <alloc_block+0x3af>
  8039d0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8039d3:	8b 00                	mov    (%eax),%eax
  8039d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039d8:	c1 e2 04             	shl    $0x4,%edx
  8039db:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  8039e1:	89 02                	mov    %eax,(%edx)
  8039e3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8039e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039ec:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8039ef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039f9:	c1 e0 04             	shl    $0x4,%eax
  8039fc:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803a01:	8b 00                	mov    (%eax),%eax
  803a03:	8d 50 ff             	lea    -0x1(%eax),%edx
  803a06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a09:	c1 e0 04             	shl    $0x4,%eax
  803a0c:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803a11:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  803a13:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a16:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803a1a:	48                   	dec    %eax
  803a1b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803a1e:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  803a22:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  803a25:	c9                   	leave  
  803a26:	c3                   	ret    

00803a27 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803a27:	55                   	push   %ebp
  803a28:	89 e5                	mov    %esp,%ebp
  803a2a:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803a2d:	8b 55 08             	mov    0x8(%ebp),%edx
  803a30:	a1 84 50 83 00       	mov    0x835084,%eax
  803a35:	39 c2                	cmp    %eax,%edx
  803a37:	72 0c                	jb     803a45 <free_block+0x1e>
  803a39:	8b 55 08             	mov    0x8(%ebp),%edx
  803a3c:	a1 60 d0 81 00       	mov    0x81d060,%eax
  803a41:	39 c2                	cmp    %eax,%edx
  803a43:	72 19                	jb     803a5e <free_block+0x37>
  803a45:	68 d0 49 80 00       	push   $0x8049d0
  803a4a:	68 06 49 80 00       	push   $0x804906
  803a4f:	68 98 00 00 00       	push   $0x98
  803a54:	68 a3 48 80 00       	push   $0x8048a3
  803a59:	e8 9f c8 ff ff       	call   8002fd <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  803a61:	83 ec 0c             	sub    $0xc,%esp
  803a64:	50                   	push   %eax
  803a65:	e8 c9 f8 ff ff       	call   803333 <to_page_info>
  803a6a:	83 c4 10             	add    $0x10,%esp
  803a6d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  803a70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a73:	8b 40 08             	mov    0x8(%eax),%eax
  803a76:	0f b7 c0             	movzwl %ax,%eax
  803a79:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  803a7c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803a83:	eb 03                	jmp    803a88 <free_block+0x61>
		listIndex++;
  803a85:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a8b:	ba 08 00 00 00       	mov    $0x8,%edx
  803a90:	88 c1                	mov    %al,%cl
  803a92:	d3 e2                	shl    %cl,%edx
  803a94:	89 d0                	mov    %edx,%eax
  803a96:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803a99:	72 ea                	jb     803a85 <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  803a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  803a9e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  803aa1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803aa5:	75 17                	jne    803abe <free_block+0x97>
  803aa7:	83 ec 04             	sub    $0x4,%esp
  803aaa:	68 ac 49 80 00       	push   $0x8049ac
  803aaf:	68 a2 00 00 00       	push   $0xa2
  803ab4:	68 a3 48 80 00       	push   $0x8048a3
  803ab9:	e8 3f c8 ff ff       	call   8002fd <_panic>
  803abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac1:	c1 e0 04             	shl    $0x4,%eax
  803ac4:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803ac9:	8b 10                	mov    (%eax),%edx
  803acb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ace:	89 10                	mov    %edx,(%eax)
  803ad0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ad3:	8b 00                	mov    (%eax),%eax
  803ad5:	85 c0                	test   %eax,%eax
  803ad7:	74 15                	je     803aee <free_block+0xc7>
  803ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803adc:	c1 e0 04             	shl    $0x4,%eax
  803adf:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803ae4:	8b 00                	mov    (%eax),%eax
  803ae6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ae9:	89 50 04             	mov    %edx,0x4(%eax)
  803aec:	eb 11                	jmp    803aff <free_block+0xd8>
  803aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803af1:	c1 e0 04             	shl    $0x4,%eax
  803af4:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803afa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803afd:	89 02                	mov    %eax,(%edx)
  803aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b02:	c1 e0 04             	shl    $0x4,%eax
  803b05:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803b0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b0e:	89 02                	mov    %eax,(%edx)
  803b10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b13:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b1d:	c1 e0 04             	shl    $0x4,%eax
  803b20:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803b25:	8b 00                	mov    (%eax),%eax
  803b27:	8d 50 01             	lea    0x1(%eax),%edx
  803b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b2d:	c1 e0 04             	shl    $0x4,%eax
  803b30:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803b35:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  803b37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b3a:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803b3e:	40                   	inc    %eax
  803b3f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b42:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  803b46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b49:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803b4d:	0f b7 c8             	movzwl %ax,%ecx
  803b50:	b8 00 10 00 00       	mov    $0x1000,%eax
  803b55:	ba 00 00 00 00       	mov    $0x0,%edx
  803b5a:	f7 75 e8             	divl   -0x18(%ebp)
  803b5d:	39 c1                	cmp    %eax,%ecx
  803b5f:	0f 85 ed 01 00 00    	jne    803d52 <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803b65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b68:	c1 e0 04             	shl    $0x4,%eax
  803b6b:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803b70:	8b 00                	mov    (%eax),%eax
  803b72:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803b75:	eb 2a                	jmp    803ba1 <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  803b77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b7a:	83 ec 0c             	sub    $0xc,%esp
  803b7d:	50                   	push   %eax
  803b7e:	e8 b0 f7 ff ff       	call   803333 <to_page_info>
  803b83:	83 c4 10             	add    $0x10,%esp
  803b86:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803b89:	75 06                	jne    803b91 <free_block+0x16a>
				tmp = b;
  803b8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b8e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803b91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b94:	c1 e0 04             	shl    $0x4,%eax
  803b97:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803b9c:	8b 00                	mov    (%eax),%eax
  803b9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803ba1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803ba5:	74 07                	je     803bae <free_block+0x187>
  803ba7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803baa:	8b 00                	mov    (%eax),%eax
  803bac:	eb 05                	jmp    803bb3 <free_block+0x18c>
  803bae:	b8 00 00 00 00       	mov    $0x0,%eax
  803bb3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803bb6:	c1 e2 04             	shl    $0x4,%edx
  803bb9:	81 c2 a8 50 83 00    	add    $0x8350a8,%edx
  803bbf:	89 02                	mov    %eax,(%edx)
  803bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bc4:	c1 e0 04             	shl    $0x4,%eax
  803bc7:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803bcc:	8b 00                	mov    (%eax),%eax
  803bce:	85 c0                	test   %eax,%eax
  803bd0:	75 a5                	jne    803b77 <free_block+0x150>
  803bd2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803bd6:	75 9f                	jne    803b77 <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  803bd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bdb:	c1 e0 04             	shl    $0x4,%eax
  803bde:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803be3:	8b 00                	mov    (%eax),%eax
  803be5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  803be8:	e9 cc 00 00 00       	jmp    803cb9 <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  803bed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bf0:	8b 00                	mov    (%eax),%eax
  803bf2:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  803bf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bf8:	83 ec 0c             	sub    $0xc,%esp
  803bfb:	50                   	push   %eax
  803bfc:	e8 32 f7 ff ff       	call   803333 <to_page_info>
  803c01:	83 c4 10             	add    $0x10,%esp
  803c04:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803c07:	0f 85 a6 00 00 00    	jne    803cb3 <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  803c0d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803c11:	75 17                	jne    803c2a <free_block+0x203>
  803c13:	83 ec 04             	sub    $0x4,%esp
  803c16:	68 3d 49 80 00       	push   $0x80493d
  803c1b:	68 b5 00 00 00       	push   $0xb5
  803c20:	68 a3 48 80 00       	push   $0x8048a3
  803c25:	e8 d3 c6 ff ff       	call   8002fd <_panic>
  803c2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c2d:	8b 00                	mov    (%eax),%eax
  803c2f:	85 c0                	test   %eax,%eax
  803c31:	74 10                	je     803c43 <free_block+0x21c>
  803c33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c36:	8b 00                	mov    (%eax),%eax
  803c38:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c3b:	8b 52 04             	mov    0x4(%edx),%edx
  803c3e:	89 50 04             	mov    %edx,0x4(%eax)
  803c41:	eb 14                	jmp    803c57 <free_block+0x230>
  803c43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c46:	8b 40 04             	mov    0x4(%eax),%eax
  803c49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c4c:	c1 e2 04             	shl    $0x4,%edx
  803c4f:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803c55:	89 02                	mov    %eax,(%edx)
  803c57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c5a:	8b 40 04             	mov    0x4(%eax),%eax
  803c5d:	85 c0                	test   %eax,%eax
  803c5f:	74 0f                	je     803c70 <free_block+0x249>
  803c61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c64:	8b 40 04             	mov    0x4(%eax),%eax
  803c67:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c6a:	8b 12                	mov    (%edx),%edx
  803c6c:	89 10                	mov    %edx,(%eax)
  803c6e:	eb 13                	jmp    803c83 <free_block+0x25c>
  803c70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c73:	8b 00                	mov    (%eax),%eax
  803c75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c78:	c1 e2 04             	shl    $0x4,%edx
  803c7b:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803c81:	89 02                	mov    %eax,(%edx)
  803c83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c86:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c8f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c99:	c1 e0 04             	shl    $0x4,%eax
  803c9c:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803ca1:	8b 00                	mov    (%eax),%eax
  803ca3:	8d 50 ff             	lea    -0x1(%eax),%edx
  803ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ca9:	c1 e0 04             	shl    $0x4,%eax
  803cac:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803cb1:	89 10                	mov    %edx,(%eax)
			b = next;
  803cb3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803cb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  803cb9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803cbd:	0f 85 2a ff ff ff    	jne    803bed <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  803cc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cc6:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  803ccc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ccf:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  803cd5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803cd9:	75 17                	jne    803cf2 <free_block+0x2cb>
  803cdb:	83 ec 04             	sub    $0x4,%esp
  803cde:	68 ac 49 80 00       	push   $0x8049ac
  803ce3:	68 bc 00 00 00       	push   $0xbc
  803ce8:	68 a3 48 80 00       	push   $0x8048a3
  803ced:	e8 0b c6 ff ff       	call   8002fd <_panic>
  803cf2:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803cf8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cfb:	89 10                	mov    %edx,(%eax)
  803cfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d00:	8b 00                	mov    (%eax),%eax
  803d02:	85 c0                	test   %eax,%eax
  803d04:	74 0d                	je     803d13 <free_block+0x2ec>
  803d06:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803d0b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803d0e:	89 50 04             	mov    %edx,0x4(%eax)
  803d11:	eb 08                	jmp    803d1b <free_block+0x2f4>
  803d13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d16:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803d1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d1e:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803d23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d26:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d2d:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803d32:	40                   	inc    %eax
  803d33:	a3 74 d0 81 00       	mov    %eax,0x81d074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  803d38:	83 ec 0c             	sub    $0xc,%esp
  803d3b:	ff 75 ec             	pushl  -0x14(%ebp)
  803d3e:	e8 7e f5 ff ff       	call   8032c1 <to_page_va>
  803d43:	83 c4 10             	add    $0x10,%esp
  803d46:	83 ec 0c             	sub    $0xc,%esp
  803d49:	50                   	push   %eax
  803d4a:	e8 fe d7 ff ff       	call   80154d <return_page>
  803d4f:	83 c4 10             	add    $0x10,%esp
	}
}
  803d52:	90                   	nop
  803d53:	c9                   	leave  
  803d54:	c3                   	ret    
  803d55:	66 90                	xchg   %ax,%ax
  803d57:	90                   	nop

00803d58 <__udivdi3>:
  803d58:	55                   	push   %ebp
  803d59:	57                   	push   %edi
  803d5a:	56                   	push   %esi
  803d5b:	53                   	push   %ebx
  803d5c:	83 ec 1c             	sub    $0x1c,%esp
  803d5f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803d63:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803d67:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d6b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803d6f:	89 ca                	mov    %ecx,%edx
  803d71:	89 f8                	mov    %edi,%eax
  803d73:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803d77:	85 f6                	test   %esi,%esi
  803d79:	75 2d                	jne    803da8 <__udivdi3+0x50>
  803d7b:	39 cf                	cmp    %ecx,%edi
  803d7d:	77 65                	ja     803de4 <__udivdi3+0x8c>
  803d7f:	89 fd                	mov    %edi,%ebp
  803d81:	85 ff                	test   %edi,%edi
  803d83:	75 0b                	jne    803d90 <__udivdi3+0x38>
  803d85:	b8 01 00 00 00       	mov    $0x1,%eax
  803d8a:	31 d2                	xor    %edx,%edx
  803d8c:	f7 f7                	div    %edi
  803d8e:	89 c5                	mov    %eax,%ebp
  803d90:	31 d2                	xor    %edx,%edx
  803d92:	89 c8                	mov    %ecx,%eax
  803d94:	f7 f5                	div    %ebp
  803d96:	89 c1                	mov    %eax,%ecx
  803d98:	89 d8                	mov    %ebx,%eax
  803d9a:	f7 f5                	div    %ebp
  803d9c:	89 cf                	mov    %ecx,%edi
  803d9e:	89 fa                	mov    %edi,%edx
  803da0:	83 c4 1c             	add    $0x1c,%esp
  803da3:	5b                   	pop    %ebx
  803da4:	5e                   	pop    %esi
  803da5:	5f                   	pop    %edi
  803da6:	5d                   	pop    %ebp
  803da7:	c3                   	ret    
  803da8:	39 ce                	cmp    %ecx,%esi
  803daa:	77 28                	ja     803dd4 <__udivdi3+0x7c>
  803dac:	0f bd fe             	bsr    %esi,%edi
  803daf:	83 f7 1f             	xor    $0x1f,%edi
  803db2:	75 40                	jne    803df4 <__udivdi3+0x9c>
  803db4:	39 ce                	cmp    %ecx,%esi
  803db6:	72 0a                	jb     803dc2 <__udivdi3+0x6a>
  803db8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803dbc:	0f 87 9e 00 00 00    	ja     803e60 <__udivdi3+0x108>
  803dc2:	b8 01 00 00 00       	mov    $0x1,%eax
  803dc7:	89 fa                	mov    %edi,%edx
  803dc9:	83 c4 1c             	add    $0x1c,%esp
  803dcc:	5b                   	pop    %ebx
  803dcd:	5e                   	pop    %esi
  803dce:	5f                   	pop    %edi
  803dcf:	5d                   	pop    %ebp
  803dd0:	c3                   	ret    
  803dd1:	8d 76 00             	lea    0x0(%esi),%esi
  803dd4:	31 ff                	xor    %edi,%edi
  803dd6:	31 c0                	xor    %eax,%eax
  803dd8:	89 fa                	mov    %edi,%edx
  803dda:	83 c4 1c             	add    $0x1c,%esp
  803ddd:	5b                   	pop    %ebx
  803dde:	5e                   	pop    %esi
  803ddf:	5f                   	pop    %edi
  803de0:	5d                   	pop    %ebp
  803de1:	c3                   	ret    
  803de2:	66 90                	xchg   %ax,%ax
  803de4:	89 d8                	mov    %ebx,%eax
  803de6:	f7 f7                	div    %edi
  803de8:	31 ff                	xor    %edi,%edi
  803dea:	89 fa                	mov    %edi,%edx
  803dec:	83 c4 1c             	add    $0x1c,%esp
  803def:	5b                   	pop    %ebx
  803df0:	5e                   	pop    %esi
  803df1:	5f                   	pop    %edi
  803df2:	5d                   	pop    %ebp
  803df3:	c3                   	ret    
  803df4:	bd 20 00 00 00       	mov    $0x20,%ebp
  803df9:	89 eb                	mov    %ebp,%ebx
  803dfb:	29 fb                	sub    %edi,%ebx
  803dfd:	89 f9                	mov    %edi,%ecx
  803dff:	d3 e6                	shl    %cl,%esi
  803e01:	89 c5                	mov    %eax,%ebp
  803e03:	88 d9                	mov    %bl,%cl
  803e05:	d3 ed                	shr    %cl,%ebp
  803e07:	89 e9                	mov    %ebp,%ecx
  803e09:	09 f1                	or     %esi,%ecx
  803e0b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803e0f:	89 f9                	mov    %edi,%ecx
  803e11:	d3 e0                	shl    %cl,%eax
  803e13:	89 c5                	mov    %eax,%ebp
  803e15:	89 d6                	mov    %edx,%esi
  803e17:	88 d9                	mov    %bl,%cl
  803e19:	d3 ee                	shr    %cl,%esi
  803e1b:	89 f9                	mov    %edi,%ecx
  803e1d:	d3 e2                	shl    %cl,%edx
  803e1f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e23:	88 d9                	mov    %bl,%cl
  803e25:	d3 e8                	shr    %cl,%eax
  803e27:	09 c2                	or     %eax,%edx
  803e29:	89 d0                	mov    %edx,%eax
  803e2b:	89 f2                	mov    %esi,%edx
  803e2d:	f7 74 24 0c          	divl   0xc(%esp)
  803e31:	89 d6                	mov    %edx,%esi
  803e33:	89 c3                	mov    %eax,%ebx
  803e35:	f7 e5                	mul    %ebp
  803e37:	39 d6                	cmp    %edx,%esi
  803e39:	72 19                	jb     803e54 <__udivdi3+0xfc>
  803e3b:	74 0b                	je     803e48 <__udivdi3+0xf0>
  803e3d:	89 d8                	mov    %ebx,%eax
  803e3f:	31 ff                	xor    %edi,%edi
  803e41:	e9 58 ff ff ff       	jmp    803d9e <__udivdi3+0x46>
  803e46:	66 90                	xchg   %ax,%ax
  803e48:	8b 54 24 08          	mov    0x8(%esp),%edx
  803e4c:	89 f9                	mov    %edi,%ecx
  803e4e:	d3 e2                	shl    %cl,%edx
  803e50:	39 c2                	cmp    %eax,%edx
  803e52:	73 e9                	jae    803e3d <__udivdi3+0xe5>
  803e54:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803e57:	31 ff                	xor    %edi,%edi
  803e59:	e9 40 ff ff ff       	jmp    803d9e <__udivdi3+0x46>
  803e5e:	66 90                	xchg   %ax,%ax
  803e60:	31 c0                	xor    %eax,%eax
  803e62:	e9 37 ff ff ff       	jmp    803d9e <__udivdi3+0x46>
  803e67:	90                   	nop

00803e68 <__umoddi3>:
  803e68:	55                   	push   %ebp
  803e69:	57                   	push   %edi
  803e6a:	56                   	push   %esi
  803e6b:	53                   	push   %ebx
  803e6c:	83 ec 1c             	sub    $0x1c,%esp
  803e6f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803e73:	8b 74 24 34          	mov    0x34(%esp),%esi
  803e77:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803e7b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803e7f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803e83:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803e87:	89 f3                	mov    %esi,%ebx
  803e89:	89 fa                	mov    %edi,%edx
  803e8b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e8f:	89 34 24             	mov    %esi,(%esp)
  803e92:	85 c0                	test   %eax,%eax
  803e94:	75 1a                	jne    803eb0 <__umoddi3+0x48>
  803e96:	39 f7                	cmp    %esi,%edi
  803e98:	0f 86 a2 00 00 00    	jbe    803f40 <__umoddi3+0xd8>
  803e9e:	89 c8                	mov    %ecx,%eax
  803ea0:	89 f2                	mov    %esi,%edx
  803ea2:	f7 f7                	div    %edi
  803ea4:	89 d0                	mov    %edx,%eax
  803ea6:	31 d2                	xor    %edx,%edx
  803ea8:	83 c4 1c             	add    $0x1c,%esp
  803eab:	5b                   	pop    %ebx
  803eac:	5e                   	pop    %esi
  803ead:	5f                   	pop    %edi
  803eae:	5d                   	pop    %ebp
  803eaf:	c3                   	ret    
  803eb0:	39 f0                	cmp    %esi,%eax
  803eb2:	0f 87 ac 00 00 00    	ja     803f64 <__umoddi3+0xfc>
  803eb8:	0f bd e8             	bsr    %eax,%ebp
  803ebb:	83 f5 1f             	xor    $0x1f,%ebp
  803ebe:	0f 84 ac 00 00 00    	je     803f70 <__umoddi3+0x108>
  803ec4:	bf 20 00 00 00       	mov    $0x20,%edi
  803ec9:	29 ef                	sub    %ebp,%edi
  803ecb:	89 fe                	mov    %edi,%esi
  803ecd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803ed1:	89 e9                	mov    %ebp,%ecx
  803ed3:	d3 e0                	shl    %cl,%eax
  803ed5:	89 d7                	mov    %edx,%edi
  803ed7:	89 f1                	mov    %esi,%ecx
  803ed9:	d3 ef                	shr    %cl,%edi
  803edb:	09 c7                	or     %eax,%edi
  803edd:	89 e9                	mov    %ebp,%ecx
  803edf:	d3 e2                	shl    %cl,%edx
  803ee1:	89 14 24             	mov    %edx,(%esp)
  803ee4:	89 d8                	mov    %ebx,%eax
  803ee6:	d3 e0                	shl    %cl,%eax
  803ee8:	89 c2                	mov    %eax,%edx
  803eea:	8b 44 24 08          	mov    0x8(%esp),%eax
  803eee:	d3 e0                	shl    %cl,%eax
  803ef0:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ef4:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ef8:	89 f1                	mov    %esi,%ecx
  803efa:	d3 e8                	shr    %cl,%eax
  803efc:	09 d0                	or     %edx,%eax
  803efe:	d3 eb                	shr    %cl,%ebx
  803f00:	89 da                	mov    %ebx,%edx
  803f02:	f7 f7                	div    %edi
  803f04:	89 d3                	mov    %edx,%ebx
  803f06:	f7 24 24             	mull   (%esp)
  803f09:	89 c6                	mov    %eax,%esi
  803f0b:	89 d1                	mov    %edx,%ecx
  803f0d:	39 d3                	cmp    %edx,%ebx
  803f0f:	0f 82 87 00 00 00    	jb     803f9c <__umoddi3+0x134>
  803f15:	0f 84 91 00 00 00    	je     803fac <__umoddi3+0x144>
  803f1b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803f1f:	29 f2                	sub    %esi,%edx
  803f21:	19 cb                	sbb    %ecx,%ebx
  803f23:	89 d8                	mov    %ebx,%eax
  803f25:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803f29:	d3 e0                	shl    %cl,%eax
  803f2b:	89 e9                	mov    %ebp,%ecx
  803f2d:	d3 ea                	shr    %cl,%edx
  803f2f:	09 d0                	or     %edx,%eax
  803f31:	89 e9                	mov    %ebp,%ecx
  803f33:	d3 eb                	shr    %cl,%ebx
  803f35:	89 da                	mov    %ebx,%edx
  803f37:	83 c4 1c             	add    $0x1c,%esp
  803f3a:	5b                   	pop    %ebx
  803f3b:	5e                   	pop    %esi
  803f3c:	5f                   	pop    %edi
  803f3d:	5d                   	pop    %ebp
  803f3e:	c3                   	ret    
  803f3f:	90                   	nop
  803f40:	89 fd                	mov    %edi,%ebp
  803f42:	85 ff                	test   %edi,%edi
  803f44:	75 0b                	jne    803f51 <__umoddi3+0xe9>
  803f46:	b8 01 00 00 00       	mov    $0x1,%eax
  803f4b:	31 d2                	xor    %edx,%edx
  803f4d:	f7 f7                	div    %edi
  803f4f:	89 c5                	mov    %eax,%ebp
  803f51:	89 f0                	mov    %esi,%eax
  803f53:	31 d2                	xor    %edx,%edx
  803f55:	f7 f5                	div    %ebp
  803f57:	89 c8                	mov    %ecx,%eax
  803f59:	f7 f5                	div    %ebp
  803f5b:	89 d0                	mov    %edx,%eax
  803f5d:	e9 44 ff ff ff       	jmp    803ea6 <__umoddi3+0x3e>
  803f62:	66 90                	xchg   %ax,%ax
  803f64:	89 c8                	mov    %ecx,%eax
  803f66:	89 f2                	mov    %esi,%edx
  803f68:	83 c4 1c             	add    $0x1c,%esp
  803f6b:	5b                   	pop    %ebx
  803f6c:	5e                   	pop    %esi
  803f6d:	5f                   	pop    %edi
  803f6e:	5d                   	pop    %ebp
  803f6f:	c3                   	ret    
  803f70:	3b 04 24             	cmp    (%esp),%eax
  803f73:	72 06                	jb     803f7b <__umoddi3+0x113>
  803f75:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803f79:	77 0f                	ja     803f8a <__umoddi3+0x122>
  803f7b:	89 f2                	mov    %esi,%edx
  803f7d:	29 f9                	sub    %edi,%ecx
  803f7f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803f83:	89 14 24             	mov    %edx,(%esp)
  803f86:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803f8a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803f8e:	8b 14 24             	mov    (%esp),%edx
  803f91:	83 c4 1c             	add    $0x1c,%esp
  803f94:	5b                   	pop    %ebx
  803f95:	5e                   	pop    %esi
  803f96:	5f                   	pop    %edi
  803f97:	5d                   	pop    %ebp
  803f98:	c3                   	ret    
  803f99:	8d 76 00             	lea    0x0(%esi),%esi
  803f9c:	2b 04 24             	sub    (%esp),%eax
  803f9f:	19 fa                	sbb    %edi,%edx
  803fa1:	89 d1                	mov    %edx,%ecx
  803fa3:	89 c6                	mov    %eax,%esi
  803fa5:	e9 71 ff ff ff       	jmp    803f1b <__umoddi3+0xb3>
  803faa:	66 90                	xchg   %ax,%ax
  803fac:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803fb0:	72 ea                	jb     803f9c <__umoddi3+0x134>
  803fb2:	89 d9                	mov    %ebx,%ecx
  803fb4:	e9 62 ff ff ff       	jmp    803f1b <__umoddi3+0xb3>
