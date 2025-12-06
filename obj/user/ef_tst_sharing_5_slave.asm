
obj/user/ef_tst_sharing_5_slave:     file format elf32-i386


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
  800031:	e8 dc 00 00 00       	call   800112 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

extern volatile bool printStats;
void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	printStats = 0;
  80003e:	c7 05 00 50 80 00 00 	movl   $0x0,0x805000
  800045:	00 00 00 
	/*=================================================*/
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  800048:	a1 20 50 80 00       	mov    0x805020,%eax
  80004d:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  800053:	a1 20 50 80 00       	mov    0x805020,%eax
  800058:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80005e:	39 c2                	cmp    %eax,%edx
  800060:	72 14                	jb     800076 <_main+0x3e>
			panic("Please increase the WS size");
  800062:	83 ec 04             	sub    $0x4,%esp
  800065:	68 80 3f 80 00       	push   $0x803f80
  80006a:	6a 0e                	push   $0xe
  80006c:	68 9c 3f 80 00       	push   $0x803f9c
  800071:	e8 4c 02 00 00       	call   8002c2 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  800076:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)
	uint32 *x, *y, *z ;
	int freeFrames, diff, expected;
sys_lock_cons();
  80007d:	e8 c8 2c 00 00       	call   802d4a <sys_lock_cons>
	x = sget(sys_getparentenvid(),"x");
  800082:	e8 55 2f 00 00       	call   802fdc <sys_getparentenvid>
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	68 ba 3f 80 00       	push   $0x803fba
  80008f:	50                   	push   %eax
  800090:	e8 84 1f 00 00       	call   802019 <sget>
  800095:	83 c4 10             	add    $0x10,%esp
  800098:	89 45 f0             	mov    %eax,-0x10(%ebp)

	freeFrames = sys_calculate_free_frames() ;
  80009b:	e8 5a 2d 00 00       	call   802dfa <sys_calculate_free_frames>
  8000a0:	89 45 ec             	mov    %eax,-0x14(%ebp)

	cprintf("Slave env used x (getSharedObject)\n");
  8000a3:	83 ec 0c             	sub    $0xc,%esp
  8000a6:	68 bc 3f 80 00       	push   $0x803fbc
  8000ab:	e8 e0 04 00 00       	call   800590 <cprintf>
  8000b0:	83 c4 10             	add    $0x10,%esp

	sfree(x);
  8000b3:	83 ec 0c             	sub    $0xc,%esp
  8000b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8000b9:	e8 ce 28 00 00       	call   80298c <sfree>
  8000be:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave env removed x\n");
  8000c1:	83 ec 0c             	sub    $0xc,%esp
  8000c4:	68 e0 3f 80 00       	push   $0x803fe0
  8000c9:	e8 c2 04 00 00       	call   800590 <cprintf>
  8000ce:	83 c4 10             	add    $0x10,%esp

	diff = (sys_calculate_free_frames() - freeFrames);
  8000d1:	e8 24 2d 00 00       	call   802dfa <sys_calculate_free_frames>
  8000d6:	89 c2                	mov    %eax,%edx
  8000d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000db:	29 c2                	sub    %eax,%edx
  8000dd:	89 d0                	mov    %edx,%eax
  8000df:	89 45 e8             	mov    %eax,-0x18(%ebp)
sys_unlock_cons();
  8000e2:	e8 7d 2c 00 00       	call   802d64 <sys_unlock_cons>
	expected = 1;
  8000e7:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
	if (diff != expected) panic("wrong free: frames removed not equal 1 !, correct frames to be removed is 1:\nfrom the env: 1 table for x\nframes_storage: not cleared yet\n");
  8000ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8000f4:	74 14                	je     80010a <_main+0xd2>
  8000f6:	83 ec 04             	sub    $0x4,%esp
  8000f9:	68 f8 3f 80 00       	push   $0x803ff8
  8000fe:	6a 25                	push   $0x25
  800100:	68 9c 3f 80 00       	push   $0x803f9c
  800105:	e8 b8 01 00 00       	call   8002c2 <_panic>

	//to ensure that this environment is completed successfully
	inctst();
  80010a:	e8 f2 2f 00 00       	call   803101 <inctst>

	return;
  80010f:	90                   	nop
}
  800110:	c9                   	leave  
  800111:	c3                   	ret    

00800112 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800112:	55                   	push   %ebp
  800113:	89 e5                	mov    %esp,%ebp
  800115:	57                   	push   %edi
  800116:	56                   	push   %esi
  800117:	53                   	push   %ebx
  800118:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80011b:	e8 a3 2e 00 00       	call   802fc3 <sys_getenvindex>
  800120:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800123:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800126:	89 d0                	mov    %edx,%eax
  800128:	c1 e0 03             	shl    $0x3,%eax
  80012b:	01 d0                	add    %edx,%eax
  80012d:	c1 e0 02             	shl    $0x2,%eax
  800130:	01 d0                	add    %edx,%eax
  800132:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800139:	01 d0                	add    %edx,%eax
  80013b:	c1 e0 03             	shl    $0x3,%eax
  80013e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800143:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800148:	a1 20 50 80 00       	mov    0x805020,%eax
  80014d:	8a 40 20             	mov    0x20(%eax),%al
  800150:	84 c0                	test   %al,%al
  800152:	74 0d                	je     800161 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800154:	a1 20 50 80 00       	mov    0x805020,%eax
  800159:	83 c0 20             	add    $0x20,%eax
  80015c:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800161:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800165:	7e 0a                	jle    800171 <libmain+0x5f>
		binaryname = argv[0];
  800167:	8b 45 0c             	mov    0xc(%ebp),%eax
  80016a:	8b 00                	mov    (%eax),%eax
  80016c:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  800171:	83 ec 08             	sub    $0x8,%esp
  800174:	ff 75 0c             	pushl  0xc(%ebp)
  800177:	ff 75 08             	pushl  0x8(%ebp)
  80017a:	e8 b9 fe ff ff       	call   800038 <_main>
  80017f:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800182:	a1 00 50 80 00       	mov    0x805000,%eax
  800187:	85 c0                	test   %eax,%eax
  800189:	0f 84 01 01 00 00    	je     800290 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80018f:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800195:	bb 7c 41 80 00       	mov    $0x80417c,%ebx
  80019a:	ba 0e 00 00 00       	mov    $0xe,%edx
  80019f:	89 c7                	mov    %eax,%edi
  8001a1:	89 de                	mov    %ebx,%esi
  8001a3:	89 d1                	mov    %edx,%ecx
  8001a5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001a7:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8001aa:	b9 56 00 00 00       	mov    $0x56,%ecx
  8001af:	b0 00                	mov    $0x0,%al
  8001b1:	89 d7                	mov    %edx,%edi
  8001b3:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8001b5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8001bc:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8001bf:	83 ec 08             	sub    $0x8,%esp
  8001c2:	50                   	push   %eax
  8001c3:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001c9:	50                   	push   %eax
  8001ca:	e8 2a 30 00 00       	call   8031f9 <sys_utilities>
  8001cf:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001d2:	e8 73 2b 00 00       	call   802d4a <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001d7:	83 ec 0c             	sub    $0xc,%esp
  8001da:	68 9c 40 80 00       	push   $0x80409c
  8001df:	e8 ac 03 00 00       	call   800590 <cprintf>
  8001e4:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8001e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001ea:	85 c0                	test   %eax,%eax
  8001ec:	74 18                	je     800206 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8001ee:	e8 24 30 00 00       	call   803217 <sys_get_optimal_num_faults>
  8001f3:	83 ec 08             	sub    $0x8,%esp
  8001f6:	50                   	push   %eax
  8001f7:	68 c4 40 80 00       	push   $0x8040c4
  8001fc:	e8 8f 03 00 00       	call   800590 <cprintf>
  800201:	83 c4 10             	add    $0x10,%esp
  800204:	eb 59                	jmp    80025f <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800206:	a1 20 50 80 00       	mov    0x805020,%eax
  80020b:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  800211:	a1 20 50 80 00       	mov    0x805020,%eax
  800216:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80021c:	83 ec 04             	sub    $0x4,%esp
  80021f:	52                   	push   %edx
  800220:	50                   	push   %eax
  800221:	68 e8 40 80 00       	push   $0x8040e8
  800226:	e8 65 03 00 00       	call   800590 <cprintf>
  80022b:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80022e:	a1 20 50 80 00       	mov    0x805020,%eax
  800233:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  800239:	a1 20 50 80 00       	mov    0x805020,%eax
  80023e:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  800244:	a1 20 50 80 00       	mov    0x805020,%eax
  800249:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80024f:	51                   	push   %ecx
  800250:	52                   	push   %edx
  800251:	50                   	push   %eax
  800252:	68 10 41 80 00       	push   $0x804110
  800257:	e8 34 03 00 00       	call   800590 <cprintf>
  80025c:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80025f:	a1 20 50 80 00       	mov    0x805020,%eax
  800264:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  80026a:	83 ec 08             	sub    $0x8,%esp
  80026d:	50                   	push   %eax
  80026e:	68 68 41 80 00       	push   $0x804168
  800273:	e8 18 03 00 00       	call   800590 <cprintf>
  800278:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80027b:	83 ec 0c             	sub    $0xc,%esp
  80027e:	68 9c 40 80 00       	push   $0x80409c
  800283:	e8 08 03 00 00       	call   800590 <cprintf>
  800288:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80028b:	e8 d4 2a 00 00       	call   802d64 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800290:	e8 1f 00 00 00       	call   8002b4 <exit>
}
  800295:	90                   	nop
  800296:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800299:	5b                   	pop    %ebx
  80029a:	5e                   	pop    %esi
  80029b:	5f                   	pop    %edi
  80029c:	5d                   	pop    %ebp
  80029d:	c3                   	ret    

0080029e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80029e:	55                   	push   %ebp
  80029f:	89 e5                	mov    %esp,%ebp
  8002a1:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002a4:	83 ec 0c             	sub    $0xc,%esp
  8002a7:	6a 00                	push   $0x0
  8002a9:	e8 e1 2c 00 00       	call   802f8f <sys_destroy_env>
  8002ae:	83 c4 10             	add    $0x10,%esp
}
  8002b1:	90                   	nop
  8002b2:	c9                   	leave  
  8002b3:	c3                   	ret    

008002b4 <exit>:

void
exit(void)
{
  8002b4:	55                   	push   %ebp
  8002b5:	89 e5                	mov    %esp,%ebp
  8002b7:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002ba:	e8 36 2d 00 00       	call   802ff5 <sys_exit_env>
}
  8002bf:	90                   	nop
  8002c0:	c9                   	leave  
  8002c1:	c3                   	ret    

008002c2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002c2:	55                   	push   %ebp
  8002c3:	89 e5                	mov    %esp,%ebp
  8002c5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002c8:	8d 45 10             	lea    0x10(%ebp),%eax
  8002cb:	83 c0 04             	add    $0x4,%eax
  8002ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002d1:	a1 38 51 83 00       	mov    0x835138,%eax
  8002d6:	85 c0                	test   %eax,%eax
  8002d8:	74 16                	je     8002f0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002da:	a1 38 51 83 00       	mov    0x835138,%eax
  8002df:	83 ec 08             	sub    $0x8,%esp
  8002e2:	50                   	push   %eax
  8002e3:	68 e0 41 80 00       	push   $0x8041e0
  8002e8:	e8 a3 02 00 00       	call   800590 <cprintf>
  8002ed:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8002f0:	a1 04 50 80 00       	mov    0x805004,%eax
  8002f5:	83 ec 0c             	sub    $0xc,%esp
  8002f8:	ff 75 0c             	pushl  0xc(%ebp)
  8002fb:	ff 75 08             	pushl  0x8(%ebp)
  8002fe:	50                   	push   %eax
  8002ff:	68 e8 41 80 00       	push   $0x8041e8
  800304:	6a 74                	push   $0x74
  800306:	e8 b2 02 00 00       	call   8005bd <cprintf_colored>
  80030b:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80030e:	8b 45 10             	mov    0x10(%ebp),%eax
  800311:	83 ec 08             	sub    $0x8,%esp
  800314:	ff 75 f4             	pushl  -0xc(%ebp)
  800317:	50                   	push   %eax
  800318:	e8 04 02 00 00       	call   800521 <vcprintf>
  80031d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800320:	83 ec 08             	sub    $0x8,%esp
  800323:	6a 00                	push   $0x0
  800325:	68 10 42 80 00       	push   $0x804210
  80032a:	e8 f2 01 00 00       	call   800521 <vcprintf>
  80032f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800332:	e8 7d ff ff ff       	call   8002b4 <exit>

	// should not return here
	while (1) ;
  800337:	eb fe                	jmp    800337 <_panic+0x75>

00800339 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800339:	55                   	push   %ebp
  80033a:	89 e5                	mov    %esp,%ebp
  80033c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80033f:	a1 20 50 80 00       	mov    0x805020,%eax
  800344:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80034a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80034d:	39 c2                	cmp    %eax,%edx
  80034f:	74 14                	je     800365 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800351:	83 ec 04             	sub    $0x4,%esp
  800354:	68 14 42 80 00       	push   $0x804214
  800359:	6a 26                	push   $0x26
  80035b:	68 60 42 80 00       	push   $0x804260
  800360:	e8 5d ff ff ff       	call   8002c2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800365:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80036c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800373:	e9 c5 00 00 00       	jmp    80043d <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800378:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80037b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800382:	8b 45 08             	mov    0x8(%ebp),%eax
  800385:	01 d0                	add    %edx,%eax
  800387:	8b 00                	mov    (%eax),%eax
  800389:	85 c0                	test   %eax,%eax
  80038b:	75 08                	jne    800395 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80038d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800390:	e9 a5 00 00 00       	jmp    80043a <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800395:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80039c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003a3:	eb 69                	jmp    80040e <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003a5:	a1 20 50 80 00       	mov    0x805020,%eax
  8003aa:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8003b0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003b3:	89 d0                	mov    %edx,%eax
  8003b5:	01 c0                	add    %eax,%eax
  8003b7:	01 d0                	add    %edx,%eax
  8003b9:	c1 e0 03             	shl    $0x3,%eax
  8003bc:	01 c8                	add    %ecx,%eax
  8003be:	8a 40 04             	mov    0x4(%eax),%al
  8003c1:	84 c0                	test   %al,%al
  8003c3:	75 46                	jne    80040b <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003c5:	a1 20 50 80 00       	mov    0x805020,%eax
  8003ca:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8003d0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003d3:	89 d0                	mov    %edx,%eax
  8003d5:	01 c0                	add    %eax,%eax
  8003d7:	01 d0                	add    %edx,%eax
  8003d9:	c1 e0 03             	shl    $0x3,%eax
  8003dc:	01 c8                	add    %ecx,%eax
  8003de:	8b 00                	mov    (%eax),%eax
  8003e0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003e3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003e6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003eb:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fa:	01 c8                	add    %ecx,%eax
  8003fc:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003fe:	39 c2                	cmp    %eax,%edx
  800400:	75 09                	jne    80040b <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800402:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800409:	eb 15                	jmp    800420 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80040b:	ff 45 e8             	incl   -0x18(%ebp)
  80040e:	a1 20 50 80 00       	mov    0x805020,%eax
  800413:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800419:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80041c:	39 c2                	cmp    %eax,%edx
  80041e:	77 85                	ja     8003a5 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800420:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800424:	75 14                	jne    80043a <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800426:	83 ec 04             	sub    $0x4,%esp
  800429:	68 6c 42 80 00       	push   $0x80426c
  80042e:	6a 3a                	push   $0x3a
  800430:	68 60 42 80 00       	push   $0x804260
  800435:	e8 88 fe ff ff       	call   8002c2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80043a:	ff 45 f0             	incl   -0x10(%ebp)
  80043d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800440:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800443:	0f 8c 2f ff ff ff    	jl     800378 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800449:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800450:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800457:	eb 26                	jmp    80047f <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800459:	a1 20 50 80 00       	mov    0x805020,%eax
  80045e:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800464:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800467:	89 d0                	mov    %edx,%eax
  800469:	01 c0                	add    %eax,%eax
  80046b:	01 d0                	add    %edx,%eax
  80046d:	c1 e0 03             	shl    $0x3,%eax
  800470:	01 c8                	add    %ecx,%eax
  800472:	8a 40 04             	mov    0x4(%eax),%al
  800475:	3c 01                	cmp    $0x1,%al
  800477:	75 03                	jne    80047c <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800479:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80047c:	ff 45 e0             	incl   -0x20(%ebp)
  80047f:	a1 20 50 80 00       	mov    0x805020,%eax
  800484:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80048a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80048d:	39 c2                	cmp    %eax,%edx
  80048f:	77 c8                	ja     800459 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800491:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800494:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800497:	74 14                	je     8004ad <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800499:	83 ec 04             	sub    $0x4,%esp
  80049c:	68 c0 42 80 00       	push   $0x8042c0
  8004a1:	6a 44                	push   $0x44
  8004a3:	68 60 42 80 00       	push   $0x804260
  8004a8:	e8 15 fe ff ff       	call   8002c2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004ad:	90                   	nop
  8004ae:	c9                   	leave  
  8004af:	c3                   	ret    

008004b0 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8004b0:	55                   	push   %ebp
  8004b1:	89 e5                	mov    %esp,%ebp
  8004b3:	53                   	push   %ebx
  8004b4:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8004b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ba:	8b 00                	mov    (%eax),%eax
  8004bc:	8d 48 01             	lea    0x1(%eax),%ecx
  8004bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c2:	89 0a                	mov    %ecx,(%edx)
  8004c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8004c7:	88 d1                	mov    %dl,%cl
  8004c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004cc:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d3:	8b 00                	mov    (%eax),%eax
  8004d5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004da:	75 30                	jne    80050c <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8004dc:	8b 15 3c 51 83 00    	mov    0x83513c,%edx
  8004e2:	a0 64 d0 81 00       	mov    0x81d064,%al
  8004e7:	0f b6 c0             	movzbl %al,%eax
  8004ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004ed:	8b 09                	mov    (%ecx),%ecx
  8004ef:	89 cb                	mov    %ecx,%ebx
  8004f1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004f4:	83 c1 08             	add    $0x8,%ecx
  8004f7:	52                   	push   %edx
  8004f8:	50                   	push   %eax
  8004f9:	53                   	push   %ebx
  8004fa:	51                   	push   %ecx
  8004fb:	e8 06 28 00 00       	call   802d06 <sys_cputs>
  800500:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800503:	8b 45 0c             	mov    0xc(%ebp),%eax
  800506:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80050c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80050f:	8b 40 04             	mov    0x4(%eax),%eax
  800512:	8d 50 01             	lea    0x1(%eax),%edx
  800515:	8b 45 0c             	mov    0xc(%ebp),%eax
  800518:	89 50 04             	mov    %edx,0x4(%eax)
}
  80051b:	90                   	nop
  80051c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80051f:	c9                   	leave  
  800520:	c3                   	ret    

00800521 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800521:	55                   	push   %ebp
  800522:	89 e5                	mov    %esp,%ebp
  800524:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80052a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800531:	00 00 00 
	b.cnt = 0;
  800534:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80053b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80053e:	ff 75 0c             	pushl  0xc(%ebp)
  800541:	ff 75 08             	pushl  0x8(%ebp)
  800544:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80054a:	50                   	push   %eax
  80054b:	68 b0 04 80 00       	push   $0x8004b0
  800550:	e8 5a 02 00 00       	call   8007af <vprintfmt>
  800555:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800558:	8b 15 3c 51 83 00    	mov    0x83513c,%edx
  80055e:	a0 64 d0 81 00       	mov    0x81d064,%al
  800563:	0f b6 c0             	movzbl %al,%eax
  800566:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80056c:	52                   	push   %edx
  80056d:	50                   	push   %eax
  80056e:	51                   	push   %ecx
  80056f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800575:	83 c0 08             	add    $0x8,%eax
  800578:	50                   	push   %eax
  800579:	e8 88 27 00 00       	call   802d06 <sys_cputs>
  80057e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800581:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
	return b.cnt;
  800588:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80058e:	c9                   	leave  
  80058f:	c3                   	ret    

00800590 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800590:	55                   	push   %ebp
  800591:	89 e5                	mov    %esp,%ebp
  800593:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800596:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	va_start(ap, fmt);
  80059d:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a6:	83 ec 08             	sub    $0x8,%esp
  8005a9:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ac:	50                   	push   %eax
  8005ad:	e8 6f ff ff ff       	call   800521 <vcprintf>
  8005b2:	83 c4 10             	add    $0x10,%esp
  8005b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005bb:	c9                   	leave  
  8005bc:	c3                   	ret    

008005bd <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8005bd:	55                   	push   %ebp
  8005be:	89 e5                	mov    %esp,%ebp
  8005c0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005c3:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	curTextClr = (textClr << 8) ; //set text color by the given value
  8005ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cd:	c1 e0 08             	shl    $0x8,%eax
  8005d0:	a3 3c 51 83 00       	mov    %eax,0x83513c
	va_start(ap, fmt);
  8005d5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005d8:	83 c0 04             	add    $0x4,%eax
  8005db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e1:	83 ec 08             	sub    $0x8,%esp
  8005e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8005e7:	50                   	push   %eax
  8005e8:	e8 34 ff ff ff       	call   800521 <vcprintf>
  8005ed:	83 c4 10             	add    $0x10,%esp
  8005f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8005f3:	c7 05 3c 51 83 00 00 	movl   $0x700,0x83513c
  8005fa:	07 00 00 

	return cnt;
  8005fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800600:	c9                   	leave  
  800601:	c3                   	ret    

00800602 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800602:	55                   	push   %ebp
  800603:	89 e5                	mov    %esp,%ebp
  800605:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800608:	e8 3d 27 00 00       	call   802d4a <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80060d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800610:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800613:	8b 45 08             	mov    0x8(%ebp),%eax
  800616:	83 ec 08             	sub    $0x8,%esp
  800619:	ff 75 f4             	pushl  -0xc(%ebp)
  80061c:	50                   	push   %eax
  80061d:	e8 ff fe ff ff       	call   800521 <vcprintf>
  800622:	83 c4 10             	add    $0x10,%esp
  800625:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800628:	e8 37 27 00 00       	call   802d64 <sys_unlock_cons>
	return cnt;
  80062d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800630:	c9                   	leave  
  800631:	c3                   	ret    

00800632 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800632:	55                   	push   %ebp
  800633:	89 e5                	mov    %esp,%ebp
  800635:	53                   	push   %ebx
  800636:	83 ec 14             	sub    $0x14,%esp
  800639:	8b 45 10             	mov    0x10(%ebp),%eax
  80063c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80063f:	8b 45 14             	mov    0x14(%ebp),%eax
  800642:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800645:	8b 45 18             	mov    0x18(%ebp),%eax
  800648:	ba 00 00 00 00       	mov    $0x0,%edx
  80064d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800650:	77 55                	ja     8006a7 <printnum+0x75>
  800652:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800655:	72 05                	jb     80065c <printnum+0x2a>
  800657:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80065a:	77 4b                	ja     8006a7 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80065c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80065f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800662:	8b 45 18             	mov    0x18(%ebp),%eax
  800665:	ba 00 00 00 00       	mov    $0x0,%edx
  80066a:	52                   	push   %edx
  80066b:	50                   	push   %eax
  80066c:	ff 75 f4             	pushl  -0xc(%ebp)
  80066f:	ff 75 f0             	pushl  -0x10(%ebp)
  800672:	e8 a5 36 00 00       	call   803d1c <__udivdi3>
  800677:	83 c4 10             	add    $0x10,%esp
  80067a:	83 ec 04             	sub    $0x4,%esp
  80067d:	ff 75 20             	pushl  0x20(%ebp)
  800680:	53                   	push   %ebx
  800681:	ff 75 18             	pushl  0x18(%ebp)
  800684:	52                   	push   %edx
  800685:	50                   	push   %eax
  800686:	ff 75 0c             	pushl  0xc(%ebp)
  800689:	ff 75 08             	pushl  0x8(%ebp)
  80068c:	e8 a1 ff ff ff       	call   800632 <printnum>
  800691:	83 c4 20             	add    $0x20,%esp
  800694:	eb 1a                	jmp    8006b0 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800696:	83 ec 08             	sub    $0x8,%esp
  800699:	ff 75 0c             	pushl  0xc(%ebp)
  80069c:	ff 75 20             	pushl  0x20(%ebp)
  80069f:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a2:	ff d0                	call   *%eax
  8006a4:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006a7:	ff 4d 1c             	decl   0x1c(%ebp)
  8006aa:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006ae:	7f e6                	jg     800696 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006b0:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006b3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006be:	53                   	push   %ebx
  8006bf:	51                   	push   %ecx
  8006c0:	52                   	push   %edx
  8006c1:	50                   	push   %eax
  8006c2:	e8 65 37 00 00       	call   803e2c <__umoddi3>
  8006c7:	83 c4 10             	add    $0x10,%esp
  8006ca:	05 34 45 80 00       	add    $0x804534,%eax
  8006cf:	8a 00                	mov    (%eax),%al
  8006d1:	0f be c0             	movsbl %al,%eax
  8006d4:	83 ec 08             	sub    $0x8,%esp
  8006d7:	ff 75 0c             	pushl  0xc(%ebp)
  8006da:	50                   	push   %eax
  8006db:	8b 45 08             	mov    0x8(%ebp),%eax
  8006de:	ff d0                	call   *%eax
  8006e0:	83 c4 10             	add    $0x10,%esp
}
  8006e3:	90                   	nop
  8006e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006e7:	c9                   	leave  
  8006e8:	c3                   	ret    

008006e9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006e9:	55                   	push   %ebp
  8006ea:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006ec:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006f0:	7e 1c                	jle    80070e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f5:	8b 00                	mov    (%eax),%eax
  8006f7:	8d 50 08             	lea    0x8(%eax),%edx
  8006fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fd:	89 10                	mov    %edx,(%eax)
  8006ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800702:	8b 00                	mov    (%eax),%eax
  800704:	83 e8 08             	sub    $0x8,%eax
  800707:	8b 50 04             	mov    0x4(%eax),%edx
  80070a:	8b 00                	mov    (%eax),%eax
  80070c:	eb 40                	jmp    80074e <getuint+0x65>
	else if (lflag)
  80070e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800712:	74 1e                	je     800732 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800714:	8b 45 08             	mov    0x8(%ebp),%eax
  800717:	8b 00                	mov    (%eax),%eax
  800719:	8d 50 04             	lea    0x4(%eax),%edx
  80071c:	8b 45 08             	mov    0x8(%ebp),%eax
  80071f:	89 10                	mov    %edx,(%eax)
  800721:	8b 45 08             	mov    0x8(%ebp),%eax
  800724:	8b 00                	mov    (%eax),%eax
  800726:	83 e8 04             	sub    $0x4,%eax
  800729:	8b 00                	mov    (%eax),%eax
  80072b:	ba 00 00 00 00       	mov    $0x0,%edx
  800730:	eb 1c                	jmp    80074e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800732:	8b 45 08             	mov    0x8(%ebp),%eax
  800735:	8b 00                	mov    (%eax),%eax
  800737:	8d 50 04             	lea    0x4(%eax),%edx
  80073a:	8b 45 08             	mov    0x8(%ebp),%eax
  80073d:	89 10                	mov    %edx,(%eax)
  80073f:	8b 45 08             	mov    0x8(%ebp),%eax
  800742:	8b 00                	mov    (%eax),%eax
  800744:	83 e8 04             	sub    $0x4,%eax
  800747:	8b 00                	mov    (%eax),%eax
  800749:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80074e:	5d                   	pop    %ebp
  80074f:	c3                   	ret    

00800750 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800750:	55                   	push   %ebp
  800751:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800753:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800757:	7e 1c                	jle    800775 <getint+0x25>
		return va_arg(*ap, long long);
  800759:	8b 45 08             	mov    0x8(%ebp),%eax
  80075c:	8b 00                	mov    (%eax),%eax
  80075e:	8d 50 08             	lea    0x8(%eax),%edx
  800761:	8b 45 08             	mov    0x8(%ebp),%eax
  800764:	89 10                	mov    %edx,(%eax)
  800766:	8b 45 08             	mov    0x8(%ebp),%eax
  800769:	8b 00                	mov    (%eax),%eax
  80076b:	83 e8 08             	sub    $0x8,%eax
  80076e:	8b 50 04             	mov    0x4(%eax),%edx
  800771:	8b 00                	mov    (%eax),%eax
  800773:	eb 38                	jmp    8007ad <getint+0x5d>
	else if (lflag)
  800775:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800779:	74 1a                	je     800795 <getint+0x45>
		return va_arg(*ap, long);
  80077b:	8b 45 08             	mov    0x8(%ebp),%eax
  80077e:	8b 00                	mov    (%eax),%eax
  800780:	8d 50 04             	lea    0x4(%eax),%edx
  800783:	8b 45 08             	mov    0x8(%ebp),%eax
  800786:	89 10                	mov    %edx,(%eax)
  800788:	8b 45 08             	mov    0x8(%ebp),%eax
  80078b:	8b 00                	mov    (%eax),%eax
  80078d:	83 e8 04             	sub    $0x4,%eax
  800790:	8b 00                	mov    (%eax),%eax
  800792:	99                   	cltd   
  800793:	eb 18                	jmp    8007ad <getint+0x5d>
	else
		return va_arg(*ap, int);
  800795:	8b 45 08             	mov    0x8(%ebp),%eax
  800798:	8b 00                	mov    (%eax),%eax
  80079a:	8d 50 04             	lea    0x4(%eax),%edx
  80079d:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a0:	89 10                	mov    %edx,(%eax)
  8007a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a5:	8b 00                	mov    (%eax),%eax
  8007a7:	83 e8 04             	sub    $0x4,%eax
  8007aa:	8b 00                	mov    (%eax),%eax
  8007ac:	99                   	cltd   
}
  8007ad:	5d                   	pop    %ebp
  8007ae:	c3                   	ret    

