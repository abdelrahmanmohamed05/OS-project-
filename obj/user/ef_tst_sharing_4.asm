
obj/user/ef_tst_sharing_4:     file format elf32-i386


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
  800031:	e8 53 06 00 00       	call   800689 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables (create_shared_memory)
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 64             	sub    $0x64,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  80003f:	a1 20 60 80 00       	mov    0x806020,%eax
  800044:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  80004a:	a1 20 60 80 00       	mov    0x806020,%eax
  80004f:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800055:	39 c2                	cmp    %eax,%edx
  800057:	72 14                	jb     80006d <_main+0x35>
			panic("Please increase the WS size");
  800059:	83 ec 04             	sub    $0x4,%esp
  80005c:	68 00 45 80 00       	push   $0x804500
  800061:	6a 0b                	push   $0xb
  800063:	68 1c 45 80 00       	push   $0x80451c
  800068:	e8 cc 07 00 00       	call   800839 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80006d:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)
	uint32 *x, *y, *z ;
	int freeFrames, diff, expected;

	cprintf("************************************************\n");
  800074:	83 ec 0c             	sub    $0xc,%esp
  800077:	68 34 45 80 00       	push   $0x804534
  80007c:	e8 86 0a 00 00       	call   800b07 <cprintf>
  800081:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  800084:	83 ec 0c             	sub    $0xc,%esp
  800087:	68 68 45 80 00       	push   $0x804568
  80008c:	e8 76 0a 00 00       	call   800b07 <cprintf>
  800091:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  800094:	83 ec 0c             	sub    $0xc,%esp
  800097:	68 c4 45 80 00       	push   $0x8045c4
  80009c:	e8 66 0a 00 00       	call   800b07 <cprintf>
  8000a1:	83 c4 10             	add    $0x10,%esp

	int Mega = 1024*1024;
  8000a4:	c7 45 f0 00 00 10 00 	movl   $0x100000,-0x10(%ebp)
	int kilo = 1024;
  8000ab:	c7 45 ec 00 04 00 00 	movl   $0x400,-0x14(%ebp)
	int envID = sys_getenvid();
  8000b2:	e8 6a 34 00 00       	call   803521 <sys_getenvid>
  8000b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	cprintf("STEP A: checking free of a shared object ... [25%]\n");
  8000ba:	83 ec 0c             	sub    $0xc,%esp
  8000bd:	68 f8 45 80 00       	push   $0x8045f8
  8000c2:	e8 40 0a 00 00       	call   800b07 <cprintf>
  8000c7:	83 c4 10             	add    $0x10,%esp
	{
		freeFrames = sys_calculate_free_frames() ;
  8000ca:	e8 a2 32 00 00       	call   803371 <sys_calculate_free_frames>
  8000cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000d2:	83 ec 04             	sub    $0x4,%esp
  8000d5:	6a 01                	push   $0x1
  8000d7:	68 00 10 00 00       	push   $0x1000
  8000dc:	68 2c 46 80 00       	push   $0x80462c
  8000e1:	e8 50 21 00 00       	call   802236 <smalloc>
  8000e6:	83 c4 10             	add    $0x10,%esp
  8000e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (x != (uint32*)pagealloc_start)
  8000ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000ef:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  8000f2:	74 14                	je     800108 <_main+0xd0>
		{panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  8000f4:	83 ec 04             	sub    $0x4,%esp
  8000f7:	68 30 46 80 00       	push   $0x804630
  8000fc:	6a 22                	push   $0x22
  8000fe:	68 1c 45 80 00       	push   $0x80451c
  800103:	e8 31 07 00 00       	call   800839 <_panic>
		expected = 1+1 ; /*1page +1table*/
  800108:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)

		/*extra 1 page & 1 table for kernel sbrk (at max) due to sharedObject & frameStorage*/
		/*extra 1 page & 1 table for user sbrk (at max) if creating special DS to manage USER PAGE ALLOC */
		int upperLimit = expected +1+1 +1+1 ;
  80010f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800112:	83 c0 04             	add    $0x4,%eax
  800115:	89 45 d8             	mov    %eax,-0x28(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800118:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80011b:	e8 51 32 00 00       	call   803371 <sys_calculate_free_frames>
  800120:	29 c3                	sub    %eax,%ebx
  800122:	89 d8                	mov    %ebx,%eax
  800124:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (diff < expected || diff > upperLimit)
  800127:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80012a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80012d:	7c 08                	jl     800137 <_main+0xff>
  80012f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800132:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800135:	7e 24                	jle    80015b <_main+0x123>
			{panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800137:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80013a:	e8 32 32 00 00       	call   803371 <sys_calculate_free_frames>
  80013f:	29 c3                	sub    %eax,%ebx
  800141:	89 d8                	mov    %ebx,%eax
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	ff 75 dc             	pushl  -0x24(%ebp)
  800149:	50                   	push   %eax
  80014a:	68 9c 46 80 00       	push   $0x80469c
  80014f:	6a 2a                	push   $0x2a
  800151:	68 1c 45 80 00       	push   $0x80451c
  800156:	e8 de 06 00 00       	call   800839 <_panic>

		sfree(x);
  80015b:	83 ec 0c             	sub    $0xc,%esp
  80015e:	ff 75 e0             	pushl  -0x20(%ebp)
  800161:	e8 9d 2d 00 00       	call   802f03 <sfree>
  800166:	83 c4 10             	add    $0x10,%esp

		int diff2 = (freeFrames - sys_calculate_free_frames());
  800169:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80016c:	e8 00 32 00 00       	call   803371 <sys_calculate_free_frames>
  800171:	29 c3                	sub    %eax,%ebx
  800173:	89 d8                	mov    %ebx,%eax
  800175:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff2 !=  (diff - expected))
  800178:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80017b:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80017e:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800181:	74 24                	je     8001a7 <_main+0x16f>
		{panic("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  800183:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800186:	e8 e6 31 00 00       	call   803371 <sys_calculate_free_frames>
  80018b:	29 c3                	sub    %eax,%ebx
  80018d:	89 d8                	mov    %ebx,%eax
  80018f:	83 ec 0c             	sub    $0xc,%esp
  800192:	50                   	push   %eax
  800193:	ff 75 dc             	pushl  -0x24(%ebp)
  800196:	68 34 47 80 00       	push   $0x804734
  80019b:	6a 30                	push   $0x30
  80019d:	68 1c 45 80 00       	push   $0x80451c
  8001a2:	e8 92 06 00 00       	call   800839 <_panic>
	}
	cprintf("Step A completed!!\n\n\n");
  8001a7:	83 ec 0c             	sub    $0xc,%esp
  8001aa:	68 7f 47 80 00       	push   $0x80477f
  8001af:	e8 53 09 00 00       	call   800b07 <cprintf>
  8001b4:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking free of 2 shared objects ... [25%]\n");
  8001b7:	83 ec 0c             	sub    $0xc,%esp
  8001ba:	68 98 47 80 00       	push   $0x804798
  8001bf:	e8 43 09 00 00       	call   800b07 <cprintf>
  8001c4:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		freeFrames = sys_calculate_free_frames() ;
  8001c7:	e8 a5 31 00 00       	call   803371 <sys_calculate_free_frames>
  8001cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		z = smalloc("z", PAGE_SIZE, 1);
  8001cf:	83 ec 04             	sub    $0x4,%esp
  8001d2:	6a 01                	push   $0x1
  8001d4:	68 00 10 00 00       	push   $0x1000
  8001d9:	68 cd 47 80 00       	push   $0x8047cd
  8001de:	e8 53 20 00 00       	call   802236 <smalloc>
  8001e3:	83 c4 10             	add    $0x10,%esp
  8001e6:	89 45 cc             	mov    %eax,-0x34(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8001e9:	83 ec 04             	sub    $0x4,%esp
  8001ec:	6a 01                	push   $0x1
  8001ee:	68 00 10 00 00       	push   $0x1000
  8001f3:	68 2c 46 80 00       	push   $0x80462c
  8001f8:	e8 39 20 00 00       	call   802236 <smalloc>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 c8             	mov    %eax,-0x38(%ebp)

		if(x == NULL)
  800203:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800207:	75 14                	jne    80021d <_main+0x1e5>
		{panic("Wrong free: make sure that you free the shared object by calling free_share_object()");}
  800209:	83 ec 04             	sub    $0x4,%esp
  80020c:	68 d0 47 80 00       	push   $0x8047d0
  800211:	6a 3c                	push   $0x3c
  800213:	68 1c 45 80 00       	push   $0x80451c
  800218:	e8 1c 06 00 00       	call   800839 <_panic>

		expected = 2+1 ; /*2pages +1table*/
  80021d:	c7 45 dc 03 00 00 00 	movl   $0x3,-0x24(%ebp)
		/*extra 1 page for kernel sbrk (at max) due to sharedObject & frameStorage of the 2nd object "x"*/
		/*if creating special DS to manage USER PAGE ALLOC, the prev. created page from STEP A is sufficient */
		int upperLimit = expected +1 ;
  800224:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800227:	40                   	inc    %eax
  800228:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80022b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80022e:	e8 3e 31 00 00       	call   803371 <sys_calculate_free_frames>
  800233:	29 c3                	sub    %eax,%ebx
  800235:	89 d8                	mov    %ebx,%eax
  800237:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (diff < expected || diff > upperLimit)
  80023a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80023d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800240:	7c 08                	jl     80024a <_main+0x212>
  800242:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800245:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800248:	7e 14                	jle    80025e <_main+0x226>
			{panic("Wrong previous free: make sure that you correctly free shared object before (Step A)");}
  80024a:	83 ec 04             	sub    $0x4,%esp
  80024d:	68 28 48 80 00       	push   $0x804828
  800252:	6a 44                	push   $0x44
  800254:	68 1c 45 80 00       	push   $0x80451c
  800259:	e8 db 05 00 00       	call   800839 <_panic>

		sfree(z);
  80025e:	83 ec 0c             	sub    $0xc,%esp
  800261:	ff 75 cc             	pushl  -0x34(%ebp)
  800264:	e8 9a 2c 00 00       	call   802f03 <sfree>
  800269:	83 c4 10             	add    $0x10,%esp

		int diff2 = (freeFrames - sys_calculate_free_frames());
  80026c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80026f:	e8 fd 30 00 00       	call   803371 <sys_calculate_free_frames>
  800274:	29 c3                	sub    %eax,%ebx
  800276:	89 d8                	mov    %ebx,%eax
  800278:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if (diff2 != (diff - 1 /*1 page*/))
  80027b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80027e:	48                   	dec    %eax
  80027f:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  800282:	74 24                	je     8002a8 <_main+0x270>
		{panic("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  800284:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800287:	e8 e5 30 00 00       	call   803371 <sys_calculate_free_frames>
  80028c:	29 c3                	sub    %eax,%ebx
  80028e:	89 d8                	mov    %ebx,%eax
  800290:	83 ec 0c             	sub    $0xc,%esp
  800293:	50                   	push   %eax
  800294:	ff 75 dc             	pushl  -0x24(%ebp)
  800297:	68 34 47 80 00       	push   $0x804734
  80029c:	6a 4a                	push   $0x4a
  80029e:	68 1c 45 80 00       	push   $0x80451c
  8002a3:	e8 91 05 00 00       	call   800839 <_panic>

		sfree(x);
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	ff 75 c8             	pushl  -0x38(%ebp)
  8002ae:	e8 50 2c 00 00       	call   802f03 <sfree>
  8002b3:	83 c4 10             	add    $0x10,%esp

		expected = 0;
  8002b6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		int diff3 = (freeFrames - sys_calculate_free_frames());
  8002bd:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8002c0:	e8 ac 30 00 00       	call   803371 <sys_calculate_free_frames>
  8002c5:	29 c3                	sub    %eax,%ebx
  8002c7:	89 d8                	mov    %ebx,%eax
  8002c9:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if (diff3 != (diff2 - (1+1) /*1 page + 1 table*/))
  8002cc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8002cf:	83 e8 02             	sub    $0x2,%eax
  8002d2:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  8002d5:	74 24                	je     8002fb <_main+0x2c3>
		{panic("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  8002d7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8002da:	e8 92 30 00 00       	call   803371 <sys_calculate_free_frames>
  8002df:	29 c3                	sub    %eax,%ebx
  8002e1:	89 d8                	mov    %ebx,%eax
  8002e3:	83 ec 0c             	sub    $0xc,%esp
  8002e6:	50                   	push   %eax
  8002e7:	ff 75 dc             	pushl  -0x24(%ebp)
  8002ea:	68 34 47 80 00       	push   $0x804734
  8002ef:	6a 51                	push   $0x51
  8002f1:	68 1c 45 80 00       	push   $0x80451c
  8002f6:	e8 3e 05 00 00       	call   800839 <_panic>

	}
	cprintf("Step B completed!!\n\n\n");
  8002fb:	83 ec 0c             	sub    $0xc,%esp
  8002fe:	68 7d 48 80 00       	push   $0x80487d
  800303:	e8 ff 07 00 00       	call   800b07 <cprintf>
  800308:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP C: checking range of loop during free... [50%]\n");
  80030b:	83 ec 0c             	sub    $0xc,%esp
  80030e:	68 94 48 80 00       	push   $0x804894
  800313:	e8 ef 07 00 00       	call   800b07 <cprintf>
  800318:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *w, *u;
		int freeFrames = sys_calculate_free_frames() ;
  80031b:	e8 51 30 00 00       	call   803371 <sys_calculate_free_frames>
  800320:	89 45 b8             	mov    %eax,-0x48(%ebp)
		w = smalloc("w", 3 * PAGE_SIZE+1, 1);
  800323:	83 ec 04             	sub    $0x4,%esp
  800326:	6a 01                	push   $0x1
  800328:	68 01 30 00 00       	push   $0x3001
  80032d:	68 c9 48 80 00       	push   $0x8048c9
  800332:	e8 ff 1e 00 00       	call   802236 <smalloc>
  800337:	83 c4 10             	add    $0x10,%esp
  80033a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		u = smalloc("u", PAGE_SIZE, 1);
  80033d:	83 ec 04             	sub    $0x4,%esp
  800340:	6a 01                	push   $0x1
  800342:	68 00 10 00 00       	push   $0x1000
  800347:	68 cb 48 80 00       	push   $0x8048cb
  80034c:	e8 e5 1e 00 00       	call   802236 <smalloc>
  800351:	83 c4 10             	add    $0x10,%esp
  800354:	89 45 b0             	mov    %eax,-0x50(%ebp)
		expected = 5+1 ; /*5pages +1table*/
  800357:	c7 45 dc 06 00 00 00 	movl   $0x6,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80035e:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  800361:	e8 0b 30 00 00       	call   803371 <sys_calculate_free_frames>
  800366:	29 c3                	sub    %eax,%ebx
  800368:	89 d8                	mov    %ebx,%eax
  80036a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (diff != expected)
  80036d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800370:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800373:	74 24                	je     800399 <_main+0x361>
			{panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800375:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  800378:	e8 f4 2f 00 00       	call   803371 <sys_calculate_free_frames>
  80037d:	29 c3                	sub    %eax,%ebx
  80037f:	89 d8                	mov    %ebx,%eax
  800381:	83 ec 0c             	sub    $0xc,%esp
  800384:	ff 75 dc             	pushl  -0x24(%ebp)
  800387:	50                   	push   %eax
  800388:	68 9c 46 80 00       	push   $0x80469c
  80038d:	6a 5f                	push   $0x5f
  80038f:	68 1c 45 80 00       	push   $0x80451c
  800394:	e8 a0 04 00 00       	call   800839 <_panic>

		sfree(w);
  800399:	83 ec 0c             	sub    $0xc,%esp
  80039c:	ff 75 b4             	pushl  -0x4c(%ebp)
  80039f:	e8 5f 2b 00 00       	call   802f03 <sfree>
  8003a4:	83 c4 10             	add    $0x10,%esp

		expected = 1+1 ; /*1page +1table*/
  8003a7:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8003ae:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  8003b1:	e8 bb 2f 00 00       	call   803371 <sys_calculate_free_frames>
  8003b6:	29 c3                	sub    %eax,%ebx
  8003b8:	89 d8                	mov    %ebx,%eax
  8003ba:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (diff != expected) {panic("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  8003bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003c0:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003c3:	74 24                	je     8003e9 <_main+0x3b1>
  8003c5:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  8003c8:	e8 a4 2f 00 00       	call   803371 <sys_calculate_free_frames>
  8003cd:	29 c3                	sub    %eax,%ebx
  8003cf:	89 d8                	mov    %ebx,%eax
  8003d1:	83 ec 0c             	sub    $0xc,%esp
  8003d4:	50                   	push   %eax
  8003d5:	ff 75 dc             	pushl  -0x24(%ebp)
  8003d8:	68 34 47 80 00       	push   $0x804734
  8003dd:	6a 65                	push   $0x65
  8003df:	68 1c 45 80 00       	push   $0x80451c
  8003e4:	e8 50 04 00 00       	call   800839 <_panic>

		uint32 *o;

		o = smalloc("o", 2 * PAGE_SIZE-1,1);
  8003e9:	83 ec 04             	sub    $0x4,%esp
  8003ec:	6a 01                	push   $0x1
  8003ee:	68 ff 1f 00 00       	push   $0x1fff
  8003f3:	68 cd 48 80 00       	push   $0x8048cd
  8003f8:	e8 39 1e 00 00       	call   802236 <smalloc>
  8003fd:	83 c4 10             	add    $0x10,%esp
  800400:	89 45 ac             	mov    %eax,-0x54(%ebp)

		expected = 3+1 ; /*3pages +1table*/
  800403:	c7 45 dc 04 00 00 00 	movl   $0x4,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80040a:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  80040d:	e8 5f 2f 00 00       	call   803371 <sys_calculate_free_frames>
  800412:	29 c3                	sub    %eax,%ebx
  800414:	89 d8                	mov    %ebx,%eax
  800416:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (diff != expected /*Exact! since it's not expected that to invloke sbrk due to the prev. sfree*/)
  800419:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80041c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80041f:	74 24                	je     800445 <_main+0x40d>
			{panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800421:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  800424:	e8 48 2f 00 00       	call   803371 <sys_calculate_free_frames>
  800429:	29 c3                	sub    %eax,%ebx
  80042b:	89 d8                	mov    %ebx,%eax
  80042d:	83 ec 0c             	sub    $0xc,%esp
  800430:	ff 75 dc             	pushl  -0x24(%ebp)
  800433:	50                   	push   %eax
  800434:	68 9c 46 80 00       	push   $0x80469c
  800439:	6a 6e                	push   $0x6e
  80043b:	68 1c 45 80 00       	push   $0x80451c
  800440:	e8 f4 03 00 00       	call   800839 <_panic>

		sfree(o);
  800445:	83 ec 0c             	sub    $0xc,%esp
  800448:	ff 75 ac             	pushl  -0x54(%ebp)
  80044b:	e8 b3 2a 00 00       	call   802f03 <sfree>
  800450:	83 c4 10             	add    $0x10,%esp

		expected = 1+1 ; /*1page +1table*/
  800453:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80045a:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  80045d:	e8 0f 2f 00 00       	call   803371 <sys_calculate_free_frames>
  800462:	29 c3                	sub    %eax,%ebx
  800464:	89 d8                	mov    %ebx,%eax
  800466:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (diff != expected) {panic("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  800469:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80046c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80046f:	74 24                	je     800495 <_main+0x45d>
  800471:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  800474:	e8 f8 2e 00 00       	call   803371 <sys_calculate_free_frames>
  800479:	29 c3                	sub    %eax,%ebx
  80047b:	89 d8                	mov    %ebx,%eax
  80047d:	83 ec 0c             	sub    $0xc,%esp
  800480:	50                   	push   %eax
  800481:	ff 75 dc             	pushl  -0x24(%ebp)
  800484:	68 34 47 80 00       	push   $0x804734
  800489:	6a 74                	push   $0x74
  80048b:	68 1c 45 80 00       	push   $0x80451c
  800490:	e8 a4 03 00 00       	call   800839 <_panic>

		sfree(u);
  800495:	83 ec 0c             	sub    $0xc,%esp
  800498:	ff 75 b0             	pushl  -0x50(%ebp)
  80049b:	e8 63 2a 00 00       	call   802f03 <sfree>
  8004a0:	83 c4 10             	add    $0x10,%esp

		expected = 0;
  8004a3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8004aa:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  8004ad:	e8 bf 2e 00 00       	call   803371 <sys_calculate_free_frames>
  8004b2:	29 c3                	sub    %eax,%ebx
  8004b4:	89 d8                	mov    %ebx,%eax
  8004b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (diff != expected) {panic("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  8004b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004bc:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8004bf:	74 24                	je     8004e5 <_main+0x4ad>
  8004c1:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  8004c4:	e8 a8 2e 00 00       	call   803371 <sys_calculate_free_frames>
  8004c9:	29 c3                	sub    %eax,%ebx
  8004cb:	89 d8                	mov    %ebx,%eax
  8004cd:	83 ec 0c             	sub    $0xc,%esp
  8004d0:	50                   	push   %eax
  8004d1:	ff 75 dc             	pushl  -0x24(%ebp)
  8004d4:	68 34 47 80 00       	push   $0x804734
  8004d9:	6a 7a                	push   $0x7a
  8004db:	68 1c 45 80 00       	push   $0x80451c
  8004e0:	e8 54 03 00 00       	call   800839 <_panic>

		//Checking boundaries of page tables
		freeFrames = sys_calculate_free_frames() ;
  8004e5:	e8 87 2e 00 00       	call   803371 <sys_calculate_free_frames>
  8004ea:	89 45 b8             	mov    %eax,-0x48(%ebp)
		w = smalloc("w", 3 * Mega - 1*kilo, 1);
  8004ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004f0:	89 c2                	mov    %eax,%edx
  8004f2:	01 d2                	add    %edx,%edx
  8004f4:	01 d0                	add    %edx,%eax
  8004f6:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8004f9:	83 ec 04             	sub    $0x4,%esp
  8004fc:	6a 01                	push   $0x1
  8004fe:	50                   	push   %eax
  8004ff:	68 c9 48 80 00       	push   $0x8048c9
  800504:	e8 2d 1d 00 00       	call   802236 <smalloc>
  800509:	83 c4 10             	add    $0x10,%esp
  80050c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		u = smalloc("u", 7 * Mega - 1*kilo, 1);
  80050f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800512:	89 d0                	mov    %edx,%eax
  800514:	01 c0                	add    %eax,%eax
  800516:	01 d0                	add    %edx,%eax
  800518:	01 c0                	add    %eax,%eax
  80051a:	01 d0                	add    %edx,%eax
  80051c:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80051f:	83 ec 04             	sub    $0x4,%esp
  800522:	6a 01                	push   $0x1
  800524:	50                   	push   %eax
  800525:	68 cb 48 80 00       	push   $0x8048cb
  80052a:	e8 07 1d 00 00       	call   802236 <smalloc>
  80052f:	83 c4 10             	add    $0x10,%esp
  800532:	89 45 b0             	mov    %eax,-0x50(%ebp)
		o = smalloc("o", 2 * Mega + 1*kilo, 1);
  800535:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800538:	01 c0                	add    %eax,%eax
  80053a:	89 c2                	mov    %eax,%edx
  80053c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80053f:	01 d0                	add    %edx,%eax
  800541:	83 ec 04             	sub    $0x4,%esp
  800544:	6a 01                	push   $0x1
  800546:	50                   	push   %eax
  800547:	68 cd 48 80 00       	push   $0x8048cd
  80054c:	e8 e5 1c 00 00       	call   802236 <smalloc>
  800551:	83 c4 10             	add    $0x10,%esp
  800554:	89 45 ac             	mov    %eax,-0x54(%ebp)

		expected = 3073+4+4 ; /*3073pages +4tables +4pages for framesStorage by Kernel Page Allocator since it exceed 2KB size*/
  800557:	c7 45 dc 09 0c 00 00 	movl   $0xc09,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80055e:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  800561:	e8 0b 2e 00 00       	call   803371 <sys_calculate_free_frames>
  800566:	29 c3                	sub    %eax,%ebx
  800568:	89 d8                	mov    %ebx,%eax
  80056a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/)
  80056d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800570:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800573:	7c 0b                	jl     800580 <_main+0x548>
  800575:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800578:	83 c0 02             	add    $0x2,%eax
  80057b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80057e:	7d 27                	jge    8005a7 <_main+0x56f>
			{panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800580:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  800583:	e8 e9 2d 00 00       	call   803371 <sys_calculate_free_frames>
  800588:	29 c3                	sub    %eax,%ebx
  80058a:	89 d8                	mov    %ebx,%eax
  80058c:	83 ec 0c             	sub    $0xc,%esp
  80058f:	ff 75 dc             	pushl  -0x24(%ebp)
  800592:	50                   	push   %eax
  800593:	68 9c 46 80 00       	push   $0x80469c
  800598:	68 85 00 00 00       	push   $0x85
  80059d:	68 1c 45 80 00       	push   $0x80451c
  8005a2:	e8 92 02 00 00       	call   800839 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8005a7:	e8 c5 2d 00 00       	call   803371 <sys_calculate_free_frames>
  8005ac:	89 45 b8             	mov    %eax,-0x48(%ebp)

		sfree(o);
  8005af:	83 ec 0c             	sub    $0xc,%esp
  8005b2:	ff 75 ac             	pushl  -0x54(%ebp)
  8005b5:	e8 49 29 00 00       	call   802f03 <sfree>
  8005ba:	83 c4 10             	add    $0x10,%esp
//		if ((freeFrames - sys_calculate_free_frames()) !=  2560+3+5) {panic("Wrong free: check your logic");

		sfree(w);
  8005bd:	83 ec 0c             	sub    $0xc,%esp
  8005c0:	ff 75 b4             	pushl  -0x4c(%ebp)
  8005c3:	e8 3b 29 00 00       	call   802f03 <sfree>
  8005c8:	83 c4 10             	add    $0x10,%esp
//		if ((freeFrames - sys_calculate_free_frames()) !=  1792+3+3) {panic("Wrong free: check your logic");

		sfree(u);
  8005cb:	83 ec 0c             	sub    $0xc,%esp
  8005ce:	ff 75 b0             	pushl  -0x50(%ebp)
  8005d1:	e8 2d 29 00 00       	call   802f03 <sfree>
  8005d6:	83 c4 10             	add    $0x10,%esp

		expected = 3073+4+4;
  8005d9:	c7 45 dc 09 0c 00 00 	movl   $0xc09,-0x24(%ebp)
		diff = (sys_calculate_free_frames() - freeFrames);
  8005e0:	e8 8c 2d 00 00       	call   803371 <sys_calculate_free_frames>
  8005e5:	89 c2                	mov    %eax,%edx
  8005e7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8005ea:	29 c2                	sub    %eax,%edx
  8005ec:	89 d0                	mov    %edx,%eax
  8005ee:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (diff != expected) {panic("Wrong free: revise your freeSharedObject logic. Expected = %d, Actual = %d", expected, (freeFrames - sys_calculate_free_frames()));}
  8005f1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005f4:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005f7:	74 27                	je     800620 <_main+0x5e8>
  8005f9:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  8005fc:	e8 70 2d 00 00       	call   803371 <sys_calculate_free_frames>
  800601:	29 c3                	sub    %eax,%ebx
  800603:	89 d8                	mov    %ebx,%eax
  800605:	83 ec 0c             	sub    $0xc,%esp
  800608:	50                   	push   %eax
  800609:	ff 75 dc             	pushl  -0x24(%ebp)
  80060c:	68 34 47 80 00       	push   $0x804734
  800611:	68 93 00 00 00       	push   $0x93
  800616:	68 1c 45 80 00       	push   $0x80451c
  80061b:	e8 19 02 00 00       	call   800839 <_panic>
	}
	cprintf("Step C completed!!\n\n\n");
  800620:	83 ec 0c             	sub    $0xc,%esp
  800623:	68 cf 48 80 00       	push   $0x8048cf
  800628:	e8 da 04 00 00       	call   800b07 <cprintf>
  80062d:	83 c4 10             	add    $0x10,%esp

	cprintf("Test of freeSharedObjects [4] is finished!!\n\n\n");
  800630:	83 ec 0c             	sub    $0xc,%esp
  800633:	68 e8 48 80 00       	push   $0x8048e8
  800638:	e8 ca 04 00 00       	call   800b07 <cprintf>
  80063d:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800640:	e8 0e 2f 00 00       	call   803553 <sys_getparentenvid>
  800645:	89 45 a8             	mov    %eax,-0x58(%ebp)
	if(parentenvID > 0)
  800648:	83 7d a8 00          	cmpl   $0x0,-0x58(%ebp)
  80064c:	7e 35                	jle    800683 <_main+0x64b>
	{
		//Get the check-finishing counter
		int *finishedCount = NULL;
  80064e:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
		finishedCount = sget(parentenvID, "finishedCount") ;
  800655:	83 ec 08             	sub    $0x8,%esp
  800658:	68 17 49 80 00       	push   $0x804917
  80065d:	ff 75 a8             	pushl  -0x58(%ebp)
  800660:	e8 2b 1f 00 00       	call   802590 <sget>
  800665:	83 c4 10             	add    $0x10,%esp
  800668:	89 45 a4             	mov    %eax,-0x5c(%ebp)

		//Critical section to protect the shared variable
		sys_lock_cons();
  80066b:	e8 51 2c 00 00       	call   8032c1 <sys_lock_cons>
		{
			(*finishedCount)++ ;
  800670:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800673:	8b 00                	mov    (%eax),%eax
  800675:	8d 50 01             	lea    0x1(%eax),%edx
  800678:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80067b:	89 10                	mov    %edx,(%eax)
		}
		sys_unlock_cons();
  80067d:	e8 59 2c 00 00       	call   8032db <sys_unlock_cons>
	}
	return;
  800682:	90                   	nop
  800683:	90                   	nop
}
  800684:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800687:	c9                   	leave  
  800688:	c3                   	ret    

00800689 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800689:	55                   	push   %ebp
  80068a:	89 e5                	mov    %esp,%ebp
  80068c:	57                   	push   %edi
  80068d:	56                   	push   %esi
  80068e:	53                   	push   %ebx
  80068f:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800692:	e8 a3 2e 00 00       	call   80353a <sys_getenvindex>
  800697:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80069a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80069d:	89 d0                	mov    %edx,%eax
  80069f:	c1 e0 03             	shl    $0x3,%eax
  8006a2:	01 d0                	add    %edx,%eax
  8006a4:	c1 e0 02             	shl    $0x2,%eax
  8006a7:	01 d0                	add    %edx,%eax
  8006a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006b0:	01 d0                	add    %edx,%eax
  8006b2:	c1 e0 03             	shl    $0x3,%eax
  8006b5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8006ba:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8006bf:	a1 20 60 80 00       	mov    0x806020,%eax
  8006c4:	8a 40 20             	mov    0x20(%eax),%al
  8006c7:	84 c0                	test   %al,%al
  8006c9:	74 0d                	je     8006d8 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8006cb:	a1 20 60 80 00       	mov    0x806020,%eax
  8006d0:	83 c0 20             	add    $0x20,%eax
  8006d3:	a3 04 60 80 00       	mov    %eax,0x806004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006dc:	7e 0a                	jle    8006e8 <libmain+0x5f>
		binaryname = argv[0];
  8006de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e1:	8b 00                	mov    (%eax),%eax
  8006e3:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	_main(argc, argv);
  8006e8:	83 ec 08             	sub    $0x8,%esp
  8006eb:	ff 75 0c             	pushl  0xc(%ebp)
  8006ee:	ff 75 08             	pushl  0x8(%ebp)
  8006f1:	e8 42 f9 ff ff       	call   800038 <_main>
  8006f6:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8006f9:	a1 00 60 80 00       	mov    0x806000,%eax
  8006fe:	85 c0                	test   %eax,%eax
  800700:	0f 84 01 01 00 00    	je     800807 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800706:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80070c:	bb 20 4a 80 00       	mov    $0x804a20,%ebx
  800711:	ba 0e 00 00 00       	mov    $0xe,%edx
  800716:	89 c7                	mov    %eax,%edi
  800718:	89 de                	mov    %ebx,%esi
  80071a:	89 d1                	mov    %edx,%ecx
  80071c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80071e:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800721:	b9 56 00 00 00       	mov    $0x56,%ecx
  800726:	b0 00                	mov    $0x0,%al
  800728:	89 d7                	mov    %edx,%edi
  80072a:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80072c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800733:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800736:	83 ec 08             	sub    $0x8,%esp
  800739:	50                   	push   %eax
  80073a:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800740:	50                   	push   %eax
  800741:	e8 2a 30 00 00       	call   803770 <sys_utilities>
  800746:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800749:	e8 73 2b 00 00       	call   8032c1 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80074e:	83 ec 0c             	sub    $0xc,%esp
  800751:	68 40 49 80 00       	push   $0x804940
  800756:	e8 ac 03 00 00       	call   800b07 <cprintf>
  80075b:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80075e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800761:	85 c0                	test   %eax,%eax
  800763:	74 18                	je     80077d <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800765:	e8 24 30 00 00       	call   80378e <sys_get_optimal_num_faults>
  80076a:	83 ec 08             	sub    $0x8,%esp
  80076d:	50                   	push   %eax
  80076e:	68 68 49 80 00       	push   $0x804968
  800773:	e8 8f 03 00 00       	call   800b07 <cprintf>
  800778:	83 c4 10             	add    $0x10,%esp
  80077b:	eb 59                	jmp    8007d6 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80077d:	a1 20 60 80 00       	mov    0x806020,%eax
  800782:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  800788:	a1 20 60 80 00       	mov    0x806020,%eax
  80078d:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800793:	83 ec 04             	sub    $0x4,%esp
  800796:	52                   	push   %edx
  800797:	50                   	push   %eax
  800798:	68 8c 49 80 00       	push   $0x80498c
  80079d:	e8 65 03 00 00       	call   800b07 <cprintf>
  8007a2:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8007a5:	a1 20 60 80 00       	mov    0x806020,%eax
  8007aa:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  8007b0:	a1 20 60 80 00       	mov    0x806020,%eax
  8007b5:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  8007bb:	a1 20 60 80 00       	mov    0x806020,%eax
  8007c0:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8007c6:	51                   	push   %ecx
  8007c7:	52                   	push   %edx
  8007c8:	50                   	push   %eax
  8007c9:	68 b4 49 80 00       	push   $0x8049b4
  8007ce:	e8 34 03 00 00       	call   800b07 <cprintf>
  8007d3:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8007d6:	a1 20 60 80 00       	mov    0x806020,%eax
  8007db:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  8007e1:	83 ec 08             	sub    $0x8,%esp
  8007e4:	50                   	push   %eax
  8007e5:	68 0c 4a 80 00       	push   $0x804a0c
  8007ea:	e8 18 03 00 00       	call   800b07 <cprintf>
  8007ef:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8007f2:	83 ec 0c             	sub    $0xc,%esp
  8007f5:	68 40 49 80 00       	push   $0x804940
  8007fa:	e8 08 03 00 00       	call   800b07 <cprintf>
  8007ff:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800802:	e8 d4 2a 00 00       	call   8032db <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800807:	e8 1f 00 00 00       	call   80082b <exit>
}
  80080c:	90                   	nop
  80080d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800810:	5b                   	pop    %ebx
  800811:	5e                   	pop    %esi
  800812:	5f                   	pop    %edi
  800813:	5d                   	pop    %ebp
  800814:	c3                   	ret    

00800815 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800815:	55                   	push   %ebp
  800816:	89 e5                	mov    %esp,%ebp
  800818:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80081b:	83 ec 0c             	sub    $0xc,%esp
  80081e:	6a 00                	push   $0x0
  800820:	e8 e1 2c 00 00       	call   803506 <sys_destroy_env>
  800825:	83 c4 10             	add    $0x10,%esp
}
  800828:	90                   	nop
  800829:	c9                   	leave  
  80082a:	c3                   	ret    

0080082b <exit>:

void
exit(void)
{
  80082b:	55                   	push   %ebp
  80082c:	89 e5                	mov    %esp,%ebp
  80082e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800831:	e8 36 2d 00 00       	call   80356c <sys_exit_env>
}
  800836:	90                   	nop
  800837:	c9                   	leave  
  800838:	c3                   	ret    

00800839 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800839:	55                   	push   %ebp
  80083a:	89 e5                	mov    %esp,%ebp
  80083c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80083f:	8d 45 10             	lea    0x10(%ebp),%eax
  800842:	83 c0 04             	add    $0x4,%eax
  800845:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800848:	a1 38 61 83 00       	mov    0x836138,%eax
  80084d:	85 c0                	test   %eax,%eax
  80084f:	74 16                	je     800867 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800851:	a1 38 61 83 00       	mov    0x836138,%eax
  800856:	83 ec 08             	sub    $0x8,%esp
  800859:	50                   	push   %eax
  80085a:	68 84 4a 80 00       	push   $0x804a84
  80085f:	e8 a3 02 00 00       	call   800b07 <cprintf>
  800864:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800867:	a1 04 60 80 00       	mov    0x806004,%eax
  80086c:	83 ec 0c             	sub    $0xc,%esp
  80086f:	ff 75 0c             	pushl  0xc(%ebp)
  800872:	ff 75 08             	pushl  0x8(%ebp)
  800875:	50                   	push   %eax
  800876:	68 8c 4a 80 00       	push   $0x804a8c
  80087b:	6a 74                	push   $0x74
  80087d:	e8 b2 02 00 00       	call   800b34 <cprintf_colored>
  800882:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800885:	8b 45 10             	mov    0x10(%ebp),%eax
  800888:	83 ec 08             	sub    $0x8,%esp
  80088b:	ff 75 f4             	pushl  -0xc(%ebp)
  80088e:	50                   	push   %eax
  80088f:	e8 04 02 00 00       	call   800a98 <vcprintf>
  800894:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800897:	83 ec 08             	sub    $0x8,%esp
  80089a:	6a 00                	push   $0x0
  80089c:	68 b4 4a 80 00       	push   $0x804ab4
  8008a1:	e8 f2 01 00 00       	call   800a98 <vcprintf>
  8008a6:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8008a9:	e8 7d ff ff ff       	call   80082b <exit>

	// should not return here
	while (1) ;
  8008ae:	eb fe                	jmp    8008ae <_panic+0x75>

008008b0 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8008b0:	55                   	push   %ebp
  8008b1:	89 e5                	mov    %esp,%ebp
  8008b3:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8008b6:	a1 20 60 80 00       	mov    0x806020,%eax
  8008bb:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8008c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c4:	39 c2                	cmp    %eax,%edx
  8008c6:	74 14                	je     8008dc <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8008c8:	83 ec 04             	sub    $0x4,%esp
  8008cb:	68 b8 4a 80 00       	push   $0x804ab8
  8008d0:	6a 26                	push   $0x26
  8008d2:	68 04 4b 80 00       	push   $0x804b04
  8008d7:	e8 5d ff ff ff       	call   800839 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8008dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8008e3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008ea:	e9 c5 00 00 00       	jmp    8009b4 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8008ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008f2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8008f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fc:	01 d0                	add    %edx,%eax
  8008fe:	8b 00                	mov    (%eax),%eax
  800900:	85 c0                	test   %eax,%eax
  800902:	75 08                	jne    80090c <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800904:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800907:	e9 a5 00 00 00       	jmp    8009b1 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80090c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800913:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80091a:	eb 69                	jmp    800985 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80091c:	a1 20 60 80 00       	mov    0x806020,%eax
  800921:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800927:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80092a:	89 d0                	mov    %edx,%eax
  80092c:	01 c0                	add    %eax,%eax
  80092e:	01 d0                	add    %edx,%eax
  800930:	c1 e0 03             	shl    $0x3,%eax
  800933:	01 c8                	add    %ecx,%eax
  800935:	8a 40 04             	mov    0x4(%eax),%al
  800938:	84 c0                	test   %al,%al
  80093a:	75 46                	jne    800982 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80093c:	a1 20 60 80 00       	mov    0x806020,%eax
  800941:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800947:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80094a:	89 d0                	mov    %edx,%eax
  80094c:	01 c0                	add    %eax,%eax
  80094e:	01 d0                	add    %edx,%eax
  800950:	c1 e0 03             	shl    $0x3,%eax
  800953:	01 c8                	add    %ecx,%eax
  800955:	8b 00                	mov    (%eax),%eax
  800957:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80095a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80095d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800962:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800964:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800967:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80096e:	8b 45 08             	mov    0x8(%ebp),%eax
  800971:	01 c8                	add    %ecx,%eax
  800973:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800975:	39 c2                	cmp    %eax,%edx
  800977:	75 09                	jne    800982 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800979:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800980:	eb 15                	jmp    800997 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800982:	ff 45 e8             	incl   -0x18(%ebp)
  800985:	a1 20 60 80 00       	mov    0x806020,%eax
  80098a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800990:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800993:	39 c2                	cmp    %eax,%edx
  800995:	77 85                	ja     80091c <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800997:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80099b:	75 14                	jne    8009b1 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80099d:	83 ec 04             	sub    $0x4,%esp
  8009a0:	68 10 4b 80 00       	push   $0x804b10
  8009a5:	6a 3a                	push   $0x3a
  8009a7:	68 04 4b 80 00       	push   $0x804b04
  8009ac:	e8 88 fe ff ff       	call   800839 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8009b1:	ff 45 f0             	incl   -0x10(%ebp)
  8009b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8009ba:	0f 8c 2f ff ff ff    	jl     8008ef <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8009c0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009c7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8009ce:	eb 26                	jmp    8009f6 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8009d0:	a1 20 60 80 00       	mov    0x806020,%eax
  8009d5:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8009db:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009de:	89 d0                	mov    %edx,%eax
  8009e0:	01 c0                	add    %eax,%eax
  8009e2:	01 d0                	add    %edx,%eax
  8009e4:	c1 e0 03             	shl    $0x3,%eax
  8009e7:	01 c8                	add    %ecx,%eax
  8009e9:	8a 40 04             	mov    0x4(%eax),%al
  8009ec:	3c 01                	cmp    $0x1,%al
  8009ee:	75 03                	jne    8009f3 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8009f0:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009f3:	ff 45 e0             	incl   -0x20(%ebp)
  8009f6:	a1 20 60 80 00       	mov    0x806020,%eax
  8009fb:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800a01:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a04:	39 c2                	cmp    %eax,%edx
  800a06:	77 c8                	ja     8009d0 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a0b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800a0e:	74 14                	je     800a24 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800a10:	83 ec 04             	sub    $0x4,%esp
  800a13:	68 64 4b 80 00       	push   $0x804b64
  800a18:	6a 44                	push   $0x44
  800a1a:	68 04 4b 80 00       	push   $0x804b04
  800a1f:	e8 15 fe ff ff       	call   800839 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800a24:	90                   	nop
  800a25:	c9                   	leave  
  800a26:	c3                   	ret    

00800a27 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800a27:	55                   	push   %ebp
  800a28:	89 e5                	mov    %esp,%ebp
  800a2a:	53                   	push   %ebx
  800a2b:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800a2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a31:	8b 00                	mov    (%eax),%eax
  800a33:	8d 48 01             	lea    0x1(%eax),%ecx
  800a36:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a39:	89 0a                	mov    %ecx,(%edx)
  800a3b:	8b 55 08             	mov    0x8(%ebp),%edx
  800a3e:	88 d1                	mov    %dl,%cl
  800a40:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a43:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800a47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4a:	8b 00                	mov    (%eax),%eax
  800a4c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a51:	75 30                	jne    800a83 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800a53:	8b 15 3c 61 83 00    	mov    0x83613c,%edx
  800a59:	a0 64 e0 81 00       	mov    0x81e064,%al
  800a5e:	0f b6 c0             	movzbl %al,%eax
  800a61:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a64:	8b 09                	mov    (%ecx),%ecx
  800a66:	89 cb                	mov    %ecx,%ebx
  800a68:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a6b:	83 c1 08             	add    $0x8,%ecx
  800a6e:	52                   	push   %edx
  800a6f:	50                   	push   %eax
  800a70:	53                   	push   %ebx
  800a71:	51                   	push   %ecx
  800a72:	e8 06 28 00 00       	call   80327d <sys_cputs>
  800a77:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800a7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800a83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a86:	8b 40 04             	mov    0x4(%eax),%eax
  800a89:	8d 50 01             	lea    0x1(%eax),%edx
  800a8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a92:	90                   	nop
  800a93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a96:	c9                   	leave  
  800a97:	c3                   	ret    

00800a98 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a98:	55                   	push   %ebp
  800a99:	89 e5                	mov    %esp,%ebp
  800a9b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800aa1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800aa8:	00 00 00 
	b.cnt = 0;
  800aab:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800ab2:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800ab5:	ff 75 0c             	pushl  0xc(%ebp)
  800ab8:	ff 75 08             	pushl  0x8(%ebp)
  800abb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ac1:	50                   	push   %eax
  800ac2:	68 27 0a 80 00       	push   $0x800a27
  800ac7:	e8 5a 02 00 00       	call   800d26 <vprintfmt>
  800acc:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800acf:	8b 15 3c 61 83 00    	mov    0x83613c,%edx
  800ad5:	a0 64 e0 81 00       	mov    0x81e064,%al
  800ada:	0f b6 c0             	movzbl %al,%eax
  800add:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800ae3:	52                   	push   %edx
  800ae4:	50                   	push   %eax
  800ae5:	51                   	push   %ecx
  800ae6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800aec:	83 c0 08             	add    $0x8,%eax
  800aef:	50                   	push   %eax
  800af0:	e8 88 27 00 00       	call   80327d <sys_cputs>
  800af5:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800af8:	c6 05 64 e0 81 00 00 	movb   $0x0,0x81e064
	return b.cnt;
  800aff:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800b05:	c9                   	leave  
  800b06:	c3                   	ret    

00800b07 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800b07:	55                   	push   %ebp
  800b08:	89 e5                	mov    %esp,%ebp
  800b0a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b0d:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
	va_start(ap, fmt);
  800b14:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b17:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1d:	83 ec 08             	sub    $0x8,%esp
  800b20:	ff 75 f4             	pushl  -0xc(%ebp)
  800b23:	50                   	push   %eax
  800b24:	e8 6f ff ff ff       	call   800a98 <vcprintf>
  800b29:	83 c4 10             	add    $0x10,%esp
  800b2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800b2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b32:	c9                   	leave  
  800b33:	c3                   	ret    

00800b34 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800b34:	55                   	push   %ebp
  800b35:	89 e5                	mov    %esp,%ebp
  800b37:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b3a:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
	curTextClr = (textClr << 8) ; //set text color by the given value
  800b41:	8b 45 08             	mov    0x8(%ebp),%eax
  800b44:	c1 e0 08             	shl    $0x8,%eax
  800b47:	a3 3c 61 83 00       	mov    %eax,0x83613c
	va_start(ap, fmt);
  800b4c:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b4f:	83 c0 04             	add    $0x4,%eax
  800b52:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b58:	83 ec 08             	sub    $0x8,%esp
  800b5b:	ff 75 f4             	pushl  -0xc(%ebp)
  800b5e:	50                   	push   %eax
  800b5f:	e8 34 ff ff ff       	call   800a98 <vcprintf>
  800b64:	83 c4 10             	add    $0x10,%esp
  800b67:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800b6a:	c7 05 3c 61 83 00 00 	movl   $0x700,0x83613c
  800b71:	07 00 00 

	return cnt;
  800b74:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b77:	c9                   	leave  
  800b78:	c3                   	ret    

00800b79 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800b79:	55                   	push   %ebp
  800b7a:	89 e5                	mov    %esp,%ebp
  800b7c:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800b7f:	e8 3d 27 00 00       	call   8032c1 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800b84:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b87:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8d:	83 ec 08             	sub    $0x8,%esp
  800b90:	ff 75 f4             	pushl  -0xc(%ebp)
  800b93:	50                   	push   %eax
  800b94:	e8 ff fe ff ff       	call   800a98 <vcprintf>
  800b99:	83 c4 10             	add    $0x10,%esp
  800b9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800b9f:	e8 37 27 00 00       	call   8032db <sys_unlock_cons>
	return cnt;
  800ba4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ba7:	c9                   	leave  
  800ba8:	c3                   	ret    

00800ba9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800ba9:	55                   	push   %ebp
  800baa:	89 e5                	mov    %esp,%ebp
  800bac:	53                   	push   %ebx
  800bad:	83 ec 14             	sub    $0x14,%esp
  800bb0:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb6:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800bbc:	8b 45 18             	mov    0x18(%ebp),%eax
  800bbf:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bc7:	77 55                	ja     800c1e <printnum+0x75>
  800bc9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bcc:	72 05                	jb     800bd3 <printnum+0x2a>
  800bce:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800bd1:	77 4b                	ja     800c1e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800bd3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800bd6:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800bd9:	8b 45 18             	mov    0x18(%ebp),%eax
  800bdc:	ba 00 00 00 00       	mov    $0x0,%edx
  800be1:	52                   	push   %edx
  800be2:	50                   	push   %eax
  800be3:	ff 75 f4             	pushl  -0xc(%ebp)
  800be6:	ff 75 f0             	pushl  -0x10(%ebp)
  800be9:	e8 a6 36 00 00       	call   804294 <__udivdi3>
  800bee:	83 c4 10             	add    $0x10,%esp
  800bf1:	83 ec 04             	sub    $0x4,%esp
  800bf4:	ff 75 20             	pushl  0x20(%ebp)
  800bf7:	53                   	push   %ebx
  800bf8:	ff 75 18             	pushl  0x18(%ebp)
  800bfb:	52                   	push   %edx
  800bfc:	50                   	push   %eax
  800bfd:	ff 75 0c             	pushl  0xc(%ebp)
  800c00:	ff 75 08             	pushl  0x8(%ebp)
  800c03:	e8 a1 ff ff ff       	call   800ba9 <printnum>
  800c08:	83 c4 20             	add    $0x20,%esp
  800c0b:	eb 1a                	jmp    800c27 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c0d:	83 ec 08             	sub    $0x8,%esp
  800c10:	ff 75 0c             	pushl  0xc(%ebp)
  800c13:	ff 75 20             	pushl  0x20(%ebp)
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
  800c19:	ff d0                	call   *%eax
  800c1b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c1e:	ff 4d 1c             	decl   0x1c(%ebp)
  800c21:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c25:	7f e6                	jg     800c0d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c27:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c2a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c35:	53                   	push   %ebx
  800c36:	51                   	push   %ecx
  800c37:	52                   	push   %edx
  800c38:	50                   	push   %eax
  800c39:	e8 66 37 00 00       	call   8043a4 <__umoddi3>
  800c3e:	83 c4 10             	add    $0x10,%esp
  800c41:	05 d4 4d 80 00       	add    $0x804dd4,%eax
  800c46:	8a 00                	mov    (%eax),%al
  800c48:	0f be c0             	movsbl %al,%eax
  800c4b:	83 ec 08             	sub    $0x8,%esp
  800c4e:	ff 75 0c             	pushl  0xc(%ebp)
  800c51:	50                   	push   %eax
  800c52:	8b 45 08             	mov    0x8(%ebp),%eax
  800c55:	ff d0                	call   *%eax
  800c57:	83 c4 10             	add    $0x10,%esp
}
  800c5a:	90                   	nop
  800c5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c5e:	c9                   	leave  
  800c5f:	c3                   	ret    

00800c60 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c60:	55                   	push   %ebp
  800c61:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c63:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c67:	7e 1c                	jle    800c85 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800c69:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6c:	8b 00                	mov    (%eax),%eax
  800c6e:	8d 50 08             	lea    0x8(%eax),%edx
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	89 10                	mov    %edx,(%eax)
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	8b 00                	mov    (%eax),%eax
  800c7b:	83 e8 08             	sub    $0x8,%eax
  800c7e:	8b 50 04             	mov    0x4(%eax),%edx
  800c81:	8b 00                	mov    (%eax),%eax
  800c83:	eb 40                	jmp    800cc5 <getuint+0x65>
	else if (lflag)
  800c85:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c89:	74 1e                	je     800ca9 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8e:	8b 00                	mov    (%eax),%eax
  800c90:	8d 50 04             	lea    0x4(%eax),%edx
  800c93:	8b 45 08             	mov    0x8(%ebp),%eax
  800c96:	89 10                	mov    %edx,(%eax)
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	8b 00                	mov    (%eax),%eax
  800c9d:	83 e8 04             	sub    $0x4,%eax
  800ca0:	8b 00                	mov    (%eax),%eax
  800ca2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca7:	eb 1c                	jmp    800cc5 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cac:	8b 00                	mov    (%eax),%eax
  800cae:	8d 50 04             	lea    0x4(%eax),%edx
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	89 10                	mov    %edx,(%eax)
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	8b 00                	mov    (%eax),%eax
  800cbb:	83 e8 04             	sub    $0x4,%eax
  800cbe:	8b 00                	mov    (%eax),%eax
  800cc0:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800cc5:	5d                   	pop    %ebp
  800cc6:	c3                   	ret    

00800cc7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800cc7:	55                   	push   %ebp
  800cc8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800cca:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cce:	7e 1c                	jle    800cec <getint+0x25>
		return va_arg(*ap, long long);
  800cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd3:	8b 00                	mov    (%eax),%eax
  800cd5:	8d 50 08             	lea    0x8(%eax),%edx
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdb:	89 10                	mov    %edx,(%eax)
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	8b 00                	mov    (%eax),%eax
  800ce2:	83 e8 08             	sub    $0x8,%eax
  800ce5:	8b 50 04             	mov    0x4(%eax),%edx
  800ce8:	8b 00                	mov    (%eax),%eax
  800cea:	eb 38                	jmp    800d24 <getint+0x5d>
	else if (lflag)
  800cec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf0:	74 1a                	je     800d0c <getint+0x45>
		return va_arg(*ap, long);
  800cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf5:	8b 00                	mov    (%eax),%eax
  800cf7:	8d 50 04             	lea    0x4(%eax),%edx
  800cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfd:	89 10                	mov    %edx,(%eax)
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	8b 00                	mov    (%eax),%eax
  800d04:	83 e8 04             	sub    $0x4,%eax
  800d07:	8b 00                	mov    (%eax),%eax
  800d09:	99                   	cltd   
  800d0a:	eb 18                	jmp    800d24 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	8b 00                	mov    (%eax),%eax
  800d11:	8d 50 04             	lea    0x4(%eax),%edx
  800d14:	8b 45 08             	mov    0x8(%ebp),%eax
  800d17:	89 10                	mov    %edx,(%eax)
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	8b 00                	mov    (%eax),%eax
  800d1e:	83 e8 04             	sub    $0x4,%eax
  800d21:	8b 00                	mov    (%eax),%eax
  800d23:	99                   	cltd   
}
  800d24:	5d                   	pop    %ebp
  800d25:	c3                   	ret    

00800d26 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
  800d29:	56                   	push   %esi
  800d2a:	53                   	push   %ebx
  800d2b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d2e:	eb 17                	jmp    800d47 <vprintfmt+0x21>
			if (ch == '\0')
  800d30:	85 db                	test   %ebx,%ebx
  800d32:	0f 84 c1 03 00 00    	je     8010f9 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800d38:	83 ec 08             	sub    $0x8,%esp
  800d3b:	ff 75 0c             	pushl  0xc(%ebp)
  800d3e:	53                   	push   %ebx
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	ff d0                	call   *%eax
  800d44:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d47:	8b 45 10             	mov    0x10(%ebp),%eax
  800d4a:	8d 50 01             	lea    0x1(%eax),%edx
  800d4d:	89 55 10             	mov    %edx,0x10(%ebp)
  800d50:	8a 00                	mov    (%eax),%al
  800d52:	0f b6 d8             	movzbl %al,%ebx
  800d55:	83 fb 25             	cmp    $0x25,%ebx
  800d58:	75 d6                	jne    800d30 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d5a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d5e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800d65:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800d6c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800d73:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d7a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7d:	8d 50 01             	lea    0x1(%eax),%edx
  800d80:	89 55 10             	mov    %edx,0x10(%ebp)
  800d83:	8a 00                	mov    (%eax),%al
  800d85:	0f b6 d8             	movzbl %al,%ebx
  800d88:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d8b:	83 f8 5b             	cmp    $0x5b,%eax
  800d8e:	0f 87 3d 03 00 00    	ja     8010d1 <vprintfmt+0x3ab>
  800d94:	8b 04 85 f8 4d 80 00 	mov    0x804df8(,%eax,4),%eax
  800d9b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800d9d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800da1:	eb d7                	jmp    800d7a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800da3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800da7:	eb d1                	jmp    800d7a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800da9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800db0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800db3:	89 d0                	mov    %edx,%eax
  800db5:	c1 e0 02             	shl    $0x2,%eax
  800db8:	01 d0                	add    %edx,%eax
  800dba:	01 c0                	add    %eax,%eax
  800dbc:	01 d8                	add    %ebx,%eax
  800dbe:	83 e8 30             	sub    $0x30,%eax
  800dc1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800dc4:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc7:	8a 00                	mov    (%eax),%al
  800dc9:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800dcc:	83 fb 2f             	cmp    $0x2f,%ebx
  800dcf:	7e 3e                	jle    800e0f <vprintfmt+0xe9>
  800dd1:	83 fb 39             	cmp    $0x39,%ebx
  800dd4:	7f 39                	jg     800e0f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800dd6:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800dd9:	eb d5                	jmp    800db0 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ddb:	8b 45 14             	mov    0x14(%ebp),%eax
  800dde:	83 c0 04             	add    $0x4,%eax
  800de1:	89 45 14             	mov    %eax,0x14(%ebp)
  800de4:	8b 45 14             	mov    0x14(%ebp),%eax
  800de7:	83 e8 04             	sub    $0x4,%eax
  800dea:	8b 00                	mov    (%eax),%eax
  800dec:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800def:	eb 1f                	jmp    800e10 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800df1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800df5:	79 83                	jns    800d7a <vprintfmt+0x54>
				width = 0;
  800df7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800dfe:	e9 77 ff ff ff       	jmp    800d7a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e03:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e0a:	e9 6b ff ff ff       	jmp    800d7a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e0f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e10:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e14:	0f 89 60 ff ff ff    	jns    800d7a <vprintfmt+0x54>
				width = precision, precision = -1;
  800e1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e1d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e20:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e27:	e9 4e ff ff ff       	jmp    800d7a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e2c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e2f:	e9 46 ff ff ff       	jmp    800d7a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e34:	8b 45 14             	mov    0x14(%ebp),%eax
  800e37:	83 c0 04             	add    $0x4,%eax
  800e3a:	89 45 14             	mov    %eax,0x14(%ebp)
  800e3d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e40:	83 e8 04             	sub    $0x4,%eax
  800e43:	8b 00                	mov    (%eax),%eax
  800e45:	83 ec 08             	sub    $0x8,%esp
  800e48:	ff 75 0c             	pushl  0xc(%ebp)
  800e4b:	50                   	push   %eax
  800e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4f:	ff d0                	call   *%eax
  800e51:	83 c4 10             	add    $0x10,%esp
			break;
  800e54:	e9 9b 02 00 00       	jmp    8010f4 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e59:	8b 45 14             	mov    0x14(%ebp),%eax
  800e5c:	83 c0 04             	add    $0x4,%eax
  800e5f:	89 45 14             	mov    %eax,0x14(%ebp)
  800e62:	8b 45 14             	mov    0x14(%ebp),%eax
  800e65:	83 e8 04             	sub    $0x4,%eax
  800e68:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800e6a:	85 db                	test   %ebx,%ebx
  800e6c:	79 02                	jns    800e70 <vprintfmt+0x14a>
				err = -err;
  800e6e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800e70:	83 fb 64             	cmp    $0x64,%ebx
  800e73:	7f 0b                	jg     800e80 <vprintfmt+0x15a>
  800e75:	8b 34 9d 40 4c 80 00 	mov    0x804c40(,%ebx,4),%esi
  800e7c:	85 f6                	test   %esi,%esi
  800e7e:	75 19                	jne    800e99 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e80:	53                   	push   %ebx
  800e81:	68 e5 4d 80 00       	push   $0x804de5
  800e86:	ff 75 0c             	pushl  0xc(%ebp)
  800e89:	ff 75 08             	pushl  0x8(%ebp)
  800e8c:	e8 70 02 00 00       	call   801101 <printfmt>
  800e91:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e94:	e9 5b 02 00 00       	jmp    8010f4 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e99:	56                   	push   %esi
  800e9a:	68 ee 4d 80 00       	push   $0x804dee
  800e9f:	ff 75 0c             	pushl  0xc(%ebp)
  800ea2:	ff 75 08             	pushl  0x8(%ebp)
  800ea5:	e8 57 02 00 00       	call   801101 <printfmt>
  800eaa:	83 c4 10             	add    $0x10,%esp
			break;
  800ead:	e9 42 02 00 00       	jmp    8010f4 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800eb2:	8b 45 14             	mov    0x14(%ebp),%eax
  800eb5:	83 c0 04             	add    $0x4,%eax
  800eb8:	89 45 14             	mov    %eax,0x14(%ebp)
  800ebb:	8b 45 14             	mov    0x14(%ebp),%eax
  800ebe:	83 e8 04             	sub    $0x4,%eax
  800ec1:	8b 30                	mov    (%eax),%esi
  800ec3:	85 f6                	test   %esi,%esi
  800ec5:	75 05                	jne    800ecc <vprintfmt+0x1a6>
				p = "(null)";
  800ec7:	be f1 4d 80 00       	mov    $0x804df1,%esi
			if (width > 0 && padc != '-')
  800ecc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ed0:	7e 6d                	jle    800f3f <vprintfmt+0x219>
  800ed2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ed6:	74 67                	je     800f3f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ed8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800edb:	83 ec 08             	sub    $0x8,%esp
  800ede:	50                   	push   %eax
  800edf:	56                   	push   %esi
  800ee0:	e8 1e 03 00 00       	call   801203 <strnlen>
  800ee5:	83 c4 10             	add    $0x10,%esp
  800ee8:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800eeb:	eb 16                	jmp    800f03 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800eed:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ef1:	83 ec 08             	sub    $0x8,%esp
  800ef4:	ff 75 0c             	pushl  0xc(%ebp)
  800ef7:	50                   	push   %eax
  800ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  800efb:	ff d0                	call   *%eax
  800efd:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f00:	ff 4d e4             	decl   -0x1c(%ebp)
  800f03:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f07:	7f e4                	jg     800eed <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f09:	eb 34                	jmp    800f3f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f0b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f0f:	74 1c                	je     800f2d <vprintfmt+0x207>
  800f11:	83 fb 1f             	cmp    $0x1f,%ebx
  800f14:	7e 05                	jle    800f1b <vprintfmt+0x1f5>
  800f16:	83 fb 7e             	cmp    $0x7e,%ebx
  800f19:	7e 12                	jle    800f2d <vprintfmt+0x207>
					putch('?', putdat);
  800f1b:	83 ec 08             	sub    $0x8,%esp
  800f1e:	ff 75 0c             	pushl  0xc(%ebp)
  800f21:	6a 3f                	push   $0x3f
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	ff d0                	call   *%eax
  800f28:	83 c4 10             	add    $0x10,%esp
  800f2b:	eb 0f                	jmp    800f3c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f2d:	83 ec 08             	sub    $0x8,%esp
  800f30:	ff 75 0c             	pushl  0xc(%ebp)
  800f33:	53                   	push   %ebx
  800f34:	8b 45 08             	mov    0x8(%ebp),%eax
  800f37:	ff d0                	call   *%eax
  800f39:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f3c:	ff 4d e4             	decl   -0x1c(%ebp)
  800f3f:	89 f0                	mov    %esi,%eax
  800f41:	8d 70 01             	lea    0x1(%eax),%esi
  800f44:	8a 00                	mov    (%eax),%al
  800f46:	0f be d8             	movsbl %al,%ebx
  800f49:	85 db                	test   %ebx,%ebx
  800f4b:	74 24                	je     800f71 <vprintfmt+0x24b>
  800f4d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f51:	78 b8                	js     800f0b <vprintfmt+0x1e5>
  800f53:	ff 4d e0             	decl   -0x20(%ebp)
  800f56:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f5a:	79 af                	jns    800f0b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f5c:	eb 13                	jmp    800f71 <vprintfmt+0x24b>
				putch(' ', putdat);
  800f5e:	83 ec 08             	sub    $0x8,%esp
  800f61:	ff 75 0c             	pushl  0xc(%ebp)
  800f64:	6a 20                	push   $0x20
  800f66:	8b 45 08             	mov    0x8(%ebp),%eax
  800f69:	ff d0                	call   *%eax
  800f6b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f6e:	ff 4d e4             	decl   -0x1c(%ebp)
  800f71:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f75:	7f e7                	jg     800f5e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800f77:	e9 78 01 00 00       	jmp    8010f4 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f7c:	83 ec 08             	sub    $0x8,%esp
  800f7f:	ff 75 e8             	pushl  -0x18(%ebp)
  800f82:	8d 45 14             	lea    0x14(%ebp),%eax
  800f85:	50                   	push   %eax
  800f86:	e8 3c fd ff ff       	call   800cc7 <getint>
  800f8b:	83 c4 10             	add    $0x10,%esp
  800f8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f91:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f97:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f9a:	85 d2                	test   %edx,%edx
  800f9c:	79 23                	jns    800fc1 <vprintfmt+0x29b>
				putch('-', putdat);
  800f9e:	83 ec 08             	sub    $0x8,%esp
  800fa1:	ff 75 0c             	pushl  0xc(%ebp)
  800fa4:	6a 2d                	push   $0x2d
  800fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa9:	ff d0                	call   *%eax
  800fab:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800fae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fb1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fb4:	f7 d8                	neg    %eax
  800fb6:	83 d2 00             	adc    $0x0,%edx
  800fb9:	f7 da                	neg    %edx
  800fbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fbe:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800fc1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800fc8:	e9 bc 00 00 00       	jmp    801089 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800fcd:	83 ec 08             	sub    $0x8,%esp
  800fd0:	ff 75 e8             	pushl  -0x18(%ebp)
  800fd3:	8d 45 14             	lea    0x14(%ebp),%eax
  800fd6:	50                   	push   %eax
  800fd7:	e8 84 fc ff ff       	call   800c60 <getuint>
  800fdc:	83 c4 10             	add    $0x10,%esp
  800fdf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fe2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800fe5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800fec:	e9 98 00 00 00       	jmp    801089 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ff1:	83 ec 08             	sub    $0x8,%esp
  800ff4:	ff 75 0c             	pushl  0xc(%ebp)
  800ff7:	6a 58                	push   $0x58
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	ff d0                	call   *%eax
  800ffe:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801001:	83 ec 08             	sub    $0x8,%esp
  801004:	ff 75 0c             	pushl  0xc(%ebp)
  801007:	6a 58                	push   $0x58
  801009:	8b 45 08             	mov    0x8(%ebp),%eax
  80100c:	ff d0                	call   *%eax
  80100e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801011:	83 ec 08             	sub    $0x8,%esp
  801014:	ff 75 0c             	pushl  0xc(%ebp)
  801017:	6a 58                	push   $0x58
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	ff d0                	call   *%eax
  80101e:	83 c4 10             	add    $0x10,%esp
			break;
  801021:	e9 ce 00 00 00       	jmp    8010f4 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801026:	83 ec 08             	sub    $0x8,%esp
  801029:	ff 75 0c             	pushl  0xc(%ebp)
  80102c:	6a 30                	push   $0x30
  80102e:	8b 45 08             	mov    0x8(%ebp),%eax
  801031:	ff d0                	call   *%eax
  801033:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801036:	83 ec 08             	sub    $0x8,%esp
  801039:	ff 75 0c             	pushl  0xc(%ebp)
  80103c:	6a 78                	push   $0x78
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
  801041:	ff d0                	call   *%eax
  801043:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801046:	8b 45 14             	mov    0x14(%ebp),%eax
  801049:	83 c0 04             	add    $0x4,%eax
  80104c:	89 45 14             	mov    %eax,0x14(%ebp)
  80104f:	8b 45 14             	mov    0x14(%ebp),%eax
  801052:	83 e8 04             	sub    $0x4,%eax
  801055:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801057:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80105a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801061:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801068:	eb 1f                	jmp    801089 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80106a:	83 ec 08             	sub    $0x8,%esp
  80106d:	ff 75 e8             	pushl  -0x18(%ebp)
  801070:	8d 45 14             	lea    0x14(%ebp),%eax
  801073:	50                   	push   %eax
  801074:	e8 e7 fb ff ff       	call   800c60 <getuint>
  801079:	83 c4 10             	add    $0x10,%esp
  80107c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80107f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801082:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801089:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80108d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801090:	83 ec 04             	sub    $0x4,%esp
  801093:	52                   	push   %edx
  801094:	ff 75 e4             	pushl  -0x1c(%ebp)
  801097:	50                   	push   %eax
  801098:	ff 75 f4             	pushl  -0xc(%ebp)
  80109b:	ff 75 f0             	pushl  -0x10(%ebp)
  80109e:	ff 75 0c             	pushl  0xc(%ebp)
  8010a1:	ff 75 08             	pushl  0x8(%ebp)
  8010a4:	e8 00 fb ff ff       	call   800ba9 <printnum>
  8010a9:	83 c4 20             	add    $0x20,%esp
			break;
  8010ac:	eb 46                	jmp    8010f4 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010ae:	83 ec 08             	sub    $0x8,%esp
  8010b1:	ff 75 0c             	pushl  0xc(%ebp)
  8010b4:	53                   	push   %ebx
  8010b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b8:	ff d0                	call   *%eax
  8010ba:	83 c4 10             	add    $0x10,%esp
			break;
  8010bd:	eb 35                	jmp    8010f4 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8010bf:	c6 05 64 e0 81 00 00 	movb   $0x0,0x81e064
			break;
  8010c6:	eb 2c                	jmp    8010f4 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8010c8:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
			break;
  8010cf:	eb 23                	jmp    8010f4 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010d1:	83 ec 08             	sub    $0x8,%esp
  8010d4:	ff 75 0c             	pushl  0xc(%ebp)
  8010d7:	6a 25                	push   $0x25
  8010d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dc:	ff d0                	call   *%eax
  8010de:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010e1:	ff 4d 10             	decl   0x10(%ebp)
  8010e4:	eb 03                	jmp    8010e9 <vprintfmt+0x3c3>
  8010e6:	ff 4d 10             	decl   0x10(%ebp)
  8010e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ec:	48                   	dec    %eax
  8010ed:	8a 00                	mov    (%eax),%al
  8010ef:	3c 25                	cmp    $0x25,%al
  8010f1:	75 f3                	jne    8010e6 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8010f3:	90                   	nop
		}
	}
  8010f4:	e9 35 fc ff ff       	jmp    800d2e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8010f9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8010fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010fd:	5b                   	pop    %ebx
  8010fe:	5e                   	pop    %esi
  8010ff:	5d                   	pop    %ebp
  801100:	c3                   	ret    

00801101 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801101:	55                   	push   %ebp
  801102:	89 e5                	mov    %esp,%ebp
  801104:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801107:	8d 45 10             	lea    0x10(%ebp),%eax
  80110a:	83 c0 04             	add    $0x4,%eax
  80110d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801110:	8b 45 10             	mov    0x10(%ebp),%eax
  801113:	ff 75 f4             	pushl  -0xc(%ebp)
  801116:	50                   	push   %eax
  801117:	ff 75 0c             	pushl  0xc(%ebp)
  80111a:	ff 75 08             	pushl  0x8(%ebp)
  80111d:	e8 04 fc ff ff       	call   800d26 <vprintfmt>
  801122:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801125:	90                   	nop
  801126:	c9                   	leave  
  801127:	c3                   	ret    

00801128 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801128:	55                   	push   %ebp
  801129:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80112b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112e:	8b 40 08             	mov    0x8(%eax),%eax
  801131:	8d 50 01             	lea    0x1(%eax),%edx
  801134:	8b 45 0c             	mov    0xc(%ebp),%eax
  801137:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80113a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113d:	8b 10                	mov    (%eax),%edx
  80113f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801142:	8b 40 04             	mov    0x4(%eax),%eax
  801145:	39 c2                	cmp    %eax,%edx
  801147:	73 12                	jae    80115b <sprintputch+0x33>
		*b->buf++ = ch;
  801149:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114c:	8b 00                	mov    (%eax),%eax
  80114e:	8d 48 01             	lea    0x1(%eax),%ecx
  801151:	8b 55 0c             	mov    0xc(%ebp),%edx
  801154:	89 0a                	mov    %ecx,(%edx)
  801156:	8b 55 08             	mov    0x8(%ebp),%edx
  801159:	88 10                	mov    %dl,(%eax)
}
  80115b:	90                   	nop
  80115c:	5d                   	pop    %ebp
  80115d:	c3                   	ret    

0080115e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80115e:	55                   	push   %ebp
  80115f:	89 e5                	mov    %esp,%ebp
  801161:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801164:	8b 45 08             	mov    0x8(%ebp),%eax
  801167:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80116a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801170:	8b 45 08             	mov    0x8(%ebp),%eax
  801173:	01 d0                	add    %edx,%eax
  801175:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801178:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80117f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801183:	74 06                	je     80118b <vsnprintf+0x2d>
  801185:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801189:	7f 07                	jg     801192 <vsnprintf+0x34>
		return -E_INVAL;
  80118b:	b8 03 00 00 00       	mov    $0x3,%eax
  801190:	eb 20                	jmp    8011b2 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801192:	ff 75 14             	pushl  0x14(%ebp)
  801195:	ff 75 10             	pushl  0x10(%ebp)
  801198:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80119b:	50                   	push   %eax
  80119c:	68 28 11 80 00       	push   $0x801128
  8011a1:	e8 80 fb ff ff       	call   800d26 <vprintfmt>
  8011a6:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8011a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011ac:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8011af:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8011b2:	c9                   	leave  
  8011b3:	c3                   	ret    

008011b4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011b4:	55                   	push   %ebp
  8011b5:	89 e5                	mov    %esp,%ebp
  8011b7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8011ba:	8d 45 10             	lea    0x10(%ebp),%eax
  8011bd:	83 c0 04             	add    $0x4,%eax
  8011c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8011c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8011c9:	50                   	push   %eax
  8011ca:	ff 75 0c             	pushl  0xc(%ebp)
  8011cd:	ff 75 08             	pushl  0x8(%ebp)
  8011d0:	e8 89 ff ff ff       	call   80115e <vsnprintf>
  8011d5:	83 c4 10             	add    $0x10,%esp
  8011d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8011db:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011de:	c9                   	leave  
  8011df:	c3                   	ret    

008011e0 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8011e0:	55                   	push   %ebp
  8011e1:	89 e5                	mov    %esp,%ebp
  8011e3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8011e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011ed:	eb 06                	jmp    8011f5 <strlen+0x15>
		n++;
  8011ef:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8011f2:	ff 45 08             	incl   0x8(%ebp)
  8011f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f8:	8a 00                	mov    (%eax),%al
  8011fa:	84 c0                	test   %al,%al
  8011fc:	75 f1                	jne    8011ef <strlen+0xf>
		n++;
	return n;
  8011fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801201:	c9                   	leave  
  801202:	c3                   	ret    

00801203 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801203:	55                   	push   %ebp
  801204:	89 e5                	mov    %esp,%ebp
  801206:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801209:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801210:	eb 09                	jmp    80121b <strnlen+0x18>
		n++;
  801212:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801215:	ff 45 08             	incl   0x8(%ebp)
  801218:	ff 4d 0c             	decl   0xc(%ebp)
  80121b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80121f:	74 09                	je     80122a <strnlen+0x27>
  801221:	8b 45 08             	mov    0x8(%ebp),%eax
  801224:	8a 00                	mov    (%eax),%al
  801226:	84 c0                	test   %al,%al
  801228:	75 e8                	jne    801212 <strnlen+0xf>
		n++;
	return n;
  80122a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80122d:	c9                   	leave  
  80122e:	c3                   	ret    

0080122f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80122f:	55                   	push   %ebp
  801230:	89 e5                	mov    %esp,%ebp
  801232:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801235:	8b 45 08             	mov    0x8(%ebp),%eax
  801238:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80123b:	90                   	nop
  80123c:	8b 45 08             	mov    0x8(%ebp),%eax
  80123f:	8d 50 01             	lea    0x1(%eax),%edx
  801242:	89 55 08             	mov    %edx,0x8(%ebp)
  801245:	8b 55 0c             	mov    0xc(%ebp),%edx
  801248:	8d 4a 01             	lea    0x1(%edx),%ecx
  80124b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80124e:	8a 12                	mov    (%edx),%dl
  801250:	88 10                	mov    %dl,(%eax)
  801252:	8a 00                	mov    (%eax),%al
  801254:	84 c0                	test   %al,%al
  801256:	75 e4                	jne    80123c <strcpy+0xd>
		/* do nothing */;
	return ret;
  801258:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80125b:	c9                   	leave  
  80125c:	c3                   	ret    

0080125d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80125d:	55                   	push   %ebp
  80125e:	89 e5                	mov    %esp,%ebp
  801260:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801263:	8b 45 08             	mov    0x8(%ebp),%eax
  801266:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801269:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801270:	eb 1f                	jmp    801291 <strncpy+0x34>
		*dst++ = *src;
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
  801275:	8d 50 01             	lea    0x1(%eax),%edx
  801278:	89 55 08             	mov    %edx,0x8(%ebp)
  80127b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80127e:	8a 12                	mov    (%edx),%dl
  801280:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801282:	8b 45 0c             	mov    0xc(%ebp),%eax
  801285:	8a 00                	mov    (%eax),%al
  801287:	84 c0                	test   %al,%al
  801289:	74 03                	je     80128e <strncpy+0x31>
			src++;
  80128b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80128e:	ff 45 fc             	incl   -0x4(%ebp)
  801291:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801294:	3b 45 10             	cmp    0x10(%ebp),%eax
  801297:	72 d9                	jb     801272 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801299:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80129c:	c9                   	leave  
  80129d:	c3                   	ret    

0080129e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80129e:	55                   	push   %ebp
  80129f:	89 e5                	mov    %esp,%ebp
  8012a1:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8012aa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012ae:	74 30                	je     8012e0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8012b0:	eb 16                	jmp    8012c8 <strlcpy+0x2a>
			*dst++ = *src++;
  8012b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b5:	8d 50 01             	lea    0x1(%eax),%edx
  8012b8:	89 55 08             	mov    %edx,0x8(%ebp)
  8012bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012be:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012c1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8012c4:	8a 12                	mov    (%edx),%dl
  8012c6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8012c8:	ff 4d 10             	decl   0x10(%ebp)
  8012cb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012cf:	74 09                	je     8012da <strlcpy+0x3c>
  8012d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d4:	8a 00                	mov    (%eax),%al
  8012d6:	84 c0                	test   %al,%al
  8012d8:	75 d8                	jne    8012b2 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8012da:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8012e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8012e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012e6:	29 c2                	sub    %eax,%edx
  8012e8:	89 d0                	mov    %edx,%eax
}
  8012ea:	c9                   	leave  
  8012eb:	c3                   	ret    

008012ec <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8012ec:	55                   	push   %ebp
  8012ed:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8012ef:	eb 06                	jmp    8012f7 <strcmp+0xb>
		p++, q++;
  8012f1:	ff 45 08             	incl   0x8(%ebp)
  8012f4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8012f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fa:	8a 00                	mov    (%eax),%al
  8012fc:	84 c0                	test   %al,%al
  8012fe:	74 0e                	je     80130e <strcmp+0x22>
  801300:	8b 45 08             	mov    0x8(%ebp),%eax
  801303:	8a 10                	mov    (%eax),%dl
  801305:	8b 45 0c             	mov    0xc(%ebp),%eax
  801308:	8a 00                	mov    (%eax),%al
  80130a:	38 c2                	cmp    %al,%dl
  80130c:	74 e3                	je     8012f1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	8a 00                	mov    (%eax),%al
  801313:	0f b6 d0             	movzbl %al,%edx
  801316:	8b 45 0c             	mov    0xc(%ebp),%eax
  801319:	8a 00                	mov    (%eax),%al
  80131b:	0f b6 c0             	movzbl %al,%eax
  80131e:	29 c2                	sub    %eax,%edx
  801320:	89 d0                	mov    %edx,%eax
}
  801322:	5d                   	pop    %ebp
  801323:	c3                   	ret    

00801324 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801324:	55                   	push   %ebp
  801325:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801327:	eb 09                	jmp    801332 <strncmp+0xe>
		n--, p++, q++;
  801329:	ff 4d 10             	decl   0x10(%ebp)
  80132c:	ff 45 08             	incl   0x8(%ebp)
  80132f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801332:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801336:	74 17                	je     80134f <strncmp+0x2b>
  801338:	8b 45 08             	mov    0x8(%ebp),%eax
  80133b:	8a 00                	mov    (%eax),%al
  80133d:	84 c0                	test   %al,%al
  80133f:	74 0e                	je     80134f <strncmp+0x2b>
  801341:	8b 45 08             	mov    0x8(%ebp),%eax
  801344:	8a 10                	mov    (%eax),%dl
  801346:	8b 45 0c             	mov    0xc(%ebp),%eax
  801349:	8a 00                	mov    (%eax),%al
  80134b:	38 c2                	cmp    %al,%dl
  80134d:	74 da                	je     801329 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80134f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801353:	75 07                	jne    80135c <strncmp+0x38>
		return 0;
  801355:	b8 00 00 00 00       	mov    $0x0,%eax
  80135a:	eb 14                	jmp    801370 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80135c:	8b 45 08             	mov    0x8(%ebp),%eax
  80135f:	8a 00                	mov    (%eax),%al
  801361:	0f b6 d0             	movzbl %al,%edx
  801364:	8b 45 0c             	mov    0xc(%ebp),%eax
  801367:	8a 00                	mov    (%eax),%al
  801369:	0f b6 c0             	movzbl %al,%eax
  80136c:	29 c2                	sub    %eax,%edx
  80136e:	89 d0                	mov    %edx,%eax
}
  801370:	5d                   	pop    %ebp
  801371:	c3                   	ret    

00801372 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801372:	55                   	push   %ebp
  801373:	89 e5                	mov    %esp,%ebp
  801375:	83 ec 04             	sub    $0x4,%esp
  801378:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80137e:	eb 12                	jmp    801392 <strchr+0x20>
		if (*s == c)
  801380:	8b 45 08             	mov    0x8(%ebp),%eax
  801383:	8a 00                	mov    (%eax),%al
  801385:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801388:	75 05                	jne    80138f <strchr+0x1d>
			return (char *) s;
  80138a:	8b 45 08             	mov    0x8(%ebp),%eax
  80138d:	eb 11                	jmp    8013a0 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80138f:	ff 45 08             	incl   0x8(%ebp)
  801392:	8b 45 08             	mov    0x8(%ebp),%eax
  801395:	8a 00                	mov    (%eax),%al
  801397:	84 c0                	test   %al,%al
  801399:	75 e5                	jne    801380 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80139b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013a0:	c9                   	leave  
  8013a1:	c3                   	ret    

008013a2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013a2:	55                   	push   %ebp
  8013a3:	89 e5                	mov    %esp,%ebp
  8013a5:	83 ec 04             	sub    $0x4,%esp
  8013a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ab:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8013ae:	eb 0d                	jmp    8013bd <strfind+0x1b>
		if (*s == c)
  8013b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b3:	8a 00                	mov    (%eax),%al
  8013b5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8013b8:	74 0e                	je     8013c8 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8013ba:	ff 45 08             	incl   0x8(%ebp)
  8013bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c0:	8a 00                	mov    (%eax),%al
  8013c2:	84 c0                	test   %al,%al
  8013c4:	75 ea                	jne    8013b0 <strfind+0xe>
  8013c6:	eb 01                	jmp    8013c9 <strfind+0x27>
		if (*s == c)
			break;
  8013c8:	90                   	nop
	return (char *) s;
  8013c9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013cc:	c9                   	leave  
  8013cd:	c3                   	ret    

008013ce <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8013ce:	55                   	push   %ebp
  8013cf:	89 e5                	mov    %esp,%ebp
  8013d1:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8013d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8013da:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8013de:	76 63                	jbe    801443 <memset+0x75>
		uint64 data_block = c;
  8013e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e3:	99                   	cltd   
  8013e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013e7:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8013ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013f0:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8013f4:	c1 e0 08             	shl    $0x8,%eax
  8013f7:	09 45 f0             	or     %eax,-0x10(%ebp)
  8013fa:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8013fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801400:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801403:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801407:	c1 e0 10             	shl    $0x10,%eax
  80140a:	09 45 f0             	or     %eax,-0x10(%ebp)
  80140d:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801410:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801413:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801416:	89 c2                	mov    %eax,%edx
  801418:	b8 00 00 00 00       	mov    $0x0,%eax
  80141d:	09 45 f0             	or     %eax,-0x10(%ebp)
  801420:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801423:	eb 18                	jmp    80143d <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801425:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801428:	8d 41 08             	lea    0x8(%ecx),%eax
  80142b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80142e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801431:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801434:	89 01                	mov    %eax,(%ecx)
  801436:	89 51 04             	mov    %edx,0x4(%ecx)
  801439:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80143d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801441:	77 e2                	ja     801425 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801443:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801447:	74 23                	je     80146c <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801449:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80144c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80144f:	eb 0e                	jmp    80145f <memset+0x91>
			*p8++ = (uint8)c;
  801451:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801454:	8d 50 01             	lea    0x1(%eax),%edx
  801457:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80145a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80145d:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  80145f:	8b 45 10             	mov    0x10(%ebp),%eax
  801462:	8d 50 ff             	lea    -0x1(%eax),%edx
  801465:	89 55 10             	mov    %edx,0x10(%ebp)
  801468:	85 c0                	test   %eax,%eax
  80146a:	75 e5                	jne    801451 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  80146c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80146f:	c9                   	leave  
  801470:	c3                   	ret    

00801471 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801471:	55                   	push   %ebp
  801472:	89 e5                	mov    %esp,%ebp
  801474:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801477:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
  801480:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801483:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801487:	76 24                	jbe    8014ad <memcpy+0x3c>
		while(n >= 8){
  801489:	eb 1c                	jmp    8014a7 <memcpy+0x36>
			*d64 = *s64;
  80148b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80148e:	8b 50 04             	mov    0x4(%eax),%edx
  801491:	8b 00                	mov    (%eax),%eax
  801493:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801496:	89 01                	mov    %eax,(%ecx)
  801498:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80149b:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80149f:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8014a3:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8014a7:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8014ab:	77 de                	ja     80148b <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8014ad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014b1:	74 31                	je     8014e4 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8014b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8014b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8014bf:	eb 16                	jmp    8014d7 <memcpy+0x66>
			*d8++ = *s8++;
  8014c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c4:	8d 50 01             	lea    0x1(%eax),%edx
  8014c7:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8014ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014cd:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014d0:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8014d3:	8a 12                	mov    (%edx),%dl
  8014d5:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8014d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8014da:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014dd:	89 55 10             	mov    %edx,0x10(%ebp)
  8014e0:	85 c0                	test   %eax,%eax
  8014e2:	75 dd                	jne    8014c1 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8014e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014e7:	c9                   	leave  
  8014e8:	c3                   	ret    

008014e9 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8014e9:	55                   	push   %ebp
  8014ea:	89 e5                	mov    %esp,%ebp
  8014ec:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8014fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014fe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801501:	73 50                	jae    801553 <memmove+0x6a>
  801503:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801506:	8b 45 10             	mov    0x10(%ebp),%eax
  801509:	01 d0                	add    %edx,%eax
  80150b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80150e:	76 43                	jbe    801553 <memmove+0x6a>
		s += n;
  801510:	8b 45 10             	mov    0x10(%ebp),%eax
  801513:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801516:	8b 45 10             	mov    0x10(%ebp),%eax
  801519:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80151c:	eb 10                	jmp    80152e <memmove+0x45>
			*--d = *--s;
  80151e:	ff 4d f8             	decl   -0x8(%ebp)
  801521:	ff 4d fc             	decl   -0x4(%ebp)
  801524:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801527:	8a 10                	mov    (%eax),%dl
  801529:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80152c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80152e:	8b 45 10             	mov    0x10(%ebp),%eax
  801531:	8d 50 ff             	lea    -0x1(%eax),%edx
  801534:	89 55 10             	mov    %edx,0x10(%ebp)
  801537:	85 c0                	test   %eax,%eax
  801539:	75 e3                	jne    80151e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80153b:	eb 23                	jmp    801560 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80153d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801540:	8d 50 01             	lea    0x1(%eax),%edx
  801543:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801546:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801549:	8d 4a 01             	lea    0x1(%edx),%ecx
  80154c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80154f:	8a 12                	mov    (%edx),%dl
  801551:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801553:	8b 45 10             	mov    0x10(%ebp),%eax
  801556:	8d 50 ff             	lea    -0x1(%eax),%edx
  801559:	89 55 10             	mov    %edx,0x10(%ebp)
  80155c:	85 c0                	test   %eax,%eax
  80155e:	75 dd                	jne    80153d <memmove+0x54>
			*d++ = *s++;

	return dst;
  801560:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801563:	c9                   	leave  
  801564:	c3                   	ret    

00801565 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801565:	55                   	push   %ebp
  801566:	89 e5                	mov    %esp,%ebp
  801568:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80156b:	8b 45 08             	mov    0x8(%ebp),%eax
  80156e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801571:	8b 45 0c             	mov    0xc(%ebp),%eax
  801574:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801577:	eb 2a                	jmp    8015a3 <memcmp+0x3e>
		if (*s1 != *s2)
  801579:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80157c:	8a 10                	mov    (%eax),%dl
  80157e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801581:	8a 00                	mov    (%eax),%al
  801583:	38 c2                	cmp    %al,%dl
  801585:	74 16                	je     80159d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801587:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80158a:	8a 00                	mov    (%eax),%al
  80158c:	0f b6 d0             	movzbl %al,%edx
  80158f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801592:	8a 00                	mov    (%eax),%al
  801594:	0f b6 c0             	movzbl %al,%eax
  801597:	29 c2                	sub    %eax,%edx
  801599:	89 d0                	mov    %edx,%eax
  80159b:	eb 18                	jmp    8015b5 <memcmp+0x50>
		s1++, s2++;
  80159d:	ff 45 fc             	incl   -0x4(%ebp)
  8015a0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8015a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015a9:	89 55 10             	mov    %edx,0x10(%ebp)
  8015ac:	85 c0                	test   %eax,%eax
  8015ae:	75 c9                	jne    801579 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015b5:	c9                   	leave  
  8015b6:	c3                   	ret    

008015b7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8015b7:	55                   	push   %ebp
  8015b8:	89 e5                	mov    %esp,%ebp
  8015ba:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8015bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8015c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c3:	01 d0                	add    %edx,%eax
  8015c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8015c8:	eb 15                	jmp    8015df <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cd:	8a 00                	mov    (%eax),%al
  8015cf:	0f b6 d0             	movzbl %al,%edx
  8015d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d5:	0f b6 c0             	movzbl %al,%eax
  8015d8:	39 c2                	cmp    %eax,%edx
  8015da:	74 0d                	je     8015e9 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015dc:	ff 45 08             	incl   0x8(%ebp)
  8015df:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015e5:	72 e3                	jb     8015ca <memfind+0x13>
  8015e7:	eb 01                	jmp    8015ea <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8015e9:	90                   	nop
	return (void *) s;
  8015ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015ed:	c9                   	leave  
  8015ee:	c3                   	ret    

008015ef <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015ef:	55                   	push   %ebp
  8015f0:	89 e5                	mov    %esp,%ebp
  8015f2:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8015f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8015fc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801603:	eb 03                	jmp    801608 <strtol+0x19>
		s++;
  801605:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801608:	8b 45 08             	mov    0x8(%ebp),%eax
  80160b:	8a 00                	mov    (%eax),%al
  80160d:	3c 20                	cmp    $0x20,%al
  80160f:	74 f4                	je     801605 <strtol+0x16>
  801611:	8b 45 08             	mov    0x8(%ebp),%eax
  801614:	8a 00                	mov    (%eax),%al
  801616:	3c 09                	cmp    $0x9,%al
  801618:	74 eb                	je     801605 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80161a:	8b 45 08             	mov    0x8(%ebp),%eax
  80161d:	8a 00                	mov    (%eax),%al
  80161f:	3c 2b                	cmp    $0x2b,%al
  801621:	75 05                	jne    801628 <strtol+0x39>
		s++;
  801623:	ff 45 08             	incl   0x8(%ebp)
  801626:	eb 13                	jmp    80163b <strtol+0x4c>
	else if (*s == '-')
  801628:	8b 45 08             	mov    0x8(%ebp),%eax
  80162b:	8a 00                	mov    (%eax),%al
  80162d:	3c 2d                	cmp    $0x2d,%al
  80162f:	75 0a                	jne    80163b <strtol+0x4c>
		s++, neg = 1;
  801631:	ff 45 08             	incl   0x8(%ebp)
  801634:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80163b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80163f:	74 06                	je     801647 <strtol+0x58>
  801641:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801645:	75 20                	jne    801667 <strtol+0x78>
  801647:	8b 45 08             	mov    0x8(%ebp),%eax
  80164a:	8a 00                	mov    (%eax),%al
  80164c:	3c 30                	cmp    $0x30,%al
  80164e:	75 17                	jne    801667 <strtol+0x78>
  801650:	8b 45 08             	mov    0x8(%ebp),%eax
  801653:	40                   	inc    %eax
  801654:	8a 00                	mov    (%eax),%al
  801656:	3c 78                	cmp    $0x78,%al
  801658:	75 0d                	jne    801667 <strtol+0x78>
		s += 2, base = 16;
  80165a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80165e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801665:	eb 28                	jmp    80168f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801667:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80166b:	75 15                	jne    801682 <strtol+0x93>
  80166d:	8b 45 08             	mov    0x8(%ebp),%eax
  801670:	8a 00                	mov    (%eax),%al
  801672:	3c 30                	cmp    $0x30,%al
  801674:	75 0c                	jne    801682 <strtol+0x93>
		s++, base = 8;
  801676:	ff 45 08             	incl   0x8(%ebp)
  801679:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801680:	eb 0d                	jmp    80168f <strtol+0xa0>
	else if (base == 0)
  801682:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801686:	75 07                	jne    80168f <strtol+0xa0>
		base = 10;
  801688:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80168f:	8b 45 08             	mov    0x8(%ebp),%eax
  801692:	8a 00                	mov    (%eax),%al
  801694:	3c 2f                	cmp    $0x2f,%al
  801696:	7e 19                	jle    8016b1 <strtol+0xc2>
  801698:	8b 45 08             	mov    0x8(%ebp),%eax
  80169b:	8a 00                	mov    (%eax),%al
  80169d:	3c 39                	cmp    $0x39,%al
  80169f:	7f 10                	jg     8016b1 <strtol+0xc2>
			dig = *s - '0';
  8016a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a4:	8a 00                	mov    (%eax),%al
  8016a6:	0f be c0             	movsbl %al,%eax
  8016a9:	83 e8 30             	sub    $0x30,%eax
  8016ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016af:	eb 42                	jmp    8016f3 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8016b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b4:	8a 00                	mov    (%eax),%al
  8016b6:	3c 60                	cmp    $0x60,%al
  8016b8:	7e 19                	jle    8016d3 <strtol+0xe4>
  8016ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bd:	8a 00                	mov    (%eax),%al
  8016bf:	3c 7a                	cmp    $0x7a,%al
  8016c1:	7f 10                	jg     8016d3 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8016c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c6:	8a 00                	mov    (%eax),%al
  8016c8:	0f be c0             	movsbl %al,%eax
  8016cb:	83 e8 57             	sub    $0x57,%eax
  8016ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016d1:	eb 20                	jmp    8016f3 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8016d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d6:	8a 00                	mov    (%eax),%al
  8016d8:	3c 40                	cmp    $0x40,%al
  8016da:	7e 39                	jle    801715 <strtol+0x126>
  8016dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016df:	8a 00                	mov    (%eax),%al
  8016e1:	3c 5a                	cmp    $0x5a,%al
  8016e3:	7f 30                	jg     801715 <strtol+0x126>
			dig = *s - 'A' + 10;
  8016e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e8:	8a 00                	mov    (%eax),%al
  8016ea:	0f be c0             	movsbl %al,%eax
  8016ed:	83 e8 37             	sub    $0x37,%eax
  8016f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8016f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8016f9:	7d 19                	jge    801714 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8016fb:	ff 45 08             	incl   0x8(%ebp)
  8016fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801701:	0f af 45 10          	imul   0x10(%ebp),%eax
  801705:	89 c2                	mov    %eax,%edx
  801707:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80170a:	01 d0                	add    %edx,%eax
  80170c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80170f:	e9 7b ff ff ff       	jmp    80168f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801714:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801715:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801719:	74 08                	je     801723 <strtol+0x134>
		*endptr = (char *) s;
  80171b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171e:	8b 55 08             	mov    0x8(%ebp),%edx
  801721:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801723:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801727:	74 07                	je     801730 <strtol+0x141>
  801729:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80172c:	f7 d8                	neg    %eax
  80172e:	eb 03                	jmp    801733 <strtol+0x144>
  801730:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801733:	c9                   	leave  
  801734:	c3                   	ret    

00801735 <ltostr>:

void
ltostr(long value, char *str)
{
  801735:	55                   	push   %ebp
  801736:	89 e5                	mov    %esp,%ebp
  801738:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80173b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801742:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801749:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80174d:	79 13                	jns    801762 <ltostr+0x2d>
	{
		neg = 1;
  80174f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801756:	8b 45 0c             	mov    0xc(%ebp),%eax
  801759:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80175c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80175f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801762:	8b 45 08             	mov    0x8(%ebp),%eax
  801765:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80176a:	99                   	cltd   
  80176b:	f7 f9                	idiv   %ecx
  80176d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801770:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801773:	8d 50 01             	lea    0x1(%eax),%edx
  801776:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801779:	89 c2                	mov    %eax,%edx
  80177b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177e:	01 d0                	add    %edx,%eax
  801780:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801783:	83 c2 30             	add    $0x30,%edx
  801786:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801788:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80178b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801790:	f7 e9                	imul   %ecx
  801792:	c1 fa 02             	sar    $0x2,%edx
  801795:	89 c8                	mov    %ecx,%eax
  801797:	c1 f8 1f             	sar    $0x1f,%eax
  80179a:	29 c2                	sub    %eax,%edx
  80179c:	89 d0                	mov    %edx,%eax
  80179e:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8017a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8017a5:	75 bb                	jne    801762 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8017a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8017ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017b1:	48                   	dec    %eax
  8017b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8017b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8017b9:	74 3d                	je     8017f8 <ltostr+0xc3>
		start = 1 ;
  8017bb:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8017c2:	eb 34                	jmp    8017f8 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8017c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ca:	01 d0                	add    %edx,%eax
  8017cc:	8a 00                	mov    (%eax),%al
  8017ce:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8017d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d7:	01 c2                	add    %eax,%edx
  8017d9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8017dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017df:	01 c8                	add    %ecx,%eax
  8017e1:	8a 00                	mov    (%eax),%al
  8017e3:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8017e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017eb:	01 c2                	add    %eax,%edx
  8017ed:	8a 45 eb             	mov    -0x15(%ebp),%al
  8017f0:	88 02                	mov    %al,(%edx)
		start++ ;
  8017f2:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8017f5:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8017f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017fb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8017fe:	7c c4                	jl     8017c4 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801800:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801803:	8b 45 0c             	mov    0xc(%ebp),%eax
  801806:	01 d0                	add    %edx,%eax
  801808:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80180b:	90                   	nop
  80180c:	c9                   	leave  
  80180d:	c3                   	ret    

0080180e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
  801811:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801814:	ff 75 08             	pushl  0x8(%ebp)
  801817:	e8 c4 f9 ff ff       	call   8011e0 <strlen>
  80181c:	83 c4 04             	add    $0x4,%esp
  80181f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801822:	ff 75 0c             	pushl  0xc(%ebp)
  801825:	e8 b6 f9 ff ff       	call   8011e0 <strlen>
  80182a:	83 c4 04             	add    $0x4,%esp
  80182d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801830:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801837:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80183e:	eb 17                	jmp    801857 <strcconcat+0x49>
		final[s] = str1[s] ;
  801840:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801843:	8b 45 10             	mov    0x10(%ebp),%eax
  801846:	01 c2                	add    %eax,%edx
  801848:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80184b:	8b 45 08             	mov    0x8(%ebp),%eax
  80184e:	01 c8                	add    %ecx,%eax
  801850:	8a 00                	mov    (%eax),%al
  801852:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801854:	ff 45 fc             	incl   -0x4(%ebp)
  801857:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80185a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80185d:	7c e1                	jl     801840 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80185f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801866:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80186d:	eb 1f                	jmp    80188e <strcconcat+0x80>
		final[s++] = str2[i] ;
  80186f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801872:	8d 50 01             	lea    0x1(%eax),%edx
  801875:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801878:	89 c2                	mov    %eax,%edx
  80187a:	8b 45 10             	mov    0x10(%ebp),%eax
  80187d:	01 c2                	add    %eax,%edx
  80187f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801882:	8b 45 0c             	mov    0xc(%ebp),%eax
  801885:	01 c8                	add    %ecx,%eax
  801887:	8a 00                	mov    (%eax),%al
  801889:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80188b:	ff 45 f8             	incl   -0x8(%ebp)
  80188e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801891:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801894:	7c d9                	jl     80186f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801896:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801899:	8b 45 10             	mov    0x10(%ebp),%eax
  80189c:	01 d0                	add    %edx,%eax
  80189e:	c6 00 00             	movb   $0x0,(%eax)
}
  8018a1:	90                   	nop
  8018a2:	c9                   	leave  
  8018a3:	c3                   	ret    

008018a4 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8018a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8018aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8018b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8018b3:	8b 00                	mov    (%eax),%eax
  8018b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8018bf:	01 d0                	add    %edx,%eax
  8018c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018c7:	eb 0c                	jmp    8018d5 <strsplit+0x31>
			*string++ = 0;
  8018c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cc:	8d 50 01             	lea    0x1(%eax),%edx
  8018cf:	89 55 08             	mov    %edx,0x8(%ebp)
  8018d2:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d8:	8a 00                	mov    (%eax),%al
  8018da:	84 c0                	test   %al,%al
  8018dc:	74 18                	je     8018f6 <strsplit+0x52>
  8018de:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e1:	8a 00                	mov    (%eax),%al
  8018e3:	0f be c0             	movsbl %al,%eax
  8018e6:	50                   	push   %eax
  8018e7:	ff 75 0c             	pushl  0xc(%ebp)
  8018ea:	e8 83 fa ff ff       	call   801372 <strchr>
  8018ef:	83 c4 08             	add    $0x8,%esp
  8018f2:	85 c0                	test   %eax,%eax
  8018f4:	75 d3                	jne    8018c9 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8018f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f9:	8a 00                	mov    (%eax),%al
  8018fb:	84 c0                	test   %al,%al
  8018fd:	74 5a                	je     801959 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8018ff:	8b 45 14             	mov    0x14(%ebp),%eax
  801902:	8b 00                	mov    (%eax),%eax
  801904:	83 f8 0f             	cmp    $0xf,%eax
  801907:	75 07                	jne    801910 <strsplit+0x6c>
		{
			return 0;
  801909:	b8 00 00 00 00       	mov    $0x0,%eax
  80190e:	eb 66                	jmp    801976 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801910:	8b 45 14             	mov    0x14(%ebp),%eax
  801913:	8b 00                	mov    (%eax),%eax
  801915:	8d 48 01             	lea    0x1(%eax),%ecx
  801918:	8b 55 14             	mov    0x14(%ebp),%edx
  80191b:	89 0a                	mov    %ecx,(%edx)
  80191d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801924:	8b 45 10             	mov    0x10(%ebp),%eax
  801927:	01 c2                	add    %eax,%edx
  801929:	8b 45 08             	mov    0x8(%ebp),%eax
  80192c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80192e:	eb 03                	jmp    801933 <strsplit+0x8f>
			string++;
  801930:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801933:	8b 45 08             	mov    0x8(%ebp),%eax
  801936:	8a 00                	mov    (%eax),%al
  801938:	84 c0                	test   %al,%al
  80193a:	74 8b                	je     8018c7 <strsplit+0x23>
  80193c:	8b 45 08             	mov    0x8(%ebp),%eax
  80193f:	8a 00                	mov    (%eax),%al
  801941:	0f be c0             	movsbl %al,%eax
  801944:	50                   	push   %eax
  801945:	ff 75 0c             	pushl  0xc(%ebp)
  801948:	e8 25 fa ff ff       	call   801372 <strchr>
  80194d:	83 c4 08             	add    $0x8,%esp
  801950:	85 c0                	test   %eax,%eax
  801952:	74 dc                	je     801930 <strsplit+0x8c>
			string++;
	}
  801954:	e9 6e ff ff ff       	jmp    8018c7 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801959:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80195a:	8b 45 14             	mov    0x14(%ebp),%eax
  80195d:	8b 00                	mov    (%eax),%eax
  80195f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801966:	8b 45 10             	mov    0x10(%ebp),%eax
  801969:	01 d0                	add    %edx,%eax
  80196b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801971:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801976:	c9                   	leave  
  801977:	c3                   	ret    

00801978 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
  80197b:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80197e:	8b 45 08             	mov    0x8(%ebp),%eax
  801981:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801984:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80198b:	eb 4a                	jmp    8019d7 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80198d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801990:	8b 45 08             	mov    0x8(%ebp),%eax
  801993:	01 c2                	add    %eax,%edx
  801995:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801998:	8b 45 0c             	mov    0xc(%ebp),%eax
  80199b:	01 c8                	add    %ecx,%eax
  80199d:	8a 00                	mov    (%eax),%al
  80199f:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8019a1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a7:	01 d0                	add    %edx,%eax
  8019a9:	8a 00                	mov    (%eax),%al
  8019ab:	3c 40                	cmp    $0x40,%al
  8019ad:	7e 25                	jle    8019d4 <str2lower+0x5c>
  8019af:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019b5:	01 d0                	add    %edx,%eax
  8019b7:	8a 00                	mov    (%eax),%al
  8019b9:	3c 5a                	cmp    $0x5a,%al
  8019bb:	7f 17                	jg     8019d4 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8019bd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c3:	01 d0                	add    %edx,%eax
  8019c5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8019cb:	01 ca                	add    %ecx,%edx
  8019cd:	8a 12                	mov    (%edx),%dl
  8019cf:	83 c2 20             	add    $0x20,%edx
  8019d2:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8019d4:	ff 45 fc             	incl   -0x4(%ebp)
  8019d7:	ff 75 0c             	pushl  0xc(%ebp)
  8019da:	e8 01 f8 ff ff       	call   8011e0 <strlen>
  8019df:	83 c4 04             	add    $0x4,%esp
  8019e2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8019e5:	7f a6                	jg     80198d <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8019e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8019ea:	c9                   	leave  
  8019eb:	c3                   	ret    

008019ec <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8019ec:	55                   	push   %ebp
  8019ed:	89 e5                	mov    %esp,%ebp
  8019ef:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8019f2:	a1 08 60 80 00       	mov    0x806008,%eax
  8019f7:	85 c0                	test   %eax,%eax
  8019f9:	74 42                	je     801a3d <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8019fb:	83 ec 08             	sub    $0x8,%esp
  8019fe:	68 00 00 00 82       	push   $0x82000000
  801a03:	68 00 00 00 80       	push   $0x80000000
  801a08:	e8 b0 1e 00 00       	call   8038bd <initialize_dynamic_allocator>
  801a0d:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801a10:	e8 96 1c 00 00       	call   8036ab <sys_get_uheap_strategy>
  801a15:	a3 80 60 83 00       	mov    %eax,0x836080
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801a1a:	a1 60 e0 81 00       	mov    0x81e060,%eax
  801a1f:	05 00 10 00 00       	add    $0x1000,%eax
  801a24:	a3 30 61 83 00       	mov    %eax,0x836130
		uheapPageAllocBreak = uheapPageAllocStart;
  801a29:	a1 30 61 83 00       	mov    0x836130,%eax
  801a2e:	a3 88 60 83 00       	mov    %eax,0x836088

		__firstTimeFlag = 0;
  801a33:	c7 05 08 60 80 00 00 	movl   $0x0,0x806008
  801a3a:	00 00 00 
	}
}
  801a3d:	90                   	nop
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    

00801a40 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
  801a43:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801a46:	8b 45 08             	mov    0x8(%ebp),%eax
  801a49:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a4f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a54:	83 ec 08             	sub    $0x8,%esp
  801a57:	68 06 04 00 00       	push   $0x406
  801a5c:	50                   	push   %eax
  801a5d:	e8 93 18 00 00       	call   8032f5 <__sys_allocate_page>
  801a62:	83 c4 10             	add    $0x10,%esp
  801a65:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801a68:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801a6c:	79 14                	jns    801a82 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801a6e:	83 ec 04             	sub    $0x4,%esp
  801a71:	68 68 4f 80 00       	push   $0x804f68
  801a76:	6a 1f                	push   $0x1f
  801a78:	68 a4 4f 80 00       	push   $0x804fa4
  801a7d:	e8 b7 ed ff ff       	call   800839 <_panic>
	return 0;
  801a82:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a87:	c9                   	leave  
  801a88:	c3                   	ret    

00801a89 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
  801a8c:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a92:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a98:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a9d:	83 ec 0c             	sub    $0xc,%esp
  801aa0:	50                   	push   %eax
  801aa1:	e8 96 18 00 00       	call   80333c <__sys_unmap_frame>
  801aa6:	83 c4 10             	add    $0x10,%esp
  801aa9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801aac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ab0:	79 14                	jns    801ac6 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801ab2:	83 ec 04             	sub    $0x4,%esp
  801ab5:	68 b0 4f 80 00       	push   $0x804fb0
  801aba:	6a 2a                	push   $0x2a
  801abc:	68 a4 4f 80 00       	push   $0x804fa4
  801ac1:	e8 73 ed ff ff       	call   800839 <_panic>
}
  801ac6:	90                   	nop
  801ac7:	c9                   	leave  
  801ac8:	c3                   	ret    

00801ac9 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
  801acc:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801acf:	e8 18 ff ff ff       	call   8019ec <uheap_init>
	if (size == 0) return NULL ;
  801ad4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ad8:	75 0a                	jne    801ae4 <malloc+0x1b>
  801ada:	b8 00 00 00 00       	mov    $0x0,%eax
  801adf:	e9 43 03 00 00       	jmp    801e27 <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801ae4:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801aeb:	77 13                	ja     801b00 <malloc+0x37>
    {
        return alloc_block(size);
  801aed:	83 ec 0c             	sub    $0xc,%esp
  801af0:	ff 75 08             	pushl  0x8(%ebp)
  801af3:	e8 78 20 00 00       	call   803b70 <alloc_block>
  801af8:	83 c4 10             	add    $0x10,%esp
  801afb:	e9 27 03 00 00       	jmp    801e27 <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801b00:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801b07:	8b 55 08             	mov    0x8(%ebp),%edx
  801b0a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b0d:	01 d0                	add    %edx,%eax
  801b0f:	48                   	dec    %eax
  801b10:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801b13:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b16:	ba 00 00 00 00       	mov    $0x0,%edx
  801b1b:	f7 75 dc             	divl   -0x24(%ebp)
  801b1e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b21:	29 d0                	sub    %edx,%eax
  801b23:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  801b26:	a1 40 e0 81 00       	mov    0x81e040,%eax
  801b2b:	85 c0                	test   %eax,%eax
  801b2d:	75 0a                	jne    801b39 <malloc+0x70>
    {
        uhp_inited = 1;
  801b2f:	c7 05 40 e0 81 00 01 	movl   $0x1,0x81e040
  801b36:	00 00 00 
    }

    int exactIdx = -1;
  801b39:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801b40:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801b47:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801b4e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801b55:	e9 85 00 00 00       	jmp    801bdf <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801b5a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b5d:	89 d0                	mov    %edx,%eax
  801b5f:	01 c0                	add    %eax,%eax
  801b61:	01 d0                	add    %edx,%eax
  801b63:	c1 e0 02             	shl    $0x2,%eax
  801b66:	05 48 20 81 00       	add    $0x812048,%eax
  801b6b:	8a 00                	mov    (%eax),%al
  801b6d:	84 c0                	test   %al,%al
  801b6f:	74 20                	je     801b91 <malloc+0xc8>
  801b71:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b74:	89 d0                	mov    %edx,%eax
  801b76:	01 c0                	add    %eax,%eax
  801b78:	01 d0                	add    %edx,%eax
  801b7a:	c1 e0 02             	shl    $0x2,%eax
  801b7d:	05 44 20 81 00       	add    $0x812044,%eax
  801b82:	8b 00                	mov    (%eax),%eax
  801b84:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801b87:	75 08                	jne    801b91 <malloc+0xc8>
        {
            exactIdx = i;
  801b89:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801b8f:	eb 5b                	jmp    801bec <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801b91:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b94:	89 d0                	mov    %edx,%eax
  801b96:	01 c0                	add    %eax,%eax
  801b98:	01 d0                	add    %edx,%eax
  801b9a:	c1 e0 02             	shl    $0x2,%eax
  801b9d:	05 48 20 81 00       	add    $0x812048,%eax
  801ba2:	8a 00                	mov    (%eax),%al
  801ba4:	84 c0                	test   %al,%al
  801ba6:	74 34                	je     801bdc <malloc+0x113>
  801ba8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801bab:	89 d0                	mov    %edx,%eax
  801bad:	01 c0                	add    %eax,%eax
  801baf:	01 d0                	add    %edx,%eax
  801bb1:	c1 e0 02             	shl    $0x2,%eax
  801bb4:	05 44 20 81 00       	add    $0x812044,%eax
  801bb9:	8b 00                	mov    (%eax),%eax
  801bbb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801bbe:	76 1c                	jbe    801bdc <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  801bc0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801bc3:	89 d0                	mov    %edx,%eax
  801bc5:	01 c0                	add    %eax,%eax
  801bc7:	01 d0                	add    %edx,%eax
  801bc9:	c1 e0 02             	shl    $0x2,%eax
  801bcc:	05 44 20 81 00       	add    $0x812044,%eax
  801bd1:	8b 00                	mov    (%eax),%eax
  801bd3:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801bd6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801bdc:	ff 45 e8             	incl   -0x18(%ebp)
  801bdf:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801be6:	0f 8e 6e ff ff ff    	jle    801b5a <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  801bec:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801bf3:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801bf7:	74 7d                	je     801c76 <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801bf9:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801c00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c03:	89 d0                	mov    %edx,%eax
  801c05:	01 c0                	add    %eax,%eax
  801c07:	01 d0                	add    %edx,%eax
  801c09:	c1 e0 02             	shl    $0x2,%eax
  801c0c:	05 40 20 81 00       	add    $0x812040,%eax
  801c11:	8b 10                	mov    (%eax),%edx
  801c13:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801c16:	01 d0                	add    %edx,%eax
  801c18:	48                   	dec    %eax
  801c19:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801c1c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801c1f:	ba 00 00 00 00       	mov    $0x0,%edx
  801c24:	f7 75 bc             	divl   -0x44(%ebp)
  801c27:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801c2a:	29 d0                	sub    %edx,%eax
  801c2c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801c2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c32:	89 d0                	mov    %edx,%eax
  801c34:	01 c0                	add    %eax,%eax
  801c36:	01 d0                	add    %edx,%eax
  801c38:	c1 e0 02             	shl    $0x2,%eax
  801c3b:	05 48 20 81 00       	add    $0x812048,%eax
  801c40:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801c43:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c46:	89 d0                	mov    %edx,%eax
  801c48:	01 c0                	add    %eax,%eax
  801c4a:	01 d0                	add    %edx,%eax
  801c4c:	c1 e0 02             	shl    $0x2,%eax
  801c4f:	05 44 20 81 00       	add    $0x812044,%eax
  801c54:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801c5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c5d:	89 d0                	mov    %edx,%eax
  801c5f:	01 c0                	add    %eax,%eax
  801c61:	01 d0                	add    %edx,%eax
  801c63:	c1 e0 02             	shl    $0x2,%eax
  801c66:	05 40 20 81 00       	add    $0x812040,%eax
  801c6b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c71:	e9 2d 01 00 00       	jmp    801da3 <malloc+0x2da>
    }
    else if (worstIdx != -1)
  801c76:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801c7a:	0f 84 ce 00 00 00    	je     801d4e <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  801c80:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  801c87:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c8a:	89 d0                	mov    %edx,%eax
  801c8c:	01 c0                	add    %eax,%eax
  801c8e:	01 d0                	add    %edx,%eax
  801c90:	c1 e0 02             	shl    $0x2,%eax
  801c93:	05 40 20 81 00       	add    $0x812040,%eax
  801c98:	8b 10                	mov    (%eax),%edx
  801c9a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801c9d:	01 d0                	add    %edx,%eax
  801c9f:	48                   	dec    %eax
  801ca0:	89 45 c0             	mov    %eax,-0x40(%ebp)
  801ca3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801ca6:	ba 00 00 00 00       	mov    $0x0,%edx
  801cab:	f7 75 c4             	divl   -0x3c(%ebp)
  801cae:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801cb1:	29 d0                	sub    %edx,%eax
  801cb3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  801cb6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801cb9:	89 d0                	mov    %edx,%eax
  801cbb:	01 c0                	add    %eax,%eax
  801cbd:	01 d0                	add    %edx,%eax
  801cbf:	c1 e0 02             	shl    $0x2,%eax
  801cc2:	05 44 20 81 00       	add    $0x812044,%eax
  801cc7:	8b 00                	mov    (%eax),%eax
  801cc9:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801ccc:	75 47                	jne    801d15 <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  801cce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801cd1:	89 d0                	mov    %edx,%eax
  801cd3:	01 c0                	add    %eax,%eax
  801cd5:	01 d0                	add    %edx,%eax
  801cd7:	c1 e0 02             	shl    $0x2,%eax
  801cda:	05 48 20 81 00       	add    $0x812048,%eax
  801cdf:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  801ce2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ce5:	89 d0                	mov    %edx,%eax
  801ce7:	01 c0                	add    %eax,%eax
  801ce9:	01 d0                	add    %edx,%eax
  801ceb:	c1 e0 02             	shl    $0x2,%eax
  801cee:	05 44 20 81 00       	add    $0x812044,%eax
  801cf3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  801cf9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801cfc:	89 d0                	mov    %edx,%eax
  801cfe:	01 c0                	add    %eax,%eax
  801d00:	01 d0                	add    %edx,%eax
  801d02:	c1 e0 02             	shl    $0x2,%eax
  801d05:	05 40 20 81 00       	add    $0x812040,%eax
  801d0a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801d10:	e9 8e 00 00 00       	jmp    801da3 <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  801d15:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801d18:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d1b:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801d1e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d21:	89 d0                	mov    %edx,%eax
  801d23:	01 c0                	add    %eax,%eax
  801d25:	01 d0                	add    %edx,%eax
  801d27:	c1 e0 02             	shl    $0x2,%eax
  801d2a:	05 40 20 81 00       	add    $0x812040,%eax
  801d2f:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  801d31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d34:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801d37:	89 c2                	mov    %eax,%edx
  801d39:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801d3c:	89 c8                	mov    %ecx,%eax
  801d3e:	01 c0                	add    %eax,%eax
  801d40:	01 c8                	add    %ecx,%eax
  801d42:	c1 e0 02             	shl    $0x2,%eax
  801d45:	05 44 20 81 00       	add    $0x812044,%eax
  801d4a:	89 10                	mov    %edx,(%eax)
  801d4c:	eb 55                	jmp    801da3 <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  801d4e:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801d55:	8b 15 88 60 83 00    	mov    0x836088,%edx
  801d5b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801d5e:	01 d0                	add    %edx,%eax
  801d60:	48                   	dec    %eax
  801d61:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801d64:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801d67:	ba 00 00 00 00       	mov    $0x0,%edx
  801d6c:	f7 75 d0             	divl   -0x30(%ebp)
  801d6f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801d72:	29 d0                	sub    %edx,%eax
  801d74:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  801d77:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801d7a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d7d:	01 d0                	add    %edx,%eax
  801d7f:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801d84:	76 0a                	jbe    801d90 <malloc+0x2c7>
            return NULL;
  801d86:	b8 00 00 00 00       	mov    $0x0,%eax
  801d8b:	e9 97 00 00 00       	jmp    801e27 <malloc+0x35e>
        va = start;
  801d90:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801d93:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  801d96:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801d99:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d9c:	01 d0                	add    %edx,%eax
  801d9e:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801da3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801daa:	eb 5e                	jmp    801e0a <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  801dac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801daf:	89 d0                	mov    %edx,%eax
  801db1:	01 c0                	add    %eax,%eax
  801db3:	01 d0                	add    %edx,%eax
  801db5:	c1 e0 02             	shl    $0x2,%eax
  801db8:	05 48 60 80 00       	add    $0x806048,%eax
  801dbd:	8a 00                	mov    (%eax),%al
  801dbf:	84 c0                	test   %al,%al
  801dc1:	75 44                	jne    801e07 <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  801dc3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801dc6:	89 d0                	mov    %edx,%eax
  801dc8:	01 c0                	add    %eax,%eax
  801dca:	01 d0                	add    %edx,%eax
  801dcc:	c1 e0 02             	shl    $0x2,%eax
  801dcf:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  801dd5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dd8:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  801dda:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ddd:	89 d0                	mov    %edx,%eax
  801ddf:	01 c0                	add    %eax,%eax
  801de1:	01 d0                	add    %edx,%eax
  801de3:	c1 e0 02             	shl    $0x2,%eax
  801de6:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  801dec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801def:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  801df1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801df4:	89 d0                	mov    %edx,%eax
  801df6:	01 c0                	add    %eax,%eax
  801df8:	01 d0                	add    %edx,%eax
  801dfa:	c1 e0 02             	shl    $0x2,%eax
  801dfd:	05 48 60 80 00       	add    $0x806048,%eax
  801e02:	c6 00 01             	movb   $0x1,(%eax)
            break;
  801e05:	eb 0c                	jmp    801e13 <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801e07:	ff 45 e0             	incl   -0x20(%ebp)
  801e0a:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801e11:	7e 99                	jle    801dac <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  801e13:	83 ec 08             	sub    $0x8,%esp
  801e16:	ff 75 d4             	pushl  -0x2c(%ebp)
  801e19:	ff 75 e4             	pushl  -0x1c(%ebp)
  801e1c:	e8 a2 19 00 00       	call   8037c3 <sys_allocate_user_mem>
  801e21:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  801e24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801e27:	c9                   	leave  
  801e28:	c3                   	ret    

00801e29 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801e29:	55                   	push   %ebp
  801e2a:	89 e5                	mov    %esp,%ebp
  801e2c:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  801e2f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e33:	0f 84 fa 03 00 00    	je     802233 <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  801e39:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  801e3f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e42:	85 c0                	test   %eax,%eax
  801e44:	79 1c                	jns    801e62 <free+0x39>
  801e46:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  801e4d:	77 13                	ja     801e62 <free+0x39>
    {
        free_block(virtual_address);
  801e4f:	83 ec 0c             	sub    $0xc,%esp
  801e52:	ff 75 08             	pushl  0x8(%ebp)
  801e55:	e8 09 21 00 00       	call   803f63 <free_block>
  801e5a:	83 c4 10             	add    $0x10,%esp
        return;
  801e5d:	e9 d2 03 00 00       	jmp    802234 <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  801e62:	a1 30 61 83 00       	mov    0x836130,%eax
  801e67:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  801e6a:	72 09                	jb     801e75 <free+0x4c>
  801e6c:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  801e73:	76 17                	jbe    801e8c <free+0x63>
        panic("free: invalid address");
  801e75:	83 ec 04             	sub    $0x4,%esp
  801e78:	68 ed 4f 80 00       	push   $0x804fed
  801e7d:	68 9b 00 00 00       	push   $0x9b
  801e82:	68 a4 4f 80 00       	push   $0x804fa4
  801e87:	e8 ad e9 ff ff       	call   800839 <_panic>

    uint32 size = 0;
  801e8c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  801e93:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801e9a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801ea1:	eb 50                	jmp    801ef3 <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  801ea3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ea6:	89 d0                	mov    %edx,%eax
  801ea8:	01 c0                	add    %eax,%eax
  801eaa:	01 d0                	add    %edx,%eax
  801eac:	c1 e0 02             	shl    $0x2,%eax
  801eaf:	05 48 60 80 00       	add    $0x806048,%eax
  801eb4:	8a 00                	mov    (%eax),%al
  801eb6:	84 c0                	test   %al,%al
  801eb8:	74 36                	je     801ef0 <free+0xc7>
  801eba:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ebd:	89 d0                	mov    %edx,%eax
  801ebf:	01 c0                	add    %eax,%eax
  801ec1:	01 d0                	add    %edx,%eax
  801ec3:	c1 e0 02             	shl    $0x2,%eax
  801ec6:	05 40 60 80 00       	add    $0x806040,%eax
  801ecb:	8b 00                	mov    (%eax),%eax
  801ecd:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801ed0:	75 1e                	jne    801ef0 <free+0xc7>
        {
            size = uhp_allocs[i].size;
  801ed2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ed5:	89 d0                	mov    %edx,%eax
  801ed7:	01 c0                	add    %eax,%eax
  801ed9:	01 d0                	add    %edx,%eax
  801edb:	c1 e0 02             	shl    $0x2,%eax
  801ede:	05 44 60 80 00       	add    $0x806044,%eax
  801ee3:	8b 00                	mov    (%eax),%eax
  801ee5:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  801ee8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eeb:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  801eee:	eb 0c                	jmp    801efc <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801ef0:	ff 45 ec             	incl   -0x14(%ebp)
  801ef3:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  801efa:	7e a7                	jle    801ea3 <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  801efc:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801f00:	74 06                	je     801f08 <free+0xdf>
  801f02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f06:	75 17                	jne    801f1f <free+0xf6>
        panic("free: unknown block");
  801f08:	83 ec 04             	sub    $0x4,%esp
  801f0b:	68 03 50 80 00       	push   $0x805003
  801f10:	68 a9 00 00 00       	push   $0xa9
  801f15:	68 a4 4f 80 00       	push   $0x804fa4
  801f1a:	e8 1a e9 ff ff       	call   800839 <_panic>

    uhp_allocs[idx].used = 0;
  801f1f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f22:	89 d0                	mov    %edx,%eax
  801f24:	01 c0                	add    %eax,%eax
  801f26:	01 d0                	add    %edx,%eax
  801f28:	c1 e0 02             	shl    $0x2,%eax
  801f2b:	05 48 60 80 00       	add    $0x806048,%eax
  801f30:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  801f33:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801f3a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801f41:	eb 64                	jmp    801fa7 <free+0x17e>
    {
        if (!uhp_frees[i].free)
  801f43:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801f46:	89 d0                	mov    %edx,%eax
  801f48:	01 c0                	add    %eax,%eax
  801f4a:	01 d0                	add    %edx,%eax
  801f4c:	c1 e0 02             	shl    $0x2,%eax
  801f4f:	05 48 20 81 00       	add    $0x812048,%eax
  801f54:	8a 00                	mov    (%eax),%al
  801f56:	84 c0                	test   %al,%al
  801f58:	75 4a                	jne    801fa4 <free+0x17b>
        {
            uhp_frees[i].va = va;
  801f5a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801f5d:	89 d0                	mov    %edx,%eax
  801f5f:	01 c0                	add    %eax,%eax
  801f61:	01 d0                	add    %edx,%eax
  801f63:	c1 e0 02             	shl    $0x2,%eax
  801f66:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  801f6c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f6f:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  801f71:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801f74:	89 d0                	mov    %edx,%eax
  801f76:	01 c0                	add    %eax,%eax
  801f78:	01 d0                	add    %edx,%eax
  801f7a:	c1 e0 02             	shl    $0x2,%eax
  801f7d:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  801f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f86:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  801f88:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801f8b:	89 d0                	mov    %edx,%eax
  801f8d:	01 c0                	add    %eax,%eax
  801f8f:	01 d0                	add    %edx,%eax
  801f91:	c1 e0 02             	shl    $0x2,%eax
  801f94:	05 48 20 81 00       	add    $0x812048,%eax
  801f99:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  801f9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f9f:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  801fa2:	eb 0c                	jmp    801fb0 <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801fa4:	ff 45 e4             	incl   -0x1c(%ebp)
  801fa7:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  801fae:	7e 93                	jle    801f43 <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  801fb0:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  801fb4:	0f 84 f1 01 00 00    	je     8021ab <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801fba:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801fc1:	e9 d8 01 00 00       	jmp    80219e <free+0x375>
        {
            if (i == fidx) continue;
  801fc6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fc9:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801fcc:	0f 84 c8 01 00 00    	je     80219a <free+0x371>
            if (uhp_frees[i].free)
  801fd2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801fd5:	89 d0                	mov    %edx,%eax
  801fd7:	01 c0                	add    %eax,%eax
  801fd9:	01 d0                	add    %edx,%eax
  801fdb:	c1 e0 02             	shl    $0x2,%eax
  801fde:	05 48 20 81 00       	add    $0x812048,%eax
  801fe3:	8a 00                	mov    (%eax),%al
  801fe5:	84 c0                	test   %al,%al
  801fe7:	0f 84 ae 01 00 00    	je     80219b <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  801fed:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ff0:	89 d0                	mov    %edx,%eax
  801ff2:	01 c0                	add    %eax,%eax
  801ff4:	01 d0                	add    %edx,%eax
  801ff6:	c1 e0 02             	shl    $0x2,%eax
  801ff9:	05 40 20 81 00       	add    $0x812040,%eax
  801ffe:	8b 08                	mov    (%eax),%ecx
  802000:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802003:	89 d0                	mov    %edx,%eax
  802005:	01 c0                	add    %eax,%eax
  802007:	01 d0                	add    %edx,%eax
  802009:	c1 e0 02             	shl    $0x2,%eax
  80200c:	05 44 20 81 00       	add    $0x812044,%eax
  802011:	8b 00                	mov    (%eax),%eax
  802013:	01 c1                	add    %eax,%ecx
  802015:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802018:	89 d0                	mov    %edx,%eax
  80201a:	01 c0                	add    %eax,%eax
  80201c:	01 d0                	add    %edx,%eax
  80201e:	c1 e0 02             	shl    $0x2,%eax
  802021:	05 40 20 81 00       	add    $0x812040,%eax
  802026:	8b 00                	mov    (%eax),%eax
  802028:	39 c1                	cmp    %eax,%ecx
  80202a:	0f 85 a8 00 00 00    	jne    8020d8 <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  802030:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802033:	89 d0                	mov    %edx,%eax
  802035:	01 c0                	add    %eax,%eax
  802037:	01 d0                	add    %edx,%eax
  802039:	c1 e0 02             	shl    $0x2,%eax
  80203c:	05 40 20 81 00       	add    $0x812040,%eax
  802041:	8b 10                	mov    (%eax),%edx
  802043:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  802046:	89 c8                	mov    %ecx,%eax
  802048:	01 c0                	add    %eax,%eax
  80204a:	01 c8                	add    %ecx,%eax
  80204c:	c1 e0 02             	shl    $0x2,%eax
  80204f:	05 40 20 81 00       	add    $0x812040,%eax
  802054:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  802056:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802059:	89 d0                	mov    %edx,%eax
  80205b:	01 c0                	add    %eax,%eax
  80205d:	01 d0                	add    %edx,%eax
  80205f:	c1 e0 02             	shl    $0x2,%eax
  802062:	05 44 20 81 00       	add    $0x812044,%eax
  802067:	8b 08                	mov    (%eax),%ecx
  802069:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80206c:	89 d0                	mov    %edx,%eax
  80206e:	01 c0                	add    %eax,%eax
  802070:	01 d0                	add    %edx,%eax
  802072:	c1 e0 02             	shl    $0x2,%eax
  802075:	05 44 20 81 00       	add    $0x812044,%eax
  80207a:	8b 00                	mov    (%eax),%eax
  80207c:	01 c1                	add    %eax,%ecx
  80207e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802081:	89 d0                	mov    %edx,%eax
  802083:	01 c0                	add    %eax,%eax
  802085:	01 d0                	add    %edx,%eax
  802087:	c1 e0 02             	shl    $0x2,%eax
  80208a:	05 44 20 81 00       	add    $0x812044,%eax
  80208f:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  802091:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802094:	89 d0                	mov    %edx,%eax
  802096:	01 c0                	add    %eax,%eax
  802098:	01 d0                	add    %edx,%eax
  80209a:	c1 e0 02             	shl    $0x2,%eax
  80209d:	05 48 20 81 00       	add    $0x812048,%eax
  8020a2:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  8020a5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020a8:	89 d0                	mov    %edx,%eax
  8020aa:	01 c0                	add    %eax,%eax
  8020ac:	01 d0                	add    %edx,%eax
  8020ae:	c1 e0 02             	shl    $0x2,%eax
  8020b1:	05 40 20 81 00       	add    $0x812040,%eax
  8020b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  8020bc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020bf:	89 d0                	mov    %edx,%eax
  8020c1:	01 c0                	add    %eax,%eax
  8020c3:	01 d0                	add    %edx,%eax
  8020c5:	c1 e0 02             	shl    $0x2,%eax
  8020c8:	05 44 20 81 00       	add    $0x812044,%eax
  8020cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020d3:	e9 c3 00 00 00       	jmp    80219b <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  8020d8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8020db:	89 d0                	mov    %edx,%eax
  8020dd:	01 c0                	add    %eax,%eax
  8020df:	01 d0                	add    %edx,%eax
  8020e1:	c1 e0 02             	shl    $0x2,%eax
  8020e4:	05 40 20 81 00       	add    $0x812040,%eax
  8020e9:	8b 08                	mov    (%eax),%ecx
  8020eb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8020ee:	89 d0                	mov    %edx,%eax
  8020f0:	01 c0                	add    %eax,%eax
  8020f2:	01 d0                	add    %edx,%eax
  8020f4:	c1 e0 02             	shl    $0x2,%eax
  8020f7:	05 44 20 81 00       	add    $0x812044,%eax
  8020fc:	8b 00                	mov    (%eax),%eax
  8020fe:	01 c1                	add    %eax,%ecx
  802100:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802103:	89 d0                	mov    %edx,%eax
  802105:	01 c0                	add    %eax,%eax
  802107:	01 d0                	add    %edx,%eax
  802109:	c1 e0 02             	shl    $0x2,%eax
  80210c:	05 40 20 81 00       	add    $0x812040,%eax
  802111:	8b 00                	mov    (%eax),%eax
  802113:	39 c1                	cmp    %eax,%ecx
  802115:	0f 85 80 00 00 00    	jne    80219b <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  80211b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80211e:	89 d0                	mov    %edx,%eax
  802120:	01 c0                	add    %eax,%eax
  802122:	01 d0                	add    %edx,%eax
  802124:	c1 e0 02             	shl    $0x2,%eax
  802127:	05 44 20 81 00       	add    $0x812044,%eax
  80212c:	8b 08                	mov    (%eax),%ecx
  80212e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802131:	89 d0                	mov    %edx,%eax
  802133:	01 c0                	add    %eax,%eax
  802135:	01 d0                	add    %edx,%eax
  802137:	c1 e0 02             	shl    $0x2,%eax
  80213a:	05 44 20 81 00       	add    $0x812044,%eax
  80213f:	8b 00                	mov    (%eax),%eax
  802141:	01 c1                	add    %eax,%ecx
  802143:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802146:	89 d0                	mov    %edx,%eax
  802148:	01 c0                	add    %eax,%eax
  80214a:	01 d0                	add    %edx,%eax
  80214c:	c1 e0 02             	shl    $0x2,%eax
  80214f:	05 44 20 81 00       	add    $0x812044,%eax
  802154:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  802156:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802159:	89 d0                	mov    %edx,%eax
  80215b:	01 c0                	add    %eax,%eax
  80215d:	01 d0                	add    %edx,%eax
  80215f:	c1 e0 02             	shl    $0x2,%eax
  802162:	05 48 20 81 00       	add    $0x812048,%eax
  802167:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  80216a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80216d:	89 d0                	mov    %edx,%eax
  80216f:	01 c0                	add    %eax,%eax
  802171:	01 d0                	add    %edx,%eax
  802173:	c1 e0 02             	shl    $0x2,%eax
  802176:	05 40 20 81 00       	add    $0x812040,%eax
  80217b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  802181:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802184:	89 d0                	mov    %edx,%eax
  802186:	01 c0                	add    %eax,%eax
  802188:	01 d0                	add    %edx,%eax
  80218a:	c1 e0 02             	shl    $0x2,%eax
  80218d:	05 44 20 81 00       	add    $0x812044,%eax
  802192:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802198:	eb 01                	jmp    80219b <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  80219a:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80219b:	ff 45 e0             	incl   -0x20(%ebp)
  80219e:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8021a5:	0f 8e 1b fe ff ff    	jle    801fc6 <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  8021ab:	a1 30 61 83 00       	mov    0x836130,%eax
  8021b0:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8021b3:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8021ba:	eb 53                	jmp    80220f <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  8021bc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8021bf:	89 d0                	mov    %edx,%eax
  8021c1:	01 c0                	add    %eax,%eax
  8021c3:	01 d0                	add    %edx,%eax
  8021c5:	c1 e0 02             	shl    $0x2,%eax
  8021c8:	05 48 60 80 00       	add    $0x806048,%eax
  8021cd:	8a 00                	mov    (%eax),%al
  8021cf:	84 c0                	test   %al,%al
  8021d1:	74 39                	je     80220c <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  8021d3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8021d6:	89 d0                	mov    %edx,%eax
  8021d8:	01 c0                	add    %eax,%eax
  8021da:	01 d0                	add    %edx,%eax
  8021dc:	c1 e0 02             	shl    $0x2,%eax
  8021df:	05 40 60 80 00       	add    $0x806040,%eax
  8021e4:	8b 08                	mov    (%eax),%ecx
  8021e6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8021e9:	89 d0                	mov    %edx,%eax
  8021eb:	01 c0                	add    %eax,%eax
  8021ed:	01 d0                	add    %edx,%eax
  8021ef:	c1 e0 02             	shl    $0x2,%eax
  8021f2:	05 44 60 80 00       	add    $0x806044,%eax
  8021f7:	8b 00                	mov    (%eax),%eax
  8021f9:	01 c8                	add    %ecx,%eax
  8021fb:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  8021fe:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802201:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802204:	76 06                	jbe    80220c <free+0x3e3>
  802206:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802209:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80220c:	ff 45 d8             	incl   -0x28(%ebp)
  80220f:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  802216:	7e a4                	jle    8021bc <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  802218:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80221b:	a3 88 60 83 00       	mov    %eax,0x836088

    sys_free_user_mem(va, size);
  802220:	83 ec 08             	sub    $0x8,%esp
  802223:	ff 75 f4             	pushl  -0xc(%ebp)
  802226:	ff 75 d4             	pushl  -0x2c(%ebp)
  802229:	e8 79 15 00 00       	call   8037a7 <sys_free_user_mem>
  80222e:	83 c4 10             	add    $0x10,%esp
  802231:	eb 01                	jmp    802234 <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  802233:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  802234:	c9                   	leave  
  802235:	c3                   	ret    

00802236 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802236:	55                   	push   %ebp
  802237:	89 e5                	mov    %esp,%ebp
  802239:	83 ec 68             	sub    $0x68,%esp
  80223c:	8b 45 10             	mov    0x10(%ebp),%eax
  80223f:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802242:	e8 a5 f7 ff ff       	call   8019ec <uheap_init>
	if (size == 0) return NULL ;
  802247:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80224b:	75 0a                	jne    802257 <smalloc+0x21>
  80224d:	b8 00 00 00 00       	mov    $0x0,%eax
  802252:	e9 37 03 00 00       	jmp    80258e <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  802257:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  80225e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802261:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802264:	01 d0                	add    %edx,%eax
  802266:	48                   	dec    %eax
  802267:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80226a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80226d:	ba 00 00 00 00       	mov    $0x0,%edx
  802272:	f7 75 dc             	divl   -0x24(%ebp)
  802275:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802278:	29 d0                	sub    %edx,%eax
  80227a:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  80227d:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  802284:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  80228b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802292:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802299:	e9 85 00 00 00       	jmp    802323 <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  80229e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8022a1:	89 d0                	mov    %edx,%eax
  8022a3:	01 c0                	add    %eax,%eax
  8022a5:	01 d0                	add    %edx,%eax
  8022a7:	c1 e0 02             	shl    $0x2,%eax
  8022aa:	05 48 20 81 00       	add    $0x812048,%eax
  8022af:	8a 00                	mov    (%eax),%al
  8022b1:	84 c0                	test   %al,%al
  8022b3:	74 20                	je     8022d5 <smalloc+0x9f>
  8022b5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8022b8:	89 d0                	mov    %edx,%eax
  8022ba:	01 c0                	add    %eax,%eax
  8022bc:	01 d0                	add    %edx,%eax
  8022be:	c1 e0 02             	shl    $0x2,%eax
  8022c1:	05 44 20 81 00       	add    $0x812044,%eax
  8022c6:	8b 00                	mov    (%eax),%eax
  8022c8:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8022cb:	75 08                	jne    8022d5 <smalloc+0x9f>
        {
            exactIdx = i;
  8022cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  8022d3:	eb 5b                	jmp    802330 <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  8022d5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8022d8:	89 d0                	mov    %edx,%eax
  8022da:	01 c0                	add    %eax,%eax
  8022dc:	01 d0                	add    %edx,%eax
  8022de:	c1 e0 02             	shl    $0x2,%eax
  8022e1:	05 48 20 81 00       	add    $0x812048,%eax
  8022e6:	8a 00                	mov    (%eax),%al
  8022e8:	84 c0                	test   %al,%al
  8022ea:	74 34                	je     802320 <smalloc+0xea>
  8022ec:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8022ef:	89 d0                	mov    %edx,%eax
  8022f1:	01 c0                	add    %eax,%eax
  8022f3:	01 d0                	add    %edx,%eax
  8022f5:	c1 e0 02             	shl    $0x2,%eax
  8022f8:	05 44 20 81 00       	add    $0x812044,%eax
  8022fd:	8b 00                	mov    (%eax),%eax
  8022ff:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802302:	76 1c                	jbe    802320 <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  802304:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802307:	89 d0                	mov    %edx,%eax
  802309:	01 c0                	add    %eax,%eax
  80230b:	01 d0                	add    %edx,%eax
  80230d:	c1 e0 02             	shl    $0x2,%eax
  802310:	05 44 20 81 00       	add    $0x812044,%eax
  802315:	8b 00                	mov    (%eax),%eax
  802317:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  80231a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80231d:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802320:	ff 45 e8             	incl   -0x18(%ebp)
  802323:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  80232a:	0f 8e 6e ff ff ff    	jle    80229e <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  802330:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  802337:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  80233b:	74 7d                	je     8023ba <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  80233d:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  802344:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802347:	89 d0                	mov    %edx,%eax
  802349:	01 c0                	add    %eax,%eax
  80234b:	01 d0                	add    %edx,%eax
  80234d:	c1 e0 02             	shl    $0x2,%eax
  802350:	05 40 20 81 00       	add    $0x812040,%eax
  802355:	8b 10                	mov    (%eax),%edx
  802357:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80235a:	01 d0                	add    %edx,%eax
  80235c:	48                   	dec    %eax
  80235d:	89 45 b8             	mov    %eax,-0x48(%ebp)
  802360:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802363:	ba 00 00 00 00       	mov    $0x0,%edx
  802368:	f7 75 bc             	divl   -0x44(%ebp)
  80236b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80236e:	29 d0                	sub    %edx,%eax
  802370:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  802373:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802376:	89 d0                	mov    %edx,%eax
  802378:	01 c0                	add    %eax,%eax
  80237a:	01 d0                	add    %edx,%eax
  80237c:	c1 e0 02             	shl    $0x2,%eax
  80237f:	05 48 20 81 00       	add    $0x812048,%eax
  802384:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  802387:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80238a:	89 d0                	mov    %edx,%eax
  80238c:	01 c0                	add    %eax,%eax
  80238e:	01 d0                	add    %edx,%eax
  802390:	c1 e0 02             	shl    $0x2,%eax
  802393:	05 44 20 81 00       	add    $0x812044,%eax
  802398:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  80239e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023a1:	89 d0                	mov    %edx,%eax
  8023a3:	01 c0                	add    %eax,%eax
  8023a5:	01 d0                	add    %edx,%eax
  8023a7:	c1 e0 02             	shl    $0x2,%eax
  8023aa:	05 40 20 81 00       	add    $0x812040,%eax
  8023af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023b5:	e9 2d 01 00 00       	jmp    8024e7 <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  8023ba:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8023be:	0f 84 ce 00 00 00    	je     802492 <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  8023c4:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8023cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023ce:	89 d0                	mov    %edx,%eax
  8023d0:	01 c0                	add    %eax,%eax
  8023d2:	01 d0                	add    %edx,%eax
  8023d4:	c1 e0 02             	shl    $0x2,%eax
  8023d7:	05 40 20 81 00       	add    $0x812040,%eax
  8023dc:	8b 10                	mov    (%eax),%edx
  8023de:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8023e1:	01 d0                	add    %edx,%eax
  8023e3:	48                   	dec    %eax
  8023e4:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8023e7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8023ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8023ef:	f7 75 c4             	divl   -0x3c(%ebp)
  8023f2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8023f5:	29 d0                	sub    %edx,%eax
  8023f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  8023fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023fd:	89 d0                	mov    %edx,%eax
  8023ff:	01 c0                	add    %eax,%eax
  802401:	01 d0                	add    %edx,%eax
  802403:	c1 e0 02             	shl    $0x2,%eax
  802406:	05 44 20 81 00       	add    $0x812044,%eax
  80240b:	8b 00                	mov    (%eax),%eax
  80240d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802410:	75 47                	jne    802459 <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  802412:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802415:	89 d0                	mov    %edx,%eax
  802417:	01 c0                	add    %eax,%eax
  802419:	01 d0                	add    %edx,%eax
  80241b:	c1 e0 02             	shl    $0x2,%eax
  80241e:	05 48 20 81 00       	add    $0x812048,%eax
  802423:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  802426:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802429:	89 d0                	mov    %edx,%eax
  80242b:	01 c0                	add    %eax,%eax
  80242d:	01 d0                	add    %edx,%eax
  80242f:	c1 e0 02             	shl    $0x2,%eax
  802432:	05 44 20 81 00       	add    $0x812044,%eax
  802437:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  80243d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802440:	89 d0                	mov    %edx,%eax
  802442:	01 c0                	add    %eax,%eax
  802444:	01 d0                	add    %edx,%eax
  802446:	c1 e0 02             	shl    $0x2,%eax
  802449:	05 40 20 81 00       	add    $0x812040,%eax
  80244e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802454:	e9 8e 00 00 00       	jmp    8024e7 <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  802459:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80245c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80245f:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802462:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802465:	89 d0                	mov    %edx,%eax
  802467:	01 c0                	add    %eax,%eax
  802469:	01 d0                	add    %edx,%eax
  80246b:	c1 e0 02             	shl    $0x2,%eax
  80246e:	05 40 20 81 00       	add    $0x812040,%eax
  802473:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  802475:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802478:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80247b:	89 c2                	mov    %eax,%edx
  80247d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802480:	89 c8                	mov    %ecx,%eax
  802482:	01 c0                	add    %eax,%eax
  802484:	01 c8                	add    %ecx,%eax
  802486:	c1 e0 02             	shl    $0x2,%eax
  802489:	05 44 20 81 00       	add    $0x812044,%eax
  80248e:	89 10                	mov    %edx,(%eax)
  802490:	eb 55                	jmp    8024e7 <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  802492:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  802499:	8b 15 88 60 83 00    	mov    0x836088,%edx
  80249f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8024a2:	01 d0                	add    %edx,%eax
  8024a4:	48                   	dec    %eax
  8024a5:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8024a8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8024ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8024b0:	f7 75 d0             	divl   -0x30(%ebp)
  8024b3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8024b6:	29 d0                	sub    %edx,%eax
  8024b8:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  8024bb:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8024be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024c1:	01 d0                	add    %edx,%eax
  8024c3:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8024c8:	76 0a                	jbe    8024d4 <smalloc+0x29e>
            return NULL;
  8024ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8024cf:	e9 ba 00 00 00       	jmp    80258e <smalloc+0x358>
        va = start;
  8024d4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8024d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  8024da:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8024dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024e0:	01 d0                	add    %edx,%eax
  8024e2:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8024e7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8024ee:	eb 5e                	jmp    80254e <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  8024f0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024f3:	89 d0                	mov    %edx,%eax
  8024f5:	01 c0                	add    %eax,%eax
  8024f7:	01 d0                	add    %edx,%eax
  8024f9:	c1 e0 02             	shl    $0x2,%eax
  8024fc:	05 48 60 80 00       	add    $0x806048,%eax
  802501:	8a 00                	mov    (%eax),%al
  802503:	84 c0                	test   %al,%al
  802505:	75 44                	jne    80254b <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  802507:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80250a:	89 d0                	mov    %edx,%eax
  80250c:	01 c0                	add    %eax,%eax
  80250e:	01 d0                	add    %edx,%eax
  802510:	c1 e0 02             	shl    $0x2,%eax
  802513:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  802519:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80251c:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  80251e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802521:	89 d0                	mov    %edx,%eax
  802523:	01 c0                	add    %eax,%eax
  802525:	01 d0                	add    %edx,%eax
  802527:	c1 e0 02             	shl    $0x2,%eax
  80252a:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802530:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802533:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  802535:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802538:	89 d0                	mov    %edx,%eax
  80253a:	01 c0                	add    %eax,%eax
  80253c:	01 d0                	add    %edx,%eax
  80253e:	c1 e0 02             	shl    $0x2,%eax
  802541:	05 48 60 80 00       	add    $0x806048,%eax
  802546:	c6 00 01             	movb   $0x1,(%eax)
            break;
  802549:	eb 0c                	jmp    802557 <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80254b:	ff 45 e0             	incl   -0x20(%ebp)
  80254e:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802555:	7e 99                	jle    8024f0 <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  802557:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80255a:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  80255e:	52                   	push   %edx
  80255f:	50                   	push   %eax
  802560:	ff 75 d4             	pushl  -0x2c(%ebp)
  802563:	ff 75 08             	pushl  0x8(%ebp)
  802566:	e8 de 0e 00 00       	call   803449 <sys_create_shared_object>
  80256b:	83 c4 10             	add    $0x10,%esp
  80256e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  802571:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  802575:	75 07                	jne    80257e <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  802577:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80257c:	eb 10                	jmp    80258e <smalloc+0x358>
    if (r < 0)
  80257e:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  802582:	79 07                	jns    80258b <smalloc+0x355>
        return NULL;
  802584:	b8 00 00 00 00       	mov    $0x0,%eax
  802589:	eb 03                	jmp    80258e <smalloc+0x358>
    return (void*)va;
  80258b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  80258e:	c9                   	leave  
  80258f:	c3                   	ret    

00802590 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802590:	55                   	push   %ebp
  802591:	89 e5                	mov    %esp,%ebp
  802593:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802596:	e8 51 f4 ff ff       	call   8019ec <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  80259b:	83 ec 08             	sub    $0x8,%esp
  80259e:	ff 75 0c             	pushl  0xc(%ebp)
  8025a1:	ff 75 08             	pushl  0x8(%ebp)
  8025a4:	e8 ca 0e 00 00       	call   803473 <sys_size_of_shared_object>
  8025a9:	83 c4 10             	add    $0x10,%esp
  8025ac:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  8025af:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8025b3:	7f 0a                	jg     8025bf <sget+0x2f>
        return NULL;
  8025b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ba:	e9 28 03 00 00       	jmp    8028e7 <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  8025bf:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8025c6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025c9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8025cc:	01 d0                	add    %edx,%eax
  8025ce:	48                   	dec    %eax
  8025cf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8025d2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8025da:	f7 75 d8             	divl   -0x28(%ebp)
  8025dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025e0:	29 d0                	sub    %edx,%eax
  8025e2:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  8025e5:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  8025ec:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  8025f3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8025fa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802601:	e9 85 00 00 00       	jmp    80268b <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  802606:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802609:	89 d0                	mov    %edx,%eax
  80260b:	01 c0                	add    %eax,%eax
  80260d:	01 d0                	add    %edx,%eax
  80260f:	c1 e0 02             	shl    $0x2,%eax
  802612:	05 48 20 81 00       	add    $0x812048,%eax
  802617:	8a 00                	mov    (%eax),%al
  802619:	84 c0                	test   %al,%al
  80261b:	74 20                	je     80263d <sget+0xad>
  80261d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802620:	89 d0                	mov    %edx,%eax
  802622:	01 c0                	add    %eax,%eax
  802624:	01 d0                	add    %edx,%eax
  802626:	c1 e0 02             	shl    $0x2,%eax
  802629:	05 44 20 81 00       	add    $0x812044,%eax
  80262e:	8b 00                	mov    (%eax),%eax
  802630:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802633:	75 08                	jne    80263d <sget+0xad>
        {
            exactIdx = i;
  802635:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802638:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  80263b:	eb 5b                	jmp    802698 <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  80263d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802640:	89 d0                	mov    %edx,%eax
  802642:	01 c0                	add    %eax,%eax
  802644:	01 d0                	add    %edx,%eax
  802646:	c1 e0 02             	shl    $0x2,%eax
  802649:	05 48 20 81 00       	add    $0x812048,%eax
  80264e:	8a 00                	mov    (%eax),%al
  802650:	84 c0                	test   %al,%al
  802652:	74 34                	je     802688 <sget+0xf8>
  802654:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802657:	89 d0                	mov    %edx,%eax
  802659:	01 c0                	add    %eax,%eax
  80265b:	01 d0                	add    %edx,%eax
  80265d:	c1 e0 02             	shl    $0x2,%eax
  802660:	05 44 20 81 00       	add    $0x812044,%eax
  802665:	8b 00                	mov    (%eax),%eax
  802667:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80266a:	76 1c                	jbe    802688 <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  80266c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80266f:	89 d0                	mov    %edx,%eax
  802671:	01 c0                	add    %eax,%eax
  802673:	01 d0                	add    %edx,%eax
  802675:	c1 e0 02             	shl    $0x2,%eax
  802678:	05 44 20 81 00       	add    $0x812044,%eax
  80267d:	8b 00                	mov    (%eax),%eax
  80267f:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  802682:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802685:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802688:	ff 45 e8             	incl   -0x18(%ebp)
  80268b:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802692:	0f 8e 6e ff ff ff    	jle    802606 <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  802698:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  80269f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8026a3:	74 7d                	je     802722 <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  8026a5:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8026ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026af:	89 d0                	mov    %edx,%eax
  8026b1:	01 c0                	add    %eax,%eax
  8026b3:	01 d0                	add    %edx,%eax
  8026b5:	c1 e0 02             	shl    $0x2,%eax
  8026b8:	05 40 20 81 00       	add    $0x812040,%eax
  8026bd:	8b 10                	mov    (%eax),%edx
  8026bf:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8026c2:	01 d0                	add    %edx,%eax
  8026c4:	48                   	dec    %eax
  8026c5:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8026c8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8026cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8026d0:	f7 75 b8             	divl   -0x48(%ebp)
  8026d3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8026d6:	29 d0                	sub    %edx,%eax
  8026d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  8026db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026de:	89 d0                	mov    %edx,%eax
  8026e0:	01 c0                	add    %eax,%eax
  8026e2:	01 d0                	add    %edx,%eax
  8026e4:	c1 e0 02             	shl    $0x2,%eax
  8026e7:	05 48 20 81 00       	add    $0x812048,%eax
  8026ec:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  8026ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026f2:	89 d0                	mov    %edx,%eax
  8026f4:	01 c0                	add    %eax,%eax
  8026f6:	01 d0                	add    %edx,%eax
  8026f8:	c1 e0 02             	shl    $0x2,%eax
  8026fb:	05 44 20 81 00       	add    $0x812044,%eax
  802700:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  802706:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802709:	89 d0                	mov    %edx,%eax
  80270b:	01 c0                	add    %eax,%eax
  80270d:	01 d0                	add    %edx,%eax
  80270f:	c1 e0 02             	shl    $0x2,%eax
  802712:	05 40 20 81 00       	add    $0x812040,%eax
  802717:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80271d:	e9 2d 01 00 00       	jmp    80284f <sget+0x2bf>
    }
    else if (worstIdx != -1)
  802722:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802726:	0f 84 ce 00 00 00    	je     8027fa <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  80272c:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  802733:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802736:	89 d0                	mov    %edx,%eax
  802738:	01 c0                	add    %eax,%eax
  80273a:	01 d0                	add    %edx,%eax
  80273c:	c1 e0 02             	shl    $0x2,%eax
  80273f:	05 40 20 81 00       	add    $0x812040,%eax
  802744:	8b 10                	mov    (%eax),%edx
  802746:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802749:	01 d0                	add    %edx,%eax
  80274b:	48                   	dec    %eax
  80274c:	89 45 bc             	mov    %eax,-0x44(%ebp)
  80274f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802752:	ba 00 00 00 00       	mov    $0x0,%edx
  802757:	f7 75 c0             	divl   -0x40(%ebp)
  80275a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80275d:	29 d0                	sub    %edx,%eax
  80275f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  802762:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802765:	89 d0                	mov    %edx,%eax
  802767:	01 c0                	add    %eax,%eax
  802769:	01 d0                	add    %edx,%eax
  80276b:	c1 e0 02             	shl    $0x2,%eax
  80276e:	05 44 20 81 00       	add    $0x812044,%eax
  802773:	8b 00                	mov    (%eax),%eax
  802775:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802778:	75 47                	jne    8027c1 <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  80277a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80277d:	89 d0                	mov    %edx,%eax
  80277f:	01 c0                	add    %eax,%eax
  802781:	01 d0                	add    %edx,%eax
  802783:	c1 e0 02             	shl    $0x2,%eax
  802786:	05 48 20 81 00       	add    $0x812048,%eax
  80278b:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  80278e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802791:	89 d0                	mov    %edx,%eax
  802793:	01 c0                	add    %eax,%eax
  802795:	01 d0                	add    %edx,%eax
  802797:	c1 e0 02             	shl    $0x2,%eax
  80279a:	05 44 20 81 00       	add    $0x812044,%eax
  80279f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  8027a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027a8:	89 d0                	mov    %edx,%eax
  8027aa:	01 c0                	add    %eax,%eax
  8027ac:	01 d0                	add    %edx,%eax
  8027ae:	c1 e0 02             	shl    $0x2,%eax
  8027b1:	05 40 20 81 00       	add    $0x812040,%eax
  8027b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027bc:	e9 8e 00 00 00       	jmp    80284f <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  8027c1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027c4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8027c7:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8027ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027cd:	89 d0                	mov    %edx,%eax
  8027cf:	01 c0                	add    %eax,%eax
  8027d1:	01 d0                	add    %edx,%eax
  8027d3:	c1 e0 02             	shl    $0x2,%eax
  8027d6:	05 40 20 81 00       	add    $0x812040,%eax
  8027db:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  8027dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e0:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8027e3:	89 c2                	mov    %eax,%edx
  8027e5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8027e8:	89 c8                	mov    %ecx,%eax
  8027ea:	01 c0                	add    %eax,%eax
  8027ec:	01 c8                	add    %ecx,%eax
  8027ee:	c1 e0 02             	shl    $0x2,%eax
  8027f1:	05 44 20 81 00       	add    $0x812044,%eax
  8027f6:	89 10                	mov    %edx,(%eax)
  8027f8:	eb 55                	jmp    80284f <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  8027fa:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802801:	8b 15 88 60 83 00    	mov    0x836088,%edx
  802807:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80280a:	01 d0                	add    %edx,%eax
  80280c:	48                   	dec    %eax
  80280d:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802810:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802813:	ba 00 00 00 00       	mov    $0x0,%edx
  802818:	f7 75 cc             	divl   -0x34(%ebp)
  80281b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80281e:	29 d0                	sub    %edx,%eax
  802820:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  802823:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802826:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802829:	01 d0                	add    %edx,%eax
  80282b:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802830:	76 0a                	jbe    80283c <sget+0x2ac>
            return NULL;
  802832:	b8 00 00 00 00       	mov    $0x0,%eax
  802837:	e9 ab 00 00 00       	jmp    8028e7 <sget+0x357>
        va = start;
  80283c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80283f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  802842:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802845:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802848:	01 d0                	add    %edx,%eax
  80284a:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80284f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802856:	eb 5e                	jmp    8028b6 <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  802858:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80285b:	89 d0                	mov    %edx,%eax
  80285d:	01 c0                	add    %eax,%eax
  80285f:	01 d0                	add    %edx,%eax
  802861:	c1 e0 02             	shl    $0x2,%eax
  802864:	05 48 60 80 00       	add    $0x806048,%eax
  802869:	8a 00                	mov    (%eax),%al
  80286b:	84 c0                	test   %al,%al
  80286d:	75 44                	jne    8028b3 <sget+0x323>
        {
            uhp_allocs[i].va = va;
  80286f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802872:	89 d0                	mov    %edx,%eax
  802874:	01 c0                	add    %eax,%eax
  802876:	01 d0                	add    %edx,%eax
  802878:	c1 e0 02             	shl    $0x2,%eax
  80287b:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  802881:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802884:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  802886:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802889:	89 d0                	mov    %edx,%eax
  80288b:	01 c0                	add    %eax,%eax
  80288d:	01 d0                	add    %edx,%eax
  80288f:	c1 e0 02             	shl    $0x2,%eax
  802892:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802898:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80289b:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  80289d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028a0:	89 d0                	mov    %edx,%eax
  8028a2:	01 c0                	add    %eax,%eax
  8028a4:	01 d0                	add    %edx,%eax
  8028a6:	c1 e0 02             	shl    $0x2,%eax
  8028a9:	05 48 60 80 00       	add    $0x806048,%eax
  8028ae:	c6 00 01             	movb   $0x1,(%eax)
            break;
  8028b1:	eb 0c                	jmp    8028bf <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8028b3:	ff 45 e0             	incl   -0x20(%ebp)
  8028b6:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8028bd:	7e 99                	jle    802858 <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  8028bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028c2:	83 ec 04             	sub    $0x4,%esp
  8028c5:	50                   	push   %eax
  8028c6:	ff 75 0c             	pushl  0xc(%ebp)
  8028c9:	ff 75 08             	pushl  0x8(%ebp)
  8028cc:	e8 bf 0b 00 00       	call   803490 <sys_get_shared_object>
  8028d1:	83 c4 10             	add    $0x10,%esp
  8028d4:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  8028d7:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8028db:	79 07                	jns    8028e4 <sget+0x354>
        return NULL;
  8028dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e2:	eb 03                	jmp    8028e7 <sget+0x357>
    return (void*)va;
  8028e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8028e7:	c9                   	leave  
  8028e8:	c3                   	ret    

008028e9 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8028e9:	55                   	push   %ebp
  8028ea:	89 e5                	mov    %esp,%ebp
  8028ec:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8028ef:	e8 f8 f0 ff ff       	call   8019ec <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  8028f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028f8:	75 13                	jne    80290d <realloc+0x24>
		return malloc(new_size);
  8028fa:	83 ec 0c             	sub    $0xc,%esp
  8028fd:	ff 75 0c             	pushl  0xc(%ebp)
  802900:	e8 c4 f1 ff ff       	call   801ac9 <malloc>
  802905:	83 c4 10             	add    $0x10,%esp
  802908:	e9 f4 05 00 00       	jmp    802f01 <realloc+0x618>
	if (new_size == 0)
  80290d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802911:	75 18                	jne    80292b <realloc+0x42>
	{
		free(virtual_address);
  802913:	83 ec 0c             	sub    $0xc,%esp
  802916:	ff 75 08             	pushl  0x8(%ebp)
  802919:	e8 0b f5 ff ff       	call   801e29 <free>
  80291e:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802921:	b8 00 00 00 00       	mov    $0x0,%eax
  802926:	e9 d6 05 00 00       	jmp    802f01 <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  80292b:	8b 45 08             	mov    0x8(%ebp),%eax
  80292e:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  802931:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802934:	85 c0                	test   %eax,%eax
  802936:	79 74                	jns    8029ac <realloc+0xc3>
  802938:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  80293f:	77 6b                	ja     8029ac <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  802941:	83 ec 0c             	sub    $0xc,%esp
  802944:	ff 75 0c             	pushl  0xc(%ebp)
  802947:	e8 7d f1 ff ff       	call   801ac9 <malloc>
  80294c:	83 c4 10             	add    $0x10,%esp
  80294f:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  802952:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  802956:	75 0a                	jne    802962 <realloc+0x79>
			return NULL;
  802958:	b8 00 00 00 00       	mov    $0x0,%eax
  80295d:	e9 9f 05 00 00       	jmp    802f01 <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  802962:	83 ec 0c             	sub    $0xc,%esp
  802965:	ff 75 08             	pushl  0x8(%ebp)
  802968:	e8 e0 11 00 00       	call   803b4d <get_block_size>
  80296d:	83 c4 10             	add    $0x10,%esp
  802970:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  802973:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802976:	8b 45 0c             	mov    0xc(%ebp),%eax
  802979:	39 d0                	cmp    %edx,%eax
  80297b:	76 02                	jbe    80297f <realloc+0x96>
  80297d:	89 d0                	mov    %edx,%eax
  80297f:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  802982:	83 ec 04             	sub    $0x4,%esp
  802985:	ff 75 c0             	pushl  -0x40(%ebp)
  802988:	ff 75 08             	pushl  0x8(%ebp)
  80298b:	ff 75 c8             	pushl  -0x38(%ebp)
  80298e:	e8 56 eb ff ff       	call   8014e9 <memmove>
  802993:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  802996:	83 ec 0c             	sub    $0xc,%esp
  802999:	ff 75 08             	pushl  0x8(%ebp)
  80299c:	e8 88 f4 ff ff       	call   801e29 <free>
  8029a1:	83 c4 10             	add    $0x10,%esp
		return newptr;
  8029a4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8029a7:	e9 55 05 00 00       	jmp    802f01 <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  8029ac:	a1 30 61 83 00       	mov    0x836130,%eax
  8029b1:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  8029b4:	72 09                	jb     8029bf <realloc+0xd6>
  8029b6:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  8029bd:	76 0a                	jbe    8029c9 <realloc+0xe0>
		return NULL;
  8029bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8029c4:	e9 38 05 00 00       	jmp    802f01 <realloc+0x618>
	uint32 oldsz = 0;
  8029c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  8029d0:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8029d7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8029de:	eb 50                	jmp    802a30 <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  8029e0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029e3:	89 d0                	mov    %edx,%eax
  8029e5:	01 c0                	add    %eax,%eax
  8029e7:	01 d0                	add    %edx,%eax
  8029e9:	c1 e0 02             	shl    $0x2,%eax
  8029ec:	05 48 60 80 00       	add    $0x806048,%eax
  8029f1:	8a 00                	mov    (%eax),%al
  8029f3:	84 c0                	test   %al,%al
  8029f5:	74 36                	je     802a2d <realloc+0x144>
  8029f7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029fa:	89 d0                	mov    %edx,%eax
  8029fc:	01 c0                	add    %eax,%eax
  8029fe:	01 d0                	add    %edx,%eax
  802a00:	c1 e0 02             	shl    $0x2,%eax
  802a03:	05 40 60 80 00       	add    $0x806040,%eax
  802a08:	8b 00                	mov    (%eax),%eax
  802a0a:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  802a0d:	75 1e                	jne    802a2d <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  802a0f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a12:	89 d0                	mov    %edx,%eax
  802a14:	01 c0                	add    %eax,%eax
  802a16:	01 d0                	add    %edx,%eax
  802a18:	c1 e0 02             	shl    $0x2,%eax
  802a1b:	05 44 60 80 00       	add    $0x806044,%eax
  802a20:	8b 00                	mov    (%eax),%eax
  802a22:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  802a25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a28:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802a2b:	eb 0c                	jmp    802a39 <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802a2d:	ff 45 ec             	incl   -0x14(%ebp)
  802a30:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802a37:	7e a7                	jle    8029e0 <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  802a39:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802a3d:	75 0a                	jne    802a49 <realloc+0x160>
		return NULL;
  802a3f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a44:	e9 b8 04 00 00       	jmp    802f01 <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  802a49:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  802a50:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a53:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802a56:	01 d0                	add    %edx,%eax
  802a58:	48                   	dec    %eax
  802a59:	89 45 b8             	mov    %eax,-0x48(%ebp)
  802a5c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802a5f:	ba 00 00 00 00       	mov    $0x0,%edx
  802a64:	f7 75 bc             	divl   -0x44(%ebp)
  802a67:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802a6a:	29 d0                	sub    %edx,%eax
  802a6c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  802a6f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a72:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802a75:	75 08                	jne    802a7f <realloc+0x196>
		return virtual_address;
  802a77:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7a:	e9 82 04 00 00       	jmp    802f01 <realloc+0x618>
	if (req < oldsz)
  802a7f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a82:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802a85:	0f 83 cd 02 00 00    	jae    802d58 <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  802a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8e:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  802a91:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  802a94:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a97:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a9a:	01 d0                	add    %edx,%eax
  802a9c:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  802a9f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802aa2:	89 d0                	mov    %edx,%eax
  802aa4:	01 c0                	add    %eax,%eax
  802aa6:	01 d0                	add    %edx,%eax
  802aa8:	c1 e0 02             	shl    $0x2,%eax
  802aab:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802ab1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ab4:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  802ab6:	83 ec 08             	sub    $0x8,%esp
  802ab9:	ff 75 b0             	pushl  -0x50(%ebp)
  802abc:	ff 75 ac             	pushl  -0x54(%ebp)
  802abf:	e8 e3 0c 00 00       	call   8037a7 <sys_free_user_mem>
  802ac4:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  802ac7:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802ace:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  802ad5:	eb 64                	jmp    802b3b <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  802ad7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ada:	89 d0                	mov    %edx,%eax
  802adc:	01 c0                	add    %eax,%eax
  802ade:	01 d0                	add    %edx,%eax
  802ae0:	c1 e0 02             	shl    $0x2,%eax
  802ae3:	05 48 20 81 00       	add    $0x812048,%eax
  802ae8:	8a 00                	mov    (%eax),%al
  802aea:	84 c0                	test   %al,%al
  802aec:	75 4a                	jne    802b38 <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  802aee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802af1:	89 d0                	mov    %edx,%eax
  802af3:	01 c0                	add    %eax,%eax
  802af5:	01 d0                	add    %edx,%eax
  802af7:	c1 e0 02             	shl    $0x2,%eax
  802afa:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  802b00:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802b03:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  802b05:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b08:	89 d0                	mov    %edx,%eax
  802b0a:	01 c0                	add    %eax,%eax
  802b0c:	01 d0                	add    %edx,%eax
  802b0e:	c1 e0 02             	shl    $0x2,%eax
  802b11:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  802b17:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b1a:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  802b1c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b1f:	89 d0                	mov    %edx,%eax
  802b21:	01 c0                	add    %eax,%eax
  802b23:	01 d0                	add    %edx,%eax
  802b25:	c1 e0 02             	shl    $0x2,%eax
  802b28:	05 48 20 81 00       	add    $0x812048,%eax
  802b2d:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  802b30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b33:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  802b36:	eb 0c                	jmp    802b44 <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802b38:	ff 45 e4             	incl   -0x1c(%ebp)
  802b3b:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  802b42:	7e 93                	jle    802ad7 <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  802b44:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802b48:	0f 84 8d 01 00 00    	je     802cdb <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802b4e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802b55:	e9 74 01 00 00       	jmp    802cce <realloc+0x3e5>
			{
				if (k == fidx) continue;
  802b5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b5d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802b60:	0f 84 64 01 00 00    	je     802cca <realloc+0x3e1>
				if (uhp_frees[k].free)
  802b66:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b69:	89 d0                	mov    %edx,%eax
  802b6b:	01 c0                	add    %eax,%eax
  802b6d:	01 d0                	add    %edx,%eax
  802b6f:	c1 e0 02             	shl    $0x2,%eax
  802b72:	05 48 20 81 00       	add    $0x812048,%eax
  802b77:	8a 00                	mov    (%eax),%al
  802b79:	84 c0                	test   %al,%al
  802b7b:	0f 84 4a 01 00 00    	je     802ccb <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802b81:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b84:	89 d0                	mov    %edx,%eax
  802b86:	01 c0                	add    %eax,%eax
  802b88:	01 d0                	add    %edx,%eax
  802b8a:	c1 e0 02             	shl    $0x2,%eax
  802b8d:	05 40 20 81 00       	add    $0x812040,%eax
  802b92:	8b 08                	mov    (%eax),%ecx
  802b94:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b97:	89 d0                	mov    %edx,%eax
  802b99:	01 c0                	add    %eax,%eax
  802b9b:	01 d0                	add    %edx,%eax
  802b9d:	c1 e0 02             	shl    $0x2,%eax
  802ba0:	05 44 20 81 00       	add    $0x812044,%eax
  802ba5:	8b 00                	mov    (%eax),%eax
  802ba7:	01 c1                	add    %eax,%ecx
  802ba9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bac:	89 d0                	mov    %edx,%eax
  802bae:	01 c0                	add    %eax,%eax
  802bb0:	01 d0                	add    %edx,%eax
  802bb2:	c1 e0 02             	shl    $0x2,%eax
  802bb5:	05 40 20 81 00       	add    $0x812040,%eax
  802bba:	8b 00                	mov    (%eax),%eax
  802bbc:	39 c1                	cmp    %eax,%ecx
  802bbe:	75 7a                	jne    802c3a <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  802bc0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802bc3:	89 d0                	mov    %edx,%eax
  802bc5:	01 c0                	add    %eax,%eax
  802bc7:	01 d0                	add    %edx,%eax
  802bc9:	c1 e0 02             	shl    $0x2,%eax
  802bcc:	05 40 20 81 00       	add    $0x812040,%eax
  802bd1:	8b 10                	mov    (%eax),%edx
  802bd3:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  802bd6:	89 c8                	mov    %ecx,%eax
  802bd8:	01 c0                	add    %eax,%eax
  802bda:	01 c8                	add    %ecx,%eax
  802bdc:	c1 e0 02             	shl    $0x2,%eax
  802bdf:	05 40 20 81 00       	add    $0x812040,%eax
  802be4:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  802be6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802be9:	89 d0                	mov    %edx,%eax
  802beb:	01 c0                	add    %eax,%eax
  802bed:	01 d0                	add    %edx,%eax
  802bef:	c1 e0 02             	shl    $0x2,%eax
  802bf2:	05 44 20 81 00       	add    $0x812044,%eax
  802bf7:	8b 08                	mov    (%eax),%ecx
  802bf9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802bfc:	89 d0                	mov    %edx,%eax
  802bfe:	01 c0                	add    %eax,%eax
  802c00:	01 d0                	add    %edx,%eax
  802c02:	c1 e0 02             	shl    $0x2,%eax
  802c05:	05 44 20 81 00       	add    $0x812044,%eax
  802c0a:	8b 00                	mov    (%eax),%eax
  802c0c:	01 c1                	add    %eax,%ecx
  802c0e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c11:	89 d0                	mov    %edx,%eax
  802c13:	01 c0                	add    %eax,%eax
  802c15:	01 d0                	add    %edx,%eax
  802c17:	c1 e0 02             	shl    $0x2,%eax
  802c1a:	05 44 20 81 00       	add    $0x812044,%eax
  802c1f:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802c21:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c24:	89 d0                	mov    %edx,%eax
  802c26:	01 c0                	add    %eax,%eax
  802c28:	01 d0                	add    %edx,%eax
  802c2a:	c1 e0 02             	shl    $0x2,%eax
  802c2d:	05 48 20 81 00       	add    $0x812048,%eax
  802c32:	c6 00 00             	movb   $0x0,(%eax)
  802c35:	e9 91 00 00 00       	jmp    802ccb <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802c3a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c3d:	89 d0                	mov    %edx,%eax
  802c3f:	01 c0                	add    %eax,%eax
  802c41:	01 d0                	add    %edx,%eax
  802c43:	c1 e0 02             	shl    $0x2,%eax
  802c46:	05 40 20 81 00       	add    $0x812040,%eax
  802c4b:	8b 08                	mov    (%eax),%ecx
  802c4d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c50:	89 d0                	mov    %edx,%eax
  802c52:	01 c0                	add    %eax,%eax
  802c54:	01 d0                	add    %edx,%eax
  802c56:	c1 e0 02             	shl    $0x2,%eax
  802c59:	05 44 20 81 00       	add    $0x812044,%eax
  802c5e:	8b 00                	mov    (%eax),%eax
  802c60:	01 c1                	add    %eax,%ecx
  802c62:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c65:	89 d0                	mov    %edx,%eax
  802c67:	01 c0                	add    %eax,%eax
  802c69:	01 d0                	add    %edx,%eax
  802c6b:	c1 e0 02             	shl    $0x2,%eax
  802c6e:	05 40 20 81 00       	add    $0x812040,%eax
  802c73:	8b 00                	mov    (%eax),%eax
  802c75:	39 c1                	cmp    %eax,%ecx
  802c77:	75 52                	jne    802ccb <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  802c79:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c7c:	89 d0                	mov    %edx,%eax
  802c7e:	01 c0                	add    %eax,%eax
  802c80:	01 d0                	add    %edx,%eax
  802c82:	c1 e0 02             	shl    $0x2,%eax
  802c85:	05 44 20 81 00       	add    $0x812044,%eax
  802c8a:	8b 08                	mov    (%eax),%ecx
  802c8c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c8f:	89 d0                	mov    %edx,%eax
  802c91:	01 c0                	add    %eax,%eax
  802c93:	01 d0                	add    %edx,%eax
  802c95:	c1 e0 02             	shl    $0x2,%eax
  802c98:	05 44 20 81 00       	add    $0x812044,%eax
  802c9d:	8b 00                	mov    (%eax),%eax
  802c9f:	01 c1                	add    %eax,%ecx
  802ca1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ca4:	89 d0                	mov    %edx,%eax
  802ca6:	01 c0                	add    %eax,%eax
  802ca8:	01 d0                	add    %edx,%eax
  802caa:	c1 e0 02             	shl    $0x2,%eax
  802cad:	05 44 20 81 00       	add    $0x812044,%eax
  802cb2:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802cb4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cb7:	89 d0                	mov    %edx,%eax
  802cb9:	01 c0                	add    %eax,%eax
  802cbb:	01 d0                	add    %edx,%eax
  802cbd:	c1 e0 02             	shl    $0x2,%eax
  802cc0:	05 48 20 81 00       	add    $0x812048,%eax
  802cc5:	c6 00 00             	movb   $0x0,(%eax)
  802cc8:	eb 01                	jmp    802ccb <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  802cca:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802ccb:	ff 45 e0             	incl   -0x20(%ebp)
  802cce:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802cd5:	0f 8e 7f fe ff ff    	jle    802b5a <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  802cdb:	a1 30 61 83 00       	mov    0x836130,%eax
  802ce0:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802ce3:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  802cea:	eb 53                	jmp    802d3f <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  802cec:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802cef:	89 d0                	mov    %edx,%eax
  802cf1:	01 c0                	add    %eax,%eax
  802cf3:	01 d0                	add    %edx,%eax
  802cf5:	c1 e0 02             	shl    $0x2,%eax
  802cf8:	05 48 60 80 00       	add    $0x806048,%eax
  802cfd:	8a 00                	mov    (%eax),%al
  802cff:	84 c0                	test   %al,%al
  802d01:	74 39                	je     802d3c <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802d03:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802d06:	89 d0                	mov    %edx,%eax
  802d08:	01 c0                	add    %eax,%eax
  802d0a:	01 d0                	add    %edx,%eax
  802d0c:	c1 e0 02             	shl    $0x2,%eax
  802d0f:	05 40 60 80 00       	add    $0x806040,%eax
  802d14:	8b 08                	mov    (%eax),%ecx
  802d16:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802d19:	89 d0                	mov    %edx,%eax
  802d1b:	01 c0                	add    %eax,%eax
  802d1d:	01 d0                	add    %edx,%eax
  802d1f:	c1 e0 02             	shl    $0x2,%eax
  802d22:	05 44 60 80 00       	add    $0x806044,%eax
  802d27:	8b 00                	mov    (%eax),%eax
  802d29:	01 c8                	add    %ecx,%eax
  802d2b:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  802d2e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802d31:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802d34:	76 06                	jbe    802d3c <realloc+0x453>
  802d36:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802d39:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802d3c:	ff 45 d8             	incl   -0x28(%ebp)
  802d3f:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  802d46:	7e a4                	jle    802cec <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  802d48:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d4b:	a3 88 60 83 00       	mov    %eax,0x836088
		return virtual_address;
  802d50:	8b 45 08             	mov    0x8(%ebp),%eax
  802d53:	e9 a9 01 00 00       	jmp    802f01 <realloc+0x618>
	}
	uint32 end = va + oldsz;
  802d58:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802d5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5e:	01 d0                	add    %edx,%eax
  802d60:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  802d63:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802d6a:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  802d71:	eb 57                	jmp    802dca <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  802d73:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802d76:	89 d0                	mov    %edx,%eax
  802d78:	01 c0                	add    %eax,%eax
  802d7a:	01 d0                	add    %edx,%eax
  802d7c:	c1 e0 02             	shl    $0x2,%eax
  802d7f:	05 48 20 81 00       	add    $0x812048,%eax
  802d84:	8a 00                	mov    (%eax),%al
  802d86:	84 c0                	test   %al,%al
  802d88:	74 3d                	je     802dc7 <realloc+0x4de>
  802d8a:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802d8d:	89 d0                	mov    %edx,%eax
  802d8f:	01 c0                	add    %eax,%eax
  802d91:	01 d0                	add    %edx,%eax
  802d93:	c1 e0 02             	shl    $0x2,%eax
  802d96:	05 40 20 81 00       	add    $0x812040,%eax
  802d9b:	8b 00                	mov    (%eax),%eax
  802d9d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802da0:	75 25                	jne    802dc7 <realloc+0x4de>
  802da2:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802da5:	89 d0                	mov    %edx,%eax
  802da7:	01 c0                	add    %eax,%eax
  802da9:	01 d0                	add    %edx,%eax
  802dab:	c1 e0 02             	shl    $0x2,%eax
  802dae:	05 44 20 81 00       	add    $0x812044,%eax
  802db3:	8b 10                	mov    (%eax),%edx
  802db5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802db8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802dbb:	39 c2                	cmp    %eax,%edx
  802dbd:	72 08                	jb     802dc7 <realloc+0x4de>
		{
			adjIdx = j; break;
  802dbf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802dc2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802dc5:	eb 0c                	jmp    802dd3 <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802dc7:	ff 45 d0             	incl   -0x30(%ebp)
  802dca:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  802dd1:	7e a0                	jle    802d73 <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  802dd3:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  802dd7:	0f 84 d6 00 00 00    	je     802eb3 <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  802ddd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802de0:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802de3:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  802de6:	83 ec 08             	sub    $0x8,%esp
  802de9:	ff 75 a0             	pushl  -0x60(%ebp)
  802dec:	ff 75 a4             	pushl  -0x5c(%ebp)
  802def:	e8 cf 09 00 00       	call   8037c3 <sys_allocate_user_mem>
  802df4:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  802df7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dfa:	89 d0                	mov    %edx,%eax
  802dfc:	01 c0                	add    %eax,%eax
  802dfe:	01 d0                	add    %edx,%eax
  802e00:	c1 e0 02             	shl    $0x2,%eax
  802e03:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802e09:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e0c:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  802e0e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802e11:	89 d0                	mov    %edx,%eax
  802e13:	01 c0                	add    %eax,%eax
  802e15:	01 d0                	add    %edx,%eax
  802e17:	c1 e0 02             	shl    $0x2,%eax
  802e1a:	05 40 20 81 00       	add    $0x812040,%eax
  802e1f:	8b 10                	mov    (%eax),%edx
  802e21:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802e24:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802e27:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802e2a:	89 d0                	mov    %edx,%eax
  802e2c:	01 c0                	add    %eax,%eax
  802e2e:	01 d0                	add    %edx,%eax
  802e30:	c1 e0 02             	shl    $0x2,%eax
  802e33:	05 40 20 81 00       	add    $0x812040,%eax
  802e38:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  802e3a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802e3d:	89 d0                	mov    %edx,%eax
  802e3f:	01 c0                	add    %eax,%eax
  802e41:	01 d0                	add    %edx,%eax
  802e43:	c1 e0 02             	shl    $0x2,%eax
  802e46:	05 44 20 81 00       	add    $0x812044,%eax
  802e4b:	8b 00                	mov    (%eax),%eax
  802e4d:	2b 45 a0             	sub    -0x60(%ebp),%eax
  802e50:	89 c2                	mov    %eax,%edx
  802e52:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  802e55:	89 c8                	mov    %ecx,%eax
  802e57:	01 c0                	add    %eax,%eax
  802e59:	01 c8                	add    %ecx,%eax
  802e5b:	c1 e0 02             	shl    $0x2,%eax
  802e5e:	05 44 20 81 00       	add    $0x812044,%eax
  802e63:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  802e65:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802e68:	89 d0                	mov    %edx,%eax
  802e6a:	01 c0                	add    %eax,%eax
  802e6c:	01 d0                	add    %edx,%eax
  802e6e:	c1 e0 02             	shl    $0x2,%eax
  802e71:	05 44 20 81 00       	add    $0x812044,%eax
  802e76:	8b 00                	mov    (%eax),%eax
  802e78:	85 c0                	test   %eax,%eax
  802e7a:	75 14                	jne    802e90 <realloc+0x5a7>
  802e7c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802e7f:	89 d0                	mov    %edx,%eax
  802e81:	01 c0                	add    %eax,%eax
  802e83:	01 d0                	add    %edx,%eax
  802e85:	c1 e0 02             	shl    $0x2,%eax
  802e88:	05 48 20 81 00       	add    $0x812048,%eax
  802e8d:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  802e90:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802e93:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e96:	01 c2                	add    %eax,%edx
  802e98:	a1 88 60 83 00       	mov    0x836088,%eax
  802e9d:	39 c2                	cmp    %eax,%edx
  802e9f:	76 0d                	jbe    802eae <realloc+0x5c5>
  802ea1:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ea4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ea7:	01 d0                	add    %edx,%eax
  802ea9:	a3 88 60 83 00       	mov    %eax,0x836088
		return virtual_address;
  802eae:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb1:	eb 4e                	jmp    802f01 <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  802eb3:	83 ec 0c             	sub    $0xc,%esp
  802eb6:	ff 75 0c             	pushl  0xc(%ebp)
  802eb9:	e8 0b ec ff ff       	call   801ac9 <malloc>
  802ebe:	83 c4 10             	add    $0x10,%esp
  802ec1:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  802ec4:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  802ec8:	75 07                	jne    802ed1 <realloc+0x5e8>
		return NULL;
  802eca:	b8 00 00 00 00       	mov    $0x0,%eax
  802ecf:	eb 30                	jmp    802f01 <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  802ed1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ed4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ed7:	39 d0                	cmp    %edx,%eax
  802ed9:	76 02                	jbe    802edd <realloc+0x5f4>
  802edb:	89 d0                	mov    %edx,%eax
  802edd:	8b 55 9c             	mov    -0x64(%ebp),%edx
  802ee0:	83 ec 04             	sub    $0x4,%esp
  802ee3:	50                   	push   %eax
  802ee4:	52                   	push   %edx
  802ee5:	ff 75 cc             	pushl  -0x34(%ebp)
  802ee8:	e8 cf 06 00 00       	call   8035bc <sys_move_user_mem>
  802eed:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  802ef0:	83 ec 0c             	sub    $0xc,%esp
  802ef3:	ff 75 08             	pushl  0x8(%ebp)
  802ef6:	e8 2e ef ff ff       	call   801e29 <free>
  802efb:	83 c4 10             	add    $0x10,%esp
	return newptr;
  802efe:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  802f01:	c9                   	leave  
  802f02:	c3                   	ret    

00802f03 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802f03:	55                   	push   %ebp
  802f04:	89 e5                	mov    %esp,%ebp
  802f06:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  802f09:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0c:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  802f0f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f13:	0f 84 33 03 00 00    	je     80324c <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  802f19:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f1c:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  802f21:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  802f24:	83 ec 08             	sub    $0x8,%esp
  802f27:	ff 75 08             	pushl  0x8(%ebp)
  802f2a:	ff 75 d8             	pushl  -0x28(%ebp)
  802f2d:	e8 7d 05 00 00       	call   8034af <sys_delete_shared_object>
  802f32:	83 c4 10             	add    $0x10,%esp
  802f35:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  802f38:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802f3c:	0f 88 0d 03 00 00    	js     80324f <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802f42:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802f49:	e9 ef 02 00 00       	jmp    80323d <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802f4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f51:	89 d0                	mov    %edx,%eax
  802f53:	01 c0                	add    %eax,%eax
  802f55:	01 d0                	add    %edx,%eax
  802f57:	c1 e0 02             	shl    $0x2,%eax
  802f5a:	05 48 60 80 00       	add    $0x806048,%eax
  802f5f:	8a 00                	mov    (%eax),%al
  802f61:	84 c0                	test   %al,%al
  802f63:	0f 84 d1 02 00 00    	je     80323a <sfree+0x337>
  802f69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f6c:	89 d0                	mov    %edx,%eax
  802f6e:	01 c0                	add    %eax,%eax
  802f70:	01 d0                	add    %edx,%eax
  802f72:	c1 e0 02             	shl    $0x2,%eax
  802f75:	05 40 60 80 00       	add    $0x806040,%eax
  802f7a:	8b 00                	mov    (%eax),%eax
  802f7c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802f7f:	0f 85 b5 02 00 00    	jne    80323a <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  802f85:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f88:	89 d0                	mov    %edx,%eax
  802f8a:	01 c0                	add    %eax,%eax
  802f8c:	01 d0                	add    %edx,%eax
  802f8e:	c1 e0 02             	shl    $0x2,%eax
  802f91:	05 44 60 80 00       	add    $0x806044,%eax
  802f96:	8b 00                	mov    (%eax),%eax
  802f98:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  802f9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f9e:	89 d0                	mov    %edx,%eax
  802fa0:	01 c0                	add    %eax,%eax
  802fa2:	01 d0                	add    %edx,%eax
  802fa4:	c1 e0 02             	shl    $0x2,%eax
  802fa7:	05 48 60 80 00       	add    $0x806048,%eax
  802fac:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  802faf:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802fb6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802fbd:	eb 64                	jmp    803023 <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  802fbf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802fc2:	89 d0                	mov    %edx,%eax
  802fc4:	01 c0                	add    %eax,%eax
  802fc6:	01 d0                	add    %edx,%eax
  802fc8:	c1 e0 02             	shl    $0x2,%eax
  802fcb:	05 48 20 81 00       	add    $0x812048,%eax
  802fd0:	8a 00                	mov    (%eax),%al
  802fd2:	84 c0                	test   %al,%al
  802fd4:	75 4a                	jne    803020 <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  802fd6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802fd9:	89 d0                	mov    %edx,%eax
  802fdb:	01 c0                	add    %eax,%eax
  802fdd:	01 d0                	add    %edx,%eax
  802fdf:	c1 e0 02             	shl    $0x2,%eax
  802fe2:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  802fe8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802feb:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  802fed:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ff0:	89 d0                	mov    %edx,%eax
  802ff2:	01 c0                	add    %eax,%eax
  802ff4:	01 d0                	add    %edx,%eax
  802ff6:	c1 e0 02             	shl    $0x2,%eax
  802ff9:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  802fff:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803002:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  803004:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803007:	89 d0                	mov    %edx,%eax
  803009:	01 c0                	add    %eax,%eax
  80300b:	01 d0                	add    %edx,%eax
  80300d:	c1 e0 02             	shl    $0x2,%eax
  803010:	05 48 20 81 00       	add    $0x812048,%eax
  803015:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  803018:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80301b:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  80301e:	eb 0c                	jmp    80302c <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  803020:	ff 45 ec             	incl   -0x14(%ebp)
  803023:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  80302a:	7e 93                	jle    802fbf <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  80302c:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  803030:	0f 84 8d 01 00 00    	je     8031c3 <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  803036:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80303d:	e9 74 01 00 00       	jmp    8031b6 <sfree+0x2b3>
				{
					if (k == fidx) continue;
  803042:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803045:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803048:	0f 84 64 01 00 00    	je     8031b2 <sfree+0x2af>
					if (uhp_frees[k].free)
  80304e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803051:	89 d0                	mov    %edx,%eax
  803053:	01 c0                	add    %eax,%eax
  803055:	01 d0                	add    %edx,%eax
  803057:	c1 e0 02             	shl    $0x2,%eax
  80305a:	05 48 20 81 00       	add    $0x812048,%eax
  80305f:	8a 00                	mov    (%eax),%al
  803061:	84 c0                	test   %al,%al
  803063:	0f 84 4a 01 00 00    	je     8031b3 <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  803069:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80306c:	89 d0                	mov    %edx,%eax
  80306e:	01 c0                	add    %eax,%eax
  803070:	01 d0                	add    %edx,%eax
  803072:	c1 e0 02             	shl    $0x2,%eax
  803075:	05 40 20 81 00       	add    $0x812040,%eax
  80307a:	8b 08                	mov    (%eax),%ecx
  80307c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80307f:	89 d0                	mov    %edx,%eax
  803081:	01 c0                	add    %eax,%eax
  803083:	01 d0                	add    %edx,%eax
  803085:	c1 e0 02             	shl    $0x2,%eax
  803088:	05 44 20 81 00       	add    $0x812044,%eax
  80308d:	8b 00                	mov    (%eax),%eax
  80308f:	01 c1                	add    %eax,%ecx
  803091:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803094:	89 d0                	mov    %edx,%eax
  803096:	01 c0                	add    %eax,%eax
  803098:	01 d0                	add    %edx,%eax
  80309a:	c1 e0 02             	shl    $0x2,%eax
  80309d:	05 40 20 81 00       	add    $0x812040,%eax
  8030a2:	8b 00                	mov    (%eax),%eax
  8030a4:	39 c1                	cmp    %eax,%ecx
  8030a6:	75 7a                	jne    803122 <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  8030a8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030ab:	89 d0                	mov    %edx,%eax
  8030ad:	01 c0                	add    %eax,%eax
  8030af:	01 d0                	add    %edx,%eax
  8030b1:	c1 e0 02             	shl    $0x2,%eax
  8030b4:	05 40 20 81 00       	add    $0x812040,%eax
  8030b9:	8b 10                	mov    (%eax),%edx
  8030bb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8030be:	89 c8                	mov    %ecx,%eax
  8030c0:	01 c0                	add    %eax,%eax
  8030c2:	01 c8                	add    %ecx,%eax
  8030c4:	c1 e0 02             	shl    $0x2,%eax
  8030c7:	05 40 20 81 00       	add    $0x812040,%eax
  8030cc:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  8030ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030d1:	89 d0                	mov    %edx,%eax
  8030d3:	01 c0                	add    %eax,%eax
  8030d5:	01 d0                	add    %edx,%eax
  8030d7:	c1 e0 02             	shl    $0x2,%eax
  8030da:	05 44 20 81 00       	add    $0x812044,%eax
  8030df:	8b 08                	mov    (%eax),%ecx
  8030e1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030e4:	89 d0                	mov    %edx,%eax
  8030e6:	01 c0                	add    %eax,%eax
  8030e8:	01 d0                	add    %edx,%eax
  8030ea:	c1 e0 02             	shl    $0x2,%eax
  8030ed:	05 44 20 81 00       	add    $0x812044,%eax
  8030f2:	8b 00                	mov    (%eax),%eax
  8030f4:	01 c1                	add    %eax,%ecx
  8030f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030f9:	89 d0                	mov    %edx,%eax
  8030fb:	01 c0                	add    %eax,%eax
  8030fd:	01 d0                	add    %edx,%eax
  8030ff:	c1 e0 02             	shl    $0x2,%eax
  803102:	05 44 20 81 00       	add    $0x812044,%eax
  803107:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  803109:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80310c:	89 d0                	mov    %edx,%eax
  80310e:	01 c0                	add    %eax,%eax
  803110:	01 d0                	add    %edx,%eax
  803112:	c1 e0 02             	shl    $0x2,%eax
  803115:	05 48 20 81 00       	add    $0x812048,%eax
  80311a:	c6 00 00             	movb   $0x0,(%eax)
  80311d:	e9 91 00 00 00       	jmp    8031b3 <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  803122:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803125:	89 d0                	mov    %edx,%eax
  803127:	01 c0                	add    %eax,%eax
  803129:	01 d0                	add    %edx,%eax
  80312b:	c1 e0 02             	shl    $0x2,%eax
  80312e:	05 40 20 81 00       	add    $0x812040,%eax
  803133:	8b 08                	mov    (%eax),%ecx
  803135:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803138:	89 d0                	mov    %edx,%eax
  80313a:	01 c0                	add    %eax,%eax
  80313c:	01 d0                	add    %edx,%eax
  80313e:	c1 e0 02             	shl    $0x2,%eax
  803141:	05 44 20 81 00       	add    $0x812044,%eax
  803146:	8b 00                	mov    (%eax),%eax
  803148:	01 c1                	add    %eax,%ecx
  80314a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80314d:	89 d0                	mov    %edx,%eax
  80314f:	01 c0                	add    %eax,%eax
  803151:	01 d0                	add    %edx,%eax
  803153:	c1 e0 02             	shl    $0x2,%eax
  803156:	05 40 20 81 00       	add    $0x812040,%eax
  80315b:	8b 00                	mov    (%eax),%eax
  80315d:	39 c1                	cmp    %eax,%ecx
  80315f:	75 52                	jne    8031b3 <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  803161:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803164:	89 d0                	mov    %edx,%eax
  803166:	01 c0                	add    %eax,%eax
  803168:	01 d0                	add    %edx,%eax
  80316a:	c1 e0 02             	shl    $0x2,%eax
  80316d:	05 44 20 81 00       	add    $0x812044,%eax
  803172:	8b 08                	mov    (%eax),%ecx
  803174:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803177:	89 d0                	mov    %edx,%eax
  803179:	01 c0                	add    %eax,%eax
  80317b:	01 d0                	add    %edx,%eax
  80317d:	c1 e0 02             	shl    $0x2,%eax
  803180:	05 44 20 81 00       	add    $0x812044,%eax
  803185:	8b 00                	mov    (%eax),%eax
  803187:	01 c1                	add    %eax,%ecx
  803189:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80318c:	89 d0                	mov    %edx,%eax
  80318e:	01 c0                	add    %eax,%eax
  803190:	01 d0                	add    %edx,%eax
  803192:	c1 e0 02             	shl    $0x2,%eax
  803195:	05 44 20 81 00       	add    $0x812044,%eax
  80319a:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  80319c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80319f:	89 d0                	mov    %edx,%eax
  8031a1:	01 c0                	add    %eax,%eax
  8031a3:	01 d0                	add    %edx,%eax
  8031a5:	c1 e0 02             	shl    $0x2,%eax
  8031a8:	05 48 20 81 00       	add    $0x812048,%eax
  8031ad:	c6 00 00             	movb   $0x0,(%eax)
  8031b0:	eb 01                	jmp    8031b3 <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  8031b2:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  8031b3:	ff 45 e8             	incl   -0x18(%ebp)
  8031b6:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8031bd:	0f 8e 7f fe ff ff    	jle    803042 <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  8031c3:	a1 30 61 83 00       	mov    0x836130,%eax
  8031c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  8031cb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8031d2:	eb 53                	jmp    803227 <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  8031d4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031d7:	89 d0                	mov    %edx,%eax
  8031d9:	01 c0                	add    %eax,%eax
  8031db:	01 d0                	add    %edx,%eax
  8031dd:	c1 e0 02             	shl    $0x2,%eax
  8031e0:	05 48 60 80 00       	add    $0x806048,%eax
  8031e5:	8a 00                	mov    (%eax),%al
  8031e7:	84 c0                	test   %al,%al
  8031e9:	74 39                	je     803224 <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  8031eb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031ee:	89 d0                	mov    %edx,%eax
  8031f0:	01 c0                	add    %eax,%eax
  8031f2:	01 d0                	add    %edx,%eax
  8031f4:	c1 e0 02             	shl    $0x2,%eax
  8031f7:	05 40 60 80 00       	add    $0x806040,%eax
  8031fc:	8b 08                	mov    (%eax),%ecx
  8031fe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803201:	89 d0                	mov    %edx,%eax
  803203:	01 c0                	add    %eax,%eax
  803205:	01 d0                	add    %edx,%eax
  803207:	c1 e0 02             	shl    $0x2,%eax
  80320a:	05 44 60 80 00       	add    $0x806044,%eax
  80320f:	8b 00                	mov    (%eax),%eax
  803211:	01 c8                	add    %ecx,%eax
  803213:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  803216:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803219:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80321c:	76 06                	jbe    803224 <sfree+0x321>
  80321e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803221:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  803224:	ff 45 e0             	incl   -0x20(%ebp)
  803227:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80322e:	7e a4                	jle    8031d4 <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  803230:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803233:	a3 88 60 83 00       	mov    %eax,0x836088
			break;
  803238:	eb 16                	jmp    803250 <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80323a:	ff 45 f4             	incl   -0xc(%ebp)
  80323d:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  803244:	0f 8e 04 fd ff ff    	jle    802f4e <sfree+0x4b>
  80324a:	eb 04                	jmp    803250 <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  80324c:	90                   	nop
  80324d:	eb 01                	jmp    803250 <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  80324f:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  803250:	c9                   	leave  
  803251:	c3                   	ret    

00803252 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  803252:	55                   	push   %ebp
  803253:	89 e5                	mov    %esp,%ebp
  803255:	57                   	push   %edi
  803256:	56                   	push   %esi
  803257:	53                   	push   %ebx
  803258:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80325b:	8b 45 08             	mov    0x8(%ebp),%eax
  80325e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803261:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803264:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803267:	8b 7d 18             	mov    0x18(%ebp),%edi
  80326a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80326d:	cd 30                	int    $0x30
  80326f:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  803272:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  803275:	83 c4 10             	add    $0x10,%esp
  803278:	5b                   	pop    %ebx
  803279:	5e                   	pop    %esi
  80327a:	5f                   	pop    %edi
  80327b:	5d                   	pop    %ebp
  80327c:	c3                   	ret    

0080327d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80327d:	55                   	push   %ebp
  80327e:	89 e5                	mov    %esp,%ebp
  803280:	83 ec 04             	sub    $0x4,%esp
  803283:	8b 45 10             	mov    0x10(%ebp),%eax
  803286:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  803289:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80328c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803290:	8b 45 08             	mov    0x8(%ebp),%eax
  803293:	6a 00                	push   $0x0
  803295:	51                   	push   %ecx
  803296:	52                   	push   %edx
  803297:	ff 75 0c             	pushl  0xc(%ebp)
  80329a:	50                   	push   %eax
  80329b:	6a 00                	push   $0x0
  80329d:	e8 b0 ff ff ff       	call   803252 <syscall>
  8032a2:	83 c4 18             	add    $0x18,%esp
}
  8032a5:	90                   	nop
  8032a6:	c9                   	leave  
  8032a7:	c3                   	ret    

008032a8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8032a8:	55                   	push   %ebp
  8032a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8032ab:	6a 00                	push   $0x0
  8032ad:	6a 00                	push   $0x0
  8032af:	6a 00                	push   $0x0
  8032b1:	6a 00                	push   $0x0
  8032b3:	6a 00                	push   $0x0
  8032b5:	6a 02                	push   $0x2
  8032b7:	e8 96 ff ff ff       	call   803252 <syscall>
  8032bc:	83 c4 18             	add    $0x18,%esp
}
  8032bf:	c9                   	leave  
  8032c0:	c3                   	ret    

008032c1 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8032c1:	55                   	push   %ebp
  8032c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8032c4:	6a 00                	push   $0x0
  8032c6:	6a 00                	push   $0x0
  8032c8:	6a 00                	push   $0x0
  8032ca:	6a 00                	push   $0x0
  8032cc:	6a 00                	push   $0x0
  8032ce:	6a 03                	push   $0x3
  8032d0:	e8 7d ff ff ff       	call   803252 <syscall>
  8032d5:	83 c4 18             	add    $0x18,%esp
}
  8032d8:	90                   	nop
  8032d9:	c9                   	leave  
  8032da:	c3                   	ret    

008032db <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8032db:	55                   	push   %ebp
  8032dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8032de:	6a 00                	push   $0x0
  8032e0:	6a 00                	push   $0x0
  8032e2:	6a 00                	push   $0x0
  8032e4:	6a 00                	push   $0x0
  8032e6:	6a 00                	push   $0x0
  8032e8:	6a 04                	push   $0x4
  8032ea:	e8 63 ff ff ff       	call   803252 <syscall>
  8032ef:	83 c4 18             	add    $0x18,%esp
}
  8032f2:	90                   	nop
  8032f3:	c9                   	leave  
  8032f4:	c3                   	ret    

008032f5 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8032f5:	55                   	push   %ebp
  8032f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8032f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fe:	6a 00                	push   $0x0
  803300:	6a 00                	push   $0x0
  803302:	6a 00                	push   $0x0
  803304:	52                   	push   %edx
  803305:	50                   	push   %eax
  803306:	6a 08                	push   $0x8
  803308:	e8 45 ff ff ff       	call   803252 <syscall>
  80330d:	83 c4 18             	add    $0x18,%esp
}
  803310:	c9                   	leave  
  803311:	c3                   	ret    

00803312 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  803312:	55                   	push   %ebp
  803313:	89 e5                	mov    %esp,%ebp
  803315:	56                   	push   %esi
  803316:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  803317:	8b 75 18             	mov    0x18(%ebp),%esi
  80331a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80331d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803320:	8b 55 0c             	mov    0xc(%ebp),%edx
  803323:	8b 45 08             	mov    0x8(%ebp),%eax
  803326:	56                   	push   %esi
  803327:	53                   	push   %ebx
  803328:	51                   	push   %ecx
  803329:	52                   	push   %edx
  80332a:	50                   	push   %eax
  80332b:	6a 09                	push   $0x9
  80332d:	e8 20 ff ff ff       	call   803252 <syscall>
  803332:	83 c4 18             	add    $0x18,%esp
}
  803335:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803338:	5b                   	pop    %ebx
  803339:	5e                   	pop    %esi
  80333a:	5d                   	pop    %ebp
  80333b:	c3                   	ret    

0080333c <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80333c:	55                   	push   %ebp
  80333d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80333f:	6a 00                	push   $0x0
  803341:	6a 00                	push   $0x0
  803343:	6a 00                	push   $0x0
  803345:	6a 00                	push   $0x0
  803347:	ff 75 08             	pushl  0x8(%ebp)
  80334a:	6a 0a                	push   $0xa
  80334c:	e8 01 ff ff ff       	call   803252 <syscall>
  803351:	83 c4 18             	add    $0x18,%esp
}
  803354:	c9                   	leave  
  803355:	c3                   	ret    

00803356 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  803356:	55                   	push   %ebp
  803357:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  803359:	6a 00                	push   $0x0
  80335b:	6a 00                	push   $0x0
  80335d:	6a 00                	push   $0x0
  80335f:	ff 75 0c             	pushl  0xc(%ebp)
  803362:	ff 75 08             	pushl  0x8(%ebp)
  803365:	6a 0b                	push   $0xb
  803367:	e8 e6 fe ff ff       	call   803252 <syscall>
  80336c:	83 c4 18             	add    $0x18,%esp
}
  80336f:	c9                   	leave  
  803370:	c3                   	ret    

00803371 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  803371:	55                   	push   %ebp
  803372:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  803374:	6a 00                	push   $0x0
  803376:	6a 00                	push   $0x0
  803378:	6a 00                	push   $0x0
  80337a:	6a 00                	push   $0x0
  80337c:	6a 00                	push   $0x0
  80337e:	6a 0c                	push   $0xc
  803380:	e8 cd fe ff ff       	call   803252 <syscall>
  803385:	83 c4 18             	add    $0x18,%esp
}
  803388:	c9                   	leave  
  803389:	c3                   	ret    

0080338a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80338a:	55                   	push   %ebp
  80338b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80338d:	6a 00                	push   $0x0
  80338f:	6a 00                	push   $0x0
  803391:	6a 00                	push   $0x0
  803393:	6a 00                	push   $0x0
  803395:	6a 00                	push   $0x0
  803397:	6a 0d                	push   $0xd
  803399:	e8 b4 fe ff ff       	call   803252 <syscall>
  80339e:	83 c4 18             	add    $0x18,%esp
}
  8033a1:	c9                   	leave  
  8033a2:	c3                   	ret    

008033a3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8033a3:	55                   	push   %ebp
  8033a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8033a6:	6a 00                	push   $0x0
  8033a8:	6a 00                	push   $0x0
  8033aa:	6a 00                	push   $0x0
  8033ac:	6a 00                	push   $0x0
  8033ae:	6a 00                	push   $0x0
  8033b0:	6a 0e                	push   $0xe
  8033b2:	e8 9b fe ff ff       	call   803252 <syscall>
  8033b7:	83 c4 18             	add    $0x18,%esp
}
  8033ba:	c9                   	leave  
  8033bb:	c3                   	ret    

008033bc <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8033bc:	55                   	push   %ebp
  8033bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8033bf:	6a 00                	push   $0x0
  8033c1:	6a 00                	push   $0x0
  8033c3:	6a 00                	push   $0x0
  8033c5:	6a 00                	push   $0x0
  8033c7:	6a 00                	push   $0x0
  8033c9:	6a 0f                	push   $0xf
  8033cb:	e8 82 fe ff ff       	call   803252 <syscall>
  8033d0:	83 c4 18             	add    $0x18,%esp
}
  8033d3:	c9                   	leave  
  8033d4:	c3                   	ret    

008033d5 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8033d5:	55                   	push   %ebp
  8033d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8033d8:	6a 00                	push   $0x0
  8033da:	6a 00                	push   $0x0
  8033dc:	6a 00                	push   $0x0
  8033de:	6a 00                	push   $0x0
  8033e0:	ff 75 08             	pushl  0x8(%ebp)
  8033e3:	6a 10                	push   $0x10
  8033e5:	e8 68 fe ff ff       	call   803252 <syscall>
  8033ea:	83 c4 18             	add    $0x18,%esp
}
  8033ed:	c9                   	leave  
  8033ee:	c3                   	ret    

