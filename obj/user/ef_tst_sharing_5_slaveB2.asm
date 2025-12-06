
obj/user/ef_tst_sharing_5_slaveB2:     file format elf32-i386


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
  800031:	e8 60 01 00 00       	call   800196 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  80003e:	a1 20 50 80 00       	mov    0x805020,%eax
  800043:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  800049:	a1 20 50 80 00       	mov    0x805020,%eax
  80004e:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800054:	39 c2                	cmp    %eax,%edx
  800056:	72 14                	jb     80006c <_main+0x34>
			panic("Please increase the WS size");
  800058:	83 ec 04             	sub    $0x4,%esp
  80005b:	68 c0 40 80 00       	push   $0x8040c0
  800060:	6a 0b                	push   $0xb
  800062:	68 dc 40 80 00       	push   $0x8040dc
  800067:	e8 da 02 00 00       	call   800346 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80006c:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)
	uint32 *x, *y, *z ;
	int freeFrames, diff, expected;

	z = sget(sys_getparentenvid(),"z");
  800073:	e8 e8 2f 00 00       	call   803060 <sys_getparentenvid>
  800078:	83 ec 08             	sub    $0x8,%esp
  80007b:	68 fc 40 80 00       	push   $0x8040fc
  800080:	50                   	push   %eax
  800081:	e8 17 20 00 00       	call   80209d <sget>
  800086:	83 c4 10             	add    $0x10,%esp
  800089:	89 45 f0             	mov    %eax,-0x10(%ebp)
	inctst(); //to indicate that the shared object is taken
  80008c:	e8 f4 30 00 00       	call   803185 <inctst>
	cprintf("Slave B2 env used z (getSharedObject)\n");
  800091:	83 ec 0c             	sub    $0xc,%esp
  800094:	68 00 41 80 00       	push   $0x804100
  800099:	e8 76 05 00 00       	call   800614 <cprintf>
  80009e:	83 c4 10             	add    $0x10,%esp

	cprintf("Slave B2 please be patient ...\n");
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	68 28 41 80 00       	push   $0x804128
  8000a9:	e8 66 05 00 00       	call   800614 <cprintf>
  8000ae:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z
	env_sleep(9000);
  8000b1:	83 ec 0c             	sub    $0xc,%esp
  8000b4:	68 28 23 00 00       	push   $0x2328
  8000b9:	e8 e0 3c 00 00       	call   803d9e <env_sleep>
  8000be:	83 c4 10             	add    $0x10,%esp
	//to ensure that the other environments completed successfully
	while (gettst()!=5) ;// panic("test failed");
  8000c1:	90                   	nop
  8000c2:	e8 d8 30 00 00       	call   80319f <gettst>
  8000c7:	83 f8 05             	cmp    $0x5,%eax
  8000ca:	75 f6                	jne    8000c2 <_main+0x8a>

	sys_lock_cons(); //critical section to ensure it's executed at atomically
  8000cc:	e8 fd 2c 00 00       	call   802dce <sys_lock_cons>
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000d1:	e8 a8 2d 00 00       	call   802e7e <sys_calculate_free_frames>
  8000d6:	89 45 ec             	mov    %eax,-0x14(%ebp)

		sfree(z);
  8000d9:	83 ec 0c             	sub    $0xc,%esp
  8000dc:	ff 75 f0             	pushl  -0x10(%ebp)
  8000df:	e8 2c 29 00 00       	call   802a10 <sfree>
  8000e4:	83 c4 10             	add    $0x10,%esp
		cprintf("Slave B2 env removed z\n");
  8000e7:	83 ec 0c             	sub    $0xc,%esp
  8000ea:	68 48 41 80 00       	push   $0x804148
  8000ef:	e8 20 05 00 00       	call   800614 <cprintf>
  8000f4:	83 c4 10             	add    $0x10,%esp

		expected = 2+1; /*2pages+1table*/
  8000f7:	c7 45 e8 03 00 00 00 	movl   $0x3,-0x18(%ebp)
		if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("B1 wrong free: frames removed not equal %d !, Expected:\nfrom the env: 1 table and 2 for frames of z\nframes_storage of z: should be cleared now\n", expected);
  8000fe:	e8 7b 2d 00 00       	call   802e7e <sys_calculate_free_frames>
  800103:	89 c2                	mov    %eax,%edx
  800105:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800108:	29 c2                	sub    %eax,%edx
  80010a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80010d:	39 c2                	cmp    %eax,%edx
  80010f:	74 14                	je     800125 <_main+0xed>
  800111:	ff 75 e8             	pushl  -0x18(%ebp)
  800114:	68 60 41 80 00       	push   $0x804160
  800119:	6a 29                	push   $0x29
  80011b:	68 dc 40 80 00       	push   $0x8040dc
  800120:	e8 21 02 00 00       	call   800346 <_panic>
	}
	sys_unlock_cons();
  800125:	e8 be 2c 00 00       	call   802de8 <sys_unlock_cons>
	//To indicate that it's completed successfully
	inctst();
  80012a:	e8 56 30 00 00       	call   803185 <inctst>

	//to ensure that the other environments completed successfully
	while (gettst()!=7) ;// panic("test failed");
  80012f:	90                   	nop
  800130:	e8 6a 30 00 00       	call   80319f <gettst>
  800135:	83 f8 07             	cmp    $0x7,%eax
  800138:	75 f6                	jne    800130 <_main+0xf8>

	cprintf("Step B is finished!!\n\n\n");
  80013a:	83 ec 0c             	sub    $0xc,%esp
  80013d:	68 f0 41 80 00       	push   $0x8041f0
  800142:	e8 cd 04 00 00       	call   800614 <cprintf>
  800147:	83 c4 10             	add    $0x10,%esp
	cprintf("Test of freeSharedObjects [5] is finished!!\n\n\n");
  80014a:	83 ec 0c             	sub    $0xc,%esp
  80014d:	68 08 42 80 00       	push   $0x804208
  800152:	e8 bd 04 00 00       	call   800614 <cprintf>
  800157:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  80015a:	e8 01 2f 00 00       	call   803060 <sys_getparentenvid>
  80015f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(parentenvID > 0)
  800162:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800166:	7e 2b                	jle    800193 <_main+0x15b>
	{
		//Get the check-finishing counter
		int *finish = NULL;
  800168:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		finish = sget(parentenvID, "finish_children") ;
  80016f:	83 ec 08             	sub    $0x8,%esp
  800172:	68 37 42 80 00       	push   $0x804237
  800177:	ff 75 e4             	pushl  -0x1c(%ebp)
  80017a:	e8 1e 1f 00 00       	call   80209d <sget>
  80017f:	83 c4 10             	add    $0x10,%esp
  800182:	89 45 e0             	mov    %eax,-0x20(%ebp)
		(*finish)++ ;
  800185:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800188:	8b 00                	mov    (%eax),%eax
  80018a:	8d 50 01             	lea    0x1(%eax),%edx
  80018d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800190:	89 10                	mov    %edx,(%eax)
	}
	return;
  800192:	90                   	nop
  800193:	90                   	nop
}
  800194:	c9                   	leave  
  800195:	c3                   	ret    

00800196 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800196:	55                   	push   %ebp
  800197:	89 e5                	mov    %esp,%ebp
  800199:	57                   	push   %edi
  80019a:	56                   	push   %esi
  80019b:	53                   	push   %ebx
  80019c:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80019f:	e8 a3 2e 00 00       	call   803047 <sys_getenvindex>
  8001a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8001a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8001aa:	89 d0                	mov    %edx,%eax
  8001ac:	c1 e0 03             	shl    $0x3,%eax
  8001af:	01 d0                	add    %edx,%eax
  8001b1:	c1 e0 02             	shl    $0x2,%eax
  8001b4:	01 d0                	add    %edx,%eax
  8001b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001bd:	01 d0                	add    %edx,%eax
  8001bf:	c1 e0 03             	shl    $0x3,%eax
  8001c2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001c7:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001cc:	a1 20 50 80 00       	mov    0x805020,%eax
  8001d1:	8a 40 20             	mov    0x20(%eax),%al
  8001d4:	84 c0                	test   %al,%al
  8001d6:	74 0d                	je     8001e5 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8001d8:	a1 20 50 80 00       	mov    0x805020,%eax
  8001dd:	83 c0 20             	add    $0x20,%eax
  8001e0:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001e9:	7e 0a                	jle    8001f5 <libmain+0x5f>
		binaryname = argv[0];
  8001eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ee:	8b 00                	mov    (%eax),%eax
  8001f0:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  8001f5:	83 ec 08             	sub    $0x8,%esp
  8001f8:	ff 75 0c             	pushl  0xc(%ebp)
  8001fb:	ff 75 08             	pushl  0x8(%ebp)
  8001fe:	e8 35 fe ff ff       	call   800038 <_main>
  800203:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800206:	a1 00 50 80 00       	mov    0x805000,%eax
  80020b:	85 c0                	test   %eax,%eax
  80020d:	0f 84 01 01 00 00    	je     800314 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800213:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800219:	bb 40 43 80 00       	mov    $0x804340,%ebx
  80021e:	ba 0e 00 00 00       	mov    $0xe,%edx
  800223:	89 c7                	mov    %eax,%edi
  800225:	89 de                	mov    %ebx,%esi
  800227:	89 d1                	mov    %edx,%ecx
  800229:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80022b:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80022e:	b9 56 00 00 00       	mov    $0x56,%ecx
  800233:	b0 00                	mov    $0x0,%al
  800235:	89 d7                	mov    %edx,%edi
  800237:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800239:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800240:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800243:	83 ec 08             	sub    $0x8,%esp
  800246:	50                   	push   %eax
  800247:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80024d:	50                   	push   %eax
  80024e:	e8 2a 30 00 00       	call   80327d <sys_utilities>
  800253:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800256:	e8 73 2b 00 00       	call   802dce <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80025b:	83 ec 0c             	sub    $0xc,%esp
  80025e:	68 60 42 80 00       	push   $0x804260
  800263:	e8 ac 03 00 00       	call   800614 <cprintf>
  800268:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80026b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80026e:	85 c0                	test   %eax,%eax
  800270:	74 18                	je     80028a <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800272:	e8 24 30 00 00       	call   80329b <sys_get_optimal_num_faults>
  800277:	83 ec 08             	sub    $0x8,%esp
  80027a:	50                   	push   %eax
  80027b:	68 88 42 80 00       	push   $0x804288
  800280:	e8 8f 03 00 00       	call   800614 <cprintf>
  800285:	83 c4 10             	add    $0x10,%esp
  800288:	eb 59                	jmp    8002e3 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80028a:	a1 20 50 80 00       	mov    0x805020,%eax
  80028f:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  800295:	a1 20 50 80 00       	mov    0x805020,%eax
  80029a:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8002a0:	83 ec 04             	sub    $0x4,%esp
  8002a3:	52                   	push   %edx
  8002a4:	50                   	push   %eax
  8002a5:	68 ac 42 80 00       	push   $0x8042ac
  8002aa:	e8 65 03 00 00       	call   800614 <cprintf>
  8002af:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002b2:	a1 20 50 80 00       	mov    0x805020,%eax
  8002b7:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  8002bd:	a1 20 50 80 00       	mov    0x805020,%eax
  8002c2:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  8002c8:	a1 20 50 80 00       	mov    0x805020,%eax
  8002cd:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8002d3:	51                   	push   %ecx
  8002d4:	52                   	push   %edx
  8002d5:	50                   	push   %eax
  8002d6:	68 d4 42 80 00       	push   $0x8042d4
  8002db:	e8 34 03 00 00       	call   800614 <cprintf>
  8002e0:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002e3:	a1 20 50 80 00       	mov    0x805020,%eax
  8002e8:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  8002ee:	83 ec 08             	sub    $0x8,%esp
  8002f1:	50                   	push   %eax
  8002f2:	68 2c 43 80 00       	push   $0x80432c
  8002f7:	e8 18 03 00 00       	call   800614 <cprintf>
  8002fc:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8002ff:	83 ec 0c             	sub    $0xc,%esp
  800302:	68 60 42 80 00       	push   $0x804260
  800307:	e8 08 03 00 00       	call   800614 <cprintf>
  80030c:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80030f:	e8 d4 2a 00 00       	call   802de8 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800314:	e8 1f 00 00 00       	call   800338 <exit>
}
  800319:	90                   	nop
  80031a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80031d:	5b                   	pop    %ebx
  80031e:	5e                   	pop    %esi
  80031f:	5f                   	pop    %edi
  800320:	5d                   	pop    %ebp
  800321:	c3                   	ret    

00800322 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800322:	55                   	push   %ebp
  800323:	89 e5                	mov    %esp,%ebp
  800325:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800328:	83 ec 0c             	sub    $0xc,%esp
  80032b:	6a 00                	push   $0x0
  80032d:	e8 e1 2c 00 00       	call   803013 <sys_destroy_env>
  800332:	83 c4 10             	add    $0x10,%esp
}
  800335:	90                   	nop
  800336:	c9                   	leave  
  800337:	c3                   	ret    

00800338 <exit>:

void
exit(void)
{
  800338:	55                   	push   %ebp
  800339:	89 e5                	mov    %esp,%ebp
  80033b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80033e:	e8 36 2d 00 00       	call   803079 <sys_exit_env>
}
  800343:	90                   	nop
  800344:	c9                   	leave  
  800345:	c3                   	ret    

00800346 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800346:	55                   	push   %ebp
  800347:	89 e5                	mov    %esp,%ebp
  800349:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80034c:	8d 45 10             	lea    0x10(%ebp),%eax
  80034f:	83 c0 04             	add    $0x4,%eax
  800352:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800355:	a1 38 51 83 00       	mov    0x835138,%eax
  80035a:	85 c0                	test   %eax,%eax
  80035c:	74 16                	je     800374 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80035e:	a1 38 51 83 00       	mov    0x835138,%eax
  800363:	83 ec 08             	sub    $0x8,%esp
  800366:	50                   	push   %eax
  800367:	68 a4 43 80 00       	push   $0x8043a4
  80036c:	e8 a3 02 00 00       	call   800614 <cprintf>
  800371:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800374:	a1 04 50 80 00       	mov    0x805004,%eax
  800379:	83 ec 0c             	sub    $0xc,%esp
  80037c:	ff 75 0c             	pushl  0xc(%ebp)
  80037f:	ff 75 08             	pushl  0x8(%ebp)
  800382:	50                   	push   %eax
  800383:	68 ac 43 80 00       	push   $0x8043ac
  800388:	6a 74                	push   $0x74
  80038a:	e8 b2 02 00 00       	call   800641 <cprintf_colored>
  80038f:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800392:	8b 45 10             	mov    0x10(%ebp),%eax
  800395:	83 ec 08             	sub    $0x8,%esp
  800398:	ff 75 f4             	pushl  -0xc(%ebp)
  80039b:	50                   	push   %eax
  80039c:	e8 04 02 00 00       	call   8005a5 <vcprintf>
  8003a1:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003a4:	83 ec 08             	sub    $0x8,%esp
  8003a7:	6a 00                	push   $0x0
  8003a9:	68 d4 43 80 00       	push   $0x8043d4
  8003ae:	e8 f2 01 00 00       	call   8005a5 <vcprintf>
  8003b3:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003b6:	e8 7d ff ff ff       	call   800338 <exit>

	// should not return here
	while (1) ;
  8003bb:	eb fe                	jmp    8003bb <_panic+0x75>

008003bd <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8003bd:	55                   	push   %ebp
  8003be:	89 e5                	mov    %esp,%ebp
  8003c0:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8003c3:	a1 20 50 80 00       	mov    0x805020,%eax
  8003c8:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8003ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d1:	39 c2                	cmp    %eax,%edx
  8003d3:	74 14                	je     8003e9 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003d5:	83 ec 04             	sub    $0x4,%esp
  8003d8:	68 d8 43 80 00       	push   $0x8043d8
  8003dd:	6a 26                	push   $0x26
  8003df:	68 24 44 80 00       	push   $0x804424
  8003e4:	e8 5d ff ff ff       	call   800346 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003f0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003f7:	e9 c5 00 00 00       	jmp    8004c1 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8003fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800406:	8b 45 08             	mov    0x8(%ebp),%eax
  800409:	01 d0                	add    %edx,%eax
  80040b:	8b 00                	mov    (%eax),%eax
  80040d:	85 c0                	test   %eax,%eax
  80040f:	75 08                	jne    800419 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800411:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800414:	e9 a5 00 00 00       	jmp    8004be <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800419:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800420:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800427:	eb 69                	jmp    800492 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800429:	a1 20 50 80 00       	mov    0x805020,%eax
  80042e:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800434:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800437:	89 d0                	mov    %edx,%eax
  800439:	01 c0                	add    %eax,%eax
  80043b:	01 d0                	add    %edx,%eax
  80043d:	c1 e0 03             	shl    $0x3,%eax
  800440:	01 c8                	add    %ecx,%eax
  800442:	8a 40 04             	mov    0x4(%eax),%al
  800445:	84 c0                	test   %al,%al
  800447:	75 46                	jne    80048f <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800449:	a1 20 50 80 00       	mov    0x805020,%eax
  80044e:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800454:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800457:	89 d0                	mov    %edx,%eax
  800459:	01 c0                	add    %eax,%eax
  80045b:	01 d0                	add    %edx,%eax
  80045d:	c1 e0 03             	shl    $0x3,%eax
  800460:	01 c8                	add    %ecx,%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800467:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80046a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80046f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800471:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800474:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80047b:	8b 45 08             	mov    0x8(%ebp),%eax
  80047e:	01 c8                	add    %ecx,%eax
  800480:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800482:	39 c2                	cmp    %eax,%edx
  800484:	75 09                	jne    80048f <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800486:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80048d:	eb 15                	jmp    8004a4 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80048f:	ff 45 e8             	incl   -0x18(%ebp)
  800492:	a1 20 50 80 00       	mov    0x805020,%eax
  800497:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80049d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004a0:	39 c2                	cmp    %eax,%edx
  8004a2:	77 85                	ja     800429 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004a4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004a8:	75 14                	jne    8004be <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8004aa:	83 ec 04             	sub    $0x4,%esp
  8004ad:	68 30 44 80 00       	push   $0x804430
  8004b2:	6a 3a                	push   $0x3a
  8004b4:	68 24 44 80 00       	push   $0x804424
  8004b9:	e8 88 fe ff ff       	call   800346 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004be:	ff 45 f0             	incl   -0x10(%ebp)
  8004c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004c4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004c7:	0f 8c 2f ff ff ff    	jl     8003fc <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004cd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004d4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004db:	eb 26                	jmp    800503 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004dd:	a1 20 50 80 00       	mov    0x805020,%eax
  8004e2:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8004e8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004eb:	89 d0                	mov    %edx,%eax
  8004ed:	01 c0                	add    %eax,%eax
  8004ef:	01 d0                	add    %edx,%eax
  8004f1:	c1 e0 03             	shl    $0x3,%eax
  8004f4:	01 c8                	add    %ecx,%eax
  8004f6:	8a 40 04             	mov    0x4(%eax),%al
  8004f9:	3c 01                	cmp    $0x1,%al
  8004fb:	75 03                	jne    800500 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8004fd:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800500:	ff 45 e0             	incl   -0x20(%ebp)
  800503:	a1 20 50 80 00       	mov    0x805020,%eax
  800508:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80050e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800511:	39 c2                	cmp    %eax,%edx
  800513:	77 c8                	ja     8004dd <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800518:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80051b:	74 14                	je     800531 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80051d:	83 ec 04             	sub    $0x4,%esp
  800520:	68 84 44 80 00       	push   $0x804484
  800525:	6a 44                	push   $0x44
  800527:	68 24 44 80 00       	push   $0x804424
  80052c:	e8 15 fe ff ff       	call   800346 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800531:	90                   	nop
  800532:	c9                   	leave  
  800533:	c3                   	ret    

00800534 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800534:	55                   	push   %ebp
  800535:	89 e5                	mov    %esp,%ebp
  800537:	53                   	push   %ebx
  800538:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80053b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80053e:	8b 00                	mov    (%eax),%eax
  800540:	8d 48 01             	lea    0x1(%eax),%ecx
  800543:	8b 55 0c             	mov    0xc(%ebp),%edx
  800546:	89 0a                	mov    %ecx,(%edx)
  800548:	8b 55 08             	mov    0x8(%ebp),%edx
  80054b:	88 d1                	mov    %dl,%cl
  80054d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800550:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800554:	8b 45 0c             	mov    0xc(%ebp),%eax
  800557:	8b 00                	mov    (%eax),%eax
  800559:	3d ff 00 00 00       	cmp    $0xff,%eax
  80055e:	75 30                	jne    800590 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800560:	8b 15 3c 51 83 00    	mov    0x83513c,%edx
  800566:	a0 64 d0 81 00       	mov    0x81d064,%al
  80056b:	0f b6 c0             	movzbl %al,%eax
  80056e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800571:	8b 09                	mov    (%ecx),%ecx
  800573:	89 cb                	mov    %ecx,%ebx
  800575:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800578:	83 c1 08             	add    $0x8,%ecx
  80057b:	52                   	push   %edx
  80057c:	50                   	push   %eax
  80057d:	53                   	push   %ebx
  80057e:	51                   	push   %ecx
  80057f:	e8 06 28 00 00       	call   802d8a <sys_cputs>
  800584:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800587:	8b 45 0c             	mov    0xc(%ebp),%eax
  80058a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800590:	8b 45 0c             	mov    0xc(%ebp),%eax
  800593:	8b 40 04             	mov    0x4(%eax),%eax
  800596:	8d 50 01             	lea    0x1(%eax),%edx
  800599:	8b 45 0c             	mov    0xc(%ebp),%eax
  80059c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80059f:	90                   	nop
  8005a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005a3:	c9                   	leave  
  8005a4:	c3                   	ret    

008005a5 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005a5:	55                   	push   %ebp
  8005a6:	89 e5                	mov    %esp,%ebp
  8005a8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005ae:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005b5:	00 00 00 
	b.cnt = 0;
  8005b8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005bf:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005c2:	ff 75 0c             	pushl  0xc(%ebp)
  8005c5:	ff 75 08             	pushl  0x8(%ebp)
  8005c8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005ce:	50                   	push   %eax
  8005cf:	68 34 05 80 00       	push   $0x800534
  8005d4:	e8 5a 02 00 00       	call   800833 <vprintfmt>
  8005d9:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8005dc:	8b 15 3c 51 83 00    	mov    0x83513c,%edx
  8005e2:	a0 64 d0 81 00       	mov    0x81d064,%al
  8005e7:	0f b6 c0             	movzbl %al,%eax
  8005ea:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8005f0:	52                   	push   %edx
  8005f1:	50                   	push   %eax
  8005f2:	51                   	push   %ecx
  8005f3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005f9:	83 c0 08             	add    $0x8,%eax
  8005fc:	50                   	push   %eax
  8005fd:	e8 88 27 00 00       	call   802d8a <sys_cputs>
  800602:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800605:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
	return b.cnt;
  80060c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800612:	c9                   	leave  
  800613:	c3                   	ret    

00800614 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800614:	55                   	push   %ebp
  800615:	89 e5                	mov    %esp,%ebp
  800617:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80061a:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	va_start(ap, fmt);
  800621:	8d 45 0c             	lea    0xc(%ebp),%eax
  800624:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800627:	8b 45 08             	mov    0x8(%ebp),%eax
  80062a:	83 ec 08             	sub    $0x8,%esp
  80062d:	ff 75 f4             	pushl  -0xc(%ebp)
  800630:	50                   	push   %eax
  800631:	e8 6f ff ff ff       	call   8005a5 <vcprintf>
  800636:	83 c4 10             	add    $0x10,%esp
  800639:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80063c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80063f:	c9                   	leave  
  800640:	c3                   	ret    

00800641 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800641:	55                   	push   %ebp
  800642:	89 e5                	mov    %esp,%ebp
  800644:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800647:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	curTextClr = (textClr << 8) ; //set text color by the given value
  80064e:	8b 45 08             	mov    0x8(%ebp),%eax
  800651:	c1 e0 08             	shl    $0x8,%eax
  800654:	a3 3c 51 83 00       	mov    %eax,0x83513c
	va_start(ap, fmt);
  800659:	8d 45 0c             	lea    0xc(%ebp),%eax
  80065c:	83 c0 04             	add    $0x4,%eax
  80065f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800662:	8b 45 0c             	mov    0xc(%ebp),%eax
  800665:	83 ec 08             	sub    $0x8,%esp
  800668:	ff 75 f4             	pushl  -0xc(%ebp)
  80066b:	50                   	push   %eax
  80066c:	e8 34 ff ff ff       	call   8005a5 <vcprintf>
  800671:	83 c4 10             	add    $0x10,%esp
  800674:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800677:	c7 05 3c 51 83 00 00 	movl   $0x700,0x83513c
  80067e:	07 00 00 

	return cnt;
  800681:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800684:	c9                   	leave  
  800685:	c3                   	ret    

00800686 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800686:	55                   	push   %ebp
  800687:	89 e5                	mov    %esp,%ebp
  800689:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80068c:	e8 3d 27 00 00       	call   802dce <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800691:	8d 45 0c             	lea    0xc(%ebp),%eax
  800694:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800697:	8b 45 08             	mov    0x8(%ebp),%eax
  80069a:	83 ec 08             	sub    $0x8,%esp
  80069d:	ff 75 f4             	pushl  -0xc(%ebp)
  8006a0:	50                   	push   %eax
  8006a1:	e8 ff fe ff ff       	call   8005a5 <vcprintf>
  8006a6:	83 c4 10             	add    $0x10,%esp
  8006a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8006ac:	e8 37 27 00 00       	call   802de8 <sys_unlock_cons>
	return cnt;
  8006b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006b4:	c9                   	leave  
  8006b5:	c3                   	ret    

008006b6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006b6:	55                   	push   %ebp
  8006b7:	89 e5                	mov    %esp,%ebp
  8006b9:	53                   	push   %ebx
  8006ba:	83 ec 14             	sub    $0x14,%esp
  8006bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8006c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006c9:	8b 45 18             	mov    0x18(%ebp),%eax
  8006cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006d4:	77 55                	ja     80072b <printnum+0x75>
  8006d6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006d9:	72 05                	jb     8006e0 <printnum+0x2a>
  8006db:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006de:	77 4b                	ja     80072b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006e0:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006e3:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006e6:	8b 45 18             	mov    0x18(%ebp),%eax
  8006e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ee:	52                   	push   %edx
  8006ef:	50                   	push   %eax
  8006f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8006f3:	ff 75 f0             	pushl  -0x10(%ebp)
  8006f6:	e8 61 37 00 00       	call   803e5c <__udivdi3>
  8006fb:	83 c4 10             	add    $0x10,%esp
  8006fe:	83 ec 04             	sub    $0x4,%esp
  800701:	ff 75 20             	pushl  0x20(%ebp)
  800704:	53                   	push   %ebx
  800705:	ff 75 18             	pushl  0x18(%ebp)
  800708:	52                   	push   %edx
  800709:	50                   	push   %eax
  80070a:	ff 75 0c             	pushl  0xc(%ebp)
  80070d:	ff 75 08             	pushl  0x8(%ebp)
  800710:	e8 a1 ff ff ff       	call   8006b6 <printnum>
  800715:	83 c4 20             	add    $0x20,%esp
  800718:	eb 1a                	jmp    800734 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80071a:	83 ec 08             	sub    $0x8,%esp
  80071d:	ff 75 0c             	pushl  0xc(%ebp)
  800720:	ff 75 20             	pushl  0x20(%ebp)
  800723:	8b 45 08             	mov    0x8(%ebp),%eax
  800726:	ff d0                	call   *%eax
  800728:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80072b:	ff 4d 1c             	decl   0x1c(%ebp)
  80072e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800732:	7f e6                	jg     80071a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800734:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800737:	bb 00 00 00 00       	mov    $0x0,%ebx
  80073c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80073f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800742:	53                   	push   %ebx
  800743:	51                   	push   %ecx
  800744:	52                   	push   %edx
  800745:	50                   	push   %eax
  800746:	e8 21 38 00 00       	call   803f6c <__umoddi3>
  80074b:	83 c4 10             	add    $0x10,%esp
  80074e:	05 f4 46 80 00       	add    $0x8046f4,%eax
  800753:	8a 00                	mov    (%eax),%al
  800755:	0f be c0             	movsbl %al,%eax
  800758:	83 ec 08             	sub    $0x8,%esp
  80075b:	ff 75 0c             	pushl  0xc(%ebp)
  80075e:	50                   	push   %eax
  80075f:	8b 45 08             	mov    0x8(%ebp),%eax
  800762:	ff d0                	call   *%eax
  800764:	83 c4 10             	add    $0x10,%esp
}
  800767:	90                   	nop
  800768:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80076b:	c9                   	leave  
  80076c:	c3                   	ret    

0080076d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80076d:	55                   	push   %ebp
  80076e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800770:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800774:	7e 1c                	jle    800792 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800776:	8b 45 08             	mov    0x8(%ebp),%eax
  800779:	8b 00                	mov    (%eax),%eax
  80077b:	8d 50 08             	lea    0x8(%eax),%edx
  80077e:	8b 45 08             	mov    0x8(%ebp),%eax
  800781:	89 10                	mov    %edx,(%eax)
  800783:	8b 45 08             	mov    0x8(%ebp),%eax
  800786:	8b 00                	mov    (%eax),%eax
  800788:	83 e8 08             	sub    $0x8,%eax
  80078b:	8b 50 04             	mov    0x4(%eax),%edx
  80078e:	8b 00                	mov    (%eax),%eax
  800790:	eb 40                	jmp    8007d2 <getuint+0x65>
	else if (lflag)
  800792:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800796:	74 1e                	je     8007b6 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800798:	8b 45 08             	mov    0x8(%ebp),%eax
  80079b:	8b 00                	mov    (%eax),%eax
  80079d:	8d 50 04             	lea    0x4(%eax),%edx
  8007a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a3:	89 10                	mov    %edx,(%eax)
  8007a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a8:	8b 00                	mov    (%eax),%eax
  8007aa:	83 e8 04             	sub    $0x4,%eax
  8007ad:	8b 00                	mov    (%eax),%eax
  8007af:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b4:	eb 1c                	jmp    8007d2 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	8b 00                	mov    (%eax),%eax
  8007bb:	8d 50 04             	lea    0x4(%eax),%edx
  8007be:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c1:	89 10                	mov    %edx,(%eax)
  8007c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c6:	8b 00                	mov    (%eax),%eax
  8007c8:	83 e8 04             	sub    $0x4,%eax
  8007cb:	8b 00                	mov    (%eax),%eax
  8007cd:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007d2:	5d                   	pop    %ebp
  8007d3:	c3                   	ret    

008007d4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007d4:	55                   	push   %ebp
  8007d5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007d7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007db:	7e 1c                	jle    8007f9 <getint+0x25>
		return va_arg(*ap, long long);
  8007dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e0:	8b 00                	mov    (%eax),%eax
  8007e2:	8d 50 08             	lea    0x8(%eax),%edx
  8007e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e8:	89 10                	mov    %edx,(%eax)
  8007ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ed:	8b 00                	mov    (%eax),%eax
  8007ef:	83 e8 08             	sub    $0x8,%eax
  8007f2:	8b 50 04             	mov    0x4(%eax),%edx
  8007f5:	8b 00                	mov    (%eax),%eax
  8007f7:	eb 38                	jmp    800831 <getint+0x5d>
	else if (lflag)
  8007f9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007fd:	74 1a                	je     800819 <getint+0x45>
		return va_arg(*ap, long);
  8007ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800802:	8b 00                	mov    (%eax),%eax
  800804:	8d 50 04             	lea    0x4(%eax),%edx
  800807:	8b 45 08             	mov    0x8(%ebp),%eax
  80080a:	89 10                	mov    %edx,(%eax)
  80080c:	8b 45 08             	mov    0x8(%ebp),%eax
  80080f:	8b 00                	mov    (%eax),%eax
  800811:	83 e8 04             	sub    $0x4,%eax
  800814:	8b 00                	mov    (%eax),%eax
  800816:	99                   	cltd   
  800817:	eb 18                	jmp    800831 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800819:	8b 45 08             	mov    0x8(%ebp),%eax
  80081c:	8b 00                	mov    (%eax),%eax
  80081e:	8d 50 04             	lea    0x4(%eax),%edx
  800821:	8b 45 08             	mov    0x8(%ebp),%eax
  800824:	89 10                	mov    %edx,(%eax)
  800826:	8b 45 08             	mov    0x8(%ebp),%eax
  800829:	8b 00                	mov    (%eax),%eax
  80082b:	83 e8 04             	sub    $0x4,%eax
  80082e:	8b 00                	mov    (%eax),%eax
  800830:	99                   	cltd   
}
  800831:	5d                   	pop    %ebp
  800832:	c3                   	ret    