008007af <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007af:	55                   	push   %ebp
  8007b0:	89 e5                	mov    %esp,%ebp
  8007b2:	56                   	push   %esi
  8007b3:	53                   	push   %ebx
  8007b4:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007b7:	eb 17                	jmp    8007d0 <vprintfmt+0x21>
			if (ch == '\0')
  8007b9:	85 db                	test   %ebx,%ebx
  8007bb:	0f 84 c1 03 00 00    	je     800b82 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007c1:	83 ec 08             	sub    $0x8,%esp
  8007c4:	ff 75 0c             	pushl  0xc(%ebp)
  8007c7:	53                   	push   %ebx
  8007c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cb:	ff d0                	call   *%eax
  8007cd:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d3:	8d 50 01             	lea    0x1(%eax),%edx
  8007d6:	89 55 10             	mov    %edx,0x10(%ebp)
  8007d9:	8a 00                	mov    (%eax),%al
  8007db:	0f b6 d8             	movzbl %al,%ebx
  8007de:	83 fb 25             	cmp    $0x25,%ebx
  8007e1:	75 d6                	jne    8007b9 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007e3:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007e7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007ee:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007f5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007fc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800803:	8b 45 10             	mov    0x10(%ebp),%eax
  800806:	8d 50 01             	lea    0x1(%eax),%edx
  800809:	89 55 10             	mov    %edx,0x10(%ebp)
  80080c:	8a 00                	mov    (%eax),%al
  80080e:	0f b6 d8             	movzbl %al,%ebx
  800811:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800814:	83 f8 5b             	cmp    $0x5b,%eax
  800817:	0f 87 3d 03 00 00    	ja     800b5a <vprintfmt+0x3ab>
  80081d:	8b 04 85 58 45 80 00 	mov    0x804558(,%eax,4),%eax
  800824:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800826:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80082a:	eb d7                	jmp    800803 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80082c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800830:	eb d1                	jmp    800803 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800832:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800839:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80083c:	89 d0                	mov    %edx,%eax
  80083e:	c1 e0 02             	shl    $0x2,%eax
  800841:	01 d0                	add    %edx,%eax
  800843:	01 c0                	add    %eax,%eax
  800845:	01 d8                	add    %ebx,%eax
  800847:	83 e8 30             	sub    $0x30,%eax
  80084a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80084d:	8b 45 10             	mov    0x10(%ebp),%eax
  800850:	8a 00                	mov    (%eax),%al
  800852:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800855:	83 fb 2f             	cmp    $0x2f,%ebx
  800858:	7e 3e                	jle    800898 <vprintfmt+0xe9>
  80085a:	83 fb 39             	cmp    $0x39,%ebx
  80085d:	7f 39                	jg     800898 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80085f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800862:	eb d5                	jmp    800839 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800864:	8b 45 14             	mov    0x14(%ebp),%eax
  800867:	83 c0 04             	add    $0x4,%eax
  80086a:	89 45 14             	mov    %eax,0x14(%ebp)
  80086d:	8b 45 14             	mov    0x14(%ebp),%eax
  800870:	83 e8 04             	sub    $0x4,%eax
  800873:	8b 00                	mov    (%eax),%eax
  800875:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800878:	eb 1f                	jmp    800899 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80087a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80087e:	79 83                	jns    800803 <vprintfmt+0x54>
				width = 0;
  800880:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800887:	e9 77 ff ff ff       	jmp    800803 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80088c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800893:	e9 6b ff ff ff       	jmp    800803 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800898:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800899:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80089d:	0f 89 60 ff ff ff    	jns    800803 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008a9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008b0:	e9 4e ff ff ff       	jmp    800803 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008b5:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008b8:	e9 46 ff ff ff       	jmp    800803 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c0:	83 c0 04             	add    $0x4,%eax
  8008c3:	89 45 14             	mov    %eax,0x14(%ebp)
  8008c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c9:	83 e8 04             	sub    $0x4,%eax
  8008cc:	8b 00                	mov    (%eax),%eax
  8008ce:	83 ec 08             	sub    $0x8,%esp
  8008d1:	ff 75 0c             	pushl  0xc(%ebp)
  8008d4:	50                   	push   %eax
  8008d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d8:	ff d0                	call   *%eax
  8008da:	83 c4 10             	add    $0x10,%esp
			break;
  8008dd:	e9 9b 02 00 00       	jmp    800b7d <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e5:	83 c0 04             	add    $0x4,%eax
  8008e8:	89 45 14             	mov    %eax,0x14(%ebp)
  8008eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ee:	83 e8 04             	sub    $0x4,%eax
  8008f1:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008f3:	85 db                	test   %ebx,%ebx
  8008f5:	79 02                	jns    8008f9 <vprintfmt+0x14a>
				err = -err;
  8008f7:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008f9:	83 fb 64             	cmp    $0x64,%ebx
  8008fc:	7f 0b                	jg     800909 <vprintfmt+0x15a>
  8008fe:	8b 34 9d a0 43 80 00 	mov    0x8043a0(,%ebx,4),%esi
  800905:	85 f6                	test   %esi,%esi
  800907:	75 19                	jne    800922 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800909:	53                   	push   %ebx
  80090a:	68 45 45 80 00       	push   $0x804545
  80090f:	ff 75 0c             	pushl  0xc(%ebp)
  800912:	ff 75 08             	pushl  0x8(%ebp)
  800915:	e8 70 02 00 00       	call   800b8a <printfmt>
  80091a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80091d:	e9 5b 02 00 00       	jmp    800b7d <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800922:	56                   	push   %esi
  800923:	68 4e 45 80 00       	push   $0x80454e
  800928:	ff 75 0c             	pushl  0xc(%ebp)
  80092b:	ff 75 08             	pushl  0x8(%ebp)
  80092e:	e8 57 02 00 00       	call   800b8a <printfmt>
  800933:	83 c4 10             	add    $0x10,%esp
			break;
  800936:	e9 42 02 00 00       	jmp    800b7d <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80093b:	8b 45 14             	mov    0x14(%ebp),%eax
  80093e:	83 c0 04             	add    $0x4,%eax
  800941:	89 45 14             	mov    %eax,0x14(%ebp)
  800944:	8b 45 14             	mov    0x14(%ebp),%eax
  800947:	83 e8 04             	sub    $0x4,%eax
  80094a:	8b 30                	mov    (%eax),%esi
  80094c:	85 f6                	test   %esi,%esi
  80094e:	75 05                	jne    800955 <vprintfmt+0x1a6>
				p = "(null)";
  800950:	be 51 45 80 00       	mov    $0x804551,%esi
			if (width > 0 && padc != '-')
  800955:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800959:	7e 6d                	jle    8009c8 <vprintfmt+0x219>
  80095b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80095f:	74 67                	je     8009c8 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800961:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800964:	83 ec 08             	sub    $0x8,%esp
  800967:	50                   	push   %eax
  800968:	56                   	push   %esi
  800969:	e8 1e 03 00 00       	call   800c8c <strnlen>
  80096e:	83 c4 10             	add    $0x10,%esp
  800971:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800974:	eb 16                	jmp    80098c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800976:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80097a:	83 ec 08             	sub    $0x8,%esp
  80097d:	ff 75 0c             	pushl  0xc(%ebp)
  800980:	50                   	push   %eax
  800981:	8b 45 08             	mov    0x8(%ebp),%eax
  800984:	ff d0                	call   *%eax
  800986:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800989:	ff 4d e4             	decl   -0x1c(%ebp)
  80098c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800990:	7f e4                	jg     800976 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800992:	eb 34                	jmp    8009c8 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800994:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800998:	74 1c                	je     8009b6 <vprintfmt+0x207>
  80099a:	83 fb 1f             	cmp    $0x1f,%ebx
  80099d:	7e 05                	jle    8009a4 <vprintfmt+0x1f5>
  80099f:	83 fb 7e             	cmp    $0x7e,%ebx
  8009a2:	7e 12                	jle    8009b6 <vprintfmt+0x207>
					putch('?', putdat);
  8009a4:	83 ec 08             	sub    $0x8,%esp
  8009a7:	ff 75 0c             	pushl  0xc(%ebp)
  8009aa:	6a 3f                	push   $0x3f
  8009ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8009af:	ff d0                	call   *%eax
  8009b1:	83 c4 10             	add    $0x10,%esp
  8009b4:	eb 0f                	jmp    8009c5 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009b6:	83 ec 08             	sub    $0x8,%esp
  8009b9:	ff 75 0c             	pushl  0xc(%ebp)
  8009bc:	53                   	push   %ebx
  8009bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c0:	ff d0                	call   *%eax
  8009c2:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009c5:	ff 4d e4             	decl   -0x1c(%ebp)
  8009c8:	89 f0                	mov    %esi,%eax
  8009ca:	8d 70 01             	lea    0x1(%eax),%esi
  8009cd:	8a 00                	mov    (%eax),%al
  8009cf:	0f be d8             	movsbl %al,%ebx
  8009d2:	85 db                	test   %ebx,%ebx
  8009d4:	74 24                	je     8009fa <vprintfmt+0x24b>
  8009d6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009da:	78 b8                	js     800994 <vprintfmt+0x1e5>
  8009dc:	ff 4d e0             	decl   -0x20(%ebp)
  8009df:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009e3:	79 af                	jns    800994 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009e5:	eb 13                	jmp    8009fa <vprintfmt+0x24b>
				putch(' ', putdat);
  8009e7:	83 ec 08             	sub    $0x8,%esp
  8009ea:	ff 75 0c             	pushl  0xc(%ebp)
  8009ed:	6a 20                	push   $0x20
  8009ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f2:	ff d0                	call   *%eax
  8009f4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009f7:	ff 4d e4             	decl   -0x1c(%ebp)
  8009fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009fe:	7f e7                	jg     8009e7 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a00:	e9 78 01 00 00       	jmp    800b7d <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a05:	83 ec 08             	sub    $0x8,%esp
  800a08:	ff 75 e8             	pushl  -0x18(%ebp)
  800a0b:	8d 45 14             	lea    0x14(%ebp),%eax
  800a0e:	50                   	push   %eax
  800a0f:	e8 3c fd ff ff       	call   800750 <getint>
  800a14:	83 c4 10             	add    $0x10,%esp
  800a17:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a1a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a23:	85 d2                	test   %edx,%edx
  800a25:	79 23                	jns    800a4a <vprintfmt+0x29b>
				putch('-', putdat);
  800a27:	83 ec 08             	sub    $0x8,%esp
  800a2a:	ff 75 0c             	pushl  0xc(%ebp)
  800a2d:	6a 2d                	push   $0x2d
  800a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a32:	ff d0                	call   *%eax
  800a34:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a3d:	f7 d8                	neg    %eax
  800a3f:	83 d2 00             	adc    $0x0,%edx
  800a42:	f7 da                	neg    %edx
  800a44:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a47:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a4a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a51:	e9 bc 00 00 00       	jmp    800b12 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a56:	83 ec 08             	sub    $0x8,%esp
  800a59:	ff 75 e8             	pushl  -0x18(%ebp)
  800a5c:	8d 45 14             	lea    0x14(%ebp),%eax
  800a5f:	50                   	push   %eax
  800a60:	e8 84 fc ff ff       	call   8006e9 <getuint>
  800a65:	83 c4 10             	add    $0x10,%esp
  800a68:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a6b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a6e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a75:	e9 98 00 00 00       	jmp    800b12 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a7a:	83 ec 08             	sub    $0x8,%esp
  800a7d:	ff 75 0c             	pushl  0xc(%ebp)
  800a80:	6a 58                	push   $0x58
  800a82:	8b 45 08             	mov    0x8(%ebp),%eax
  800a85:	ff d0                	call   *%eax
  800a87:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a8a:	83 ec 08             	sub    $0x8,%esp
  800a8d:	ff 75 0c             	pushl  0xc(%ebp)
  800a90:	6a 58                	push   $0x58
  800a92:	8b 45 08             	mov    0x8(%ebp),%eax
  800a95:	ff d0                	call   *%eax
  800a97:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a9a:	83 ec 08             	sub    $0x8,%esp
  800a9d:	ff 75 0c             	pushl  0xc(%ebp)
  800aa0:	6a 58                	push   $0x58
  800aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa5:	ff d0                	call   *%eax
  800aa7:	83 c4 10             	add    $0x10,%esp
			break;
  800aaa:	e9 ce 00 00 00       	jmp    800b7d <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800aaf:	83 ec 08             	sub    $0x8,%esp
  800ab2:	ff 75 0c             	pushl  0xc(%ebp)
  800ab5:	6a 30                	push   $0x30
  800ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aba:	ff d0                	call   *%eax
  800abc:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800abf:	83 ec 08             	sub    $0x8,%esp
  800ac2:	ff 75 0c             	pushl  0xc(%ebp)
  800ac5:	6a 78                	push   $0x78
  800ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aca:	ff d0                	call   *%eax
  800acc:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800acf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad2:	83 c0 04             	add    $0x4,%eax
  800ad5:	89 45 14             	mov    %eax,0x14(%ebp)
  800ad8:	8b 45 14             	mov    0x14(%ebp),%eax
  800adb:	83 e8 04             	sub    $0x4,%eax
  800ade:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ae0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ae3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800aea:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800af1:	eb 1f                	jmp    800b12 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800af3:	83 ec 08             	sub    $0x8,%esp
  800af6:	ff 75 e8             	pushl  -0x18(%ebp)
  800af9:	8d 45 14             	lea    0x14(%ebp),%eax
  800afc:	50                   	push   %eax
  800afd:	e8 e7 fb ff ff       	call   8006e9 <getuint>
  800b02:	83 c4 10             	add    $0x10,%esp
  800b05:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b08:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b0b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b12:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b19:	83 ec 04             	sub    $0x4,%esp
  800b1c:	52                   	push   %edx
  800b1d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b20:	50                   	push   %eax
  800b21:	ff 75 f4             	pushl  -0xc(%ebp)
  800b24:	ff 75 f0             	pushl  -0x10(%ebp)
  800b27:	ff 75 0c             	pushl  0xc(%ebp)
  800b2a:	ff 75 08             	pushl  0x8(%ebp)
  800b2d:	e8 00 fb ff ff       	call   800632 <printnum>
  800b32:	83 c4 20             	add    $0x20,%esp
			break;
  800b35:	eb 46                	jmp    800b7d <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b37:	83 ec 08             	sub    $0x8,%esp
  800b3a:	ff 75 0c             	pushl  0xc(%ebp)
  800b3d:	53                   	push   %ebx
  800b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b41:	ff d0                	call   *%eax
  800b43:	83 c4 10             	add    $0x10,%esp
			break;
  800b46:	eb 35                	jmp    800b7d <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b48:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
			break;
  800b4f:	eb 2c                	jmp    800b7d <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b51:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
			break;
  800b58:	eb 23                	jmp    800b7d <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b5a:	83 ec 08             	sub    $0x8,%esp
  800b5d:	ff 75 0c             	pushl  0xc(%ebp)
  800b60:	6a 25                	push   $0x25
  800b62:	8b 45 08             	mov    0x8(%ebp),%eax
  800b65:	ff d0                	call   *%eax
  800b67:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b6a:	ff 4d 10             	decl   0x10(%ebp)
  800b6d:	eb 03                	jmp    800b72 <vprintfmt+0x3c3>
  800b6f:	ff 4d 10             	decl   0x10(%ebp)
  800b72:	8b 45 10             	mov    0x10(%ebp),%eax
  800b75:	48                   	dec    %eax
  800b76:	8a 00                	mov    (%eax),%al
  800b78:	3c 25                	cmp    $0x25,%al
  800b7a:	75 f3                	jne    800b6f <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b7c:	90                   	nop
		}
	}
  800b7d:	e9 35 fc ff ff       	jmp    8007b7 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b82:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b83:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b86:	5b                   	pop    %ebx
  800b87:	5e                   	pop    %esi
  800b88:	5d                   	pop    %ebp
  800b89:	c3                   	ret    

00800b8a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b8a:	55                   	push   %ebp
  800b8b:	89 e5                	mov    %esp,%ebp
  800b8d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b90:	8d 45 10             	lea    0x10(%ebp),%eax
  800b93:	83 c0 04             	add    $0x4,%eax
  800b96:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b99:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9c:	ff 75 f4             	pushl  -0xc(%ebp)
  800b9f:	50                   	push   %eax
  800ba0:	ff 75 0c             	pushl  0xc(%ebp)
  800ba3:	ff 75 08             	pushl  0x8(%ebp)
  800ba6:	e8 04 fc ff ff       	call   8007af <vprintfmt>
  800bab:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bae:	90                   	nop
  800baf:	c9                   	leave  
  800bb0:	c3                   	ret    

00800bb1 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bb1:	55                   	push   %ebp
  800bb2:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb7:	8b 40 08             	mov    0x8(%eax),%eax
  800bba:	8d 50 01             	lea    0x1(%eax),%edx
  800bbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc0:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc6:	8b 10                	mov    (%eax),%edx
  800bc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bcb:	8b 40 04             	mov    0x4(%eax),%eax
  800bce:	39 c2                	cmp    %eax,%edx
  800bd0:	73 12                	jae    800be4 <sprintputch+0x33>
		*b->buf++ = ch;
  800bd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd5:	8b 00                	mov    (%eax),%eax
  800bd7:	8d 48 01             	lea    0x1(%eax),%ecx
  800bda:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bdd:	89 0a                	mov    %ecx,(%edx)
  800bdf:	8b 55 08             	mov    0x8(%ebp),%edx
  800be2:	88 10                	mov    %dl,(%eax)
}
  800be4:	90                   	nop
  800be5:	5d                   	pop    %ebp
  800be6:	c3                   	ret    

00800be7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800be7:	55                   	push   %ebp
  800be8:	89 e5                	mov    %esp,%ebp
  800bea:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bed:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bf3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfc:	01 d0                	add    %edx,%eax
  800bfe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c01:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c08:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c0c:	74 06                	je     800c14 <vsnprintf+0x2d>
  800c0e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c12:	7f 07                	jg     800c1b <vsnprintf+0x34>
		return -E_INVAL;
  800c14:	b8 03 00 00 00       	mov    $0x3,%eax
  800c19:	eb 20                	jmp    800c3b <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c1b:	ff 75 14             	pushl  0x14(%ebp)
  800c1e:	ff 75 10             	pushl  0x10(%ebp)
  800c21:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c24:	50                   	push   %eax
  800c25:	68 b1 0b 80 00       	push   $0x800bb1
  800c2a:	e8 80 fb ff ff       	call   8007af <vprintfmt>
  800c2f:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c35:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c3b:	c9                   	leave  
  800c3c:	c3                   	ret    

00800c3d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c3d:	55                   	push   %ebp
  800c3e:	89 e5                	mov    %esp,%ebp
  800c40:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c43:	8d 45 10             	lea    0x10(%ebp),%eax
  800c46:	83 c0 04             	add    $0x4,%eax
  800c49:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c4c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4f:	ff 75 f4             	pushl  -0xc(%ebp)
  800c52:	50                   	push   %eax
  800c53:	ff 75 0c             	pushl  0xc(%ebp)
  800c56:	ff 75 08             	pushl  0x8(%ebp)
  800c59:	e8 89 ff ff ff       	call   800be7 <vsnprintf>
  800c5e:	83 c4 10             	add    $0x10,%esp
  800c61:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c64:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c67:	c9                   	leave  
  800c68:	c3                   	ret    

00800c69 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c69:	55                   	push   %ebp
  800c6a:	89 e5                	mov    %esp,%ebp
  800c6c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c6f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c76:	eb 06                	jmp    800c7e <strlen+0x15>
		n++;
  800c78:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c7b:	ff 45 08             	incl   0x8(%ebp)
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c81:	8a 00                	mov    (%eax),%al
  800c83:	84 c0                	test   %al,%al
  800c85:	75 f1                	jne    800c78 <strlen+0xf>
		n++;
	return n;
  800c87:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c8a:	c9                   	leave  
  800c8b:	c3                   	ret    

00800c8c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c8c:	55                   	push   %ebp
  800c8d:	89 e5                	mov    %esp,%ebp
  800c8f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c92:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c99:	eb 09                	jmp    800ca4 <strnlen+0x18>
		n++;
  800c9b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c9e:	ff 45 08             	incl   0x8(%ebp)
  800ca1:	ff 4d 0c             	decl   0xc(%ebp)
  800ca4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ca8:	74 09                	je     800cb3 <strnlen+0x27>
  800caa:	8b 45 08             	mov    0x8(%ebp),%eax
  800cad:	8a 00                	mov    (%eax),%al
  800caf:	84 c0                	test   %al,%al
  800cb1:	75 e8                	jne    800c9b <strnlen+0xf>
		n++;
	return n;
  800cb3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cb6:	c9                   	leave  
  800cb7:	c3                   	ret    

00800cb8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cb8:	55                   	push   %ebp
  800cb9:	89 e5                	mov    %esp,%ebp
  800cbb:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cc4:	90                   	nop
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc8:	8d 50 01             	lea    0x1(%eax),%edx
  800ccb:	89 55 08             	mov    %edx,0x8(%ebp)
  800cce:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cd1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cd4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cd7:	8a 12                	mov    (%edx),%dl
  800cd9:	88 10                	mov    %dl,(%eax)
  800cdb:	8a 00                	mov    (%eax),%al
  800cdd:	84 c0                	test   %al,%al
  800cdf:	75 e4                	jne    800cc5 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ce1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ce4:	c9                   	leave  
  800ce5:	c3                   	ret    

00800ce6 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ce6:	55                   	push   %ebp
  800ce7:	89 e5                	mov    %esp,%ebp
  800ce9:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cec:	8b 45 08             	mov    0x8(%ebp),%eax
  800cef:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cf2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cf9:	eb 1f                	jmp    800d1a <strncpy+0x34>
		*dst++ = *src;
  800cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfe:	8d 50 01             	lea    0x1(%eax),%edx
  800d01:	89 55 08             	mov    %edx,0x8(%ebp)
  800d04:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d07:	8a 12                	mov    (%edx),%dl
  800d09:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0e:	8a 00                	mov    (%eax),%al
  800d10:	84 c0                	test   %al,%al
  800d12:	74 03                	je     800d17 <strncpy+0x31>
			src++;
  800d14:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d17:	ff 45 fc             	incl   -0x4(%ebp)
  800d1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d1d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d20:	72 d9                	jb     800cfb <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d22:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d25:	c9                   	leave  
  800d26:	c3                   	ret    

00800d27 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d27:	55                   	push   %ebp
  800d28:	89 e5                	mov    %esp,%ebp
  800d2a:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d30:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d33:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d37:	74 30                	je     800d69 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d39:	eb 16                	jmp    800d51 <strlcpy+0x2a>
			*dst++ = *src++;
  800d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3e:	8d 50 01             	lea    0x1(%eax),%edx
  800d41:	89 55 08             	mov    %edx,0x8(%ebp)
  800d44:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d47:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d4a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d4d:	8a 12                	mov    (%edx),%dl
  800d4f:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d51:	ff 4d 10             	decl   0x10(%ebp)
  800d54:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d58:	74 09                	je     800d63 <strlcpy+0x3c>
  800d5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5d:	8a 00                	mov    (%eax),%al
  800d5f:	84 c0                	test   %al,%al
  800d61:	75 d8                	jne    800d3b <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d63:	8b 45 08             	mov    0x8(%ebp),%eax
  800d66:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d69:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d6f:	29 c2                	sub    %eax,%edx
  800d71:	89 d0                	mov    %edx,%eax
}
  800d73:	c9                   	leave  
  800d74:	c3                   	ret    

00800d75 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d75:	55                   	push   %ebp
  800d76:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d78:	eb 06                	jmp    800d80 <strcmp+0xb>
		p++, q++;
  800d7a:	ff 45 08             	incl   0x8(%ebp)
  800d7d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8a 00                	mov    (%eax),%al
  800d85:	84 c0                	test   %al,%al
  800d87:	74 0e                	je     800d97 <strcmp+0x22>
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	8a 10                	mov    (%eax),%dl
  800d8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d91:	8a 00                	mov    (%eax),%al
  800d93:	38 c2                	cmp    %al,%dl
  800d95:	74 e3                	je     800d7a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d97:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9a:	8a 00                	mov    (%eax),%al
  800d9c:	0f b6 d0             	movzbl %al,%edx
  800d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da2:	8a 00                	mov    (%eax),%al
  800da4:	0f b6 c0             	movzbl %al,%eax
  800da7:	29 c2                	sub    %eax,%edx
  800da9:	89 d0                	mov    %edx,%eax
}
  800dab:	5d                   	pop    %ebp
  800dac:	c3                   	ret    

00800dad <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800dad:	55                   	push   %ebp
  800dae:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800db0:	eb 09                	jmp    800dbb <strncmp+0xe>
		n--, p++, q++;
  800db2:	ff 4d 10             	decl   0x10(%ebp)
  800db5:	ff 45 08             	incl   0x8(%ebp)
  800db8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800dbb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dbf:	74 17                	je     800dd8 <strncmp+0x2b>
  800dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc4:	8a 00                	mov    (%eax),%al
  800dc6:	84 c0                	test   %al,%al
  800dc8:	74 0e                	je     800dd8 <strncmp+0x2b>
  800dca:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcd:	8a 10                	mov    (%eax),%dl
  800dcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd2:	8a 00                	mov    (%eax),%al
  800dd4:	38 c2                	cmp    %al,%dl
  800dd6:	74 da                	je     800db2 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dd8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ddc:	75 07                	jne    800de5 <strncmp+0x38>
		return 0;
  800dde:	b8 00 00 00 00       	mov    $0x0,%eax
  800de3:	eb 14                	jmp    800df9 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800de5:	8b 45 08             	mov    0x8(%ebp),%eax
  800de8:	8a 00                	mov    (%eax),%al
  800dea:	0f b6 d0             	movzbl %al,%edx
  800ded:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df0:	8a 00                	mov    (%eax),%al
  800df2:	0f b6 c0             	movzbl %al,%eax
  800df5:	29 c2                	sub    %eax,%edx
  800df7:	89 d0                	mov    %edx,%eax
}
  800df9:	5d                   	pop    %ebp
  800dfa:	c3                   	ret    

00800dfb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800dfb:	55                   	push   %ebp
  800dfc:	89 e5                	mov    %esp,%ebp
  800dfe:	83 ec 04             	sub    $0x4,%esp
  800e01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e04:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e07:	eb 12                	jmp    800e1b <strchr+0x20>
		if (*s == c)
  800e09:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0c:	8a 00                	mov    (%eax),%al
  800e0e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e11:	75 05                	jne    800e18 <strchr+0x1d>
			return (char *) s;
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
  800e16:	eb 11                	jmp    800e29 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e18:	ff 45 08             	incl   0x8(%ebp)
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	8a 00                	mov    (%eax),%al
  800e20:	84 c0                	test   %al,%al
  800e22:	75 e5                	jne    800e09 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e29:	c9                   	leave  
  800e2a:	c3                   	ret    

00800e2b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e2b:	55                   	push   %ebp
  800e2c:	89 e5                	mov    %esp,%ebp
  800e2e:	83 ec 04             	sub    $0x4,%esp
  800e31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e34:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e37:	eb 0d                	jmp    800e46 <strfind+0x1b>
		if (*s == c)
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	8a 00                	mov    (%eax),%al
  800e3e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e41:	74 0e                	je     800e51 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e43:	ff 45 08             	incl   0x8(%ebp)
  800e46:	8b 45 08             	mov    0x8(%ebp),%eax
  800e49:	8a 00                	mov    (%eax),%al
  800e4b:	84 c0                	test   %al,%al
  800e4d:	75 ea                	jne    800e39 <strfind+0xe>
  800e4f:	eb 01                	jmp    800e52 <strfind+0x27>
		if (*s == c)
			break;
  800e51:	90                   	nop
	return (char *) s;
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e55:	c9                   	leave  
  800e56:	c3                   	ret    

00800e57 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e57:	55                   	push   %ebp
  800e58:	89 e5                	mov    %esp,%ebp
  800e5a:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e60:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e63:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e67:	76 63                	jbe    800ecc <memset+0x75>
		uint64 data_block = c;
  800e69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6c:	99                   	cltd   
  800e6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e70:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e79:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e7d:	c1 e0 08             	shl    $0x8,%eax
  800e80:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e83:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800e86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e89:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e8c:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800e90:	c1 e0 10             	shl    $0x10,%eax
  800e93:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e96:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800e99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e9f:	89 c2                	mov    %eax,%edx
  800ea1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ea6:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ea9:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800eac:	eb 18                	jmp    800ec6 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800eae:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800eb1:	8d 41 08             	lea    0x8(%ecx),%eax
  800eb4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800eb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ebd:	89 01                	mov    %eax,(%ecx)
  800ebf:	89 51 04             	mov    %edx,0x4(%ecx)
  800ec2:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800ec6:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800eca:	77 e2                	ja     800eae <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800ecc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed0:	74 23                	je     800ef5 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800ed2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ed8:	eb 0e                	jmp    800ee8 <memset+0x91>
			*p8++ = (uint8)c;
  800eda:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800edd:	8d 50 01             	lea    0x1(%eax),%edx
  800ee0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ee3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ee6:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800ee8:	8b 45 10             	mov    0x10(%ebp),%eax
  800eeb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eee:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef1:	85 c0                	test   %eax,%eax
  800ef3:	75 e5                	jne    800eda <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800ef5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ef8:	c9                   	leave  
  800ef9:	c3                   	ret    