008033ef <sys_scarce_memory>:

void sys_scarce_memory()
{
  8033ef:	55                   	push   %ebp
  8033f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8033f2:	6a 00                	push   $0x0
  8033f4:	6a 00                	push   $0x0
  8033f6:	6a 00                	push   $0x0
  8033f8:	6a 00                	push   $0x0
  8033fa:	6a 00                	push   $0x0
  8033fc:	6a 11                	push   $0x11
  8033fe:	e8 4f fe ff ff       	call   803252 <syscall>
  803403:	83 c4 18             	add    $0x18,%esp
}
  803406:	90                   	nop
  803407:	c9                   	leave  
  803408:	c3                   	ret    

00803409 <sys_cputc>:

void
sys_cputc(const char c)
{
  803409:	55                   	push   %ebp
  80340a:	89 e5                	mov    %esp,%ebp
  80340c:	83 ec 04             	sub    $0x4,%esp
  80340f:	8b 45 08             	mov    0x8(%ebp),%eax
  803412:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  803415:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803419:	6a 00                	push   $0x0
  80341b:	6a 00                	push   $0x0
  80341d:	6a 00                	push   $0x0
  80341f:	6a 00                	push   $0x0
  803421:	50                   	push   %eax
  803422:	6a 01                	push   $0x1
  803424:	e8 29 fe ff ff       	call   803252 <syscall>
  803429:	83 c4 18             	add    $0x18,%esp
}
  80342c:	90                   	nop
  80342d:	c9                   	leave  
  80342e:	c3                   	ret    