00800833 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800833:	55                   	push   %ebp
  800834:	89 e5                	mov    %esp,%ebp
  800836:	56                   	push   %esi
  800837:	53                   	push   %ebx
  800838:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80083b:	eb 17                	jmp    800854 <vprintfmt+0x21>
			if (ch == '\0')
  80083d:	85 db                	test   %ebx,%ebx
  80083f:	0f 84 c1 03 00 00    	je     800c06 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800845:	83 ec 08             	sub    $0x8,%esp
  800848:	ff 75 0c             	pushl  0xc(%ebp)
  80084b:	53                   	push   %ebx
  80084c:	8b 45 08             	mov    0x8(%ebp),%eax
  80084f:	ff d0                	call   *%eax
  800851:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800854:	8b 45 10             	mov    0x10(%ebp),%eax
  800857:	8d 50 01             	lea    0x1(%eax),%edx
  80085a:	89 55 10             	mov    %edx,0x10(%ebp)
  80085d:	8a 00                	mov    (%eax),%al
  80085f:	0f b6 d8             	movzbl %al,%ebx
  800862:	83 fb 25             	cmp    $0x25,%ebx
  800865:	75 d6                	jne    80083d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800867:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80086b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800872:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800879:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800880:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800887:	8b 45 10             	mov    0x10(%ebp),%eax
  80088a:	8d 50 01             	lea    0x1(%eax),%edx
  80088d:	89 55 10             	mov    %edx,0x10(%ebp)
  800890:	8a 00                	mov    (%eax),%al
  800892:	0f b6 d8             	movzbl %al,%ebx
  800895:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800898:	83 f8 5b             	cmp    $0x5b,%eax
  80089b:	0f 87 3d 03 00 00    	ja     800bde <vprintfmt+0x3ab>
  8008a1:	8b 04 85 18 47 80 00 	mov    0x804718(,%eax,4),%eax
  8008a8:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008aa:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008ae:	eb d7                	jmp    800887 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008b0:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8008b4:	eb d1                	jmp    800887 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008b6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008bd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008c0:	89 d0                	mov    %edx,%eax
  8008c2:	c1 e0 02             	shl    $0x2,%eax
  8008c5:	01 d0                	add    %edx,%eax
  8008c7:	01 c0                	add    %eax,%eax
  8008c9:	01 d8                	add    %ebx,%eax
  8008cb:	83 e8 30             	sub    $0x30,%eax
  8008ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d4:	8a 00                	mov    (%eax),%al
  8008d6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008d9:	83 fb 2f             	cmp    $0x2f,%ebx
  8008dc:	7e 3e                	jle    80091c <vprintfmt+0xe9>
  8008de:	83 fb 39             	cmp    $0x39,%ebx
  8008e1:	7f 39                	jg     80091c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008e3:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008e6:	eb d5                	jmp    8008bd <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008eb:	83 c0 04             	add    $0x4,%eax
  8008ee:	89 45 14             	mov    %eax,0x14(%ebp)
  8008f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f4:	83 e8 04             	sub    $0x4,%eax
  8008f7:	8b 00                	mov    (%eax),%eax
  8008f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008fc:	eb 1f                	jmp    80091d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008fe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800902:	79 83                	jns    800887 <vprintfmt+0x54>
				width = 0;
  800904:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80090b:	e9 77 ff ff ff       	jmp    800887 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800910:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800917:	e9 6b ff ff ff       	jmp    800887 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80091c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80091d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800921:	0f 89 60 ff ff ff    	jns    800887 <vprintfmt+0x54>
				width = precision, precision = -1;
  800927:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80092a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80092d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800934:	e9 4e ff ff ff       	jmp    800887 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800939:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80093c:	e9 46 ff ff ff       	jmp    800887 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800941:	8b 45 14             	mov    0x14(%ebp),%eax
  800944:	83 c0 04             	add    $0x4,%eax
  800947:	89 45 14             	mov    %eax,0x14(%ebp)
  80094a:	8b 45 14             	mov    0x14(%ebp),%eax
  80094d:	83 e8 04             	sub    $0x4,%eax
  800950:	8b 00                	mov    (%eax),%eax
  800952:	83 ec 08             	sub    $0x8,%esp
  800955:	ff 75 0c             	pushl  0xc(%ebp)
  800958:	50                   	push   %eax
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	ff d0                	call   *%eax
  80095e:	83 c4 10             	add    $0x10,%esp
			break;
  800961:	e9 9b 02 00 00       	jmp    800c01 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800966:	8b 45 14             	mov    0x14(%ebp),%eax
  800969:	83 c0 04             	add    $0x4,%eax
  80096c:	89 45 14             	mov    %eax,0x14(%ebp)
  80096f:	8b 45 14             	mov    0x14(%ebp),%eax
  800972:	83 e8 04             	sub    $0x4,%eax
  800975:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800977:	85 db                	test   %ebx,%ebx
  800979:	79 02                	jns    80097d <vprintfmt+0x14a>
				err = -err;
  80097b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80097d:	83 fb 64             	cmp    $0x64,%ebx
  800980:	7f 0b                	jg     80098d <vprintfmt+0x15a>
  800982:	8b 34 9d 60 45 80 00 	mov    0x804560(,%ebx,4),%esi
  800989:	85 f6                	test   %esi,%esi
  80098b:	75 19                	jne    8009a6 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80098d:	53                   	push   %ebx
  80098e:	68 05 47 80 00       	push   $0x804705
  800993:	ff 75 0c             	pushl  0xc(%ebp)
  800996:	ff 75 08             	pushl  0x8(%ebp)
  800999:	e8 70 02 00 00       	call   800c0e <printfmt>
  80099e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009a1:	e9 5b 02 00 00       	jmp    800c01 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009a6:	56                   	push   %esi
  8009a7:	68 0e 47 80 00       	push   $0x80470e
  8009ac:	ff 75 0c             	pushl  0xc(%ebp)
  8009af:	ff 75 08             	pushl  0x8(%ebp)
  8009b2:	e8 57 02 00 00       	call   800c0e <printfmt>
  8009b7:	83 c4 10             	add    $0x10,%esp
			break;
  8009ba:	e9 42 02 00 00       	jmp    800c01 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c2:	83 c0 04             	add    $0x4,%eax
  8009c5:	89 45 14             	mov    %eax,0x14(%ebp)
  8009c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cb:	83 e8 04             	sub    $0x4,%eax
  8009ce:	8b 30                	mov    (%eax),%esi
  8009d0:	85 f6                	test   %esi,%esi
  8009d2:	75 05                	jne    8009d9 <vprintfmt+0x1a6>
				p = "(null)";
  8009d4:	be 11 47 80 00       	mov    $0x804711,%esi
			if (width > 0 && padc != '-')
  8009d9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009dd:	7e 6d                	jle    800a4c <vprintfmt+0x219>
  8009df:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009e3:	74 67                	je     800a4c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009e8:	83 ec 08             	sub    $0x8,%esp
  8009eb:	50                   	push   %eax
  8009ec:	56                   	push   %esi
  8009ed:	e8 1e 03 00 00       	call   800d10 <strnlen>
  8009f2:	83 c4 10             	add    $0x10,%esp
  8009f5:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009f8:	eb 16                	jmp    800a10 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009fa:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009fe:	83 ec 08             	sub    $0x8,%esp
  800a01:	ff 75 0c             	pushl  0xc(%ebp)
  800a04:	50                   	push   %eax
  800a05:	8b 45 08             	mov    0x8(%ebp),%eax
  800a08:	ff d0                	call   *%eax
  800a0a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a0d:	ff 4d e4             	decl   -0x1c(%ebp)
  800a10:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a14:	7f e4                	jg     8009fa <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a16:	eb 34                	jmp    800a4c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a18:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a1c:	74 1c                	je     800a3a <vprintfmt+0x207>
  800a1e:	83 fb 1f             	cmp    $0x1f,%ebx
  800a21:	7e 05                	jle    800a28 <vprintfmt+0x1f5>
  800a23:	83 fb 7e             	cmp    $0x7e,%ebx
  800a26:	7e 12                	jle    800a3a <vprintfmt+0x207>
					putch('?', putdat);
  800a28:	83 ec 08             	sub    $0x8,%esp
  800a2b:	ff 75 0c             	pushl  0xc(%ebp)
  800a2e:	6a 3f                	push   $0x3f
  800a30:	8b 45 08             	mov    0x8(%ebp),%eax
  800a33:	ff d0                	call   *%eax
  800a35:	83 c4 10             	add    $0x10,%esp
  800a38:	eb 0f                	jmp    800a49 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a3a:	83 ec 08             	sub    $0x8,%esp
  800a3d:	ff 75 0c             	pushl  0xc(%ebp)
  800a40:	53                   	push   %ebx
  800a41:	8b 45 08             	mov    0x8(%ebp),%eax
  800a44:	ff d0                	call   *%eax
  800a46:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a49:	ff 4d e4             	decl   -0x1c(%ebp)
  800a4c:	89 f0                	mov    %esi,%eax
  800a4e:	8d 70 01             	lea    0x1(%eax),%esi
  800a51:	8a 00                	mov    (%eax),%al
  800a53:	0f be d8             	movsbl %al,%ebx
  800a56:	85 db                	test   %ebx,%ebx
  800a58:	74 24                	je     800a7e <vprintfmt+0x24b>
  800a5a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a5e:	78 b8                	js     800a18 <vprintfmt+0x1e5>
  800a60:	ff 4d e0             	decl   -0x20(%ebp)
  800a63:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a67:	79 af                	jns    800a18 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a69:	eb 13                	jmp    800a7e <vprintfmt+0x24b>
				putch(' ', putdat);
  800a6b:	83 ec 08             	sub    $0x8,%esp
  800a6e:	ff 75 0c             	pushl  0xc(%ebp)
  800a71:	6a 20                	push   $0x20
  800a73:	8b 45 08             	mov    0x8(%ebp),%eax
  800a76:	ff d0                	call   *%eax
  800a78:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a7b:	ff 4d e4             	decl   -0x1c(%ebp)
  800a7e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a82:	7f e7                	jg     800a6b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a84:	e9 78 01 00 00       	jmp    800c01 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a89:	83 ec 08             	sub    $0x8,%esp
  800a8c:	ff 75 e8             	pushl  -0x18(%ebp)
  800a8f:	8d 45 14             	lea    0x14(%ebp),%eax
  800a92:	50                   	push   %eax
  800a93:	e8 3c fd ff ff       	call   8007d4 <getint>
  800a98:	83 c4 10             	add    $0x10,%esp
  800a9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a9e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800aa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aa4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800aa7:	85 d2                	test   %edx,%edx
  800aa9:	79 23                	jns    800ace <vprintfmt+0x29b>
				putch('-', putdat);
  800aab:	83 ec 08             	sub    $0x8,%esp
  800aae:	ff 75 0c             	pushl  0xc(%ebp)
  800ab1:	6a 2d                	push   $0x2d
  800ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab6:	ff d0                	call   *%eax
  800ab8:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800abb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800abe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ac1:	f7 d8                	neg    %eax
  800ac3:	83 d2 00             	adc    $0x0,%edx
  800ac6:	f7 da                	neg    %edx
  800ac8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800acb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ace:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ad5:	e9 bc 00 00 00       	jmp    800b96 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ada:	83 ec 08             	sub    $0x8,%esp
  800add:	ff 75 e8             	pushl  -0x18(%ebp)
  800ae0:	8d 45 14             	lea    0x14(%ebp),%eax
  800ae3:	50                   	push   %eax
  800ae4:	e8 84 fc ff ff       	call   80076d <getuint>
  800ae9:	83 c4 10             	add    $0x10,%esp
  800aec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aef:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800af2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800af9:	e9 98 00 00 00       	jmp    800b96 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800afe:	83 ec 08             	sub    $0x8,%esp
  800b01:	ff 75 0c             	pushl  0xc(%ebp)
  800b04:	6a 58                	push   $0x58
  800b06:	8b 45 08             	mov    0x8(%ebp),%eax
  800b09:	ff d0                	call   *%eax
  800b0b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b0e:	83 ec 08             	sub    $0x8,%esp
  800b11:	ff 75 0c             	pushl  0xc(%ebp)
  800b14:	6a 58                	push   $0x58
  800b16:	8b 45 08             	mov    0x8(%ebp),%eax
  800b19:	ff d0                	call   *%eax
  800b1b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b1e:	83 ec 08             	sub    $0x8,%esp
  800b21:	ff 75 0c             	pushl  0xc(%ebp)
  800b24:	6a 58                	push   $0x58
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	ff d0                	call   *%eax
  800b2b:	83 c4 10             	add    $0x10,%esp
			break;
  800b2e:	e9 ce 00 00 00       	jmp    800c01 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800b33:	83 ec 08             	sub    $0x8,%esp
  800b36:	ff 75 0c             	pushl  0xc(%ebp)
  800b39:	6a 30                	push   $0x30
  800b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3e:	ff d0                	call   *%eax
  800b40:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b43:	83 ec 08             	sub    $0x8,%esp
  800b46:	ff 75 0c             	pushl  0xc(%ebp)
  800b49:	6a 78                	push   $0x78
  800b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4e:	ff d0                	call   *%eax
  800b50:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b53:	8b 45 14             	mov    0x14(%ebp),%eax
  800b56:	83 c0 04             	add    $0x4,%eax
  800b59:	89 45 14             	mov    %eax,0x14(%ebp)
  800b5c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b5f:	83 e8 04             	sub    $0x4,%eax
  800b62:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b67:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b6e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b75:	eb 1f                	jmp    800b96 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b77:	83 ec 08             	sub    $0x8,%esp
  800b7a:	ff 75 e8             	pushl  -0x18(%ebp)
  800b7d:	8d 45 14             	lea    0x14(%ebp),%eax
  800b80:	50                   	push   %eax
  800b81:	e8 e7 fb ff ff       	call   80076d <getuint>
  800b86:	83 c4 10             	add    $0x10,%esp
  800b89:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b8c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b8f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b96:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b9d:	83 ec 04             	sub    $0x4,%esp
  800ba0:	52                   	push   %edx
  800ba1:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ba4:	50                   	push   %eax
  800ba5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba8:	ff 75 f0             	pushl  -0x10(%ebp)
  800bab:	ff 75 0c             	pushl  0xc(%ebp)
  800bae:	ff 75 08             	pushl  0x8(%ebp)
  800bb1:	e8 00 fb ff ff       	call   8006b6 <printnum>
  800bb6:	83 c4 20             	add    $0x20,%esp
			break;
  800bb9:	eb 46                	jmp    800c01 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bbb:	83 ec 08             	sub    $0x8,%esp
  800bbe:	ff 75 0c             	pushl  0xc(%ebp)
  800bc1:	53                   	push   %ebx
  800bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc5:	ff d0                	call   *%eax
  800bc7:	83 c4 10             	add    $0x10,%esp
			break;
  800bca:	eb 35                	jmp    800c01 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800bcc:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
			break;
  800bd3:	eb 2c                	jmp    800c01 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800bd5:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
			break;
  800bdc:	eb 23                	jmp    800c01 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bde:	83 ec 08             	sub    $0x8,%esp
  800be1:	ff 75 0c             	pushl  0xc(%ebp)
  800be4:	6a 25                	push   $0x25
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
  800be9:	ff d0                	call   *%eax
  800beb:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bee:	ff 4d 10             	decl   0x10(%ebp)
  800bf1:	eb 03                	jmp    800bf6 <vprintfmt+0x3c3>
  800bf3:	ff 4d 10             	decl   0x10(%ebp)
  800bf6:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf9:	48                   	dec    %eax
  800bfa:	8a 00                	mov    (%eax),%al
  800bfc:	3c 25                	cmp    $0x25,%al
  800bfe:	75 f3                	jne    800bf3 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800c00:	90                   	nop
		}
	}
  800c01:	e9 35 fc ff ff       	jmp    80083b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c06:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c07:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c0a:	5b                   	pop    %ebx
  800c0b:	5e                   	pop    %esi
  800c0c:	5d                   	pop    %ebp
  800c0d:	c3                   	ret    

00800c0e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
  800c11:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c14:	8d 45 10             	lea    0x10(%ebp),%eax
  800c17:	83 c0 04             	add    $0x4,%eax
  800c1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c1d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c20:	ff 75 f4             	pushl  -0xc(%ebp)
  800c23:	50                   	push   %eax
  800c24:	ff 75 0c             	pushl  0xc(%ebp)
  800c27:	ff 75 08             	pushl  0x8(%ebp)
  800c2a:	e8 04 fc ff ff       	call   800833 <vprintfmt>
  800c2f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c32:	90                   	nop
  800c33:	c9                   	leave  
  800c34:	c3                   	ret    

00800c35 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c35:	55                   	push   %ebp
  800c36:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3b:	8b 40 08             	mov    0x8(%eax),%eax
  800c3e:	8d 50 01             	lea    0x1(%eax),%edx
  800c41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c44:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4a:	8b 10                	mov    (%eax),%edx
  800c4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4f:	8b 40 04             	mov    0x4(%eax),%eax
  800c52:	39 c2                	cmp    %eax,%edx
  800c54:	73 12                	jae    800c68 <sprintputch+0x33>
		*b->buf++ = ch;
  800c56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c59:	8b 00                	mov    (%eax),%eax
  800c5b:	8d 48 01             	lea    0x1(%eax),%ecx
  800c5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c61:	89 0a                	mov    %ecx,(%edx)
  800c63:	8b 55 08             	mov    0x8(%ebp),%edx
  800c66:	88 10                	mov    %dl,(%eax)
}
  800c68:	90                   	nop
  800c69:	5d                   	pop    %ebp
  800c6a:	c3                   	ret    

00800c6b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c6b:	55                   	push   %ebp
  800c6c:	89 e5                	mov    %esp,%ebp
  800c6e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c80:	01 d0                	add    %edx,%eax
  800c82:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c85:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c8c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c90:	74 06                	je     800c98 <vsnprintf+0x2d>
  800c92:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c96:	7f 07                	jg     800c9f <vsnprintf+0x34>
		return -E_INVAL;
  800c98:	b8 03 00 00 00       	mov    $0x3,%eax
  800c9d:	eb 20                	jmp    800cbf <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c9f:	ff 75 14             	pushl  0x14(%ebp)
  800ca2:	ff 75 10             	pushl  0x10(%ebp)
  800ca5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ca8:	50                   	push   %eax
  800ca9:	68 35 0c 80 00       	push   $0x800c35
  800cae:	e8 80 fb ff ff       	call   800833 <vprintfmt>
  800cb3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800cb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cb9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800cbf:	c9                   	leave  
  800cc0:	c3                   	ret    

00800cc1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cc1:	55                   	push   %ebp
  800cc2:	89 e5                	mov    %esp,%ebp
  800cc4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cc7:	8d 45 10             	lea    0x10(%ebp),%eax
  800cca:	83 c0 04             	add    $0x4,%eax
  800ccd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800cd0:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd3:	ff 75 f4             	pushl  -0xc(%ebp)
  800cd6:	50                   	push   %eax
  800cd7:	ff 75 0c             	pushl  0xc(%ebp)
  800cda:	ff 75 08             	pushl  0x8(%ebp)
  800cdd:	e8 89 ff ff ff       	call   800c6b <vsnprintf>
  800ce2:	83 c4 10             	add    $0x10,%esp
  800ce5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ce8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ceb:	c9                   	leave  
  800cec:	c3                   	ret    

00800ced <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ced:	55                   	push   %ebp
  800cee:	89 e5                	mov    %esp,%ebp
  800cf0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800cf3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cfa:	eb 06                	jmp    800d02 <strlen+0x15>
		n++;
  800cfc:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cff:	ff 45 08             	incl   0x8(%ebp)
  800d02:	8b 45 08             	mov    0x8(%ebp),%eax
  800d05:	8a 00                	mov    (%eax),%al
  800d07:	84 c0                	test   %al,%al
  800d09:	75 f1                	jne    800cfc <strlen+0xf>
		n++;
	return n;
  800d0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d0e:	c9                   	leave  
  800d0f:	c3                   	ret    

00800d10 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d10:	55                   	push   %ebp
  800d11:	89 e5                	mov    %esp,%ebp
  800d13:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d16:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d1d:	eb 09                	jmp    800d28 <strnlen+0x18>
		n++;
  800d1f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d22:	ff 45 08             	incl   0x8(%ebp)
  800d25:	ff 4d 0c             	decl   0xc(%ebp)
  800d28:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d2c:	74 09                	je     800d37 <strnlen+0x27>
  800d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d31:	8a 00                	mov    (%eax),%al
  800d33:	84 c0                	test   %al,%al
  800d35:	75 e8                	jne    800d1f <strnlen+0xf>
		n++;
	return n;
  800d37:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d3a:	c9                   	leave  
  800d3b:	c3                   	ret    

00800d3c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d3c:	55                   	push   %ebp
  800d3d:	89 e5                	mov    %esp,%ebp
  800d3f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
  800d45:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d48:	90                   	nop
  800d49:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4c:	8d 50 01             	lea    0x1(%eax),%edx
  800d4f:	89 55 08             	mov    %edx,0x8(%ebp)
  800d52:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d55:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d58:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d5b:	8a 12                	mov    (%edx),%dl
  800d5d:	88 10                	mov    %dl,(%eax)
  800d5f:	8a 00                	mov    (%eax),%al
  800d61:	84 c0                	test   %al,%al
  800d63:	75 e4                	jne    800d49 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d65:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d68:	c9                   	leave  
  800d69:	c3                   	ret    

00800d6a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d6a:	55                   	push   %ebp
  800d6b:	89 e5                	mov    %esp,%ebp
  800d6d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d70:	8b 45 08             	mov    0x8(%ebp),%eax
  800d73:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d76:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d7d:	eb 1f                	jmp    800d9e <strncpy+0x34>
		*dst++ = *src;
  800d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d82:	8d 50 01             	lea    0x1(%eax),%edx
  800d85:	89 55 08             	mov    %edx,0x8(%ebp)
  800d88:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d8b:	8a 12                	mov    (%edx),%dl
  800d8d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d92:	8a 00                	mov    (%eax),%al
  800d94:	84 c0                	test   %al,%al
  800d96:	74 03                	je     800d9b <strncpy+0x31>
			src++;
  800d98:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d9b:	ff 45 fc             	incl   -0x4(%ebp)
  800d9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800da1:	3b 45 10             	cmp    0x10(%ebp),%eax
  800da4:	72 d9                	jb     800d7f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800da6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800da9:	c9                   	leave  
  800daa:	c3                   	ret    

00800dab <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800dab:	55                   	push   %ebp
  800dac:	89 e5                	mov    %esp,%ebp
  800dae:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
  800db4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800db7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dbb:	74 30                	je     800ded <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800dbd:	eb 16                	jmp    800dd5 <strlcpy+0x2a>
			*dst++ = *src++;
  800dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc2:	8d 50 01             	lea    0x1(%eax),%edx
  800dc5:	89 55 08             	mov    %edx,0x8(%ebp)
  800dc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dcb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dce:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800dd1:	8a 12                	mov    (%edx),%dl
  800dd3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800dd5:	ff 4d 10             	decl   0x10(%ebp)
  800dd8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ddc:	74 09                	je     800de7 <strlcpy+0x3c>
  800dde:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de1:	8a 00                	mov    (%eax),%al
  800de3:	84 c0                	test   %al,%al
  800de5:	75 d8                	jne    800dbf <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ded:	8b 55 08             	mov    0x8(%ebp),%edx
  800df0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df3:	29 c2                	sub    %eax,%edx
  800df5:	89 d0                	mov    %edx,%eax
}
  800df7:	c9                   	leave  
  800df8:	c3                   	ret    

00800df9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800df9:	55                   	push   %ebp
  800dfa:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800dfc:	eb 06                	jmp    800e04 <strcmp+0xb>
		p++, q++;
  800dfe:	ff 45 08             	incl   0x8(%ebp)
  800e01:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	8a 00                	mov    (%eax),%al
  800e09:	84 c0                	test   %al,%al
  800e0b:	74 0e                	je     800e1b <strcmp+0x22>
  800e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e10:	8a 10                	mov    (%eax),%dl
  800e12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e15:	8a 00                	mov    (%eax),%al
  800e17:	38 c2                	cmp    %al,%dl
  800e19:	74 e3                	je     800dfe <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	8a 00                	mov    (%eax),%al
  800e20:	0f b6 d0             	movzbl %al,%edx
  800e23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e26:	8a 00                	mov    (%eax),%al
  800e28:	0f b6 c0             	movzbl %al,%eax
  800e2b:	29 c2                	sub    %eax,%edx
  800e2d:	89 d0                	mov    %edx,%eax
}
  800e2f:	5d                   	pop    %ebp
  800e30:	c3                   	ret    

00800e31 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e31:	55                   	push   %ebp
  800e32:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e34:	eb 09                	jmp    800e3f <strncmp+0xe>
		n--, p++, q++;
  800e36:	ff 4d 10             	decl   0x10(%ebp)
  800e39:	ff 45 08             	incl   0x8(%ebp)
  800e3c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e3f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e43:	74 17                	je     800e5c <strncmp+0x2b>
  800e45:	8b 45 08             	mov    0x8(%ebp),%eax
  800e48:	8a 00                	mov    (%eax),%al
  800e4a:	84 c0                	test   %al,%al
  800e4c:	74 0e                	je     800e5c <strncmp+0x2b>
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e51:	8a 10                	mov    (%eax),%dl
  800e53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e56:	8a 00                	mov    (%eax),%al
  800e58:	38 c2                	cmp    %al,%dl
  800e5a:	74 da                	je     800e36 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e5c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e60:	75 07                	jne    800e69 <strncmp+0x38>
		return 0;
  800e62:	b8 00 00 00 00       	mov    $0x0,%eax
  800e67:	eb 14                	jmp    800e7d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	8a 00                	mov    (%eax),%al
  800e6e:	0f b6 d0             	movzbl %al,%edx
  800e71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e74:	8a 00                	mov    (%eax),%al
  800e76:	0f b6 c0             	movzbl %al,%eax
  800e79:	29 c2                	sub    %eax,%edx
  800e7b:	89 d0                	mov    %edx,%eax
}
  800e7d:	5d                   	pop    %ebp
  800e7e:	c3                   	ret    

00800e7f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e7f:	55                   	push   %ebp
  800e80:	89 e5                	mov    %esp,%ebp
  800e82:	83 ec 04             	sub    $0x4,%esp
  800e85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e88:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e8b:	eb 12                	jmp    800e9f <strchr+0x20>
		if (*s == c)
  800e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e90:	8a 00                	mov    (%eax),%al
  800e92:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e95:	75 05                	jne    800e9c <strchr+0x1d>
			return (char *) s;
  800e97:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9a:	eb 11                	jmp    800ead <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e9c:	ff 45 08             	incl   0x8(%ebp)
  800e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea2:	8a 00                	mov    (%eax),%al
  800ea4:	84 c0                	test   %al,%al
  800ea6:	75 e5                	jne    800e8d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ea8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ead:	c9                   	leave  
  800eae:	c3                   	ret    

00800eaf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800eaf:	55                   	push   %ebp
  800eb0:	89 e5                	mov    %esp,%ebp
  800eb2:	83 ec 04             	sub    $0x4,%esp
  800eb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ebb:	eb 0d                	jmp    800eca <strfind+0x1b>
		if (*s == c)
  800ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec0:	8a 00                	mov    (%eax),%al
  800ec2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ec5:	74 0e                	je     800ed5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ec7:	ff 45 08             	incl   0x8(%ebp)
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	8a 00                	mov    (%eax),%al
  800ecf:	84 c0                	test   %al,%al
  800ed1:	75 ea                	jne    800ebd <strfind+0xe>
  800ed3:	eb 01                	jmp    800ed6 <strfind+0x27>
		if (*s == c)
			break;
  800ed5:	90                   	nop
	return (char *) s;
  800ed6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ed9:	c9                   	leave  
  800eda:	c3                   	ret    

00800edb <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800edb:	55                   	push   %ebp
  800edc:	89 e5                	mov    %esp,%ebp
  800ede:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800ee7:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800eeb:	76 63                	jbe    800f50 <memset+0x75>
		uint64 data_block = c;
  800eed:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef0:	99                   	cltd   
  800ef1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ef4:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800ef7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800efa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800efd:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800f01:	c1 e0 08             	shl    $0x8,%eax
  800f04:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f07:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800f0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f10:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800f14:	c1 e0 10             	shl    $0x10,%eax
  800f17:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f1a:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800f1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f23:	89 c2                	mov    %eax,%edx
  800f25:	b8 00 00 00 00       	mov    $0x0,%eax
  800f2a:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f2d:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800f30:	eb 18                	jmp    800f4a <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800f32:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f35:	8d 41 08             	lea    0x8(%ecx),%eax
  800f38:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800f3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f41:	89 01                	mov    %eax,(%ecx)
  800f43:	89 51 04             	mov    %edx,0x4(%ecx)
  800f46:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800f4a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f4e:	77 e2                	ja     800f32 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800f50:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f54:	74 23                	je     800f79 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800f56:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f59:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f5c:	eb 0e                	jmp    800f6c <memset+0x91>
			*p8++ = (uint8)c;
  800f5e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f61:	8d 50 01             	lea    0x1(%eax),%edx
  800f64:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f67:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f6a:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800f6c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f72:	89 55 10             	mov    %edx,0x10(%ebp)
  800f75:	85 c0                	test   %eax,%eax
  800f77:	75 e5                	jne    800f5e <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f7c:	c9                   	leave  
  800f7d:	c3                   	ret    