00800efa <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800efa:	55                   	push   %ebp
  800efb:	89 e5                	mov    %esp,%ebp
  800efd:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f03:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f06:	8b 45 08             	mov    0x8(%ebp),%eax
  800f09:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f0c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f10:	76 24                	jbe    800f36 <memcpy+0x3c>
		while(n >= 8){
  800f12:	eb 1c                	jmp    800f30 <memcpy+0x36>
			*d64 = *s64;
  800f14:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f17:	8b 50 04             	mov    0x4(%eax),%edx
  800f1a:	8b 00                	mov    (%eax),%eax
  800f1c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f1f:	89 01                	mov    %eax,(%ecx)
  800f21:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f24:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f28:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f2c:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f30:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f34:	77 de                	ja     800f14 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f36:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f3a:	74 31                	je     800f6d <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f42:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f45:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f48:	eb 16                	jmp    800f60 <memcpy+0x66>
			*d8++ = *s8++;
  800f4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f4d:	8d 50 01             	lea    0x1(%eax),%edx
  800f50:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f56:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f59:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f5c:	8a 12                	mov    (%edx),%dl
  800f5e:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f60:	8b 45 10             	mov    0x10(%ebp),%eax
  800f63:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f66:	89 55 10             	mov    %edx,0x10(%ebp)
  800f69:	85 c0                	test   %eax,%eax
  800f6b:	75 dd                	jne    800f4a <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f70:	c9                   	leave  
  800f71:	c3                   	ret    

00800f72 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f72:	55                   	push   %ebp
  800f73:	89 e5                	mov    %esp,%ebp
  800f75:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f81:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f84:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f87:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f8a:	73 50                	jae    800fdc <memmove+0x6a>
  800f8c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f8f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f92:	01 d0                	add    %edx,%eax
  800f94:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f97:	76 43                	jbe    800fdc <memmove+0x6a>
		s += n;
  800f99:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f9f:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa2:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fa5:	eb 10                	jmp    800fb7 <memmove+0x45>
			*--d = *--s;
  800fa7:	ff 4d f8             	decl   -0x8(%ebp)
  800faa:	ff 4d fc             	decl   -0x4(%ebp)
  800fad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb0:	8a 10                	mov    (%eax),%dl
  800fb2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb5:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fb7:	8b 45 10             	mov    0x10(%ebp),%eax
  800fba:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fbd:	89 55 10             	mov    %edx,0x10(%ebp)
  800fc0:	85 c0                	test   %eax,%eax
  800fc2:	75 e3                	jne    800fa7 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fc4:	eb 23                	jmp    800fe9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fc6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc9:	8d 50 01             	lea    0x1(%eax),%edx
  800fcc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fcf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fd2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fd5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fd8:	8a 12                	mov    (%edx),%dl
  800fda:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fdc:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fe2:	89 55 10             	mov    %edx,0x10(%ebp)
  800fe5:	85 c0                	test   %eax,%eax
  800fe7:	75 dd                	jne    800fc6 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fec:	c9                   	leave  
  800fed:	c3                   	ret    

00800fee <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fee:	55                   	push   %ebp
  800fef:	89 e5                	mov    %esp,%ebp
  800ff1:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ffa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffd:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801000:	eb 2a                	jmp    80102c <memcmp+0x3e>
		if (*s1 != *s2)
  801002:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801005:	8a 10                	mov    (%eax),%dl
  801007:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80100a:	8a 00                	mov    (%eax),%al
  80100c:	38 c2                	cmp    %al,%dl
  80100e:	74 16                	je     801026 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801010:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801013:	8a 00                	mov    (%eax),%al
  801015:	0f b6 d0             	movzbl %al,%edx
  801018:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101b:	8a 00                	mov    (%eax),%al
  80101d:	0f b6 c0             	movzbl %al,%eax
  801020:	29 c2                	sub    %eax,%edx
  801022:	89 d0                	mov    %edx,%eax
  801024:	eb 18                	jmp    80103e <memcmp+0x50>
		s1++, s2++;
  801026:	ff 45 fc             	incl   -0x4(%ebp)
  801029:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80102c:	8b 45 10             	mov    0x10(%ebp),%eax
  80102f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801032:	89 55 10             	mov    %edx,0x10(%ebp)
  801035:	85 c0                	test   %eax,%eax
  801037:	75 c9                	jne    801002 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801039:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80103e:	c9                   	leave  
  80103f:	c3                   	ret    

00801040 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801040:	55                   	push   %ebp
  801041:	89 e5                	mov    %esp,%ebp
  801043:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801046:	8b 55 08             	mov    0x8(%ebp),%edx
  801049:	8b 45 10             	mov    0x10(%ebp),%eax
  80104c:	01 d0                	add    %edx,%eax
  80104e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801051:	eb 15                	jmp    801068 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801053:	8b 45 08             	mov    0x8(%ebp),%eax
  801056:	8a 00                	mov    (%eax),%al
  801058:	0f b6 d0             	movzbl %al,%edx
  80105b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105e:	0f b6 c0             	movzbl %al,%eax
  801061:	39 c2                	cmp    %eax,%edx
  801063:	74 0d                	je     801072 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801065:	ff 45 08             	incl   0x8(%ebp)
  801068:	8b 45 08             	mov    0x8(%ebp),%eax
  80106b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80106e:	72 e3                	jb     801053 <memfind+0x13>
  801070:	eb 01                	jmp    801073 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801072:	90                   	nop
	return (void *) s;
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801076:	c9                   	leave  
  801077:	c3                   	ret    

00801078 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801078:	55                   	push   %ebp
  801079:	89 e5                	mov    %esp,%ebp
  80107b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80107e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801085:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80108c:	eb 03                	jmp    801091 <strtol+0x19>
		s++;
  80108e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801091:	8b 45 08             	mov    0x8(%ebp),%eax
  801094:	8a 00                	mov    (%eax),%al
  801096:	3c 20                	cmp    $0x20,%al
  801098:	74 f4                	je     80108e <strtol+0x16>
  80109a:	8b 45 08             	mov    0x8(%ebp),%eax
  80109d:	8a 00                	mov    (%eax),%al
  80109f:	3c 09                	cmp    $0x9,%al
  8010a1:	74 eb                	je     80108e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a6:	8a 00                	mov    (%eax),%al
  8010a8:	3c 2b                	cmp    $0x2b,%al
  8010aa:	75 05                	jne    8010b1 <strtol+0x39>
		s++;
  8010ac:	ff 45 08             	incl   0x8(%ebp)
  8010af:	eb 13                	jmp    8010c4 <strtol+0x4c>
	else if (*s == '-')
  8010b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b4:	8a 00                	mov    (%eax),%al
  8010b6:	3c 2d                	cmp    $0x2d,%al
  8010b8:	75 0a                	jne    8010c4 <strtol+0x4c>
		s++, neg = 1;
  8010ba:	ff 45 08             	incl   0x8(%ebp)
  8010bd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010c4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010c8:	74 06                	je     8010d0 <strtol+0x58>
  8010ca:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010ce:	75 20                	jne    8010f0 <strtol+0x78>
  8010d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d3:	8a 00                	mov    (%eax),%al
  8010d5:	3c 30                	cmp    $0x30,%al
  8010d7:	75 17                	jne    8010f0 <strtol+0x78>
  8010d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dc:	40                   	inc    %eax
  8010dd:	8a 00                	mov    (%eax),%al
  8010df:	3c 78                	cmp    $0x78,%al
  8010e1:	75 0d                	jne    8010f0 <strtol+0x78>
		s += 2, base = 16;
  8010e3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010e7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010ee:	eb 28                	jmp    801118 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010f0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010f4:	75 15                	jne    80110b <strtol+0x93>
  8010f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f9:	8a 00                	mov    (%eax),%al
  8010fb:	3c 30                	cmp    $0x30,%al
  8010fd:	75 0c                	jne    80110b <strtol+0x93>
		s++, base = 8;
  8010ff:	ff 45 08             	incl   0x8(%ebp)
  801102:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801109:	eb 0d                	jmp    801118 <strtol+0xa0>
	else if (base == 0)
  80110b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80110f:	75 07                	jne    801118 <strtol+0xa0>
		base = 10;
  801111:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
  80111b:	8a 00                	mov    (%eax),%al
  80111d:	3c 2f                	cmp    $0x2f,%al
  80111f:	7e 19                	jle    80113a <strtol+0xc2>
  801121:	8b 45 08             	mov    0x8(%ebp),%eax
  801124:	8a 00                	mov    (%eax),%al
  801126:	3c 39                	cmp    $0x39,%al
  801128:	7f 10                	jg     80113a <strtol+0xc2>
			dig = *s - '0';
  80112a:	8b 45 08             	mov    0x8(%ebp),%eax
  80112d:	8a 00                	mov    (%eax),%al
  80112f:	0f be c0             	movsbl %al,%eax
  801132:	83 e8 30             	sub    $0x30,%eax
  801135:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801138:	eb 42                	jmp    80117c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80113a:	8b 45 08             	mov    0x8(%ebp),%eax
  80113d:	8a 00                	mov    (%eax),%al
  80113f:	3c 60                	cmp    $0x60,%al
  801141:	7e 19                	jle    80115c <strtol+0xe4>
  801143:	8b 45 08             	mov    0x8(%ebp),%eax
  801146:	8a 00                	mov    (%eax),%al
  801148:	3c 7a                	cmp    $0x7a,%al
  80114a:	7f 10                	jg     80115c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
  80114f:	8a 00                	mov    (%eax),%al
  801151:	0f be c0             	movsbl %al,%eax
  801154:	83 e8 57             	sub    $0x57,%eax
  801157:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80115a:	eb 20                	jmp    80117c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80115c:	8b 45 08             	mov    0x8(%ebp),%eax
  80115f:	8a 00                	mov    (%eax),%al
  801161:	3c 40                	cmp    $0x40,%al
  801163:	7e 39                	jle    80119e <strtol+0x126>
  801165:	8b 45 08             	mov    0x8(%ebp),%eax
  801168:	8a 00                	mov    (%eax),%al
  80116a:	3c 5a                	cmp    $0x5a,%al
  80116c:	7f 30                	jg     80119e <strtol+0x126>
			dig = *s - 'A' + 10;
  80116e:	8b 45 08             	mov    0x8(%ebp),%eax
  801171:	8a 00                	mov    (%eax),%al
  801173:	0f be c0             	movsbl %al,%eax
  801176:	83 e8 37             	sub    $0x37,%eax
  801179:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80117c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80117f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801182:	7d 19                	jge    80119d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801184:	ff 45 08             	incl   0x8(%ebp)
  801187:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80118a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80118e:	89 c2                	mov    %eax,%edx
  801190:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801193:	01 d0                	add    %edx,%eax
  801195:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801198:	e9 7b ff ff ff       	jmp    801118 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80119d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80119e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011a2:	74 08                	je     8011ac <strtol+0x134>
		*endptr = (char *) s;
  8011a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8011aa:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011b0:	74 07                	je     8011b9 <strtol+0x141>
  8011b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b5:	f7 d8                	neg    %eax
  8011b7:	eb 03                	jmp    8011bc <strtol+0x144>
  8011b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011bc:	c9                   	leave  
  8011bd:	c3                   	ret    

008011be <ltostr>:

void
ltostr(long value, char *str)
{
  8011be:	55                   	push   %ebp
  8011bf:	89 e5                	mov    %esp,%ebp
  8011c1:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011cb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011d6:	79 13                	jns    8011eb <ltostr+0x2d>
	{
		neg = 1;
  8011d8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011e5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011e8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ee:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011f3:	99                   	cltd   
  8011f4:	f7 f9                	idiv   %ecx
  8011f6:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011fc:	8d 50 01             	lea    0x1(%eax),%edx
  8011ff:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801202:	89 c2                	mov    %eax,%edx
  801204:	8b 45 0c             	mov    0xc(%ebp),%eax
  801207:	01 d0                	add    %edx,%eax
  801209:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80120c:	83 c2 30             	add    $0x30,%edx
  80120f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801211:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801214:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801219:	f7 e9                	imul   %ecx
  80121b:	c1 fa 02             	sar    $0x2,%edx
  80121e:	89 c8                	mov    %ecx,%eax
  801220:	c1 f8 1f             	sar    $0x1f,%eax
  801223:	29 c2                	sub    %eax,%edx
  801225:	89 d0                	mov    %edx,%eax
  801227:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80122a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80122e:	75 bb                	jne    8011eb <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801230:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801237:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80123a:	48                   	dec    %eax
  80123b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80123e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801242:	74 3d                	je     801281 <ltostr+0xc3>
		start = 1 ;
  801244:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80124b:	eb 34                	jmp    801281 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80124d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801250:	8b 45 0c             	mov    0xc(%ebp),%eax
  801253:	01 d0                	add    %edx,%eax
  801255:	8a 00                	mov    (%eax),%al
  801257:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80125a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80125d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801260:	01 c2                	add    %eax,%edx
  801262:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801265:	8b 45 0c             	mov    0xc(%ebp),%eax
  801268:	01 c8                	add    %ecx,%eax
  80126a:	8a 00                	mov    (%eax),%al
  80126c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80126e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801271:	8b 45 0c             	mov    0xc(%ebp),%eax
  801274:	01 c2                	add    %eax,%edx
  801276:	8a 45 eb             	mov    -0x15(%ebp),%al
  801279:	88 02                	mov    %al,(%edx)
		start++ ;
  80127b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80127e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801281:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801284:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801287:	7c c4                	jl     80124d <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801289:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80128c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128f:	01 d0                	add    %edx,%eax
  801291:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801294:	90                   	nop
  801295:	c9                   	leave  
  801296:	c3                   	ret    

00801297 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801297:	55                   	push   %ebp
  801298:	89 e5                	mov    %esp,%ebp
  80129a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80129d:	ff 75 08             	pushl  0x8(%ebp)
  8012a0:	e8 c4 f9 ff ff       	call   800c69 <strlen>
  8012a5:	83 c4 04             	add    $0x4,%esp
  8012a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012ab:	ff 75 0c             	pushl  0xc(%ebp)
  8012ae:	e8 b6 f9 ff ff       	call   800c69 <strlen>
  8012b3:	83 c4 04             	add    $0x4,%esp
  8012b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012c0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012c7:	eb 17                	jmp    8012e0 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012cf:	01 c2                	add    %eax,%edx
  8012d1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d7:	01 c8                	add    %ecx,%eax
  8012d9:	8a 00                	mov    (%eax),%al
  8012db:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012dd:	ff 45 fc             	incl   -0x4(%ebp)
  8012e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012e3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012e6:	7c e1                	jl     8012c9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012e8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012ef:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012f6:	eb 1f                	jmp    801317 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012fb:	8d 50 01             	lea    0x1(%eax),%edx
  8012fe:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801301:	89 c2                	mov    %eax,%edx
  801303:	8b 45 10             	mov    0x10(%ebp),%eax
  801306:	01 c2                	add    %eax,%edx
  801308:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80130b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130e:	01 c8                	add    %ecx,%eax
  801310:	8a 00                	mov    (%eax),%al
  801312:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801314:	ff 45 f8             	incl   -0x8(%ebp)
  801317:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80131d:	7c d9                	jl     8012f8 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80131f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801322:	8b 45 10             	mov    0x10(%ebp),%eax
  801325:	01 d0                	add    %edx,%eax
  801327:	c6 00 00             	movb   $0x0,(%eax)
}
  80132a:	90                   	nop
  80132b:	c9                   	leave  
  80132c:	c3                   	ret    

0080132d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80132d:	55                   	push   %ebp
  80132e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801330:	8b 45 14             	mov    0x14(%ebp),%eax
  801333:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801339:	8b 45 14             	mov    0x14(%ebp),%eax
  80133c:	8b 00                	mov    (%eax),%eax
  80133e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801345:	8b 45 10             	mov    0x10(%ebp),%eax
  801348:	01 d0                	add    %edx,%eax
  80134a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801350:	eb 0c                	jmp    80135e <strsplit+0x31>
			*string++ = 0;
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
  801355:	8d 50 01             	lea    0x1(%eax),%edx
  801358:	89 55 08             	mov    %edx,0x8(%ebp)
  80135b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80135e:	8b 45 08             	mov    0x8(%ebp),%eax
  801361:	8a 00                	mov    (%eax),%al
  801363:	84 c0                	test   %al,%al
  801365:	74 18                	je     80137f <strsplit+0x52>
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
  80136a:	8a 00                	mov    (%eax),%al
  80136c:	0f be c0             	movsbl %al,%eax
  80136f:	50                   	push   %eax
  801370:	ff 75 0c             	pushl  0xc(%ebp)
  801373:	e8 83 fa ff ff       	call   800dfb <strchr>
  801378:	83 c4 08             	add    $0x8,%esp
  80137b:	85 c0                	test   %eax,%eax
  80137d:	75 d3                	jne    801352 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80137f:	8b 45 08             	mov    0x8(%ebp),%eax
  801382:	8a 00                	mov    (%eax),%al
  801384:	84 c0                	test   %al,%al
  801386:	74 5a                	je     8013e2 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801388:	8b 45 14             	mov    0x14(%ebp),%eax
  80138b:	8b 00                	mov    (%eax),%eax
  80138d:	83 f8 0f             	cmp    $0xf,%eax
  801390:	75 07                	jne    801399 <strsplit+0x6c>
		{
			return 0;
  801392:	b8 00 00 00 00       	mov    $0x0,%eax
  801397:	eb 66                	jmp    8013ff <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801399:	8b 45 14             	mov    0x14(%ebp),%eax
  80139c:	8b 00                	mov    (%eax),%eax
  80139e:	8d 48 01             	lea    0x1(%eax),%ecx
  8013a1:	8b 55 14             	mov    0x14(%ebp),%edx
  8013a4:	89 0a                	mov    %ecx,(%edx)
  8013a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b0:	01 c2                	add    %eax,%edx
  8013b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b5:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013b7:	eb 03                	jmp    8013bc <strsplit+0x8f>
			string++;
  8013b9:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bf:	8a 00                	mov    (%eax),%al
  8013c1:	84 c0                	test   %al,%al
  8013c3:	74 8b                	je     801350 <strsplit+0x23>
  8013c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c8:	8a 00                	mov    (%eax),%al
  8013ca:	0f be c0             	movsbl %al,%eax
  8013cd:	50                   	push   %eax
  8013ce:	ff 75 0c             	pushl  0xc(%ebp)
  8013d1:	e8 25 fa ff ff       	call   800dfb <strchr>
  8013d6:	83 c4 08             	add    $0x8,%esp
  8013d9:	85 c0                	test   %eax,%eax
  8013db:	74 dc                	je     8013b9 <strsplit+0x8c>
			string++;
	}
  8013dd:	e9 6e ff ff ff       	jmp    801350 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013e2:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8013e6:	8b 00                	mov    (%eax),%eax
  8013e8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f2:	01 d0                	add    %edx,%eax
  8013f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013fa:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013ff:	c9                   	leave  
  801400:	c3                   	ret    

00801401 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801401:	55                   	push   %ebp
  801402:	89 e5                	mov    %esp,%ebp
  801404:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801407:	8b 45 08             	mov    0x8(%ebp),%eax
  80140a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80140d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801414:	eb 4a                	jmp    801460 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801416:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801419:	8b 45 08             	mov    0x8(%ebp),%eax
  80141c:	01 c2                	add    %eax,%edx
  80141e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801421:	8b 45 0c             	mov    0xc(%ebp),%eax
  801424:	01 c8                	add    %ecx,%eax
  801426:	8a 00                	mov    (%eax),%al
  801428:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80142a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80142d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801430:	01 d0                	add    %edx,%eax
  801432:	8a 00                	mov    (%eax),%al
  801434:	3c 40                	cmp    $0x40,%al
  801436:	7e 25                	jle    80145d <str2lower+0x5c>
  801438:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80143b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143e:	01 d0                	add    %edx,%eax
  801440:	8a 00                	mov    (%eax),%al
  801442:	3c 5a                	cmp    $0x5a,%al
  801444:	7f 17                	jg     80145d <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801446:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	01 d0                	add    %edx,%eax
  80144e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801451:	8b 55 08             	mov    0x8(%ebp),%edx
  801454:	01 ca                	add    %ecx,%edx
  801456:	8a 12                	mov    (%edx),%dl
  801458:	83 c2 20             	add    $0x20,%edx
  80145b:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80145d:	ff 45 fc             	incl   -0x4(%ebp)
  801460:	ff 75 0c             	pushl  0xc(%ebp)
  801463:	e8 01 f8 ff ff       	call   800c69 <strlen>
  801468:	83 c4 04             	add    $0x4,%esp
  80146b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80146e:	7f a6                	jg     801416 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801470:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801473:	c9                   	leave  
  801474:	c3                   	ret    

00801475 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801475:	55                   	push   %ebp
  801476:	89 e5                	mov    %esp,%ebp
  801478:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  80147b:	a1 08 50 80 00       	mov    0x805008,%eax
  801480:	85 c0                	test   %eax,%eax
  801482:	74 42                	je     8014c6 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801484:	83 ec 08             	sub    $0x8,%esp
  801487:	68 00 00 00 82       	push   $0x82000000
  80148c:	68 00 00 00 80       	push   $0x80000000
  801491:	e8 b0 1e 00 00       	call   803346 <initialize_dynamic_allocator>
  801496:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801499:	e8 96 1c 00 00       	call   803134 <sys_get_uheap_strategy>
  80149e:	a3 80 50 83 00       	mov    %eax,0x835080
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  8014a3:	a1 60 d0 81 00       	mov    0x81d060,%eax
  8014a8:	05 00 10 00 00       	add    $0x1000,%eax
  8014ad:	a3 30 51 83 00       	mov    %eax,0x835130
		uheapPageAllocBreak = uheapPageAllocStart;
  8014b2:	a1 30 51 83 00       	mov    0x835130,%eax
  8014b7:	a3 88 50 83 00       	mov    %eax,0x835088

		__firstTimeFlag = 0;
  8014bc:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8014c3:	00 00 00 
	}
}
  8014c6:	90                   	nop
  8014c7:	c9                   	leave  
  8014c8:	c3                   	ret    

008014c9 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8014c9:	55                   	push   %ebp
  8014ca:	89 e5                	mov    %esp,%ebp
  8014cc:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8014cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014d8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014dd:	83 ec 08             	sub    $0x8,%esp
  8014e0:	68 06 04 00 00       	push   $0x406
  8014e5:	50                   	push   %eax
  8014e6:	e8 93 18 00 00       	call   802d7e <__sys_allocate_page>
  8014eb:	83 c4 10             	add    $0x10,%esp
  8014ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8014f1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8014f5:	79 14                	jns    80150b <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8014f7:	83 ec 04             	sub    $0x4,%esp
  8014fa:	68 c8 46 80 00       	push   $0x8046c8
  8014ff:	6a 1f                	push   $0x1f
  801501:	68 04 47 80 00       	push   $0x804704
  801506:	e8 b7 ed ff ff       	call   8002c2 <_panic>
	return 0;
  80150b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801510:	c9                   	leave  
  801511:	c3                   	ret    

00801512 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801512:	55                   	push   %ebp
  801513:	89 e5                	mov    %esp,%ebp
  801515:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801518:	8b 45 08             	mov    0x8(%ebp),%eax
  80151b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80151e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801521:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801526:	83 ec 0c             	sub    $0xc,%esp
  801529:	50                   	push   %eax
  80152a:	e8 96 18 00 00       	call   802dc5 <__sys_unmap_frame>
  80152f:	83 c4 10             	add    $0x10,%esp
  801532:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801535:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801539:	79 14                	jns    80154f <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  80153b:	83 ec 04             	sub    $0x4,%esp
  80153e:	68 10 47 80 00       	push   $0x804710
  801543:	6a 2a                	push   $0x2a
  801545:	68 04 47 80 00       	push   $0x804704
  80154a:	e8 73 ed ff ff       	call   8002c2 <_panic>
}
  80154f:	90                   	nop
  801550:	c9                   	leave  
  801551:	c3                   	ret    