0080342f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80342f:	55                   	push   %ebp
  803430:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  803432:	6a 00                	push   $0x0
  803434:	6a 00                	push   $0x0
  803436:	6a 00                	push   $0x0
  803438:	6a 00                	push   $0x0
  80343a:	6a 00                	push   $0x0
  80343c:	6a 14                	push   $0x14
  80343e:	e8 0f fe ff ff       	call   803252 <syscall>
  803443:	83 c4 18             	add    $0x18,%esp
}
  803446:	90                   	nop
  803447:	c9                   	leave  
  803448:	c3                   	ret    

00803449 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  803449:	55                   	push   %ebp
  80344a:	89 e5                	mov    %esp,%ebp
  80344c:	83 ec 04             	sub    $0x4,%esp
  80344f:	8b 45 10             	mov    0x10(%ebp),%eax
  803452:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  803455:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803458:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80345c:	8b 45 08             	mov    0x8(%ebp),%eax
  80345f:	6a 00                	push   $0x0
  803461:	51                   	push   %ecx
  803462:	52                   	push   %edx
  803463:	ff 75 0c             	pushl  0xc(%ebp)
  803466:	50                   	push   %eax
  803467:	6a 15                	push   $0x15
  803469:	e8 e4 fd ff ff       	call   803252 <syscall>
  80346e:	83 c4 18             	add    $0x18,%esp
}
  803471:	c9                   	leave  
  803472:	c3                   	ret    