00800f7e <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f7e:	55                   	push   %ebp
  800f7f:	89 e5                	mov    %esp,%ebp
  800f81:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f87:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f90:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f94:	76 24                	jbe    800fba <memcpy+0x3c>
		while(n >= 8){
  800f96:	eb 1c                	jmp    800fb4 <memcpy+0x36>
			*d64 = *s64;
  800f98:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f9b:	8b 50 04             	mov    0x4(%eax),%edx
  800f9e:	8b 00                	mov    (%eax),%eax
  800fa0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800fa3:	89 01                	mov    %eax,(%ecx)
  800fa5:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800fa8:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800fac:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800fb0:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800fb4:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800fb8:	77 de                	ja     800f98 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800fba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fbe:	74 31                	je     800ff1 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800fc0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800fc6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800fcc:	eb 16                	jmp    800fe4 <memcpy+0x66>
			*d8++ = *s8++;
  800fce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fd1:	8d 50 01             	lea    0x1(%eax),%edx
  800fd4:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800fd7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fda:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fdd:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800fe0:	8a 12                	mov    (%edx),%dl
  800fe2:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800fe4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fea:	89 55 10             	mov    %edx,0x10(%ebp)
  800fed:	85 c0                	test   %eax,%eax
  800fef:	75 dd                	jne    800fce <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ff4:	c9                   	leave  
  800ff5:	c3                   	ret    

00800ff6 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ff6:	55                   	push   %ebp
  800ff7:	89 e5                	mov    %esp,%ebp
  800ff9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801008:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80100b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80100e:	73 50                	jae    801060 <memmove+0x6a>
  801010:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801013:	8b 45 10             	mov    0x10(%ebp),%eax
  801016:	01 d0                	add    %edx,%eax
  801018:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80101b:	76 43                	jbe    801060 <memmove+0x6a>
		s += n;
  80101d:	8b 45 10             	mov    0x10(%ebp),%eax
  801020:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801023:	8b 45 10             	mov    0x10(%ebp),%eax
  801026:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801029:	eb 10                	jmp    80103b <memmove+0x45>
			*--d = *--s;
  80102b:	ff 4d f8             	decl   -0x8(%ebp)
  80102e:	ff 4d fc             	decl   -0x4(%ebp)
  801031:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801034:	8a 10                	mov    (%eax),%dl
  801036:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801039:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80103b:	8b 45 10             	mov    0x10(%ebp),%eax
  80103e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801041:	89 55 10             	mov    %edx,0x10(%ebp)
  801044:	85 c0                	test   %eax,%eax
  801046:	75 e3                	jne    80102b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801048:	eb 23                	jmp    80106d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80104a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80104d:	8d 50 01             	lea    0x1(%eax),%edx
  801050:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801053:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801056:	8d 4a 01             	lea    0x1(%edx),%ecx
  801059:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80105c:	8a 12                	mov    (%edx),%dl
  80105e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801060:	8b 45 10             	mov    0x10(%ebp),%eax
  801063:	8d 50 ff             	lea    -0x1(%eax),%edx
  801066:	89 55 10             	mov    %edx,0x10(%ebp)
  801069:	85 c0                	test   %eax,%eax
  80106b:	75 dd                	jne    80104a <memmove+0x54>
			*d++ = *s++;

	return dst;
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801070:	c9                   	leave  
  801071:	c3                   	ret    

00801072 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801072:	55                   	push   %ebp
  801073:	89 e5                	mov    %esp,%ebp
  801075:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801078:	8b 45 08             	mov    0x8(%ebp),%eax
  80107b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80107e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801081:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801084:	eb 2a                	jmp    8010b0 <memcmp+0x3e>
		if (*s1 != *s2)
  801086:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801089:	8a 10                	mov    (%eax),%dl
  80108b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80108e:	8a 00                	mov    (%eax),%al
  801090:	38 c2                	cmp    %al,%dl
  801092:	74 16                	je     8010aa <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801094:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801097:	8a 00                	mov    (%eax),%al
  801099:	0f b6 d0             	movzbl %al,%edx
  80109c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80109f:	8a 00                	mov    (%eax),%al
  8010a1:	0f b6 c0             	movzbl %al,%eax
  8010a4:	29 c2                	sub    %eax,%edx
  8010a6:	89 d0                	mov    %edx,%eax
  8010a8:	eb 18                	jmp    8010c2 <memcmp+0x50>
		s1++, s2++;
  8010aa:	ff 45 fc             	incl   -0x4(%ebp)
  8010ad:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010b6:	89 55 10             	mov    %edx,0x10(%ebp)
  8010b9:	85 c0                	test   %eax,%eax
  8010bb:	75 c9                	jne    801086 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010c2:	c9                   	leave  
  8010c3:	c3                   	ret    

008010c4 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8010c4:	55                   	push   %ebp
  8010c5:	89 e5                	mov    %esp,%ebp
  8010c7:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8010ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8010cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d0:	01 d0                	add    %edx,%eax
  8010d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8010d5:	eb 15                	jmp    8010ec <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	8a 00                	mov    (%eax),%al
  8010dc:	0f b6 d0             	movzbl %al,%edx
  8010df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e2:	0f b6 c0             	movzbl %al,%eax
  8010e5:	39 c2                	cmp    %eax,%edx
  8010e7:	74 0d                	je     8010f6 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8010e9:	ff 45 08             	incl   0x8(%ebp)
  8010ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ef:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8010f2:	72 e3                	jb     8010d7 <memfind+0x13>
  8010f4:	eb 01                	jmp    8010f7 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8010f6:	90                   	nop
	return (void *) s;
  8010f7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010fa:	c9                   	leave  
  8010fb:	c3                   	ret    

008010fc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010fc:	55                   	push   %ebp
  8010fd:	89 e5                	mov    %esp,%ebp
  8010ff:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801102:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801109:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801110:	eb 03                	jmp    801115 <strtol+0x19>
		s++;
  801112:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801115:	8b 45 08             	mov    0x8(%ebp),%eax
  801118:	8a 00                	mov    (%eax),%al
  80111a:	3c 20                	cmp    $0x20,%al
  80111c:	74 f4                	je     801112 <strtol+0x16>
  80111e:	8b 45 08             	mov    0x8(%ebp),%eax
  801121:	8a 00                	mov    (%eax),%al
  801123:	3c 09                	cmp    $0x9,%al
  801125:	74 eb                	je     801112 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801127:	8b 45 08             	mov    0x8(%ebp),%eax
  80112a:	8a 00                	mov    (%eax),%al
  80112c:	3c 2b                	cmp    $0x2b,%al
  80112e:	75 05                	jne    801135 <strtol+0x39>
		s++;
  801130:	ff 45 08             	incl   0x8(%ebp)
  801133:	eb 13                	jmp    801148 <strtol+0x4c>
	else if (*s == '-')
  801135:	8b 45 08             	mov    0x8(%ebp),%eax
  801138:	8a 00                	mov    (%eax),%al
  80113a:	3c 2d                	cmp    $0x2d,%al
  80113c:	75 0a                	jne    801148 <strtol+0x4c>
		s++, neg = 1;
  80113e:	ff 45 08             	incl   0x8(%ebp)
  801141:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801148:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80114c:	74 06                	je     801154 <strtol+0x58>
  80114e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801152:	75 20                	jne    801174 <strtol+0x78>
  801154:	8b 45 08             	mov    0x8(%ebp),%eax
  801157:	8a 00                	mov    (%eax),%al
  801159:	3c 30                	cmp    $0x30,%al
  80115b:	75 17                	jne    801174 <strtol+0x78>
  80115d:	8b 45 08             	mov    0x8(%ebp),%eax
  801160:	40                   	inc    %eax
  801161:	8a 00                	mov    (%eax),%al
  801163:	3c 78                	cmp    $0x78,%al
  801165:	75 0d                	jne    801174 <strtol+0x78>
		s += 2, base = 16;
  801167:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80116b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801172:	eb 28                	jmp    80119c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801174:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801178:	75 15                	jne    80118f <strtol+0x93>
  80117a:	8b 45 08             	mov    0x8(%ebp),%eax
  80117d:	8a 00                	mov    (%eax),%al
  80117f:	3c 30                	cmp    $0x30,%al
  801181:	75 0c                	jne    80118f <strtol+0x93>
		s++, base = 8;
  801183:	ff 45 08             	incl   0x8(%ebp)
  801186:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80118d:	eb 0d                	jmp    80119c <strtol+0xa0>
	else if (base == 0)
  80118f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801193:	75 07                	jne    80119c <strtol+0xa0>
		base = 10;
  801195:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80119c:	8b 45 08             	mov    0x8(%ebp),%eax
  80119f:	8a 00                	mov    (%eax),%al
  8011a1:	3c 2f                	cmp    $0x2f,%al
  8011a3:	7e 19                	jle    8011be <strtol+0xc2>
  8011a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a8:	8a 00                	mov    (%eax),%al
  8011aa:	3c 39                	cmp    $0x39,%al
  8011ac:	7f 10                	jg     8011be <strtol+0xc2>
			dig = *s - '0';
  8011ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b1:	8a 00                	mov    (%eax),%al
  8011b3:	0f be c0             	movsbl %al,%eax
  8011b6:	83 e8 30             	sub    $0x30,%eax
  8011b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011bc:	eb 42                	jmp    801200 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011be:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c1:	8a 00                	mov    (%eax),%al
  8011c3:	3c 60                	cmp    $0x60,%al
  8011c5:	7e 19                	jle    8011e0 <strtol+0xe4>
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ca:	8a 00                	mov    (%eax),%al
  8011cc:	3c 7a                	cmp    $0x7a,%al
  8011ce:	7f 10                	jg     8011e0 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8011d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d3:	8a 00                	mov    (%eax),%al
  8011d5:	0f be c0             	movsbl %al,%eax
  8011d8:	83 e8 57             	sub    $0x57,%eax
  8011db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011de:	eb 20                	jmp    801200 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8011e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e3:	8a 00                	mov    (%eax),%al
  8011e5:	3c 40                	cmp    $0x40,%al
  8011e7:	7e 39                	jle    801222 <strtol+0x126>
  8011e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ec:	8a 00                	mov    (%eax),%al
  8011ee:	3c 5a                	cmp    $0x5a,%al
  8011f0:	7f 30                	jg     801222 <strtol+0x126>
			dig = *s - 'A' + 10;
  8011f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f5:	8a 00                	mov    (%eax),%al
  8011f7:	0f be c0             	movsbl %al,%eax
  8011fa:	83 e8 37             	sub    $0x37,%eax
  8011fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801200:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801203:	3b 45 10             	cmp    0x10(%ebp),%eax
  801206:	7d 19                	jge    801221 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801208:	ff 45 08             	incl   0x8(%ebp)
  80120b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80120e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801212:	89 c2                	mov    %eax,%edx
  801214:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801217:	01 d0                	add    %edx,%eax
  801219:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80121c:	e9 7b ff ff ff       	jmp    80119c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801221:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801222:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801226:	74 08                	je     801230 <strtol+0x134>
		*endptr = (char *) s;
  801228:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122b:	8b 55 08             	mov    0x8(%ebp),%edx
  80122e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801230:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801234:	74 07                	je     80123d <strtol+0x141>
  801236:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801239:	f7 d8                	neg    %eax
  80123b:	eb 03                	jmp    801240 <strtol+0x144>
  80123d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801240:	c9                   	leave  
  801241:	c3                   	ret    

00801242 <ltostr>:

void
ltostr(long value, char *str)
{
  801242:	55                   	push   %ebp
  801243:	89 e5                	mov    %esp,%ebp
  801245:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801248:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80124f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801256:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80125a:	79 13                	jns    80126f <ltostr+0x2d>
	{
		neg = 1;
  80125c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801263:	8b 45 0c             	mov    0xc(%ebp),%eax
  801266:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801269:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80126c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80126f:	8b 45 08             	mov    0x8(%ebp),%eax
  801272:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801277:	99                   	cltd   
  801278:	f7 f9                	idiv   %ecx
  80127a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80127d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801280:	8d 50 01             	lea    0x1(%eax),%edx
  801283:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801286:	89 c2                	mov    %eax,%edx
  801288:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128b:	01 d0                	add    %edx,%eax
  80128d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801290:	83 c2 30             	add    $0x30,%edx
  801293:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801295:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801298:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80129d:	f7 e9                	imul   %ecx
  80129f:	c1 fa 02             	sar    $0x2,%edx
  8012a2:	89 c8                	mov    %ecx,%eax
  8012a4:	c1 f8 1f             	sar    $0x1f,%eax
  8012a7:	29 c2                	sub    %eax,%edx
  8012a9:	89 d0                	mov    %edx,%eax
  8012ab:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8012ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012b2:	75 bb                	jne    80126f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8012b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8012bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012be:	48                   	dec    %eax
  8012bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8012c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012c6:	74 3d                	je     801305 <ltostr+0xc3>
		start = 1 ;
  8012c8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8012cf:	eb 34                	jmp    801305 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8012d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d7:	01 d0                	add    %edx,%eax
  8012d9:	8a 00                	mov    (%eax),%al
  8012db:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8012de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e4:	01 c2                	add    %eax,%edx
  8012e6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8012e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ec:	01 c8                	add    %ecx,%eax
  8012ee:	8a 00                	mov    (%eax),%al
  8012f0:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f8:	01 c2                	add    %eax,%edx
  8012fa:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012fd:	88 02                	mov    %al,(%edx)
		start++ ;
  8012ff:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801302:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801305:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801308:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80130b:	7c c4                	jl     8012d1 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80130d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801310:	8b 45 0c             	mov    0xc(%ebp),%eax
  801313:	01 d0                	add    %edx,%eax
  801315:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801318:	90                   	nop
  801319:	c9                   	leave  
  80131a:	c3                   	ret    

0080131b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80131b:	55                   	push   %ebp
  80131c:	89 e5                	mov    %esp,%ebp
  80131e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801321:	ff 75 08             	pushl  0x8(%ebp)
  801324:	e8 c4 f9 ff ff       	call   800ced <strlen>
  801329:	83 c4 04             	add    $0x4,%esp
  80132c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80132f:	ff 75 0c             	pushl  0xc(%ebp)
  801332:	e8 b6 f9 ff ff       	call   800ced <strlen>
  801337:	83 c4 04             	add    $0x4,%esp
  80133a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80133d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801344:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80134b:	eb 17                	jmp    801364 <strcconcat+0x49>
		final[s] = str1[s] ;
  80134d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801350:	8b 45 10             	mov    0x10(%ebp),%eax
  801353:	01 c2                	add    %eax,%edx
  801355:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801358:	8b 45 08             	mov    0x8(%ebp),%eax
  80135b:	01 c8                	add    %ecx,%eax
  80135d:	8a 00                	mov    (%eax),%al
  80135f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801361:	ff 45 fc             	incl   -0x4(%ebp)
  801364:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801367:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80136a:	7c e1                	jl     80134d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80136c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801373:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80137a:	eb 1f                	jmp    80139b <strcconcat+0x80>
		final[s++] = str2[i] ;
  80137c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80137f:	8d 50 01             	lea    0x1(%eax),%edx
  801382:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801385:	89 c2                	mov    %eax,%edx
  801387:	8b 45 10             	mov    0x10(%ebp),%eax
  80138a:	01 c2                	add    %eax,%edx
  80138c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80138f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801392:	01 c8                	add    %ecx,%eax
  801394:	8a 00                	mov    (%eax),%al
  801396:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801398:	ff 45 f8             	incl   -0x8(%ebp)
  80139b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80139e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013a1:	7c d9                	jl     80137c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8013a3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a9:	01 d0                	add    %edx,%eax
  8013ab:	c6 00 00             	movb   $0x0,(%eax)
}
  8013ae:	90                   	nop
  8013af:	c9                   	leave  
  8013b0:	c3                   	ret    

008013b1 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8013b1:	55                   	push   %ebp
  8013b2:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8013b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8013b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8013bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c0:	8b 00                	mov    (%eax),%eax
  8013c2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013cc:	01 d0                	add    %edx,%eax
  8013ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013d4:	eb 0c                	jmp    8013e2 <strsplit+0x31>
			*string++ = 0;
  8013d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d9:	8d 50 01             	lea    0x1(%eax),%edx
  8013dc:	89 55 08             	mov    %edx,0x8(%ebp)
  8013df:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e5:	8a 00                	mov    (%eax),%al
  8013e7:	84 c0                	test   %al,%al
  8013e9:	74 18                	je     801403 <strsplit+0x52>
  8013eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ee:	8a 00                	mov    (%eax),%al
  8013f0:	0f be c0             	movsbl %al,%eax
  8013f3:	50                   	push   %eax
  8013f4:	ff 75 0c             	pushl  0xc(%ebp)
  8013f7:	e8 83 fa ff ff       	call   800e7f <strchr>
  8013fc:	83 c4 08             	add    $0x8,%esp
  8013ff:	85 c0                	test   %eax,%eax
  801401:	75 d3                	jne    8013d6 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801403:	8b 45 08             	mov    0x8(%ebp),%eax
  801406:	8a 00                	mov    (%eax),%al
  801408:	84 c0                	test   %al,%al
  80140a:	74 5a                	je     801466 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80140c:	8b 45 14             	mov    0x14(%ebp),%eax
  80140f:	8b 00                	mov    (%eax),%eax
  801411:	83 f8 0f             	cmp    $0xf,%eax
  801414:	75 07                	jne    80141d <strsplit+0x6c>
		{
			return 0;
  801416:	b8 00 00 00 00       	mov    $0x0,%eax
  80141b:	eb 66                	jmp    801483 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80141d:	8b 45 14             	mov    0x14(%ebp),%eax
  801420:	8b 00                	mov    (%eax),%eax
  801422:	8d 48 01             	lea    0x1(%eax),%ecx
  801425:	8b 55 14             	mov    0x14(%ebp),%edx
  801428:	89 0a                	mov    %ecx,(%edx)
  80142a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801431:	8b 45 10             	mov    0x10(%ebp),%eax
  801434:	01 c2                	add    %eax,%edx
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80143b:	eb 03                	jmp    801440 <strsplit+0x8f>
			string++;
  80143d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801440:	8b 45 08             	mov    0x8(%ebp),%eax
  801443:	8a 00                	mov    (%eax),%al
  801445:	84 c0                	test   %al,%al
  801447:	74 8b                	je     8013d4 <strsplit+0x23>
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	8a 00                	mov    (%eax),%al
  80144e:	0f be c0             	movsbl %al,%eax
  801451:	50                   	push   %eax
  801452:	ff 75 0c             	pushl  0xc(%ebp)
  801455:	e8 25 fa ff ff       	call   800e7f <strchr>
  80145a:	83 c4 08             	add    $0x8,%esp
  80145d:	85 c0                	test   %eax,%eax
  80145f:	74 dc                	je     80143d <strsplit+0x8c>
			string++;
	}
  801461:	e9 6e ff ff ff       	jmp    8013d4 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801466:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801467:	8b 45 14             	mov    0x14(%ebp),%eax
  80146a:	8b 00                	mov    (%eax),%eax
  80146c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801473:	8b 45 10             	mov    0x10(%ebp),%eax
  801476:	01 d0                	add    %edx,%eax
  801478:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80147e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801483:	c9                   	leave  
  801484:	c3                   	ret    

00801485 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801485:	55                   	push   %ebp
  801486:	89 e5                	mov    %esp,%ebp
  801488:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801491:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801498:	eb 4a                	jmp    8014e4 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80149a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80149d:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a0:	01 c2                	add    %eax,%edx
  8014a2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a8:	01 c8                	add    %ecx,%eax
  8014aa:	8a 00                	mov    (%eax),%al
  8014ac:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8014ae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b4:	01 d0                	add    %edx,%eax
  8014b6:	8a 00                	mov    (%eax),%al
  8014b8:	3c 40                	cmp    $0x40,%al
  8014ba:	7e 25                	jle    8014e1 <str2lower+0x5c>
  8014bc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c2:	01 d0                	add    %edx,%eax
  8014c4:	8a 00                	mov    (%eax),%al
  8014c6:	3c 5a                	cmp    $0x5a,%al
  8014c8:	7f 17                	jg     8014e1 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8014ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d0:	01 d0                	add    %edx,%eax
  8014d2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8014d8:	01 ca                	add    %ecx,%edx
  8014da:	8a 12                	mov    (%edx),%dl
  8014dc:	83 c2 20             	add    $0x20,%edx
  8014df:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8014e1:	ff 45 fc             	incl   -0x4(%ebp)
  8014e4:	ff 75 0c             	pushl  0xc(%ebp)
  8014e7:	e8 01 f8 ff ff       	call   800ced <strlen>
  8014ec:	83 c4 04             	add    $0x4,%esp
  8014ef:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8014f2:	7f a6                	jg     80149a <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8014f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014f7:	c9                   	leave  
  8014f8:	c3                   	ret    

008014f9 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8014f9:	55                   	push   %ebp
  8014fa:	89 e5                	mov    %esp,%ebp
  8014fc:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8014ff:	a1 08 50 80 00       	mov    0x805008,%eax
  801504:	85 c0                	test   %eax,%eax
  801506:	74 42                	je     80154a <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801508:	83 ec 08             	sub    $0x8,%esp
  80150b:	68 00 00 00 82       	push   $0x82000000
  801510:	68 00 00 00 80       	push   $0x80000000
  801515:	e8 b0 1e 00 00       	call   8033ca <initialize_dynamic_allocator>
  80151a:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  80151d:	e8 96 1c 00 00       	call   8031b8 <sys_get_uheap_strategy>
  801522:	a3 80 50 83 00       	mov    %eax,0x835080
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801527:	a1 60 d0 81 00       	mov    0x81d060,%eax
  80152c:	05 00 10 00 00       	add    $0x1000,%eax
  801531:	a3 30 51 83 00       	mov    %eax,0x835130
		uheapPageAllocBreak = uheapPageAllocStart;
  801536:	a1 30 51 83 00       	mov    0x835130,%eax
  80153b:	a3 88 50 83 00       	mov    %eax,0x835088

		__firstTimeFlag = 0;
  801540:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  801547:	00 00 00 
	}
}
  80154a:	90                   	nop
  80154b:	c9                   	leave  
  80154c:	c3                   	ret    

0080154d <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  80154d:	55                   	push   %ebp
  80154e:	89 e5                	mov    %esp,%ebp
  801550:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801553:	8b 45 08             	mov    0x8(%ebp),%eax
  801556:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80155c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801561:	83 ec 08             	sub    $0x8,%esp
  801564:	68 06 04 00 00       	push   $0x406
  801569:	50                   	push   %eax
  80156a:	e8 93 18 00 00       	call   802e02 <__sys_allocate_page>
  80156f:	83 c4 10             	add    $0x10,%esp
  801572:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801575:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801579:	79 14                	jns    80158f <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  80157b:	83 ec 04             	sub    $0x4,%esp
  80157e:	68 88 48 80 00       	push   $0x804888
  801583:	6a 1f                	push   $0x1f
  801585:	68 c4 48 80 00       	push   $0x8048c4
  80158a:	e8 b7 ed ff ff       	call   800346 <_panic>
	return 0;
  80158f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801594:	c9                   	leave  
  801595:	c3                   	ret    

00801596 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801596:	55                   	push   %ebp
  801597:	89 e5                	mov    %esp,%ebp
  801599:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  80159c:	8b 45 08             	mov    0x8(%ebp),%eax
  80159f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8015a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015aa:	83 ec 0c             	sub    $0xc,%esp
  8015ad:	50                   	push   %eax
  8015ae:	e8 96 18 00 00       	call   802e49 <__sys_unmap_frame>
  8015b3:	83 c4 10             	add    $0x10,%esp
  8015b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8015b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015bd:	79 14                	jns    8015d3 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8015bf:	83 ec 04             	sub    $0x4,%esp
  8015c2:	68 d0 48 80 00       	push   $0x8048d0
  8015c7:	6a 2a                	push   $0x2a
  8015c9:	68 c4 48 80 00       	push   $0x8048c4
  8015ce:	e8 73 ed ff ff       	call   800346 <_panic>
}
  8015d3:	90                   	nop
  8015d4:	c9                   	leave  
  8015d5:	c3                   	ret    

