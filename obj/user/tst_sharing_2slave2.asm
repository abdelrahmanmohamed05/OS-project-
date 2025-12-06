
obj/user/tst_sharing_2slave2:     file format elf32-i386


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
  800031:	e8 23 02 00 00       	call   800259 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Slave program2: Get 2 shared variables, edit the writable one, and attempt to edit the readOnly one
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 24             	sub    $0x24,%esp
	/*=================================================*/
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  80003f:	a1 20 50 80 00       	mov    0x805020,%eax
  800044:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  80004a:	a1 20 50 80 00       	mov    0x805020,%eax
  80004f:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800055:	39 c2                	cmp    %eax,%edx
  800057:	72 14                	jb     80006d <_main+0x35>
			panic("Please increase the WS size");
  800059:	83 ec 04             	sub    $0x4,%esp
  80005c:	68 e0 40 80 00       	push   $0x8040e0
  800061:	6a 0d                	push   $0xd
  800063:	68 fc 40 80 00       	push   $0x8040fc
  800068:	e8 9c 03 00 00       	call   800409 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80006d:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)


	int32 parentenvID = sys_getparentenvid();
  800074:	e8 aa 30 00 00       	call   803123 <sys_getparentenvid>
  800079:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int freeFrames, diff, expected;

	//GET: z then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	//sys_lock_cons();
	sys_lock_cons();
  80007c:	e8 10 2e 00 00       	call   802e91 <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  800081:	e8 bb 2e 00 00       	call   802f41 <sys_calculate_free_frames>
  800086:	89 45 ec             	mov    %eax,-0x14(%ebp)
		z = sget(parentenvID,"z");
  800089:	83 ec 08             	sub    $0x8,%esp
  80008c:	68 17 41 80 00       	push   $0x804117
  800091:	ff 75 f0             	pushl  -0x10(%ebp)
  800094:	e8 c7 20 00 00       	call   802160 <sget>
  800099:	83 c4 10             	add    $0x10,%esp
  80009c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		expectedVA = (uint32*)(pagealloc_start + 0 * PAGE_SIZE);
  80009f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (z != expectedVA) panic("Get(): Returned address is not correct. Expected = %x, Actual = %x\nMake sure that you align the allocation on 4KB boundary", expectedVA, z);
  8000a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000a8:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8000ab:	74 1a                	je     8000c7 <_main+0x8f>
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	ff 75 e8             	pushl  -0x18(%ebp)
  8000b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000b6:	68 1c 41 80 00       	push   $0x80411c
  8000bb:	6a 23                	push   $0x23
  8000bd:	68 fc 40 80 00       	push   $0x8040fc
  8000c2:	e8 42 03 00 00       	call   800409 <_panic>
		expected = 1 ; /*1table*/
  8000c7:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8000ce:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000d1:	e8 6b 2e 00 00       	call   802f41 <sys_calculate_free_frames>
  8000d6:	29 c3                	sub    %eax,%ebx
  8000d8:	89 d8                	mov    %ebx,%eax
  8000da:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  8000dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000e0:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8000e3:	74 24                	je     800109 <_main+0xd1>
  8000e5:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000e8:	e8 54 2e 00 00       	call   802f41 <sys_calculate_free_frames>
  8000ed:	29 c3                	sub    %eax,%ebx
  8000ef:	89 d8                	mov    %ebx,%eax
  8000f1:	83 ec 0c             	sub    $0xc,%esp
  8000f4:	ff 75 e0             	pushl  -0x20(%ebp)
  8000f7:	50                   	push   %eax
  8000f8:	68 98 41 80 00       	push   $0x804198
  8000fd:	6a 26                	push   $0x26
  8000ff:	68 fc 40 80 00       	push   $0x8040fc
  800104:	e8 00 03 00 00       	call   800409 <_panic>
	}
	sys_unlock_cons();
  800109:	e8 9d 2d 00 00       	call   802eab <sys_unlock_cons>
	//sys_unlock_cons();

	//sys_lock_cons();
	sys_lock_cons();
  80010e:	e8 7e 2d 00 00       	call   802e91 <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  800113:	e8 29 2e 00 00       	call   802f41 <sys_calculate_free_frames>
  800118:	89 45 ec             	mov    %eax,-0x14(%ebp)
		x = sget(parentenvID,"x");
  80011b:	83 ec 08             	sub    $0x8,%esp
  80011e:	68 30 42 80 00       	push   $0x804230
  800123:	ff 75 f0             	pushl  -0x10(%ebp)
  800126:	e8 35 20 00 00       	call   802160 <sget>
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		expectedVA = (uint32*)(pagealloc_start + 1 * PAGE_SIZE);
  800131:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800134:	05 00 10 00 00       	add    $0x1000,%eax
  800139:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (x != expectedVA) panic("Get(): Returned address is not correct. Expected = %x, Actual = %x\nMake sure that you align the allocation on 4KB boundary", expectedVA, x);
  80013c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80013f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800142:	74 1a                	je     80015e <_main+0x126>
  800144:	83 ec 0c             	sub    $0xc,%esp
  800147:	ff 75 d8             	pushl  -0x28(%ebp)
  80014a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80014d:	68 1c 41 80 00       	push   $0x80411c
  800152:	6a 31                	push   $0x31
  800154:	68 fc 40 80 00       	push   $0x8040fc
  800159:	e8 ab 02 00 00       	call   800409 <_panic>
		expected = 0;
  80015e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800165:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800168:	e8 d4 2d 00 00       	call   802f41 <sys_calculate_free_frames>
  80016d:	29 c3                	sub    %eax,%ebx
  80016f:	89 d8                	mov    %ebx,%eax
  800171:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800174:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800177:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80017a:	74 24                	je     8001a0 <_main+0x168>
  80017c:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80017f:	e8 bd 2d 00 00       	call   802f41 <sys_calculate_free_frames>
  800184:	29 c3                	sub    %eax,%ebx
  800186:	89 d8                	mov    %ebx,%eax
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	ff 75 e0             	pushl  -0x20(%ebp)
  80018e:	50                   	push   %eax
  80018f:	68 98 41 80 00       	push   $0x804198
  800194:	6a 34                	push   $0x34
  800196:	68 fc 40 80 00       	push   $0x8040fc
  80019b:	e8 69 02 00 00       	call   800409 <_panic>
	}
	sys_unlock_cons();
  8001a0:	e8 06 2d 00 00       	call   802eab <sys_unlock_cons>
	//sys_unlock_cons();

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  8001a5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001a8:	8b 00                	mov    (%eax),%eax
  8001aa:	83 f8 0a             	cmp    $0xa,%eax
  8001ad:	74 14                	je     8001c3 <_main+0x18b>
  8001af:	83 ec 04             	sub    $0x4,%esp
  8001b2:	68 34 42 80 00       	push   $0x804234
  8001b7:	6a 39                	push   $0x39
  8001b9:	68 fc 40 80 00       	push   $0x8040fc
  8001be:	e8 46 02 00 00       	call   800409 <_panic>

	//Edit the writable object
	*z = 50;
  8001c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001c6:	c7 00 32 00 00 00    	movl   $0x32,(%eax)
	if (*z != 50) panic("Get(): Shared Variable is not created or got correctly") ;
  8001cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001cf:	8b 00                	mov    (%eax),%eax
  8001d1:	83 f8 32             	cmp    $0x32,%eax
  8001d4:	74 14                	je     8001ea <_main+0x1b2>
  8001d6:	83 ec 04             	sub    $0x4,%esp
  8001d9:	68 34 42 80 00       	push   $0x804234
  8001de:	6a 3d                	push   $0x3d
  8001e0:	68 fc 40 80 00       	push   $0x8040fc
  8001e5:	e8 1f 02 00 00       	call   800409 <_panic>

	inctst();
  8001ea:	e8 59 30 00 00       	call   803248 <inctst>

	//sync with master
	while (gettst() != 5) ;
  8001ef:	90                   	nop
  8001f0:	e8 6d 30 00 00       	call   803262 <gettst>
  8001f5:	83 f8 05             	cmp    $0x5,%eax
  8001f8:	75 f6                	jne    8001f0 <_main+0x1b8>

	//Attempt to edit the ReadOnly object, it should panic
	sys_bypassPageFault(6);
  8001fa:	83 ec 0c             	sub    $0xc,%esp
  8001fd:	6a 06                	push   $0x6
  8001ff:	e8 be 2f 00 00       	call   8031c2 <sys_bypassPageFault>
  800204:	83 c4 10             	add    $0x10,%esp
	cprintf("Attempt to edit the ReadOnly object @ va = %x\n", x);
  800207:	83 ec 08             	sub    $0x8,%esp
  80020a:	ff 75 d8             	pushl  -0x28(%ebp)
  80020d:	68 6c 42 80 00       	push   $0x80426c
  800212:	e8 c0 04 00 00       	call   8006d7 <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
	*x = 100;
  80021a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80021d:	c7 00 64 00 00 00    	movl   $0x64,(%eax)

	sys_bypassPageFault(0);
  800223:	83 ec 0c             	sub    $0xc,%esp
  800226:	6a 00                	push   $0x0
  800228:	e8 95 2f 00 00       	call   8031c2 <sys_bypassPageFault>
  80022d:	83 c4 10             	add    $0x10,%esp

	inctst();
  800230:	e8 13 30 00 00       	call   803248 <inctst>
	if (*x == 100)
  800235:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800238:	8b 00                	mov    (%eax),%eax
  80023a:	83 f8 64             	cmp    $0x64,%eax
  80023d:	75 14                	jne    800253 <_main+0x21b>
		panic("Test FAILED! it should not edit the variable x since it's a read-only!") ;
  80023f:	83 ec 04             	sub    $0x4,%esp
  800242:	68 9c 42 80 00       	push   $0x80429c
  800247:	6a 4d                	push   $0x4d
  800249:	68 fc 40 80 00       	push   $0x8040fc
  80024e:	e8 b6 01 00 00       	call   800409 <_panic>
	return;
  800253:	90                   	nop
}
  800254:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800257:	c9                   	leave  
  800258:	c3                   	ret    

00800259 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800259:	55                   	push   %ebp
  80025a:	89 e5                	mov    %esp,%ebp
  80025c:	57                   	push   %edi
  80025d:	56                   	push   %esi
  80025e:	53                   	push   %ebx
  80025f:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800262:	e8 a3 2e 00 00       	call   80310a <sys_getenvindex>
  800267:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80026a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80026d:	89 d0                	mov    %edx,%eax
  80026f:	c1 e0 03             	shl    $0x3,%eax
  800272:	01 d0                	add    %edx,%eax
  800274:	c1 e0 02             	shl    $0x2,%eax
  800277:	01 d0                	add    %edx,%eax
  800279:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800280:	01 d0                	add    %edx,%eax
  800282:	c1 e0 03             	shl    $0x3,%eax
  800285:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80028a:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80028f:	a1 20 50 80 00       	mov    0x805020,%eax
  800294:	8a 40 20             	mov    0x20(%eax),%al
  800297:	84 c0                	test   %al,%al
  800299:	74 0d                	je     8002a8 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80029b:	a1 20 50 80 00       	mov    0x805020,%eax
  8002a0:	83 c0 20             	add    $0x20,%eax
  8002a3:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002ac:	7e 0a                	jle    8002b8 <libmain+0x5f>
		binaryname = argv[0];
  8002ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b1:	8b 00                	mov    (%eax),%eax
  8002b3:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  8002b8:	83 ec 08             	sub    $0x8,%esp
  8002bb:	ff 75 0c             	pushl  0xc(%ebp)
  8002be:	ff 75 08             	pushl  0x8(%ebp)
  8002c1:	e8 72 fd ff ff       	call   800038 <_main>
  8002c6:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8002c9:	a1 00 50 80 00       	mov    0x805000,%eax
  8002ce:	85 c0                	test   %eax,%eax
  8002d0:	0f 84 01 01 00 00    	je     8003d7 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8002d6:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8002dc:	bb dc 43 80 00       	mov    $0x8043dc,%ebx
  8002e1:	ba 0e 00 00 00       	mov    $0xe,%edx
  8002e6:	89 c7                	mov    %eax,%edi
  8002e8:	89 de                	mov    %ebx,%esi
  8002ea:	89 d1                	mov    %edx,%ecx
  8002ec:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8002ee:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8002f1:	b9 56 00 00 00       	mov    $0x56,%ecx
  8002f6:	b0 00                	mov    $0x0,%al
  8002f8:	89 d7                	mov    %edx,%edi
  8002fa:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8002fc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800303:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800306:	83 ec 08             	sub    $0x8,%esp
  800309:	50                   	push   %eax
  80030a:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800310:	50                   	push   %eax
  800311:	e8 2a 30 00 00       	call   803340 <sys_utilities>
  800316:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800319:	e8 73 2b 00 00       	call   802e91 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80031e:	83 ec 0c             	sub    $0xc,%esp
  800321:	68 fc 42 80 00       	push   $0x8042fc
  800326:	e8 ac 03 00 00       	call   8006d7 <cprintf>
  80032b:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80032e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800331:	85 c0                	test   %eax,%eax
  800333:	74 18                	je     80034d <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800335:	e8 24 30 00 00       	call   80335e <sys_get_optimal_num_faults>
  80033a:	83 ec 08             	sub    $0x8,%esp
  80033d:	50                   	push   %eax
  80033e:	68 24 43 80 00       	push   $0x804324
  800343:	e8 8f 03 00 00       	call   8006d7 <cprintf>
  800348:	83 c4 10             	add    $0x10,%esp
  80034b:	eb 59                	jmp    8003a6 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80034d:	a1 20 50 80 00       	mov    0x805020,%eax
  800352:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  800358:	a1 20 50 80 00       	mov    0x805020,%eax
  80035d:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800363:	83 ec 04             	sub    $0x4,%esp
  800366:	52                   	push   %edx
  800367:	50                   	push   %eax
  800368:	68 48 43 80 00       	push   $0x804348
  80036d:	e8 65 03 00 00       	call   8006d7 <cprintf>
  800372:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800375:	a1 20 50 80 00       	mov    0x805020,%eax
  80037a:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  800380:	a1 20 50 80 00       	mov    0x805020,%eax
  800385:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  80038b:	a1 20 50 80 00       	mov    0x805020,%eax
  800390:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800396:	51                   	push   %ecx
  800397:	52                   	push   %edx
  800398:	50                   	push   %eax
  800399:	68 70 43 80 00       	push   $0x804370
  80039e:	e8 34 03 00 00       	call   8006d7 <cprintf>
  8003a3:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003a6:	a1 20 50 80 00       	mov    0x805020,%eax
  8003ab:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  8003b1:	83 ec 08             	sub    $0x8,%esp
  8003b4:	50                   	push   %eax
  8003b5:	68 c8 43 80 00       	push   $0x8043c8
  8003ba:	e8 18 03 00 00       	call   8006d7 <cprintf>
  8003bf:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8003c2:	83 ec 0c             	sub    $0xc,%esp
  8003c5:	68 fc 42 80 00       	push   $0x8042fc
  8003ca:	e8 08 03 00 00       	call   8006d7 <cprintf>
  8003cf:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8003d2:	e8 d4 2a 00 00       	call   802eab <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8003d7:	e8 1f 00 00 00       	call   8003fb <exit>
}
  8003dc:	90                   	nop
  8003dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003e0:	5b                   	pop    %ebx
  8003e1:	5e                   	pop    %esi
  8003e2:	5f                   	pop    %edi
  8003e3:	5d                   	pop    %ebp
  8003e4:	c3                   	ret    

008003e5 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003e5:	55                   	push   %ebp
  8003e6:	89 e5                	mov    %esp,%ebp
  8003e8:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003eb:	83 ec 0c             	sub    $0xc,%esp
  8003ee:	6a 00                	push   $0x0
  8003f0:	e8 e1 2c 00 00       	call   8030d6 <sys_destroy_env>
  8003f5:	83 c4 10             	add    $0x10,%esp
}
  8003f8:	90                   	nop
  8003f9:	c9                   	leave  
  8003fa:	c3                   	ret    

008003fb <exit>:

void
exit(void)
{
  8003fb:	55                   	push   %ebp
  8003fc:	89 e5                	mov    %esp,%ebp
  8003fe:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800401:	e8 36 2d 00 00       	call   80313c <sys_exit_env>
}
  800406:	90                   	nop
  800407:	c9                   	leave  
  800408:	c3                   	ret    

00800409 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800409:	55                   	push   %ebp
  80040a:	89 e5                	mov    %esp,%ebp
  80040c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80040f:	8d 45 10             	lea    0x10(%ebp),%eax
  800412:	83 c0 04             	add    $0x4,%eax
  800415:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800418:	a1 38 51 83 00       	mov    0x835138,%eax
  80041d:	85 c0                	test   %eax,%eax
  80041f:	74 16                	je     800437 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800421:	a1 38 51 83 00       	mov    0x835138,%eax
  800426:	83 ec 08             	sub    $0x8,%esp
  800429:	50                   	push   %eax
  80042a:	68 40 44 80 00       	push   $0x804440
  80042f:	e8 a3 02 00 00       	call   8006d7 <cprintf>
  800434:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800437:	a1 04 50 80 00       	mov    0x805004,%eax
  80043c:	83 ec 0c             	sub    $0xc,%esp
  80043f:	ff 75 0c             	pushl  0xc(%ebp)
  800442:	ff 75 08             	pushl  0x8(%ebp)
  800445:	50                   	push   %eax
  800446:	68 48 44 80 00       	push   $0x804448
  80044b:	6a 74                	push   $0x74
  80044d:	e8 b2 02 00 00       	call   800704 <cprintf_colored>
  800452:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800455:	8b 45 10             	mov    0x10(%ebp),%eax
  800458:	83 ec 08             	sub    $0x8,%esp
  80045b:	ff 75 f4             	pushl  -0xc(%ebp)
  80045e:	50                   	push   %eax
  80045f:	e8 04 02 00 00       	call   800668 <vcprintf>
  800464:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800467:	83 ec 08             	sub    $0x8,%esp
  80046a:	6a 00                	push   $0x0
  80046c:	68 70 44 80 00       	push   $0x804470
  800471:	e8 f2 01 00 00       	call   800668 <vcprintf>
  800476:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800479:	e8 7d ff ff ff       	call   8003fb <exit>

	// should not return here
	while (1) ;
  80047e:	eb fe                	jmp    80047e <_panic+0x75>

00800480 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800480:	55                   	push   %ebp
  800481:	89 e5                	mov    %esp,%ebp
  800483:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800486:	a1 20 50 80 00       	mov    0x805020,%eax
  80048b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800491:	8b 45 0c             	mov    0xc(%ebp),%eax
  800494:	39 c2                	cmp    %eax,%edx
  800496:	74 14                	je     8004ac <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800498:	83 ec 04             	sub    $0x4,%esp
  80049b:	68 74 44 80 00       	push   $0x804474
  8004a0:	6a 26                	push   $0x26
  8004a2:	68 c0 44 80 00       	push   $0x8044c0
  8004a7:	e8 5d ff ff ff       	call   800409 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8004ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8004b3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004ba:	e9 c5 00 00 00       	jmp    800584 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8004bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004c2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cc:	01 d0                	add    %edx,%eax
  8004ce:	8b 00                	mov    (%eax),%eax
  8004d0:	85 c0                	test   %eax,%eax
  8004d2:	75 08                	jne    8004dc <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8004d4:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004d7:	e9 a5 00 00 00       	jmp    800581 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8004dc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004e3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8004ea:	eb 69                	jmp    800555 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8004ec:	a1 20 50 80 00       	mov    0x805020,%eax
  8004f1:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8004f7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004fa:	89 d0                	mov    %edx,%eax
  8004fc:	01 c0                	add    %eax,%eax
  8004fe:	01 d0                	add    %edx,%eax
  800500:	c1 e0 03             	shl    $0x3,%eax
  800503:	01 c8                	add    %ecx,%eax
  800505:	8a 40 04             	mov    0x4(%eax),%al
  800508:	84 c0                	test   %al,%al
  80050a:	75 46                	jne    800552 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80050c:	a1 20 50 80 00       	mov    0x805020,%eax
  800511:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800517:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80051a:	89 d0                	mov    %edx,%eax
  80051c:	01 c0                	add    %eax,%eax
  80051e:	01 d0                	add    %edx,%eax
  800520:	c1 e0 03             	shl    $0x3,%eax
  800523:	01 c8                	add    %ecx,%eax
  800525:	8b 00                	mov    (%eax),%eax
  800527:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80052a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80052d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800532:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800534:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800537:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80053e:	8b 45 08             	mov    0x8(%ebp),%eax
  800541:	01 c8                	add    %ecx,%eax
  800543:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800545:	39 c2                	cmp    %eax,%edx
  800547:	75 09                	jne    800552 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800549:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800550:	eb 15                	jmp    800567 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800552:	ff 45 e8             	incl   -0x18(%ebp)
  800555:	a1 20 50 80 00       	mov    0x805020,%eax
  80055a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800560:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800563:	39 c2                	cmp    %eax,%edx
  800565:	77 85                	ja     8004ec <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800567:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80056b:	75 14                	jne    800581 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80056d:	83 ec 04             	sub    $0x4,%esp
  800570:	68 cc 44 80 00       	push   $0x8044cc
  800575:	6a 3a                	push   $0x3a
  800577:	68 c0 44 80 00       	push   $0x8044c0
  80057c:	e8 88 fe ff ff       	call   800409 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800581:	ff 45 f0             	incl   -0x10(%ebp)
  800584:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800587:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80058a:	0f 8c 2f ff ff ff    	jl     8004bf <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800590:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800597:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80059e:	eb 26                	jmp    8005c6 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8005a0:	a1 20 50 80 00       	mov    0x805020,%eax
  8005a5:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8005ab:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005ae:	89 d0                	mov    %edx,%eax
  8005b0:	01 c0                	add    %eax,%eax
  8005b2:	01 d0                	add    %edx,%eax
  8005b4:	c1 e0 03             	shl    $0x3,%eax
  8005b7:	01 c8                	add    %ecx,%eax
  8005b9:	8a 40 04             	mov    0x4(%eax),%al
  8005bc:	3c 01                	cmp    $0x1,%al
  8005be:	75 03                	jne    8005c3 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8005c0:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005c3:	ff 45 e0             	incl   -0x20(%ebp)
  8005c6:	a1 20 50 80 00       	mov    0x805020,%eax
  8005cb:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005d4:	39 c2                	cmp    %eax,%edx
  8005d6:	77 c8                	ja     8005a0 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005db:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005de:	74 14                	je     8005f4 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8005e0:	83 ec 04             	sub    $0x4,%esp
  8005e3:	68 20 45 80 00       	push   $0x804520
  8005e8:	6a 44                	push   $0x44
  8005ea:	68 c0 44 80 00       	push   $0x8044c0
  8005ef:	e8 15 fe ff ff       	call   800409 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8005f4:	90                   	nop
  8005f5:	c9                   	leave  
  8005f6:	c3                   	ret    

008005f7 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8005f7:	55                   	push   %ebp
  8005f8:	89 e5                	mov    %esp,%ebp
  8005fa:	53                   	push   %ebx
  8005fb:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8005fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800601:	8b 00                	mov    (%eax),%eax
  800603:	8d 48 01             	lea    0x1(%eax),%ecx
  800606:	8b 55 0c             	mov    0xc(%ebp),%edx
  800609:	89 0a                	mov    %ecx,(%edx)
  80060b:	8b 55 08             	mov    0x8(%ebp),%edx
  80060e:	88 d1                	mov    %dl,%cl
  800610:	8b 55 0c             	mov    0xc(%ebp),%edx
  800613:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800617:	8b 45 0c             	mov    0xc(%ebp),%eax
  80061a:	8b 00                	mov    (%eax),%eax
  80061c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800621:	75 30                	jne    800653 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800623:	8b 15 3c 51 83 00    	mov    0x83513c,%edx
  800629:	a0 64 d0 81 00       	mov    0x81d064,%al
  80062e:	0f b6 c0             	movzbl %al,%eax
  800631:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800634:	8b 09                	mov    (%ecx),%ecx
  800636:	89 cb                	mov    %ecx,%ebx
  800638:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80063b:	83 c1 08             	add    $0x8,%ecx
  80063e:	52                   	push   %edx
  80063f:	50                   	push   %eax
  800640:	53                   	push   %ebx
  800641:	51                   	push   %ecx
  800642:	e8 06 28 00 00       	call   802e4d <sys_cputs>
  800647:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80064a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80064d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800653:	8b 45 0c             	mov    0xc(%ebp),%eax
  800656:	8b 40 04             	mov    0x4(%eax),%eax
  800659:	8d 50 01             	lea    0x1(%eax),%edx
  80065c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80065f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800662:	90                   	nop
  800663:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800666:	c9                   	leave  
  800667:	c3                   	ret    

00800668 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800668:	55                   	push   %ebp
  800669:	89 e5                	mov    %esp,%ebp
  80066b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800671:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800678:	00 00 00 
	b.cnt = 0;
  80067b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800682:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800685:	ff 75 0c             	pushl  0xc(%ebp)
  800688:	ff 75 08             	pushl  0x8(%ebp)
  80068b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800691:	50                   	push   %eax
  800692:	68 f7 05 80 00       	push   $0x8005f7
  800697:	e8 5a 02 00 00       	call   8008f6 <vprintfmt>
  80069c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80069f:	8b 15 3c 51 83 00    	mov    0x83513c,%edx
  8006a5:	a0 64 d0 81 00       	mov    0x81d064,%al
  8006aa:	0f b6 c0             	movzbl %al,%eax
  8006ad:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8006b3:	52                   	push   %edx
  8006b4:	50                   	push   %eax
  8006b5:	51                   	push   %ecx
  8006b6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006bc:	83 c0 08             	add    $0x8,%eax
  8006bf:	50                   	push   %eax
  8006c0:	e8 88 27 00 00       	call   802e4d <sys_cputs>
  8006c5:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8006c8:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
	return b.cnt;
  8006cf:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006d5:	c9                   	leave  
  8006d6:	c3                   	ret    

008006d7 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8006d7:	55                   	push   %ebp
  8006d8:	89 e5                	mov    %esp,%ebp
  8006da:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006dd:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	va_start(ap, fmt);
  8006e4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ed:	83 ec 08             	sub    $0x8,%esp
  8006f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8006f3:	50                   	push   %eax
  8006f4:	e8 6f ff ff ff       	call   800668 <vcprintf>
  8006f9:	83 c4 10             	add    $0x10,%esp
  8006fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800702:	c9                   	leave  
  800703:	c3                   	ret    

00800704 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800704:	55                   	push   %ebp
  800705:	89 e5                	mov    %esp,%ebp
  800707:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80070a:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	curTextClr = (textClr << 8) ; //set text color by the given value
  800711:	8b 45 08             	mov    0x8(%ebp),%eax
  800714:	c1 e0 08             	shl    $0x8,%eax
  800717:	a3 3c 51 83 00       	mov    %eax,0x83513c
	va_start(ap, fmt);
  80071c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80071f:	83 c0 04             	add    $0x4,%eax
  800722:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800725:	8b 45 0c             	mov    0xc(%ebp),%eax
  800728:	83 ec 08             	sub    $0x8,%esp
  80072b:	ff 75 f4             	pushl  -0xc(%ebp)
  80072e:	50                   	push   %eax
  80072f:	e8 34 ff ff ff       	call   800668 <vcprintf>
  800734:	83 c4 10             	add    $0x10,%esp
  800737:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80073a:	c7 05 3c 51 83 00 00 	movl   $0x700,0x83513c
  800741:	07 00 00 

	return cnt;
  800744:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800747:	c9                   	leave  
  800748:	c3                   	ret    

00800749 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800749:	55                   	push   %ebp
  80074a:	89 e5                	mov    %esp,%ebp
  80074c:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80074f:	e8 3d 27 00 00       	call   802e91 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800754:	8d 45 0c             	lea    0xc(%ebp),%eax
  800757:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	83 ec 08             	sub    $0x8,%esp
  800760:	ff 75 f4             	pushl  -0xc(%ebp)
  800763:	50                   	push   %eax
  800764:	e8 ff fe ff ff       	call   800668 <vcprintf>
  800769:	83 c4 10             	add    $0x10,%esp
  80076c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80076f:	e8 37 27 00 00       	call   802eab <sys_unlock_cons>
	return cnt;
  800774:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800777:	c9                   	leave  
  800778:	c3                   	ret    

00800779 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800779:	55                   	push   %ebp
  80077a:	89 e5                	mov    %esp,%ebp
  80077c:	53                   	push   %ebx
  80077d:	83 ec 14             	sub    $0x14,%esp
  800780:	8b 45 10             	mov    0x10(%ebp),%eax
  800783:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800786:	8b 45 14             	mov    0x14(%ebp),%eax
  800789:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80078c:	8b 45 18             	mov    0x18(%ebp),%eax
  80078f:	ba 00 00 00 00       	mov    $0x0,%edx
  800794:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800797:	77 55                	ja     8007ee <printnum+0x75>
  800799:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80079c:	72 05                	jb     8007a3 <printnum+0x2a>
  80079e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007a1:	77 4b                	ja     8007ee <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007a3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007a6:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007a9:	8b 45 18             	mov    0x18(%ebp),%eax
  8007ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b1:	52                   	push   %edx
  8007b2:	50                   	push   %eax
  8007b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8007b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8007b9:	e8 a6 36 00 00       	call   803e64 <__udivdi3>
  8007be:	83 c4 10             	add    $0x10,%esp
  8007c1:	83 ec 04             	sub    $0x4,%esp
  8007c4:	ff 75 20             	pushl  0x20(%ebp)
  8007c7:	53                   	push   %ebx
  8007c8:	ff 75 18             	pushl  0x18(%ebp)
  8007cb:	52                   	push   %edx
  8007cc:	50                   	push   %eax
  8007cd:	ff 75 0c             	pushl  0xc(%ebp)
  8007d0:	ff 75 08             	pushl  0x8(%ebp)
  8007d3:	e8 a1 ff ff ff       	call   800779 <printnum>
  8007d8:	83 c4 20             	add    $0x20,%esp
  8007db:	eb 1a                	jmp    8007f7 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007dd:	83 ec 08             	sub    $0x8,%esp
  8007e0:	ff 75 0c             	pushl  0xc(%ebp)
  8007e3:	ff 75 20             	pushl  0x20(%ebp)
  8007e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e9:	ff d0                	call   *%eax
  8007eb:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007ee:	ff 4d 1c             	decl   0x1c(%ebp)
  8007f1:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8007f5:	7f e6                	jg     8007dd <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007f7:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8007fa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800802:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800805:	53                   	push   %ebx
  800806:	51                   	push   %ecx
  800807:	52                   	push   %edx
  800808:	50                   	push   %eax
  800809:	e8 66 37 00 00       	call   803f74 <__umoddi3>
  80080e:	83 c4 10             	add    $0x10,%esp
  800811:	05 94 47 80 00       	add    $0x804794,%eax
  800816:	8a 00                	mov    (%eax),%al
  800818:	0f be c0             	movsbl %al,%eax
  80081b:	83 ec 08             	sub    $0x8,%esp
  80081e:	ff 75 0c             	pushl  0xc(%ebp)
  800821:	50                   	push   %eax
  800822:	8b 45 08             	mov    0x8(%ebp),%eax
  800825:	ff d0                	call   *%eax
  800827:	83 c4 10             	add    $0x10,%esp
}
  80082a:	90                   	nop
  80082b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80082e:	c9                   	leave  
  80082f:	c3                   	ret    

00800830 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800830:	55                   	push   %ebp
  800831:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800833:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800837:	7e 1c                	jle    800855 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800839:	8b 45 08             	mov    0x8(%ebp),%eax
  80083c:	8b 00                	mov    (%eax),%eax
  80083e:	8d 50 08             	lea    0x8(%eax),%edx
  800841:	8b 45 08             	mov    0x8(%ebp),%eax
  800844:	89 10                	mov    %edx,(%eax)
  800846:	8b 45 08             	mov    0x8(%ebp),%eax
  800849:	8b 00                	mov    (%eax),%eax
  80084b:	83 e8 08             	sub    $0x8,%eax
  80084e:	8b 50 04             	mov    0x4(%eax),%edx
  800851:	8b 00                	mov    (%eax),%eax
  800853:	eb 40                	jmp    800895 <getuint+0x65>
	else if (lflag)
  800855:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800859:	74 1e                	je     800879 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80085b:	8b 45 08             	mov    0x8(%ebp),%eax
  80085e:	8b 00                	mov    (%eax),%eax
  800860:	8d 50 04             	lea    0x4(%eax),%edx
  800863:	8b 45 08             	mov    0x8(%ebp),%eax
  800866:	89 10                	mov    %edx,(%eax)
  800868:	8b 45 08             	mov    0x8(%ebp),%eax
  80086b:	8b 00                	mov    (%eax),%eax
  80086d:	83 e8 04             	sub    $0x4,%eax
  800870:	8b 00                	mov    (%eax),%eax
  800872:	ba 00 00 00 00       	mov    $0x0,%edx
  800877:	eb 1c                	jmp    800895 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800879:	8b 45 08             	mov    0x8(%ebp),%eax
  80087c:	8b 00                	mov    (%eax),%eax
  80087e:	8d 50 04             	lea    0x4(%eax),%edx
  800881:	8b 45 08             	mov    0x8(%ebp),%eax
  800884:	89 10                	mov    %edx,(%eax)
  800886:	8b 45 08             	mov    0x8(%ebp),%eax
  800889:	8b 00                	mov    (%eax),%eax
  80088b:	83 e8 04             	sub    $0x4,%eax
  80088e:	8b 00                	mov    (%eax),%eax
  800890:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800895:	5d                   	pop    %ebp
  800896:	c3                   	ret    