00803473 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  803473:	55                   	push   %ebp
  803474:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  803476:	8b 55 0c             	mov    0xc(%ebp),%edx
  803479:	8b 45 08             	mov    0x8(%ebp),%eax
  80347c:	6a 00                	push   $0x0
  80347e:	6a 00                	push   $0x0
  803480:	6a 00                	push   $0x0
  803482:	52                   	push   %edx
  803483:	50                   	push   %eax
  803484:	6a 16                	push   $0x16
  803486:	e8 c7 fd ff ff       	call   803252 <syscall>
  80348b:	83 c4 18             	add    $0x18,%esp
}
  80348e:	c9                   	leave  
  80348f:	c3                   	ret    

00803490 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  803490:	55                   	push   %ebp
  803491:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  803493:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803496:	8b 55 0c             	mov    0xc(%ebp),%edx
  803499:	8b 45 08             	mov    0x8(%ebp),%eax
  80349c:	6a 00                	push   $0x0
  80349e:	6a 00                	push   $0x0
  8034a0:	51                   	push   %ecx
  8034a1:	52                   	push   %edx
  8034a2:	50                   	push   %eax
  8034a3:	6a 17                	push   $0x17
  8034a5:	e8 a8 fd ff ff       	call   803252 <syscall>
  8034aa:	83 c4 18             	add    $0x18,%esp
}
  8034ad:	c9                   	leave  
  8034ae:	c3                   	ret    