008015d6 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8015d6:	55                   	push   %ebp
  8015d7:	89 e5                	mov    %esp,%ebp
  8015d9:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8015dc:	e8 18 ff ff ff       	call   8014f9 <uheap_init>
	if (size == 0) return NULL ;
  8015e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015e5:	75 0a                	jne    8015f1 <malloc+0x1b>
  8015e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ec:	e9 43 03 00 00       	jmp    801934 <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  8015f1:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8015f8:	77 13                	ja     80160d <malloc+0x37>
    {
        return alloc_block(size);
  8015fa:	83 ec 0c             	sub    $0xc,%esp
  8015fd:	ff 75 08             	pushl  0x8(%ebp)
  801600:	e8 78 20 00 00       	call   80367d <alloc_block>
  801605:	83 c4 10             	add    $0x10,%esp
  801608:	e9 27 03 00 00       	jmp    801934 <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  80160d:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801614:	8b 55 08             	mov    0x8(%ebp),%edx
  801617:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80161a:	01 d0                	add    %edx,%eax
  80161c:	48                   	dec    %eax
  80161d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801620:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801623:	ba 00 00 00 00       	mov    $0x0,%edx
  801628:	f7 75 dc             	divl   -0x24(%ebp)
  80162b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80162e:	29 d0                	sub    %edx,%eax
  801630:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  801633:	a1 40 d0 81 00       	mov    0x81d040,%eax
  801638:	85 c0                	test   %eax,%eax
  80163a:	75 0a                	jne    801646 <malloc+0x70>
    {
        uhp_inited = 1;
  80163c:	c7 05 40 d0 81 00 01 	movl   $0x1,0x81d040
  801643:	00 00 00 
    }

    int exactIdx = -1;
  801646:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  80164d:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801654:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80165b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801662:	e9 85 00 00 00       	jmp    8016ec <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801667:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80166a:	89 d0                	mov    %edx,%eax
  80166c:	01 c0                	add    %eax,%eax
  80166e:	01 d0                	add    %edx,%eax
  801670:	c1 e0 02             	shl    $0x2,%eax
  801673:	05 48 10 81 00       	add    $0x811048,%eax
  801678:	8a 00                	mov    (%eax),%al
  80167a:	84 c0                	test   %al,%al
  80167c:	74 20                	je     80169e <malloc+0xc8>
  80167e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801681:	89 d0                	mov    %edx,%eax
  801683:	01 c0                	add    %eax,%eax
  801685:	01 d0                	add    %edx,%eax
  801687:	c1 e0 02             	shl    $0x2,%eax
  80168a:	05 44 10 81 00       	add    $0x811044,%eax
  80168f:	8b 00                	mov    (%eax),%eax
  801691:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801694:	75 08                	jne    80169e <malloc+0xc8>
        {
            exactIdx = i;
  801696:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801699:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  80169c:	eb 5b                	jmp    8016f9 <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  80169e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8016a1:	89 d0                	mov    %edx,%eax
  8016a3:	01 c0                	add    %eax,%eax
  8016a5:	01 d0                	add    %edx,%eax
  8016a7:	c1 e0 02             	shl    $0x2,%eax
  8016aa:	05 48 10 81 00       	add    $0x811048,%eax
  8016af:	8a 00                	mov    (%eax),%al
  8016b1:	84 c0                	test   %al,%al
  8016b3:	74 34                	je     8016e9 <malloc+0x113>
  8016b5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8016b8:	89 d0                	mov    %edx,%eax
  8016ba:	01 c0                	add    %eax,%eax
  8016bc:	01 d0                	add    %edx,%eax
  8016be:	c1 e0 02             	shl    $0x2,%eax
  8016c1:	05 44 10 81 00       	add    $0x811044,%eax
  8016c6:	8b 00                	mov    (%eax),%eax
  8016c8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8016cb:	76 1c                	jbe    8016e9 <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  8016cd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8016d0:	89 d0                	mov    %edx,%eax
  8016d2:	01 c0                	add    %eax,%eax
  8016d4:	01 d0                	add    %edx,%eax
  8016d6:	c1 e0 02             	shl    $0x2,%eax
  8016d9:	05 44 10 81 00       	add    $0x811044,%eax
  8016de:	8b 00                	mov    (%eax),%eax
  8016e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  8016e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8016e9:	ff 45 e8             	incl   -0x18(%ebp)
  8016ec:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8016f3:	0f 8e 6e ff ff ff    	jle    801667 <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  8016f9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801700:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801704:	74 7d                	je     801783 <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801706:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  80170d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801710:	89 d0                	mov    %edx,%eax
  801712:	01 c0                	add    %eax,%eax
  801714:	01 d0                	add    %edx,%eax
  801716:	c1 e0 02             	shl    $0x2,%eax
  801719:	05 40 10 81 00       	add    $0x811040,%eax
  80171e:	8b 10                	mov    (%eax),%edx
  801720:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801723:	01 d0                	add    %edx,%eax
  801725:	48                   	dec    %eax
  801726:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801729:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80172c:	ba 00 00 00 00       	mov    $0x0,%edx
  801731:	f7 75 bc             	divl   -0x44(%ebp)
  801734:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801737:	29 d0                	sub    %edx,%eax
  801739:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  80173c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80173f:	89 d0                	mov    %edx,%eax
  801741:	01 c0                	add    %eax,%eax
  801743:	01 d0                	add    %edx,%eax
  801745:	c1 e0 02             	shl    $0x2,%eax
  801748:	05 48 10 81 00       	add    $0x811048,%eax
  80174d:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801750:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801753:	89 d0                	mov    %edx,%eax
  801755:	01 c0                	add    %eax,%eax
  801757:	01 d0                	add    %edx,%eax
  801759:	c1 e0 02             	shl    $0x2,%eax
  80175c:	05 44 10 81 00       	add    $0x811044,%eax
  801761:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801767:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80176a:	89 d0                	mov    %edx,%eax
  80176c:	01 c0                	add    %eax,%eax
  80176e:	01 d0                	add    %edx,%eax
  801770:	c1 e0 02             	shl    $0x2,%eax
  801773:	05 40 10 81 00       	add    $0x811040,%eax
  801778:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80177e:	e9 2d 01 00 00       	jmp    8018b0 <malloc+0x2da>
    }
    else if (worstIdx != -1)
  801783:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801787:	0f 84 ce 00 00 00    	je     80185b <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  80178d:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  801794:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801797:	89 d0                	mov    %edx,%eax
  801799:	01 c0                	add    %eax,%eax
  80179b:	01 d0                	add    %edx,%eax
  80179d:	c1 e0 02             	shl    $0x2,%eax
  8017a0:	05 40 10 81 00       	add    $0x811040,%eax
  8017a5:	8b 10                	mov    (%eax),%edx
  8017a7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8017aa:	01 d0                	add    %edx,%eax
  8017ac:	48                   	dec    %eax
  8017ad:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8017b0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8017b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b8:	f7 75 c4             	divl   -0x3c(%ebp)
  8017bb:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8017be:	29 d0                	sub    %edx,%eax
  8017c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  8017c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017c6:	89 d0                	mov    %edx,%eax
  8017c8:	01 c0                	add    %eax,%eax
  8017ca:	01 d0                	add    %edx,%eax
  8017cc:	c1 e0 02             	shl    $0x2,%eax
  8017cf:	05 44 10 81 00       	add    $0x811044,%eax
  8017d4:	8b 00                	mov    (%eax),%eax
  8017d6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8017d9:	75 47                	jne    801822 <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  8017db:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017de:	89 d0                	mov    %edx,%eax
  8017e0:	01 c0                	add    %eax,%eax
  8017e2:	01 d0                	add    %edx,%eax
  8017e4:	c1 e0 02             	shl    $0x2,%eax
  8017e7:	05 48 10 81 00       	add    $0x811048,%eax
  8017ec:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  8017ef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017f2:	89 d0                	mov    %edx,%eax
  8017f4:	01 c0                	add    %eax,%eax
  8017f6:	01 d0                	add    %edx,%eax
  8017f8:	c1 e0 02             	shl    $0x2,%eax
  8017fb:	05 44 10 81 00       	add    $0x811044,%eax
  801800:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  801806:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801809:	89 d0                	mov    %edx,%eax
  80180b:	01 c0                	add    %eax,%eax
  80180d:	01 d0                	add    %edx,%eax
  80180f:	c1 e0 02             	shl    $0x2,%eax
  801812:	05 40 10 81 00       	add    $0x811040,%eax
  801817:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80181d:	e9 8e 00 00 00       	jmp    8018b0 <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  801822:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801825:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801828:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80182b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80182e:	89 d0                	mov    %edx,%eax
  801830:	01 c0                	add    %eax,%eax
  801832:	01 d0                	add    %edx,%eax
  801834:	c1 e0 02             	shl    $0x2,%eax
  801837:	05 40 10 81 00       	add    $0x811040,%eax
  80183c:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  80183e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801841:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801844:	89 c2                	mov    %eax,%edx
  801846:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801849:	89 c8                	mov    %ecx,%eax
  80184b:	01 c0                	add    %eax,%eax
  80184d:	01 c8                	add    %ecx,%eax
  80184f:	c1 e0 02             	shl    $0x2,%eax
  801852:	05 44 10 81 00       	add    $0x811044,%eax
  801857:	89 10                	mov    %edx,(%eax)
  801859:	eb 55                	jmp    8018b0 <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  80185b:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801862:	8b 15 88 50 83 00    	mov    0x835088,%edx
  801868:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80186b:	01 d0                	add    %edx,%eax
  80186d:	48                   	dec    %eax
  80186e:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801871:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801874:	ba 00 00 00 00       	mov    $0x0,%edx
  801879:	f7 75 d0             	divl   -0x30(%ebp)
  80187c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80187f:	29 d0                	sub    %edx,%eax
  801881:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  801884:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801887:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80188a:	01 d0                	add    %edx,%eax
  80188c:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801891:	76 0a                	jbe    80189d <malloc+0x2c7>
            return NULL;
  801893:	b8 00 00 00 00       	mov    $0x0,%eax
  801898:	e9 97 00 00 00       	jmp    801934 <malloc+0x35e>
        va = start;
  80189d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8018a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  8018a3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8018a6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8018a9:	01 d0                	add    %edx,%eax
  8018ab:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8018b0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8018b7:	eb 5e                	jmp    801917 <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  8018b9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018bc:	89 d0                	mov    %edx,%eax
  8018be:	01 c0                	add    %eax,%eax
  8018c0:	01 d0                	add    %edx,%eax
  8018c2:	c1 e0 02             	shl    $0x2,%eax
  8018c5:	05 48 50 80 00       	add    $0x805048,%eax
  8018ca:	8a 00                	mov    (%eax),%al
  8018cc:	84 c0                	test   %al,%al
  8018ce:	75 44                	jne    801914 <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  8018d0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018d3:	89 d0                	mov    %edx,%eax
  8018d5:	01 c0                	add    %eax,%eax
  8018d7:	01 d0                	add    %edx,%eax
  8018d9:	c1 e0 02             	shl    $0x2,%eax
  8018dc:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  8018e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018e5:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  8018e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018ea:	89 d0                	mov    %edx,%eax
  8018ec:	01 c0                	add    %eax,%eax
  8018ee:	01 d0                	add    %edx,%eax
  8018f0:	c1 e0 02             	shl    $0x2,%eax
  8018f3:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8018f9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8018fc:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  8018fe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801901:	89 d0                	mov    %edx,%eax
  801903:	01 c0                	add    %eax,%eax
  801905:	01 d0                	add    %edx,%eax
  801907:	c1 e0 02             	shl    $0x2,%eax
  80190a:	05 48 50 80 00       	add    $0x805048,%eax
  80190f:	c6 00 01             	movb   $0x1,(%eax)
            break;
  801912:	eb 0c                	jmp    801920 <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801914:	ff 45 e0             	incl   -0x20(%ebp)
  801917:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80191e:	7e 99                	jle    8018b9 <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  801920:	83 ec 08             	sub    $0x8,%esp
  801923:	ff 75 d4             	pushl  -0x2c(%ebp)
  801926:	ff 75 e4             	pushl  -0x1c(%ebp)
  801929:	e8 a2 19 00 00       	call   8032d0 <sys_allocate_user_mem>
  80192e:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  801931:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801934:	c9                   	leave  
  801935:	c3                   	ret    

00801936 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
  801939:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  80193c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801940:	0f 84 fa 03 00 00    	je     801d40 <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  801946:	8b 45 08             	mov    0x8(%ebp),%eax
  801949:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  80194c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80194f:	85 c0                	test   %eax,%eax
  801951:	79 1c                	jns    80196f <free+0x39>
  801953:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  80195a:	77 13                	ja     80196f <free+0x39>
    {
        free_block(virtual_address);
  80195c:	83 ec 0c             	sub    $0xc,%esp
  80195f:	ff 75 08             	pushl  0x8(%ebp)
  801962:	e8 09 21 00 00       	call   803a70 <free_block>
  801967:	83 c4 10             	add    $0x10,%esp
        return;
  80196a:	e9 d2 03 00 00       	jmp    801d41 <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  80196f:	a1 30 51 83 00       	mov    0x835130,%eax
  801974:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  801977:	72 09                	jb     801982 <free+0x4c>
  801979:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  801980:	76 17                	jbe    801999 <free+0x63>
        panic("free: invalid address");
  801982:	83 ec 04             	sub    $0x4,%esp
  801985:	68 0d 49 80 00       	push   $0x80490d
  80198a:	68 9b 00 00 00       	push   $0x9b
  80198f:	68 c4 48 80 00       	push   $0x8048c4
  801994:	e8 ad e9 ff ff       	call   800346 <_panic>

    uint32 size = 0;
  801999:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  8019a0:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8019a7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8019ae:	eb 50                	jmp    801a00 <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  8019b0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019b3:	89 d0                	mov    %edx,%eax
  8019b5:	01 c0                	add    %eax,%eax
  8019b7:	01 d0                	add    %edx,%eax
  8019b9:	c1 e0 02             	shl    $0x2,%eax
  8019bc:	05 48 50 80 00       	add    $0x805048,%eax
  8019c1:	8a 00                	mov    (%eax),%al
  8019c3:	84 c0                	test   %al,%al
  8019c5:	74 36                	je     8019fd <free+0xc7>
  8019c7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019ca:	89 d0                	mov    %edx,%eax
  8019cc:	01 c0                	add    %eax,%eax
  8019ce:	01 d0                	add    %edx,%eax
  8019d0:	c1 e0 02             	shl    $0x2,%eax
  8019d3:	05 40 50 80 00       	add    $0x805040,%eax
  8019d8:	8b 00                	mov    (%eax),%eax
  8019da:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8019dd:	75 1e                	jne    8019fd <free+0xc7>
        {
            size = uhp_allocs[i].size;
  8019df:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019e2:	89 d0                	mov    %edx,%eax
  8019e4:	01 c0                	add    %eax,%eax
  8019e6:	01 d0                	add    %edx,%eax
  8019e8:	c1 e0 02             	shl    $0x2,%eax
  8019eb:	05 44 50 80 00       	add    $0x805044,%eax
  8019f0:	8b 00                	mov    (%eax),%eax
  8019f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  8019f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  8019fb:	eb 0c                	jmp    801a09 <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8019fd:	ff 45 ec             	incl   -0x14(%ebp)
  801a00:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  801a07:	7e a7                	jle    8019b0 <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  801a09:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801a0d:	74 06                	je     801a15 <free+0xdf>
  801a0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a13:	75 17                	jne    801a2c <free+0xf6>
        panic("free: unknown block");
  801a15:	83 ec 04             	sub    $0x4,%esp
  801a18:	68 23 49 80 00       	push   $0x804923
  801a1d:	68 a9 00 00 00       	push   $0xa9
  801a22:	68 c4 48 80 00       	push   $0x8048c4
  801a27:	e8 1a e9 ff ff       	call   800346 <_panic>

    uhp_allocs[idx].used = 0;
  801a2c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a2f:	89 d0                	mov    %edx,%eax
  801a31:	01 c0                	add    %eax,%eax
  801a33:	01 d0                	add    %edx,%eax
  801a35:	c1 e0 02             	shl    $0x2,%eax
  801a38:	05 48 50 80 00       	add    $0x805048,%eax
  801a3d:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  801a40:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801a47:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801a4e:	eb 64                	jmp    801ab4 <free+0x17e>
    {
        if (!uhp_frees[i].free)
  801a50:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a53:	89 d0                	mov    %edx,%eax
  801a55:	01 c0                	add    %eax,%eax
  801a57:	01 d0                	add    %edx,%eax
  801a59:	c1 e0 02             	shl    $0x2,%eax
  801a5c:	05 48 10 81 00       	add    $0x811048,%eax
  801a61:	8a 00                	mov    (%eax),%al
  801a63:	84 c0                	test   %al,%al
  801a65:	75 4a                	jne    801ab1 <free+0x17b>
        {
            uhp_frees[i].va = va;
  801a67:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a6a:	89 d0                	mov    %edx,%eax
  801a6c:	01 c0                	add    %eax,%eax
  801a6e:	01 d0                	add    %edx,%eax
  801a70:	c1 e0 02             	shl    $0x2,%eax
  801a73:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  801a79:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a7c:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  801a7e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a81:	89 d0                	mov    %edx,%eax
  801a83:	01 c0                	add    %eax,%eax
  801a85:	01 d0                	add    %edx,%eax
  801a87:	c1 e0 02             	shl    $0x2,%eax
  801a8a:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  801a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a93:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  801a95:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a98:	89 d0                	mov    %edx,%eax
  801a9a:	01 c0                	add    %eax,%eax
  801a9c:	01 d0                	add    %edx,%eax
  801a9e:	c1 e0 02             	shl    $0x2,%eax
  801aa1:	05 48 10 81 00       	add    $0x811048,%eax
  801aa6:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  801aa9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801aac:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  801aaf:	eb 0c                	jmp    801abd <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801ab1:	ff 45 e4             	incl   -0x1c(%ebp)
  801ab4:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  801abb:	7e 93                	jle    801a50 <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  801abd:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  801ac1:	0f 84 f1 01 00 00    	je     801cb8 <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801ac7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801ace:	e9 d8 01 00 00       	jmp    801cab <free+0x375>
        {
            if (i == fidx) continue;
  801ad3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ad6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801ad9:	0f 84 c8 01 00 00    	je     801ca7 <free+0x371>
            if (uhp_frees[i].free)
  801adf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ae2:	89 d0                	mov    %edx,%eax
  801ae4:	01 c0                	add    %eax,%eax
  801ae6:	01 d0                	add    %edx,%eax
  801ae8:	c1 e0 02             	shl    $0x2,%eax
  801aeb:	05 48 10 81 00       	add    $0x811048,%eax
  801af0:	8a 00                	mov    (%eax),%al
  801af2:	84 c0                	test   %al,%al
  801af4:	0f 84 ae 01 00 00    	je     801ca8 <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  801afa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801afd:	89 d0                	mov    %edx,%eax
  801aff:	01 c0                	add    %eax,%eax
  801b01:	01 d0                	add    %edx,%eax
  801b03:	c1 e0 02             	shl    $0x2,%eax
  801b06:	05 40 10 81 00       	add    $0x811040,%eax
  801b0b:	8b 08                	mov    (%eax),%ecx
  801b0d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b10:	89 d0                	mov    %edx,%eax
  801b12:	01 c0                	add    %eax,%eax
  801b14:	01 d0                	add    %edx,%eax
  801b16:	c1 e0 02             	shl    $0x2,%eax
  801b19:	05 44 10 81 00       	add    $0x811044,%eax
  801b1e:	8b 00                	mov    (%eax),%eax
  801b20:	01 c1                	add    %eax,%ecx
  801b22:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b25:	89 d0                	mov    %edx,%eax
  801b27:	01 c0                	add    %eax,%eax
  801b29:	01 d0                	add    %edx,%eax
  801b2b:	c1 e0 02             	shl    $0x2,%eax
  801b2e:	05 40 10 81 00       	add    $0x811040,%eax
  801b33:	8b 00                	mov    (%eax),%eax
  801b35:	39 c1                	cmp    %eax,%ecx
  801b37:	0f 85 a8 00 00 00    	jne    801be5 <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  801b3d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b40:	89 d0                	mov    %edx,%eax
  801b42:	01 c0                	add    %eax,%eax
  801b44:	01 d0                	add    %edx,%eax
  801b46:	c1 e0 02             	shl    $0x2,%eax
  801b49:	05 40 10 81 00       	add    $0x811040,%eax
  801b4e:	8b 10                	mov    (%eax),%edx
  801b50:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  801b53:	89 c8                	mov    %ecx,%eax
  801b55:	01 c0                	add    %eax,%eax
  801b57:	01 c8                	add    %ecx,%eax
  801b59:	c1 e0 02             	shl    $0x2,%eax
  801b5c:	05 40 10 81 00       	add    $0x811040,%eax
  801b61:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801b63:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b66:	89 d0                	mov    %edx,%eax
  801b68:	01 c0                	add    %eax,%eax
  801b6a:	01 d0                	add    %edx,%eax
  801b6c:	c1 e0 02             	shl    $0x2,%eax
  801b6f:	05 44 10 81 00       	add    $0x811044,%eax
  801b74:	8b 08                	mov    (%eax),%ecx
  801b76:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b79:	89 d0                	mov    %edx,%eax
  801b7b:	01 c0                	add    %eax,%eax
  801b7d:	01 d0                	add    %edx,%eax
  801b7f:	c1 e0 02             	shl    $0x2,%eax
  801b82:	05 44 10 81 00       	add    $0x811044,%eax
  801b87:	8b 00                	mov    (%eax),%eax
  801b89:	01 c1                	add    %eax,%ecx
  801b8b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b8e:	89 d0                	mov    %edx,%eax
  801b90:	01 c0                	add    %eax,%eax
  801b92:	01 d0                	add    %edx,%eax
  801b94:	c1 e0 02             	shl    $0x2,%eax
  801b97:	05 44 10 81 00       	add    $0x811044,%eax
  801b9c:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801b9e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ba1:	89 d0                	mov    %edx,%eax
  801ba3:	01 c0                	add    %eax,%eax
  801ba5:	01 d0                	add    %edx,%eax
  801ba7:	c1 e0 02             	shl    $0x2,%eax
  801baa:	05 48 10 81 00       	add    $0x811048,%eax
  801baf:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801bb2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bb5:	89 d0                	mov    %edx,%eax
  801bb7:	01 c0                	add    %eax,%eax
  801bb9:	01 d0                	add    %edx,%eax
  801bbb:	c1 e0 02             	shl    $0x2,%eax
  801bbe:	05 40 10 81 00       	add    $0x811040,%eax
  801bc3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801bc9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bcc:	89 d0                	mov    %edx,%eax
  801bce:	01 c0                	add    %eax,%eax
  801bd0:	01 d0                	add    %edx,%eax
  801bd2:	c1 e0 02             	shl    $0x2,%eax
  801bd5:	05 44 10 81 00       	add    $0x811044,%eax
  801bda:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801be0:	e9 c3 00 00 00       	jmp    801ca8 <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  801be5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801be8:	89 d0                	mov    %edx,%eax
  801bea:	01 c0                	add    %eax,%eax
  801bec:	01 d0                	add    %edx,%eax
  801bee:	c1 e0 02             	shl    $0x2,%eax
  801bf1:	05 40 10 81 00       	add    $0x811040,%eax
  801bf6:	8b 08                	mov    (%eax),%ecx
  801bf8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801bfb:	89 d0                	mov    %edx,%eax
  801bfd:	01 c0                	add    %eax,%eax
  801bff:	01 d0                	add    %edx,%eax
  801c01:	c1 e0 02             	shl    $0x2,%eax
  801c04:	05 44 10 81 00       	add    $0x811044,%eax
  801c09:	8b 00                	mov    (%eax),%eax
  801c0b:	01 c1                	add    %eax,%ecx
  801c0d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c10:	89 d0                	mov    %edx,%eax
  801c12:	01 c0                	add    %eax,%eax
  801c14:	01 d0                	add    %edx,%eax
  801c16:	c1 e0 02             	shl    $0x2,%eax
  801c19:	05 40 10 81 00       	add    $0x811040,%eax
  801c1e:	8b 00                	mov    (%eax),%eax
  801c20:	39 c1                	cmp    %eax,%ecx
  801c22:	0f 85 80 00 00 00    	jne    801ca8 <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801c28:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c2b:	89 d0                	mov    %edx,%eax
  801c2d:	01 c0                	add    %eax,%eax
  801c2f:	01 d0                	add    %edx,%eax
  801c31:	c1 e0 02             	shl    $0x2,%eax
  801c34:	05 44 10 81 00       	add    $0x811044,%eax
  801c39:	8b 08                	mov    (%eax),%ecx
  801c3b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c3e:	89 d0                	mov    %edx,%eax
  801c40:	01 c0                	add    %eax,%eax
  801c42:	01 d0                	add    %edx,%eax
  801c44:	c1 e0 02             	shl    $0x2,%eax
  801c47:	05 44 10 81 00       	add    $0x811044,%eax
  801c4c:	8b 00                	mov    (%eax),%eax
  801c4e:	01 c1                	add    %eax,%ecx
  801c50:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c53:	89 d0                	mov    %edx,%eax
  801c55:	01 c0                	add    %eax,%eax
  801c57:	01 d0                	add    %edx,%eax
  801c59:	c1 e0 02             	shl    $0x2,%eax
  801c5c:	05 44 10 81 00       	add    $0x811044,%eax
  801c61:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801c63:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c66:	89 d0                	mov    %edx,%eax
  801c68:	01 c0                	add    %eax,%eax
  801c6a:	01 d0                	add    %edx,%eax
  801c6c:	c1 e0 02             	shl    $0x2,%eax
  801c6f:	05 48 10 81 00       	add    $0x811048,%eax
  801c74:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801c77:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c7a:	89 d0                	mov    %edx,%eax
  801c7c:	01 c0                	add    %eax,%eax
  801c7e:	01 d0                	add    %edx,%eax
  801c80:	c1 e0 02             	shl    $0x2,%eax
  801c83:	05 40 10 81 00       	add    $0x811040,%eax
  801c88:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801c8e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c91:	89 d0                	mov    %edx,%eax
  801c93:	01 c0                	add    %eax,%eax
  801c95:	01 d0                	add    %edx,%eax
  801c97:	c1 e0 02             	shl    $0x2,%eax
  801c9a:	05 44 10 81 00       	add    $0x811044,%eax
  801c9f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ca5:	eb 01                	jmp    801ca8 <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  801ca7:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801ca8:	ff 45 e0             	incl   -0x20(%ebp)
  801cab:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801cb2:	0f 8e 1b fe ff ff    	jle    801ad3 <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  801cb8:	a1 30 51 83 00       	mov    0x835130,%eax
  801cbd:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801cc0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801cc7:	eb 53                	jmp    801d1c <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  801cc9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801ccc:	89 d0                	mov    %edx,%eax
  801cce:	01 c0                	add    %eax,%eax
  801cd0:	01 d0                	add    %edx,%eax
  801cd2:	c1 e0 02             	shl    $0x2,%eax
  801cd5:	05 48 50 80 00       	add    $0x805048,%eax
  801cda:	8a 00                	mov    (%eax),%al
  801cdc:	84 c0                	test   %al,%al
  801cde:	74 39                	je     801d19 <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  801ce0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801ce3:	89 d0                	mov    %edx,%eax
  801ce5:	01 c0                	add    %eax,%eax
  801ce7:	01 d0                	add    %edx,%eax
  801ce9:	c1 e0 02             	shl    $0x2,%eax
  801cec:	05 40 50 80 00       	add    $0x805040,%eax
  801cf1:	8b 08                	mov    (%eax),%ecx
  801cf3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801cf6:	89 d0                	mov    %edx,%eax
  801cf8:	01 c0                	add    %eax,%eax
  801cfa:	01 d0                	add    %edx,%eax
  801cfc:	c1 e0 02             	shl    $0x2,%eax
  801cff:	05 44 50 80 00       	add    $0x805044,%eax
  801d04:	8b 00                	mov    (%eax),%eax
  801d06:	01 c8                	add    %ecx,%eax
  801d08:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  801d0b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801d0e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801d11:	76 06                	jbe    801d19 <free+0x3e3>
  801d13:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801d16:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801d19:	ff 45 d8             	incl   -0x28(%ebp)
  801d1c:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  801d23:	7e a4                	jle    801cc9 <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  801d25:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d28:	a3 88 50 83 00       	mov    %eax,0x835088

    sys_free_user_mem(va, size);
  801d2d:	83 ec 08             	sub    $0x8,%esp
  801d30:	ff 75 f4             	pushl  -0xc(%ebp)
  801d33:	ff 75 d4             	pushl  -0x2c(%ebp)
  801d36:	e8 79 15 00 00       	call   8032b4 <sys_free_user_mem>
  801d3b:	83 c4 10             	add    $0x10,%esp
  801d3e:	eb 01                	jmp    801d41 <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  801d40:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  801d41:	c9                   	leave  
  801d42:	c3                   	ret    

00801d43 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801d43:	55                   	push   %ebp
  801d44:	89 e5                	mov    %esp,%ebp
  801d46:	83 ec 68             	sub    $0x68,%esp
  801d49:	8b 45 10             	mov    0x10(%ebp),%eax
  801d4c:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801d4f:	e8 a5 f7 ff ff       	call   8014f9 <uheap_init>
	if (size == 0) return NULL ;
  801d54:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d58:	75 0a                	jne    801d64 <smalloc+0x21>
  801d5a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5f:	e9 37 03 00 00       	jmp    80209b <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801d64:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801d6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d6e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d71:	01 d0                	add    %edx,%eax
  801d73:	48                   	dec    %eax
  801d74:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801d77:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d7a:	ba 00 00 00 00       	mov    $0x0,%edx
  801d7f:	f7 75 dc             	divl   -0x24(%ebp)
  801d82:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d85:	29 d0                	sub    %edx,%eax
  801d87:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  801d8a:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801d91:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801d98:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801d9f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801da6:	e9 85 00 00 00       	jmp    801e30 <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801dab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801dae:	89 d0                	mov    %edx,%eax
  801db0:	01 c0                	add    %eax,%eax
  801db2:	01 d0                	add    %edx,%eax
  801db4:	c1 e0 02             	shl    $0x2,%eax
  801db7:	05 48 10 81 00       	add    $0x811048,%eax
  801dbc:	8a 00                	mov    (%eax),%al
  801dbe:	84 c0                	test   %al,%al
  801dc0:	74 20                	je     801de2 <smalloc+0x9f>
  801dc2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801dc5:	89 d0                	mov    %edx,%eax
  801dc7:	01 c0                	add    %eax,%eax
  801dc9:	01 d0                	add    %edx,%eax
  801dcb:	c1 e0 02             	shl    $0x2,%eax
  801dce:	05 44 10 81 00       	add    $0x811044,%eax
  801dd3:	8b 00                	mov    (%eax),%eax
  801dd5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801dd8:	75 08                	jne    801de2 <smalloc+0x9f>
        {
            exactIdx = i;
  801dda:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ddd:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801de0:	eb 5b                	jmp    801e3d <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801de2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801de5:	89 d0                	mov    %edx,%eax
  801de7:	01 c0                	add    %eax,%eax
  801de9:	01 d0                	add    %edx,%eax
  801deb:	c1 e0 02             	shl    $0x2,%eax
  801dee:	05 48 10 81 00       	add    $0x811048,%eax
  801df3:	8a 00                	mov    (%eax),%al
  801df5:	84 c0                	test   %al,%al
  801df7:	74 34                	je     801e2d <smalloc+0xea>
  801df9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801dfc:	89 d0                	mov    %edx,%eax
  801dfe:	01 c0                	add    %eax,%eax
  801e00:	01 d0                	add    %edx,%eax
  801e02:	c1 e0 02             	shl    $0x2,%eax
  801e05:	05 44 10 81 00       	add    $0x811044,%eax
  801e0a:	8b 00                	mov    (%eax),%eax
  801e0c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801e0f:	76 1c                	jbe    801e2d <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  801e11:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e14:	89 d0                	mov    %edx,%eax
  801e16:	01 c0                	add    %eax,%eax
  801e18:	01 d0                	add    %edx,%eax
  801e1a:	c1 e0 02             	shl    $0x2,%eax
  801e1d:	05 44 10 81 00       	add    $0x811044,%eax
  801e22:	8b 00                	mov    (%eax),%eax
  801e24:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801e27:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e2a:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801e2d:	ff 45 e8             	incl   -0x18(%ebp)
  801e30:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801e37:	0f 8e 6e ff ff ff    	jle    801dab <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  801e3d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801e44:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801e48:	74 7d                	je     801ec7 <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801e4a:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801e51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e54:	89 d0                	mov    %edx,%eax
  801e56:	01 c0                	add    %eax,%eax
  801e58:	01 d0                	add    %edx,%eax
  801e5a:	c1 e0 02             	shl    $0x2,%eax
  801e5d:	05 40 10 81 00       	add    $0x811040,%eax
  801e62:	8b 10                	mov    (%eax),%edx
  801e64:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801e67:	01 d0                	add    %edx,%eax
  801e69:	48                   	dec    %eax
  801e6a:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801e6d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801e70:	ba 00 00 00 00       	mov    $0x0,%edx
  801e75:	f7 75 bc             	divl   -0x44(%ebp)
  801e78:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801e7b:	29 d0                	sub    %edx,%eax
  801e7d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801e80:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e83:	89 d0                	mov    %edx,%eax
  801e85:	01 c0                	add    %eax,%eax
  801e87:	01 d0                	add    %edx,%eax
  801e89:	c1 e0 02             	shl    $0x2,%eax
  801e8c:	05 48 10 81 00       	add    $0x811048,%eax
  801e91:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801e94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e97:	89 d0                	mov    %edx,%eax
  801e99:	01 c0                	add    %eax,%eax
  801e9b:	01 d0                	add    %edx,%eax
  801e9d:	c1 e0 02             	shl    $0x2,%eax
  801ea0:	05 44 10 81 00       	add    $0x811044,%eax
  801ea5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801eab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eae:	89 d0                	mov    %edx,%eax
  801eb0:	01 c0                	add    %eax,%eax
  801eb2:	01 d0                	add    %edx,%eax
  801eb4:	c1 e0 02             	shl    $0x2,%eax
  801eb7:	05 40 10 81 00       	add    $0x811040,%eax
  801ebc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ec2:	e9 2d 01 00 00       	jmp    801ff4 <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  801ec7:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801ecb:	0f 84 ce 00 00 00    	je     801f9f <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  801ed1:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  801ed8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801edb:	89 d0                	mov    %edx,%eax
  801edd:	01 c0                	add    %eax,%eax
  801edf:	01 d0                	add    %edx,%eax
  801ee1:	c1 e0 02             	shl    $0x2,%eax
  801ee4:	05 40 10 81 00       	add    $0x811040,%eax
  801ee9:	8b 10                	mov    (%eax),%edx
  801eeb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801eee:	01 d0                	add    %edx,%eax
  801ef0:	48                   	dec    %eax
  801ef1:	89 45 c0             	mov    %eax,-0x40(%ebp)
  801ef4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801ef7:	ba 00 00 00 00       	mov    $0x0,%edx
  801efc:	f7 75 c4             	divl   -0x3c(%ebp)
  801eff:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801f02:	29 d0                	sub    %edx,%eax
  801f04:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  801f07:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f0a:	89 d0                	mov    %edx,%eax
  801f0c:	01 c0                	add    %eax,%eax
  801f0e:	01 d0                	add    %edx,%eax
  801f10:	c1 e0 02             	shl    $0x2,%eax
  801f13:	05 44 10 81 00       	add    $0x811044,%eax
  801f18:	8b 00                	mov    (%eax),%eax
  801f1a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801f1d:	75 47                	jne    801f66 <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  801f1f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f22:	89 d0                	mov    %edx,%eax
  801f24:	01 c0                	add    %eax,%eax
  801f26:	01 d0                	add    %edx,%eax
  801f28:	c1 e0 02             	shl    $0x2,%eax
  801f2b:	05 48 10 81 00       	add    $0x811048,%eax
  801f30:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  801f33:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f36:	89 d0                	mov    %edx,%eax
  801f38:	01 c0                	add    %eax,%eax
  801f3a:	01 d0                	add    %edx,%eax
  801f3c:	c1 e0 02             	shl    $0x2,%eax
  801f3f:	05 44 10 81 00       	add    $0x811044,%eax
  801f44:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  801f4a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f4d:	89 d0                	mov    %edx,%eax
  801f4f:	01 c0                	add    %eax,%eax
  801f51:	01 d0                	add    %edx,%eax
  801f53:	c1 e0 02             	shl    $0x2,%eax
  801f56:	05 40 10 81 00       	add    $0x811040,%eax
  801f5b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f61:	e9 8e 00 00 00       	jmp    801ff4 <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  801f66:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801f69:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f6c:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801f6f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f72:	89 d0                	mov    %edx,%eax
  801f74:	01 c0                	add    %eax,%eax
  801f76:	01 d0                	add    %edx,%eax
  801f78:	c1 e0 02             	shl    $0x2,%eax
  801f7b:	05 40 10 81 00       	add    $0x811040,%eax
  801f80:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  801f82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f85:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801f88:	89 c2                	mov    %eax,%edx
  801f8a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801f8d:	89 c8                	mov    %ecx,%eax
  801f8f:	01 c0                	add    %eax,%eax
  801f91:	01 c8                	add    %ecx,%eax
  801f93:	c1 e0 02             	shl    $0x2,%eax
  801f96:	05 44 10 81 00       	add    $0x811044,%eax
  801f9b:	89 10                	mov    %edx,(%eax)
  801f9d:	eb 55                	jmp    801ff4 <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  801f9f:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801fa6:	8b 15 88 50 83 00    	mov    0x835088,%edx
  801fac:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801faf:	01 d0                	add    %edx,%eax
  801fb1:	48                   	dec    %eax
  801fb2:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801fb5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801fb8:	ba 00 00 00 00       	mov    $0x0,%edx
  801fbd:	f7 75 d0             	divl   -0x30(%ebp)
  801fc0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801fc3:	29 d0                	sub    %edx,%eax
  801fc5:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  801fc8:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801fcb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fce:	01 d0                	add    %edx,%eax
  801fd0:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801fd5:	76 0a                	jbe    801fe1 <smalloc+0x29e>
            return NULL;
  801fd7:	b8 00 00 00 00       	mov    $0x0,%eax
  801fdc:	e9 ba 00 00 00       	jmp    80209b <smalloc+0x358>
        va = start;
  801fe1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801fe4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  801fe7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801fea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fed:	01 d0                	add    %edx,%eax
  801fef:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801ff4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801ffb:	eb 5e                	jmp    80205b <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  801ffd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802000:	89 d0                	mov    %edx,%eax
  802002:	01 c0                	add    %eax,%eax
  802004:	01 d0                	add    %edx,%eax
  802006:	c1 e0 02             	shl    $0x2,%eax
  802009:	05 48 50 80 00       	add    $0x805048,%eax
  80200e:	8a 00                	mov    (%eax),%al
  802010:	84 c0                	test   %al,%al
  802012:	75 44                	jne    802058 <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  802014:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802017:	89 d0                	mov    %edx,%eax
  802019:	01 c0                	add    %eax,%eax
  80201b:	01 d0                	add    %edx,%eax
  80201d:	c1 e0 02             	shl    $0x2,%eax
  802020:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  802026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802029:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  80202b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80202e:	89 d0                	mov    %edx,%eax
  802030:	01 c0                	add    %eax,%eax
  802032:	01 d0                	add    %edx,%eax
  802034:	c1 e0 02             	shl    $0x2,%eax
  802037:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  80203d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802040:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  802042:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802045:	89 d0                	mov    %edx,%eax
  802047:	01 c0                	add    %eax,%eax
  802049:	01 d0                	add    %edx,%eax
  80204b:	c1 e0 02             	shl    $0x2,%eax
  80204e:	05 48 50 80 00       	add    $0x805048,%eax
  802053:	c6 00 01             	movb   $0x1,(%eax)
            break;
  802056:	eb 0c                	jmp    802064 <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802058:	ff 45 e0             	incl   -0x20(%ebp)
  80205b:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802062:	7e 99                	jle    801ffd <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  802064:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802067:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  80206b:	52                   	push   %edx
  80206c:	50                   	push   %eax
  80206d:	ff 75 d4             	pushl  -0x2c(%ebp)
  802070:	ff 75 08             	pushl  0x8(%ebp)
  802073:	e8 de 0e 00 00       	call   802f56 <sys_create_shared_object>
  802078:	83 c4 10             	add    $0x10,%esp
  80207b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  80207e:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  802082:	75 07                	jne    80208b <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  802084:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802089:	eb 10                	jmp    80209b <smalloc+0x358>
    if (r < 0)
  80208b:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  80208f:	79 07                	jns    802098 <smalloc+0x355>
        return NULL;
  802091:	b8 00 00 00 00       	mov    $0x0,%eax
  802096:	eb 03                	jmp    80209b <smalloc+0x358>
    return (void*)va;
  802098:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  80209b:	c9                   	leave  
  80209c:	c3                   	ret    

0080209d <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80209d:	55                   	push   %ebp
  80209e:	89 e5                	mov    %esp,%ebp
  8020a0:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8020a3:	e8 51 f4 ff ff       	call   8014f9 <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  8020a8:	83 ec 08             	sub    $0x8,%esp
  8020ab:	ff 75 0c             	pushl  0xc(%ebp)
  8020ae:	ff 75 08             	pushl  0x8(%ebp)
  8020b1:	e8 ca 0e 00 00       	call   802f80 <sys_size_of_shared_object>
  8020b6:	83 c4 10             	add    $0x10,%esp
  8020b9:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  8020bc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8020c0:	7f 0a                	jg     8020cc <sget+0x2f>
        return NULL;
  8020c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c7:	e9 28 03 00 00       	jmp    8023f4 <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  8020cc:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8020d3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8020d6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8020d9:	01 d0                	add    %edx,%eax
  8020db:	48                   	dec    %eax
  8020dc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8020df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8020e7:	f7 75 d8             	divl   -0x28(%ebp)
  8020ea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020ed:	29 d0                	sub    %edx,%eax
  8020ef:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  8020f2:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  8020f9:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  802100:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802107:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80210e:	e9 85 00 00 00       	jmp    802198 <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  802113:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802116:	89 d0                	mov    %edx,%eax
  802118:	01 c0                	add    %eax,%eax
  80211a:	01 d0                	add    %edx,%eax
  80211c:	c1 e0 02             	shl    $0x2,%eax
  80211f:	05 48 10 81 00       	add    $0x811048,%eax
  802124:	8a 00                	mov    (%eax),%al
  802126:	84 c0                	test   %al,%al
  802128:	74 20                	je     80214a <sget+0xad>
  80212a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80212d:	89 d0                	mov    %edx,%eax
  80212f:	01 c0                	add    %eax,%eax
  802131:	01 d0                	add    %edx,%eax
  802133:	c1 e0 02             	shl    $0x2,%eax
  802136:	05 44 10 81 00       	add    $0x811044,%eax
  80213b:	8b 00                	mov    (%eax),%eax
  80213d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802140:	75 08                	jne    80214a <sget+0xad>
        {
            exactIdx = i;
  802142:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802145:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  802148:	eb 5b                	jmp    8021a5 <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  80214a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80214d:	89 d0                	mov    %edx,%eax
  80214f:	01 c0                	add    %eax,%eax
  802151:	01 d0                	add    %edx,%eax
  802153:	c1 e0 02             	shl    $0x2,%eax
  802156:	05 48 10 81 00       	add    $0x811048,%eax
  80215b:	8a 00                	mov    (%eax),%al
  80215d:	84 c0                	test   %al,%al
  80215f:	74 34                	je     802195 <sget+0xf8>
  802161:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802164:	89 d0                	mov    %edx,%eax
  802166:	01 c0                	add    %eax,%eax
  802168:	01 d0                	add    %edx,%eax
  80216a:	c1 e0 02             	shl    $0x2,%eax
  80216d:	05 44 10 81 00       	add    $0x811044,%eax
  802172:	8b 00                	mov    (%eax),%eax
  802174:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802177:	76 1c                	jbe    802195 <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  802179:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80217c:	89 d0                	mov    %edx,%eax
  80217e:	01 c0                	add    %eax,%eax
  802180:	01 d0                	add    %edx,%eax
  802182:	c1 e0 02             	shl    $0x2,%eax
  802185:	05 44 10 81 00       	add    $0x811044,%eax
  80218a:	8b 00                	mov    (%eax),%eax
  80218c:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  80218f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802192:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802195:	ff 45 e8             	incl   -0x18(%ebp)
  802198:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  80219f:	0f 8e 6e ff ff ff    	jle    802113 <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  8021a5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  8021ac:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8021b0:	74 7d                	je     80222f <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  8021b2:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8021b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021bc:	89 d0                	mov    %edx,%eax
  8021be:	01 c0                	add    %eax,%eax
  8021c0:	01 d0                	add    %edx,%eax
  8021c2:	c1 e0 02             	shl    $0x2,%eax
  8021c5:	05 40 10 81 00       	add    $0x811040,%eax
  8021ca:	8b 10                	mov    (%eax),%edx
  8021cc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8021cf:	01 d0                	add    %edx,%eax
  8021d1:	48                   	dec    %eax
  8021d2:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8021d5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8021d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8021dd:	f7 75 b8             	divl   -0x48(%ebp)
  8021e0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8021e3:	29 d0                	sub    %edx,%eax
  8021e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  8021e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021eb:	89 d0                	mov    %edx,%eax
  8021ed:	01 c0                	add    %eax,%eax
  8021ef:	01 d0                	add    %edx,%eax
  8021f1:	c1 e0 02             	shl    $0x2,%eax
  8021f4:	05 48 10 81 00       	add    $0x811048,%eax
  8021f9:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  8021fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021ff:	89 d0                	mov    %edx,%eax
  802201:	01 c0                	add    %eax,%eax
  802203:	01 d0                	add    %edx,%eax
  802205:	c1 e0 02             	shl    $0x2,%eax
  802208:	05 44 10 81 00       	add    $0x811044,%eax
  80220d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  802213:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802216:	89 d0                	mov    %edx,%eax
  802218:	01 c0                	add    %eax,%eax
  80221a:	01 d0                	add    %edx,%eax
  80221c:	c1 e0 02             	shl    $0x2,%eax
  80221f:	05 40 10 81 00       	add    $0x811040,%eax
  802224:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80222a:	e9 2d 01 00 00       	jmp    80235c <sget+0x2bf>
    }
    else if (worstIdx != -1)
  80222f:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802233:	0f 84 ce 00 00 00    	je     802307 <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  802239:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  802240:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802243:	89 d0                	mov    %edx,%eax
  802245:	01 c0                	add    %eax,%eax
  802247:	01 d0                	add    %edx,%eax
  802249:	c1 e0 02             	shl    $0x2,%eax
  80224c:	05 40 10 81 00       	add    $0x811040,%eax
  802251:	8b 10                	mov    (%eax),%edx
  802253:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802256:	01 d0                	add    %edx,%eax
  802258:	48                   	dec    %eax
  802259:	89 45 bc             	mov    %eax,-0x44(%ebp)
  80225c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80225f:	ba 00 00 00 00       	mov    $0x0,%edx
  802264:	f7 75 c0             	divl   -0x40(%ebp)
  802267:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80226a:	29 d0                	sub    %edx,%eax
  80226c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  80226f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802272:	89 d0                	mov    %edx,%eax
  802274:	01 c0                	add    %eax,%eax
  802276:	01 d0                	add    %edx,%eax
  802278:	c1 e0 02             	shl    $0x2,%eax
  80227b:	05 44 10 81 00       	add    $0x811044,%eax
  802280:	8b 00                	mov    (%eax),%eax
  802282:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802285:	75 47                	jne    8022ce <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  802287:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80228a:	89 d0                	mov    %edx,%eax
  80228c:	01 c0                	add    %eax,%eax
  80228e:	01 d0                	add    %edx,%eax
  802290:	c1 e0 02             	shl    $0x2,%eax
  802293:	05 48 10 81 00       	add    $0x811048,%eax
  802298:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  80229b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80229e:	89 d0                	mov    %edx,%eax
  8022a0:	01 c0                	add    %eax,%eax
  8022a2:	01 d0                	add    %edx,%eax
  8022a4:	c1 e0 02             	shl    $0x2,%eax
  8022a7:	05 44 10 81 00       	add    $0x811044,%eax
  8022ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  8022b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022b5:	89 d0                	mov    %edx,%eax
  8022b7:	01 c0                	add    %eax,%eax
  8022b9:	01 d0                	add    %edx,%eax
  8022bb:	c1 e0 02             	shl    $0x2,%eax
  8022be:	05 40 10 81 00       	add    $0x811040,%eax
  8022c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022c9:	e9 8e 00 00 00       	jmp    80235c <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  8022ce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8022d1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8022d4:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8022d7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022da:	89 d0                	mov    %edx,%eax
  8022dc:	01 c0                	add    %eax,%eax
  8022de:	01 d0                	add    %edx,%eax
  8022e0:	c1 e0 02             	shl    $0x2,%eax
  8022e3:	05 40 10 81 00       	add    $0x811040,%eax
  8022e8:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  8022ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022ed:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8022f0:	89 c2                	mov    %eax,%edx
  8022f2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8022f5:	89 c8                	mov    %ecx,%eax
  8022f7:	01 c0                	add    %eax,%eax
  8022f9:	01 c8                	add    %ecx,%eax
  8022fb:	c1 e0 02             	shl    $0x2,%eax
  8022fe:	05 44 10 81 00       	add    $0x811044,%eax
  802303:	89 10                	mov    %edx,(%eax)
  802305:	eb 55                	jmp    80235c <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  802307:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80230e:	8b 15 88 50 83 00    	mov    0x835088,%edx
  802314:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802317:	01 d0                	add    %edx,%eax
  802319:	48                   	dec    %eax
  80231a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80231d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802320:	ba 00 00 00 00       	mov    $0x0,%edx
  802325:	f7 75 cc             	divl   -0x34(%ebp)
  802328:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80232b:	29 d0                	sub    %edx,%eax
  80232d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  802330:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802333:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802336:	01 d0                	add    %edx,%eax
  802338:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  80233d:	76 0a                	jbe    802349 <sget+0x2ac>
            return NULL;
  80233f:	b8 00 00 00 00       	mov    $0x0,%eax
  802344:	e9 ab 00 00 00       	jmp    8023f4 <sget+0x357>
        va = start;
  802349:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80234c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  80234f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802352:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802355:	01 d0                	add    %edx,%eax
  802357:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80235c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802363:	eb 5e                	jmp    8023c3 <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  802365:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802368:	89 d0                	mov    %edx,%eax
  80236a:	01 c0                	add    %eax,%eax
  80236c:	01 d0                	add    %edx,%eax
  80236e:	c1 e0 02             	shl    $0x2,%eax
  802371:	05 48 50 80 00       	add    $0x805048,%eax
  802376:	8a 00                	mov    (%eax),%al
  802378:	84 c0                	test   %al,%al
  80237a:	75 44                	jne    8023c0 <sget+0x323>
        {
            uhp_allocs[i].va = va;
  80237c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80237f:	89 d0                	mov    %edx,%eax
  802381:	01 c0                	add    %eax,%eax
  802383:	01 d0                	add    %edx,%eax
  802385:	c1 e0 02             	shl    $0x2,%eax
  802388:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  80238e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802391:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  802393:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802396:	89 d0                	mov    %edx,%eax
  802398:	01 c0                	add    %eax,%eax
  80239a:	01 d0                	add    %edx,%eax
  80239c:	c1 e0 02             	shl    $0x2,%eax
  80239f:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8023a5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8023a8:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  8023aa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8023ad:	89 d0                	mov    %edx,%eax
  8023af:	01 c0                	add    %eax,%eax
  8023b1:	01 d0                	add    %edx,%eax
  8023b3:	c1 e0 02             	shl    $0x2,%eax
  8023b6:	05 48 50 80 00       	add    $0x805048,%eax
  8023bb:	c6 00 01             	movb   $0x1,(%eax)
            break;
  8023be:	eb 0c                	jmp    8023cc <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8023c0:	ff 45 e0             	incl   -0x20(%ebp)
  8023c3:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8023ca:	7e 99                	jle    802365 <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  8023cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023cf:	83 ec 04             	sub    $0x4,%esp
  8023d2:	50                   	push   %eax
  8023d3:	ff 75 0c             	pushl  0xc(%ebp)
  8023d6:	ff 75 08             	pushl  0x8(%ebp)
  8023d9:	e8 bf 0b 00 00       	call   802f9d <sys_get_shared_object>
  8023de:	83 c4 10             	add    $0x10,%esp
  8023e1:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  8023e4:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8023e8:	79 07                	jns    8023f1 <sget+0x354>
        return NULL;
  8023ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ef:	eb 03                	jmp    8023f4 <sget+0x357>
    return (void*)va;
  8023f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8023f4:	c9                   	leave  
  8023f5:	c3                   	ret    

008023f6 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8023f6:	55                   	push   %ebp
  8023f7:	89 e5                	mov    %esp,%ebp
  8023f9:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8023fc:	e8 f8 f0 ff ff       	call   8014f9 <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  802401:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802405:	75 13                	jne    80241a <realloc+0x24>
		return malloc(new_size);
  802407:	83 ec 0c             	sub    $0xc,%esp
  80240a:	ff 75 0c             	pushl  0xc(%ebp)
  80240d:	e8 c4 f1 ff ff       	call   8015d6 <malloc>
  802412:	83 c4 10             	add    $0x10,%esp
  802415:	e9 f4 05 00 00       	jmp    802a0e <realloc+0x618>
	if (new_size == 0)
  80241a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80241e:	75 18                	jne    802438 <realloc+0x42>
	{
		free(virtual_address);
  802420:	83 ec 0c             	sub    $0xc,%esp
  802423:	ff 75 08             	pushl  0x8(%ebp)
  802426:	e8 0b f5 ff ff       	call   801936 <free>
  80242b:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80242e:	b8 00 00 00 00       	mov    $0x0,%eax
  802433:	e9 d6 05 00 00       	jmp    802a0e <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  802438:	8b 45 08             	mov    0x8(%ebp),%eax
  80243b:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  80243e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802441:	85 c0                	test   %eax,%eax
  802443:	79 74                	jns    8024b9 <realloc+0xc3>
  802445:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  80244c:	77 6b                	ja     8024b9 <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  80244e:	83 ec 0c             	sub    $0xc,%esp
  802451:	ff 75 0c             	pushl  0xc(%ebp)
  802454:	e8 7d f1 ff ff       	call   8015d6 <malloc>
  802459:	83 c4 10             	add    $0x10,%esp
  80245c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  80245f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  802463:	75 0a                	jne    80246f <realloc+0x79>
			return NULL;
  802465:	b8 00 00 00 00       	mov    $0x0,%eax
  80246a:	e9 9f 05 00 00       	jmp    802a0e <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  80246f:	83 ec 0c             	sub    $0xc,%esp
  802472:	ff 75 08             	pushl  0x8(%ebp)
  802475:	e8 e0 11 00 00       	call   80365a <get_block_size>
  80247a:	83 c4 10             	add    $0x10,%esp
  80247d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  802480:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802483:	8b 45 0c             	mov    0xc(%ebp),%eax
  802486:	39 d0                	cmp    %edx,%eax
  802488:	76 02                	jbe    80248c <realloc+0x96>
  80248a:	89 d0                	mov    %edx,%eax
  80248c:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  80248f:	83 ec 04             	sub    $0x4,%esp
  802492:	ff 75 c0             	pushl  -0x40(%ebp)
  802495:	ff 75 08             	pushl  0x8(%ebp)
  802498:	ff 75 c8             	pushl  -0x38(%ebp)
  80249b:	e8 56 eb ff ff       	call   800ff6 <memmove>
  8024a0:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  8024a3:	83 ec 0c             	sub    $0xc,%esp
  8024a6:	ff 75 08             	pushl  0x8(%ebp)
  8024a9:	e8 88 f4 ff ff       	call   801936 <free>
  8024ae:	83 c4 10             	add    $0x10,%esp
		return newptr;
  8024b1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8024b4:	e9 55 05 00 00       	jmp    802a0e <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  8024b9:	a1 30 51 83 00       	mov    0x835130,%eax
  8024be:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  8024c1:	72 09                	jb     8024cc <realloc+0xd6>
  8024c3:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  8024ca:	76 0a                	jbe    8024d6 <realloc+0xe0>
		return NULL;
  8024cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d1:	e9 38 05 00 00       	jmp    802a0e <realloc+0x618>
	uint32 oldsz = 0;
  8024d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  8024dd:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8024e4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8024eb:	eb 50                	jmp    80253d <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  8024ed:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024f0:	89 d0                	mov    %edx,%eax
  8024f2:	01 c0                	add    %eax,%eax
  8024f4:	01 d0                	add    %edx,%eax
  8024f6:	c1 e0 02             	shl    $0x2,%eax
  8024f9:	05 48 50 80 00       	add    $0x805048,%eax
  8024fe:	8a 00                	mov    (%eax),%al
  802500:	84 c0                	test   %al,%al
  802502:	74 36                	je     80253a <realloc+0x144>
  802504:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802507:	89 d0                	mov    %edx,%eax
  802509:	01 c0                	add    %eax,%eax
  80250b:	01 d0                	add    %edx,%eax
  80250d:	c1 e0 02             	shl    $0x2,%eax
  802510:	05 40 50 80 00       	add    $0x805040,%eax
  802515:	8b 00                	mov    (%eax),%eax
  802517:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  80251a:	75 1e                	jne    80253a <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  80251c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80251f:	89 d0                	mov    %edx,%eax
  802521:	01 c0                	add    %eax,%eax
  802523:	01 d0                	add    %edx,%eax
  802525:	c1 e0 02             	shl    $0x2,%eax
  802528:	05 44 50 80 00       	add    $0x805044,%eax
  80252d:	8b 00                	mov    (%eax),%eax
  80252f:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  802532:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802535:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802538:	eb 0c                	jmp    802546 <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80253a:	ff 45 ec             	incl   -0x14(%ebp)
  80253d:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802544:	7e a7                	jle    8024ed <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  802546:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80254a:	75 0a                	jne    802556 <realloc+0x160>
		return NULL;
  80254c:	b8 00 00 00 00       	mov    $0x0,%eax
  802551:	e9 b8 04 00 00       	jmp    802a0e <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  802556:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  80255d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802560:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802563:	01 d0                	add    %edx,%eax
  802565:	48                   	dec    %eax
  802566:	89 45 b8             	mov    %eax,-0x48(%ebp)
  802569:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80256c:	ba 00 00 00 00       	mov    $0x0,%edx
  802571:	f7 75 bc             	divl   -0x44(%ebp)
  802574:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802577:	29 d0                	sub    %edx,%eax
  802579:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  80257c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80257f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802582:	75 08                	jne    80258c <realloc+0x196>
		return virtual_address;
  802584:	8b 45 08             	mov    0x8(%ebp),%eax
  802587:	e9 82 04 00 00       	jmp    802a0e <realloc+0x618>
	if (req < oldsz)
  80258c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80258f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802592:	0f 83 cd 02 00 00    	jae    802865 <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  802598:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259b:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  80259e:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  8025a1:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8025a4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8025a7:	01 d0                	add    %edx,%eax
  8025a9:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  8025ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025af:	89 d0                	mov    %edx,%eax
  8025b1:	01 c0                	add    %eax,%eax
  8025b3:	01 d0                	add    %edx,%eax
  8025b5:	c1 e0 02             	shl    $0x2,%eax
  8025b8:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8025be:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8025c1:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  8025c3:	83 ec 08             	sub    $0x8,%esp
  8025c6:	ff 75 b0             	pushl  -0x50(%ebp)
  8025c9:	ff 75 ac             	pushl  -0x54(%ebp)
  8025cc:	e8 e3 0c 00 00       	call   8032b4 <sys_free_user_mem>
  8025d1:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  8025d4:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8025db:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8025e2:	eb 64                	jmp    802648 <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  8025e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025e7:	89 d0                	mov    %edx,%eax
  8025e9:	01 c0                	add    %eax,%eax
  8025eb:	01 d0                	add    %edx,%eax
  8025ed:	c1 e0 02             	shl    $0x2,%eax
  8025f0:	05 48 10 81 00       	add    $0x811048,%eax
  8025f5:	8a 00                	mov    (%eax),%al
  8025f7:	84 c0                	test   %al,%al
  8025f9:	75 4a                	jne    802645 <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  8025fb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025fe:	89 d0                	mov    %edx,%eax
  802600:	01 c0                	add    %eax,%eax
  802602:	01 d0                	add    %edx,%eax
  802604:	c1 e0 02             	shl    $0x2,%eax
  802607:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  80260d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802610:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  802612:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802615:	89 d0                	mov    %edx,%eax
  802617:	01 c0                	add    %eax,%eax
  802619:	01 d0                	add    %edx,%eax
  80261b:	c1 e0 02             	shl    $0x2,%eax
  80261e:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  802624:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802627:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  802629:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80262c:	89 d0                	mov    %edx,%eax
  80262e:	01 c0                	add    %eax,%eax
  802630:	01 d0                	add    %edx,%eax
  802632:	c1 e0 02             	shl    $0x2,%eax
  802635:	05 48 10 81 00       	add    $0x811048,%eax
  80263a:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  80263d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802640:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  802643:	eb 0c                	jmp    802651 <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802645:	ff 45 e4             	incl   -0x1c(%ebp)
  802648:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  80264f:	7e 93                	jle    8025e4 <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  802651:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802655:	0f 84 8d 01 00 00    	je     8027e8 <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  80265b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802662:	e9 74 01 00 00       	jmp    8027db <realloc+0x3e5>
			{
				if (k == fidx) continue;
  802667:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80266a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80266d:	0f 84 64 01 00 00    	je     8027d7 <realloc+0x3e1>
				if (uhp_frees[k].free)
  802673:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802676:	89 d0                	mov    %edx,%eax
  802678:	01 c0                	add    %eax,%eax
  80267a:	01 d0                	add    %edx,%eax
  80267c:	c1 e0 02             	shl    $0x2,%eax
  80267f:	05 48 10 81 00       	add    $0x811048,%eax
  802684:	8a 00                	mov    (%eax),%al
  802686:	84 c0                	test   %al,%al
  802688:	0f 84 4a 01 00 00    	je     8027d8 <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  80268e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802691:	89 d0                	mov    %edx,%eax
  802693:	01 c0                	add    %eax,%eax
  802695:	01 d0                	add    %edx,%eax
  802697:	c1 e0 02             	shl    $0x2,%eax
  80269a:	05 40 10 81 00       	add    $0x811040,%eax
  80269f:	8b 08                	mov    (%eax),%ecx
  8026a1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026a4:	89 d0                	mov    %edx,%eax
  8026a6:	01 c0                	add    %eax,%eax
  8026a8:	01 d0                	add    %edx,%eax
  8026aa:	c1 e0 02             	shl    $0x2,%eax
  8026ad:	05 44 10 81 00       	add    $0x811044,%eax
  8026b2:	8b 00                	mov    (%eax),%eax
  8026b4:	01 c1                	add    %eax,%ecx
  8026b6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026b9:	89 d0                	mov    %edx,%eax
  8026bb:	01 c0                	add    %eax,%eax
  8026bd:	01 d0                	add    %edx,%eax
  8026bf:	c1 e0 02             	shl    $0x2,%eax
  8026c2:	05 40 10 81 00       	add    $0x811040,%eax
  8026c7:	8b 00                	mov    (%eax),%eax
  8026c9:	39 c1                	cmp    %eax,%ecx
  8026cb:	75 7a                	jne    802747 <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  8026cd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026d0:	89 d0                	mov    %edx,%eax
  8026d2:	01 c0                	add    %eax,%eax
  8026d4:	01 d0                	add    %edx,%eax
  8026d6:	c1 e0 02             	shl    $0x2,%eax
  8026d9:	05 40 10 81 00       	add    $0x811040,%eax
  8026de:	8b 10                	mov    (%eax),%edx
  8026e0:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  8026e3:	89 c8                	mov    %ecx,%eax
  8026e5:	01 c0                	add    %eax,%eax
  8026e7:	01 c8                	add    %ecx,%eax
  8026e9:	c1 e0 02             	shl    $0x2,%eax
  8026ec:	05 40 10 81 00       	add    $0x811040,%eax
  8026f1:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  8026f3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026f6:	89 d0                	mov    %edx,%eax
  8026f8:	01 c0                	add    %eax,%eax
  8026fa:	01 d0                	add    %edx,%eax
  8026fc:	c1 e0 02             	shl    $0x2,%eax
  8026ff:	05 44 10 81 00       	add    $0x811044,%eax
  802704:	8b 08                	mov    (%eax),%ecx
  802706:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802709:	89 d0                	mov    %edx,%eax
  80270b:	01 c0                	add    %eax,%eax
  80270d:	01 d0                	add    %edx,%eax
  80270f:	c1 e0 02             	shl    $0x2,%eax
  802712:	05 44 10 81 00       	add    $0x811044,%eax
  802717:	8b 00                	mov    (%eax),%eax
  802719:	01 c1                	add    %eax,%ecx
  80271b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80271e:	89 d0                	mov    %edx,%eax
  802720:	01 c0                	add    %eax,%eax
  802722:	01 d0                	add    %edx,%eax
  802724:	c1 e0 02             	shl    $0x2,%eax
  802727:	05 44 10 81 00       	add    $0x811044,%eax
  80272c:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  80272e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802731:	89 d0                	mov    %edx,%eax
  802733:	01 c0                	add    %eax,%eax
  802735:	01 d0                	add    %edx,%eax
  802737:	c1 e0 02             	shl    $0x2,%eax
  80273a:	05 48 10 81 00       	add    $0x811048,%eax
  80273f:	c6 00 00             	movb   $0x0,(%eax)
  802742:	e9 91 00 00 00       	jmp    8027d8 <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802747:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80274a:	89 d0                	mov    %edx,%eax
  80274c:	01 c0                	add    %eax,%eax
  80274e:	01 d0                	add    %edx,%eax
  802750:	c1 e0 02             	shl    $0x2,%eax
  802753:	05 40 10 81 00       	add    $0x811040,%eax
  802758:	8b 08                	mov    (%eax),%ecx
  80275a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80275d:	89 d0                	mov    %edx,%eax
  80275f:	01 c0                	add    %eax,%eax
  802761:	01 d0                	add    %edx,%eax
  802763:	c1 e0 02             	shl    $0x2,%eax
  802766:	05 44 10 81 00       	add    $0x811044,%eax
  80276b:	8b 00                	mov    (%eax),%eax
  80276d:	01 c1                	add    %eax,%ecx
  80276f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802772:	89 d0                	mov    %edx,%eax
  802774:	01 c0                	add    %eax,%eax
  802776:	01 d0                	add    %edx,%eax
  802778:	c1 e0 02             	shl    $0x2,%eax
  80277b:	05 40 10 81 00       	add    $0x811040,%eax
  802780:	8b 00                	mov    (%eax),%eax
  802782:	39 c1                	cmp    %eax,%ecx
  802784:	75 52                	jne    8027d8 <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  802786:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802789:	89 d0                	mov    %edx,%eax
  80278b:	01 c0                	add    %eax,%eax
  80278d:	01 d0                	add    %edx,%eax
  80278f:	c1 e0 02             	shl    $0x2,%eax
  802792:	05 44 10 81 00       	add    $0x811044,%eax
  802797:	8b 08                	mov    (%eax),%ecx
  802799:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80279c:	89 d0                	mov    %edx,%eax
  80279e:	01 c0                	add    %eax,%eax
  8027a0:	01 d0                	add    %edx,%eax
  8027a2:	c1 e0 02             	shl    $0x2,%eax
  8027a5:	05 44 10 81 00       	add    $0x811044,%eax
  8027aa:	8b 00                	mov    (%eax),%eax
  8027ac:	01 c1                	add    %eax,%ecx
  8027ae:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027b1:	89 d0                	mov    %edx,%eax
  8027b3:	01 c0                	add    %eax,%eax
  8027b5:	01 d0                	add    %edx,%eax
  8027b7:	c1 e0 02             	shl    $0x2,%eax
  8027ba:	05 44 10 81 00       	add    $0x811044,%eax
  8027bf:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  8027c1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027c4:	89 d0                	mov    %edx,%eax
  8027c6:	01 c0                	add    %eax,%eax
  8027c8:	01 d0                	add    %edx,%eax
  8027ca:	c1 e0 02             	shl    $0x2,%eax
  8027cd:	05 48 10 81 00       	add    $0x811048,%eax
  8027d2:	c6 00 00             	movb   $0x0,(%eax)
  8027d5:	eb 01                	jmp    8027d8 <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  8027d7:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  8027d8:	ff 45 e0             	incl   -0x20(%ebp)
  8027db:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8027e2:	0f 8e 7f fe ff ff    	jle    802667 <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  8027e8:	a1 30 51 83 00       	mov    0x835130,%eax
  8027ed:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  8027f0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8027f7:	eb 53                	jmp    80284c <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  8027f9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8027fc:	89 d0                	mov    %edx,%eax
  8027fe:	01 c0                	add    %eax,%eax
  802800:	01 d0                	add    %edx,%eax
  802802:	c1 e0 02             	shl    $0x2,%eax
  802805:	05 48 50 80 00       	add    $0x805048,%eax
  80280a:	8a 00                	mov    (%eax),%al
  80280c:	84 c0                	test   %al,%al
  80280e:	74 39                	je     802849 <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802810:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802813:	89 d0                	mov    %edx,%eax
  802815:	01 c0                	add    %eax,%eax
  802817:	01 d0                	add    %edx,%eax
  802819:	c1 e0 02             	shl    $0x2,%eax
  80281c:	05 40 50 80 00       	add    $0x805040,%eax
  802821:	8b 08                	mov    (%eax),%ecx
  802823:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802826:	89 d0                	mov    %edx,%eax
  802828:	01 c0                	add    %eax,%eax
  80282a:	01 d0                	add    %edx,%eax
  80282c:	c1 e0 02             	shl    $0x2,%eax
  80282f:	05 44 50 80 00       	add    $0x805044,%eax
  802834:	8b 00                	mov    (%eax),%eax
  802836:	01 c8                	add    %ecx,%eax
  802838:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  80283b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80283e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802841:	76 06                	jbe    802849 <realloc+0x453>
  802843:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802846:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802849:	ff 45 d8             	incl   -0x28(%ebp)
  80284c:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  802853:	7e a4                	jle    8027f9 <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  802855:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802858:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  80285d:	8b 45 08             	mov    0x8(%ebp),%eax
  802860:	e9 a9 01 00 00       	jmp    802a0e <realloc+0x618>
	}
	uint32 end = va + oldsz;
  802865:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802868:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286b:	01 d0                	add    %edx,%eax
  80286d:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  802870:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802877:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  80287e:	eb 57                	jmp    8028d7 <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  802880:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802883:	89 d0                	mov    %edx,%eax
  802885:	01 c0                	add    %eax,%eax
  802887:	01 d0                	add    %edx,%eax
  802889:	c1 e0 02             	shl    $0x2,%eax
  80288c:	05 48 10 81 00       	add    $0x811048,%eax
  802891:	8a 00                	mov    (%eax),%al
  802893:	84 c0                	test   %al,%al
  802895:	74 3d                	je     8028d4 <realloc+0x4de>
  802897:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80289a:	89 d0                	mov    %edx,%eax
  80289c:	01 c0                	add    %eax,%eax
  80289e:	01 d0                	add    %edx,%eax
  8028a0:	c1 e0 02             	shl    $0x2,%eax
  8028a3:	05 40 10 81 00       	add    $0x811040,%eax
  8028a8:	8b 00                	mov    (%eax),%eax
  8028aa:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028ad:	75 25                	jne    8028d4 <realloc+0x4de>
  8028af:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8028b2:	89 d0                	mov    %edx,%eax
  8028b4:	01 c0                	add    %eax,%eax
  8028b6:	01 d0                	add    %edx,%eax
  8028b8:	c1 e0 02             	shl    $0x2,%eax
  8028bb:	05 44 10 81 00       	add    $0x811044,%eax
  8028c0:	8b 10                	mov    (%eax),%edx
  8028c2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8028c5:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8028c8:	39 c2                	cmp    %eax,%edx
  8028ca:	72 08                	jb     8028d4 <realloc+0x4de>
		{
			adjIdx = j; break;
  8028cc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028cf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8028d2:	eb 0c                	jmp    8028e0 <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8028d4:	ff 45 d0             	incl   -0x30(%ebp)
  8028d7:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  8028de:	7e a0                	jle    802880 <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  8028e0:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  8028e4:	0f 84 d6 00 00 00    	je     8029c0 <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  8028ea:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8028ed:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8028f0:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  8028f3:	83 ec 08             	sub    $0x8,%esp
  8028f6:	ff 75 a0             	pushl  -0x60(%ebp)
  8028f9:	ff 75 a4             	pushl  -0x5c(%ebp)
  8028fc:	e8 cf 09 00 00       	call   8032d0 <sys_allocate_user_mem>
  802901:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  802904:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802907:	89 d0                	mov    %edx,%eax
  802909:	01 c0                	add    %eax,%eax
  80290b:	01 d0                	add    %edx,%eax
  80290d:	c1 e0 02             	shl    $0x2,%eax
  802910:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802916:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802919:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  80291b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80291e:	89 d0                	mov    %edx,%eax
  802920:	01 c0                	add    %eax,%eax
  802922:	01 d0                	add    %edx,%eax
  802924:	c1 e0 02             	shl    $0x2,%eax
  802927:	05 40 10 81 00       	add    $0x811040,%eax
  80292c:	8b 10                	mov    (%eax),%edx
  80292e:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802931:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802934:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802937:	89 d0                	mov    %edx,%eax
  802939:	01 c0                	add    %eax,%eax
  80293b:	01 d0                	add    %edx,%eax
  80293d:	c1 e0 02             	shl    $0x2,%eax
  802940:	05 40 10 81 00       	add    $0x811040,%eax
  802945:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  802947:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80294a:	89 d0                	mov    %edx,%eax
  80294c:	01 c0                	add    %eax,%eax
  80294e:	01 d0                	add    %edx,%eax
  802950:	c1 e0 02             	shl    $0x2,%eax
  802953:	05 44 10 81 00       	add    $0x811044,%eax
  802958:	8b 00                	mov    (%eax),%eax
  80295a:	2b 45 a0             	sub    -0x60(%ebp),%eax
  80295d:	89 c2                	mov    %eax,%edx
  80295f:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  802962:	89 c8                	mov    %ecx,%eax
  802964:	01 c0                	add    %eax,%eax
  802966:	01 c8                	add    %ecx,%eax
  802968:	c1 e0 02             	shl    $0x2,%eax
  80296b:	05 44 10 81 00       	add    $0x811044,%eax
  802970:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  802972:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802975:	89 d0                	mov    %edx,%eax
  802977:	01 c0                	add    %eax,%eax
  802979:	01 d0                	add    %edx,%eax
  80297b:	c1 e0 02             	shl    $0x2,%eax
  80297e:	05 44 10 81 00       	add    $0x811044,%eax
  802983:	8b 00                	mov    (%eax),%eax
  802985:	85 c0                	test   %eax,%eax
  802987:	75 14                	jne    80299d <realloc+0x5a7>
  802989:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80298c:	89 d0                	mov    %edx,%eax
  80298e:	01 c0                	add    %eax,%eax
  802990:	01 d0                	add    %edx,%eax
  802992:	c1 e0 02             	shl    $0x2,%eax
  802995:	05 48 10 81 00       	add    $0x811048,%eax
  80299a:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  80299d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029a0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8029a3:	01 c2                	add    %eax,%edx
  8029a5:	a1 88 50 83 00       	mov    0x835088,%eax
  8029aa:	39 c2                	cmp    %eax,%edx
  8029ac:	76 0d                	jbe    8029bb <realloc+0x5c5>
  8029ae:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029b1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8029b4:	01 d0                	add    %edx,%eax
  8029b6:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  8029bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029be:	eb 4e                	jmp    802a0e <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  8029c0:	83 ec 0c             	sub    $0xc,%esp
  8029c3:	ff 75 0c             	pushl  0xc(%ebp)
  8029c6:	e8 0b ec ff ff       	call   8015d6 <malloc>
  8029cb:	83 c4 10             	add    $0x10,%esp
  8029ce:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  8029d1:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  8029d5:	75 07                	jne    8029de <realloc+0x5e8>
		return NULL;
  8029d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8029dc:	eb 30                	jmp    802a0e <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  8029de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029e1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8029e4:	39 d0                	cmp    %edx,%eax
  8029e6:	76 02                	jbe    8029ea <realloc+0x5f4>
  8029e8:	89 d0                	mov    %edx,%eax
  8029ea:	8b 55 9c             	mov    -0x64(%ebp),%edx
  8029ed:	83 ec 04             	sub    $0x4,%esp
  8029f0:	50                   	push   %eax
  8029f1:	52                   	push   %edx
  8029f2:	ff 75 cc             	pushl  -0x34(%ebp)
  8029f5:	e8 cf 06 00 00       	call   8030c9 <sys_move_user_mem>
  8029fa:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  8029fd:	83 ec 0c             	sub    $0xc,%esp
  802a00:	ff 75 08             	pushl  0x8(%ebp)
  802a03:	e8 2e ef ff ff       	call   801936 <free>
  802a08:	83 c4 10             	add    $0x10,%esp
	return newptr;
  802a0b:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  802a0e:	c9                   	leave  
  802a0f:	c3                   	ret    

00802a10 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802a10:	55                   	push   %ebp
  802a11:	89 e5                	mov    %esp,%ebp
  802a13:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  802a16:	8b 45 08             	mov    0x8(%ebp),%eax
  802a19:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  802a1c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802a20:	0f 84 33 03 00 00    	je     802d59 <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  802a26:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a29:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  802a2e:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  802a31:	83 ec 08             	sub    $0x8,%esp
  802a34:	ff 75 08             	pushl  0x8(%ebp)
  802a37:	ff 75 d8             	pushl  -0x28(%ebp)
  802a3a:	e8 7d 05 00 00       	call   802fbc <sys_delete_shared_object>
  802a3f:	83 c4 10             	add    $0x10,%esp
  802a42:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  802a45:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802a49:	0f 88 0d 03 00 00    	js     802d5c <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802a4f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802a56:	e9 ef 02 00 00       	jmp    802d4a <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802a5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a5e:	89 d0                	mov    %edx,%eax
  802a60:	01 c0                	add    %eax,%eax
  802a62:	01 d0                	add    %edx,%eax
  802a64:	c1 e0 02             	shl    $0x2,%eax
  802a67:	05 48 50 80 00       	add    $0x805048,%eax
  802a6c:	8a 00                	mov    (%eax),%al
  802a6e:	84 c0                	test   %al,%al
  802a70:	0f 84 d1 02 00 00    	je     802d47 <sfree+0x337>
  802a76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a79:	89 d0                	mov    %edx,%eax
  802a7b:	01 c0                	add    %eax,%eax
  802a7d:	01 d0                	add    %edx,%eax
  802a7f:	c1 e0 02             	shl    $0x2,%eax
  802a82:	05 40 50 80 00       	add    $0x805040,%eax
  802a87:	8b 00                	mov    (%eax),%eax
  802a89:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802a8c:	0f 85 b5 02 00 00    	jne    802d47 <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  802a92:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a95:	89 d0                	mov    %edx,%eax
  802a97:	01 c0                	add    %eax,%eax
  802a99:	01 d0                	add    %edx,%eax
  802a9b:	c1 e0 02             	shl    $0x2,%eax
  802a9e:	05 44 50 80 00       	add    $0x805044,%eax
  802aa3:	8b 00                	mov    (%eax),%eax
  802aa5:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  802aa8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aab:	89 d0                	mov    %edx,%eax
  802aad:	01 c0                	add    %eax,%eax
  802aaf:	01 d0                	add    %edx,%eax
  802ab1:	c1 e0 02             	shl    $0x2,%eax
  802ab4:	05 48 50 80 00       	add    $0x805048,%eax
  802ab9:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  802abc:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802ac3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802aca:	eb 64                	jmp    802b30 <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  802acc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802acf:	89 d0                	mov    %edx,%eax
  802ad1:	01 c0                	add    %eax,%eax
  802ad3:	01 d0                	add    %edx,%eax
  802ad5:	c1 e0 02             	shl    $0x2,%eax
  802ad8:	05 48 10 81 00       	add    $0x811048,%eax
  802add:	8a 00                	mov    (%eax),%al
  802adf:	84 c0                	test   %al,%al
  802ae1:	75 4a                	jne    802b2d <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  802ae3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ae6:	89 d0                	mov    %edx,%eax
  802ae8:	01 c0                	add    %eax,%eax
  802aea:	01 d0                	add    %edx,%eax
  802aec:	c1 e0 02             	shl    $0x2,%eax
  802aef:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  802af5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802af8:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  802afa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802afd:	89 d0                	mov    %edx,%eax
  802aff:	01 c0                	add    %eax,%eax
  802b01:	01 d0                	add    %edx,%eax
  802b03:	c1 e0 02             	shl    $0x2,%eax
  802b06:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  802b0c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802b0f:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  802b11:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b14:	89 d0                	mov    %edx,%eax
  802b16:	01 c0                	add    %eax,%eax
  802b18:	01 d0                	add    %edx,%eax
  802b1a:	c1 e0 02             	shl    $0x2,%eax
  802b1d:	05 48 10 81 00       	add    $0x811048,%eax
  802b22:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  802b25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b28:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  802b2b:	eb 0c                	jmp    802b39 <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802b2d:	ff 45 ec             	incl   -0x14(%ebp)
  802b30:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802b37:	7e 93                	jle    802acc <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  802b39:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802b3d:	0f 84 8d 01 00 00    	je     802cd0 <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802b43:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802b4a:	e9 74 01 00 00       	jmp    802cc3 <sfree+0x2b3>
				{
					if (k == fidx) continue;
  802b4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b52:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802b55:	0f 84 64 01 00 00    	je     802cbf <sfree+0x2af>
					if (uhp_frees[k].free)
  802b5b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b5e:	89 d0                	mov    %edx,%eax
  802b60:	01 c0                	add    %eax,%eax
  802b62:	01 d0                	add    %edx,%eax
  802b64:	c1 e0 02             	shl    $0x2,%eax
  802b67:	05 48 10 81 00       	add    $0x811048,%eax
  802b6c:	8a 00                	mov    (%eax),%al
  802b6e:	84 c0                	test   %al,%al
  802b70:	0f 84 4a 01 00 00    	je     802cc0 <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802b76:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b79:	89 d0                	mov    %edx,%eax
  802b7b:	01 c0                	add    %eax,%eax
  802b7d:	01 d0                	add    %edx,%eax
  802b7f:	c1 e0 02             	shl    $0x2,%eax
  802b82:	05 40 10 81 00       	add    $0x811040,%eax
  802b87:	8b 08                	mov    (%eax),%ecx
  802b89:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b8c:	89 d0                	mov    %edx,%eax
  802b8e:	01 c0                	add    %eax,%eax
  802b90:	01 d0                	add    %edx,%eax
  802b92:	c1 e0 02             	shl    $0x2,%eax
  802b95:	05 44 10 81 00       	add    $0x811044,%eax
  802b9a:	8b 00                	mov    (%eax),%eax
  802b9c:	01 c1                	add    %eax,%ecx
  802b9e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ba1:	89 d0                	mov    %edx,%eax
  802ba3:	01 c0                	add    %eax,%eax
  802ba5:	01 d0                	add    %edx,%eax
  802ba7:	c1 e0 02             	shl    $0x2,%eax
  802baa:	05 40 10 81 00       	add    $0x811040,%eax
  802baf:	8b 00                	mov    (%eax),%eax
  802bb1:	39 c1                	cmp    %eax,%ecx
  802bb3:	75 7a                	jne    802c2f <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  802bb5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bb8:	89 d0                	mov    %edx,%eax
  802bba:	01 c0                	add    %eax,%eax
  802bbc:	01 d0                	add    %edx,%eax
  802bbe:	c1 e0 02             	shl    $0x2,%eax
  802bc1:	05 40 10 81 00       	add    $0x811040,%eax
  802bc6:	8b 10                	mov    (%eax),%edx
  802bc8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802bcb:	89 c8                	mov    %ecx,%eax
  802bcd:	01 c0                	add    %eax,%eax
  802bcf:	01 c8                	add    %ecx,%eax
  802bd1:	c1 e0 02             	shl    $0x2,%eax
  802bd4:	05 40 10 81 00       	add    $0x811040,%eax
  802bd9:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  802bdb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bde:	89 d0                	mov    %edx,%eax
  802be0:	01 c0                	add    %eax,%eax
  802be2:	01 d0                	add    %edx,%eax
  802be4:	c1 e0 02             	shl    $0x2,%eax
  802be7:	05 44 10 81 00       	add    $0x811044,%eax
  802bec:	8b 08                	mov    (%eax),%ecx
  802bee:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bf1:	89 d0                	mov    %edx,%eax
  802bf3:	01 c0                	add    %eax,%eax
  802bf5:	01 d0                	add    %edx,%eax
  802bf7:	c1 e0 02             	shl    $0x2,%eax
  802bfa:	05 44 10 81 00       	add    $0x811044,%eax
  802bff:	8b 00                	mov    (%eax),%eax
  802c01:	01 c1                	add    %eax,%ecx
  802c03:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c06:	89 d0                	mov    %edx,%eax
  802c08:	01 c0                	add    %eax,%eax
  802c0a:	01 d0                	add    %edx,%eax
  802c0c:	c1 e0 02             	shl    $0x2,%eax
  802c0f:	05 44 10 81 00       	add    $0x811044,%eax
  802c14:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802c16:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c19:	89 d0                	mov    %edx,%eax
  802c1b:	01 c0                	add    %eax,%eax
  802c1d:	01 d0                	add    %edx,%eax
  802c1f:	c1 e0 02             	shl    $0x2,%eax
  802c22:	05 48 10 81 00       	add    $0x811048,%eax
  802c27:	c6 00 00             	movb   $0x0,(%eax)
  802c2a:	e9 91 00 00 00       	jmp    802cc0 <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802c2f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c32:	89 d0                	mov    %edx,%eax
  802c34:	01 c0                	add    %eax,%eax
  802c36:	01 d0                	add    %edx,%eax
  802c38:	c1 e0 02             	shl    $0x2,%eax
  802c3b:	05 40 10 81 00       	add    $0x811040,%eax
  802c40:	8b 08                	mov    (%eax),%ecx
  802c42:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c45:	89 d0                	mov    %edx,%eax
  802c47:	01 c0                	add    %eax,%eax
  802c49:	01 d0                	add    %edx,%eax
  802c4b:	c1 e0 02             	shl    $0x2,%eax
  802c4e:	05 44 10 81 00       	add    $0x811044,%eax
  802c53:	8b 00                	mov    (%eax),%eax
  802c55:	01 c1                	add    %eax,%ecx
  802c57:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c5a:	89 d0                	mov    %edx,%eax
  802c5c:	01 c0                	add    %eax,%eax
  802c5e:	01 d0                	add    %edx,%eax
  802c60:	c1 e0 02             	shl    $0x2,%eax
  802c63:	05 40 10 81 00       	add    $0x811040,%eax
  802c68:	8b 00                	mov    (%eax),%eax
  802c6a:	39 c1                	cmp    %eax,%ecx
  802c6c:	75 52                	jne    802cc0 <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  802c6e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c71:	89 d0                	mov    %edx,%eax
  802c73:	01 c0                	add    %eax,%eax
  802c75:	01 d0                	add    %edx,%eax
  802c77:	c1 e0 02             	shl    $0x2,%eax
  802c7a:	05 44 10 81 00       	add    $0x811044,%eax
  802c7f:	8b 08                	mov    (%eax),%ecx
  802c81:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c84:	89 d0                	mov    %edx,%eax
  802c86:	01 c0                	add    %eax,%eax
  802c88:	01 d0                	add    %edx,%eax
  802c8a:	c1 e0 02             	shl    $0x2,%eax
  802c8d:	05 44 10 81 00       	add    $0x811044,%eax
  802c92:	8b 00                	mov    (%eax),%eax
  802c94:	01 c1                	add    %eax,%ecx
  802c96:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c99:	89 d0                	mov    %edx,%eax
  802c9b:	01 c0                	add    %eax,%eax
  802c9d:	01 d0                	add    %edx,%eax
  802c9f:	c1 e0 02             	shl    $0x2,%eax
  802ca2:	05 44 10 81 00       	add    $0x811044,%eax
  802ca7:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802ca9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cac:	89 d0                	mov    %edx,%eax
  802cae:	01 c0                	add    %eax,%eax
  802cb0:	01 d0                	add    %edx,%eax
  802cb2:	c1 e0 02             	shl    $0x2,%eax
  802cb5:	05 48 10 81 00       	add    $0x811048,%eax
  802cba:	c6 00 00             	movb   $0x0,(%eax)
  802cbd:	eb 01                	jmp    802cc0 <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  802cbf:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802cc0:	ff 45 e8             	incl   -0x18(%ebp)
  802cc3:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802cca:	0f 8e 7f fe ff ff    	jle    802b4f <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  802cd0:	a1 30 51 83 00       	mov    0x835130,%eax
  802cd5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802cd8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802cdf:	eb 53                	jmp    802d34 <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  802ce1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ce4:	89 d0                	mov    %edx,%eax
  802ce6:	01 c0                	add    %eax,%eax
  802ce8:	01 d0                	add    %edx,%eax
  802cea:	c1 e0 02             	shl    $0x2,%eax
  802ced:	05 48 50 80 00       	add    $0x805048,%eax
  802cf2:	8a 00                	mov    (%eax),%al
  802cf4:	84 c0                	test   %al,%al
  802cf6:	74 39                	je     802d31 <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802cf8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cfb:	89 d0                	mov    %edx,%eax
  802cfd:	01 c0                	add    %eax,%eax
  802cff:	01 d0                	add    %edx,%eax
  802d01:	c1 e0 02             	shl    $0x2,%eax
  802d04:	05 40 50 80 00       	add    $0x805040,%eax
  802d09:	8b 08                	mov    (%eax),%ecx
  802d0b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d0e:	89 d0                	mov    %edx,%eax
  802d10:	01 c0                	add    %eax,%eax
  802d12:	01 d0                	add    %edx,%eax
  802d14:	c1 e0 02             	shl    $0x2,%eax
  802d17:	05 44 50 80 00       	add    $0x805044,%eax
  802d1c:	8b 00                	mov    (%eax),%eax
  802d1e:	01 c8                	add    %ecx,%eax
  802d20:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  802d23:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d26:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802d29:	76 06                	jbe    802d31 <sfree+0x321>
  802d2b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d2e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802d31:	ff 45 e0             	incl   -0x20(%ebp)
  802d34:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802d3b:	7e a4                	jle    802ce1 <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  802d3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d40:	a3 88 50 83 00       	mov    %eax,0x835088
			break;
  802d45:	eb 16                	jmp    802d5d <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802d47:	ff 45 f4             	incl   -0xc(%ebp)
  802d4a:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  802d51:	0f 8e 04 fd ff ff    	jle    802a5b <sfree+0x4b>
  802d57:	eb 04                	jmp    802d5d <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  802d59:	90                   	nop
  802d5a:	eb 01                	jmp    802d5d <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  802d5c:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  802d5d:	c9                   	leave  
  802d5e:	c3                   	ret    

00802d5f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802d5f:	55                   	push   %ebp
  802d60:	89 e5                	mov    %esp,%ebp
  802d62:	57                   	push   %edi
  802d63:	56                   	push   %esi
  802d64:	53                   	push   %ebx
  802d65:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802d68:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d6e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802d71:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802d74:	8b 7d 18             	mov    0x18(%ebp),%edi
  802d77:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802d7a:	cd 30                	int    $0x30
  802d7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802d7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802d82:	83 c4 10             	add    $0x10,%esp
  802d85:	5b                   	pop    %ebx
  802d86:	5e                   	pop    %esi
  802d87:	5f                   	pop    %edi
  802d88:	5d                   	pop    %ebp
  802d89:	c3                   	ret    

00802d8a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802d8a:	55                   	push   %ebp
  802d8b:	89 e5                	mov    %esp,%ebp
  802d8d:	83 ec 04             	sub    $0x4,%esp
  802d90:	8b 45 10             	mov    0x10(%ebp),%eax
  802d93:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802d96:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802d99:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802da0:	6a 00                	push   $0x0
  802da2:	51                   	push   %ecx
  802da3:	52                   	push   %edx
  802da4:	ff 75 0c             	pushl  0xc(%ebp)
  802da7:	50                   	push   %eax
  802da8:	6a 00                	push   $0x0
  802daa:	e8 b0 ff ff ff       	call   802d5f <syscall>
  802daf:	83 c4 18             	add    $0x18,%esp
}
  802db2:	90                   	nop
  802db3:	c9                   	leave  
  802db4:	c3                   	ret    

00802db5 <sys_cgetc>:

int
sys_cgetc(void)
{
  802db5:	55                   	push   %ebp
  802db6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802db8:	6a 00                	push   $0x0
  802dba:	6a 00                	push   $0x0
  802dbc:	6a 00                	push   $0x0
  802dbe:	6a 00                	push   $0x0
  802dc0:	6a 00                	push   $0x0
  802dc2:	6a 02                	push   $0x2
  802dc4:	e8 96 ff ff ff       	call   802d5f <syscall>
  802dc9:	83 c4 18             	add    $0x18,%esp
}
  802dcc:	c9                   	leave  
  802dcd:	c3                   	ret    

00802dce <sys_lock_cons>:

void sys_lock_cons(void)
{
  802dce:	55                   	push   %ebp
  802dcf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802dd1:	6a 00                	push   $0x0
  802dd3:	6a 00                	push   $0x0
  802dd5:	6a 00                	push   $0x0
  802dd7:	6a 00                	push   $0x0
  802dd9:	6a 00                	push   $0x0
  802ddb:	6a 03                	push   $0x3
  802ddd:	e8 7d ff ff ff       	call   802d5f <syscall>
  802de2:	83 c4 18             	add    $0x18,%esp
}
  802de5:	90                   	nop
  802de6:	c9                   	leave  
  802de7:	c3                   	ret    

00802de8 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802de8:	55                   	push   %ebp
  802de9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802deb:	6a 00                	push   $0x0
  802ded:	6a 00                	push   $0x0
  802def:	6a 00                	push   $0x0
  802df1:	6a 00                	push   $0x0
  802df3:	6a 00                	push   $0x0
  802df5:	6a 04                	push   $0x4
  802df7:	e8 63 ff ff ff       	call   802d5f <syscall>
  802dfc:	83 c4 18             	add    $0x18,%esp
}
  802dff:	90                   	nop
  802e00:	c9                   	leave  
  802e01:	c3                   	ret    

00802e02 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802e02:	55                   	push   %ebp
  802e03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802e05:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e08:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0b:	6a 00                	push   $0x0
  802e0d:	6a 00                	push   $0x0
  802e0f:	6a 00                	push   $0x0
  802e11:	52                   	push   %edx
  802e12:	50                   	push   %eax
  802e13:	6a 08                	push   $0x8
  802e15:	e8 45 ff ff ff       	call   802d5f <syscall>
  802e1a:	83 c4 18             	add    $0x18,%esp
}
  802e1d:	c9                   	leave  
  802e1e:	c3                   	ret    

00802e1f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802e1f:	55                   	push   %ebp
  802e20:	89 e5                	mov    %esp,%ebp
  802e22:	56                   	push   %esi
  802e23:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802e24:	8b 75 18             	mov    0x18(%ebp),%esi
  802e27:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802e2a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802e2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e30:	8b 45 08             	mov    0x8(%ebp),%eax
  802e33:	56                   	push   %esi
  802e34:	53                   	push   %ebx
  802e35:	51                   	push   %ecx
  802e36:	52                   	push   %edx
  802e37:	50                   	push   %eax
  802e38:	6a 09                	push   $0x9
  802e3a:	e8 20 ff ff ff       	call   802d5f <syscall>
  802e3f:	83 c4 18             	add    $0x18,%esp
}
  802e42:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802e45:	5b                   	pop    %ebx
  802e46:	5e                   	pop    %esi
  802e47:	5d                   	pop    %ebp
  802e48:	c3                   	ret    

00802e49 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802e49:	55                   	push   %ebp
  802e4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802e4c:	6a 00                	push   $0x0
  802e4e:	6a 00                	push   $0x0
  802e50:	6a 00                	push   $0x0
  802e52:	6a 00                	push   $0x0
  802e54:	ff 75 08             	pushl  0x8(%ebp)
  802e57:	6a 0a                	push   $0xa
  802e59:	e8 01 ff ff ff       	call   802d5f <syscall>
  802e5e:	83 c4 18             	add    $0x18,%esp
}
  802e61:	c9                   	leave  
  802e62:	c3                   	ret    

00802e63 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802e63:	55                   	push   %ebp
  802e64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802e66:	6a 00                	push   $0x0
  802e68:	6a 00                	push   $0x0
  802e6a:	6a 00                	push   $0x0
  802e6c:	ff 75 0c             	pushl  0xc(%ebp)
  802e6f:	ff 75 08             	pushl  0x8(%ebp)
  802e72:	6a 0b                	push   $0xb
  802e74:	e8 e6 fe ff ff       	call   802d5f <syscall>
  802e79:	83 c4 18             	add    $0x18,%esp
}
  802e7c:	c9                   	leave  
  802e7d:	c3                   	ret    

00802e7e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802e7e:	55                   	push   %ebp
  802e7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802e81:	6a 00                	push   $0x0
  802e83:	6a 00                	push   $0x0
  802e85:	6a 00                	push   $0x0
  802e87:	6a 00                	push   $0x0
  802e89:	6a 00                	push   $0x0
  802e8b:	6a 0c                	push   $0xc
  802e8d:	e8 cd fe ff ff       	call   802d5f <syscall>
  802e92:	83 c4 18             	add    $0x18,%esp
}
  802e95:	c9                   	leave  
  802e96:	c3                   	ret    

00802e97 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802e97:	55                   	push   %ebp
  802e98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802e9a:	6a 00                	push   $0x0
  802e9c:	6a 00                	push   $0x0
  802e9e:	6a 00                	push   $0x0
  802ea0:	6a 00                	push   $0x0
  802ea2:	6a 00                	push   $0x0
  802ea4:	6a 0d                	push   $0xd
  802ea6:	e8 b4 fe ff ff       	call   802d5f <syscall>
  802eab:	83 c4 18             	add    $0x18,%esp
}
  802eae:	c9                   	leave  
  802eaf:	c3                   	ret    

00802eb0 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802eb0:	55                   	push   %ebp
  802eb1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802eb3:	6a 00                	push   $0x0
  802eb5:	6a 00                	push   $0x0
  802eb7:	6a 00                	push   $0x0
  802eb9:	6a 00                	push   $0x0
  802ebb:	6a 00                	push   $0x0
  802ebd:	6a 0e                	push   $0xe
  802ebf:	e8 9b fe ff ff       	call   802d5f <syscall>
  802ec4:	83 c4 18             	add    $0x18,%esp
}
  802ec7:	c9                   	leave  
  802ec8:	c3                   	ret    

00802ec9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802ec9:	55                   	push   %ebp
  802eca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802ecc:	6a 00                	push   $0x0
  802ece:	6a 00                	push   $0x0
  802ed0:	6a 00                	push   $0x0
  802ed2:	6a 00                	push   $0x0
  802ed4:	6a 00                	push   $0x0
  802ed6:	6a 0f                	push   $0xf
  802ed8:	e8 82 fe ff ff       	call   802d5f <syscall>
  802edd:	83 c4 18             	add    $0x18,%esp
}
  802ee0:	c9                   	leave  
  802ee1:	c3                   	ret    

00802ee2 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802ee2:	55                   	push   %ebp
  802ee3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802ee5:	6a 00                	push   $0x0
  802ee7:	6a 00                	push   $0x0
  802ee9:	6a 00                	push   $0x0
  802eeb:	6a 00                	push   $0x0
  802eed:	ff 75 08             	pushl  0x8(%ebp)
  802ef0:	6a 10                	push   $0x10
  802ef2:	e8 68 fe ff ff       	call   802d5f <syscall>
  802ef7:	83 c4 18             	add    $0x18,%esp
}
  802efa:	c9                   	leave  
  802efb:	c3                   	ret    

