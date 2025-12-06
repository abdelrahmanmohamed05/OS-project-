
obj/user/ef_tst_sharing_5_slaveB1:     file format elf32-i386


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
  800031:	e8 0c 01 00 00       	call   800142 <libmain>
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
  80003b:	83 ec 18             	sub    $0x18,%esp
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
  800065:	68 80 40 80 00       	push   $0x804080
  80006a:	6a 0f                	push   $0xf
  80006c:	68 9c 40 80 00       	push   $0x80409c
  800071:	e8 7c 02 00 00       	call   8002f2 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  800076:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)
	uint32 *x, *y, *z ;
	int freeFrames, diff, expected;

	x = sget(sys_getparentenvid(),"x");
  80007d:	e8 8a 2f 00 00       	call   80300c <sys_getparentenvid>
  800082:	83 ec 08             	sub    $0x8,%esp
  800085:	68 bc 40 80 00       	push   $0x8040bc
  80008a:	50                   	push   %eax
  80008b:	e8 b9 1f 00 00       	call   802049 <sget>
  800090:	83 c4 10             	add    $0x10,%esp
  800093:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("Slave B1 env used x (getSharedObject)\n");
  800096:	83 ec 0c             	sub    $0xc,%esp
  800099:	68 c0 40 80 00       	push   $0x8040c0
  80009e:	e8 1d 05 00 00       	call   8005c0 <cprintf>
  8000a3:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's successfully got x
	inctst();
  8000a6:	e8 86 30 00 00       	call   803131 <inctst>
	cprintf("Slave B1 please be patient ...\n");
  8000ab:	83 ec 0c             	sub    $0xc,%esp
  8000ae:	68 e8 40 80 00       	push   $0x8040e8
  8000b3:	e8 08 05 00 00       	call   8005c0 <cprintf>
  8000b8:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z and be completed.
	env_sleep(6000);
  8000bb:	83 ec 0c             	sub    $0xc,%esp
  8000be:	68 70 17 00 00       	push   $0x1770
  8000c3:	e8 82 3c 00 00       	call   803d4a <env_sleep>
  8000c8:	83 c4 10             	add    $0x10,%esp
	while (gettst()!=4) ;// panic("test failed");
  8000cb:	90                   	nop
  8000cc:	e8 7a 30 00 00       	call   80314b <gettst>
  8000d1:	83 f8 04             	cmp    $0x4,%eax
  8000d4:	75 f6                	jne    8000cc <_main+0x94>

	freeFrames = sys_calculate_free_frames() ;
  8000d6:	e8 4f 2d 00 00       	call   802e2a <sys_calculate_free_frames>
  8000db:	89 45 ec             	mov    %eax,-0x14(%ebp)

	sfree(x);
  8000de:	83 ec 0c             	sub    $0xc,%esp
  8000e1:	ff 75 f0             	pushl  -0x10(%ebp)
  8000e4:	e8 d3 28 00 00       	call   8029bc <sfree>
  8000e9:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B1 env removed x\n");
  8000ec:	83 ec 0c             	sub    $0xc,%esp
  8000ef:	68 08 41 80 00       	push   $0x804108
  8000f4:	e8 c7 04 00 00       	call   8005c0 <cprintf>
  8000f9:	83 c4 10             	add    $0x10,%esp
	expected = 2+1; /*2pages+1table*/
  8000fc:	c7 45 e8 03 00 00 00 	movl   $0x3,-0x18(%ebp)
	if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("B1 wrong free: frames removed not equal %d !, Expected:\nfrom the env: 1 table and 2 for frames of x\nframes_storage of x: should be cleared now\n", expected);
  800103:	e8 22 2d 00 00       	call   802e2a <sys_calculate_free_frames>
  800108:	89 c2                	mov    %eax,%edx
  80010a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80010d:	29 c2                	sub    %eax,%edx
  80010f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800112:	39 c2                	cmp    %eax,%edx
  800114:	74 14                	je     80012a <_main+0xf2>
  800116:	ff 75 e8             	pushl  -0x18(%ebp)
  800119:	68 20 41 80 00       	push   $0x804120
  80011e:	6a 29                	push   $0x29
  800120:	68 9c 40 80 00       	push   $0x80409c
  800125:	e8 c8 01 00 00       	call   8002f2 <_panic>

	//To indicate that it's completed successfully
	cprintf("SlaveB1 is completed.\n");
  80012a:	83 ec 0c             	sub    $0xc,%esp
  80012d:	68 b0 41 80 00       	push   $0x8041b0
  800132:	e8 89 04 00 00       	call   8005c0 <cprintf>
  800137:	83 c4 10             	add    $0x10,%esp
	inctst();
  80013a:	e8 f2 2f 00 00       	call   803131 <inctst>
	return;
  80013f:	90                   	nop
}
  800140:	c9                   	leave  
  800141:	c3                   	ret    

00800142 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800142:	55                   	push   %ebp
  800143:	89 e5                	mov    %esp,%ebp
  800145:	57                   	push   %edi
  800146:	56                   	push   %esi
  800147:	53                   	push   %ebx
  800148:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80014b:	e8 a3 2e 00 00       	call   802ff3 <sys_getenvindex>
  800150:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800153:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800156:	89 d0                	mov    %edx,%eax
  800158:	c1 e0 03             	shl    $0x3,%eax
  80015b:	01 d0                	add    %edx,%eax
  80015d:	c1 e0 02             	shl    $0x2,%eax
  800160:	01 d0                	add    %edx,%eax
  800162:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800169:	01 d0                	add    %edx,%eax
  80016b:	c1 e0 03             	shl    $0x3,%eax
  80016e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800173:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800178:	a1 20 50 80 00       	mov    0x805020,%eax
  80017d:	8a 40 20             	mov    0x20(%eax),%al
  800180:	84 c0                	test   %al,%al
  800182:	74 0d                	je     800191 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800184:	a1 20 50 80 00       	mov    0x805020,%eax
  800189:	83 c0 20             	add    $0x20,%eax
  80018c:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800191:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800195:	7e 0a                	jle    8001a1 <libmain+0x5f>
		binaryname = argv[0];
  800197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80019a:	8b 00                	mov    (%eax),%eax
  80019c:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  8001a1:	83 ec 08             	sub    $0x8,%esp
  8001a4:	ff 75 0c             	pushl  0xc(%ebp)
  8001a7:	ff 75 08             	pushl  0x8(%ebp)
  8001aa:	e8 89 fe ff ff       	call   800038 <_main>
  8001af:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001b2:	a1 00 50 80 00       	mov    0x805000,%eax
  8001b7:	85 c0                	test   %eax,%eax
  8001b9:	0f 84 01 01 00 00    	je     8002c0 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8001bf:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001c5:	bb c0 42 80 00       	mov    $0x8042c0,%ebx
  8001ca:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001cf:	89 c7                	mov    %eax,%edi
  8001d1:	89 de                	mov    %ebx,%esi
  8001d3:	89 d1                	mov    %edx,%ecx
  8001d5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001d7:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8001da:	b9 56 00 00 00       	mov    $0x56,%ecx
  8001df:	b0 00                	mov    $0x0,%al
  8001e1:	89 d7                	mov    %edx,%edi
  8001e3:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8001e5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8001ec:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8001ef:	83 ec 08             	sub    $0x8,%esp
  8001f2:	50                   	push   %eax
  8001f3:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001f9:	50                   	push   %eax
  8001fa:	e8 2a 30 00 00       	call   803229 <sys_utilities>
  8001ff:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800202:	e8 73 2b 00 00       	call   802d7a <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800207:	83 ec 0c             	sub    $0xc,%esp
  80020a:	68 e0 41 80 00       	push   $0x8041e0
  80020f:	e8 ac 03 00 00       	call   8005c0 <cprintf>
  800214:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800217:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80021a:	85 c0                	test   %eax,%eax
  80021c:	74 18                	je     800236 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80021e:	e8 24 30 00 00       	call   803247 <sys_get_optimal_num_faults>
  800223:	83 ec 08             	sub    $0x8,%esp
  800226:	50                   	push   %eax
  800227:	68 08 42 80 00       	push   $0x804208
  80022c:	e8 8f 03 00 00       	call   8005c0 <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
  800234:	eb 59                	jmp    80028f <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800236:	a1 20 50 80 00       	mov    0x805020,%eax
  80023b:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  800241:	a1 20 50 80 00       	mov    0x805020,%eax
  800246:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80024c:	83 ec 04             	sub    $0x4,%esp
  80024f:	52                   	push   %edx
  800250:	50                   	push   %eax
  800251:	68 2c 42 80 00       	push   $0x80422c
  800256:	e8 65 03 00 00       	call   8005c0 <cprintf>
  80025b:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80025e:	a1 20 50 80 00       	mov    0x805020,%eax
  800263:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  800269:	a1 20 50 80 00       	mov    0x805020,%eax
  80026e:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  800274:	a1 20 50 80 00       	mov    0x805020,%eax
  800279:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80027f:	51                   	push   %ecx
  800280:	52                   	push   %edx
  800281:	50                   	push   %eax
  800282:	68 54 42 80 00       	push   $0x804254
  800287:	e8 34 03 00 00       	call   8005c0 <cprintf>
  80028c:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80028f:	a1 20 50 80 00       	mov    0x805020,%eax
  800294:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  80029a:	83 ec 08             	sub    $0x8,%esp
  80029d:	50                   	push   %eax
  80029e:	68 ac 42 80 00       	push   $0x8042ac
  8002a3:	e8 18 03 00 00       	call   8005c0 <cprintf>
  8002a8:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8002ab:	83 ec 0c             	sub    $0xc,%esp
  8002ae:	68 e0 41 80 00       	push   $0x8041e0
  8002b3:	e8 08 03 00 00       	call   8005c0 <cprintf>
  8002b8:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8002bb:	e8 d4 2a 00 00       	call   802d94 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8002c0:	e8 1f 00 00 00       	call   8002e4 <exit>
}
  8002c5:	90                   	nop
  8002c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c9:	5b                   	pop    %ebx
  8002ca:	5e                   	pop    %esi
  8002cb:	5f                   	pop    %edi
  8002cc:	5d                   	pop    %ebp
  8002cd:	c3                   	ret    

008002ce <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002ce:	55                   	push   %ebp
  8002cf:	89 e5                	mov    %esp,%ebp
  8002d1:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002d4:	83 ec 0c             	sub    $0xc,%esp
  8002d7:	6a 00                	push   $0x0
  8002d9:	e8 e1 2c 00 00       	call   802fbf <sys_destroy_env>
  8002de:	83 c4 10             	add    $0x10,%esp
}
  8002e1:	90                   	nop
  8002e2:	c9                   	leave  
  8002e3:	c3                   	ret    

008002e4 <exit>:

void
exit(void)
{
  8002e4:	55                   	push   %ebp
  8002e5:	89 e5                	mov    %esp,%ebp
  8002e7:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002ea:	e8 36 2d 00 00       	call   803025 <sys_exit_env>
}
  8002ef:	90                   	nop
  8002f0:	c9                   	leave  
  8002f1:	c3                   	ret    

008002f2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002f2:	55                   	push   %ebp
  8002f3:	89 e5                	mov    %esp,%ebp
  8002f5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002f8:	8d 45 10             	lea    0x10(%ebp),%eax
  8002fb:	83 c0 04             	add    $0x4,%eax
  8002fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800301:	a1 38 51 83 00       	mov    0x835138,%eax
  800306:	85 c0                	test   %eax,%eax
  800308:	74 16                	je     800320 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80030a:	a1 38 51 83 00       	mov    0x835138,%eax
  80030f:	83 ec 08             	sub    $0x8,%esp
  800312:	50                   	push   %eax
  800313:	68 24 43 80 00       	push   $0x804324
  800318:	e8 a3 02 00 00       	call   8005c0 <cprintf>
  80031d:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800320:	a1 04 50 80 00       	mov    0x805004,%eax
  800325:	83 ec 0c             	sub    $0xc,%esp
  800328:	ff 75 0c             	pushl  0xc(%ebp)
  80032b:	ff 75 08             	pushl  0x8(%ebp)
  80032e:	50                   	push   %eax
  80032f:	68 2c 43 80 00       	push   $0x80432c
  800334:	6a 74                	push   $0x74
  800336:	e8 b2 02 00 00       	call   8005ed <cprintf_colored>
  80033b:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80033e:	8b 45 10             	mov    0x10(%ebp),%eax
  800341:	83 ec 08             	sub    $0x8,%esp
  800344:	ff 75 f4             	pushl  -0xc(%ebp)
  800347:	50                   	push   %eax
  800348:	e8 04 02 00 00       	call   800551 <vcprintf>
  80034d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800350:	83 ec 08             	sub    $0x8,%esp
  800353:	6a 00                	push   $0x0
  800355:	68 54 43 80 00       	push   $0x804354
  80035a:	e8 f2 01 00 00       	call   800551 <vcprintf>
  80035f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800362:	e8 7d ff ff ff       	call   8002e4 <exit>

	// should not return here
	while (1) ;
  800367:	eb fe                	jmp    800367 <_panic+0x75>

00800369 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800369:	55                   	push   %ebp
  80036a:	89 e5                	mov    %esp,%ebp
  80036c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80036f:	a1 20 50 80 00       	mov    0x805020,%eax
  800374:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80037a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80037d:	39 c2                	cmp    %eax,%edx
  80037f:	74 14                	je     800395 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800381:	83 ec 04             	sub    $0x4,%esp
  800384:	68 58 43 80 00       	push   $0x804358
  800389:	6a 26                	push   $0x26
  80038b:	68 a4 43 80 00       	push   $0x8043a4
  800390:	e8 5d ff ff ff       	call   8002f2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800395:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80039c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003a3:	e9 c5 00 00 00       	jmp    80046d <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8003a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b5:	01 d0                	add    %edx,%eax
  8003b7:	8b 00                	mov    (%eax),%eax
  8003b9:	85 c0                	test   %eax,%eax
  8003bb:	75 08                	jne    8003c5 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8003bd:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003c0:	e9 a5 00 00 00       	jmp    80046a <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8003c5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003cc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003d3:	eb 69                	jmp    80043e <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003d5:	a1 20 50 80 00       	mov    0x805020,%eax
  8003da:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8003e0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003e3:	89 d0                	mov    %edx,%eax
  8003e5:	01 c0                	add    %eax,%eax
  8003e7:	01 d0                	add    %edx,%eax
  8003e9:	c1 e0 03             	shl    $0x3,%eax
  8003ec:	01 c8                	add    %ecx,%eax
  8003ee:	8a 40 04             	mov    0x4(%eax),%al
  8003f1:	84 c0                	test   %al,%al
  8003f3:	75 46                	jne    80043b <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003f5:	a1 20 50 80 00       	mov    0x805020,%eax
  8003fa:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800400:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800403:	89 d0                	mov    %edx,%eax
  800405:	01 c0                	add    %eax,%eax
  800407:	01 d0                	add    %edx,%eax
  800409:	c1 e0 03             	shl    $0x3,%eax
  80040c:	01 c8                	add    %ecx,%eax
  80040e:	8b 00                	mov    (%eax),%eax
  800410:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800413:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800416:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80041b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80041d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800420:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800427:	8b 45 08             	mov    0x8(%ebp),%eax
  80042a:	01 c8                	add    %ecx,%eax
  80042c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80042e:	39 c2                	cmp    %eax,%edx
  800430:	75 09                	jne    80043b <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800432:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800439:	eb 15                	jmp    800450 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80043b:	ff 45 e8             	incl   -0x18(%ebp)
  80043e:	a1 20 50 80 00       	mov    0x805020,%eax
  800443:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800449:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80044c:	39 c2                	cmp    %eax,%edx
  80044e:	77 85                	ja     8003d5 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800450:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800454:	75 14                	jne    80046a <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800456:	83 ec 04             	sub    $0x4,%esp
  800459:	68 b0 43 80 00       	push   $0x8043b0
  80045e:	6a 3a                	push   $0x3a
  800460:	68 a4 43 80 00       	push   $0x8043a4
  800465:	e8 88 fe ff ff       	call   8002f2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80046a:	ff 45 f0             	incl   -0x10(%ebp)
  80046d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800470:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800473:	0f 8c 2f ff ff ff    	jl     8003a8 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800479:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800480:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800487:	eb 26                	jmp    8004af <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800489:	a1 20 50 80 00       	mov    0x805020,%eax
  80048e:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800494:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800497:	89 d0                	mov    %edx,%eax
  800499:	01 c0                	add    %eax,%eax
  80049b:	01 d0                	add    %edx,%eax
  80049d:	c1 e0 03             	shl    $0x3,%eax
  8004a0:	01 c8                	add    %ecx,%eax
  8004a2:	8a 40 04             	mov    0x4(%eax),%al
  8004a5:	3c 01                	cmp    $0x1,%al
  8004a7:	75 03                	jne    8004ac <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8004a9:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004ac:	ff 45 e0             	incl   -0x20(%ebp)
  8004af:	a1 20 50 80 00       	mov    0x805020,%eax
  8004b4:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004bd:	39 c2                	cmp    %eax,%edx
  8004bf:	77 c8                	ja     800489 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004c4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004c7:	74 14                	je     8004dd <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8004c9:	83 ec 04             	sub    $0x4,%esp
  8004cc:	68 04 44 80 00       	push   $0x804404
  8004d1:	6a 44                	push   $0x44
  8004d3:	68 a4 43 80 00       	push   $0x8043a4
  8004d8:	e8 15 fe ff ff       	call   8002f2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004dd:	90                   	nop
  8004de:	c9                   	leave  
  8004df:	c3                   	ret    

008004e0 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8004e0:	55                   	push   %ebp
  8004e1:	89 e5                	mov    %esp,%ebp
  8004e3:	53                   	push   %ebx
  8004e4:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8004e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ea:	8b 00                	mov    (%eax),%eax
  8004ec:	8d 48 01             	lea    0x1(%eax),%ecx
  8004ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004f2:	89 0a                	mov    %ecx,(%edx)
  8004f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8004f7:	88 d1                	mov    %dl,%cl
  8004f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004fc:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800500:	8b 45 0c             	mov    0xc(%ebp),%eax
  800503:	8b 00                	mov    (%eax),%eax
  800505:	3d ff 00 00 00       	cmp    $0xff,%eax
  80050a:	75 30                	jne    80053c <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80050c:	8b 15 3c 51 83 00    	mov    0x83513c,%edx
  800512:	a0 64 d0 81 00       	mov    0x81d064,%al
  800517:	0f b6 c0             	movzbl %al,%eax
  80051a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80051d:	8b 09                	mov    (%ecx),%ecx
  80051f:	89 cb                	mov    %ecx,%ebx
  800521:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800524:	83 c1 08             	add    $0x8,%ecx
  800527:	52                   	push   %edx
  800528:	50                   	push   %eax
  800529:	53                   	push   %ebx
  80052a:	51                   	push   %ecx
  80052b:	e8 06 28 00 00       	call   802d36 <sys_cputs>
  800530:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800533:	8b 45 0c             	mov    0xc(%ebp),%eax
  800536:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80053c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80053f:	8b 40 04             	mov    0x4(%eax),%eax
  800542:	8d 50 01             	lea    0x1(%eax),%edx
  800545:	8b 45 0c             	mov    0xc(%ebp),%eax
  800548:	89 50 04             	mov    %edx,0x4(%eax)
}
  80054b:	90                   	nop
  80054c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80054f:	c9                   	leave  
  800550:	c3                   	ret    

00800551 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800551:	55                   	push   %ebp
  800552:	89 e5                	mov    %esp,%ebp
  800554:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80055a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800561:	00 00 00 
	b.cnt = 0;
  800564:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80056b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80056e:	ff 75 0c             	pushl  0xc(%ebp)
  800571:	ff 75 08             	pushl  0x8(%ebp)
  800574:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80057a:	50                   	push   %eax
  80057b:	68 e0 04 80 00       	push   $0x8004e0
  800580:	e8 5a 02 00 00       	call   8007df <vprintfmt>
  800585:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800588:	8b 15 3c 51 83 00    	mov    0x83513c,%edx
  80058e:	a0 64 d0 81 00       	mov    0x81d064,%al
  800593:	0f b6 c0             	movzbl %al,%eax
  800596:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80059c:	52                   	push   %edx
  80059d:	50                   	push   %eax
  80059e:	51                   	push   %ecx
  80059f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005a5:	83 c0 08             	add    $0x8,%eax
  8005a8:	50                   	push   %eax
  8005a9:	e8 88 27 00 00       	call   802d36 <sys_cputs>
  8005ae:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005b1:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
	return b.cnt;
  8005b8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005be:	c9                   	leave  
  8005bf:	c3                   	ret    

008005c0 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005c0:	55                   	push   %ebp
  8005c1:	89 e5                	mov    %esp,%ebp
  8005c3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005c6:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	va_start(ap, fmt);
  8005cd:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d6:	83 ec 08             	sub    $0x8,%esp
  8005d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8005dc:	50                   	push   %eax
  8005dd:	e8 6f ff ff ff       	call   800551 <vcprintf>
  8005e2:	83 c4 10             	add    $0x10,%esp
  8005e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005eb:	c9                   	leave  
  8005ec:	c3                   	ret    

008005ed <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8005ed:	55                   	push   %ebp
  8005ee:	89 e5                	mov    %esp,%ebp
  8005f0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005f3:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	curTextClr = (textClr << 8) ; //set text color by the given value
  8005fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fd:	c1 e0 08             	shl    $0x8,%eax
  800600:	a3 3c 51 83 00       	mov    %eax,0x83513c
	va_start(ap, fmt);
  800605:	8d 45 0c             	lea    0xc(%ebp),%eax
  800608:	83 c0 04             	add    $0x4,%eax
  80060b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80060e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800611:	83 ec 08             	sub    $0x8,%esp
  800614:	ff 75 f4             	pushl  -0xc(%ebp)
  800617:	50                   	push   %eax
  800618:	e8 34 ff ff ff       	call   800551 <vcprintf>
  80061d:	83 c4 10             	add    $0x10,%esp
  800620:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800623:	c7 05 3c 51 83 00 00 	movl   $0x700,0x83513c
  80062a:	07 00 00 

	return cnt;
  80062d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800630:	c9                   	leave  
  800631:	c3                   	ret    

00800632 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800632:	55                   	push   %ebp
  800633:	89 e5                	mov    %esp,%ebp
  800635:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800638:	e8 3d 27 00 00       	call   802d7a <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80063d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800640:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800643:	8b 45 08             	mov    0x8(%ebp),%eax
  800646:	83 ec 08             	sub    $0x8,%esp
  800649:	ff 75 f4             	pushl  -0xc(%ebp)
  80064c:	50                   	push   %eax
  80064d:	e8 ff fe ff ff       	call   800551 <vcprintf>
  800652:	83 c4 10             	add    $0x10,%esp
  800655:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800658:	e8 37 27 00 00       	call   802d94 <sys_unlock_cons>
	return cnt;
  80065d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800660:	c9                   	leave  
  800661:	c3                   	ret    

00800662 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800662:	55                   	push   %ebp
  800663:	89 e5                	mov    %esp,%ebp
  800665:	53                   	push   %ebx
  800666:	83 ec 14             	sub    $0x14,%esp
  800669:	8b 45 10             	mov    0x10(%ebp),%eax
  80066c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80066f:	8b 45 14             	mov    0x14(%ebp),%eax
  800672:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800675:	8b 45 18             	mov    0x18(%ebp),%eax
  800678:	ba 00 00 00 00       	mov    $0x0,%edx
  80067d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800680:	77 55                	ja     8006d7 <printnum+0x75>
  800682:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800685:	72 05                	jb     80068c <printnum+0x2a>
  800687:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80068a:	77 4b                	ja     8006d7 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80068c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80068f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800692:	8b 45 18             	mov    0x18(%ebp),%eax
  800695:	ba 00 00 00 00       	mov    $0x0,%edx
  80069a:	52                   	push   %edx
  80069b:	50                   	push   %eax
  80069c:	ff 75 f4             	pushl  -0xc(%ebp)
  80069f:	ff 75 f0             	pushl  -0x10(%ebp)
  8006a2:	e8 61 37 00 00       	call   803e08 <__udivdi3>
  8006a7:	83 c4 10             	add    $0x10,%esp
  8006aa:	83 ec 04             	sub    $0x4,%esp
  8006ad:	ff 75 20             	pushl  0x20(%ebp)
  8006b0:	53                   	push   %ebx
  8006b1:	ff 75 18             	pushl  0x18(%ebp)
  8006b4:	52                   	push   %edx
  8006b5:	50                   	push   %eax
  8006b6:	ff 75 0c             	pushl  0xc(%ebp)
  8006b9:	ff 75 08             	pushl  0x8(%ebp)
  8006bc:	e8 a1 ff ff ff       	call   800662 <printnum>
  8006c1:	83 c4 20             	add    $0x20,%esp
  8006c4:	eb 1a                	jmp    8006e0 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006c6:	83 ec 08             	sub    $0x8,%esp
  8006c9:	ff 75 0c             	pushl  0xc(%ebp)
  8006cc:	ff 75 20             	pushl  0x20(%ebp)
  8006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d2:	ff d0                	call   *%eax
  8006d4:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006d7:	ff 4d 1c             	decl   0x1c(%ebp)
  8006da:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006de:	7f e6                	jg     8006c6 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006e0:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006e3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006ee:	53                   	push   %ebx
  8006ef:	51                   	push   %ecx
  8006f0:	52                   	push   %edx
  8006f1:	50                   	push   %eax
  8006f2:	e8 21 38 00 00       	call   803f18 <__umoddi3>
  8006f7:	83 c4 10             	add    $0x10,%esp
  8006fa:	05 74 46 80 00       	add    $0x804674,%eax
  8006ff:	8a 00                	mov    (%eax),%al
  800701:	0f be c0             	movsbl %al,%eax
  800704:	83 ec 08             	sub    $0x8,%esp
  800707:	ff 75 0c             	pushl  0xc(%ebp)
  80070a:	50                   	push   %eax
  80070b:	8b 45 08             	mov    0x8(%ebp),%eax
  80070e:	ff d0                	call   *%eax
  800710:	83 c4 10             	add    $0x10,%esp
}
  800713:	90                   	nop
  800714:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800717:	c9                   	leave  
  800718:	c3                   	ret    

00800719 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800719:	55                   	push   %ebp
  80071a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80071c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800720:	7e 1c                	jle    80073e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800722:	8b 45 08             	mov    0x8(%ebp),%eax
  800725:	8b 00                	mov    (%eax),%eax
  800727:	8d 50 08             	lea    0x8(%eax),%edx
  80072a:	8b 45 08             	mov    0x8(%ebp),%eax
  80072d:	89 10                	mov    %edx,(%eax)
  80072f:	8b 45 08             	mov    0x8(%ebp),%eax
  800732:	8b 00                	mov    (%eax),%eax
  800734:	83 e8 08             	sub    $0x8,%eax
  800737:	8b 50 04             	mov    0x4(%eax),%edx
  80073a:	8b 00                	mov    (%eax),%eax
  80073c:	eb 40                	jmp    80077e <getuint+0x65>
	else if (lflag)
  80073e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800742:	74 1e                	je     800762 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800744:	8b 45 08             	mov    0x8(%ebp),%eax
  800747:	8b 00                	mov    (%eax),%eax
  800749:	8d 50 04             	lea    0x4(%eax),%edx
  80074c:	8b 45 08             	mov    0x8(%ebp),%eax
  80074f:	89 10                	mov    %edx,(%eax)
  800751:	8b 45 08             	mov    0x8(%ebp),%eax
  800754:	8b 00                	mov    (%eax),%eax
  800756:	83 e8 04             	sub    $0x4,%eax
  800759:	8b 00                	mov    (%eax),%eax
  80075b:	ba 00 00 00 00       	mov    $0x0,%edx
  800760:	eb 1c                	jmp    80077e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800762:	8b 45 08             	mov    0x8(%ebp),%eax
  800765:	8b 00                	mov    (%eax),%eax
  800767:	8d 50 04             	lea    0x4(%eax),%edx
  80076a:	8b 45 08             	mov    0x8(%ebp),%eax
  80076d:	89 10                	mov    %edx,(%eax)
  80076f:	8b 45 08             	mov    0x8(%ebp),%eax
  800772:	8b 00                	mov    (%eax),%eax
  800774:	83 e8 04             	sub    $0x4,%eax
  800777:	8b 00                	mov    (%eax),%eax
  800779:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80077e:	5d                   	pop    %ebp
  80077f:	c3                   	ret    

00800780 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800780:	55                   	push   %ebp
  800781:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800783:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800787:	7e 1c                	jle    8007a5 <getint+0x25>
		return va_arg(*ap, long long);
  800789:	8b 45 08             	mov    0x8(%ebp),%eax
  80078c:	8b 00                	mov    (%eax),%eax
  80078e:	8d 50 08             	lea    0x8(%eax),%edx
  800791:	8b 45 08             	mov    0x8(%ebp),%eax
  800794:	89 10                	mov    %edx,(%eax)
  800796:	8b 45 08             	mov    0x8(%ebp),%eax
  800799:	8b 00                	mov    (%eax),%eax
  80079b:	83 e8 08             	sub    $0x8,%eax
  80079e:	8b 50 04             	mov    0x4(%eax),%edx
  8007a1:	8b 00                	mov    (%eax),%eax
  8007a3:	eb 38                	jmp    8007dd <getint+0x5d>
	else if (lflag)
  8007a5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007a9:	74 1a                	je     8007c5 <getint+0x45>
		return va_arg(*ap, long);
  8007ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ae:	8b 00                	mov    (%eax),%eax
  8007b0:	8d 50 04             	lea    0x4(%eax),%edx
  8007b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b6:	89 10                	mov    %edx,(%eax)
  8007b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bb:	8b 00                	mov    (%eax),%eax
  8007bd:	83 e8 04             	sub    $0x4,%eax
  8007c0:	8b 00                	mov    (%eax),%eax
  8007c2:	99                   	cltd   
  8007c3:	eb 18                	jmp    8007dd <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c8:	8b 00                	mov    (%eax),%eax
  8007ca:	8d 50 04             	lea    0x4(%eax),%edx
  8007cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d0:	89 10                	mov    %edx,(%eax)
  8007d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d5:	8b 00                	mov    (%eax),%eax
  8007d7:	83 e8 04             	sub    $0x4,%eax
  8007da:	8b 00                	mov    (%eax),%eax
  8007dc:	99                   	cltd   
}
  8007dd:	5d                   	pop    %ebp
  8007de:	c3                   	ret    