008034af <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8034af:	55                   	push   %ebp
  8034b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8034b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b8:	6a 00                	push   $0x0
  8034ba:	6a 00                	push   $0x0
  8034bc:	6a 00                	push   $0x0
  8034be:	52                   	push   %edx
  8034bf:	50                   	push   %eax
  8034c0:	6a 18                	push   $0x18
  8034c2:	e8 8b fd ff ff       	call   803252 <syscall>
  8034c7:	83 c4 18             	add    $0x18,%esp
}
  8034ca:	c9                   	leave  
  8034cb:	c3                   	ret    

008034cc <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8034cc:	55                   	push   %ebp
  8034cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8034cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d2:	6a 00                	push   $0x0
  8034d4:	ff 75 14             	pushl  0x14(%ebp)
  8034d7:	ff 75 10             	pushl  0x10(%ebp)
  8034da:	ff 75 0c             	pushl  0xc(%ebp)
  8034dd:	50                   	push   %eax
  8034de:	6a 19                	push   $0x19
  8034e0:	e8 6d fd ff ff       	call   803252 <syscall>
  8034e5:	83 c4 18             	add    $0x18,%esp
}
  8034e8:	c9                   	leave  
  8034e9:	c3                   	ret    

008034ea <sys_run_env>:

void sys_run_env(int32 envId)
{
  8034ea:	55                   	push   %ebp
  8034eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8034ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f0:	6a 00                	push   $0x0
  8034f2:	6a 00                	push   $0x0
  8034f4:	6a 00                	push   $0x0
  8034f6:	6a 00                	push   $0x0
  8034f8:	50                   	push   %eax
  8034f9:	6a 1a                	push   $0x1a
  8034fb:	e8 52 fd ff ff       	call   803252 <syscall>
  803500:	83 c4 18             	add    $0x18,%esp
}
  803503:	90                   	nop
  803504:	c9                   	leave  
  803505:	c3                   	ret    