00801552 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801552:	55                   	push   %ebp
  801553:	89 e5                	mov    %esp,%ebp
  801555:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801558:	e8 18 ff ff ff       	call   801475 <uheap_init>
	if (size == 0) return NULL ;
  80155d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801561:	75 0a                	jne    80156d <malloc+0x1b>
  801563:	b8 00 00 00 00       	mov    $0x0,%eax
  801568:	e9 43 03 00 00       	jmp    8018b0 <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  80156d:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801574:	77 13                	ja     801589 <malloc+0x37>
    {
        return alloc_block(size);
  801576:	83 ec 0c             	sub    $0xc,%esp
  801579:	ff 75 08             	pushl  0x8(%ebp)
  80157c:	e8 78 20 00 00       	call   8035f9 <alloc_block>
  801581:	83 c4 10             	add    $0x10,%esp
  801584:	e9 27 03 00 00       	jmp    8018b0 <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801589:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801590:	8b 55 08             	mov    0x8(%ebp),%edx
  801593:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801596:	01 d0                	add    %edx,%eax
  801598:	48                   	dec    %eax
  801599:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80159c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80159f:	ba 00 00 00 00       	mov    $0x0,%edx
  8015a4:	f7 75 dc             	divl   -0x24(%ebp)
  8015a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015aa:	29 d0                	sub    %edx,%eax
  8015ac:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  8015af:	a1 40 d0 81 00       	mov    0x81d040,%eax
  8015b4:	85 c0                	test   %eax,%eax
  8015b6:	75 0a                	jne    8015c2 <malloc+0x70>
    {
        uhp_inited = 1;
  8015b8:	c7 05 40 d0 81 00 01 	movl   $0x1,0x81d040
  8015bf:	00 00 00 
    }

    int exactIdx = -1;
  8015c2:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  8015c9:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  8015d0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8015d7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8015de:	e9 85 00 00 00       	jmp    801668 <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  8015e3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8015e6:	89 d0                	mov    %edx,%eax
  8015e8:	01 c0                	add    %eax,%eax
  8015ea:	01 d0                	add    %edx,%eax
  8015ec:	c1 e0 02             	shl    $0x2,%eax
  8015ef:	05 48 10 81 00       	add    $0x811048,%eax
  8015f4:	8a 00                	mov    (%eax),%al
  8015f6:	84 c0                	test   %al,%al
  8015f8:	74 20                	je     80161a <malloc+0xc8>
  8015fa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8015fd:	89 d0                	mov    %edx,%eax
  8015ff:	01 c0                	add    %eax,%eax
  801601:	01 d0                	add    %edx,%eax
  801603:	c1 e0 02             	shl    $0x2,%eax
  801606:	05 44 10 81 00       	add    $0x811044,%eax
  80160b:	8b 00                	mov    (%eax),%eax
  80160d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801610:	75 08                	jne    80161a <malloc+0xc8>
        {
            exactIdx = i;
  801612:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801615:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801618:	eb 5b                	jmp    801675 <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  80161a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80161d:	89 d0                	mov    %edx,%eax
  80161f:	01 c0                	add    %eax,%eax
  801621:	01 d0                	add    %edx,%eax
  801623:	c1 e0 02             	shl    $0x2,%eax
  801626:	05 48 10 81 00       	add    $0x811048,%eax
  80162b:	8a 00                	mov    (%eax),%al
  80162d:	84 c0                	test   %al,%al
  80162f:	74 34                	je     801665 <malloc+0x113>
  801631:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801634:	89 d0                	mov    %edx,%eax
  801636:	01 c0                	add    %eax,%eax
  801638:	01 d0                	add    %edx,%eax
  80163a:	c1 e0 02             	shl    $0x2,%eax
  80163d:	05 44 10 81 00       	add    $0x811044,%eax
  801642:	8b 00                	mov    (%eax),%eax
  801644:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801647:	76 1c                	jbe    801665 <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  801649:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80164c:	89 d0                	mov    %edx,%eax
  80164e:	01 c0                	add    %eax,%eax
  801650:	01 d0                	add    %edx,%eax
  801652:	c1 e0 02             	shl    $0x2,%eax
  801655:	05 44 10 81 00       	add    $0x811044,%eax
  80165a:	8b 00                	mov    (%eax),%eax
  80165c:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  80165f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801662:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801665:	ff 45 e8             	incl   -0x18(%ebp)
  801668:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  80166f:	0f 8e 6e ff ff ff    	jle    8015e3 <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  801675:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  80167c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801680:	74 7d                	je     8016ff <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801682:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801689:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80168c:	89 d0                	mov    %edx,%eax
  80168e:	01 c0                	add    %eax,%eax
  801690:	01 d0                	add    %edx,%eax
  801692:	c1 e0 02             	shl    $0x2,%eax
  801695:	05 40 10 81 00       	add    $0x811040,%eax
  80169a:	8b 10                	mov    (%eax),%edx
  80169c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80169f:	01 d0                	add    %edx,%eax
  8016a1:	48                   	dec    %eax
  8016a2:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8016a5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8016a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ad:	f7 75 bc             	divl   -0x44(%ebp)
  8016b0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8016b3:	29 d0                	sub    %edx,%eax
  8016b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  8016b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016bb:	89 d0                	mov    %edx,%eax
  8016bd:	01 c0                	add    %eax,%eax
  8016bf:	01 d0                	add    %edx,%eax
  8016c1:	c1 e0 02             	shl    $0x2,%eax
  8016c4:	05 48 10 81 00       	add    $0x811048,%eax
  8016c9:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  8016cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016cf:	89 d0                	mov    %edx,%eax
  8016d1:	01 c0                	add    %eax,%eax
  8016d3:	01 d0                	add    %edx,%eax
  8016d5:	c1 e0 02             	shl    $0x2,%eax
  8016d8:	05 44 10 81 00       	add    $0x811044,%eax
  8016dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  8016e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016e6:	89 d0                	mov    %edx,%eax
  8016e8:	01 c0                	add    %eax,%eax
  8016ea:	01 d0                	add    %edx,%eax
  8016ec:	c1 e0 02             	shl    $0x2,%eax
  8016ef:	05 40 10 81 00       	add    $0x811040,%eax
  8016f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8016fa:	e9 2d 01 00 00       	jmp    80182c <malloc+0x2da>
    }
    else if (worstIdx != -1)
  8016ff:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801703:	0f 84 ce 00 00 00    	je     8017d7 <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  801709:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  801710:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801713:	89 d0                	mov    %edx,%eax
  801715:	01 c0                	add    %eax,%eax
  801717:	01 d0                	add    %edx,%eax
  801719:	c1 e0 02             	shl    $0x2,%eax
  80171c:	05 40 10 81 00       	add    $0x811040,%eax
  801721:	8b 10                	mov    (%eax),%edx
  801723:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801726:	01 d0                	add    %edx,%eax
  801728:	48                   	dec    %eax
  801729:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80172c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80172f:	ba 00 00 00 00       	mov    $0x0,%edx
  801734:	f7 75 c4             	divl   -0x3c(%ebp)
  801737:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80173a:	29 d0                	sub    %edx,%eax
  80173c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  80173f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801742:	89 d0                	mov    %edx,%eax
  801744:	01 c0                	add    %eax,%eax
  801746:	01 d0                	add    %edx,%eax
  801748:	c1 e0 02             	shl    $0x2,%eax
  80174b:	05 44 10 81 00       	add    $0x811044,%eax
  801750:	8b 00                	mov    (%eax),%eax
  801752:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801755:	75 47                	jne    80179e <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  801757:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80175a:	89 d0                	mov    %edx,%eax
  80175c:	01 c0                	add    %eax,%eax
  80175e:	01 d0                	add    %edx,%eax
  801760:	c1 e0 02             	shl    $0x2,%eax
  801763:	05 48 10 81 00       	add    $0x811048,%eax
  801768:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  80176b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80176e:	89 d0                	mov    %edx,%eax
  801770:	01 c0                	add    %eax,%eax
  801772:	01 d0                	add    %edx,%eax
  801774:	c1 e0 02             	shl    $0x2,%eax
  801777:	05 44 10 81 00       	add    $0x811044,%eax
  80177c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  801782:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801785:	89 d0                	mov    %edx,%eax
  801787:	01 c0                	add    %eax,%eax
  801789:	01 d0                	add    %edx,%eax
  80178b:	c1 e0 02             	shl    $0x2,%eax
  80178e:	05 40 10 81 00       	add    $0x811040,%eax
  801793:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801799:	e9 8e 00 00 00       	jmp    80182c <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  80179e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8017a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8017a4:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8017a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017aa:	89 d0                	mov    %edx,%eax
  8017ac:	01 c0                	add    %eax,%eax
  8017ae:	01 d0                	add    %edx,%eax
  8017b0:	c1 e0 02             	shl    $0x2,%eax
  8017b3:	05 40 10 81 00       	add    $0x811040,%eax
  8017b8:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  8017ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017bd:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8017c0:	89 c2                	mov    %eax,%edx
  8017c2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8017c5:	89 c8                	mov    %ecx,%eax
  8017c7:	01 c0                	add    %eax,%eax
  8017c9:	01 c8                	add    %ecx,%eax
  8017cb:	c1 e0 02             	shl    $0x2,%eax
  8017ce:	05 44 10 81 00       	add    $0x811044,%eax
  8017d3:	89 10                	mov    %edx,(%eax)
  8017d5:	eb 55                	jmp    80182c <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  8017d7:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  8017de:	8b 15 88 50 83 00    	mov    0x835088,%edx
  8017e4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8017e7:	01 d0                	add    %edx,%eax
  8017e9:	48                   	dec    %eax
  8017ea:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8017ed:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8017f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f5:	f7 75 d0             	divl   -0x30(%ebp)
  8017f8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8017fb:	29 d0                	sub    %edx,%eax
  8017fd:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  801800:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801803:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801806:	01 d0                	add    %edx,%eax
  801808:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  80180d:	76 0a                	jbe    801819 <malloc+0x2c7>
            return NULL;
  80180f:	b8 00 00 00 00       	mov    $0x0,%eax
  801814:	e9 97 00 00 00       	jmp    8018b0 <malloc+0x35e>
        va = start;
  801819:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80181c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  80181f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801822:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801825:	01 d0                	add    %edx,%eax
  801827:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80182c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801833:	eb 5e                	jmp    801893 <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  801835:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801838:	89 d0                	mov    %edx,%eax
  80183a:	01 c0                	add    %eax,%eax
  80183c:	01 d0                	add    %edx,%eax
  80183e:	c1 e0 02             	shl    $0x2,%eax
  801841:	05 48 50 80 00       	add    $0x805048,%eax
  801846:	8a 00                	mov    (%eax),%al
  801848:	84 c0                	test   %al,%al
  80184a:	75 44                	jne    801890 <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  80184c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80184f:	89 d0                	mov    %edx,%eax
  801851:	01 c0                	add    %eax,%eax
  801853:	01 d0                	add    %edx,%eax
  801855:	c1 e0 02             	shl    $0x2,%eax
  801858:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  80185e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801861:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  801863:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801866:	89 d0                	mov    %edx,%eax
  801868:	01 c0                	add    %eax,%eax
  80186a:	01 d0                	add    %edx,%eax
  80186c:	c1 e0 02             	shl    $0x2,%eax
  80186f:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  801875:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801878:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  80187a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80187d:	89 d0                	mov    %edx,%eax
  80187f:	01 c0                	add    %eax,%eax
  801881:	01 d0                	add    %edx,%eax
  801883:	c1 e0 02             	shl    $0x2,%eax
  801886:	05 48 50 80 00       	add    $0x805048,%eax
  80188b:	c6 00 01             	movb   $0x1,(%eax)
            break;
  80188e:	eb 0c                	jmp    80189c <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801890:	ff 45 e0             	incl   -0x20(%ebp)
  801893:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80189a:	7e 99                	jle    801835 <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  80189c:	83 ec 08             	sub    $0x8,%esp
  80189f:	ff 75 d4             	pushl  -0x2c(%ebp)
  8018a2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018a5:	e8 a2 19 00 00       	call   80324c <sys_allocate_user_mem>
  8018aa:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  8018ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8018b0:	c9                   	leave  
  8018b1:	c3                   	ret    

008018b2 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8018b2:	55                   	push   %ebp
  8018b3:	89 e5                	mov    %esp,%ebp
  8018b5:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  8018b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018bc:	0f 84 fa 03 00 00    	je     801cbc <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  8018c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  8018c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8018cb:	85 c0                	test   %eax,%eax
  8018cd:	79 1c                	jns    8018eb <free+0x39>
  8018cf:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  8018d6:	77 13                	ja     8018eb <free+0x39>
    {
        free_block(virtual_address);
  8018d8:	83 ec 0c             	sub    $0xc,%esp
  8018db:	ff 75 08             	pushl  0x8(%ebp)
  8018de:	e8 09 21 00 00       	call   8039ec <free_block>
  8018e3:	83 c4 10             	add    $0x10,%esp
        return;
  8018e6:	e9 d2 03 00 00       	jmp    801cbd <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  8018eb:	a1 30 51 83 00       	mov    0x835130,%eax
  8018f0:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  8018f3:	72 09                	jb     8018fe <free+0x4c>
  8018f5:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  8018fc:	76 17                	jbe    801915 <free+0x63>
        panic("free: invalid address");
  8018fe:	83 ec 04             	sub    $0x4,%esp
  801901:	68 4d 47 80 00       	push   $0x80474d
  801906:	68 9b 00 00 00       	push   $0x9b
  80190b:	68 04 47 80 00       	push   $0x804704
  801910:	e8 ad e9 ff ff       	call   8002c2 <_panic>

    uint32 size = 0;
  801915:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  80191c:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801923:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80192a:	eb 50                	jmp    80197c <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  80192c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80192f:	89 d0                	mov    %edx,%eax
  801931:	01 c0                	add    %eax,%eax
  801933:	01 d0                	add    %edx,%eax
  801935:	c1 e0 02             	shl    $0x2,%eax
  801938:	05 48 50 80 00       	add    $0x805048,%eax
  80193d:	8a 00                	mov    (%eax),%al
  80193f:	84 c0                	test   %al,%al
  801941:	74 36                	je     801979 <free+0xc7>
  801943:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801946:	89 d0                	mov    %edx,%eax
  801948:	01 c0                	add    %eax,%eax
  80194a:	01 d0                	add    %edx,%eax
  80194c:	c1 e0 02             	shl    $0x2,%eax
  80194f:	05 40 50 80 00       	add    $0x805040,%eax
  801954:	8b 00                	mov    (%eax),%eax
  801956:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801959:	75 1e                	jne    801979 <free+0xc7>
        {
            size = uhp_allocs[i].size;
  80195b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80195e:	89 d0                	mov    %edx,%eax
  801960:	01 c0                	add    %eax,%eax
  801962:	01 d0                	add    %edx,%eax
  801964:	c1 e0 02             	shl    $0x2,%eax
  801967:	05 44 50 80 00       	add    $0x805044,%eax
  80196c:	8b 00                	mov    (%eax),%eax
  80196e:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  801971:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801974:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  801977:	eb 0c                	jmp    801985 <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801979:	ff 45 ec             	incl   -0x14(%ebp)
  80197c:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  801983:	7e a7                	jle    80192c <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  801985:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801989:	74 06                	je     801991 <free+0xdf>
  80198b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80198f:	75 17                	jne    8019a8 <free+0xf6>
        panic("free: unknown block");
  801991:	83 ec 04             	sub    $0x4,%esp
  801994:	68 63 47 80 00       	push   $0x804763
  801999:	68 a9 00 00 00       	push   $0xa9
  80199e:	68 04 47 80 00       	push   $0x804704
  8019a3:	e8 1a e9 ff ff       	call   8002c2 <_panic>

    uhp_allocs[idx].used = 0;
  8019a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019ab:	89 d0                	mov    %edx,%eax
  8019ad:	01 c0                	add    %eax,%eax
  8019af:	01 d0                	add    %edx,%eax
  8019b1:	c1 e0 02             	shl    $0x2,%eax
  8019b4:	05 48 50 80 00       	add    $0x805048,%eax
  8019b9:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  8019bc:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8019c3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8019ca:	eb 64                	jmp    801a30 <free+0x17e>
    {
        if (!uhp_frees[i].free)
  8019cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8019cf:	89 d0                	mov    %edx,%eax
  8019d1:	01 c0                	add    %eax,%eax
  8019d3:	01 d0                	add    %edx,%eax
  8019d5:	c1 e0 02             	shl    $0x2,%eax
  8019d8:	05 48 10 81 00       	add    $0x811048,%eax
  8019dd:	8a 00                	mov    (%eax),%al
  8019df:	84 c0                	test   %al,%al
  8019e1:	75 4a                	jne    801a2d <free+0x17b>
        {
            uhp_frees[i].va = va;
  8019e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8019e6:	89 d0                	mov    %edx,%eax
  8019e8:	01 c0                	add    %eax,%eax
  8019ea:	01 d0                	add    %edx,%eax
  8019ec:	c1 e0 02             	shl    $0x2,%eax
  8019ef:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  8019f5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019f8:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  8019fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8019fd:	89 d0                	mov    %edx,%eax
  8019ff:	01 c0                	add    %eax,%eax
  801a01:	01 d0                	add    %edx,%eax
  801a03:	c1 e0 02             	shl    $0x2,%eax
  801a06:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  801a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a0f:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  801a11:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a14:	89 d0                	mov    %edx,%eax
  801a16:	01 c0                	add    %eax,%eax
  801a18:	01 d0                	add    %edx,%eax
  801a1a:	c1 e0 02             	shl    $0x2,%eax
  801a1d:	05 48 10 81 00       	add    $0x811048,%eax
  801a22:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  801a25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a28:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  801a2b:	eb 0c                	jmp    801a39 <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801a2d:	ff 45 e4             	incl   -0x1c(%ebp)
  801a30:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  801a37:	7e 93                	jle    8019cc <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  801a39:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  801a3d:	0f 84 f1 01 00 00    	je     801c34 <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801a43:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801a4a:	e9 d8 01 00 00       	jmp    801c27 <free+0x375>
        {
            if (i == fidx) continue;
  801a4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a52:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801a55:	0f 84 c8 01 00 00    	je     801c23 <free+0x371>
            if (uhp_frees[i].free)
  801a5b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a5e:	89 d0                	mov    %edx,%eax
  801a60:	01 c0                	add    %eax,%eax
  801a62:	01 d0                	add    %edx,%eax
  801a64:	c1 e0 02             	shl    $0x2,%eax
  801a67:	05 48 10 81 00       	add    $0x811048,%eax
  801a6c:	8a 00                	mov    (%eax),%al
  801a6e:	84 c0                	test   %al,%al
  801a70:	0f 84 ae 01 00 00    	je     801c24 <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  801a76:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a79:	89 d0                	mov    %edx,%eax
  801a7b:	01 c0                	add    %eax,%eax
  801a7d:	01 d0                	add    %edx,%eax
  801a7f:	c1 e0 02             	shl    $0x2,%eax
  801a82:	05 40 10 81 00       	add    $0x811040,%eax
  801a87:	8b 08                	mov    (%eax),%ecx
  801a89:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a8c:	89 d0                	mov    %edx,%eax
  801a8e:	01 c0                	add    %eax,%eax
  801a90:	01 d0                	add    %edx,%eax
  801a92:	c1 e0 02             	shl    $0x2,%eax
  801a95:	05 44 10 81 00       	add    $0x811044,%eax
  801a9a:	8b 00                	mov    (%eax),%eax
  801a9c:	01 c1                	add    %eax,%ecx
  801a9e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801aa1:	89 d0                	mov    %edx,%eax
  801aa3:	01 c0                	add    %eax,%eax
  801aa5:	01 d0                	add    %edx,%eax
  801aa7:	c1 e0 02             	shl    $0x2,%eax
  801aaa:	05 40 10 81 00       	add    $0x811040,%eax
  801aaf:	8b 00                	mov    (%eax),%eax
  801ab1:	39 c1                	cmp    %eax,%ecx
  801ab3:	0f 85 a8 00 00 00    	jne    801b61 <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  801ab9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801abc:	89 d0                	mov    %edx,%eax
  801abe:	01 c0                	add    %eax,%eax
  801ac0:	01 d0                	add    %edx,%eax
  801ac2:	c1 e0 02             	shl    $0x2,%eax
  801ac5:	05 40 10 81 00       	add    $0x811040,%eax
  801aca:	8b 10                	mov    (%eax),%edx
  801acc:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  801acf:	89 c8                	mov    %ecx,%eax
  801ad1:	01 c0                	add    %eax,%eax
  801ad3:	01 c8                	add    %ecx,%eax
  801ad5:	c1 e0 02             	shl    $0x2,%eax
  801ad8:	05 40 10 81 00       	add    $0x811040,%eax
  801add:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801adf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ae2:	89 d0                	mov    %edx,%eax
  801ae4:	01 c0                	add    %eax,%eax
  801ae6:	01 d0                	add    %edx,%eax
  801ae8:	c1 e0 02             	shl    $0x2,%eax
  801aeb:	05 44 10 81 00       	add    $0x811044,%eax
  801af0:	8b 08                	mov    (%eax),%ecx
  801af2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801af5:	89 d0                	mov    %edx,%eax
  801af7:	01 c0                	add    %eax,%eax
  801af9:	01 d0                	add    %edx,%eax
  801afb:	c1 e0 02             	shl    $0x2,%eax
  801afe:	05 44 10 81 00       	add    $0x811044,%eax
  801b03:	8b 00                	mov    (%eax),%eax
  801b05:	01 c1                	add    %eax,%ecx
  801b07:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b0a:	89 d0                	mov    %edx,%eax
  801b0c:	01 c0                	add    %eax,%eax
  801b0e:	01 d0                	add    %edx,%eax
  801b10:	c1 e0 02             	shl    $0x2,%eax
  801b13:	05 44 10 81 00       	add    $0x811044,%eax
  801b18:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801b1a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b1d:	89 d0                	mov    %edx,%eax
  801b1f:	01 c0                	add    %eax,%eax
  801b21:	01 d0                	add    %edx,%eax
  801b23:	c1 e0 02             	shl    $0x2,%eax
  801b26:	05 48 10 81 00       	add    $0x811048,%eax
  801b2b:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801b2e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b31:	89 d0                	mov    %edx,%eax
  801b33:	01 c0                	add    %eax,%eax
  801b35:	01 d0                	add    %edx,%eax
  801b37:	c1 e0 02             	shl    $0x2,%eax
  801b3a:	05 40 10 81 00       	add    $0x811040,%eax
  801b3f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801b45:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b48:	89 d0                	mov    %edx,%eax
  801b4a:	01 c0                	add    %eax,%eax
  801b4c:	01 d0                	add    %edx,%eax
  801b4e:	c1 e0 02             	shl    $0x2,%eax
  801b51:	05 44 10 81 00       	add    $0x811044,%eax
  801b56:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801b5c:	e9 c3 00 00 00       	jmp    801c24 <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  801b61:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b64:	89 d0                	mov    %edx,%eax
  801b66:	01 c0                	add    %eax,%eax
  801b68:	01 d0                	add    %edx,%eax
  801b6a:	c1 e0 02             	shl    $0x2,%eax
  801b6d:	05 40 10 81 00       	add    $0x811040,%eax
  801b72:	8b 08                	mov    (%eax),%ecx
  801b74:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b77:	89 d0                	mov    %edx,%eax
  801b79:	01 c0                	add    %eax,%eax
  801b7b:	01 d0                	add    %edx,%eax
  801b7d:	c1 e0 02             	shl    $0x2,%eax
  801b80:	05 44 10 81 00       	add    $0x811044,%eax
  801b85:	8b 00                	mov    (%eax),%eax
  801b87:	01 c1                	add    %eax,%ecx
  801b89:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b8c:	89 d0                	mov    %edx,%eax
  801b8e:	01 c0                	add    %eax,%eax
  801b90:	01 d0                	add    %edx,%eax
  801b92:	c1 e0 02             	shl    $0x2,%eax
  801b95:	05 40 10 81 00       	add    $0x811040,%eax
  801b9a:	8b 00                	mov    (%eax),%eax
  801b9c:	39 c1                	cmp    %eax,%ecx
  801b9e:	0f 85 80 00 00 00    	jne    801c24 <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801ba4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ba7:	89 d0                	mov    %edx,%eax
  801ba9:	01 c0                	add    %eax,%eax
  801bab:	01 d0                	add    %edx,%eax
  801bad:	c1 e0 02             	shl    $0x2,%eax
  801bb0:	05 44 10 81 00       	add    $0x811044,%eax
  801bb5:	8b 08                	mov    (%eax),%ecx
  801bb7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bba:	89 d0                	mov    %edx,%eax
  801bbc:	01 c0                	add    %eax,%eax
  801bbe:	01 d0                	add    %edx,%eax
  801bc0:	c1 e0 02             	shl    $0x2,%eax
  801bc3:	05 44 10 81 00       	add    $0x811044,%eax
  801bc8:	8b 00                	mov    (%eax),%eax
  801bca:	01 c1                	add    %eax,%ecx
  801bcc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801bcf:	89 d0                	mov    %edx,%eax
  801bd1:	01 c0                	add    %eax,%eax
  801bd3:	01 d0                	add    %edx,%eax
  801bd5:	c1 e0 02             	shl    $0x2,%eax
  801bd8:	05 44 10 81 00       	add    $0x811044,%eax
  801bdd:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801bdf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801be2:	89 d0                	mov    %edx,%eax
  801be4:	01 c0                	add    %eax,%eax
  801be6:	01 d0                	add    %edx,%eax
  801be8:	c1 e0 02             	shl    $0x2,%eax
  801beb:	05 48 10 81 00       	add    $0x811048,%eax
  801bf0:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801bf3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bf6:	89 d0                	mov    %edx,%eax
  801bf8:	01 c0                	add    %eax,%eax
  801bfa:	01 d0                	add    %edx,%eax
  801bfc:	c1 e0 02             	shl    $0x2,%eax
  801bff:	05 40 10 81 00       	add    $0x811040,%eax
  801c04:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801c0a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c0d:	89 d0                	mov    %edx,%eax
  801c0f:	01 c0                	add    %eax,%eax
  801c11:	01 d0                	add    %edx,%eax
  801c13:	c1 e0 02             	shl    $0x2,%eax
  801c16:	05 44 10 81 00       	add    $0x811044,%eax
  801c1b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c21:	eb 01                	jmp    801c24 <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  801c23:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801c24:	ff 45 e0             	incl   -0x20(%ebp)
  801c27:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801c2e:	0f 8e 1b fe ff ff    	jle    801a4f <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  801c34:	a1 30 51 83 00       	mov    0x835130,%eax
  801c39:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801c3c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801c43:	eb 53                	jmp    801c98 <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  801c45:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801c48:	89 d0                	mov    %edx,%eax
  801c4a:	01 c0                	add    %eax,%eax
  801c4c:	01 d0                	add    %edx,%eax
  801c4e:	c1 e0 02             	shl    $0x2,%eax
  801c51:	05 48 50 80 00       	add    $0x805048,%eax
  801c56:	8a 00                	mov    (%eax),%al
  801c58:	84 c0                	test   %al,%al
  801c5a:	74 39                	je     801c95 <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  801c5c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801c5f:	89 d0                	mov    %edx,%eax
  801c61:	01 c0                	add    %eax,%eax
  801c63:	01 d0                	add    %edx,%eax
  801c65:	c1 e0 02             	shl    $0x2,%eax
  801c68:	05 40 50 80 00       	add    $0x805040,%eax
  801c6d:	8b 08                	mov    (%eax),%ecx
  801c6f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801c72:	89 d0                	mov    %edx,%eax
  801c74:	01 c0                	add    %eax,%eax
  801c76:	01 d0                	add    %edx,%eax
  801c78:	c1 e0 02             	shl    $0x2,%eax
  801c7b:	05 44 50 80 00       	add    $0x805044,%eax
  801c80:	8b 00                	mov    (%eax),%eax
  801c82:	01 c8                	add    %ecx,%eax
  801c84:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  801c87:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801c8a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801c8d:	76 06                	jbe    801c95 <free+0x3e3>
  801c8f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801c92:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801c95:	ff 45 d8             	incl   -0x28(%ebp)
  801c98:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  801c9f:	7e a4                	jle    801c45 <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  801ca1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ca4:	a3 88 50 83 00       	mov    %eax,0x835088

    sys_free_user_mem(va, size);
  801ca9:	83 ec 08             	sub    $0x8,%esp
  801cac:	ff 75 f4             	pushl  -0xc(%ebp)
  801caf:	ff 75 d4             	pushl  -0x2c(%ebp)
  801cb2:	e8 79 15 00 00       	call   803230 <sys_free_user_mem>
  801cb7:	83 c4 10             	add    $0x10,%esp
  801cba:	eb 01                	jmp    801cbd <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  801cbc:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  801cbd:	c9                   	leave  
  801cbe:	c3                   	ret    

00801cbf <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801cbf:	55                   	push   %ebp
  801cc0:	89 e5                	mov    %esp,%ebp
  801cc2:	83 ec 68             	sub    $0x68,%esp
  801cc5:	8b 45 10             	mov    0x10(%ebp),%eax
  801cc8:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801ccb:	e8 a5 f7 ff ff       	call   801475 <uheap_init>
	if (size == 0) return NULL ;
  801cd0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801cd4:	75 0a                	jne    801ce0 <smalloc+0x21>
  801cd6:	b8 00 00 00 00       	mov    $0x0,%eax
  801cdb:	e9 37 03 00 00       	jmp    802017 <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801ce0:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801ce7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ced:	01 d0                	add    %edx,%eax
  801cef:	48                   	dec    %eax
  801cf0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801cf3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801cf6:	ba 00 00 00 00       	mov    $0x0,%edx
  801cfb:	f7 75 dc             	divl   -0x24(%ebp)
  801cfe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d01:	29 d0                	sub    %edx,%eax
  801d03:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  801d06:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801d0d:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801d14:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801d1b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801d22:	e9 85 00 00 00       	jmp    801dac <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801d27:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d2a:	89 d0                	mov    %edx,%eax
  801d2c:	01 c0                	add    %eax,%eax
  801d2e:	01 d0                	add    %edx,%eax
  801d30:	c1 e0 02             	shl    $0x2,%eax
  801d33:	05 48 10 81 00       	add    $0x811048,%eax
  801d38:	8a 00                	mov    (%eax),%al
  801d3a:	84 c0                	test   %al,%al
  801d3c:	74 20                	je     801d5e <smalloc+0x9f>
  801d3e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d41:	89 d0                	mov    %edx,%eax
  801d43:	01 c0                	add    %eax,%eax
  801d45:	01 d0                	add    %edx,%eax
  801d47:	c1 e0 02             	shl    $0x2,%eax
  801d4a:	05 44 10 81 00       	add    $0x811044,%eax
  801d4f:	8b 00                	mov    (%eax),%eax
  801d51:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801d54:	75 08                	jne    801d5e <smalloc+0x9f>
        {
            exactIdx = i;
  801d56:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d59:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801d5c:	eb 5b                	jmp    801db9 <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801d5e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d61:	89 d0                	mov    %edx,%eax
  801d63:	01 c0                	add    %eax,%eax
  801d65:	01 d0                	add    %edx,%eax
  801d67:	c1 e0 02             	shl    $0x2,%eax
  801d6a:	05 48 10 81 00       	add    $0x811048,%eax
  801d6f:	8a 00                	mov    (%eax),%al
  801d71:	84 c0                	test   %al,%al
  801d73:	74 34                	je     801da9 <smalloc+0xea>
  801d75:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d78:	89 d0                	mov    %edx,%eax
  801d7a:	01 c0                	add    %eax,%eax
  801d7c:	01 d0                	add    %edx,%eax
  801d7e:	c1 e0 02             	shl    $0x2,%eax
  801d81:	05 44 10 81 00       	add    $0x811044,%eax
  801d86:	8b 00                	mov    (%eax),%eax
  801d88:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801d8b:	76 1c                	jbe    801da9 <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  801d8d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d90:	89 d0                	mov    %edx,%eax
  801d92:	01 c0                	add    %eax,%eax
  801d94:	01 d0                	add    %edx,%eax
  801d96:	c1 e0 02             	shl    $0x2,%eax
  801d99:	05 44 10 81 00       	add    $0x811044,%eax
  801d9e:	8b 00                	mov    (%eax),%eax
  801da0:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801da3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801da6:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801da9:	ff 45 e8             	incl   -0x18(%ebp)
  801dac:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801db3:	0f 8e 6e ff ff ff    	jle    801d27 <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  801db9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801dc0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801dc4:	74 7d                	je     801e43 <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801dc6:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801dcd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dd0:	89 d0                	mov    %edx,%eax
  801dd2:	01 c0                	add    %eax,%eax
  801dd4:	01 d0                	add    %edx,%eax
  801dd6:	c1 e0 02             	shl    $0x2,%eax
  801dd9:	05 40 10 81 00       	add    $0x811040,%eax
  801dde:	8b 10                	mov    (%eax),%edx
  801de0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801de3:	01 d0                	add    %edx,%eax
  801de5:	48                   	dec    %eax
  801de6:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801de9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801dec:	ba 00 00 00 00       	mov    $0x0,%edx
  801df1:	f7 75 bc             	divl   -0x44(%ebp)
  801df4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801df7:	29 d0                	sub    %edx,%eax
  801df9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801dfc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dff:	89 d0                	mov    %edx,%eax
  801e01:	01 c0                	add    %eax,%eax
  801e03:	01 d0                	add    %edx,%eax
  801e05:	c1 e0 02             	shl    $0x2,%eax
  801e08:	05 48 10 81 00       	add    $0x811048,%eax
  801e0d:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801e10:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e13:	89 d0                	mov    %edx,%eax
  801e15:	01 c0                	add    %eax,%eax
  801e17:	01 d0                	add    %edx,%eax
  801e19:	c1 e0 02             	shl    $0x2,%eax
  801e1c:	05 44 10 81 00       	add    $0x811044,%eax
  801e21:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801e27:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e2a:	89 d0                	mov    %edx,%eax
  801e2c:	01 c0                	add    %eax,%eax
  801e2e:	01 d0                	add    %edx,%eax
  801e30:	c1 e0 02             	shl    $0x2,%eax
  801e33:	05 40 10 81 00       	add    $0x811040,%eax
  801e38:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e3e:	e9 2d 01 00 00       	jmp    801f70 <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  801e43:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801e47:	0f 84 ce 00 00 00    	je     801f1b <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  801e4d:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  801e54:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e57:	89 d0                	mov    %edx,%eax
  801e59:	01 c0                	add    %eax,%eax
  801e5b:	01 d0                	add    %edx,%eax
  801e5d:	c1 e0 02             	shl    $0x2,%eax
  801e60:	05 40 10 81 00       	add    $0x811040,%eax
  801e65:	8b 10                	mov    (%eax),%edx
  801e67:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801e6a:	01 d0                	add    %edx,%eax
  801e6c:	48                   	dec    %eax
  801e6d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  801e70:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801e73:	ba 00 00 00 00       	mov    $0x0,%edx
  801e78:	f7 75 c4             	divl   -0x3c(%ebp)
  801e7b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801e7e:	29 d0                	sub    %edx,%eax
  801e80:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  801e83:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e86:	89 d0                	mov    %edx,%eax
  801e88:	01 c0                	add    %eax,%eax
  801e8a:	01 d0                	add    %edx,%eax
  801e8c:	c1 e0 02             	shl    $0x2,%eax
  801e8f:	05 44 10 81 00       	add    $0x811044,%eax
  801e94:	8b 00                	mov    (%eax),%eax
  801e96:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801e99:	75 47                	jne    801ee2 <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  801e9b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e9e:	89 d0                	mov    %edx,%eax
  801ea0:	01 c0                	add    %eax,%eax
  801ea2:	01 d0                	add    %edx,%eax
  801ea4:	c1 e0 02             	shl    $0x2,%eax
  801ea7:	05 48 10 81 00       	add    $0x811048,%eax
  801eac:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  801eaf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801eb2:	89 d0                	mov    %edx,%eax
  801eb4:	01 c0                	add    %eax,%eax
  801eb6:	01 d0                	add    %edx,%eax
  801eb8:	c1 e0 02             	shl    $0x2,%eax
  801ebb:	05 44 10 81 00       	add    $0x811044,%eax
  801ec0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  801ec6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ec9:	89 d0                	mov    %edx,%eax
  801ecb:	01 c0                	add    %eax,%eax
  801ecd:	01 d0                	add    %edx,%eax
  801ecf:	c1 e0 02             	shl    $0x2,%eax
  801ed2:	05 40 10 81 00       	add    $0x811040,%eax
  801ed7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801edd:	e9 8e 00 00 00       	jmp    801f70 <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  801ee2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801ee5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ee8:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801eeb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801eee:	89 d0                	mov    %edx,%eax
  801ef0:	01 c0                	add    %eax,%eax
  801ef2:	01 d0                	add    %edx,%eax
  801ef4:	c1 e0 02             	shl    $0x2,%eax
  801ef7:	05 40 10 81 00       	add    $0x811040,%eax
  801efc:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  801efe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f01:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801f04:	89 c2                	mov    %eax,%edx
  801f06:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801f09:	89 c8                	mov    %ecx,%eax
  801f0b:	01 c0                	add    %eax,%eax
  801f0d:	01 c8                	add    %ecx,%eax
  801f0f:	c1 e0 02             	shl    $0x2,%eax
  801f12:	05 44 10 81 00       	add    $0x811044,%eax
  801f17:	89 10                	mov    %edx,(%eax)
  801f19:	eb 55                	jmp    801f70 <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  801f1b:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801f22:	8b 15 88 50 83 00    	mov    0x835088,%edx
  801f28:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f2b:	01 d0                	add    %edx,%eax
  801f2d:	48                   	dec    %eax
  801f2e:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801f31:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801f34:	ba 00 00 00 00       	mov    $0x0,%edx
  801f39:	f7 75 d0             	divl   -0x30(%ebp)
  801f3c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801f3f:	29 d0                	sub    %edx,%eax
  801f41:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  801f44:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801f47:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f4a:	01 d0                	add    %edx,%eax
  801f4c:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801f51:	76 0a                	jbe    801f5d <smalloc+0x29e>
            return NULL;
  801f53:	b8 00 00 00 00       	mov    $0x0,%eax
  801f58:	e9 ba 00 00 00       	jmp    802017 <smalloc+0x358>
        va = start;
  801f5d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801f60:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  801f63:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801f66:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f69:	01 d0                	add    %edx,%eax
  801f6b:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801f70:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801f77:	eb 5e                	jmp    801fd7 <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  801f79:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f7c:	89 d0                	mov    %edx,%eax
  801f7e:	01 c0                	add    %eax,%eax
  801f80:	01 d0                	add    %edx,%eax
  801f82:	c1 e0 02             	shl    $0x2,%eax
  801f85:	05 48 50 80 00       	add    $0x805048,%eax
  801f8a:	8a 00                	mov    (%eax),%al
  801f8c:	84 c0                	test   %al,%al
  801f8e:	75 44                	jne    801fd4 <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  801f90:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f93:	89 d0                	mov    %edx,%eax
  801f95:	01 c0                	add    %eax,%eax
  801f97:	01 d0                	add    %edx,%eax
  801f99:	c1 e0 02             	shl    $0x2,%eax
  801f9c:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  801fa2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fa5:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  801fa7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801faa:	89 d0                	mov    %edx,%eax
  801fac:	01 c0                	add    %eax,%eax
  801fae:	01 d0                	add    %edx,%eax
  801fb0:	c1 e0 02             	shl    $0x2,%eax
  801fb3:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  801fb9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fbc:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  801fbe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801fc1:	89 d0                	mov    %edx,%eax
  801fc3:	01 c0                	add    %eax,%eax
  801fc5:	01 d0                	add    %edx,%eax
  801fc7:	c1 e0 02             	shl    $0x2,%eax
  801fca:	05 48 50 80 00       	add    $0x805048,%eax
  801fcf:	c6 00 01             	movb   $0x1,(%eax)
            break;
  801fd2:	eb 0c                	jmp    801fe0 <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801fd4:	ff 45 e0             	incl   -0x20(%ebp)
  801fd7:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801fde:	7e 99                	jle    801f79 <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  801fe0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801fe3:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  801fe7:	52                   	push   %edx
  801fe8:	50                   	push   %eax
  801fe9:	ff 75 d4             	pushl  -0x2c(%ebp)
  801fec:	ff 75 08             	pushl  0x8(%ebp)
  801fef:	e8 de 0e 00 00       	call   802ed2 <sys_create_shared_object>
  801ff4:	83 c4 10             	add    $0x10,%esp
  801ff7:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  801ffa:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  801ffe:	75 07                	jne    802007 <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  802000:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802005:	eb 10                	jmp    802017 <smalloc+0x358>
    if (r < 0)
  802007:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  80200b:	79 07                	jns    802014 <smalloc+0x355>
        return NULL;
  80200d:	b8 00 00 00 00       	mov    $0x0,%eax
  802012:	eb 03                	jmp    802017 <smalloc+0x358>
    return (void*)va;
  802014:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  802017:	c9                   	leave  
  802018:	c3                   	ret    

00802019 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802019:	55                   	push   %ebp
  80201a:	89 e5                	mov    %esp,%ebp
  80201c:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80201f:	e8 51 f4 ff ff       	call   801475 <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  802024:	83 ec 08             	sub    $0x8,%esp
  802027:	ff 75 0c             	pushl  0xc(%ebp)
  80202a:	ff 75 08             	pushl  0x8(%ebp)
  80202d:	e8 ca 0e 00 00       	call   802efc <sys_size_of_shared_object>
  802032:	83 c4 10             	add    $0x10,%esp
  802035:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  802038:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80203c:	7f 0a                	jg     802048 <sget+0x2f>
        return NULL;
  80203e:	b8 00 00 00 00       	mov    $0x0,%eax
  802043:	e9 28 03 00 00       	jmp    802370 <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  802048:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80204f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802052:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802055:	01 d0                	add    %edx,%eax
  802057:	48                   	dec    %eax
  802058:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80205b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80205e:	ba 00 00 00 00       	mov    $0x0,%edx
  802063:	f7 75 d8             	divl   -0x28(%ebp)
  802066:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802069:	29 d0                	sub    %edx,%eax
  80206b:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  80206e:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  802075:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  80207c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802083:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80208a:	e9 85 00 00 00       	jmp    802114 <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  80208f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802092:	89 d0                	mov    %edx,%eax
  802094:	01 c0                	add    %eax,%eax
  802096:	01 d0                	add    %edx,%eax
  802098:	c1 e0 02             	shl    $0x2,%eax
  80209b:	05 48 10 81 00       	add    $0x811048,%eax
  8020a0:	8a 00                	mov    (%eax),%al
  8020a2:	84 c0                	test   %al,%al
  8020a4:	74 20                	je     8020c6 <sget+0xad>
  8020a6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8020a9:	89 d0                	mov    %edx,%eax
  8020ab:	01 c0                	add    %eax,%eax
  8020ad:	01 d0                	add    %edx,%eax
  8020af:	c1 e0 02             	shl    $0x2,%eax
  8020b2:	05 44 10 81 00       	add    $0x811044,%eax
  8020b7:	8b 00                	mov    (%eax),%eax
  8020b9:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8020bc:	75 08                	jne    8020c6 <sget+0xad>
        {
            exactIdx = i;
  8020be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  8020c4:	eb 5b                	jmp    802121 <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  8020c6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8020c9:	89 d0                	mov    %edx,%eax
  8020cb:	01 c0                	add    %eax,%eax
  8020cd:	01 d0                	add    %edx,%eax
  8020cf:	c1 e0 02             	shl    $0x2,%eax
  8020d2:	05 48 10 81 00       	add    $0x811048,%eax
  8020d7:	8a 00                	mov    (%eax),%al
  8020d9:	84 c0                	test   %al,%al
  8020db:	74 34                	je     802111 <sget+0xf8>
  8020dd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8020e0:	89 d0                	mov    %edx,%eax
  8020e2:	01 c0                	add    %eax,%eax
  8020e4:	01 d0                	add    %edx,%eax
  8020e6:	c1 e0 02             	shl    $0x2,%eax
  8020e9:	05 44 10 81 00       	add    $0x811044,%eax
  8020ee:	8b 00                	mov    (%eax),%eax
  8020f0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8020f3:	76 1c                	jbe    802111 <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  8020f5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8020f8:	89 d0                	mov    %edx,%eax
  8020fa:	01 c0                	add    %eax,%eax
  8020fc:	01 d0                	add    %edx,%eax
  8020fe:	c1 e0 02             	shl    $0x2,%eax
  802101:	05 44 10 81 00       	add    $0x811044,%eax
  802106:	8b 00                	mov    (%eax),%eax
  802108:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  80210b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80210e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802111:	ff 45 e8             	incl   -0x18(%ebp)
  802114:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  80211b:	0f 8e 6e ff ff ff    	jle    80208f <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  802121:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  802128:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  80212c:	74 7d                	je     8021ab <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  80212e:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802135:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802138:	89 d0                	mov    %edx,%eax
  80213a:	01 c0                	add    %eax,%eax
  80213c:	01 d0                	add    %edx,%eax
  80213e:	c1 e0 02             	shl    $0x2,%eax
  802141:	05 40 10 81 00       	add    $0x811040,%eax
  802146:	8b 10                	mov    (%eax),%edx
  802148:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80214b:	01 d0                	add    %edx,%eax
  80214d:	48                   	dec    %eax
  80214e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802151:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802154:	ba 00 00 00 00       	mov    $0x0,%edx
  802159:	f7 75 b8             	divl   -0x48(%ebp)
  80215c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80215f:	29 d0                	sub    %edx,%eax
  802161:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  802164:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802167:	89 d0                	mov    %edx,%eax
  802169:	01 c0                	add    %eax,%eax
  80216b:	01 d0                	add    %edx,%eax
  80216d:	c1 e0 02             	shl    $0x2,%eax
  802170:	05 48 10 81 00       	add    $0x811048,%eax
  802175:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  802178:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80217b:	89 d0                	mov    %edx,%eax
  80217d:	01 c0                	add    %eax,%eax
  80217f:	01 d0                	add    %edx,%eax
  802181:	c1 e0 02             	shl    $0x2,%eax
  802184:	05 44 10 81 00       	add    $0x811044,%eax
  802189:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  80218f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802192:	89 d0                	mov    %edx,%eax
  802194:	01 c0                	add    %eax,%eax
  802196:	01 d0                	add    %edx,%eax
  802198:	c1 e0 02             	shl    $0x2,%eax
  80219b:	05 40 10 81 00       	add    $0x811040,%eax
  8021a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021a6:	e9 2d 01 00 00       	jmp    8022d8 <sget+0x2bf>
    }
    else if (worstIdx != -1)
  8021ab:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8021af:	0f 84 ce 00 00 00    	je     802283 <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  8021b5:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  8021bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021bf:	89 d0                	mov    %edx,%eax
  8021c1:	01 c0                	add    %eax,%eax
  8021c3:	01 d0                	add    %edx,%eax
  8021c5:	c1 e0 02             	shl    $0x2,%eax
  8021c8:	05 40 10 81 00       	add    $0x811040,%eax
  8021cd:	8b 10                	mov    (%eax),%edx
  8021cf:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8021d2:	01 d0                	add    %edx,%eax
  8021d4:	48                   	dec    %eax
  8021d5:	89 45 bc             	mov    %eax,-0x44(%ebp)
  8021d8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8021db:	ba 00 00 00 00       	mov    $0x0,%edx
  8021e0:	f7 75 c0             	divl   -0x40(%ebp)
  8021e3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8021e6:	29 d0                	sub    %edx,%eax
  8021e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  8021eb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021ee:	89 d0                	mov    %edx,%eax
  8021f0:	01 c0                	add    %eax,%eax
  8021f2:	01 d0                	add    %edx,%eax
  8021f4:	c1 e0 02             	shl    $0x2,%eax
  8021f7:	05 44 10 81 00       	add    $0x811044,%eax
  8021fc:	8b 00                	mov    (%eax),%eax
  8021fe:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802201:	75 47                	jne    80224a <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  802203:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802206:	89 d0                	mov    %edx,%eax
  802208:	01 c0                	add    %eax,%eax
  80220a:	01 d0                	add    %edx,%eax
  80220c:	c1 e0 02             	shl    $0x2,%eax
  80220f:	05 48 10 81 00       	add    $0x811048,%eax
  802214:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  802217:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80221a:	89 d0                	mov    %edx,%eax
  80221c:	01 c0                	add    %eax,%eax
  80221e:	01 d0                	add    %edx,%eax
  802220:	c1 e0 02             	shl    $0x2,%eax
  802223:	05 44 10 81 00       	add    $0x811044,%eax
  802228:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  80222e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802231:	89 d0                	mov    %edx,%eax
  802233:	01 c0                	add    %eax,%eax
  802235:	01 d0                	add    %edx,%eax
  802237:	c1 e0 02             	shl    $0x2,%eax
  80223a:	05 40 10 81 00       	add    $0x811040,%eax
  80223f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802245:	e9 8e 00 00 00       	jmp    8022d8 <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  80224a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80224d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802250:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802253:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802256:	89 d0                	mov    %edx,%eax
  802258:	01 c0                	add    %eax,%eax
  80225a:	01 d0                	add    %edx,%eax
  80225c:	c1 e0 02             	shl    $0x2,%eax
  80225f:	05 40 10 81 00       	add    $0x811040,%eax
  802264:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  802266:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802269:	2b 45 d0             	sub    -0x30(%ebp),%eax
  80226c:	89 c2                	mov    %eax,%edx
  80226e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802271:	89 c8                	mov    %ecx,%eax
  802273:	01 c0                	add    %eax,%eax
  802275:	01 c8                	add    %ecx,%eax
  802277:	c1 e0 02             	shl    $0x2,%eax
  80227a:	05 44 10 81 00       	add    $0x811044,%eax
  80227f:	89 10                	mov    %edx,(%eax)
  802281:	eb 55                	jmp    8022d8 <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  802283:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80228a:	8b 15 88 50 83 00    	mov    0x835088,%edx
  802290:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802293:	01 d0                	add    %edx,%eax
  802295:	48                   	dec    %eax
  802296:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802299:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80229c:	ba 00 00 00 00       	mov    $0x0,%edx
  8022a1:	f7 75 cc             	divl   -0x34(%ebp)
  8022a4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8022a7:	29 d0                	sub    %edx,%eax
  8022a9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  8022ac:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8022af:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8022b2:	01 d0                	add    %edx,%eax
  8022b4:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8022b9:	76 0a                	jbe    8022c5 <sget+0x2ac>
            return NULL;
  8022bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c0:	e9 ab 00 00 00       	jmp    802370 <sget+0x357>
        va = start;
  8022c5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8022c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  8022cb:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8022ce:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8022d1:	01 d0                	add    %edx,%eax
  8022d3:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8022d8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8022df:	eb 5e                	jmp    80233f <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  8022e1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022e4:	89 d0                	mov    %edx,%eax
  8022e6:	01 c0                	add    %eax,%eax
  8022e8:	01 d0                	add    %edx,%eax
  8022ea:	c1 e0 02             	shl    $0x2,%eax
  8022ed:	05 48 50 80 00       	add    $0x805048,%eax
  8022f2:	8a 00                	mov    (%eax),%al
  8022f4:	84 c0                	test   %al,%al
  8022f6:	75 44                	jne    80233c <sget+0x323>
        {
            uhp_allocs[i].va = va;
  8022f8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022fb:	89 d0                	mov    %edx,%eax
  8022fd:	01 c0                	add    %eax,%eax
  8022ff:	01 d0                	add    %edx,%eax
  802301:	c1 e0 02             	shl    $0x2,%eax
  802304:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  80230a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80230d:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  80230f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802312:	89 d0                	mov    %edx,%eax
  802314:	01 c0                	add    %eax,%eax
  802316:	01 d0                	add    %edx,%eax
  802318:	c1 e0 02             	shl    $0x2,%eax
  80231b:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802321:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802324:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  802326:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802329:	89 d0                	mov    %edx,%eax
  80232b:	01 c0                	add    %eax,%eax
  80232d:	01 d0                	add    %edx,%eax
  80232f:	c1 e0 02             	shl    $0x2,%eax
  802332:	05 48 50 80 00       	add    $0x805048,%eax
  802337:	c6 00 01             	movb   $0x1,(%eax)
            break;
  80233a:	eb 0c                	jmp    802348 <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80233c:	ff 45 e0             	incl   -0x20(%ebp)
  80233f:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802346:	7e 99                	jle    8022e1 <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  802348:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80234b:	83 ec 04             	sub    $0x4,%esp
  80234e:	50                   	push   %eax
  80234f:	ff 75 0c             	pushl  0xc(%ebp)
  802352:	ff 75 08             	pushl  0x8(%ebp)
  802355:	e8 bf 0b 00 00       	call   802f19 <sys_get_shared_object>
  80235a:	83 c4 10             	add    $0x10,%esp
  80235d:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  802360:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802364:	79 07                	jns    80236d <sget+0x354>
        return NULL;
  802366:	b8 00 00 00 00       	mov    $0x0,%eax
  80236b:	eb 03                	jmp    802370 <sget+0x357>
    return (void*)va;
  80236d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  802370:	c9                   	leave  
  802371:	c3                   	ret    

00802372 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802372:	55                   	push   %ebp
  802373:	89 e5                	mov    %esp,%ebp
  802375:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802378:	e8 f8 f0 ff ff       	call   801475 <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  80237d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802381:	75 13                	jne    802396 <realloc+0x24>
		return malloc(new_size);
  802383:	83 ec 0c             	sub    $0xc,%esp
  802386:	ff 75 0c             	pushl  0xc(%ebp)
  802389:	e8 c4 f1 ff ff       	call   801552 <malloc>
  80238e:	83 c4 10             	add    $0x10,%esp
  802391:	e9 f4 05 00 00       	jmp    80298a <realloc+0x618>
	if (new_size == 0)
  802396:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80239a:	75 18                	jne    8023b4 <realloc+0x42>
	{
		free(virtual_address);
  80239c:	83 ec 0c             	sub    $0xc,%esp
  80239f:	ff 75 08             	pushl  0x8(%ebp)
  8023a2:	e8 0b f5 ff ff       	call   8018b2 <free>
  8023a7:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8023aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8023af:	e9 d6 05 00 00       	jmp    80298a <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  8023b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b7:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  8023ba:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8023bd:	85 c0                	test   %eax,%eax
  8023bf:	79 74                	jns    802435 <realloc+0xc3>
  8023c1:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  8023c8:	77 6b                	ja     802435 <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  8023ca:	83 ec 0c             	sub    $0xc,%esp
  8023cd:	ff 75 0c             	pushl  0xc(%ebp)
  8023d0:	e8 7d f1 ff ff       	call   801552 <malloc>
  8023d5:	83 c4 10             	add    $0x10,%esp
  8023d8:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  8023db:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8023df:	75 0a                	jne    8023eb <realloc+0x79>
			return NULL;
  8023e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e6:	e9 9f 05 00 00       	jmp    80298a <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  8023eb:	83 ec 0c             	sub    $0xc,%esp
  8023ee:	ff 75 08             	pushl  0x8(%ebp)
  8023f1:	e8 e0 11 00 00       	call   8035d6 <get_block_size>
  8023f6:	83 c4 10             	add    $0x10,%esp
  8023f9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  8023fc:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8023ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  802402:	39 d0                	cmp    %edx,%eax
  802404:	76 02                	jbe    802408 <realloc+0x96>
  802406:	89 d0                	mov    %edx,%eax
  802408:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  80240b:	83 ec 04             	sub    $0x4,%esp
  80240e:	ff 75 c0             	pushl  -0x40(%ebp)
  802411:	ff 75 08             	pushl  0x8(%ebp)
  802414:	ff 75 c8             	pushl  -0x38(%ebp)
  802417:	e8 56 eb ff ff       	call   800f72 <memmove>
  80241c:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  80241f:	83 ec 0c             	sub    $0xc,%esp
  802422:	ff 75 08             	pushl  0x8(%ebp)
  802425:	e8 88 f4 ff ff       	call   8018b2 <free>
  80242a:	83 c4 10             	add    $0x10,%esp
		return newptr;
  80242d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802430:	e9 55 05 00 00       	jmp    80298a <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  802435:	a1 30 51 83 00       	mov    0x835130,%eax
  80243a:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  80243d:	72 09                	jb     802448 <realloc+0xd6>
  80243f:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  802446:	76 0a                	jbe    802452 <realloc+0xe0>
		return NULL;
  802448:	b8 00 00 00 00       	mov    $0x0,%eax
  80244d:	e9 38 05 00 00       	jmp    80298a <realloc+0x618>
	uint32 oldsz = 0;
  802452:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  802459:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802460:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802467:	eb 50                	jmp    8024b9 <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802469:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80246c:	89 d0                	mov    %edx,%eax
  80246e:	01 c0                	add    %eax,%eax
  802470:	01 d0                	add    %edx,%eax
  802472:	c1 e0 02             	shl    $0x2,%eax
  802475:	05 48 50 80 00       	add    $0x805048,%eax
  80247a:	8a 00                	mov    (%eax),%al
  80247c:	84 c0                	test   %al,%al
  80247e:	74 36                	je     8024b6 <realloc+0x144>
  802480:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802483:	89 d0                	mov    %edx,%eax
  802485:	01 c0                	add    %eax,%eax
  802487:	01 d0                	add    %edx,%eax
  802489:	c1 e0 02             	shl    $0x2,%eax
  80248c:	05 40 50 80 00       	add    $0x805040,%eax
  802491:	8b 00                	mov    (%eax),%eax
  802493:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  802496:	75 1e                	jne    8024b6 <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  802498:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80249b:	89 d0                	mov    %edx,%eax
  80249d:	01 c0                	add    %eax,%eax
  80249f:	01 d0                	add    %edx,%eax
  8024a1:	c1 e0 02             	shl    $0x2,%eax
  8024a4:	05 44 50 80 00       	add    $0x805044,%eax
  8024a9:	8b 00                	mov    (%eax),%eax
  8024ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  8024ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  8024b4:	eb 0c                	jmp    8024c2 <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8024b6:	ff 45 ec             	incl   -0x14(%ebp)
  8024b9:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  8024c0:	7e a7                	jle    802469 <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  8024c2:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8024c6:	75 0a                	jne    8024d2 <realloc+0x160>
		return NULL;
  8024c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8024cd:	e9 b8 04 00 00       	jmp    80298a <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  8024d2:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  8024d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024dc:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8024df:	01 d0                	add    %edx,%eax
  8024e1:	48                   	dec    %eax
  8024e2:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8024e5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8024e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8024ed:	f7 75 bc             	divl   -0x44(%ebp)
  8024f0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8024f3:	29 d0                	sub    %edx,%eax
  8024f5:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  8024f8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8024fb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8024fe:	75 08                	jne    802508 <realloc+0x196>
		return virtual_address;
  802500:	8b 45 08             	mov    0x8(%ebp),%eax
  802503:	e9 82 04 00 00       	jmp    80298a <realloc+0x618>
	if (req < oldsz)
  802508:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80250b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80250e:	0f 83 cd 02 00 00    	jae    8027e1 <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  802514:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802517:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  80251a:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  80251d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802520:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802523:	01 d0                	add    %edx,%eax
  802525:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  802528:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80252b:	89 d0                	mov    %edx,%eax
  80252d:	01 c0                	add    %eax,%eax
  80252f:	01 d0                	add    %edx,%eax
  802531:	c1 e0 02             	shl    $0x2,%eax
  802534:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  80253a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80253d:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  80253f:	83 ec 08             	sub    $0x8,%esp
  802542:	ff 75 b0             	pushl  -0x50(%ebp)
  802545:	ff 75 ac             	pushl  -0x54(%ebp)
  802548:	e8 e3 0c 00 00       	call   803230 <sys_free_user_mem>
  80254d:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  802550:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802557:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80255e:	eb 64                	jmp    8025c4 <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  802560:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802563:	89 d0                	mov    %edx,%eax
  802565:	01 c0                	add    %eax,%eax
  802567:	01 d0                	add    %edx,%eax
  802569:	c1 e0 02             	shl    $0x2,%eax
  80256c:	05 48 10 81 00       	add    $0x811048,%eax
  802571:	8a 00                	mov    (%eax),%al
  802573:	84 c0                	test   %al,%al
  802575:	75 4a                	jne    8025c1 <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  802577:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80257a:	89 d0                	mov    %edx,%eax
  80257c:	01 c0                	add    %eax,%eax
  80257e:	01 d0                	add    %edx,%eax
  802580:	c1 e0 02             	shl    $0x2,%eax
  802583:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  802589:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80258c:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  80258e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802591:	89 d0                	mov    %edx,%eax
  802593:	01 c0                	add    %eax,%eax
  802595:	01 d0                	add    %edx,%eax
  802597:	c1 e0 02             	shl    $0x2,%eax
  80259a:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  8025a0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025a3:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  8025a5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025a8:	89 d0                	mov    %edx,%eax
  8025aa:	01 c0                	add    %eax,%eax
  8025ac:	01 d0                	add    %edx,%eax
  8025ae:	c1 e0 02             	shl    $0x2,%eax
  8025b1:	05 48 10 81 00       	add    $0x811048,%eax
  8025b6:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  8025b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025bc:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  8025bf:	eb 0c                	jmp    8025cd <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8025c1:	ff 45 e4             	incl   -0x1c(%ebp)
  8025c4:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  8025cb:	7e 93                	jle    802560 <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  8025cd:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  8025d1:	0f 84 8d 01 00 00    	je     802764 <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  8025d7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8025de:	e9 74 01 00 00       	jmp    802757 <realloc+0x3e5>
			{
				if (k == fidx) continue;
  8025e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025e6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8025e9:	0f 84 64 01 00 00    	je     802753 <realloc+0x3e1>
				if (uhp_frees[k].free)
  8025ef:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8025f2:	89 d0                	mov    %edx,%eax
  8025f4:	01 c0                	add    %eax,%eax
  8025f6:	01 d0                	add    %edx,%eax
  8025f8:	c1 e0 02             	shl    $0x2,%eax
  8025fb:	05 48 10 81 00       	add    $0x811048,%eax
  802600:	8a 00                	mov    (%eax),%al
  802602:	84 c0                	test   %al,%al
  802604:	0f 84 4a 01 00 00    	je     802754 <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  80260a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80260d:	89 d0                	mov    %edx,%eax
  80260f:	01 c0                	add    %eax,%eax
  802611:	01 d0                	add    %edx,%eax
  802613:	c1 e0 02             	shl    $0x2,%eax
  802616:	05 40 10 81 00       	add    $0x811040,%eax
  80261b:	8b 08                	mov    (%eax),%ecx
  80261d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802620:	89 d0                	mov    %edx,%eax
  802622:	01 c0                	add    %eax,%eax
  802624:	01 d0                	add    %edx,%eax
  802626:	c1 e0 02             	shl    $0x2,%eax
  802629:	05 44 10 81 00       	add    $0x811044,%eax
  80262e:	8b 00                	mov    (%eax),%eax
  802630:	01 c1                	add    %eax,%ecx
  802632:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802635:	89 d0                	mov    %edx,%eax
  802637:	01 c0                	add    %eax,%eax
  802639:	01 d0                	add    %edx,%eax
  80263b:	c1 e0 02             	shl    $0x2,%eax
  80263e:	05 40 10 81 00       	add    $0x811040,%eax
  802643:	8b 00                	mov    (%eax),%eax
  802645:	39 c1                	cmp    %eax,%ecx
  802647:	75 7a                	jne    8026c3 <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  802649:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80264c:	89 d0                	mov    %edx,%eax
  80264e:	01 c0                	add    %eax,%eax
  802650:	01 d0                	add    %edx,%eax
  802652:	c1 e0 02             	shl    $0x2,%eax
  802655:	05 40 10 81 00       	add    $0x811040,%eax
  80265a:	8b 10                	mov    (%eax),%edx
  80265c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  80265f:	89 c8                	mov    %ecx,%eax
  802661:	01 c0                	add    %eax,%eax
  802663:	01 c8                	add    %ecx,%eax
  802665:	c1 e0 02             	shl    $0x2,%eax
  802668:	05 40 10 81 00       	add    $0x811040,%eax
  80266d:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  80266f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802672:	89 d0                	mov    %edx,%eax
  802674:	01 c0                	add    %eax,%eax
  802676:	01 d0                	add    %edx,%eax
  802678:	c1 e0 02             	shl    $0x2,%eax
  80267b:	05 44 10 81 00       	add    $0x811044,%eax
  802680:	8b 08                	mov    (%eax),%ecx
  802682:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802685:	89 d0                	mov    %edx,%eax
  802687:	01 c0                	add    %eax,%eax
  802689:	01 d0                	add    %edx,%eax
  80268b:	c1 e0 02             	shl    $0x2,%eax
  80268e:	05 44 10 81 00       	add    $0x811044,%eax
  802693:	8b 00                	mov    (%eax),%eax
  802695:	01 c1                	add    %eax,%ecx
  802697:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80269a:	89 d0                	mov    %edx,%eax
  80269c:	01 c0                	add    %eax,%eax
  80269e:	01 d0                	add    %edx,%eax
  8026a0:	c1 e0 02             	shl    $0x2,%eax
  8026a3:	05 44 10 81 00       	add    $0x811044,%eax
  8026a8:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  8026aa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026ad:	89 d0                	mov    %edx,%eax
  8026af:	01 c0                	add    %eax,%eax
  8026b1:	01 d0                	add    %edx,%eax
  8026b3:	c1 e0 02             	shl    $0x2,%eax
  8026b6:	05 48 10 81 00       	add    $0x811048,%eax
  8026bb:	c6 00 00             	movb   $0x0,(%eax)
  8026be:	e9 91 00 00 00       	jmp    802754 <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  8026c3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026c6:	89 d0                	mov    %edx,%eax
  8026c8:	01 c0                	add    %eax,%eax
  8026ca:	01 d0                	add    %edx,%eax
  8026cc:	c1 e0 02             	shl    $0x2,%eax
  8026cf:	05 40 10 81 00       	add    $0x811040,%eax
  8026d4:	8b 08                	mov    (%eax),%ecx
  8026d6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026d9:	89 d0                	mov    %edx,%eax
  8026db:	01 c0                	add    %eax,%eax
  8026dd:	01 d0                	add    %edx,%eax
  8026df:	c1 e0 02             	shl    $0x2,%eax
  8026e2:	05 44 10 81 00       	add    $0x811044,%eax
  8026e7:	8b 00                	mov    (%eax),%eax
  8026e9:	01 c1                	add    %eax,%ecx
  8026eb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026ee:	89 d0                	mov    %edx,%eax
  8026f0:	01 c0                	add    %eax,%eax
  8026f2:	01 d0                	add    %edx,%eax
  8026f4:	c1 e0 02             	shl    $0x2,%eax
  8026f7:	05 40 10 81 00       	add    $0x811040,%eax
  8026fc:	8b 00                	mov    (%eax),%eax
  8026fe:	39 c1                	cmp    %eax,%ecx
  802700:	75 52                	jne    802754 <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  802702:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802705:	89 d0                	mov    %edx,%eax
  802707:	01 c0                	add    %eax,%eax
  802709:	01 d0                	add    %edx,%eax
  80270b:	c1 e0 02             	shl    $0x2,%eax
  80270e:	05 44 10 81 00       	add    $0x811044,%eax
  802713:	8b 08                	mov    (%eax),%ecx
  802715:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802718:	89 d0                	mov    %edx,%eax
  80271a:	01 c0                	add    %eax,%eax
  80271c:	01 d0                	add    %edx,%eax
  80271e:	c1 e0 02             	shl    $0x2,%eax
  802721:	05 44 10 81 00       	add    $0x811044,%eax
  802726:	8b 00                	mov    (%eax),%eax
  802728:	01 c1                	add    %eax,%ecx
  80272a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80272d:	89 d0                	mov    %edx,%eax
  80272f:	01 c0                	add    %eax,%eax
  802731:	01 d0                	add    %edx,%eax
  802733:	c1 e0 02             	shl    $0x2,%eax
  802736:	05 44 10 81 00       	add    $0x811044,%eax
  80273b:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  80273d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802740:	89 d0                	mov    %edx,%eax
  802742:	01 c0                	add    %eax,%eax
  802744:	01 d0                	add    %edx,%eax
  802746:	c1 e0 02             	shl    $0x2,%eax
  802749:	05 48 10 81 00       	add    $0x811048,%eax
  80274e:	c6 00 00             	movb   $0x0,(%eax)
  802751:	eb 01                	jmp    802754 <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  802753:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802754:	ff 45 e0             	incl   -0x20(%ebp)
  802757:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80275e:	0f 8e 7f fe ff ff    	jle    8025e3 <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  802764:	a1 30 51 83 00       	mov    0x835130,%eax
  802769:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  80276c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  802773:	eb 53                	jmp    8027c8 <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  802775:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802778:	89 d0                	mov    %edx,%eax
  80277a:	01 c0                	add    %eax,%eax
  80277c:	01 d0                	add    %edx,%eax
  80277e:	c1 e0 02             	shl    $0x2,%eax
  802781:	05 48 50 80 00       	add    $0x805048,%eax
  802786:	8a 00                	mov    (%eax),%al
  802788:	84 c0                	test   %al,%al
  80278a:	74 39                	je     8027c5 <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  80278c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80278f:	89 d0                	mov    %edx,%eax
  802791:	01 c0                	add    %eax,%eax
  802793:	01 d0                	add    %edx,%eax
  802795:	c1 e0 02             	shl    $0x2,%eax
  802798:	05 40 50 80 00       	add    $0x805040,%eax
  80279d:	8b 08                	mov    (%eax),%ecx
  80279f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8027a2:	89 d0                	mov    %edx,%eax
  8027a4:	01 c0                	add    %eax,%eax
  8027a6:	01 d0                	add    %edx,%eax
  8027a8:	c1 e0 02             	shl    $0x2,%eax
  8027ab:	05 44 50 80 00       	add    $0x805044,%eax
  8027b0:	8b 00                	mov    (%eax),%eax
  8027b2:	01 c8                	add    %ecx,%eax
  8027b4:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  8027b7:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8027ba:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8027bd:	76 06                	jbe    8027c5 <realloc+0x453>
  8027bf:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8027c2:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  8027c5:	ff 45 d8             	incl   -0x28(%ebp)
  8027c8:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  8027cf:	7e a4                	jle    802775 <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  8027d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027d4:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  8027d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027dc:	e9 a9 01 00 00       	jmp    80298a <realloc+0x618>
	}
	uint32 end = va + oldsz;
  8027e1:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8027e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e7:	01 d0                	add    %edx,%eax
  8027e9:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  8027ec:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8027f3:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  8027fa:	eb 57                	jmp    802853 <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  8027fc:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8027ff:	89 d0                	mov    %edx,%eax
  802801:	01 c0                	add    %eax,%eax
  802803:	01 d0                	add    %edx,%eax
  802805:	c1 e0 02             	shl    $0x2,%eax
  802808:	05 48 10 81 00       	add    $0x811048,%eax
  80280d:	8a 00                	mov    (%eax),%al
  80280f:	84 c0                	test   %al,%al
  802811:	74 3d                	je     802850 <realloc+0x4de>
  802813:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802816:	89 d0                	mov    %edx,%eax
  802818:	01 c0                	add    %eax,%eax
  80281a:	01 d0                	add    %edx,%eax
  80281c:	c1 e0 02             	shl    $0x2,%eax
  80281f:	05 40 10 81 00       	add    $0x811040,%eax
  802824:	8b 00                	mov    (%eax),%eax
  802826:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802829:	75 25                	jne    802850 <realloc+0x4de>
  80282b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80282e:	89 d0                	mov    %edx,%eax
  802830:	01 c0                	add    %eax,%eax
  802832:	01 d0                	add    %edx,%eax
  802834:	c1 e0 02             	shl    $0x2,%eax
  802837:	05 44 10 81 00       	add    $0x811044,%eax
  80283c:	8b 10                	mov    (%eax),%edx
  80283e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802841:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802844:	39 c2                	cmp    %eax,%edx
  802846:	72 08                	jb     802850 <realloc+0x4de>
		{
			adjIdx = j; break;
  802848:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80284b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80284e:	eb 0c                	jmp    80285c <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802850:	ff 45 d0             	incl   -0x30(%ebp)
  802853:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  80285a:	7e a0                	jle    8027fc <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  80285c:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  802860:	0f 84 d6 00 00 00    	je     80293c <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  802866:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802869:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80286c:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  80286f:	83 ec 08             	sub    $0x8,%esp
  802872:	ff 75 a0             	pushl  -0x60(%ebp)
  802875:	ff 75 a4             	pushl  -0x5c(%ebp)
  802878:	e8 cf 09 00 00       	call   80324c <sys_allocate_user_mem>
  80287d:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  802880:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802883:	89 d0                	mov    %edx,%eax
  802885:	01 c0                	add    %eax,%eax
  802887:	01 d0                	add    %edx,%eax
  802889:	c1 e0 02             	shl    $0x2,%eax
  80288c:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802892:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802895:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  802897:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80289a:	89 d0                	mov    %edx,%eax
  80289c:	01 c0                	add    %eax,%eax
  80289e:	01 d0                	add    %edx,%eax
  8028a0:	c1 e0 02             	shl    $0x2,%eax
  8028a3:	05 40 10 81 00       	add    $0x811040,%eax
  8028a8:	8b 10                	mov    (%eax),%edx
  8028aa:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8028ad:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8028b0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8028b3:	89 d0                	mov    %edx,%eax
  8028b5:	01 c0                	add    %eax,%eax
  8028b7:	01 d0                	add    %edx,%eax
  8028b9:	c1 e0 02             	shl    $0x2,%eax
  8028bc:	05 40 10 81 00       	add    $0x811040,%eax
  8028c1:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  8028c3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8028c6:	89 d0                	mov    %edx,%eax
  8028c8:	01 c0                	add    %eax,%eax
  8028ca:	01 d0                	add    %edx,%eax
  8028cc:	c1 e0 02             	shl    $0x2,%eax
  8028cf:	05 44 10 81 00       	add    $0x811044,%eax
  8028d4:	8b 00                	mov    (%eax),%eax
  8028d6:	2b 45 a0             	sub    -0x60(%ebp),%eax
  8028d9:	89 c2                	mov    %eax,%edx
  8028db:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8028de:	89 c8                	mov    %ecx,%eax
  8028e0:	01 c0                	add    %eax,%eax
  8028e2:	01 c8                	add    %ecx,%eax
  8028e4:	c1 e0 02             	shl    $0x2,%eax
  8028e7:	05 44 10 81 00       	add    $0x811044,%eax
  8028ec:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  8028ee:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8028f1:	89 d0                	mov    %edx,%eax
  8028f3:	01 c0                	add    %eax,%eax
  8028f5:	01 d0                	add    %edx,%eax
  8028f7:	c1 e0 02             	shl    $0x2,%eax
  8028fa:	05 44 10 81 00       	add    $0x811044,%eax
  8028ff:	8b 00                	mov    (%eax),%eax
  802901:	85 c0                	test   %eax,%eax
  802903:	75 14                	jne    802919 <realloc+0x5a7>
  802905:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802908:	89 d0                	mov    %edx,%eax
  80290a:	01 c0                	add    %eax,%eax
  80290c:	01 d0                	add    %edx,%eax
  80290e:	c1 e0 02             	shl    $0x2,%eax
  802911:	05 48 10 81 00       	add    $0x811048,%eax
  802916:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  802919:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80291c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80291f:	01 c2                	add    %eax,%edx
  802921:	a1 88 50 83 00       	mov    0x835088,%eax
  802926:	39 c2                	cmp    %eax,%edx
  802928:	76 0d                	jbe    802937 <realloc+0x5c5>
  80292a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80292d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802930:	01 d0                	add    %edx,%eax
  802932:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  802937:	8b 45 08             	mov    0x8(%ebp),%eax
  80293a:	eb 4e                	jmp    80298a <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  80293c:	83 ec 0c             	sub    $0xc,%esp
  80293f:	ff 75 0c             	pushl  0xc(%ebp)
  802942:	e8 0b ec ff ff       	call   801552 <malloc>
  802947:	83 c4 10             	add    $0x10,%esp
  80294a:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  80294d:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  802951:	75 07                	jne    80295a <realloc+0x5e8>
		return NULL;
  802953:	b8 00 00 00 00       	mov    $0x0,%eax
  802958:	eb 30                	jmp    80298a <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  80295a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80295d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802960:	39 d0                	cmp    %edx,%eax
  802962:	76 02                	jbe    802966 <realloc+0x5f4>
  802964:	89 d0                	mov    %edx,%eax
  802966:	8b 55 9c             	mov    -0x64(%ebp),%edx
  802969:	83 ec 04             	sub    $0x4,%esp
  80296c:	50                   	push   %eax
  80296d:	52                   	push   %edx
  80296e:	ff 75 cc             	pushl  -0x34(%ebp)
  802971:	e8 cf 06 00 00       	call   803045 <sys_move_user_mem>
  802976:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  802979:	83 ec 0c             	sub    $0xc,%esp
  80297c:	ff 75 08             	pushl  0x8(%ebp)
  80297f:	e8 2e ef ff ff       	call   8018b2 <free>
  802984:	83 c4 10             	add    $0x10,%esp
	return newptr;
  802987:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  80298a:	c9                   	leave  
  80298b:	c3                   	ret    

0080298c <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  80298c:	55                   	push   %ebp
  80298d:	89 e5                	mov    %esp,%ebp
  80298f:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  802992:	8b 45 08             	mov    0x8(%ebp),%eax
  802995:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  802998:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80299c:	0f 84 33 03 00 00    	je     802cd5 <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  8029a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8029a5:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  8029aa:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  8029ad:	83 ec 08             	sub    $0x8,%esp
  8029b0:	ff 75 08             	pushl  0x8(%ebp)
  8029b3:	ff 75 d8             	pushl  -0x28(%ebp)
  8029b6:	e8 7d 05 00 00       	call   802f38 <sys_delete_shared_object>
  8029bb:	83 c4 10             	add    $0x10,%esp
  8029be:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  8029c1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8029c5:	0f 88 0d 03 00 00    	js     802cd8 <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8029cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8029d2:	e9 ef 02 00 00       	jmp    802cc6 <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  8029d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029da:	89 d0                	mov    %edx,%eax
  8029dc:	01 c0                	add    %eax,%eax
  8029de:	01 d0                	add    %edx,%eax
  8029e0:	c1 e0 02             	shl    $0x2,%eax
  8029e3:	05 48 50 80 00       	add    $0x805048,%eax
  8029e8:	8a 00                	mov    (%eax),%al
  8029ea:	84 c0                	test   %al,%al
  8029ec:	0f 84 d1 02 00 00    	je     802cc3 <sfree+0x337>
  8029f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029f5:	89 d0                	mov    %edx,%eax
  8029f7:	01 c0                	add    %eax,%eax
  8029f9:	01 d0                	add    %edx,%eax
  8029fb:	c1 e0 02             	shl    $0x2,%eax
  8029fe:	05 40 50 80 00       	add    $0x805040,%eax
  802a03:	8b 00                	mov    (%eax),%eax
  802a05:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802a08:	0f 85 b5 02 00 00    	jne    802cc3 <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  802a0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a11:	89 d0                	mov    %edx,%eax
  802a13:	01 c0                	add    %eax,%eax
  802a15:	01 d0                	add    %edx,%eax
  802a17:	c1 e0 02             	shl    $0x2,%eax
  802a1a:	05 44 50 80 00       	add    $0x805044,%eax
  802a1f:	8b 00                	mov    (%eax),%eax
  802a21:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  802a24:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a27:	89 d0                	mov    %edx,%eax
  802a29:	01 c0                	add    %eax,%eax
  802a2b:	01 d0                	add    %edx,%eax
  802a2d:	c1 e0 02             	shl    $0x2,%eax
  802a30:	05 48 50 80 00       	add    $0x805048,%eax
  802a35:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  802a38:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802a3f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802a46:	eb 64                	jmp    802aac <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  802a48:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a4b:	89 d0                	mov    %edx,%eax
  802a4d:	01 c0                	add    %eax,%eax
  802a4f:	01 d0                	add    %edx,%eax
  802a51:	c1 e0 02             	shl    $0x2,%eax
  802a54:	05 48 10 81 00       	add    $0x811048,%eax
  802a59:	8a 00                	mov    (%eax),%al
  802a5b:	84 c0                	test   %al,%al
  802a5d:	75 4a                	jne    802aa9 <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  802a5f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a62:	89 d0                	mov    %edx,%eax
  802a64:	01 c0                	add    %eax,%eax
  802a66:	01 d0                	add    %edx,%eax
  802a68:	c1 e0 02             	shl    $0x2,%eax
  802a6b:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  802a71:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a74:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  802a76:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a79:	89 d0                	mov    %edx,%eax
  802a7b:	01 c0                	add    %eax,%eax
  802a7d:	01 d0                	add    %edx,%eax
  802a7f:	c1 e0 02             	shl    $0x2,%eax
  802a82:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  802a88:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802a8b:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  802a8d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a90:	89 d0                	mov    %edx,%eax
  802a92:	01 c0                	add    %eax,%eax
  802a94:	01 d0                	add    %edx,%eax
  802a96:	c1 e0 02             	shl    $0x2,%eax
  802a99:	05 48 10 81 00       	add    $0x811048,%eax
  802a9e:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  802aa1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa4:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  802aa7:	eb 0c                	jmp    802ab5 <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802aa9:	ff 45 ec             	incl   -0x14(%ebp)
  802aac:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802ab3:	7e 93                	jle    802a48 <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  802ab5:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802ab9:	0f 84 8d 01 00 00    	je     802c4c <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802abf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802ac6:	e9 74 01 00 00       	jmp    802c3f <sfree+0x2b3>
				{
					if (k == fidx) continue;
  802acb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ace:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802ad1:	0f 84 64 01 00 00    	je     802c3b <sfree+0x2af>
					if (uhp_frees[k].free)
  802ad7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ada:	89 d0                	mov    %edx,%eax
  802adc:	01 c0                	add    %eax,%eax
  802ade:	01 d0                	add    %edx,%eax
  802ae0:	c1 e0 02             	shl    $0x2,%eax
  802ae3:	05 48 10 81 00       	add    $0x811048,%eax
  802ae8:	8a 00                	mov    (%eax),%al
  802aea:	84 c0                	test   %al,%al
  802aec:	0f 84 4a 01 00 00    	je     802c3c <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802af2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802af5:	89 d0                	mov    %edx,%eax
  802af7:	01 c0                	add    %eax,%eax
  802af9:	01 d0                	add    %edx,%eax
  802afb:	c1 e0 02             	shl    $0x2,%eax
  802afe:	05 40 10 81 00       	add    $0x811040,%eax
  802b03:	8b 08                	mov    (%eax),%ecx
  802b05:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b08:	89 d0                	mov    %edx,%eax
  802b0a:	01 c0                	add    %eax,%eax
  802b0c:	01 d0                	add    %edx,%eax
  802b0e:	c1 e0 02             	shl    $0x2,%eax
  802b11:	05 44 10 81 00       	add    $0x811044,%eax
  802b16:	8b 00                	mov    (%eax),%eax
  802b18:	01 c1                	add    %eax,%ecx
  802b1a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b1d:	89 d0                	mov    %edx,%eax
  802b1f:	01 c0                	add    %eax,%eax
  802b21:	01 d0                	add    %edx,%eax
  802b23:	c1 e0 02             	shl    $0x2,%eax
  802b26:	05 40 10 81 00       	add    $0x811040,%eax
  802b2b:	8b 00                	mov    (%eax),%eax
  802b2d:	39 c1                	cmp    %eax,%ecx
  802b2f:	75 7a                	jne    802bab <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  802b31:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b34:	89 d0                	mov    %edx,%eax
  802b36:	01 c0                	add    %eax,%eax
  802b38:	01 d0                	add    %edx,%eax
  802b3a:	c1 e0 02             	shl    $0x2,%eax
  802b3d:	05 40 10 81 00       	add    $0x811040,%eax
  802b42:	8b 10                	mov    (%eax),%edx
  802b44:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802b47:	89 c8                	mov    %ecx,%eax
  802b49:	01 c0                	add    %eax,%eax
  802b4b:	01 c8                	add    %ecx,%eax
  802b4d:	c1 e0 02             	shl    $0x2,%eax
  802b50:	05 40 10 81 00       	add    $0x811040,%eax
  802b55:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  802b57:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b5a:	89 d0                	mov    %edx,%eax
  802b5c:	01 c0                	add    %eax,%eax
  802b5e:	01 d0                	add    %edx,%eax
  802b60:	c1 e0 02             	shl    $0x2,%eax
  802b63:	05 44 10 81 00       	add    $0x811044,%eax
  802b68:	8b 08                	mov    (%eax),%ecx
  802b6a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b6d:	89 d0                	mov    %edx,%eax
  802b6f:	01 c0                	add    %eax,%eax
  802b71:	01 d0                	add    %edx,%eax
  802b73:	c1 e0 02             	shl    $0x2,%eax
  802b76:	05 44 10 81 00       	add    $0x811044,%eax
  802b7b:	8b 00                	mov    (%eax),%eax
  802b7d:	01 c1                	add    %eax,%ecx
  802b7f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b82:	89 d0                	mov    %edx,%eax
  802b84:	01 c0                	add    %eax,%eax
  802b86:	01 d0                	add    %edx,%eax
  802b88:	c1 e0 02             	shl    $0x2,%eax
  802b8b:	05 44 10 81 00       	add    $0x811044,%eax
  802b90:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802b92:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b95:	89 d0                	mov    %edx,%eax
  802b97:	01 c0                	add    %eax,%eax
  802b99:	01 d0                	add    %edx,%eax
  802b9b:	c1 e0 02             	shl    $0x2,%eax
  802b9e:	05 48 10 81 00       	add    $0x811048,%eax
  802ba3:	c6 00 00             	movb   $0x0,(%eax)
  802ba6:	e9 91 00 00 00       	jmp    802c3c <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802bab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bae:	89 d0                	mov    %edx,%eax
  802bb0:	01 c0                	add    %eax,%eax
  802bb2:	01 d0                	add    %edx,%eax
  802bb4:	c1 e0 02             	shl    $0x2,%eax
  802bb7:	05 40 10 81 00       	add    $0x811040,%eax
  802bbc:	8b 08                	mov    (%eax),%ecx
  802bbe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bc1:	89 d0                	mov    %edx,%eax
  802bc3:	01 c0                	add    %eax,%eax
  802bc5:	01 d0                	add    %edx,%eax
  802bc7:	c1 e0 02             	shl    $0x2,%eax
  802bca:	05 44 10 81 00       	add    $0x811044,%eax
  802bcf:	8b 00                	mov    (%eax),%eax
  802bd1:	01 c1                	add    %eax,%ecx
  802bd3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bd6:	89 d0                	mov    %edx,%eax
  802bd8:	01 c0                	add    %eax,%eax
  802bda:	01 d0                	add    %edx,%eax
  802bdc:	c1 e0 02             	shl    $0x2,%eax
  802bdf:	05 40 10 81 00       	add    $0x811040,%eax
  802be4:	8b 00                	mov    (%eax),%eax
  802be6:	39 c1                	cmp    %eax,%ecx
  802be8:	75 52                	jne    802c3c <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  802bea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bed:	89 d0                	mov    %edx,%eax
  802bef:	01 c0                	add    %eax,%eax
  802bf1:	01 d0                	add    %edx,%eax
  802bf3:	c1 e0 02             	shl    $0x2,%eax
  802bf6:	05 44 10 81 00       	add    $0x811044,%eax
  802bfb:	8b 08                	mov    (%eax),%ecx
  802bfd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c00:	89 d0                	mov    %edx,%eax
  802c02:	01 c0                	add    %eax,%eax
  802c04:	01 d0                	add    %edx,%eax
  802c06:	c1 e0 02             	shl    $0x2,%eax
  802c09:	05 44 10 81 00       	add    $0x811044,%eax
  802c0e:	8b 00                	mov    (%eax),%eax
  802c10:	01 c1                	add    %eax,%ecx
  802c12:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c15:	89 d0                	mov    %edx,%eax
  802c17:	01 c0                	add    %eax,%eax
  802c19:	01 d0                	add    %edx,%eax
  802c1b:	c1 e0 02             	shl    $0x2,%eax
  802c1e:	05 44 10 81 00       	add    $0x811044,%eax
  802c23:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802c25:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c28:	89 d0                	mov    %edx,%eax
  802c2a:	01 c0                	add    %eax,%eax
  802c2c:	01 d0                	add    %edx,%eax
  802c2e:	c1 e0 02             	shl    $0x2,%eax
  802c31:	05 48 10 81 00       	add    $0x811048,%eax
  802c36:	c6 00 00             	movb   $0x0,(%eax)
  802c39:	eb 01                	jmp    802c3c <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  802c3b:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802c3c:	ff 45 e8             	incl   -0x18(%ebp)
  802c3f:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802c46:	0f 8e 7f fe ff ff    	jle    802acb <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  802c4c:	a1 30 51 83 00       	mov    0x835130,%eax
  802c51:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802c54:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802c5b:	eb 53                	jmp    802cb0 <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  802c5d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c60:	89 d0                	mov    %edx,%eax
  802c62:	01 c0                	add    %eax,%eax
  802c64:	01 d0                	add    %edx,%eax
  802c66:	c1 e0 02             	shl    $0x2,%eax
  802c69:	05 48 50 80 00       	add    $0x805048,%eax
  802c6e:	8a 00                	mov    (%eax),%al
  802c70:	84 c0                	test   %al,%al
  802c72:	74 39                	je     802cad <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802c74:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c77:	89 d0                	mov    %edx,%eax
  802c79:	01 c0                	add    %eax,%eax
  802c7b:	01 d0                	add    %edx,%eax
  802c7d:	c1 e0 02             	shl    $0x2,%eax
  802c80:	05 40 50 80 00       	add    $0x805040,%eax
  802c85:	8b 08                	mov    (%eax),%ecx
  802c87:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c8a:	89 d0                	mov    %edx,%eax
  802c8c:	01 c0                	add    %eax,%eax
  802c8e:	01 d0                	add    %edx,%eax
  802c90:	c1 e0 02             	shl    $0x2,%eax
  802c93:	05 44 50 80 00       	add    $0x805044,%eax
  802c98:	8b 00                	mov    (%eax),%eax
  802c9a:	01 c8                	add    %ecx,%eax
  802c9c:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  802c9f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ca2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802ca5:	76 06                	jbe    802cad <sfree+0x321>
  802ca7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802caa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802cad:	ff 45 e0             	incl   -0x20(%ebp)
  802cb0:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802cb7:	7e a4                	jle    802c5d <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  802cb9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cbc:	a3 88 50 83 00       	mov    %eax,0x835088
			break;
  802cc1:	eb 16                	jmp    802cd9 <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802cc3:	ff 45 f4             	incl   -0xc(%ebp)
  802cc6:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  802ccd:	0f 8e 04 fd ff ff    	jle    8029d7 <sfree+0x4b>
  802cd3:	eb 04                	jmp    802cd9 <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  802cd5:	90                   	nop
  802cd6:	eb 01                	jmp    802cd9 <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  802cd8:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  802cd9:	c9                   	leave  
  802cda:	c3                   	ret    

00802cdb <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802cdb:	55                   	push   %ebp
  802cdc:	89 e5                	mov    %esp,%ebp
  802cde:	57                   	push   %edi
  802cdf:	56                   	push   %esi
  802ce0:	53                   	push   %ebx
  802ce1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce7:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cea:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802ced:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802cf0:	8b 7d 18             	mov    0x18(%ebp),%edi
  802cf3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802cf6:	cd 30                	int    $0x30
  802cf8:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802cfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802cfe:	83 c4 10             	add    $0x10,%esp
  802d01:	5b                   	pop    %ebx
  802d02:	5e                   	pop    %esi
  802d03:	5f                   	pop    %edi
  802d04:	5d                   	pop    %ebp
  802d05:	c3                   	ret    

00802d06 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802d06:	55                   	push   %ebp
  802d07:	89 e5                	mov    %esp,%ebp
  802d09:	83 ec 04             	sub    $0x4,%esp
  802d0c:	8b 45 10             	mov    0x10(%ebp),%eax
  802d0f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802d12:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802d15:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802d19:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1c:	6a 00                	push   $0x0
  802d1e:	51                   	push   %ecx
  802d1f:	52                   	push   %edx
  802d20:	ff 75 0c             	pushl  0xc(%ebp)
  802d23:	50                   	push   %eax
  802d24:	6a 00                	push   $0x0
  802d26:	e8 b0 ff ff ff       	call   802cdb <syscall>
  802d2b:	83 c4 18             	add    $0x18,%esp
}
  802d2e:	90                   	nop
  802d2f:	c9                   	leave  
  802d30:	c3                   	ret    

00802d31 <sys_cgetc>:

int
sys_cgetc(void)
{
  802d31:	55                   	push   %ebp
  802d32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802d34:	6a 00                	push   $0x0
  802d36:	6a 00                	push   $0x0
  802d38:	6a 00                	push   $0x0
  802d3a:	6a 00                	push   $0x0
  802d3c:	6a 00                	push   $0x0
  802d3e:	6a 02                	push   $0x2
  802d40:	e8 96 ff ff ff       	call   802cdb <syscall>
  802d45:	83 c4 18             	add    $0x18,%esp
}
  802d48:	c9                   	leave  
  802d49:	c3                   	ret    

00802d4a <sys_lock_cons>:

void sys_lock_cons(void)
{
  802d4a:	55                   	push   %ebp
  802d4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802d4d:	6a 00                	push   $0x0
  802d4f:	6a 00                	push   $0x0
  802d51:	6a 00                	push   $0x0
  802d53:	6a 00                	push   $0x0
  802d55:	6a 00                	push   $0x0
  802d57:	6a 03                	push   $0x3
  802d59:	e8 7d ff ff ff       	call   802cdb <syscall>
  802d5e:	83 c4 18             	add    $0x18,%esp
}
  802d61:	90                   	nop
  802d62:	c9                   	leave  
  802d63:	c3                   	ret    

00802d64 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802d64:	55                   	push   %ebp
  802d65:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802d67:	6a 00                	push   $0x0
  802d69:	6a 00                	push   $0x0
  802d6b:	6a 00                	push   $0x0
  802d6d:	6a 00                	push   $0x0
  802d6f:	6a 00                	push   $0x0
  802d71:	6a 04                	push   $0x4
  802d73:	e8 63 ff ff ff       	call   802cdb <syscall>
  802d78:	83 c4 18             	add    $0x18,%esp
}
  802d7b:	90                   	nop
  802d7c:	c9                   	leave  
  802d7d:	c3                   	ret    

00802d7e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802d7e:	55                   	push   %ebp
  802d7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802d81:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d84:	8b 45 08             	mov    0x8(%ebp),%eax
  802d87:	6a 00                	push   $0x0
  802d89:	6a 00                	push   $0x0
  802d8b:	6a 00                	push   $0x0
  802d8d:	52                   	push   %edx
  802d8e:	50                   	push   %eax
  802d8f:	6a 08                	push   $0x8
  802d91:	e8 45 ff ff ff       	call   802cdb <syscall>
  802d96:	83 c4 18             	add    $0x18,%esp
}
  802d99:	c9                   	leave  
  802d9a:	c3                   	ret    

00802d9b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802d9b:	55                   	push   %ebp
  802d9c:	89 e5                	mov    %esp,%ebp
  802d9e:	56                   	push   %esi
  802d9f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802da0:	8b 75 18             	mov    0x18(%ebp),%esi
  802da3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802da6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802da9:	8b 55 0c             	mov    0xc(%ebp),%edx
  802dac:	8b 45 08             	mov    0x8(%ebp),%eax
  802daf:	56                   	push   %esi
  802db0:	53                   	push   %ebx
  802db1:	51                   	push   %ecx
  802db2:	52                   	push   %edx
  802db3:	50                   	push   %eax
  802db4:	6a 09                	push   $0x9
  802db6:	e8 20 ff ff ff       	call   802cdb <syscall>
  802dbb:	83 c4 18             	add    $0x18,%esp
}
  802dbe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802dc1:	5b                   	pop    %ebx
  802dc2:	5e                   	pop    %esi
  802dc3:	5d                   	pop    %ebp
  802dc4:	c3                   	ret    

00802dc5 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802dc5:	55                   	push   %ebp
  802dc6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802dc8:	6a 00                	push   $0x0
  802dca:	6a 00                	push   $0x0
  802dcc:	6a 00                	push   $0x0
  802dce:	6a 00                	push   $0x0
  802dd0:	ff 75 08             	pushl  0x8(%ebp)
  802dd3:	6a 0a                	push   $0xa
  802dd5:	e8 01 ff ff ff       	call   802cdb <syscall>
  802dda:	83 c4 18             	add    $0x18,%esp
}
  802ddd:	c9                   	leave  
  802dde:	c3                   	ret    

00802ddf <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802ddf:	55                   	push   %ebp
  802de0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802de2:	6a 00                	push   $0x0
  802de4:	6a 00                	push   $0x0
  802de6:	6a 00                	push   $0x0
  802de8:	ff 75 0c             	pushl  0xc(%ebp)
  802deb:	ff 75 08             	pushl  0x8(%ebp)
  802dee:	6a 0b                	push   $0xb
  802df0:	e8 e6 fe ff ff       	call   802cdb <syscall>
  802df5:	83 c4 18             	add    $0x18,%esp
}
  802df8:	c9                   	leave  
  802df9:	c3                   	ret    

00802dfa <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802dfa:	55                   	push   %ebp
  802dfb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802dfd:	6a 00                	push   $0x0
  802dff:	6a 00                	push   $0x0
  802e01:	6a 00                	push   $0x0
  802e03:	6a 00                	push   $0x0
  802e05:	6a 00                	push   $0x0
  802e07:	6a 0c                	push   $0xc
  802e09:	e8 cd fe ff ff       	call   802cdb <syscall>
  802e0e:	83 c4 18             	add    $0x18,%esp
}
  802e11:	c9                   	leave  
  802e12:	c3                   	ret    

00802e13 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802e13:	55                   	push   %ebp
  802e14:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802e16:	6a 00                	push   $0x0
  802e18:	6a 00                	push   $0x0
  802e1a:	6a 00                	push   $0x0
  802e1c:	6a 00                	push   $0x0
  802e1e:	6a 00                	push   $0x0
  802e20:	6a 0d                	push   $0xd
  802e22:	e8 b4 fe ff ff       	call   802cdb <syscall>
  802e27:	83 c4 18             	add    $0x18,%esp
}
  802e2a:	c9                   	leave  
  802e2b:	c3                   	ret    

00802e2c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802e2c:	55                   	push   %ebp
  802e2d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802e2f:	6a 00                	push   $0x0
  802e31:	6a 00                	push   $0x0
  802e33:	6a 00                	push   $0x0
  802e35:	6a 00                	push   $0x0
  802e37:	6a 00                	push   $0x0
  802e39:	6a 0e                	push   $0xe
  802e3b:	e8 9b fe ff ff       	call   802cdb <syscall>
  802e40:	83 c4 18             	add    $0x18,%esp
}
  802e43:	c9                   	leave  
  802e44:	c3                   	ret    

00802e45 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802e45:	55                   	push   %ebp
  802e46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802e48:	6a 00                	push   $0x0
  802e4a:	6a 00                	push   $0x0
  802e4c:	6a 00                	push   $0x0
  802e4e:	6a 00                	push   $0x0
  802e50:	6a 00                	push   $0x0
  802e52:	6a 0f                	push   $0xf
  802e54:	e8 82 fe ff ff       	call   802cdb <syscall>
  802e59:	83 c4 18             	add    $0x18,%esp
}
  802e5c:	c9                   	leave  
  802e5d:	c3                   	ret    

00802e5e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802e5e:	55                   	push   %ebp
  802e5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802e61:	6a 00                	push   $0x0
  802e63:	6a 00                	push   $0x0
  802e65:	6a 00                	push   $0x0
  802e67:	6a 00                	push   $0x0
  802e69:	ff 75 08             	pushl  0x8(%ebp)
  802e6c:	6a 10                	push   $0x10
  802e6e:	e8 68 fe ff ff       	call   802cdb <syscall>
  802e73:	83 c4 18             	add    $0x18,%esp
}
  802e76:	c9                   	leave  
  802e77:	c3                   	ret    