00800897 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800897:	55                   	push   %ebp
  800898:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80089a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80089e:	7e 1c                	jle    8008bc <getint+0x25>
		return va_arg(*ap, long long);
  8008a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a3:	8b 00                	mov    (%eax),%eax
  8008a5:	8d 50 08             	lea    0x8(%eax),%edx
  8008a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ab:	89 10                	mov    %edx,(%eax)
  8008ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b0:	8b 00                	mov    (%eax),%eax
  8008b2:	83 e8 08             	sub    $0x8,%eax
  8008b5:	8b 50 04             	mov    0x4(%eax),%edx
  8008b8:	8b 00                	mov    (%eax),%eax
  8008ba:	eb 38                	jmp    8008f4 <getint+0x5d>
	else if (lflag)
  8008bc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008c0:	74 1a                	je     8008dc <getint+0x45>
		return va_arg(*ap, long);
  8008c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c5:	8b 00                	mov    (%eax),%eax
  8008c7:	8d 50 04             	lea    0x4(%eax),%edx
  8008ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cd:	89 10                	mov    %edx,(%eax)
  8008cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d2:	8b 00                	mov    (%eax),%eax
  8008d4:	83 e8 04             	sub    $0x4,%eax
  8008d7:	8b 00                	mov    (%eax),%eax
  8008d9:	99                   	cltd   
  8008da:	eb 18                	jmp    8008f4 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8008dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008df:	8b 00                	mov    (%eax),%eax
  8008e1:	8d 50 04             	lea    0x4(%eax),%edx
  8008e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e7:	89 10                	mov    %edx,(%eax)
  8008e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ec:	8b 00                	mov    (%eax),%eax
  8008ee:	83 e8 04             	sub    $0x4,%eax
  8008f1:	8b 00                	mov    (%eax),%eax
  8008f3:	99                   	cltd   
}
  8008f4:	5d                   	pop    %ebp
  8008f5:	c3                   	ret    

008008f6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008f6:	55                   	push   %ebp
  8008f7:	89 e5                	mov    %esp,%ebp
  8008f9:	56                   	push   %esi
  8008fa:	53                   	push   %ebx
  8008fb:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008fe:	eb 17                	jmp    800917 <vprintfmt+0x21>
			if (ch == '\0')
  800900:	85 db                	test   %ebx,%ebx
  800902:	0f 84 c1 03 00 00    	je     800cc9 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800908:	83 ec 08             	sub    $0x8,%esp
  80090b:	ff 75 0c             	pushl  0xc(%ebp)
  80090e:	53                   	push   %ebx
  80090f:	8b 45 08             	mov    0x8(%ebp),%eax
  800912:	ff d0                	call   *%eax
  800914:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800917:	8b 45 10             	mov    0x10(%ebp),%eax
  80091a:	8d 50 01             	lea    0x1(%eax),%edx
  80091d:	89 55 10             	mov    %edx,0x10(%ebp)
  800920:	8a 00                	mov    (%eax),%al
  800922:	0f b6 d8             	movzbl %al,%ebx
  800925:	83 fb 25             	cmp    $0x25,%ebx
  800928:	75 d6                	jne    800900 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80092a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80092e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800935:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80093c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800943:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80094a:	8b 45 10             	mov    0x10(%ebp),%eax
  80094d:	8d 50 01             	lea    0x1(%eax),%edx
  800950:	89 55 10             	mov    %edx,0x10(%ebp)
  800953:	8a 00                	mov    (%eax),%al
  800955:	0f b6 d8             	movzbl %al,%ebx
  800958:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80095b:	83 f8 5b             	cmp    $0x5b,%eax
  80095e:	0f 87 3d 03 00 00    	ja     800ca1 <vprintfmt+0x3ab>
  800964:	8b 04 85 b8 47 80 00 	mov    0x8047b8(,%eax,4),%eax
  80096b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80096d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800971:	eb d7                	jmp    80094a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800973:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800977:	eb d1                	jmp    80094a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800979:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800980:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800983:	89 d0                	mov    %edx,%eax
  800985:	c1 e0 02             	shl    $0x2,%eax
  800988:	01 d0                	add    %edx,%eax
  80098a:	01 c0                	add    %eax,%eax
  80098c:	01 d8                	add    %ebx,%eax
  80098e:	83 e8 30             	sub    $0x30,%eax
  800991:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800994:	8b 45 10             	mov    0x10(%ebp),%eax
  800997:	8a 00                	mov    (%eax),%al
  800999:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80099c:	83 fb 2f             	cmp    $0x2f,%ebx
  80099f:	7e 3e                	jle    8009df <vprintfmt+0xe9>
  8009a1:	83 fb 39             	cmp    $0x39,%ebx
  8009a4:	7f 39                	jg     8009df <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009a6:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009a9:	eb d5                	jmp    800980 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ae:	83 c0 04             	add    $0x4,%eax
  8009b1:	89 45 14             	mov    %eax,0x14(%ebp)
  8009b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b7:	83 e8 04             	sub    $0x4,%eax
  8009ba:	8b 00                	mov    (%eax),%eax
  8009bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009bf:	eb 1f                	jmp    8009e0 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009c1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009c5:	79 83                	jns    80094a <vprintfmt+0x54>
				width = 0;
  8009c7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8009ce:	e9 77 ff ff ff       	jmp    80094a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8009d3:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8009da:	e9 6b ff ff ff       	jmp    80094a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8009df:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8009e0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009e4:	0f 89 60 ff ff ff    	jns    80094a <vprintfmt+0x54>
				width = precision, precision = -1;
  8009ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009f0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8009f7:	e9 4e ff ff ff       	jmp    80094a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009fc:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8009ff:	e9 46 ff ff ff       	jmp    80094a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a04:	8b 45 14             	mov    0x14(%ebp),%eax
  800a07:	83 c0 04             	add    $0x4,%eax
  800a0a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a0d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a10:	83 e8 04             	sub    $0x4,%eax
  800a13:	8b 00                	mov    (%eax),%eax
  800a15:	83 ec 08             	sub    $0x8,%esp
  800a18:	ff 75 0c             	pushl  0xc(%ebp)
  800a1b:	50                   	push   %eax
  800a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1f:	ff d0                	call   *%eax
  800a21:	83 c4 10             	add    $0x10,%esp
			break;
  800a24:	e9 9b 02 00 00       	jmp    800cc4 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a29:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2c:	83 c0 04             	add    $0x4,%eax
  800a2f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a32:	8b 45 14             	mov    0x14(%ebp),%eax
  800a35:	83 e8 04             	sub    $0x4,%eax
  800a38:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a3a:	85 db                	test   %ebx,%ebx
  800a3c:	79 02                	jns    800a40 <vprintfmt+0x14a>
				err = -err;
  800a3e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a40:	83 fb 64             	cmp    $0x64,%ebx
  800a43:	7f 0b                	jg     800a50 <vprintfmt+0x15a>
  800a45:	8b 34 9d 00 46 80 00 	mov    0x804600(,%ebx,4),%esi
  800a4c:	85 f6                	test   %esi,%esi
  800a4e:	75 19                	jne    800a69 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a50:	53                   	push   %ebx
  800a51:	68 a5 47 80 00       	push   $0x8047a5
  800a56:	ff 75 0c             	pushl  0xc(%ebp)
  800a59:	ff 75 08             	pushl  0x8(%ebp)
  800a5c:	e8 70 02 00 00       	call   800cd1 <printfmt>
  800a61:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a64:	e9 5b 02 00 00       	jmp    800cc4 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a69:	56                   	push   %esi
  800a6a:	68 ae 47 80 00       	push   $0x8047ae
  800a6f:	ff 75 0c             	pushl  0xc(%ebp)
  800a72:	ff 75 08             	pushl  0x8(%ebp)
  800a75:	e8 57 02 00 00       	call   800cd1 <printfmt>
  800a7a:	83 c4 10             	add    $0x10,%esp
			break;
  800a7d:	e9 42 02 00 00       	jmp    800cc4 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a82:	8b 45 14             	mov    0x14(%ebp),%eax
  800a85:	83 c0 04             	add    $0x4,%eax
  800a88:	89 45 14             	mov    %eax,0x14(%ebp)
  800a8b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8e:	83 e8 04             	sub    $0x4,%eax
  800a91:	8b 30                	mov    (%eax),%esi
  800a93:	85 f6                	test   %esi,%esi
  800a95:	75 05                	jne    800a9c <vprintfmt+0x1a6>
				p = "(null)";
  800a97:	be b1 47 80 00       	mov    $0x8047b1,%esi
			if (width > 0 && padc != '-')
  800a9c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aa0:	7e 6d                	jle    800b0f <vprintfmt+0x219>
  800aa2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800aa6:	74 67                	je     800b0f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800aa8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800aab:	83 ec 08             	sub    $0x8,%esp
  800aae:	50                   	push   %eax
  800aaf:	56                   	push   %esi
  800ab0:	e8 1e 03 00 00       	call   800dd3 <strnlen>
  800ab5:	83 c4 10             	add    $0x10,%esp
  800ab8:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800abb:	eb 16                	jmp    800ad3 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800abd:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ac1:	83 ec 08             	sub    $0x8,%esp
  800ac4:	ff 75 0c             	pushl  0xc(%ebp)
  800ac7:	50                   	push   %eax
  800ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  800acb:	ff d0                	call   *%eax
  800acd:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ad0:	ff 4d e4             	decl   -0x1c(%ebp)
  800ad3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ad7:	7f e4                	jg     800abd <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ad9:	eb 34                	jmp    800b0f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800adb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800adf:	74 1c                	je     800afd <vprintfmt+0x207>
  800ae1:	83 fb 1f             	cmp    $0x1f,%ebx
  800ae4:	7e 05                	jle    800aeb <vprintfmt+0x1f5>
  800ae6:	83 fb 7e             	cmp    $0x7e,%ebx
  800ae9:	7e 12                	jle    800afd <vprintfmt+0x207>
					putch('?', putdat);
  800aeb:	83 ec 08             	sub    $0x8,%esp
  800aee:	ff 75 0c             	pushl  0xc(%ebp)
  800af1:	6a 3f                	push   $0x3f
  800af3:	8b 45 08             	mov    0x8(%ebp),%eax
  800af6:	ff d0                	call   *%eax
  800af8:	83 c4 10             	add    $0x10,%esp
  800afb:	eb 0f                	jmp    800b0c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800afd:	83 ec 08             	sub    $0x8,%esp
  800b00:	ff 75 0c             	pushl  0xc(%ebp)
  800b03:	53                   	push   %ebx
  800b04:	8b 45 08             	mov    0x8(%ebp),%eax
  800b07:	ff d0                	call   *%eax
  800b09:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b0c:	ff 4d e4             	decl   -0x1c(%ebp)
  800b0f:	89 f0                	mov    %esi,%eax
  800b11:	8d 70 01             	lea    0x1(%eax),%esi
  800b14:	8a 00                	mov    (%eax),%al
  800b16:	0f be d8             	movsbl %al,%ebx
  800b19:	85 db                	test   %ebx,%ebx
  800b1b:	74 24                	je     800b41 <vprintfmt+0x24b>
  800b1d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b21:	78 b8                	js     800adb <vprintfmt+0x1e5>
  800b23:	ff 4d e0             	decl   -0x20(%ebp)
  800b26:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b2a:	79 af                	jns    800adb <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b2c:	eb 13                	jmp    800b41 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b2e:	83 ec 08             	sub    $0x8,%esp
  800b31:	ff 75 0c             	pushl  0xc(%ebp)
  800b34:	6a 20                	push   $0x20
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	ff d0                	call   *%eax
  800b3b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b3e:	ff 4d e4             	decl   -0x1c(%ebp)
  800b41:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b45:	7f e7                	jg     800b2e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b47:	e9 78 01 00 00       	jmp    800cc4 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b4c:	83 ec 08             	sub    $0x8,%esp
  800b4f:	ff 75 e8             	pushl  -0x18(%ebp)
  800b52:	8d 45 14             	lea    0x14(%ebp),%eax
  800b55:	50                   	push   %eax
  800b56:	e8 3c fd ff ff       	call   800897 <getint>
  800b5b:	83 c4 10             	add    $0x10,%esp
  800b5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b61:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b67:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b6a:	85 d2                	test   %edx,%edx
  800b6c:	79 23                	jns    800b91 <vprintfmt+0x29b>
				putch('-', putdat);
  800b6e:	83 ec 08             	sub    $0x8,%esp
  800b71:	ff 75 0c             	pushl  0xc(%ebp)
  800b74:	6a 2d                	push   $0x2d
  800b76:	8b 45 08             	mov    0x8(%ebp),%eax
  800b79:	ff d0                	call   *%eax
  800b7b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b84:	f7 d8                	neg    %eax
  800b86:	83 d2 00             	adc    $0x0,%edx
  800b89:	f7 da                	neg    %edx
  800b8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b8e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b91:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b98:	e9 bc 00 00 00       	jmp    800c59 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b9d:	83 ec 08             	sub    $0x8,%esp
  800ba0:	ff 75 e8             	pushl  -0x18(%ebp)
  800ba3:	8d 45 14             	lea    0x14(%ebp),%eax
  800ba6:	50                   	push   %eax
  800ba7:	e8 84 fc ff ff       	call   800830 <getuint>
  800bac:	83 c4 10             	add    $0x10,%esp
  800baf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bb5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bbc:	e9 98 00 00 00       	jmp    800c59 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800bc1:	83 ec 08             	sub    $0x8,%esp
  800bc4:	ff 75 0c             	pushl  0xc(%ebp)
  800bc7:	6a 58                	push   $0x58
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	ff d0                	call   *%eax
  800bce:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bd1:	83 ec 08             	sub    $0x8,%esp
  800bd4:	ff 75 0c             	pushl  0xc(%ebp)
  800bd7:	6a 58                	push   $0x58
  800bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdc:	ff d0                	call   *%eax
  800bde:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800be1:	83 ec 08             	sub    $0x8,%esp
  800be4:	ff 75 0c             	pushl  0xc(%ebp)
  800be7:	6a 58                	push   $0x58
  800be9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bec:	ff d0                	call   *%eax
  800bee:	83 c4 10             	add    $0x10,%esp
			break;
  800bf1:	e9 ce 00 00 00       	jmp    800cc4 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800bf6:	83 ec 08             	sub    $0x8,%esp
  800bf9:	ff 75 0c             	pushl  0xc(%ebp)
  800bfc:	6a 30                	push   $0x30
  800bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800c01:	ff d0                	call   *%eax
  800c03:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c06:	83 ec 08             	sub    $0x8,%esp
  800c09:	ff 75 0c             	pushl  0xc(%ebp)
  800c0c:	6a 78                	push   $0x78
  800c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c11:	ff d0                	call   *%eax
  800c13:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c16:	8b 45 14             	mov    0x14(%ebp),%eax
  800c19:	83 c0 04             	add    $0x4,%eax
  800c1c:	89 45 14             	mov    %eax,0x14(%ebp)
  800c1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c22:	83 e8 04             	sub    $0x4,%eax
  800c25:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c27:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c2a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c31:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c38:	eb 1f                	jmp    800c59 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c3a:	83 ec 08             	sub    $0x8,%esp
  800c3d:	ff 75 e8             	pushl  -0x18(%ebp)
  800c40:	8d 45 14             	lea    0x14(%ebp),%eax
  800c43:	50                   	push   %eax
  800c44:	e8 e7 fb ff ff       	call   800830 <getuint>
  800c49:	83 c4 10             	add    $0x10,%esp
  800c4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c4f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c52:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c59:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c60:	83 ec 04             	sub    $0x4,%esp
  800c63:	52                   	push   %edx
  800c64:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c67:	50                   	push   %eax
  800c68:	ff 75 f4             	pushl  -0xc(%ebp)
  800c6b:	ff 75 f0             	pushl  -0x10(%ebp)
  800c6e:	ff 75 0c             	pushl  0xc(%ebp)
  800c71:	ff 75 08             	pushl  0x8(%ebp)
  800c74:	e8 00 fb ff ff       	call   800779 <printnum>
  800c79:	83 c4 20             	add    $0x20,%esp
			break;
  800c7c:	eb 46                	jmp    800cc4 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c7e:	83 ec 08             	sub    $0x8,%esp
  800c81:	ff 75 0c             	pushl  0xc(%ebp)
  800c84:	53                   	push   %ebx
  800c85:	8b 45 08             	mov    0x8(%ebp),%eax
  800c88:	ff d0                	call   *%eax
  800c8a:	83 c4 10             	add    $0x10,%esp
			break;
  800c8d:	eb 35                	jmp    800cc4 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800c8f:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
			break;
  800c96:	eb 2c                	jmp    800cc4 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c98:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
			break;
  800c9f:	eb 23                	jmp    800cc4 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ca1:	83 ec 08             	sub    $0x8,%esp
  800ca4:	ff 75 0c             	pushl  0xc(%ebp)
  800ca7:	6a 25                	push   $0x25
  800ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cac:	ff d0                	call   *%eax
  800cae:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cb1:	ff 4d 10             	decl   0x10(%ebp)
  800cb4:	eb 03                	jmp    800cb9 <vprintfmt+0x3c3>
  800cb6:	ff 4d 10             	decl   0x10(%ebp)
  800cb9:	8b 45 10             	mov    0x10(%ebp),%eax
  800cbc:	48                   	dec    %eax
  800cbd:	8a 00                	mov    (%eax),%al
  800cbf:	3c 25                	cmp    $0x25,%al
  800cc1:	75 f3                	jne    800cb6 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800cc3:	90                   	nop
		}
	}
  800cc4:	e9 35 fc ff ff       	jmp    8008fe <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800cc9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800cca:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ccd:	5b                   	pop    %ebx
  800cce:	5e                   	pop    %esi
  800ccf:	5d                   	pop    %ebp
  800cd0:	c3                   	ret    

00800cd1 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cd1:	55                   	push   %ebp
  800cd2:	89 e5                	mov    %esp,%ebp
  800cd4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800cd7:	8d 45 10             	lea    0x10(%ebp),%eax
  800cda:	83 c0 04             	add    $0x4,%eax
  800cdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ce0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce3:	ff 75 f4             	pushl  -0xc(%ebp)
  800ce6:	50                   	push   %eax
  800ce7:	ff 75 0c             	pushl  0xc(%ebp)
  800cea:	ff 75 08             	pushl  0x8(%ebp)
  800ced:	e8 04 fc ff ff       	call   8008f6 <vprintfmt>
  800cf2:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800cf5:	90                   	nop
  800cf6:	c9                   	leave  
  800cf7:	c3                   	ret    

00800cf8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800cf8:	55                   	push   %ebp
  800cf9:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800cfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfe:	8b 40 08             	mov    0x8(%eax),%eax
  800d01:	8d 50 01             	lea    0x1(%eax),%edx
  800d04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d07:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0d:	8b 10                	mov    (%eax),%edx
  800d0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d12:	8b 40 04             	mov    0x4(%eax),%eax
  800d15:	39 c2                	cmp    %eax,%edx
  800d17:	73 12                	jae    800d2b <sprintputch+0x33>
		*b->buf++ = ch;
  800d19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1c:	8b 00                	mov    (%eax),%eax
  800d1e:	8d 48 01             	lea    0x1(%eax),%ecx
  800d21:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d24:	89 0a                	mov    %ecx,(%edx)
  800d26:	8b 55 08             	mov    0x8(%ebp),%edx
  800d29:	88 10                	mov    %dl,(%eax)
}
  800d2b:	90                   	nop
  800d2c:	5d                   	pop    %ebp
  800d2d:	c3                   	ret    

00800d2e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d2e:	55                   	push   %ebp
  800d2f:	89 e5                	mov    %esp,%ebp
  800d31:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d40:	8b 45 08             	mov    0x8(%ebp),%eax
  800d43:	01 d0                	add    %edx,%eax
  800d45:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d48:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d4f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d53:	74 06                	je     800d5b <vsnprintf+0x2d>
  800d55:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d59:	7f 07                	jg     800d62 <vsnprintf+0x34>
		return -E_INVAL;
  800d5b:	b8 03 00 00 00       	mov    $0x3,%eax
  800d60:	eb 20                	jmp    800d82 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d62:	ff 75 14             	pushl  0x14(%ebp)
  800d65:	ff 75 10             	pushl  0x10(%ebp)
  800d68:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d6b:	50                   	push   %eax
  800d6c:	68 f8 0c 80 00       	push   $0x800cf8
  800d71:	e8 80 fb ff ff       	call   8008f6 <vprintfmt>
  800d76:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d7c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d82:	c9                   	leave  
  800d83:	c3                   	ret    

00800d84 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d84:	55                   	push   %ebp
  800d85:	89 e5                	mov    %esp,%ebp
  800d87:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d8a:	8d 45 10             	lea    0x10(%ebp),%eax
  800d8d:	83 c0 04             	add    $0x4,%eax
  800d90:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d93:	8b 45 10             	mov    0x10(%ebp),%eax
  800d96:	ff 75 f4             	pushl  -0xc(%ebp)
  800d99:	50                   	push   %eax
  800d9a:	ff 75 0c             	pushl  0xc(%ebp)
  800d9d:	ff 75 08             	pushl  0x8(%ebp)
  800da0:	e8 89 ff ff ff       	call   800d2e <vsnprintf>
  800da5:	83 c4 10             	add    $0x10,%esp
  800da8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dab:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dae:	c9                   	leave  
  800daf:	c3                   	ret    

00800db0 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800db0:	55                   	push   %ebp
  800db1:	89 e5                	mov    %esp,%ebp
  800db3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800db6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dbd:	eb 06                	jmp    800dc5 <strlen+0x15>
		n++;
  800dbf:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800dc2:	ff 45 08             	incl   0x8(%ebp)
  800dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc8:	8a 00                	mov    (%eax),%al
  800dca:	84 c0                	test   %al,%al
  800dcc:	75 f1                	jne    800dbf <strlen+0xf>
		n++;
	return n;
  800dce:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dd1:	c9                   	leave  
  800dd2:	c3                   	ret    

00800dd3 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800dd3:	55                   	push   %ebp
  800dd4:	89 e5                	mov    %esp,%ebp
  800dd6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dd9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800de0:	eb 09                	jmp    800deb <strnlen+0x18>
		n++;
  800de2:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800de5:	ff 45 08             	incl   0x8(%ebp)
  800de8:	ff 4d 0c             	decl   0xc(%ebp)
  800deb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800def:	74 09                	je     800dfa <strnlen+0x27>
  800df1:	8b 45 08             	mov    0x8(%ebp),%eax
  800df4:	8a 00                	mov    (%eax),%al
  800df6:	84 c0                	test   %al,%al
  800df8:	75 e8                	jne    800de2 <strnlen+0xf>
		n++;
	return n;
  800dfa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dfd:	c9                   	leave  
  800dfe:	c3                   	ret    

00800dff <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800dff:	55                   	push   %ebp
  800e00:	89 e5                	mov    %esp,%ebp
  800e02:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
  800e08:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e0b:	90                   	nop
  800e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0f:	8d 50 01             	lea    0x1(%eax),%edx
  800e12:	89 55 08             	mov    %edx,0x8(%ebp)
  800e15:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e18:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e1b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e1e:	8a 12                	mov    (%edx),%dl
  800e20:	88 10                	mov    %dl,(%eax)
  800e22:	8a 00                	mov    (%eax),%al
  800e24:	84 c0                	test   %al,%al
  800e26:	75 e4                	jne    800e0c <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e28:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e2b:	c9                   	leave  
  800e2c:	c3                   	ret    

00800e2d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e2d:	55                   	push   %ebp
  800e2e:	89 e5                	mov    %esp,%ebp
  800e30:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e33:	8b 45 08             	mov    0x8(%ebp),%eax
  800e36:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e39:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e40:	eb 1f                	jmp    800e61 <strncpy+0x34>
		*dst++ = *src;
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	8d 50 01             	lea    0x1(%eax),%edx
  800e48:	89 55 08             	mov    %edx,0x8(%ebp)
  800e4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e4e:	8a 12                	mov    (%edx),%dl
  800e50:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e55:	8a 00                	mov    (%eax),%al
  800e57:	84 c0                	test   %al,%al
  800e59:	74 03                	je     800e5e <strncpy+0x31>
			src++;
  800e5b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e5e:	ff 45 fc             	incl   -0x4(%ebp)
  800e61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e64:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e67:	72 d9                	jb     800e42 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e69:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e6c:	c9                   	leave  
  800e6d:	c3                   	ret    

00800e6e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e6e:	55                   	push   %ebp
  800e6f:	89 e5                	mov    %esp,%ebp
  800e71:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
  800e77:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e7a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e7e:	74 30                	je     800eb0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e80:	eb 16                	jmp    800e98 <strlcpy+0x2a>
			*dst++ = *src++;
  800e82:	8b 45 08             	mov    0x8(%ebp),%eax
  800e85:	8d 50 01             	lea    0x1(%eax),%edx
  800e88:	89 55 08             	mov    %edx,0x8(%ebp)
  800e8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e8e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e91:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e94:	8a 12                	mov    (%edx),%dl
  800e96:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e98:	ff 4d 10             	decl   0x10(%ebp)
  800e9b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e9f:	74 09                	je     800eaa <strlcpy+0x3c>
  800ea1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea4:	8a 00                	mov    (%eax),%al
  800ea6:	84 c0                	test   %al,%al
  800ea8:	75 d8                	jne    800e82 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ead:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800eb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb6:	29 c2                	sub    %eax,%edx
  800eb8:	89 d0                	mov    %edx,%eax
}
  800eba:	c9                   	leave  
  800ebb:	c3                   	ret    

00800ebc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ebc:	55                   	push   %ebp
  800ebd:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ebf:	eb 06                	jmp    800ec7 <strcmp+0xb>
		p++, q++;
  800ec1:	ff 45 08             	incl   0x8(%ebp)
  800ec4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eca:	8a 00                	mov    (%eax),%al
  800ecc:	84 c0                	test   %al,%al
  800ece:	74 0e                	je     800ede <strcmp+0x22>
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed3:	8a 10                	mov    (%eax),%dl
  800ed5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed8:	8a 00                	mov    (%eax),%al
  800eda:	38 c2                	cmp    %al,%dl
  800edc:	74 e3                	je     800ec1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ede:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee1:	8a 00                	mov    (%eax),%al
  800ee3:	0f b6 d0             	movzbl %al,%edx
  800ee6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee9:	8a 00                	mov    (%eax),%al
  800eeb:	0f b6 c0             	movzbl %al,%eax
  800eee:	29 c2                	sub    %eax,%edx
  800ef0:	89 d0                	mov    %edx,%eax
}
  800ef2:	5d                   	pop    %ebp
  800ef3:	c3                   	ret    

00800ef4 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ef4:	55                   	push   %ebp
  800ef5:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800ef7:	eb 09                	jmp    800f02 <strncmp+0xe>
		n--, p++, q++;
  800ef9:	ff 4d 10             	decl   0x10(%ebp)
  800efc:	ff 45 08             	incl   0x8(%ebp)
  800eff:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f02:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f06:	74 17                	je     800f1f <strncmp+0x2b>
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0b:	8a 00                	mov    (%eax),%al
  800f0d:	84 c0                	test   %al,%al
  800f0f:	74 0e                	je     800f1f <strncmp+0x2b>
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	8a 10                	mov    (%eax),%dl
  800f16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f19:	8a 00                	mov    (%eax),%al
  800f1b:	38 c2                	cmp    %al,%dl
  800f1d:	74 da                	je     800ef9 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f1f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f23:	75 07                	jne    800f2c <strncmp+0x38>
		return 0;
  800f25:	b8 00 00 00 00       	mov    $0x0,%eax
  800f2a:	eb 14                	jmp    800f40 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	8a 00                	mov    (%eax),%al
  800f31:	0f b6 d0             	movzbl %al,%edx
  800f34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f37:	8a 00                	mov    (%eax),%al
  800f39:	0f b6 c0             	movzbl %al,%eax
  800f3c:	29 c2                	sub    %eax,%edx
  800f3e:	89 d0                	mov    %edx,%eax
}
  800f40:	5d                   	pop    %ebp
  800f41:	c3                   	ret    

00800f42 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f42:	55                   	push   %ebp
  800f43:	89 e5                	mov    %esp,%ebp
  800f45:	83 ec 04             	sub    $0x4,%esp
  800f48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f4e:	eb 12                	jmp    800f62 <strchr+0x20>
		if (*s == c)
  800f50:	8b 45 08             	mov    0x8(%ebp),%eax
  800f53:	8a 00                	mov    (%eax),%al
  800f55:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f58:	75 05                	jne    800f5f <strchr+0x1d>
			return (char *) s;
  800f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5d:	eb 11                	jmp    800f70 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f5f:	ff 45 08             	incl   0x8(%ebp)
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
  800f65:	8a 00                	mov    (%eax),%al
  800f67:	84 c0                	test   %al,%al
  800f69:	75 e5                	jne    800f50 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f70:	c9                   	leave  
  800f71:	c3                   	ret    

00800f72 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f72:	55                   	push   %ebp
  800f73:	89 e5                	mov    %esp,%ebp
  800f75:	83 ec 04             	sub    $0x4,%esp
  800f78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f7e:	eb 0d                	jmp    800f8d <strfind+0x1b>
		if (*s == c)
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	8a 00                	mov    (%eax),%al
  800f85:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f88:	74 0e                	je     800f98 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f8a:	ff 45 08             	incl   0x8(%ebp)
  800f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f90:	8a 00                	mov    (%eax),%al
  800f92:	84 c0                	test   %al,%al
  800f94:	75 ea                	jne    800f80 <strfind+0xe>
  800f96:	eb 01                	jmp    800f99 <strfind+0x27>
		if (*s == c)
			break;
  800f98:	90                   	nop
	return (char *) s;
  800f99:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f9c:	c9                   	leave  
  800f9d:	c3                   	ret    

00800f9e <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800f9e:	55                   	push   %ebp
  800f9f:	89 e5                	mov    %esp,%ebp
  800fa1:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800faa:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800fae:	76 63                	jbe    801013 <memset+0x75>
		uint64 data_block = c;
  800fb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb3:	99                   	cltd   
  800fb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fb7:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800fba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fbd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fc0:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800fc4:	c1 e0 08             	shl    $0x8,%eax
  800fc7:	09 45 f0             	or     %eax,-0x10(%ebp)
  800fca:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800fcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fd0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fd3:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800fd7:	c1 e0 10             	shl    $0x10,%eax
  800fda:	09 45 f0             	or     %eax,-0x10(%ebp)
  800fdd:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800fe0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fe3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fe6:	89 c2                	mov    %eax,%edx
  800fe8:	b8 00 00 00 00       	mov    $0x0,%eax
  800fed:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ff0:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800ff3:	eb 18                	jmp    80100d <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800ff5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ff8:	8d 41 08             	lea    0x8(%ecx),%eax
  800ffb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800ffe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801001:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801004:	89 01                	mov    %eax,(%ecx)
  801006:	89 51 04             	mov    %edx,0x4(%ecx)
  801009:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80100d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801011:	77 e2                	ja     800ff5 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801013:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801017:	74 23                	je     80103c <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801019:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80101c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80101f:	eb 0e                	jmp    80102f <memset+0x91>
			*p8++ = (uint8)c;
  801021:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801024:	8d 50 01             	lea    0x1(%eax),%edx
  801027:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80102a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80102d:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  80102f:	8b 45 10             	mov    0x10(%ebp),%eax
  801032:	8d 50 ff             	lea    -0x1(%eax),%edx
  801035:	89 55 10             	mov    %edx,0x10(%ebp)
  801038:	85 c0                	test   %eax,%eax
  80103a:	75 e5                	jne    801021 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  80103c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80103f:	c9                   	leave  
  801040:	c3                   	ret    