008007df <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007df:	55                   	push   %ebp
  8007e0:	89 e5                	mov    %esp,%ebp
  8007e2:	56                   	push   %esi
  8007e3:	53                   	push   %ebx
  8007e4:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007e7:	eb 17                	jmp    800800 <vprintfmt+0x21>
			if (ch == '\0')
  8007e9:	85 db                	test   %ebx,%ebx
  8007eb:	0f 84 c1 03 00 00    	je     800bb2 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007f1:	83 ec 08             	sub    $0x8,%esp
  8007f4:	ff 75 0c             	pushl  0xc(%ebp)
  8007f7:	53                   	push   %ebx
  8007f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fb:	ff d0                	call   *%eax
  8007fd:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800800:	8b 45 10             	mov    0x10(%ebp),%eax
  800803:	8d 50 01             	lea    0x1(%eax),%edx
  800806:	89 55 10             	mov    %edx,0x10(%ebp)
  800809:	8a 00                	mov    (%eax),%al
  80080b:	0f b6 d8             	movzbl %al,%ebx
  80080e:	83 fb 25             	cmp    $0x25,%ebx
  800811:	75 d6                	jne    8007e9 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800813:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800817:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80081e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800825:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80082c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800833:	8b 45 10             	mov    0x10(%ebp),%eax
  800836:	8d 50 01             	lea    0x1(%eax),%edx
  800839:	89 55 10             	mov    %edx,0x10(%ebp)
  80083c:	8a 00                	mov    (%eax),%al
  80083e:	0f b6 d8             	movzbl %al,%ebx
  800841:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800844:	83 f8 5b             	cmp    $0x5b,%eax
  800847:	0f 87 3d 03 00 00    	ja     800b8a <vprintfmt+0x3ab>
  80084d:	8b 04 85 98 46 80 00 	mov    0x804698(,%eax,4),%eax
  800854:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800856:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80085a:	eb d7                	jmp    800833 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80085c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800860:	eb d1                	jmp    800833 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800862:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800869:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80086c:	89 d0                	mov    %edx,%eax
  80086e:	c1 e0 02             	shl    $0x2,%eax
  800871:	01 d0                	add    %edx,%eax
  800873:	01 c0                	add    %eax,%eax
  800875:	01 d8                	add    %ebx,%eax
  800877:	83 e8 30             	sub    $0x30,%eax
  80087a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80087d:	8b 45 10             	mov    0x10(%ebp),%eax
  800880:	8a 00                	mov    (%eax),%al
  800882:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800885:	83 fb 2f             	cmp    $0x2f,%ebx
  800888:	7e 3e                	jle    8008c8 <vprintfmt+0xe9>
  80088a:	83 fb 39             	cmp    $0x39,%ebx
  80088d:	7f 39                	jg     8008c8 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80088f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800892:	eb d5                	jmp    800869 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800894:	8b 45 14             	mov    0x14(%ebp),%eax
  800897:	83 c0 04             	add    $0x4,%eax
  80089a:	89 45 14             	mov    %eax,0x14(%ebp)
  80089d:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a0:	83 e8 04             	sub    $0x4,%eax
  8008a3:	8b 00                	mov    (%eax),%eax
  8008a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008a8:	eb 1f                	jmp    8008c9 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008aa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ae:	79 83                	jns    800833 <vprintfmt+0x54>
				width = 0;
  8008b0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008b7:	e9 77 ff ff ff       	jmp    800833 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008bc:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008c3:	e9 6b ff ff ff       	jmp    800833 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008c8:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008c9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008cd:	0f 89 60 ff ff ff    	jns    800833 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008d9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008e0:	e9 4e ff ff ff       	jmp    800833 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008e5:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008e8:	e9 46 ff ff ff       	jmp    800833 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f0:	83 c0 04             	add    $0x4,%eax
  8008f3:	89 45 14             	mov    %eax,0x14(%ebp)
  8008f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f9:	83 e8 04             	sub    $0x4,%eax
  8008fc:	8b 00                	mov    (%eax),%eax
  8008fe:	83 ec 08             	sub    $0x8,%esp
  800901:	ff 75 0c             	pushl  0xc(%ebp)
  800904:	50                   	push   %eax
  800905:	8b 45 08             	mov    0x8(%ebp),%eax
  800908:	ff d0                	call   *%eax
  80090a:	83 c4 10             	add    $0x10,%esp
			break;
  80090d:	e9 9b 02 00 00       	jmp    800bad <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800912:	8b 45 14             	mov    0x14(%ebp),%eax
  800915:	83 c0 04             	add    $0x4,%eax
  800918:	89 45 14             	mov    %eax,0x14(%ebp)
  80091b:	8b 45 14             	mov    0x14(%ebp),%eax
  80091e:	83 e8 04             	sub    $0x4,%eax
  800921:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800923:	85 db                	test   %ebx,%ebx
  800925:	79 02                	jns    800929 <vprintfmt+0x14a>
				err = -err;
  800927:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800929:	83 fb 64             	cmp    $0x64,%ebx
  80092c:	7f 0b                	jg     800939 <vprintfmt+0x15a>
  80092e:	8b 34 9d e0 44 80 00 	mov    0x8044e0(,%ebx,4),%esi
  800935:	85 f6                	test   %esi,%esi
  800937:	75 19                	jne    800952 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800939:	53                   	push   %ebx
  80093a:	68 85 46 80 00       	push   $0x804685
  80093f:	ff 75 0c             	pushl  0xc(%ebp)
  800942:	ff 75 08             	pushl  0x8(%ebp)
  800945:	e8 70 02 00 00       	call   800bba <printfmt>
  80094a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80094d:	e9 5b 02 00 00       	jmp    800bad <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800952:	56                   	push   %esi
  800953:	68 8e 46 80 00       	push   $0x80468e
  800958:	ff 75 0c             	pushl  0xc(%ebp)
  80095b:	ff 75 08             	pushl  0x8(%ebp)
  80095e:	e8 57 02 00 00       	call   800bba <printfmt>
  800963:	83 c4 10             	add    $0x10,%esp
			break;
  800966:	e9 42 02 00 00       	jmp    800bad <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80096b:	8b 45 14             	mov    0x14(%ebp),%eax
  80096e:	83 c0 04             	add    $0x4,%eax
  800971:	89 45 14             	mov    %eax,0x14(%ebp)
  800974:	8b 45 14             	mov    0x14(%ebp),%eax
  800977:	83 e8 04             	sub    $0x4,%eax
  80097a:	8b 30                	mov    (%eax),%esi
  80097c:	85 f6                	test   %esi,%esi
  80097e:	75 05                	jne    800985 <vprintfmt+0x1a6>
				p = "(null)";
  800980:	be 91 46 80 00       	mov    $0x804691,%esi
			if (width > 0 && padc != '-')
  800985:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800989:	7e 6d                	jle    8009f8 <vprintfmt+0x219>
  80098b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80098f:	74 67                	je     8009f8 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800991:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800994:	83 ec 08             	sub    $0x8,%esp
  800997:	50                   	push   %eax
  800998:	56                   	push   %esi
  800999:	e8 1e 03 00 00       	call   800cbc <strnlen>
  80099e:	83 c4 10             	add    $0x10,%esp
  8009a1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009a4:	eb 16                	jmp    8009bc <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009a6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009aa:	83 ec 08             	sub    $0x8,%esp
  8009ad:	ff 75 0c             	pushl  0xc(%ebp)
  8009b0:	50                   	push   %eax
  8009b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b4:	ff d0                	call   *%eax
  8009b6:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009b9:	ff 4d e4             	decl   -0x1c(%ebp)
  8009bc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009c0:	7f e4                	jg     8009a6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009c2:	eb 34                	jmp    8009f8 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009c4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009c8:	74 1c                	je     8009e6 <vprintfmt+0x207>
  8009ca:	83 fb 1f             	cmp    $0x1f,%ebx
  8009cd:	7e 05                	jle    8009d4 <vprintfmt+0x1f5>
  8009cf:	83 fb 7e             	cmp    $0x7e,%ebx
  8009d2:	7e 12                	jle    8009e6 <vprintfmt+0x207>
					putch('?', putdat);
  8009d4:	83 ec 08             	sub    $0x8,%esp
  8009d7:	ff 75 0c             	pushl  0xc(%ebp)
  8009da:	6a 3f                	push   $0x3f
  8009dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009df:	ff d0                	call   *%eax
  8009e1:	83 c4 10             	add    $0x10,%esp
  8009e4:	eb 0f                	jmp    8009f5 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009e6:	83 ec 08             	sub    $0x8,%esp
  8009e9:	ff 75 0c             	pushl  0xc(%ebp)
  8009ec:	53                   	push   %ebx
  8009ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f0:	ff d0                	call   *%eax
  8009f2:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009f5:	ff 4d e4             	decl   -0x1c(%ebp)
  8009f8:	89 f0                	mov    %esi,%eax
  8009fa:	8d 70 01             	lea    0x1(%eax),%esi
  8009fd:	8a 00                	mov    (%eax),%al
  8009ff:	0f be d8             	movsbl %al,%ebx
  800a02:	85 db                	test   %ebx,%ebx
  800a04:	74 24                	je     800a2a <vprintfmt+0x24b>
  800a06:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a0a:	78 b8                	js     8009c4 <vprintfmt+0x1e5>
  800a0c:	ff 4d e0             	decl   -0x20(%ebp)
  800a0f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a13:	79 af                	jns    8009c4 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a15:	eb 13                	jmp    800a2a <vprintfmt+0x24b>
				putch(' ', putdat);
  800a17:	83 ec 08             	sub    $0x8,%esp
  800a1a:	ff 75 0c             	pushl  0xc(%ebp)
  800a1d:	6a 20                	push   $0x20
  800a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a22:	ff d0                	call   *%eax
  800a24:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a27:	ff 4d e4             	decl   -0x1c(%ebp)
  800a2a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a2e:	7f e7                	jg     800a17 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a30:	e9 78 01 00 00       	jmp    800bad <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a35:	83 ec 08             	sub    $0x8,%esp
  800a38:	ff 75 e8             	pushl  -0x18(%ebp)
  800a3b:	8d 45 14             	lea    0x14(%ebp),%eax
  800a3e:	50                   	push   %eax
  800a3f:	e8 3c fd ff ff       	call   800780 <getint>
  800a44:	83 c4 10             	add    $0x10,%esp
  800a47:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a4a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a53:	85 d2                	test   %edx,%edx
  800a55:	79 23                	jns    800a7a <vprintfmt+0x29b>
				putch('-', putdat);
  800a57:	83 ec 08             	sub    $0x8,%esp
  800a5a:	ff 75 0c             	pushl  0xc(%ebp)
  800a5d:	6a 2d                	push   $0x2d
  800a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a62:	ff d0                	call   *%eax
  800a64:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a6d:	f7 d8                	neg    %eax
  800a6f:	83 d2 00             	adc    $0x0,%edx
  800a72:	f7 da                	neg    %edx
  800a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a77:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a7a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a81:	e9 bc 00 00 00       	jmp    800b42 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a86:	83 ec 08             	sub    $0x8,%esp
  800a89:	ff 75 e8             	pushl  -0x18(%ebp)
  800a8c:	8d 45 14             	lea    0x14(%ebp),%eax
  800a8f:	50                   	push   %eax
  800a90:	e8 84 fc ff ff       	call   800719 <getuint>
  800a95:	83 c4 10             	add    $0x10,%esp
  800a98:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a9b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a9e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800aa5:	e9 98 00 00 00       	jmp    800b42 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800aaa:	83 ec 08             	sub    $0x8,%esp
  800aad:	ff 75 0c             	pushl  0xc(%ebp)
  800ab0:	6a 58                	push   $0x58
  800ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab5:	ff d0                	call   *%eax
  800ab7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800aba:	83 ec 08             	sub    $0x8,%esp
  800abd:	ff 75 0c             	pushl  0xc(%ebp)
  800ac0:	6a 58                	push   $0x58
  800ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac5:	ff d0                	call   *%eax
  800ac7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800aca:	83 ec 08             	sub    $0x8,%esp
  800acd:	ff 75 0c             	pushl  0xc(%ebp)
  800ad0:	6a 58                	push   $0x58
  800ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad5:	ff d0                	call   *%eax
  800ad7:	83 c4 10             	add    $0x10,%esp
			break;
  800ada:	e9 ce 00 00 00       	jmp    800bad <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800adf:	83 ec 08             	sub    $0x8,%esp
  800ae2:	ff 75 0c             	pushl  0xc(%ebp)
  800ae5:	6a 30                	push   $0x30
  800ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aea:	ff d0                	call   *%eax
  800aec:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800aef:	83 ec 08             	sub    $0x8,%esp
  800af2:	ff 75 0c             	pushl  0xc(%ebp)
  800af5:	6a 78                	push   $0x78
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	ff d0                	call   *%eax
  800afc:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800aff:	8b 45 14             	mov    0x14(%ebp),%eax
  800b02:	83 c0 04             	add    $0x4,%eax
  800b05:	89 45 14             	mov    %eax,0x14(%ebp)
  800b08:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0b:	83 e8 04             	sub    $0x4,%eax
  800b0e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b10:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b13:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b1a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b21:	eb 1f                	jmp    800b42 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b23:	83 ec 08             	sub    $0x8,%esp
  800b26:	ff 75 e8             	pushl  -0x18(%ebp)
  800b29:	8d 45 14             	lea    0x14(%ebp),%eax
  800b2c:	50                   	push   %eax
  800b2d:	e8 e7 fb ff ff       	call   800719 <getuint>
  800b32:	83 c4 10             	add    $0x10,%esp
  800b35:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b38:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b3b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b42:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b49:	83 ec 04             	sub    $0x4,%esp
  800b4c:	52                   	push   %edx
  800b4d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b50:	50                   	push   %eax
  800b51:	ff 75 f4             	pushl  -0xc(%ebp)
  800b54:	ff 75 f0             	pushl  -0x10(%ebp)
  800b57:	ff 75 0c             	pushl  0xc(%ebp)
  800b5a:	ff 75 08             	pushl  0x8(%ebp)
  800b5d:	e8 00 fb ff ff       	call   800662 <printnum>
  800b62:	83 c4 20             	add    $0x20,%esp
			break;
  800b65:	eb 46                	jmp    800bad <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b67:	83 ec 08             	sub    $0x8,%esp
  800b6a:	ff 75 0c             	pushl  0xc(%ebp)
  800b6d:	53                   	push   %ebx
  800b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b71:	ff d0                	call   *%eax
  800b73:	83 c4 10             	add    $0x10,%esp
			break;
  800b76:	eb 35                	jmp    800bad <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b78:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
			break;
  800b7f:	eb 2c                	jmp    800bad <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b81:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
			break;
  800b88:	eb 23                	jmp    800bad <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b8a:	83 ec 08             	sub    $0x8,%esp
  800b8d:	ff 75 0c             	pushl  0xc(%ebp)
  800b90:	6a 25                	push   $0x25
  800b92:	8b 45 08             	mov    0x8(%ebp),%eax
  800b95:	ff d0                	call   *%eax
  800b97:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b9a:	ff 4d 10             	decl   0x10(%ebp)
  800b9d:	eb 03                	jmp    800ba2 <vprintfmt+0x3c3>
  800b9f:	ff 4d 10             	decl   0x10(%ebp)
  800ba2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba5:	48                   	dec    %eax
  800ba6:	8a 00                	mov    (%eax),%al
  800ba8:	3c 25                	cmp    $0x25,%al
  800baa:	75 f3                	jne    800b9f <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800bac:	90                   	nop
		}
	}
  800bad:	e9 35 fc ff ff       	jmp    8007e7 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bb2:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bb3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bb6:	5b                   	pop    %ebx
  800bb7:	5e                   	pop    %esi
  800bb8:	5d                   	pop    %ebp
  800bb9:	c3                   	ret    

00800bba <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bba:	55                   	push   %ebp
  800bbb:	89 e5                	mov    %esp,%ebp
  800bbd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bc0:	8d 45 10             	lea    0x10(%ebp),%eax
  800bc3:	83 c0 04             	add    $0x4,%eax
  800bc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800bcc:	ff 75 f4             	pushl  -0xc(%ebp)
  800bcf:	50                   	push   %eax
  800bd0:	ff 75 0c             	pushl  0xc(%ebp)
  800bd3:	ff 75 08             	pushl  0x8(%ebp)
  800bd6:	e8 04 fc ff ff       	call   8007df <vprintfmt>
  800bdb:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bde:	90                   	nop
  800bdf:	c9                   	leave  
  800be0:	c3                   	ret    

00800be1 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800be1:	55                   	push   %ebp
  800be2:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800be4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be7:	8b 40 08             	mov    0x8(%eax),%eax
  800bea:	8d 50 01             	lea    0x1(%eax),%edx
  800bed:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf0:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bf3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf6:	8b 10                	mov    (%eax),%edx
  800bf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfb:	8b 40 04             	mov    0x4(%eax),%eax
  800bfe:	39 c2                	cmp    %eax,%edx
  800c00:	73 12                	jae    800c14 <sprintputch+0x33>
		*b->buf++ = ch;
  800c02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c05:	8b 00                	mov    (%eax),%eax
  800c07:	8d 48 01             	lea    0x1(%eax),%ecx
  800c0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c0d:	89 0a                	mov    %ecx,(%edx)
  800c0f:	8b 55 08             	mov    0x8(%ebp),%edx
  800c12:	88 10                	mov    %dl,(%eax)
}
  800c14:	90                   	nop
  800c15:	5d                   	pop    %ebp
  800c16:	c3                   	ret    

00800c17 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c17:	55                   	push   %ebp
  800c18:	89 e5                	mov    %esp,%ebp
  800c1a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c20:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c26:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c29:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2c:	01 d0                	add    %edx,%eax
  800c2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c31:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c38:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c3c:	74 06                	je     800c44 <vsnprintf+0x2d>
  800c3e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c42:	7f 07                	jg     800c4b <vsnprintf+0x34>
		return -E_INVAL;
  800c44:	b8 03 00 00 00       	mov    $0x3,%eax
  800c49:	eb 20                	jmp    800c6b <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c4b:	ff 75 14             	pushl  0x14(%ebp)
  800c4e:	ff 75 10             	pushl  0x10(%ebp)
  800c51:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c54:	50                   	push   %eax
  800c55:	68 e1 0b 80 00       	push   $0x800be1
  800c5a:	e8 80 fb ff ff       	call   8007df <vprintfmt>
  800c5f:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c65:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c68:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c6b:	c9                   	leave  
  800c6c:	c3                   	ret    

00800c6d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
  800c70:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c73:	8d 45 10             	lea    0x10(%ebp),%eax
  800c76:	83 c0 04             	add    $0x4,%eax
  800c79:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c7f:	ff 75 f4             	pushl  -0xc(%ebp)
  800c82:	50                   	push   %eax
  800c83:	ff 75 0c             	pushl  0xc(%ebp)
  800c86:	ff 75 08             	pushl  0x8(%ebp)
  800c89:	e8 89 ff ff ff       	call   800c17 <vsnprintf>
  800c8e:	83 c4 10             	add    $0x10,%esp
  800c91:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c94:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c97:	c9                   	leave  
  800c98:	c3                   	ret    

00800c99 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c99:	55                   	push   %ebp
  800c9a:	89 e5                	mov    %esp,%ebp
  800c9c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c9f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ca6:	eb 06                	jmp    800cae <strlen+0x15>
		n++;
  800ca8:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cab:	ff 45 08             	incl   0x8(%ebp)
  800cae:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb1:	8a 00                	mov    (%eax),%al
  800cb3:	84 c0                	test   %al,%al
  800cb5:	75 f1                	jne    800ca8 <strlen+0xf>
		n++;
	return n;
  800cb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cba:	c9                   	leave  
  800cbb:	c3                   	ret    

00800cbc <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cbc:	55                   	push   %ebp
  800cbd:	89 e5                	mov    %esp,%ebp
  800cbf:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cc2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cc9:	eb 09                	jmp    800cd4 <strnlen+0x18>
		n++;
  800ccb:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cce:	ff 45 08             	incl   0x8(%ebp)
  800cd1:	ff 4d 0c             	decl   0xc(%ebp)
  800cd4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cd8:	74 09                	je     800ce3 <strnlen+0x27>
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	8a 00                	mov    (%eax),%al
  800cdf:	84 c0                	test   %al,%al
  800ce1:	75 e8                	jne    800ccb <strnlen+0xf>
		n++;
	return n;
  800ce3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ce6:	c9                   	leave  
  800ce7:	c3                   	ret    

00800ce8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ce8:	55                   	push   %ebp
  800ce9:	89 e5                	mov    %esp,%ebp
  800ceb:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cf4:	90                   	nop
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	8d 50 01             	lea    0x1(%eax),%edx
  800cfb:	89 55 08             	mov    %edx,0x8(%ebp)
  800cfe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d01:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d04:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d07:	8a 12                	mov    (%edx),%dl
  800d09:	88 10                	mov    %dl,(%eax)
  800d0b:	8a 00                	mov    (%eax),%al
  800d0d:	84 c0                	test   %al,%al
  800d0f:	75 e4                	jne    800cf5 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d11:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d14:	c9                   	leave  
  800d15:	c3                   	ret    

00800d16 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d16:	55                   	push   %ebp
  800d17:	89 e5                	mov    %esp,%ebp
  800d19:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d22:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d29:	eb 1f                	jmp    800d4a <strncpy+0x34>
		*dst++ = *src;
  800d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2e:	8d 50 01             	lea    0x1(%eax),%edx
  800d31:	89 55 08             	mov    %edx,0x8(%ebp)
  800d34:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d37:	8a 12                	mov    (%edx),%dl
  800d39:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3e:	8a 00                	mov    (%eax),%al
  800d40:	84 c0                	test   %al,%al
  800d42:	74 03                	je     800d47 <strncpy+0x31>
			src++;
  800d44:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d47:	ff 45 fc             	incl   -0x4(%ebp)
  800d4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d4d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d50:	72 d9                	jb     800d2b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d52:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d55:	c9                   	leave  
  800d56:	c3                   	ret    

00800d57 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d57:	55                   	push   %ebp
  800d58:	89 e5                	mov    %esp,%ebp
  800d5a:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d60:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d63:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d67:	74 30                	je     800d99 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d69:	eb 16                	jmp    800d81 <strlcpy+0x2a>
			*dst++ = *src++;
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	8d 50 01             	lea    0x1(%eax),%edx
  800d71:	89 55 08             	mov    %edx,0x8(%ebp)
  800d74:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d77:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d7a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d7d:	8a 12                	mov    (%edx),%dl
  800d7f:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d81:	ff 4d 10             	decl   0x10(%ebp)
  800d84:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d88:	74 09                	je     800d93 <strlcpy+0x3c>
  800d8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8d:	8a 00                	mov    (%eax),%al
  800d8f:	84 c0                	test   %al,%al
  800d91:	75 d8                	jne    800d6b <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d93:	8b 45 08             	mov    0x8(%ebp),%eax
  800d96:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d99:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d9f:	29 c2                	sub    %eax,%edx
  800da1:	89 d0                	mov    %edx,%eax
}
  800da3:	c9                   	leave  
  800da4:	c3                   	ret    

00800da5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800da5:	55                   	push   %ebp
  800da6:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800da8:	eb 06                	jmp    800db0 <strcmp+0xb>
		p++, q++;
  800daa:	ff 45 08             	incl   0x8(%ebp)
  800dad:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800db0:	8b 45 08             	mov    0x8(%ebp),%eax
  800db3:	8a 00                	mov    (%eax),%al
  800db5:	84 c0                	test   %al,%al
  800db7:	74 0e                	je     800dc7 <strcmp+0x22>
  800db9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbc:	8a 10                	mov    (%eax),%dl
  800dbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc1:	8a 00                	mov    (%eax),%al
  800dc3:	38 c2                	cmp    %al,%dl
  800dc5:	74 e3                	je     800daa <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dca:	8a 00                	mov    (%eax),%al
  800dcc:	0f b6 d0             	movzbl %al,%edx
  800dcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd2:	8a 00                	mov    (%eax),%al
  800dd4:	0f b6 c0             	movzbl %al,%eax
  800dd7:	29 c2                	sub    %eax,%edx
  800dd9:	89 d0                	mov    %edx,%eax
}
  800ddb:	5d                   	pop    %ebp
  800ddc:	c3                   	ret    

00800ddd <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800de0:	eb 09                	jmp    800deb <strncmp+0xe>
		n--, p++, q++;
  800de2:	ff 4d 10             	decl   0x10(%ebp)
  800de5:	ff 45 08             	incl   0x8(%ebp)
  800de8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800deb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800def:	74 17                	je     800e08 <strncmp+0x2b>
  800df1:	8b 45 08             	mov    0x8(%ebp),%eax
  800df4:	8a 00                	mov    (%eax),%al
  800df6:	84 c0                	test   %al,%al
  800df8:	74 0e                	je     800e08 <strncmp+0x2b>
  800dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfd:	8a 10                	mov    (%eax),%dl
  800dff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e02:	8a 00                	mov    (%eax),%al
  800e04:	38 c2                	cmp    %al,%dl
  800e06:	74 da                	je     800de2 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e08:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e0c:	75 07                	jne    800e15 <strncmp+0x38>
		return 0;
  800e0e:	b8 00 00 00 00       	mov    $0x0,%eax
  800e13:	eb 14                	jmp    800e29 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e15:	8b 45 08             	mov    0x8(%ebp),%eax
  800e18:	8a 00                	mov    (%eax),%al
  800e1a:	0f b6 d0             	movzbl %al,%edx
  800e1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e20:	8a 00                	mov    (%eax),%al
  800e22:	0f b6 c0             	movzbl %al,%eax
  800e25:	29 c2                	sub    %eax,%edx
  800e27:	89 d0                	mov    %edx,%eax
}
  800e29:	5d                   	pop    %ebp
  800e2a:	c3                   	ret    

00800e2b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e2b:	55                   	push   %ebp
  800e2c:	89 e5                	mov    %esp,%ebp
  800e2e:	83 ec 04             	sub    $0x4,%esp
  800e31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e34:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e37:	eb 12                	jmp    800e4b <strchr+0x20>
		if (*s == c)
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	8a 00                	mov    (%eax),%al
  800e3e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e41:	75 05                	jne    800e48 <strchr+0x1d>
			return (char *) s;
  800e43:	8b 45 08             	mov    0x8(%ebp),%eax
  800e46:	eb 11                	jmp    800e59 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e48:	ff 45 08             	incl   0x8(%ebp)
  800e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4e:	8a 00                	mov    (%eax),%al
  800e50:	84 c0                	test   %al,%al
  800e52:	75 e5                	jne    800e39 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e54:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e59:	c9                   	leave  
  800e5a:	c3                   	ret    

00800e5b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e5b:	55                   	push   %ebp
  800e5c:	89 e5                	mov    %esp,%ebp
  800e5e:	83 ec 04             	sub    $0x4,%esp
  800e61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e64:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e67:	eb 0d                	jmp    800e76 <strfind+0x1b>
		if (*s == c)
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	8a 00                	mov    (%eax),%al
  800e6e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e71:	74 0e                	je     800e81 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e73:	ff 45 08             	incl   0x8(%ebp)
  800e76:	8b 45 08             	mov    0x8(%ebp),%eax
  800e79:	8a 00                	mov    (%eax),%al
  800e7b:	84 c0                	test   %al,%al
  800e7d:	75 ea                	jne    800e69 <strfind+0xe>
  800e7f:	eb 01                	jmp    800e82 <strfind+0x27>
		if (*s == c)
			break;
  800e81:	90                   	nop
	return (char *) s;
  800e82:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e85:	c9                   	leave  
  800e86:	c3                   	ret    

00800e87 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e87:	55                   	push   %ebp
  800e88:	89 e5                	mov    %esp,%ebp
  800e8a:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e90:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e93:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e97:	76 63                	jbe    800efc <memset+0x75>
		uint64 data_block = c;
  800e99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9c:	99                   	cltd   
  800e9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ea0:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800ea3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ea6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ea9:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800ead:	c1 e0 08             	shl    $0x8,%eax
  800eb0:	09 45 f0             	or     %eax,-0x10(%ebp)
  800eb3:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800eb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ebc:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800ec0:	c1 e0 10             	shl    $0x10,%eax
  800ec3:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ec6:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800ec9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ecc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ecf:	89 c2                	mov    %eax,%edx
  800ed1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ed6:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ed9:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800edc:	eb 18                	jmp    800ef6 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800ede:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ee1:	8d 41 08             	lea    0x8(%ecx),%eax
  800ee4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800ee7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eed:	89 01                	mov    %eax,(%ecx)
  800eef:	89 51 04             	mov    %edx,0x4(%ecx)
  800ef2:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800ef6:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800efa:	77 e2                	ja     800ede <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800efc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f00:	74 23                	je     800f25 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800f02:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f05:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f08:	eb 0e                	jmp    800f18 <memset+0x91>
			*p8++ = (uint8)c;
  800f0a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0d:	8d 50 01             	lea    0x1(%eax),%edx
  800f10:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f13:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f16:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800f18:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f1e:	89 55 10             	mov    %edx,0x10(%ebp)
  800f21:	85 c0                	test   %eax,%eax
  800f23:	75 e5                	jne    800f0a <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f25:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f28:	c9                   	leave  
  800f29:	c3                   	ret    