00803506 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  803506:	55                   	push   %ebp
  803507:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  803509:	8b 45 08             	mov    0x8(%ebp),%eax
  80350c:	6a 00                	push   $0x0
  80350e:	6a 00                	push   $0x0
  803510:	6a 00                	push   $0x0
  803512:	6a 00                	push   $0x0
  803514:	50                   	push   %eax
  803515:	6a 1b                	push   $0x1b
  803517:	e8 36 fd ff ff       	call   803252 <syscall>
  80351c:	83 c4 18             	add    $0x18,%esp
}
  80351f:	c9                   	leave  
  803520:	c3                   	ret    

00803521 <sys_getenvid>:

int32 sys_getenvid(void)
{
  803521:	55                   	push   %ebp
  803522:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  803524:	6a 00                	push   $0x0
  803526:	6a 00                	push   $0x0
  803528:	6a 00                	push   $0x0
  80352a:	6a 00                	push   $0x0
  80352c:	6a 00                	push   $0x0
  80352e:	6a 05                	push   $0x5
  803530:	e8 1d fd ff ff       	call   803252 <syscall>
  803535:	83 c4 18             	add    $0x18,%esp
}
  803538:	c9                   	leave  
  803539:	c3                   	ret    

0080353a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80353a:	55                   	push   %ebp
  80353b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80353d:	6a 00                	push   $0x0
  80353f:	6a 00                	push   $0x0
  803541:	6a 00                	push   $0x0
  803543:	6a 00                	push   $0x0
  803545:	6a 00                	push   $0x0
  803547:	6a 06                	push   $0x6
  803549:	e8 04 fd ff ff       	call   803252 <syscall>
  80354e:	83 c4 18             	add    $0x18,%esp
}
  803551:	c9                   	leave  
  803552:	c3                   	ret    