00801041 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801041:	55                   	push   %ebp
  801042:	89 e5                	mov    %esp,%ebp
  801044:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801047:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  80104d:	8b 45 08             	mov    0x8(%ebp),%eax
  801050:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801053:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801057:	76 24                	jbe    80107d <memcpy+0x3c>
		while(n >= 8){
  801059:	eb 1c                	jmp    801077 <memcpy+0x36>
			*d64 = *s64;
  80105b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80105e:	8b 50 04             	mov    0x4(%eax),%edx
  801061:	8b 00                	mov    (%eax),%eax
  801063:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801066:	89 01                	mov    %eax,(%ecx)
  801068:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80106b:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80106f:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801073:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801077:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80107b:	77 de                	ja     80105b <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80107d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801081:	74 31                	je     8010b4 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801083:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801086:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801089:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80108c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80108f:	eb 16                	jmp    8010a7 <memcpy+0x66>
			*d8++ = *s8++;
  801091:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801094:	8d 50 01             	lea    0x1(%eax),%edx
  801097:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80109a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80109d:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010a0:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8010a3:	8a 12                	mov    (%edx),%dl
  8010a5:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8010a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010aa:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010ad:	89 55 10             	mov    %edx,0x10(%ebp)
  8010b0:	85 c0                	test   %eax,%eax
  8010b2:	75 dd                	jne    801091 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010b7:	c9                   	leave  
  8010b8:	c3                   	ret    

008010b9 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010b9:	55                   	push   %ebp
  8010ba:	89 e5                	mov    %esp,%ebp
  8010bc:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ce:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010d1:	73 50                	jae    801123 <memmove+0x6a>
  8010d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d9:	01 d0                	add    %edx,%eax
  8010db:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010de:	76 43                	jbe    801123 <memmove+0x6a>
		s += n;
  8010e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e3:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e9:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010ec:	eb 10                	jmp    8010fe <memmove+0x45>
			*--d = *--s;
  8010ee:	ff 4d f8             	decl   -0x8(%ebp)
  8010f1:	ff 4d fc             	decl   -0x4(%ebp)
  8010f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f7:	8a 10                	mov    (%eax),%dl
  8010f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010fc:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801101:	8d 50 ff             	lea    -0x1(%eax),%edx
  801104:	89 55 10             	mov    %edx,0x10(%ebp)
  801107:	85 c0                	test   %eax,%eax
  801109:	75 e3                	jne    8010ee <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80110b:	eb 23                	jmp    801130 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80110d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801110:	8d 50 01             	lea    0x1(%eax),%edx
  801113:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801116:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801119:	8d 4a 01             	lea    0x1(%edx),%ecx
  80111c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80111f:	8a 12                	mov    (%edx),%dl
  801121:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801123:	8b 45 10             	mov    0x10(%ebp),%eax
  801126:	8d 50 ff             	lea    -0x1(%eax),%edx
  801129:	89 55 10             	mov    %edx,0x10(%ebp)
  80112c:	85 c0                	test   %eax,%eax
  80112e:	75 dd                	jne    80110d <memmove+0x54>
			*d++ = *s++;

	return dst;
  801130:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801133:	c9                   	leave  
  801134:	c3                   	ret    

00801135 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801135:	55                   	push   %ebp
  801136:	89 e5                	mov    %esp,%ebp
  801138:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80113b:	8b 45 08             	mov    0x8(%ebp),%eax
  80113e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801141:	8b 45 0c             	mov    0xc(%ebp),%eax
  801144:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801147:	eb 2a                	jmp    801173 <memcmp+0x3e>
		if (*s1 != *s2)
  801149:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80114c:	8a 10                	mov    (%eax),%dl
  80114e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801151:	8a 00                	mov    (%eax),%al
  801153:	38 c2                	cmp    %al,%dl
  801155:	74 16                	je     80116d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801157:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80115a:	8a 00                	mov    (%eax),%al
  80115c:	0f b6 d0             	movzbl %al,%edx
  80115f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801162:	8a 00                	mov    (%eax),%al
  801164:	0f b6 c0             	movzbl %al,%eax
  801167:	29 c2                	sub    %eax,%edx
  801169:	89 d0                	mov    %edx,%eax
  80116b:	eb 18                	jmp    801185 <memcmp+0x50>
		s1++, s2++;
  80116d:	ff 45 fc             	incl   -0x4(%ebp)
  801170:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801173:	8b 45 10             	mov    0x10(%ebp),%eax
  801176:	8d 50 ff             	lea    -0x1(%eax),%edx
  801179:	89 55 10             	mov    %edx,0x10(%ebp)
  80117c:	85 c0                	test   %eax,%eax
  80117e:	75 c9                	jne    801149 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801180:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801185:	c9                   	leave  
  801186:	c3                   	ret    

00801187 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801187:	55                   	push   %ebp
  801188:	89 e5                	mov    %esp,%ebp
  80118a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80118d:	8b 55 08             	mov    0x8(%ebp),%edx
  801190:	8b 45 10             	mov    0x10(%ebp),%eax
  801193:	01 d0                	add    %edx,%eax
  801195:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801198:	eb 15                	jmp    8011af <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80119a:	8b 45 08             	mov    0x8(%ebp),%eax
  80119d:	8a 00                	mov    (%eax),%al
  80119f:	0f b6 d0             	movzbl %al,%edx
  8011a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a5:	0f b6 c0             	movzbl %al,%eax
  8011a8:	39 c2                	cmp    %eax,%edx
  8011aa:	74 0d                	je     8011b9 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011ac:	ff 45 08             	incl   0x8(%ebp)
  8011af:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011b5:	72 e3                	jb     80119a <memfind+0x13>
  8011b7:	eb 01                	jmp    8011ba <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011b9:	90                   	nop
	return (void *) s;
  8011ba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011bd:	c9                   	leave  
  8011be:	c3                   	ret    

008011bf <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011bf:	55                   	push   %ebp
  8011c0:	89 e5                	mov    %esp,%ebp
  8011c2:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011cc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011d3:	eb 03                	jmp    8011d8 <strtol+0x19>
		s++;
  8011d5:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011db:	8a 00                	mov    (%eax),%al
  8011dd:	3c 20                	cmp    $0x20,%al
  8011df:	74 f4                	je     8011d5 <strtol+0x16>
  8011e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e4:	8a 00                	mov    (%eax),%al
  8011e6:	3c 09                	cmp    $0x9,%al
  8011e8:	74 eb                	je     8011d5 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	8a 00                	mov    (%eax),%al
  8011ef:	3c 2b                	cmp    $0x2b,%al
  8011f1:	75 05                	jne    8011f8 <strtol+0x39>
		s++;
  8011f3:	ff 45 08             	incl   0x8(%ebp)
  8011f6:	eb 13                	jmp    80120b <strtol+0x4c>
	else if (*s == '-')
  8011f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fb:	8a 00                	mov    (%eax),%al
  8011fd:	3c 2d                	cmp    $0x2d,%al
  8011ff:	75 0a                	jne    80120b <strtol+0x4c>
		s++, neg = 1;
  801201:	ff 45 08             	incl   0x8(%ebp)
  801204:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80120b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80120f:	74 06                	je     801217 <strtol+0x58>
  801211:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801215:	75 20                	jne    801237 <strtol+0x78>
  801217:	8b 45 08             	mov    0x8(%ebp),%eax
  80121a:	8a 00                	mov    (%eax),%al
  80121c:	3c 30                	cmp    $0x30,%al
  80121e:	75 17                	jne    801237 <strtol+0x78>
  801220:	8b 45 08             	mov    0x8(%ebp),%eax
  801223:	40                   	inc    %eax
  801224:	8a 00                	mov    (%eax),%al
  801226:	3c 78                	cmp    $0x78,%al
  801228:	75 0d                	jne    801237 <strtol+0x78>
		s += 2, base = 16;
  80122a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80122e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801235:	eb 28                	jmp    80125f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801237:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80123b:	75 15                	jne    801252 <strtol+0x93>
  80123d:	8b 45 08             	mov    0x8(%ebp),%eax
  801240:	8a 00                	mov    (%eax),%al
  801242:	3c 30                	cmp    $0x30,%al
  801244:	75 0c                	jne    801252 <strtol+0x93>
		s++, base = 8;
  801246:	ff 45 08             	incl   0x8(%ebp)
  801249:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801250:	eb 0d                	jmp    80125f <strtol+0xa0>
	else if (base == 0)
  801252:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801256:	75 07                	jne    80125f <strtol+0xa0>
		base = 10;
  801258:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80125f:	8b 45 08             	mov    0x8(%ebp),%eax
  801262:	8a 00                	mov    (%eax),%al
  801264:	3c 2f                	cmp    $0x2f,%al
  801266:	7e 19                	jle    801281 <strtol+0xc2>
  801268:	8b 45 08             	mov    0x8(%ebp),%eax
  80126b:	8a 00                	mov    (%eax),%al
  80126d:	3c 39                	cmp    $0x39,%al
  80126f:	7f 10                	jg     801281 <strtol+0xc2>
			dig = *s - '0';
  801271:	8b 45 08             	mov    0x8(%ebp),%eax
  801274:	8a 00                	mov    (%eax),%al
  801276:	0f be c0             	movsbl %al,%eax
  801279:	83 e8 30             	sub    $0x30,%eax
  80127c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80127f:	eb 42                	jmp    8012c3 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801281:	8b 45 08             	mov    0x8(%ebp),%eax
  801284:	8a 00                	mov    (%eax),%al
  801286:	3c 60                	cmp    $0x60,%al
  801288:	7e 19                	jle    8012a3 <strtol+0xe4>
  80128a:	8b 45 08             	mov    0x8(%ebp),%eax
  80128d:	8a 00                	mov    (%eax),%al
  80128f:	3c 7a                	cmp    $0x7a,%al
  801291:	7f 10                	jg     8012a3 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801293:	8b 45 08             	mov    0x8(%ebp),%eax
  801296:	8a 00                	mov    (%eax),%al
  801298:	0f be c0             	movsbl %al,%eax
  80129b:	83 e8 57             	sub    $0x57,%eax
  80129e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012a1:	eb 20                	jmp    8012c3 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a6:	8a 00                	mov    (%eax),%al
  8012a8:	3c 40                	cmp    $0x40,%al
  8012aa:	7e 39                	jle    8012e5 <strtol+0x126>
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8012af:	8a 00                	mov    (%eax),%al
  8012b1:	3c 5a                	cmp    $0x5a,%al
  8012b3:	7f 30                	jg     8012e5 <strtol+0x126>
			dig = *s - 'A' + 10;
  8012b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b8:	8a 00                	mov    (%eax),%al
  8012ba:	0f be c0             	movsbl %al,%eax
  8012bd:	83 e8 37             	sub    $0x37,%eax
  8012c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012c6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012c9:	7d 19                	jge    8012e4 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012cb:	ff 45 08             	incl   0x8(%ebp)
  8012ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012d1:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012d5:	89 c2                	mov    %eax,%edx
  8012d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012da:	01 d0                	add    %edx,%eax
  8012dc:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012df:	e9 7b ff ff ff       	jmp    80125f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012e4:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012e5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012e9:	74 08                	je     8012f3 <strtol+0x134>
		*endptr = (char *) s;
  8012eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8012f1:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012f7:	74 07                	je     801300 <strtol+0x141>
  8012f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012fc:	f7 d8                	neg    %eax
  8012fe:	eb 03                	jmp    801303 <strtol+0x144>
  801300:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801303:	c9                   	leave  
  801304:	c3                   	ret    

00801305 <ltostr>:

void
ltostr(long value, char *str)
{
  801305:	55                   	push   %ebp
  801306:	89 e5                	mov    %esp,%ebp
  801308:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80130b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801312:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801319:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80131d:	79 13                	jns    801332 <ltostr+0x2d>
	{
		neg = 1;
  80131f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801326:	8b 45 0c             	mov    0xc(%ebp),%eax
  801329:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80132c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80132f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801332:	8b 45 08             	mov    0x8(%ebp),%eax
  801335:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80133a:	99                   	cltd   
  80133b:	f7 f9                	idiv   %ecx
  80133d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801340:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801343:	8d 50 01             	lea    0x1(%eax),%edx
  801346:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801349:	89 c2                	mov    %eax,%edx
  80134b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134e:	01 d0                	add    %edx,%eax
  801350:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801353:	83 c2 30             	add    $0x30,%edx
  801356:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801358:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80135b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801360:	f7 e9                	imul   %ecx
  801362:	c1 fa 02             	sar    $0x2,%edx
  801365:	89 c8                	mov    %ecx,%eax
  801367:	c1 f8 1f             	sar    $0x1f,%eax
  80136a:	29 c2                	sub    %eax,%edx
  80136c:	89 d0                	mov    %edx,%eax
  80136e:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801371:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801375:	75 bb                	jne    801332 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801377:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80137e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801381:	48                   	dec    %eax
  801382:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801385:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801389:	74 3d                	je     8013c8 <ltostr+0xc3>
		start = 1 ;
  80138b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801392:	eb 34                	jmp    8013c8 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801394:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801397:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139a:	01 d0                	add    %edx,%eax
  80139c:	8a 00                	mov    (%eax),%al
  80139e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a7:	01 c2                	add    %eax,%edx
  8013a9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013af:	01 c8                	add    %ecx,%eax
  8013b1:	8a 00                	mov    (%eax),%al
  8013b3:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013bb:	01 c2                	add    %eax,%edx
  8013bd:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013c0:	88 02                	mov    %al,(%edx)
		start++ ;
  8013c2:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013c5:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013cb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013ce:	7c c4                	jl     801394 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013d0:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d6:	01 d0                	add    %edx,%eax
  8013d8:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013db:	90                   	nop
  8013dc:	c9                   	leave  
  8013dd:	c3                   	ret    

008013de <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013de:	55                   	push   %ebp
  8013df:	89 e5                	mov    %esp,%ebp
  8013e1:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013e4:	ff 75 08             	pushl  0x8(%ebp)
  8013e7:	e8 c4 f9 ff ff       	call   800db0 <strlen>
  8013ec:	83 c4 04             	add    $0x4,%esp
  8013ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013f2:	ff 75 0c             	pushl  0xc(%ebp)
  8013f5:	e8 b6 f9 ff ff       	call   800db0 <strlen>
  8013fa:	83 c4 04             	add    $0x4,%esp
  8013fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801400:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801407:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80140e:	eb 17                	jmp    801427 <strcconcat+0x49>
		final[s] = str1[s] ;
  801410:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801413:	8b 45 10             	mov    0x10(%ebp),%eax
  801416:	01 c2                	add    %eax,%edx
  801418:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80141b:	8b 45 08             	mov    0x8(%ebp),%eax
  80141e:	01 c8                	add    %ecx,%eax
  801420:	8a 00                	mov    (%eax),%al
  801422:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801424:	ff 45 fc             	incl   -0x4(%ebp)
  801427:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80142a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80142d:	7c e1                	jl     801410 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80142f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801436:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80143d:	eb 1f                	jmp    80145e <strcconcat+0x80>
		final[s++] = str2[i] ;
  80143f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801442:	8d 50 01             	lea    0x1(%eax),%edx
  801445:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801448:	89 c2                	mov    %eax,%edx
  80144a:	8b 45 10             	mov    0x10(%ebp),%eax
  80144d:	01 c2                	add    %eax,%edx
  80144f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801452:	8b 45 0c             	mov    0xc(%ebp),%eax
  801455:	01 c8                	add    %ecx,%eax
  801457:	8a 00                	mov    (%eax),%al
  801459:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80145b:	ff 45 f8             	incl   -0x8(%ebp)
  80145e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801461:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801464:	7c d9                	jl     80143f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801466:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801469:	8b 45 10             	mov    0x10(%ebp),%eax
  80146c:	01 d0                	add    %edx,%eax
  80146e:	c6 00 00             	movb   $0x0,(%eax)
}
  801471:	90                   	nop
  801472:	c9                   	leave  
  801473:	c3                   	ret    

00801474 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801474:	55                   	push   %ebp
  801475:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801477:	8b 45 14             	mov    0x14(%ebp),%eax
  80147a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801480:	8b 45 14             	mov    0x14(%ebp),%eax
  801483:	8b 00                	mov    (%eax),%eax
  801485:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80148c:	8b 45 10             	mov    0x10(%ebp),%eax
  80148f:	01 d0                	add    %edx,%eax
  801491:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801497:	eb 0c                	jmp    8014a5 <strsplit+0x31>
			*string++ = 0;
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	8d 50 01             	lea    0x1(%eax),%edx
  80149f:	89 55 08             	mov    %edx,0x8(%ebp)
  8014a2:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a8:	8a 00                	mov    (%eax),%al
  8014aa:	84 c0                	test   %al,%al
  8014ac:	74 18                	je     8014c6 <strsplit+0x52>
  8014ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b1:	8a 00                	mov    (%eax),%al
  8014b3:	0f be c0             	movsbl %al,%eax
  8014b6:	50                   	push   %eax
  8014b7:	ff 75 0c             	pushl  0xc(%ebp)
  8014ba:	e8 83 fa ff ff       	call   800f42 <strchr>
  8014bf:	83 c4 08             	add    $0x8,%esp
  8014c2:	85 c0                	test   %eax,%eax
  8014c4:	75 d3                	jne    801499 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c9:	8a 00                	mov    (%eax),%al
  8014cb:	84 c0                	test   %al,%al
  8014cd:	74 5a                	je     801529 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8014d2:	8b 00                	mov    (%eax),%eax
  8014d4:	83 f8 0f             	cmp    $0xf,%eax
  8014d7:	75 07                	jne    8014e0 <strsplit+0x6c>
		{
			return 0;
  8014d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8014de:	eb 66                	jmp    801546 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e3:	8b 00                	mov    (%eax),%eax
  8014e5:	8d 48 01             	lea    0x1(%eax),%ecx
  8014e8:	8b 55 14             	mov    0x14(%ebp),%edx
  8014eb:	89 0a                	mov    %ecx,(%edx)
  8014ed:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f7:	01 c2                	add    %eax,%edx
  8014f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fc:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014fe:	eb 03                	jmp    801503 <strsplit+0x8f>
			string++;
  801500:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801503:	8b 45 08             	mov    0x8(%ebp),%eax
  801506:	8a 00                	mov    (%eax),%al
  801508:	84 c0                	test   %al,%al
  80150a:	74 8b                	je     801497 <strsplit+0x23>
  80150c:	8b 45 08             	mov    0x8(%ebp),%eax
  80150f:	8a 00                	mov    (%eax),%al
  801511:	0f be c0             	movsbl %al,%eax
  801514:	50                   	push   %eax
  801515:	ff 75 0c             	pushl  0xc(%ebp)
  801518:	e8 25 fa ff ff       	call   800f42 <strchr>
  80151d:	83 c4 08             	add    $0x8,%esp
  801520:	85 c0                	test   %eax,%eax
  801522:	74 dc                	je     801500 <strsplit+0x8c>
			string++;
	}
  801524:	e9 6e ff ff ff       	jmp    801497 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801529:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80152a:	8b 45 14             	mov    0x14(%ebp),%eax
  80152d:	8b 00                	mov    (%eax),%eax
  80152f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801536:	8b 45 10             	mov    0x10(%ebp),%eax
  801539:	01 d0                	add    %edx,%eax
  80153b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801541:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801546:	c9                   	leave  
  801547:	c3                   	ret    

00801548 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801548:	55                   	push   %ebp
  801549:	89 e5                	mov    %esp,%ebp
  80154b:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80154e:	8b 45 08             	mov    0x8(%ebp),%eax
  801551:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801554:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80155b:	eb 4a                	jmp    8015a7 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80155d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801560:	8b 45 08             	mov    0x8(%ebp),%eax
  801563:	01 c2                	add    %eax,%edx
  801565:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801568:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156b:	01 c8                	add    %ecx,%eax
  80156d:	8a 00                	mov    (%eax),%al
  80156f:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801571:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801574:	8b 45 0c             	mov    0xc(%ebp),%eax
  801577:	01 d0                	add    %edx,%eax
  801579:	8a 00                	mov    (%eax),%al
  80157b:	3c 40                	cmp    $0x40,%al
  80157d:	7e 25                	jle    8015a4 <str2lower+0x5c>
  80157f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801582:	8b 45 0c             	mov    0xc(%ebp),%eax
  801585:	01 d0                	add    %edx,%eax
  801587:	8a 00                	mov    (%eax),%al
  801589:	3c 5a                	cmp    $0x5a,%al
  80158b:	7f 17                	jg     8015a4 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80158d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801590:	8b 45 08             	mov    0x8(%ebp),%eax
  801593:	01 d0                	add    %edx,%eax
  801595:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801598:	8b 55 08             	mov    0x8(%ebp),%edx
  80159b:	01 ca                	add    %ecx,%edx
  80159d:	8a 12                	mov    (%edx),%dl
  80159f:	83 c2 20             	add    $0x20,%edx
  8015a2:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8015a4:	ff 45 fc             	incl   -0x4(%ebp)
  8015a7:	ff 75 0c             	pushl  0xc(%ebp)
  8015aa:	e8 01 f8 ff ff       	call   800db0 <strlen>
  8015af:	83 c4 04             	add    $0x4,%esp
  8015b2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015b5:	7f a6                	jg     80155d <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8015b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8015ba:	c9                   	leave  
  8015bb:	c3                   	ret    

008015bc <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8015bc:	55                   	push   %ebp
  8015bd:	89 e5                	mov    %esp,%ebp
  8015bf:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8015c2:	a1 08 50 80 00       	mov    0x805008,%eax
  8015c7:	85 c0                	test   %eax,%eax
  8015c9:	74 42                	je     80160d <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8015cb:	83 ec 08             	sub    $0x8,%esp
  8015ce:	68 00 00 00 82       	push   $0x82000000
  8015d3:	68 00 00 00 80       	push   $0x80000000
  8015d8:	e8 b0 1e 00 00       	call   80348d <initialize_dynamic_allocator>
  8015dd:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  8015e0:	e8 96 1c 00 00       	call   80327b <sys_get_uheap_strategy>
  8015e5:	a3 80 50 83 00       	mov    %eax,0x835080
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  8015ea:	a1 60 d0 81 00       	mov    0x81d060,%eax
  8015ef:	05 00 10 00 00       	add    $0x1000,%eax
  8015f4:	a3 30 51 83 00       	mov    %eax,0x835130
		uheapPageAllocBreak = uheapPageAllocStart;
  8015f9:	a1 30 51 83 00       	mov    0x835130,%eax
  8015fe:	a3 88 50 83 00       	mov    %eax,0x835088

		__firstTimeFlag = 0;
  801603:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  80160a:	00 00 00 
	}
}
  80160d:	90                   	nop
  80160e:	c9                   	leave  
  80160f:	c3                   	ret    

00801610 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801610:	55                   	push   %ebp
  801611:	89 e5                	mov    %esp,%ebp
  801613:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801616:	8b 45 08             	mov    0x8(%ebp),%eax
  801619:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80161c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80161f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801624:	83 ec 08             	sub    $0x8,%esp
  801627:	68 06 04 00 00       	push   $0x406
  80162c:	50                   	push   %eax
  80162d:	e8 93 18 00 00       	call   802ec5 <__sys_allocate_page>
  801632:	83 c4 10             	add    $0x10,%esp
  801635:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801638:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80163c:	79 14                	jns    801652 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  80163e:	83 ec 04             	sub    $0x4,%esp
  801641:	68 28 49 80 00       	push   $0x804928
  801646:	6a 1f                	push   $0x1f
  801648:	68 64 49 80 00       	push   $0x804964
  80164d:	e8 b7 ed ff ff       	call   800409 <_panic>
	return 0;
  801652:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801657:	c9                   	leave  
  801658:	c3                   	ret    

00801659 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801659:	55                   	push   %ebp
  80165a:	89 e5                	mov    %esp,%ebp
  80165c:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  80165f:	8b 45 08             	mov    0x8(%ebp),%eax
  801662:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801665:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801668:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80166d:	83 ec 0c             	sub    $0xc,%esp
  801670:	50                   	push   %eax
  801671:	e8 96 18 00 00       	call   802f0c <__sys_unmap_frame>
  801676:	83 c4 10             	add    $0x10,%esp
  801679:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80167c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801680:	79 14                	jns    801696 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801682:	83 ec 04             	sub    $0x4,%esp
  801685:	68 70 49 80 00       	push   $0x804970
  80168a:	6a 2a                	push   $0x2a
  80168c:	68 64 49 80 00       	push   $0x804964
  801691:	e8 73 ed ff ff       	call   800409 <_panic>
}
  801696:	90                   	nop
  801697:	c9                   	leave  
  801698:	c3                   	ret    