00800f2a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f2a:	55                   	push   %ebp
  800f2b:	89 e5                	mov    %esp,%ebp
  800f2d:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f33:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f36:	8b 45 08             	mov    0x8(%ebp),%eax
  800f39:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f3c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f40:	76 24                	jbe    800f66 <memcpy+0x3c>
		while(n >= 8){
  800f42:	eb 1c                	jmp    800f60 <memcpy+0x36>
			*d64 = *s64;
  800f44:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f47:	8b 50 04             	mov    0x4(%eax),%edx
  800f4a:	8b 00                	mov    (%eax),%eax
  800f4c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f4f:	89 01                	mov    %eax,(%ecx)
  800f51:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f54:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f58:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f5c:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f60:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f64:	77 de                	ja     800f44 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f66:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f6a:	74 31                	je     800f9d <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f72:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f75:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f78:	eb 16                	jmp    800f90 <memcpy+0x66>
			*d8++ = *s8++;
  800f7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f7d:	8d 50 01             	lea    0x1(%eax),%edx
  800f80:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f86:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f89:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f8c:	8a 12                	mov    (%edx),%dl
  800f8e:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f90:	8b 45 10             	mov    0x10(%ebp),%eax
  800f93:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f96:	89 55 10             	mov    %edx,0x10(%ebp)
  800f99:	85 c0                	test   %eax,%eax
  800f9b:	75 dd                	jne    800f7a <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fa0:	c9                   	leave  
  800fa1:	c3                   	ret    

00800fa2 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800fa2:	55                   	push   %ebp
  800fa3:	89 e5                	mov    %esp,%ebp
  800fa5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fba:	73 50                	jae    80100c <memmove+0x6a>
  800fbc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc2:	01 d0                	add    %edx,%eax
  800fc4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fc7:	76 43                	jbe    80100c <memmove+0x6a>
		s += n;
  800fc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcc:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fcf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd2:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fd5:	eb 10                	jmp    800fe7 <memmove+0x45>
			*--d = *--s;
  800fd7:	ff 4d f8             	decl   -0x8(%ebp)
  800fda:	ff 4d fc             	decl   -0x4(%ebp)
  800fdd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe0:	8a 10                	mov    (%eax),%dl
  800fe2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe5:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fe7:	8b 45 10             	mov    0x10(%ebp),%eax
  800fea:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fed:	89 55 10             	mov    %edx,0x10(%ebp)
  800ff0:	85 c0                	test   %eax,%eax
  800ff2:	75 e3                	jne    800fd7 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ff4:	eb 23                	jmp    801019 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ff6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff9:	8d 50 01             	lea    0x1(%eax),%edx
  800ffc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801002:	8d 4a 01             	lea    0x1(%edx),%ecx
  801005:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801008:	8a 12                	mov    (%edx),%dl
  80100a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80100c:	8b 45 10             	mov    0x10(%ebp),%eax
  80100f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801012:	89 55 10             	mov    %edx,0x10(%ebp)
  801015:	85 c0                	test   %eax,%eax
  801017:	75 dd                	jne    800ff6 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80101c:	c9                   	leave  
  80101d:	c3                   	ret    

0080101e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80101e:	55                   	push   %ebp
  80101f:	89 e5                	mov    %esp,%ebp
  801021:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801024:	8b 45 08             	mov    0x8(%ebp),%eax
  801027:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80102a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801030:	eb 2a                	jmp    80105c <memcmp+0x3e>
		if (*s1 != *s2)
  801032:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801035:	8a 10                	mov    (%eax),%dl
  801037:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80103a:	8a 00                	mov    (%eax),%al
  80103c:	38 c2                	cmp    %al,%dl
  80103e:	74 16                	je     801056 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801040:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801043:	8a 00                	mov    (%eax),%al
  801045:	0f b6 d0             	movzbl %al,%edx
  801048:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80104b:	8a 00                	mov    (%eax),%al
  80104d:	0f b6 c0             	movzbl %al,%eax
  801050:	29 c2                	sub    %eax,%edx
  801052:	89 d0                	mov    %edx,%eax
  801054:	eb 18                	jmp    80106e <memcmp+0x50>
		s1++, s2++;
  801056:	ff 45 fc             	incl   -0x4(%ebp)
  801059:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80105c:	8b 45 10             	mov    0x10(%ebp),%eax
  80105f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801062:	89 55 10             	mov    %edx,0x10(%ebp)
  801065:	85 c0                	test   %eax,%eax
  801067:	75 c9                	jne    801032 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801069:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80106e:	c9                   	leave  
  80106f:	c3                   	ret    

00801070 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801070:	55                   	push   %ebp
  801071:	89 e5                	mov    %esp,%ebp
  801073:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801076:	8b 55 08             	mov    0x8(%ebp),%edx
  801079:	8b 45 10             	mov    0x10(%ebp),%eax
  80107c:	01 d0                	add    %edx,%eax
  80107e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801081:	eb 15                	jmp    801098 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	8a 00                	mov    (%eax),%al
  801088:	0f b6 d0             	movzbl %al,%edx
  80108b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108e:	0f b6 c0             	movzbl %al,%eax
  801091:	39 c2                	cmp    %eax,%edx
  801093:	74 0d                	je     8010a2 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801095:	ff 45 08             	incl   0x8(%ebp)
  801098:	8b 45 08             	mov    0x8(%ebp),%eax
  80109b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80109e:	72 e3                	jb     801083 <memfind+0x13>
  8010a0:	eb 01                	jmp    8010a3 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8010a2:	90                   	nop
	return (void *) s;
  8010a3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010a6:	c9                   	leave  
  8010a7:	c3                   	ret    

008010a8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010a8:	55                   	push   %ebp
  8010a9:	89 e5                	mov    %esp,%ebp
  8010ab:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010b5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010bc:	eb 03                	jmp    8010c1 <strtol+0x19>
		s++;
  8010be:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	8a 00                	mov    (%eax),%al
  8010c6:	3c 20                	cmp    $0x20,%al
  8010c8:	74 f4                	je     8010be <strtol+0x16>
  8010ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cd:	8a 00                	mov    (%eax),%al
  8010cf:	3c 09                	cmp    $0x9,%al
  8010d1:	74 eb                	je     8010be <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d6:	8a 00                	mov    (%eax),%al
  8010d8:	3c 2b                	cmp    $0x2b,%al
  8010da:	75 05                	jne    8010e1 <strtol+0x39>
		s++;
  8010dc:	ff 45 08             	incl   0x8(%ebp)
  8010df:	eb 13                	jmp    8010f4 <strtol+0x4c>
	else if (*s == '-')
  8010e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e4:	8a 00                	mov    (%eax),%al
  8010e6:	3c 2d                	cmp    $0x2d,%al
  8010e8:	75 0a                	jne    8010f4 <strtol+0x4c>
		s++, neg = 1;
  8010ea:	ff 45 08             	incl   0x8(%ebp)
  8010ed:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010f4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010f8:	74 06                	je     801100 <strtol+0x58>
  8010fa:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010fe:	75 20                	jne    801120 <strtol+0x78>
  801100:	8b 45 08             	mov    0x8(%ebp),%eax
  801103:	8a 00                	mov    (%eax),%al
  801105:	3c 30                	cmp    $0x30,%al
  801107:	75 17                	jne    801120 <strtol+0x78>
  801109:	8b 45 08             	mov    0x8(%ebp),%eax
  80110c:	40                   	inc    %eax
  80110d:	8a 00                	mov    (%eax),%al
  80110f:	3c 78                	cmp    $0x78,%al
  801111:	75 0d                	jne    801120 <strtol+0x78>
		s += 2, base = 16;
  801113:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801117:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80111e:	eb 28                	jmp    801148 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801120:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801124:	75 15                	jne    80113b <strtol+0x93>
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	8a 00                	mov    (%eax),%al
  80112b:	3c 30                	cmp    $0x30,%al
  80112d:	75 0c                	jne    80113b <strtol+0x93>
		s++, base = 8;
  80112f:	ff 45 08             	incl   0x8(%ebp)
  801132:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801139:	eb 0d                	jmp    801148 <strtol+0xa0>
	else if (base == 0)
  80113b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80113f:	75 07                	jne    801148 <strtol+0xa0>
		base = 10;
  801141:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
  80114b:	8a 00                	mov    (%eax),%al
  80114d:	3c 2f                	cmp    $0x2f,%al
  80114f:	7e 19                	jle    80116a <strtol+0xc2>
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
  801154:	8a 00                	mov    (%eax),%al
  801156:	3c 39                	cmp    $0x39,%al
  801158:	7f 10                	jg     80116a <strtol+0xc2>
			dig = *s - '0';
  80115a:	8b 45 08             	mov    0x8(%ebp),%eax
  80115d:	8a 00                	mov    (%eax),%al
  80115f:	0f be c0             	movsbl %al,%eax
  801162:	83 e8 30             	sub    $0x30,%eax
  801165:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801168:	eb 42                	jmp    8011ac <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80116a:	8b 45 08             	mov    0x8(%ebp),%eax
  80116d:	8a 00                	mov    (%eax),%al
  80116f:	3c 60                	cmp    $0x60,%al
  801171:	7e 19                	jle    80118c <strtol+0xe4>
  801173:	8b 45 08             	mov    0x8(%ebp),%eax
  801176:	8a 00                	mov    (%eax),%al
  801178:	3c 7a                	cmp    $0x7a,%al
  80117a:	7f 10                	jg     80118c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80117c:	8b 45 08             	mov    0x8(%ebp),%eax
  80117f:	8a 00                	mov    (%eax),%al
  801181:	0f be c0             	movsbl %al,%eax
  801184:	83 e8 57             	sub    $0x57,%eax
  801187:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80118a:	eb 20                	jmp    8011ac <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80118c:	8b 45 08             	mov    0x8(%ebp),%eax
  80118f:	8a 00                	mov    (%eax),%al
  801191:	3c 40                	cmp    $0x40,%al
  801193:	7e 39                	jle    8011ce <strtol+0x126>
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	8a 00                	mov    (%eax),%al
  80119a:	3c 5a                	cmp    $0x5a,%al
  80119c:	7f 30                	jg     8011ce <strtol+0x126>
			dig = *s - 'A' + 10;
  80119e:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a1:	8a 00                	mov    (%eax),%al
  8011a3:	0f be c0             	movsbl %al,%eax
  8011a6:	83 e8 37             	sub    $0x37,%eax
  8011a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011af:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011b2:	7d 19                	jge    8011cd <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011b4:	ff 45 08             	incl   0x8(%ebp)
  8011b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ba:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011be:	89 c2                	mov    %eax,%edx
  8011c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011c3:	01 d0                	add    %edx,%eax
  8011c5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011c8:	e9 7b ff ff ff       	jmp    801148 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011cd:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011ce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011d2:	74 08                	je     8011dc <strtol+0x134>
		*endptr = (char *) s;
  8011d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8011da:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011e0:	74 07                	je     8011e9 <strtol+0x141>
  8011e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e5:	f7 d8                	neg    %eax
  8011e7:	eb 03                	jmp    8011ec <strtol+0x144>
  8011e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011ec:	c9                   	leave  
  8011ed:	c3                   	ret    

008011ee <ltostr>:

void
ltostr(long value, char *str)
{
  8011ee:	55                   	push   %ebp
  8011ef:	89 e5                	mov    %esp,%ebp
  8011f1:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011fb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801202:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801206:	79 13                	jns    80121b <ltostr+0x2d>
	{
		neg = 1;
  801208:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80120f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801212:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801215:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801218:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80121b:	8b 45 08             	mov    0x8(%ebp),%eax
  80121e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801223:	99                   	cltd   
  801224:	f7 f9                	idiv   %ecx
  801226:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801229:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80122c:	8d 50 01             	lea    0x1(%eax),%edx
  80122f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801232:	89 c2                	mov    %eax,%edx
  801234:	8b 45 0c             	mov    0xc(%ebp),%eax
  801237:	01 d0                	add    %edx,%eax
  801239:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80123c:	83 c2 30             	add    $0x30,%edx
  80123f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801241:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801244:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801249:	f7 e9                	imul   %ecx
  80124b:	c1 fa 02             	sar    $0x2,%edx
  80124e:	89 c8                	mov    %ecx,%eax
  801250:	c1 f8 1f             	sar    $0x1f,%eax
  801253:	29 c2                	sub    %eax,%edx
  801255:	89 d0                	mov    %edx,%eax
  801257:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80125a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80125e:	75 bb                	jne    80121b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801260:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801267:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80126a:	48                   	dec    %eax
  80126b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80126e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801272:	74 3d                	je     8012b1 <ltostr+0xc3>
		start = 1 ;
  801274:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80127b:	eb 34                	jmp    8012b1 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80127d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801280:	8b 45 0c             	mov    0xc(%ebp),%eax
  801283:	01 d0                	add    %edx,%eax
  801285:	8a 00                	mov    (%eax),%al
  801287:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80128a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80128d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801290:	01 c2                	add    %eax,%edx
  801292:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801295:	8b 45 0c             	mov    0xc(%ebp),%eax
  801298:	01 c8                	add    %ecx,%eax
  80129a:	8a 00                	mov    (%eax),%al
  80129c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80129e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a4:	01 c2                	add    %eax,%edx
  8012a6:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012a9:	88 02                	mov    %al,(%edx)
		start++ ;
  8012ab:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012ae:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012b4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012b7:	7c c4                	jl     80127d <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012b9:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bf:	01 d0                	add    %edx,%eax
  8012c1:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012c4:	90                   	nop
  8012c5:	c9                   	leave  
  8012c6:	c3                   	ret    

008012c7 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012c7:	55                   	push   %ebp
  8012c8:	89 e5                	mov    %esp,%ebp
  8012ca:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012cd:	ff 75 08             	pushl  0x8(%ebp)
  8012d0:	e8 c4 f9 ff ff       	call   800c99 <strlen>
  8012d5:	83 c4 04             	add    $0x4,%esp
  8012d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012db:	ff 75 0c             	pushl  0xc(%ebp)
  8012de:	e8 b6 f9 ff ff       	call   800c99 <strlen>
  8012e3:	83 c4 04             	add    $0x4,%esp
  8012e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012f7:	eb 17                	jmp    801310 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ff:	01 c2                	add    %eax,%edx
  801301:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801304:	8b 45 08             	mov    0x8(%ebp),%eax
  801307:	01 c8                	add    %ecx,%eax
  801309:	8a 00                	mov    (%eax),%al
  80130b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80130d:	ff 45 fc             	incl   -0x4(%ebp)
  801310:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801313:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801316:	7c e1                	jl     8012f9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801318:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80131f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801326:	eb 1f                	jmp    801347 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801328:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80132b:	8d 50 01             	lea    0x1(%eax),%edx
  80132e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801331:	89 c2                	mov    %eax,%edx
  801333:	8b 45 10             	mov    0x10(%ebp),%eax
  801336:	01 c2                	add    %eax,%edx
  801338:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80133b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133e:	01 c8                	add    %ecx,%eax
  801340:	8a 00                	mov    (%eax),%al
  801342:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801344:	ff 45 f8             	incl   -0x8(%ebp)
  801347:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80134a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80134d:	7c d9                	jl     801328 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80134f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801352:	8b 45 10             	mov    0x10(%ebp),%eax
  801355:	01 d0                	add    %edx,%eax
  801357:	c6 00 00             	movb   $0x0,(%eax)
}
  80135a:	90                   	nop
  80135b:	c9                   	leave  
  80135c:	c3                   	ret    

0080135d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80135d:	55                   	push   %ebp
  80135e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801360:	8b 45 14             	mov    0x14(%ebp),%eax
  801363:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801369:	8b 45 14             	mov    0x14(%ebp),%eax
  80136c:	8b 00                	mov    (%eax),%eax
  80136e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801375:	8b 45 10             	mov    0x10(%ebp),%eax
  801378:	01 d0                	add    %edx,%eax
  80137a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801380:	eb 0c                	jmp    80138e <strsplit+0x31>
			*string++ = 0;
  801382:	8b 45 08             	mov    0x8(%ebp),%eax
  801385:	8d 50 01             	lea    0x1(%eax),%edx
  801388:	89 55 08             	mov    %edx,0x8(%ebp)
  80138b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80138e:	8b 45 08             	mov    0x8(%ebp),%eax
  801391:	8a 00                	mov    (%eax),%al
  801393:	84 c0                	test   %al,%al
  801395:	74 18                	je     8013af <strsplit+0x52>
  801397:	8b 45 08             	mov    0x8(%ebp),%eax
  80139a:	8a 00                	mov    (%eax),%al
  80139c:	0f be c0             	movsbl %al,%eax
  80139f:	50                   	push   %eax
  8013a0:	ff 75 0c             	pushl  0xc(%ebp)
  8013a3:	e8 83 fa ff ff       	call   800e2b <strchr>
  8013a8:	83 c4 08             	add    $0x8,%esp
  8013ab:	85 c0                	test   %eax,%eax
  8013ad:	75 d3                	jne    801382 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013af:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b2:	8a 00                	mov    (%eax),%al
  8013b4:	84 c0                	test   %al,%al
  8013b6:	74 5a                	je     801412 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8013bb:	8b 00                	mov    (%eax),%eax
  8013bd:	83 f8 0f             	cmp    $0xf,%eax
  8013c0:	75 07                	jne    8013c9 <strsplit+0x6c>
		{
			return 0;
  8013c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c7:	eb 66                	jmp    80142f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8013cc:	8b 00                	mov    (%eax),%eax
  8013ce:	8d 48 01             	lea    0x1(%eax),%ecx
  8013d1:	8b 55 14             	mov    0x14(%ebp),%edx
  8013d4:	89 0a                	mov    %ecx,(%edx)
  8013d6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e0:	01 c2                	add    %eax,%edx
  8013e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e5:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013e7:	eb 03                	jmp    8013ec <strsplit+0x8f>
			string++;
  8013e9:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ef:	8a 00                	mov    (%eax),%al
  8013f1:	84 c0                	test   %al,%al
  8013f3:	74 8b                	je     801380 <strsplit+0x23>
  8013f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f8:	8a 00                	mov    (%eax),%al
  8013fa:	0f be c0             	movsbl %al,%eax
  8013fd:	50                   	push   %eax
  8013fe:	ff 75 0c             	pushl  0xc(%ebp)
  801401:	e8 25 fa ff ff       	call   800e2b <strchr>
  801406:	83 c4 08             	add    $0x8,%esp
  801409:	85 c0                	test   %eax,%eax
  80140b:	74 dc                	je     8013e9 <strsplit+0x8c>
			string++;
	}
  80140d:	e9 6e ff ff ff       	jmp    801380 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801412:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801413:	8b 45 14             	mov    0x14(%ebp),%eax
  801416:	8b 00                	mov    (%eax),%eax
  801418:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80141f:	8b 45 10             	mov    0x10(%ebp),%eax
  801422:	01 d0                	add    %edx,%eax
  801424:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80142a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80142f:	c9                   	leave  
  801430:	c3                   	ret    

00801431 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801431:	55                   	push   %ebp
  801432:	89 e5                	mov    %esp,%ebp
  801434:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801437:	8b 45 08             	mov    0x8(%ebp),%eax
  80143a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80143d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801444:	eb 4a                	jmp    801490 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801446:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	01 c2                	add    %eax,%edx
  80144e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801451:	8b 45 0c             	mov    0xc(%ebp),%eax
  801454:	01 c8                	add    %ecx,%eax
  801456:	8a 00                	mov    (%eax),%al
  801458:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80145a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80145d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801460:	01 d0                	add    %edx,%eax
  801462:	8a 00                	mov    (%eax),%al
  801464:	3c 40                	cmp    $0x40,%al
  801466:	7e 25                	jle    80148d <str2lower+0x5c>
  801468:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80146b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146e:	01 d0                	add    %edx,%eax
  801470:	8a 00                	mov    (%eax),%al
  801472:	3c 5a                	cmp    $0x5a,%al
  801474:	7f 17                	jg     80148d <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801476:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801479:	8b 45 08             	mov    0x8(%ebp),%eax
  80147c:	01 d0                	add    %edx,%eax
  80147e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801481:	8b 55 08             	mov    0x8(%ebp),%edx
  801484:	01 ca                	add    %ecx,%edx
  801486:	8a 12                	mov    (%edx),%dl
  801488:	83 c2 20             	add    $0x20,%edx
  80148b:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80148d:	ff 45 fc             	incl   -0x4(%ebp)
  801490:	ff 75 0c             	pushl  0xc(%ebp)
  801493:	e8 01 f8 ff ff       	call   800c99 <strlen>
  801498:	83 c4 04             	add    $0x4,%esp
  80149b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80149e:	7f a6                	jg     801446 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8014a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014a3:	c9                   	leave  
  8014a4:	c3                   	ret    

008014a5 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8014a5:	55                   	push   %ebp
  8014a6:	89 e5                	mov    %esp,%ebp
  8014a8:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8014ab:	a1 08 50 80 00       	mov    0x805008,%eax
  8014b0:	85 c0                	test   %eax,%eax
  8014b2:	74 42                	je     8014f6 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8014b4:	83 ec 08             	sub    $0x8,%esp
  8014b7:	68 00 00 00 82       	push   $0x82000000
  8014bc:	68 00 00 00 80       	push   $0x80000000
  8014c1:	e8 b0 1e 00 00       	call   803376 <initialize_dynamic_allocator>
  8014c6:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  8014c9:	e8 96 1c 00 00       	call   803164 <sys_get_uheap_strategy>
  8014ce:	a3 80 50 83 00       	mov    %eax,0x835080
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  8014d3:	a1 60 d0 81 00       	mov    0x81d060,%eax
  8014d8:	05 00 10 00 00       	add    $0x1000,%eax
  8014dd:	a3 30 51 83 00       	mov    %eax,0x835130
		uheapPageAllocBreak = uheapPageAllocStart;
  8014e2:	a1 30 51 83 00       	mov    0x835130,%eax
  8014e7:	a3 88 50 83 00       	mov    %eax,0x835088

		__firstTimeFlag = 0;
  8014ec:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8014f3:	00 00 00 
	}
}
  8014f6:	90                   	nop
  8014f7:	c9                   	leave  
  8014f8:	c3                   	ret    

008014f9 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8014f9:	55                   	push   %ebp
  8014fa:	89 e5                	mov    %esp,%ebp
  8014fc:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8014ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801502:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801505:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801508:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80150d:	83 ec 08             	sub    $0x8,%esp
  801510:	68 06 04 00 00       	push   $0x406
  801515:	50                   	push   %eax
  801516:	e8 93 18 00 00       	call   802dae <__sys_allocate_page>
  80151b:	83 c4 10             	add    $0x10,%esp
  80151e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801521:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801525:	79 14                	jns    80153b <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801527:	83 ec 04             	sub    $0x4,%esp
  80152a:	68 08 48 80 00       	push   $0x804808
  80152f:	6a 1f                	push   $0x1f
  801531:	68 44 48 80 00       	push   $0x804844
  801536:	e8 b7 ed ff ff       	call   8002f2 <_panic>
	return 0;
  80153b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801540:	c9                   	leave  
  801541:	c3                   	ret    

00801542 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801542:	55                   	push   %ebp
  801543:	89 e5                	mov    %esp,%ebp
  801545:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801548:	8b 45 08             	mov    0x8(%ebp),%eax
  80154b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80154e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801551:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801556:	83 ec 0c             	sub    $0xc,%esp
  801559:	50                   	push   %eax
  80155a:	e8 96 18 00 00       	call   802df5 <__sys_unmap_frame>
  80155f:	83 c4 10             	add    $0x10,%esp
  801562:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801565:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801569:	79 14                	jns    80157f <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  80156b:	83 ec 04             	sub    $0x4,%esp
  80156e:	68 50 48 80 00       	push   $0x804850
  801573:	6a 2a                	push   $0x2a
  801575:	68 44 48 80 00       	push   $0x804844
  80157a:	e8 73 ed ff ff       	call   8002f2 <_panic>
}
  80157f:	90                   	nop
  801580:	c9                   	leave  
  801581:	c3                   	ret    