00803553 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  803553:	55                   	push   %ebp
  803554:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  803556:	6a 00                	push   $0x0
  803558:	6a 00                	push   $0x0
  80355a:	6a 00                	push   $0x0
  80355c:	6a 00                	push   $0x0
  80355e:	6a 00                	push   $0x0
  803560:	6a 07                	push   $0x7
  803562:	e8 eb fc ff ff       	call   803252 <syscall>
  803567:	83 c4 18             	add    $0x18,%esp
}
  80356a:	c9                   	leave  
  80356b:	c3                   	ret    

0080356c <sys_exit_env>:


void sys_exit_env(void)
{
  80356c:	55                   	push   %ebp
  80356d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80356f:	6a 00                	push   $0x0
  803571:	6a 00                	push   $0x0
  803573:	6a 00                	push   $0x0
  803575:	6a 00                	push   $0x0
  803577:	6a 00                	push   $0x0
  803579:	6a 1c                	push   $0x1c
  80357b:	e8 d2 fc ff ff       	call   803252 <syscall>
  803580:	83 c4 18             	add    $0x18,%esp
}
  803583:	90                   	nop
  803584:	c9                   	leave  
  803585:	c3                   	ret    

00803586 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  803586:	55                   	push   %ebp
  803587:	89 e5                	mov    %esp,%ebp
  803589:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80358c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80358f:	8d 50 04             	lea    0x4(%eax),%edx
  803592:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803595:	6a 00                	push   $0x0
  803597:	6a 00                	push   $0x0
  803599:	6a 00                	push   $0x0
  80359b:	52                   	push   %edx
  80359c:	50                   	push   %eax
  80359d:	6a 1d                	push   $0x1d
  80359f:	e8 ae fc ff ff       	call   803252 <syscall>
  8035a4:	83 c4 18             	add    $0x18,%esp
	return result;
  8035a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8035aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8035ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8035b0:	89 01                	mov    %eax,(%ecx)
  8035b2:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8035b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b8:	c9                   	leave  
  8035b9:	c2 04 00             	ret    $0x4

008035bc <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8035bc:	55                   	push   %ebp
  8035bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8035bf:	6a 00                	push   $0x0
  8035c1:	6a 00                	push   $0x0
  8035c3:	ff 75 10             	pushl  0x10(%ebp)
  8035c6:	ff 75 0c             	pushl  0xc(%ebp)
  8035c9:	ff 75 08             	pushl  0x8(%ebp)
  8035cc:	6a 13                	push   $0x13
  8035ce:	e8 7f fc ff ff       	call   803252 <syscall>
  8035d3:	83 c4 18             	add    $0x18,%esp
	return ;
  8035d6:	90                   	nop
}
  8035d7:	c9                   	leave  
  8035d8:	c3                   	ret    

008035d9 <sys_rcr2>:
uint32 sys_rcr2()
{
  8035d9:	55                   	push   %ebp
  8035da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8035dc:	6a 00                	push   $0x0
  8035de:	6a 00                	push   $0x0
  8035e0:	6a 00                	push   $0x0
  8035e2:	6a 00                	push   $0x0
  8035e4:	6a 00                	push   $0x0
  8035e6:	6a 1e                	push   $0x1e
  8035e8:	e8 65 fc ff ff       	call   803252 <syscall>
  8035ed:	83 c4 18             	add    $0x18,%esp
}
  8035f0:	c9                   	leave  
  8035f1:	c3                   	ret    

008035f2 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8035f2:	55                   	push   %ebp
  8035f3:	89 e5                	mov    %esp,%ebp
  8035f5:	83 ec 04             	sub    $0x4,%esp
  8035f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8035fe:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  803602:	6a 00                	push   $0x0
  803604:	6a 00                	push   $0x0
  803606:	6a 00                	push   $0x0
  803608:	6a 00                	push   $0x0
  80360a:	50                   	push   %eax
  80360b:	6a 1f                	push   $0x1f
  80360d:	e8 40 fc ff ff       	call   803252 <syscall>
  803612:	83 c4 18             	add    $0x18,%esp
	return ;
  803615:	90                   	nop
}
  803616:	c9                   	leave  
  803617:	c3                   	ret    

00803618 <rsttst>:
void rsttst()
{
  803618:	55                   	push   %ebp
  803619:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80361b:	6a 00                	push   $0x0
  80361d:	6a 00                	push   $0x0
  80361f:	6a 00                	push   $0x0
  803621:	6a 00                	push   $0x0
  803623:	6a 00                	push   $0x0
  803625:	6a 21                	push   $0x21
  803627:	e8 26 fc ff ff       	call   803252 <syscall>
  80362c:	83 c4 18             	add    $0x18,%esp
	return ;
  80362f:	90                   	nop
}
  803630:	c9                   	leave  
  803631:	c3                   	ret    

00803632 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  803632:	55                   	push   %ebp
  803633:	89 e5                	mov    %esp,%ebp
  803635:	83 ec 04             	sub    $0x4,%esp
  803638:	8b 45 14             	mov    0x14(%ebp),%eax
  80363b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80363e:	8b 55 18             	mov    0x18(%ebp),%edx
  803641:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803645:	52                   	push   %edx
  803646:	50                   	push   %eax
  803647:	ff 75 10             	pushl  0x10(%ebp)
  80364a:	ff 75 0c             	pushl  0xc(%ebp)
  80364d:	ff 75 08             	pushl  0x8(%ebp)
  803650:	6a 20                	push   $0x20
  803652:	e8 fb fb ff ff       	call   803252 <syscall>
  803657:	83 c4 18             	add    $0x18,%esp
	return ;
  80365a:	90                   	nop
}
  80365b:	c9                   	leave  
  80365c:	c3                   	ret    

0080365d <chktst>:
void chktst(uint32 n)
{
  80365d:	55                   	push   %ebp
  80365e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803660:	6a 00                	push   $0x0
  803662:	6a 00                	push   $0x0
  803664:	6a 00                	push   $0x0
  803666:	6a 00                	push   $0x0
  803668:	ff 75 08             	pushl  0x8(%ebp)
  80366b:	6a 22                	push   $0x22
  80366d:	e8 e0 fb ff ff       	call   803252 <syscall>
  803672:	83 c4 18             	add    $0x18,%esp
	return ;
  803675:	90                   	nop
}
  803676:	c9                   	leave  
  803677:	c3                   	ret    

00803678 <inctst>:

void inctst()
{
  803678:	55                   	push   %ebp
  803679:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80367b:	6a 00                	push   $0x0
  80367d:	6a 00                	push   $0x0
  80367f:	6a 00                	push   $0x0
  803681:	6a 00                	push   $0x0
  803683:	6a 00                	push   $0x0
  803685:	6a 23                	push   $0x23
  803687:	e8 c6 fb ff ff       	call   803252 <syscall>
  80368c:	83 c4 18             	add    $0x18,%esp
	return ;
  80368f:	90                   	nop
}
  803690:	c9                   	leave  
  803691:	c3                   	ret    

00803692 <gettst>:
uint32 gettst()
{
  803692:	55                   	push   %ebp
  803693:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803695:	6a 00                	push   $0x0
  803697:	6a 00                	push   $0x0
  803699:	6a 00                	push   $0x0
  80369b:	6a 00                	push   $0x0
  80369d:	6a 00                	push   $0x0
  80369f:	6a 24                	push   $0x24
  8036a1:	e8 ac fb ff ff       	call   803252 <syscall>
  8036a6:	83 c4 18             	add    $0x18,%esp
}
  8036a9:	c9                   	leave  
  8036aa:	c3                   	ret    

008036ab <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8036ab:	55                   	push   %ebp
  8036ac:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8036ae:	6a 00                	push   $0x0
  8036b0:	6a 00                	push   $0x0
  8036b2:	6a 00                	push   $0x0
  8036b4:	6a 00                	push   $0x0
  8036b6:	6a 00                	push   $0x0
  8036b8:	6a 25                	push   $0x25
  8036ba:	e8 93 fb ff ff       	call   803252 <syscall>
  8036bf:	83 c4 18             	add    $0x18,%esp
  8036c2:	a3 80 60 83 00       	mov    %eax,0x836080
	return uheapPlaceStrategy ;
  8036c7:	a1 80 60 83 00       	mov    0x836080,%eax
}
  8036cc:	c9                   	leave  
  8036cd:	c3                   	ret    

008036ce <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8036ce:	55                   	push   %ebp
  8036cf:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8036d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d4:	a3 80 60 83 00       	mov    %eax,0x836080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8036d9:	6a 00                	push   $0x0
  8036db:	6a 00                	push   $0x0
  8036dd:	6a 00                	push   $0x0
  8036df:	6a 00                	push   $0x0
  8036e1:	ff 75 08             	pushl  0x8(%ebp)
  8036e4:	6a 26                	push   $0x26
  8036e6:	e8 67 fb ff ff       	call   803252 <syscall>
  8036eb:	83 c4 18             	add    $0x18,%esp
	return ;
  8036ee:	90                   	nop
}
  8036ef:	c9                   	leave  
  8036f0:	c3                   	ret    

008036f1 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8036f1:	55                   	push   %ebp
  8036f2:	89 e5                	mov    %esp,%ebp
  8036f4:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8036f5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8036f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8036fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803701:	6a 00                	push   $0x0
  803703:	53                   	push   %ebx
  803704:	51                   	push   %ecx
  803705:	52                   	push   %edx
  803706:	50                   	push   %eax
  803707:	6a 27                	push   $0x27
  803709:	e8 44 fb ff ff       	call   803252 <syscall>
  80370e:	83 c4 18             	add    $0x18,%esp
}
  803711:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803714:	c9                   	leave  
  803715:	c3                   	ret    

00803716 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803716:	55                   	push   %ebp
  803717:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803719:	8b 55 0c             	mov    0xc(%ebp),%edx
  80371c:	8b 45 08             	mov    0x8(%ebp),%eax
  80371f:	6a 00                	push   $0x0
  803721:	6a 00                	push   $0x0
  803723:	6a 00                	push   $0x0
  803725:	52                   	push   %edx
  803726:	50                   	push   %eax
  803727:	6a 28                	push   $0x28
  803729:	e8 24 fb ff ff       	call   803252 <syscall>
  80372e:	83 c4 18             	add    $0x18,%esp
}
  803731:	c9                   	leave  
  803732:	c3                   	ret    

00803733 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  803733:	55                   	push   %ebp
  803734:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  803736:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803739:	8b 55 0c             	mov    0xc(%ebp),%edx
  80373c:	8b 45 08             	mov    0x8(%ebp),%eax
  80373f:	6a 00                	push   $0x0
  803741:	51                   	push   %ecx
  803742:	ff 75 10             	pushl  0x10(%ebp)
  803745:	52                   	push   %edx
  803746:	50                   	push   %eax
  803747:	6a 29                	push   $0x29
  803749:	e8 04 fb ff ff       	call   803252 <syscall>
  80374e:	83 c4 18             	add    $0x18,%esp
}
  803751:	c9                   	leave  
  803752:	c3                   	ret    

00803753 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  803753:	55                   	push   %ebp
  803754:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803756:	6a 00                	push   $0x0
  803758:	6a 00                	push   $0x0
  80375a:	ff 75 10             	pushl  0x10(%ebp)
  80375d:	ff 75 0c             	pushl  0xc(%ebp)
  803760:	ff 75 08             	pushl  0x8(%ebp)
  803763:	6a 12                	push   $0x12
  803765:	e8 e8 fa ff ff       	call   803252 <syscall>
  80376a:	83 c4 18             	add    $0x18,%esp
	return ;
  80376d:	90                   	nop
}
  80376e:	c9                   	leave  
  80376f:	c3                   	ret    

00803770 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  803770:	55                   	push   %ebp
  803771:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  803773:	8b 55 0c             	mov    0xc(%ebp),%edx
  803776:	8b 45 08             	mov    0x8(%ebp),%eax
  803779:	6a 00                	push   $0x0
  80377b:	6a 00                	push   $0x0
  80377d:	6a 00                	push   $0x0
  80377f:	52                   	push   %edx
  803780:	50                   	push   %eax
  803781:	6a 2a                	push   $0x2a
  803783:	e8 ca fa ff ff       	call   803252 <syscall>
  803788:	83 c4 18             	add    $0x18,%esp
	return;
  80378b:	90                   	nop
}
  80378c:	c9                   	leave  
  80378d:	c3                   	ret    

0080378e <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80378e:	55                   	push   %ebp
  80378f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  803791:	6a 00                	push   $0x0
  803793:	6a 00                	push   $0x0
  803795:	6a 00                	push   $0x0
  803797:	6a 00                	push   $0x0
  803799:	6a 00                	push   $0x0
  80379b:	6a 2b                	push   $0x2b
  80379d:	e8 b0 fa ff ff       	call   803252 <syscall>
  8037a2:	83 c4 18             	add    $0x18,%esp
}
  8037a5:	c9                   	leave  
  8037a6:	c3                   	ret    

008037a7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8037a7:	55                   	push   %ebp
  8037a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8037aa:	6a 00                	push   $0x0
  8037ac:	6a 00                	push   $0x0
  8037ae:	6a 00                	push   $0x0
  8037b0:	ff 75 0c             	pushl  0xc(%ebp)
  8037b3:	ff 75 08             	pushl  0x8(%ebp)
  8037b6:	6a 2d                	push   $0x2d
  8037b8:	e8 95 fa ff ff       	call   803252 <syscall>
  8037bd:	83 c4 18             	add    $0x18,%esp
	return;
  8037c0:	90                   	nop
}
  8037c1:	c9                   	leave  
  8037c2:	c3                   	ret    

008037c3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8037c3:	55                   	push   %ebp
  8037c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8037c6:	6a 00                	push   $0x0
  8037c8:	6a 00                	push   $0x0
  8037ca:	6a 00                	push   $0x0
  8037cc:	ff 75 0c             	pushl  0xc(%ebp)
  8037cf:	ff 75 08             	pushl  0x8(%ebp)
  8037d2:	6a 2c                	push   $0x2c
  8037d4:	e8 79 fa ff ff       	call   803252 <syscall>
  8037d9:	83 c4 18             	add    $0x18,%esp
	return ;
  8037dc:	90                   	nop
}
  8037dd:	c9                   	leave  
  8037de:	c3                   	ret    

008037df <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8037df:	55                   	push   %ebp
  8037e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8037e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8037e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e8:	6a 00                	push   $0x0
  8037ea:	6a 00                	push   $0x0
  8037ec:	6a 00                	push   $0x0
  8037ee:	52                   	push   %edx
  8037ef:	50                   	push   %eax
  8037f0:	6a 2e                	push   $0x2e
  8037f2:	e8 5b fa ff ff       	call   803252 <syscall>
  8037f7:	83 c4 18             	add    $0x18,%esp
}
  8037fa:	90                   	nop
  8037fb:	c9                   	leave  
  8037fc:	c3                   	ret    

008037fd <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8037fd:	55                   	push   %ebp
  8037fe:	89 e5                	mov    %esp,%ebp
  803800:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  803803:	81 7d 08 80 e0 81 00 	cmpl   $0x81e080,0x8(%ebp)
  80380a:	72 09                	jb     803815 <to_page_va+0x18>
  80380c:	81 7d 08 80 60 83 00 	cmpl   $0x836080,0x8(%ebp)
  803813:	72 14                	jb     803829 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  803815:	83 ec 04             	sub    $0x4,%esp
  803818:	68 18 50 80 00       	push   $0x805018
  80381d:	6a 15                	push   $0x15
  80381f:	68 43 50 80 00       	push   $0x805043
  803824:	e8 10 d0 ff ff       	call   800839 <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803829:	8b 45 08             	mov    0x8(%ebp),%eax
  80382c:	ba 80 e0 81 00       	mov    $0x81e080,%edx
  803831:	29 d0                	sub    %edx,%eax
  803833:	c1 f8 02             	sar    $0x2,%eax
  803836:	89 c2                	mov    %eax,%edx
  803838:	89 d0                	mov    %edx,%eax
  80383a:	c1 e0 02             	shl    $0x2,%eax
  80383d:	01 d0                	add    %edx,%eax
  80383f:	c1 e0 02             	shl    $0x2,%eax
  803842:	01 d0                	add    %edx,%eax
  803844:	c1 e0 02             	shl    $0x2,%eax
  803847:	01 d0                	add    %edx,%eax
  803849:	89 c1                	mov    %eax,%ecx
  80384b:	c1 e1 08             	shl    $0x8,%ecx
  80384e:	01 c8                	add    %ecx,%eax
  803850:	89 c1                	mov    %eax,%ecx
  803852:	c1 e1 10             	shl    $0x10,%ecx
  803855:	01 c8                	add    %ecx,%eax
  803857:	01 c0                	add    %eax,%eax
  803859:	01 d0                	add    %edx,%eax
  80385b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  80385e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803861:	c1 e0 0c             	shl    $0xc,%eax
  803864:	89 c2                	mov    %eax,%edx
  803866:	a1 84 60 83 00       	mov    0x836084,%eax
  80386b:	01 d0                	add    %edx,%eax
}
  80386d:	c9                   	leave  
  80386e:	c3                   	ret    

0080386f <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  80386f:	55                   	push   %ebp
  803870:	89 e5                	mov    %esp,%ebp
  803872:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  803875:	a1 84 60 83 00       	mov    0x836084,%eax
  80387a:	8b 55 08             	mov    0x8(%ebp),%edx
  80387d:	29 c2                	sub    %eax,%edx
  80387f:	89 d0                	mov    %edx,%eax
  803881:	c1 e8 0c             	shr    $0xc,%eax
  803884:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  803887:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80388b:	78 09                	js     803896 <to_page_info+0x27>
  80388d:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  803894:	7e 14                	jle    8038aa <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  803896:	83 ec 04             	sub    $0x4,%esp
  803899:	68 5c 50 80 00       	push   $0x80505c
  80389e:	6a 21                	push   $0x21
  8038a0:	68 43 50 80 00       	push   $0x805043
  8038a5:	e8 8f cf ff ff       	call   800839 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  8038aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8038ad:	89 d0                	mov    %edx,%eax
  8038af:	01 c0                	add    %eax,%eax
  8038b1:	01 d0                	add    %edx,%eax
  8038b3:	c1 e0 02             	shl    $0x2,%eax
  8038b6:	05 80 e0 81 00       	add    $0x81e080,%eax
}
  8038bb:	c9                   	leave  
  8038bc:	c3                   	ret    

008038bd <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8038bd:	55                   	push   %ebp
  8038be:	89 e5                	mov    %esp,%ebp
  8038c0:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8038c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c6:	05 00 00 00 02       	add    $0x2000000,%eax
  8038cb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8038ce:	73 16                	jae    8038e6 <initialize_dynamic_allocator+0x29>
  8038d0:	68 80 50 80 00       	push   $0x805080
  8038d5:	68 a6 50 80 00       	push   $0x8050a6
  8038da:	6a 2f                	push   $0x2f
  8038dc:	68 43 50 80 00       	push   $0x805043
  8038e1:	e8 53 cf ff ff       	call   800839 <_panic>
	dynAllocStart = daStart;
  8038e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e9:	a3 84 60 83 00       	mov    %eax,0x836084
	dynAllocEnd = daEnd;
  8038ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038f1:	a3 60 e0 81 00       	mov    %eax,0x81e060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8038f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8038fd:	eb 36                	jmp    803935 <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  8038ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803902:	c1 e0 04             	shl    $0x4,%eax
  803905:	05 a0 60 83 00       	add    $0x8360a0,%eax
  80390a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803910:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803913:	c1 e0 04             	shl    $0x4,%eax
  803916:	05 a4 60 83 00       	add    $0x8360a4,%eax
  80391b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803921:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803924:	c1 e0 04             	shl    $0x4,%eax
  803927:	05 ac 60 83 00       	add    $0x8360ac,%eax
  80392c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803932:	ff 45 f4             	incl   -0xc(%ebp)
  803935:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  803939:	7e c4                	jle    8038ff <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  80393b:	c7 05 68 e0 81 00 00 	movl   $0x0,0x81e068
  803942:	00 00 00 
  803945:	c7 05 6c e0 81 00 00 	movl   $0x0,0x81e06c
  80394c:	00 00 00 
  80394f:	c7 05 74 e0 81 00 00 	movl   $0x0,0x81e074
  803956:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803959:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803960:	e9 1b 01 00 00       	jmp    803a80 <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  803965:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803968:	89 d0                	mov    %edx,%eax
  80396a:	01 c0                	add    %eax,%eax
  80396c:	01 d0                	add    %edx,%eax
  80396e:	c1 e0 02             	shl    $0x2,%eax
  803971:	05 88 e0 81 00       	add    $0x81e088,%eax
  803976:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  80397b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80397e:	89 d0                	mov    %edx,%eax
  803980:	01 c0                	add    %eax,%eax
  803982:	01 d0                	add    %edx,%eax
  803984:	c1 e0 02             	shl    $0x2,%eax
  803987:	05 8a e0 81 00       	add    $0x81e08a,%eax
  80398c:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  803991:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803994:	89 d0                	mov    %edx,%eax
  803996:	01 c0                	add    %eax,%eax
  803998:	01 d0                	add    %edx,%eax
  80399a:	c1 e0 02             	shl    $0x2,%eax
  80399d:	05 80 e0 81 00       	add    $0x81e080,%eax
  8039a2:	8b 00                	mov    (%eax),%eax
  8039a4:	85 c0                	test   %eax,%eax
  8039a6:	74 2b                	je     8039d3 <initialize_dynamic_allocator+0x116>
  8039a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039ab:	89 d0                	mov    %edx,%eax
  8039ad:	01 c0                	add    %eax,%eax
  8039af:	01 d0                	add    %edx,%eax
  8039b1:	c1 e0 02             	shl    $0x2,%eax
  8039b4:	05 80 e0 81 00       	add    $0x81e080,%eax
  8039b9:	8b 10                	mov    (%eax),%edx
  8039bb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8039be:	89 c8                	mov    %ecx,%eax
  8039c0:	01 c0                	add    %eax,%eax
  8039c2:	01 c8                	add    %ecx,%eax
  8039c4:	c1 e0 02             	shl    $0x2,%eax
  8039c7:	05 84 e0 81 00       	add    $0x81e084,%eax
  8039cc:	8b 00                	mov    (%eax),%eax
  8039ce:	89 42 04             	mov    %eax,0x4(%edx)
  8039d1:	eb 18                	jmp    8039eb <initialize_dynamic_allocator+0x12e>
  8039d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039d6:	89 d0                	mov    %edx,%eax
  8039d8:	01 c0                	add    %eax,%eax
  8039da:	01 d0                	add    %edx,%eax
  8039dc:	c1 e0 02             	shl    $0x2,%eax
  8039df:	05 84 e0 81 00       	add    $0x81e084,%eax
  8039e4:	8b 00                	mov    (%eax),%eax
  8039e6:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  8039eb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039ee:	89 d0                	mov    %edx,%eax
  8039f0:	01 c0                	add    %eax,%eax
  8039f2:	01 d0                	add    %edx,%eax
  8039f4:	c1 e0 02             	shl    $0x2,%eax
  8039f7:	05 84 e0 81 00       	add    $0x81e084,%eax
  8039fc:	8b 00                	mov    (%eax),%eax
  8039fe:	85 c0                	test   %eax,%eax
  803a00:	74 2a                	je     803a2c <initialize_dynamic_allocator+0x16f>
  803a02:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a05:	89 d0                	mov    %edx,%eax
  803a07:	01 c0                	add    %eax,%eax
  803a09:	01 d0                	add    %edx,%eax
  803a0b:	c1 e0 02             	shl    $0x2,%eax
  803a0e:	05 84 e0 81 00       	add    $0x81e084,%eax
  803a13:	8b 10                	mov    (%eax),%edx
  803a15:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803a18:	89 c8                	mov    %ecx,%eax
  803a1a:	01 c0                	add    %eax,%eax
  803a1c:	01 c8                	add    %ecx,%eax
  803a1e:	c1 e0 02             	shl    $0x2,%eax
  803a21:	05 80 e0 81 00       	add    $0x81e080,%eax
  803a26:	8b 00                	mov    (%eax),%eax
  803a28:	89 02                	mov    %eax,(%edx)
  803a2a:	eb 18                	jmp    803a44 <initialize_dynamic_allocator+0x187>
  803a2c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a2f:	89 d0                	mov    %edx,%eax
  803a31:	01 c0                	add    %eax,%eax
  803a33:	01 d0                	add    %edx,%eax
  803a35:	c1 e0 02             	shl    $0x2,%eax
  803a38:	05 80 e0 81 00       	add    $0x81e080,%eax
  803a3d:	8b 00                	mov    (%eax),%eax
  803a3f:	a3 68 e0 81 00       	mov    %eax,0x81e068
  803a44:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a47:	89 d0                	mov    %edx,%eax
  803a49:	01 c0                	add    %eax,%eax
  803a4b:	01 d0                	add    %edx,%eax
  803a4d:	c1 e0 02             	shl    $0x2,%eax
  803a50:	05 80 e0 81 00       	add    $0x81e080,%eax
  803a55:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a5b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a5e:	89 d0                	mov    %edx,%eax
  803a60:	01 c0                	add    %eax,%eax
  803a62:	01 d0                	add    %edx,%eax
  803a64:	c1 e0 02             	shl    $0x2,%eax
  803a67:	05 84 e0 81 00       	add    $0x81e084,%eax
  803a6c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a72:	a1 74 e0 81 00       	mov    0x81e074,%eax
  803a77:	48                   	dec    %eax
  803a78:	a3 74 e0 81 00       	mov    %eax,0x81e074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803a7d:	ff 45 f0             	incl   -0x10(%ebp)
  803a80:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  803a87:	0f 8e d8 fe ff ff    	jle    803965 <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803a8d:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  803a94:	e9 9d 00 00 00       	jmp    803b36 <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  803a99:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  803a9f:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803aa2:	89 c8                	mov    %ecx,%eax
  803aa4:	01 c0                	add    %eax,%eax
  803aa6:	01 c8                	add    %ecx,%eax
  803aa8:	c1 e0 02             	shl    $0x2,%eax
  803aab:	05 80 e0 81 00       	add    $0x81e080,%eax
  803ab0:	89 10                	mov    %edx,(%eax)
  803ab2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803ab5:	89 d0                	mov    %edx,%eax
  803ab7:	01 c0                	add    %eax,%eax
  803ab9:	01 d0                	add    %edx,%eax
  803abb:	c1 e0 02             	shl    $0x2,%eax
  803abe:	05 80 e0 81 00       	add    $0x81e080,%eax
  803ac3:	8b 00                	mov    (%eax),%eax
  803ac5:	85 c0                	test   %eax,%eax
  803ac7:	74 1c                	je     803ae5 <initialize_dynamic_allocator+0x228>
  803ac9:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  803acf:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803ad2:	89 c8                	mov    %ecx,%eax
  803ad4:	01 c0                	add    %eax,%eax
  803ad6:	01 c8                	add    %ecx,%eax
  803ad8:	c1 e0 02             	shl    $0x2,%eax
  803adb:	05 80 e0 81 00       	add    $0x81e080,%eax
  803ae0:	89 42 04             	mov    %eax,0x4(%edx)
  803ae3:	eb 16                	jmp    803afb <initialize_dynamic_allocator+0x23e>
  803ae5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803ae8:	89 d0                	mov    %edx,%eax
  803aea:	01 c0                	add    %eax,%eax
  803aec:	01 d0                	add    %edx,%eax
  803aee:	c1 e0 02             	shl    $0x2,%eax
  803af1:	05 80 e0 81 00       	add    $0x81e080,%eax
  803af6:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  803afb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803afe:	89 d0                	mov    %edx,%eax
  803b00:	01 c0                	add    %eax,%eax
  803b02:	01 d0                	add    %edx,%eax
  803b04:	c1 e0 02             	shl    $0x2,%eax
  803b07:	05 80 e0 81 00       	add    $0x81e080,%eax
  803b0c:	a3 68 e0 81 00       	mov    %eax,0x81e068
  803b11:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b14:	89 d0                	mov    %edx,%eax
  803b16:	01 c0                	add    %eax,%eax
  803b18:	01 d0                	add    %edx,%eax
  803b1a:	c1 e0 02             	shl    $0x2,%eax
  803b1d:	05 84 e0 81 00       	add    $0x81e084,%eax
  803b22:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b28:	a1 74 e0 81 00       	mov    0x81e074,%eax
  803b2d:	40                   	inc    %eax
  803b2e:	a3 74 e0 81 00       	mov    %eax,0x81e074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803b33:	ff 4d ec             	decl   -0x14(%ebp)
  803b36:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803b3a:	0f 89 59 ff ff ff    	jns    803a99 <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  803b40:	c7 05 44 e0 81 00 01 	movl   $0x1,0x81e044
  803b47:	00 00 00 
}
  803b4a:	90                   	nop
  803b4b:	c9                   	leave  
  803b4c:	c3                   	ret    

00803b4d <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  803b4d:	55                   	push   %ebp
  803b4e:	89 e5                	mov    %esp,%ebp
  803b50:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803b53:	8b 45 08             	mov    0x8(%ebp),%eax
  803b56:	83 ec 0c             	sub    $0xc,%esp
  803b59:	50                   	push   %eax
  803b5a:	e8 10 fd ff ff       	call   80386f <to_page_info>
  803b5f:	83 c4 10             	add    $0x10,%esp
  803b62:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  803b65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b68:	8b 40 08             	mov    0x8(%eax),%eax
  803b6b:	0f b7 c0             	movzwl %ax,%eax
}
  803b6e:	c9                   	leave  
  803b6f:	c3                   	ret    