00802efc <sys_scarce_memory>:

void sys_scarce_memory()
{
  802efc:	55                   	push   %ebp
  802efd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802eff:	6a 00                	push   $0x0
  802f01:	6a 00                	push   $0x0
  802f03:	6a 00                	push   $0x0
  802f05:	6a 00                	push   $0x0
  802f07:	6a 00                	push   $0x0
  802f09:	6a 11                	push   $0x11
  802f0b:	e8 4f fe ff ff       	call   802d5f <syscall>
  802f10:	83 c4 18             	add    $0x18,%esp
}
  802f13:	90                   	nop
  802f14:	c9                   	leave  
  802f15:	c3                   	ret    

00802f16 <sys_cputc>:

void
sys_cputc(const char c)
{
  802f16:	55                   	push   %ebp
  802f17:	89 e5                	mov    %esp,%ebp
  802f19:	83 ec 04             	sub    $0x4,%esp
  802f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802f22:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802f26:	6a 00                	push   $0x0
  802f28:	6a 00                	push   $0x0
  802f2a:	6a 00                	push   $0x0
  802f2c:	6a 00                	push   $0x0
  802f2e:	50                   	push   %eax
  802f2f:	6a 01                	push   $0x1
  802f31:	e8 29 fe ff ff       	call   802d5f <syscall>
  802f36:	83 c4 18             	add    $0x18,%esp
}
  802f39:	90                   	nop
  802f3a:	c9                   	leave  
  802f3b:	c3                   	ret    