00801582 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801582:	55                   	push   %ebp
  801583:	89 e5                	mov    %esp,%ebp
  801585:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801588:	e8 18 ff ff ff       	call   8014a5 <uheap_init>
	if (size == 0) return NULL ;
  80158d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801591:	75 0a                	jne    80159d <malloc+0x1b>
  801593:	b8 00 00 00 00       	mov    $0x0,%eax
  801598:	e9 43 03 00 00       	jmp    8018e0 <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  80159d:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8015a4:	77 13                	ja     8015b9 <malloc+0x37>
    {
        return alloc_block(size);
  8015a6:	83 ec 0c             	sub    $0xc,%esp
  8015a9:	ff 75 08             	pushl  0x8(%ebp)
  8015ac:	e8 78 20 00 00       	call   803629 <alloc_block>
  8015b1:	83 c4 10             	add    $0x10,%esp
  8015b4:	e9 27 03 00 00       	jmp    8018e0 <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  8015b9:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  8015c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8015c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015c6:	01 d0                	add    %edx,%eax
  8015c8:	48                   	dec    %eax
  8015c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8015cc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8015d4:	f7 75 dc             	divl   -0x24(%ebp)
  8015d7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015da:	29 d0                	sub    %edx,%eax
  8015dc:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  8015df:	a1 40 d0 81 00       	mov    0x81d040,%eax
  8015e4:	85 c0                	test   %eax,%eax
  8015e6:	75 0a                	jne    8015f2 <malloc+0x70>
    {
        uhp_inited = 1;
  8015e8:	c7 05 40 d0 81 00 01 	movl   $0x1,0x81d040
  8015ef:	00 00 00 
    }

    int exactIdx = -1;
  8015f2:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  8015f9:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801600:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801607:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80160e:	e9 85 00 00 00       	jmp    801698 <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801613:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801616:	89 d0                	mov    %edx,%eax
  801618:	01 c0                	add    %eax,%eax
  80161a:	01 d0                	add    %edx,%eax
  80161c:	c1 e0 02             	shl    $0x2,%eax
  80161f:	05 48 10 81 00       	add    $0x811048,%eax
  801624:	8a 00                	mov    (%eax),%al
  801626:	84 c0                	test   %al,%al
  801628:	74 20                	je     80164a <malloc+0xc8>
  80162a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80162d:	89 d0                	mov    %edx,%eax
  80162f:	01 c0                	add    %eax,%eax
  801631:	01 d0                	add    %edx,%eax
  801633:	c1 e0 02             	shl    $0x2,%eax
  801636:	05 44 10 81 00       	add    $0x811044,%eax
  80163b:	8b 00                	mov    (%eax),%eax
  80163d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801640:	75 08                	jne    80164a <malloc+0xc8>
        {
            exactIdx = i;
  801642:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801645:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801648:	eb 5b                	jmp    8016a5 <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  80164a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80164d:	89 d0                	mov    %edx,%eax
  80164f:	01 c0                	add    %eax,%eax
  801651:	01 d0                	add    %edx,%eax
  801653:	c1 e0 02             	shl    $0x2,%eax
  801656:	05 48 10 81 00       	add    $0x811048,%eax
  80165b:	8a 00                	mov    (%eax),%al
  80165d:	84 c0                	test   %al,%al
  80165f:	74 34                	je     801695 <malloc+0x113>
  801661:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801664:	89 d0                	mov    %edx,%eax
  801666:	01 c0                	add    %eax,%eax
  801668:	01 d0                	add    %edx,%eax
  80166a:	c1 e0 02             	shl    $0x2,%eax
  80166d:	05 44 10 81 00       	add    $0x811044,%eax
  801672:	8b 00                	mov    (%eax),%eax
  801674:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801677:	76 1c                	jbe    801695 <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  801679:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80167c:	89 d0                	mov    %edx,%eax
  80167e:	01 c0                	add    %eax,%eax
  801680:	01 d0                	add    %edx,%eax
  801682:	c1 e0 02             	shl    $0x2,%eax
  801685:	05 44 10 81 00       	add    $0x811044,%eax
  80168a:	8b 00                	mov    (%eax),%eax
  80168c:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  80168f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801692:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801695:	ff 45 e8             	incl   -0x18(%ebp)
  801698:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  80169f:	0f 8e 6e ff ff ff    	jle    801613 <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  8016a5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  8016ac:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8016b0:	74 7d                	je     80172f <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  8016b2:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  8016b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016bc:	89 d0                	mov    %edx,%eax
  8016be:	01 c0                	add    %eax,%eax
  8016c0:	01 d0                	add    %edx,%eax
  8016c2:	c1 e0 02             	shl    $0x2,%eax
  8016c5:	05 40 10 81 00       	add    $0x811040,%eax
  8016ca:	8b 10                	mov    (%eax),%edx
  8016cc:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8016cf:	01 d0                	add    %edx,%eax
  8016d1:	48                   	dec    %eax
  8016d2:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8016d5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8016d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8016dd:	f7 75 bc             	divl   -0x44(%ebp)
  8016e0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8016e3:	29 d0                	sub    %edx,%eax
  8016e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  8016e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016eb:	89 d0                	mov    %edx,%eax
  8016ed:	01 c0                	add    %eax,%eax
  8016ef:	01 d0                	add    %edx,%eax
  8016f1:	c1 e0 02             	shl    $0x2,%eax
  8016f4:	05 48 10 81 00       	add    $0x811048,%eax
  8016f9:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  8016fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016ff:	89 d0                	mov    %edx,%eax
  801701:	01 c0                	add    %eax,%eax
  801703:	01 d0                	add    %edx,%eax
  801705:	c1 e0 02             	shl    $0x2,%eax
  801708:	05 44 10 81 00       	add    $0x811044,%eax
  80170d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801713:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801716:	89 d0                	mov    %edx,%eax
  801718:	01 c0                	add    %eax,%eax
  80171a:	01 d0                	add    %edx,%eax
  80171c:	c1 e0 02             	shl    $0x2,%eax
  80171f:	05 40 10 81 00       	add    $0x811040,%eax
  801724:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80172a:	e9 2d 01 00 00       	jmp    80185c <malloc+0x2da>
    }
    else if (worstIdx != -1)
  80172f:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801733:	0f 84 ce 00 00 00    	je     801807 <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  801739:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  801740:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801743:	89 d0                	mov    %edx,%eax
  801745:	01 c0                	add    %eax,%eax
  801747:	01 d0                	add    %edx,%eax
  801749:	c1 e0 02             	shl    $0x2,%eax
  80174c:	05 40 10 81 00       	add    $0x811040,%eax
  801751:	8b 10                	mov    (%eax),%edx
  801753:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801756:	01 d0                	add    %edx,%eax
  801758:	48                   	dec    %eax
  801759:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80175c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80175f:	ba 00 00 00 00       	mov    $0x0,%edx
  801764:	f7 75 c4             	divl   -0x3c(%ebp)
  801767:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80176a:	29 d0                	sub    %edx,%eax
  80176c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  80176f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801772:	89 d0                	mov    %edx,%eax
  801774:	01 c0                	add    %eax,%eax
  801776:	01 d0                	add    %edx,%eax
  801778:	c1 e0 02             	shl    $0x2,%eax
  80177b:	05 44 10 81 00       	add    $0x811044,%eax
  801780:	8b 00                	mov    (%eax),%eax
  801782:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801785:	75 47                	jne    8017ce <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  801787:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80178a:	89 d0                	mov    %edx,%eax
  80178c:	01 c0                	add    %eax,%eax
  80178e:	01 d0                	add    %edx,%eax
  801790:	c1 e0 02             	shl    $0x2,%eax
  801793:	05 48 10 81 00       	add    $0x811048,%eax
  801798:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  80179b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80179e:	89 d0                	mov    %edx,%eax
  8017a0:	01 c0                	add    %eax,%eax
  8017a2:	01 d0                	add    %edx,%eax
  8017a4:	c1 e0 02             	shl    $0x2,%eax
  8017a7:	05 44 10 81 00       	add    $0x811044,%eax
  8017ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  8017b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017b5:	89 d0                	mov    %edx,%eax
  8017b7:	01 c0                	add    %eax,%eax
  8017b9:	01 d0                	add    %edx,%eax
  8017bb:	c1 e0 02             	shl    $0x2,%eax
  8017be:	05 40 10 81 00       	add    $0x811040,%eax
  8017c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8017c9:	e9 8e 00 00 00       	jmp    80185c <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  8017ce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8017d1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8017d4:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8017d7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017da:	89 d0                	mov    %edx,%eax
  8017dc:	01 c0                	add    %eax,%eax
  8017de:	01 d0                	add    %edx,%eax
  8017e0:	c1 e0 02             	shl    $0x2,%eax
  8017e3:	05 40 10 81 00       	add    $0x811040,%eax
  8017e8:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  8017ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017ed:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8017f0:	89 c2                	mov    %eax,%edx
  8017f2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8017f5:	89 c8                	mov    %ecx,%eax
  8017f7:	01 c0                	add    %eax,%eax
  8017f9:	01 c8                	add    %ecx,%eax
  8017fb:	c1 e0 02             	shl    $0x2,%eax
  8017fe:	05 44 10 81 00       	add    $0x811044,%eax
  801803:	89 10                	mov    %edx,(%eax)
  801805:	eb 55                	jmp    80185c <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  801807:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  80180e:	8b 15 88 50 83 00    	mov    0x835088,%edx
  801814:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801817:	01 d0                	add    %edx,%eax
  801819:	48                   	dec    %eax
  80181a:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80181d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801820:	ba 00 00 00 00       	mov    $0x0,%edx
  801825:	f7 75 d0             	divl   -0x30(%ebp)
  801828:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80182b:	29 d0                	sub    %edx,%eax
  80182d:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  801830:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801833:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801836:	01 d0                	add    %edx,%eax
  801838:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  80183d:	76 0a                	jbe    801849 <malloc+0x2c7>
            return NULL;
  80183f:	b8 00 00 00 00       	mov    $0x0,%eax
  801844:	e9 97 00 00 00       	jmp    8018e0 <malloc+0x35e>
        va = start;
  801849:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80184c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  80184f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801852:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801855:	01 d0                	add    %edx,%eax
  801857:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80185c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801863:	eb 5e                	jmp    8018c3 <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  801865:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801868:	89 d0                	mov    %edx,%eax
  80186a:	01 c0                	add    %eax,%eax
  80186c:	01 d0                	add    %edx,%eax
  80186e:	c1 e0 02             	shl    $0x2,%eax
  801871:	05 48 50 80 00       	add    $0x805048,%eax
  801876:	8a 00                	mov    (%eax),%al
  801878:	84 c0                	test   %al,%al
  80187a:	75 44                	jne    8018c0 <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  80187c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80187f:	89 d0                	mov    %edx,%eax
  801881:	01 c0                	add    %eax,%eax
  801883:	01 d0                	add    %edx,%eax
  801885:	c1 e0 02             	shl    $0x2,%eax
  801888:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  80188e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801891:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  801893:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801896:	89 d0                	mov    %edx,%eax
  801898:	01 c0                	add    %eax,%eax
  80189a:	01 d0                	add    %edx,%eax
  80189c:	c1 e0 02             	shl    $0x2,%eax
  80189f:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8018a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8018a8:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  8018aa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018ad:	89 d0                	mov    %edx,%eax
  8018af:	01 c0                	add    %eax,%eax
  8018b1:	01 d0                	add    %edx,%eax
  8018b3:	c1 e0 02             	shl    $0x2,%eax
  8018b6:	05 48 50 80 00       	add    $0x805048,%eax
  8018bb:	c6 00 01             	movb   $0x1,(%eax)
            break;
  8018be:	eb 0c                	jmp    8018cc <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8018c0:	ff 45 e0             	incl   -0x20(%ebp)
  8018c3:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8018ca:	7e 99                	jle    801865 <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  8018cc:	83 ec 08             	sub    $0x8,%esp
  8018cf:	ff 75 d4             	pushl  -0x2c(%ebp)
  8018d2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018d5:	e8 a2 19 00 00       	call   80327c <sys_allocate_user_mem>
  8018da:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  8018dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8018e0:	c9                   	leave  
  8018e1:	c3                   	ret    

008018e2 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
  8018e5:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  8018e8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018ec:	0f 84 fa 03 00 00    	je     801cec <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  8018f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  8018f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8018fb:	85 c0                	test   %eax,%eax
  8018fd:	79 1c                	jns    80191b <free+0x39>
  8018ff:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  801906:	77 13                	ja     80191b <free+0x39>
    {
        free_block(virtual_address);
  801908:	83 ec 0c             	sub    $0xc,%esp
  80190b:	ff 75 08             	pushl  0x8(%ebp)
  80190e:	e8 09 21 00 00       	call   803a1c <free_block>
  801913:	83 c4 10             	add    $0x10,%esp
        return;
  801916:	e9 d2 03 00 00       	jmp    801ced <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  80191b:	a1 30 51 83 00       	mov    0x835130,%eax
  801920:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  801923:	72 09                	jb     80192e <free+0x4c>
  801925:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  80192c:	76 17                	jbe    801945 <free+0x63>
        panic("free: invalid address");
  80192e:	83 ec 04             	sub    $0x4,%esp
  801931:	68 8d 48 80 00       	push   $0x80488d
  801936:	68 9b 00 00 00       	push   $0x9b
  80193b:	68 44 48 80 00       	push   $0x804844
  801940:	e8 ad e9 ff ff       	call   8002f2 <_panic>

    uint32 size = 0;
  801945:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  80194c:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801953:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80195a:	eb 50                	jmp    8019ac <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  80195c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80195f:	89 d0                	mov    %edx,%eax
  801961:	01 c0                	add    %eax,%eax
  801963:	01 d0                	add    %edx,%eax
  801965:	c1 e0 02             	shl    $0x2,%eax
  801968:	05 48 50 80 00       	add    $0x805048,%eax
  80196d:	8a 00                	mov    (%eax),%al
  80196f:	84 c0                	test   %al,%al
  801971:	74 36                	je     8019a9 <free+0xc7>
  801973:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801976:	89 d0                	mov    %edx,%eax
  801978:	01 c0                	add    %eax,%eax
  80197a:	01 d0                	add    %edx,%eax
  80197c:	c1 e0 02             	shl    $0x2,%eax
  80197f:	05 40 50 80 00       	add    $0x805040,%eax
  801984:	8b 00                	mov    (%eax),%eax
  801986:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801989:	75 1e                	jne    8019a9 <free+0xc7>
        {
            size = uhp_allocs[i].size;
  80198b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80198e:	89 d0                	mov    %edx,%eax
  801990:	01 c0                	add    %eax,%eax
  801992:	01 d0                	add    %edx,%eax
  801994:	c1 e0 02             	shl    $0x2,%eax
  801997:	05 44 50 80 00       	add    $0x805044,%eax
  80199c:	8b 00                	mov    (%eax),%eax
  80199e:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  8019a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  8019a7:	eb 0c                	jmp    8019b5 <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8019a9:	ff 45 ec             	incl   -0x14(%ebp)
  8019ac:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  8019b3:	7e a7                	jle    80195c <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  8019b5:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8019b9:	74 06                	je     8019c1 <free+0xdf>
  8019bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019bf:	75 17                	jne    8019d8 <free+0xf6>
        panic("free: unknown block");
  8019c1:	83 ec 04             	sub    $0x4,%esp
  8019c4:	68 a3 48 80 00       	push   $0x8048a3
  8019c9:	68 a9 00 00 00       	push   $0xa9
  8019ce:	68 44 48 80 00       	push   $0x804844
  8019d3:	e8 1a e9 ff ff       	call   8002f2 <_panic>

    uhp_allocs[idx].used = 0;
  8019d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019db:	89 d0                	mov    %edx,%eax
  8019dd:	01 c0                	add    %eax,%eax
  8019df:	01 d0                	add    %edx,%eax
  8019e1:	c1 e0 02             	shl    $0x2,%eax
  8019e4:	05 48 50 80 00       	add    $0x805048,%eax
  8019e9:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  8019ec:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8019f3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8019fa:	eb 64                	jmp    801a60 <free+0x17e>
    {
        if (!uhp_frees[i].free)
  8019fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8019ff:	89 d0                	mov    %edx,%eax
  801a01:	01 c0                	add    %eax,%eax
  801a03:	01 d0                	add    %edx,%eax
  801a05:	c1 e0 02             	shl    $0x2,%eax
  801a08:	05 48 10 81 00       	add    $0x811048,%eax
  801a0d:	8a 00                	mov    (%eax),%al
  801a0f:	84 c0                	test   %al,%al
  801a11:	75 4a                	jne    801a5d <free+0x17b>
        {
            uhp_frees[i].va = va;
  801a13:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a16:	89 d0                	mov    %edx,%eax
  801a18:	01 c0                	add    %eax,%eax
  801a1a:	01 d0                	add    %edx,%eax
  801a1c:	c1 e0 02             	shl    $0x2,%eax
  801a1f:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  801a25:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a28:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  801a2a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a2d:	89 d0                	mov    %edx,%eax
  801a2f:	01 c0                	add    %eax,%eax
  801a31:	01 d0                	add    %edx,%eax
  801a33:	c1 e0 02             	shl    $0x2,%eax
  801a36:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  801a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a3f:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  801a41:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a44:	89 d0                	mov    %edx,%eax
  801a46:	01 c0                	add    %eax,%eax
  801a48:	01 d0                	add    %edx,%eax
  801a4a:	c1 e0 02             	shl    $0x2,%eax
  801a4d:	05 48 10 81 00       	add    $0x811048,%eax
  801a52:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  801a55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a58:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  801a5b:	eb 0c                	jmp    801a69 <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801a5d:	ff 45 e4             	incl   -0x1c(%ebp)
  801a60:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  801a67:	7e 93                	jle    8019fc <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  801a69:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  801a6d:	0f 84 f1 01 00 00    	je     801c64 <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801a73:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801a7a:	e9 d8 01 00 00       	jmp    801c57 <free+0x375>
        {
            if (i == fidx) continue;
  801a7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a82:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801a85:	0f 84 c8 01 00 00    	je     801c53 <free+0x371>
            if (uhp_frees[i].free)
  801a8b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a8e:	89 d0                	mov    %edx,%eax
  801a90:	01 c0                	add    %eax,%eax
  801a92:	01 d0                	add    %edx,%eax
  801a94:	c1 e0 02             	shl    $0x2,%eax
  801a97:	05 48 10 81 00       	add    $0x811048,%eax
  801a9c:	8a 00                	mov    (%eax),%al
  801a9e:	84 c0                	test   %al,%al
  801aa0:	0f 84 ae 01 00 00    	je     801c54 <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  801aa6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801aa9:	89 d0                	mov    %edx,%eax
  801aab:	01 c0                	add    %eax,%eax
  801aad:	01 d0                	add    %edx,%eax
  801aaf:	c1 e0 02             	shl    $0x2,%eax
  801ab2:	05 40 10 81 00       	add    $0x811040,%eax
  801ab7:	8b 08                	mov    (%eax),%ecx
  801ab9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801abc:	89 d0                	mov    %edx,%eax
  801abe:	01 c0                	add    %eax,%eax
  801ac0:	01 d0                	add    %edx,%eax
  801ac2:	c1 e0 02             	shl    $0x2,%eax
  801ac5:	05 44 10 81 00       	add    $0x811044,%eax
  801aca:	8b 00                	mov    (%eax),%eax
  801acc:	01 c1                	add    %eax,%ecx
  801ace:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ad1:	89 d0                	mov    %edx,%eax
  801ad3:	01 c0                	add    %eax,%eax
  801ad5:	01 d0                	add    %edx,%eax
  801ad7:	c1 e0 02             	shl    $0x2,%eax
  801ada:	05 40 10 81 00       	add    $0x811040,%eax
  801adf:	8b 00                	mov    (%eax),%eax
  801ae1:	39 c1                	cmp    %eax,%ecx
  801ae3:	0f 85 a8 00 00 00    	jne    801b91 <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  801ae9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801aec:	89 d0                	mov    %edx,%eax
  801aee:	01 c0                	add    %eax,%eax
  801af0:	01 d0                	add    %edx,%eax
  801af2:	c1 e0 02             	shl    $0x2,%eax
  801af5:	05 40 10 81 00       	add    $0x811040,%eax
  801afa:	8b 10                	mov    (%eax),%edx
  801afc:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  801aff:	89 c8                	mov    %ecx,%eax
  801b01:	01 c0                	add    %eax,%eax
  801b03:	01 c8                	add    %ecx,%eax
  801b05:	c1 e0 02             	shl    $0x2,%eax
  801b08:	05 40 10 81 00       	add    $0x811040,%eax
  801b0d:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801b0f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b12:	89 d0                	mov    %edx,%eax
  801b14:	01 c0                	add    %eax,%eax
  801b16:	01 d0                	add    %edx,%eax
  801b18:	c1 e0 02             	shl    $0x2,%eax
  801b1b:	05 44 10 81 00       	add    $0x811044,%eax
  801b20:	8b 08                	mov    (%eax),%ecx
  801b22:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b25:	89 d0                	mov    %edx,%eax
  801b27:	01 c0                	add    %eax,%eax
  801b29:	01 d0                	add    %edx,%eax
  801b2b:	c1 e0 02             	shl    $0x2,%eax
  801b2e:	05 44 10 81 00       	add    $0x811044,%eax
  801b33:	8b 00                	mov    (%eax),%eax
  801b35:	01 c1                	add    %eax,%ecx
  801b37:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b3a:	89 d0                	mov    %edx,%eax
  801b3c:	01 c0                	add    %eax,%eax
  801b3e:	01 d0                	add    %edx,%eax
  801b40:	c1 e0 02             	shl    $0x2,%eax
  801b43:	05 44 10 81 00       	add    $0x811044,%eax
  801b48:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801b4a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b4d:	89 d0                	mov    %edx,%eax
  801b4f:	01 c0                	add    %eax,%eax
  801b51:	01 d0                	add    %edx,%eax
  801b53:	c1 e0 02             	shl    $0x2,%eax
  801b56:	05 48 10 81 00       	add    $0x811048,%eax
  801b5b:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801b5e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b61:	89 d0                	mov    %edx,%eax
  801b63:	01 c0                	add    %eax,%eax
  801b65:	01 d0                	add    %edx,%eax
  801b67:	c1 e0 02             	shl    $0x2,%eax
  801b6a:	05 40 10 81 00       	add    $0x811040,%eax
  801b6f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801b75:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b78:	89 d0                	mov    %edx,%eax
  801b7a:	01 c0                	add    %eax,%eax
  801b7c:	01 d0                	add    %edx,%eax
  801b7e:	c1 e0 02             	shl    $0x2,%eax
  801b81:	05 44 10 81 00       	add    $0x811044,%eax
  801b86:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801b8c:	e9 c3 00 00 00       	jmp    801c54 <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  801b91:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b94:	89 d0                	mov    %edx,%eax
  801b96:	01 c0                	add    %eax,%eax
  801b98:	01 d0                	add    %edx,%eax
  801b9a:	c1 e0 02             	shl    $0x2,%eax
  801b9d:	05 40 10 81 00       	add    $0x811040,%eax
  801ba2:	8b 08                	mov    (%eax),%ecx
  801ba4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ba7:	89 d0                	mov    %edx,%eax
  801ba9:	01 c0                	add    %eax,%eax
  801bab:	01 d0                	add    %edx,%eax
  801bad:	c1 e0 02             	shl    $0x2,%eax
  801bb0:	05 44 10 81 00       	add    $0x811044,%eax
  801bb5:	8b 00                	mov    (%eax),%eax
  801bb7:	01 c1                	add    %eax,%ecx
  801bb9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bbc:	89 d0                	mov    %edx,%eax
  801bbe:	01 c0                	add    %eax,%eax
  801bc0:	01 d0                	add    %edx,%eax
  801bc2:	c1 e0 02             	shl    $0x2,%eax
  801bc5:	05 40 10 81 00       	add    $0x811040,%eax
  801bca:	8b 00                	mov    (%eax),%eax
  801bcc:	39 c1                	cmp    %eax,%ecx
  801bce:	0f 85 80 00 00 00    	jne    801c54 <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801bd4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801bd7:	89 d0                	mov    %edx,%eax
  801bd9:	01 c0                	add    %eax,%eax
  801bdb:	01 d0                	add    %edx,%eax
  801bdd:	c1 e0 02             	shl    $0x2,%eax
  801be0:	05 44 10 81 00       	add    $0x811044,%eax
  801be5:	8b 08                	mov    (%eax),%ecx
  801be7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bea:	89 d0                	mov    %edx,%eax
  801bec:	01 c0                	add    %eax,%eax
  801bee:	01 d0                	add    %edx,%eax
  801bf0:	c1 e0 02             	shl    $0x2,%eax
  801bf3:	05 44 10 81 00       	add    $0x811044,%eax
  801bf8:	8b 00                	mov    (%eax),%eax
  801bfa:	01 c1                	add    %eax,%ecx
  801bfc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801bff:	89 d0                	mov    %edx,%eax
  801c01:	01 c0                	add    %eax,%eax
  801c03:	01 d0                	add    %edx,%eax
  801c05:	c1 e0 02             	shl    $0x2,%eax
  801c08:	05 44 10 81 00       	add    $0x811044,%eax
  801c0d:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801c0f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c12:	89 d0                	mov    %edx,%eax
  801c14:	01 c0                	add    %eax,%eax
  801c16:	01 d0                	add    %edx,%eax
  801c18:	c1 e0 02             	shl    $0x2,%eax
  801c1b:	05 48 10 81 00       	add    $0x811048,%eax
  801c20:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801c23:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c26:	89 d0                	mov    %edx,%eax
  801c28:	01 c0                	add    %eax,%eax
  801c2a:	01 d0                	add    %edx,%eax
  801c2c:	c1 e0 02             	shl    $0x2,%eax
  801c2f:	05 40 10 81 00       	add    $0x811040,%eax
  801c34:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801c3a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c3d:	89 d0                	mov    %edx,%eax
  801c3f:	01 c0                	add    %eax,%eax
  801c41:	01 d0                	add    %edx,%eax
  801c43:	c1 e0 02             	shl    $0x2,%eax
  801c46:	05 44 10 81 00       	add    $0x811044,%eax
  801c4b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c51:	eb 01                	jmp    801c54 <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  801c53:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801c54:	ff 45 e0             	incl   -0x20(%ebp)
  801c57:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801c5e:	0f 8e 1b fe ff ff    	jle    801a7f <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  801c64:	a1 30 51 83 00       	mov    0x835130,%eax
  801c69:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801c6c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801c73:	eb 53                	jmp    801cc8 <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  801c75:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801c78:	89 d0                	mov    %edx,%eax
  801c7a:	01 c0                	add    %eax,%eax
  801c7c:	01 d0                	add    %edx,%eax
  801c7e:	c1 e0 02             	shl    $0x2,%eax
  801c81:	05 48 50 80 00       	add    $0x805048,%eax
  801c86:	8a 00                	mov    (%eax),%al
  801c88:	84 c0                	test   %al,%al
  801c8a:	74 39                	je     801cc5 <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  801c8c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801c8f:	89 d0                	mov    %edx,%eax
  801c91:	01 c0                	add    %eax,%eax
  801c93:	01 d0                	add    %edx,%eax
  801c95:	c1 e0 02             	shl    $0x2,%eax
  801c98:	05 40 50 80 00       	add    $0x805040,%eax
  801c9d:	8b 08                	mov    (%eax),%ecx
  801c9f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801ca2:	89 d0                	mov    %edx,%eax
  801ca4:	01 c0                	add    %eax,%eax
  801ca6:	01 d0                	add    %edx,%eax
  801ca8:	c1 e0 02             	shl    $0x2,%eax
  801cab:	05 44 50 80 00       	add    $0x805044,%eax
  801cb0:	8b 00                	mov    (%eax),%eax
  801cb2:	01 c8                	add    %ecx,%eax
  801cb4:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  801cb7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801cba:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801cbd:	76 06                	jbe    801cc5 <free+0x3e3>
  801cbf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801cc2:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801cc5:	ff 45 d8             	incl   -0x28(%ebp)
  801cc8:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  801ccf:	7e a4                	jle    801c75 <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  801cd1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801cd4:	a3 88 50 83 00       	mov    %eax,0x835088

    sys_free_user_mem(va, size);
  801cd9:	83 ec 08             	sub    $0x8,%esp
  801cdc:	ff 75 f4             	pushl  -0xc(%ebp)
  801cdf:	ff 75 d4             	pushl  -0x2c(%ebp)
  801ce2:	e8 79 15 00 00       	call   803260 <sys_free_user_mem>
  801ce7:	83 c4 10             	add    $0x10,%esp
  801cea:	eb 01                	jmp    801ced <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  801cec:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  801ced:	c9                   	leave  
  801cee:	c3                   	ret    

00801cef <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801cef:	55                   	push   %ebp
  801cf0:	89 e5                	mov    %esp,%ebp
  801cf2:	83 ec 68             	sub    $0x68,%esp
  801cf5:	8b 45 10             	mov    0x10(%ebp),%eax
  801cf8:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801cfb:	e8 a5 f7 ff ff       	call   8014a5 <uheap_init>
	if (size == 0) return NULL ;
  801d00:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d04:	75 0a                	jne    801d10 <smalloc+0x21>
  801d06:	b8 00 00 00 00       	mov    $0x0,%eax
  801d0b:	e9 37 03 00 00       	jmp    802047 <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801d10:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801d17:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d1a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d1d:	01 d0                	add    %edx,%eax
  801d1f:	48                   	dec    %eax
  801d20:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801d23:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d26:	ba 00 00 00 00       	mov    $0x0,%edx
  801d2b:	f7 75 dc             	divl   -0x24(%ebp)
  801d2e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d31:	29 d0                	sub    %edx,%eax
  801d33:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  801d36:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801d3d:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801d44:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801d4b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801d52:	e9 85 00 00 00       	jmp    801ddc <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801d57:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d5a:	89 d0                	mov    %edx,%eax
  801d5c:	01 c0                	add    %eax,%eax
  801d5e:	01 d0                	add    %edx,%eax
  801d60:	c1 e0 02             	shl    $0x2,%eax
  801d63:	05 48 10 81 00       	add    $0x811048,%eax
  801d68:	8a 00                	mov    (%eax),%al
  801d6a:	84 c0                	test   %al,%al
  801d6c:	74 20                	je     801d8e <smalloc+0x9f>
  801d6e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d71:	89 d0                	mov    %edx,%eax
  801d73:	01 c0                	add    %eax,%eax
  801d75:	01 d0                	add    %edx,%eax
  801d77:	c1 e0 02             	shl    $0x2,%eax
  801d7a:	05 44 10 81 00       	add    $0x811044,%eax
  801d7f:	8b 00                	mov    (%eax),%eax
  801d81:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801d84:	75 08                	jne    801d8e <smalloc+0x9f>
        {
            exactIdx = i;
  801d86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d89:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801d8c:	eb 5b                	jmp    801de9 <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801d8e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d91:	89 d0                	mov    %edx,%eax
  801d93:	01 c0                	add    %eax,%eax
  801d95:	01 d0                	add    %edx,%eax
  801d97:	c1 e0 02             	shl    $0x2,%eax
  801d9a:	05 48 10 81 00       	add    $0x811048,%eax
  801d9f:	8a 00                	mov    (%eax),%al
  801da1:	84 c0                	test   %al,%al
  801da3:	74 34                	je     801dd9 <smalloc+0xea>
  801da5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801da8:	89 d0                	mov    %edx,%eax
  801daa:	01 c0                	add    %eax,%eax
  801dac:	01 d0                	add    %edx,%eax
  801dae:	c1 e0 02             	shl    $0x2,%eax
  801db1:	05 44 10 81 00       	add    $0x811044,%eax
  801db6:	8b 00                	mov    (%eax),%eax
  801db8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801dbb:	76 1c                	jbe    801dd9 <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  801dbd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801dc0:	89 d0                	mov    %edx,%eax
  801dc2:	01 c0                	add    %eax,%eax
  801dc4:	01 d0                	add    %edx,%eax
  801dc6:	c1 e0 02             	shl    $0x2,%eax
  801dc9:	05 44 10 81 00       	add    $0x811044,%eax
  801dce:	8b 00                	mov    (%eax),%eax
  801dd0:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801dd3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801dd6:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801dd9:	ff 45 e8             	incl   -0x18(%ebp)
  801ddc:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801de3:	0f 8e 6e ff ff ff    	jle    801d57 <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  801de9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801df0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801df4:	74 7d                	je     801e73 <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801df6:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801dfd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e00:	89 d0                	mov    %edx,%eax
  801e02:	01 c0                	add    %eax,%eax
  801e04:	01 d0                	add    %edx,%eax
  801e06:	c1 e0 02             	shl    $0x2,%eax
  801e09:	05 40 10 81 00       	add    $0x811040,%eax
  801e0e:	8b 10                	mov    (%eax),%edx
  801e10:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801e13:	01 d0                	add    %edx,%eax
  801e15:	48                   	dec    %eax
  801e16:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801e19:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801e1c:	ba 00 00 00 00       	mov    $0x0,%edx
  801e21:	f7 75 bc             	divl   -0x44(%ebp)
  801e24:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801e27:	29 d0                	sub    %edx,%eax
  801e29:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801e2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e2f:	89 d0                	mov    %edx,%eax
  801e31:	01 c0                	add    %eax,%eax
  801e33:	01 d0                	add    %edx,%eax
  801e35:	c1 e0 02             	shl    $0x2,%eax
  801e38:	05 48 10 81 00       	add    $0x811048,%eax
  801e3d:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801e40:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e43:	89 d0                	mov    %edx,%eax
  801e45:	01 c0                	add    %eax,%eax
  801e47:	01 d0                	add    %edx,%eax
  801e49:	c1 e0 02             	shl    $0x2,%eax
  801e4c:	05 44 10 81 00       	add    $0x811044,%eax
  801e51:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801e57:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e5a:	89 d0                	mov    %edx,%eax
  801e5c:	01 c0                	add    %eax,%eax
  801e5e:	01 d0                	add    %edx,%eax
  801e60:	c1 e0 02             	shl    $0x2,%eax
  801e63:	05 40 10 81 00       	add    $0x811040,%eax
  801e68:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e6e:	e9 2d 01 00 00       	jmp    801fa0 <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  801e73:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801e77:	0f 84 ce 00 00 00    	je     801f4b <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  801e7d:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  801e84:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e87:	89 d0                	mov    %edx,%eax
  801e89:	01 c0                	add    %eax,%eax
  801e8b:	01 d0                	add    %edx,%eax
  801e8d:	c1 e0 02             	shl    $0x2,%eax
  801e90:	05 40 10 81 00       	add    $0x811040,%eax
  801e95:	8b 10                	mov    (%eax),%edx
  801e97:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801e9a:	01 d0                	add    %edx,%eax
  801e9c:	48                   	dec    %eax
  801e9d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  801ea0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801ea3:	ba 00 00 00 00       	mov    $0x0,%edx
  801ea8:	f7 75 c4             	divl   -0x3c(%ebp)
  801eab:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801eae:	29 d0                	sub    %edx,%eax
  801eb0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  801eb3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801eb6:	89 d0                	mov    %edx,%eax
  801eb8:	01 c0                	add    %eax,%eax
  801eba:	01 d0                	add    %edx,%eax
  801ebc:	c1 e0 02             	shl    $0x2,%eax
  801ebf:	05 44 10 81 00       	add    $0x811044,%eax
  801ec4:	8b 00                	mov    (%eax),%eax
  801ec6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801ec9:	75 47                	jne    801f12 <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  801ecb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ece:	89 d0                	mov    %edx,%eax
  801ed0:	01 c0                	add    %eax,%eax
  801ed2:	01 d0                	add    %edx,%eax
  801ed4:	c1 e0 02             	shl    $0x2,%eax
  801ed7:	05 48 10 81 00       	add    $0x811048,%eax
  801edc:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  801edf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ee2:	89 d0                	mov    %edx,%eax
  801ee4:	01 c0                	add    %eax,%eax
  801ee6:	01 d0                	add    %edx,%eax
  801ee8:	c1 e0 02             	shl    $0x2,%eax
  801eeb:	05 44 10 81 00       	add    $0x811044,%eax
  801ef0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  801ef6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ef9:	89 d0                	mov    %edx,%eax
  801efb:	01 c0                	add    %eax,%eax
  801efd:	01 d0                	add    %edx,%eax
  801eff:	c1 e0 02             	shl    $0x2,%eax
  801f02:	05 40 10 81 00       	add    $0x811040,%eax
  801f07:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f0d:	e9 8e 00 00 00       	jmp    801fa0 <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  801f12:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801f15:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f18:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801f1b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f1e:	89 d0                	mov    %edx,%eax
  801f20:	01 c0                	add    %eax,%eax
  801f22:	01 d0                	add    %edx,%eax
  801f24:	c1 e0 02             	shl    $0x2,%eax
  801f27:	05 40 10 81 00       	add    $0x811040,%eax
  801f2c:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  801f2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f31:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801f34:	89 c2                	mov    %eax,%edx
  801f36:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801f39:	89 c8                	mov    %ecx,%eax
  801f3b:	01 c0                	add    %eax,%eax
  801f3d:	01 c8                	add    %ecx,%eax
  801f3f:	c1 e0 02             	shl    $0x2,%eax
  801f42:	05 44 10 81 00       	add    $0x811044,%eax
  801f47:	89 10                	mov    %edx,(%eax)
  801f49:	eb 55                	jmp    801fa0 <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  801f4b:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801f52:	8b 15 88 50 83 00    	mov    0x835088,%edx
  801f58:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f5b:	01 d0                	add    %edx,%eax
  801f5d:	48                   	dec    %eax
  801f5e:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801f61:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801f64:	ba 00 00 00 00       	mov    $0x0,%edx
  801f69:	f7 75 d0             	divl   -0x30(%ebp)
  801f6c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801f6f:	29 d0                	sub    %edx,%eax
  801f71:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  801f74:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801f77:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f7a:	01 d0                	add    %edx,%eax
  801f7c:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801f81:	76 0a                	jbe    801f8d <smalloc+0x29e>
            return NULL;
  801f83:	b8 00 00 00 00       	mov    $0x0,%eax
  801f88:	e9 ba 00 00 00       	jmp    802047 <smalloc+0x358>
        va = start;
  801f8d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801f90:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  801f93:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801f96:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f99:	01 d0                	add    %edx,%eax
  801f9b:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801fa0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801fa7:	eb 5e                	jmp    802007 <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  801fa9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801fac:	89 d0                	mov    %edx,%eax
  801fae:	01 c0                	add    %eax,%eax
  801fb0:	01 d0                	add    %edx,%eax
  801fb2:	c1 e0 02             	shl    $0x2,%eax
  801fb5:	05 48 50 80 00       	add    $0x805048,%eax
  801fba:	8a 00                	mov    (%eax),%al
  801fbc:	84 c0                	test   %al,%al
  801fbe:	75 44                	jne    802004 <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  801fc0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801fc3:	89 d0                	mov    %edx,%eax
  801fc5:	01 c0                	add    %eax,%eax
  801fc7:	01 d0                	add    %edx,%eax
  801fc9:	c1 e0 02             	shl    $0x2,%eax
  801fcc:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  801fd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fd5:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  801fd7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801fda:	89 d0                	mov    %edx,%eax
  801fdc:	01 c0                	add    %eax,%eax
  801fde:	01 d0                	add    %edx,%eax
  801fe0:	c1 e0 02             	shl    $0x2,%eax
  801fe3:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  801fe9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fec:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  801fee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ff1:	89 d0                	mov    %edx,%eax
  801ff3:	01 c0                	add    %eax,%eax
  801ff5:	01 d0                	add    %edx,%eax
  801ff7:	c1 e0 02             	shl    $0x2,%eax
  801ffa:	05 48 50 80 00       	add    $0x805048,%eax
  801fff:	c6 00 01             	movb   $0x1,(%eax)
            break;
  802002:	eb 0c                	jmp    802010 <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802004:	ff 45 e0             	incl   -0x20(%ebp)
  802007:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80200e:	7e 99                	jle    801fa9 <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  802010:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802013:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  802017:	52                   	push   %edx
  802018:	50                   	push   %eax
  802019:	ff 75 d4             	pushl  -0x2c(%ebp)
  80201c:	ff 75 08             	pushl  0x8(%ebp)
  80201f:	e8 de 0e 00 00       	call   802f02 <sys_create_shared_object>
  802024:	83 c4 10             	add    $0x10,%esp
  802027:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  80202a:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  80202e:	75 07                	jne    802037 <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  802030:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802035:	eb 10                	jmp    802047 <smalloc+0x358>
    if (r < 0)
  802037:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  80203b:	79 07                	jns    802044 <smalloc+0x355>
        return NULL;
  80203d:	b8 00 00 00 00       	mov    $0x0,%eax
  802042:	eb 03                	jmp    802047 <smalloc+0x358>
    return (void*)va;
  802044:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  802047:	c9                   	leave  
  802048:	c3                   	ret    

00802049 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802049:	55                   	push   %ebp
  80204a:	89 e5                	mov    %esp,%ebp
  80204c:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80204f:	e8 51 f4 ff ff       	call   8014a5 <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  802054:	83 ec 08             	sub    $0x8,%esp
  802057:	ff 75 0c             	pushl  0xc(%ebp)
  80205a:	ff 75 08             	pushl  0x8(%ebp)
  80205d:	e8 ca 0e 00 00       	call   802f2c <sys_size_of_shared_object>
  802062:	83 c4 10             	add    $0x10,%esp
  802065:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  802068:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80206c:	7f 0a                	jg     802078 <sget+0x2f>
        return NULL;
  80206e:	b8 00 00 00 00       	mov    $0x0,%eax
  802073:	e9 28 03 00 00       	jmp    8023a0 <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  802078:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80207f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802082:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802085:	01 d0                	add    %edx,%eax
  802087:	48                   	dec    %eax
  802088:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80208b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80208e:	ba 00 00 00 00       	mov    $0x0,%edx
  802093:	f7 75 d8             	divl   -0x28(%ebp)
  802096:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802099:	29 d0                	sub    %edx,%eax
  80209b:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  80209e:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  8020a5:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  8020ac:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8020b3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8020ba:	e9 85 00 00 00       	jmp    802144 <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  8020bf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8020c2:	89 d0                	mov    %edx,%eax
  8020c4:	01 c0                	add    %eax,%eax
  8020c6:	01 d0                	add    %edx,%eax
  8020c8:	c1 e0 02             	shl    $0x2,%eax
  8020cb:	05 48 10 81 00       	add    $0x811048,%eax
  8020d0:	8a 00                	mov    (%eax),%al
  8020d2:	84 c0                	test   %al,%al
  8020d4:	74 20                	je     8020f6 <sget+0xad>
  8020d6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8020d9:	89 d0                	mov    %edx,%eax
  8020db:	01 c0                	add    %eax,%eax
  8020dd:	01 d0                	add    %edx,%eax
  8020df:	c1 e0 02             	shl    $0x2,%eax
  8020e2:	05 44 10 81 00       	add    $0x811044,%eax
  8020e7:	8b 00                	mov    (%eax),%eax
  8020e9:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8020ec:	75 08                	jne    8020f6 <sget+0xad>
        {
            exactIdx = i;
  8020ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  8020f4:	eb 5b                	jmp    802151 <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  8020f6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8020f9:	89 d0                	mov    %edx,%eax
  8020fb:	01 c0                	add    %eax,%eax
  8020fd:	01 d0                	add    %edx,%eax
  8020ff:	c1 e0 02             	shl    $0x2,%eax
  802102:	05 48 10 81 00       	add    $0x811048,%eax
  802107:	8a 00                	mov    (%eax),%al
  802109:	84 c0                	test   %al,%al
  80210b:	74 34                	je     802141 <sget+0xf8>
  80210d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802110:	89 d0                	mov    %edx,%eax
  802112:	01 c0                	add    %eax,%eax
  802114:	01 d0                	add    %edx,%eax
  802116:	c1 e0 02             	shl    $0x2,%eax
  802119:	05 44 10 81 00       	add    $0x811044,%eax
  80211e:	8b 00                	mov    (%eax),%eax
  802120:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802123:	76 1c                	jbe    802141 <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  802125:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802128:	89 d0                	mov    %edx,%eax
  80212a:	01 c0                	add    %eax,%eax
  80212c:	01 d0                	add    %edx,%eax
  80212e:	c1 e0 02             	shl    $0x2,%eax
  802131:	05 44 10 81 00       	add    $0x811044,%eax
  802136:	8b 00                	mov    (%eax),%eax
  802138:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  80213b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80213e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802141:	ff 45 e8             	incl   -0x18(%ebp)
  802144:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  80214b:	0f 8e 6e ff ff ff    	jle    8020bf <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  802151:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  802158:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  80215c:	74 7d                	je     8021db <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  80215e:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802165:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802168:	89 d0                	mov    %edx,%eax
  80216a:	01 c0                	add    %eax,%eax
  80216c:	01 d0                	add    %edx,%eax
  80216e:	c1 e0 02             	shl    $0x2,%eax
  802171:	05 40 10 81 00       	add    $0x811040,%eax
  802176:	8b 10                	mov    (%eax),%edx
  802178:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80217b:	01 d0                	add    %edx,%eax
  80217d:	48                   	dec    %eax
  80217e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802181:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802184:	ba 00 00 00 00       	mov    $0x0,%edx
  802189:	f7 75 b8             	divl   -0x48(%ebp)
  80218c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80218f:	29 d0                	sub    %edx,%eax
  802191:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  802194:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802197:	89 d0                	mov    %edx,%eax
  802199:	01 c0                	add    %eax,%eax
  80219b:	01 d0                	add    %edx,%eax
  80219d:	c1 e0 02             	shl    $0x2,%eax
  8021a0:	05 48 10 81 00       	add    $0x811048,%eax
  8021a5:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  8021a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021ab:	89 d0                	mov    %edx,%eax
  8021ad:	01 c0                	add    %eax,%eax
  8021af:	01 d0                	add    %edx,%eax
  8021b1:	c1 e0 02             	shl    $0x2,%eax
  8021b4:	05 44 10 81 00       	add    $0x811044,%eax
  8021b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  8021bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021c2:	89 d0                	mov    %edx,%eax
  8021c4:	01 c0                	add    %eax,%eax
  8021c6:	01 d0                	add    %edx,%eax
  8021c8:	c1 e0 02             	shl    $0x2,%eax
  8021cb:	05 40 10 81 00       	add    $0x811040,%eax
  8021d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021d6:	e9 2d 01 00 00       	jmp    802308 <sget+0x2bf>
    }
    else if (worstIdx != -1)
  8021db:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8021df:	0f 84 ce 00 00 00    	je     8022b3 <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  8021e5:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  8021ec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021ef:	89 d0                	mov    %edx,%eax
  8021f1:	01 c0                	add    %eax,%eax
  8021f3:	01 d0                	add    %edx,%eax
  8021f5:	c1 e0 02             	shl    $0x2,%eax
  8021f8:	05 40 10 81 00       	add    $0x811040,%eax
  8021fd:	8b 10                	mov    (%eax),%edx
  8021ff:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802202:	01 d0                	add    %edx,%eax
  802204:	48                   	dec    %eax
  802205:	89 45 bc             	mov    %eax,-0x44(%ebp)
  802208:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80220b:	ba 00 00 00 00       	mov    $0x0,%edx
  802210:	f7 75 c0             	divl   -0x40(%ebp)
  802213:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802216:	29 d0                	sub    %edx,%eax
  802218:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  80221b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80221e:	89 d0                	mov    %edx,%eax
  802220:	01 c0                	add    %eax,%eax
  802222:	01 d0                	add    %edx,%eax
  802224:	c1 e0 02             	shl    $0x2,%eax
  802227:	05 44 10 81 00       	add    $0x811044,%eax
  80222c:	8b 00                	mov    (%eax),%eax
  80222e:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802231:	75 47                	jne    80227a <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  802233:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802236:	89 d0                	mov    %edx,%eax
  802238:	01 c0                	add    %eax,%eax
  80223a:	01 d0                	add    %edx,%eax
  80223c:	c1 e0 02             	shl    $0x2,%eax
  80223f:	05 48 10 81 00       	add    $0x811048,%eax
  802244:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  802247:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80224a:	89 d0                	mov    %edx,%eax
  80224c:	01 c0                	add    %eax,%eax
  80224e:	01 d0                	add    %edx,%eax
  802250:	c1 e0 02             	shl    $0x2,%eax
  802253:	05 44 10 81 00       	add    $0x811044,%eax
  802258:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  80225e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802261:	89 d0                	mov    %edx,%eax
  802263:	01 c0                	add    %eax,%eax
  802265:	01 d0                	add    %edx,%eax
  802267:	c1 e0 02             	shl    $0x2,%eax
  80226a:	05 40 10 81 00       	add    $0x811040,%eax
  80226f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802275:	e9 8e 00 00 00       	jmp    802308 <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  80227a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80227d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802280:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802283:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802286:	89 d0                	mov    %edx,%eax
  802288:	01 c0                	add    %eax,%eax
  80228a:	01 d0                	add    %edx,%eax
  80228c:	c1 e0 02             	shl    $0x2,%eax
  80228f:	05 40 10 81 00       	add    $0x811040,%eax
  802294:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  802296:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802299:	2b 45 d0             	sub    -0x30(%ebp),%eax
  80229c:	89 c2                	mov    %eax,%edx
  80229e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8022a1:	89 c8                	mov    %ecx,%eax
  8022a3:	01 c0                	add    %eax,%eax
  8022a5:	01 c8                	add    %ecx,%eax
  8022a7:	c1 e0 02             	shl    $0x2,%eax
  8022aa:	05 44 10 81 00       	add    $0x811044,%eax
  8022af:	89 10                	mov    %edx,(%eax)
  8022b1:	eb 55                	jmp    802308 <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  8022b3:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8022ba:	8b 15 88 50 83 00    	mov    0x835088,%edx
  8022c0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8022c3:	01 d0                	add    %edx,%eax
  8022c5:	48                   	dec    %eax
  8022c6:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8022c9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8022cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8022d1:	f7 75 cc             	divl   -0x34(%ebp)
  8022d4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8022d7:	29 d0                	sub    %edx,%eax
  8022d9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  8022dc:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8022df:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8022e2:	01 d0                	add    %edx,%eax
  8022e4:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8022e9:	76 0a                	jbe    8022f5 <sget+0x2ac>
            return NULL;
  8022eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f0:	e9 ab 00 00 00       	jmp    8023a0 <sget+0x357>
        va = start;
  8022f5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8022f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  8022fb:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8022fe:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802301:	01 d0                	add    %edx,%eax
  802303:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802308:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80230f:	eb 5e                	jmp    80236f <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  802311:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802314:	89 d0                	mov    %edx,%eax
  802316:	01 c0                	add    %eax,%eax
  802318:	01 d0                	add    %edx,%eax
  80231a:	c1 e0 02             	shl    $0x2,%eax
  80231d:	05 48 50 80 00       	add    $0x805048,%eax
  802322:	8a 00                	mov    (%eax),%al
  802324:	84 c0                	test   %al,%al
  802326:	75 44                	jne    80236c <sget+0x323>
        {
            uhp_allocs[i].va = va;
  802328:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80232b:	89 d0                	mov    %edx,%eax
  80232d:	01 c0                	add    %eax,%eax
  80232f:	01 d0                	add    %edx,%eax
  802331:	c1 e0 02             	shl    $0x2,%eax
  802334:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  80233a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80233d:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  80233f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802342:	89 d0                	mov    %edx,%eax
  802344:	01 c0                	add    %eax,%eax
  802346:	01 d0                	add    %edx,%eax
  802348:	c1 e0 02             	shl    $0x2,%eax
  80234b:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802351:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802354:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  802356:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802359:	89 d0                	mov    %edx,%eax
  80235b:	01 c0                	add    %eax,%eax
  80235d:	01 d0                	add    %edx,%eax
  80235f:	c1 e0 02             	shl    $0x2,%eax
  802362:	05 48 50 80 00       	add    $0x805048,%eax
  802367:	c6 00 01             	movb   $0x1,(%eax)
            break;
  80236a:	eb 0c                	jmp    802378 <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80236c:	ff 45 e0             	incl   -0x20(%ebp)
  80236f:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802376:	7e 99                	jle    802311 <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  802378:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80237b:	83 ec 04             	sub    $0x4,%esp
  80237e:	50                   	push   %eax
  80237f:	ff 75 0c             	pushl  0xc(%ebp)
  802382:	ff 75 08             	pushl  0x8(%ebp)
  802385:	e8 bf 0b 00 00       	call   802f49 <sys_get_shared_object>
  80238a:	83 c4 10             	add    $0x10,%esp
  80238d:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  802390:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802394:	79 07                	jns    80239d <sget+0x354>
        return NULL;
  802396:	b8 00 00 00 00       	mov    $0x0,%eax
  80239b:	eb 03                	jmp    8023a0 <sget+0x357>
    return (void*)va;
  80239d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8023a0:	c9                   	leave  
  8023a1:	c3                   	ret    

008023a2 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8023a2:	55                   	push   %ebp
  8023a3:	89 e5                	mov    %esp,%ebp
  8023a5:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8023a8:	e8 f8 f0 ff ff       	call   8014a5 <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  8023ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023b1:	75 13                	jne    8023c6 <realloc+0x24>
		return malloc(new_size);
  8023b3:	83 ec 0c             	sub    $0xc,%esp
  8023b6:	ff 75 0c             	pushl  0xc(%ebp)
  8023b9:	e8 c4 f1 ff ff       	call   801582 <malloc>
  8023be:	83 c4 10             	add    $0x10,%esp
  8023c1:	e9 f4 05 00 00       	jmp    8029ba <realloc+0x618>
	if (new_size == 0)
  8023c6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8023ca:	75 18                	jne    8023e4 <realloc+0x42>
	{
		free(virtual_address);
  8023cc:	83 ec 0c             	sub    $0xc,%esp
  8023cf:	ff 75 08             	pushl  0x8(%ebp)
  8023d2:	e8 0b f5 ff ff       	call   8018e2 <free>
  8023d7:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8023da:	b8 00 00 00 00       	mov    $0x0,%eax
  8023df:	e9 d6 05 00 00       	jmp    8029ba <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  8023e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e7:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  8023ea:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8023ed:	85 c0                	test   %eax,%eax
  8023ef:	79 74                	jns    802465 <realloc+0xc3>
  8023f1:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  8023f8:	77 6b                	ja     802465 <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  8023fa:	83 ec 0c             	sub    $0xc,%esp
  8023fd:	ff 75 0c             	pushl  0xc(%ebp)
  802400:	e8 7d f1 ff ff       	call   801582 <malloc>
  802405:	83 c4 10             	add    $0x10,%esp
  802408:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  80240b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80240f:	75 0a                	jne    80241b <realloc+0x79>
			return NULL;
  802411:	b8 00 00 00 00       	mov    $0x0,%eax
  802416:	e9 9f 05 00 00       	jmp    8029ba <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  80241b:	83 ec 0c             	sub    $0xc,%esp
  80241e:	ff 75 08             	pushl  0x8(%ebp)
  802421:	e8 e0 11 00 00       	call   803606 <get_block_size>
  802426:	83 c4 10             	add    $0x10,%esp
  802429:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  80242c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80242f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802432:	39 d0                	cmp    %edx,%eax
  802434:	76 02                	jbe    802438 <realloc+0x96>
  802436:	89 d0                	mov    %edx,%eax
  802438:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  80243b:	83 ec 04             	sub    $0x4,%esp
  80243e:	ff 75 c0             	pushl  -0x40(%ebp)
  802441:	ff 75 08             	pushl  0x8(%ebp)
  802444:	ff 75 c8             	pushl  -0x38(%ebp)
  802447:	e8 56 eb ff ff       	call   800fa2 <memmove>
  80244c:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  80244f:	83 ec 0c             	sub    $0xc,%esp
  802452:	ff 75 08             	pushl  0x8(%ebp)
  802455:	e8 88 f4 ff ff       	call   8018e2 <free>
  80245a:	83 c4 10             	add    $0x10,%esp
		return newptr;
  80245d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802460:	e9 55 05 00 00       	jmp    8029ba <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  802465:	a1 30 51 83 00       	mov    0x835130,%eax
  80246a:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  80246d:	72 09                	jb     802478 <realloc+0xd6>
  80246f:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  802476:	76 0a                	jbe    802482 <realloc+0xe0>
		return NULL;
  802478:	b8 00 00 00 00       	mov    $0x0,%eax
  80247d:	e9 38 05 00 00       	jmp    8029ba <realloc+0x618>
	uint32 oldsz = 0;
  802482:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  802489:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802490:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802497:	eb 50                	jmp    8024e9 <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802499:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80249c:	89 d0                	mov    %edx,%eax
  80249e:	01 c0                	add    %eax,%eax
  8024a0:	01 d0                	add    %edx,%eax
  8024a2:	c1 e0 02             	shl    $0x2,%eax
  8024a5:	05 48 50 80 00       	add    $0x805048,%eax
  8024aa:	8a 00                	mov    (%eax),%al
  8024ac:	84 c0                	test   %al,%al
  8024ae:	74 36                	je     8024e6 <realloc+0x144>
  8024b0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024b3:	89 d0                	mov    %edx,%eax
  8024b5:	01 c0                	add    %eax,%eax
  8024b7:	01 d0                	add    %edx,%eax
  8024b9:	c1 e0 02             	shl    $0x2,%eax
  8024bc:	05 40 50 80 00       	add    $0x805040,%eax
  8024c1:	8b 00                	mov    (%eax),%eax
  8024c3:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8024c6:	75 1e                	jne    8024e6 <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  8024c8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024cb:	89 d0                	mov    %edx,%eax
  8024cd:	01 c0                	add    %eax,%eax
  8024cf:	01 d0                	add    %edx,%eax
  8024d1:	c1 e0 02             	shl    $0x2,%eax
  8024d4:	05 44 50 80 00       	add    $0x805044,%eax
  8024d9:	8b 00                	mov    (%eax),%eax
  8024db:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  8024de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  8024e4:	eb 0c                	jmp    8024f2 <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8024e6:	ff 45 ec             	incl   -0x14(%ebp)
  8024e9:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  8024f0:	7e a7                	jle    802499 <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  8024f2:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8024f6:	75 0a                	jne    802502 <realloc+0x160>
		return NULL;
  8024f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8024fd:	e9 b8 04 00 00       	jmp    8029ba <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  802502:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  802509:	8b 55 0c             	mov    0xc(%ebp),%edx
  80250c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80250f:	01 d0                	add    %edx,%eax
  802511:	48                   	dec    %eax
  802512:	89 45 b8             	mov    %eax,-0x48(%ebp)
  802515:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802518:	ba 00 00 00 00       	mov    $0x0,%edx
  80251d:	f7 75 bc             	divl   -0x44(%ebp)
  802520:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802523:	29 d0                	sub    %edx,%eax
  802525:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  802528:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80252b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80252e:	75 08                	jne    802538 <realloc+0x196>
		return virtual_address;
  802530:	8b 45 08             	mov    0x8(%ebp),%eax
  802533:	e9 82 04 00 00       	jmp    8029ba <realloc+0x618>
	if (req < oldsz)
  802538:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80253b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80253e:	0f 83 cd 02 00 00    	jae    802811 <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  802544:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802547:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  80254a:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  80254d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802550:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802553:	01 d0                	add    %edx,%eax
  802555:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  802558:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80255b:	89 d0                	mov    %edx,%eax
  80255d:	01 c0                	add    %eax,%eax
  80255f:	01 d0                	add    %edx,%eax
  802561:	c1 e0 02             	shl    $0x2,%eax
  802564:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  80256a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80256d:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  80256f:	83 ec 08             	sub    $0x8,%esp
  802572:	ff 75 b0             	pushl  -0x50(%ebp)
  802575:	ff 75 ac             	pushl  -0x54(%ebp)
  802578:	e8 e3 0c 00 00       	call   803260 <sys_free_user_mem>
  80257d:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  802580:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802587:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80258e:	eb 64                	jmp    8025f4 <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  802590:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802593:	89 d0                	mov    %edx,%eax
  802595:	01 c0                	add    %eax,%eax
  802597:	01 d0                	add    %edx,%eax
  802599:	c1 e0 02             	shl    $0x2,%eax
  80259c:	05 48 10 81 00       	add    $0x811048,%eax
  8025a1:	8a 00                	mov    (%eax),%al
  8025a3:	84 c0                	test   %al,%al
  8025a5:	75 4a                	jne    8025f1 <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  8025a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025aa:	89 d0                	mov    %edx,%eax
  8025ac:	01 c0                	add    %eax,%eax
  8025ae:	01 d0                	add    %edx,%eax
  8025b0:	c1 e0 02             	shl    $0x2,%eax
  8025b3:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  8025b9:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8025bc:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  8025be:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025c1:	89 d0                	mov    %edx,%eax
  8025c3:	01 c0                	add    %eax,%eax
  8025c5:	01 d0                	add    %edx,%eax
  8025c7:	c1 e0 02             	shl    $0x2,%eax
  8025ca:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  8025d0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025d3:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  8025d5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025d8:	89 d0                	mov    %edx,%eax
  8025da:	01 c0                	add    %eax,%eax
  8025dc:	01 d0                	add    %edx,%eax
  8025de:	c1 e0 02             	shl    $0x2,%eax
  8025e1:	05 48 10 81 00       	add    $0x811048,%eax
  8025e6:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  8025e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ec:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  8025ef:	eb 0c                	jmp    8025fd <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8025f1:	ff 45 e4             	incl   -0x1c(%ebp)
  8025f4:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  8025fb:	7e 93                	jle    802590 <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  8025fd:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802601:	0f 84 8d 01 00 00    	je     802794 <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802607:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80260e:	e9 74 01 00 00       	jmp    802787 <realloc+0x3e5>
			{
				if (k == fidx) continue;
  802613:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802616:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802619:	0f 84 64 01 00 00    	je     802783 <realloc+0x3e1>
				if (uhp_frees[k].free)
  80261f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802622:	89 d0                	mov    %edx,%eax
  802624:	01 c0                	add    %eax,%eax
  802626:	01 d0                	add    %edx,%eax
  802628:	c1 e0 02             	shl    $0x2,%eax
  80262b:	05 48 10 81 00       	add    $0x811048,%eax
  802630:	8a 00                	mov    (%eax),%al
  802632:	84 c0                	test   %al,%al
  802634:	0f 84 4a 01 00 00    	je     802784 <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  80263a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80263d:	89 d0                	mov    %edx,%eax
  80263f:	01 c0                	add    %eax,%eax
  802641:	01 d0                	add    %edx,%eax
  802643:	c1 e0 02             	shl    $0x2,%eax
  802646:	05 40 10 81 00       	add    $0x811040,%eax
  80264b:	8b 08                	mov    (%eax),%ecx
  80264d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802650:	89 d0                	mov    %edx,%eax
  802652:	01 c0                	add    %eax,%eax
  802654:	01 d0                	add    %edx,%eax
  802656:	c1 e0 02             	shl    $0x2,%eax
  802659:	05 44 10 81 00       	add    $0x811044,%eax
  80265e:	8b 00                	mov    (%eax),%eax
  802660:	01 c1                	add    %eax,%ecx
  802662:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802665:	89 d0                	mov    %edx,%eax
  802667:	01 c0                	add    %eax,%eax
  802669:	01 d0                	add    %edx,%eax
  80266b:	c1 e0 02             	shl    $0x2,%eax
  80266e:	05 40 10 81 00       	add    $0x811040,%eax
  802673:	8b 00                	mov    (%eax),%eax
  802675:	39 c1                	cmp    %eax,%ecx
  802677:	75 7a                	jne    8026f3 <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  802679:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80267c:	89 d0                	mov    %edx,%eax
  80267e:	01 c0                	add    %eax,%eax
  802680:	01 d0                	add    %edx,%eax
  802682:	c1 e0 02             	shl    $0x2,%eax
  802685:	05 40 10 81 00       	add    $0x811040,%eax
  80268a:	8b 10                	mov    (%eax),%edx
  80268c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  80268f:	89 c8                	mov    %ecx,%eax
  802691:	01 c0                	add    %eax,%eax
  802693:	01 c8                	add    %ecx,%eax
  802695:	c1 e0 02             	shl    $0x2,%eax
  802698:	05 40 10 81 00       	add    $0x811040,%eax
  80269d:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  80269f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026a2:	89 d0                	mov    %edx,%eax
  8026a4:	01 c0                	add    %eax,%eax
  8026a6:	01 d0                	add    %edx,%eax
  8026a8:	c1 e0 02             	shl    $0x2,%eax
  8026ab:	05 44 10 81 00       	add    $0x811044,%eax
  8026b0:	8b 08                	mov    (%eax),%ecx
  8026b2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026b5:	89 d0                	mov    %edx,%eax
  8026b7:	01 c0                	add    %eax,%eax
  8026b9:	01 d0                	add    %edx,%eax
  8026bb:	c1 e0 02             	shl    $0x2,%eax
  8026be:	05 44 10 81 00       	add    $0x811044,%eax
  8026c3:	8b 00                	mov    (%eax),%eax
  8026c5:	01 c1                	add    %eax,%ecx
  8026c7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026ca:	89 d0                	mov    %edx,%eax
  8026cc:	01 c0                	add    %eax,%eax
  8026ce:	01 d0                	add    %edx,%eax
  8026d0:	c1 e0 02             	shl    $0x2,%eax
  8026d3:	05 44 10 81 00       	add    $0x811044,%eax
  8026d8:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  8026da:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026dd:	89 d0                	mov    %edx,%eax
  8026df:	01 c0                	add    %eax,%eax
  8026e1:	01 d0                	add    %edx,%eax
  8026e3:	c1 e0 02             	shl    $0x2,%eax
  8026e6:	05 48 10 81 00       	add    $0x811048,%eax
  8026eb:	c6 00 00             	movb   $0x0,(%eax)
  8026ee:	e9 91 00 00 00       	jmp    802784 <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  8026f3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026f6:	89 d0                	mov    %edx,%eax
  8026f8:	01 c0                	add    %eax,%eax
  8026fa:	01 d0                	add    %edx,%eax
  8026fc:	c1 e0 02             	shl    $0x2,%eax
  8026ff:	05 40 10 81 00       	add    $0x811040,%eax
  802704:	8b 08                	mov    (%eax),%ecx
  802706:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802709:	89 d0                	mov    %edx,%eax
  80270b:	01 c0                	add    %eax,%eax
  80270d:	01 d0                	add    %edx,%eax
  80270f:	c1 e0 02             	shl    $0x2,%eax
  802712:	05 44 10 81 00       	add    $0x811044,%eax
  802717:	8b 00                	mov    (%eax),%eax
  802719:	01 c1                	add    %eax,%ecx
  80271b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80271e:	89 d0                	mov    %edx,%eax
  802720:	01 c0                	add    %eax,%eax
  802722:	01 d0                	add    %edx,%eax
  802724:	c1 e0 02             	shl    $0x2,%eax
  802727:	05 40 10 81 00       	add    $0x811040,%eax
  80272c:	8b 00                	mov    (%eax),%eax
  80272e:	39 c1                	cmp    %eax,%ecx
  802730:	75 52                	jne    802784 <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  802732:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802735:	89 d0                	mov    %edx,%eax
  802737:	01 c0                	add    %eax,%eax
  802739:	01 d0                	add    %edx,%eax
  80273b:	c1 e0 02             	shl    $0x2,%eax
  80273e:	05 44 10 81 00       	add    $0x811044,%eax
  802743:	8b 08                	mov    (%eax),%ecx
  802745:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802748:	89 d0                	mov    %edx,%eax
  80274a:	01 c0                	add    %eax,%eax
  80274c:	01 d0                	add    %edx,%eax
  80274e:	c1 e0 02             	shl    $0x2,%eax
  802751:	05 44 10 81 00       	add    $0x811044,%eax
  802756:	8b 00                	mov    (%eax),%eax
  802758:	01 c1                	add    %eax,%ecx
  80275a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80275d:	89 d0                	mov    %edx,%eax
  80275f:	01 c0                	add    %eax,%eax
  802761:	01 d0                	add    %edx,%eax
  802763:	c1 e0 02             	shl    $0x2,%eax
  802766:	05 44 10 81 00       	add    $0x811044,%eax
  80276b:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  80276d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802770:	89 d0                	mov    %edx,%eax
  802772:	01 c0                	add    %eax,%eax
  802774:	01 d0                	add    %edx,%eax
  802776:	c1 e0 02             	shl    $0x2,%eax
  802779:	05 48 10 81 00       	add    $0x811048,%eax
  80277e:	c6 00 00             	movb   $0x0,(%eax)
  802781:	eb 01                	jmp    802784 <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  802783:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802784:	ff 45 e0             	incl   -0x20(%ebp)
  802787:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80278e:	0f 8e 7f fe ff ff    	jle    802613 <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  802794:	a1 30 51 83 00       	mov    0x835130,%eax
  802799:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  80279c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8027a3:	eb 53                	jmp    8027f8 <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  8027a5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8027a8:	89 d0                	mov    %edx,%eax
  8027aa:	01 c0                	add    %eax,%eax
  8027ac:	01 d0                	add    %edx,%eax
  8027ae:	c1 e0 02             	shl    $0x2,%eax
  8027b1:	05 48 50 80 00       	add    $0x805048,%eax
  8027b6:	8a 00                	mov    (%eax),%al
  8027b8:	84 c0                	test   %al,%al
  8027ba:	74 39                	je     8027f5 <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  8027bc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8027bf:	89 d0                	mov    %edx,%eax
  8027c1:	01 c0                	add    %eax,%eax
  8027c3:	01 d0                	add    %edx,%eax
  8027c5:	c1 e0 02             	shl    $0x2,%eax
  8027c8:	05 40 50 80 00       	add    $0x805040,%eax
  8027cd:	8b 08                	mov    (%eax),%ecx
  8027cf:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8027d2:	89 d0                	mov    %edx,%eax
  8027d4:	01 c0                	add    %eax,%eax
  8027d6:	01 d0                	add    %edx,%eax
  8027d8:	c1 e0 02             	shl    $0x2,%eax
  8027db:	05 44 50 80 00       	add    $0x805044,%eax
  8027e0:	8b 00                	mov    (%eax),%eax
  8027e2:	01 c8                	add    %ecx,%eax
  8027e4:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  8027e7:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8027ea:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8027ed:	76 06                	jbe    8027f5 <realloc+0x453>
  8027ef:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8027f2:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  8027f5:	ff 45 d8             	incl   -0x28(%ebp)
  8027f8:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  8027ff:	7e a4                	jle    8027a5 <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  802801:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802804:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  802809:	8b 45 08             	mov    0x8(%ebp),%eax
  80280c:	e9 a9 01 00 00       	jmp    8029ba <realloc+0x618>
	}
	uint32 end = va + oldsz;
  802811:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802814:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802817:	01 d0                	add    %edx,%eax
  802819:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  80281c:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802823:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  80282a:	eb 57                	jmp    802883 <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  80282c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80282f:	89 d0                	mov    %edx,%eax
  802831:	01 c0                	add    %eax,%eax
  802833:	01 d0                	add    %edx,%eax
  802835:	c1 e0 02             	shl    $0x2,%eax
  802838:	05 48 10 81 00       	add    $0x811048,%eax
  80283d:	8a 00                	mov    (%eax),%al
  80283f:	84 c0                	test   %al,%al
  802841:	74 3d                	je     802880 <realloc+0x4de>
  802843:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802846:	89 d0                	mov    %edx,%eax
  802848:	01 c0                	add    %eax,%eax
  80284a:	01 d0                	add    %edx,%eax
  80284c:	c1 e0 02             	shl    $0x2,%eax
  80284f:	05 40 10 81 00       	add    $0x811040,%eax
  802854:	8b 00                	mov    (%eax),%eax
  802856:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802859:	75 25                	jne    802880 <realloc+0x4de>
  80285b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80285e:	89 d0                	mov    %edx,%eax
  802860:	01 c0                	add    %eax,%eax
  802862:	01 d0                	add    %edx,%eax
  802864:	c1 e0 02             	shl    $0x2,%eax
  802867:	05 44 10 81 00       	add    $0x811044,%eax
  80286c:	8b 10                	mov    (%eax),%edx
  80286e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802871:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802874:	39 c2                	cmp    %eax,%edx
  802876:	72 08                	jb     802880 <realloc+0x4de>
		{
			adjIdx = j; break;
  802878:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80287b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80287e:	eb 0c                	jmp    80288c <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802880:	ff 45 d0             	incl   -0x30(%ebp)
  802883:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  80288a:	7e a0                	jle    80282c <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  80288c:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  802890:	0f 84 d6 00 00 00    	je     80296c <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  802896:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802899:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80289c:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  80289f:	83 ec 08             	sub    $0x8,%esp
  8028a2:	ff 75 a0             	pushl  -0x60(%ebp)
  8028a5:	ff 75 a4             	pushl  -0x5c(%ebp)
  8028a8:	e8 cf 09 00 00       	call   80327c <sys_allocate_user_mem>
  8028ad:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  8028b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028b3:	89 d0                	mov    %edx,%eax
  8028b5:	01 c0                	add    %eax,%eax
  8028b7:	01 d0                	add    %edx,%eax
  8028b9:	c1 e0 02             	shl    $0x2,%eax
  8028bc:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8028c2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8028c5:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  8028c7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8028ca:	89 d0                	mov    %edx,%eax
  8028cc:	01 c0                	add    %eax,%eax
  8028ce:	01 d0                	add    %edx,%eax
  8028d0:	c1 e0 02             	shl    $0x2,%eax
  8028d3:	05 40 10 81 00       	add    $0x811040,%eax
  8028d8:	8b 10                	mov    (%eax),%edx
  8028da:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8028dd:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8028e0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8028e3:	89 d0                	mov    %edx,%eax
  8028e5:	01 c0                	add    %eax,%eax
  8028e7:	01 d0                	add    %edx,%eax
  8028e9:	c1 e0 02             	shl    $0x2,%eax
  8028ec:	05 40 10 81 00       	add    $0x811040,%eax
  8028f1:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  8028f3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8028f6:	89 d0                	mov    %edx,%eax
  8028f8:	01 c0                	add    %eax,%eax
  8028fa:	01 d0                	add    %edx,%eax
  8028fc:	c1 e0 02             	shl    $0x2,%eax
  8028ff:	05 44 10 81 00       	add    $0x811044,%eax
  802904:	8b 00                	mov    (%eax),%eax
  802906:	2b 45 a0             	sub    -0x60(%ebp),%eax
  802909:	89 c2                	mov    %eax,%edx
  80290b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80290e:	89 c8                	mov    %ecx,%eax
  802910:	01 c0                	add    %eax,%eax
  802912:	01 c8                	add    %ecx,%eax
  802914:	c1 e0 02             	shl    $0x2,%eax
  802917:	05 44 10 81 00       	add    $0x811044,%eax
  80291c:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  80291e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802921:	89 d0                	mov    %edx,%eax
  802923:	01 c0                	add    %eax,%eax
  802925:	01 d0                	add    %edx,%eax
  802927:	c1 e0 02             	shl    $0x2,%eax
  80292a:	05 44 10 81 00       	add    $0x811044,%eax
  80292f:	8b 00                	mov    (%eax),%eax
  802931:	85 c0                	test   %eax,%eax
  802933:	75 14                	jne    802949 <realloc+0x5a7>
  802935:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802938:	89 d0                	mov    %edx,%eax
  80293a:	01 c0                	add    %eax,%eax
  80293c:	01 d0                	add    %edx,%eax
  80293e:	c1 e0 02             	shl    $0x2,%eax
  802941:	05 48 10 81 00       	add    $0x811048,%eax
  802946:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  802949:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80294c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80294f:	01 c2                	add    %eax,%edx
  802951:	a1 88 50 83 00       	mov    0x835088,%eax
  802956:	39 c2                	cmp    %eax,%edx
  802958:	76 0d                	jbe    802967 <realloc+0x5c5>
  80295a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80295d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802960:	01 d0                	add    %edx,%eax
  802962:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  802967:	8b 45 08             	mov    0x8(%ebp),%eax
  80296a:	eb 4e                	jmp    8029ba <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  80296c:	83 ec 0c             	sub    $0xc,%esp
  80296f:	ff 75 0c             	pushl  0xc(%ebp)
  802972:	e8 0b ec ff ff       	call   801582 <malloc>
  802977:	83 c4 10             	add    $0x10,%esp
  80297a:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  80297d:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  802981:	75 07                	jne    80298a <realloc+0x5e8>
		return NULL;
  802983:	b8 00 00 00 00       	mov    $0x0,%eax
  802988:	eb 30                	jmp    8029ba <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  80298a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80298d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802990:	39 d0                	cmp    %edx,%eax
  802992:	76 02                	jbe    802996 <realloc+0x5f4>
  802994:	89 d0                	mov    %edx,%eax
  802996:	8b 55 9c             	mov    -0x64(%ebp),%edx
  802999:	83 ec 04             	sub    $0x4,%esp
  80299c:	50                   	push   %eax
  80299d:	52                   	push   %edx
  80299e:	ff 75 cc             	pushl  -0x34(%ebp)
  8029a1:	e8 cf 06 00 00       	call   803075 <sys_move_user_mem>
  8029a6:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  8029a9:	83 ec 0c             	sub    $0xc,%esp
  8029ac:	ff 75 08             	pushl  0x8(%ebp)
  8029af:	e8 2e ef ff ff       	call   8018e2 <free>
  8029b4:	83 c4 10             	add    $0x10,%esp
	return newptr;
  8029b7:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  8029ba:	c9                   	leave  
  8029bb:	c3                   	ret    

008029bc <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8029bc:	55                   	push   %ebp
  8029bd:	89 e5                	mov    %esp,%ebp
  8029bf:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  8029c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c5:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  8029c8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8029cc:	0f 84 33 03 00 00    	je     802d05 <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  8029d2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8029d5:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  8029da:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  8029dd:	83 ec 08             	sub    $0x8,%esp
  8029e0:	ff 75 08             	pushl  0x8(%ebp)
  8029e3:	ff 75 d8             	pushl  -0x28(%ebp)
  8029e6:	e8 7d 05 00 00       	call   802f68 <sys_delete_shared_object>
  8029eb:	83 c4 10             	add    $0x10,%esp
  8029ee:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  8029f1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8029f5:	0f 88 0d 03 00 00    	js     802d08 <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8029fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802a02:	e9 ef 02 00 00       	jmp    802cf6 <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802a07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a0a:	89 d0                	mov    %edx,%eax
  802a0c:	01 c0                	add    %eax,%eax
  802a0e:	01 d0                	add    %edx,%eax
  802a10:	c1 e0 02             	shl    $0x2,%eax
  802a13:	05 48 50 80 00       	add    $0x805048,%eax
  802a18:	8a 00                	mov    (%eax),%al
  802a1a:	84 c0                	test   %al,%al
  802a1c:	0f 84 d1 02 00 00    	je     802cf3 <sfree+0x337>
  802a22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a25:	89 d0                	mov    %edx,%eax
  802a27:	01 c0                	add    %eax,%eax
  802a29:	01 d0                	add    %edx,%eax
  802a2b:	c1 e0 02             	shl    $0x2,%eax
  802a2e:	05 40 50 80 00       	add    $0x805040,%eax
  802a33:	8b 00                	mov    (%eax),%eax
  802a35:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802a38:	0f 85 b5 02 00 00    	jne    802cf3 <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  802a3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a41:	89 d0                	mov    %edx,%eax
  802a43:	01 c0                	add    %eax,%eax
  802a45:	01 d0                	add    %edx,%eax
  802a47:	c1 e0 02             	shl    $0x2,%eax
  802a4a:	05 44 50 80 00       	add    $0x805044,%eax
  802a4f:	8b 00                	mov    (%eax),%eax
  802a51:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  802a54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a57:	89 d0                	mov    %edx,%eax
  802a59:	01 c0                	add    %eax,%eax
  802a5b:	01 d0                	add    %edx,%eax
  802a5d:	c1 e0 02             	shl    $0x2,%eax
  802a60:	05 48 50 80 00       	add    $0x805048,%eax
  802a65:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  802a68:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802a6f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802a76:	eb 64                	jmp    802adc <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  802a78:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a7b:	89 d0                	mov    %edx,%eax
  802a7d:	01 c0                	add    %eax,%eax
  802a7f:	01 d0                	add    %edx,%eax
  802a81:	c1 e0 02             	shl    $0x2,%eax
  802a84:	05 48 10 81 00       	add    $0x811048,%eax
  802a89:	8a 00                	mov    (%eax),%al
  802a8b:	84 c0                	test   %al,%al
  802a8d:	75 4a                	jne    802ad9 <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  802a8f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a92:	89 d0                	mov    %edx,%eax
  802a94:	01 c0                	add    %eax,%eax
  802a96:	01 d0                	add    %edx,%eax
  802a98:	c1 e0 02             	shl    $0x2,%eax
  802a9b:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  802aa1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802aa4:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  802aa6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802aa9:	89 d0                	mov    %edx,%eax
  802aab:	01 c0                	add    %eax,%eax
  802aad:	01 d0                	add    %edx,%eax
  802aaf:	c1 e0 02             	shl    $0x2,%eax
  802ab2:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  802ab8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802abb:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  802abd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ac0:	89 d0                	mov    %edx,%eax
  802ac2:	01 c0                	add    %eax,%eax
  802ac4:	01 d0                	add    %edx,%eax
  802ac6:	c1 e0 02             	shl    $0x2,%eax
  802ac9:	05 48 10 81 00       	add    $0x811048,%eax
  802ace:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  802ad1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad4:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  802ad7:	eb 0c                	jmp    802ae5 <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802ad9:	ff 45 ec             	incl   -0x14(%ebp)
  802adc:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802ae3:	7e 93                	jle    802a78 <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  802ae5:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802ae9:	0f 84 8d 01 00 00    	je     802c7c <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802aef:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802af6:	e9 74 01 00 00       	jmp    802c6f <sfree+0x2b3>
				{
					if (k == fidx) continue;
  802afb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802afe:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802b01:	0f 84 64 01 00 00    	je     802c6b <sfree+0x2af>
					if (uhp_frees[k].free)
  802b07:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b0a:	89 d0                	mov    %edx,%eax
  802b0c:	01 c0                	add    %eax,%eax
  802b0e:	01 d0                	add    %edx,%eax
  802b10:	c1 e0 02             	shl    $0x2,%eax
  802b13:	05 48 10 81 00       	add    $0x811048,%eax
  802b18:	8a 00                	mov    (%eax),%al
  802b1a:	84 c0                	test   %al,%al
  802b1c:	0f 84 4a 01 00 00    	je     802c6c <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802b22:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b25:	89 d0                	mov    %edx,%eax
  802b27:	01 c0                	add    %eax,%eax
  802b29:	01 d0                	add    %edx,%eax
  802b2b:	c1 e0 02             	shl    $0x2,%eax
  802b2e:	05 40 10 81 00       	add    $0x811040,%eax
  802b33:	8b 08                	mov    (%eax),%ecx
  802b35:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b38:	89 d0                	mov    %edx,%eax
  802b3a:	01 c0                	add    %eax,%eax
  802b3c:	01 d0                	add    %edx,%eax
  802b3e:	c1 e0 02             	shl    $0x2,%eax
  802b41:	05 44 10 81 00       	add    $0x811044,%eax
  802b46:	8b 00                	mov    (%eax),%eax
  802b48:	01 c1                	add    %eax,%ecx
  802b4a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b4d:	89 d0                	mov    %edx,%eax
  802b4f:	01 c0                	add    %eax,%eax
  802b51:	01 d0                	add    %edx,%eax
  802b53:	c1 e0 02             	shl    $0x2,%eax
  802b56:	05 40 10 81 00       	add    $0x811040,%eax
  802b5b:	8b 00                	mov    (%eax),%eax
  802b5d:	39 c1                	cmp    %eax,%ecx
  802b5f:	75 7a                	jne    802bdb <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  802b61:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b64:	89 d0                	mov    %edx,%eax
  802b66:	01 c0                	add    %eax,%eax
  802b68:	01 d0                	add    %edx,%eax
  802b6a:	c1 e0 02             	shl    $0x2,%eax
  802b6d:	05 40 10 81 00       	add    $0x811040,%eax
  802b72:	8b 10                	mov    (%eax),%edx
  802b74:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802b77:	89 c8                	mov    %ecx,%eax
  802b79:	01 c0                	add    %eax,%eax
  802b7b:	01 c8                	add    %ecx,%eax
  802b7d:	c1 e0 02             	shl    $0x2,%eax
  802b80:	05 40 10 81 00       	add    $0x811040,%eax
  802b85:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  802b87:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b8a:	89 d0                	mov    %edx,%eax
  802b8c:	01 c0                	add    %eax,%eax
  802b8e:	01 d0                	add    %edx,%eax
  802b90:	c1 e0 02             	shl    $0x2,%eax
  802b93:	05 44 10 81 00       	add    $0x811044,%eax
  802b98:	8b 08                	mov    (%eax),%ecx
  802b9a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b9d:	89 d0                	mov    %edx,%eax
  802b9f:	01 c0                	add    %eax,%eax
  802ba1:	01 d0                	add    %edx,%eax
  802ba3:	c1 e0 02             	shl    $0x2,%eax
  802ba6:	05 44 10 81 00       	add    $0x811044,%eax
  802bab:	8b 00                	mov    (%eax),%eax
  802bad:	01 c1                	add    %eax,%ecx
  802baf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bb2:	89 d0                	mov    %edx,%eax
  802bb4:	01 c0                	add    %eax,%eax
  802bb6:	01 d0                	add    %edx,%eax
  802bb8:	c1 e0 02             	shl    $0x2,%eax
  802bbb:	05 44 10 81 00       	add    $0x811044,%eax
  802bc0:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802bc2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bc5:	89 d0                	mov    %edx,%eax
  802bc7:	01 c0                	add    %eax,%eax
  802bc9:	01 d0                	add    %edx,%eax
  802bcb:	c1 e0 02             	shl    $0x2,%eax
  802bce:	05 48 10 81 00       	add    $0x811048,%eax
  802bd3:	c6 00 00             	movb   $0x0,(%eax)
  802bd6:	e9 91 00 00 00       	jmp    802c6c <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802bdb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bde:	89 d0                	mov    %edx,%eax
  802be0:	01 c0                	add    %eax,%eax
  802be2:	01 d0                	add    %edx,%eax
  802be4:	c1 e0 02             	shl    $0x2,%eax
  802be7:	05 40 10 81 00       	add    $0x811040,%eax
  802bec:	8b 08                	mov    (%eax),%ecx
  802bee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bf1:	89 d0                	mov    %edx,%eax
  802bf3:	01 c0                	add    %eax,%eax
  802bf5:	01 d0                	add    %edx,%eax
  802bf7:	c1 e0 02             	shl    $0x2,%eax
  802bfa:	05 44 10 81 00       	add    $0x811044,%eax
  802bff:	8b 00                	mov    (%eax),%eax
  802c01:	01 c1                	add    %eax,%ecx
  802c03:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c06:	89 d0                	mov    %edx,%eax
  802c08:	01 c0                	add    %eax,%eax
  802c0a:	01 d0                	add    %edx,%eax
  802c0c:	c1 e0 02             	shl    $0x2,%eax
  802c0f:	05 40 10 81 00       	add    $0x811040,%eax
  802c14:	8b 00                	mov    (%eax),%eax
  802c16:	39 c1                	cmp    %eax,%ecx
  802c18:	75 52                	jne    802c6c <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  802c1a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c1d:	89 d0                	mov    %edx,%eax
  802c1f:	01 c0                	add    %eax,%eax
  802c21:	01 d0                	add    %edx,%eax
  802c23:	c1 e0 02             	shl    $0x2,%eax
  802c26:	05 44 10 81 00       	add    $0x811044,%eax
  802c2b:	8b 08                	mov    (%eax),%ecx
  802c2d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c30:	89 d0                	mov    %edx,%eax
  802c32:	01 c0                	add    %eax,%eax
  802c34:	01 d0                	add    %edx,%eax
  802c36:	c1 e0 02             	shl    $0x2,%eax
  802c39:	05 44 10 81 00       	add    $0x811044,%eax
  802c3e:	8b 00                	mov    (%eax),%eax
  802c40:	01 c1                	add    %eax,%ecx
  802c42:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c45:	89 d0                	mov    %edx,%eax
  802c47:	01 c0                	add    %eax,%eax
  802c49:	01 d0                	add    %edx,%eax
  802c4b:	c1 e0 02             	shl    $0x2,%eax
  802c4e:	05 44 10 81 00       	add    $0x811044,%eax
  802c53:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802c55:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c58:	89 d0                	mov    %edx,%eax
  802c5a:	01 c0                	add    %eax,%eax
  802c5c:	01 d0                	add    %edx,%eax
  802c5e:	c1 e0 02             	shl    $0x2,%eax
  802c61:	05 48 10 81 00       	add    $0x811048,%eax
  802c66:	c6 00 00             	movb   $0x0,(%eax)
  802c69:	eb 01                	jmp    802c6c <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  802c6b:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802c6c:	ff 45 e8             	incl   -0x18(%ebp)
  802c6f:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802c76:	0f 8e 7f fe ff ff    	jle    802afb <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  802c7c:	a1 30 51 83 00       	mov    0x835130,%eax
  802c81:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802c84:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802c8b:	eb 53                	jmp    802ce0 <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  802c8d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c90:	89 d0                	mov    %edx,%eax
  802c92:	01 c0                	add    %eax,%eax
  802c94:	01 d0                	add    %edx,%eax
  802c96:	c1 e0 02             	shl    $0x2,%eax
  802c99:	05 48 50 80 00       	add    $0x805048,%eax
  802c9e:	8a 00                	mov    (%eax),%al
  802ca0:	84 c0                	test   %al,%al
  802ca2:	74 39                	je     802cdd <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802ca4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ca7:	89 d0                	mov    %edx,%eax
  802ca9:	01 c0                	add    %eax,%eax
  802cab:	01 d0                	add    %edx,%eax
  802cad:	c1 e0 02             	shl    $0x2,%eax
  802cb0:	05 40 50 80 00       	add    $0x805040,%eax
  802cb5:	8b 08                	mov    (%eax),%ecx
  802cb7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cba:	89 d0                	mov    %edx,%eax
  802cbc:	01 c0                	add    %eax,%eax
  802cbe:	01 d0                	add    %edx,%eax
  802cc0:	c1 e0 02             	shl    $0x2,%eax
  802cc3:	05 44 50 80 00       	add    $0x805044,%eax
  802cc8:	8b 00                	mov    (%eax),%eax
  802cca:	01 c8                	add    %ecx,%eax
  802ccc:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  802ccf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cd2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802cd5:	76 06                	jbe    802cdd <sfree+0x321>
  802cd7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cda:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802cdd:	ff 45 e0             	incl   -0x20(%ebp)
  802ce0:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802ce7:	7e a4                	jle    802c8d <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  802ce9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cec:	a3 88 50 83 00       	mov    %eax,0x835088
			break;
  802cf1:	eb 16                	jmp    802d09 <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802cf3:	ff 45 f4             	incl   -0xc(%ebp)
  802cf6:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  802cfd:	0f 8e 04 fd ff ff    	jle    802a07 <sfree+0x4b>
  802d03:	eb 04                	jmp    802d09 <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  802d05:	90                   	nop
  802d06:	eb 01                	jmp    802d09 <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  802d08:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  802d09:	c9                   	leave  
  802d0a:	c3                   	ret    

00802d0b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802d0b:	55                   	push   %ebp
  802d0c:	89 e5                	mov    %esp,%ebp
  802d0e:	57                   	push   %edi
  802d0f:	56                   	push   %esi
  802d10:	53                   	push   %ebx
  802d11:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802d14:	8b 45 08             	mov    0x8(%ebp),%eax
  802d17:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d1a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802d1d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802d20:	8b 7d 18             	mov    0x18(%ebp),%edi
  802d23:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802d26:	cd 30                	int    $0x30
  802d28:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802d2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802d2e:	83 c4 10             	add    $0x10,%esp
  802d31:	5b                   	pop    %ebx
  802d32:	5e                   	pop    %esi
  802d33:	5f                   	pop    %edi
  802d34:	5d                   	pop    %ebp
  802d35:	c3                   	ret    

00802d36 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802d36:	55                   	push   %ebp
  802d37:	89 e5                	mov    %esp,%ebp
  802d39:	83 ec 04             	sub    $0x4,%esp
  802d3c:	8b 45 10             	mov    0x10(%ebp),%eax
  802d3f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802d42:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802d45:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802d49:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4c:	6a 00                	push   $0x0
  802d4e:	51                   	push   %ecx
  802d4f:	52                   	push   %edx
  802d50:	ff 75 0c             	pushl  0xc(%ebp)
  802d53:	50                   	push   %eax
  802d54:	6a 00                	push   $0x0
  802d56:	e8 b0 ff ff ff       	call   802d0b <syscall>
  802d5b:	83 c4 18             	add    $0x18,%esp
}
  802d5e:	90                   	nop
  802d5f:	c9                   	leave  
  802d60:	c3                   	ret    

00802d61 <sys_cgetc>:

int
sys_cgetc(void)
{
  802d61:	55                   	push   %ebp
  802d62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802d64:	6a 00                	push   $0x0
  802d66:	6a 00                	push   $0x0
  802d68:	6a 00                	push   $0x0
  802d6a:	6a 00                	push   $0x0
  802d6c:	6a 00                	push   $0x0
  802d6e:	6a 02                	push   $0x2
  802d70:	e8 96 ff ff ff       	call   802d0b <syscall>
  802d75:	83 c4 18             	add    $0x18,%esp
}
  802d78:	c9                   	leave  
  802d79:	c3                   	ret    

00802d7a <sys_lock_cons>:

void sys_lock_cons(void)
{
  802d7a:	55                   	push   %ebp
  802d7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802d7d:	6a 00                	push   $0x0
  802d7f:	6a 00                	push   $0x0
  802d81:	6a 00                	push   $0x0
  802d83:	6a 00                	push   $0x0
  802d85:	6a 00                	push   $0x0
  802d87:	6a 03                	push   $0x3
  802d89:	e8 7d ff ff ff       	call   802d0b <syscall>
  802d8e:	83 c4 18             	add    $0x18,%esp
}
  802d91:	90                   	nop
  802d92:	c9                   	leave  
  802d93:	c3                   	ret    

00802d94 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802d94:	55                   	push   %ebp
  802d95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802d97:	6a 00                	push   $0x0
  802d99:	6a 00                	push   $0x0
  802d9b:	6a 00                	push   $0x0
  802d9d:	6a 00                	push   $0x0
  802d9f:	6a 00                	push   $0x0
  802da1:	6a 04                	push   $0x4
  802da3:	e8 63 ff ff ff       	call   802d0b <syscall>
  802da8:	83 c4 18             	add    $0x18,%esp
}
  802dab:	90                   	nop
  802dac:	c9                   	leave  
  802dad:	c3                   	ret    

00802dae <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802dae:	55                   	push   %ebp
  802daf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802db1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802db4:	8b 45 08             	mov    0x8(%ebp),%eax
  802db7:	6a 00                	push   $0x0
  802db9:	6a 00                	push   $0x0
  802dbb:	6a 00                	push   $0x0
  802dbd:	52                   	push   %edx
  802dbe:	50                   	push   %eax
  802dbf:	6a 08                	push   $0x8
  802dc1:	e8 45 ff ff ff       	call   802d0b <syscall>
  802dc6:	83 c4 18             	add    $0x18,%esp
}
  802dc9:	c9                   	leave  
  802dca:	c3                   	ret    

00802dcb <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802dcb:	55                   	push   %ebp
  802dcc:	89 e5                	mov    %esp,%ebp
  802dce:	56                   	push   %esi
  802dcf:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802dd0:	8b 75 18             	mov    0x18(%ebp),%esi
  802dd3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802dd6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802dd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddf:	56                   	push   %esi
  802de0:	53                   	push   %ebx
  802de1:	51                   	push   %ecx
  802de2:	52                   	push   %edx
  802de3:	50                   	push   %eax
  802de4:	6a 09                	push   $0x9
  802de6:	e8 20 ff ff ff       	call   802d0b <syscall>
  802deb:	83 c4 18             	add    $0x18,%esp
}
  802dee:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802df1:	5b                   	pop    %ebx
  802df2:	5e                   	pop    %esi
  802df3:	5d                   	pop    %ebp
  802df4:	c3                   	ret    

00802df5 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802df5:	55                   	push   %ebp
  802df6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802df8:	6a 00                	push   $0x0
  802dfa:	6a 00                	push   $0x0
  802dfc:	6a 00                	push   $0x0
  802dfe:	6a 00                	push   $0x0
  802e00:	ff 75 08             	pushl  0x8(%ebp)
  802e03:	6a 0a                	push   $0xa
  802e05:	e8 01 ff ff ff       	call   802d0b <syscall>
  802e0a:	83 c4 18             	add    $0x18,%esp
}
  802e0d:	c9                   	leave  
  802e0e:	c3                   	ret    

00802e0f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802e0f:	55                   	push   %ebp
  802e10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802e12:	6a 00                	push   $0x0
  802e14:	6a 00                	push   $0x0
  802e16:	6a 00                	push   $0x0
  802e18:	ff 75 0c             	pushl  0xc(%ebp)
  802e1b:	ff 75 08             	pushl  0x8(%ebp)
  802e1e:	6a 0b                	push   $0xb
  802e20:	e8 e6 fe ff ff       	call   802d0b <syscall>
  802e25:	83 c4 18             	add    $0x18,%esp
}
  802e28:	c9                   	leave  
  802e29:	c3                   	ret    

00802e2a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802e2a:	55                   	push   %ebp
  802e2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802e2d:	6a 00                	push   $0x0
  802e2f:	6a 00                	push   $0x0
  802e31:	6a 00                	push   $0x0
  802e33:	6a 00                	push   $0x0
  802e35:	6a 00                	push   $0x0
  802e37:	6a 0c                	push   $0xc
  802e39:	e8 cd fe ff ff       	call   802d0b <syscall>
  802e3e:	83 c4 18             	add    $0x18,%esp
}
  802e41:	c9                   	leave  
  802e42:	c3                   	ret    

00802e43 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802e43:	55                   	push   %ebp
  802e44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802e46:	6a 00                	push   $0x0
  802e48:	6a 00                	push   $0x0
  802e4a:	6a 00                	push   $0x0
  802e4c:	6a 00                	push   $0x0
  802e4e:	6a 00                	push   $0x0
  802e50:	6a 0d                	push   $0xd
  802e52:	e8 b4 fe ff ff       	call   802d0b <syscall>
  802e57:	83 c4 18             	add    $0x18,%esp
}
  802e5a:	c9                   	leave  
  802e5b:	c3                   	ret    

00802e5c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802e5c:	55                   	push   %ebp
  802e5d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802e5f:	6a 00                	push   $0x0
  802e61:	6a 00                	push   $0x0
  802e63:	6a 00                	push   $0x0
  802e65:	6a 00                	push   $0x0
  802e67:	6a 00                	push   $0x0
  802e69:	6a 0e                	push   $0xe
  802e6b:	e8 9b fe ff ff       	call   802d0b <syscall>
  802e70:	83 c4 18             	add    $0x18,%esp
}
  802e73:	c9                   	leave  
  802e74:	c3                   	ret    

00802e75 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802e75:	55                   	push   %ebp
  802e76:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802e78:	6a 00                	push   $0x0
  802e7a:	6a 00                	push   $0x0
  802e7c:	6a 00                	push   $0x0
  802e7e:	6a 00                	push   $0x0
  802e80:	6a 00                	push   $0x0
  802e82:	6a 0f                	push   $0xf
  802e84:	e8 82 fe ff ff       	call   802d0b <syscall>
  802e89:	83 c4 18             	add    $0x18,%esp
}
  802e8c:	c9                   	leave  
  802e8d:	c3                   	ret    

00802e8e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802e8e:	55                   	push   %ebp
  802e8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802e91:	6a 00                	push   $0x0
  802e93:	6a 00                	push   $0x0
  802e95:	6a 00                	push   $0x0
  802e97:	6a 00                	push   $0x0
  802e99:	ff 75 08             	pushl  0x8(%ebp)
  802e9c:	6a 10                	push   $0x10
  802e9e:	e8 68 fe ff ff       	call   802d0b <syscall>
  802ea3:	83 c4 18             	add    $0x18,%esp
}
  802ea6:	c9                   	leave  
  802ea7:	c3                   	ret    