00801699 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801699:	55                   	push   %ebp
  80169a:	89 e5                	mov    %esp,%ebp
  80169c:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80169f:	e8 18 ff ff ff       	call   8015bc <uheap_init>
	if (size == 0) return NULL ;
  8016a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016a8:	75 0a                	jne    8016b4 <malloc+0x1b>
  8016aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8016af:	e9 43 03 00 00       	jmp    8019f7 <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  8016b4:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8016bb:	77 13                	ja     8016d0 <malloc+0x37>
    {
        return alloc_block(size);
  8016bd:	83 ec 0c             	sub    $0xc,%esp
  8016c0:	ff 75 08             	pushl  0x8(%ebp)
  8016c3:	e8 78 20 00 00       	call   803740 <alloc_block>
  8016c8:	83 c4 10             	add    $0x10,%esp
  8016cb:	e9 27 03 00 00       	jmp    8019f7 <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  8016d0:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  8016d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8016da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016dd:	01 d0                	add    %edx,%eax
  8016df:	48                   	dec    %eax
  8016e0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8016e3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8016eb:	f7 75 dc             	divl   -0x24(%ebp)
  8016ee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016f1:	29 d0                	sub    %edx,%eax
  8016f3:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  8016f6:	a1 40 d0 81 00       	mov    0x81d040,%eax
  8016fb:	85 c0                	test   %eax,%eax
  8016fd:	75 0a                	jne    801709 <malloc+0x70>
    {
        uhp_inited = 1;
  8016ff:	c7 05 40 d0 81 00 01 	movl   $0x1,0x81d040
  801706:	00 00 00 
    }

    int exactIdx = -1;
  801709:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801710:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801717:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80171e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801725:	e9 85 00 00 00       	jmp    8017af <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  80172a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80172d:	89 d0                	mov    %edx,%eax
  80172f:	01 c0                	add    %eax,%eax
  801731:	01 d0                	add    %edx,%eax
  801733:	c1 e0 02             	shl    $0x2,%eax
  801736:	05 48 10 81 00       	add    $0x811048,%eax
  80173b:	8a 00                	mov    (%eax),%al
  80173d:	84 c0                	test   %al,%al
  80173f:	74 20                	je     801761 <malloc+0xc8>
  801741:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801744:	89 d0                	mov    %edx,%eax
  801746:	01 c0                	add    %eax,%eax
  801748:	01 d0                	add    %edx,%eax
  80174a:	c1 e0 02             	shl    $0x2,%eax
  80174d:	05 44 10 81 00       	add    $0x811044,%eax
  801752:	8b 00                	mov    (%eax),%eax
  801754:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801757:	75 08                	jne    801761 <malloc+0xc8>
        {
            exactIdx = i;
  801759:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80175c:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  80175f:	eb 5b                	jmp    8017bc <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801761:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801764:	89 d0                	mov    %edx,%eax
  801766:	01 c0                	add    %eax,%eax
  801768:	01 d0                	add    %edx,%eax
  80176a:	c1 e0 02             	shl    $0x2,%eax
  80176d:	05 48 10 81 00       	add    $0x811048,%eax
  801772:	8a 00                	mov    (%eax),%al
  801774:	84 c0                	test   %al,%al
  801776:	74 34                	je     8017ac <malloc+0x113>
  801778:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80177b:	89 d0                	mov    %edx,%eax
  80177d:	01 c0                	add    %eax,%eax
  80177f:	01 d0                	add    %edx,%eax
  801781:	c1 e0 02             	shl    $0x2,%eax
  801784:	05 44 10 81 00       	add    $0x811044,%eax
  801789:	8b 00                	mov    (%eax),%eax
  80178b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80178e:	76 1c                	jbe    8017ac <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  801790:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801793:	89 d0                	mov    %edx,%eax
  801795:	01 c0                	add    %eax,%eax
  801797:	01 d0                	add    %edx,%eax
  801799:	c1 e0 02             	shl    $0x2,%eax
  80179c:	05 44 10 81 00       	add    $0x811044,%eax
  8017a1:	8b 00                	mov    (%eax),%eax
  8017a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  8017a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8017ac:	ff 45 e8             	incl   -0x18(%ebp)
  8017af:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8017b6:	0f 8e 6e ff ff ff    	jle    80172a <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  8017bc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  8017c3:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8017c7:	74 7d                	je     801846 <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  8017c9:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  8017d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017d3:	89 d0                	mov    %edx,%eax
  8017d5:	01 c0                	add    %eax,%eax
  8017d7:	01 d0                	add    %edx,%eax
  8017d9:	c1 e0 02             	shl    $0x2,%eax
  8017dc:	05 40 10 81 00       	add    $0x811040,%eax
  8017e1:	8b 10                	mov    (%eax),%edx
  8017e3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8017e6:	01 d0                	add    %edx,%eax
  8017e8:	48                   	dec    %eax
  8017e9:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8017ec:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8017ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f4:	f7 75 bc             	divl   -0x44(%ebp)
  8017f7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8017fa:	29 d0                	sub    %edx,%eax
  8017fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  8017ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801802:	89 d0                	mov    %edx,%eax
  801804:	01 c0                	add    %eax,%eax
  801806:	01 d0                	add    %edx,%eax
  801808:	c1 e0 02             	shl    $0x2,%eax
  80180b:	05 48 10 81 00       	add    $0x811048,%eax
  801810:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801813:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801816:	89 d0                	mov    %edx,%eax
  801818:	01 c0                	add    %eax,%eax
  80181a:	01 d0                	add    %edx,%eax
  80181c:	c1 e0 02             	shl    $0x2,%eax
  80181f:	05 44 10 81 00       	add    $0x811044,%eax
  801824:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  80182a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80182d:	89 d0                	mov    %edx,%eax
  80182f:	01 c0                	add    %eax,%eax
  801831:	01 d0                	add    %edx,%eax
  801833:	c1 e0 02             	shl    $0x2,%eax
  801836:	05 40 10 81 00       	add    $0x811040,%eax
  80183b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801841:	e9 2d 01 00 00       	jmp    801973 <malloc+0x2da>
    }
    else if (worstIdx != -1)
  801846:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80184a:	0f 84 ce 00 00 00    	je     80191e <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  801850:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  801857:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80185a:	89 d0                	mov    %edx,%eax
  80185c:	01 c0                	add    %eax,%eax
  80185e:	01 d0                	add    %edx,%eax
  801860:	c1 e0 02             	shl    $0x2,%eax
  801863:	05 40 10 81 00       	add    $0x811040,%eax
  801868:	8b 10                	mov    (%eax),%edx
  80186a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80186d:	01 d0                	add    %edx,%eax
  80186f:	48                   	dec    %eax
  801870:	89 45 c0             	mov    %eax,-0x40(%ebp)
  801873:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801876:	ba 00 00 00 00       	mov    $0x0,%edx
  80187b:	f7 75 c4             	divl   -0x3c(%ebp)
  80187e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801881:	29 d0                	sub    %edx,%eax
  801883:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  801886:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801889:	89 d0                	mov    %edx,%eax
  80188b:	01 c0                	add    %eax,%eax
  80188d:	01 d0                	add    %edx,%eax
  80188f:	c1 e0 02             	shl    $0x2,%eax
  801892:	05 44 10 81 00       	add    $0x811044,%eax
  801897:	8b 00                	mov    (%eax),%eax
  801899:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80189c:	75 47                	jne    8018e5 <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  80189e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018a1:	89 d0                	mov    %edx,%eax
  8018a3:	01 c0                	add    %eax,%eax
  8018a5:	01 d0                	add    %edx,%eax
  8018a7:	c1 e0 02             	shl    $0x2,%eax
  8018aa:	05 48 10 81 00       	add    $0x811048,%eax
  8018af:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  8018b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018b5:	89 d0                	mov    %edx,%eax
  8018b7:	01 c0                	add    %eax,%eax
  8018b9:	01 d0                	add    %edx,%eax
  8018bb:	c1 e0 02             	shl    $0x2,%eax
  8018be:	05 44 10 81 00       	add    $0x811044,%eax
  8018c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  8018c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018cc:	89 d0                	mov    %edx,%eax
  8018ce:	01 c0                	add    %eax,%eax
  8018d0:	01 d0                	add    %edx,%eax
  8018d2:	c1 e0 02             	shl    $0x2,%eax
  8018d5:	05 40 10 81 00       	add    $0x811040,%eax
  8018da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8018e0:	e9 8e 00 00 00       	jmp    801973 <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  8018e5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8018e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8018eb:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8018ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018f1:	89 d0                	mov    %edx,%eax
  8018f3:	01 c0                	add    %eax,%eax
  8018f5:	01 d0                	add    %edx,%eax
  8018f7:	c1 e0 02             	shl    $0x2,%eax
  8018fa:	05 40 10 81 00       	add    $0x811040,%eax
  8018ff:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  801901:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801904:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801907:	89 c2                	mov    %eax,%edx
  801909:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80190c:	89 c8                	mov    %ecx,%eax
  80190e:	01 c0                	add    %eax,%eax
  801910:	01 c8                	add    %ecx,%eax
  801912:	c1 e0 02             	shl    $0x2,%eax
  801915:	05 44 10 81 00       	add    $0x811044,%eax
  80191a:	89 10                	mov    %edx,(%eax)
  80191c:	eb 55                	jmp    801973 <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  80191e:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801925:	8b 15 88 50 83 00    	mov    0x835088,%edx
  80192b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80192e:	01 d0                	add    %edx,%eax
  801930:	48                   	dec    %eax
  801931:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801934:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801937:	ba 00 00 00 00       	mov    $0x0,%edx
  80193c:	f7 75 d0             	divl   -0x30(%ebp)
  80193f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801942:	29 d0                	sub    %edx,%eax
  801944:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  801947:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80194a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80194d:	01 d0                	add    %edx,%eax
  80194f:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801954:	76 0a                	jbe    801960 <malloc+0x2c7>
            return NULL;
  801956:	b8 00 00 00 00       	mov    $0x0,%eax
  80195b:	e9 97 00 00 00       	jmp    8019f7 <malloc+0x35e>
        va = start;
  801960:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801963:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  801966:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801969:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80196c:	01 d0                	add    %edx,%eax
  80196e:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801973:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80197a:	eb 5e                	jmp    8019da <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  80197c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80197f:	89 d0                	mov    %edx,%eax
  801981:	01 c0                	add    %eax,%eax
  801983:	01 d0                	add    %edx,%eax
  801985:	c1 e0 02             	shl    $0x2,%eax
  801988:	05 48 50 80 00       	add    $0x805048,%eax
  80198d:	8a 00                	mov    (%eax),%al
  80198f:	84 c0                	test   %al,%al
  801991:	75 44                	jne    8019d7 <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  801993:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801996:	89 d0                	mov    %edx,%eax
  801998:	01 c0                	add    %eax,%eax
  80199a:	01 d0                	add    %edx,%eax
  80199c:	c1 e0 02             	shl    $0x2,%eax
  80199f:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  8019a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019a8:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  8019aa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019ad:	89 d0                	mov    %edx,%eax
  8019af:	01 c0                	add    %eax,%eax
  8019b1:	01 d0                	add    %edx,%eax
  8019b3:	c1 e0 02             	shl    $0x2,%eax
  8019b6:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8019bc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019bf:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  8019c1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019c4:	89 d0                	mov    %edx,%eax
  8019c6:	01 c0                	add    %eax,%eax
  8019c8:	01 d0                	add    %edx,%eax
  8019ca:	c1 e0 02             	shl    $0x2,%eax
  8019cd:	05 48 50 80 00       	add    $0x805048,%eax
  8019d2:	c6 00 01             	movb   $0x1,(%eax)
            break;
  8019d5:	eb 0c                	jmp    8019e3 <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8019d7:	ff 45 e0             	incl   -0x20(%ebp)
  8019da:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8019e1:	7e 99                	jle    80197c <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  8019e3:	83 ec 08             	sub    $0x8,%esp
  8019e6:	ff 75 d4             	pushl  -0x2c(%ebp)
  8019e9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8019ec:	e8 a2 19 00 00       	call   803393 <sys_allocate_user_mem>
  8019f1:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  8019f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8019f7:	c9                   	leave  
  8019f8:	c3                   	ret    

008019f9 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8019f9:	55                   	push   %ebp
  8019fa:	89 e5                	mov    %esp,%ebp
  8019fc:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  8019ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a03:	0f 84 fa 03 00 00    	je     801e03 <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  801a09:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  801a0f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a12:	85 c0                	test   %eax,%eax
  801a14:	79 1c                	jns    801a32 <free+0x39>
  801a16:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  801a1d:	77 13                	ja     801a32 <free+0x39>
    {
        free_block(virtual_address);
  801a1f:	83 ec 0c             	sub    $0xc,%esp
  801a22:	ff 75 08             	pushl  0x8(%ebp)
  801a25:	e8 09 21 00 00       	call   803b33 <free_block>
  801a2a:	83 c4 10             	add    $0x10,%esp
        return;
  801a2d:	e9 d2 03 00 00       	jmp    801e04 <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  801a32:	a1 30 51 83 00       	mov    0x835130,%eax
  801a37:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  801a3a:	72 09                	jb     801a45 <free+0x4c>
  801a3c:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  801a43:	76 17                	jbe    801a5c <free+0x63>
        panic("free: invalid address");
  801a45:	83 ec 04             	sub    $0x4,%esp
  801a48:	68 ad 49 80 00       	push   $0x8049ad
  801a4d:	68 9b 00 00 00       	push   $0x9b
  801a52:	68 64 49 80 00       	push   $0x804964
  801a57:	e8 ad e9 ff ff       	call   800409 <_panic>

    uint32 size = 0;
  801a5c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  801a63:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801a6a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801a71:	eb 50                	jmp    801ac3 <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  801a73:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a76:	89 d0                	mov    %edx,%eax
  801a78:	01 c0                	add    %eax,%eax
  801a7a:	01 d0                	add    %edx,%eax
  801a7c:	c1 e0 02             	shl    $0x2,%eax
  801a7f:	05 48 50 80 00       	add    $0x805048,%eax
  801a84:	8a 00                	mov    (%eax),%al
  801a86:	84 c0                	test   %al,%al
  801a88:	74 36                	je     801ac0 <free+0xc7>
  801a8a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a8d:	89 d0                	mov    %edx,%eax
  801a8f:	01 c0                	add    %eax,%eax
  801a91:	01 d0                	add    %edx,%eax
  801a93:	c1 e0 02             	shl    $0x2,%eax
  801a96:	05 40 50 80 00       	add    $0x805040,%eax
  801a9b:	8b 00                	mov    (%eax),%eax
  801a9d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801aa0:	75 1e                	jne    801ac0 <free+0xc7>
        {
            size = uhp_allocs[i].size;
  801aa2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801aa5:	89 d0                	mov    %edx,%eax
  801aa7:	01 c0                	add    %eax,%eax
  801aa9:	01 d0                	add    %edx,%eax
  801aab:	c1 e0 02             	shl    $0x2,%eax
  801aae:	05 44 50 80 00       	add    $0x805044,%eax
  801ab3:	8b 00                	mov    (%eax),%eax
  801ab5:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  801ab8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801abb:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  801abe:	eb 0c                	jmp    801acc <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801ac0:	ff 45 ec             	incl   -0x14(%ebp)
  801ac3:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  801aca:	7e a7                	jle    801a73 <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  801acc:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801ad0:	74 06                	je     801ad8 <free+0xdf>
  801ad2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ad6:	75 17                	jne    801aef <free+0xf6>
        panic("free: unknown block");
  801ad8:	83 ec 04             	sub    $0x4,%esp
  801adb:	68 c3 49 80 00       	push   $0x8049c3
  801ae0:	68 a9 00 00 00       	push   $0xa9
  801ae5:	68 64 49 80 00       	push   $0x804964
  801aea:	e8 1a e9 ff ff       	call   800409 <_panic>

    uhp_allocs[idx].used = 0;
  801aef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801af2:	89 d0                	mov    %edx,%eax
  801af4:	01 c0                	add    %eax,%eax
  801af6:	01 d0                	add    %edx,%eax
  801af8:	c1 e0 02             	shl    $0x2,%eax
  801afb:	05 48 50 80 00       	add    $0x805048,%eax
  801b00:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  801b03:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801b0a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801b11:	eb 64                	jmp    801b77 <free+0x17e>
    {
        if (!uhp_frees[i].free)
  801b13:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b16:	89 d0                	mov    %edx,%eax
  801b18:	01 c0                	add    %eax,%eax
  801b1a:	01 d0                	add    %edx,%eax
  801b1c:	c1 e0 02             	shl    $0x2,%eax
  801b1f:	05 48 10 81 00       	add    $0x811048,%eax
  801b24:	8a 00                	mov    (%eax),%al
  801b26:	84 c0                	test   %al,%al
  801b28:	75 4a                	jne    801b74 <free+0x17b>
        {
            uhp_frees[i].va = va;
  801b2a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b2d:	89 d0                	mov    %edx,%eax
  801b2f:	01 c0                	add    %eax,%eax
  801b31:	01 d0                	add    %edx,%eax
  801b33:	c1 e0 02             	shl    $0x2,%eax
  801b36:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  801b3c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b3f:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  801b41:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b44:	89 d0                	mov    %edx,%eax
  801b46:	01 c0                	add    %eax,%eax
  801b48:	01 d0                	add    %edx,%eax
  801b4a:	c1 e0 02             	shl    $0x2,%eax
  801b4d:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  801b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b56:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  801b58:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b5b:	89 d0                	mov    %edx,%eax
  801b5d:	01 c0                	add    %eax,%eax
  801b5f:	01 d0                	add    %edx,%eax
  801b61:	c1 e0 02             	shl    $0x2,%eax
  801b64:	05 48 10 81 00       	add    $0x811048,%eax
  801b69:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  801b6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b6f:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  801b72:	eb 0c                	jmp    801b80 <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801b74:	ff 45 e4             	incl   -0x1c(%ebp)
  801b77:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  801b7e:	7e 93                	jle    801b13 <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  801b80:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  801b84:	0f 84 f1 01 00 00    	je     801d7b <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801b8a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801b91:	e9 d8 01 00 00       	jmp    801d6e <free+0x375>
        {
            if (i == fidx) continue;
  801b96:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b99:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801b9c:	0f 84 c8 01 00 00    	je     801d6a <free+0x371>
            if (uhp_frees[i].free)
  801ba2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ba5:	89 d0                	mov    %edx,%eax
  801ba7:	01 c0                	add    %eax,%eax
  801ba9:	01 d0                	add    %edx,%eax
  801bab:	c1 e0 02             	shl    $0x2,%eax
  801bae:	05 48 10 81 00       	add    $0x811048,%eax
  801bb3:	8a 00                	mov    (%eax),%al
  801bb5:	84 c0                	test   %al,%al
  801bb7:	0f 84 ae 01 00 00    	je     801d6b <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  801bbd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bc0:	89 d0                	mov    %edx,%eax
  801bc2:	01 c0                	add    %eax,%eax
  801bc4:	01 d0                	add    %edx,%eax
  801bc6:	c1 e0 02             	shl    $0x2,%eax
  801bc9:	05 40 10 81 00       	add    $0x811040,%eax
  801bce:	8b 08                	mov    (%eax),%ecx
  801bd0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bd3:	89 d0                	mov    %edx,%eax
  801bd5:	01 c0                	add    %eax,%eax
  801bd7:	01 d0                	add    %edx,%eax
  801bd9:	c1 e0 02             	shl    $0x2,%eax
  801bdc:	05 44 10 81 00       	add    $0x811044,%eax
  801be1:	8b 00                	mov    (%eax),%eax
  801be3:	01 c1                	add    %eax,%ecx
  801be5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801be8:	89 d0                	mov    %edx,%eax
  801bea:	01 c0                	add    %eax,%eax
  801bec:	01 d0                	add    %edx,%eax
  801bee:	c1 e0 02             	shl    $0x2,%eax
  801bf1:	05 40 10 81 00       	add    $0x811040,%eax
  801bf6:	8b 00                	mov    (%eax),%eax
  801bf8:	39 c1                	cmp    %eax,%ecx
  801bfa:	0f 85 a8 00 00 00    	jne    801ca8 <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  801c00:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c03:	89 d0                	mov    %edx,%eax
  801c05:	01 c0                	add    %eax,%eax
  801c07:	01 d0                	add    %edx,%eax
  801c09:	c1 e0 02             	shl    $0x2,%eax
  801c0c:	05 40 10 81 00       	add    $0x811040,%eax
  801c11:	8b 10                	mov    (%eax),%edx
  801c13:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  801c16:	89 c8                	mov    %ecx,%eax
  801c18:	01 c0                	add    %eax,%eax
  801c1a:	01 c8                	add    %ecx,%eax
  801c1c:	c1 e0 02             	shl    $0x2,%eax
  801c1f:	05 40 10 81 00       	add    $0x811040,%eax
  801c24:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801c26:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c29:	89 d0                	mov    %edx,%eax
  801c2b:	01 c0                	add    %eax,%eax
  801c2d:	01 d0                	add    %edx,%eax
  801c2f:	c1 e0 02             	shl    $0x2,%eax
  801c32:	05 44 10 81 00       	add    $0x811044,%eax
  801c37:	8b 08                	mov    (%eax),%ecx
  801c39:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c3c:	89 d0                	mov    %edx,%eax
  801c3e:	01 c0                	add    %eax,%eax
  801c40:	01 d0                	add    %edx,%eax
  801c42:	c1 e0 02             	shl    $0x2,%eax
  801c45:	05 44 10 81 00       	add    $0x811044,%eax
  801c4a:	8b 00                	mov    (%eax),%eax
  801c4c:	01 c1                	add    %eax,%ecx
  801c4e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c51:	89 d0                	mov    %edx,%eax
  801c53:	01 c0                	add    %eax,%eax
  801c55:	01 d0                	add    %edx,%eax
  801c57:	c1 e0 02             	shl    $0x2,%eax
  801c5a:	05 44 10 81 00       	add    $0x811044,%eax
  801c5f:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801c61:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c64:	89 d0                	mov    %edx,%eax
  801c66:	01 c0                	add    %eax,%eax
  801c68:	01 d0                	add    %edx,%eax
  801c6a:	c1 e0 02             	shl    $0x2,%eax
  801c6d:	05 48 10 81 00       	add    $0x811048,%eax
  801c72:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801c75:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c78:	89 d0                	mov    %edx,%eax
  801c7a:	01 c0                	add    %eax,%eax
  801c7c:	01 d0                	add    %edx,%eax
  801c7e:	c1 e0 02             	shl    $0x2,%eax
  801c81:	05 40 10 81 00       	add    $0x811040,%eax
  801c86:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801c8c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c8f:	89 d0                	mov    %edx,%eax
  801c91:	01 c0                	add    %eax,%eax
  801c93:	01 d0                	add    %edx,%eax
  801c95:	c1 e0 02             	shl    $0x2,%eax
  801c98:	05 44 10 81 00       	add    $0x811044,%eax
  801c9d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ca3:	e9 c3 00 00 00       	jmp    801d6b <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  801ca8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801cab:	89 d0                	mov    %edx,%eax
  801cad:	01 c0                	add    %eax,%eax
  801caf:	01 d0                	add    %edx,%eax
  801cb1:	c1 e0 02             	shl    $0x2,%eax
  801cb4:	05 40 10 81 00       	add    $0x811040,%eax
  801cb9:	8b 08                	mov    (%eax),%ecx
  801cbb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801cbe:	89 d0                	mov    %edx,%eax
  801cc0:	01 c0                	add    %eax,%eax
  801cc2:	01 d0                	add    %edx,%eax
  801cc4:	c1 e0 02             	shl    $0x2,%eax
  801cc7:	05 44 10 81 00       	add    $0x811044,%eax
  801ccc:	8b 00                	mov    (%eax),%eax
  801cce:	01 c1                	add    %eax,%ecx
  801cd0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801cd3:	89 d0                	mov    %edx,%eax
  801cd5:	01 c0                	add    %eax,%eax
  801cd7:	01 d0                	add    %edx,%eax
  801cd9:	c1 e0 02             	shl    $0x2,%eax
  801cdc:	05 40 10 81 00       	add    $0x811040,%eax
  801ce1:	8b 00                	mov    (%eax),%eax
  801ce3:	39 c1                	cmp    %eax,%ecx
  801ce5:	0f 85 80 00 00 00    	jne    801d6b <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801ceb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801cee:	89 d0                	mov    %edx,%eax
  801cf0:	01 c0                	add    %eax,%eax
  801cf2:	01 d0                	add    %edx,%eax
  801cf4:	c1 e0 02             	shl    $0x2,%eax
  801cf7:	05 44 10 81 00       	add    $0x811044,%eax
  801cfc:	8b 08                	mov    (%eax),%ecx
  801cfe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d01:	89 d0                	mov    %edx,%eax
  801d03:	01 c0                	add    %eax,%eax
  801d05:	01 d0                	add    %edx,%eax
  801d07:	c1 e0 02             	shl    $0x2,%eax
  801d0a:	05 44 10 81 00       	add    $0x811044,%eax
  801d0f:	8b 00                	mov    (%eax),%eax
  801d11:	01 c1                	add    %eax,%ecx
  801d13:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d16:	89 d0                	mov    %edx,%eax
  801d18:	01 c0                	add    %eax,%eax
  801d1a:	01 d0                	add    %edx,%eax
  801d1c:	c1 e0 02             	shl    $0x2,%eax
  801d1f:	05 44 10 81 00       	add    $0x811044,%eax
  801d24:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801d26:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d29:	89 d0                	mov    %edx,%eax
  801d2b:	01 c0                	add    %eax,%eax
  801d2d:	01 d0                	add    %edx,%eax
  801d2f:	c1 e0 02             	shl    $0x2,%eax
  801d32:	05 48 10 81 00       	add    $0x811048,%eax
  801d37:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801d3a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d3d:	89 d0                	mov    %edx,%eax
  801d3f:	01 c0                	add    %eax,%eax
  801d41:	01 d0                	add    %edx,%eax
  801d43:	c1 e0 02             	shl    $0x2,%eax
  801d46:	05 40 10 81 00       	add    $0x811040,%eax
  801d4b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801d51:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d54:	89 d0                	mov    %edx,%eax
  801d56:	01 c0                	add    %eax,%eax
  801d58:	01 d0                	add    %edx,%eax
  801d5a:	c1 e0 02             	shl    $0x2,%eax
  801d5d:	05 44 10 81 00       	add    $0x811044,%eax
  801d62:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801d68:	eb 01                	jmp    801d6b <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  801d6a:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801d6b:	ff 45 e0             	incl   -0x20(%ebp)
  801d6e:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801d75:	0f 8e 1b fe ff ff    	jle    801b96 <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  801d7b:	a1 30 51 83 00       	mov    0x835130,%eax
  801d80:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801d83:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801d8a:	eb 53                	jmp    801ddf <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  801d8c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801d8f:	89 d0                	mov    %edx,%eax
  801d91:	01 c0                	add    %eax,%eax
  801d93:	01 d0                	add    %edx,%eax
  801d95:	c1 e0 02             	shl    $0x2,%eax
  801d98:	05 48 50 80 00       	add    $0x805048,%eax
  801d9d:	8a 00                	mov    (%eax),%al
  801d9f:	84 c0                	test   %al,%al
  801da1:	74 39                	je     801ddc <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  801da3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801da6:	89 d0                	mov    %edx,%eax
  801da8:	01 c0                	add    %eax,%eax
  801daa:	01 d0                	add    %edx,%eax
  801dac:	c1 e0 02             	shl    $0x2,%eax
  801daf:	05 40 50 80 00       	add    $0x805040,%eax
  801db4:	8b 08                	mov    (%eax),%ecx
  801db6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801db9:	89 d0                	mov    %edx,%eax
  801dbb:	01 c0                	add    %eax,%eax
  801dbd:	01 d0                	add    %edx,%eax
  801dbf:	c1 e0 02             	shl    $0x2,%eax
  801dc2:	05 44 50 80 00       	add    $0x805044,%eax
  801dc7:	8b 00                	mov    (%eax),%eax
  801dc9:	01 c8                	add    %ecx,%eax
  801dcb:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  801dce:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801dd1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801dd4:	76 06                	jbe    801ddc <free+0x3e3>
  801dd6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801dd9:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801ddc:	ff 45 d8             	incl   -0x28(%ebp)
  801ddf:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  801de6:	7e a4                	jle    801d8c <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  801de8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801deb:	a3 88 50 83 00       	mov    %eax,0x835088

    sys_free_user_mem(va, size);
  801df0:	83 ec 08             	sub    $0x8,%esp
  801df3:	ff 75 f4             	pushl  -0xc(%ebp)
  801df6:	ff 75 d4             	pushl  -0x2c(%ebp)
  801df9:	e8 79 15 00 00       	call   803377 <sys_free_user_mem>
  801dfe:	83 c4 10             	add    $0x10,%esp
  801e01:	eb 01                	jmp    801e04 <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  801e03:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  801e04:	c9                   	leave  
  801e05:	c3                   	ret    

00801e06 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801e06:	55                   	push   %ebp
  801e07:	89 e5                	mov    %esp,%ebp
  801e09:	83 ec 68             	sub    $0x68,%esp
  801e0c:	8b 45 10             	mov    0x10(%ebp),%eax
  801e0f:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801e12:	e8 a5 f7 ff ff       	call   8015bc <uheap_init>
	if (size == 0) return NULL ;
  801e17:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e1b:	75 0a                	jne    801e27 <smalloc+0x21>
  801e1d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e22:	e9 37 03 00 00       	jmp    80215e <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801e27:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801e2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e31:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e34:	01 d0                	add    %edx,%eax
  801e36:	48                   	dec    %eax
  801e37:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801e3a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e3d:	ba 00 00 00 00       	mov    $0x0,%edx
  801e42:	f7 75 dc             	divl   -0x24(%ebp)
  801e45:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e48:	29 d0                	sub    %edx,%eax
  801e4a:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  801e4d:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801e54:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801e5b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801e62:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801e69:	e9 85 00 00 00       	jmp    801ef3 <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801e6e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e71:	89 d0                	mov    %edx,%eax
  801e73:	01 c0                	add    %eax,%eax
  801e75:	01 d0                	add    %edx,%eax
  801e77:	c1 e0 02             	shl    $0x2,%eax
  801e7a:	05 48 10 81 00       	add    $0x811048,%eax
  801e7f:	8a 00                	mov    (%eax),%al
  801e81:	84 c0                	test   %al,%al
  801e83:	74 20                	je     801ea5 <smalloc+0x9f>
  801e85:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e88:	89 d0                	mov    %edx,%eax
  801e8a:	01 c0                	add    %eax,%eax
  801e8c:	01 d0                	add    %edx,%eax
  801e8e:	c1 e0 02             	shl    $0x2,%eax
  801e91:	05 44 10 81 00       	add    $0x811044,%eax
  801e96:	8b 00                	mov    (%eax),%eax
  801e98:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801e9b:	75 08                	jne    801ea5 <smalloc+0x9f>
        {
            exactIdx = i;
  801e9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ea0:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801ea3:	eb 5b                	jmp    801f00 <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801ea5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ea8:	89 d0                	mov    %edx,%eax
  801eaa:	01 c0                	add    %eax,%eax
  801eac:	01 d0                	add    %edx,%eax
  801eae:	c1 e0 02             	shl    $0x2,%eax
  801eb1:	05 48 10 81 00       	add    $0x811048,%eax
  801eb6:	8a 00                	mov    (%eax),%al
  801eb8:	84 c0                	test   %al,%al
  801eba:	74 34                	je     801ef0 <smalloc+0xea>
  801ebc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ebf:	89 d0                	mov    %edx,%eax
  801ec1:	01 c0                	add    %eax,%eax
  801ec3:	01 d0                	add    %edx,%eax
  801ec5:	c1 e0 02             	shl    $0x2,%eax
  801ec8:	05 44 10 81 00       	add    $0x811044,%eax
  801ecd:	8b 00                	mov    (%eax),%eax
  801ecf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801ed2:	76 1c                	jbe    801ef0 <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  801ed4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ed7:	89 d0                	mov    %edx,%eax
  801ed9:	01 c0                	add    %eax,%eax
  801edb:	01 d0                	add    %edx,%eax
  801edd:	c1 e0 02             	shl    $0x2,%eax
  801ee0:	05 44 10 81 00       	add    $0x811044,%eax
  801ee5:	8b 00                	mov    (%eax),%eax
  801ee7:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801eea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801eed:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801ef0:	ff 45 e8             	incl   -0x18(%ebp)
  801ef3:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801efa:	0f 8e 6e ff ff ff    	jle    801e6e <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  801f00:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801f07:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801f0b:	74 7d                	je     801f8a <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801f0d:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801f14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f17:	89 d0                	mov    %edx,%eax
  801f19:	01 c0                	add    %eax,%eax
  801f1b:	01 d0                	add    %edx,%eax
  801f1d:	c1 e0 02             	shl    $0x2,%eax
  801f20:	05 40 10 81 00       	add    $0x811040,%eax
  801f25:	8b 10                	mov    (%eax),%edx
  801f27:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801f2a:	01 d0                	add    %edx,%eax
  801f2c:	48                   	dec    %eax
  801f2d:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801f30:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801f33:	ba 00 00 00 00       	mov    $0x0,%edx
  801f38:	f7 75 bc             	divl   -0x44(%ebp)
  801f3b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801f3e:	29 d0                	sub    %edx,%eax
  801f40:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801f43:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f46:	89 d0                	mov    %edx,%eax
  801f48:	01 c0                	add    %eax,%eax
  801f4a:	01 d0                	add    %edx,%eax
  801f4c:	c1 e0 02             	shl    $0x2,%eax
  801f4f:	05 48 10 81 00       	add    $0x811048,%eax
  801f54:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801f57:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f5a:	89 d0                	mov    %edx,%eax
  801f5c:	01 c0                	add    %eax,%eax
  801f5e:	01 d0                	add    %edx,%eax
  801f60:	c1 e0 02             	shl    $0x2,%eax
  801f63:	05 44 10 81 00       	add    $0x811044,%eax
  801f68:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801f6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f71:	89 d0                	mov    %edx,%eax
  801f73:	01 c0                	add    %eax,%eax
  801f75:	01 d0                	add    %edx,%eax
  801f77:	c1 e0 02             	shl    $0x2,%eax
  801f7a:	05 40 10 81 00       	add    $0x811040,%eax
  801f7f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f85:	e9 2d 01 00 00       	jmp    8020b7 <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  801f8a:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801f8e:	0f 84 ce 00 00 00    	je     802062 <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  801f94:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  801f9b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f9e:	89 d0                	mov    %edx,%eax
  801fa0:	01 c0                	add    %eax,%eax
  801fa2:	01 d0                	add    %edx,%eax
  801fa4:	c1 e0 02             	shl    $0x2,%eax
  801fa7:	05 40 10 81 00       	add    $0x811040,%eax
  801fac:	8b 10                	mov    (%eax),%edx
  801fae:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801fb1:	01 d0                	add    %edx,%eax
  801fb3:	48                   	dec    %eax
  801fb4:	89 45 c0             	mov    %eax,-0x40(%ebp)
  801fb7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801fba:	ba 00 00 00 00       	mov    $0x0,%edx
  801fbf:	f7 75 c4             	divl   -0x3c(%ebp)
  801fc2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801fc5:	29 d0                	sub    %edx,%eax
  801fc7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  801fca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fcd:	89 d0                	mov    %edx,%eax
  801fcf:	01 c0                	add    %eax,%eax
  801fd1:	01 d0                	add    %edx,%eax
  801fd3:	c1 e0 02             	shl    $0x2,%eax
  801fd6:	05 44 10 81 00       	add    $0x811044,%eax
  801fdb:	8b 00                	mov    (%eax),%eax
  801fdd:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801fe0:	75 47                	jne    802029 <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  801fe2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fe5:	89 d0                	mov    %edx,%eax
  801fe7:	01 c0                	add    %eax,%eax
  801fe9:	01 d0                	add    %edx,%eax
  801feb:	c1 e0 02             	shl    $0x2,%eax
  801fee:	05 48 10 81 00       	add    $0x811048,%eax
  801ff3:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  801ff6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ff9:	89 d0                	mov    %edx,%eax
  801ffb:	01 c0                	add    %eax,%eax
  801ffd:	01 d0                	add    %edx,%eax
  801fff:	c1 e0 02             	shl    $0x2,%eax
  802002:	05 44 10 81 00       	add    $0x811044,%eax
  802007:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  80200d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802010:	89 d0                	mov    %edx,%eax
  802012:	01 c0                	add    %eax,%eax
  802014:	01 d0                	add    %edx,%eax
  802016:	c1 e0 02             	shl    $0x2,%eax
  802019:	05 40 10 81 00       	add    $0x811040,%eax
  80201e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802024:	e9 8e 00 00 00       	jmp    8020b7 <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  802029:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80202c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80202f:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802032:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802035:	89 d0                	mov    %edx,%eax
  802037:	01 c0                	add    %eax,%eax
  802039:	01 d0                	add    %edx,%eax
  80203b:	c1 e0 02             	shl    $0x2,%eax
  80203e:	05 40 10 81 00       	add    $0x811040,%eax
  802043:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  802045:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802048:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80204b:	89 c2                	mov    %eax,%edx
  80204d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802050:	89 c8                	mov    %ecx,%eax
  802052:	01 c0                	add    %eax,%eax
  802054:	01 c8                	add    %ecx,%eax
  802056:	c1 e0 02             	shl    $0x2,%eax
  802059:	05 44 10 81 00       	add    $0x811044,%eax
  80205e:	89 10                	mov    %edx,(%eax)
  802060:	eb 55                	jmp    8020b7 <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  802062:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  802069:	8b 15 88 50 83 00    	mov    0x835088,%edx
  80206f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802072:	01 d0                	add    %edx,%eax
  802074:	48                   	dec    %eax
  802075:	89 45 cc             	mov    %eax,-0x34(%ebp)
  802078:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80207b:	ba 00 00 00 00       	mov    $0x0,%edx
  802080:	f7 75 d0             	divl   -0x30(%ebp)
  802083:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802086:	29 d0                	sub    %edx,%eax
  802088:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  80208b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80208e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802091:	01 d0                	add    %edx,%eax
  802093:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802098:	76 0a                	jbe    8020a4 <smalloc+0x29e>
            return NULL;
  80209a:	b8 00 00 00 00       	mov    $0x0,%eax
  80209f:	e9 ba 00 00 00       	jmp    80215e <smalloc+0x358>
        va = start;
  8020a4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8020a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  8020aa:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8020ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020b0:	01 d0                	add    %edx,%eax
  8020b2:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8020b7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8020be:	eb 5e                	jmp    80211e <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  8020c0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020c3:	89 d0                	mov    %edx,%eax
  8020c5:	01 c0                	add    %eax,%eax
  8020c7:	01 d0                	add    %edx,%eax
  8020c9:	c1 e0 02             	shl    $0x2,%eax
  8020cc:	05 48 50 80 00       	add    $0x805048,%eax
  8020d1:	8a 00                	mov    (%eax),%al
  8020d3:	84 c0                	test   %al,%al
  8020d5:	75 44                	jne    80211b <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  8020d7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020da:	89 d0                	mov    %edx,%eax
  8020dc:	01 c0                	add    %eax,%eax
  8020de:	01 d0                	add    %edx,%eax
  8020e0:	c1 e0 02             	shl    $0x2,%eax
  8020e3:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  8020e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020ec:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  8020ee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020f1:	89 d0                	mov    %edx,%eax
  8020f3:	01 c0                	add    %eax,%eax
  8020f5:	01 d0                	add    %edx,%eax
  8020f7:	c1 e0 02             	shl    $0x2,%eax
  8020fa:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802100:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802103:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  802105:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802108:	89 d0                	mov    %edx,%eax
  80210a:	01 c0                	add    %eax,%eax
  80210c:	01 d0                	add    %edx,%eax
  80210e:	c1 e0 02             	shl    $0x2,%eax
  802111:	05 48 50 80 00       	add    $0x805048,%eax
  802116:	c6 00 01             	movb   $0x1,(%eax)
            break;
  802119:	eb 0c                	jmp    802127 <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80211b:	ff 45 e0             	incl   -0x20(%ebp)
  80211e:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802125:	7e 99                	jle    8020c0 <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  802127:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80212a:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  80212e:	52                   	push   %edx
  80212f:	50                   	push   %eax
  802130:	ff 75 d4             	pushl  -0x2c(%ebp)
  802133:	ff 75 08             	pushl  0x8(%ebp)
  802136:	e8 de 0e 00 00       	call   803019 <sys_create_shared_object>
  80213b:	83 c4 10             	add    $0x10,%esp
  80213e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  802141:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  802145:	75 07                	jne    80214e <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  802147:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80214c:	eb 10                	jmp    80215e <smalloc+0x358>
    if (r < 0)
  80214e:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  802152:	79 07                	jns    80215b <smalloc+0x355>
        return NULL;
  802154:	b8 00 00 00 00       	mov    $0x0,%eax
  802159:	eb 03                	jmp    80215e <smalloc+0x358>
    return (void*)va;
  80215b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  80215e:	c9                   	leave  
  80215f:	c3                   	ret    

00802160 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802160:	55                   	push   %ebp
  802161:	89 e5                	mov    %esp,%ebp
  802163:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802166:	e8 51 f4 ff ff       	call   8015bc <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  80216b:	83 ec 08             	sub    $0x8,%esp
  80216e:	ff 75 0c             	pushl  0xc(%ebp)
  802171:	ff 75 08             	pushl  0x8(%ebp)
  802174:	e8 ca 0e 00 00       	call   803043 <sys_size_of_shared_object>
  802179:	83 c4 10             	add    $0x10,%esp
  80217c:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  80217f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802183:	7f 0a                	jg     80218f <sget+0x2f>
        return NULL;
  802185:	b8 00 00 00 00       	mov    $0x0,%eax
  80218a:	e9 28 03 00 00       	jmp    8024b7 <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  80218f:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802196:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802199:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80219c:	01 d0                	add    %edx,%eax
  80219e:	48                   	dec    %eax
  80219f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8021a2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8021a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8021aa:	f7 75 d8             	divl   -0x28(%ebp)
  8021ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8021b0:	29 d0                	sub    %edx,%eax
  8021b2:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  8021b5:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  8021bc:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  8021c3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8021ca:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8021d1:	e9 85 00 00 00       	jmp    80225b <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  8021d6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8021d9:	89 d0                	mov    %edx,%eax
  8021db:	01 c0                	add    %eax,%eax
  8021dd:	01 d0                	add    %edx,%eax
  8021df:	c1 e0 02             	shl    $0x2,%eax
  8021e2:	05 48 10 81 00       	add    $0x811048,%eax
  8021e7:	8a 00                	mov    (%eax),%al
  8021e9:	84 c0                	test   %al,%al
  8021eb:	74 20                	je     80220d <sget+0xad>
  8021ed:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8021f0:	89 d0                	mov    %edx,%eax
  8021f2:	01 c0                	add    %eax,%eax
  8021f4:	01 d0                	add    %edx,%eax
  8021f6:	c1 e0 02             	shl    $0x2,%eax
  8021f9:	05 44 10 81 00       	add    $0x811044,%eax
  8021fe:	8b 00                	mov    (%eax),%eax
  802200:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802203:	75 08                	jne    80220d <sget+0xad>
        {
            exactIdx = i;
  802205:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802208:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  80220b:	eb 5b                	jmp    802268 <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  80220d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802210:	89 d0                	mov    %edx,%eax
  802212:	01 c0                	add    %eax,%eax
  802214:	01 d0                	add    %edx,%eax
  802216:	c1 e0 02             	shl    $0x2,%eax
  802219:	05 48 10 81 00       	add    $0x811048,%eax
  80221e:	8a 00                	mov    (%eax),%al
  802220:	84 c0                	test   %al,%al
  802222:	74 34                	je     802258 <sget+0xf8>
  802224:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802227:	89 d0                	mov    %edx,%eax
  802229:	01 c0                	add    %eax,%eax
  80222b:	01 d0                	add    %edx,%eax
  80222d:	c1 e0 02             	shl    $0x2,%eax
  802230:	05 44 10 81 00       	add    $0x811044,%eax
  802235:	8b 00                	mov    (%eax),%eax
  802237:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80223a:	76 1c                	jbe    802258 <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  80223c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80223f:	89 d0                	mov    %edx,%eax
  802241:	01 c0                	add    %eax,%eax
  802243:	01 d0                	add    %edx,%eax
  802245:	c1 e0 02             	shl    $0x2,%eax
  802248:	05 44 10 81 00       	add    $0x811044,%eax
  80224d:	8b 00                	mov    (%eax),%eax
  80224f:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  802252:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802255:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802258:	ff 45 e8             	incl   -0x18(%ebp)
  80225b:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802262:	0f 8e 6e ff ff ff    	jle    8021d6 <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  802268:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  80226f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  802273:	74 7d                	je     8022f2 <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  802275:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  80227c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80227f:	89 d0                	mov    %edx,%eax
  802281:	01 c0                	add    %eax,%eax
  802283:	01 d0                	add    %edx,%eax
  802285:	c1 e0 02             	shl    $0x2,%eax
  802288:	05 40 10 81 00       	add    $0x811040,%eax
  80228d:	8b 10                	mov    (%eax),%edx
  80228f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802292:	01 d0                	add    %edx,%eax
  802294:	48                   	dec    %eax
  802295:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802298:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80229b:	ba 00 00 00 00       	mov    $0x0,%edx
  8022a0:	f7 75 b8             	divl   -0x48(%ebp)
  8022a3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8022a6:	29 d0                	sub    %edx,%eax
  8022a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  8022ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ae:	89 d0                	mov    %edx,%eax
  8022b0:	01 c0                	add    %eax,%eax
  8022b2:	01 d0                	add    %edx,%eax
  8022b4:	c1 e0 02             	shl    $0x2,%eax
  8022b7:	05 48 10 81 00       	add    $0x811048,%eax
  8022bc:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  8022bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022c2:	89 d0                	mov    %edx,%eax
  8022c4:	01 c0                	add    %eax,%eax
  8022c6:	01 d0                	add    %edx,%eax
  8022c8:	c1 e0 02             	shl    $0x2,%eax
  8022cb:	05 44 10 81 00       	add    $0x811044,%eax
  8022d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  8022d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022d9:	89 d0                	mov    %edx,%eax
  8022db:	01 c0                	add    %eax,%eax
  8022dd:	01 d0                	add    %edx,%eax
  8022df:	c1 e0 02             	shl    $0x2,%eax
  8022e2:	05 40 10 81 00       	add    $0x811040,%eax
  8022e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022ed:	e9 2d 01 00 00       	jmp    80241f <sget+0x2bf>
    }
    else if (worstIdx != -1)
  8022f2:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8022f6:	0f 84 ce 00 00 00    	je     8023ca <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  8022fc:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  802303:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802306:	89 d0                	mov    %edx,%eax
  802308:	01 c0                	add    %eax,%eax
  80230a:	01 d0                	add    %edx,%eax
  80230c:	c1 e0 02             	shl    $0x2,%eax
  80230f:	05 40 10 81 00       	add    $0x811040,%eax
  802314:	8b 10                	mov    (%eax),%edx
  802316:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802319:	01 d0                	add    %edx,%eax
  80231b:	48                   	dec    %eax
  80231c:	89 45 bc             	mov    %eax,-0x44(%ebp)
  80231f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802322:	ba 00 00 00 00       	mov    $0x0,%edx
  802327:	f7 75 c0             	divl   -0x40(%ebp)
  80232a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80232d:	29 d0                	sub    %edx,%eax
  80232f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  802332:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802335:	89 d0                	mov    %edx,%eax
  802337:	01 c0                	add    %eax,%eax
  802339:	01 d0                	add    %edx,%eax
  80233b:	c1 e0 02             	shl    $0x2,%eax
  80233e:	05 44 10 81 00       	add    $0x811044,%eax
  802343:	8b 00                	mov    (%eax),%eax
  802345:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802348:	75 47                	jne    802391 <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  80234a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80234d:	89 d0                	mov    %edx,%eax
  80234f:	01 c0                	add    %eax,%eax
  802351:	01 d0                	add    %edx,%eax
  802353:	c1 e0 02             	shl    $0x2,%eax
  802356:	05 48 10 81 00       	add    $0x811048,%eax
  80235b:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  80235e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802361:	89 d0                	mov    %edx,%eax
  802363:	01 c0                	add    %eax,%eax
  802365:	01 d0                	add    %edx,%eax
  802367:	c1 e0 02             	shl    $0x2,%eax
  80236a:	05 44 10 81 00       	add    $0x811044,%eax
  80236f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  802375:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802378:	89 d0                	mov    %edx,%eax
  80237a:	01 c0                	add    %eax,%eax
  80237c:	01 d0                	add    %edx,%eax
  80237e:	c1 e0 02             	shl    $0x2,%eax
  802381:	05 40 10 81 00       	add    $0x811040,%eax
  802386:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80238c:	e9 8e 00 00 00       	jmp    80241f <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  802391:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802394:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802397:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80239a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80239d:	89 d0                	mov    %edx,%eax
  80239f:	01 c0                	add    %eax,%eax
  8023a1:	01 d0                	add    %edx,%eax
  8023a3:	c1 e0 02             	shl    $0x2,%eax
  8023a6:	05 40 10 81 00       	add    $0x811040,%eax
  8023ab:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  8023ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023b0:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8023b3:	89 c2                	mov    %eax,%edx
  8023b5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8023b8:	89 c8                	mov    %ecx,%eax
  8023ba:	01 c0                	add    %eax,%eax
  8023bc:	01 c8                	add    %ecx,%eax
  8023be:	c1 e0 02             	shl    $0x2,%eax
  8023c1:	05 44 10 81 00       	add    $0x811044,%eax
  8023c6:	89 10                	mov    %edx,(%eax)
  8023c8:	eb 55                	jmp    80241f <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  8023ca:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8023d1:	8b 15 88 50 83 00    	mov    0x835088,%edx
  8023d7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8023da:	01 d0                	add    %edx,%eax
  8023dc:	48                   	dec    %eax
  8023dd:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8023e0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8023e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8023e8:	f7 75 cc             	divl   -0x34(%ebp)
  8023eb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8023ee:	29 d0                	sub    %edx,%eax
  8023f0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  8023f3:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8023f6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8023f9:	01 d0                	add    %edx,%eax
  8023fb:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802400:	76 0a                	jbe    80240c <sget+0x2ac>
            return NULL;
  802402:	b8 00 00 00 00       	mov    $0x0,%eax
  802407:	e9 ab 00 00 00       	jmp    8024b7 <sget+0x357>
        va = start;
  80240c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80240f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  802412:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802415:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802418:	01 d0                	add    %edx,%eax
  80241a:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80241f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802426:	eb 5e                	jmp    802486 <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  802428:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80242b:	89 d0                	mov    %edx,%eax
  80242d:	01 c0                	add    %eax,%eax
  80242f:	01 d0                	add    %edx,%eax
  802431:	c1 e0 02             	shl    $0x2,%eax
  802434:	05 48 50 80 00       	add    $0x805048,%eax
  802439:	8a 00                	mov    (%eax),%al
  80243b:	84 c0                	test   %al,%al
  80243d:	75 44                	jne    802483 <sget+0x323>
        {
            uhp_allocs[i].va = va;
  80243f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802442:	89 d0                	mov    %edx,%eax
  802444:	01 c0                	add    %eax,%eax
  802446:	01 d0                	add    %edx,%eax
  802448:	c1 e0 02             	shl    $0x2,%eax
  80244b:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  802451:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802454:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  802456:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802459:	89 d0                	mov    %edx,%eax
  80245b:	01 c0                	add    %eax,%eax
  80245d:	01 d0                	add    %edx,%eax
  80245f:	c1 e0 02             	shl    $0x2,%eax
  802462:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802468:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80246b:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  80246d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802470:	89 d0                	mov    %edx,%eax
  802472:	01 c0                	add    %eax,%eax
  802474:	01 d0                	add    %edx,%eax
  802476:	c1 e0 02             	shl    $0x2,%eax
  802479:	05 48 50 80 00       	add    $0x805048,%eax
  80247e:	c6 00 01             	movb   $0x1,(%eax)
            break;
  802481:	eb 0c                	jmp    80248f <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802483:	ff 45 e0             	incl   -0x20(%ebp)
  802486:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80248d:	7e 99                	jle    802428 <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  80248f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802492:	83 ec 04             	sub    $0x4,%esp
  802495:	50                   	push   %eax
  802496:	ff 75 0c             	pushl  0xc(%ebp)
  802499:	ff 75 08             	pushl  0x8(%ebp)
  80249c:	e8 bf 0b 00 00       	call   803060 <sys_get_shared_object>
  8024a1:	83 c4 10             	add    $0x10,%esp
  8024a4:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  8024a7:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8024ab:	79 07                	jns    8024b4 <sget+0x354>
        return NULL;
  8024ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b2:	eb 03                	jmp    8024b7 <sget+0x357>
    return (void*)va;
  8024b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8024b7:	c9                   	leave  
  8024b8:	c3                   	ret    

008024b9 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8024b9:	55                   	push   %ebp
  8024ba:	89 e5                	mov    %esp,%ebp
  8024bc:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8024bf:	e8 f8 f0 ff ff       	call   8015bc <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  8024c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024c8:	75 13                	jne    8024dd <realloc+0x24>
		return malloc(new_size);
  8024ca:	83 ec 0c             	sub    $0xc,%esp
  8024cd:	ff 75 0c             	pushl  0xc(%ebp)
  8024d0:	e8 c4 f1 ff ff       	call   801699 <malloc>
  8024d5:	83 c4 10             	add    $0x10,%esp
  8024d8:	e9 f4 05 00 00       	jmp    802ad1 <realloc+0x618>
	if (new_size == 0)
  8024dd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8024e1:	75 18                	jne    8024fb <realloc+0x42>
	{
		free(virtual_address);
  8024e3:	83 ec 0c             	sub    $0xc,%esp
  8024e6:	ff 75 08             	pushl  0x8(%ebp)
  8024e9:	e8 0b f5 ff ff       	call   8019f9 <free>
  8024ee:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8024f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f6:	e9 d6 05 00 00       	jmp    802ad1 <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  8024fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fe:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  802501:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802504:	85 c0                	test   %eax,%eax
  802506:	79 74                	jns    80257c <realloc+0xc3>
  802508:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  80250f:	77 6b                	ja     80257c <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  802511:	83 ec 0c             	sub    $0xc,%esp
  802514:	ff 75 0c             	pushl  0xc(%ebp)
  802517:	e8 7d f1 ff ff       	call   801699 <malloc>
  80251c:	83 c4 10             	add    $0x10,%esp
  80251f:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  802522:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  802526:	75 0a                	jne    802532 <realloc+0x79>
			return NULL;
  802528:	b8 00 00 00 00       	mov    $0x0,%eax
  80252d:	e9 9f 05 00 00       	jmp    802ad1 <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  802532:	83 ec 0c             	sub    $0xc,%esp
  802535:	ff 75 08             	pushl  0x8(%ebp)
  802538:	e8 e0 11 00 00       	call   80371d <get_block_size>
  80253d:	83 c4 10             	add    $0x10,%esp
  802540:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  802543:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802546:	8b 45 0c             	mov    0xc(%ebp),%eax
  802549:	39 d0                	cmp    %edx,%eax
  80254b:	76 02                	jbe    80254f <realloc+0x96>
  80254d:	89 d0                	mov    %edx,%eax
  80254f:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  802552:	83 ec 04             	sub    $0x4,%esp
  802555:	ff 75 c0             	pushl  -0x40(%ebp)
  802558:	ff 75 08             	pushl  0x8(%ebp)
  80255b:	ff 75 c8             	pushl  -0x38(%ebp)
  80255e:	e8 56 eb ff ff       	call   8010b9 <memmove>
  802563:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  802566:	83 ec 0c             	sub    $0xc,%esp
  802569:	ff 75 08             	pushl  0x8(%ebp)
  80256c:	e8 88 f4 ff ff       	call   8019f9 <free>
  802571:	83 c4 10             	add    $0x10,%esp
		return newptr;
  802574:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802577:	e9 55 05 00 00       	jmp    802ad1 <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  80257c:	a1 30 51 83 00       	mov    0x835130,%eax
  802581:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  802584:	72 09                	jb     80258f <realloc+0xd6>
  802586:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  80258d:	76 0a                	jbe    802599 <realloc+0xe0>
		return NULL;
  80258f:	b8 00 00 00 00       	mov    $0x0,%eax
  802594:	e9 38 05 00 00       	jmp    802ad1 <realloc+0x618>
	uint32 oldsz = 0;
  802599:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  8025a0:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8025a7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8025ae:	eb 50                	jmp    802600 <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  8025b0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025b3:	89 d0                	mov    %edx,%eax
  8025b5:	01 c0                	add    %eax,%eax
  8025b7:	01 d0                	add    %edx,%eax
  8025b9:	c1 e0 02             	shl    $0x2,%eax
  8025bc:	05 48 50 80 00       	add    $0x805048,%eax
  8025c1:	8a 00                	mov    (%eax),%al
  8025c3:	84 c0                	test   %al,%al
  8025c5:	74 36                	je     8025fd <realloc+0x144>
  8025c7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025ca:	89 d0                	mov    %edx,%eax
  8025cc:	01 c0                	add    %eax,%eax
  8025ce:	01 d0                	add    %edx,%eax
  8025d0:	c1 e0 02             	shl    $0x2,%eax
  8025d3:	05 40 50 80 00       	add    $0x805040,%eax
  8025d8:	8b 00                	mov    (%eax),%eax
  8025da:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8025dd:	75 1e                	jne    8025fd <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  8025df:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025e2:	89 d0                	mov    %edx,%eax
  8025e4:	01 c0                	add    %eax,%eax
  8025e6:	01 d0                	add    %edx,%eax
  8025e8:	c1 e0 02             	shl    $0x2,%eax
  8025eb:	05 44 50 80 00       	add    $0x805044,%eax
  8025f0:	8b 00                	mov    (%eax),%eax
  8025f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  8025f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  8025fb:	eb 0c                	jmp    802609 <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8025fd:	ff 45 ec             	incl   -0x14(%ebp)
  802600:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802607:	7e a7                	jle    8025b0 <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  802609:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80260d:	75 0a                	jne    802619 <realloc+0x160>
		return NULL;
  80260f:	b8 00 00 00 00       	mov    $0x0,%eax
  802614:	e9 b8 04 00 00       	jmp    802ad1 <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  802619:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  802620:	8b 55 0c             	mov    0xc(%ebp),%edx
  802623:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802626:	01 d0                	add    %edx,%eax
  802628:	48                   	dec    %eax
  802629:	89 45 b8             	mov    %eax,-0x48(%ebp)
  80262c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80262f:	ba 00 00 00 00       	mov    $0x0,%edx
  802634:	f7 75 bc             	divl   -0x44(%ebp)
  802637:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80263a:	29 d0                	sub    %edx,%eax
  80263c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  80263f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802642:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802645:	75 08                	jne    80264f <realloc+0x196>
		return virtual_address;
  802647:	8b 45 08             	mov    0x8(%ebp),%eax
  80264a:	e9 82 04 00 00       	jmp    802ad1 <realloc+0x618>
	if (req < oldsz)
  80264f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802652:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802655:	0f 83 cd 02 00 00    	jae    802928 <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  80265b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265e:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  802661:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  802664:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802667:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80266a:	01 d0                	add    %edx,%eax
  80266c:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  80266f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802672:	89 d0                	mov    %edx,%eax
  802674:	01 c0                	add    %eax,%eax
  802676:	01 d0                	add    %edx,%eax
  802678:	c1 e0 02             	shl    $0x2,%eax
  80267b:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802681:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802684:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  802686:	83 ec 08             	sub    $0x8,%esp
  802689:	ff 75 b0             	pushl  -0x50(%ebp)
  80268c:	ff 75 ac             	pushl  -0x54(%ebp)
  80268f:	e8 e3 0c 00 00       	call   803377 <sys_free_user_mem>
  802694:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  802697:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  80269e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8026a5:	eb 64                	jmp    80270b <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  8026a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026aa:	89 d0                	mov    %edx,%eax
  8026ac:	01 c0                	add    %eax,%eax
  8026ae:	01 d0                	add    %edx,%eax
  8026b0:	c1 e0 02             	shl    $0x2,%eax
  8026b3:	05 48 10 81 00       	add    $0x811048,%eax
  8026b8:	8a 00                	mov    (%eax),%al
  8026ba:	84 c0                	test   %al,%al
  8026bc:	75 4a                	jne    802708 <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  8026be:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026c1:	89 d0                	mov    %edx,%eax
  8026c3:	01 c0                	add    %eax,%eax
  8026c5:	01 d0                	add    %edx,%eax
  8026c7:	c1 e0 02             	shl    $0x2,%eax
  8026ca:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  8026d0:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8026d3:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  8026d5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026d8:	89 d0                	mov    %edx,%eax
  8026da:	01 c0                	add    %eax,%eax
  8026dc:	01 d0                	add    %edx,%eax
  8026de:	c1 e0 02             	shl    $0x2,%eax
  8026e1:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  8026e7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026ea:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  8026ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026ef:	89 d0                	mov    %edx,%eax
  8026f1:	01 c0                	add    %eax,%eax
  8026f3:	01 d0                	add    %edx,%eax
  8026f5:	c1 e0 02             	shl    $0x2,%eax
  8026f8:	05 48 10 81 00       	add    $0x811048,%eax
  8026fd:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  802700:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802703:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  802706:	eb 0c                	jmp    802714 <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802708:	ff 45 e4             	incl   -0x1c(%ebp)
  80270b:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  802712:	7e 93                	jle    8026a7 <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  802714:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802718:	0f 84 8d 01 00 00    	je     8028ab <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  80271e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802725:	e9 74 01 00 00       	jmp    80289e <realloc+0x3e5>
			{
				if (k == fidx) continue;
  80272a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80272d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802730:	0f 84 64 01 00 00    	je     80289a <realloc+0x3e1>
				if (uhp_frees[k].free)
  802736:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802739:	89 d0                	mov    %edx,%eax
  80273b:	01 c0                	add    %eax,%eax
  80273d:	01 d0                	add    %edx,%eax
  80273f:	c1 e0 02             	shl    $0x2,%eax
  802742:	05 48 10 81 00       	add    $0x811048,%eax
  802747:	8a 00                	mov    (%eax),%al
  802749:	84 c0                	test   %al,%al
  80274b:	0f 84 4a 01 00 00    	je     80289b <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802751:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802754:	89 d0                	mov    %edx,%eax
  802756:	01 c0                	add    %eax,%eax
  802758:	01 d0                	add    %edx,%eax
  80275a:	c1 e0 02             	shl    $0x2,%eax
  80275d:	05 40 10 81 00       	add    $0x811040,%eax
  802762:	8b 08                	mov    (%eax),%ecx
  802764:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802767:	89 d0                	mov    %edx,%eax
  802769:	01 c0                	add    %eax,%eax
  80276b:	01 d0                	add    %edx,%eax
  80276d:	c1 e0 02             	shl    $0x2,%eax
  802770:	05 44 10 81 00       	add    $0x811044,%eax
  802775:	8b 00                	mov    (%eax),%eax
  802777:	01 c1                	add    %eax,%ecx
  802779:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80277c:	89 d0                	mov    %edx,%eax
  80277e:	01 c0                	add    %eax,%eax
  802780:	01 d0                	add    %edx,%eax
  802782:	c1 e0 02             	shl    $0x2,%eax
  802785:	05 40 10 81 00       	add    $0x811040,%eax
  80278a:	8b 00                	mov    (%eax),%eax
  80278c:	39 c1                	cmp    %eax,%ecx
  80278e:	75 7a                	jne    80280a <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  802790:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802793:	89 d0                	mov    %edx,%eax
  802795:	01 c0                	add    %eax,%eax
  802797:	01 d0                	add    %edx,%eax
  802799:	c1 e0 02             	shl    $0x2,%eax
  80279c:	05 40 10 81 00       	add    $0x811040,%eax
  8027a1:	8b 10                	mov    (%eax),%edx
  8027a3:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  8027a6:	89 c8                	mov    %ecx,%eax
  8027a8:	01 c0                	add    %eax,%eax
  8027aa:	01 c8                	add    %ecx,%eax
  8027ac:	c1 e0 02             	shl    $0x2,%eax
  8027af:	05 40 10 81 00       	add    $0x811040,%eax
  8027b4:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  8027b6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027b9:	89 d0                	mov    %edx,%eax
  8027bb:	01 c0                	add    %eax,%eax
  8027bd:	01 d0                	add    %edx,%eax
  8027bf:	c1 e0 02             	shl    $0x2,%eax
  8027c2:	05 44 10 81 00       	add    $0x811044,%eax
  8027c7:	8b 08                	mov    (%eax),%ecx
  8027c9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027cc:	89 d0                	mov    %edx,%eax
  8027ce:	01 c0                	add    %eax,%eax
  8027d0:	01 d0                	add    %edx,%eax
  8027d2:	c1 e0 02             	shl    $0x2,%eax
  8027d5:	05 44 10 81 00       	add    $0x811044,%eax
  8027da:	8b 00                	mov    (%eax),%eax
  8027dc:	01 c1                	add    %eax,%ecx
  8027de:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027e1:	89 d0                	mov    %edx,%eax
  8027e3:	01 c0                	add    %eax,%eax
  8027e5:	01 d0                	add    %edx,%eax
  8027e7:	c1 e0 02             	shl    $0x2,%eax
  8027ea:	05 44 10 81 00       	add    $0x811044,%eax
  8027ef:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  8027f1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027f4:	89 d0                	mov    %edx,%eax
  8027f6:	01 c0                	add    %eax,%eax
  8027f8:	01 d0                	add    %edx,%eax
  8027fa:	c1 e0 02             	shl    $0x2,%eax
  8027fd:	05 48 10 81 00       	add    $0x811048,%eax
  802802:	c6 00 00             	movb   $0x0,(%eax)
  802805:	e9 91 00 00 00       	jmp    80289b <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  80280a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80280d:	89 d0                	mov    %edx,%eax
  80280f:	01 c0                	add    %eax,%eax
  802811:	01 d0                	add    %edx,%eax
  802813:	c1 e0 02             	shl    $0x2,%eax
  802816:	05 40 10 81 00       	add    $0x811040,%eax
  80281b:	8b 08                	mov    (%eax),%ecx
  80281d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802820:	89 d0                	mov    %edx,%eax
  802822:	01 c0                	add    %eax,%eax
  802824:	01 d0                	add    %edx,%eax
  802826:	c1 e0 02             	shl    $0x2,%eax
  802829:	05 44 10 81 00       	add    $0x811044,%eax
  80282e:	8b 00                	mov    (%eax),%eax
  802830:	01 c1                	add    %eax,%ecx
  802832:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802835:	89 d0                	mov    %edx,%eax
  802837:	01 c0                	add    %eax,%eax
  802839:	01 d0                	add    %edx,%eax
  80283b:	c1 e0 02             	shl    $0x2,%eax
  80283e:	05 40 10 81 00       	add    $0x811040,%eax
  802843:	8b 00                	mov    (%eax),%eax
  802845:	39 c1                	cmp    %eax,%ecx
  802847:	75 52                	jne    80289b <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  802849:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80284c:	89 d0                	mov    %edx,%eax
  80284e:	01 c0                	add    %eax,%eax
  802850:	01 d0                	add    %edx,%eax
  802852:	c1 e0 02             	shl    $0x2,%eax
  802855:	05 44 10 81 00       	add    $0x811044,%eax
  80285a:	8b 08                	mov    (%eax),%ecx
  80285c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80285f:	89 d0                	mov    %edx,%eax
  802861:	01 c0                	add    %eax,%eax
  802863:	01 d0                	add    %edx,%eax
  802865:	c1 e0 02             	shl    $0x2,%eax
  802868:	05 44 10 81 00       	add    $0x811044,%eax
  80286d:	8b 00                	mov    (%eax),%eax
  80286f:	01 c1                	add    %eax,%ecx
  802871:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802874:	89 d0                	mov    %edx,%eax
  802876:	01 c0                	add    %eax,%eax
  802878:	01 d0                	add    %edx,%eax
  80287a:	c1 e0 02             	shl    $0x2,%eax
  80287d:	05 44 10 81 00       	add    $0x811044,%eax
  802882:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802884:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802887:	89 d0                	mov    %edx,%eax
  802889:	01 c0                	add    %eax,%eax
  80288b:	01 d0                	add    %edx,%eax
  80288d:	c1 e0 02             	shl    $0x2,%eax
  802890:	05 48 10 81 00       	add    $0x811048,%eax
  802895:	c6 00 00             	movb   $0x0,(%eax)
  802898:	eb 01                	jmp    80289b <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  80289a:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  80289b:	ff 45 e0             	incl   -0x20(%ebp)
  80289e:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8028a5:	0f 8e 7f fe ff ff    	jle    80272a <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  8028ab:	a1 30 51 83 00       	mov    0x835130,%eax
  8028b0:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  8028b3:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8028ba:	eb 53                	jmp    80290f <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  8028bc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8028bf:	89 d0                	mov    %edx,%eax
  8028c1:	01 c0                	add    %eax,%eax
  8028c3:	01 d0                	add    %edx,%eax
  8028c5:	c1 e0 02             	shl    $0x2,%eax
  8028c8:	05 48 50 80 00       	add    $0x805048,%eax
  8028cd:	8a 00                	mov    (%eax),%al
  8028cf:	84 c0                	test   %al,%al
  8028d1:	74 39                	je     80290c <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  8028d3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8028d6:	89 d0                	mov    %edx,%eax
  8028d8:	01 c0                	add    %eax,%eax
  8028da:	01 d0                	add    %edx,%eax
  8028dc:	c1 e0 02             	shl    $0x2,%eax
  8028df:	05 40 50 80 00       	add    $0x805040,%eax
  8028e4:	8b 08                	mov    (%eax),%ecx
  8028e6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8028e9:	89 d0                	mov    %edx,%eax
  8028eb:	01 c0                	add    %eax,%eax
  8028ed:	01 d0                	add    %edx,%eax
  8028ef:	c1 e0 02             	shl    $0x2,%eax
  8028f2:	05 44 50 80 00       	add    $0x805044,%eax
  8028f7:	8b 00                	mov    (%eax),%eax
  8028f9:	01 c8                	add    %ecx,%eax
  8028fb:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  8028fe:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802901:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802904:	76 06                	jbe    80290c <realloc+0x453>
  802906:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802909:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  80290c:	ff 45 d8             	incl   -0x28(%ebp)
  80290f:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  802916:	7e a4                	jle    8028bc <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  802918:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80291b:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  802920:	8b 45 08             	mov    0x8(%ebp),%eax
  802923:	e9 a9 01 00 00       	jmp    802ad1 <realloc+0x618>
	}
	uint32 end = va + oldsz;
  802928:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80292b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292e:	01 d0                	add    %edx,%eax
  802930:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  802933:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  80293a:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  802941:	eb 57                	jmp    80299a <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  802943:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802946:	89 d0                	mov    %edx,%eax
  802948:	01 c0                	add    %eax,%eax
  80294a:	01 d0                	add    %edx,%eax
  80294c:	c1 e0 02             	shl    $0x2,%eax
  80294f:	05 48 10 81 00       	add    $0x811048,%eax
  802954:	8a 00                	mov    (%eax),%al
  802956:	84 c0                	test   %al,%al
  802958:	74 3d                	je     802997 <realloc+0x4de>
  80295a:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80295d:	89 d0                	mov    %edx,%eax
  80295f:	01 c0                	add    %eax,%eax
  802961:	01 d0                	add    %edx,%eax
  802963:	c1 e0 02             	shl    $0x2,%eax
  802966:	05 40 10 81 00       	add    $0x811040,%eax
  80296b:	8b 00                	mov    (%eax),%eax
  80296d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802970:	75 25                	jne    802997 <realloc+0x4de>
  802972:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802975:	89 d0                	mov    %edx,%eax
  802977:	01 c0                	add    %eax,%eax
  802979:	01 d0                	add    %edx,%eax
  80297b:	c1 e0 02             	shl    $0x2,%eax
  80297e:	05 44 10 81 00       	add    $0x811044,%eax
  802983:	8b 10                	mov    (%eax),%edx
  802985:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802988:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80298b:	39 c2                	cmp    %eax,%edx
  80298d:	72 08                	jb     802997 <realloc+0x4de>
		{
			adjIdx = j; break;
  80298f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802992:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802995:	eb 0c                	jmp    8029a3 <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802997:	ff 45 d0             	incl   -0x30(%ebp)
  80299a:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  8029a1:	7e a0                	jle    802943 <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  8029a3:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  8029a7:	0f 84 d6 00 00 00    	je     802a83 <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  8029ad:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8029b0:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8029b3:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  8029b6:	83 ec 08             	sub    $0x8,%esp
  8029b9:	ff 75 a0             	pushl  -0x60(%ebp)
  8029bc:	ff 75 a4             	pushl  -0x5c(%ebp)
  8029bf:	e8 cf 09 00 00       	call   803393 <sys_allocate_user_mem>
  8029c4:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  8029c7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029ca:	89 d0                	mov    %edx,%eax
  8029cc:	01 c0                	add    %eax,%eax
  8029ce:	01 d0                	add    %edx,%eax
  8029d0:	c1 e0 02             	shl    $0x2,%eax
  8029d3:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8029d9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8029dc:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  8029de:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8029e1:	89 d0                	mov    %edx,%eax
  8029e3:	01 c0                	add    %eax,%eax
  8029e5:	01 d0                	add    %edx,%eax
  8029e7:	c1 e0 02             	shl    $0x2,%eax
  8029ea:	05 40 10 81 00       	add    $0x811040,%eax
  8029ef:	8b 10                	mov    (%eax),%edx
  8029f1:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8029f4:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8029f7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8029fa:	89 d0                	mov    %edx,%eax
  8029fc:	01 c0                	add    %eax,%eax
  8029fe:	01 d0                	add    %edx,%eax
  802a00:	c1 e0 02             	shl    $0x2,%eax
  802a03:	05 40 10 81 00       	add    $0x811040,%eax
  802a08:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  802a0a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a0d:	89 d0                	mov    %edx,%eax
  802a0f:	01 c0                	add    %eax,%eax
  802a11:	01 d0                	add    %edx,%eax
  802a13:	c1 e0 02             	shl    $0x2,%eax
  802a16:	05 44 10 81 00       	add    $0x811044,%eax
  802a1b:	8b 00                	mov    (%eax),%eax
  802a1d:	2b 45 a0             	sub    -0x60(%ebp),%eax
  802a20:	89 c2                	mov    %eax,%edx
  802a22:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  802a25:	89 c8                	mov    %ecx,%eax
  802a27:	01 c0                	add    %eax,%eax
  802a29:	01 c8                	add    %ecx,%eax
  802a2b:	c1 e0 02             	shl    $0x2,%eax
  802a2e:	05 44 10 81 00       	add    $0x811044,%eax
  802a33:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  802a35:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a38:	89 d0                	mov    %edx,%eax
  802a3a:	01 c0                	add    %eax,%eax
  802a3c:	01 d0                	add    %edx,%eax
  802a3e:	c1 e0 02             	shl    $0x2,%eax
  802a41:	05 44 10 81 00       	add    $0x811044,%eax
  802a46:	8b 00                	mov    (%eax),%eax
  802a48:	85 c0                	test   %eax,%eax
  802a4a:	75 14                	jne    802a60 <realloc+0x5a7>
  802a4c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a4f:	89 d0                	mov    %edx,%eax
  802a51:	01 c0                	add    %eax,%eax
  802a53:	01 d0                	add    %edx,%eax
  802a55:	c1 e0 02             	shl    $0x2,%eax
  802a58:	05 48 10 81 00       	add    $0x811048,%eax
  802a5d:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  802a60:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a63:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a66:	01 c2                	add    %eax,%edx
  802a68:	a1 88 50 83 00       	mov    0x835088,%eax
  802a6d:	39 c2                	cmp    %eax,%edx
  802a6f:	76 0d                	jbe    802a7e <realloc+0x5c5>
  802a71:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a74:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a77:	01 d0                	add    %edx,%eax
  802a79:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  802a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a81:	eb 4e                	jmp    802ad1 <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  802a83:	83 ec 0c             	sub    $0xc,%esp
  802a86:	ff 75 0c             	pushl  0xc(%ebp)
  802a89:	e8 0b ec ff ff       	call   801699 <malloc>
  802a8e:	83 c4 10             	add    $0x10,%esp
  802a91:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  802a94:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  802a98:	75 07                	jne    802aa1 <realloc+0x5e8>
		return NULL;
  802a9a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a9f:	eb 30                	jmp    802ad1 <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  802aa1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aa4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802aa7:	39 d0                	cmp    %edx,%eax
  802aa9:	76 02                	jbe    802aad <realloc+0x5f4>
  802aab:	89 d0                	mov    %edx,%eax
  802aad:	8b 55 9c             	mov    -0x64(%ebp),%edx
  802ab0:	83 ec 04             	sub    $0x4,%esp
  802ab3:	50                   	push   %eax
  802ab4:	52                   	push   %edx
  802ab5:	ff 75 cc             	pushl  -0x34(%ebp)
  802ab8:	e8 cf 06 00 00       	call   80318c <sys_move_user_mem>
  802abd:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  802ac0:	83 ec 0c             	sub    $0xc,%esp
  802ac3:	ff 75 08             	pushl  0x8(%ebp)
  802ac6:	e8 2e ef ff ff       	call   8019f9 <free>
  802acb:	83 c4 10             	add    $0x10,%esp
	return newptr;
  802ace:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  802ad1:	c9                   	leave  
  802ad2:	c3                   	ret    

00802ad3 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802ad3:	55                   	push   %ebp
  802ad4:	89 e5                	mov    %esp,%ebp
  802ad6:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  802ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  802adc:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  802adf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802ae3:	0f 84 33 03 00 00    	je     802e1c <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  802ae9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802aec:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  802af1:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  802af4:	83 ec 08             	sub    $0x8,%esp
  802af7:	ff 75 08             	pushl  0x8(%ebp)
  802afa:	ff 75 d8             	pushl  -0x28(%ebp)
  802afd:	e8 7d 05 00 00       	call   80307f <sys_delete_shared_object>
  802b02:	83 c4 10             	add    $0x10,%esp
  802b05:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  802b08:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802b0c:	0f 88 0d 03 00 00    	js     802e1f <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802b12:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802b19:	e9 ef 02 00 00       	jmp    802e0d <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802b1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b21:	89 d0                	mov    %edx,%eax
  802b23:	01 c0                	add    %eax,%eax
  802b25:	01 d0                	add    %edx,%eax
  802b27:	c1 e0 02             	shl    $0x2,%eax
  802b2a:	05 48 50 80 00       	add    $0x805048,%eax
  802b2f:	8a 00                	mov    (%eax),%al
  802b31:	84 c0                	test   %al,%al
  802b33:	0f 84 d1 02 00 00    	je     802e0a <sfree+0x337>
  802b39:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b3c:	89 d0                	mov    %edx,%eax
  802b3e:	01 c0                	add    %eax,%eax
  802b40:	01 d0                	add    %edx,%eax
  802b42:	c1 e0 02             	shl    $0x2,%eax
  802b45:	05 40 50 80 00       	add    $0x805040,%eax
  802b4a:	8b 00                	mov    (%eax),%eax
  802b4c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802b4f:	0f 85 b5 02 00 00    	jne    802e0a <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  802b55:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b58:	89 d0                	mov    %edx,%eax
  802b5a:	01 c0                	add    %eax,%eax
  802b5c:	01 d0                	add    %edx,%eax
  802b5e:	c1 e0 02             	shl    $0x2,%eax
  802b61:	05 44 50 80 00       	add    $0x805044,%eax
  802b66:	8b 00                	mov    (%eax),%eax
  802b68:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  802b6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b6e:	89 d0                	mov    %edx,%eax
  802b70:	01 c0                	add    %eax,%eax
  802b72:	01 d0                	add    %edx,%eax
  802b74:	c1 e0 02             	shl    $0x2,%eax
  802b77:	05 48 50 80 00       	add    $0x805048,%eax
  802b7c:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  802b7f:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802b86:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802b8d:	eb 64                	jmp    802bf3 <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  802b8f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b92:	89 d0                	mov    %edx,%eax
  802b94:	01 c0                	add    %eax,%eax
  802b96:	01 d0                	add    %edx,%eax
  802b98:	c1 e0 02             	shl    $0x2,%eax
  802b9b:	05 48 10 81 00       	add    $0x811048,%eax
  802ba0:	8a 00                	mov    (%eax),%al
  802ba2:	84 c0                	test   %al,%al
  802ba4:	75 4a                	jne    802bf0 <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  802ba6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ba9:	89 d0                	mov    %edx,%eax
  802bab:	01 c0                	add    %eax,%eax
  802bad:	01 d0                	add    %edx,%eax
  802baf:	c1 e0 02             	shl    $0x2,%eax
  802bb2:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  802bb8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802bbb:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  802bbd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bc0:	89 d0                	mov    %edx,%eax
  802bc2:	01 c0                	add    %eax,%eax
  802bc4:	01 d0                	add    %edx,%eax
  802bc6:	c1 e0 02             	shl    $0x2,%eax
  802bc9:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  802bcf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802bd2:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  802bd4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bd7:	89 d0                	mov    %edx,%eax
  802bd9:	01 c0                	add    %eax,%eax
  802bdb:	01 d0                	add    %edx,%eax
  802bdd:	c1 e0 02             	shl    $0x2,%eax
  802be0:	05 48 10 81 00       	add    $0x811048,%eax
  802be5:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  802be8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802beb:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  802bee:	eb 0c                	jmp    802bfc <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802bf0:	ff 45 ec             	incl   -0x14(%ebp)
  802bf3:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802bfa:	7e 93                	jle    802b8f <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  802bfc:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802c00:	0f 84 8d 01 00 00    	je     802d93 <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802c06:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802c0d:	e9 74 01 00 00       	jmp    802d86 <sfree+0x2b3>
				{
					if (k == fidx) continue;
  802c12:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c15:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c18:	0f 84 64 01 00 00    	je     802d82 <sfree+0x2af>
					if (uhp_frees[k].free)
  802c1e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c21:	89 d0                	mov    %edx,%eax
  802c23:	01 c0                	add    %eax,%eax
  802c25:	01 d0                	add    %edx,%eax
  802c27:	c1 e0 02             	shl    $0x2,%eax
  802c2a:	05 48 10 81 00       	add    $0x811048,%eax
  802c2f:	8a 00                	mov    (%eax),%al
  802c31:	84 c0                	test   %al,%al
  802c33:	0f 84 4a 01 00 00    	je     802d83 <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802c39:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c3c:	89 d0                	mov    %edx,%eax
  802c3e:	01 c0                	add    %eax,%eax
  802c40:	01 d0                	add    %edx,%eax
  802c42:	c1 e0 02             	shl    $0x2,%eax
  802c45:	05 40 10 81 00       	add    $0x811040,%eax
  802c4a:	8b 08                	mov    (%eax),%ecx
  802c4c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c4f:	89 d0                	mov    %edx,%eax
  802c51:	01 c0                	add    %eax,%eax
  802c53:	01 d0                	add    %edx,%eax
  802c55:	c1 e0 02             	shl    $0x2,%eax
  802c58:	05 44 10 81 00       	add    $0x811044,%eax
  802c5d:	8b 00                	mov    (%eax),%eax
  802c5f:	01 c1                	add    %eax,%ecx
  802c61:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c64:	89 d0                	mov    %edx,%eax
  802c66:	01 c0                	add    %eax,%eax
  802c68:	01 d0                	add    %edx,%eax
  802c6a:	c1 e0 02             	shl    $0x2,%eax
  802c6d:	05 40 10 81 00       	add    $0x811040,%eax
  802c72:	8b 00                	mov    (%eax),%eax
  802c74:	39 c1                	cmp    %eax,%ecx
  802c76:	75 7a                	jne    802cf2 <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  802c78:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c7b:	89 d0                	mov    %edx,%eax
  802c7d:	01 c0                	add    %eax,%eax
  802c7f:	01 d0                	add    %edx,%eax
  802c81:	c1 e0 02             	shl    $0x2,%eax
  802c84:	05 40 10 81 00       	add    $0x811040,%eax
  802c89:	8b 10                	mov    (%eax),%edx
  802c8b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802c8e:	89 c8                	mov    %ecx,%eax
  802c90:	01 c0                	add    %eax,%eax
  802c92:	01 c8                	add    %ecx,%eax
  802c94:	c1 e0 02             	shl    $0x2,%eax
  802c97:	05 40 10 81 00       	add    $0x811040,%eax
  802c9c:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  802c9e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ca1:	89 d0                	mov    %edx,%eax
  802ca3:	01 c0                	add    %eax,%eax
  802ca5:	01 d0                	add    %edx,%eax
  802ca7:	c1 e0 02             	shl    $0x2,%eax
  802caa:	05 44 10 81 00       	add    $0x811044,%eax
  802caf:	8b 08                	mov    (%eax),%ecx
  802cb1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cb4:	89 d0                	mov    %edx,%eax
  802cb6:	01 c0                	add    %eax,%eax
  802cb8:	01 d0                	add    %edx,%eax
  802cba:	c1 e0 02             	shl    $0x2,%eax
  802cbd:	05 44 10 81 00       	add    $0x811044,%eax
  802cc2:	8b 00                	mov    (%eax),%eax
  802cc4:	01 c1                	add    %eax,%ecx
  802cc6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cc9:	89 d0                	mov    %edx,%eax
  802ccb:	01 c0                	add    %eax,%eax
  802ccd:	01 d0                	add    %edx,%eax
  802ccf:	c1 e0 02             	shl    $0x2,%eax
  802cd2:	05 44 10 81 00       	add    $0x811044,%eax
  802cd7:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802cd9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cdc:	89 d0                	mov    %edx,%eax
  802cde:	01 c0                	add    %eax,%eax
  802ce0:	01 d0                	add    %edx,%eax
  802ce2:	c1 e0 02             	shl    $0x2,%eax
  802ce5:	05 48 10 81 00       	add    $0x811048,%eax
  802cea:	c6 00 00             	movb   $0x0,(%eax)
  802ced:	e9 91 00 00 00       	jmp    802d83 <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802cf2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cf5:	89 d0                	mov    %edx,%eax
  802cf7:	01 c0                	add    %eax,%eax
  802cf9:	01 d0                	add    %edx,%eax
  802cfb:	c1 e0 02             	shl    $0x2,%eax
  802cfe:	05 40 10 81 00       	add    $0x811040,%eax
  802d03:	8b 08                	mov    (%eax),%ecx
  802d05:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d08:	89 d0                	mov    %edx,%eax
  802d0a:	01 c0                	add    %eax,%eax
  802d0c:	01 d0                	add    %edx,%eax
  802d0e:	c1 e0 02             	shl    $0x2,%eax
  802d11:	05 44 10 81 00       	add    $0x811044,%eax
  802d16:	8b 00                	mov    (%eax),%eax
  802d18:	01 c1                	add    %eax,%ecx
  802d1a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d1d:	89 d0                	mov    %edx,%eax
  802d1f:	01 c0                	add    %eax,%eax
  802d21:	01 d0                	add    %edx,%eax
  802d23:	c1 e0 02             	shl    $0x2,%eax
  802d26:	05 40 10 81 00       	add    $0x811040,%eax
  802d2b:	8b 00                	mov    (%eax),%eax
  802d2d:	39 c1                	cmp    %eax,%ecx
  802d2f:	75 52                	jne    802d83 <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  802d31:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d34:	89 d0                	mov    %edx,%eax
  802d36:	01 c0                	add    %eax,%eax
  802d38:	01 d0                	add    %edx,%eax
  802d3a:	c1 e0 02             	shl    $0x2,%eax
  802d3d:	05 44 10 81 00       	add    $0x811044,%eax
  802d42:	8b 08                	mov    (%eax),%ecx
  802d44:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d47:	89 d0                	mov    %edx,%eax
  802d49:	01 c0                	add    %eax,%eax
  802d4b:	01 d0                	add    %edx,%eax
  802d4d:	c1 e0 02             	shl    $0x2,%eax
  802d50:	05 44 10 81 00       	add    $0x811044,%eax
  802d55:	8b 00                	mov    (%eax),%eax
  802d57:	01 c1                	add    %eax,%ecx
  802d59:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d5c:	89 d0                	mov    %edx,%eax
  802d5e:	01 c0                	add    %eax,%eax
  802d60:	01 d0                	add    %edx,%eax
  802d62:	c1 e0 02             	shl    $0x2,%eax
  802d65:	05 44 10 81 00       	add    $0x811044,%eax
  802d6a:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802d6c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d6f:	89 d0                	mov    %edx,%eax
  802d71:	01 c0                	add    %eax,%eax
  802d73:	01 d0                	add    %edx,%eax
  802d75:	c1 e0 02             	shl    $0x2,%eax
  802d78:	05 48 10 81 00       	add    $0x811048,%eax
  802d7d:	c6 00 00             	movb   $0x0,(%eax)
  802d80:	eb 01                	jmp    802d83 <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  802d82:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802d83:	ff 45 e8             	incl   -0x18(%ebp)
  802d86:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802d8d:	0f 8e 7f fe ff ff    	jle    802c12 <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  802d93:	a1 30 51 83 00       	mov    0x835130,%eax
  802d98:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802d9b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802da2:	eb 53                	jmp    802df7 <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  802da4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802da7:	89 d0                	mov    %edx,%eax
  802da9:	01 c0                	add    %eax,%eax
  802dab:	01 d0                	add    %edx,%eax
  802dad:	c1 e0 02             	shl    $0x2,%eax
  802db0:	05 48 50 80 00       	add    $0x805048,%eax
  802db5:	8a 00                	mov    (%eax),%al
  802db7:	84 c0                	test   %al,%al
  802db9:	74 39                	je     802df4 <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802dbb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802dbe:	89 d0                	mov    %edx,%eax
  802dc0:	01 c0                	add    %eax,%eax
  802dc2:	01 d0                	add    %edx,%eax
  802dc4:	c1 e0 02             	shl    $0x2,%eax
  802dc7:	05 40 50 80 00       	add    $0x805040,%eax
  802dcc:	8b 08                	mov    (%eax),%ecx
  802dce:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802dd1:	89 d0                	mov    %edx,%eax
  802dd3:	01 c0                	add    %eax,%eax
  802dd5:	01 d0                	add    %edx,%eax
  802dd7:	c1 e0 02             	shl    $0x2,%eax
  802dda:	05 44 50 80 00       	add    $0x805044,%eax
  802ddf:	8b 00                	mov    (%eax),%eax
  802de1:	01 c8                	add    %ecx,%eax
  802de3:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  802de6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802de9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802dec:	76 06                	jbe    802df4 <sfree+0x321>
  802dee:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802df1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802df4:	ff 45 e0             	incl   -0x20(%ebp)
  802df7:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802dfe:	7e a4                	jle    802da4 <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  802e00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e03:	a3 88 50 83 00       	mov    %eax,0x835088
			break;
  802e08:	eb 16                	jmp    802e20 <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802e0a:	ff 45 f4             	incl   -0xc(%ebp)
  802e0d:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  802e14:	0f 8e 04 fd ff ff    	jle    802b1e <sfree+0x4b>
  802e1a:	eb 04                	jmp    802e20 <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  802e1c:	90                   	nop
  802e1d:	eb 01                	jmp    802e20 <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  802e1f:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  802e20:	c9                   	leave  
  802e21:	c3                   	ret    

00802e22 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802e22:	55                   	push   %ebp
  802e23:	89 e5                	mov    %esp,%ebp
  802e25:	57                   	push   %edi
  802e26:	56                   	push   %esi
  802e27:	53                   	push   %ebx
  802e28:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e31:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802e34:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802e37:	8b 7d 18             	mov    0x18(%ebp),%edi
  802e3a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802e3d:	cd 30                	int    $0x30
  802e3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802e42:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802e45:	83 c4 10             	add    $0x10,%esp
  802e48:	5b                   	pop    %ebx
  802e49:	5e                   	pop    %esi
  802e4a:	5f                   	pop    %edi
  802e4b:	5d                   	pop    %ebp
  802e4c:	c3                   	ret    

00802e4d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802e4d:	55                   	push   %ebp
  802e4e:	89 e5                	mov    %esp,%ebp
  802e50:	83 ec 04             	sub    $0x4,%esp
  802e53:	8b 45 10             	mov    0x10(%ebp),%eax
  802e56:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802e59:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802e5c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802e60:	8b 45 08             	mov    0x8(%ebp),%eax
  802e63:	6a 00                	push   $0x0
  802e65:	51                   	push   %ecx
  802e66:	52                   	push   %edx
  802e67:	ff 75 0c             	pushl  0xc(%ebp)
  802e6a:	50                   	push   %eax
  802e6b:	6a 00                	push   $0x0
  802e6d:	e8 b0 ff ff ff       	call   802e22 <syscall>
  802e72:	83 c4 18             	add    $0x18,%esp
}
  802e75:	90                   	nop
  802e76:	c9                   	leave  
  802e77:	c3                   	ret    

00802e78 <sys_cgetc>:

int
sys_cgetc(void)
{
  802e78:	55                   	push   %ebp
  802e79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802e7b:	6a 00                	push   $0x0
  802e7d:	6a 00                	push   $0x0
  802e7f:	6a 00                	push   $0x0
  802e81:	6a 00                	push   $0x0
  802e83:	6a 00                	push   $0x0
  802e85:	6a 02                	push   $0x2
  802e87:	e8 96 ff ff ff       	call   802e22 <syscall>
  802e8c:	83 c4 18             	add    $0x18,%esp
}
  802e8f:	c9                   	leave  
  802e90:	c3                   	ret    

00802e91 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802e91:	55                   	push   %ebp
  802e92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802e94:	6a 00                	push   $0x0
  802e96:	6a 00                	push   $0x0
  802e98:	6a 00                	push   $0x0
  802e9a:	6a 00                	push   $0x0
  802e9c:	6a 00                	push   $0x0
  802e9e:	6a 03                	push   $0x3
  802ea0:	e8 7d ff ff ff       	call   802e22 <syscall>
  802ea5:	83 c4 18             	add    $0x18,%esp
}
  802ea8:	90                   	nop
  802ea9:	c9                   	leave  
  802eaa:	c3                   	ret    

00802eab <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802eab:	55                   	push   %ebp
  802eac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802eae:	6a 00                	push   $0x0
  802eb0:	6a 00                	push   $0x0
  802eb2:	6a 00                	push   $0x0
  802eb4:	6a 00                	push   $0x0
  802eb6:	6a 00                	push   $0x0
  802eb8:	6a 04                	push   $0x4
  802eba:	e8 63 ff ff ff       	call   802e22 <syscall>
  802ebf:	83 c4 18             	add    $0x18,%esp
}
  802ec2:	90                   	nop
  802ec3:	c9                   	leave  
  802ec4:	c3                   	ret    

00802ec5 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802ec5:	55                   	push   %ebp
  802ec6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802ec8:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ece:	6a 00                	push   $0x0
  802ed0:	6a 00                	push   $0x0
  802ed2:	6a 00                	push   $0x0
  802ed4:	52                   	push   %edx
  802ed5:	50                   	push   %eax
  802ed6:	6a 08                	push   $0x8
  802ed8:	e8 45 ff ff ff       	call   802e22 <syscall>
  802edd:	83 c4 18             	add    $0x18,%esp
}
  802ee0:	c9                   	leave  
  802ee1:	c3                   	ret    

00802ee2 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802ee2:	55                   	push   %ebp
  802ee3:	89 e5                	mov    %esp,%ebp
  802ee5:	56                   	push   %esi
  802ee6:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802ee7:	8b 75 18             	mov    0x18(%ebp),%esi
  802eea:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802eed:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802ef0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef6:	56                   	push   %esi
  802ef7:	53                   	push   %ebx
  802ef8:	51                   	push   %ecx
  802ef9:	52                   	push   %edx
  802efa:	50                   	push   %eax
  802efb:	6a 09                	push   $0x9
  802efd:	e8 20 ff ff ff       	call   802e22 <syscall>
  802f02:	83 c4 18             	add    $0x18,%esp
}
  802f05:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802f08:	5b                   	pop    %ebx
  802f09:	5e                   	pop    %esi
  802f0a:	5d                   	pop    %ebp
  802f0b:	c3                   	ret    

00802f0c <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802f0c:	55                   	push   %ebp
  802f0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802f0f:	6a 00                	push   $0x0
  802f11:	6a 00                	push   $0x0
  802f13:	6a 00                	push   $0x0
  802f15:	6a 00                	push   $0x0
  802f17:	ff 75 08             	pushl  0x8(%ebp)
  802f1a:	6a 0a                	push   $0xa
  802f1c:	e8 01 ff ff ff       	call   802e22 <syscall>
  802f21:	83 c4 18             	add    $0x18,%esp
}
  802f24:	c9                   	leave  
  802f25:	c3                   	ret    

00802f26 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802f26:	55                   	push   %ebp
  802f27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802f29:	6a 00                	push   $0x0
  802f2b:	6a 00                	push   $0x0
  802f2d:	6a 00                	push   $0x0
  802f2f:	ff 75 0c             	pushl  0xc(%ebp)
  802f32:	ff 75 08             	pushl  0x8(%ebp)
  802f35:	6a 0b                	push   $0xb
  802f37:	e8 e6 fe ff ff       	call   802e22 <syscall>
  802f3c:	83 c4 18             	add    $0x18,%esp
}
  802f3f:	c9                   	leave  
  802f40:	c3                   	ret    

00802f41 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802f41:	55                   	push   %ebp
  802f42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802f44:	6a 00                	push   $0x0
  802f46:	6a 00                	push   $0x0
  802f48:	6a 00                	push   $0x0
  802f4a:	6a 00                	push   $0x0
  802f4c:	6a 00                	push   $0x0
  802f4e:	6a 0c                	push   $0xc
  802f50:	e8 cd fe ff ff       	call   802e22 <syscall>
  802f55:	83 c4 18             	add    $0x18,%esp
}
  802f58:	c9                   	leave  
  802f59:	c3                   	ret    

00802f5a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802f5a:	55                   	push   %ebp
  802f5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802f5d:	6a 00                	push   $0x0
  802f5f:	6a 00                	push   $0x0
  802f61:	6a 00                	push   $0x0
  802f63:	6a 00                	push   $0x0
  802f65:	6a 00                	push   $0x0
  802f67:	6a 0d                	push   $0xd
  802f69:	e8 b4 fe ff ff       	call   802e22 <syscall>
  802f6e:	83 c4 18             	add    $0x18,%esp
}
  802f71:	c9                   	leave  
  802f72:	c3                   	ret    

00802f73 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802f73:	55                   	push   %ebp
  802f74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802f76:	6a 00                	push   $0x0
  802f78:	6a 00                	push   $0x0
  802f7a:	6a 00                	push   $0x0
  802f7c:	6a 00                	push   $0x0
  802f7e:	6a 00                	push   $0x0
  802f80:	6a 0e                	push   $0xe
  802f82:	e8 9b fe ff ff       	call   802e22 <syscall>
  802f87:	83 c4 18             	add    $0x18,%esp
}
  802f8a:	c9                   	leave  
  802f8b:	c3                   	ret    

00802f8c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802f8c:	55                   	push   %ebp
  802f8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802f8f:	6a 00                	push   $0x0
  802f91:	6a 00                	push   $0x0
  802f93:	6a 00                	push   $0x0
  802f95:	6a 00                	push   $0x0
  802f97:	6a 00                	push   $0x0
  802f99:	6a 0f                	push   $0xf
  802f9b:	e8 82 fe ff ff       	call   802e22 <syscall>
  802fa0:	83 c4 18             	add    $0x18,%esp
}
  802fa3:	c9                   	leave  
  802fa4:	c3                   	ret    