00802f3c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802f3c:	55                   	push   %ebp
  802f3d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802f3f:	6a 00                	push   $0x0
  802f41:	6a 00                	push   $0x0
  802f43:	6a 00                	push   $0x0
  802f45:	6a 00                	push   $0x0
  802f47:	6a 00                	push   $0x0
  802f49:	6a 14                	push   $0x14
  802f4b:	e8 0f fe ff ff       	call   802d5f <syscall>
  802f50:	83 c4 18             	add    $0x18,%esp
}
  802f53:	90                   	nop
  802f54:	c9                   	leave  
  802f55:	c3                   	ret    

00802f56 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802f56:	55                   	push   %ebp
  802f57:	89 e5                	mov    %esp,%ebp
  802f59:	83 ec 04             	sub    $0x4,%esp
  802f5c:	8b 45 10             	mov    0x10(%ebp),%eax
  802f5f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802f62:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802f65:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802f69:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6c:	6a 00                	push   $0x0
  802f6e:	51                   	push   %ecx
  802f6f:	52                   	push   %edx
  802f70:	ff 75 0c             	pushl  0xc(%ebp)
  802f73:	50                   	push   %eax
  802f74:	6a 15                	push   $0x15
  802f76:	e8 e4 fd ff ff       	call   802d5f <syscall>
  802f7b:	83 c4 18             	add    $0x18,%esp
}
  802f7e:	c9                   	leave  
  802f7f:	c3                   	ret    

00802f80 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802f80:	55                   	push   %ebp
  802f81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802f83:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f86:	8b 45 08             	mov    0x8(%ebp),%eax
  802f89:	6a 00                	push   $0x0
  802f8b:	6a 00                	push   $0x0
  802f8d:	6a 00                	push   $0x0
  802f8f:	52                   	push   %edx
  802f90:	50                   	push   %eax
  802f91:	6a 16                	push   $0x16
  802f93:	e8 c7 fd ff ff       	call   802d5f <syscall>
  802f98:	83 c4 18             	add    $0x18,%esp
}
  802f9b:	c9                   	leave  
  802f9c:	c3                   	ret    

00802f9d <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802f9d:	55                   	push   %ebp
  802f9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802fa0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802fa3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa9:	6a 00                	push   $0x0
  802fab:	6a 00                	push   $0x0
  802fad:	51                   	push   %ecx
  802fae:	52                   	push   %edx
  802faf:	50                   	push   %eax
  802fb0:	6a 17                	push   $0x17
  802fb2:	e8 a8 fd ff ff       	call   802d5f <syscall>
  802fb7:	83 c4 18             	add    $0x18,%esp
}
  802fba:	c9                   	leave  
  802fbb:	c3                   	ret    

00802fbc <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802fbc:	55                   	push   %ebp
  802fbd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802fbf:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc5:	6a 00                	push   $0x0
  802fc7:	6a 00                	push   $0x0
  802fc9:	6a 00                	push   $0x0
  802fcb:	52                   	push   %edx
  802fcc:	50                   	push   %eax
  802fcd:	6a 18                	push   $0x18
  802fcf:	e8 8b fd ff ff       	call   802d5f <syscall>
  802fd4:	83 c4 18             	add    $0x18,%esp
}
  802fd7:	c9                   	leave  
  802fd8:	c3                   	ret    

00802fd9 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802fd9:	55                   	push   %ebp
  802fda:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdf:	6a 00                	push   $0x0
  802fe1:	ff 75 14             	pushl  0x14(%ebp)
  802fe4:	ff 75 10             	pushl  0x10(%ebp)
  802fe7:	ff 75 0c             	pushl  0xc(%ebp)
  802fea:	50                   	push   %eax
  802feb:	6a 19                	push   $0x19
  802fed:	e8 6d fd ff ff       	call   802d5f <syscall>
  802ff2:	83 c4 18             	add    $0x18,%esp
}
  802ff5:	c9                   	leave  
  802ff6:	c3                   	ret    

00802ff7 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802ff7:	55                   	push   %ebp
  802ff8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffd:	6a 00                	push   $0x0
  802fff:	6a 00                	push   $0x0
  803001:	6a 00                	push   $0x0
  803003:	6a 00                	push   $0x0
  803005:	50                   	push   %eax
  803006:	6a 1a                	push   $0x1a
  803008:	e8 52 fd ff ff       	call   802d5f <syscall>
  80300d:	83 c4 18             	add    $0x18,%esp
}
  803010:	90                   	nop
  803011:	c9                   	leave  
  803012:	c3                   	ret    

00803013 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  803013:	55                   	push   %ebp
  803014:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  803016:	8b 45 08             	mov    0x8(%ebp),%eax
  803019:	6a 00                	push   $0x0
  80301b:	6a 00                	push   $0x0
  80301d:	6a 00                	push   $0x0
  80301f:	6a 00                	push   $0x0
  803021:	50                   	push   %eax
  803022:	6a 1b                	push   $0x1b
  803024:	e8 36 fd ff ff       	call   802d5f <syscall>
  803029:	83 c4 18             	add    $0x18,%esp
}
  80302c:	c9                   	leave  
  80302d:	c3                   	ret    

0080302e <sys_getenvid>:

int32 sys_getenvid(void)
{
  80302e:	55                   	push   %ebp
  80302f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  803031:	6a 00                	push   $0x0
  803033:	6a 00                	push   $0x0
  803035:	6a 00                	push   $0x0
  803037:	6a 00                	push   $0x0
  803039:	6a 00                	push   $0x0
  80303b:	6a 05                	push   $0x5
  80303d:	e8 1d fd ff ff       	call   802d5f <syscall>
  803042:	83 c4 18             	add    $0x18,%esp
}
  803045:	c9                   	leave  
  803046:	c3                   	ret    

00803047 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  803047:	55                   	push   %ebp
  803048:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80304a:	6a 00                	push   $0x0
  80304c:	6a 00                	push   $0x0
  80304e:	6a 00                	push   $0x0
  803050:	6a 00                	push   $0x0
  803052:	6a 00                	push   $0x0
  803054:	6a 06                	push   $0x6
  803056:	e8 04 fd ff ff       	call   802d5f <syscall>
  80305b:	83 c4 18             	add    $0x18,%esp
}
  80305e:	c9                   	leave  
  80305f:	c3                   	ret    

00803060 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  803060:	55                   	push   %ebp
  803061:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  803063:	6a 00                	push   $0x0
  803065:	6a 00                	push   $0x0
  803067:	6a 00                	push   $0x0
  803069:	6a 00                	push   $0x0
  80306b:	6a 00                	push   $0x0
  80306d:	6a 07                	push   $0x7
  80306f:	e8 eb fc ff ff       	call   802d5f <syscall>
  803074:	83 c4 18             	add    $0x18,%esp
}
  803077:	c9                   	leave  
  803078:	c3                   	ret    

00803079 <sys_exit_env>:


void sys_exit_env(void)
{
  803079:	55                   	push   %ebp
  80307a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80307c:	6a 00                	push   $0x0
  80307e:	6a 00                	push   $0x0
  803080:	6a 00                	push   $0x0
  803082:	6a 00                	push   $0x0
  803084:	6a 00                	push   $0x0
  803086:	6a 1c                	push   $0x1c
  803088:	e8 d2 fc ff ff       	call   802d5f <syscall>
  80308d:	83 c4 18             	add    $0x18,%esp
}
  803090:	90                   	nop
  803091:	c9                   	leave  
  803092:	c3                   	ret    

00803093 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  803093:	55                   	push   %ebp
  803094:	89 e5                	mov    %esp,%ebp
  803096:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  803099:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80309c:	8d 50 04             	lea    0x4(%eax),%edx
  80309f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8030a2:	6a 00                	push   $0x0
  8030a4:	6a 00                	push   $0x0
  8030a6:	6a 00                	push   $0x0
  8030a8:	52                   	push   %edx
  8030a9:	50                   	push   %eax
  8030aa:	6a 1d                	push   $0x1d
  8030ac:	e8 ae fc ff ff       	call   802d5f <syscall>
  8030b1:	83 c4 18             	add    $0x18,%esp
	return result;
  8030b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8030b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8030ba:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8030bd:	89 01                	mov    %eax,(%ecx)
  8030bf:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8030c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c5:	c9                   	leave  
  8030c6:	c2 04 00             	ret    $0x4

008030c9 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8030c9:	55                   	push   %ebp
  8030ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8030cc:	6a 00                	push   $0x0
  8030ce:	6a 00                	push   $0x0
  8030d0:	ff 75 10             	pushl  0x10(%ebp)
  8030d3:	ff 75 0c             	pushl  0xc(%ebp)
  8030d6:	ff 75 08             	pushl  0x8(%ebp)
  8030d9:	6a 13                	push   $0x13
  8030db:	e8 7f fc ff ff       	call   802d5f <syscall>
  8030e0:	83 c4 18             	add    $0x18,%esp
	return ;
  8030e3:	90                   	nop
}
  8030e4:	c9                   	leave  
  8030e5:	c3                   	ret    

008030e6 <sys_rcr2>:
uint32 sys_rcr2()
{
  8030e6:	55                   	push   %ebp
  8030e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8030e9:	6a 00                	push   $0x0
  8030eb:	6a 00                	push   $0x0
  8030ed:	6a 00                	push   $0x0
  8030ef:	6a 00                	push   $0x0
  8030f1:	6a 00                	push   $0x0
  8030f3:	6a 1e                	push   $0x1e
  8030f5:	e8 65 fc ff ff       	call   802d5f <syscall>
  8030fa:	83 c4 18             	add    $0x18,%esp
}
  8030fd:	c9                   	leave  
  8030fe:	c3                   	ret    