00802ea8 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802ea8:	55                   	push   %ebp
  802ea9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802eab:	6a 00                	push   $0x0
  802ead:	6a 00                	push   $0x0
  802eaf:	6a 00                	push   $0x0
  802eb1:	6a 00                	push   $0x0
  802eb3:	6a 00                	push   $0x0
  802eb5:	6a 11                	push   $0x11
  802eb7:	e8 4f fe ff ff       	call   802d0b <syscall>
  802ebc:	83 c4 18             	add    $0x18,%esp
}
  802ebf:	90                   	nop
  802ec0:	c9                   	leave  
  802ec1:	c3                   	ret    

00802ec2 <sys_cputc>:

void
sys_cputc(const char c)
{
  802ec2:	55                   	push   %ebp
  802ec3:	89 e5                	mov    %esp,%ebp
  802ec5:	83 ec 04             	sub    $0x4,%esp
  802ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802ece:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802ed2:	6a 00                	push   $0x0
  802ed4:	6a 00                	push   $0x0
  802ed6:	6a 00                	push   $0x0
  802ed8:	6a 00                	push   $0x0
  802eda:	50                   	push   %eax
  802edb:	6a 01                	push   $0x1
  802edd:	e8 29 fe ff ff       	call   802d0b <syscall>
  802ee2:	83 c4 18             	add    $0x18,%esp
}
  802ee5:	90                   	nop
  802ee6:	c9                   	leave  
  802ee7:	c3                   	ret    