00802fa5 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802fa5:	55                   	push   %ebp
  802fa6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802fa8:	6a 00                	push   $0x0
  802faa:	6a 00                	push   $0x0
  802fac:	6a 00                	push   $0x0
  802fae:	6a 00                	push   $0x0
  802fb0:	ff 75 08             	pushl  0x8(%ebp)
  802fb3:	6a 10                	push   $0x10
  802fb5:	e8 68 fe ff ff       	call   802e22 <syscall>
  802fba:	83 c4 18             	add    $0x18,%esp
}
  802fbd:	c9                   	leave  
  802fbe:	c3                   	ret    

00802fbf <sys_scarce_memory>:

void sys_scarce_memory()
{
  802fbf:	55                   	push   %ebp
  802fc0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802fc2:	6a 00                	push   $0x0
  802fc4:	6a 00                	push   $0x0
  802fc6:	6a 00                	push   $0x0
  802fc8:	6a 00                	push   $0x0
  802fca:	6a 00                	push   $0x0
  802fcc:	6a 11                	push   $0x11
  802fce:	e8 4f fe ff ff       	call   802e22 <syscall>
  802fd3:	83 c4 18             	add    $0x18,%esp
}
  802fd6:	90                   	nop
  802fd7:	c9                   	leave  
  802fd8:	c3                   	ret    