00803b70 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803b70:	55                   	push   %ebp
  803b71:	89 e5                	mov    %esp,%ebp
  803b73:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803b76:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803b7d:	76 16                	jbe    803b95 <alloc_block+0x25>
  803b7f:	68 bc 50 80 00       	push   $0x8050bc
  803b84:	68 a6 50 80 00       	push   $0x8050a6
  803b89:	6a 59                	push   $0x59
  803b8b:	68 43 50 80 00       	push   $0x805043
  803b90:	e8 a4 cc ff ff       	call   800839 <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  803b95:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803b9c:	eb 08                	jmp    803ba6 <alloc_block+0x36>
		allocSize <<= 1;
  803b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ba1:	01 c0                	add    %eax,%eax
  803ba3:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ba9:	3b 45 08             	cmp    0x8(%ebp),%eax
  803bac:	73 09                	jae    803bb7 <alloc_block+0x47>
  803bae:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  803bb5:	76 e7                	jbe    803b9e <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  803bb7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803bbe:	eb 03                	jmp    803bc3 <alloc_block+0x53>
		listIndex++;
  803bc0:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803bc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bc6:	ba 08 00 00 00       	mov    $0x8,%edx
  803bcb:	88 c1                	mov    %al,%cl
  803bcd:	d3 e2                	shl    %cl,%edx
  803bcf:	89 d0                	mov    %edx,%eax
  803bd1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803bd4:	72 ea                	jb     803bc0 <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803bd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bd9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803bdc:	e9 f4 00 00 00       	jmp    803cd5 <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  803be1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803be4:	c1 e0 04             	shl    $0x4,%eax
  803be7:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803bec:	8b 00                	mov    (%eax),%eax
  803bee:	85 c0                	test   %eax,%eax
  803bf0:	0f 84 dc 00 00 00    	je     803cd2 <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  803bf6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bf9:	c1 e0 04             	shl    $0x4,%eax
  803bfc:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803c01:	8b 00                	mov    (%eax),%eax
  803c03:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  803c06:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c0a:	75 14                	jne    803c20 <alloc_block+0xb0>
  803c0c:	83 ec 04             	sub    $0x4,%esp
  803c0f:	68 dd 50 80 00       	push   $0x8050dd
  803c14:	6a 6b                	push   $0x6b
  803c16:	68 43 50 80 00       	push   $0x805043
  803c1b:	e8 19 cc ff ff       	call   800839 <_panic>
  803c20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c23:	8b 00                	mov    (%eax),%eax
  803c25:	85 c0                	test   %eax,%eax
  803c27:	74 10                	je     803c39 <alloc_block+0xc9>
  803c29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c2c:	8b 00                	mov    (%eax),%eax
  803c2e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c31:	8b 52 04             	mov    0x4(%edx),%edx
  803c34:	89 50 04             	mov    %edx,0x4(%eax)
  803c37:	eb 14                	jmp    803c4d <alloc_block+0xdd>
  803c39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c3c:	8b 40 04             	mov    0x4(%eax),%eax
  803c3f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c42:	c1 e2 04             	shl    $0x4,%edx
  803c45:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  803c4b:	89 02                	mov    %eax,(%edx)
  803c4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c50:	8b 40 04             	mov    0x4(%eax),%eax
  803c53:	85 c0                	test   %eax,%eax
  803c55:	74 0f                	je     803c66 <alloc_block+0xf6>
  803c57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c5a:	8b 40 04             	mov    0x4(%eax),%eax
  803c5d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c60:	8b 12                	mov    (%edx),%edx
  803c62:	89 10                	mov    %edx,(%eax)
  803c64:	eb 13                	jmp    803c79 <alloc_block+0x109>
  803c66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c69:	8b 00                	mov    (%eax),%eax
  803c6b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c6e:	c1 e2 04             	shl    $0x4,%edx
  803c71:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  803c77:	89 02                	mov    %eax,(%edx)
  803c79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c7c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c85:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c8f:	c1 e0 04             	shl    $0x4,%eax
  803c92:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803c97:	8b 00                	mov    (%eax),%eax
  803c99:	8d 50 ff             	lea    -0x1(%eax),%edx
  803c9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c9f:	c1 e0 04             	shl    $0x4,%eax
  803ca2:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803ca7:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  803ca9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cac:	83 ec 0c             	sub    $0xc,%esp
  803caf:	50                   	push   %eax
  803cb0:	e8 ba fb ff ff       	call   80386f <to_page_info>
  803cb5:	83 c4 10             	add    $0x10,%esp
  803cb8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  803cbb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cbe:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803cc2:	48                   	dec    %eax
  803cc3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803cc6:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  803cca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ccd:	e9 8f 02 00 00       	jmp    803f61 <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803cd2:	ff 45 ec             	incl   -0x14(%ebp)
  803cd5:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803cd9:	0f 8e 02 ff ff ff    	jle    803be1 <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  803cdf:	a1 68 e0 81 00       	mov    0x81e068,%eax
  803ce4:	85 c0                	test   %eax,%eax
  803ce6:	75 14                	jne    803cfc <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  803ce8:	83 ec 04             	sub    $0x4,%esp
  803ceb:	68 fc 50 80 00       	push   $0x8050fc
  803cf0:	6a 77                	push   $0x77
  803cf2:	68 43 50 80 00       	push   $0x805043
  803cf7:	e8 3d cb ff ff       	call   800839 <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  803cfc:	a1 68 e0 81 00       	mov    0x81e068,%eax
  803d01:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  803d04:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803d08:	75 14                	jne    803d1e <alloc_block+0x1ae>
  803d0a:	83 ec 04             	sub    $0x4,%esp
  803d0d:	68 dd 50 80 00       	push   $0x8050dd
  803d12:	6a 7a                	push   $0x7a
  803d14:	68 43 50 80 00       	push   $0x805043
  803d19:	e8 1b cb ff ff       	call   800839 <_panic>
  803d1e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d21:	8b 00                	mov    (%eax),%eax
  803d23:	85 c0                	test   %eax,%eax
  803d25:	74 10                	je     803d37 <alloc_block+0x1c7>
  803d27:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d2a:	8b 00                	mov    (%eax),%eax
  803d2c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803d2f:	8b 52 04             	mov    0x4(%edx),%edx
  803d32:	89 50 04             	mov    %edx,0x4(%eax)
  803d35:	eb 0b                	jmp    803d42 <alloc_block+0x1d2>
  803d37:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d3a:	8b 40 04             	mov    0x4(%eax),%eax
  803d3d:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  803d42:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d45:	8b 40 04             	mov    0x4(%eax),%eax
  803d48:	85 c0                	test   %eax,%eax
  803d4a:	74 0f                	je     803d5b <alloc_block+0x1eb>
  803d4c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d4f:	8b 40 04             	mov    0x4(%eax),%eax
  803d52:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803d55:	8b 12                	mov    (%edx),%edx
  803d57:	89 10                	mov    %edx,(%eax)
  803d59:	eb 0a                	jmp    803d65 <alloc_block+0x1f5>
  803d5b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d5e:	8b 00                	mov    (%eax),%eax
  803d60:	a3 68 e0 81 00       	mov    %eax,0x81e068
  803d65:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d68:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d6e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d71:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d78:	a1 74 e0 81 00       	mov    0x81e074,%eax
  803d7d:	48                   	dec    %eax
  803d7e:	a3 74 e0 81 00       	mov    %eax,0x81e074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  803d83:	83 ec 0c             	sub    $0xc,%esp
  803d86:	ff 75 dc             	pushl  -0x24(%ebp)
  803d89:	e8 6f fa ff ff       	call   8037fd <to_page_va>
  803d8e:	83 c4 10             	add    $0x10,%esp
  803d91:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  803d94:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803d97:	83 ec 0c             	sub    $0xc,%esp
  803d9a:	50                   	push   %eax
  803d9b:	e8 a0 dc ff ff       	call   801a40 <get_page>
  803da0:	83 c4 10             	add    $0x10,%esp
  803da3:	85 c0                	test   %eax,%eax
  803da5:	74 14                	je     803dbb <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  803da7:	83 ec 04             	sub    $0x4,%esp
  803daa:	68 24 51 80 00       	push   $0x805124
  803daf:	6a 7f                	push   $0x7f
  803db1:	68 43 50 80 00       	push   $0x805043
  803db6:	e8 7e ca ff ff       	call   800839 <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  803dbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dbe:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803dc1:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  803dc5:	b8 00 10 00 00       	mov    $0x1000,%eax
  803dca:	ba 00 00 00 00       	mov    $0x0,%edx
  803dcf:	f7 75 f4             	divl   -0xc(%ebp)
  803dd2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803dd5:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803dd9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803de0:	e9 a7 00 00 00       	jmp    803e8c <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  803de5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803de8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803deb:	01 d0                	add    %edx,%eax
  803ded:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  803df0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803df4:	75 17                	jne    803e0d <alloc_block+0x29d>
  803df6:	83 ec 04             	sub    $0x4,%esp
  803df9:	68 4c 51 80 00       	push   $0x80514c
  803dfe:	68 88 00 00 00       	push   $0x88
  803e03:	68 43 50 80 00       	push   $0x805043
  803e08:	e8 2c ca ff ff       	call   800839 <_panic>
  803e0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e10:	c1 e0 04             	shl    $0x4,%eax
  803e13:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803e18:	8b 10                	mov    (%eax),%edx
  803e1a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e1d:	89 10                	mov    %edx,(%eax)
  803e1f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e22:	8b 00                	mov    (%eax),%eax
  803e24:	85 c0                	test   %eax,%eax
  803e26:	74 15                	je     803e3d <alloc_block+0x2cd>
  803e28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e2b:	c1 e0 04             	shl    $0x4,%eax
  803e2e:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803e33:	8b 00                	mov    (%eax),%eax
  803e35:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803e38:	89 50 04             	mov    %edx,0x4(%eax)
  803e3b:	eb 11                	jmp    803e4e <alloc_block+0x2de>
  803e3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e40:	c1 e0 04             	shl    $0x4,%eax
  803e43:	8d 90 a4 60 83 00    	lea    0x8360a4(%eax),%edx
  803e49:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e4c:	89 02                	mov    %eax,(%edx)
  803e4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e51:	c1 e0 04             	shl    $0x4,%eax
  803e54:	8d 90 a0 60 83 00    	lea    0x8360a0(%eax),%edx
  803e5a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e5d:	89 02                	mov    %eax,(%edx)
  803e5f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e62:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e6c:	c1 e0 04             	shl    $0x4,%eax
  803e6f:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803e74:	8b 00                	mov    (%eax),%eax
  803e76:	8d 50 01             	lea    0x1(%eax),%edx
  803e79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e7c:	c1 e0 04             	shl    $0x4,%eax
  803e7f:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803e84:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e89:	01 45 e8             	add    %eax,-0x18(%ebp)
  803e8c:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  803e93:	0f 86 4c ff ff ff    	jbe    803de5 <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  803e99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e9c:	c1 e0 04             	shl    $0x4,%eax
  803e9f:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803ea4:	8b 00                	mov    (%eax),%eax
  803ea6:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  803ea9:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803ead:	75 17                	jne    803ec6 <alloc_block+0x356>
  803eaf:	83 ec 04             	sub    $0x4,%esp
  803eb2:	68 dd 50 80 00       	push   $0x8050dd
  803eb7:	68 8d 00 00 00       	push   $0x8d
  803ebc:	68 43 50 80 00       	push   $0x805043
  803ec1:	e8 73 c9 ff ff       	call   800839 <_panic>
  803ec6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803ec9:	8b 00                	mov    (%eax),%eax
  803ecb:	85 c0                	test   %eax,%eax
  803ecd:	74 10                	je     803edf <alloc_block+0x36f>
  803ecf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803ed2:	8b 00                	mov    (%eax),%eax
  803ed4:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803ed7:	8b 52 04             	mov    0x4(%edx),%edx
  803eda:	89 50 04             	mov    %edx,0x4(%eax)
  803edd:	eb 14                	jmp    803ef3 <alloc_block+0x383>
  803edf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803ee2:	8b 40 04             	mov    0x4(%eax),%eax
  803ee5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ee8:	c1 e2 04             	shl    $0x4,%edx
  803eeb:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  803ef1:	89 02                	mov    %eax,(%edx)
  803ef3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803ef6:	8b 40 04             	mov    0x4(%eax),%eax
  803ef9:	85 c0                	test   %eax,%eax
  803efb:	74 0f                	je     803f0c <alloc_block+0x39c>
  803efd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f00:	8b 40 04             	mov    0x4(%eax),%eax
  803f03:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803f06:	8b 12                	mov    (%edx),%edx
  803f08:	89 10                	mov    %edx,(%eax)
  803f0a:	eb 13                	jmp    803f1f <alloc_block+0x3af>
  803f0c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f0f:	8b 00                	mov    (%eax),%eax
  803f11:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803f14:	c1 e2 04             	shl    $0x4,%edx
  803f17:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  803f1d:	89 02                	mov    %eax,(%edx)
  803f1f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f22:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f28:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f2b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f35:	c1 e0 04             	shl    $0x4,%eax
  803f38:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803f3d:	8b 00                	mov    (%eax),%eax
  803f3f:	8d 50 ff             	lea    -0x1(%eax),%edx
  803f42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f45:	c1 e0 04             	shl    $0x4,%eax
  803f48:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803f4d:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  803f4f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f52:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803f56:	48                   	dec    %eax
  803f57:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803f5a:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  803f5e:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  803f61:	c9                   	leave  
  803f62:	c3                   	ret    

00803f63 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803f63:	55                   	push   %ebp
  803f64:	89 e5                	mov    %esp,%ebp
  803f66:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803f69:	8b 55 08             	mov    0x8(%ebp),%edx
  803f6c:	a1 84 60 83 00       	mov    0x836084,%eax
  803f71:	39 c2                	cmp    %eax,%edx
  803f73:	72 0c                	jb     803f81 <free_block+0x1e>
  803f75:	8b 55 08             	mov    0x8(%ebp),%edx
  803f78:	a1 60 e0 81 00       	mov    0x81e060,%eax
  803f7d:	39 c2                	cmp    %eax,%edx
  803f7f:	72 19                	jb     803f9a <free_block+0x37>
  803f81:	68 70 51 80 00       	push   $0x805170
  803f86:	68 a6 50 80 00       	push   $0x8050a6
  803f8b:	68 98 00 00 00       	push   $0x98
  803f90:	68 43 50 80 00       	push   $0x805043
  803f95:	e8 9f c8 ff ff       	call   800839 <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  803f9d:	83 ec 0c             	sub    $0xc,%esp
  803fa0:	50                   	push   %eax
  803fa1:	e8 c9 f8 ff ff       	call   80386f <to_page_info>
  803fa6:	83 c4 10             	add    $0x10,%esp
  803fa9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  803fac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803faf:	8b 40 08             	mov    0x8(%eax),%eax
  803fb2:	0f b7 c0             	movzwl %ax,%eax
  803fb5:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  803fb8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803fbf:	eb 03                	jmp    803fc4 <free_block+0x61>
		listIndex++;
  803fc1:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803fc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fc7:	ba 08 00 00 00       	mov    $0x8,%edx
  803fcc:	88 c1                	mov    %al,%cl
  803fce:	d3 e2                	shl    %cl,%edx
  803fd0:	89 d0                	mov    %edx,%eax
  803fd2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803fd5:	72 ea                	jb     803fc1 <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  803fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  803fda:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  803fdd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803fe1:	75 17                	jne    803ffa <free_block+0x97>
  803fe3:	83 ec 04             	sub    $0x4,%esp
  803fe6:	68 4c 51 80 00       	push   $0x80514c
  803feb:	68 a2 00 00 00       	push   $0xa2
  803ff0:	68 43 50 80 00       	push   $0x805043
  803ff5:	e8 3f c8 ff ff       	call   800839 <_panic>
  803ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ffd:	c1 e0 04             	shl    $0x4,%eax
  804000:	05 a0 60 83 00       	add    $0x8360a0,%eax
  804005:	8b 10                	mov    (%eax),%edx
  804007:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80400a:	89 10                	mov    %edx,(%eax)
  80400c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80400f:	8b 00                	mov    (%eax),%eax
  804011:	85 c0                	test   %eax,%eax
  804013:	74 15                	je     80402a <free_block+0xc7>
  804015:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804018:	c1 e0 04             	shl    $0x4,%eax
  80401b:	05 a0 60 83 00       	add    $0x8360a0,%eax
  804020:	8b 00                	mov    (%eax),%eax
  804022:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804025:	89 50 04             	mov    %edx,0x4(%eax)
  804028:	eb 11                	jmp    80403b <free_block+0xd8>
  80402a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80402d:	c1 e0 04             	shl    $0x4,%eax
  804030:	8d 90 a4 60 83 00    	lea    0x8360a4(%eax),%edx
  804036:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804039:	89 02                	mov    %eax,(%edx)
  80403b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80403e:	c1 e0 04             	shl    $0x4,%eax
  804041:	8d 90 a0 60 83 00    	lea    0x8360a0(%eax),%edx
  804047:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80404a:	89 02                	mov    %eax,(%edx)
  80404c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80404f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804056:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804059:	c1 e0 04             	shl    $0x4,%eax
  80405c:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804061:	8b 00                	mov    (%eax),%eax
  804063:	8d 50 01             	lea    0x1(%eax),%edx
  804066:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804069:	c1 e0 04             	shl    $0x4,%eax
  80406c:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804071:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  804073:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804076:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80407a:	40                   	inc    %eax
  80407b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80407e:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  804082:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804085:	66 8b 40 0a          	mov    0xa(%eax),%ax
  804089:	0f b7 c8             	movzwl %ax,%ecx
  80408c:	b8 00 10 00 00       	mov    $0x1000,%eax
  804091:	ba 00 00 00 00       	mov    $0x0,%edx
  804096:	f7 75 e8             	divl   -0x18(%ebp)
  804099:	39 c1                	cmp    %eax,%ecx
  80409b:	0f 85 ed 01 00 00    	jne    80428e <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  8040a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040a4:	c1 e0 04             	shl    $0x4,%eax
  8040a7:	05 a0 60 83 00       	add    $0x8360a0,%eax
  8040ac:	8b 00                	mov    (%eax),%eax
  8040ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8040b1:	eb 2a                	jmp    8040dd <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  8040b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040b6:	83 ec 0c             	sub    $0xc,%esp
  8040b9:	50                   	push   %eax
  8040ba:	e8 b0 f7 ff ff       	call   80386f <to_page_info>
  8040bf:	83 c4 10             	add    $0x10,%esp
  8040c2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8040c5:	75 06                	jne    8040cd <free_block+0x16a>
				tmp = b;
  8040c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  8040cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040d0:	c1 e0 04             	shl    $0x4,%eax
  8040d3:	05 a8 60 83 00       	add    $0x8360a8,%eax
  8040d8:	8b 00                	mov    (%eax),%eax
  8040da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8040dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8040e1:	74 07                	je     8040ea <free_block+0x187>
  8040e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040e6:	8b 00                	mov    (%eax),%eax
  8040e8:	eb 05                	jmp    8040ef <free_block+0x18c>
  8040ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8040ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8040f2:	c1 e2 04             	shl    $0x4,%edx
  8040f5:	81 c2 a8 60 83 00    	add    $0x8360a8,%edx
  8040fb:	89 02                	mov    %eax,(%edx)
  8040fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804100:	c1 e0 04             	shl    $0x4,%eax
  804103:	05 a8 60 83 00       	add    $0x8360a8,%eax
  804108:	8b 00                	mov    (%eax),%eax
  80410a:	85 c0                	test   %eax,%eax
  80410c:	75 a5                	jne    8040b3 <free_block+0x150>
  80410e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804112:	75 9f                	jne    8040b3 <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  804114:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804117:	c1 e0 04             	shl    $0x4,%eax
  80411a:	05 a0 60 83 00       	add    $0x8360a0,%eax
  80411f:	8b 00                	mov    (%eax),%eax
  804121:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  804124:	e9 cc 00 00 00       	jmp    8041f5 <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  804129:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80412c:	8b 00                	mov    (%eax),%eax
  80412e:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  804131:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804134:	83 ec 0c             	sub    $0xc,%esp
  804137:	50                   	push   %eax
  804138:	e8 32 f7 ff ff       	call   80386f <to_page_info>
  80413d:	83 c4 10             	add    $0x10,%esp
  804140:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  804143:	0f 85 a6 00 00 00    	jne    8041ef <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  804149:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80414d:	75 17                	jne    804166 <free_block+0x203>
  80414f:	83 ec 04             	sub    $0x4,%esp
  804152:	68 dd 50 80 00       	push   $0x8050dd
  804157:	68 b5 00 00 00       	push   $0xb5
  80415c:	68 43 50 80 00       	push   $0x805043
  804161:	e8 d3 c6 ff ff       	call   800839 <_panic>
  804166:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804169:	8b 00                	mov    (%eax),%eax
  80416b:	85 c0                	test   %eax,%eax
  80416d:	74 10                	je     80417f <free_block+0x21c>
  80416f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804172:	8b 00                	mov    (%eax),%eax
  804174:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804177:	8b 52 04             	mov    0x4(%edx),%edx
  80417a:	89 50 04             	mov    %edx,0x4(%eax)
  80417d:	eb 14                	jmp    804193 <free_block+0x230>
  80417f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804182:	8b 40 04             	mov    0x4(%eax),%eax
  804185:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804188:	c1 e2 04             	shl    $0x4,%edx
  80418b:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  804191:	89 02                	mov    %eax,(%edx)
  804193:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804196:	8b 40 04             	mov    0x4(%eax),%eax
  804199:	85 c0                	test   %eax,%eax
  80419b:	74 0f                	je     8041ac <free_block+0x249>
  80419d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041a0:	8b 40 04             	mov    0x4(%eax),%eax
  8041a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8041a6:	8b 12                	mov    (%edx),%edx
  8041a8:	89 10                	mov    %edx,(%eax)
  8041aa:	eb 13                	jmp    8041bf <free_block+0x25c>
  8041ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041af:	8b 00                	mov    (%eax),%eax
  8041b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8041b4:	c1 e2 04             	shl    $0x4,%edx
  8041b7:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  8041bd:	89 02                	mov    %eax,(%edx)
  8041bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8041c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041cb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8041d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041d5:	c1 e0 04             	shl    $0x4,%eax
  8041d8:	05 ac 60 83 00       	add    $0x8360ac,%eax
  8041dd:	8b 00                	mov    (%eax),%eax
  8041df:	8d 50 ff             	lea    -0x1(%eax),%edx
  8041e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041e5:	c1 e0 04             	shl    $0x4,%eax
  8041e8:	05 ac 60 83 00       	add    $0x8360ac,%eax
  8041ed:	89 10                	mov    %edx,(%eax)
			b = next;
  8041ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8041f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  8041f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8041f9:	0f 85 2a ff ff ff    	jne    804129 <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  8041ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804202:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  804208:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80420b:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  804211:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  804215:	75 17                	jne    80422e <free_block+0x2cb>
  804217:	83 ec 04             	sub    $0x4,%esp
  80421a:	68 4c 51 80 00       	push   $0x80514c
  80421f:	68 bc 00 00 00       	push   $0xbc
  804224:	68 43 50 80 00       	push   $0x805043
  804229:	e8 0b c6 ff ff       	call   800839 <_panic>
  80422e:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  804234:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804237:	89 10                	mov    %edx,(%eax)
  804239:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80423c:	8b 00                	mov    (%eax),%eax
  80423e:	85 c0                	test   %eax,%eax
  804240:	74 0d                	je     80424f <free_block+0x2ec>
  804242:	a1 68 e0 81 00       	mov    0x81e068,%eax
  804247:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80424a:	89 50 04             	mov    %edx,0x4(%eax)
  80424d:	eb 08                	jmp    804257 <free_block+0x2f4>
  80424f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804252:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  804257:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80425a:	a3 68 e0 81 00       	mov    %eax,0x81e068
  80425f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804262:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804269:	a1 74 e0 81 00       	mov    0x81e074,%eax
  80426e:	40                   	inc    %eax
  80426f:	a3 74 e0 81 00       	mov    %eax,0x81e074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  804274:	83 ec 0c             	sub    $0xc,%esp
  804277:	ff 75 ec             	pushl  -0x14(%ebp)
  80427a:	e8 7e f5 ff ff       	call   8037fd <to_page_va>
  80427f:	83 c4 10             	add    $0x10,%esp
  804282:	83 ec 0c             	sub    $0xc,%esp
  804285:	50                   	push   %eax
  804286:	e8 fe d7 ff ff       	call   801a89 <return_page>
  80428b:	83 c4 10             	add    $0x10,%esp
	}
}
  80428e:	90                   	nop
  80428f:	c9                   	leave  
  804290:	c3                   	ret    
  804291:	66 90                	xchg   %ax,%ax
  804293:	90                   	nop

00804294 <__udivdi3>:
  804294:	55                   	push   %ebp
  804295:	57                   	push   %edi
  804296:	56                   	push   %esi
  804297:	53                   	push   %ebx
  804298:	83 ec 1c             	sub    $0x1c,%esp
  80429b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80429f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8042a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8042a7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8042ab:	89 ca                	mov    %ecx,%edx
  8042ad:	89 f8                	mov    %edi,%eax
  8042af:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8042b3:	85 f6                	test   %esi,%esi
  8042b5:	75 2d                	jne    8042e4 <__udivdi3+0x50>
  8042b7:	39 cf                	cmp    %ecx,%edi
  8042b9:	77 65                	ja     804320 <__udivdi3+0x8c>
  8042bb:	89 fd                	mov    %edi,%ebp
  8042bd:	85 ff                	test   %edi,%edi
  8042bf:	75 0b                	jne    8042cc <__udivdi3+0x38>
  8042c1:	b8 01 00 00 00       	mov    $0x1,%eax
  8042c6:	31 d2                	xor    %edx,%edx
  8042c8:	f7 f7                	div    %edi
  8042ca:	89 c5                	mov    %eax,%ebp
  8042cc:	31 d2                	xor    %edx,%edx
  8042ce:	89 c8                	mov    %ecx,%eax
  8042d0:	f7 f5                	div    %ebp
  8042d2:	89 c1                	mov    %eax,%ecx
  8042d4:	89 d8                	mov    %ebx,%eax
  8042d6:	f7 f5                	div    %ebp
  8042d8:	89 cf                	mov    %ecx,%edi
  8042da:	89 fa                	mov    %edi,%edx
  8042dc:	83 c4 1c             	add    $0x1c,%esp
  8042df:	5b                   	pop    %ebx
  8042e0:	5e                   	pop    %esi
  8042e1:	5f                   	pop    %edi
  8042e2:	5d                   	pop    %ebp
  8042e3:	c3                   	ret    
  8042e4:	39 ce                	cmp    %ecx,%esi
  8042e6:	77 28                	ja     804310 <__udivdi3+0x7c>
  8042e8:	0f bd fe             	bsr    %esi,%edi
  8042eb:	83 f7 1f             	xor    $0x1f,%edi
  8042ee:	75 40                	jne    804330 <__udivdi3+0x9c>
  8042f0:	39 ce                	cmp    %ecx,%esi
  8042f2:	72 0a                	jb     8042fe <__udivdi3+0x6a>
  8042f4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8042f8:	0f 87 9e 00 00 00    	ja     80439c <__udivdi3+0x108>
  8042fe:	b8 01 00 00 00       	mov    $0x1,%eax
  804303:	89 fa                	mov    %edi,%edx
  804305:	83 c4 1c             	add    $0x1c,%esp
  804308:	5b                   	pop    %ebx
  804309:	5e                   	pop    %esi
  80430a:	5f                   	pop    %edi
  80430b:	5d                   	pop    %ebp
  80430c:	c3                   	ret    
  80430d:	8d 76 00             	lea    0x0(%esi),%esi
  804310:	31 ff                	xor    %edi,%edi
  804312:	31 c0                	xor    %eax,%eax
  804314:	89 fa                	mov    %edi,%edx
  804316:	83 c4 1c             	add    $0x1c,%esp
  804319:	5b                   	pop    %ebx
  80431a:	5e                   	pop    %esi
  80431b:	5f                   	pop    %edi
  80431c:	5d                   	pop    %ebp
  80431d:	c3                   	ret    
  80431e:	66 90                	xchg   %ax,%ax
  804320:	89 d8                	mov    %ebx,%eax
  804322:	f7 f7                	div    %edi
  804324:	31 ff                	xor    %edi,%edi
  804326:	89 fa                	mov    %edi,%edx
  804328:	83 c4 1c             	add    $0x1c,%esp
  80432b:	5b                   	pop    %ebx
  80432c:	5e                   	pop    %esi
  80432d:	5f                   	pop    %edi
  80432e:	5d                   	pop    %ebp
  80432f:	c3                   	ret    
  804330:	bd 20 00 00 00       	mov    $0x20,%ebp
  804335:	89 eb                	mov    %ebp,%ebx
  804337:	29 fb                	sub    %edi,%ebx
  804339:	89 f9                	mov    %edi,%ecx
  80433b:	d3 e6                	shl    %cl,%esi
  80433d:	89 c5                	mov    %eax,%ebp
  80433f:	88 d9                	mov    %bl,%cl
  804341:	d3 ed                	shr    %cl,%ebp
  804343:	89 e9                	mov    %ebp,%ecx
  804345:	09 f1                	or     %esi,%ecx
  804347:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80434b:	89 f9                	mov    %edi,%ecx
  80434d:	d3 e0                	shl    %cl,%eax
  80434f:	89 c5                	mov    %eax,%ebp
  804351:	89 d6                	mov    %edx,%esi
  804353:	88 d9                	mov    %bl,%cl
  804355:	d3 ee                	shr    %cl,%esi
  804357:	89 f9                	mov    %edi,%ecx
  804359:	d3 e2                	shl    %cl,%edx
  80435b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80435f:	88 d9                	mov    %bl,%cl
  804361:	d3 e8                	shr    %cl,%eax
  804363:	09 c2                	or     %eax,%edx
  804365:	89 d0                	mov    %edx,%eax
  804367:	89 f2                	mov    %esi,%edx
  804369:	f7 74 24 0c          	divl   0xc(%esp)
  80436d:	89 d6                	mov    %edx,%esi
  80436f:	89 c3                	mov    %eax,%ebx
  804371:	f7 e5                	mul    %ebp
  804373:	39 d6                	cmp    %edx,%esi
  804375:	72 19                	jb     804390 <__udivdi3+0xfc>
  804377:	74 0b                	je     804384 <__udivdi3+0xf0>
  804379:	89 d8                	mov    %ebx,%eax
  80437b:	31 ff                	xor    %edi,%edi
  80437d:	e9 58 ff ff ff       	jmp    8042da <__udivdi3+0x46>
  804382:	66 90                	xchg   %ax,%ax
  804384:	8b 54 24 08          	mov    0x8(%esp),%edx
  804388:	89 f9                	mov    %edi,%ecx
  80438a:	d3 e2                	shl    %cl,%edx
  80438c:	39 c2                	cmp    %eax,%edx
  80438e:	73 e9                	jae    804379 <__udivdi3+0xe5>
  804390:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804393:	31 ff                	xor    %edi,%edi
  804395:	e9 40 ff ff ff       	jmp    8042da <__udivdi3+0x46>
  80439a:	66 90                	xchg   %ax,%ax
  80439c:	31 c0                	xor    %eax,%eax
  80439e:	e9 37 ff ff ff       	jmp    8042da <__udivdi3+0x46>
  8043a3:	90                   	nop

008043a4 <__umoddi3>:
  8043a4:	55                   	push   %ebp
  8043a5:	57                   	push   %edi
  8043a6:	56                   	push   %esi
  8043a7:	53                   	push   %ebx
  8043a8:	83 ec 1c             	sub    $0x1c,%esp
  8043ab:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8043af:	8b 74 24 34          	mov    0x34(%esp),%esi
  8043b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8043b7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8043bb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8043bf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8043c3:	89 f3                	mov    %esi,%ebx
  8043c5:	89 fa                	mov    %edi,%edx
  8043c7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8043cb:	89 34 24             	mov    %esi,(%esp)
  8043ce:	85 c0                	test   %eax,%eax
  8043d0:	75 1a                	jne    8043ec <__umoddi3+0x48>
  8043d2:	39 f7                	cmp    %esi,%edi
  8043d4:	0f 86 a2 00 00 00    	jbe    80447c <__umoddi3+0xd8>
  8043da:	89 c8                	mov    %ecx,%eax
  8043dc:	89 f2                	mov    %esi,%edx
  8043de:	f7 f7                	div    %edi
  8043e0:	89 d0                	mov    %edx,%eax
  8043e2:	31 d2                	xor    %edx,%edx
  8043e4:	83 c4 1c             	add    $0x1c,%esp
  8043e7:	5b                   	pop    %ebx
  8043e8:	5e                   	pop    %esi
  8043e9:	5f                   	pop    %edi
  8043ea:	5d                   	pop    %ebp
  8043eb:	c3                   	ret    
  8043ec:	39 f0                	cmp    %esi,%eax
  8043ee:	0f 87 ac 00 00 00    	ja     8044a0 <__umoddi3+0xfc>
  8043f4:	0f bd e8             	bsr    %eax,%ebp
  8043f7:	83 f5 1f             	xor    $0x1f,%ebp
  8043fa:	0f 84 ac 00 00 00    	je     8044ac <__umoddi3+0x108>
  804400:	bf 20 00 00 00       	mov    $0x20,%edi
  804405:	29 ef                	sub    %ebp,%edi
  804407:	89 fe                	mov    %edi,%esi
  804409:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80440d:	89 e9                	mov    %ebp,%ecx
  80440f:	d3 e0                	shl    %cl,%eax
  804411:	89 d7                	mov    %edx,%edi
  804413:	89 f1                	mov    %esi,%ecx
  804415:	d3 ef                	shr    %cl,%edi
  804417:	09 c7                	or     %eax,%edi
  804419:	89 e9                	mov    %ebp,%ecx
  80441b:	d3 e2                	shl    %cl,%edx
  80441d:	89 14 24             	mov    %edx,(%esp)
  804420:	89 d8                	mov    %ebx,%eax
  804422:	d3 e0                	shl    %cl,%eax
  804424:	89 c2                	mov    %eax,%edx
  804426:	8b 44 24 08          	mov    0x8(%esp),%eax
  80442a:	d3 e0                	shl    %cl,%eax
  80442c:	89 44 24 04          	mov    %eax,0x4(%esp)
  804430:	8b 44 24 08          	mov    0x8(%esp),%eax
  804434:	89 f1                	mov    %esi,%ecx
  804436:	d3 e8                	shr    %cl,%eax
  804438:	09 d0                	or     %edx,%eax
  80443a:	d3 eb                	shr    %cl,%ebx
  80443c:	89 da                	mov    %ebx,%edx
  80443e:	f7 f7                	div    %edi
  804440:	89 d3                	mov    %edx,%ebx
  804442:	f7 24 24             	mull   (%esp)
  804445:	89 c6                	mov    %eax,%esi
  804447:	89 d1                	mov    %edx,%ecx
  804449:	39 d3                	cmp    %edx,%ebx
  80444b:	0f 82 87 00 00 00    	jb     8044d8 <__umoddi3+0x134>
  804451:	0f 84 91 00 00 00    	je     8044e8 <__umoddi3+0x144>
  804457:	8b 54 24 04          	mov    0x4(%esp),%edx
  80445b:	29 f2                	sub    %esi,%edx
  80445d:	19 cb                	sbb    %ecx,%ebx
  80445f:	89 d8                	mov    %ebx,%eax
  804461:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804465:	d3 e0                	shl    %cl,%eax
  804467:	89 e9                	mov    %ebp,%ecx
  804469:	d3 ea                	shr    %cl,%edx
  80446b:	09 d0                	or     %edx,%eax
  80446d:	89 e9                	mov    %ebp,%ecx
  80446f:	d3 eb                	shr    %cl,%ebx
  804471:	89 da                	mov    %ebx,%edx
  804473:	83 c4 1c             	add    $0x1c,%esp
  804476:	5b                   	pop    %ebx
  804477:	5e                   	pop    %esi
  804478:	5f                   	pop    %edi
  804479:	5d                   	pop    %ebp
  80447a:	c3                   	ret    
  80447b:	90                   	nop
  80447c:	89 fd                	mov    %edi,%ebp
  80447e:	85 ff                	test   %edi,%edi
  804480:	75 0b                	jne    80448d <__umoddi3+0xe9>
  804482:	b8 01 00 00 00       	mov    $0x1,%eax
  804487:	31 d2                	xor    %edx,%edx
  804489:	f7 f7                	div    %edi
  80448b:	89 c5                	mov    %eax,%ebp
  80448d:	89 f0                	mov    %esi,%eax
  80448f:	31 d2                	xor    %edx,%edx
  804491:	f7 f5                	div    %ebp
  804493:	89 c8                	mov    %ecx,%eax
  804495:	f7 f5                	div    %ebp
  804497:	89 d0                	mov    %edx,%eax
  804499:	e9 44 ff ff ff       	jmp    8043e2 <__umoddi3+0x3e>
  80449e:	66 90                	xchg   %ax,%ax
  8044a0:	89 c8                	mov    %ecx,%eax
  8044a2:	89 f2                	mov    %esi,%edx
  8044a4:	83 c4 1c             	add    $0x1c,%esp
  8044a7:	5b                   	pop    %ebx
  8044a8:	5e                   	pop    %esi
  8044a9:	5f                   	pop    %edi
  8044aa:	5d                   	pop    %ebp
  8044ab:	c3                   	ret    
  8044ac:	3b 04 24             	cmp    (%esp),%eax
  8044af:	72 06                	jb     8044b7 <__umoddi3+0x113>
  8044b1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8044b5:	77 0f                	ja     8044c6 <__umoddi3+0x122>
  8044b7:	89 f2                	mov    %esi,%edx
  8044b9:	29 f9                	sub    %edi,%ecx
  8044bb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8044bf:	89 14 24             	mov    %edx,(%esp)
  8044c2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8044c6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8044ca:	8b 14 24             	mov    (%esp),%edx
  8044cd:	83 c4 1c             	add    $0x1c,%esp
  8044d0:	5b                   	pop    %ebx
  8044d1:	5e                   	pop    %esi
  8044d2:	5f                   	pop    %edi
  8044d3:	5d                   	pop    %ebp
  8044d4:	c3                   	ret    
  8044d5:	8d 76 00             	lea    0x0(%esi),%esi
  8044d8:	2b 04 24             	sub    (%esp),%eax
  8044db:	19 fa                	sbb    %edi,%edx
  8044dd:	89 d1                	mov    %edx,%ecx
  8044df:	89 c6                	mov    %eax,%esi
  8044e1:	e9 71 ff ff ff       	jmp    804457 <__umoddi3+0xb3>
  8044e6:	66 90                	xchg   %ax,%ax
  8044e8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8044ec:	72 ea                	jb     8044d8 <__umoddi3+0x134>
  8044ee:	89 d9                	mov    %ebx,%ecx
  8044f0:	e9 62 ff ff ff       	jmp    804457 <__umoddi3+0xb3>