00802ee8 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802ee8:	55                   	push   %ebp
  802ee9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802eeb:	6a 00                	push   $0x0
  802eed:	6a 00                	push   $0x0
  802eef:	6a 00                	push   $0x0
  802ef1:	6a 00                	push   $0x0
  802ef3:	6a 00                	push   $0x0
  802ef5:	6a 14                	push   $0x14
  802ef7:	e8 0f fe ff ff       	call   802d0b <syscall>
  802efc:	83 c4 18             	add    $0x18,%esp
}
  802eff:	90                   	nop
  802f00:	c9                   	leave  
  802f01:	c3                   	ret    

00802f02 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802f02:	55                   	push   %ebp
  802f03:	89 e5                	mov    %esp,%ebp
  802f05:	83 ec 04             	sub    $0x4,%esp
  802f08:	8b 45 10             	mov    0x10(%ebp),%eax
  802f0b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802f0e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802f11:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802f15:	8b 45 08             	mov    0x8(%ebp),%eax
  802f18:	6a 00                	push   $0x0
  802f1a:	51                   	push   %ecx
  802f1b:	52                   	push   %edx
  802f1c:	ff 75 0c             	pushl  0xc(%ebp)
  802f1f:	50                   	push   %eax
  802f20:	6a 15                	push   $0x15
  802f22:	e8 e4 fd ff ff       	call   802d0b <syscall>
  802f27:	83 c4 18             	add    $0x18,%esp
}
  802f2a:	c9                   	leave  
  802f2b:	c3                   	ret    

00802f2c <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802f2c:	55                   	push   %ebp
  802f2d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802f2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f32:	8b 45 08             	mov    0x8(%ebp),%eax
  802f35:	6a 00                	push   $0x0
  802f37:	6a 00                	push   $0x0
  802f39:	6a 00                	push   $0x0
  802f3b:	52                   	push   %edx
  802f3c:	50                   	push   %eax
  802f3d:	6a 16                	push   $0x16
  802f3f:	e8 c7 fd ff ff       	call   802d0b <syscall>
  802f44:	83 c4 18             	add    $0x18,%esp
}
  802f47:	c9                   	leave  
  802f48:	c3                   	ret    

00802f49 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802f49:	55                   	push   %ebp
  802f4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802f4c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802f4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f52:	8b 45 08             	mov    0x8(%ebp),%eax
  802f55:	6a 00                	push   $0x0
  802f57:	6a 00                	push   $0x0
  802f59:	51                   	push   %ecx
  802f5a:	52                   	push   %edx
  802f5b:	50                   	push   %eax
  802f5c:	6a 17                	push   $0x17
  802f5e:	e8 a8 fd ff ff       	call   802d0b <syscall>
  802f63:	83 c4 18             	add    $0x18,%esp
}
  802f66:	c9                   	leave  
  802f67:	c3                   	ret    

00802f68 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802f68:	55                   	push   %ebp
  802f69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802f6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f71:	6a 00                	push   $0x0
  802f73:	6a 00                	push   $0x0
  802f75:	6a 00                	push   $0x0
  802f77:	52                   	push   %edx
  802f78:	50                   	push   %eax
  802f79:	6a 18                	push   $0x18
  802f7b:	e8 8b fd ff ff       	call   802d0b <syscall>
  802f80:	83 c4 18             	add    $0x18,%esp
}
  802f83:	c9                   	leave  
  802f84:	c3                   	ret    

00802f85 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802f85:	55                   	push   %ebp
  802f86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802f88:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8b:	6a 00                	push   $0x0
  802f8d:	ff 75 14             	pushl  0x14(%ebp)
  802f90:	ff 75 10             	pushl  0x10(%ebp)
  802f93:	ff 75 0c             	pushl  0xc(%ebp)
  802f96:	50                   	push   %eax
  802f97:	6a 19                	push   $0x19
  802f99:	e8 6d fd ff ff       	call   802d0b <syscall>
  802f9e:	83 c4 18             	add    $0x18,%esp
}
  802fa1:	c9                   	leave  
  802fa2:	c3                   	ret    

00802fa3 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802fa3:	55                   	push   %ebp
  802fa4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa9:	6a 00                	push   $0x0
  802fab:	6a 00                	push   $0x0
  802fad:	6a 00                	push   $0x0
  802faf:	6a 00                	push   $0x0
  802fb1:	50                   	push   %eax
  802fb2:	6a 1a                	push   $0x1a
  802fb4:	e8 52 fd ff ff       	call   802d0b <syscall>
  802fb9:	83 c4 18             	add    $0x18,%esp
}
  802fbc:	90                   	nop
  802fbd:	c9                   	leave  
  802fbe:	c3                   	ret    

00802fbf <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802fbf:	55                   	push   %ebp
  802fc0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc5:	6a 00                	push   $0x0
  802fc7:	6a 00                	push   $0x0
  802fc9:	6a 00                	push   $0x0
  802fcb:	6a 00                	push   $0x0
  802fcd:	50                   	push   %eax
  802fce:	6a 1b                	push   $0x1b
  802fd0:	e8 36 fd ff ff       	call   802d0b <syscall>
  802fd5:	83 c4 18             	add    $0x18,%esp
}
  802fd8:	c9                   	leave  
  802fd9:	c3                   	ret    

00802fda <sys_getenvid>:

int32 sys_getenvid(void)
{
  802fda:	55                   	push   %ebp
  802fdb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802fdd:	6a 00                	push   $0x0
  802fdf:	6a 00                	push   $0x0
  802fe1:	6a 00                	push   $0x0
  802fe3:	6a 00                	push   $0x0
  802fe5:	6a 00                	push   $0x0
  802fe7:	6a 05                	push   $0x5
  802fe9:	e8 1d fd ff ff       	call   802d0b <syscall>
  802fee:	83 c4 18             	add    $0x18,%esp
}
  802ff1:	c9                   	leave  
  802ff2:	c3                   	ret    

00802ff3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802ff3:	55                   	push   %ebp
  802ff4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802ff6:	6a 00                	push   $0x0
  802ff8:	6a 00                	push   $0x0
  802ffa:	6a 00                	push   $0x0
  802ffc:	6a 00                	push   $0x0
  802ffe:	6a 00                	push   $0x0
  803000:	6a 06                	push   $0x6
  803002:	e8 04 fd ff ff       	call   802d0b <syscall>
  803007:	83 c4 18             	add    $0x18,%esp
}
  80300a:	c9                   	leave  
  80300b:	c3                   	ret    

0080300c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80300c:	55                   	push   %ebp
  80300d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80300f:	6a 00                	push   $0x0
  803011:	6a 00                	push   $0x0
  803013:	6a 00                	push   $0x0
  803015:	6a 00                	push   $0x0
  803017:	6a 00                	push   $0x0
  803019:	6a 07                	push   $0x7
  80301b:	e8 eb fc ff ff       	call   802d0b <syscall>
  803020:	83 c4 18             	add    $0x18,%esp
}
  803023:	c9                   	leave  
  803024:	c3                   	ret    

00803025 <sys_exit_env>:


void sys_exit_env(void)
{
  803025:	55                   	push   %ebp
  803026:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  803028:	6a 00                	push   $0x0
  80302a:	6a 00                	push   $0x0
  80302c:	6a 00                	push   $0x0
  80302e:	6a 00                	push   $0x0
  803030:	6a 00                	push   $0x0
  803032:	6a 1c                	push   $0x1c
  803034:	e8 d2 fc ff ff       	call   802d0b <syscall>
  803039:	83 c4 18             	add    $0x18,%esp
}
  80303c:	90                   	nop
  80303d:	c9                   	leave  
  80303e:	c3                   	ret    

0080303f <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80303f:	55                   	push   %ebp
  803040:	89 e5                	mov    %esp,%ebp
  803042:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  803045:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803048:	8d 50 04             	lea    0x4(%eax),%edx
  80304b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80304e:	6a 00                	push   $0x0
  803050:	6a 00                	push   $0x0
  803052:	6a 00                	push   $0x0
  803054:	52                   	push   %edx
  803055:	50                   	push   %eax
  803056:	6a 1d                	push   $0x1d
  803058:	e8 ae fc ff ff       	call   802d0b <syscall>
  80305d:	83 c4 18             	add    $0x18,%esp
	return result;
  803060:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803063:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803066:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803069:	89 01                	mov    %eax,(%ecx)
  80306b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80306e:	8b 45 08             	mov    0x8(%ebp),%eax
  803071:	c9                   	leave  
  803072:	c2 04 00             	ret    $0x4

00803075 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  803075:	55                   	push   %ebp
  803076:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  803078:	6a 00                	push   $0x0
  80307a:	6a 00                	push   $0x0
  80307c:	ff 75 10             	pushl  0x10(%ebp)
  80307f:	ff 75 0c             	pushl  0xc(%ebp)
  803082:	ff 75 08             	pushl  0x8(%ebp)
  803085:	6a 13                	push   $0x13
  803087:	e8 7f fc ff ff       	call   802d0b <syscall>
  80308c:	83 c4 18             	add    $0x18,%esp
	return ;
  80308f:	90                   	nop
}
  803090:	c9                   	leave  
  803091:	c3                   	ret    

00803092 <sys_rcr2>:
uint32 sys_rcr2()
{
  803092:	55                   	push   %ebp
  803093:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  803095:	6a 00                	push   $0x0
  803097:	6a 00                	push   $0x0
  803099:	6a 00                	push   $0x0
  80309b:	6a 00                	push   $0x0
  80309d:	6a 00                	push   $0x0
  80309f:	6a 1e                	push   $0x1e
  8030a1:	e8 65 fc ff ff       	call   802d0b <syscall>
  8030a6:	83 c4 18             	add    $0x18,%esp
}
  8030a9:	c9                   	leave  
  8030aa:	c3                   	ret    

008030ab <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8030ab:	55                   	push   %ebp
  8030ac:	89 e5                	mov    %esp,%ebp
  8030ae:	83 ec 04             	sub    $0x4,%esp
  8030b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8030b7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8030bb:	6a 00                	push   $0x0
  8030bd:	6a 00                	push   $0x0
  8030bf:	6a 00                	push   $0x0
  8030c1:	6a 00                	push   $0x0
  8030c3:	50                   	push   %eax
  8030c4:	6a 1f                	push   $0x1f
  8030c6:	e8 40 fc ff ff       	call   802d0b <syscall>
  8030cb:	83 c4 18             	add    $0x18,%esp
	return ;
  8030ce:	90                   	nop
}
  8030cf:	c9                   	leave  
  8030d0:	c3                   	ret    