008030ff <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8030ff:	55                   	push   %ebp
  803100:	89 e5                	mov    %esp,%ebp
  803102:	83 ec 04             	sub    $0x4,%esp
  803105:	8b 45 08             	mov    0x8(%ebp),%eax
  803108:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80310b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80310f:	6a 00                	push   $0x0
  803111:	6a 00                	push   $0x0
  803113:	6a 00                	push   $0x0
  803115:	6a 00                	push   $0x0
  803117:	50                   	push   %eax
  803118:	6a 1f                	push   $0x1f
  80311a:	e8 40 fc ff ff       	call   802d5f <syscall>
  80311f:	83 c4 18             	add    $0x18,%esp
	return ;
  803122:	90                   	nop
}
  803123:	c9                   	leave  
  803124:	c3                   	ret    

00803125 <rsttst>:
void rsttst()
{
  803125:	55                   	push   %ebp
  803126:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803128:	6a 00                	push   $0x0
  80312a:	6a 00                	push   $0x0
  80312c:	6a 00                	push   $0x0
  80312e:	6a 00                	push   $0x0
  803130:	6a 00                	push   $0x0
  803132:	6a 21                	push   $0x21
  803134:	e8 26 fc ff ff       	call   802d5f <syscall>
  803139:	83 c4 18             	add    $0x18,%esp
	return ;
  80313c:	90                   	nop
}
  80313d:	c9                   	leave  
  80313e:	c3                   	ret    

0080313f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80313f:	55                   	push   %ebp
  803140:	89 e5                	mov    %esp,%ebp
  803142:	83 ec 04             	sub    $0x4,%esp
  803145:	8b 45 14             	mov    0x14(%ebp),%eax
  803148:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80314b:	8b 55 18             	mov    0x18(%ebp),%edx
  80314e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803152:	52                   	push   %edx
  803153:	50                   	push   %eax
  803154:	ff 75 10             	pushl  0x10(%ebp)
  803157:	ff 75 0c             	pushl  0xc(%ebp)
  80315a:	ff 75 08             	pushl  0x8(%ebp)
  80315d:	6a 20                	push   $0x20
  80315f:	e8 fb fb ff ff       	call   802d5f <syscall>
  803164:	83 c4 18             	add    $0x18,%esp
	return ;
  803167:	90                   	nop
}
  803168:	c9                   	leave  
  803169:	c3                   	ret    

0080316a <chktst>:
void chktst(uint32 n)
{
  80316a:	55                   	push   %ebp
  80316b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80316d:	6a 00                	push   $0x0
  80316f:	6a 00                	push   $0x0
  803171:	6a 00                	push   $0x0
  803173:	6a 00                	push   $0x0
  803175:	ff 75 08             	pushl  0x8(%ebp)
  803178:	6a 22                	push   $0x22
  80317a:	e8 e0 fb ff ff       	call   802d5f <syscall>
  80317f:	83 c4 18             	add    $0x18,%esp
	return ;
  803182:	90                   	nop
}
  803183:	c9                   	leave  
  803184:	c3                   	ret    

00803185 <inctst>:

void inctst()
{
  803185:	55                   	push   %ebp
  803186:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803188:	6a 00                	push   $0x0
  80318a:	6a 00                	push   $0x0
  80318c:	6a 00                	push   $0x0
  80318e:	6a 00                	push   $0x0
  803190:	6a 00                	push   $0x0
  803192:	6a 23                	push   $0x23
  803194:	e8 c6 fb ff ff       	call   802d5f <syscall>
  803199:	83 c4 18             	add    $0x18,%esp
	return ;
  80319c:	90                   	nop
}
  80319d:	c9                   	leave  
  80319e:	c3                   	ret    

0080319f <gettst>:
uint32 gettst()
{
  80319f:	55                   	push   %ebp
  8031a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8031a2:	6a 00                	push   $0x0
  8031a4:	6a 00                	push   $0x0
  8031a6:	6a 00                	push   $0x0
  8031a8:	6a 00                	push   $0x0
  8031aa:	6a 00                	push   $0x0
  8031ac:	6a 24                	push   $0x24
  8031ae:	e8 ac fb ff ff       	call   802d5f <syscall>
  8031b3:	83 c4 18             	add    $0x18,%esp
}
  8031b6:	c9                   	leave  
  8031b7:	c3                   	ret    

008031b8 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8031b8:	55                   	push   %ebp
  8031b9:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8031bb:	6a 00                	push   $0x0
  8031bd:	6a 00                	push   $0x0
  8031bf:	6a 00                	push   $0x0
  8031c1:	6a 00                	push   $0x0
  8031c3:	6a 00                	push   $0x0
  8031c5:	6a 25                	push   $0x25
  8031c7:	e8 93 fb ff ff       	call   802d5f <syscall>
  8031cc:	83 c4 18             	add    $0x18,%esp
  8031cf:	a3 80 50 83 00       	mov    %eax,0x835080
	return uheapPlaceStrategy ;
  8031d4:	a1 80 50 83 00       	mov    0x835080,%eax
}
  8031d9:	c9                   	leave  
  8031da:	c3                   	ret    

008031db <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8031db:	55                   	push   %ebp
  8031dc:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8031de:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e1:	a3 80 50 83 00       	mov    %eax,0x835080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8031e6:	6a 00                	push   $0x0
  8031e8:	6a 00                	push   $0x0
  8031ea:	6a 00                	push   $0x0
  8031ec:	6a 00                	push   $0x0
  8031ee:	ff 75 08             	pushl  0x8(%ebp)
  8031f1:	6a 26                	push   $0x26
  8031f3:	e8 67 fb ff ff       	call   802d5f <syscall>
  8031f8:	83 c4 18             	add    $0x18,%esp
	return ;
  8031fb:	90                   	nop
}
  8031fc:	c9                   	leave  
  8031fd:	c3                   	ret    

008031fe <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8031fe:	55                   	push   %ebp
  8031ff:	89 e5                	mov    %esp,%ebp
  803201:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  803202:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803205:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803208:	8b 55 0c             	mov    0xc(%ebp),%edx
  80320b:	8b 45 08             	mov    0x8(%ebp),%eax
  80320e:	6a 00                	push   $0x0
  803210:	53                   	push   %ebx
  803211:	51                   	push   %ecx
  803212:	52                   	push   %edx
  803213:	50                   	push   %eax
  803214:	6a 27                	push   $0x27
  803216:	e8 44 fb ff ff       	call   802d5f <syscall>
  80321b:	83 c4 18             	add    $0x18,%esp
}
  80321e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803221:	c9                   	leave  
  803222:	c3                   	ret    

00803223 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803223:	55                   	push   %ebp
  803224:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803226:	8b 55 0c             	mov    0xc(%ebp),%edx
  803229:	8b 45 08             	mov    0x8(%ebp),%eax
  80322c:	6a 00                	push   $0x0
  80322e:	6a 00                	push   $0x0
  803230:	6a 00                	push   $0x0
  803232:	52                   	push   %edx
  803233:	50                   	push   %eax
  803234:	6a 28                	push   $0x28
  803236:	e8 24 fb ff ff       	call   802d5f <syscall>
  80323b:	83 c4 18             	add    $0x18,%esp
}
  80323e:	c9                   	leave  
  80323f:	c3                   	ret    

00803240 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  803240:	55                   	push   %ebp
  803241:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  803243:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803246:	8b 55 0c             	mov    0xc(%ebp),%edx
  803249:	8b 45 08             	mov    0x8(%ebp),%eax
  80324c:	6a 00                	push   $0x0
  80324e:	51                   	push   %ecx
  80324f:	ff 75 10             	pushl  0x10(%ebp)
  803252:	52                   	push   %edx
  803253:	50                   	push   %eax
  803254:	6a 29                	push   $0x29
  803256:	e8 04 fb ff ff       	call   802d5f <syscall>
  80325b:	83 c4 18             	add    $0x18,%esp
}
  80325e:	c9                   	leave  
  80325f:	c3                   	ret    

00803260 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  803260:	55                   	push   %ebp
  803261:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803263:	6a 00                	push   $0x0
  803265:	6a 00                	push   $0x0
  803267:	ff 75 10             	pushl  0x10(%ebp)
  80326a:	ff 75 0c             	pushl  0xc(%ebp)
  80326d:	ff 75 08             	pushl  0x8(%ebp)
  803270:	6a 12                	push   $0x12
  803272:	e8 e8 fa ff ff       	call   802d5f <syscall>
  803277:	83 c4 18             	add    $0x18,%esp
	return ;
  80327a:	90                   	nop
}
  80327b:	c9                   	leave  
  80327c:	c3                   	ret    

0080327d <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80327d:	55                   	push   %ebp
  80327e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  803280:	8b 55 0c             	mov    0xc(%ebp),%edx
  803283:	8b 45 08             	mov    0x8(%ebp),%eax
  803286:	6a 00                	push   $0x0
  803288:	6a 00                	push   $0x0
  80328a:	6a 00                	push   $0x0
  80328c:	52                   	push   %edx
  80328d:	50                   	push   %eax
  80328e:	6a 2a                	push   $0x2a
  803290:	e8 ca fa ff ff       	call   802d5f <syscall>
  803295:	83 c4 18             	add    $0x18,%esp
	return;
  803298:	90                   	nop
}
  803299:	c9                   	leave  
  80329a:	c3                   	ret    

0080329b <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80329b:	55                   	push   %ebp
  80329c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80329e:	6a 00                	push   $0x0
  8032a0:	6a 00                	push   $0x0
  8032a2:	6a 00                	push   $0x0
  8032a4:	6a 00                	push   $0x0
  8032a6:	6a 00                	push   $0x0
  8032a8:	6a 2b                	push   $0x2b
  8032aa:	e8 b0 fa ff ff       	call   802d5f <syscall>
  8032af:	83 c4 18             	add    $0x18,%esp
}
  8032b2:	c9                   	leave  
  8032b3:	c3                   	ret    

008032b4 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8032b4:	55                   	push   %ebp
  8032b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8032b7:	6a 00                	push   $0x0
  8032b9:	6a 00                	push   $0x0
  8032bb:	6a 00                	push   $0x0
  8032bd:	ff 75 0c             	pushl  0xc(%ebp)
  8032c0:	ff 75 08             	pushl  0x8(%ebp)
  8032c3:	6a 2d                	push   $0x2d
  8032c5:	e8 95 fa ff ff       	call   802d5f <syscall>
  8032ca:	83 c4 18             	add    $0x18,%esp
	return;
  8032cd:	90                   	nop
}
  8032ce:	c9                   	leave  
  8032cf:	c3                   	ret    

008032d0 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8032d0:	55                   	push   %ebp
  8032d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8032d3:	6a 00                	push   $0x0
  8032d5:	6a 00                	push   $0x0
  8032d7:	6a 00                	push   $0x0
  8032d9:	ff 75 0c             	pushl  0xc(%ebp)
  8032dc:	ff 75 08             	pushl  0x8(%ebp)
  8032df:	6a 2c                	push   $0x2c
  8032e1:	e8 79 fa ff ff       	call   802d5f <syscall>
  8032e6:	83 c4 18             	add    $0x18,%esp
	return ;
  8032e9:	90                   	nop
}
  8032ea:	c9                   	leave  
  8032eb:	c3                   	ret    

008032ec <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8032ec:	55                   	push   %ebp
  8032ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8032ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f5:	6a 00                	push   $0x0
  8032f7:	6a 00                	push   $0x0
  8032f9:	6a 00                	push   $0x0
  8032fb:	52                   	push   %edx
  8032fc:	50                   	push   %eax
  8032fd:	6a 2e                	push   $0x2e
  8032ff:	e8 5b fa ff ff       	call   802d5f <syscall>
  803304:	83 c4 18             	add    $0x18,%esp
}
  803307:	90                   	nop
  803308:	c9                   	leave  
  803309:	c3                   	ret    

0080330a <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  80330a:	55                   	push   %ebp
  80330b:	89 e5                	mov    %esp,%ebp
  80330d:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  803310:	81 7d 08 80 d0 81 00 	cmpl   $0x81d080,0x8(%ebp)
  803317:	72 09                	jb     803322 <to_page_va+0x18>
  803319:	81 7d 08 80 50 83 00 	cmpl   $0x835080,0x8(%ebp)
  803320:	72 14                	jb     803336 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  803322:	83 ec 04             	sub    $0x4,%esp
  803325:	68 38 49 80 00       	push   $0x804938
  80332a:	6a 15                	push   $0x15
  80332c:	68 63 49 80 00       	push   $0x804963
  803331:	e8 10 d0 ff ff       	call   800346 <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803336:	8b 45 08             	mov    0x8(%ebp),%eax
  803339:	ba 80 d0 81 00       	mov    $0x81d080,%edx
  80333e:	29 d0                	sub    %edx,%eax
  803340:	c1 f8 02             	sar    $0x2,%eax
  803343:	89 c2                	mov    %eax,%edx
  803345:	89 d0                	mov    %edx,%eax
  803347:	c1 e0 02             	shl    $0x2,%eax
  80334a:	01 d0                	add    %edx,%eax
  80334c:	c1 e0 02             	shl    $0x2,%eax
  80334f:	01 d0                	add    %edx,%eax
  803351:	c1 e0 02             	shl    $0x2,%eax
  803354:	01 d0                	add    %edx,%eax
  803356:	89 c1                	mov    %eax,%ecx
  803358:	c1 e1 08             	shl    $0x8,%ecx
  80335b:	01 c8                	add    %ecx,%eax
  80335d:	89 c1                	mov    %eax,%ecx
  80335f:	c1 e1 10             	shl    $0x10,%ecx
  803362:	01 c8                	add    %ecx,%eax
  803364:	01 c0                	add    %eax,%eax
  803366:	01 d0                	add    %edx,%eax
  803368:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  80336b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336e:	c1 e0 0c             	shl    $0xc,%eax
  803371:	89 c2                	mov    %eax,%edx
  803373:	a1 84 50 83 00       	mov    0x835084,%eax
  803378:	01 d0                	add    %edx,%eax
}
  80337a:	c9                   	leave  
  80337b:	c3                   	ret    

0080337c <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  80337c:	55                   	push   %ebp
  80337d:	89 e5                	mov    %esp,%ebp
  80337f:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  803382:	a1 84 50 83 00       	mov    0x835084,%eax
  803387:	8b 55 08             	mov    0x8(%ebp),%edx
  80338a:	29 c2                	sub    %eax,%edx
  80338c:	89 d0                	mov    %edx,%eax
  80338e:	c1 e8 0c             	shr    $0xc,%eax
  803391:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  803394:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803398:	78 09                	js     8033a3 <to_page_info+0x27>
  80339a:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  8033a1:	7e 14                	jle    8033b7 <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  8033a3:	83 ec 04             	sub    $0x4,%esp
  8033a6:	68 7c 49 80 00       	push   $0x80497c
  8033ab:	6a 21                	push   $0x21
  8033ad:	68 63 49 80 00       	push   $0x804963
  8033b2:	e8 8f cf ff ff       	call   800346 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  8033b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033ba:	89 d0                	mov    %edx,%eax
  8033bc:	01 c0                	add    %eax,%eax
  8033be:	01 d0                	add    %edx,%eax
  8033c0:	c1 e0 02             	shl    $0x2,%eax
  8033c3:	05 80 d0 81 00       	add    $0x81d080,%eax
}
  8033c8:	c9                   	leave  
  8033c9:	c3                   	ret    

008033ca <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8033ca:	55                   	push   %ebp
  8033cb:	89 e5                	mov    %esp,%ebp
  8033cd:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8033d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d3:	05 00 00 00 02       	add    $0x2000000,%eax
  8033d8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8033db:	73 16                	jae    8033f3 <initialize_dynamic_allocator+0x29>
  8033dd:	68 a0 49 80 00       	push   $0x8049a0
  8033e2:	68 c6 49 80 00       	push   $0x8049c6
  8033e7:	6a 2f                	push   $0x2f
  8033e9:	68 63 49 80 00       	push   $0x804963
  8033ee:	e8 53 cf ff ff       	call   800346 <_panic>
	dynAllocStart = daStart;
  8033f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f6:	a3 84 50 83 00       	mov    %eax,0x835084
	dynAllocEnd = daEnd;
  8033fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033fe:	a3 60 d0 81 00       	mov    %eax,0x81d060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803403:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80340a:	eb 36                	jmp    803442 <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  80340c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80340f:	c1 e0 04             	shl    $0x4,%eax
  803412:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803417:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80341d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803420:	c1 e0 04             	shl    $0x4,%eax
  803423:	05 a4 50 83 00       	add    $0x8350a4,%eax
  803428:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80342e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803431:	c1 e0 04             	shl    $0x4,%eax
  803434:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803439:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  80343f:	ff 45 f4             	incl   -0xc(%ebp)
  803442:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  803446:	7e c4                	jle    80340c <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  803448:	c7 05 68 d0 81 00 00 	movl   $0x0,0x81d068
  80344f:	00 00 00 
  803452:	c7 05 6c d0 81 00 00 	movl   $0x0,0x81d06c
  803459:	00 00 00 
  80345c:	c7 05 74 d0 81 00 00 	movl   $0x0,0x81d074
  803463:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803466:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80346d:	e9 1b 01 00 00       	jmp    80358d <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  803472:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803475:	89 d0                	mov    %edx,%eax
  803477:	01 c0                	add    %eax,%eax
  803479:	01 d0                	add    %edx,%eax
  80347b:	c1 e0 02             	shl    $0x2,%eax
  80347e:	05 88 d0 81 00       	add    $0x81d088,%eax
  803483:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  803488:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80348b:	89 d0                	mov    %edx,%eax
  80348d:	01 c0                	add    %eax,%eax
  80348f:	01 d0                	add    %edx,%eax
  803491:	c1 e0 02             	shl    $0x2,%eax
  803494:	05 8a d0 81 00       	add    $0x81d08a,%eax
  803499:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  80349e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034a1:	89 d0                	mov    %edx,%eax
  8034a3:	01 c0                	add    %eax,%eax
  8034a5:	01 d0                	add    %edx,%eax
  8034a7:	c1 e0 02             	shl    $0x2,%eax
  8034aa:	05 80 d0 81 00       	add    $0x81d080,%eax
  8034af:	8b 00                	mov    (%eax),%eax
  8034b1:	85 c0                	test   %eax,%eax
  8034b3:	74 2b                	je     8034e0 <initialize_dynamic_allocator+0x116>
  8034b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034b8:	89 d0                	mov    %edx,%eax
  8034ba:	01 c0                	add    %eax,%eax
  8034bc:	01 d0                	add    %edx,%eax
  8034be:	c1 e0 02             	shl    $0x2,%eax
  8034c1:	05 80 d0 81 00       	add    $0x81d080,%eax
  8034c6:	8b 10                	mov    (%eax),%edx
  8034c8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8034cb:	89 c8                	mov    %ecx,%eax
  8034cd:	01 c0                	add    %eax,%eax
  8034cf:	01 c8                	add    %ecx,%eax
  8034d1:	c1 e0 02             	shl    $0x2,%eax
  8034d4:	05 84 d0 81 00       	add    $0x81d084,%eax
  8034d9:	8b 00                	mov    (%eax),%eax
  8034db:	89 42 04             	mov    %eax,0x4(%edx)
  8034de:	eb 18                	jmp    8034f8 <initialize_dynamic_allocator+0x12e>
  8034e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034e3:	89 d0                	mov    %edx,%eax
  8034e5:	01 c0                	add    %eax,%eax
  8034e7:	01 d0                	add    %edx,%eax
  8034e9:	c1 e0 02             	shl    $0x2,%eax
  8034ec:	05 84 d0 81 00       	add    $0x81d084,%eax
  8034f1:	8b 00                	mov    (%eax),%eax
  8034f3:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  8034f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034fb:	89 d0                	mov    %edx,%eax
  8034fd:	01 c0                	add    %eax,%eax
  8034ff:	01 d0                	add    %edx,%eax
  803501:	c1 e0 02             	shl    $0x2,%eax
  803504:	05 84 d0 81 00       	add    $0x81d084,%eax
  803509:	8b 00                	mov    (%eax),%eax
  80350b:	85 c0                	test   %eax,%eax
  80350d:	74 2a                	je     803539 <initialize_dynamic_allocator+0x16f>
  80350f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803512:	89 d0                	mov    %edx,%eax
  803514:	01 c0                	add    %eax,%eax
  803516:	01 d0                	add    %edx,%eax
  803518:	c1 e0 02             	shl    $0x2,%eax
  80351b:	05 84 d0 81 00       	add    $0x81d084,%eax
  803520:	8b 10                	mov    (%eax),%edx
  803522:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803525:	89 c8                	mov    %ecx,%eax
  803527:	01 c0                	add    %eax,%eax
  803529:	01 c8                	add    %ecx,%eax
  80352b:	c1 e0 02             	shl    $0x2,%eax
  80352e:	05 80 d0 81 00       	add    $0x81d080,%eax
  803533:	8b 00                	mov    (%eax),%eax
  803535:	89 02                	mov    %eax,(%edx)
  803537:	eb 18                	jmp    803551 <initialize_dynamic_allocator+0x187>
  803539:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80353c:	89 d0                	mov    %edx,%eax
  80353e:	01 c0                	add    %eax,%eax
  803540:	01 d0                	add    %edx,%eax
  803542:	c1 e0 02             	shl    $0x2,%eax
  803545:	05 80 d0 81 00       	add    $0x81d080,%eax
  80354a:	8b 00                	mov    (%eax),%eax
  80354c:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803551:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803554:	89 d0                	mov    %edx,%eax
  803556:	01 c0                	add    %eax,%eax
  803558:	01 d0                	add    %edx,%eax
  80355a:	c1 e0 02             	shl    $0x2,%eax
  80355d:	05 80 d0 81 00       	add    $0x81d080,%eax
  803562:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803568:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80356b:	89 d0                	mov    %edx,%eax
  80356d:	01 c0                	add    %eax,%eax
  80356f:	01 d0                	add    %edx,%eax
  803571:	c1 e0 02             	shl    $0x2,%eax
  803574:	05 84 d0 81 00       	add    $0x81d084,%eax
  803579:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80357f:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803584:	48                   	dec    %eax
  803585:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  80358a:	ff 45 f0             	incl   -0x10(%ebp)
  80358d:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  803594:	0f 8e d8 fe ff ff    	jle    803472 <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  80359a:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  8035a1:	e9 9d 00 00 00       	jmp    803643 <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  8035a6:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8035ac:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  8035af:	89 c8                	mov    %ecx,%eax
  8035b1:	01 c0                	add    %eax,%eax
  8035b3:	01 c8                	add    %ecx,%eax
  8035b5:	c1 e0 02             	shl    $0x2,%eax
  8035b8:	05 80 d0 81 00       	add    $0x81d080,%eax
  8035bd:	89 10                	mov    %edx,(%eax)
  8035bf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8035c2:	89 d0                	mov    %edx,%eax
  8035c4:	01 c0                	add    %eax,%eax
  8035c6:	01 d0                	add    %edx,%eax
  8035c8:	c1 e0 02             	shl    $0x2,%eax
  8035cb:	05 80 d0 81 00       	add    $0x81d080,%eax
  8035d0:	8b 00                	mov    (%eax),%eax
  8035d2:	85 c0                	test   %eax,%eax
  8035d4:	74 1c                	je     8035f2 <initialize_dynamic_allocator+0x228>
  8035d6:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8035dc:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  8035df:	89 c8                	mov    %ecx,%eax
  8035e1:	01 c0                	add    %eax,%eax
  8035e3:	01 c8                	add    %ecx,%eax
  8035e5:	c1 e0 02             	shl    $0x2,%eax
  8035e8:	05 80 d0 81 00       	add    $0x81d080,%eax
  8035ed:	89 42 04             	mov    %eax,0x4(%edx)
  8035f0:	eb 16                	jmp    803608 <initialize_dynamic_allocator+0x23e>
  8035f2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8035f5:	89 d0                	mov    %edx,%eax
  8035f7:	01 c0                	add    %eax,%eax
  8035f9:	01 d0                	add    %edx,%eax
  8035fb:	c1 e0 02             	shl    $0x2,%eax
  8035fe:	05 80 d0 81 00       	add    $0x81d080,%eax
  803603:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803608:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80360b:	89 d0                	mov    %edx,%eax
  80360d:	01 c0                	add    %eax,%eax
  80360f:	01 d0                	add    %edx,%eax
  803611:	c1 e0 02             	shl    $0x2,%eax
  803614:	05 80 d0 81 00       	add    $0x81d080,%eax
  803619:	a3 68 d0 81 00       	mov    %eax,0x81d068
  80361e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803621:	89 d0                	mov    %edx,%eax
  803623:	01 c0                	add    %eax,%eax
  803625:	01 d0                	add    %edx,%eax
  803627:	c1 e0 02             	shl    $0x2,%eax
  80362a:	05 84 d0 81 00       	add    $0x81d084,%eax
  80362f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803635:	a1 74 d0 81 00       	mov    0x81d074,%eax
  80363a:	40                   	inc    %eax
  80363b:	a3 74 d0 81 00       	mov    %eax,0x81d074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803640:	ff 4d ec             	decl   -0x14(%ebp)
  803643:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803647:	0f 89 59 ff ff ff    	jns    8035a6 <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  80364d:	c7 05 44 d0 81 00 01 	movl   $0x1,0x81d044
  803654:	00 00 00 
}
  803657:	90                   	nop
  803658:	c9                   	leave  
  803659:	c3                   	ret    

0080365a <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  80365a:	55                   	push   %ebp
  80365b:	89 e5                	mov    %esp,%ebp
  80365d:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803660:	8b 45 08             	mov    0x8(%ebp),%eax
  803663:	83 ec 0c             	sub    $0xc,%esp
  803666:	50                   	push   %eax
  803667:	e8 10 fd ff ff       	call   80337c <to_page_info>
  80366c:	83 c4 10             	add    $0x10,%esp
  80366f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  803672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803675:	8b 40 08             	mov    0x8(%eax),%eax
  803678:	0f b7 c0             	movzwl %ax,%eax
}
  80367b:	c9                   	leave  
  80367c:	c3                   	ret    

0080367d <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  80367d:	55                   	push   %ebp
  80367e:	89 e5                	mov    %esp,%ebp
  803680:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803683:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80368a:	76 16                	jbe    8036a2 <alloc_block+0x25>
  80368c:	68 dc 49 80 00       	push   $0x8049dc
  803691:	68 c6 49 80 00       	push   $0x8049c6
  803696:	6a 59                	push   $0x59
  803698:	68 63 49 80 00       	push   $0x804963
  80369d:	e8 a4 cc ff ff       	call   800346 <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  8036a2:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  8036a9:	eb 08                	jmp    8036b3 <alloc_block+0x36>
		allocSize <<= 1;
  8036ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ae:	01 c0                	add    %eax,%eax
  8036b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  8036b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8036b9:	73 09                	jae    8036c4 <alloc_block+0x47>
  8036bb:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  8036c2:	76 e7                	jbe    8036ab <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  8036c4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  8036cb:	eb 03                	jmp    8036d0 <alloc_block+0x53>
		listIndex++;
  8036cd:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  8036d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036d3:	ba 08 00 00 00       	mov    $0x8,%edx
  8036d8:	88 c1                	mov    %al,%cl
  8036da:	d3 e2                	shl    %cl,%edx
  8036dc:	89 d0                	mov    %edx,%eax
  8036de:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8036e1:	72 ea                	jb     8036cd <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8036e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8036e9:	e9 f4 00 00 00       	jmp    8037e2 <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  8036ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036f1:	c1 e0 04             	shl    $0x4,%eax
  8036f4:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8036f9:	8b 00                	mov    (%eax),%eax
  8036fb:	85 c0                	test   %eax,%eax
  8036fd:	0f 84 dc 00 00 00    	je     8037df <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  803703:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803706:	c1 e0 04             	shl    $0x4,%eax
  803709:	05 a0 50 83 00       	add    $0x8350a0,%eax
  80370e:	8b 00                	mov    (%eax),%eax
  803710:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  803713:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803717:	75 14                	jne    80372d <alloc_block+0xb0>
  803719:	83 ec 04             	sub    $0x4,%esp
  80371c:	68 fd 49 80 00       	push   $0x8049fd
  803721:	6a 6b                	push   $0x6b
  803723:	68 63 49 80 00       	push   $0x804963
  803728:	e8 19 cc ff ff       	call   800346 <_panic>
  80372d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803730:	8b 00                	mov    (%eax),%eax
  803732:	85 c0                	test   %eax,%eax
  803734:	74 10                	je     803746 <alloc_block+0xc9>
  803736:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803739:	8b 00                	mov    (%eax),%eax
  80373b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80373e:	8b 52 04             	mov    0x4(%edx),%edx
  803741:	89 50 04             	mov    %edx,0x4(%eax)
  803744:	eb 14                	jmp    80375a <alloc_block+0xdd>
  803746:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803749:	8b 40 04             	mov    0x4(%eax),%eax
  80374c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80374f:	c1 e2 04             	shl    $0x4,%edx
  803752:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803758:	89 02                	mov    %eax,(%edx)
  80375a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80375d:	8b 40 04             	mov    0x4(%eax),%eax
  803760:	85 c0                	test   %eax,%eax
  803762:	74 0f                	je     803773 <alloc_block+0xf6>
  803764:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803767:	8b 40 04             	mov    0x4(%eax),%eax
  80376a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80376d:	8b 12                	mov    (%edx),%edx
  80376f:	89 10                	mov    %edx,(%eax)
  803771:	eb 13                	jmp    803786 <alloc_block+0x109>
  803773:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803776:	8b 00                	mov    (%eax),%eax
  803778:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80377b:	c1 e2 04             	shl    $0x4,%edx
  80377e:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803784:	89 02                	mov    %eax,(%edx)
  803786:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803789:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80378f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803792:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803799:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80379c:	c1 e0 04             	shl    $0x4,%eax
  80379f:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8037a4:	8b 00                	mov    (%eax),%eax
  8037a6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8037a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037ac:	c1 e0 04             	shl    $0x4,%eax
  8037af:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8037b4:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  8037b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037b9:	83 ec 0c             	sub    $0xc,%esp
  8037bc:	50                   	push   %eax
  8037bd:	e8 ba fb ff ff       	call   80337c <to_page_info>
  8037c2:	83 c4 10             	add    $0x10,%esp
  8037c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  8037c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037cb:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8037cf:	48                   	dec    %eax
  8037d0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8037d3:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  8037d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037da:	e9 8f 02 00 00       	jmp    803a6e <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8037df:	ff 45 ec             	incl   -0x14(%ebp)
  8037e2:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8037e6:	0f 8e 02 ff ff ff    	jle    8036ee <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  8037ec:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8037f1:	85 c0                	test   %eax,%eax
  8037f3:	75 14                	jne    803809 <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  8037f5:	83 ec 04             	sub    $0x4,%esp
  8037f8:	68 1c 4a 80 00       	push   $0x804a1c
  8037fd:	6a 77                	push   $0x77
  8037ff:	68 63 49 80 00       	push   $0x804963
  803804:	e8 3d cb ff ff       	call   800346 <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  803809:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80380e:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  803811:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803815:	75 14                	jne    80382b <alloc_block+0x1ae>
  803817:	83 ec 04             	sub    $0x4,%esp
  80381a:	68 fd 49 80 00       	push   $0x8049fd
  80381f:	6a 7a                	push   $0x7a
  803821:	68 63 49 80 00       	push   $0x804963
  803826:	e8 1b cb ff ff       	call   800346 <_panic>
  80382b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80382e:	8b 00                	mov    (%eax),%eax
  803830:	85 c0                	test   %eax,%eax
  803832:	74 10                	je     803844 <alloc_block+0x1c7>
  803834:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803837:	8b 00                	mov    (%eax),%eax
  803839:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80383c:	8b 52 04             	mov    0x4(%edx),%edx
  80383f:	89 50 04             	mov    %edx,0x4(%eax)
  803842:	eb 0b                	jmp    80384f <alloc_block+0x1d2>
  803844:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803847:	8b 40 04             	mov    0x4(%eax),%eax
  80384a:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  80384f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803852:	8b 40 04             	mov    0x4(%eax),%eax
  803855:	85 c0                	test   %eax,%eax
  803857:	74 0f                	je     803868 <alloc_block+0x1eb>
  803859:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80385c:	8b 40 04             	mov    0x4(%eax),%eax
  80385f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803862:	8b 12                	mov    (%edx),%edx
  803864:	89 10                	mov    %edx,(%eax)
  803866:	eb 0a                	jmp    803872 <alloc_block+0x1f5>
  803868:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80386b:	8b 00                	mov    (%eax),%eax
  80386d:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803872:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803875:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80387b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80387e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803885:	a1 74 d0 81 00       	mov    0x81d074,%eax
  80388a:	48                   	dec    %eax
  80388b:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  803890:	83 ec 0c             	sub    $0xc,%esp
  803893:	ff 75 dc             	pushl  -0x24(%ebp)
  803896:	e8 6f fa ff ff       	call   80330a <to_page_va>
  80389b:	83 c4 10             	add    $0x10,%esp
  80389e:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  8038a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8038a4:	83 ec 0c             	sub    $0xc,%esp
  8038a7:	50                   	push   %eax
  8038a8:	e8 a0 dc ff ff       	call   80154d <get_page>
  8038ad:	83 c4 10             	add    $0x10,%esp
  8038b0:	85 c0                	test   %eax,%eax
  8038b2:	74 14                	je     8038c8 <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  8038b4:	83 ec 04             	sub    $0x4,%esp
  8038b7:	68 44 4a 80 00       	push   $0x804a44
  8038bc:	6a 7f                	push   $0x7f
  8038be:	68 63 49 80 00       	push   $0x804963
  8038c3:	e8 7e ca ff ff       	call   800346 <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  8038c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038cb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8038ce:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  8038d2:	b8 00 10 00 00       	mov    $0x1000,%eax
  8038d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8038dc:	f7 75 f4             	divl   -0xc(%ebp)
  8038df:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8038e2:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  8038e6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8038ed:	e9 a7 00 00 00       	jmp    803999 <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  8038f2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8038f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038f8:	01 d0                	add    %edx,%eax
  8038fa:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  8038fd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803901:	75 17                	jne    80391a <alloc_block+0x29d>
  803903:	83 ec 04             	sub    $0x4,%esp
  803906:	68 6c 4a 80 00       	push   $0x804a6c
  80390b:	68 88 00 00 00       	push   $0x88
  803910:	68 63 49 80 00       	push   $0x804963
  803915:	e8 2c ca ff ff       	call   800346 <_panic>
  80391a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80391d:	c1 e0 04             	shl    $0x4,%eax
  803920:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803925:	8b 10                	mov    (%eax),%edx
  803927:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80392a:	89 10                	mov    %edx,(%eax)
  80392c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80392f:	8b 00                	mov    (%eax),%eax
  803931:	85 c0                	test   %eax,%eax
  803933:	74 15                	je     80394a <alloc_block+0x2cd>
  803935:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803938:	c1 e0 04             	shl    $0x4,%eax
  80393b:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803940:	8b 00                	mov    (%eax),%eax
  803942:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803945:	89 50 04             	mov    %edx,0x4(%eax)
  803948:	eb 11                	jmp    80395b <alloc_block+0x2de>
  80394a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80394d:	c1 e0 04             	shl    $0x4,%eax
  803950:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803956:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803959:	89 02                	mov    %eax,(%edx)
  80395b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80395e:	c1 e0 04             	shl    $0x4,%eax
  803961:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803967:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80396a:	89 02                	mov    %eax,(%edx)
  80396c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80396f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803976:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803979:	c1 e0 04             	shl    $0x4,%eax
  80397c:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803981:	8b 00                	mov    (%eax),%eax
  803983:	8d 50 01             	lea    0x1(%eax),%edx
  803986:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803989:	c1 e0 04             	shl    $0x4,%eax
  80398c:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803991:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803993:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803996:	01 45 e8             	add    %eax,-0x18(%ebp)
  803999:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8039a0:	0f 86 4c ff ff ff    	jbe    8038f2 <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  8039a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039a9:	c1 e0 04             	shl    $0x4,%eax
  8039ac:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8039b1:	8b 00                	mov    (%eax),%eax
  8039b3:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  8039b6:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8039ba:	75 17                	jne    8039d3 <alloc_block+0x356>
  8039bc:	83 ec 04             	sub    $0x4,%esp
  8039bf:	68 fd 49 80 00       	push   $0x8049fd
  8039c4:	68 8d 00 00 00       	push   $0x8d
  8039c9:	68 63 49 80 00       	push   $0x804963
  8039ce:	e8 73 c9 ff ff       	call   800346 <_panic>
  8039d3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8039d6:	8b 00                	mov    (%eax),%eax
  8039d8:	85 c0                	test   %eax,%eax
  8039da:	74 10                	je     8039ec <alloc_block+0x36f>
  8039dc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8039df:	8b 00                	mov    (%eax),%eax
  8039e1:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8039e4:	8b 52 04             	mov    0x4(%edx),%edx
  8039e7:	89 50 04             	mov    %edx,0x4(%eax)
  8039ea:	eb 14                	jmp    803a00 <alloc_block+0x383>
  8039ec:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8039ef:	8b 40 04             	mov    0x4(%eax),%eax
  8039f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039f5:	c1 e2 04             	shl    $0x4,%edx
  8039f8:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  8039fe:	89 02                	mov    %eax,(%edx)
  803a00:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a03:	8b 40 04             	mov    0x4(%eax),%eax
  803a06:	85 c0                	test   %eax,%eax
  803a08:	74 0f                	je     803a19 <alloc_block+0x39c>
  803a0a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a0d:	8b 40 04             	mov    0x4(%eax),%eax
  803a10:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803a13:	8b 12                	mov    (%edx),%edx
  803a15:	89 10                	mov    %edx,(%eax)
  803a17:	eb 13                	jmp    803a2c <alloc_block+0x3af>
  803a19:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a1c:	8b 00                	mov    (%eax),%eax
  803a1e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a21:	c1 e2 04             	shl    $0x4,%edx
  803a24:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803a2a:	89 02                	mov    %eax,(%edx)
  803a2c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a35:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a38:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a42:	c1 e0 04             	shl    $0x4,%eax
  803a45:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803a4a:	8b 00                	mov    (%eax),%eax
  803a4c:	8d 50 ff             	lea    -0x1(%eax),%edx
  803a4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a52:	c1 e0 04             	shl    $0x4,%eax
  803a55:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803a5a:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  803a5c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a5f:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803a63:	48                   	dec    %eax
  803a64:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803a67:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  803a6b:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  803a6e:	c9                   	leave  
  803a6f:	c3                   	ret    