00802e78 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802e78:	55                   	push   %ebp
  802e79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802e7b:	6a 00                	push   $0x0
  802e7d:	6a 00                	push   $0x0
  802e7f:	6a 00                	push   $0x0
  802e81:	6a 00                	push   $0x0
  802e83:	6a 00                	push   $0x0
  802e85:	6a 11                	push   $0x11
  802e87:	e8 4f fe ff ff       	call   802cdb <syscall>
  802e8c:	83 c4 18             	add    $0x18,%esp
}
  802e8f:	90                   	nop
  802e90:	c9                   	leave  
  802e91:	c3                   	ret    

00802e92 <sys_cputc>:

void
sys_cputc(const char c)
{
  802e92:	55                   	push   %ebp
  802e93:	89 e5                	mov    %esp,%ebp
  802e95:	83 ec 04             	sub    $0x4,%esp
  802e98:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802e9e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802ea2:	6a 00                	push   $0x0
  802ea4:	6a 00                	push   $0x0
  802ea6:	6a 00                	push   $0x0
  802ea8:	6a 00                	push   $0x0
  802eaa:	50                   	push   %eax
  802eab:	6a 01                	push   $0x1
  802ead:	e8 29 fe ff ff       	call   802cdb <syscall>
  802eb2:	83 c4 18             	add    $0x18,%esp
}
  802eb5:	90                   	nop
  802eb6:	c9                   	leave  
  802eb7:	c3                   	ret    