008030d1 <rsttst>:
void rsttst()
{
  8030d1:	55                   	push   %ebp
  8030d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8030d4:	6a 00                	push   $0x0
  8030d6:	6a 00                	push   $0x0
  8030d8:	6a 00                	push   $0x0
  8030da:	6a 00                	push   $0x0
  8030dc:	6a 00                	push   $0x0
  8030de:	6a 21                	push   $0x21
  8030e0:	e8 26 fc ff ff       	call   802d0b <syscall>
  8030e5:	83 c4 18             	add    $0x18,%esp
	return ;
  8030e8:	90                   	nop
}
  8030e9:	c9                   	leave  
  8030ea:	c3                   	ret    

008030eb <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8030eb:	55                   	push   %ebp
  8030ec:	89 e5                	mov    %esp,%ebp
  8030ee:	83 ec 04             	sub    $0x4,%esp
  8030f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8030f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8030f7:	8b 55 18             	mov    0x18(%ebp),%edx
  8030fa:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8030fe:	52                   	push   %edx
  8030ff:	50                   	push   %eax
  803100:	ff 75 10             	pushl  0x10(%ebp)
  803103:	ff 75 0c             	pushl  0xc(%ebp)
  803106:	ff 75 08             	pushl  0x8(%ebp)
  803109:	6a 20                	push   $0x20
  80310b:	e8 fb fb ff ff       	call   802d0b <syscall>
  803110:	83 c4 18             	add    $0x18,%esp
	return ;
  803113:	90                   	nop
}
  803114:	c9                   	leave  
  803115:	c3                   	ret    

00803116 <chktst>:
void chktst(uint32 n)
{
  803116:	55                   	push   %ebp
  803117:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803119:	6a 00                	push   $0x0
  80311b:	6a 00                	push   $0x0
  80311d:	6a 00                	push   $0x0
  80311f:	6a 00                	push   $0x0
  803121:	ff 75 08             	pushl  0x8(%ebp)
  803124:	6a 22                	push   $0x22
  803126:	e8 e0 fb ff ff       	call   802d0b <syscall>
  80312b:	83 c4 18             	add    $0x18,%esp
	return ;
  80312e:	90                   	nop
}
  80312f:	c9                   	leave  
  803130:	c3                   	ret    

00803131 <inctst>:

void inctst()
{
  803131:	55                   	push   %ebp
  803132:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803134:	6a 00                	push   $0x0
  803136:	6a 00                	push   $0x0
  803138:	6a 00                	push   $0x0
  80313a:	6a 00                	push   $0x0
  80313c:	6a 00                	push   $0x0
  80313e:	6a 23                	push   $0x23
  803140:	e8 c6 fb ff ff       	call   802d0b <syscall>
  803145:	83 c4 18             	add    $0x18,%esp
	return ;
  803148:	90                   	nop
}
  803149:	c9                   	leave  
  80314a:	c3                   	ret    

0080314b <gettst>:
uint32 gettst()
{
  80314b:	55                   	push   %ebp
  80314c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80314e:	6a 00                	push   $0x0
  803150:	6a 00                	push   $0x0
  803152:	6a 00                	push   $0x0
  803154:	6a 00                	push   $0x0
  803156:	6a 00                	push   $0x0
  803158:	6a 24                	push   $0x24
  80315a:	e8 ac fb ff ff       	call   802d0b <syscall>
  80315f:	83 c4 18             	add    $0x18,%esp
}
  803162:	c9                   	leave  
  803163:	c3                   	ret    

00803164 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  803164:	55                   	push   %ebp
  803165:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803167:	6a 00                	push   $0x0
  803169:	6a 00                	push   $0x0
  80316b:	6a 00                	push   $0x0
  80316d:	6a 00                	push   $0x0
  80316f:	6a 00                	push   $0x0
  803171:	6a 25                	push   $0x25
  803173:	e8 93 fb ff ff       	call   802d0b <syscall>
  803178:	83 c4 18             	add    $0x18,%esp
  80317b:	a3 80 50 83 00       	mov    %eax,0x835080
	return uheapPlaceStrategy ;
  803180:	a1 80 50 83 00       	mov    0x835080,%eax
}
  803185:	c9                   	leave  
  803186:	c3                   	ret    

00803187 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803187:	55                   	push   %ebp
  803188:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80318a:	8b 45 08             	mov    0x8(%ebp),%eax
  80318d:	a3 80 50 83 00       	mov    %eax,0x835080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803192:	6a 00                	push   $0x0
  803194:	6a 00                	push   $0x0
  803196:	6a 00                	push   $0x0
  803198:	6a 00                	push   $0x0
  80319a:	ff 75 08             	pushl  0x8(%ebp)
  80319d:	6a 26                	push   $0x26
  80319f:	e8 67 fb ff ff       	call   802d0b <syscall>
  8031a4:	83 c4 18             	add    $0x18,%esp
	return ;
  8031a7:	90                   	nop
}
  8031a8:	c9                   	leave  
  8031a9:	c3                   	ret    

008031aa <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8031aa:	55                   	push   %ebp
  8031ab:	89 e5                	mov    %esp,%ebp
  8031ad:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8031ae:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8031b1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8031b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ba:	6a 00                	push   $0x0
  8031bc:	53                   	push   %ebx
  8031bd:	51                   	push   %ecx
  8031be:	52                   	push   %edx
  8031bf:	50                   	push   %eax
  8031c0:	6a 27                	push   $0x27
  8031c2:	e8 44 fb ff ff       	call   802d0b <syscall>
  8031c7:	83 c4 18             	add    $0x18,%esp
}
  8031ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8031cd:	c9                   	leave  
  8031ce:	c3                   	ret    

008031cf <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8031cf:	55                   	push   %ebp
  8031d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8031d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d8:	6a 00                	push   $0x0
  8031da:	6a 00                	push   $0x0
  8031dc:	6a 00                	push   $0x0
  8031de:	52                   	push   %edx
  8031df:	50                   	push   %eax
  8031e0:	6a 28                	push   $0x28
  8031e2:	e8 24 fb ff ff       	call   802d0b <syscall>
  8031e7:	83 c4 18             	add    $0x18,%esp
}
  8031ea:	c9                   	leave  
  8031eb:	c3                   	ret    

008031ec <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8031ec:	55                   	push   %ebp
  8031ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8031ef:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8031f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f8:	6a 00                	push   $0x0
  8031fa:	51                   	push   %ecx
  8031fb:	ff 75 10             	pushl  0x10(%ebp)
  8031fe:	52                   	push   %edx
  8031ff:	50                   	push   %eax
  803200:	6a 29                	push   $0x29
  803202:	e8 04 fb ff ff       	call   802d0b <syscall>
  803207:	83 c4 18             	add    $0x18,%esp
}
  80320a:	c9                   	leave  
  80320b:	c3                   	ret    

0080320c <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80320c:	55                   	push   %ebp
  80320d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80320f:	6a 00                	push   $0x0
  803211:	6a 00                	push   $0x0
  803213:	ff 75 10             	pushl  0x10(%ebp)
  803216:	ff 75 0c             	pushl  0xc(%ebp)
  803219:	ff 75 08             	pushl  0x8(%ebp)
  80321c:	6a 12                	push   $0x12
  80321e:	e8 e8 fa ff ff       	call   802d0b <syscall>
  803223:	83 c4 18             	add    $0x18,%esp
	return ;
  803226:	90                   	nop
}
  803227:	c9                   	leave  
  803228:	c3                   	ret    

00803229 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  803229:	55                   	push   %ebp
  80322a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80322c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80322f:	8b 45 08             	mov    0x8(%ebp),%eax
  803232:	6a 00                	push   $0x0
  803234:	6a 00                	push   $0x0
  803236:	6a 00                	push   $0x0
  803238:	52                   	push   %edx
  803239:	50                   	push   %eax
  80323a:	6a 2a                	push   $0x2a
  80323c:	e8 ca fa ff ff       	call   802d0b <syscall>
  803241:	83 c4 18             	add    $0x18,%esp
	return;
  803244:	90                   	nop
}
  803245:	c9                   	leave  
  803246:	c3                   	ret    

00803247 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  803247:	55                   	push   %ebp
  803248:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80324a:	6a 00                	push   $0x0
  80324c:	6a 00                	push   $0x0
  80324e:	6a 00                	push   $0x0
  803250:	6a 00                	push   $0x0
  803252:	6a 00                	push   $0x0
  803254:	6a 2b                	push   $0x2b
  803256:	e8 b0 fa ff ff       	call   802d0b <syscall>
  80325b:	83 c4 18             	add    $0x18,%esp
}
  80325e:	c9                   	leave  
  80325f:	c3                   	ret    

00803260 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803260:	55                   	push   %ebp
  803261:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  803263:	6a 00                	push   $0x0
  803265:	6a 00                	push   $0x0
  803267:	6a 00                	push   $0x0
  803269:	ff 75 0c             	pushl  0xc(%ebp)
  80326c:	ff 75 08             	pushl  0x8(%ebp)
  80326f:	6a 2d                	push   $0x2d
  803271:	e8 95 fa ff ff       	call   802d0b <syscall>
  803276:	83 c4 18             	add    $0x18,%esp
	return;
  803279:	90                   	nop
}
  80327a:	c9                   	leave  
  80327b:	c3                   	ret    

0080327c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80327c:	55                   	push   %ebp
  80327d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80327f:	6a 00                	push   $0x0
  803281:	6a 00                	push   $0x0
  803283:	6a 00                	push   $0x0
  803285:	ff 75 0c             	pushl  0xc(%ebp)
  803288:	ff 75 08             	pushl  0x8(%ebp)
  80328b:	6a 2c                	push   $0x2c
  80328d:	e8 79 fa ff ff       	call   802d0b <syscall>
  803292:	83 c4 18             	add    $0x18,%esp
	return ;
  803295:	90                   	nop
}
  803296:	c9                   	leave  
  803297:	c3                   	ret    

00803298 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  803298:	55                   	push   %ebp
  803299:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80329b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80329e:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a1:	6a 00                	push   $0x0
  8032a3:	6a 00                	push   $0x0
  8032a5:	6a 00                	push   $0x0
  8032a7:	52                   	push   %edx
  8032a8:	50                   	push   %eax
  8032a9:	6a 2e                	push   $0x2e
  8032ab:	e8 5b fa ff ff       	call   802d0b <syscall>
  8032b0:	83 c4 18             	add    $0x18,%esp
}
  8032b3:	90                   	nop
  8032b4:	c9                   	leave  
  8032b5:	c3                   	ret    

008032b6 <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8032b6:	55                   	push   %ebp
  8032b7:	89 e5                	mov    %esp,%ebp
  8032b9:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  8032bc:	81 7d 08 80 d0 81 00 	cmpl   $0x81d080,0x8(%ebp)
  8032c3:	72 09                	jb     8032ce <to_page_va+0x18>
  8032c5:	81 7d 08 80 50 83 00 	cmpl   $0x835080,0x8(%ebp)
  8032cc:	72 14                	jb     8032e2 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  8032ce:	83 ec 04             	sub    $0x4,%esp
  8032d1:	68 b8 48 80 00       	push   $0x8048b8
  8032d6:	6a 15                	push   $0x15
  8032d8:	68 e3 48 80 00       	push   $0x8048e3
  8032dd:	e8 10 d0 ff ff       	call   8002f2 <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8032e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e5:	ba 80 d0 81 00       	mov    $0x81d080,%edx
  8032ea:	29 d0                	sub    %edx,%eax
  8032ec:	c1 f8 02             	sar    $0x2,%eax
  8032ef:	89 c2                	mov    %eax,%edx
  8032f1:	89 d0                	mov    %edx,%eax
  8032f3:	c1 e0 02             	shl    $0x2,%eax
  8032f6:	01 d0                	add    %edx,%eax
  8032f8:	c1 e0 02             	shl    $0x2,%eax
  8032fb:	01 d0                	add    %edx,%eax
  8032fd:	c1 e0 02             	shl    $0x2,%eax
  803300:	01 d0                	add    %edx,%eax
  803302:	89 c1                	mov    %eax,%ecx
  803304:	c1 e1 08             	shl    $0x8,%ecx
  803307:	01 c8                	add    %ecx,%eax
  803309:	89 c1                	mov    %eax,%ecx
  80330b:	c1 e1 10             	shl    $0x10,%ecx
  80330e:	01 c8                	add    %ecx,%eax
  803310:	01 c0                	add    %eax,%eax
  803312:	01 d0                	add    %edx,%eax
  803314:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  803317:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331a:	c1 e0 0c             	shl    $0xc,%eax
  80331d:	89 c2                	mov    %eax,%edx
  80331f:	a1 84 50 83 00       	mov    0x835084,%eax
  803324:	01 d0                	add    %edx,%eax
}
  803326:	c9                   	leave  
  803327:	c3                   	ret    

00803328 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  803328:	55                   	push   %ebp
  803329:	89 e5                	mov    %esp,%ebp
  80332b:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  80332e:	a1 84 50 83 00       	mov    0x835084,%eax
  803333:	8b 55 08             	mov    0x8(%ebp),%edx
  803336:	29 c2                	sub    %eax,%edx
  803338:	89 d0                	mov    %edx,%eax
  80333a:	c1 e8 0c             	shr    $0xc,%eax
  80333d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  803340:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803344:	78 09                	js     80334f <to_page_info+0x27>
  803346:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  80334d:	7e 14                	jle    803363 <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  80334f:	83 ec 04             	sub    $0x4,%esp
  803352:	68 fc 48 80 00       	push   $0x8048fc
  803357:	6a 21                	push   $0x21
  803359:	68 e3 48 80 00       	push   $0x8048e3
  80335e:	e8 8f cf ff ff       	call   8002f2 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  803363:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803366:	89 d0                	mov    %edx,%eax
  803368:	01 c0                	add    %eax,%eax
  80336a:	01 d0                	add    %edx,%eax
  80336c:	c1 e0 02             	shl    $0x2,%eax
  80336f:	05 80 d0 81 00       	add    $0x81d080,%eax
}
  803374:	c9                   	leave  
  803375:	c3                   	ret    

00803376 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803376:	55                   	push   %ebp
  803377:	89 e5                	mov    %esp,%ebp
  803379:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  80337c:	8b 45 08             	mov    0x8(%ebp),%eax
  80337f:	05 00 00 00 02       	add    $0x2000000,%eax
  803384:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803387:	73 16                	jae    80339f <initialize_dynamic_allocator+0x29>
  803389:	68 20 49 80 00       	push   $0x804920
  80338e:	68 46 49 80 00       	push   $0x804946
  803393:	6a 2f                	push   $0x2f
  803395:	68 e3 48 80 00       	push   $0x8048e3
  80339a:	e8 53 cf ff ff       	call   8002f2 <_panic>
	dynAllocStart = daStart;
  80339f:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a2:	a3 84 50 83 00       	mov    %eax,0x835084
	dynAllocEnd = daEnd;
  8033a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033aa:	a3 60 d0 81 00       	mov    %eax,0x81d060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8033af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8033b6:	eb 36                	jmp    8033ee <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  8033b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033bb:	c1 e0 04             	shl    $0x4,%eax
  8033be:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8033c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033cc:	c1 e0 04             	shl    $0x4,%eax
  8033cf:	05 a4 50 83 00       	add    $0x8350a4,%eax
  8033d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033dd:	c1 e0 04             	shl    $0x4,%eax
  8033e0:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8033e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8033eb:	ff 45 f4             	incl   -0xc(%ebp)
  8033ee:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  8033f2:	7e c4                	jle    8033b8 <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  8033f4:	c7 05 68 d0 81 00 00 	movl   $0x0,0x81d068
  8033fb:	00 00 00 
  8033fe:	c7 05 6c d0 81 00 00 	movl   $0x0,0x81d06c
  803405:	00 00 00 
  803408:	c7 05 74 d0 81 00 00 	movl   $0x0,0x81d074
  80340f:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803412:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803419:	e9 1b 01 00 00       	jmp    803539 <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  80341e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803421:	89 d0                	mov    %edx,%eax
  803423:	01 c0                	add    %eax,%eax
  803425:	01 d0                	add    %edx,%eax
  803427:	c1 e0 02             	shl    $0x2,%eax
  80342a:	05 88 d0 81 00       	add    $0x81d088,%eax
  80342f:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  803434:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803437:	89 d0                	mov    %edx,%eax
  803439:	01 c0                	add    %eax,%eax
  80343b:	01 d0                	add    %edx,%eax
  80343d:	c1 e0 02             	shl    $0x2,%eax
  803440:	05 8a d0 81 00       	add    $0x81d08a,%eax
  803445:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  80344a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80344d:	89 d0                	mov    %edx,%eax
  80344f:	01 c0                	add    %eax,%eax
  803451:	01 d0                	add    %edx,%eax
  803453:	c1 e0 02             	shl    $0x2,%eax
  803456:	05 80 d0 81 00       	add    $0x81d080,%eax
  80345b:	8b 00                	mov    (%eax),%eax
  80345d:	85 c0                	test   %eax,%eax
  80345f:	74 2b                	je     80348c <initialize_dynamic_allocator+0x116>
  803461:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803464:	89 d0                	mov    %edx,%eax
  803466:	01 c0                	add    %eax,%eax
  803468:	01 d0                	add    %edx,%eax
  80346a:	c1 e0 02             	shl    $0x2,%eax
  80346d:	05 80 d0 81 00       	add    $0x81d080,%eax
  803472:	8b 10                	mov    (%eax),%edx
  803474:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803477:	89 c8                	mov    %ecx,%eax
  803479:	01 c0                	add    %eax,%eax
  80347b:	01 c8                	add    %ecx,%eax
  80347d:	c1 e0 02             	shl    $0x2,%eax
  803480:	05 84 d0 81 00       	add    $0x81d084,%eax
  803485:	8b 00                	mov    (%eax),%eax
  803487:	89 42 04             	mov    %eax,0x4(%edx)
  80348a:	eb 18                	jmp    8034a4 <initialize_dynamic_allocator+0x12e>
  80348c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80348f:	89 d0                	mov    %edx,%eax
  803491:	01 c0                	add    %eax,%eax
  803493:	01 d0                	add    %edx,%eax
  803495:	c1 e0 02             	shl    $0x2,%eax
  803498:	05 84 d0 81 00       	add    $0x81d084,%eax
  80349d:	8b 00                	mov    (%eax),%eax
  80349f:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  8034a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034a7:	89 d0                	mov    %edx,%eax
  8034a9:	01 c0                	add    %eax,%eax
  8034ab:	01 d0                	add    %edx,%eax
  8034ad:	c1 e0 02             	shl    $0x2,%eax
  8034b0:	05 84 d0 81 00       	add    $0x81d084,%eax
  8034b5:	8b 00                	mov    (%eax),%eax
  8034b7:	85 c0                	test   %eax,%eax
  8034b9:	74 2a                	je     8034e5 <initialize_dynamic_allocator+0x16f>
  8034bb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034be:	89 d0                	mov    %edx,%eax
  8034c0:	01 c0                	add    %eax,%eax
  8034c2:	01 d0                	add    %edx,%eax
  8034c4:	c1 e0 02             	shl    $0x2,%eax
  8034c7:	05 84 d0 81 00       	add    $0x81d084,%eax
  8034cc:	8b 10                	mov    (%eax),%edx
  8034ce:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8034d1:	89 c8                	mov    %ecx,%eax
  8034d3:	01 c0                	add    %eax,%eax
  8034d5:	01 c8                	add    %ecx,%eax
  8034d7:	c1 e0 02             	shl    $0x2,%eax
  8034da:	05 80 d0 81 00       	add    $0x81d080,%eax
  8034df:	8b 00                	mov    (%eax),%eax
  8034e1:	89 02                	mov    %eax,(%edx)
  8034e3:	eb 18                	jmp    8034fd <initialize_dynamic_allocator+0x187>
  8034e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034e8:	89 d0                	mov    %edx,%eax
  8034ea:	01 c0                	add    %eax,%eax
  8034ec:	01 d0                	add    %edx,%eax
  8034ee:	c1 e0 02             	shl    $0x2,%eax
  8034f1:	05 80 d0 81 00       	add    $0x81d080,%eax
  8034f6:	8b 00                	mov    (%eax),%eax
  8034f8:	a3 68 d0 81 00       	mov    %eax,0x81d068
  8034fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803500:	89 d0                	mov    %edx,%eax
  803502:	01 c0                	add    %eax,%eax
  803504:	01 d0                	add    %edx,%eax
  803506:	c1 e0 02             	shl    $0x2,%eax
  803509:	05 80 d0 81 00       	add    $0x81d080,%eax
  80350e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803514:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803517:	89 d0                	mov    %edx,%eax
  803519:	01 c0                	add    %eax,%eax
  80351b:	01 d0                	add    %edx,%eax
  80351d:	c1 e0 02             	shl    $0x2,%eax
  803520:	05 84 d0 81 00       	add    $0x81d084,%eax
  803525:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80352b:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803530:	48                   	dec    %eax
  803531:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803536:	ff 45 f0             	incl   -0x10(%ebp)
  803539:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  803540:	0f 8e d8 fe ff ff    	jle    80341e <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803546:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  80354d:	e9 9d 00 00 00       	jmp    8035ef <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  803552:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803558:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  80355b:	89 c8                	mov    %ecx,%eax
  80355d:	01 c0                	add    %eax,%eax
  80355f:	01 c8                	add    %ecx,%eax
  803561:	c1 e0 02             	shl    $0x2,%eax
  803564:	05 80 d0 81 00       	add    $0x81d080,%eax
  803569:	89 10                	mov    %edx,(%eax)
  80356b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80356e:	89 d0                	mov    %edx,%eax
  803570:	01 c0                	add    %eax,%eax
  803572:	01 d0                	add    %edx,%eax
  803574:	c1 e0 02             	shl    $0x2,%eax
  803577:	05 80 d0 81 00       	add    $0x81d080,%eax
  80357c:	8b 00                	mov    (%eax),%eax
  80357e:	85 c0                	test   %eax,%eax
  803580:	74 1c                	je     80359e <initialize_dynamic_allocator+0x228>
  803582:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803588:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  80358b:	89 c8                	mov    %ecx,%eax
  80358d:	01 c0                	add    %eax,%eax
  80358f:	01 c8                	add    %ecx,%eax
  803591:	c1 e0 02             	shl    $0x2,%eax
  803594:	05 80 d0 81 00       	add    $0x81d080,%eax
  803599:	89 42 04             	mov    %eax,0x4(%edx)
  80359c:	eb 16                	jmp    8035b4 <initialize_dynamic_allocator+0x23e>
  80359e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8035a1:	89 d0                	mov    %edx,%eax
  8035a3:	01 c0                	add    %eax,%eax
  8035a5:	01 d0                	add    %edx,%eax
  8035a7:	c1 e0 02             	shl    $0x2,%eax
  8035aa:	05 80 d0 81 00       	add    $0x81d080,%eax
  8035af:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  8035b4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8035b7:	89 d0                	mov    %edx,%eax
  8035b9:	01 c0                	add    %eax,%eax
  8035bb:	01 d0                	add    %edx,%eax
  8035bd:	c1 e0 02             	shl    $0x2,%eax
  8035c0:	05 80 d0 81 00       	add    $0x81d080,%eax
  8035c5:	a3 68 d0 81 00       	mov    %eax,0x81d068
  8035ca:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8035cd:	89 d0                	mov    %edx,%eax
  8035cf:	01 c0                	add    %eax,%eax
  8035d1:	01 d0                	add    %edx,%eax
  8035d3:	c1 e0 02             	shl    $0x2,%eax
  8035d6:	05 84 d0 81 00       	add    $0x81d084,%eax
  8035db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035e1:	a1 74 d0 81 00       	mov    0x81d074,%eax
  8035e6:	40                   	inc    %eax
  8035e7:	a3 74 d0 81 00       	mov    %eax,0x81d074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  8035ec:	ff 4d ec             	decl   -0x14(%ebp)
  8035ef:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8035f3:	0f 89 59 ff ff ff    	jns    803552 <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  8035f9:	c7 05 44 d0 81 00 01 	movl   $0x1,0x81d044
  803600:	00 00 00 
}
  803603:	90                   	nop
  803604:	c9                   	leave  
  803605:	c3                   	ret    

00803606 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  803606:	55                   	push   %ebp
  803607:	89 e5                	mov    %esp,%ebp
  803609:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  80360c:	8b 45 08             	mov    0x8(%ebp),%eax
  80360f:	83 ec 0c             	sub    $0xc,%esp
  803612:	50                   	push   %eax
  803613:	e8 10 fd ff ff       	call   803328 <to_page_info>
  803618:	83 c4 10             	add    $0x10,%esp
  80361b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  80361e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803621:	8b 40 08             	mov    0x8(%eax),%eax
  803624:	0f b7 c0             	movzwl %ax,%eax
}
  803627:	c9                   	leave  
  803628:	c3                   	ret    

00803629 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803629:	55                   	push   %ebp
  80362a:	89 e5                	mov    %esp,%ebp
  80362c:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  80362f:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803636:	76 16                	jbe    80364e <alloc_block+0x25>
  803638:	68 5c 49 80 00       	push   $0x80495c
  80363d:	68 46 49 80 00       	push   $0x804946
  803642:	6a 59                	push   $0x59
  803644:	68 e3 48 80 00       	push   $0x8048e3
  803649:	e8 a4 cc ff ff       	call   8002f2 <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  80364e:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803655:	eb 08                	jmp    80365f <alloc_block+0x36>
		allocSize <<= 1;
  803657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365a:	01 c0                	add    %eax,%eax
  80365c:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  80365f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803662:	3b 45 08             	cmp    0x8(%ebp),%eax
  803665:	73 09                	jae    803670 <alloc_block+0x47>
  803667:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  80366e:	76 e7                	jbe    803657 <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  803670:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803677:	eb 03                	jmp    80367c <alloc_block+0x53>
		listIndex++;
  803679:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  80367c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80367f:	ba 08 00 00 00       	mov    $0x8,%edx
  803684:	88 c1                	mov    %al,%cl
  803686:	d3 e2                	shl    %cl,%edx
  803688:	89 d0                	mov    %edx,%eax
  80368a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80368d:	72 ea                	jb     803679 <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  80368f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803692:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803695:	e9 f4 00 00 00       	jmp    80378e <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  80369a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80369d:	c1 e0 04             	shl    $0x4,%eax
  8036a0:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8036a5:	8b 00                	mov    (%eax),%eax
  8036a7:	85 c0                	test   %eax,%eax
  8036a9:	0f 84 dc 00 00 00    	je     80378b <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  8036af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036b2:	c1 e0 04             	shl    $0x4,%eax
  8036b5:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8036ba:	8b 00                	mov    (%eax),%eax
  8036bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  8036bf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036c3:	75 14                	jne    8036d9 <alloc_block+0xb0>
  8036c5:	83 ec 04             	sub    $0x4,%esp
  8036c8:	68 7d 49 80 00       	push   $0x80497d
  8036cd:	6a 6b                	push   $0x6b
  8036cf:	68 e3 48 80 00       	push   $0x8048e3
  8036d4:	e8 19 cc ff ff       	call   8002f2 <_panic>
  8036d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036dc:	8b 00                	mov    (%eax),%eax
  8036de:	85 c0                	test   %eax,%eax
  8036e0:	74 10                	je     8036f2 <alloc_block+0xc9>
  8036e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036e5:	8b 00                	mov    (%eax),%eax
  8036e7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036ea:	8b 52 04             	mov    0x4(%edx),%edx
  8036ed:	89 50 04             	mov    %edx,0x4(%eax)
  8036f0:	eb 14                	jmp    803706 <alloc_block+0xdd>
  8036f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036f5:	8b 40 04             	mov    0x4(%eax),%eax
  8036f8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036fb:	c1 e2 04             	shl    $0x4,%edx
  8036fe:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803704:	89 02                	mov    %eax,(%edx)
  803706:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803709:	8b 40 04             	mov    0x4(%eax),%eax
  80370c:	85 c0                	test   %eax,%eax
  80370e:	74 0f                	je     80371f <alloc_block+0xf6>
  803710:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803713:	8b 40 04             	mov    0x4(%eax),%eax
  803716:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803719:	8b 12                	mov    (%edx),%edx
  80371b:	89 10                	mov    %edx,(%eax)
  80371d:	eb 13                	jmp    803732 <alloc_block+0x109>
  80371f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803722:	8b 00                	mov    (%eax),%eax
  803724:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803727:	c1 e2 04             	shl    $0x4,%edx
  80372a:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803730:	89 02                	mov    %eax,(%edx)
  803732:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803735:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80373b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80373e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803745:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803748:	c1 e0 04             	shl    $0x4,%eax
  80374b:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803750:	8b 00                	mov    (%eax),%eax
  803752:	8d 50 ff             	lea    -0x1(%eax),%edx
  803755:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803758:	c1 e0 04             	shl    $0x4,%eax
  80375b:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803760:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  803762:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803765:	83 ec 0c             	sub    $0xc,%esp
  803768:	50                   	push   %eax
  803769:	e8 ba fb ff ff       	call   803328 <to_page_info>
  80376e:	83 c4 10             	add    $0x10,%esp
  803771:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  803774:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803777:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80377b:	48                   	dec    %eax
  80377c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80377f:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  803783:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803786:	e9 8f 02 00 00       	jmp    803a1a <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  80378b:	ff 45 ec             	incl   -0x14(%ebp)
  80378e:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803792:	0f 8e 02 ff ff ff    	jle    80369a <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  803798:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80379d:	85 c0                	test   %eax,%eax
  80379f:	75 14                	jne    8037b5 <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  8037a1:	83 ec 04             	sub    $0x4,%esp
  8037a4:	68 9c 49 80 00       	push   $0x80499c
  8037a9:	6a 77                	push   $0x77
  8037ab:	68 e3 48 80 00       	push   $0x8048e3
  8037b0:	e8 3d cb ff ff       	call   8002f2 <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  8037b5:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8037ba:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  8037bd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8037c1:	75 14                	jne    8037d7 <alloc_block+0x1ae>
  8037c3:	83 ec 04             	sub    $0x4,%esp
  8037c6:	68 7d 49 80 00       	push   $0x80497d
  8037cb:	6a 7a                	push   $0x7a
  8037cd:	68 e3 48 80 00       	push   $0x8048e3
  8037d2:	e8 1b cb ff ff       	call   8002f2 <_panic>
  8037d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037da:	8b 00                	mov    (%eax),%eax
  8037dc:	85 c0                	test   %eax,%eax
  8037de:	74 10                	je     8037f0 <alloc_block+0x1c7>
  8037e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037e3:	8b 00                	mov    (%eax),%eax
  8037e5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8037e8:	8b 52 04             	mov    0x4(%edx),%edx
  8037eb:	89 50 04             	mov    %edx,0x4(%eax)
  8037ee:	eb 0b                	jmp    8037fb <alloc_block+0x1d2>
  8037f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037f3:	8b 40 04             	mov    0x4(%eax),%eax
  8037f6:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  8037fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037fe:	8b 40 04             	mov    0x4(%eax),%eax
  803801:	85 c0                	test   %eax,%eax
  803803:	74 0f                	je     803814 <alloc_block+0x1eb>
  803805:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803808:	8b 40 04             	mov    0x4(%eax),%eax
  80380b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80380e:	8b 12                	mov    (%edx),%edx
  803810:	89 10                	mov    %edx,(%eax)
  803812:	eb 0a                	jmp    80381e <alloc_block+0x1f5>
  803814:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803817:	8b 00                	mov    (%eax),%eax
  803819:	a3 68 d0 81 00       	mov    %eax,0x81d068
  80381e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803821:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803827:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80382a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803831:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803836:	48                   	dec    %eax
  803837:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  80383c:	83 ec 0c             	sub    $0xc,%esp
  80383f:	ff 75 dc             	pushl  -0x24(%ebp)
  803842:	e8 6f fa ff ff       	call   8032b6 <to_page_va>
  803847:	83 c4 10             	add    $0x10,%esp
  80384a:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  80384d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803850:	83 ec 0c             	sub    $0xc,%esp
  803853:	50                   	push   %eax
  803854:	e8 a0 dc ff ff       	call   8014f9 <get_page>
  803859:	83 c4 10             	add    $0x10,%esp
  80385c:	85 c0                	test   %eax,%eax
  80385e:	74 14                	je     803874 <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  803860:	83 ec 04             	sub    $0x4,%esp
  803863:	68 c4 49 80 00       	push   $0x8049c4
  803868:	6a 7f                	push   $0x7f
  80386a:	68 e3 48 80 00       	push   $0x8048e3
  80386f:	e8 7e ca ff ff       	call   8002f2 <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  803874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803877:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80387a:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  80387e:	b8 00 10 00 00       	mov    $0x1000,%eax
  803883:	ba 00 00 00 00       	mov    $0x0,%edx
  803888:	f7 75 f4             	divl   -0xc(%ebp)
  80388b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80388e:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803892:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803899:	e9 a7 00 00 00       	jmp    803945 <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  80389e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8038a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038a4:	01 d0                	add    %edx,%eax
  8038a6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  8038a9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8038ad:	75 17                	jne    8038c6 <alloc_block+0x29d>
  8038af:	83 ec 04             	sub    $0x4,%esp
  8038b2:	68 ec 49 80 00       	push   $0x8049ec
  8038b7:	68 88 00 00 00       	push   $0x88
  8038bc:	68 e3 48 80 00       	push   $0x8048e3
  8038c1:	e8 2c ca ff ff       	call   8002f2 <_panic>
  8038c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038c9:	c1 e0 04             	shl    $0x4,%eax
  8038cc:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8038d1:	8b 10                	mov    (%eax),%edx
  8038d3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038d6:	89 10                	mov    %edx,(%eax)
  8038d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038db:	8b 00                	mov    (%eax),%eax
  8038dd:	85 c0                	test   %eax,%eax
  8038df:	74 15                	je     8038f6 <alloc_block+0x2cd>
  8038e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038e4:	c1 e0 04             	shl    $0x4,%eax
  8038e7:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8038ec:	8b 00                	mov    (%eax),%eax
  8038ee:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8038f1:	89 50 04             	mov    %edx,0x4(%eax)
  8038f4:	eb 11                	jmp    803907 <alloc_block+0x2de>
  8038f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038f9:	c1 e0 04             	shl    $0x4,%eax
  8038fc:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803902:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803905:	89 02                	mov    %eax,(%edx)
  803907:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80390a:	c1 e0 04             	shl    $0x4,%eax
  80390d:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803913:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803916:	89 02                	mov    %eax,(%edx)
  803918:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80391b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803922:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803925:	c1 e0 04             	shl    $0x4,%eax
  803928:	05 ac 50 83 00       	add    $0x8350ac,%eax
  80392d:	8b 00                	mov    (%eax),%eax
  80392f:	8d 50 01             	lea    0x1(%eax),%edx
  803932:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803935:	c1 e0 04             	shl    $0x4,%eax
  803938:	05 ac 50 83 00       	add    $0x8350ac,%eax
  80393d:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  80393f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803942:	01 45 e8             	add    %eax,-0x18(%ebp)
  803945:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  80394c:	0f 86 4c ff ff ff    	jbe    80389e <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  803952:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803955:	c1 e0 04             	shl    $0x4,%eax
  803958:	05 a0 50 83 00       	add    $0x8350a0,%eax
  80395d:	8b 00                	mov    (%eax),%eax
  80395f:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  803962:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803966:	75 17                	jne    80397f <alloc_block+0x356>
  803968:	83 ec 04             	sub    $0x4,%esp
  80396b:	68 7d 49 80 00       	push   $0x80497d
  803970:	68 8d 00 00 00       	push   $0x8d
  803975:	68 e3 48 80 00       	push   $0x8048e3
  80397a:	e8 73 c9 ff ff       	call   8002f2 <_panic>
  80397f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803982:	8b 00                	mov    (%eax),%eax
  803984:	85 c0                	test   %eax,%eax
  803986:	74 10                	je     803998 <alloc_block+0x36f>
  803988:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80398b:	8b 00                	mov    (%eax),%eax
  80398d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803990:	8b 52 04             	mov    0x4(%edx),%edx
  803993:	89 50 04             	mov    %edx,0x4(%eax)
  803996:	eb 14                	jmp    8039ac <alloc_block+0x383>
  803998:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80399b:	8b 40 04             	mov    0x4(%eax),%eax
  80399e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039a1:	c1 e2 04             	shl    $0x4,%edx
  8039a4:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  8039aa:	89 02                	mov    %eax,(%edx)
  8039ac:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8039af:	8b 40 04             	mov    0x4(%eax),%eax
  8039b2:	85 c0                	test   %eax,%eax
  8039b4:	74 0f                	je     8039c5 <alloc_block+0x39c>
  8039b6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8039b9:	8b 40 04             	mov    0x4(%eax),%eax
  8039bc:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8039bf:	8b 12                	mov    (%edx),%edx
  8039c1:	89 10                	mov    %edx,(%eax)
  8039c3:	eb 13                	jmp    8039d8 <alloc_block+0x3af>
  8039c5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8039c8:	8b 00                	mov    (%eax),%eax
  8039ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039cd:	c1 e2 04             	shl    $0x4,%edx
  8039d0:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  8039d6:	89 02                	mov    %eax,(%edx)
  8039d8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8039db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039e1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8039e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039ee:	c1 e0 04             	shl    $0x4,%eax
  8039f1:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8039f6:	8b 00                	mov    (%eax),%eax
  8039f8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8039fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039fe:	c1 e0 04             	shl    $0x4,%eax
  803a01:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803a06:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  803a08:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a0b:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803a0f:	48                   	dec    %eax
  803a10:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803a13:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  803a17:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  803a1a:	c9                   	leave  
  803a1b:	c3                   	ret    