00802fd9 <sys_cputc>:

void
sys_cputc(const char c)
{
  802fd9:	55                   	push   %ebp
  802fda:	89 e5                	mov    %esp,%ebp
  802fdc:	83 ec 04             	sub    $0x4,%esp
  802fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802fe5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802fe9:	6a 00                	push   $0x0
  802feb:	6a 00                	push   $0x0
  802fed:	6a 00                	push   $0x0
  802fef:	6a 00                	push   $0x0
  802ff1:	50                   	push   %eax
  802ff2:	6a 01                	push   $0x1
  802ff4:	e8 29 fe ff ff       	call   802e22 <syscall>
  802ff9:	83 c4 18             	add    $0x18,%esp
}
  802ffc:	90                   	nop
  802ffd:	c9                   	leave  
  802ffe:	c3                   	ret    

00802fff <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802fff:	55                   	push   %ebp
  803000:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  803002:	6a 00                	push   $0x0
  803004:	6a 00                	push   $0x0
  803006:	6a 00                	push   $0x0
  803008:	6a 00                	push   $0x0
  80300a:	6a 00                	push   $0x0
  80300c:	6a 14                	push   $0x14
  80300e:	e8 0f fe ff ff       	call   802e22 <syscall>
  803013:	83 c4 18             	add    $0x18,%esp
}
  803016:	90                   	nop
  803017:	c9                   	leave  
  803018:	c3                   	ret    

00803019 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  803019:	55                   	push   %ebp
  80301a:	89 e5                	mov    %esp,%ebp
  80301c:	83 ec 04             	sub    $0x4,%esp
  80301f:	8b 45 10             	mov    0x10(%ebp),%eax
  803022:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  803025:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803028:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80302c:	8b 45 08             	mov    0x8(%ebp),%eax
  80302f:	6a 00                	push   $0x0
  803031:	51                   	push   %ecx
  803032:	52                   	push   %edx
  803033:	ff 75 0c             	pushl  0xc(%ebp)
  803036:	50                   	push   %eax
  803037:	6a 15                	push   $0x15
  803039:	e8 e4 fd ff ff       	call   802e22 <syscall>
  80303e:	83 c4 18             	add    $0x18,%esp
}
  803041:	c9                   	leave  
  803042:	c3                   	ret    

00803043 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  803043:	55                   	push   %ebp
  803044:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  803046:	8b 55 0c             	mov    0xc(%ebp),%edx
  803049:	8b 45 08             	mov    0x8(%ebp),%eax
  80304c:	6a 00                	push   $0x0
  80304e:	6a 00                	push   $0x0
  803050:	6a 00                	push   $0x0
  803052:	52                   	push   %edx
  803053:	50                   	push   %eax
  803054:	6a 16                	push   $0x16
  803056:	e8 c7 fd ff ff       	call   802e22 <syscall>
  80305b:	83 c4 18             	add    $0x18,%esp
}
  80305e:	c9                   	leave  
  80305f:	c3                   	ret    

00803060 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  803060:	55                   	push   %ebp
  803061:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  803063:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803066:	8b 55 0c             	mov    0xc(%ebp),%edx
  803069:	8b 45 08             	mov    0x8(%ebp),%eax
  80306c:	6a 00                	push   $0x0
  80306e:	6a 00                	push   $0x0
  803070:	51                   	push   %ecx
  803071:	52                   	push   %edx
  803072:	50                   	push   %eax
  803073:	6a 17                	push   $0x17
  803075:	e8 a8 fd ff ff       	call   802e22 <syscall>
  80307a:	83 c4 18             	add    $0x18,%esp
}
  80307d:	c9                   	leave  
  80307e:	c3                   	ret    

0080307f <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80307f:	55                   	push   %ebp
  803080:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  803082:	8b 55 0c             	mov    0xc(%ebp),%edx
  803085:	8b 45 08             	mov    0x8(%ebp),%eax
  803088:	6a 00                	push   $0x0
  80308a:	6a 00                	push   $0x0
  80308c:	6a 00                	push   $0x0
  80308e:	52                   	push   %edx
  80308f:	50                   	push   %eax
  803090:	6a 18                	push   $0x18
  803092:	e8 8b fd ff ff       	call   802e22 <syscall>
  803097:	83 c4 18             	add    $0x18,%esp
}
  80309a:	c9                   	leave  
  80309b:	c3                   	ret    

0080309c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80309c:	55                   	push   %ebp
  80309d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80309f:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a2:	6a 00                	push   $0x0
  8030a4:	ff 75 14             	pushl  0x14(%ebp)
  8030a7:	ff 75 10             	pushl  0x10(%ebp)
  8030aa:	ff 75 0c             	pushl  0xc(%ebp)
  8030ad:	50                   	push   %eax
  8030ae:	6a 19                	push   $0x19
  8030b0:	e8 6d fd ff ff       	call   802e22 <syscall>
  8030b5:	83 c4 18             	add    $0x18,%esp
}
  8030b8:	c9                   	leave  
  8030b9:	c3                   	ret    

008030ba <sys_run_env>:

void sys_run_env(int32 envId)
{
  8030ba:	55                   	push   %ebp
  8030bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8030bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c0:	6a 00                	push   $0x0
  8030c2:	6a 00                	push   $0x0
  8030c4:	6a 00                	push   $0x0
  8030c6:	6a 00                	push   $0x0
  8030c8:	50                   	push   %eax
  8030c9:	6a 1a                	push   $0x1a
  8030cb:	e8 52 fd ff ff       	call   802e22 <syscall>
  8030d0:	83 c4 18             	add    $0x18,%esp
}
  8030d3:	90                   	nop
  8030d4:	c9                   	leave  
  8030d5:	c3                   	ret    

008030d6 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8030d6:	55                   	push   %ebp
  8030d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8030d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030dc:	6a 00                	push   $0x0
  8030de:	6a 00                	push   $0x0
  8030e0:	6a 00                	push   $0x0
  8030e2:	6a 00                	push   $0x0
  8030e4:	50                   	push   %eax
  8030e5:	6a 1b                	push   $0x1b
  8030e7:	e8 36 fd ff ff       	call   802e22 <syscall>
  8030ec:	83 c4 18             	add    $0x18,%esp
}
  8030ef:	c9                   	leave  
  8030f0:	c3                   	ret    

008030f1 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8030f1:	55                   	push   %ebp
  8030f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8030f4:	6a 00                	push   $0x0
  8030f6:	6a 00                	push   $0x0
  8030f8:	6a 00                	push   $0x0
  8030fa:	6a 00                	push   $0x0
  8030fc:	6a 00                	push   $0x0
  8030fe:	6a 05                	push   $0x5
  803100:	e8 1d fd ff ff       	call   802e22 <syscall>
  803105:	83 c4 18             	add    $0x18,%esp
}
  803108:	c9                   	leave  
  803109:	c3                   	ret    

0080310a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80310a:	55                   	push   %ebp
  80310b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80310d:	6a 00                	push   $0x0
  80310f:	6a 00                	push   $0x0
  803111:	6a 00                	push   $0x0
  803113:	6a 00                	push   $0x0
  803115:	6a 00                	push   $0x0
  803117:	6a 06                	push   $0x6
  803119:	e8 04 fd ff ff       	call   802e22 <syscall>
  80311e:	83 c4 18             	add    $0x18,%esp
}
  803121:	c9                   	leave  
  803122:	c3                   	ret    

00803123 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  803123:	55                   	push   %ebp
  803124:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  803126:	6a 00                	push   $0x0
  803128:	6a 00                	push   $0x0
  80312a:	6a 00                	push   $0x0
  80312c:	6a 00                	push   $0x0
  80312e:	6a 00                	push   $0x0
  803130:	6a 07                	push   $0x7
  803132:	e8 eb fc ff ff       	call   802e22 <syscall>
  803137:	83 c4 18             	add    $0x18,%esp
}
  80313a:	c9                   	leave  
  80313b:	c3                   	ret    