00802eb8 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802eb8:	55                   	push   %ebp
  802eb9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802ebb:	6a 00                	push   $0x0
  802ebd:	6a 00                	push   $0x0
  802ebf:	6a 00                	push   $0x0
  802ec1:	6a 00                	push   $0x0
  802ec3:	6a 00                	push   $0x0
  802ec5:	6a 14                	push   $0x14
  802ec7:	e8 0f fe ff ff       	call   802cdb <syscall>
  802ecc:	83 c4 18             	add    $0x18,%esp
}
  802ecf:	90                   	nop
  802ed0:	c9                   	leave  
  802ed1:	c3                   	ret    

00802ed2 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802ed2:	55                   	push   %ebp
  802ed3:	89 e5                	mov    %esp,%ebp
  802ed5:	83 ec 04             	sub    $0x4,%esp
  802ed8:	8b 45 10             	mov    0x10(%ebp),%eax
  802edb:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802ede:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802ee1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee8:	6a 00                	push   $0x0
  802eea:	51                   	push   %ecx
  802eeb:	52                   	push   %edx
  802eec:	ff 75 0c             	pushl  0xc(%ebp)
  802eef:	50                   	push   %eax
  802ef0:	6a 15                	push   $0x15
  802ef2:	e8 e4 fd ff ff       	call   802cdb <syscall>
  802ef7:	83 c4 18             	add    $0x18,%esp
}
  802efa:	c9                   	leave  
  802efb:	c3                   	ret    

00802efc <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802efc:	55                   	push   %ebp
  802efd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802eff:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f02:	8b 45 08             	mov    0x8(%ebp),%eax
  802f05:	6a 00                	push   $0x0
  802f07:	6a 00                	push   $0x0
  802f09:	6a 00                	push   $0x0
  802f0b:	52                   	push   %edx
  802f0c:	50                   	push   %eax
  802f0d:	6a 16                	push   $0x16
  802f0f:	e8 c7 fd ff ff       	call   802cdb <syscall>
  802f14:	83 c4 18             	add    $0x18,%esp
}
  802f17:	c9                   	leave  
  802f18:	c3                   	ret    

00802f19 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802f19:	55                   	push   %ebp
  802f1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802f1c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802f1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f22:	8b 45 08             	mov    0x8(%ebp),%eax
  802f25:	6a 00                	push   $0x0
  802f27:	6a 00                	push   $0x0
  802f29:	51                   	push   %ecx
  802f2a:	52                   	push   %edx
  802f2b:	50                   	push   %eax
  802f2c:	6a 17                	push   $0x17
  802f2e:	e8 a8 fd ff ff       	call   802cdb <syscall>
  802f33:	83 c4 18             	add    $0x18,%esp
}
  802f36:	c9                   	leave  
  802f37:	c3                   	ret    

00802f38 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802f38:	55                   	push   %ebp
  802f39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802f3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f41:	6a 00                	push   $0x0
  802f43:	6a 00                	push   $0x0
  802f45:	6a 00                	push   $0x0
  802f47:	52                   	push   %edx
  802f48:	50                   	push   %eax
  802f49:	6a 18                	push   $0x18
  802f4b:	e8 8b fd ff ff       	call   802cdb <syscall>
  802f50:	83 c4 18             	add    $0x18,%esp
}
  802f53:	c9                   	leave  
  802f54:	c3                   	ret    

00802f55 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802f55:	55                   	push   %ebp
  802f56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802f58:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5b:	6a 00                	push   $0x0
  802f5d:	ff 75 14             	pushl  0x14(%ebp)
  802f60:	ff 75 10             	pushl  0x10(%ebp)
  802f63:	ff 75 0c             	pushl  0xc(%ebp)
  802f66:	50                   	push   %eax
  802f67:	6a 19                	push   $0x19
  802f69:	e8 6d fd ff ff       	call   802cdb <syscall>
  802f6e:	83 c4 18             	add    $0x18,%esp
}
  802f71:	c9                   	leave  
  802f72:	c3                   	ret    

00802f73 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802f73:	55                   	push   %ebp
  802f74:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802f76:	8b 45 08             	mov    0x8(%ebp),%eax
  802f79:	6a 00                	push   $0x0
  802f7b:	6a 00                	push   $0x0
  802f7d:	6a 00                	push   $0x0
  802f7f:	6a 00                	push   $0x0
  802f81:	50                   	push   %eax
  802f82:	6a 1a                	push   $0x1a
  802f84:	e8 52 fd ff ff       	call   802cdb <syscall>
  802f89:	83 c4 18             	add    $0x18,%esp
}
  802f8c:	90                   	nop
  802f8d:	c9                   	leave  
  802f8e:	c3                   	ret    

00802f8f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802f8f:	55                   	push   %ebp
  802f90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802f92:	8b 45 08             	mov    0x8(%ebp),%eax
  802f95:	6a 00                	push   $0x0
  802f97:	6a 00                	push   $0x0
  802f99:	6a 00                	push   $0x0
  802f9b:	6a 00                	push   $0x0
  802f9d:	50                   	push   %eax
  802f9e:	6a 1b                	push   $0x1b
  802fa0:	e8 36 fd ff ff       	call   802cdb <syscall>
  802fa5:	83 c4 18             	add    $0x18,%esp
}
  802fa8:	c9                   	leave  
  802fa9:	c3                   	ret    

00802faa <sys_getenvid>:

int32 sys_getenvid(void)
{
  802faa:	55                   	push   %ebp
  802fab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802fad:	6a 00                	push   $0x0
  802faf:	6a 00                	push   $0x0
  802fb1:	6a 00                	push   $0x0
  802fb3:	6a 00                	push   $0x0
  802fb5:	6a 00                	push   $0x0
  802fb7:	6a 05                	push   $0x5
  802fb9:	e8 1d fd ff ff       	call   802cdb <syscall>
  802fbe:	83 c4 18             	add    $0x18,%esp
}
  802fc1:	c9                   	leave  
  802fc2:	c3                   	ret    

00802fc3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802fc3:	55                   	push   %ebp
  802fc4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802fc6:	6a 00                	push   $0x0
  802fc8:	6a 00                	push   $0x0
  802fca:	6a 00                	push   $0x0
  802fcc:	6a 00                	push   $0x0
  802fce:	6a 00                	push   $0x0
  802fd0:	6a 06                	push   $0x6
  802fd2:	e8 04 fd ff ff       	call   802cdb <syscall>
  802fd7:	83 c4 18             	add    $0x18,%esp
}
  802fda:	c9                   	leave  
  802fdb:	c3                   	ret    

00802fdc <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802fdc:	55                   	push   %ebp
  802fdd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802fdf:	6a 00                	push   $0x0
  802fe1:	6a 00                	push   $0x0
  802fe3:	6a 00                	push   $0x0
  802fe5:	6a 00                	push   $0x0
  802fe7:	6a 00                	push   $0x0
  802fe9:	6a 07                	push   $0x7
  802feb:	e8 eb fc ff ff       	call   802cdb <syscall>
  802ff0:	83 c4 18             	add    $0x18,%esp
}
  802ff3:	c9                   	leave  
  802ff4:	c3                   	ret    

00802ff5 <sys_exit_env>:


void sys_exit_env(void)
{
  802ff5:	55                   	push   %ebp
  802ff6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802ff8:	6a 00                	push   $0x0
  802ffa:	6a 00                	push   $0x0
  802ffc:	6a 00                	push   $0x0
  802ffe:	6a 00                	push   $0x0
  803000:	6a 00                	push   $0x0
  803002:	6a 1c                	push   $0x1c
  803004:	e8 d2 fc ff ff       	call   802cdb <syscall>
  803009:	83 c4 18             	add    $0x18,%esp
}
  80300c:	90                   	nop
  80300d:	c9                   	leave  
  80300e:	c3                   	ret    

0080300f <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80300f:	55                   	push   %ebp
  803010:	89 e5                	mov    %esp,%ebp
  803012:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  803015:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803018:	8d 50 04             	lea    0x4(%eax),%edx
  80301b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80301e:	6a 00                	push   $0x0
  803020:	6a 00                	push   $0x0
  803022:	6a 00                	push   $0x0
  803024:	52                   	push   %edx
  803025:	50                   	push   %eax
  803026:	6a 1d                	push   $0x1d
  803028:	e8 ae fc ff ff       	call   802cdb <syscall>
  80302d:	83 c4 18             	add    $0x18,%esp
	return result;
  803030:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803033:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803036:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803039:	89 01                	mov    %eax,(%ecx)
  80303b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80303e:	8b 45 08             	mov    0x8(%ebp),%eax
  803041:	c9                   	leave  
  803042:	c2 04 00             	ret    $0x4

00803045 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  803045:	55                   	push   %ebp
  803046:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  803048:	6a 00                	push   $0x0
  80304a:	6a 00                	push   $0x0
  80304c:	ff 75 10             	pushl  0x10(%ebp)
  80304f:	ff 75 0c             	pushl  0xc(%ebp)
  803052:	ff 75 08             	pushl  0x8(%ebp)
  803055:	6a 13                	push   $0x13
  803057:	e8 7f fc ff ff       	call   802cdb <syscall>
  80305c:	83 c4 18             	add    $0x18,%esp
	return ;
  80305f:	90                   	nop
}
  803060:	c9                   	leave  
  803061:	c3                   	ret    