00803a1c <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803a1c:	55                   	push   %ebp
  803a1d:	89 e5                	mov    %esp,%ebp
  803a1f:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803a22:	8b 55 08             	mov    0x8(%ebp),%edx
  803a25:	a1 84 50 83 00       	mov    0x835084,%eax
  803a2a:	39 c2                	cmp    %eax,%edx
  803a2c:	72 0c                	jb     803a3a <free_block+0x1e>
  803a2e:	8b 55 08             	mov    0x8(%ebp),%edx
  803a31:	a1 60 d0 81 00       	mov    0x81d060,%eax
  803a36:	39 c2                	cmp    %eax,%edx
  803a38:	72 19                	jb     803a53 <free_block+0x37>
  803a3a:	68 10 4a 80 00       	push   $0x804a10
  803a3f:	68 46 49 80 00       	push   $0x804946
  803a44:	68 98 00 00 00       	push   $0x98
  803a49:	68 e3 48 80 00       	push   $0x8048e3
  803a4e:	e8 9f c8 ff ff       	call   8002f2 <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803a53:	8b 45 08             	mov    0x8(%ebp),%eax
  803a56:	83 ec 0c             	sub    $0xc,%esp
  803a59:	50                   	push   %eax
  803a5a:	e8 c9 f8 ff ff       	call   803328 <to_page_info>
  803a5f:	83 c4 10             	add    $0x10,%esp
  803a62:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  803a65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a68:	8b 40 08             	mov    0x8(%eax),%eax
  803a6b:	0f b7 c0             	movzwl %ax,%eax
  803a6e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  803a71:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803a78:	eb 03                	jmp    803a7d <free_block+0x61>
		listIndex++;
  803a7a:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a80:	ba 08 00 00 00       	mov    $0x8,%edx
  803a85:	88 c1                	mov    %al,%cl
  803a87:	d3 e2                	shl    %cl,%edx
  803a89:	89 d0                	mov    %edx,%eax
  803a8b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803a8e:	72 ea                	jb     803a7a <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  803a90:	8b 45 08             	mov    0x8(%ebp),%eax
  803a93:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  803a96:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a9a:	75 17                	jne    803ab3 <free_block+0x97>
  803a9c:	83 ec 04             	sub    $0x4,%esp
  803a9f:	68 ec 49 80 00       	push   $0x8049ec
  803aa4:	68 a2 00 00 00       	push   $0xa2
  803aa9:	68 e3 48 80 00       	push   $0x8048e3
  803aae:	e8 3f c8 ff ff       	call   8002f2 <_panic>
  803ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ab6:	c1 e0 04             	shl    $0x4,%eax
  803ab9:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803abe:	8b 10                	mov    (%eax),%edx
  803ac0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ac3:	89 10                	mov    %edx,(%eax)
  803ac5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ac8:	8b 00                	mov    (%eax),%eax
  803aca:	85 c0                	test   %eax,%eax
  803acc:	74 15                	je     803ae3 <free_block+0xc7>
  803ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ad1:	c1 e0 04             	shl    $0x4,%eax
  803ad4:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803ad9:	8b 00                	mov    (%eax),%eax
  803adb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ade:	89 50 04             	mov    %edx,0x4(%eax)
  803ae1:	eb 11                	jmp    803af4 <free_block+0xd8>
  803ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ae6:	c1 e0 04             	shl    $0x4,%eax
  803ae9:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803aef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803af2:	89 02                	mov    %eax,(%edx)
  803af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803af7:	c1 e0 04             	shl    $0x4,%eax
  803afa:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803b00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b03:	89 02                	mov    %eax,(%edx)
  803b05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b08:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b12:	c1 e0 04             	shl    $0x4,%eax
  803b15:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803b1a:	8b 00                	mov    (%eax),%eax
  803b1c:	8d 50 01             	lea    0x1(%eax),%edx
  803b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b22:	c1 e0 04             	shl    $0x4,%eax
  803b25:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803b2a:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  803b2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b2f:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803b33:	40                   	inc    %eax
  803b34:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b37:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  803b3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b3e:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803b42:	0f b7 c8             	movzwl %ax,%ecx
  803b45:	b8 00 10 00 00       	mov    $0x1000,%eax
  803b4a:	ba 00 00 00 00       	mov    $0x0,%edx
  803b4f:	f7 75 e8             	divl   -0x18(%ebp)
  803b52:	39 c1                	cmp    %eax,%ecx
  803b54:	0f 85 ed 01 00 00    	jne    803d47 <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b5d:	c1 e0 04             	shl    $0x4,%eax
  803b60:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803b65:	8b 00                	mov    (%eax),%eax
  803b67:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803b6a:	eb 2a                	jmp    803b96 <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  803b6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b6f:	83 ec 0c             	sub    $0xc,%esp
  803b72:	50                   	push   %eax
  803b73:	e8 b0 f7 ff ff       	call   803328 <to_page_info>
  803b78:	83 c4 10             	add    $0x10,%esp
  803b7b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803b7e:	75 06                	jne    803b86 <free_block+0x16a>
				tmp = b;
  803b80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b83:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803b86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b89:	c1 e0 04             	shl    $0x4,%eax
  803b8c:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803b91:	8b 00                	mov    (%eax),%eax
  803b93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803b96:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803b9a:	74 07                	je     803ba3 <free_block+0x187>
  803b9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b9f:	8b 00                	mov    (%eax),%eax
  803ba1:	eb 05                	jmp    803ba8 <free_block+0x18c>
  803ba3:	b8 00 00 00 00       	mov    $0x0,%eax
  803ba8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803bab:	c1 e2 04             	shl    $0x4,%edx
  803bae:	81 c2 a8 50 83 00    	add    $0x8350a8,%edx
  803bb4:	89 02                	mov    %eax,(%edx)
  803bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bb9:	c1 e0 04             	shl    $0x4,%eax
  803bbc:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803bc1:	8b 00                	mov    (%eax),%eax
  803bc3:	85 c0                	test   %eax,%eax
  803bc5:	75 a5                	jne    803b6c <free_block+0x150>
  803bc7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803bcb:	75 9f                	jne    803b6c <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  803bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bd0:	c1 e0 04             	shl    $0x4,%eax
  803bd3:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803bd8:	8b 00                	mov    (%eax),%eax
  803bda:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  803bdd:	e9 cc 00 00 00       	jmp    803cae <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  803be2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803be5:	8b 00                	mov    (%eax),%eax
  803be7:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  803bea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bed:	83 ec 0c             	sub    $0xc,%esp
  803bf0:	50                   	push   %eax
  803bf1:	e8 32 f7 ff ff       	call   803328 <to_page_info>
  803bf6:	83 c4 10             	add    $0x10,%esp
  803bf9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803bfc:	0f 85 a6 00 00 00    	jne    803ca8 <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  803c02:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803c06:	75 17                	jne    803c1f <free_block+0x203>
  803c08:	83 ec 04             	sub    $0x4,%esp
  803c0b:	68 7d 49 80 00       	push   $0x80497d
  803c10:	68 b5 00 00 00       	push   $0xb5
  803c15:	68 e3 48 80 00       	push   $0x8048e3
  803c1a:	e8 d3 c6 ff ff       	call   8002f2 <_panic>
  803c1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c22:	8b 00                	mov    (%eax),%eax
  803c24:	85 c0                	test   %eax,%eax
  803c26:	74 10                	je     803c38 <free_block+0x21c>
  803c28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c2b:	8b 00                	mov    (%eax),%eax
  803c2d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c30:	8b 52 04             	mov    0x4(%edx),%edx
  803c33:	89 50 04             	mov    %edx,0x4(%eax)
  803c36:	eb 14                	jmp    803c4c <free_block+0x230>
  803c38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c3b:	8b 40 04             	mov    0x4(%eax),%eax
  803c3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c41:	c1 e2 04             	shl    $0x4,%edx
  803c44:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803c4a:	89 02                	mov    %eax,(%edx)
  803c4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c4f:	8b 40 04             	mov    0x4(%eax),%eax
  803c52:	85 c0                	test   %eax,%eax
  803c54:	74 0f                	je     803c65 <free_block+0x249>
  803c56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c59:	8b 40 04             	mov    0x4(%eax),%eax
  803c5c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c5f:	8b 12                	mov    (%edx),%edx
  803c61:	89 10                	mov    %edx,(%eax)
  803c63:	eb 13                	jmp    803c78 <free_block+0x25c>
  803c65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c68:	8b 00                	mov    (%eax),%eax
  803c6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c6d:	c1 e2 04             	shl    $0x4,%edx
  803c70:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803c76:	89 02                	mov    %eax,(%edx)
  803c78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c7b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c84:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c8e:	c1 e0 04             	shl    $0x4,%eax
  803c91:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803c96:	8b 00                	mov    (%eax),%eax
  803c98:	8d 50 ff             	lea    -0x1(%eax),%edx
  803c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c9e:	c1 e0 04             	shl    $0x4,%eax
  803ca1:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803ca6:	89 10                	mov    %edx,(%eax)
			b = next;
  803ca8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803cab:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  803cae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803cb2:	0f 85 2a ff ff ff    	jne    803be2 <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  803cb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cbb:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  803cc1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cc4:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  803cca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803cce:	75 17                	jne    803ce7 <free_block+0x2cb>
  803cd0:	83 ec 04             	sub    $0x4,%esp
  803cd3:	68 ec 49 80 00       	push   $0x8049ec
  803cd8:	68 bc 00 00 00       	push   $0xbc
  803cdd:	68 e3 48 80 00       	push   $0x8048e3
  803ce2:	e8 0b c6 ff ff       	call   8002f2 <_panic>
  803ce7:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803ced:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cf0:	89 10                	mov    %edx,(%eax)
  803cf2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cf5:	8b 00                	mov    (%eax),%eax
  803cf7:	85 c0                	test   %eax,%eax
  803cf9:	74 0d                	je     803d08 <free_block+0x2ec>
  803cfb:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803d00:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803d03:	89 50 04             	mov    %edx,0x4(%eax)
  803d06:	eb 08                	jmp    803d10 <free_block+0x2f4>
  803d08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d0b:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803d10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d13:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803d18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d1b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d22:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803d27:	40                   	inc    %eax
  803d28:	a3 74 d0 81 00       	mov    %eax,0x81d074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  803d2d:	83 ec 0c             	sub    $0xc,%esp
  803d30:	ff 75 ec             	pushl  -0x14(%ebp)
  803d33:	e8 7e f5 ff ff       	call   8032b6 <to_page_va>
  803d38:	83 c4 10             	add    $0x10,%esp
  803d3b:	83 ec 0c             	sub    $0xc,%esp
  803d3e:	50                   	push   %eax
  803d3f:	e8 fe d7 ff ff       	call   801542 <return_page>
  803d44:	83 c4 10             	add    $0x10,%esp
	}
}
  803d47:	90                   	nop
  803d48:	c9                   	leave  
  803d49:	c3                   	ret    

00803d4a <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803d4a:	55                   	push   %ebp
  803d4b:	89 e5                	mov    %esp,%ebp
  803d4d:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803d50:	8b 55 08             	mov    0x8(%ebp),%edx
  803d53:	89 d0                	mov    %edx,%eax
  803d55:	c1 e0 02             	shl    $0x2,%eax
  803d58:	01 d0                	add    %edx,%eax
  803d5a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803d61:	01 d0                	add    %edx,%eax
  803d63:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803d6a:	01 d0                	add    %edx,%eax
  803d6c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803d73:	01 d0                	add    %edx,%eax
  803d75:	c1 e0 04             	shl    $0x4,%eax
  803d78:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  803d7b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  803d82:	0f 31                	rdtsc  
  803d84:	89 45 e8             	mov    %eax,-0x18(%ebp)
  803d87:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  803d8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d8d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803d90:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803d93:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  803d96:	eb 46                	jmp    803dde <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  803d98:	0f 31                	rdtsc  
  803d9a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  803d9d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  803da0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803da3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803da6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  803da9:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803dac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803daf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803db2:	29 c2                	sub    %eax,%edx
  803db4:	89 d0                	mov    %edx,%eax
  803db6:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803db9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dbf:	89 d1                	mov    %edx,%ecx
  803dc1:	29 c1                	sub    %eax,%ecx
  803dc3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803dc6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803dc9:	39 c2                	cmp    %eax,%edx
  803dcb:	0f 97 c0             	seta   %al
  803dce:	0f b6 c0             	movzbl %al,%eax
  803dd1:	29 c1                	sub    %eax,%ecx
  803dd3:	89 c8                	mov    %ecx,%eax
  803dd5:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803dd8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803ddb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  803dde:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803de1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803de4:	72 b2                	jb     803d98 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803de6:	90                   	nop
  803de7:	c9                   	leave  
  803de8:	c3                   	ret    

00803de9 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803de9:	55                   	push   %ebp
  803dea:	89 e5                	mov    %esp,%ebp
  803dec:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803def:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803df6:	eb 03                	jmp    803dfb <busy_wait+0x12>
  803df8:	ff 45 fc             	incl   -0x4(%ebp)
  803dfb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803dfe:	3b 45 08             	cmp    0x8(%ebp),%eax
  803e01:	72 f5                	jb     803df8 <busy_wait+0xf>
	return i;
  803e03:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803e06:	c9                   	leave  
  803e07:	c3                   	ret    

00803e08 <__udivdi3>:
  803e08:	55                   	push   %ebp
  803e09:	57                   	push   %edi
  803e0a:	56                   	push   %esi
  803e0b:	53                   	push   %ebx
  803e0c:	83 ec 1c             	sub    $0x1c,%esp
  803e0f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803e13:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803e17:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803e1b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803e1f:	89 ca                	mov    %ecx,%edx
  803e21:	89 f8                	mov    %edi,%eax
  803e23:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803e27:	85 f6                	test   %esi,%esi
  803e29:	75 2d                	jne    803e58 <__udivdi3+0x50>
  803e2b:	39 cf                	cmp    %ecx,%edi
  803e2d:	77 65                	ja     803e94 <__udivdi3+0x8c>
  803e2f:	89 fd                	mov    %edi,%ebp
  803e31:	85 ff                	test   %edi,%edi
  803e33:	75 0b                	jne    803e40 <__udivdi3+0x38>
  803e35:	b8 01 00 00 00       	mov    $0x1,%eax
  803e3a:	31 d2                	xor    %edx,%edx
  803e3c:	f7 f7                	div    %edi
  803e3e:	89 c5                	mov    %eax,%ebp
  803e40:	31 d2                	xor    %edx,%edx
  803e42:	89 c8                	mov    %ecx,%eax
  803e44:	f7 f5                	div    %ebp
  803e46:	89 c1                	mov    %eax,%ecx
  803e48:	89 d8                	mov    %ebx,%eax
  803e4a:	f7 f5                	div    %ebp
  803e4c:	89 cf                	mov    %ecx,%edi
  803e4e:	89 fa                	mov    %edi,%edx
  803e50:	83 c4 1c             	add    $0x1c,%esp
  803e53:	5b                   	pop    %ebx
  803e54:	5e                   	pop    %esi
  803e55:	5f                   	pop    %edi
  803e56:	5d                   	pop    %ebp
  803e57:	c3                   	ret    
  803e58:	39 ce                	cmp    %ecx,%esi
  803e5a:	77 28                	ja     803e84 <__udivdi3+0x7c>
  803e5c:	0f bd fe             	bsr    %esi,%edi
  803e5f:	83 f7 1f             	xor    $0x1f,%edi
  803e62:	75 40                	jne    803ea4 <__udivdi3+0x9c>
  803e64:	39 ce                	cmp    %ecx,%esi
  803e66:	72 0a                	jb     803e72 <__udivdi3+0x6a>
  803e68:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803e6c:	0f 87 9e 00 00 00    	ja     803f10 <__udivdi3+0x108>
  803e72:	b8 01 00 00 00       	mov    $0x1,%eax
  803e77:	89 fa                	mov    %edi,%edx
  803e79:	83 c4 1c             	add    $0x1c,%esp
  803e7c:	5b                   	pop    %ebx
  803e7d:	5e                   	pop    %esi
  803e7e:	5f                   	pop    %edi
  803e7f:	5d                   	pop    %ebp
  803e80:	c3                   	ret    
  803e81:	8d 76 00             	lea    0x0(%esi),%esi
  803e84:	31 ff                	xor    %edi,%edi
  803e86:	31 c0                	xor    %eax,%eax
  803e88:	89 fa                	mov    %edi,%edx
  803e8a:	83 c4 1c             	add    $0x1c,%esp
  803e8d:	5b                   	pop    %ebx
  803e8e:	5e                   	pop    %esi
  803e8f:	5f                   	pop    %edi
  803e90:	5d                   	pop    %ebp
  803e91:	c3                   	ret    
  803e92:	66 90                	xchg   %ax,%ax
  803e94:	89 d8                	mov    %ebx,%eax
  803e96:	f7 f7                	div    %edi
  803e98:	31 ff                	xor    %edi,%edi
  803e9a:	89 fa                	mov    %edi,%edx
  803e9c:	83 c4 1c             	add    $0x1c,%esp
  803e9f:	5b                   	pop    %ebx
  803ea0:	5e                   	pop    %esi
  803ea1:	5f                   	pop    %edi
  803ea2:	5d                   	pop    %ebp
  803ea3:	c3                   	ret    
  803ea4:	bd 20 00 00 00       	mov    $0x20,%ebp
  803ea9:	89 eb                	mov    %ebp,%ebx
  803eab:	29 fb                	sub    %edi,%ebx
  803ead:	89 f9                	mov    %edi,%ecx
  803eaf:	d3 e6                	shl    %cl,%esi
  803eb1:	89 c5                	mov    %eax,%ebp
  803eb3:	88 d9                	mov    %bl,%cl
  803eb5:	d3 ed                	shr    %cl,%ebp
  803eb7:	89 e9                	mov    %ebp,%ecx
  803eb9:	09 f1                	or     %esi,%ecx
  803ebb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803ebf:	89 f9                	mov    %edi,%ecx
  803ec1:	d3 e0                	shl    %cl,%eax
  803ec3:	89 c5                	mov    %eax,%ebp
  803ec5:	89 d6                	mov    %edx,%esi
  803ec7:	88 d9                	mov    %bl,%cl
  803ec9:	d3 ee                	shr    %cl,%esi
  803ecb:	89 f9                	mov    %edi,%ecx
  803ecd:	d3 e2                	shl    %cl,%edx
  803ecf:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ed3:	88 d9                	mov    %bl,%cl
  803ed5:	d3 e8                	shr    %cl,%eax
  803ed7:	09 c2                	or     %eax,%edx
  803ed9:	89 d0                	mov    %edx,%eax
  803edb:	89 f2                	mov    %esi,%edx
  803edd:	f7 74 24 0c          	divl   0xc(%esp)
  803ee1:	89 d6                	mov    %edx,%esi
  803ee3:	89 c3                	mov    %eax,%ebx
  803ee5:	f7 e5                	mul    %ebp
  803ee7:	39 d6                	cmp    %edx,%esi
  803ee9:	72 19                	jb     803f04 <__udivdi3+0xfc>
  803eeb:	74 0b                	je     803ef8 <__udivdi3+0xf0>
  803eed:	89 d8                	mov    %ebx,%eax
  803eef:	31 ff                	xor    %edi,%edi
  803ef1:	e9 58 ff ff ff       	jmp    803e4e <__udivdi3+0x46>
  803ef6:	66 90                	xchg   %ax,%ax
  803ef8:	8b 54 24 08          	mov    0x8(%esp),%edx
  803efc:	89 f9                	mov    %edi,%ecx
  803efe:	d3 e2                	shl    %cl,%edx
  803f00:	39 c2                	cmp    %eax,%edx
  803f02:	73 e9                	jae    803eed <__udivdi3+0xe5>
  803f04:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803f07:	31 ff                	xor    %edi,%edi
  803f09:	e9 40 ff ff ff       	jmp    803e4e <__udivdi3+0x46>
  803f0e:	66 90                	xchg   %ax,%ax
  803f10:	31 c0                	xor    %eax,%eax
  803f12:	e9 37 ff ff ff       	jmp    803e4e <__udivdi3+0x46>
  803f17:	90                   	nop

00803f18 <__umoddi3>:
  803f18:	55                   	push   %ebp
  803f19:	57                   	push   %edi
  803f1a:	56                   	push   %esi
  803f1b:	53                   	push   %ebx
  803f1c:	83 ec 1c             	sub    $0x1c,%esp
  803f1f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803f23:	8b 74 24 34          	mov    0x34(%esp),%esi
  803f27:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803f2b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803f2f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803f33:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803f37:	89 f3                	mov    %esi,%ebx
  803f39:	89 fa                	mov    %edi,%edx
  803f3b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803f3f:	89 34 24             	mov    %esi,(%esp)
  803f42:	85 c0                	test   %eax,%eax
  803f44:	75 1a                	jne    803f60 <__umoddi3+0x48>
  803f46:	39 f7                	cmp    %esi,%edi
  803f48:	0f 86 a2 00 00 00    	jbe    803ff0 <__umoddi3+0xd8>
  803f4e:	89 c8                	mov    %ecx,%eax
  803f50:	89 f2                	mov    %esi,%edx
  803f52:	f7 f7                	div    %edi
  803f54:	89 d0                	mov    %edx,%eax
  803f56:	31 d2                	xor    %edx,%edx
  803f58:	83 c4 1c             	add    $0x1c,%esp
  803f5b:	5b                   	pop    %ebx
  803f5c:	5e                   	pop    %esi
  803f5d:	5f                   	pop    %edi
  803f5e:	5d                   	pop    %ebp
  803f5f:	c3                   	ret    
  803f60:	39 f0                	cmp    %esi,%eax
  803f62:	0f 87 ac 00 00 00    	ja     804014 <__umoddi3+0xfc>
  803f68:	0f bd e8             	bsr    %eax,%ebp
  803f6b:	83 f5 1f             	xor    $0x1f,%ebp
  803f6e:	0f 84 ac 00 00 00    	je     804020 <__umoddi3+0x108>
  803f74:	bf 20 00 00 00       	mov    $0x20,%edi
  803f79:	29 ef                	sub    %ebp,%edi
  803f7b:	89 fe                	mov    %edi,%esi
  803f7d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803f81:	89 e9                	mov    %ebp,%ecx
  803f83:	d3 e0                	shl    %cl,%eax
  803f85:	89 d7                	mov    %edx,%edi
  803f87:	89 f1                	mov    %esi,%ecx
  803f89:	d3 ef                	shr    %cl,%edi
  803f8b:	09 c7                	or     %eax,%edi
  803f8d:	89 e9                	mov    %ebp,%ecx
  803f8f:	d3 e2                	shl    %cl,%edx
  803f91:	89 14 24             	mov    %edx,(%esp)
  803f94:	89 d8                	mov    %ebx,%eax
  803f96:	d3 e0                	shl    %cl,%eax
  803f98:	89 c2                	mov    %eax,%edx
  803f9a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f9e:	d3 e0                	shl    %cl,%eax
  803fa0:	89 44 24 04          	mov    %eax,0x4(%esp)
  803fa4:	8b 44 24 08          	mov    0x8(%esp),%eax
  803fa8:	89 f1                	mov    %esi,%ecx
  803faa:	d3 e8                	shr    %cl,%eax
  803fac:	09 d0                	or     %edx,%eax
  803fae:	d3 eb                	shr    %cl,%ebx
  803fb0:	89 da                	mov    %ebx,%edx
  803fb2:	f7 f7                	div    %edi
  803fb4:	89 d3                	mov    %edx,%ebx
  803fb6:	f7 24 24             	mull   (%esp)
  803fb9:	89 c6                	mov    %eax,%esi
  803fbb:	89 d1                	mov    %edx,%ecx
  803fbd:	39 d3                	cmp    %edx,%ebx
  803fbf:	0f 82 87 00 00 00    	jb     80404c <__umoddi3+0x134>
  803fc5:	0f 84 91 00 00 00    	je     80405c <__umoddi3+0x144>
  803fcb:	8b 54 24 04          	mov    0x4(%esp),%edx
  803fcf:	29 f2                	sub    %esi,%edx
  803fd1:	19 cb                	sbb    %ecx,%ebx
  803fd3:	89 d8                	mov    %ebx,%eax
  803fd5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803fd9:	d3 e0                	shl    %cl,%eax
  803fdb:	89 e9                	mov    %ebp,%ecx
  803fdd:	d3 ea                	shr    %cl,%edx
  803fdf:	09 d0                	or     %edx,%eax
  803fe1:	89 e9                	mov    %ebp,%ecx
  803fe3:	d3 eb                	shr    %cl,%ebx
  803fe5:	89 da                	mov    %ebx,%edx
  803fe7:	83 c4 1c             	add    $0x1c,%esp
  803fea:	5b                   	pop    %ebx
  803feb:	5e                   	pop    %esi
  803fec:	5f                   	pop    %edi
  803fed:	5d                   	pop    %ebp
  803fee:	c3                   	ret    
  803fef:	90                   	nop
  803ff0:	89 fd                	mov    %edi,%ebp
  803ff2:	85 ff                	test   %edi,%edi
  803ff4:	75 0b                	jne    804001 <__umoddi3+0xe9>
  803ff6:	b8 01 00 00 00       	mov    $0x1,%eax
  803ffb:	31 d2                	xor    %edx,%edx
  803ffd:	f7 f7                	div    %edi
  803fff:	89 c5                	mov    %eax,%ebp
  804001:	89 f0                	mov    %esi,%eax
  804003:	31 d2                	xor    %edx,%edx
  804005:	f7 f5                	div    %ebp
  804007:	89 c8                	mov    %ecx,%eax
  804009:	f7 f5                	div    %ebp
  80400b:	89 d0                	mov    %edx,%eax
  80400d:	e9 44 ff ff ff       	jmp    803f56 <__umoddi3+0x3e>
  804012:	66 90                	xchg   %ax,%ax
  804014:	89 c8                	mov    %ecx,%eax
  804016:	89 f2                	mov    %esi,%edx
  804018:	83 c4 1c             	add    $0x1c,%esp
  80401b:	5b                   	pop    %ebx
  80401c:	5e                   	pop    %esi
  80401d:	5f                   	pop    %edi
  80401e:	5d                   	pop    %ebp
  80401f:	c3                   	ret    
  804020:	3b 04 24             	cmp    (%esp),%eax
  804023:	72 06                	jb     80402b <__umoddi3+0x113>
  804025:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804029:	77 0f                	ja     80403a <__umoddi3+0x122>
  80402b:	89 f2                	mov    %esi,%edx
  80402d:	29 f9                	sub    %edi,%ecx
  80402f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804033:	89 14 24             	mov    %edx,(%esp)
  804036:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80403a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80403e:	8b 14 24             	mov    (%esp),%edx
  804041:	83 c4 1c             	add    $0x1c,%esp
  804044:	5b                   	pop    %ebx
  804045:	5e                   	pop    %esi
  804046:	5f                   	pop    %edi
  804047:	5d                   	pop    %ebp
  804048:	c3                   	ret    
  804049:	8d 76 00             	lea    0x0(%esi),%esi
  80404c:	2b 04 24             	sub    (%esp),%eax
  80404f:	19 fa                	sbb    %edi,%edx
  804051:	89 d1                	mov    %edx,%ecx
  804053:	89 c6                	mov    %eax,%esi
  804055:	e9 71 ff ff ff       	jmp    803fcb <__umoddi3+0xb3>
  80405a:	66 90                	xchg   %ax,%ax
  80405c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804060:	72 ea                	jb     80404c <__umoddi3+0x134>
  804062:	89 d9                	mov    %ebx,%ecx
  804064:	e9 62 ff ff ff       	jmp    803fcb <__umoddi3+0xb3>