0080313c <sys_exit_env>:


void sys_exit_env(void)
{
  80313c:	55                   	push   %ebp
  80313d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80313f:	6a 00                	push   $0x0
  803141:	6a 00                	push   $0x0
  803143:	6a 00                	push   $0x0
  803145:	6a 00                	push   $0x0
  803147:	6a 00                	push   $0x0
  803149:	6a 1c                	push   $0x1c
  80314b:	e8 d2 fc ff ff       	call   802e22 <syscall>
  803150:	83 c4 18             	add    $0x18,%esp
}
  803153:	90                   	nop
  803154:	c9                   	leave  
  803155:	c3                   	ret    

00803156 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  803156:	55                   	push   %ebp
  803157:	89 e5                	mov    %esp,%ebp
  803159:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80315c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80315f:	8d 50 04             	lea    0x4(%eax),%edx
  803162:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803165:	6a 00                	push   $0x0
  803167:	6a 00                	push   $0x0
  803169:	6a 00                	push   $0x0
  80316b:	52                   	push   %edx
  80316c:	50                   	push   %eax
  80316d:	6a 1d                	push   $0x1d
  80316f:	e8 ae fc ff ff       	call   802e22 <syscall>
  803174:	83 c4 18             	add    $0x18,%esp
	return result;
  803177:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80317a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80317d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803180:	89 01                	mov    %eax,(%ecx)
  803182:	89 51 04             	mov    %edx,0x4(%ecx)
}
  803185:	8b 45 08             	mov    0x8(%ebp),%eax
  803188:	c9                   	leave  
  803189:	c2 04 00             	ret    $0x4

0080318c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80318c:	55                   	push   %ebp
  80318d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80318f:	6a 00                	push   $0x0
  803191:	6a 00                	push   $0x0
  803193:	ff 75 10             	pushl  0x10(%ebp)
  803196:	ff 75 0c             	pushl  0xc(%ebp)
  803199:	ff 75 08             	pushl  0x8(%ebp)
  80319c:	6a 13                	push   $0x13
  80319e:	e8 7f fc ff ff       	call   802e22 <syscall>
  8031a3:	83 c4 18             	add    $0x18,%esp
	return ;
  8031a6:	90                   	nop
}
  8031a7:	c9                   	leave  
  8031a8:	c3                   	ret    

008031a9 <sys_rcr2>:
uint32 sys_rcr2()
{
  8031a9:	55                   	push   %ebp
  8031aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8031ac:	6a 00                	push   $0x0
  8031ae:	6a 00                	push   $0x0
  8031b0:	6a 00                	push   $0x0
  8031b2:	6a 00                	push   $0x0
  8031b4:	6a 00                	push   $0x0
  8031b6:	6a 1e                	push   $0x1e
  8031b8:	e8 65 fc ff ff       	call   802e22 <syscall>
  8031bd:	83 c4 18             	add    $0x18,%esp
}
  8031c0:	c9                   	leave  
  8031c1:	c3                   	ret    

008031c2 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8031c2:	55                   	push   %ebp
  8031c3:	89 e5                	mov    %esp,%ebp
  8031c5:	83 ec 04             	sub    $0x4,%esp
  8031c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8031ce:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8031d2:	6a 00                	push   $0x0
  8031d4:	6a 00                	push   $0x0
  8031d6:	6a 00                	push   $0x0
  8031d8:	6a 00                	push   $0x0
  8031da:	50                   	push   %eax
  8031db:	6a 1f                	push   $0x1f
  8031dd:	e8 40 fc ff ff       	call   802e22 <syscall>
  8031e2:	83 c4 18             	add    $0x18,%esp
	return ;
  8031e5:	90                   	nop
}
  8031e6:	c9                   	leave  
  8031e7:	c3                   	ret    

008031e8 <rsttst>:
void rsttst()
{
  8031e8:	55                   	push   %ebp
  8031e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8031eb:	6a 00                	push   $0x0
  8031ed:	6a 00                	push   $0x0
  8031ef:	6a 00                	push   $0x0
  8031f1:	6a 00                	push   $0x0
  8031f3:	6a 00                	push   $0x0
  8031f5:	6a 21                	push   $0x21
  8031f7:	e8 26 fc ff ff       	call   802e22 <syscall>
  8031fc:	83 c4 18             	add    $0x18,%esp
	return ;
  8031ff:	90                   	nop
}
  803200:	c9                   	leave  
  803201:	c3                   	ret    

00803202 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  803202:	55                   	push   %ebp
  803203:	89 e5                	mov    %esp,%ebp
  803205:	83 ec 04             	sub    $0x4,%esp
  803208:	8b 45 14             	mov    0x14(%ebp),%eax
  80320b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80320e:	8b 55 18             	mov    0x18(%ebp),%edx
  803211:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803215:	52                   	push   %edx
  803216:	50                   	push   %eax
  803217:	ff 75 10             	pushl  0x10(%ebp)
  80321a:	ff 75 0c             	pushl  0xc(%ebp)
  80321d:	ff 75 08             	pushl  0x8(%ebp)
  803220:	6a 20                	push   $0x20
  803222:	e8 fb fb ff ff       	call   802e22 <syscall>
  803227:	83 c4 18             	add    $0x18,%esp
	return ;
  80322a:	90                   	nop
}
  80322b:	c9                   	leave  
  80322c:	c3                   	ret    

0080322d <chktst>:
void chktst(uint32 n)
{
  80322d:	55                   	push   %ebp
  80322e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803230:	6a 00                	push   $0x0
  803232:	6a 00                	push   $0x0
  803234:	6a 00                	push   $0x0
  803236:	6a 00                	push   $0x0
  803238:	ff 75 08             	pushl  0x8(%ebp)
  80323b:	6a 22                	push   $0x22
  80323d:	e8 e0 fb ff ff       	call   802e22 <syscall>
  803242:	83 c4 18             	add    $0x18,%esp
	return ;
  803245:	90                   	nop
}
  803246:	c9                   	leave  
  803247:	c3                   	ret    

00803248 <inctst>:

void inctst()
{
  803248:	55                   	push   %ebp
  803249:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80324b:	6a 00                	push   $0x0
  80324d:	6a 00                	push   $0x0
  80324f:	6a 00                	push   $0x0
  803251:	6a 00                	push   $0x0
  803253:	6a 00                	push   $0x0
  803255:	6a 23                	push   $0x23
  803257:	e8 c6 fb ff ff       	call   802e22 <syscall>
  80325c:	83 c4 18             	add    $0x18,%esp
	return ;
  80325f:	90                   	nop
}
  803260:	c9                   	leave  
  803261:	c3                   	ret    

00803262 <gettst>:
uint32 gettst()
{
  803262:	55                   	push   %ebp
  803263:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803265:	6a 00                	push   $0x0
  803267:	6a 00                	push   $0x0
  803269:	6a 00                	push   $0x0
  80326b:	6a 00                	push   $0x0
  80326d:	6a 00                	push   $0x0
  80326f:	6a 24                	push   $0x24
  803271:	e8 ac fb ff ff       	call   802e22 <syscall>
  803276:	83 c4 18             	add    $0x18,%esp
}
  803279:	c9                   	leave  
  80327a:	c3                   	ret    

0080327b <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80327b:	55                   	push   %ebp
  80327c:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80327e:	6a 00                	push   $0x0
  803280:	6a 00                	push   $0x0
  803282:	6a 00                	push   $0x0
  803284:	6a 00                	push   $0x0
  803286:	6a 00                	push   $0x0
  803288:	6a 25                	push   $0x25
  80328a:	e8 93 fb ff ff       	call   802e22 <syscall>
  80328f:	83 c4 18             	add    $0x18,%esp
  803292:	a3 80 50 83 00       	mov    %eax,0x835080
	return uheapPlaceStrategy ;
  803297:	a1 80 50 83 00       	mov    0x835080,%eax
}
  80329c:	c9                   	leave  
  80329d:	c3                   	ret    

0080329e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80329e:	55                   	push   %ebp
  80329f:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8032a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a4:	a3 80 50 83 00       	mov    %eax,0x835080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8032a9:	6a 00                	push   $0x0
  8032ab:	6a 00                	push   $0x0
  8032ad:	6a 00                	push   $0x0
  8032af:	6a 00                	push   $0x0
  8032b1:	ff 75 08             	pushl  0x8(%ebp)
  8032b4:	6a 26                	push   $0x26
  8032b6:	e8 67 fb ff ff       	call   802e22 <syscall>
  8032bb:	83 c4 18             	add    $0x18,%esp
	return ;
  8032be:	90                   	nop
}
  8032bf:	c9                   	leave  
  8032c0:	c3                   	ret    

008032c1 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8032c1:	55                   	push   %ebp
  8032c2:	89 e5                	mov    %esp,%ebp
  8032c4:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8032c5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8032c8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8032cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d1:	6a 00                	push   $0x0
  8032d3:	53                   	push   %ebx
  8032d4:	51                   	push   %ecx
  8032d5:	52                   	push   %edx
  8032d6:	50                   	push   %eax
  8032d7:	6a 27                	push   $0x27
  8032d9:	e8 44 fb ff ff       	call   802e22 <syscall>
  8032de:	83 c4 18             	add    $0x18,%esp
}
  8032e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8032e4:	c9                   	leave  
  8032e5:	c3                   	ret    

008032e6 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8032e6:	55                   	push   %ebp
  8032e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8032e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ef:	6a 00                	push   $0x0
  8032f1:	6a 00                	push   $0x0
  8032f3:	6a 00                	push   $0x0
  8032f5:	52                   	push   %edx
  8032f6:	50                   	push   %eax
  8032f7:	6a 28                	push   $0x28
  8032f9:	e8 24 fb ff ff       	call   802e22 <syscall>
  8032fe:	83 c4 18             	add    $0x18,%esp
}
  803301:	c9                   	leave  
  803302:	c3                   	ret    

00803303 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  803303:	55                   	push   %ebp
  803304:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  803306:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803309:	8b 55 0c             	mov    0xc(%ebp),%edx
  80330c:	8b 45 08             	mov    0x8(%ebp),%eax
  80330f:	6a 00                	push   $0x0
  803311:	51                   	push   %ecx
  803312:	ff 75 10             	pushl  0x10(%ebp)
  803315:	52                   	push   %edx
  803316:	50                   	push   %eax
  803317:	6a 29                	push   $0x29
  803319:	e8 04 fb ff ff       	call   802e22 <syscall>
  80331e:	83 c4 18             	add    $0x18,%esp
}
  803321:	c9                   	leave  
  803322:	c3                   	ret    

00803323 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  803323:	55                   	push   %ebp
  803324:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803326:	6a 00                	push   $0x0
  803328:	6a 00                	push   $0x0
  80332a:	ff 75 10             	pushl  0x10(%ebp)
  80332d:	ff 75 0c             	pushl  0xc(%ebp)
  803330:	ff 75 08             	pushl  0x8(%ebp)
  803333:	6a 12                	push   $0x12
  803335:	e8 e8 fa ff ff       	call   802e22 <syscall>
  80333a:	83 c4 18             	add    $0x18,%esp
	return ;
  80333d:	90                   	nop
}
  80333e:	c9                   	leave  
  80333f:	c3                   	ret    

00803340 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  803340:	55                   	push   %ebp
  803341:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  803343:	8b 55 0c             	mov    0xc(%ebp),%edx
  803346:	8b 45 08             	mov    0x8(%ebp),%eax
  803349:	6a 00                	push   $0x0
  80334b:	6a 00                	push   $0x0
  80334d:	6a 00                	push   $0x0
  80334f:	52                   	push   %edx
  803350:	50                   	push   %eax
  803351:	6a 2a                	push   $0x2a
  803353:	e8 ca fa ff ff       	call   802e22 <syscall>
  803358:	83 c4 18             	add    $0x18,%esp
	return;
  80335b:	90                   	nop
}
  80335c:	c9                   	leave  
  80335d:	c3                   	ret    

0080335e <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80335e:	55                   	push   %ebp
  80335f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  803361:	6a 00                	push   $0x0
  803363:	6a 00                	push   $0x0
  803365:	6a 00                	push   $0x0
  803367:	6a 00                	push   $0x0
  803369:	6a 00                	push   $0x0
  80336b:	6a 2b                	push   $0x2b
  80336d:	e8 b0 fa ff ff       	call   802e22 <syscall>
  803372:	83 c4 18             	add    $0x18,%esp
}
  803375:	c9                   	leave  
  803376:	c3                   	ret    

00803377 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803377:	55                   	push   %ebp
  803378:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80337a:	6a 00                	push   $0x0
  80337c:	6a 00                	push   $0x0
  80337e:	6a 00                	push   $0x0
  803380:	ff 75 0c             	pushl  0xc(%ebp)
  803383:	ff 75 08             	pushl  0x8(%ebp)
  803386:	6a 2d                	push   $0x2d
  803388:	e8 95 fa ff ff       	call   802e22 <syscall>
  80338d:	83 c4 18             	add    $0x18,%esp
	return;
  803390:	90                   	nop
}
  803391:	c9                   	leave  
  803392:	c3                   	ret    

00803393 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  803393:	55                   	push   %ebp
  803394:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  803396:	6a 00                	push   $0x0
  803398:	6a 00                	push   $0x0
  80339a:	6a 00                	push   $0x0
  80339c:	ff 75 0c             	pushl  0xc(%ebp)
  80339f:	ff 75 08             	pushl  0x8(%ebp)
  8033a2:	6a 2c                	push   $0x2c
  8033a4:	e8 79 fa ff ff       	call   802e22 <syscall>
  8033a9:	83 c4 18             	add    $0x18,%esp
	return ;
  8033ac:	90                   	nop
}
  8033ad:	c9                   	leave  
  8033ae:	c3                   	ret    

008033af <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8033af:	55                   	push   %ebp
  8033b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8033b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b8:	6a 00                	push   $0x0
  8033ba:	6a 00                	push   $0x0
  8033bc:	6a 00                	push   $0x0
  8033be:	52                   	push   %edx
  8033bf:	50                   	push   %eax
  8033c0:	6a 2e                	push   $0x2e
  8033c2:	e8 5b fa ff ff       	call   802e22 <syscall>
  8033c7:	83 c4 18             	add    $0x18,%esp
}
  8033ca:	90                   	nop
  8033cb:	c9                   	leave  
  8033cc:	c3                   	ret    

008033cd <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8033cd:	55                   	push   %ebp
  8033ce:	89 e5                	mov    %esp,%ebp
  8033d0:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  8033d3:	81 7d 08 80 d0 81 00 	cmpl   $0x81d080,0x8(%ebp)
  8033da:	72 09                	jb     8033e5 <to_page_va+0x18>
  8033dc:	81 7d 08 80 50 83 00 	cmpl   $0x835080,0x8(%ebp)
  8033e3:	72 14                	jb     8033f9 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  8033e5:	83 ec 04             	sub    $0x4,%esp
  8033e8:	68 d8 49 80 00       	push   $0x8049d8
  8033ed:	6a 15                	push   $0x15
  8033ef:	68 03 4a 80 00       	push   $0x804a03
  8033f4:	e8 10 d0 ff ff       	call   800409 <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8033f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fc:	ba 80 d0 81 00       	mov    $0x81d080,%edx
  803401:	29 d0                	sub    %edx,%eax
  803403:	c1 f8 02             	sar    $0x2,%eax
  803406:	89 c2                	mov    %eax,%edx
  803408:	89 d0                	mov    %edx,%eax
  80340a:	c1 e0 02             	shl    $0x2,%eax
  80340d:	01 d0                	add    %edx,%eax
  80340f:	c1 e0 02             	shl    $0x2,%eax
  803412:	01 d0                	add    %edx,%eax
  803414:	c1 e0 02             	shl    $0x2,%eax
  803417:	01 d0                	add    %edx,%eax
  803419:	89 c1                	mov    %eax,%ecx
  80341b:	c1 e1 08             	shl    $0x8,%ecx
  80341e:	01 c8                	add    %ecx,%eax
  803420:	89 c1                	mov    %eax,%ecx
  803422:	c1 e1 10             	shl    $0x10,%ecx
  803425:	01 c8                	add    %ecx,%eax
  803427:	01 c0                	add    %eax,%eax
  803429:	01 d0                	add    %edx,%eax
  80342b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  80342e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803431:	c1 e0 0c             	shl    $0xc,%eax
  803434:	89 c2                	mov    %eax,%edx
  803436:	a1 84 50 83 00       	mov    0x835084,%eax
  80343b:	01 d0                	add    %edx,%eax
}
  80343d:	c9                   	leave  
  80343e:	c3                   	ret    

0080343f <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  80343f:	55                   	push   %ebp
  803440:	89 e5                	mov    %esp,%ebp
  803442:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  803445:	a1 84 50 83 00       	mov    0x835084,%eax
  80344a:	8b 55 08             	mov    0x8(%ebp),%edx
  80344d:	29 c2                	sub    %eax,%edx
  80344f:	89 d0                	mov    %edx,%eax
  803451:	c1 e8 0c             	shr    $0xc,%eax
  803454:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  803457:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80345b:	78 09                	js     803466 <to_page_info+0x27>
  80345d:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  803464:	7e 14                	jle    80347a <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  803466:	83 ec 04             	sub    $0x4,%esp
  803469:	68 1c 4a 80 00       	push   $0x804a1c
  80346e:	6a 21                	push   $0x21
  803470:	68 03 4a 80 00       	push   $0x804a03
  803475:	e8 8f cf ff ff       	call   800409 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  80347a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80347d:	89 d0                	mov    %edx,%eax
  80347f:	01 c0                	add    %eax,%eax
  803481:	01 d0                	add    %edx,%eax
  803483:	c1 e0 02             	shl    $0x2,%eax
  803486:	05 80 d0 81 00       	add    $0x81d080,%eax
}
  80348b:	c9                   	leave  
  80348c:	c3                   	ret    

0080348d <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  80348d:	55                   	push   %ebp
  80348e:	89 e5                	mov    %esp,%ebp
  803490:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  803493:	8b 45 08             	mov    0x8(%ebp),%eax
  803496:	05 00 00 00 02       	add    $0x2000000,%eax
  80349b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80349e:	73 16                	jae    8034b6 <initialize_dynamic_allocator+0x29>
  8034a0:	68 40 4a 80 00       	push   $0x804a40
  8034a5:	68 66 4a 80 00       	push   $0x804a66
  8034aa:	6a 2f                	push   $0x2f
  8034ac:	68 03 4a 80 00       	push   $0x804a03
  8034b1:	e8 53 cf ff ff       	call   800409 <_panic>
	dynAllocStart = daStart;
  8034b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b9:	a3 84 50 83 00       	mov    %eax,0x835084
	dynAllocEnd = daEnd;
  8034be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034c1:	a3 60 d0 81 00       	mov    %eax,0x81d060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8034c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8034cd:	eb 36                	jmp    803505 <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  8034cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d2:	c1 e0 04             	shl    $0x4,%eax
  8034d5:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8034da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e3:	c1 e0 04             	shl    $0x4,%eax
  8034e6:	05 a4 50 83 00       	add    $0x8350a4,%eax
  8034eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f4:	c1 e0 04             	shl    $0x4,%eax
  8034f7:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8034fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803502:	ff 45 f4             	incl   -0xc(%ebp)
  803505:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  803509:	7e c4                	jle    8034cf <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  80350b:	c7 05 68 d0 81 00 00 	movl   $0x0,0x81d068
  803512:	00 00 00 
  803515:	c7 05 6c d0 81 00 00 	movl   $0x0,0x81d06c
  80351c:	00 00 00 
  80351f:	c7 05 74 d0 81 00 00 	movl   $0x0,0x81d074
  803526:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803529:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803530:	e9 1b 01 00 00       	jmp    803650 <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  803535:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803538:	89 d0                	mov    %edx,%eax
  80353a:	01 c0                	add    %eax,%eax
  80353c:	01 d0                	add    %edx,%eax
  80353e:	c1 e0 02             	shl    $0x2,%eax
  803541:	05 88 d0 81 00       	add    $0x81d088,%eax
  803546:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  80354b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80354e:	89 d0                	mov    %edx,%eax
  803550:	01 c0                	add    %eax,%eax
  803552:	01 d0                	add    %edx,%eax
  803554:	c1 e0 02             	shl    $0x2,%eax
  803557:	05 8a d0 81 00       	add    $0x81d08a,%eax
  80355c:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  803561:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803564:	89 d0                	mov    %edx,%eax
  803566:	01 c0                	add    %eax,%eax
  803568:	01 d0                	add    %edx,%eax
  80356a:	c1 e0 02             	shl    $0x2,%eax
  80356d:	05 80 d0 81 00       	add    $0x81d080,%eax
  803572:	8b 00                	mov    (%eax),%eax
  803574:	85 c0                	test   %eax,%eax
  803576:	74 2b                	je     8035a3 <initialize_dynamic_allocator+0x116>
  803578:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80357b:	89 d0                	mov    %edx,%eax
  80357d:	01 c0                	add    %eax,%eax
  80357f:	01 d0                	add    %edx,%eax
  803581:	c1 e0 02             	shl    $0x2,%eax
  803584:	05 80 d0 81 00       	add    $0x81d080,%eax
  803589:	8b 10                	mov    (%eax),%edx
  80358b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80358e:	89 c8                	mov    %ecx,%eax
  803590:	01 c0                	add    %eax,%eax
  803592:	01 c8                	add    %ecx,%eax
  803594:	c1 e0 02             	shl    $0x2,%eax
  803597:	05 84 d0 81 00       	add    $0x81d084,%eax
  80359c:	8b 00                	mov    (%eax),%eax
  80359e:	89 42 04             	mov    %eax,0x4(%edx)
  8035a1:	eb 18                	jmp    8035bb <initialize_dynamic_allocator+0x12e>
  8035a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035a6:	89 d0                	mov    %edx,%eax
  8035a8:	01 c0                	add    %eax,%eax
  8035aa:	01 d0                	add    %edx,%eax
  8035ac:	c1 e0 02             	shl    $0x2,%eax
  8035af:	05 84 d0 81 00       	add    $0x81d084,%eax
  8035b4:	8b 00                	mov    (%eax),%eax
  8035b6:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  8035bb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035be:	89 d0                	mov    %edx,%eax
  8035c0:	01 c0                	add    %eax,%eax
  8035c2:	01 d0                	add    %edx,%eax
  8035c4:	c1 e0 02             	shl    $0x2,%eax
  8035c7:	05 84 d0 81 00       	add    $0x81d084,%eax
  8035cc:	8b 00                	mov    (%eax),%eax
  8035ce:	85 c0                	test   %eax,%eax
  8035d0:	74 2a                	je     8035fc <initialize_dynamic_allocator+0x16f>
  8035d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035d5:	89 d0                	mov    %edx,%eax
  8035d7:	01 c0                	add    %eax,%eax
  8035d9:	01 d0                	add    %edx,%eax
  8035db:	c1 e0 02             	shl    $0x2,%eax
  8035de:	05 84 d0 81 00       	add    $0x81d084,%eax
  8035e3:	8b 10                	mov    (%eax),%edx
  8035e5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8035e8:	89 c8                	mov    %ecx,%eax
  8035ea:	01 c0                	add    %eax,%eax
  8035ec:	01 c8                	add    %ecx,%eax
  8035ee:	c1 e0 02             	shl    $0x2,%eax
  8035f1:	05 80 d0 81 00       	add    $0x81d080,%eax
  8035f6:	8b 00                	mov    (%eax),%eax
  8035f8:	89 02                	mov    %eax,(%edx)
  8035fa:	eb 18                	jmp    803614 <initialize_dynamic_allocator+0x187>
  8035fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035ff:	89 d0                	mov    %edx,%eax
  803601:	01 c0                	add    %eax,%eax
  803603:	01 d0                	add    %edx,%eax
  803605:	c1 e0 02             	shl    $0x2,%eax
  803608:	05 80 d0 81 00       	add    $0x81d080,%eax
  80360d:	8b 00                	mov    (%eax),%eax
  80360f:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803614:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803617:	89 d0                	mov    %edx,%eax
  803619:	01 c0                	add    %eax,%eax
  80361b:	01 d0                	add    %edx,%eax
  80361d:	c1 e0 02             	shl    $0x2,%eax
  803620:	05 80 d0 81 00       	add    $0x81d080,%eax
  803625:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80362b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80362e:	89 d0                	mov    %edx,%eax
  803630:	01 c0                	add    %eax,%eax
  803632:	01 d0                	add    %edx,%eax
  803634:	c1 e0 02             	shl    $0x2,%eax
  803637:	05 84 d0 81 00       	add    $0x81d084,%eax
  80363c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803642:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803647:	48                   	dec    %eax
  803648:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  80364d:	ff 45 f0             	incl   -0x10(%ebp)
  803650:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  803657:	0f 8e d8 fe ff ff    	jle    803535 <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  80365d:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  803664:	e9 9d 00 00 00       	jmp    803706 <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  803669:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80366f:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803672:	89 c8                	mov    %ecx,%eax
  803674:	01 c0                	add    %eax,%eax
  803676:	01 c8                	add    %ecx,%eax
  803678:	c1 e0 02             	shl    $0x2,%eax
  80367b:	05 80 d0 81 00       	add    $0x81d080,%eax
  803680:	89 10                	mov    %edx,(%eax)
  803682:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803685:	89 d0                	mov    %edx,%eax
  803687:	01 c0                	add    %eax,%eax
  803689:	01 d0                	add    %edx,%eax
  80368b:	c1 e0 02             	shl    $0x2,%eax
  80368e:	05 80 d0 81 00       	add    $0x81d080,%eax
  803693:	8b 00                	mov    (%eax),%eax
  803695:	85 c0                	test   %eax,%eax
  803697:	74 1c                	je     8036b5 <initialize_dynamic_allocator+0x228>
  803699:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80369f:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  8036a2:	89 c8                	mov    %ecx,%eax
  8036a4:	01 c0                	add    %eax,%eax
  8036a6:	01 c8                	add    %ecx,%eax
  8036a8:	c1 e0 02             	shl    $0x2,%eax
  8036ab:	05 80 d0 81 00       	add    $0x81d080,%eax
  8036b0:	89 42 04             	mov    %eax,0x4(%edx)
  8036b3:	eb 16                	jmp    8036cb <initialize_dynamic_allocator+0x23e>
  8036b5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036b8:	89 d0                	mov    %edx,%eax
  8036ba:	01 c0                	add    %eax,%eax
  8036bc:	01 d0                	add    %edx,%eax
  8036be:	c1 e0 02             	shl    $0x2,%eax
  8036c1:	05 80 d0 81 00       	add    $0x81d080,%eax
  8036c6:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  8036cb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036ce:	89 d0                	mov    %edx,%eax
  8036d0:	01 c0                	add    %eax,%eax
  8036d2:	01 d0                	add    %edx,%eax
  8036d4:	c1 e0 02             	shl    $0x2,%eax
  8036d7:	05 80 d0 81 00       	add    $0x81d080,%eax
  8036dc:	a3 68 d0 81 00       	mov    %eax,0x81d068
  8036e1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036e4:	89 d0                	mov    %edx,%eax
  8036e6:	01 c0                	add    %eax,%eax
  8036e8:	01 d0                	add    %edx,%eax
  8036ea:	c1 e0 02             	shl    $0x2,%eax
  8036ed:	05 84 d0 81 00       	add    $0x81d084,%eax
  8036f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036f8:	a1 74 d0 81 00       	mov    0x81d074,%eax
  8036fd:	40                   	inc    %eax
  8036fe:	a3 74 d0 81 00       	mov    %eax,0x81d074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803703:	ff 4d ec             	decl   -0x14(%ebp)
  803706:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80370a:	0f 89 59 ff ff ff    	jns    803669 <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  803710:	c7 05 44 d0 81 00 01 	movl   $0x1,0x81d044
  803717:	00 00 00 
}
  80371a:	90                   	nop
  80371b:	c9                   	leave  
  80371c:	c3                   	ret    

0080371d <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  80371d:	55                   	push   %ebp
  80371e:	89 e5                	mov    %esp,%ebp
  803720:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803723:	8b 45 08             	mov    0x8(%ebp),%eax
  803726:	83 ec 0c             	sub    $0xc,%esp
  803729:	50                   	push   %eax
  80372a:	e8 10 fd ff ff       	call   80343f <to_page_info>
  80372f:	83 c4 10             	add    $0x10,%esp
  803732:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  803735:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803738:	8b 40 08             	mov    0x8(%eax),%eax
  80373b:	0f b7 c0             	movzwl %ax,%eax
}
  80373e:	c9                   	leave  
  80373f:	c3                   	ret    