00803062 <sys_rcr2>:
uint32 sys_rcr2()
{
  803062:	55                   	push   %ebp
  803063:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  803065:	6a 00                	push   $0x0
  803067:	6a 00                	push   $0x0
  803069:	6a 00                	push   $0x0
  80306b:	6a 00                	push   $0x0
  80306d:	6a 00                	push   $0x0
  80306f:	6a 1e                	push   $0x1e
  803071:	e8 65 fc ff ff       	call   802cdb <syscall>
  803076:	83 c4 18             	add    $0x18,%esp
}
  803079:	c9                   	leave  
  80307a:	c3                   	ret    

0080307b <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80307b:	55                   	push   %ebp
  80307c:	89 e5                	mov    %esp,%ebp
  80307e:	83 ec 04             	sub    $0x4,%esp
  803081:	8b 45 08             	mov    0x8(%ebp),%eax
  803084:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803087:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80308b:	6a 00                	push   $0x0
  80308d:	6a 00                	push   $0x0
  80308f:	6a 00                	push   $0x0
  803091:	6a 00                	push   $0x0
  803093:	50                   	push   %eax
  803094:	6a 1f                	push   $0x1f
  803096:	e8 40 fc ff ff       	call   802cdb <syscall>
  80309b:	83 c4 18             	add    $0x18,%esp
	return ;
  80309e:	90                   	nop
}
  80309f:	c9                   	leave  
  8030a0:	c3                   	ret    

008030a1 <rsttst>:
void rsttst()
{
  8030a1:	55                   	push   %ebp
  8030a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8030a4:	6a 00                	push   $0x0
  8030a6:	6a 00                	push   $0x0
  8030a8:	6a 00                	push   $0x0
  8030aa:	6a 00                	push   $0x0
  8030ac:	6a 00                	push   $0x0
  8030ae:	6a 21                	push   $0x21
  8030b0:	e8 26 fc ff ff       	call   802cdb <syscall>
  8030b5:	83 c4 18             	add    $0x18,%esp
	return ;
  8030b8:	90                   	nop
}
  8030b9:	c9                   	leave  
  8030ba:	c3                   	ret    

008030bb <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8030bb:	55                   	push   %ebp
  8030bc:	89 e5                	mov    %esp,%ebp
  8030be:	83 ec 04             	sub    $0x4,%esp
  8030c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8030c4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8030c7:	8b 55 18             	mov    0x18(%ebp),%edx
  8030ca:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8030ce:	52                   	push   %edx
  8030cf:	50                   	push   %eax
  8030d0:	ff 75 10             	pushl  0x10(%ebp)
  8030d3:	ff 75 0c             	pushl  0xc(%ebp)
  8030d6:	ff 75 08             	pushl  0x8(%ebp)
  8030d9:	6a 20                	push   $0x20
  8030db:	e8 fb fb ff ff       	call   802cdb <syscall>
  8030e0:	83 c4 18             	add    $0x18,%esp
	return ;
  8030e3:	90                   	nop
}
  8030e4:	c9                   	leave  
  8030e5:	c3                   	ret    

008030e6 <chktst>:
void chktst(uint32 n)
{
  8030e6:	55                   	push   %ebp
  8030e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8030e9:	6a 00                	push   $0x0
  8030eb:	6a 00                	push   $0x0
  8030ed:	6a 00                	push   $0x0
  8030ef:	6a 00                	push   $0x0
  8030f1:	ff 75 08             	pushl  0x8(%ebp)
  8030f4:	6a 22                	push   $0x22
  8030f6:	e8 e0 fb ff ff       	call   802cdb <syscall>
  8030fb:	83 c4 18             	add    $0x18,%esp
	return ;
  8030fe:	90                   	nop
}
  8030ff:	c9                   	leave  
  803100:	c3                   	ret    

00803101 <inctst>:

void inctst()
{
  803101:	55                   	push   %ebp
  803102:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803104:	6a 00                	push   $0x0
  803106:	6a 00                	push   $0x0
  803108:	6a 00                	push   $0x0
  80310a:	6a 00                	push   $0x0
  80310c:	6a 00                	push   $0x0
  80310e:	6a 23                	push   $0x23
  803110:	e8 c6 fb ff ff       	call   802cdb <syscall>
  803115:	83 c4 18             	add    $0x18,%esp
	return ;
  803118:	90                   	nop
}
  803119:	c9                   	leave  
  80311a:	c3                   	ret    

0080311b <gettst>:
uint32 gettst()
{
  80311b:	55                   	push   %ebp
  80311c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80311e:	6a 00                	push   $0x0
  803120:	6a 00                	push   $0x0
  803122:	6a 00                	push   $0x0
  803124:	6a 00                	push   $0x0
  803126:	6a 00                	push   $0x0
  803128:	6a 24                	push   $0x24
  80312a:	e8 ac fb ff ff       	call   802cdb <syscall>
  80312f:	83 c4 18             	add    $0x18,%esp
}
  803132:	c9                   	leave  
  803133:	c3                   	ret    

00803134 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  803134:	55                   	push   %ebp
  803135:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803137:	6a 00                	push   $0x0
  803139:	6a 00                	push   $0x0
  80313b:	6a 00                	push   $0x0
  80313d:	6a 00                	push   $0x0
  80313f:	6a 00                	push   $0x0
  803141:	6a 25                	push   $0x25
  803143:	e8 93 fb ff ff       	call   802cdb <syscall>
  803148:	83 c4 18             	add    $0x18,%esp
  80314b:	a3 80 50 83 00       	mov    %eax,0x835080
	return uheapPlaceStrategy ;
  803150:	a1 80 50 83 00       	mov    0x835080,%eax
}
  803155:	c9                   	leave  
  803156:	c3                   	ret    

00803157 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803157:	55                   	push   %ebp
  803158:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80315a:	8b 45 08             	mov    0x8(%ebp),%eax
  80315d:	a3 80 50 83 00       	mov    %eax,0x835080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803162:	6a 00                	push   $0x0
  803164:	6a 00                	push   $0x0
  803166:	6a 00                	push   $0x0
  803168:	6a 00                	push   $0x0
  80316a:	ff 75 08             	pushl  0x8(%ebp)
  80316d:	6a 26                	push   $0x26
  80316f:	e8 67 fb ff ff       	call   802cdb <syscall>
  803174:	83 c4 18             	add    $0x18,%esp
	return ;
  803177:	90                   	nop
}
  803178:	c9                   	leave  
  803179:	c3                   	ret    

0080317a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80317a:	55                   	push   %ebp
  80317b:	89 e5                	mov    %esp,%ebp
  80317d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80317e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803181:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803184:	8b 55 0c             	mov    0xc(%ebp),%edx
  803187:	8b 45 08             	mov    0x8(%ebp),%eax
  80318a:	6a 00                	push   $0x0
  80318c:	53                   	push   %ebx
  80318d:	51                   	push   %ecx
  80318e:	52                   	push   %edx
  80318f:	50                   	push   %eax
  803190:	6a 27                	push   $0x27
  803192:	e8 44 fb ff ff       	call   802cdb <syscall>
  803197:	83 c4 18             	add    $0x18,%esp
}
  80319a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80319d:	c9                   	leave  
  80319e:	c3                   	ret    

0080319f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80319f:	55                   	push   %ebp
  8031a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8031a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a8:	6a 00                	push   $0x0
  8031aa:	6a 00                	push   $0x0
  8031ac:	6a 00                	push   $0x0
  8031ae:	52                   	push   %edx
  8031af:	50                   	push   %eax
  8031b0:	6a 28                	push   $0x28
  8031b2:	e8 24 fb ff ff       	call   802cdb <syscall>
  8031b7:	83 c4 18             	add    $0x18,%esp
}
  8031ba:	c9                   	leave  
  8031bb:	c3                   	ret    

008031bc <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8031bc:	55                   	push   %ebp
  8031bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8031bf:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8031c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c8:	6a 00                	push   $0x0
  8031ca:	51                   	push   %ecx
  8031cb:	ff 75 10             	pushl  0x10(%ebp)
  8031ce:	52                   	push   %edx
  8031cf:	50                   	push   %eax
  8031d0:	6a 29                	push   $0x29
  8031d2:	e8 04 fb ff ff       	call   802cdb <syscall>
  8031d7:	83 c4 18             	add    $0x18,%esp
}
  8031da:	c9                   	leave  
  8031db:	c3                   	ret    

008031dc <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8031dc:	55                   	push   %ebp
  8031dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8031df:	6a 00                	push   $0x0
  8031e1:	6a 00                	push   $0x0
  8031e3:	ff 75 10             	pushl  0x10(%ebp)
  8031e6:	ff 75 0c             	pushl  0xc(%ebp)
  8031e9:	ff 75 08             	pushl  0x8(%ebp)
  8031ec:	6a 12                	push   $0x12
  8031ee:	e8 e8 fa ff ff       	call   802cdb <syscall>
  8031f3:	83 c4 18             	add    $0x18,%esp
	return ;
  8031f6:	90                   	nop
}
  8031f7:	c9                   	leave  
  8031f8:	c3                   	ret    

008031f9 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8031f9:	55                   	push   %ebp
  8031fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8031fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803202:	6a 00                	push   $0x0
  803204:	6a 00                	push   $0x0
  803206:	6a 00                	push   $0x0
  803208:	52                   	push   %edx
  803209:	50                   	push   %eax
  80320a:	6a 2a                	push   $0x2a
  80320c:	e8 ca fa ff ff       	call   802cdb <syscall>
  803211:	83 c4 18             	add    $0x18,%esp
	return;
  803214:	90                   	nop
}
  803215:	c9                   	leave  
  803216:	c3                   	ret    

00803217 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  803217:	55                   	push   %ebp
  803218:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80321a:	6a 00                	push   $0x0
  80321c:	6a 00                	push   $0x0
  80321e:	6a 00                	push   $0x0
  803220:	6a 00                	push   $0x0
  803222:	6a 00                	push   $0x0
  803224:	6a 2b                	push   $0x2b
  803226:	e8 b0 fa ff ff       	call   802cdb <syscall>
  80322b:	83 c4 18             	add    $0x18,%esp
}
  80322e:	c9                   	leave  
  80322f:	c3                   	ret    

00803230 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803230:	55                   	push   %ebp
  803231:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  803233:	6a 00                	push   $0x0
  803235:	6a 00                	push   $0x0
  803237:	6a 00                	push   $0x0
  803239:	ff 75 0c             	pushl  0xc(%ebp)
  80323c:	ff 75 08             	pushl  0x8(%ebp)
  80323f:	6a 2d                	push   $0x2d
  803241:	e8 95 fa ff ff       	call   802cdb <syscall>
  803246:	83 c4 18             	add    $0x18,%esp
	return;
  803249:	90                   	nop
}
  80324a:	c9                   	leave  
  80324b:	c3                   	ret    

0080324c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80324c:	55                   	push   %ebp
  80324d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80324f:	6a 00                	push   $0x0
  803251:	6a 00                	push   $0x0
  803253:	6a 00                	push   $0x0
  803255:	ff 75 0c             	pushl  0xc(%ebp)
  803258:	ff 75 08             	pushl  0x8(%ebp)
  80325b:	6a 2c                	push   $0x2c
  80325d:	e8 79 fa ff ff       	call   802cdb <syscall>
  803262:	83 c4 18             	add    $0x18,%esp
	return ;
  803265:	90                   	nop
}
  803266:	c9                   	leave  
  803267:	c3                   	ret    

00803268 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  803268:	55                   	push   %ebp
  803269:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80326b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80326e:	8b 45 08             	mov    0x8(%ebp),%eax
  803271:	6a 00                	push   $0x0
  803273:	6a 00                	push   $0x0
  803275:	6a 00                	push   $0x0
  803277:	52                   	push   %edx
  803278:	50                   	push   %eax
  803279:	6a 2e                	push   $0x2e
  80327b:	e8 5b fa ff ff       	call   802cdb <syscall>
  803280:	83 c4 18             	add    $0x18,%esp
}
  803283:	90                   	nop
  803284:	c9                   	leave  
  803285:	c3                   	ret    

00803286 <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  803286:	55                   	push   %ebp
  803287:	89 e5                	mov    %esp,%ebp
  803289:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  80328c:	81 7d 08 80 d0 81 00 	cmpl   $0x81d080,0x8(%ebp)
  803293:	72 09                	jb     80329e <to_page_va+0x18>
  803295:	81 7d 08 80 50 83 00 	cmpl   $0x835080,0x8(%ebp)
  80329c:	72 14                	jb     8032b2 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  80329e:	83 ec 04             	sub    $0x4,%esp
  8032a1:	68 78 47 80 00       	push   $0x804778
  8032a6:	6a 15                	push   $0x15
  8032a8:	68 a3 47 80 00       	push   $0x8047a3
  8032ad:	e8 10 d0 ff ff       	call   8002c2 <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8032b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b5:	ba 80 d0 81 00       	mov    $0x81d080,%edx
  8032ba:	29 d0                	sub    %edx,%eax
  8032bc:	c1 f8 02             	sar    $0x2,%eax
  8032bf:	89 c2                	mov    %eax,%edx
  8032c1:	89 d0                	mov    %edx,%eax
  8032c3:	c1 e0 02             	shl    $0x2,%eax
  8032c6:	01 d0                	add    %edx,%eax
  8032c8:	c1 e0 02             	shl    $0x2,%eax
  8032cb:	01 d0                	add    %edx,%eax
  8032cd:	c1 e0 02             	shl    $0x2,%eax
  8032d0:	01 d0                	add    %edx,%eax
  8032d2:	89 c1                	mov    %eax,%ecx
  8032d4:	c1 e1 08             	shl    $0x8,%ecx
  8032d7:	01 c8                	add    %ecx,%eax
  8032d9:	89 c1                	mov    %eax,%ecx
  8032db:	c1 e1 10             	shl    $0x10,%ecx
  8032de:	01 c8                	add    %ecx,%eax
  8032e0:	01 c0                	add    %eax,%eax
  8032e2:	01 d0                	add    %edx,%eax
  8032e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8032e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ea:	c1 e0 0c             	shl    $0xc,%eax
  8032ed:	89 c2                	mov    %eax,%edx
  8032ef:	a1 84 50 83 00       	mov    0x835084,%eax
  8032f4:	01 d0                	add    %edx,%eax
}
  8032f6:	c9                   	leave  
  8032f7:	c3                   	ret    

008032f8 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  8032f8:	55                   	push   %ebp
  8032f9:	89 e5                	mov    %esp,%ebp
  8032fb:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  8032fe:	a1 84 50 83 00       	mov    0x835084,%eax
  803303:	8b 55 08             	mov    0x8(%ebp),%edx
  803306:	29 c2                	sub    %eax,%edx
  803308:	89 d0                	mov    %edx,%eax
  80330a:	c1 e8 0c             	shr    $0xc,%eax
  80330d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  803310:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803314:	78 09                	js     80331f <to_page_info+0x27>
  803316:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  80331d:	7e 14                	jle    803333 <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  80331f:	83 ec 04             	sub    $0x4,%esp
  803322:	68 bc 47 80 00       	push   $0x8047bc
  803327:	6a 21                	push   $0x21
  803329:	68 a3 47 80 00       	push   $0x8047a3
  80332e:	e8 8f cf ff ff       	call   8002c2 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  803333:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803336:	89 d0                	mov    %edx,%eax
  803338:	01 c0                	add    %eax,%eax
  80333a:	01 d0                	add    %edx,%eax
  80333c:	c1 e0 02             	shl    $0x2,%eax
  80333f:	05 80 d0 81 00       	add    $0x81d080,%eax
}
  803344:	c9                   	leave  
  803345:	c3                   	ret    

00803346 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803346:	55                   	push   %ebp
  803347:	89 e5                	mov    %esp,%ebp
  803349:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  80334c:	8b 45 08             	mov    0x8(%ebp),%eax
  80334f:	05 00 00 00 02       	add    $0x2000000,%eax
  803354:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803357:	73 16                	jae    80336f <initialize_dynamic_allocator+0x29>
  803359:	68 e0 47 80 00       	push   $0x8047e0
  80335e:	68 06 48 80 00       	push   $0x804806
  803363:	6a 2f                	push   $0x2f
  803365:	68 a3 47 80 00       	push   $0x8047a3
  80336a:	e8 53 cf ff ff       	call   8002c2 <_panic>
	dynAllocStart = daStart;
  80336f:	8b 45 08             	mov    0x8(%ebp),%eax
  803372:	a3 84 50 83 00       	mov    %eax,0x835084
	dynAllocEnd = daEnd;
  803377:	8b 45 0c             	mov    0xc(%ebp),%eax
  80337a:	a3 60 d0 81 00       	mov    %eax,0x81d060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  80337f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803386:	eb 36                	jmp    8033be <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  803388:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80338b:	c1 e0 04             	shl    $0x4,%eax
  80338e:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803393:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803399:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339c:	c1 e0 04             	shl    $0x4,%eax
  80339f:	05 a4 50 83 00       	add    $0x8350a4,%eax
  8033a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ad:	c1 e0 04             	shl    $0x4,%eax
  8033b0:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8033b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8033bb:	ff 45 f4             	incl   -0xc(%ebp)
  8033be:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  8033c2:	7e c4                	jle    803388 <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  8033c4:	c7 05 68 d0 81 00 00 	movl   $0x0,0x81d068
  8033cb:	00 00 00 
  8033ce:	c7 05 6c d0 81 00 00 	movl   $0x0,0x81d06c
  8033d5:	00 00 00 
  8033d8:	c7 05 74 d0 81 00 00 	movl   $0x0,0x81d074
  8033df:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  8033e2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8033e9:	e9 1b 01 00 00       	jmp    803509 <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  8033ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033f1:	89 d0                	mov    %edx,%eax
  8033f3:	01 c0                	add    %eax,%eax
  8033f5:	01 d0                	add    %edx,%eax
  8033f7:	c1 e0 02             	shl    $0x2,%eax
  8033fa:	05 88 d0 81 00       	add    $0x81d088,%eax
  8033ff:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  803404:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803407:	89 d0                	mov    %edx,%eax
  803409:	01 c0                	add    %eax,%eax
  80340b:	01 d0                	add    %edx,%eax
  80340d:	c1 e0 02             	shl    $0x2,%eax
  803410:	05 8a d0 81 00       	add    $0x81d08a,%eax
  803415:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  80341a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80341d:	89 d0                	mov    %edx,%eax
  80341f:	01 c0                	add    %eax,%eax
  803421:	01 d0                	add    %edx,%eax
  803423:	c1 e0 02             	shl    $0x2,%eax
  803426:	05 80 d0 81 00       	add    $0x81d080,%eax
  80342b:	8b 00                	mov    (%eax),%eax
  80342d:	85 c0                	test   %eax,%eax
  80342f:	74 2b                	je     80345c <initialize_dynamic_allocator+0x116>
  803431:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803434:	89 d0                	mov    %edx,%eax
  803436:	01 c0                	add    %eax,%eax
  803438:	01 d0                	add    %edx,%eax
  80343a:	c1 e0 02             	shl    $0x2,%eax
  80343d:	05 80 d0 81 00       	add    $0x81d080,%eax
  803442:	8b 10                	mov    (%eax),%edx
  803444:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803447:	89 c8                	mov    %ecx,%eax
  803449:	01 c0                	add    %eax,%eax
  80344b:	01 c8                	add    %ecx,%eax
  80344d:	c1 e0 02             	shl    $0x2,%eax
  803450:	05 84 d0 81 00       	add    $0x81d084,%eax
  803455:	8b 00                	mov    (%eax),%eax
  803457:	89 42 04             	mov    %eax,0x4(%edx)
  80345a:	eb 18                	jmp    803474 <initialize_dynamic_allocator+0x12e>
  80345c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80345f:	89 d0                	mov    %edx,%eax
  803461:	01 c0                	add    %eax,%eax
  803463:	01 d0                	add    %edx,%eax
  803465:	c1 e0 02             	shl    $0x2,%eax
  803468:	05 84 d0 81 00       	add    $0x81d084,%eax
  80346d:	8b 00                	mov    (%eax),%eax
  80346f:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803474:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803477:	89 d0                	mov    %edx,%eax
  803479:	01 c0                	add    %eax,%eax
  80347b:	01 d0                	add    %edx,%eax
  80347d:	c1 e0 02             	shl    $0x2,%eax
  803480:	05 84 d0 81 00       	add    $0x81d084,%eax
  803485:	8b 00                	mov    (%eax),%eax
  803487:	85 c0                	test   %eax,%eax
  803489:	74 2a                	je     8034b5 <initialize_dynamic_allocator+0x16f>
  80348b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80348e:	89 d0                	mov    %edx,%eax
  803490:	01 c0                	add    %eax,%eax
  803492:	01 d0                	add    %edx,%eax
  803494:	c1 e0 02             	shl    $0x2,%eax
  803497:	05 84 d0 81 00       	add    $0x81d084,%eax
  80349c:	8b 10                	mov    (%eax),%edx
  80349e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8034a1:	89 c8                	mov    %ecx,%eax
  8034a3:	01 c0                	add    %eax,%eax
  8034a5:	01 c8                	add    %ecx,%eax
  8034a7:	c1 e0 02             	shl    $0x2,%eax
  8034aa:	05 80 d0 81 00       	add    $0x81d080,%eax
  8034af:	8b 00                	mov    (%eax),%eax
  8034b1:	89 02                	mov    %eax,(%edx)
  8034b3:	eb 18                	jmp    8034cd <initialize_dynamic_allocator+0x187>
  8034b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034b8:	89 d0                	mov    %edx,%eax
  8034ba:	01 c0                	add    %eax,%eax
  8034bc:	01 d0                	add    %edx,%eax
  8034be:	c1 e0 02             	shl    $0x2,%eax
  8034c1:	05 80 d0 81 00       	add    $0x81d080,%eax
  8034c6:	8b 00                	mov    (%eax),%eax
  8034c8:	a3 68 d0 81 00       	mov    %eax,0x81d068
  8034cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034d0:	89 d0                	mov    %edx,%eax
  8034d2:	01 c0                	add    %eax,%eax
  8034d4:	01 d0                	add    %edx,%eax
  8034d6:	c1 e0 02             	shl    $0x2,%eax
  8034d9:	05 80 d0 81 00       	add    $0x81d080,%eax
  8034de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034e7:	89 d0                	mov    %edx,%eax
  8034e9:	01 c0                	add    %eax,%eax
  8034eb:	01 d0                	add    %edx,%eax
  8034ed:	c1 e0 02             	shl    $0x2,%eax
  8034f0:	05 84 d0 81 00       	add    $0x81d084,%eax
  8034f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034fb:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803500:	48                   	dec    %eax
  803501:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803506:	ff 45 f0             	incl   -0x10(%ebp)
  803509:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  803510:	0f 8e d8 fe ff ff    	jle    8033ee <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803516:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  80351d:	e9 9d 00 00 00       	jmp    8035bf <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  803522:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803528:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  80352b:	89 c8                	mov    %ecx,%eax
  80352d:	01 c0                	add    %eax,%eax
  80352f:	01 c8                	add    %ecx,%eax
  803531:	c1 e0 02             	shl    $0x2,%eax
  803534:	05 80 d0 81 00       	add    $0x81d080,%eax
  803539:	89 10                	mov    %edx,(%eax)
  80353b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80353e:	89 d0                	mov    %edx,%eax
  803540:	01 c0                	add    %eax,%eax
  803542:	01 d0                	add    %edx,%eax
  803544:	c1 e0 02             	shl    $0x2,%eax
  803547:	05 80 d0 81 00       	add    $0x81d080,%eax
  80354c:	8b 00                	mov    (%eax),%eax
  80354e:	85 c0                	test   %eax,%eax
  803550:	74 1c                	je     80356e <initialize_dynamic_allocator+0x228>
  803552:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803558:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  80355b:	89 c8                	mov    %ecx,%eax
  80355d:	01 c0                	add    %eax,%eax
  80355f:	01 c8                	add    %ecx,%eax
  803561:	c1 e0 02             	shl    $0x2,%eax
  803564:	05 80 d0 81 00       	add    $0x81d080,%eax
  803569:	89 42 04             	mov    %eax,0x4(%edx)
  80356c:	eb 16                	jmp    803584 <initialize_dynamic_allocator+0x23e>
  80356e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803571:	89 d0                	mov    %edx,%eax
  803573:	01 c0                	add    %eax,%eax
  803575:	01 d0                	add    %edx,%eax
  803577:	c1 e0 02             	shl    $0x2,%eax
  80357a:	05 80 d0 81 00       	add    $0x81d080,%eax
  80357f:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803584:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803587:	89 d0                	mov    %edx,%eax
  803589:	01 c0                	add    %eax,%eax
  80358b:	01 d0                	add    %edx,%eax
  80358d:	c1 e0 02             	shl    $0x2,%eax
  803590:	05 80 d0 81 00       	add    $0x81d080,%eax
  803595:	a3 68 d0 81 00       	mov    %eax,0x81d068
  80359a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80359d:	89 d0                	mov    %edx,%eax
  80359f:	01 c0                	add    %eax,%eax
  8035a1:	01 d0                	add    %edx,%eax
  8035a3:	c1 e0 02             	shl    $0x2,%eax
  8035a6:	05 84 d0 81 00       	add    $0x81d084,%eax
  8035ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035b1:	a1 74 d0 81 00       	mov    0x81d074,%eax
  8035b6:	40                   	inc    %eax
  8035b7:	a3 74 d0 81 00       	mov    %eax,0x81d074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  8035bc:	ff 4d ec             	decl   -0x14(%ebp)
  8035bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8035c3:	0f 89 59 ff ff ff    	jns    803522 <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  8035c9:	c7 05 44 d0 81 00 01 	movl   $0x1,0x81d044
  8035d0:	00 00 00 
}
  8035d3:	90                   	nop
  8035d4:	c9                   	leave  
  8035d5:	c3                   	ret    

008035d6 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  8035d6:	55                   	push   %ebp
  8035d7:	89 e5                	mov    %esp,%ebp
  8035d9:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  8035dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8035df:	83 ec 0c             	sub    $0xc,%esp
  8035e2:	50                   	push   %eax
  8035e3:	e8 10 fd ff ff       	call   8032f8 <to_page_info>
  8035e8:	83 c4 10             	add    $0x10,%esp
  8035eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  8035ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f1:	8b 40 08             	mov    0x8(%eax),%eax
  8035f4:	0f b7 c0             	movzwl %ax,%eax
}
  8035f7:	c9                   	leave  
  8035f8:	c3                   	ret    