00803a70 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803a70:	55                   	push   %ebp
  803a71:	89 e5                	mov    %esp,%ebp
  803a73:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803a76:	8b 55 08             	mov    0x8(%ebp),%edx
  803a79:	a1 84 50 83 00       	mov    0x835084,%eax
  803a7e:	39 c2                	cmp    %eax,%edx
  803a80:	72 0c                	jb     803a8e <free_block+0x1e>
  803a82:	8b 55 08             	mov    0x8(%ebp),%edx
  803a85:	a1 60 d0 81 00       	mov    0x81d060,%eax
  803a8a:	39 c2                	cmp    %eax,%edx
  803a8c:	72 19                	jb     803aa7 <free_block+0x37>
  803a8e:	68 90 4a 80 00       	push   $0x804a90
  803a93:	68 c6 49 80 00       	push   $0x8049c6
  803a98:	68 98 00 00 00       	push   $0x98
  803a9d:	68 63 49 80 00       	push   $0x804963
  803aa2:	e8 9f c8 ff ff       	call   800346 <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  803aaa:	83 ec 0c             	sub    $0xc,%esp
  803aad:	50                   	push   %eax
  803aae:	e8 c9 f8 ff ff       	call   80337c <to_page_info>
  803ab3:	83 c4 10             	add    $0x10,%esp
  803ab6:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  803ab9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803abc:	8b 40 08             	mov    0x8(%eax),%eax
  803abf:	0f b7 c0             	movzwl %ax,%eax
  803ac2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  803ac5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803acc:	eb 03                	jmp    803ad1 <free_block+0x61>
		listIndex++;
  803ace:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ad4:	ba 08 00 00 00       	mov    $0x8,%edx
  803ad9:	88 c1                	mov    %al,%cl
  803adb:	d3 e2                	shl    %cl,%edx
  803add:	89 d0                	mov    %edx,%eax
  803adf:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803ae2:	72 ea                	jb     803ace <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  803ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  803aea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803aee:	75 17                	jne    803b07 <free_block+0x97>
  803af0:	83 ec 04             	sub    $0x4,%esp
  803af3:	68 6c 4a 80 00       	push   $0x804a6c
  803af8:	68 a2 00 00 00       	push   $0xa2
  803afd:	68 63 49 80 00       	push   $0x804963
  803b02:	e8 3f c8 ff ff       	call   800346 <_panic>
  803b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b0a:	c1 e0 04             	shl    $0x4,%eax
  803b0d:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803b12:	8b 10                	mov    (%eax),%edx
  803b14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b17:	89 10                	mov    %edx,(%eax)
  803b19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b1c:	8b 00                	mov    (%eax),%eax
  803b1e:	85 c0                	test   %eax,%eax
  803b20:	74 15                	je     803b37 <free_block+0xc7>
  803b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b25:	c1 e0 04             	shl    $0x4,%eax
  803b28:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803b2d:	8b 00                	mov    (%eax),%eax
  803b2f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b32:	89 50 04             	mov    %edx,0x4(%eax)
  803b35:	eb 11                	jmp    803b48 <free_block+0xd8>
  803b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b3a:	c1 e0 04             	shl    $0x4,%eax
  803b3d:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803b43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b46:	89 02                	mov    %eax,(%edx)
  803b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b4b:	c1 e0 04             	shl    $0x4,%eax
  803b4e:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803b54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b57:	89 02                	mov    %eax,(%edx)
  803b59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b5c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b66:	c1 e0 04             	shl    $0x4,%eax
  803b69:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803b6e:	8b 00                	mov    (%eax),%eax
  803b70:	8d 50 01             	lea    0x1(%eax),%edx
  803b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b76:	c1 e0 04             	shl    $0x4,%eax
  803b79:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803b7e:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  803b80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b83:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803b87:	40                   	inc    %eax
  803b88:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b8b:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  803b8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b92:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803b96:	0f b7 c8             	movzwl %ax,%ecx
  803b99:	b8 00 10 00 00       	mov    $0x1000,%eax
  803b9e:	ba 00 00 00 00       	mov    $0x0,%edx
  803ba3:	f7 75 e8             	divl   -0x18(%ebp)
  803ba6:	39 c1                	cmp    %eax,%ecx
  803ba8:	0f 85 ed 01 00 00    	jne    803d9b <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bb1:	c1 e0 04             	shl    $0x4,%eax
  803bb4:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803bb9:	8b 00                	mov    (%eax),%eax
  803bbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803bbe:	eb 2a                	jmp    803bea <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  803bc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bc3:	83 ec 0c             	sub    $0xc,%esp
  803bc6:	50                   	push   %eax
  803bc7:	e8 b0 f7 ff ff       	call   80337c <to_page_info>
  803bcc:	83 c4 10             	add    $0x10,%esp
  803bcf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803bd2:	75 06                	jne    803bda <free_block+0x16a>
				tmp = b;
  803bd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bd7:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bdd:	c1 e0 04             	shl    $0x4,%eax
  803be0:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803be5:	8b 00                	mov    (%eax),%eax
  803be7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803bea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803bee:	74 07                	je     803bf7 <free_block+0x187>
  803bf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bf3:	8b 00                	mov    (%eax),%eax
  803bf5:	eb 05                	jmp    803bfc <free_block+0x18c>
  803bf7:	b8 00 00 00 00       	mov    $0x0,%eax
  803bfc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803bff:	c1 e2 04             	shl    $0x4,%edx
  803c02:	81 c2 a8 50 83 00    	add    $0x8350a8,%edx
  803c08:	89 02                	mov    %eax,(%edx)
  803c0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c0d:	c1 e0 04             	shl    $0x4,%eax
  803c10:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803c15:	8b 00                	mov    (%eax),%eax
  803c17:	85 c0                	test   %eax,%eax
  803c19:	75 a5                	jne    803bc0 <free_block+0x150>
  803c1b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803c1f:	75 9f                	jne    803bc0 <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  803c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c24:	c1 e0 04             	shl    $0x4,%eax
  803c27:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803c2c:	8b 00                	mov    (%eax),%eax
  803c2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  803c31:	e9 cc 00 00 00       	jmp    803d02 <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  803c36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c39:	8b 00                	mov    (%eax),%eax
  803c3b:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  803c3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c41:	83 ec 0c             	sub    $0xc,%esp
  803c44:	50                   	push   %eax
  803c45:	e8 32 f7 ff ff       	call   80337c <to_page_info>
  803c4a:	83 c4 10             	add    $0x10,%esp
  803c4d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803c50:	0f 85 a6 00 00 00    	jne    803cfc <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  803c56:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803c5a:	75 17                	jne    803c73 <free_block+0x203>
  803c5c:	83 ec 04             	sub    $0x4,%esp
  803c5f:	68 fd 49 80 00       	push   $0x8049fd
  803c64:	68 b5 00 00 00       	push   $0xb5
  803c69:	68 63 49 80 00       	push   $0x804963
  803c6e:	e8 d3 c6 ff ff       	call   800346 <_panic>
  803c73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c76:	8b 00                	mov    (%eax),%eax
  803c78:	85 c0                	test   %eax,%eax
  803c7a:	74 10                	je     803c8c <free_block+0x21c>
  803c7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c7f:	8b 00                	mov    (%eax),%eax
  803c81:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c84:	8b 52 04             	mov    0x4(%edx),%edx
  803c87:	89 50 04             	mov    %edx,0x4(%eax)
  803c8a:	eb 14                	jmp    803ca0 <free_block+0x230>
  803c8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c8f:	8b 40 04             	mov    0x4(%eax),%eax
  803c92:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c95:	c1 e2 04             	shl    $0x4,%edx
  803c98:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803c9e:	89 02                	mov    %eax,(%edx)
  803ca0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ca3:	8b 40 04             	mov    0x4(%eax),%eax
  803ca6:	85 c0                	test   %eax,%eax
  803ca8:	74 0f                	je     803cb9 <free_block+0x249>
  803caa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cad:	8b 40 04             	mov    0x4(%eax),%eax
  803cb0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803cb3:	8b 12                	mov    (%edx),%edx
  803cb5:	89 10                	mov    %edx,(%eax)
  803cb7:	eb 13                	jmp    803ccc <free_block+0x25c>
  803cb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cbc:	8b 00                	mov    (%eax),%eax
  803cbe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803cc1:	c1 e2 04             	shl    $0x4,%edx
  803cc4:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803cca:	89 02                	mov    %eax,(%edx)
  803ccc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ccf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803cd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cd8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ce2:	c1 e0 04             	shl    $0x4,%eax
  803ce5:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803cea:	8b 00                	mov    (%eax),%eax
  803cec:	8d 50 ff             	lea    -0x1(%eax),%edx
  803cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cf2:	c1 e0 04             	shl    $0x4,%eax
  803cf5:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803cfa:	89 10                	mov    %edx,(%eax)
			b = next;
  803cfc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803cff:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  803d02:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d06:	0f 85 2a ff ff ff    	jne    803c36 <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  803d0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d0f:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  803d15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d18:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  803d1e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803d22:	75 17                	jne    803d3b <free_block+0x2cb>
  803d24:	83 ec 04             	sub    $0x4,%esp
  803d27:	68 6c 4a 80 00       	push   $0x804a6c
  803d2c:	68 bc 00 00 00       	push   $0xbc
  803d31:	68 63 49 80 00       	push   $0x804963
  803d36:	e8 0b c6 ff ff       	call   800346 <_panic>
  803d3b:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803d41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d44:	89 10                	mov    %edx,(%eax)
  803d46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d49:	8b 00                	mov    (%eax),%eax
  803d4b:	85 c0                	test   %eax,%eax
  803d4d:	74 0d                	je     803d5c <free_block+0x2ec>
  803d4f:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803d54:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803d57:	89 50 04             	mov    %edx,0x4(%eax)
  803d5a:	eb 08                	jmp    803d64 <free_block+0x2f4>
  803d5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d5f:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803d64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d67:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803d6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d6f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d76:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803d7b:	40                   	inc    %eax
  803d7c:	a3 74 d0 81 00       	mov    %eax,0x81d074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  803d81:	83 ec 0c             	sub    $0xc,%esp
  803d84:	ff 75 ec             	pushl  -0x14(%ebp)
  803d87:	e8 7e f5 ff ff       	call   80330a <to_page_va>
  803d8c:	83 c4 10             	add    $0x10,%esp
  803d8f:	83 ec 0c             	sub    $0xc,%esp
  803d92:	50                   	push   %eax
  803d93:	e8 fe d7 ff ff       	call   801596 <return_page>
  803d98:	83 c4 10             	add    $0x10,%esp
	}
}
  803d9b:	90                   	nop
  803d9c:	c9                   	leave  
  803d9d:	c3                   	ret    

00803d9e <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803d9e:	55                   	push   %ebp
  803d9f:	89 e5                	mov    %esp,%ebp
  803da1:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803da4:	8b 55 08             	mov    0x8(%ebp),%edx
  803da7:	89 d0                	mov    %edx,%eax
  803da9:	c1 e0 02             	shl    $0x2,%eax
  803dac:	01 d0                	add    %edx,%eax
  803dae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803db5:	01 d0                	add    %edx,%eax
  803db7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803dbe:	01 d0                	add    %edx,%eax
  803dc0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803dc7:	01 d0                	add    %edx,%eax
  803dc9:	c1 e0 04             	shl    $0x4,%eax
  803dcc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  803dcf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  803dd6:	0f 31                	rdtsc  
  803dd8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  803ddb:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  803dde:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803de1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803de4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803de7:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  803dea:	eb 46                	jmp    803e32 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  803dec:	0f 31                	rdtsc  
  803dee:	89 45 d0             	mov    %eax,-0x30(%ebp)
  803df1:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  803df4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803df7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803dfa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  803dfd:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803e00:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803e03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e06:	29 c2                	sub    %eax,%edx
  803e08:	89 d0                	mov    %edx,%eax
  803e0a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803e0d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e13:	89 d1                	mov    %edx,%ecx
  803e15:	29 c1                	sub    %eax,%ecx
  803e17:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803e1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e1d:	39 c2                	cmp    %eax,%edx
  803e1f:	0f 97 c0             	seta   %al
  803e22:	0f b6 c0             	movzbl %al,%eax
  803e25:	29 c1                	sub    %eax,%ecx
  803e27:	89 c8                	mov    %ecx,%eax
  803e29:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803e2c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803e2f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  803e32:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803e35:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803e38:	72 b2                	jb     803dec <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803e3a:	90                   	nop
  803e3b:	c9                   	leave  
  803e3c:	c3                   	ret    

00803e3d <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803e3d:	55                   	push   %ebp
  803e3e:	89 e5                	mov    %esp,%ebp
  803e40:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803e43:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803e4a:	eb 03                	jmp    803e4f <busy_wait+0x12>
  803e4c:	ff 45 fc             	incl   -0x4(%ebp)
  803e4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803e52:	3b 45 08             	cmp    0x8(%ebp),%eax
  803e55:	72 f5                	jb     803e4c <busy_wait+0xf>
	return i;
  803e57:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803e5a:	c9                   	leave  
  803e5b:	c3                   	ret    

00803e5c <__udivdi3>:
  803e5c:	55                   	push   %ebp
  803e5d:	57                   	push   %edi
  803e5e:	56                   	push   %esi
  803e5f:	53                   	push   %ebx
  803e60:	83 ec 1c             	sub    $0x1c,%esp
  803e63:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803e67:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803e6b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803e6f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803e73:	89 ca                	mov    %ecx,%edx
  803e75:	89 f8                	mov    %edi,%eax
  803e77:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803e7b:	85 f6                	test   %esi,%esi
  803e7d:	75 2d                	jne    803eac <__udivdi3+0x50>
  803e7f:	39 cf                	cmp    %ecx,%edi
  803e81:	77 65                	ja     803ee8 <__udivdi3+0x8c>
  803e83:	89 fd                	mov    %edi,%ebp
  803e85:	85 ff                	test   %edi,%edi
  803e87:	75 0b                	jne    803e94 <__udivdi3+0x38>
  803e89:	b8 01 00 00 00       	mov    $0x1,%eax
  803e8e:	31 d2                	xor    %edx,%edx
  803e90:	f7 f7                	div    %edi
  803e92:	89 c5                	mov    %eax,%ebp
  803e94:	31 d2                	xor    %edx,%edx
  803e96:	89 c8                	mov    %ecx,%eax
  803e98:	f7 f5                	div    %ebp
  803e9a:	89 c1                	mov    %eax,%ecx
  803e9c:	89 d8                	mov    %ebx,%eax
  803e9e:	f7 f5                	div    %ebp
  803ea0:	89 cf                	mov    %ecx,%edi
  803ea2:	89 fa                	mov    %edi,%edx
  803ea4:	83 c4 1c             	add    $0x1c,%esp
  803ea7:	5b                   	pop    %ebx
  803ea8:	5e                   	pop    %esi
  803ea9:	5f                   	pop    %edi
  803eaa:	5d                   	pop    %ebp
  803eab:	c3                   	ret    
  803eac:	39 ce                	cmp    %ecx,%esi
  803eae:	77 28                	ja     803ed8 <__udivdi3+0x7c>
  803eb0:	0f bd fe             	bsr    %esi,%edi
  803eb3:	83 f7 1f             	xor    $0x1f,%edi
  803eb6:	75 40                	jne    803ef8 <__udivdi3+0x9c>
  803eb8:	39 ce                	cmp    %ecx,%esi
  803eba:	72 0a                	jb     803ec6 <__udivdi3+0x6a>
  803ebc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803ec0:	0f 87 9e 00 00 00    	ja     803f64 <__udivdi3+0x108>
  803ec6:	b8 01 00 00 00       	mov    $0x1,%eax
  803ecb:	89 fa                	mov    %edi,%edx
  803ecd:	83 c4 1c             	add    $0x1c,%esp
  803ed0:	5b                   	pop    %ebx
  803ed1:	5e                   	pop    %esi
  803ed2:	5f                   	pop    %edi
  803ed3:	5d                   	pop    %ebp
  803ed4:	c3                   	ret    
  803ed5:	8d 76 00             	lea    0x0(%esi),%esi
  803ed8:	31 ff                	xor    %edi,%edi
  803eda:	31 c0                	xor    %eax,%eax
  803edc:	89 fa                	mov    %edi,%edx
  803ede:	83 c4 1c             	add    $0x1c,%esp
  803ee1:	5b                   	pop    %ebx
  803ee2:	5e                   	pop    %esi
  803ee3:	5f                   	pop    %edi
  803ee4:	5d                   	pop    %ebp
  803ee5:	c3                   	ret    
  803ee6:	66 90                	xchg   %ax,%ax
  803ee8:	89 d8                	mov    %ebx,%eax
  803eea:	f7 f7                	div    %edi
  803eec:	31 ff                	xor    %edi,%edi
  803eee:	89 fa                	mov    %edi,%edx
  803ef0:	83 c4 1c             	add    $0x1c,%esp
  803ef3:	5b                   	pop    %ebx
  803ef4:	5e                   	pop    %esi
  803ef5:	5f                   	pop    %edi
  803ef6:	5d                   	pop    %ebp
  803ef7:	c3                   	ret    
  803ef8:	bd 20 00 00 00       	mov    $0x20,%ebp
  803efd:	89 eb                	mov    %ebp,%ebx
  803eff:	29 fb                	sub    %edi,%ebx
  803f01:	89 f9                	mov    %edi,%ecx
  803f03:	d3 e6                	shl    %cl,%esi
  803f05:	89 c5                	mov    %eax,%ebp
  803f07:	88 d9                	mov    %bl,%cl
  803f09:	d3 ed                	shr    %cl,%ebp
  803f0b:	89 e9                	mov    %ebp,%ecx
  803f0d:	09 f1                	or     %esi,%ecx
  803f0f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803f13:	89 f9                	mov    %edi,%ecx
  803f15:	d3 e0                	shl    %cl,%eax
  803f17:	89 c5                	mov    %eax,%ebp
  803f19:	89 d6                	mov    %edx,%esi
  803f1b:	88 d9                	mov    %bl,%cl
  803f1d:	d3 ee                	shr    %cl,%esi
  803f1f:	89 f9                	mov    %edi,%ecx
  803f21:	d3 e2                	shl    %cl,%edx
  803f23:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f27:	88 d9                	mov    %bl,%cl
  803f29:	d3 e8                	shr    %cl,%eax
  803f2b:	09 c2                	or     %eax,%edx
  803f2d:	89 d0                	mov    %edx,%eax
  803f2f:	89 f2                	mov    %esi,%edx
  803f31:	f7 74 24 0c          	divl   0xc(%esp)
  803f35:	89 d6                	mov    %edx,%esi
  803f37:	89 c3                	mov    %eax,%ebx
  803f39:	f7 e5                	mul    %ebp
  803f3b:	39 d6                	cmp    %edx,%esi
  803f3d:	72 19                	jb     803f58 <__udivdi3+0xfc>
  803f3f:	74 0b                	je     803f4c <__udivdi3+0xf0>
  803f41:	89 d8                	mov    %ebx,%eax
  803f43:	31 ff                	xor    %edi,%edi
  803f45:	e9 58 ff ff ff       	jmp    803ea2 <__udivdi3+0x46>
  803f4a:	66 90                	xchg   %ax,%ax
  803f4c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803f50:	89 f9                	mov    %edi,%ecx
  803f52:	d3 e2                	shl    %cl,%edx
  803f54:	39 c2                	cmp    %eax,%edx
  803f56:	73 e9                	jae    803f41 <__udivdi3+0xe5>
  803f58:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803f5b:	31 ff                	xor    %edi,%edi
  803f5d:	e9 40 ff ff ff       	jmp    803ea2 <__udivdi3+0x46>
  803f62:	66 90                	xchg   %ax,%ax
  803f64:	31 c0                	xor    %eax,%eax
  803f66:	e9 37 ff ff ff       	jmp    803ea2 <__udivdi3+0x46>
  803f6b:	90                   	nop

00803f6c <__umoddi3>:
  803f6c:	55                   	push   %ebp
  803f6d:	57                   	push   %edi
  803f6e:	56                   	push   %esi
  803f6f:	53                   	push   %ebx
  803f70:	83 ec 1c             	sub    $0x1c,%esp
  803f73:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803f77:	8b 74 24 34          	mov    0x34(%esp),%esi
  803f7b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803f7f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803f83:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803f87:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803f8b:	89 f3                	mov    %esi,%ebx
  803f8d:	89 fa                	mov    %edi,%edx
  803f8f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803f93:	89 34 24             	mov    %esi,(%esp)
  803f96:	85 c0                	test   %eax,%eax
  803f98:	75 1a                	jne    803fb4 <__umoddi3+0x48>
  803f9a:	39 f7                	cmp    %esi,%edi
  803f9c:	0f 86 a2 00 00 00    	jbe    804044 <__umoddi3+0xd8>
  803fa2:	89 c8                	mov    %ecx,%eax
  803fa4:	89 f2                	mov    %esi,%edx
  803fa6:	f7 f7                	div    %edi
  803fa8:	89 d0                	mov    %edx,%eax
  803faa:	31 d2                	xor    %edx,%edx
  803fac:	83 c4 1c             	add    $0x1c,%esp
  803faf:	5b                   	pop    %ebx
  803fb0:	5e                   	pop    %esi
  803fb1:	5f                   	pop    %edi
  803fb2:	5d                   	pop    %ebp
  803fb3:	c3                   	ret    
  803fb4:	39 f0                	cmp    %esi,%eax
  803fb6:	0f 87 ac 00 00 00    	ja     804068 <__umoddi3+0xfc>
  803fbc:	0f bd e8             	bsr    %eax,%ebp
  803fbf:	83 f5 1f             	xor    $0x1f,%ebp
  803fc2:	0f 84 ac 00 00 00    	je     804074 <__umoddi3+0x108>
  803fc8:	bf 20 00 00 00       	mov    $0x20,%edi
  803fcd:	29 ef                	sub    %ebp,%edi
  803fcf:	89 fe                	mov    %edi,%esi
  803fd1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803fd5:	89 e9                	mov    %ebp,%ecx
  803fd7:	d3 e0                	shl    %cl,%eax
  803fd9:	89 d7                	mov    %edx,%edi
  803fdb:	89 f1                	mov    %esi,%ecx
  803fdd:	d3 ef                	shr    %cl,%edi
  803fdf:	09 c7                	or     %eax,%edi
  803fe1:	89 e9                	mov    %ebp,%ecx
  803fe3:	d3 e2                	shl    %cl,%edx
  803fe5:	89 14 24             	mov    %edx,(%esp)
  803fe8:	89 d8                	mov    %ebx,%eax
  803fea:	d3 e0                	shl    %cl,%eax
  803fec:	89 c2                	mov    %eax,%edx
  803fee:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ff2:	d3 e0                	shl    %cl,%eax
  803ff4:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ff8:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ffc:	89 f1                	mov    %esi,%ecx
  803ffe:	d3 e8                	shr    %cl,%eax
  804000:	09 d0                	or     %edx,%eax
  804002:	d3 eb                	shr    %cl,%ebx
  804004:	89 da                	mov    %ebx,%edx
  804006:	f7 f7                	div    %edi
  804008:	89 d3                	mov    %edx,%ebx
  80400a:	f7 24 24             	mull   (%esp)
  80400d:	89 c6                	mov    %eax,%esi
  80400f:	89 d1                	mov    %edx,%ecx
  804011:	39 d3                	cmp    %edx,%ebx
  804013:	0f 82 87 00 00 00    	jb     8040a0 <__umoddi3+0x134>
  804019:	0f 84 91 00 00 00    	je     8040b0 <__umoddi3+0x144>
  80401f:	8b 54 24 04          	mov    0x4(%esp),%edx
  804023:	29 f2                	sub    %esi,%edx
  804025:	19 cb                	sbb    %ecx,%ebx
  804027:	89 d8                	mov    %ebx,%eax
  804029:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80402d:	d3 e0                	shl    %cl,%eax
  80402f:	89 e9                	mov    %ebp,%ecx
  804031:	d3 ea                	shr    %cl,%edx
  804033:	09 d0                	or     %edx,%eax
  804035:	89 e9                	mov    %ebp,%ecx
  804037:	d3 eb                	shr    %cl,%ebx
  804039:	89 da                	mov    %ebx,%edx
  80403b:	83 c4 1c             	add    $0x1c,%esp
  80403e:	5b                   	pop    %ebx
  80403f:	5e                   	pop    %esi
  804040:	5f                   	pop    %edi
  804041:	5d                   	pop    %ebp
  804042:	c3                   	ret    
  804043:	90                   	nop
  804044:	89 fd                	mov    %edi,%ebp
  804046:	85 ff                	test   %edi,%edi
  804048:	75 0b                	jne    804055 <__umoddi3+0xe9>
  80404a:	b8 01 00 00 00       	mov    $0x1,%eax
  80404f:	31 d2                	xor    %edx,%edx
  804051:	f7 f7                	div    %edi
  804053:	89 c5                	mov    %eax,%ebp
  804055:	89 f0                	mov    %esi,%eax
  804057:	31 d2                	xor    %edx,%edx
  804059:	f7 f5                	div    %ebp
  80405b:	89 c8                	mov    %ecx,%eax
  80405d:	f7 f5                	div    %ebp
  80405f:	89 d0                	mov    %edx,%eax
  804061:	e9 44 ff ff ff       	jmp    803faa <__umoddi3+0x3e>
  804066:	66 90                	xchg   %ax,%ax
  804068:	89 c8                	mov    %ecx,%eax
  80406a:	89 f2                	mov    %esi,%edx
  80406c:	83 c4 1c             	add    $0x1c,%esp
  80406f:	5b                   	pop    %ebx
  804070:	5e                   	pop    %esi
  804071:	5f                   	pop    %edi
  804072:	5d                   	pop    %ebp
  804073:	c3                   	ret    
  804074:	3b 04 24             	cmp    (%esp),%eax
  804077:	72 06                	jb     80407f <__umoddi3+0x113>
  804079:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80407d:	77 0f                	ja     80408e <__umoddi3+0x122>
  80407f:	89 f2                	mov    %esi,%edx
  804081:	29 f9                	sub    %edi,%ecx
  804083:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804087:	89 14 24             	mov    %edx,(%esp)
  80408a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80408e:	8b 44 24 04          	mov    0x4(%esp),%eax
  804092:	8b 14 24             	mov    (%esp),%edx
  804095:	83 c4 1c             	add    $0x1c,%esp
  804098:	5b                   	pop    %ebx
  804099:	5e                   	pop    %esi
  80409a:	5f                   	pop    %edi
  80409b:	5d                   	pop    %ebp
  80409c:	c3                   	ret    
  80409d:	8d 76 00             	lea    0x0(%esi),%esi
  8040a0:	2b 04 24             	sub    (%esp),%eax
  8040a3:	19 fa                	sbb    %edi,%edx
  8040a5:	89 d1                	mov    %edx,%ecx
  8040a7:	89 c6                	mov    %eax,%esi
  8040a9:	e9 71 ff ff ff       	jmp    80401f <__umoddi3+0xb3>
  8040ae:	66 90                	xchg   %ax,%ax
  8040b0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8040b4:	72 ea                	jb     8040a0 <__umoddi3+0x134>
  8040b6:	89 d9                	mov    %ebx,%ecx
  8040b8:	e9 62 ff ff ff       	jmp    80401f <__umoddi3+0xb3>