00803740 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803740:	55                   	push   %ebp
  803741:	89 e5                	mov    %esp,%ebp
  803743:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803746:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80374d:	76 16                	jbe    803765 <alloc_block+0x25>
  80374f:	68 7c 4a 80 00       	push   $0x804a7c
  803754:	68 66 4a 80 00       	push   $0x804a66
  803759:	6a 59                	push   $0x59
  80375b:	68 03 4a 80 00       	push   $0x804a03
  803760:	e8 a4 cc ff ff       	call   800409 <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  803765:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  80376c:	eb 08                	jmp    803776 <alloc_block+0x36>
		allocSize <<= 1;
  80376e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803771:	01 c0                	add    %eax,%eax
  803773:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803776:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803779:	3b 45 08             	cmp    0x8(%ebp),%eax
  80377c:	73 09                	jae    803787 <alloc_block+0x47>
  80377e:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  803785:	76 e7                	jbe    80376e <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  803787:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  80378e:	eb 03                	jmp    803793 <alloc_block+0x53>
		listIndex++;
  803790:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803793:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803796:	ba 08 00 00 00       	mov    $0x8,%edx
  80379b:	88 c1                	mov    %al,%cl
  80379d:	d3 e2                	shl    %cl,%edx
  80379f:	89 d0                	mov    %edx,%eax
  8037a1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8037a4:	72 ea                	jb     803790 <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8037a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8037ac:	e9 f4 00 00 00       	jmp    8038a5 <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  8037b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037b4:	c1 e0 04             	shl    $0x4,%eax
  8037b7:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8037bc:	8b 00                	mov    (%eax),%eax
  8037be:	85 c0                	test   %eax,%eax
  8037c0:	0f 84 dc 00 00 00    	je     8038a2 <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  8037c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037c9:	c1 e0 04             	shl    $0x4,%eax
  8037cc:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8037d1:	8b 00                	mov    (%eax),%eax
  8037d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  8037d6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037da:	75 14                	jne    8037f0 <alloc_block+0xb0>
  8037dc:	83 ec 04             	sub    $0x4,%esp
  8037df:	68 9d 4a 80 00       	push   $0x804a9d
  8037e4:	6a 6b                	push   $0x6b
  8037e6:	68 03 4a 80 00       	push   $0x804a03
  8037eb:	e8 19 cc ff ff       	call   800409 <_panic>
  8037f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037f3:	8b 00                	mov    (%eax),%eax
  8037f5:	85 c0                	test   %eax,%eax
  8037f7:	74 10                	je     803809 <alloc_block+0xc9>
  8037f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037fc:	8b 00                	mov    (%eax),%eax
  8037fe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803801:	8b 52 04             	mov    0x4(%edx),%edx
  803804:	89 50 04             	mov    %edx,0x4(%eax)
  803807:	eb 14                	jmp    80381d <alloc_block+0xdd>
  803809:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80380c:	8b 40 04             	mov    0x4(%eax),%eax
  80380f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803812:	c1 e2 04             	shl    $0x4,%edx
  803815:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  80381b:	89 02                	mov    %eax,(%edx)
  80381d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803820:	8b 40 04             	mov    0x4(%eax),%eax
  803823:	85 c0                	test   %eax,%eax
  803825:	74 0f                	je     803836 <alloc_block+0xf6>
  803827:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80382a:	8b 40 04             	mov    0x4(%eax),%eax
  80382d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803830:	8b 12                	mov    (%edx),%edx
  803832:	89 10                	mov    %edx,(%eax)
  803834:	eb 13                	jmp    803849 <alloc_block+0x109>
  803836:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803839:	8b 00                	mov    (%eax),%eax
  80383b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80383e:	c1 e2 04             	shl    $0x4,%edx
  803841:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803847:	89 02                	mov    %eax,(%edx)
  803849:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80384c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803852:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803855:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80385c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80385f:	c1 e0 04             	shl    $0x4,%eax
  803862:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803867:	8b 00                	mov    (%eax),%eax
  803869:	8d 50 ff             	lea    -0x1(%eax),%edx
  80386c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80386f:	c1 e0 04             	shl    $0x4,%eax
  803872:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803877:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  803879:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80387c:	83 ec 0c             	sub    $0xc,%esp
  80387f:	50                   	push   %eax
  803880:	e8 ba fb ff ff       	call   80343f <to_page_info>
  803885:	83 c4 10             	add    $0x10,%esp
  803888:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  80388b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80388e:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803892:	48                   	dec    %eax
  803893:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803896:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  80389a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80389d:	e9 8f 02 00 00       	jmp    803b31 <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8038a2:	ff 45 ec             	incl   -0x14(%ebp)
  8038a5:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8038a9:	0f 8e 02 ff ff ff    	jle    8037b1 <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  8038af:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8038b4:	85 c0                	test   %eax,%eax
  8038b6:	75 14                	jne    8038cc <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  8038b8:	83 ec 04             	sub    $0x4,%esp
  8038bb:	68 bc 4a 80 00       	push   $0x804abc
  8038c0:	6a 77                	push   $0x77
  8038c2:	68 03 4a 80 00       	push   $0x804a03
  8038c7:	e8 3d cb ff ff       	call   800409 <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  8038cc:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8038d1:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  8038d4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8038d8:	75 14                	jne    8038ee <alloc_block+0x1ae>
  8038da:	83 ec 04             	sub    $0x4,%esp
  8038dd:	68 9d 4a 80 00       	push   $0x804a9d
  8038e2:	6a 7a                	push   $0x7a
  8038e4:	68 03 4a 80 00       	push   $0x804a03
  8038e9:	e8 1b cb ff ff       	call   800409 <_panic>
  8038ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038f1:	8b 00                	mov    (%eax),%eax
  8038f3:	85 c0                	test   %eax,%eax
  8038f5:	74 10                	je     803907 <alloc_block+0x1c7>
  8038f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038fa:	8b 00                	mov    (%eax),%eax
  8038fc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8038ff:	8b 52 04             	mov    0x4(%edx),%edx
  803902:	89 50 04             	mov    %edx,0x4(%eax)
  803905:	eb 0b                	jmp    803912 <alloc_block+0x1d2>
  803907:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80390a:	8b 40 04             	mov    0x4(%eax),%eax
  80390d:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803912:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803915:	8b 40 04             	mov    0x4(%eax),%eax
  803918:	85 c0                	test   %eax,%eax
  80391a:	74 0f                	je     80392b <alloc_block+0x1eb>
  80391c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80391f:	8b 40 04             	mov    0x4(%eax),%eax
  803922:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803925:	8b 12                	mov    (%edx),%edx
  803927:	89 10                	mov    %edx,(%eax)
  803929:	eb 0a                	jmp    803935 <alloc_block+0x1f5>
  80392b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80392e:	8b 00                	mov    (%eax),%eax
  803930:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803935:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803938:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80393e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803941:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803948:	a1 74 d0 81 00       	mov    0x81d074,%eax
  80394d:	48                   	dec    %eax
  80394e:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  803953:	83 ec 0c             	sub    $0xc,%esp
  803956:	ff 75 dc             	pushl  -0x24(%ebp)
  803959:	e8 6f fa ff ff       	call   8033cd <to_page_va>
  80395e:	83 c4 10             	add    $0x10,%esp
  803961:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  803964:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803967:	83 ec 0c             	sub    $0xc,%esp
  80396a:	50                   	push   %eax
  80396b:	e8 a0 dc ff ff       	call   801610 <get_page>
  803970:	83 c4 10             	add    $0x10,%esp
  803973:	85 c0                	test   %eax,%eax
  803975:	74 14                	je     80398b <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  803977:	83 ec 04             	sub    $0x4,%esp
  80397a:	68 e4 4a 80 00       	push   $0x804ae4
  80397f:	6a 7f                	push   $0x7f
  803981:	68 03 4a 80 00       	push   $0x804a03
  803986:	e8 7e ca ff ff       	call   800409 <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  80398b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80398e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803991:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  803995:	b8 00 10 00 00       	mov    $0x1000,%eax
  80399a:	ba 00 00 00 00       	mov    $0x0,%edx
  80399f:	f7 75 f4             	divl   -0xc(%ebp)
  8039a2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8039a5:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  8039a9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8039b0:	e9 a7 00 00 00       	jmp    803a5c <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  8039b5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8039b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039bb:	01 d0                	add    %edx,%eax
  8039bd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  8039c0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8039c4:	75 17                	jne    8039dd <alloc_block+0x29d>
  8039c6:	83 ec 04             	sub    $0x4,%esp
  8039c9:	68 0c 4b 80 00       	push   $0x804b0c
  8039ce:	68 88 00 00 00       	push   $0x88
  8039d3:	68 03 4a 80 00       	push   $0x804a03
  8039d8:	e8 2c ca ff ff       	call   800409 <_panic>
  8039dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039e0:	c1 e0 04             	shl    $0x4,%eax
  8039e3:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8039e8:	8b 10                	mov    (%eax),%edx
  8039ea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039ed:	89 10                	mov    %edx,(%eax)
  8039ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039f2:	8b 00                	mov    (%eax),%eax
  8039f4:	85 c0                	test   %eax,%eax
  8039f6:	74 15                	je     803a0d <alloc_block+0x2cd>
  8039f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039fb:	c1 e0 04             	shl    $0x4,%eax
  8039fe:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803a03:	8b 00                	mov    (%eax),%eax
  803a05:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a08:	89 50 04             	mov    %edx,0x4(%eax)
  803a0b:	eb 11                	jmp    803a1e <alloc_block+0x2de>
  803a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a10:	c1 e0 04             	shl    $0x4,%eax
  803a13:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803a19:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a1c:	89 02                	mov    %eax,(%edx)
  803a1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a21:	c1 e0 04             	shl    $0x4,%eax
  803a24:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803a2a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a2d:	89 02                	mov    %eax,(%edx)
  803a2f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a32:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a3c:	c1 e0 04             	shl    $0x4,%eax
  803a3f:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803a44:	8b 00                	mov    (%eax),%eax
  803a46:	8d 50 01             	lea    0x1(%eax),%edx
  803a49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a4c:	c1 e0 04             	shl    $0x4,%eax
  803a4f:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803a54:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a59:	01 45 e8             	add    %eax,-0x18(%ebp)
  803a5c:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  803a63:	0f 86 4c ff ff ff    	jbe    8039b5 <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  803a69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a6c:	c1 e0 04             	shl    $0x4,%eax
  803a6f:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803a74:	8b 00                	mov    (%eax),%eax
  803a76:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  803a79:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803a7d:	75 17                	jne    803a96 <alloc_block+0x356>
  803a7f:	83 ec 04             	sub    $0x4,%esp
  803a82:	68 9d 4a 80 00       	push   $0x804a9d
  803a87:	68 8d 00 00 00       	push   $0x8d
  803a8c:	68 03 4a 80 00       	push   $0x804a03
  803a91:	e8 73 c9 ff ff       	call   800409 <_panic>
  803a96:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a99:	8b 00                	mov    (%eax),%eax
  803a9b:	85 c0                	test   %eax,%eax
  803a9d:	74 10                	je     803aaf <alloc_block+0x36f>
  803a9f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803aa2:	8b 00                	mov    (%eax),%eax
  803aa4:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803aa7:	8b 52 04             	mov    0x4(%edx),%edx
  803aaa:	89 50 04             	mov    %edx,0x4(%eax)
  803aad:	eb 14                	jmp    803ac3 <alloc_block+0x383>
  803aaf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803ab2:	8b 40 04             	mov    0x4(%eax),%eax
  803ab5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ab8:	c1 e2 04             	shl    $0x4,%edx
  803abb:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803ac1:	89 02                	mov    %eax,(%edx)
  803ac3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803ac6:	8b 40 04             	mov    0x4(%eax),%eax
  803ac9:	85 c0                	test   %eax,%eax
  803acb:	74 0f                	je     803adc <alloc_block+0x39c>
  803acd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803ad0:	8b 40 04             	mov    0x4(%eax),%eax
  803ad3:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803ad6:	8b 12                	mov    (%edx),%edx
  803ad8:	89 10                	mov    %edx,(%eax)
  803ada:	eb 13                	jmp    803aef <alloc_block+0x3af>
  803adc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803adf:	8b 00                	mov    (%eax),%eax
  803ae1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ae4:	c1 e2 04             	shl    $0x4,%edx
  803ae7:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803aed:	89 02                	mov    %eax,(%edx)
  803aef:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803af2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803af8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803afb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b05:	c1 e0 04             	shl    $0x4,%eax
  803b08:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803b0d:	8b 00                	mov    (%eax),%eax
  803b0f:	8d 50 ff             	lea    -0x1(%eax),%edx
  803b12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b15:	c1 e0 04             	shl    $0x4,%eax
  803b18:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803b1d:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  803b1f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b22:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803b26:	48                   	dec    %eax
  803b27:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803b2a:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  803b2e:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  803b31:	c9                   	leave  
  803b32:	c3                   	ret    

00803b33 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803b33:	55                   	push   %ebp
  803b34:	89 e5                	mov    %esp,%ebp
  803b36:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803b39:	8b 55 08             	mov    0x8(%ebp),%edx
  803b3c:	a1 84 50 83 00       	mov    0x835084,%eax
  803b41:	39 c2                	cmp    %eax,%edx
  803b43:	72 0c                	jb     803b51 <free_block+0x1e>
  803b45:	8b 55 08             	mov    0x8(%ebp),%edx
  803b48:	a1 60 d0 81 00       	mov    0x81d060,%eax
  803b4d:	39 c2                	cmp    %eax,%edx
  803b4f:	72 19                	jb     803b6a <free_block+0x37>
  803b51:	68 30 4b 80 00       	push   $0x804b30
  803b56:	68 66 4a 80 00       	push   $0x804a66
  803b5b:	68 98 00 00 00       	push   $0x98
  803b60:	68 03 4a 80 00       	push   $0x804a03
  803b65:	e8 9f c8 ff ff       	call   800409 <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b6d:	83 ec 0c             	sub    $0xc,%esp
  803b70:	50                   	push   %eax
  803b71:	e8 c9 f8 ff ff       	call   80343f <to_page_info>
  803b76:	83 c4 10             	add    $0x10,%esp
  803b79:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  803b7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b7f:	8b 40 08             	mov    0x8(%eax),%eax
  803b82:	0f b7 c0             	movzwl %ax,%eax
  803b85:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  803b88:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803b8f:	eb 03                	jmp    803b94 <free_block+0x61>
		listIndex++;
  803b91:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b97:	ba 08 00 00 00       	mov    $0x8,%edx
  803b9c:	88 c1                	mov    %al,%cl
  803b9e:	d3 e2                	shl    %cl,%edx
  803ba0:	89 d0                	mov    %edx,%eax
  803ba2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803ba5:	72 ea                	jb     803b91 <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  803ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  803baa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  803bad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803bb1:	75 17                	jne    803bca <free_block+0x97>
  803bb3:	83 ec 04             	sub    $0x4,%esp
  803bb6:	68 0c 4b 80 00       	push   $0x804b0c
  803bbb:	68 a2 00 00 00       	push   $0xa2
  803bc0:	68 03 4a 80 00       	push   $0x804a03
  803bc5:	e8 3f c8 ff ff       	call   800409 <_panic>
  803bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bcd:	c1 e0 04             	shl    $0x4,%eax
  803bd0:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803bd5:	8b 10                	mov    (%eax),%edx
  803bd7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bda:	89 10                	mov    %edx,(%eax)
  803bdc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bdf:	8b 00                	mov    (%eax),%eax
  803be1:	85 c0                	test   %eax,%eax
  803be3:	74 15                	je     803bfa <free_block+0xc7>
  803be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803be8:	c1 e0 04             	shl    $0x4,%eax
  803beb:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803bf0:	8b 00                	mov    (%eax),%eax
  803bf2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803bf5:	89 50 04             	mov    %edx,0x4(%eax)
  803bf8:	eb 11                	jmp    803c0b <free_block+0xd8>
  803bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bfd:	c1 e0 04             	shl    $0x4,%eax
  803c00:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803c06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c09:	89 02                	mov    %eax,(%edx)
  803c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c0e:	c1 e0 04             	shl    $0x4,%eax
  803c11:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803c17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c1a:	89 02                	mov    %eax,(%edx)
  803c1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c1f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c29:	c1 e0 04             	shl    $0x4,%eax
  803c2c:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803c31:	8b 00                	mov    (%eax),%eax
  803c33:	8d 50 01             	lea    0x1(%eax),%edx
  803c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c39:	c1 e0 04             	shl    $0x4,%eax
  803c3c:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803c41:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  803c43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c46:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803c4a:	40                   	inc    %eax
  803c4b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c4e:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  803c52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c55:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803c59:	0f b7 c8             	movzwl %ax,%ecx
  803c5c:	b8 00 10 00 00       	mov    $0x1000,%eax
  803c61:	ba 00 00 00 00       	mov    $0x0,%edx
  803c66:	f7 75 e8             	divl   -0x18(%ebp)
  803c69:	39 c1                	cmp    %eax,%ecx
  803c6b:	0f 85 ed 01 00 00    	jne    803e5e <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c74:	c1 e0 04             	shl    $0x4,%eax
  803c77:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803c7c:	8b 00                	mov    (%eax),%eax
  803c7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803c81:	eb 2a                	jmp    803cad <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  803c83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c86:	83 ec 0c             	sub    $0xc,%esp
  803c89:	50                   	push   %eax
  803c8a:	e8 b0 f7 ff ff       	call   80343f <to_page_info>
  803c8f:	83 c4 10             	add    $0x10,%esp
  803c92:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803c95:	75 06                	jne    803c9d <free_block+0x16a>
				tmp = b;
  803c97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c9a:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803c9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ca0:	c1 e0 04             	shl    $0x4,%eax
  803ca3:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803ca8:	8b 00                	mov    (%eax),%eax
  803caa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803cad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803cb1:	74 07                	je     803cba <free_block+0x187>
  803cb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cb6:	8b 00                	mov    (%eax),%eax
  803cb8:	eb 05                	jmp    803cbf <free_block+0x18c>
  803cba:	b8 00 00 00 00       	mov    $0x0,%eax
  803cbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803cc2:	c1 e2 04             	shl    $0x4,%edx
  803cc5:	81 c2 a8 50 83 00    	add    $0x8350a8,%edx
  803ccb:	89 02                	mov    %eax,(%edx)
  803ccd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cd0:	c1 e0 04             	shl    $0x4,%eax
  803cd3:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803cd8:	8b 00                	mov    (%eax),%eax
  803cda:	85 c0                	test   %eax,%eax
  803cdc:	75 a5                	jne    803c83 <free_block+0x150>
  803cde:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803ce2:	75 9f                	jne    803c83 <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  803ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ce7:	c1 e0 04             	shl    $0x4,%eax
  803cea:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803cef:	8b 00                	mov    (%eax),%eax
  803cf1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  803cf4:	e9 cc 00 00 00       	jmp    803dc5 <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  803cf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cfc:	8b 00                	mov    (%eax),%eax
  803cfe:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  803d01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d04:	83 ec 0c             	sub    $0xc,%esp
  803d07:	50                   	push   %eax
  803d08:	e8 32 f7 ff ff       	call   80343f <to_page_info>
  803d0d:	83 c4 10             	add    $0x10,%esp
  803d10:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803d13:	0f 85 a6 00 00 00    	jne    803dbf <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  803d19:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d1d:	75 17                	jne    803d36 <free_block+0x203>
  803d1f:	83 ec 04             	sub    $0x4,%esp
  803d22:	68 9d 4a 80 00       	push   $0x804a9d
  803d27:	68 b5 00 00 00       	push   $0xb5
  803d2c:	68 03 4a 80 00       	push   $0x804a03
  803d31:	e8 d3 c6 ff ff       	call   800409 <_panic>
  803d36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d39:	8b 00                	mov    (%eax),%eax
  803d3b:	85 c0                	test   %eax,%eax
  803d3d:	74 10                	je     803d4f <free_block+0x21c>
  803d3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d42:	8b 00                	mov    (%eax),%eax
  803d44:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d47:	8b 52 04             	mov    0x4(%edx),%edx
  803d4a:	89 50 04             	mov    %edx,0x4(%eax)
  803d4d:	eb 14                	jmp    803d63 <free_block+0x230>
  803d4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d52:	8b 40 04             	mov    0x4(%eax),%eax
  803d55:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d58:	c1 e2 04             	shl    $0x4,%edx
  803d5b:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803d61:	89 02                	mov    %eax,(%edx)
  803d63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d66:	8b 40 04             	mov    0x4(%eax),%eax
  803d69:	85 c0                	test   %eax,%eax
  803d6b:	74 0f                	je     803d7c <free_block+0x249>
  803d6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d70:	8b 40 04             	mov    0x4(%eax),%eax
  803d73:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d76:	8b 12                	mov    (%edx),%edx
  803d78:	89 10                	mov    %edx,(%eax)
  803d7a:	eb 13                	jmp    803d8f <free_block+0x25c>
  803d7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d7f:	8b 00                	mov    (%eax),%eax
  803d81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d84:	c1 e2 04             	shl    $0x4,%edx
  803d87:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803d8d:	89 02                	mov    %eax,(%edx)
  803d8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d92:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d9b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803da5:	c1 e0 04             	shl    $0x4,%eax
  803da8:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803dad:	8b 00                	mov    (%eax),%eax
  803daf:	8d 50 ff             	lea    -0x1(%eax),%edx
  803db2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803db5:	c1 e0 04             	shl    $0x4,%eax
  803db8:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803dbd:	89 10                	mov    %edx,(%eax)
			b = next;
  803dbf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803dc2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  803dc5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803dc9:	0f 85 2a ff ff ff    	jne    803cf9 <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  803dcf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803dd2:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  803dd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ddb:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  803de1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803de5:	75 17                	jne    803dfe <free_block+0x2cb>
  803de7:	83 ec 04             	sub    $0x4,%esp
  803dea:	68 0c 4b 80 00       	push   $0x804b0c
  803def:	68 bc 00 00 00       	push   $0xbc
  803df4:	68 03 4a 80 00       	push   $0x804a03
  803df9:	e8 0b c6 ff ff       	call   800409 <_panic>
  803dfe:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803e04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e07:	89 10                	mov    %edx,(%eax)
  803e09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e0c:	8b 00                	mov    (%eax),%eax
  803e0e:	85 c0                	test   %eax,%eax
  803e10:	74 0d                	je     803e1f <free_block+0x2ec>
  803e12:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803e17:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e1a:	89 50 04             	mov    %edx,0x4(%eax)
  803e1d:	eb 08                	jmp    803e27 <free_block+0x2f4>
  803e1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e22:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803e27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e2a:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803e2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e32:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e39:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803e3e:	40                   	inc    %eax
  803e3f:	a3 74 d0 81 00       	mov    %eax,0x81d074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  803e44:	83 ec 0c             	sub    $0xc,%esp
  803e47:	ff 75 ec             	pushl  -0x14(%ebp)
  803e4a:	e8 7e f5 ff ff       	call   8033cd <to_page_va>
  803e4f:	83 c4 10             	add    $0x10,%esp
  803e52:	83 ec 0c             	sub    $0xc,%esp
  803e55:	50                   	push   %eax
  803e56:	e8 fe d7 ff ff       	call   801659 <return_page>
  803e5b:	83 c4 10             	add    $0x10,%esp
	}
}
  803e5e:	90                   	nop
  803e5f:	c9                   	leave  
  803e60:	c3                   	ret    
  803e61:	66 90                	xchg   %ax,%ax
  803e63:	90                   	nop

00803e64 <__udivdi3>:
  803e64:	55                   	push   %ebp
  803e65:	57                   	push   %edi
  803e66:	56                   	push   %esi
  803e67:	53                   	push   %ebx
  803e68:	83 ec 1c             	sub    $0x1c,%esp
  803e6b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803e6f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803e73:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803e77:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803e7b:	89 ca                	mov    %ecx,%edx
  803e7d:	89 f8                	mov    %edi,%eax
  803e7f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803e83:	85 f6                	test   %esi,%esi
  803e85:	75 2d                	jne    803eb4 <__udivdi3+0x50>
  803e87:	39 cf                	cmp    %ecx,%edi
  803e89:	77 65                	ja     803ef0 <__udivdi3+0x8c>
  803e8b:	89 fd                	mov    %edi,%ebp
  803e8d:	85 ff                	test   %edi,%edi
  803e8f:	75 0b                	jne    803e9c <__udivdi3+0x38>
  803e91:	b8 01 00 00 00       	mov    $0x1,%eax
  803e96:	31 d2                	xor    %edx,%edx
  803e98:	f7 f7                	div    %edi
  803e9a:	89 c5                	mov    %eax,%ebp
  803e9c:	31 d2                	xor    %edx,%edx
  803e9e:	89 c8                	mov    %ecx,%eax
  803ea0:	f7 f5                	div    %ebp
  803ea2:	89 c1                	mov    %eax,%ecx
  803ea4:	89 d8                	mov    %ebx,%eax
  803ea6:	f7 f5                	div    %ebp
  803ea8:	89 cf                	mov    %ecx,%edi
  803eaa:	89 fa                	mov    %edi,%edx
  803eac:	83 c4 1c             	add    $0x1c,%esp
  803eaf:	5b                   	pop    %ebx
  803eb0:	5e                   	pop    %esi
  803eb1:	5f                   	pop    %edi
  803eb2:	5d                   	pop    %ebp
  803eb3:	c3                   	ret    
  803eb4:	39 ce                	cmp    %ecx,%esi
  803eb6:	77 28                	ja     803ee0 <__udivdi3+0x7c>
  803eb8:	0f bd fe             	bsr    %esi,%edi
  803ebb:	83 f7 1f             	xor    $0x1f,%edi
  803ebe:	75 40                	jne    803f00 <__udivdi3+0x9c>
  803ec0:	39 ce                	cmp    %ecx,%esi
  803ec2:	72 0a                	jb     803ece <__udivdi3+0x6a>
  803ec4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803ec8:	0f 87 9e 00 00 00    	ja     803f6c <__udivdi3+0x108>
  803ece:	b8 01 00 00 00       	mov    $0x1,%eax
  803ed3:	89 fa                	mov    %edi,%edx
  803ed5:	83 c4 1c             	add    $0x1c,%esp
  803ed8:	5b                   	pop    %ebx
  803ed9:	5e                   	pop    %esi
  803eda:	5f                   	pop    %edi
  803edb:	5d                   	pop    %ebp
  803edc:	c3                   	ret    
  803edd:	8d 76 00             	lea    0x0(%esi),%esi
  803ee0:	31 ff                	xor    %edi,%edi
  803ee2:	31 c0                	xor    %eax,%eax
  803ee4:	89 fa                	mov    %edi,%edx
  803ee6:	83 c4 1c             	add    $0x1c,%esp
  803ee9:	5b                   	pop    %ebx
  803eea:	5e                   	pop    %esi
  803eeb:	5f                   	pop    %edi
  803eec:	5d                   	pop    %ebp
  803eed:	c3                   	ret    
  803eee:	66 90                	xchg   %ax,%ax
  803ef0:	89 d8                	mov    %ebx,%eax
  803ef2:	f7 f7                	div    %edi
  803ef4:	31 ff                	xor    %edi,%edi
  803ef6:	89 fa                	mov    %edi,%edx
  803ef8:	83 c4 1c             	add    $0x1c,%esp
  803efb:	5b                   	pop    %ebx
  803efc:	5e                   	pop    %esi
  803efd:	5f                   	pop    %edi
  803efe:	5d                   	pop    %ebp
  803eff:	c3                   	ret    
  803f00:	bd 20 00 00 00       	mov    $0x20,%ebp
  803f05:	89 eb                	mov    %ebp,%ebx
  803f07:	29 fb                	sub    %edi,%ebx
  803f09:	89 f9                	mov    %edi,%ecx
  803f0b:	d3 e6                	shl    %cl,%esi
  803f0d:	89 c5                	mov    %eax,%ebp
  803f0f:	88 d9                	mov    %bl,%cl
  803f11:	d3 ed                	shr    %cl,%ebp
  803f13:	89 e9                	mov    %ebp,%ecx
  803f15:	09 f1                	or     %esi,%ecx
  803f17:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803f1b:	89 f9                	mov    %edi,%ecx
  803f1d:	d3 e0                	shl    %cl,%eax
  803f1f:	89 c5                	mov    %eax,%ebp
  803f21:	89 d6                	mov    %edx,%esi
  803f23:	88 d9                	mov    %bl,%cl
  803f25:	d3 ee                	shr    %cl,%esi
  803f27:	89 f9                	mov    %edi,%ecx
  803f29:	d3 e2                	shl    %cl,%edx
  803f2b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f2f:	88 d9                	mov    %bl,%cl
  803f31:	d3 e8                	shr    %cl,%eax
  803f33:	09 c2                	or     %eax,%edx
  803f35:	89 d0                	mov    %edx,%eax
  803f37:	89 f2                	mov    %esi,%edx
  803f39:	f7 74 24 0c          	divl   0xc(%esp)
  803f3d:	89 d6                	mov    %edx,%esi
  803f3f:	89 c3                	mov    %eax,%ebx
  803f41:	f7 e5                	mul    %ebp
  803f43:	39 d6                	cmp    %edx,%esi
  803f45:	72 19                	jb     803f60 <__udivdi3+0xfc>
  803f47:	74 0b                	je     803f54 <__udivdi3+0xf0>
  803f49:	89 d8                	mov    %ebx,%eax
  803f4b:	31 ff                	xor    %edi,%edi
  803f4d:	e9 58 ff ff ff       	jmp    803eaa <__udivdi3+0x46>
  803f52:	66 90                	xchg   %ax,%ax
  803f54:	8b 54 24 08          	mov    0x8(%esp),%edx
  803f58:	89 f9                	mov    %edi,%ecx
  803f5a:	d3 e2                	shl    %cl,%edx
  803f5c:	39 c2                	cmp    %eax,%edx
  803f5e:	73 e9                	jae    803f49 <__udivdi3+0xe5>
  803f60:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803f63:	31 ff                	xor    %edi,%edi
  803f65:	e9 40 ff ff ff       	jmp    803eaa <__udivdi3+0x46>
  803f6a:	66 90                	xchg   %ax,%ax
  803f6c:	31 c0                	xor    %eax,%eax
  803f6e:	e9 37 ff ff ff       	jmp    803eaa <__udivdi3+0x46>
  803f73:	90                   	nop

00803f74 <__umoddi3>:
  803f74:	55                   	push   %ebp
  803f75:	57                   	push   %edi
  803f76:	56                   	push   %esi
  803f77:	53                   	push   %ebx
  803f78:	83 ec 1c             	sub    $0x1c,%esp
  803f7b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803f7f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803f83:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803f87:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803f8b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803f8f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803f93:	89 f3                	mov    %esi,%ebx
  803f95:	89 fa                	mov    %edi,%edx
  803f97:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803f9b:	89 34 24             	mov    %esi,(%esp)
  803f9e:	85 c0                	test   %eax,%eax
  803fa0:	75 1a                	jne    803fbc <__umoddi3+0x48>
  803fa2:	39 f7                	cmp    %esi,%edi
  803fa4:	0f 86 a2 00 00 00    	jbe    80404c <__umoddi3+0xd8>
  803faa:	89 c8                	mov    %ecx,%eax
  803fac:	89 f2                	mov    %esi,%edx
  803fae:	f7 f7                	div    %edi
  803fb0:	89 d0                	mov    %edx,%eax
  803fb2:	31 d2                	xor    %edx,%edx
  803fb4:	83 c4 1c             	add    $0x1c,%esp
  803fb7:	5b                   	pop    %ebx
  803fb8:	5e                   	pop    %esi
  803fb9:	5f                   	pop    %edi
  803fba:	5d                   	pop    %ebp
  803fbb:	c3                   	ret    
  803fbc:	39 f0                	cmp    %esi,%eax
  803fbe:	0f 87 ac 00 00 00    	ja     804070 <__umoddi3+0xfc>
  803fc4:	0f bd e8             	bsr    %eax,%ebp
  803fc7:	83 f5 1f             	xor    $0x1f,%ebp
  803fca:	0f 84 ac 00 00 00    	je     80407c <__umoddi3+0x108>
  803fd0:	bf 20 00 00 00       	mov    $0x20,%edi
  803fd5:	29 ef                	sub    %ebp,%edi
  803fd7:	89 fe                	mov    %edi,%esi
  803fd9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803fdd:	89 e9                	mov    %ebp,%ecx
  803fdf:	d3 e0                	shl    %cl,%eax
  803fe1:	89 d7                	mov    %edx,%edi
  803fe3:	89 f1                	mov    %esi,%ecx
  803fe5:	d3 ef                	shr    %cl,%edi
  803fe7:	09 c7                	or     %eax,%edi
  803fe9:	89 e9                	mov    %ebp,%ecx
  803feb:	d3 e2                	shl    %cl,%edx
  803fed:	89 14 24             	mov    %edx,(%esp)
  803ff0:	89 d8                	mov    %ebx,%eax
  803ff2:	d3 e0                	shl    %cl,%eax
  803ff4:	89 c2                	mov    %eax,%edx
  803ff6:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ffa:	d3 e0                	shl    %cl,%eax
  803ffc:	89 44 24 04          	mov    %eax,0x4(%esp)
  804000:	8b 44 24 08          	mov    0x8(%esp),%eax
  804004:	89 f1                	mov    %esi,%ecx
  804006:	d3 e8                	shr    %cl,%eax
  804008:	09 d0                	or     %edx,%eax
  80400a:	d3 eb                	shr    %cl,%ebx
  80400c:	89 da                	mov    %ebx,%edx
  80400e:	f7 f7                	div    %edi
  804010:	89 d3                	mov    %edx,%ebx
  804012:	f7 24 24             	mull   (%esp)
  804015:	89 c6                	mov    %eax,%esi
  804017:	89 d1                	mov    %edx,%ecx
  804019:	39 d3                	cmp    %edx,%ebx
  80401b:	0f 82 87 00 00 00    	jb     8040a8 <__umoddi3+0x134>
  804021:	0f 84 91 00 00 00    	je     8040b8 <__umoddi3+0x144>
  804027:	8b 54 24 04          	mov    0x4(%esp),%edx
  80402b:	29 f2                	sub    %esi,%edx
  80402d:	19 cb                	sbb    %ecx,%ebx
  80402f:	89 d8                	mov    %ebx,%eax
  804031:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804035:	d3 e0                	shl    %cl,%eax
  804037:	89 e9                	mov    %ebp,%ecx
  804039:	d3 ea                	shr    %cl,%edx
  80403b:	09 d0                	or     %edx,%eax
  80403d:	89 e9                	mov    %ebp,%ecx
  80403f:	d3 eb                	shr    %cl,%ebx
  804041:	89 da                	mov    %ebx,%edx
  804043:	83 c4 1c             	add    $0x1c,%esp
  804046:	5b                   	pop    %ebx
  804047:	5e                   	pop    %esi
  804048:	5f                   	pop    %edi
  804049:	5d                   	pop    %ebp
  80404a:	c3                   	ret    
  80404b:	90                   	nop
  80404c:	89 fd                	mov    %edi,%ebp
  80404e:	85 ff                	test   %edi,%edi
  804050:	75 0b                	jne    80405d <__umoddi3+0xe9>
  804052:	b8 01 00 00 00       	mov    $0x1,%eax
  804057:	31 d2                	xor    %edx,%edx
  804059:	f7 f7                	div    %edi
  80405b:	89 c5                	mov    %eax,%ebp
  80405d:	89 f0                	mov    %esi,%eax
  80405f:	31 d2                	xor    %edx,%edx
  804061:	f7 f5                	div    %ebp
  804063:	89 c8                	mov    %ecx,%eax
  804065:	f7 f5                	div    %ebp
  804067:	89 d0                	mov    %edx,%eax
  804069:	e9 44 ff ff ff       	jmp    803fb2 <__umoddi3+0x3e>
  80406e:	66 90                	xchg   %ax,%ax
  804070:	89 c8                	mov    %ecx,%eax
  804072:	89 f2                	mov    %esi,%edx
  804074:	83 c4 1c             	add    $0x1c,%esp
  804077:	5b                   	pop    %ebx
  804078:	5e                   	pop    %esi
  804079:	5f                   	pop    %edi
  80407a:	5d                   	pop    %ebp
  80407b:	c3                   	ret    
  80407c:	3b 04 24             	cmp    (%esp),%eax
  80407f:	72 06                	jb     804087 <__umoddi3+0x113>
  804081:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804085:	77 0f                	ja     804096 <__umoddi3+0x122>
  804087:	89 f2                	mov    %esi,%edx
  804089:	29 f9                	sub    %edi,%ecx
  80408b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80408f:	89 14 24             	mov    %edx,(%esp)
  804092:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804096:	8b 44 24 04          	mov    0x4(%esp),%eax
  80409a:	8b 14 24             	mov    (%esp),%edx
  80409d:	83 c4 1c             	add    $0x1c,%esp
  8040a0:	5b                   	pop    %ebx
  8040a1:	5e                   	pop    %esi
  8040a2:	5f                   	pop    %edi
  8040a3:	5d                   	pop    %ebp
  8040a4:	c3                   	ret    
  8040a5:	8d 76 00             	lea    0x0(%esi),%esi
  8040a8:	2b 04 24             	sub    (%esp),%eax
  8040ab:	19 fa                	sbb    %edi,%edx
  8040ad:	89 d1                	mov    %edx,%ecx
  8040af:	89 c6                	mov    %eax,%esi
  8040b1:	e9 71 ff ff ff       	jmp    804027 <__umoddi3+0xb3>
  8040b6:	66 90                	xchg   %ax,%ax
  8040b8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8040bc:	72 ea                	jb     8040a8 <__umoddi3+0x134>
  8040be:	89 d9                	mov    %ebx,%ecx
  8040c0:	e9 62 ff ff ff       	jmp    804027 <__umoddi3+0xb3>