008035f9 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8035f9:	55                   	push   %ebp
  8035fa:	89 e5                	mov    %esp,%ebp
  8035fc:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8035ff:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803606:	76 16                	jbe    80361e <alloc_block+0x25>
  803608:	68 1c 48 80 00       	push   $0x80481c
  80360d:	68 06 48 80 00       	push   $0x804806
  803612:	6a 59                	push   $0x59
  803614:	68 a3 47 80 00       	push   $0x8047a3
  803619:	e8 a4 cc ff ff       	call   8002c2 <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  80361e:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803625:	eb 08                	jmp    80362f <alloc_block+0x36>
		allocSize <<= 1;
  803627:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80362a:	01 c0                	add    %eax,%eax
  80362c:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  80362f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803632:	3b 45 08             	cmp    0x8(%ebp),%eax
  803635:	73 09                	jae    803640 <alloc_block+0x47>
  803637:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  80363e:	76 e7                	jbe    803627 <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  803640:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803647:	eb 03                	jmp    80364c <alloc_block+0x53>
		listIndex++;
  803649:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  80364c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80364f:	ba 08 00 00 00       	mov    $0x8,%edx
  803654:	88 c1                	mov    %al,%cl
  803656:	d3 e2                	shl    %cl,%edx
  803658:	89 d0                	mov    %edx,%eax
  80365a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80365d:	72 ea                	jb     803649 <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  80365f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803662:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803665:	e9 f4 00 00 00       	jmp    80375e <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  80366a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80366d:	c1 e0 04             	shl    $0x4,%eax
  803670:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803675:	8b 00                	mov    (%eax),%eax
  803677:	85 c0                	test   %eax,%eax
  803679:	0f 84 dc 00 00 00    	je     80375b <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  80367f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803682:	c1 e0 04             	shl    $0x4,%eax
  803685:	05 a0 50 83 00       	add    $0x8350a0,%eax
  80368a:	8b 00                	mov    (%eax),%eax
  80368c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  80368f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803693:	75 14                	jne    8036a9 <alloc_block+0xb0>
  803695:	83 ec 04             	sub    $0x4,%esp
  803698:	68 3d 48 80 00       	push   $0x80483d
  80369d:	6a 6b                	push   $0x6b
  80369f:	68 a3 47 80 00       	push   $0x8047a3
  8036a4:	e8 19 cc ff ff       	call   8002c2 <_panic>
  8036a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036ac:	8b 00                	mov    (%eax),%eax
  8036ae:	85 c0                	test   %eax,%eax
  8036b0:	74 10                	je     8036c2 <alloc_block+0xc9>
  8036b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036b5:	8b 00                	mov    (%eax),%eax
  8036b7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036ba:	8b 52 04             	mov    0x4(%edx),%edx
  8036bd:	89 50 04             	mov    %edx,0x4(%eax)
  8036c0:	eb 14                	jmp    8036d6 <alloc_block+0xdd>
  8036c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036c5:	8b 40 04             	mov    0x4(%eax),%eax
  8036c8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036cb:	c1 e2 04             	shl    $0x4,%edx
  8036ce:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  8036d4:	89 02                	mov    %eax,(%edx)
  8036d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036d9:	8b 40 04             	mov    0x4(%eax),%eax
  8036dc:	85 c0                	test   %eax,%eax
  8036de:	74 0f                	je     8036ef <alloc_block+0xf6>
  8036e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036e3:	8b 40 04             	mov    0x4(%eax),%eax
  8036e6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036e9:	8b 12                	mov    (%edx),%edx
  8036eb:	89 10                	mov    %edx,(%eax)
  8036ed:	eb 13                	jmp    803702 <alloc_block+0x109>
  8036ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036f2:	8b 00                	mov    (%eax),%eax
  8036f4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036f7:	c1 e2 04             	shl    $0x4,%edx
  8036fa:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803700:	89 02                	mov    %eax,(%edx)
  803702:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803705:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80370b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80370e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803715:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803718:	c1 e0 04             	shl    $0x4,%eax
  80371b:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803720:	8b 00                	mov    (%eax),%eax
  803722:	8d 50 ff             	lea    -0x1(%eax),%edx
  803725:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803728:	c1 e0 04             	shl    $0x4,%eax
  80372b:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803730:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  803732:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803735:	83 ec 0c             	sub    $0xc,%esp
  803738:	50                   	push   %eax
  803739:	e8 ba fb ff ff       	call   8032f8 <to_page_info>
  80373e:	83 c4 10             	add    $0x10,%esp
  803741:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  803744:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803747:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80374b:	48                   	dec    %eax
  80374c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80374f:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  803753:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803756:	e9 8f 02 00 00       	jmp    8039ea <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  80375b:	ff 45 ec             	incl   -0x14(%ebp)
  80375e:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803762:	0f 8e 02 ff ff ff    	jle    80366a <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  803768:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80376d:	85 c0                	test   %eax,%eax
  80376f:	75 14                	jne    803785 <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  803771:	83 ec 04             	sub    $0x4,%esp
  803774:	68 5c 48 80 00       	push   $0x80485c
  803779:	6a 77                	push   $0x77
  80377b:	68 a3 47 80 00       	push   $0x8047a3
  803780:	e8 3d cb ff ff       	call   8002c2 <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  803785:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80378a:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  80378d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803791:	75 14                	jne    8037a7 <alloc_block+0x1ae>
  803793:	83 ec 04             	sub    $0x4,%esp
  803796:	68 3d 48 80 00       	push   $0x80483d
  80379b:	6a 7a                	push   $0x7a
  80379d:	68 a3 47 80 00       	push   $0x8047a3
  8037a2:	e8 1b cb ff ff       	call   8002c2 <_panic>
  8037a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037aa:	8b 00                	mov    (%eax),%eax
  8037ac:	85 c0                	test   %eax,%eax
  8037ae:	74 10                	je     8037c0 <alloc_block+0x1c7>
  8037b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037b3:	8b 00                	mov    (%eax),%eax
  8037b5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8037b8:	8b 52 04             	mov    0x4(%edx),%edx
  8037bb:	89 50 04             	mov    %edx,0x4(%eax)
  8037be:	eb 0b                	jmp    8037cb <alloc_block+0x1d2>
  8037c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037c3:	8b 40 04             	mov    0x4(%eax),%eax
  8037c6:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  8037cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037ce:	8b 40 04             	mov    0x4(%eax),%eax
  8037d1:	85 c0                	test   %eax,%eax
  8037d3:	74 0f                	je     8037e4 <alloc_block+0x1eb>
  8037d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037d8:	8b 40 04             	mov    0x4(%eax),%eax
  8037db:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8037de:	8b 12                	mov    (%edx),%edx
  8037e0:	89 10                	mov    %edx,(%eax)
  8037e2:	eb 0a                	jmp    8037ee <alloc_block+0x1f5>
  8037e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037e7:	8b 00                	mov    (%eax),%eax
  8037e9:	a3 68 d0 81 00       	mov    %eax,0x81d068
  8037ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803801:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803806:	48                   	dec    %eax
  803807:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  80380c:	83 ec 0c             	sub    $0xc,%esp
  80380f:	ff 75 dc             	pushl  -0x24(%ebp)
  803812:	e8 6f fa ff ff       	call   803286 <to_page_va>
  803817:	83 c4 10             	add    $0x10,%esp
  80381a:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  80381d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803820:	83 ec 0c             	sub    $0xc,%esp
  803823:	50                   	push   %eax
  803824:	e8 a0 dc ff ff       	call   8014c9 <get_page>
  803829:	83 c4 10             	add    $0x10,%esp
  80382c:	85 c0                	test   %eax,%eax
  80382e:	74 14                	je     803844 <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  803830:	83 ec 04             	sub    $0x4,%esp
  803833:	68 84 48 80 00       	push   $0x804884
  803838:	6a 7f                	push   $0x7f
  80383a:	68 a3 47 80 00       	push   $0x8047a3
  80383f:	e8 7e ca ff ff       	call   8002c2 <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  803844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803847:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80384a:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  80384e:	b8 00 10 00 00       	mov    $0x1000,%eax
  803853:	ba 00 00 00 00       	mov    $0x0,%edx
  803858:	f7 75 f4             	divl   -0xc(%ebp)
  80385b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80385e:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803862:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803869:	e9 a7 00 00 00       	jmp    803915 <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  80386e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803871:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803874:	01 d0                	add    %edx,%eax
  803876:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  803879:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80387d:	75 17                	jne    803896 <alloc_block+0x29d>
  80387f:	83 ec 04             	sub    $0x4,%esp
  803882:	68 ac 48 80 00       	push   $0x8048ac
  803887:	68 88 00 00 00       	push   $0x88
  80388c:	68 a3 47 80 00       	push   $0x8047a3
  803891:	e8 2c ca ff ff       	call   8002c2 <_panic>
  803896:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803899:	c1 e0 04             	shl    $0x4,%eax
  80389c:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8038a1:	8b 10                	mov    (%eax),%edx
  8038a3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038a6:	89 10                	mov    %edx,(%eax)
  8038a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038ab:	8b 00                	mov    (%eax),%eax
  8038ad:	85 c0                	test   %eax,%eax
  8038af:	74 15                	je     8038c6 <alloc_block+0x2cd>
  8038b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038b4:	c1 e0 04             	shl    $0x4,%eax
  8038b7:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8038bc:	8b 00                	mov    (%eax),%eax
  8038be:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8038c1:	89 50 04             	mov    %edx,0x4(%eax)
  8038c4:	eb 11                	jmp    8038d7 <alloc_block+0x2de>
  8038c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038c9:	c1 e0 04             	shl    $0x4,%eax
  8038cc:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  8038d2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038d5:	89 02                	mov    %eax,(%edx)
  8038d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038da:	c1 e0 04             	shl    $0x4,%eax
  8038dd:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  8038e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038e6:	89 02                	mov    %eax,(%edx)
  8038e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038f5:	c1 e0 04             	shl    $0x4,%eax
  8038f8:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8038fd:	8b 00                	mov    (%eax),%eax
  8038ff:	8d 50 01             	lea    0x1(%eax),%edx
  803902:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803905:	c1 e0 04             	shl    $0x4,%eax
  803908:	05 ac 50 83 00       	add    $0x8350ac,%eax
  80390d:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  80390f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803912:	01 45 e8             	add    %eax,-0x18(%ebp)
  803915:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  80391c:	0f 86 4c ff ff ff    	jbe    80386e <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  803922:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803925:	c1 e0 04             	shl    $0x4,%eax
  803928:	05 a0 50 83 00       	add    $0x8350a0,%eax
  80392d:	8b 00                	mov    (%eax),%eax
  80392f:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  803932:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803936:	75 17                	jne    80394f <alloc_block+0x356>
  803938:	83 ec 04             	sub    $0x4,%esp
  80393b:	68 3d 48 80 00       	push   $0x80483d
  803940:	68 8d 00 00 00       	push   $0x8d
  803945:	68 a3 47 80 00       	push   $0x8047a3
  80394a:	e8 73 c9 ff ff       	call   8002c2 <_panic>
  80394f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803952:	8b 00                	mov    (%eax),%eax
  803954:	85 c0                	test   %eax,%eax
  803956:	74 10                	je     803968 <alloc_block+0x36f>
  803958:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80395b:	8b 00                	mov    (%eax),%eax
  80395d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803960:	8b 52 04             	mov    0x4(%edx),%edx
  803963:	89 50 04             	mov    %edx,0x4(%eax)
  803966:	eb 14                	jmp    80397c <alloc_block+0x383>
  803968:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80396b:	8b 40 04             	mov    0x4(%eax),%eax
  80396e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803971:	c1 e2 04             	shl    $0x4,%edx
  803974:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  80397a:	89 02                	mov    %eax,(%edx)
  80397c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80397f:	8b 40 04             	mov    0x4(%eax),%eax
  803982:	85 c0                	test   %eax,%eax
  803984:	74 0f                	je     803995 <alloc_block+0x39c>
  803986:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803989:	8b 40 04             	mov    0x4(%eax),%eax
  80398c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80398f:	8b 12                	mov    (%edx),%edx
  803991:	89 10                	mov    %edx,(%eax)
  803993:	eb 13                	jmp    8039a8 <alloc_block+0x3af>
  803995:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803998:	8b 00                	mov    (%eax),%eax
  80399a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80399d:	c1 e2 04             	shl    $0x4,%edx
  8039a0:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  8039a6:	89 02                	mov    %eax,(%edx)
  8039a8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8039ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039b1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8039b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039be:	c1 e0 04             	shl    $0x4,%eax
  8039c1:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8039c6:	8b 00                	mov    (%eax),%eax
  8039c8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8039cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039ce:	c1 e0 04             	shl    $0x4,%eax
  8039d1:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8039d6:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  8039d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039db:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8039df:	48                   	dec    %eax
  8039e0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8039e3:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  8039e7:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  8039ea:	c9                   	leave  
  8039eb:	c3                   	ret    

008039ec <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8039ec:	55                   	push   %ebp
  8039ed:	89 e5                	mov    %esp,%ebp
  8039ef:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8039f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8039f5:	a1 84 50 83 00       	mov    0x835084,%eax
  8039fa:	39 c2                	cmp    %eax,%edx
  8039fc:	72 0c                	jb     803a0a <free_block+0x1e>
  8039fe:	8b 55 08             	mov    0x8(%ebp),%edx
  803a01:	a1 60 d0 81 00       	mov    0x81d060,%eax
  803a06:	39 c2                	cmp    %eax,%edx
  803a08:	72 19                	jb     803a23 <free_block+0x37>
  803a0a:	68 d0 48 80 00       	push   $0x8048d0
  803a0f:	68 06 48 80 00       	push   $0x804806
  803a14:	68 98 00 00 00       	push   $0x98
  803a19:	68 a3 47 80 00       	push   $0x8047a3
  803a1e:	e8 9f c8 ff ff       	call   8002c2 <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803a23:	8b 45 08             	mov    0x8(%ebp),%eax
  803a26:	83 ec 0c             	sub    $0xc,%esp
  803a29:	50                   	push   %eax
  803a2a:	e8 c9 f8 ff ff       	call   8032f8 <to_page_info>
  803a2f:	83 c4 10             	add    $0x10,%esp
  803a32:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  803a35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a38:	8b 40 08             	mov    0x8(%eax),%eax
  803a3b:	0f b7 c0             	movzwl %ax,%eax
  803a3e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  803a41:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803a48:	eb 03                	jmp    803a4d <free_block+0x61>
		listIndex++;
  803a4a:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a50:	ba 08 00 00 00       	mov    $0x8,%edx
  803a55:	88 c1                	mov    %al,%cl
  803a57:	d3 e2                	shl    %cl,%edx
  803a59:	89 d0                	mov    %edx,%eax
  803a5b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803a5e:	72 ea                	jb     803a4a <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  803a60:	8b 45 08             	mov    0x8(%ebp),%eax
  803a63:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  803a66:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a6a:	75 17                	jne    803a83 <free_block+0x97>
  803a6c:	83 ec 04             	sub    $0x4,%esp
  803a6f:	68 ac 48 80 00       	push   $0x8048ac
  803a74:	68 a2 00 00 00       	push   $0xa2
  803a79:	68 a3 47 80 00       	push   $0x8047a3
  803a7e:	e8 3f c8 ff ff       	call   8002c2 <_panic>
  803a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a86:	c1 e0 04             	shl    $0x4,%eax
  803a89:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803a8e:	8b 10                	mov    (%eax),%edx
  803a90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a93:	89 10                	mov    %edx,(%eax)
  803a95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a98:	8b 00                	mov    (%eax),%eax
  803a9a:	85 c0                	test   %eax,%eax
  803a9c:	74 15                	je     803ab3 <free_block+0xc7>
  803a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aa1:	c1 e0 04             	shl    $0x4,%eax
  803aa4:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803aa9:	8b 00                	mov    (%eax),%eax
  803aab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803aae:	89 50 04             	mov    %edx,0x4(%eax)
  803ab1:	eb 11                	jmp    803ac4 <free_block+0xd8>
  803ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ab6:	c1 e0 04             	shl    $0x4,%eax
  803ab9:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803abf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ac2:	89 02                	mov    %eax,(%edx)
  803ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac7:	c1 e0 04             	shl    $0x4,%eax
  803aca:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803ad0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ad3:	89 02                	mov    %eax,(%edx)
  803ad5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ad8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ae2:	c1 e0 04             	shl    $0x4,%eax
  803ae5:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803aea:	8b 00                	mov    (%eax),%eax
  803aec:	8d 50 01             	lea    0x1(%eax),%edx
  803aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803af2:	c1 e0 04             	shl    $0x4,%eax
  803af5:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803afa:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  803afc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803aff:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803b03:	40                   	inc    %eax
  803b04:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b07:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  803b0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b0e:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803b12:	0f b7 c8             	movzwl %ax,%ecx
  803b15:	b8 00 10 00 00       	mov    $0x1000,%eax
  803b1a:	ba 00 00 00 00       	mov    $0x0,%edx
  803b1f:	f7 75 e8             	divl   -0x18(%ebp)
  803b22:	39 c1                	cmp    %eax,%ecx
  803b24:	0f 85 ed 01 00 00    	jne    803d17 <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b2d:	c1 e0 04             	shl    $0x4,%eax
  803b30:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803b35:	8b 00                	mov    (%eax),%eax
  803b37:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803b3a:	eb 2a                	jmp    803b66 <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  803b3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b3f:	83 ec 0c             	sub    $0xc,%esp
  803b42:	50                   	push   %eax
  803b43:	e8 b0 f7 ff ff       	call   8032f8 <to_page_info>
  803b48:	83 c4 10             	add    $0x10,%esp
  803b4b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803b4e:	75 06                	jne    803b56 <free_block+0x16a>
				tmp = b;
  803b50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b53:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b59:	c1 e0 04             	shl    $0x4,%eax
  803b5c:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803b61:	8b 00                	mov    (%eax),%eax
  803b63:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803b66:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803b6a:	74 07                	je     803b73 <free_block+0x187>
  803b6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b6f:	8b 00                	mov    (%eax),%eax
  803b71:	eb 05                	jmp    803b78 <free_block+0x18c>
  803b73:	b8 00 00 00 00       	mov    $0x0,%eax
  803b78:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b7b:	c1 e2 04             	shl    $0x4,%edx
  803b7e:	81 c2 a8 50 83 00    	add    $0x8350a8,%edx
  803b84:	89 02                	mov    %eax,(%edx)
  803b86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b89:	c1 e0 04             	shl    $0x4,%eax
  803b8c:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803b91:	8b 00                	mov    (%eax),%eax
  803b93:	85 c0                	test   %eax,%eax
  803b95:	75 a5                	jne    803b3c <free_block+0x150>
  803b97:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803b9b:	75 9f                	jne    803b3c <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  803b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ba0:	c1 e0 04             	shl    $0x4,%eax
  803ba3:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803ba8:	8b 00                	mov    (%eax),%eax
  803baa:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  803bad:	e9 cc 00 00 00       	jmp    803c7e <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  803bb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bb5:	8b 00                	mov    (%eax),%eax
  803bb7:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  803bba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bbd:	83 ec 0c             	sub    $0xc,%esp
  803bc0:	50                   	push   %eax
  803bc1:	e8 32 f7 ff ff       	call   8032f8 <to_page_info>
  803bc6:	83 c4 10             	add    $0x10,%esp
  803bc9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803bcc:	0f 85 a6 00 00 00    	jne    803c78 <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  803bd2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803bd6:	75 17                	jne    803bef <free_block+0x203>
  803bd8:	83 ec 04             	sub    $0x4,%esp
  803bdb:	68 3d 48 80 00       	push   $0x80483d
  803be0:	68 b5 00 00 00       	push   $0xb5
  803be5:	68 a3 47 80 00       	push   $0x8047a3
  803bea:	e8 d3 c6 ff ff       	call   8002c2 <_panic>
  803bef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bf2:	8b 00                	mov    (%eax),%eax
  803bf4:	85 c0                	test   %eax,%eax
  803bf6:	74 10                	je     803c08 <free_block+0x21c>
  803bf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bfb:	8b 00                	mov    (%eax),%eax
  803bfd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c00:	8b 52 04             	mov    0x4(%edx),%edx
  803c03:	89 50 04             	mov    %edx,0x4(%eax)
  803c06:	eb 14                	jmp    803c1c <free_block+0x230>
  803c08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c0b:	8b 40 04             	mov    0x4(%eax),%eax
  803c0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c11:	c1 e2 04             	shl    $0x4,%edx
  803c14:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803c1a:	89 02                	mov    %eax,(%edx)
  803c1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c1f:	8b 40 04             	mov    0x4(%eax),%eax
  803c22:	85 c0                	test   %eax,%eax
  803c24:	74 0f                	je     803c35 <free_block+0x249>
  803c26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c29:	8b 40 04             	mov    0x4(%eax),%eax
  803c2c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c2f:	8b 12                	mov    (%edx),%edx
  803c31:	89 10                	mov    %edx,(%eax)
  803c33:	eb 13                	jmp    803c48 <free_block+0x25c>
  803c35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c38:	8b 00                	mov    (%eax),%eax
  803c3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c3d:	c1 e2 04             	shl    $0x4,%edx
  803c40:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803c46:	89 02                	mov    %eax,(%edx)
  803c48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c4b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c54:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c5e:	c1 e0 04             	shl    $0x4,%eax
  803c61:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803c66:	8b 00                	mov    (%eax),%eax
  803c68:	8d 50 ff             	lea    -0x1(%eax),%edx
  803c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c6e:	c1 e0 04             	shl    $0x4,%eax
  803c71:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803c76:	89 10                	mov    %edx,(%eax)
			b = next;
  803c78:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  803c7e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803c82:	0f 85 2a ff ff ff    	jne    803bb2 <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  803c88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c8b:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  803c91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c94:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  803c9a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803c9e:	75 17                	jne    803cb7 <free_block+0x2cb>
  803ca0:	83 ec 04             	sub    $0x4,%esp
  803ca3:	68 ac 48 80 00       	push   $0x8048ac
  803ca8:	68 bc 00 00 00       	push   $0xbc
  803cad:	68 a3 47 80 00       	push   $0x8047a3
  803cb2:	e8 0b c6 ff ff       	call   8002c2 <_panic>
  803cb7:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803cbd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cc0:	89 10                	mov    %edx,(%eax)
  803cc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cc5:	8b 00                	mov    (%eax),%eax
  803cc7:	85 c0                	test   %eax,%eax
  803cc9:	74 0d                	je     803cd8 <free_block+0x2ec>
  803ccb:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803cd0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803cd3:	89 50 04             	mov    %edx,0x4(%eax)
  803cd6:	eb 08                	jmp    803ce0 <free_block+0x2f4>
  803cd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cdb:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803ce0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ce3:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803ce8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ceb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cf2:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803cf7:	40                   	inc    %eax
  803cf8:	a3 74 d0 81 00       	mov    %eax,0x81d074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  803cfd:	83 ec 0c             	sub    $0xc,%esp
  803d00:	ff 75 ec             	pushl  -0x14(%ebp)
  803d03:	e8 7e f5 ff ff       	call   803286 <to_page_va>
  803d08:	83 c4 10             	add    $0x10,%esp
  803d0b:	83 ec 0c             	sub    $0xc,%esp
  803d0e:	50                   	push   %eax
  803d0f:	e8 fe d7 ff ff       	call   801512 <return_page>
  803d14:	83 c4 10             	add    $0x10,%esp
	}
}
  803d17:	90                   	nop
  803d18:	c9                   	leave  
  803d19:	c3                   	ret    
  803d1a:	66 90                	xchg   %ax,%ax

00803d1c <__udivdi3>:
  803d1c:	55                   	push   %ebp
  803d1d:	57                   	push   %edi
  803d1e:	56                   	push   %esi
  803d1f:	53                   	push   %ebx
  803d20:	83 ec 1c             	sub    $0x1c,%esp
  803d23:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803d27:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803d2b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d2f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803d33:	89 ca                	mov    %ecx,%edx
  803d35:	89 f8                	mov    %edi,%eax
  803d37:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803d3b:	85 f6                	test   %esi,%esi
  803d3d:	75 2d                	jne    803d6c <__udivdi3+0x50>
  803d3f:	39 cf                	cmp    %ecx,%edi
  803d41:	77 65                	ja     803da8 <__udivdi3+0x8c>
  803d43:	89 fd                	mov    %edi,%ebp
  803d45:	85 ff                	test   %edi,%edi
  803d47:	75 0b                	jne    803d54 <__udivdi3+0x38>
  803d49:	b8 01 00 00 00       	mov    $0x1,%eax
  803d4e:	31 d2                	xor    %edx,%edx
  803d50:	f7 f7                	div    %edi
  803d52:	89 c5                	mov    %eax,%ebp
  803d54:	31 d2                	xor    %edx,%edx
  803d56:	89 c8                	mov    %ecx,%eax
  803d58:	f7 f5                	div    %ebp
  803d5a:	89 c1                	mov    %eax,%ecx
  803d5c:	89 d8                	mov    %ebx,%eax
  803d5e:	f7 f5                	div    %ebp
  803d60:	89 cf                	mov    %ecx,%edi
  803d62:	89 fa                	mov    %edi,%edx
  803d64:	83 c4 1c             	add    $0x1c,%esp
  803d67:	5b                   	pop    %ebx
  803d68:	5e                   	pop    %esi
  803d69:	5f                   	pop    %edi
  803d6a:	5d                   	pop    %ebp
  803d6b:	c3                   	ret    
  803d6c:	39 ce                	cmp    %ecx,%esi
  803d6e:	77 28                	ja     803d98 <__udivdi3+0x7c>
  803d70:	0f bd fe             	bsr    %esi,%edi
  803d73:	83 f7 1f             	xor    $0x1f,%edi
  803d76:	75 40                	jne    803db8 <__udivdi3+0x9c>
  803d78:	39 ce                	cmp    %ecx,%esi
  803d7a:	72 0a                	jb     803d86 <__udivdi3+0x6a>
  803d7c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803d80:	0f 87 9e 00 00 00    	ja     803e24 <__udivdi3+0x108>
  803d86:	b8 01 00 00 00       	mov    $0x1,%eax
  803d8b:	89 fa                	mov    %edi,%edx
  803d8d:	83 c4 1c             	add    $0x1c,%esp
  803d90:	5b                   	pop    %ebx
  803d91:	5e                   	pop    %esi
  803d92:	5f                   	pop    %edi
  803d93:	5d                   	pop    %ebp
  803d94:	c3                   	ret    
  803d95:	8d 76 00             	lea    0x0(%esi),%esi
  803d98:	31 ff                	xor    %edi,%edi
  803d9a:	31 c0                	xor    %eax,%eax
  803d9c:	89 fa                	mov    %edi,%edx
  803d9e:	83 c4 1c             	add    $0x1c,%esp
  803da1:	5b                   	pop    %ebx
  803da2:	5e                   	pop    %esi
  803da3:	5f                   	pop    %edi
  803da4:	5d                   	pop    %ebp
  803da5:	c3                   	ret    
  803da6:	66 90                	xchg   %ax,%ax
  803da8:	89 d8                	mov    %ebx,%eax
  803daa:	f7 f7                	div    %edi
  803dac:	31 ff                	xor    %edi,%edi
  803dae:	89 fa                	mov    %edi,%edx
  803db0:	83 c4 1c             	add    $0x1c,%esp
  803db3:	5b                   	pop    %ebx
  803db4:	5e                   	pop    %esi
  803db5:	5f                   	pop    %edi
  803db6:	5d                   	pop    %ebp
  803db7:	c3                   	ret    
  803db8:	bd 20 00 00 00       	mov    $0x20,%ebp
  803dbd:	89 eb                	mov    %ebp,%ebx
  803dbf:	29 fb                	sub    %edi,%ebx
  803dc1:	89 f9                	mov    %edi,%ecx
  803dc3:	d3 e6                	shl    %cl,%esi
  803dc5:	89 c5                	mov    %eax,%ebp
  803dc7:	88 d9                	mov    %bl,%cl
  803dc9:	d3 ed                	shr    %cl,%ebp
  803dcb:	89 e9                	mov    %ebp,%ecx
  803dcd:	09 f1                	or     %esi,%ecx
  803dcf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803dd3:	89 f9                	mov    %edi,%ecx
  803dd5:	d3 e0                	shl    %cl,%eax
  803dd7:	89 c5                	mov    %eax,%ebp
  803dd9:	89 d6                	mov    %edx,%esi
  803ddb:	88 d9                	mov    %bl,%cl
  803ddd:	d3 ee                	shr    %cl,%esi
  803ddf:	89 f9                	mov    %edi,%ecx
  803de1:	d3 e2                	shl    %cl,%edx
  803de3:	8b 44 24 08          	mov    0x8(%esp),%eax
  803de7:	88 d9                	mov    %bl,%cl
  803de9:	d3 e8                	shr    %cl,%eax
  803deb:	09 c2                	or     %eax,%edx
  803ded:	89 d0                	mov    %edx,%eax
  803def:	89 f2                	mov    %esi,%edx
  803df1:	f7 74 24 0c          	divl   0xc(%esp)
  803df5:	89 d6                	mov    %edx,%esi
  803df7:	89 c3                	mov    %eax,%ebx
  803df9:	f7 e5                	mul    %ebp
  803dfb:	39 d6                	cmp    %edx,%esi
  803dfd:	72 19                	jb     803e18 <__udivdi3+0xfc>
  803dff:	74 0b                	je     803e0c <__udivdi3+0xf0>
  803e01:	89 d8                	mov    %ebx,%eax
  803e03:	31 ff                	xor    %edi,%edi
  803e05:	e9 58 ff ff ff       	jmp    803d62 <__udivdi3+0x46>
  803e0a:	66 90                	xchg   %ax,%ax
  803e0c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803e10:	89 f9                	mov    %edi,%ecx
  803e12:	d3 e2                	shl    %cl,%edx
  803e14:	39 c2                	cmp    %eax,%edx
  803e16:	73 e9                	jae    803e01 <__udivdi3+0xe5>
  803e18:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803e1b:	31 ff                	xor    %edi,%edi
  803e1d:	e9 40 ff ff ff       	jmp    803d62 <__udivdi3+0x46>
  803e22:	66 90                	xchg   %ax,%ax
  803e24:	31 c0                	xor    %eax,%eax
  803e26:	e9 37 ff ff ff       	jmp    803d62 <__udivdi3+0x46>
  803e2b:	90                   	nop

00803e2c <__umoddi3>:
  803e2c:	55                   	push   %ebp
  803e2d:	57                   	push   %edi
  803e2e:	56                   	push   %esi
  803e2f:	53                   	push   %ebx
  803e30:	83 ec 1c             	sub    $0x1c,%esp
  803e33:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803e37:	8b 74 24 34          	mov    0x34(%esp),%esi
  803e3b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803e3f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803e43:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803e47:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803e4b:	89 f3                	mov    %esi,%ebx
  803e4d:	89 fa                	mov    %edi,%edx
  803e4f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e53:	89 34 24             	mov    %esi,(%esp)
  803e56:	85 c0                	test   %eax,%eax
  803e58:	75 1a                	jne    803e74 <__umoddi3+0x48>
  803e5a:	39 f7                	cmp    %esi,%edi
  803e5c:	0f 86 a2 00 00 00    	jbe    803f04 <__umoddi3+0xd8>
  803e62:	89 c8                	mov    %ecx,%eax
  803e64:	89 f2                	mov    %esi,%edx
  803e66:	f7 f7                	div    %edi
  803e68:	89 d0                	mov    %edx,%eax
  803e6a:	31 d2                	xor    %edx,%edx
  803e6c:	83 c4 1c             	add    $0x1c,%esp
  803e6f:	5b                   	pop    %ebx
  803e70:	5e                   	pop    %esi
  803e71:	5f                   	pop    %edi
  803e72:	5d                   	pop    %ebp
  803e73:	c3                   	ret    
  803e74:	39 f0                	cmp    %esi,%eax
  803e76:	0f 87 ac 00 00 00    	ja     803f28 <__umoddi3+0xfc>
  803e7c:	0f bd e8             	bsr    %eax,%ebp
  803e7f:	83 f5 1f             	xor    $0x1f,%ebp
  803e82:	0f 84 ac 00 00 00    	je     803f34 <__umoddi3+0x108>
  803e88:	bf 20 00 00 00       	mov    $0x20,%edi
  803e8d:	29 ef                	sub    %ebp,%edi
  803e8f:	89 fe                	mov    %edi,%esi
  803e91:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803e95:	89 e9                	mov    %ebp,%ecx
  803e97:	d3 e0                	shl    %cl,%eax
  803e99:	89 d7                	mov    %edx,%edi
  803e9b:	89 f1                	mov    %esi,%ecx
  803e9d:	d3 ef                	shr    %cl,%edi
  803e9f:	09 c7                	or     %eax,%edi
  803ea1:	89 e9                	mov    %ebp,%ecx
  803ea3:	d3 e2                	shl    %cl,%edx
  803ea5:	89 14 24             	mov    %edx,(%esp)
  803ea8:	89 d8                	mov    %ebx,%eax
  803eaa:	d3 e0                	shl    %cl,%eax
  803eac:	89 c2                	mov    %eax,%edx
  803eae:	8b 44 24 08          	mov    0x8(%esp),%eax
  803eb2:	d3 e0                	shl    %cl,%eax
  803eb4:	89 44 24 04          	mov    %eax,0x4(%esp)
  803eb8:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ebc:	89 f1                	mov    %esi,%ecx
  803ebe:	d3 e8                	shr    %cl,%eax
  803ec0:	09 d0                	or     %edx,%eax
  803ec2:	d3 eb                	shr    %cl,%ebx
  803ec4:	89 da                	mov    %ebx,%edx
  803ec6:	f7 f7                	div    %edi
  803ec8:	89 d3                	mov    %edx,%ebx
  803eca:	f7 24 24             	mull   (%esp)
  803ecd:	89 c6                	mov    %eax,%esi
  803ecf:	89 d1                	mov    %edx,%ecx
  803ed1:	39 d3                	cmp    %edx,%ebx
  803ed3:	0f 82 87 00 00 00    	jb     803f60 <__umoddi3+0x134>
  803ed9:	0f 84 91 00 00 00    	je     803f70 <__umoddi3+0x144>
  803edf:	8b 54 24 04          	mov    0x4(%esp),%edx
  803ee3:	29 f2                	sub    %esi,%edx
  803ee5:	19 cb                	sbb    %ecx,%ebx
  803ee7:	89 d8                	mov    %ebx,%eax
  803ee9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803eed:	d3 e0                	shl    %cl,%eax
  803eef:	89 e9                	mov    %ebp,%ecx
  803ef1:	d3 ea                	shr    %cl,%edx
  803ef3:	09 d0                	or     %edx,%eax
  803ef5:	89 e9                	mov    %ebp,%ecx
  803ef7:	d3 eb                	shr    %cl,%ebx
  803ef9:	89 da                	mov    %ebx,%edx
  803efb:	83 c4 1c             	add    $0x1c,%esp
  803efe:	5b                   	pop    %ebx
  803eff:	5e                   	pop    %esi
  803f00:	5f                   	pop    %edi
  803f01:	5d                   	pop    %ebp
  803f02:	c3                   	ret    
  803f03:	90                   	nop
  803f04:	89 fd                	mov    %edi,%ebp
  803f06:	85 ff                	test   %edi,%edi
  803f08:	75 0b                	jne    803f15 <__umoddi3+0xe9>
  803f0a:	b8 01 00 00 00       	mov    $0x1,%eax
  803f0f:	31 d2                	xor    %edx,%edx
  803f11:	f7 f7                	div    %edi
  803f13:	89 c5                	mov    %eax,%ebp
  803f15:	89 f0                	mov    %esi,%eax
  803f17:	31 d2                	xor    %edx,%edx
  803f19:	f7 f5                	div    %ebp
  803f1b:	89 c8                	mov    %ecx,%eax
  803f1d:	f7 f5                	div    %ebp
  803f1f:	89 d0                	mov    %edx,%eax
  803f21:	e9 44 ff ff ff       	jmp    803e6a <__umoddi3+0x3e>
  803f26:	66 90                	xchg   %ax,%ax
  803f28:	89 c8                	mov    %ecx,%eax
  803f2a:	89 f2                	mov    %esi,%edx
  803f2c:	83 c4 1c             	add    $0x1c,%esp
  803f2f:	5b                   	pop    %ebx
  803f30:	5e                   	pop    %esi
  803f31:	5f                   	pop    %edi
  803f32:	5d                   	pop    %ebp
  803f33:	c3                   	ret    
  803f34:	3b 04 24             	cmp    (%esp),%eax
  803f37:	72 06                	jb     803f3f <__umoddi3+0x113>
  803f39:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803f3d:	77 0f                	ja     803f4e <__umoddi3+0x122>
  803f3f:	89 f2                	mov    %esi,%edx
  803f41:	29 f9                	sub    %edi,%ecx
  803f43:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803f47:	89 14 24             	mov    %edx,(%esp)
  803f4a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803f4e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803f52:	8b 14 24             	mov    (%esp),%edx
  803f55:	83 c4 1c             	add    $0x1c,%esp
  803f58:	5b                   	pop    %ebx
  803f59:	5e                   	pop    %esi
  803f5a:	5f                   	pop    %edi
  803f5b:	5d                   	pop    %ebp
  803f5c:	c3                   	ret    
  803f5d:	8d 76 00             	lea    0x0(%esi),%esi
  803f60:	2b 04 24             	sub    (%esp),%eax
  803f63:	19 fa                	sbb    %edi,%edx
  803f65:	89 d1                	mov    %edx,%ecx
  803f67:	89 c6                	mov    %eax,%esi
  803f69:	e9 71 ff ff ff       	jmp    803edf <__umoddi3+0xb3>
  803f6e:	66 90                	xchg   %ax,%ax
  803f70:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803f74:	72 ea                	jb     803f60 <__umoddi3+0x134>
  803f76:	89 d9                	mov    %ebx,%ecx
  803f78:	e9 62 ff ff ff       	jmp    803edf <__umoddi3+0xb3>
