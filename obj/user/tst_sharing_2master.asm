
obj/user/tst_sharing_2master:     file format elf32-i386


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
  800031:	e8 1d 04 00 00       	call   800453 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: create the shared variables, initialize them and run slaves
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 34             	sub    $0x34,%esp

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
  80005c:	68 c0 42 80 00       	push   $0x8042c0
  800061:	6a 14                	push   $0x14
  800063:	68 dc 42 80 00       	push   $0x8042dc
  800068:	e8 96 05 00 00       	call   800603 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	int eval = 0;
  80006d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  800074:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80007b:	c7 45 ec 00 10 00 82 	movl   $0x82001000,-0x14(%ebp)
	uint32 *x, *y, *z ;
	int diff, expected;

	//x: Readonly
	int freeFrames = sys_calculate_free_frames() ;
  800082:	e8 b4 30 00 00       	call   80313b <sys_calculate_free_frames>
  800087:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = smalloc("x", 4, 0);
  80008a:	83 ec 04             	sub    $0x4,%esp
  80008d:	6a 00                	push   $0x0
  80008f:	6a 04                	push   $0x4
  800091:	68 f7 42 80 00       	push   $0x8042f7
  800096:	e8 65 1f 00 00       	call   802000 <smalloc>
  80009b:	83 c4 10             	add    $0x10,%esp
  80009e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (x != (uint32*)pagealloc_start) {is_correct = 0; cprintf("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");}
  8000a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000a4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8000a7:	74 17                	je     8000c0 <_main+0x88>
  8000a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000b0:	83 ec 0c             	sub    $0xc,%esp
  8000b3:	68 fc 42 80 00       	push   $0x8042fc
  8000b8:	e8 14 08 00 00       	call   8008d1 <cprintf>
  8000bd:	83 c4 10             	add    $0x10,%esp
	expected = 1+1 ; /*1page +1table*/
  8000c0:	c7 45 e0 02 00 00 00 	movl   $0x2,-0x20(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  8000c7:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000ca:	e8 6c 30 00 00       	call   80313b <sys_calculate_free_frames>
  8000cf:	29 c3                	sub    %eax,%ebx
  8000d1:	89 d8                	mov    %ebx,%eax
  8000d3:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  8000d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000d9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8000dc:	7c 0b                	jl     8000e9 <_main+0xb1>
  8000de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000e1:	83 c0 02             	add    $0x2,%eax
  8000e4:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8000e7:	7d 27                	jge    800110 <_main+0xd8>
  8000e9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000f0:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000f3:	e8 43 30 00 00       	call   80313b <sys_calculate_free_frames>
  8000f8:	29 c3                	sub    %eax,%ebx
  8000fa:	89 d8                	mov    %ebx,%eax
  8000fc:	83 ec 04             	sub    $0x4,%esp
  8000ff:	ff 75 e0             	pushl  -0x20(%ebp)
  800102:	50                   	push   %eax
  800103:	68 60 43 80 00       	push   $0x804360
  800108:	e8 c4 07 00 00       	call   8008d1 <cprintf>
  80010d:	83 c4 10             	add    $0x10,%esp

	//y: Readonly
	freeFrames = sys_calculate_free_frames() ;
  800110:	e8 26 30 00 00       	call   80313b <sys_calculate_free_frames>
  800115:	89 45 e8             	mov    %eax,-0x18(%ebp)
	y = smalloc("y", 4, 0);
  800118:	83 ec 04             	sub    $0x4,%esp
  80011b:	6a 00                	push   $0x0
  80011d:	6a 04                	push   $0x4
  80011f:	68 f8 43 80 00       	push   $0x8043f8
  800124:	e8 d7 1e 00 00       	call   802000 <smalloc>
  800129:	83 c4 10             	add    $0x10,%esp
  80012c:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (y != (uint32*)(pagealloc_start + 1 * PAGE_SIZE)) {is_correct = 0; cprintf("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");}
  80012f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800132:	05 00 10 00 00       	add    $0x1000,%eax
  800137:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80013a:	74 17                	je     800153 <_main+0x11b>
  80013c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	68 fc 42 80 00       	push   $0x8042fc
  80014b:	e8 81 07 00 00       	call   8008d1 <cprintf>
  800150:	83 c4 10             	add    $0x10,%esp
	expected = 1 ; /*1page*/
  800153:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  80015a:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  80015d:	e8 d9 2f 00 00       	call   80313b <sys_calculate_free_frames>
  800162:	29 c3                	sub    %eax,%ebx
  800164:	89 d8                	mov    %ebx,%eax
  800166:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800169:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80016c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80016f:	7c 0b                	jl     80017c <_main+0x144>
  800171:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800174:	83 c0 02             	add    $0x2,%eax
  800177:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80017a:	7d 27                	jge    8001a3 <_main+0x16b>
  80017c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800183:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800186:	e8 b0 2f 00 00       	call   80313b <sys_calculate_free_frames>
  80018b:	29 c3                	sub    %eax,%ebx
  80018d:	89 d8                	mov    %ebx,%eax
  80018f:	83 ec 04             	sub    $0x4,%esp
  800192:	ff 75 e0             	pushl  -0x20(%ebp)
  800195:	50                   	push   %eax
  800196:	68 60 43 80 00       	push   $0x804360
  80019b:	e8 31 07 00 00       	call   8008d1 <cprintf>
  8001a0:	83 c4 10             	add    $0x10,%esp

	//z: Writable
	freeFrames = sys_calculate_free_frames() ;
  8001a3:	e8 93 2f 00 00       	call   80313b <sys_calculate_free_frames>
  8001a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = smalloc("z", 4, 1);
  8001ab:	83 ec 04             	sub    $0x4,%esp
  8001ae:	6a 01                	push   $0x1
  8001b0:	6a 04                	push   $0x4
  8001b2:	68 fa 43 80 00       	push   $0x8043fa
  8001b7:	e8 44 1e 00 00       	call   802000 <smalloc>
  8001bc:	83 c4 10             	add    $0x10,%esp
  8001bf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (z != (uint32*)(pagealloc_start + 2 * PAGE_SIZE)) {is_correct = 0; cprintf("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");}
  8001c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001c5:	05 00 20 00 00       	add    $0x2000,%eax
  8001ca:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8001cd:	74 17                	je     8001e6 <_main+0x1ae>
  8001cf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001d6:	83 ec 0c             	sub    $0xc,%esp
  8001d9:	68 fc 42 80 00       	push   $0x8042fc
  8001de:	e8 ee 06 00 00       	call   8008d1 <cprintf>
  8001e3:	83 c4 10             	add    $0x10,%esp
	expected = 1 ; /*1page*/
  8001e6:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  8001ed:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8001f0:	e8 46 2f 00 00       	call   80313b <sys_calculate_free_frames>
  8001f5:	29 c3                	sub    %eax,%ebx
  8001f7:	89 d8                	mov    %ebx,%eax
  8001f9:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  8001fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001ff:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800202:	7c 0b                	jl     80020f <_main+0x1d7>
  800204:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800207:	83 c0 02             	add    $0x2,%eax
  80020a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80020d:	7d 27                	jge    800236 <_main+0x1fe>
  80020f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800216:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800219:	e8 1d 2f 00 00       	call   80313b <sys_calculate_free_frames>
  80021e:	29 c3                	sub    %eax,%ebx
  800220:	89 d8                	mov    %ebx,%eax
  800222:	83 ec 04             	sub    $0x4,%esp
  800225:	ff 75 e0             	pushl  -0x20(%ebp)
  800228:	50                   	push   %eax
  800229:	68 60 43 80 00       	push   $0x804360
  80022e:	e8 9e 06 00 00       	call   8008d1 <cprintf>
  800233:	83 c4 10             	add    $0x10,%esp

	if (is_correct)	eval+=25;
  800236:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80023a:	74 04                	je     800240 <_main+0x208>
  80023c:	83 45 f4 19          	addl   $0x19,-0xc(%ebp)
	is_correct = 1;
  800240:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	*x = 10 ;
  800247:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80024a:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
	*y = 20 ;
  800250:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800253:	c7 00 14 00 00 00    	movl   $0x14,(%eax)

	int id1, id2, id3;
	id1 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800259:	a1 20 50 80 00       	mov    0x805020,%eax
  80025e:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  800264:	a1 20 50 80 00       	mov    0x805020,%eax
  800269:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  80026f:	89 c1                	mov    %eax,%ecx
  800271:	a1 20 50 80 00       	mov    0x805020,%eax
  800276:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80027c:	52                   	push   %edx
  80027d:	51                   	push   %ecx
  80027e:	50                   	push   %eax
  80027f:	68 fc 43 80 00       	push   $0x8043fc
  800284:	e8 0d 30 00 00       	call   803296 <sys_create_env>
  800289:	83 c4 10             	add    $0x10,%esp
  80028c:	89 45 d0             	mov    %eax,-0x30(%ebp)
	id2 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  80028f:	a1 20 50 80 00       	mov    0x805020,%eax
  800294:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  80029a:	a1 20 50 80 00       	mov    0x805020,%eax
  80029f:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  8002a5:	89 c1                	mov    %eax,%ecx
  8002a7:	a1 20 50 80 00       	mov    0x805020,%eax
  8002ac:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8002b2:	52                   	push   %edx
  8002b3:	51                   	push   %ecx
  8002b4:	50                   	push   %eax
  8002b5:	68 fc 43 80 00       	push   $0x8043fc
  8002ba:	e8 d7 2f 00 00       	call   803296 <sys_create_env>
  8002bf:	83 c4 10             	add    $0x10,%esp
  8002c2:	89 45 cc             	mov    %eax,-0x34(%ebp)
	id3 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8002c5:	a1 20 50 80 00       	mov    0x805020,%eax
  8002ca:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  8002d0:	a1 20 50 80 00       	mov    0x805020,%eax
  8002d5:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  8002db:	89 c1                	mov    %eax,%ecx
  8002dd:	a1 20 50 80 00       	mov    0x805020,%eax
  8002e2:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8002e8:	52                   	push   %edx
  8002e9:	51                   	push   %ecx
  8002ea:	50                   	push   %eax
  8002eb:	68 fc 43 80 00       	push   $0x8043fc
  8002f0:	e8 a1 2f 00 00       	call   803296 <sys_create_env>
  8002f5:	83 c4 10             	add    $0x10,%esp
  8002f8:	89 45 c8             	mov    %eax,-0x38(%ebp)

	//to check that the slave environments completed successfully
	rsttst();
  8002fb:	e8 e2 30 00 00       	call   8033e2 <rsttst>

	sys_run_env(id1);
  800300:	83 ec 0c             	sub    $0xc,%esp
  800303:	ff 75 d0             	pushl  -0x30(%ebp)
  800306:	e8 a9 2f 00 00       	call   8032b4 <sys_run_env>
  80030b:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  80030e:	83 ec 0c             	sub    $0xc,%esp
  800311:	ff 75 cc             	pushl  -0x34(%ebp)
  800314:	e8 9b 2f 00 00       	call   8032b4 <sys_run_env>
  800319:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  80031c:	83 ec 0c             	sub    $0xc,%esp
  80031f:	ff 75 c8             	pushl  -0x38(%ebp)
  800322:	e8 8d 2f 00 00       	call   8032b4 <sys_run_env>
  800327:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environments completed successfully
	while (gettst()!=3) ;// panic("test failed");
  80032a:	90                   	nop
  80032b:	e8 2c 31 00 00       	call   80345c <gettst>
  800330:	83 f8 03             	cmp    $0x3,%eax
  800333:	75 f6                	jne    80032b <_main+0x2f3>


	if (*z != 30)
  800335:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800338:	8b 00                	mov    (%eax),%eax
  80033a:	83 f8 1e             	cmp    $0x1e,%eax
  80033d:	74 17                	je     800356 <_main+0x31e>
	{is_correct = 0; cprintf("Error!! Please check the creation (or the getting) of shared variables!!\n\n\n");}
  80033f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800346:	83 ec 0c             	sub    $0xc,%esp
  800349:	68 08 44 80 00       	push   $0x804408
  80034e:	e8 7e 05 00 00       	call   8008d1 <cprintf>
  800353:	83 c4 10             	add    $0x10,%esp

	if (is_correct)	eval+=25;
  800356:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80035a:	74 04                	je     800360 <_main+0x328>
  80035c:	83 45 f4 19          	addl   $0x19,-0xc(%ebp)
	is_correct = 1;
  800360:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	atomic_cprintf("%@Now, attempting to write a ReadOnly variable\n\n\n");
  800367:	83 ec 0c             	sub    $0xc,%esp
  80036a:	68 54 44 80 00       	push   $0x804454
  80036f:	e8 cf 05 00 00       	call   800943 <atomic_cprintf>
  800374:	83 c4 10             	add    $0x10,%esp

	id1 = sys_create_env("shr2Slave2", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800377:	a1 20 50 80 00       	mov    0x805020,%eax
  80037c:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  800382:	a1 20 50 80 00       	mov    0x805020,%eax
  800387:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  80038d:	89 c1                	mov    %eax,%ecx
  80038f:	a1 20 50 80 00       	mov    0x805020,%eax
  800394:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80039a:	52                   	push   %edx
  80039b:	51                   	push   %ecx
  80039c:	50                   	push   %eax
  80039d:	68 86 44 80 00       	push   $0x804486
  8003a2:	e8 ef 2e 00 00       	call   803296 <sys_create_env>
  8003a7:	83 c4 10             	add    $0x10,%esp
  8003aa:	89 45 d0             	mov    %eax,-0x30(%ebp)

	sys_run_env(id1);
  8003ad:	83 ec 0c             	sub    $0xc,%esp
  8003b0:	ff 75 d0             	pushl  -0x30(%ebp)
  8003b3:	e8 fc 2e 00 00       	call   8032b4 <sys_run_env>
  8003b8:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environment edits the z variable
	while (gettst() != 4) ;
  8003bb:	90                   	nop
  8003bc:	e8 9b 30 00 00       	call   80345c <gettst>
  8003c1:	83 f8 04             	cmp    $0x4,%eax
  8003c4:	75 f6                	jne    8003bc <_main+0x384>

	if (*z != 50)
  8003c6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003c9:	8b 00                	mov    (%eax),%eax
  8003cb:	83 f8 32             	cmp    $0x32,%eax
  8003ce:	74 17                	je     8003e7 <_main+0x3af>
	{is_correct = 0; cprintf("Error!! Please check the creation (or the getting) of shared variables!!\n\n\n");}
  8003d0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003d7:	83 ec 0c             	sub    $0xc,%esp
  8003da:	68 08 44 80 00       	push   $0x804408
  8003df:	e8 ed 04 00 00       	call   8008d1 <cprintf>
  8003e4:	83 c4 10             	add    $0x10,%esp

	if (is_correct)	eval+=25;
  8003e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8003eb:	74 04                	je     8003f1 <_main+0x3b9>
  8003ed:	83 45 f4 19          	addl   $0x19,-0xc(%ebp)
	is_correct = 1;
  8003f1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	//Signal slave2
	inctst();
  8003f8:	e8 45 30 00 00       	call   803442 <inctst>

	//to ensure that the slave environment attempt to edit the x variable
	while (gettst()!=6) ;// panic("test failed");
  8003fd:	90                   	nop
  8003fe:	e8 59 30 00 00       	call   80345c <gettst>
  800403:	83 f8 06             	cmp    $0x6,%eax
  800406:	75 f6                	jne    8003fe <_main+0x3c6>

	if (*x != 10)
  800408:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80040b:	8b 00                	mov    (%eax),%eax
  80040d:	83 f8 0a             	cmp    $0xa,%eax
  800410:	74 17                	je     800429 <_main+0x3f1>
	{is_correct = 0; cprintf("Error!! Please check the creation (or the getting) of shared variables!!\n\n\n");}
  800412:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800419:	83 ec 0c             	sub    $0xc,%esp
  80041c:	68 08 44 80 00       	push   $0x804408
  800421:	e8 ab 04 00 00       	call   8008d1 <cprintf>
  800426:	83 c4 10             	add    $0x10,%esp

	if (is_correct)	eval+=25;
  800429:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80042d:	74 04                	je     800433 <_main+0x3fb>
  80042f:	83 45 f4 19          	addl   $0x19,-0xc(%ebp)
	is_correct = 1;
  800433:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf("\n%~Test of Shared Variables [Create & Get] completed. Eval = %d%%\n\n", eval);
  80043a:	83 ec 08             	sub    $0x8,%esp
  80043d:	ff 75 f4             	pushl  -0xc(%ebp)
  800440:	68 94 44 80 00       	push   $0x804494
  800445:	e8 87 04 00 00       	call   8008d1 <cprintf>
  80044a:	83 c4 10             	add    $0x10,%esp
	return;
  80044d:	90                   	nop
}
  80044e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800451:	c9                   	leave  
  800452:	c3                   	ret    

00800453 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800453:	55                   	push   %ebp
  800454:	89 e5                	mov    %esp,%ebp
  800456:	57                   	push   %edi
  800457:	56                   	push   %esi
  800458:	53                   	push   %ebx
  800459:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80045c:	e8 a3 2e 00 00       	call   803304 <sys_getenvindex>
  800461:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800464:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800467:	89 d0                	mov    %edx,%eax
  800469:	c1 e0 03             	shl    $0x3,%eax
  80046c:	01 d0                	add    %edx,%eax
  80046e:	c1 e0 02             	shl    $0x2,%eax
  800471:	01 d0                	add    %edx,%eax
  800473:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80047a:	01 d0                	add    %edx,%eax
  80047c:	c1 e0 03             	shl    $0x3,%eax
  80047f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800484:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800489:	a1 20 50 80 00       	mov    0x805020,%eax
  80048e:	8a 40 20             	mov    0x20(%eax),%al
  800491:	84 c0                	test   %al,%al
  800493:	74 0d                	je     8004a2 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800495:	a1 20 50 80 00       	mov    0x805020,%eax
  80049a:	83 c0 20             	add    $0x20,%eax
  80049d:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8004a6:	7e 0a                	jle    8004b2 <libmain+0x5f>
		binaryname = argv[0];
  8004a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ab:	8b 00                	mov    (%eax),%eax
  8004ad:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  8004b2:	83 ec 08             	sub    $0x8,%esp
  8004b5:	ff 75 0c             	pushl  0xc(%ebp)
  8004b8:	ff 75 08             	pushl  0x8(%ebp)
  8004bb:	e8 78 fb ff ff       	call   800038 <_main>
  8004c0:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8004c3:	a1 00 50 80 00       	mov    0x805000,%eax
  8004c8:	85 c0                	test   %eax,%eax
  8004ca:	0f 84 01 01 00 00    	je     8005d1 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8004d0:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8004d6:	bb d0 45 80 00       	mov    $0x8045d0,%ebx
  8004db:	ba 0e 00 00 00       	mov    $0xe,%edx
  8004e0:	89 c7                	mov    %eax,%edi
  8004e2:	89 de                	mov    %ebx,%esi
  8004e4:	89 d1                	mov    %edx,%ecx
  8004e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8004e8:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8004eb:	b9 56 00 00 00       	mov    $0x56,%ecx
  8004f0:	b0 00                	mov    $0x0,%al
  8004f2:	89 d7                	mov    %edx,%edi
  8004f4:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8004f6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8004fd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800500:	83 ec 08             	sub    $0x8,%esp
  800503:	50                   	push   %eax
  800504:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80050a:	50                   	push   %eax
  80050b:	e8 2a 30 00 00       	call   80353a <sys_utilities>
  800510:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800513:	e8 73 2b 00 00       	call   80308b <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800518:	83 ec 0c             	sub    $0xc,%esp
  80051b:	68 f0 44 80 00       	push   $0x8044f0
  800520:	e8 ac 03 00 00       	call   8008d1 <cprintf>
  800525:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800528:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80052b:	85 c0                	test   %eax,%eax
  80052d:	74 18                	je     800547 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80052f:	e8 24 30 00 00       	call   803558 <sys_get_optimal_num_faults>
  800534:	83 ec 08             	sub    $0x8,%esp
  800537:	50                   	push   %eax
  800538:	68 18 45 80 00       	push   $0x804518
  80053d:	e8 8f 03 00 00       	call   8008d1 <cprintf>
  800542:	83 c4 10             	add    $0x10,%esp
  800545:	eb 59                	jmp    8005a0 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800547:	a1 20 50 80 00       	mov    0x805020,%eax
  80054c:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  800552:	a1 20 50 80 00       	mov    0x805020,%eax
  800557:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80055d:	83 ec 04             	sub    $0x4,%esp
  800560:	52                   	push   %edx
  800561:	50                   	push   %eax
  800562:	68 3c 45 80 00       	push   $0x80453c
  800567:	e8 65 03 00 00       	call   8008d1 <cprintf>
  80056c:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80056f:	a1 20 50 80 00       	mov    0x805020,%eax
  800574:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  80057a:	a1 20 50 80 00       	mov    0x805020,%eax
  80057f:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  800585:	a1 20 50 80 00       	mov    0x805020,%eax
  80058a:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800590:	51                   	push   %ecx
  800591:	52                   	push   %edx
  800592:	50                   	push   %eax
  800593:	68 64 45 80 00       	push   $0x804564
  800598:	e8 34 03 00 00       	call   8008d1 <cprintf>
  80059d:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8005a0:	a1 20 50 80 00       	mov    0x805020,%eax
  8005a5:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  8005ab:	83 ec 08             	sub    $0x8,%esp
  8005ae:	50                   	push   %eax
  8005af:	68 bc 45 80 00       	push   $0x8045bc
  8005b4:	e8 18 03 00 00       	call   8008d1 <cprintf>
  8005b9:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8005bc:	83 ec 0c             	sub    $0xc,%esp
  8005bf:	68 f0 44 80 00       	push   $0x8044f0
  8005c4:	e8 08 03 00 00       	call   8008d1 <cprintf>
  8005c9:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8005cc:	e8 d4 2a 00 00       	call   8030a5 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8005d1:	e8 1f 00 00 00       	call   8005f5 <exit>
}
  8005d6:	90                   	nop
  8005d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005da:	5b                   	pop    %ebx
  8005db:	5e                   	pop    %esi
  8005dc:	5f                   	pop    %edi
  8005dd:	5d                   	pop    %ebp
  8005de:	c3                   	ret    

008005df <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8005df:	55                   	push   %ebp
  8005e0:	89 e5                	mov    %esp,%ebp
  8005e2:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8005e5:	83 ec 0c             	sub    $0xc,%esp
  8005e8:	6a 00                	push   $0x0
  8005ea:	e8 e1 2c 00 00       	call   8032d0 <sys_destroy_env>
  8005ef:	83 c4 10             	add    $0x10,%esp
}
  8005f2:	90                   	nop
  8005f3:	c9                   	leave  
  8005f4:	c3                   	ret    

008005f5 <exit>:

void
exit(void)
{
  8005f5:	55                   	push   %ebp
  8005f6:	89 e5                	mov    %esp,%ebp
  8005f8:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8005fb:	e8 36 2d 00 00       	call   803336 <sys_exit_env>
}
  800600:	90                   	nop
  800601:	c9                   	leave  
  800602:	c3                   	ret    

00800603 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800603:	55                   	push   %ebp
  800604:	89 e5                	mov    %esp,%ebp
  800606:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800609:	8d 45 10             	lea    0x10(%ebp),%eax
  80060c:	83 c0 04             	add    $0x4,%eax
  80060f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800612:	a1 38 51 83 00       	mov    0x835138,%eax
  800617:	85 c0                	test   %eax,%eax
  800619:	74 16                	je     800631 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80061b:	a1 38 51 83 00       	mov    0x835138,%eax
  800620:	83 ec 08             	sub    $0x8,%esp
  800623:	50                   	push   %eax
  800624:	68 34 46 80 00       	push   $0x804634
  800629:	e8 a3 02 00 00       	call   8008d1 <cprintf>
  80062e:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800631:	a1 04 50 80 00       	mov    0x805004,%eax
  800636:	83 ec 0c             	sub    $0xc,%esp
  800639:	ff 75 0c             	pushl  0xc(%ebp)
  80063c:	ff 75 08             	pushl  0x8(%ebp)
  80063f:	50                   	push   %eax
  800640:	68 3c 46 80 00       	push   $0x80463c
  800645:	6a 74                	push   $0x74
  800647:	e8 b2 02 00 00       	call   8008fe <cprintf_colored>
  80064c:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80064f:	8b 45 10             	mov    0x10(%ebp),%eax
  800652:	83 ec 08             	sub    $0x8,%esp
  800655:	ff 75 f4             	pushl  -0xc(%ebp)
  800658:	50                   	push   %eax
  800659:	e8 04 02 00 00       	call   800862 <vcprintf>
  80065e:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800661:	83 ec 08             	sub    $0x8,%esp
  800664:	6a 00                	push   $0x0
  800666:	68 64 46 80 00       	push   $0x804664
  80066b:	e8 f2 01 00 00       	call   800862 <vcprintf>
  800670:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800673:	e8 7d ff ff ff       	call   8005f5 <exit>

	// should not return here
	while (1) ;
  800678:	eb fe                	jmp    800678 <_panic+0x75>

0080067a <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80067a:	55                   	push   %ebp
  80067b:	89 e5                	mov    %esp,%ebp
  80067d:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800680:	a1 20 50 80 00       	mov    0x805020,%eax
  800685:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80068b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80068e:	39 c2                	cmp    %eax,%edx
  800690:	74 14                	je     8006a6 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800692:	83 ec 04             	sub    $0x4,%esp
  800695:	68 68 46 80 00       	push   $0x804668
  80069a:	6a 26                	push   $0x26
  80069c:	68 b4 46 80 00       	push   $0x8046b4
  8006a1:	e8 5d ff ff ff       	call   800603 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8006a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8006ad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8006b4:	e9 c5 00 00 00       	jmp    80077e <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8006b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c6:	01 d0                	add    %edx,%eax
  8006c8:	8b 00                	mov    (%eax),%eax
  8006ca:	85 c0                	test   %eax,%eax
  8006cc:	75 08                	jne    8006d6 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8006ce:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8006d1:	e9 a5 00 00 00       	jmp    80077b <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8006d6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006dd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8006e4:	eb 69                	jmp    80074f <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8006e6:	a1 20 50 80 00       	mov    0x805020,%eax
  8006eb:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8006f1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006f4:	89 d0                	mov    %edx,%eax
  8006f6:	01 c0                	add    %eax,%eax
  8006f8:	01 d0                	add    %edx,%eax
  8006fa:	c1 e0 03             	shl    $0x3,%eax
  8006fd:	01 c8                	add    %ecx,%eax
  8006ff:	8a 40 04             	mov    0x4(%eax),%al
  800702:	84 c0                	test   %al,%al
  800704:	75 46                	jne    80074c <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800706:	a1 20 50 80 00       	mov    0x805020,%eax
  80070b:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800711:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800714:	89 d0                	mov    %edx,%eax
  800716:	01 c0                	add    %eax,%eax
  800718:	01 d0                	add    %edx,%eax
  80071a:	c1 e0 03             	shl    $0x3,%eax
  80071d:	01 c8                	add    %ecx,%eax
  80071f:	8b 00                	mov    (%eax),%eax
  800721:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800724:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800727:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80072c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80072e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800731:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800738:	8b 45 08             	mov    0x8(%ebp),%eax
  80073b:	01 c8                	add    %ecx,%eax
  80073d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80073f:	39 c2                	cmp    %eax,%edx
  800741:	75 09                	jne    80074c <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800743:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80074a:	eb 15                	jmp    800761 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80074c:	ff 45 e8             	incl   -0x18(%ebp)
  80074f:	a1 20 50 80 00       	mov    0x805020,%eax
  800754:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80075a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80075d:	39 c2                	cmp    %eax,%edx
  80075f:	77 85                	ja     8006e6 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800761:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800765:	75 14                	jne    80077b <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800767:	83 ec 04             	sub    $0x4,%esp
  80076a:	68 c0 46 80 00       	push   $0x8046c0
  80076f:	6a 3a                	push   $0x3a
  800771:	68 b4 46 80 00       	push   $0x8046b4
  800776:	e8 88 fe ff ff       	call   800603 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80077b:	ff 45 f0             	incl   -0x10(%ebp)
  80077e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800781:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800784:	0f 8c 2f ff ff ff    	jl     8006b9 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80078a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800791:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800798:	eb 26                	jmp    8007c0 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80079a:	a1 20 50 80 00       	mov    0x805020,%eax
  80079f:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8007a5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007a8:	89 d0                	mov    %edx,%eax
  8007aa:	01 c0                	add    %eax,%eax
  8007ac:	01 d0                	add    %edx,%eax
  8007ae:	c1 e0 03             	shl    $0x3,%eax
  8007b1:	01 c8                	add    %ecx,%eax
  8007b3:	8a 40 04             	mov    0x4(%eax),%al
  8007b6:	3c 01                	cmp    $0x1,%al
  8007b8:	75 03                	jne    8007bd <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8007ba:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007bd:	ff 45 e0             	incl   -0x20(%ebp)
  8007c0:	a1 20 50 80 00       	mov    0x805020,%eax
  8007c5:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8007cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007ce:	39 c2                	cmp    %eax,%edx
  8007d0:	77 c8                	ja     80079a <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8007d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007d5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8007d8:	74 14                	je     8007ee <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8007da:	83 ec 04             	sub    $0x4,%esp
  8007dd:	68 14 47 80 00       	push   $0x804714
  8007e2:	6a 44                	push   $0x44
  8007e4:	68 b4 46 80 00       	push   $0x8046b4
  8007e9:	e8 15 fe ff ff       	call   800603 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8007ee:	90                   	nop
  8007ef:	c9                   	leave  
  8007f0:	c3                   	ret    

008007f1 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8007f1:	55                   	push   %ebp
  8007f2:	89 e5                	mov    %esp,%ebp
  8007f4:	53                   	push   %ebx
  8007f5:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8007f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007fb:	8b 00                	mov    (%eax),%eax
  8007fd:	8d 48 01             	lea    0x1(%eax),%ecx
  800800:	8b 55 0c             	mov    0xc(%ebp),%edx
  800803:	89 0a                	mov    %ecx,(%edx)
  800805:	8b 55 08             	mov    0x8(%ebp),%edx
  800808:	88 d1                	mov    %dl,%cl
  80080a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80080d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800811:	8b 45 0c             	mov    0xc(%ebp),%eax
  800814:	8b 00                	mov    (%eax),%eax
  800816:	3d ff 00 00 00       	cmp    $0xff,%eax
  80081b:	75 30                	jne    80084d <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80081d:	8b 15 3c 51 83 00    	mov    0x83513c,%edx
  800823:	a0 64 d0 81 00       	mov    0x81d064,%al
  800828:	0f b6 c0             	movzbl %al,%eax
  80082b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80082e:	8b 09                	mov    (%ecx),%ecx
  800830:	89 cb                	mov    %ecx,%ebx
  800832:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800835:	83 c1 08             	add    $0x8,%ecx
  800838:	52                   	push   %edx
  800839:	50                   	push   %eax
  80083a:	53                   	push   %ebx
  80083b:	51                   	push   %ecx
  80083c:	e8 06 28 00 00       	call   803047 <sys_cputs>
  800841:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800844:	8b 45 0c             	mov    0xc(%ebp),%eax
  800847:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80084d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800850:	8b 40 04             	mov    0x4(%eax),%eax
  800853:	8d 50 01             	lea    0x1(%eax),%edx
  800856:	8b 45 0c             	mov    0xc(%ebp),%eax
  800859:	89 50 04             	mov    %edx,0x4(%eax)
}
  80085c:	90                   	nop
  80085d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800860:	c9                   	leave  
  800861:	c3                   	ret    

00800862 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800862:	55                   	push   %ebp
  800863:	89 e5                	mov    %esp,%ebp
  800865:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80086b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800872:	00 00 00 
	b.cnt = 0;
  800875:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80087c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80087f:	ff 75 0c             	pushl  0xc(%ebp)
  800882:	ff 75 08             	pushl  0x8(%ebp)
  800885:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80088b:	50                   	push   %eax
  80088c:	68 f1 07 80 00       	push   $0x8007f1
  800891:	e8 5a 02 00 00       	call   800af0 <vprintfmt>
  800896:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800899:	8b 15 3c 51 83 00    	mov    0x83513c,%edx
  80089f:	a0 64 d0 81 00       	mov    0x81d064,%al
  8008a4:	0f b6 c0             	movzbl %al,%eax
  8008a7:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8008ad:	52                   	push   %edx
  8008ae:	50                   	push   %eax
  8008af:	51                   	push   %ecx
  8008b0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8008b6:	83 c0 08             	add    $0x8,%eax
  8008b9:	50                   	push   %eax
  8008ba:	e8 88 27 00 00       	call   803047 <sys_cputs>
  8008bf:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8008c2:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
	return b.cnt;
  8008c9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8008cf:	c9                   	leave  
  8008d0:	c3                   	ret    

008008d1 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8008d1:	55                   	push   %ebp
  8008d2:	89 e5                	mov    %esp,%ebp
  8008d4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8008d7:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	va_start(ap, fmt);
  8008de:	8d 45 0c             	lea    0xc(%ebp),%eax
  8008e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8008e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e7:	83 ec 08             	sub    $0x8,%esp
  8008ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8008ed:	50                   	push   %eax
  8008ee:	e8 6f ff ff ff       	call   800862 <vcprintf>
  8008f3:	83 c4 10             	add    $0x10,%esp
  8008f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8008f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008fc:	c9                   	leave  
  8008fd:	c3                   	ret    

008008fe <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8008fe:	55                   	push   %ebp
  8008ff:	89 e5                	mov    %esp,%ebp
  800901:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800904:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	curTextClr = (textClr << 8) ; //set text color by the given value
  80090b:	8b 45 08             	mov    0x8(%ebp),%eax
  80090e:	c1 e0 08             	shl    $0x8,%eax
  800911:	a3 3c 51 83 00       	mov    %eax,0x83513c
	va_start(ap, fmt);
  800916:	8d 45 0c             	lea    0xc(%ebp),%eax
  800919:	83 c0 04             	add    $0x4,%eax
  80091c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80091f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800922:	83 ec 08             	sub    $0x8,%esp
  800925:	ff 75 f4             	pushl  -0xc(%ebp)
  800928:	50                   	push   %eax
  800929:	e8 34 ff ff ff       	call   800862 <vcprintf>
  80092e:	83 c4 10             	add    $0x10,%esp
  800931:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800934:	c7 05 3c 51 83 00 00 	movl   $0x700,0x83513c
  80093b:	07 00 00 

	return cnt;
  80093e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800941:	c9                   	leave  
  800942:	c3                   	ret    

00800943 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800943:	55                   	push   %ebp
  800944:	89 e5                	mov    %esp,%ebp
  800946:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800949:	e8 3d 27 00 00       	call   80308b <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80094e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800951:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800954:	8b 45 08             	mov    0x8(%ebp),%eax
  800957:	83 ec 08             	sub    $0x8,%esp
  80095a:	ff 75 f4             	pushl  -0xc(%ebp)
  80095d:	50                   	push   %eax
  80095e:	e8 ff fe ff ff       	call   800862 <vcprintf>
  800963:	83 c4 10             	add    $0x10,%esp
  800966:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800969:	e8 37 27 00 00       	call   8030a5 <sys_unlock_cons>
	return cnt;
  80096e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800971:	c9                   	leave  
  800972:	c3                   	ret    

00800973 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800973:	55                   	push   %ebp
  800974:	89 e5                	mov    %esp,%ebp
  800976:	53                   	push   %ebx
  800977:	83 ec 14             	sub    $0x14,%esp
  80097a:	8b 45 10             	mov    0x10(%ebp),%eax
  80097d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800980:	8b 45 14             	mov    0x14(%ebp),%eax
  800983:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800986:	8b 45 18             	mov    0x18(%ebp),%eax
  800989:	ba 00 00 00 00       	mov    $0x0,%edx
  80098e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800991:	77 55                	ja     8009e8 <printnum+0x75>
  800993:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800996:	72 05                	jb     80099d <printnum+0x2a>
  800998:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80099b:	77 4b                	ja     8009e8 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80099d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8009a0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8009a3:	8b 45 18             	mov    0x18(%ebp),%eax
  8009a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ab:	52                   	push   %edx
  8009ac:	50                   	push   %eax
  8009ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8009b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8009b3:	e8 a4 36 00 00       	call   80405c <__udivdi3>
  8009b8:	83 c4 10             	add    $0x10,%esp
  8009bb:	83 ec 04             	sub    $0x4,%esp
  8009be:	ff 75 20             	pushl  0x20(%ebp)
  8009c1:	53                   	push   %ebx
  8009c2:	ff 75 18             	pushl  0x18(%ebp)
  8009c5:	52                   	push   %edx
  8009c6:	50                   	push   %eax
  8009c7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ca:	ff 75 08             	pushl  0x8(%ebp)
  8009cd:	e8 a1 ff ff ff       	call   800973 <printnum>
  8009d2:	83 c4 20             	add    $0x20,%esp
  8009d5:	eb 1a                	jmp    8009f1 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8009d7:	83 ec 08             	sub    $0x8,%esp
  8009da:	ff 75 0c             	pushl  0xc(%ebp)
  8009dd:	ff 75 20             	pushl  0x20(%ebp)
  8009e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e3:	ff d0                	call   *%eax
  8009e5:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8009e8:	ff 4d 1c             	decl   0x1c(%ebp)
  8009eb:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8009ef:	7f e6                	jg     8009d7 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8009f1:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8009f4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8009f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009ff:	53                   	push   %ebx
  800a00:	51                   	push   %ecx
  800a01:	52                   	push   %edx
  800a02:	50                   	push   %eax
  800a03:	e8 64 37 00 00       	call   80416c <__umoddi3>
  800a08:	83 c4 10             	add    $0x10,%esp
  800a0b:	05 74 49 80 00       	add    $0x804974,%eax
  800a10:	8a 00                	mov    (%eax),%al
  800a12:	0f be c0             	movsbl %al,%eax
  800a15:	83 ec 08             	sub    $0x8,%esp
  800a18:	ff 75 0c             	pushl  0xc(%ebp)
  800a1b:	50                   	push   %eax
  800a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1f:	ff d0                	call   *%eax
  800a21:	83 c4 10             	add    $0x10,%esp
}
  800a24:	90                   	nop
  800a25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a28:	c9                   	leave  
  800a29:	c3                   	ret    

00800a2a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800a2a:	55                   	push   %ebp
  800a2b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a2d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a31:	7e 1c                	jle    800a4f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800a33:	8b 45 08             	mov    0x8(%ebp),%eax
  800a36:	8b 00                	mov    (%eax),%eax
  800a38:	8d 50 08             	lea    0x8(%eax),%edx
  800a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3e:	89 10                	mov    %edx,(%eax)
  800a40:	8b 45 08             	mov    0x8(%ebp),%eax
  800a43:	8b 00                	mov    (%eax),%eax
  800a45:	83 e8 08             	sub    $0x8,%eax
  800a48:	8b 50 04             	mov    0x4(%eax),%edx
  800a4b:	8b 00                	mov    (%eax),%eax
  800a4d:	eb 40                	jmp    800a8f <getuint+0x65>
	else if (lflag)
  800a4f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a53:	74 1e                	je     800a73 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800a55:	8b 45 08             	mov    0x8(%ebp),%eax
  800a58:	8b 00                	mov    (%eax),%eax
  800a5a:	8d 50 04             	lea    0x4(%eax),%edx
  800a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a60:	89 10                	mov    %edx,(%eax)
  800a62:	8b 45 08             	mov    0x8(%ebp),%eax
  800a65:	8b 00                	mov    (%eax),%eax
  800a67:	83 e8 04             	sub    $0x4,%eax
  800a6a:	8b 00                	mov    (%eax),%eax
  800a6c:	ba 00 00 00 00       	mov    $0x0,%edx
  800a71:	eb 1c                	jmp    800a8f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800a73:	8b 45 08             	mov    0x8(%ebp),%eax
  800a76:	8b 00                	mov    (%eax),%eax
  800a78:	8d 50 04             	lea    0x4(%eax),%edx
  800a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7e:	89 10                	mov    %edx,(%eax)
  800a80:	8b 45 08             	mov    0x8(%ebp),%eax
  800a83:	8b 00                	mov    (%eax),%eax
  800a85:	83 e8 04             	sub    $0x4,%eax
  800a88:	8b 00                	mov    (%eax),%eax
  800a8a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800a8f:	5d                   	pop    %ebp
  800a90:	c3                   	ret    

00800a91 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800a91:	55                   	push   %ebp
  800a92:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a94:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a98:	7e 1c                	jle    800ab6 <getint+0x25>
		return va_arg(*ap, long long);
  800a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9d:	8b 00                	mov    (%eax),%eax
  800a9f:	8d 50 08             	lea    0x8(%eax),%edx
  800aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa5:	89 10                	mov    %edx,(%eax)
  800aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aaa:	8b 00                	mov    (%eax),%eax
  800aac:	83 e8 08             	sub    $0x8,%eax
  800aaf:	8b 50 04             	mov    0x4(%eax),%edx
  800ab2:	8b 00                	mov    (%eax),%eax
  800ab4:	eb 38                	jmp    800aee <getint+0x5d>
	else if (lflag)
  800ab6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800aba:	74 1a                	je     800ad6 <getint+0x45>
		return va_arg(*ap, long);
  800abc:	8b 45 08             	mov    0x8(%ebp),%eax
  800abf:	8b 00                	mov    (%eax),%eax
  800ac1:	8d 50 04             	lea    0x4(%eax),%edx
  800ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac7:	89 10                	mov    %edx,(%eax)
  800ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  800acc:	8b 00                	mov    (%eax),%eax
  800ace:	83 e8 04             	sub    $0x4,%eax
  800ad1:	8b 00                	mov    (%eax),%eax
  800ad3:	99                   	cltd   
  800ad4:	eb 18                	jmp    800aee <getint+0x5d>
	else
		return va_arg(*ap, int);
  800ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad9:	8b 00                	mov    (%eax),%eax
  800adb:	8d 50 04             	lea    0x4(%eax),%edx
  800ade:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae1:	89 10                	mov    %edx,(%eax)
  800ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae6:	8b 00                	mov    (%eax),%eax
  800ae8:	83 e8 04             	sub    $0x4,%eax
  800aeb:	8b 00                	mov    (%eax),%eax
  800aed:	99                   	cltd   
}
  800aee:	5d                   	pop    %ebp
  800aef:	c3                   	ret    

00800af0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800af0:	55                   	push   %ebp
  800af1:	89 e5                	mov    %esp,%ebp
  800af3:	56                   	push   %esi
  800af4:	53                   	push   %ebx
  800af5:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800af8:	eb 17                	jmp    800b11 <vprintfmt+0x21>
			if (ch == '\0')
  800afa:	85 db                	test   %ebx,%ebx
  800afc:	0f 84 c1 03 00 00    	je     800ec3 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800b02:	83 ec 08             	sub    $0x8,%esp
  800b05:	ff 75 0c             	pushl  0xc(%ebp)
  800b08:	53                   	push   %ebx
  800b09:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0c:	ff d0                	call   *%eax
  800b0e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b11:	8b 45 10             	mov    0x10(%ebp),%eax
  800b14:	8d 50 01             	lea    0x1(%eax),%edx
  800b17:	89 55 10             	mov    %edx,0x10(%ebp)
  800b1a:	8a 00                	mov    (%eax),%al
  800b1c:	0f b6 d8             	movzbl %al,%ebx
  800b1f:	83 fb 25             	cmp    $0x25,%ebx
  800b22:	75 d6                	jne    800afa <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b24:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800b28:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800b2f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800b36:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800b3d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b44:	8b 45 10             	mov    0x10(%ebp),%eax
  800b47:	8d 50 01             	lea    0x1(%eax),%edx
  800b4a:	89 55 10             	mov    %edx,0x10(%ebp)
  800b4d:	8a 00                	mov    (%eax),%al
  800b4f:	0f b6 d8             	movzbl %al,%ebx
  800b52:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800b55:	83 f8 5b             	cmp    $0x5b,%eax
  800b58:	0f 87 3d 03 00 00    	ja     800e9b <vprintfmt+0x3ab>
  800b5e:	8b 04 85 98 49 80 00 	mov    0x804998(,%eax,4),%eax
  800b65:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800b67:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800b6b:	eb d7                	jmp    800b44 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800b6d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800b71:	eb d1                	jmp    800b44 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b73:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800b7a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800b7d:	89 d0                	mov    %edx,%eax
  800b7f:	c1 e0 02             	shl    $0x2,%eax
  800b82:	01 d0                	add    %edx,%eax
  800b84:	01 c0                	add    %eax,%eax
  800b86:	01 d8                	add    %ebx,%eax
  800b88:	83 e8 30             	sub    $0x30,%eax
  800b8b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800b8e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b91:	8a 00                	mov    (%eax),%al
  800b93:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800b96:	83 fb 2f             	cmp    $0x2f,%ebx
  800b99:	7e 3e                	jle    800bd9 <vprintfmt+0xe9>
  800b9b:	83 fb 39             	cmp    $0x39,%ebx
  800b9e:	7f 39                	jg     800bd9 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ba0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ba3:	eb d5                	jmp    800b7a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ba5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba8:	83 c0 04             	add    $0x4,%eax
  800bab:	89 45 14             	mov    %eax,0x14(%ebp)
  800bae:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb1:	83 e8 04             	sub    $0x4,%eax
  800bb4:	8b 00                	mov    (%eax),%eax
  800bb6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800bb9:	eb 1f                	jmp    800bda <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800bbb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bbf:	79 83                	jns    800b44 <vprintfmt+0x54>
				width = 0;
  800bc1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800bc8:	e9 77 ff ff ff       	jmp    800b44 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800bcd:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800bd4:	e9 6b ff ff ff       	jmp    800b44 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800bd9:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800bda:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bde:	0f 89 60 ff ff ff    	jns    800b44 <vprintfmt+0x54>
				width = precision, precision = -1;
  800be4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800be7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800bea:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800bf1:	e9 4e ff ff ff       	jmp    800b44 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800bf6:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800bf9:	e9 46 ff ff ff       	jmp    800b44 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800bfe:	8b 45 14             	mov    0x14(%ebp),%eax
  800c01:	83 c0 04             	add    $0x4,%eax
  800c04:	89 45 14             	mov    %eax,0x14(%ebp)
  800c07:	8b 45 14             	mov    0x14(%ebp),%eax
  800c0a:	83 e8 04             	sub    $0x4,%eax
  800c0d:	8b 00                	mov    (%eax),%eax
  800c0f:	83 ec 08             	sub    $0x8,%esp
  800c12:	ff 75 0c             	pushl  0xc(%ebp)
  800c15:	50                   	push   %eax
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
  800c19:	ff d0                	call   *%eax
  800c1b:	83 c4 10             	add    $0x10,%esp
			break;
  800c1e:	e9 9b 02 00 00       	jmp    800ebe <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800c23:	8b 45 14             	mov    0x14(%ebp),%eax
  800c26:	83 c0 04             	add    $0x4,%eax
  800c29:	89 45 14             	mov    %eax,0x14(%ebp)
  800c2c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c2f:	83 e8 04             	sub    $0x4,%eax
  800c32:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800c34:	85 db                	test   %ebx,%ebx
  800c36:	79 02                	jns    800c3a <vprintfmt+0x14a>
				err = -err;
  800c38:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800c3a:	83 fb 64             	cmp    $0x64,%ebx
  800c3d:	7f 0b                	jg     800c4a <vprintfmt+0x15a>
  800c3f:	8b 34 9d e0 47 80 00 	mov    0x8047e0(,%ebx,4),%esi
  800c46:	85 f6                	test   %esi,%esi
  800c48:	75 19                	jne    800c63 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800c4a:	53                   	push   %ebx
  800c4b:	68 85 49 80 00       	push   $0x804985
  800c50:	ff 75 0c             	pushl  0xc(%ebp)
  800c53:	ff 75 08             	pushl  0x8(%ebp)
  800c56:	e8 70 02 00 00       	call   800ecb <printfmt>
  800c5b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c5e:	e9 5b 02 00 00       	jmp    800ebe <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c63:	56                   	push   %esi
  800c64:	68 8e 49 80 00       	push   $0x80498e
  800c69:	ff 75 0c             	pushl  0xc(%ebp)
  800c6c:	ff 75 08             	pushl  0x8(%ebp)
  800c6f:	e8 57 02 00 00       	call   800ecb <printfmt>
  800c74:	83 c4 10             	add    $0x10,%esp
			break;
  800c77:	e9 42 02 00 00       	jmp    800ebe <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800c7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c7f:	83 c0 04             	add    $0x4,%eax
  800c82:	89 45 14             	mov    %eax,0x14(%ebp)
  800c85:	8b 45 14             	mov    0x14(%ebp),%eax
  800c88:	83 e8 04             	sub    $0x4,%eax
  800c8b:	8b 30                	mov    (%eax),%esi
  800c8d:	85 f6                	test   %esi,%esi
  800c8f:	75 05                	jne    800c96 <vprintfmt+0x1a6>
				p = "(null)";
  800c91:	be 91 49 80 00       	mov    $0x804991,%esi
			if (width > 0 && padc != '-')
  800c96:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c9a:	7e 6d                	jle    800d09 <vprintfmt+0x219>
  800c9c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ca0:	74 67                	je     800d09 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ca2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ca5:	83 ec 08             	sub    $0x8,%esp
  800ca8:	50                   	push   %eax
  800ca9:	56                   	push   %esi
  800caa:	e8 1e 03 00 00       	call   800fcd <strnlen>
  800caf:	83 c4 10             	add    $0x10,%esp
  800cb2:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800cb5:	eb 16                	jmp    800ccd <vprintfmt+0x1dd>
					putch(padc, putdat);
  800cb7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800cbb:	83 ec 08             	sub    $0x8,%esp
  800cbe:	ff 75 0c             	pushl  0xc(%ebp)
  800cc1:	50                   	push   %eax
  800cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc5:	ff d0                	call   *%eax
  800cc7:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800cca:	ff 4d e4             	decl   -0x1c(%ebp)
  800ccd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cd1:	7f e4                	jg     800cb7 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cd3:	eb 34                	jmp    800d09 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800cd5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800cd9:	74 1c                	je     800cf7 <vprintfmt+0x207>
  800cdb:	83 fb 1f             	cmp    $0x1f,%ebx
  800cde:	7e 05                	jle    800ce5 <vprintfmt+0x1f5>
  800ce0:	83 fb 7e             	cmp    $0x7e,%ebx
  800ce3:	7e 12                	jle    800cf7 <vprintfmt+0x207>
					putch('?', putdat);
  800ce5:	83 ec 08             	sub    $0x8,%esp
  800ce8:	ff 75 0c             	pushl  0xc(%ebp)
  800ceb:	6a 3f                	push   $0x3f
  800ced:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf0:	ff d0                	call   *%eax
  800cf2:	83 c4 10             	add    $0x10,%esp
  800cf5:	eb 0f                	jmp    800d06 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800cf7:	83 ec 08             	sub    $0x8,%esp
  800cfa:	ff 75 0c             	pushl  0xc(%ebp)
  800cfd:	53                   	push   %ebx
  800cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800d01:	ff d0                	call   *%eax
  800d03:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d06:	ff 4d e4             	decl   -0x1c(%ebp)
  800d09:	89 f0                	mov    %esi,%eax
  800d0b:	8d 70 01             	lea    0x1(%eax),%esi
  800d0e:	8a 00                	mov    (%eax),%al
  800d10:	0f be d8             	movsbl %al,%ebx
  800d13:	85 db                	test   %ebx,%ebx
  800d15:	74 24                	je     800d3b <vprintfmt+0x24b>
  800d17:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d1b:	78 b8                	js     800cd5 <vprintfmt+0x1e5>
  800d1d:	ff 4d e0             	decl   -0x20(%ebp)
  800d20:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d24:	79 af                	jns    800cd5 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d26:	eb 13                	jmp    800d3b <vprintfmt+0x24b>
				putch(' ', putdat);
  800d28:	83 ec 08             	sub    $0x8,%esp
  800d2b:	ff 75 0c             	pushl  0xc(%ebp)
  800d2e:	6a 20                	push   $0x20
  800d30:	8b 45 08             	mov    0x8(%ebp),%eax
  800d33:	ff d0                	call   *%eax
  800d35:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d38:	ff 4d e4             	decl   -0x1c(%ebp)
  800d3b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d3f:	7f e7                	jg     800d28 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800d41:	e9 78 01 00 00       	jmp    800ebe <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800d46:	83 ec 08             	sub    $0x8,%esp
  800d49:	ff 75 e8             	pushl  -0x18(%ebp)
  800d4c:	8d 45 14             	lea    0x14(%ebp),%eax
  800d4f:	50                   	push   %eax
  800d50:	e8 3c fd ff ff       	call   800a91 <getint>
  800d55:	83 c4 10             	add    $0x10,%esp
  800d58:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d5b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800d5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d64:	85 d2                	test   %edx,%edx
  800d66:	79 23                	jns    800d8b <vprintfmt+0x29b>
				putch('-', putdat);
  800d68:	83 ec 08             	sub    $0x8,%esp
  800d6b:	ff 75 0c             	pushl  0xc(%ebp)
  800d6e:	6a 2d                	push   $0x2d
  800d70:	8b 45 08             	mov    0x8(%ebp),%eax
  800d73:	ff d0                	call   *%eax
  800d75:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800d78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d7e:	f7 d8                	neg    %eax
  800d80:	83 d2 00             	adc    $0x0,%edx
  800d83:	f7 da                	neg    %edx
  800d85:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d88:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800d8b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800d92:	e9 bc 00 00 00       	jmp    800e53 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800d97:	83 ec 08             	sub    $0x8,%esp
  800d9a:	ff 75 e8             	pushl  -0x18(%ebp)
  800d9d:	8d 45 14             	lea    0x14(%ebp),%eax
  800da0:	50                   	push   %eax
  800da1:	e8 84 fc ff ff       	call   800a2a <getuint>
  800da6:	83 c4 10             	add    $0x10,%esp
  800da9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dac:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800daf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800db6:	e9 98 00 00 00       	jmp    800e53 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800dbb:	83 ec 08             	sub    $0x8,%esp
  800dbe:	ff 75 0c             	pushl  0xc(%ebp)
  800dc1:	6a 58                	push   $0x58
  800dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc6:	ff d0                	call   *%eax
  800dc8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800dcb:	83 ec 08             	sub    $0x8,%esp
  800dce:	ff 75 0c             	pushl  0xc(%ebp)
  800dd1:	6a 58                	push   $0x58
  800dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd6:	ff d0                	call   *%eax
  800dd8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ddb:	83 ec 08             	sub    $0x8,%esp
  800dde:	ff 75 0c             	pushl  0xc(%ebp)
  800de1:	6a 58                	push   $0x58
  800de3:	8b 45 08             	mov    0x8(%ebp),%eax
  800de6:	ff d0                	call   *%eax
  800de8:	83 c4 10             	add    $0x10,%esp
			break;
  800deb:	e9 ce 00 00 00       	jmp    800ebe <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800df0:	83 ec 08             	sub    $0x8,%esp
  800df3:	ff 75 0c             	pushl  0xc(%ebp)
  800df6:	6a 30                	push   $0x30
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	ff d0                	call   *%eax
  800dfd:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e00:	83 ec 08             	sub    $0x8,%esp
  800e03:	ff 75 0c             	pushl  0xc(%ebp)
  800e06:	6a 78                	push   $0x78
  800e08:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0b:	ff d0                	call   *%eax
  800e0d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e10:	8b 45 14             	mov    0x14(%ebp),%eax
  800e13:	83 c0 04             	add    $0x4,%eax
  800e16:	89 45 14             	mov    %eax,0x14(%ebp)
  800e19:	8b 45 14             	mov    0x14(%ebp),%eax
  800e1c:	83 e8 04             	sub    $0x4,%eax
  800e1f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e21:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e24:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800e2b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800e32:	eb 1f                	jmp    800e53 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800e34:	83 ec 08             	sub    $0x8,%esp
  800e37:	ff 75 e8             	pushl  -0x18(%ebp)
  800e3a:	8d 45 14             	lea    0x14(%ebp),%eax
  800e3d:	50                   	push   %eax
  800e3e:	e8 e7 fb ff ff       	call   800a2a <getuint>
  800e43:	83 c4 10             	add    $0x10,%esp
  800e46:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e49:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800e4c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e53:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800e57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e5a:	83 ec 04             	sub    $0x4,%esp
  800e5d:	52                   	push   %edx
  800e5e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800e61:	50                   	push   %eax
  800e62:	ff 75 f4             	pushl  -0xc(%ebp)
  800e65:	ff 75 f0             	pushl  -0x10(%ebp)
  800e68:	ff 75 0c             	pushl  0xc(%ebp)
  800e6b:	ff 75 08             	pushl  0x8(%ebp)
  800e6e:	e8 00 fb ff ff       	call   800973 <printnum>
  800e73:	83 c4 20             	add    $0x20,%esp
			break;
  800e76:	eb 46                	jmp    800ebe <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e78:	83 ec 08             	sub    $0x8,%esp
  800e7b:	ff 75 0c             	pushl  0xc(%ebp)
  800e7e:	53                   	push   %ebx
  800e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e82:	ff d0                	call   *%eax
  800e84:	83 c4 10             	add    $0x10,%esp
			break;
  800e87:	eb 35                	jmp    800ebe <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800e89:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
			break;
  800e90:	eb 2c                	jmp    800ebe <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800e92:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
			break;
  800e99:	eb 23                	jmp    800ebe <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e9b:	83 ec 08             	sub    $0x8,%esp
  800e9e:	ff 75 0c             	pushl  0xc(%ebp)
  800ea1:	6a 25                	push   $0x25
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	ff d0                	call   *%eax
  800ea8:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800eab:	ff 4d 10             	decl   0x10(%ebp)
  800eae:	eb 03                	jmp    800eb3 <vprintfmt+0x3c3>
  800eb0:	ff 4d 10             	decl   0x10(%ebp)
  800eb3:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb6:	48                   	dec    %eax
  800eb7:	8a 00                	mov    (%eax),%al
  800eb9:	3c 25                	cmp    $0x25,%al
  800ebb:	75 f3                	jne    800eb0 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800ebd:	90                   	nop
		}
	}
  800ebe:	e9 35 fc ff ff       	jmp    800af8 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ec3:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ec4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ec7:	5b                   	pop    %ebx
  800ec8:	5e                   	pop    %esi
  800ec9:	5d                   	pop    %ebp
  800eca:	c3                   	ret    

00800ecb <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ecb:	55                   	push   %ebp
  800ecc:	89 e5                	mov    %esp,%ebp
  800ece:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ed1:	8d 45 10             	lea    0x10(%ebp),%eax
  800ed4:	83 c0 04             	add    $0x4,%eax
  800ed7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800eda:	8b 45 10             	mov    0x10(%ebp),%eax
  800edd:	ff 75 f4             	pushl  -0xc(%ebp)
  800ee0:	50                   	push   %eax
  800ee1:	ff 75 0c             	pushl  0xc(%ebp)
  800ee4:	ff 75 08             	pushl  0x8(%ebp)
  800ee7:	e8 04 fc ff ff       	call   800af0 <vprintfmt>
  800eec:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800eef:	90                   	nop
  800ef0:	c9                   	leave  
  800ef1:	c3                   	ret    

00800ef2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ef2:	55                   	push   %ebp
  800ef3:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800ef5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef8:	8b 40 08             	mov    0x8(%eax),%eax
  800efb:	8d 50 01             	lea    0x1(%eax),%edx
  800efe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f01:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f07:	8b 10                	mov    (%eax),%edx
  800f09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0c:	8b 40 04             	mov    0x4(%eax),%eax
  800f0f:	39 c2                	cmp    %eax,%edx
  800f11:	73 12                	jae    800f25 <sprintputch+0x33>
		*b->buf++ = ch;
  800f13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f16:	8b 00                	mov    (%eax),%eax
  800f18:	8d 48 01             	lea    0x1(%eax),%ecx
  800f1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f1e:	89 0a                	mov    %ecx,(%edx)
  800f20:	8b 55 08             	mov    0x8(%ebp),%edx
  800f23:	88 10                	mov    %dl,(%eax)
}
  800f25:	90                   	nop
  800f26:	5d                   	pop    %ebp
  800f27:	c3                   	ret    

00800f28 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f28:	55                   	push   %ebp
  800f29:	89 e5                	mov    %esp,%ebp
  800f2b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f31:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f37:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	01 d0                	add    %edx,%eax
  800f3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f42:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800f49:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f4d:	74 06                	je     800f55 <vsnprintf+0x2d>
  800f4f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f53:	7f 07                	jg     800f5c <vsnprintf+0x34>
		return -E_INVAL;
  800f55:	b8 03 00 00 00       	mov    $0x3,%eax
  800f5a:	eb 20                	jmp    800f7c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800f5c:	ff 75 14             	pushl  0x14(%ebp)
  800f5f:	ff 75 10             	pushl  0x10(%ebp)
  800f62:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800f65:	50                   	push   %eax
  800f66:	68 f2 0e 80 00       	push   $0x800ef2
  800f6b:	e8 80 fb ff ff       	call   800af0 <vprintfmt>
  800f70:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800f73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f76:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800f7c:	c9                   	leave  
  800f7d:	c3                   	ret    

00800f7e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f7e:	55                   	push   %ebp
  800f7f:	89 e5                	mov    %esp,%ebp
  800f81:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800f84:	8d 45 10             	lea    0x10(%ebp),%eax
  800f87:	83 c0 04             	add    $0x4,%eax
  800f8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800f8d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f90:	ff 75 f4             	pushl  -0xc(%ebp)
  800f93:	50                   	push   %eax
  800f94:	ff 75 0c             	pushl  0xc(%ebp)
  800f97:	ff 75 08             	pushl  0x8(%ebp)
  800f9a:	e8 89 ff ff ff       	call   800f28 <vsnprintf>
  800f9f:	83 c4 10             	add    $0x10,%esp
  800fa2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800fa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800fa8:	c9                   	leave  
  800fa9:	c3                   	ret    

00800faa <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800faa:	55                   	push   %ebp
  800fab:	89 e5                	mov    %esp,%ebp
  800fad:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800fb0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fb7:	eb 06                	jmp    800fbf <strlen+0x15>
		n++;
  800fb9:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800fbc:	ff 45 08             	incl   0x8(%ebp)
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc2:	8a 00                	mov    (%eax),%al
  800fc4:	84 c0                	test   %al,%al
  800fc6:	75 f1                	jne    800fb9 <strlen+0xf>
		n++;
	return n;
  800fc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800fcb:	c9                   	leave  
  800fcc:	c3                   	ret    

00800fcd <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800fcd:	55                   	push   %ebp
  800fce:	89 e5                	mov    %esp,%ebp
  800fd0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800fd3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fda:	eb 09                	jmp    800fe5 <strnlen+0x18>
		n++;
  800fdc:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800fdf:	ff 45 08             	incl   0x8(%ebp)
  800fe2:	ff 4d 0c             	decl   0xc(%ebp)
  800fe5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fe9:	74 09                	je     800ff4 <strnlen+0x27>
  800feb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fee:	8a 00                	mov    (%eax),%al
  800ff0:	84 c0                	test   %al,%al
  800ff2:	75 e8                	jne    800fdc <strnlen+0xf>
		n++;
	return n;
  800ff4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ff7:	c9                   	leave  
  800ff8:	c3                   	ret    

00800ff9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ff9:	55                   	push   %ebp
  800ffa:	89 e5                	mov    %esp,%ebp
  800ffc:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800fff:	8b 45 08             	mov    0x8(%ebp),%eax
  801002:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801005:	90                   	nop
  801006:	8b 45 08             	mov    0x8(%ebp),%eax
  801009:	8d 50 01             	lea    0x1(%eax),%edx
  80100c:	89 55 08             	mov    %edx,0x8(%ebp)
  80100f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801012:	8d 4a 01             	lea    0x1(%edx),%ecx
  801015:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801018:	8a 12                	mov    (%edx),%dl
  80101a:	88 10                	mov    %dl,(%eax)
  80101c:	8a 00                	mov    (%eax),%al
  80101e:	84 c0                	test   %al,%al
  801020:	75 e4                	jne    801006 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801022:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801025:	c9                   	leave  
  801026:	c3                   	ret    

00801027 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801027:	55                   	push   %ebp
  801028:	89 e5                	mov    %esp,%ebp
  80102a:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
  801030:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801033:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80103a:	eb 1f                	jmp    80105b <strncpy+0x34>
		*dst++ = *src;
  80103c:	8b 45 08             	mov    0x8(%ebp),%eax
  80103f:	8d 50 01             	lea    0x1(%eax),%edx
  801042:	89 55 08             	mov    %edx,0x8(%ebp)
  801045:	8b 55 0c             	mov    0xc(%ebp),%edx
  801048:	8a 12                	mov    (%edx),%dl
  80104a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80104c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104f:	8a 00                	mov    (%eax),%al
  801051:	84 c0                	test   %al,%al
  801053:	74 03                	je     801058 <strncpy+0x31>
			src++;
  801055:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801058:	ff 45 fc             	incl   -0x4(%ebp)
  80105b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80105e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801061:	72 d9                	jb     80103c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801063:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801066:	c9                   	leave  
  801067:	c3                   	ret    

00801068 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801068:	55                   	push   %ebp
  801069:	89 e5                	mov    %esp,%ebp
  80106b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80106e:	8b 45 08             	mov    0x8(%ebp),%eax
  801071:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801074:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801078:	74 30                	je     8010aa <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80107a:	eb 16                	jmp    801092 <strlcpy+0x2a>
			*dst++ = *src++;
  80107c:	8b 45 08             	mov    0x8(%ebp),%eax
  80107f:	8d 50 01             	lea    0x1(%eax),%edx
  801082:	89 55 08             	mov    %edx,0x8(%ebp)
  801085:	8b 55 0c             	mov    0xc(%ebp),%edx
  801088:	8d 4a 01             	lea    0x1(%edx),%ecx
  80108b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80108e:	8a 12                	mov    (%edx),%dl
  801090:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801092:	ff 4d 10             	decl   0x10(%ebp)
  801095:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801099:	74 09                	je     8010a4 <strlcpy+0x3c>
  80109b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109e:	8a 00                	mov    (%eax),%al
  8010a0:	84 c0                	test   %al,%al
  8010a2:	75 d8                	jne    80107c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8010aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010b0:	29 c2                	sub    %eax,%edx
  8010b2:	89 d0                	mov    %edx,%eax
}
  8010b4:	c9                   	leave  
  8010b5:	c3                   	ret    

008010b6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010b6:	55                   	push   %ebp
  8010b7:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8010b9:	eb 06                	jmp    8010c1 <strcmp+0xb>
		p++, q++;
  8010bb:	ff 45 08             	incl   0x8(%ebp)
  8010be:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	8a 00                	mov    (%eax),%al
  8010c6:	84 c0                	test   %al,%al
  8010c8:	74 0e                	je     8010d8 <strcmp+0x22>
  8010ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cd:	8a 10                	mov    (%eax),%dl
  8010cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d2:	8a 00                	mov    (%eax),%al
  8010d4:	38 c2                	cmp    %al,%dl
  8010d6:	74 e3                	je     8010bb <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8010d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010db:	8a 00                	mov    (%eax),%al
  8010dd:	0f b6 d0             	movzbl %al,%edx
  8010e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e3:	8a 00                	mov    (%eax),%al
  8010e5:	0f b6 c0             	movzbl %al,%eax
  8010e8:	29 c2                	sub    %eax,%edx
  8010ea:	89 d0                	mov    %edx,%eax
}
  8010ec:	5d                   	pop    %ebp
  8010ed:	c3                   	ret    

008010ee <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8010ee:	55                   	push   %ebp
  8010ef:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8010f1:	eb 09                	jmp    8010fc <strncmp+0xe>
		n--, p++, q++;
  8010f3:	ff 4d 10             	decl   0x10(%ebp)
  8010f6:	ff 45 08             	incl   0x8(%ebp)
  8010f9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8010fc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801100:	74 17                	je     801119 <strncmp+0x2b>
  801102:	8b 45 08             	mov    0x8(%ebp),%eax
  801105:	8a 00                	mov    (%eax),%al
  801107:	84 c0                	test   %al,%al
  801109:	74 0e                	je     801119 <strncmp+0x2b>
  80110b:	8b 45 08             	mov    0x8(%ebp),%eax
  80110e:	8a 10                	mov    (%eax),%dl
  801110:	8b 45 0c             	mov    0xc(%ebp),%eax
  801113:	8a 00                	mov    (%eax),%al
  801115:	38 c2                	cmp    %al,%dl
  801117:	74 da                	je     8010f3 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801119:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80111d:	75 07                	jne    801126 <strncmp+0x38>
		return 0;
  80111f:	b8 00 00 00 00       	mov    $0x0,%eax
  801124:	eb 14                	jmp    80113a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	8a 00                	mov    (%eax),%al
  80112b:	0f b6 d0             	movzbl %al,%edx
  80112e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801131:	8a 00                	mov    (%eax),%al
  801133:	0f b6 c0             	movzbl %al,%eax
  801136:	29 c2                	sub    %eax,%edx
  801138:	89 d0                	mov    %edx,%eax
}
  80113a:	5d                   	pop    %ebp
  80113b:	c3                   	ret    

0080113c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80113c:	55                   	push   %ebp
  80113d:	89 e5                	mov    %esp,%ebp
  80113f:	83 ec 04             	sub    $0x4,%esp
  801142:	8b 45 0c             	mov    0xc(%ebp),%eax
  801145:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801148:	eb 12                	jmp    80115c <strchr+0x20>
		if (*s == c)
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	8a 00                	mov    (%eax),%al
  80114f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801152:	75 05                	jne    801159 <strchr+0x1d>
			return (char *) s;
  801154:	8b 45 08             	mov    0x8(%ebp),%eax
  801157:	eb 11                	jmp    80116a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801159:	ff 45 08             	incl   0x8(%ebp)
  80115c:	8b 45 08             	mov    0x8(%ebp),%eax
  80115f:	8a 00                	mov    (%eax),%al
  801161:	84 c0                	test   %al,%al
  801163:	75 e5                	jne    80114a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801165:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80116a:	c9                   	leave  
  80116b:	c3                   	ret    

0080116c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80116c:	55                   	push   %ebp
  80116d:	89 e5                	mov    %esp,%ebp
  80116f:	83 ec 04             	sub    $0x4,%esp
  801172:	8b 45 0c             	mov    0xc(%ebp),%eax
  801175:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801178:	eb 0d                	jmp    801187 <strfind+0x1b>
		if (*s == c)
  80117a:	8b 45 08             	mov    0x8(%ebp),%eax
  80117d:	8a 00                	mov    (%eax),%al
  80117f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801182:	74 0e                	je     801192 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801184:	ff 45 08             	incl   0x8(%ebp)
  801187:	8b 45 08             	mov    0x8(%ebp),%eax
  80118a:	8a 00                	mov    (%eax),%al
  80118c:	84 c0                	test   %al,%al
  80118e:	75 ea                	jne    80117a <strfind+0xe>
  801190:	eb 01                	jmp    801193 <strfind+0x27>
		if (*s == c)
			break;
  801192:	90                   	nop
	return (char *) s;
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801196:	c9                   	leave  
  801197:	c3                   	ret    

00801198 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801198:	55                   	push   %ebp
  801199:	89 e5                	mov    %esp,%ebp
  80119b:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  80119e:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8011a4:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8011a8:	76 63                	jbe    80120d <memset+0x75>
		uint64 data_block = c;
  8011aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ad:	99                   	cltd   
  8011ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011b1:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8011b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011ba:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8011be:	c1 e0 08             	shl    $0x8,%eax
  8011c1:	09 45 f0             	or     %eax,-0x10(%ebp)
  8011c4:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8011c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011cd:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8011d1:	c1 e0 10             	shl    $0x10,%eax
  8011d4:	09 45 f0             	or     %eax,-0x10(%ebp)
  8011d7:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8011da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011e0:	89 c2                	mov    %eax,%edx
  8011e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8011e7:	09 45 f0             	or     %eax,-0x10(%ebp)
  8011ea:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8011ed:	eb 18                	jmp    801207 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8011ef:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011f2:	8d 41 08             	lea    0x8(%ecx),%eax
  8011f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8011f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011fe:	89 01                	mov    %eax,(%ecx)
  801200:	89 51 04             	mov    %edx,0x4(%ecx)
  801203:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801207:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80120b:	77 e2                	ja     8011ef <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80120d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801211:	74 23                	je     801236 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801213:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801216:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801219:	eb 0e                	jmp    801229 <memset+0x91>
			*p8++ = (uint8)c;
  80121b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80121e:	8d 50 01             	lea    0x1(%eax),%edx
  801221:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801224:	8b 55 0c             	mov    0xc(%ebp),%edx
  801227:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801229:	8b 45 10             	mov    0x10(%ebp),%eax
  80122c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80122f:	89 55 10             	mov    %edx,0x10(%ebp)
  801232:	85 c0                	test   %eax,%eax
  801234:	75 e5                	jne    80121b <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801236:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801239:	c9                   	leave  
  80123a:	c3                   	ret    

0080123b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80123b:	55                   	push   %ebp
  80123c:	89 e5                	mov    %esp,%ebp
  80123e:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801241:	8b 45 0c             	mov    0xc(%ebp),%eax
  801244:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801247:	8b 45 08             	mov    0x8(%ebp),%eax
  80124a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80124d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801251:	76 24                	jbe    801277 <memcpy+0x3c>
		while(n >= 8){
  801253:	eb 1c                	jmp    801271 <memcpy+0x36>
			*d64 = *s64;
  801255:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801258:	8b 50 04             	mov    0x4(%eax),%edx
  80125b:	8b 00                	mov    (%eax),%eax
  80125d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801260:	89 01                	mov    %eax,(%ecx)
  801262:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801265:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801269:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80126d:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801271:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801275:	77 de                	ja     801255 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801277:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80127b:	74 31                	je     8012ae <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80127d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801280:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801283:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801286:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801289:	eb 16                	jmp    8012a1 <memcpy+0x66>
			*d8++ = *s8++;
  80128b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80128e:	8d 50 01             	lea    0x1(%eax),%edx
  801291:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801294:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801297:	8d 4a 01             	lea    0x1(%edx),%ecx
  80129a:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80129d:	8a 12                	mov    (%edx),%dl
  80129f:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8012a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012a7:	89 55 10             	mov    %edx,0x10(%ebp)
  8012aa:	85 c0                	test   %eax,%eax
  8012ac:	75 dd                	jne    80128b <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8012ae:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012b1:	c9                   	leave  
  8012b2:	c3                   	ret    

008012b3 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8012b3:	55                   	push   %ebp
  8012b4:	89 e5                	mov    %esp,%ebp
  8012b6:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8012c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012c8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012cb:	73 50                	jae    80131d <memmove+0x6a>
  8012cd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d3:	01 d0                	add    %edx,%eax
  8012d5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012d8:	76 43                	jbe    80131d <memmove+0x6a>
		s += n;
  8012da:	8b 45 10             	mov    0x10(%ebp),%eax
  8012dd:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8012e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e3:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012e6:	eb 10                	jmp    8012f8 <memmove+0x45>
			*--d = *--s;
  8012e8:	ff 4d f8             	decl   -0x8(%ebp)
  8012eb:	ff 4d fc             	decl   -0x4(%ebp)
  8012ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f1:	8a 10                	mov    (%eax),%dl
  8012f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f6:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012fb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012fe:	89 55 10             	mov    %edx,0x10(%ebp)
  801301:	85 c0                	test   %eax,%eax
  801303:	75 e3                	jne    8012e8 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801305:	eb 23                	jmp    80132a <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801307:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80130a:	8d 50 01             	lea    0x1(%eax),%edx
  80130d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801310:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801313:	8d 4a 01             	lea    0x1(%edx),%ecx
  801316:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801319:	8a 12                	mov    (%edx),%dl
  80131b:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80131d:	8b 45 10             	mov    0x10(%ebp),%eax
  801320:	8d 50 ff             	lea    -0x1(%eax),%edx
  801323:	89 55 10             	mov    %edx,0x10(%ebp)
  801326:	85 c0                	test   %eax,%eax
  801328:	75 dd                	jne    801307 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80132a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80132d:	c9                   	leave  
  80132e:	c3                   	ret    

0080132f <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80132f:	55                   	push   %ebp
  801330:	89 e5                	mov    %esp,%ebp
  801332:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801335:	8b 45 08             	mov    0x8(%ebp),%eax
  801338:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80133b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133e:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801341:	eb 2a                	jmp    80136d <memcmp+0x3e>
		if (*s1 != *s2)
  801343:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801346:	8a 10                	mov    (%eax),%dl
  801348:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80134b:	8a 00                	mov    (%eax),%al
  80134d:	38 c2                	cmp    %al,%dl
  80134f:	74 16                	je     801367 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801351:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801354:	8a 00                	mov    (%eax),%al
  801356:	0f b6 d0             	movzbl %al,%edx
  801359:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80135c:	8a 00                	mov    (%eax),%al
  80135e:	0f b6 c0             	movzbl %al,%eax
  801361:	29 c2                	sub    %eax,%edx
  801363:	89 d0                	mov    %edx,%eax
  801365:	eb 18                	jmp    80137f <memcmp+0x50>
		s1++, s2++;
  801367:	ff 45 fc             	incl   -0x4(%ebp)
  80136a:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80136d:	8b 45 10             	mov    0x10(%ebp),%eax
  801370:	8d 50 ff             	lea    -0x1(%eax),%edx
  801373:	89 55 10             	mov    %edx,0x10(%ebp)
  801376:	85 c0                	test   %eax,%eax
  801378:	75 c9                	jne    801343 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80137a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80137f:	c9                   	leave  
  801380:	c3                   	ret    

00801381 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801381:	55                   	push   %ebp
  801382:	89 e5                	mov    %esp,%ebp
  801384:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801387:	8b 55 08             	mov    0x8(%ebp),%edx
  80138a:	8b 45 10             	mov    0x10(%ebp),%eax
  80138d:	01 d0                	add    %edx,%eax
  80138f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801392:	eb 15                	jmp    8013a9 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801394:	8b 45 08             	mov    0x8(%ebp),%eax
  801397:	8a 00                	mov    (%eax),%al
  801399:	0f b6 d0             	movzbl %al,%edx
  80139c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139f:	0f b6 c0             	movzbl %al,%eax
  8013a2:	39 c2                	cmp    %eax,%edx
  8013a4:	74 0d                	je     8013b3 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013a6:	ff 45 08             	incl   0x8(%ebp)
  8013a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ac:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013af:	72 e3                	jb     801394 <memfind+0x13>
  8013b1:	eb 01                	jmp    8013b4 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8013b3:	90                   	nop
	return (void *) s;
  8013b4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013b7:	c9                   	leave  
  8013b8:	c3                   	ret    

008013b9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013b9:	55                   	push   %ebp
  8013ba:	89 e5                	mov    %esp,%ebp
  8013bc:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8013bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8013c6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013cd:	eb 03                	jmp    8013d2 <strtol+0x19>
		s++;
  8013cf:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d5:	8a 00                	mov    (%eax),%al
  8013d7:	3c 20                	cmp    $0x20,%al
  8013d9:	74 f4                	je     8013cf <strtol+0x16>
  8013db:	8b 45 08             	mov    0x8(%ebp),%eax
  8013de:	8a 00                	mov    (%eax),%al
  8013e0:	3c 09                	cmp    $0x9,%al
  8013e2:	74 eb                	je     8013cf <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e7:	8a 00                	mov    (%eax),%al
  8013e9:	3c 2b                	cmp    $0x2b,%al
  8013eb:	75 05                	jne    8013f2 <strtol+0x39>
		s++;
  8013ed:	ff 45 08             	incl   0x8(%ebp)
  8013f0:	eb 13                	jmp    801405 <strtol+0x4c>
	else if (*s == '-')
  8013f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	3c 2d                	cmp    $0x2d,%al
  8013f9:	75 0a                	jne    801405 <strtol+0x4c>
		s++, neg = 1;
  8013fb:	ff 45 08             	incl   0x8(%ebp)
  8013fe:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801405:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801409:	74 06                	je     801411 <strtol+0x58>
  80140b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80140f:	75 20                	jne    801431 <strtol+0x78>
  801411:	8b 45 08             	mov    0x8(%ebp),%eax
  801414:	8a 00                	mov    (%eax),%al
  801416:	3c 30                	cmp    $0x30,%al
  801418:	75 17                	jne    801431 <strtol+0x78>
  80141a:	8b 45 08             	mov    0x8(%ebp),%eax
  80141d:	40                   	inc    %eax
  80141e:	8a 00                	mov    (%eax),%al
  801420:	3c 78                	cmp    $0x78,%al
  801422:	75 0d                	jne    801431 <strtol+0x78>
		s += 2, base = 16;
  801424:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801428:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80142f:	eb 28                	jmp    801459 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801431:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801435:	75 15                	jne    80144c <strtol+0x93>
  801437:	8b 45 08             	mov    0x8(%ebp),%eax
  80143a:	8a 00                	mov    (%eax),%al
  80143c:	3c 30                	cmp    $0x30,%al
  80143e:	75 0c                	jne    80144c <strtol+0x93>
		s++, base = 8;
  801440:	ff 45 08             	incl   0x8(%ebp)
  801443:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80144a:	eb 0d                	jmp    801459 <strtol+0xa0>
	else if (base == 0)
  80144c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801450:	75 07                	jne    801459 <strtol+0xa0>
		base = 10;
  801452:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801459:	8b 45 08             	mov    0x8(%ebp),%eax
  80145c:	8a 00                	mov    (%eax),%al
  80145e:	3c 2f                	cmp    $0x2f,%al
  801460:	7e 19                	jle    80147b <strtol+0xc2>
  801462:	8b 45 08             	mov    0x8(%ebp),%eax
  801465:	8a 00                	mov    (%eax),%al
  801467:	3c 39                	cmp    $0x39,%al
  801469:	7f 10                	jg     80147b <strtol+0xc2>
			dig = *s - '0';
  80146b:	8b 45 08             	mov    0x8(%ebp),%eax
  80146e:	8a 00                	mov    (%eax),%al
  801470:	0f be c0             	movsbl %al,%eax
  801473:	83 e8 30             	sub    $0x30,%eax
  801476:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801479:	eb 42                	jmp    8014bd <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80147b:	8b 45 08             	mov    0x8(%ebp),%eax
  80147e:	8a 00                	mov    (%eax),%al
  801480:	3c 60                	cmp    $0x60,%al
  801482:	7e 19                	jle    80149d <strtol+0xe4>
  801484:	8b 45 08             	mov    0x8(%ebp),%eax
  801487:	8a 00                	mov    (%eax),%al
  801489:	3c 7a                	cmp    $0x7a,%al
  80148b:	7f 10                	jg     80149d <strtol+0xe4>
			dig = *s - 'a' + 10;
  80148d:	8b 45 08             	mov    0x8(%ebp),%eax
  801490:	8a 00                	mov    (%eax),%al
  801492:	0f be c0             	movsbl %al,%eax
  801495:	83 e8 57             	sub    $0x57,%eax
  801498:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80149b:	eb 20                	jmp    8014bd <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80149d:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a0:	8a 00                	mov    (%eax),%al
  8014a2:	3c 40                	cmp    $0x40,%al
  8014a4:	7e 39                	jle    8014df <strtol+0x126>
  8014a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a9:	8a 00                	mov    (%eax),%al
  8014ab:	3c 5a                	cmp    $0x5a,%al
  8014ad:	7f 30                	jg     8014df <strtol+0x126>
			dig = *s - 'A' + 10;
  8014af:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b2:	8a 00                	mov    (%eax),%al
  8014b4:	0f be c0             	movsbl %al,%eax
  8014b7:	83 e8 37             	sub    $0x37,%eax
  8014ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8014bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014c0:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014c3:	7d 19                	jge    8014de <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8014c5:	ff 45 08             	incl   0x8(%ebp)
  8014c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014cb:	0f af 45 10          	imul   0x10(%ebp),%eax
  8014cf:	89 c2                	mov    %eax,%edx
  8014d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014d4:	01 d0                	add    %edx,%eax
  8014d6:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8014d9:	e9 7b ff ff ff       	jmp    801459 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8014de:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8014df:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014e3:	74 08                	je     8014ed <strtol+0x134>
		*endptr = (char *) s;
  8014e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8014eb:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8014ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014f1:	74 07                	je     8014fa <strtol+0x141>
  8014f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f6:	f7 d8                	neg    %eax
  8014f8:	eb 03                	jmp    8014fd <strtol+0x144>
  8014fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014fd:	c9                   	leave  
  8014fe:	c3                   	ret    

008014ff <ltostr>:

void
ltostr(long value, char *str)
{
  8014ff:	55                   	push   %ebp
  801500:	89 e5                	mov    %esp,%ebp
  801502:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801505:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80150c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801513:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801517:	79 13                	jns    80152c <ltostr+0x2d>
	{
		neg = 1;
  801519:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801520:	8b 45 0c             	mov    0xc(%ebp),%eax
  801523:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801526:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801529:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80152c:	8b 45 08             	mov    0x8(%ebp),%eax
  80152f:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801534:	99                   	cltd   
  801535:	f7 f9                	idiv   %ecx
  801537:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80153a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80153d:	8d 50 01             	lea    0x1(%eax),%edx
  801540:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801543:	89 c2                	mov    %eax,%edx
  801545:	8b 45 0c             	mov    0xc(%ebp),%eax
  801548:	01 d0                	add    %edx,%eax
  80154a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80154d:	83 c2 30             	add    $0x30,%edx
  801550:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801552:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801555:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80155a:	f7 e9                	imul   %ecx
  80155c:	c1 fa 02             	sar    $0x2,%edx
  80155f:	89 c8                	mov    %ecx,%eax
  801561:	c1 f8 1f             	sar    $0x1f,%eax
  801564:	29 c2                	sub    %eax,%edx
  801566:	89 d0                	mov    %edx,%eax
  801568:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80156b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80156f:	75 bb                	jne    80152c <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801571:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801578:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80157b:	48                   	dec    %eax
  80157c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80157f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801583:	74 3d                	je     8015c2 <ltostr+0xc3>
		start = 1 ;
  801585:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80158c:	eb 34                	jmp    8015c2 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80158e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801591:	8b 45 0c             	mov    0xc(%ebp),%eax
  801594:	01 d0                	add    %edx,%eax
  801596:	8a 00                	mov    (%eax),%al
  801598:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80159b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80159e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a1:	01 c2                	add    %eax,%edx
  8015a3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8015a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a9:	01 c8                	add    %ecx,%eax
  8015ab:	8a 00                	mov    (%eax),%al
  8015ad:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8015af:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b5:	01 c2                	add    %eax,%edx
  8015b7:	8a 45 eb             	mov    -0x15(%ebp),%al
  8015ba:	88 02                	mov    %al,(%edx)
		start++ ;
  8015bc:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8015bf:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8015c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015c8:	7c c4                	jl     80158e <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8015ca:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8015cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d0:	01 d0                	add    %edx,%eax
  8015d2:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015d5:	90                   	nop
  8015d6:	c9                   	leave  
  8015d7:	c3                   	ret    

008015d8 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015d8:	55                   	push   %ebp
  8015d9:	89 e5                	mov    %esp,%ebp
  8015db:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8015de:	ff 75 08             	pushl  0x8(%ebp)
  8015e1:	e8 c4 f9 ff ff       	call   800faa <strlen>
  8015e6:	83 c4 04             	add    $0x4,%esp
  8015e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8015ec:	ff 75 0c             	pushl  0xc(%ebp)
  8015ef:	e8 b6 f9 ff ff       	call   800faa <strlen>
  8015f4:	83 c4 04             	add    $0x4,%esp
  8015f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801601:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801608:	eb 17                	jmp    801621 <strcconcat+0x49>
		final[s] = str1[s] ;
  80160a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80160d:	8b 45 10             	mov    0x10(%ebp),%eax
  801610:	01 c2                	add    %eax,%edx
  801612:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801615:	8b 45 08             	mov    0x8(%ebp),%eax
  801618:	01 c8                	add    %ecx,%eax
  80161a:	8a 00                	mov    (%eax),%al
  80161c:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80161e:	ff 45 fc             	incl   -0x4(%ebp)
  801621:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801624:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801627:	7c e1                	jl     80160a <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801629:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801630:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801637:	eb 1f                	jmp    801658 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801639:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80163c:	8d 50 01             	lea    0x1(%eax),%edx
  80163f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801642:	89 c2                	mov    %eax,%edx
  801644:	8b 45 10             	mov    0x10(%ebp),%eax
  801647:	01 c2                	add    %eax,%edx
  801649:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80164c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164f:	01 c8                	add    %ecx,%eax
  801651:	8a 00                	mov    (%eax),%al
  801653:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801655:	ff 45 f8             	incl   -0x8(%ebp)
  801658:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80165b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80165e:	7c d9                	jl     801639 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801660:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801663:	8b 45 10             	mov    0x10(%ebp),%eax
  801666:	01 d0                	add    %edx,%eax
  801668:	c6 00 00             	movb   $0x0,(%eax)
}
  80166b:	90                   	nop
  80166c:	c9                   	leave  
  80166d:	c3                   	ret    

0080166e <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80166e:	55                   	push   %ebp
  80166f:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801671:	8b 45 14             	mov    0x14(%ebp),%eax
  801674:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80167a:	8b 45 14             	mov    0x14(%ebp),%eax
  80167d:	8b 00                	mov    (%eax),%eax
  80167f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801686:	8b 45 10             	mov    0x10(%ebp),%eax
  801689:	01 d0                	add    %edx,%eax
  80168b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801691:	eb 0c                	jmp    80169f <strsplit+0x31>
			*string++ = 0;
  801693:	8b 45 08             	mov    0x8(%ebp),%eax
  801696:	8d 50 01             	lea    0x1(%eax),%edx
  801699:	89 55 08             	mov    %edx,0x8(%ebp)
  80169c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80169f:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a2:	8a 00                	mov    (%eax),%al
  8016a4:	84 c0                	test   %al,%al
  8016a6:	74 18                	je     8016c0 <strsplit+0x52>
  8016a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ab:	8a 00                	mov    (%eax),%al
  8016ad:	0f be c0             	movsbl %al,%eax
  8016b0:	50                   	push   %eax
  8016b1:	ff 75 0c             	pushl  0xc(%ebp)
  8016b4:	e8 83 fa ff ff       	call   80113c <strchr>
  8016b9:	83 c4 08             	add    $0x8,%esp
  8016bc:	85 c0                	test   %eax,%eax
  8016be:	75 d3                	jne    801693 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8016c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c3:	8a 00                	mov    (%eax),%al
  8016c5:	84 c0                	test   %al,%al
  8016c7:	74 5a                	je     801723 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8016c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8016cc:	8b 00                	mov    (%eax),%eax
  8016ce:	83 f8 0f             	cmp    $0xf,%eax
  8016d1:	75 07                	jne    8016da <strsplit+0x6c>
		{
			return 0;
  8016d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d8:	eb 66                	jmp    801740 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8016da:	8b 45 14             	mov    0x14(%ebp),%eax
  8016dd:	8b 00                	mov    (%eax),%eax
  8016df:	8d 48 01             	lea    0x1(%eax),%ecx
  8016e2:	8b 55 14             	mov    0x14(%ebp),%edx
  8016e5:	89 0a                	mov    %ecx,(%edx)
  8016e7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f1:	01 c2                	add    %eax,%edx
  8016f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f6:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016f8:	eb 03                	jmp    8016fd <strsplit+0x8f>
			string++;
  8016fa:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801700:	8a 00                	mov    (%eax),%al
  801702:	84 c0                	test   %al,%al
  801704:	74 8b                	je     801691 <strsplit+0x23>
  801706:	8b 45 08             	mov    0x8(%ebp),%eax
  801709:	8a 00                	mov    (%eax),%al
  80170b:	0f be c0             	movsbl %al,%eax
  80170e:	50                   	push   %eax
  80170f:	ff 75 0c             	pushl  0xc(%ebp)
  801712:	e8 25 fa ff ff       	call   80113c <strchr>
  801717:	83 c4 08             	add    $0x8,%esp
  80171a:	85 c0                	test   %eax,%eax
  80171c:	74 dc                	je     8016fa <strsplit+0x8c>
			string++;
	}
  80171e:	e9 6e ff ff ff       	jmp    801691 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801723:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801724:	8b 45 14             	mov    0x14(%ebp),%eax
  801727:	8b 00                	mov    (%eax),%eax
  801729:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801730:	8b 45 10             	mov    0x10(%ebp),%eax
  801733:	01 d0                	add    %edx,%eax
  801735:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80173b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801740:	c9                   	leave  
  801741:	c3                   	ret    

00801742 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801742:	55                   	push   %ebp
  801743:	89 e5                	mov    %esp,%ebp
  801745:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801748:	8b 45 08             	mov    0x8(%ebp),%eax
  80174b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80174e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801755:	eb 4a                	jmp    8017a1 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801757:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80175a:	8b 45 08             	mov    0x8(%ebp),%eax
  80175d:	01 c2                	add    %eax,%edx
  80175f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801762:	8b 45 0c             	mov    0xc(%ebp),%eax
  801765:	01 c8                	add    %ecx,%eax
  801767:	8a 00                	mov    (%eax),%al
  801769:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80176b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80176e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801771:	01 d0                	add    %edx,%eax
  801773:	8a 00                	mov    (%eax),%al
  801775:	3c 40                	cmp    $0x40,%al
  801777:	7e 25                	jle    80179e <str2lower+0x5c>
  801779:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80177c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177f:	01 d0                	add    %edx,%eax
  801781:	8a 00                	mov    (%eax),%al
  801783:	3c 5a                	cmp    $0x5a,%al
  801785:	7f 17                	jg     80179e <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801787:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80178a:	8b 45 08             	mov    0x8(%ebp),%eax
  80178d:	01 d0                	add    %edx,%eax
  80178f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801792:	8b 55 08             	mov    0x8(%ebp),%edx
  801795:	01 ca                	add    %ecx,%edx
  801797:	8a 12                	mov    (%edx),%dl
  801799:	83 c2 20             	add    $0x20,%edx
  80179c:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80179e:	ff 45 fc             	incl   -0x4(%ebp)
  8017a1:	ff 75 0c             	pushl  0xc(%ebp)
  8017a4:	e8 01 f8 ff ff       	call   800faa <strlen>
  8017a9:	83 c4 04             	add    $0x4,%esp
  8017ac:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8017af:	7f a6                	jg     801757 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8017b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8017b4:	c9                   	leave  
  8017b5:	c3                   	ret    

008017b6 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8017b6:	55                   	push   %ebp
  8017b7:	89 e5                	mov    %esp,%ebp
  8017b9:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8017bc:	a1 08 50 80 00       	mov    0x805008,%eax
  8017c1:	85 c0                	test   %eax,%eax
  8017c3:	74 42                	je     801807 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8017c5:	83 ec 08             	sub    $0x8,%esp
  8017c8:	68 00 00 00 82       	push   $0x82000000
  8017cd:	68 00 00 00 80       	push   $0x80000000
  8017d2:	e8 b0 1e 00 00       	call   803687 <initialize_dynamic_allocator>
  8017d7:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  8017da:	e8 96 1c 00 00       	call   803475 <sys_get_uheap_strategy>
  8017df:	a3 80 50 83 00       	mov    %eax,0x835080
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  8017e4:	a1 60 d0 81 00       	mov    0x81d060,%eax
  8017e9:	05 00 10 00 00       	add    $0x1000,%eax
  8017ee:	a3 30 51 83 00       	mov    %eax,0x835130
		uheapPageAllocBreak = uheapPageAllocStart;
  8017f3:	a1 30 51 83 00       	mov    0x835130,%eax
  8017f8:	a3 88 50 83 00       	mov    %eax,0x835088

		__firstTimeFlag = 0;
  8017fd:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  801804:	00 00 00 
	}
}
  801807:	90                   	nop
  801808:	c9                   	leave  
  801809:	c3                   	ret    

0080180a <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
  80180d:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801810:	8b 45 08             	mov    0x8(%ebp),%eax
  801813:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801816:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801819:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80181e:	83 ec 08             	sub    $0x8,%esp
  801821:	68 06 04 00 00       	push   $0x406
  801826:	50                   	push   %eax
  801827:	e8 93 18 00 00       	call   8030bf <__sys_allocate_page>
  80182c:	83 c4 10             	add    $0x10,%esp
  80182f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801832:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801836:	79 14                	jns    80184c <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801838:	83 ec 04             	sub    $0x4,%esp
  80183b:	68 08 4b 80 00       	push   $0x804b08
  801840:	6a 1f                	push   $0x1f
  801842:	68 44 4b 80 00       	push   $0x804b44
  801847:	e8 b7 ed ff ff       	call   800603 <_panic>
	return 0;
  80184c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801851:	c9                   	leave  
  801852:	c3                   	ret    

00801853 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801853:	55                   	push   %ebp
  801854:	89 e5                	mov    %esp,%ebp
  801856:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801859:	8b 45 08             	mov    0x8(%ebp),%eax
  80185c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80185f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801862:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801867:	83 ec 0c             	sub    $0xc,%esp
  80186a:	50                   	push   %eax
  80186b:	e8 96 18 00 00       	call   803106 <__sys_unmap_frame>
  801870:	83 c4 10             	add    $0x10,%esp
  801873:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801876:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80187a:	79 14                	jns    801890 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  80187c:	83 ec 04             	sub    $0x4,%esp
  80187f:	68 50 4b 80 00       	push   $0x804b50
  801884:	6a 2a                	push   $0x2a
  801886:	68 44 4b 80 00       	push   $0x804b44
  80188b:	e8 73 ed ff ff       	call   800603 <_panic>
}
  801890:	90                   	nop
  801891:	c9                   	leave  
  801892:	c3                   	ret    

00801893 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
  801896:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801899:	e8 18 ff ff ff       	call   8017b6 <uheap_init>
	if (size == 0) return NULL ;
  80189e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018a2:	75 0a                	jne    8018ae <malloc+0x1b>
  8018a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a9:	e9 43 03 00 00       	jmp    801bf1 <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  8018ae:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8018b5:	77 13                	ja     8018ca <malloc+0x37>
    {
        return alloc_block(size);
  8018b7:	83 ec 0c             	sub    $0xc,%esp
  8018ba:	ff 75 08             	pushl  0x8(%ebp)
  8018bd:	e8 78 20 00 00       	call   80393a <alloc_block>
  8018c2:	83 c4 10             	add    $0x10,%esp
  8018c5:	e9 27 03 00 00       	jmp    801bf1 <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  8018ca:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  8018d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8018d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018d7:	01 d0                	add    %edx,%eax
  8018d9:	48                   	dec    %eax
  8018da:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8018dd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8018e5:	f7 75 dc             	divl   -0x24(%ebp)
  8018e8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018eb:	29 d0                	sub    %edx,%eax
  8018ed:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  8018f0:	a1 40 d0 81 00       	mov    0x81d040,%eax
  8018f5:	85 c0                	test   %eax,%eax
  8018f7:	75 0a                	jne    801903 <malloc+0x70>
    {
        uhp_inited = 1;
  8018f9:	c7 05 40 d0 81 00 01 	movl   $0x1,0x81d040
  801900:	00 00 00 
    }

    int exactIdx = -1;
  801903:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  80190a:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801911:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801918:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80191f:	e9 85 00 00 00       	jmp    8019a9 <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801924:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801927:	89 d0                	mov    %edx,%eax
  801929:	01 c0                	add    %eax,%eax
  80192b:	01 d0                	add    %edx,%eax
  80192d:	c1 e0 02             	shl    $0x2,%eax
  801930:	05 48 10 81 00       	add    $0x811048,%eax
  801935:	8a 00                	mov    (%eax),%al
  801937:	84 c0                	test   %al,%al
  801939:	74 20                	je     80195b <malloc+0xc8>
  80193b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80193e:	89 d0                	mov    %edx,%eax
  801940:	01 c0                	add    %eax,%eax
  801942:	01 d0                	add    %edx,%eax
  801944:	c1 e0 02             	shl    $0x2,%eax
  801947:	05 44 10 81 00       	add    $0x811044,%eax
  80194c:	8b 00                	mov    (%eax),%eax
  80194e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801951:	75 08                	jne    80195b <malloc+0xc8>
        {
            exactIdx = i;
  801953:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801956:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801959:	eb 5b                	jmp    8019b6 <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  80195b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80195e:	89 d0                	mov    %edx,%eax
  801960:	01 c0                	add    %eax,%eax
  801962:	01 d0                	add    %edx,%eax
  801964:	c1 e0 02             	shl    $0x2,%eax
  801967:	05 48 10 81 00       	add    $0x811048,%eax
  80196c:	8a 00                	mov    (%eax),%al
  80196e:	84 c0                	test   %al,%al
  801970:	74 34                	je     8019a6 <malloc+0x113>
  801972:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801975:	89 d0                	mov    %edx,%eax
  801977:	01 c0                	add    %eax,%eax
  801979:	01 d0                	add    %edx,%eax
  80197b:	c1 e0 02             	shl    $0x2,%eax
  80197e:	05 44 10 81 00       	add    $0x811044,%eax
  801983:	8b 00                	mov    (%eax),%eax
  801985:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801988:	76 1c                	jbe    8019a6 <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  80198a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80198d:	89 d0                	mov    %edx,%eax
  80198f:	01 c0                	add    %eax,%eax
  801991:	01 d0                	add    %edx,%eax
  801993:	c1 e0 02             	shl    $0x2,%eax
  801996:	05 44 10 81 00       	add    $0x811044,%eax
  80199b:	8b 00                	mov    (%eax),%eax
  80199d:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  8019a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8019a6:	ff 45 e8             	incl   -0x18(%ebp)
  8019a9:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8019b0:	0f 8e 6e ff ff ff    	jle    801924 <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  8019b6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  8019bd:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8019c1:	74 7d                	je     801a40 <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  8019c3:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  8019ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019cd:	89 d0                	mov    %edx,%eax
  8019cf:	01 c0                	add    %eax,%eax
  8019d1:	01 d0                	add    %edx,%eax
  8019d3:	c1 e0 02             	shl    $0x2,%eax
  8019d6:	05 40 10 81 00       	add    $0x811040,%eax
  8019db:	8b 10                	mov    (%eax),%edx
  8019dd:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8019e0:	01 d0                	add    %edx,%eax
  8019e2:	48                   	dec    %eax
  8019e3:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8019e6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8019e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ee:	f7 75 bc             	divl   -0x44(%ebp)
  8019f1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8019f4:	29 d0                	sub    %edx,%eax
  8019f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  8019f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019fc:	89 d0                	mov    %edx,%eax
  8019fe:	01 c0                	add    %eax,%eax
  801a00:	01 d0                	add    %edx,%eax
  801a02:	c1 e0 02             	shl    $0x2,%eax
  801a05:	05 48 10 81 00       	add    $0x811048,%eax
  801a0a:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801a0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a10:	89 d0                	mov    %edx,%eax
  801a12:	01 c0                	add    %eax,%eax
  801a14:	01 d0                	add    %edx,%eax
  801a16:	c1 e0 02             	shl    $0x2,%eax
  801a19:	05 44 10 81 00       	add    $0x811044,%eax
  801a1e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801a24:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a27:	89 d0                	mov    %edx,%eax
  801a29:	01 c0                	add    %eax,%eax
  801a2b:	01 d0                	add    %edx,%eax
  801a2d:	c1 e0 02             	shl    $0x2,%eax
  801a30:	05 40 10 81 00       	add    $0x811040,%eax
  801a35:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801a3b:	e9 2d 01 00 00       	jmp    801b6d <malloc+0x2da>
    }
    else if (worstIdx != -1)
  801a40:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801a44:	0f 84 ce 00 00 00    	je     801b18 <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  801a4a:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  801a51:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a54:	89 d0                	mov    %edx,%eax
  801a56:	01 c0                	add    %eax,%eax
  801a58:	01 d0                	add    %edx,%eax
  801a5a:	c1 e0 02             	shl    $0x2,%eax
  801a5d:	05 40 10 81 00       	add    $0x811040,%eax
  801a62:	8b 10                	mov    (%eax),%edx
  801a64:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801a67:	01 d0                	add    %edx,%eax
  801a69:	48                   	dec    %eax
  801a6a:	89 45 c0             	mov    %eax,-0x40(%ebp)
  801a6d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801a70:	ba 00 00 00 00       	mov    $0x0,%edx
  801a75:	f7 75 c4             	divl   -0x3c(%ebp)
  801a78:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801a7b:	29 d0                	sub    %edx,%eax
  801a7d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  801a80:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a83:	89 d0                	mov    %edx,%eax
  801a85:	01 c0                	add    %eax,%eax
  801a87:	01 d0                	add    %edx,%eax
  801a89:	c1 e0 02             	shl    $0x2,%eax
  801a8c:	05 44 10 81 00       	add    $0x811044,%eax
  801a91:	8b 00                	mov    (%eax),%eax
  801a93:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801a96:	75 47                	jne    801adf <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  801a98:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a9b:	89 d0                	mov    %edx,%eax
  801a9d:	01 c0                	add    %eax,%eax
  801a9f:	01 d0                	add    %edx,%eax
  801aa1:	c1 e0 02             	shl    $0x2,%eax
  801aa4:	05 48 10 81 00       	add    $0x811048,%eax
  801aa9:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  801aac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801aaf:	89 d0                	mov    %edx,%eax
  801ab1:	01 c0                	add    %eax,%eax
  801ab3:	01 d0                	add    %edx,%eax
  801ab5:	c1 e0 02             	shl    $0x2,%eax
  801ab8:	05 44 10 81 00       	add    $0x811044,%eax
  801abd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  801ac3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ac6:	89 d0                	mov    %edx,%eax
  801ac8:	01 c0                	add    %eax,%eax
  801aca:	01 d0                	add    %edx,%eax
  801acc:	c1 e0 02             	shl    $0x2,%eax
  801acf:	05 40 10 81 00       	add    $0x811040,%eax
  801ad4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ada:	e9 8e 00 00 00       	jmp    801b6d <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  801adf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801ae2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ae5:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801ae8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801aeb:	89 d0                	mov    %edx,%eax
  801aed:	01 c0                	add    %eax,%eax
  801aef:	01 d0                	add    %edx,%eax
  801af1:	c1 e0 02             	shl    $0x2,%eax
  801af4:	05 40 10 81 00       	add    $0x811040,%eax
  801af9:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  801afb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801afe:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801b01:	89 c2                	mov    %eax,%edx
  801b03:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801b06:	89 c8                	mov    %ecx,%eax
  801b08:	01 c0                	add    %eax,%eax
  801b0a:	01 c8                	add    %ecx,%eax
  801b0c:	c1 e0 02             	shl    $0x2,%eax
  801b0f:	05 44 10 81 00       	add    $0x811044,%eax
  801b14:	89 10                	mov    %edx,(%eax)
  801b16:	eb 55                	jmp    801b6d <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  801b18:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801b1f:	8b 15 88 50 83 00    	mov    0x835088,%edx
  801b25:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801b28:	01 d0                	add    %edx,%eax
  801b2a:	48                   	dec    %eax
  801b2b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801b2e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801b31:	ba 00 00 00 00       	mov    $0x0,%edx
  801b36:	f7 75 d0             	divl   -0x30(%ebp)
  801b39:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801b3c:	29 d0                	sub    %edx,%eax
  801b3e:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  801b41:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801b44:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b47:	01 d0                	add    %edx,%eax
  801b49:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801b4e:	76 0a                	jbe    801b5a <malloc+0x2c7>
            return NULL;
  801b50:	b8 00 00 00 00       	mov    $0x0,%eax
  801b55:	e9 97 00 00 00       	jmp    801bf1 <malloc+0x35e>
        va = start;
  801b5a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801b5d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  801b60:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801b63:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b66:	01 d0                	add    %edx,%eax
  801b68:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801b6d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801b74:	eb 5e                	jmp    801bd4 <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  801b76:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b79:	89 d0                	mov    %edx,%eax
  801b7b:	01 c0                	add    %eax,%eax
  801b7d:	01 d0                	add    %edx,%eax
  801b7f:	c1 e0 02             	shl    $0x2,%eax
  801b82:	05 48 50 80 00       	add    $0x805048,%eax
  801b87:	8a 00                	mov    (%eax),%al
  801b89:	84 c0                	test   %al,%al
  801b8b:	75 44                	jne    801bd1 <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  801b8d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b90:	89 d0                	mov    %edx,%eax
  801b92:	01 c0                	add    %eax,%eax
  801b94:	01 d0                	add    %edx,%eax
  801b96:	c1 e0 02             	shl    $0x2,%eax
  801b99:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  801b9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ba2:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  801ba4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ba7:	89 d0                	mov    %edx,%eax
  801ba9:	01 c0                	add    %eax,%eax
  801bab:	01 d0                	add    %edx,%eax
  801bad:	c1 e0 02             	shl    $0x2,%eax
  801bb0:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  801bb6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801bb9:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  801bbb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bbe:	89 d0                	mov    %edx,%eax
  801bc0:	01 c0                	add    %eax,%eax
  801bc2:	01 d0                	add    %edx,%eax
  801bc4:	c1 e0 02             	shl    $0x2,%eax
  801bc7:	05 48 50 80 00       	add    $0x805048,%eax
  801bcc:	c6 00 01             	movb   $0x1,(%eax)
            break;
  801bcf:	eb 0c                	jmp    801bdd <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801bd1:	ff 45 e0             	incl   -0x20(%ebp)
  801bd4:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801bdb:	7e 99                	jle    801b76 <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  801bdd:	83 ec 08             	sub    $0x8,%esp
  801be0:	ff 75 d4             	pushl  -0x2c(%ebp)
  801be3:	ff 75 e4             	pushl  -0x1c(%ebp)
  801be6:	e8 a2 19 00 00       	call   80358d <sys_allocate_user_mem>
  801beb:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  801bee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801bf1:	c9                   	leave  
  801bf2:	c3                   	ret    

00801bf3 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
  801bf6:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  801bf9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801bfd:	0f 84 fa 03 00 00    	je     801ffd <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  801c03:	8b 45 08             	mov    0x8(%ebp),%eax
  801c06:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  801c09:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c0c:	85 c0                	test   %eax,%eax
  801c0e:	79 1c                	jns    801c2c <free+0x39>
  801c10:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  801c17:	77 13                	ja     801c2c <free+0x39>
    {
        free_block(virtual_address);
  801c19:	83 ec 0c             	sub    $0xc,%esp
  801c1c:	ff 75 08             	pushl  0x8(%ebp)
  801c1f:	e8 09 21 00 00       	call   803d2d <free_block>
  801c24:	83 c4 10             	add    $0x10,%esp
        return;
  801c27:	e9 d2 03 00 00       	jmp    801ffe <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  801c2c:	a1 30 51 83 00       	mov    0x835130,%eax
  801c31:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  801c34:	72 09                	jb     801c3f <free+0x4c>
  801c36:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  801c3d:	76 17                	jbe    801c56 <free+0x63>
        panic("free: invalid address");
  801c3f:	83 ec 04             	sub    $0x4,%esp
  801c42:	68 8d 4b 80 00       	push   $0x804b8d
  801c47:	68 9b 00 00 00       	push   $0x9b
  801c4c:	68 44 4b 80 00       	push   $0x804b44
  801c51:	e8 ad e9 ff ff       	call   800603 <_panic>

    uint32 size = 0;
  801c56:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  801c5d:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801c64:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801c6b:	eb 50                	jmp    801cbd <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  801c6d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c70:	89 d0                	mov    %edx,%eax
  801c72:	01 c0                	add    %eax,%eax
  801c74:	01 d0                	add    %edx,%eax
  801c76:	c1 e0 02             	shl    $0x2,%eax
  801c79:	05 48 50 80 00       	add    $0x805048,%eax
  801c7e:	8a 00                	mov    (%eax),%al
  801c80:	84 c0                	test   %al,%al
  801c82:	74 36                	je     801cba <free+0xc7>
  801c84:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c87:	89 d0                	mov    %edx,%eax
  801c89:	01 c0                	add    %eax,%eax
  801c8b:	01 d0                	add    %edx,%eax
  801c8d:	c1 e0 02             	shl    $0x2,%eax
  801c90:	05 40 50 80 00       	add    $0x805040,%eax
  801c95:	8b 00                	mov    (%eax),%eax
  801c97:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801c9a:	75 1e                	jne    801cba <free+0xc7>
        {
            size = uhp_allocs[i].size;
  801c9c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c9f:	89 d0                	mov    %edx,%eax
  801ca1:	01 c0                	add    %eax,%eax
  801ca3:	01 d0                	add    %edx,%eax
  801ca5:	c1 e0 02             	shl    $0x2,%eax
  801ca8:	05 44 50 80 00       	add    $0x805044,%eax
  801cad:	8b 00                	mov    (%eax),%eax
  801caf:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  801cb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  801cb8:	eb 0c                	jmp    801cc6 <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801cba:	ff 45 ec             	incl   -0x14(%ebp)
  801cbd:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  801cc4:	7e a7                	jle    801c6d <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  801cc6:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801cca:	74 06                	je     801cd2 <free+0xdf>
  801ccc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cd0:	75 17                	jne    801ce9 <free+0xf6>
        panic("free: unknown block");
  801cd2:	83 ec 04             	sub    $0x4,%esp
  801cd5:	68 a3 4b 80 00       	push   $0x804ba3
  801cda:	68 a9 00 00 00       	push   $0xa9
  801cdf:	68 44 4b 80 00       	push   $0x804b44
  801ce4:	e8 1a e9 ff ff       	call   800603 <_panic>

    uhp_allocs[idx].used = 0;
  801ce9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801cec:	89 d0                	mov    %edx,%eax
  801cee:	01 c0                	add    %eax,%eax
  801cf0:	01 d0                	add    %edx,%eax
  801cf2:	c1 e0 02             	shl    $0x2,%eax
  801cf5:	05 48 50 80 00       	add    $0x805048,%eax
  801cfa:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  801cfd:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801d04:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801d0b:	eb 64                	jmp    801d71 <free+0x17e>
    {
        if (!uhp_frees[i].free)
  801d0d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801d10:	89 d0                	mov    %edx,%eax
  801d12:	01 c0                	add    %eax,%eax
  801d14:	01 d0                	add    %edx,%eax
  801d16:	c1 e0 02             	shl    $0x2,%eax
  801d19:	05 48 10 81 00       	add    $0x811048,%eax
  801d1e:	8a 00                	mov    (%eax),%al
  801d20:	84 c0                	test   %al,%al
  801d22:	75 4a                	jne    801d6e <free+0x17b>
        {
            uhp_frees[i].va = va;
  801d24:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801d27:	89 d0                	mov    %edx,%eax
  801d29:	01 c0                	add    %eax,%eax
  801d2b:	01 d0                	add    %edx,%eax
  801d2d:	c1 e0 02             	shl    $0x2,%eax
  801d30:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  801d36:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d39:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  801d3b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801d3e:	89 d0                	mov    %edx,%eax
  801d40:	01 c0                	add    %eax,%eax
  801d42:	01 d0                	add    %edx,%eax
  801d44:	c1 e0 02             	shl    $0x2,%eax
  801d47:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  801d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d50:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  801d52:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801d55:	89 d0                	mov    %edx,%eax
  801d57:	01 c0                	add    %eax,%eax
  801d59:	01 d0                	add    %edx,%eax
  801d5b:	c1 e0 02             	shl    $0x2,%eax
  801d5e:	05 48 10 81 00       	add    $0x811048,%eax
  801d63:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  801d66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d69:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  801d6c:	eb 0c                	jmp    801d7a <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801d6e:	ff 45 e4             	incl   -0x1c(%ebp)
  801d71:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  801d78:	7e 93                	jle    801d0d <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  801d7a:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  801d7e:	0f 84 f1 01 00 00    	je     801f75 <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801d84:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801d8b:	e9 d8 01 00 00       	jmp    801f68 <free+0x375>
        {
            if (i == fidx) continue;
  801d90:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d93:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801d96:	0f 84 c8 01 00 00    	je     801f64 <free+0x371>
            if (uhp_frees[i].free)
  801d9c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d9f:	89 d0                	mov    %edx,%eax
  801da1:	01 c0                	add    %eax,%eax
  801da3:	01 d0                	add    %edx,%eax
  801da5:	c1 e0 02             	shl    $0x2,%eax
  801da8:	05 48 10 81 00       	add    $0x811048,%eax
  801dad:	8a 00                	mov    (%eax),%al
  801daf:	84 c0                	test   %al,%al
  801db1:	0f 84 ae 01 00 00    	je     801f65 <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  801db7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801dba:	89 d0                	mov    %edx,%eax
  801dbc:	01 c0                	add    %eax,%eax
  801dbe:	01 d0                	add    %edx,%eax
  801dc0:	c1 e0 02             	shl    $0x2,%eax
  801dc3:	05 40 10 81 00       	add    $0x811040,%eax
  801dc8:	8b 08                	mov    (%eax),%ecx
  801dca:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801dcd:	89 d0                	mov    %edx,%eax
  801dcf:	01 c0                	add    %eax,%eax
  801dd1:	01 d0                	add    %edx,%eax
  801dd3:	c1 e0 02             	shl    $0x2,%eax
  801dd6:	05 44 10 81 00       	add    $0x811044,%eax
  801ddb:	8b 00                	mov    (%eax),%eax
  801ddd:	01 c1                	add    %eax,%ecx
  801ddf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801de2:	89 d0                	mov    %edx,%eax
  801de4:	01 c0                	add    %eax,%eax
  801de6:	01 d0                	add    %edx,%eax
  801de8:	c1 e0 02             	shl    $0x2,%eax
  801deb:	05 40 10 81 00       	add    $0x811040,%eax
  801df0:	8b 00                	mov    (%eax),%eax
  801df2:	39 c1                	cmp    %eax,%ecx
  801df4:	0f 85 a8 00 00 00    	jne    801ea2 <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  801dfa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801dfd:	89 d0                	mov    %edx,%eax
  801dff:	01 c0                	add    %eax,%eax
  801e01:	01 d0                	add    %edx,%eax
  801e03:	c1 e0 02             	shl    $0x2,%eax
  801e06:	05 40 10 81 00       	add    $0x811040,%eax
  801e0b:	8b 10                	mov    (%eax),%edx
  801e0d:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  801e10:	89 c8                	mov    %ecx,%eax
  801e12:	01 c0                	add    %eax,%eax
  801e14:	01 c8                	add    %ecx,%eax
  801e16:	c1 e0 02             	shl    $0x2,%eax
  801e19:	05 40 10 81 00       	add    $0x811040,%eax
  801e1e:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801e20:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e23:	89 d0                	mov    %edx,%eax
  801e25:	01 c0                	add    %eax,%eax
  801e27:	01 d0                	add    %edx,%eax
  801e29:	c1 e0 02             	shl    $0x2,%eax
  801e2c:	05 44 10 81 00       	add    $0x811044,%eax
  801e31:	8b 08                	mov    (%eax),%ecx
  801e33:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e36:	89 d0                	mov    %edx,%eax
  801e38:	01 c0                	add    %eax,%eax
  801e3a:	01 d0                	add    %edx,%eax
  801e3c:	c1 e0 02             	shl    $0x2,%eax
  801e3f:	05 44 10 81 00       	add    $0x811044,%eax
  801e44:	8b 00                	mov    (%eax),%eax
  801e46:	01 c1                	add    %eax,%ecx
  801e48:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e4b:	89 d0                	mov    %edx,%eax
  801e4d:	01 c0                	add    %eax,%eax
  801e4f:	01 d0                	add    %edx,%eax
  801e51:	c1 e0 02             	shl    $0x2,%eax
  801e54:	05 44 10 81 00       	add    $0x811044,%eax
  801e59:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801e5b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e5e:	89 d0                	mov    %edx,%eax
  801e60:	01 c0                	add    %eax,%eax
  801e62:	01 d0                	add    %edx,%eax
  801e64:	c1 e0 02             	shl    $0x2,%eax
  801e67:	05 48 10 81 00       	add    $0x811048,%eax
  801e6c:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801e6f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e72:	89 d0                	mov    %edx,%eax
  801e74:	01 c0                	add    %eax,%eax
  801e76:	01 d0                	add    %edx,%eax
  801e78:	c1 e0 02             	shl    $0x2,%eax
  801e7b:	05 40 10 81 00       	add    $0x811040,%eax
  801e80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801e86:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e89:	89 d0                	mov    %edx,%eax
  801e8b:	01 c0                	add    %eax,%eax
  801e8d:	01 d0                	add    %edx,%eax
  801e8f:	c1 e0 02             	shl    $0x2,%eax
  801e92:	05 44 10 81 00       	add    $0x811044,%eax
  801e97:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e9d:	e9 c3 00 00 00       	jmp    801f65 <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  801ea2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ea5:	89 d0                	mov    %edx,%eax
  801ea7:	01 c0                	add    %eax,%eax
  801ea9:	01 d0                	add    %edx,%eax
  801eab:	c1 e0 02             	shl    $0x2,%eax
  801eae:	05 40 10 81 00       	add    $0x811040,%eax
  801eb3:	8b 08                	mov    (%eax),%ecx
  801eb5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801eb8:	89 d0                	mov    %edx,%eax
  801eba:	01 c0                	add    %eax,%eax
  801ebc:	01 d0                	add    %edx,%eax
  801ebe:	c1 e0 02             	shl    $0x2,%eax
  801ec1:	05 44 10 81 00       	add    $0x811044,%eax
  801ec6:	8b 00                	mov    (%eax),%eax
  801ec8:	01 c1                	add    %eax,%ecx
  801eca:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ecd:	89 d0                	mov    %edx,%eax
  801ecf:	01 c0                	add    %eax,%eax
  801ed1:	01 d0                	add    %edx,%eax
  801ed3:	c1 e0 02             	shl    $0x2,%eax
  801ed6:	05 40 10 81 00       	add    $0x811040,%eax
  801edb:	8b 00                	mov    (%eax),%eax
  801edd:	39 c1                	cmp    %eax,%ecx
  801edf:	0f 85 80 00 00 00    	jne    801f65 <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801ee5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ee8:	89 d0                	mov    %edx,%eax
  801eea:	01 c0                	add    %eax,%eax
  801eec:	01 d0                	add    %edx,%eax
  801eee:	c1 e0 02             	shl    $0x2,%eax
  801ef1:	05 44 10 81 00       	add    $0x811044,%eax
  801ef6:	8b 08                	mov    (%eax),%ecx
  801ef8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801efb:	89 d0                	mov    %edx,%eax
  801efd:	01 c0                	add    %eax,%eax
  801eff:	01 d0                	add    %edx,%eax
  801f01:	c1 e0 02             	shl    $0x2,%eax
  801f04:	05 44 10 81 00       	add    $0x811044,%eax
  801f09:	8b 00                	mov    (%eax),%eax
  801f0b:	01 c1                	add    %eax,%ecx
  801f0d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f10:	89 d0                	mov    %edx,%eax
  801f12:	01 c0                	add    %eax,%eax
  801f14:	01 d0                	add    %edx,%eax
  801f16:	c1 e0 02             	shl    $0x2,%eax
  801f19:	05 44 10 81 00       	add    $0x811044,%eax
  801f1e:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801f20:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f23:	89 d0                	mov    %edx,%eax
  801f25:	01 c0                	add    %eax,%eax
  801f27:	01 d0                	add    %edx,%eax
  801f29:	c1 e0 02             	shl    $0x2,%eax
  801f2c:	05 48 10 81 00       	add    $0x811048,%eax
  801f31:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801f34:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f37:	89 d0                	mov    %edx,%eax
  801f39:	01 c0                	add    %eax,%eax
  801f3b:	01 d0                	add    %edx,%eax
  801f3d:	c1 e0 02             	shl    $0x2,%eax
  801f40:	05 40 10 81 00       	add    $0x811040,%eax
  801f45:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801f4b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f4e:	89 d0                	mov    %edx,%eax
  801f50:	01 c0                	add    %eax,%eax
  801f52:	01 d0                	add    %edx,%eax
  801f54:	c1 e0 02             	shl    $0x2,%eax
  801f57:	05 44 10 81 00       	add    $0x811044,%eax
  801f5c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f62:	eb 01                	jmp    801f65 <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  801f64:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801f65:	ff 45 e0             	incl   -0x20(%ebp)
  801f68:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801f6f:	0f 8e 1b fe ff ff    	jle    801d90 <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  801f75:	a1 30 51 83 00       	mov    0x835130,%eax
  801f7a:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801f7d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801f84:	eb 53                	jmp    801fd9 <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  801f86:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801f89:	89 d0                	mov    %edx,%eax
  801f8b:	01 c0                	add    %eax,%eax
  801f8d:	01 d0                	add    %edx,%eax
  801f8f:	c1 e0 02             	shl    $0x2,%eax
  801f92:	05 48 50 80 00       	add    $0x805048,%eax
  801f97:	8a 00                	mov    (%eax),%al
  801f99:	84 c0                	test   %al,%al
  801f9b:	74 39                	je     801fd6 <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  801f9d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801fa0:	89 d0                	mov    %edx,%eax
  801fa2:	01 c0                	add    %eax,%eax
  801fa4:	01 d0                	add    %edx,%eax
  801fa6:	c1 e0 02             	shl    $0x2,%eax
  801fa9:	05 40 50 80 00       	add    $0x805040,%eax
  801fae:	8b 08                	mov    (%eax),%ecx
  801fb0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801fb3:	89 d0                	mov    %edx,%eax
  801fb5:	01 c0                	add    %eax,%eax
  801fb7:	01 d0                	add    %edx,%eax
  801fb9:	c1 e0 02             	shl    $0x2,%eax
  801fbc:	05 44 50 80 00       	add    $0x805044,%eax
  801fc1:	8b 00                	mov    (%eax),%eax
  801fc3:	01 c8                	add    %ecx,%eax
  801fc5:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  801fc8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801fcb:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801fce:	76 06                	jbe    801fd6 <free+0x3e3>
  801fd0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801fd3:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801fd6:	ff 45 d8             	incl   -0x28(%ebp)
  801fd9:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  801fe0:	7e a4                	jle    801f86 <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  801fe2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801fe5:	a3 88 50 83 00       	mov    %eax,0x835088

    sys_free_user_mem(va, size);
  801fea:	83 ec 08             	sub    $0x8,%esp
  801fed:	ff 75 f4             	pushl  -0xc(%ebp)
  801ff0:	ff 75 d4             	pushl  -0x2c(%ebp)
  801ff3:	e8 79 15 00 00       	call   803571 <sys_free_user_mem>
  801ff8:	83 c4 10             	add    $0x10,%esp
  801ffb:	eb 01                	jmp    801ffe <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  801ffd:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  801ffe:	c9                   	leave  
  801fff:	c3                   	ret    

00802000 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802000:	55                   	push   %ebp
  802001:	89 e5                	mov    %esp,%ebp
  802003:	83 ec 68             	sub    $0x68,%esp
  802006:	8b 45 10             	mov    0x10(%ebp),%eax
  802009:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80200c:	e8 a5 f7 ff ff       	call   8017b6 <uheap_init>
	if (size == 0) return NULL ;
  802011:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802015:	75 0a                	jne    802021 <smalloc+0x21>
  802017:	b8 00 00 00 00       	mov    $0x0,%eax
  80201c:	e9 37 03 00 00       	jmp    802358 <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  802021:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  802028:	8b 55 0c             	mov    0xc(%ebp),%edx
  80202b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80202e:	01 d0                	add    %edx,%eax
  802030:	48                   	dec    %eax
  802031:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802034:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802037:	ba 00 00 00 00       	mov    $0x0,%edx
  80203c:	f7 75 dc             	divl   -0x24(%ebp)
  80203f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802042:	29 d0                	sub    %edx,%eax
  802044:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  802047:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  80204e:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  802055:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80205c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802063:	e9 85 00 00 00       	jmp    8020ed <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  802068:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80206b:	89 d0                	mov    %edx,%eax
  80206d:	01 c0                	add    %eax,%eax
  80206f:	01 d0                	add    %edx,%eax
  802071:	c1 e0 02             	shl    $0x2,%eax
  802074:	05 48 10 81 00       	add    $0x811048,%eax
  802079:	8a 00                	mov    (%eax),%al
  80207b:	84 c0                	test   %al,%al
  80207d:	74 20                	je     80209f <smalloc+0x9f>
  80207f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802082:	89 d0                	mov    %edx,%eax
  802084:	01 c0                	add    %eax,%eax
  802086:	01 d0                	add    %edx,%eax
  802088:	c1 e0 02             	shl    $0x2,%eax
  80208b:	05 44 10 81 00       	add    $0x811044,%eax
  802090:	8b 00                	mov    (%eax),%eax
  802092:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802095:	75 08                	jne    80209f <smalloc+0x9f>
        {
            exactIdx = i;
  802097:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80209a:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  80209d:	eb 5b                	jmp    8020fa <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  80209f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8020a2:	89 d0                	mov    %edx,%eax
  8020a4:	01 c0                	add    %eax,%eax
  8020a6:	01 d0                	add    %edx,%eax
  8020a8:	c1 e0 02             	shl    $0x2,%eax
  8020ab:	05 48 10 81 00       	add    $0x811048,%eax
  8020b0:	8a 00                	mov    (%eax),%al
  8020b2:	84 c0                	test   %al,%al
  8020b4:	74 34                	je     8020ea <smalloc+0xea>
  8020b6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8020b9:	89 d0                	mov    %edx,%eax
  8020bb:	01 c0                	add    %eax,%eax
  8020bd:	01 d0                	add    %edx,%eax
  8020bf:	c1 e0 02             	shl    $0x2,%eax
  8020c2:	05 44 10 81 00       	add    $0x811044,%eax
  8020c7:	8b 00                	mov    (%eax),%eax
  8020c9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8020cc:	76 1c                	jbe    8020ea <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  8020ce:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8020d1:	89 d0                	mov    %edx,%eax
  8020d3:	01 c0                	add    %eax,%eax
  8020d5:	01 d0                	add    %edx,%eax
  8020d7:	c1 e0 02             	shl    $0x2,%eax
  8020da:	05 44 10 81 00       	add    $0x811044,%eax
  8020df:	8b 00                	mov    (%eax),%eax
  8020e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  8020e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020e7:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8020ea:	ff 45 e8             	incl   -0x18(%ebp)
  8020ed:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8020f4:	0f 8e 6e ff ff ff    	jle    802068 <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  8020fa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  802101:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  802105:	74 7d                	je     802184 <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  802107:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  80210e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802111:	89 d0                	mov    %edx,%eax
  802113:	01 c0                	add    %eax,%eax
  802115:	01 d0                	add    %edx,%eax
  802117:	c1 e0 02             	shl    $0x2,%eax
  80211a:	05 40 10 81 00       	add    $0x811040,%eax
  80211f:	8b 10                	mov    (%eax),%edx
  802121:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802124:	01 d0                	add    %edx,%eax
  802126:	48                   	dec    %eax
  802127:	89 45 b8             	mov    %eax,-0x48(%ebp)
  80212a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80212d:	ba 00 00 00 00       	mov    $0x0,%edx
  802132:	f7 75 bc             	divl   -0x44(%ebp)
  802135:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802138:	29 d0                	sub    %edx,%eax
  80213a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  80213d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802140:	89 d0                	mov    %edx,%eax
  802142:	01 c0                	add    %eax,%eax
  802144:	01 d0                	add    %edx,%eax
  802146:	c1 e0 02             	shl    $0x2,%eax
  802149:	05 48 10 81 00       	add    $0x811048,%eax
  80214e:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  802151:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802154:	89 d0                	mov    %edx,%eax
  802156:	01 c0                	add    %eax,%eax
  802158:	01 d0                	add    %edx,%eax
  80215a:	c1 e0 02             	shl    $0x2,%eax
  80215d:	05 44 10 81 00       	add    $0x811044,%eax
  802162:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  802168:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80216b:	89 d0                	mov    %edx,%eax
  80216d:	01 c0                	add    %eax,%eax
  80216f:	01 d0                	add    %edx,%eax
  802171:	c1 e0 02             	shl    $0x2,%eax
  802174:	05 40 10 81 00       	add    $0x811040,%eax
  802179:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80217f:	e9 2d 01 00 00       	jmp    8022b1 <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  802184:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802188:	0f 84 ce 00 00 00    	je     80225c <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  80218e:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802195:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802198:	89 d0                	mov    %edx,%eax
  80219a:	01 c0                	add    %eax,%eax
  80219c:	01 d0                	add    %edx,%eax
  80219e:	c1 e0 02             	shl    $0x2,%eax
  8021a1:	05 40 10 81 00       	add    $0x811040,%eax
  8021a6:	8b 10                	mov    (%eax),%edx
  8021a8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8021ab:	01 d0                	add    %edx,%eax
  8021ad:	48                   	dec    %eax
  8021ae:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8021b1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8021b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8021b9:	f7 75 c4             	divl   -0x3c(%ebp)
  8021bc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8021bf:	29 d0                	sub    %edx,%eax
  8021c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  8021c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021c7:	89 d0                	mov    %edx,%eax
  8021c9:	01 c0                	add    %eax,%eax
  8021cb:	01 d0                	add    %edx,%eax
  8021cd:	c1 e0 02             	shl    $0x2,%eax
  8021d0:	05 44 10 81 00       	add    $0x811044,%eax
  8021d5:	8b 00                	mov    (%eax),%eax
  8021d7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8021da:	75 47                	jne    802223 <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  8021dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021df:	89 d0                	mov    %edx,%eax
  8021e1:	01 c0                	add    %eax,%eax
  8021e3:	01 d0                	add    %edx,%eax
  8021e5:	c1 e0 02             	shl    $0x2,%eax
  8021e8:	05 48 10 81 00       	add    $0x811048,%eax
  8021ed:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  8021f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021f3:	89 d0                	mov    %edx,%eax
  8021f5:	01 c0                	add    %eax,%eax
  8021f7:	01 d0                	add    %edx,%eax
  8021f9:	c1 e0 02             	shl    $0x2,%eax
  8021fc:	05 44 10 81 00       	add    $0x811044,%eax
  802201:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  802207:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80220a:	89 d0                	mov    %edx,%eax
  80220c:	01 c0                	add    %eax,%eax
  80220e:	01 d0                	add    %edx,%eax
  802210:	c1 e0 02             	shl    $0x2,%eax
  802213:	05 40 10 81 00       	add    $0x811040,%eax
  802218:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80221e:	e9 8e 00 00 00       	jmp    8022b1 <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  802223:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802226:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802229:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80222c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80222f:	89 d0                	mov    %edx,%eax
  802231:	01 c0                	add    %eax,%eax
  802233:	01 d0                	add    %edx,%eax
  802235:	c1 e0 02             	shl    $0x2,%eax
  802238:	05 40 10 81 00       	add    $0x811040,%eax
  80223d:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  80223f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802242:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802245:	89 c2                	mov    %eax,%edx
  802247:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80224a:	89 c8                	mov    %ecx,%eax
  80224c:	01 c0                	add    %eax,%eax
  80224e:	01 c8                	add    %ecx,%eax
  802250:	c1 e0 02             	shl    $0x2,%eax
  802253:	05 44 10 81 00       	add    $0x811044,%eax
  802258:	89 10                	mov    %edx,(%eax)
  80225a:	eb 55                	jmp    8022b1 <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  80225c:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  802263:	8b 15 88 50 83 00    	mov    0x835088,%edx
  802269:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80226c:	01 d0                	add    %edx,%eax
  80226e:	48                   	dec    %eax
  80226f:	89 45 cc             	mov    %eax,-0x34(%ebp)
  802272:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802275:	ba 00 00 00 00       	mov    $0x0,%edx
  80227a:	f7 75 d0             	divl   -0x30(%ebp)
  80227d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802280:	29 d0                	sub    %edx,%eax
  802282:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  802285:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802288:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80228b:	01 d0                	add    %edx,%eax
  80228d:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802292:	76 0a                	jbe    80229e <smalloc+0x29e>
            return NULL;
  802294:	b8 00 00 00 00       	mov    $0x0,%eax
  802299:	e9 ba 00 00 00       	jmp    802358 <smalloc+0x358>
        va = start;
  80229e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8022a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  8022a4:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8022a7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8022aa:	01 d0                	add    %edx,%eax
  8022ac:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8022b1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8022b8:	eb 5e                	jmp    802318 <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  8022ba:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022bd:	89 d0                	mov    %edx,%eax
  8022bf:	01 c0                	add    %eax,%eax
  8022c1:	01 d0                	add    %edx,%eax
  8022c3:	c1 e0 02             	shl    $0x2,%eax
  8022c6:	05 48 50 80 00       	add    $0x805048,%eax
  8022cb:	8a 00                	mov    (%eax),%al
  8022cd:	84 c0                	test   %al,%al
  8022cf:	75 44                	jne    802315 <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  8022d1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022d4:	89 d0                	mov    %edx,%eax
  8022d6:	01 c0                	add    %eax,%eax
  8022d8:	01 d0                	add    %edx,%eax
  8022da:	c1 e0 02             	shl    $0x2,%eax
  8022dd:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  8022e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022e6:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  8022e8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022eb:	89 d0                	mov    %edx,%eax
  8022ed:	01 c0                	add    %eax,%eax
  8022ef:	01 d0                	add    %edx,%eax
  8022f1:	c1 e0 02             	shl    $0x2,%eax
  8022f4:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8022fa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8022fd:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  8022ff:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802302:	89 d0                	mov    %edx,%eax
  802304:	01 c0                	add    %eax,%eax
  802306:	01 d0                	add    %edx,%eax
  802308:	c1 e0 02             	shl    $0x2,%eax
  80230b:	05 48 50 80 00       	add    $0x805048,%eax
  802310:	c6 00 01             	movb   $0x1,(%eax)
            break;
  802313:	eb 0c                	jmp    802321 <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802315:	ff 45 e0             	incl   -0x20(%ebp)
  802318:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80231f:	7e 99                	jle    8022ba <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  802321:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802324:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  802328:	52                   	push   %edx
  802329:	50                   	push   %eax
  80232a:	ff 75 d4             	pushl  -0x2c(%ebp)
  80232d:	ff 75 08             	pushl  0x8(%ebp)
  802330:	e8 de 0e 00 00       	call   803213 <sys_create_shared_object>
  802335:	83 c4 10             	add    $0x10,%esp
  802338:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  80233b:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  80233f:	75 07                	jne    802348 <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  802341:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802346:	eb 10                	jmp    802358 <smalloc+0x358>
    if (r < 0)
  802348:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  80234c:	79 07                	jns    802355 <smalloc+0x355>
        return NULL;
  80234e:	b8 00 00 00 00       	mov    $0x0,%eax
  802353:	eb 03                	jmp    802358 <smalloc+0x358>
    return (void*)va;
  802355:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  802358:	c9                   	leave  
  802359:	c3                   	ret    

0080235a <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80235a:	55                   	push   %ebp
  80235b:	89 e5                	mov    %esp,%ebp
  80235d:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802360:	e8 51 f4 ff ff       	call   8017b6 <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  802365:	83 ec 08             	sub    $0x8,%esp
  802368:	ff 75 0c             	pushl  0xc(%ebp)
  80236b:	ff 75 08             	pushl  0x8(%ebp)
  80236e:	e8 ca 0e 00 00       	call   80323d <sys_size_of_shared_object>
  802373:	83 c4 10             	add    $0x10,%esp
  802376:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  802379:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80237d:	7f 0a                	jg     802389 <sget+0x2f>
        return NULL;
  80237f:	b8 00 00 00 00       	mov    $0x0,%eax
  802384:	e9 28 03 00 00       	jmp    8026b1 <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  802389:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802390:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802393:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802396:	01 d0                	add    %edx,%eax
  802398:	48                   	dec    %eax
  802399:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80239c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80239f:	ba 00 00 00 00       	mov    $0x0,%edx
  8023a4:	f7 75 d8             	divl   -0x28(%ebp)
  8023a7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023aa:	29 d0                	sub    %edx,%eax
  8023ac:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  8023af:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  8023b6:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  8023bd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8023c4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8023cb:	e9 85 00 00 00       	jmp    802455 <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  8023d0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8023d3:	89 d0                	mov    %edx,%eax
  8023d5:	01 c0                	add    %eax,%eax
  8023d7:	01 d0                	add    %edx,%eax
  8023d9:	c1 e0 02             	shl    $0x2,%eax
  8023dc:	05 48 10 81 00       	add    $0x811048,%eax
  8023e1:	8a 00                	mov    (%eax),%al
  8023e3:	84 c0                	test   %al,%al
  8023e5:	74 20                	je     802407 <sget+0xad>
  8023e7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8023ea:	89 d0                	mov    %edx,%eax
  8023ec:	01 c0                	add    %eax,%eax
  8023ee:	01 d0                	add    %edx,%eax
  8023f0:	c1 e0 02             	shl    $0x2,%eax
  8023f3:	05 44 10 81 00       	add    $0x811044,%eax
  8023f8:	8b 00                	mov    (%eax),%eax
  8023fa:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8023fd:	75 08                	jne    802407 <sget+0xad>
        {
            exactIdx = i;
  8023ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802402:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  802405:	eb 5b                	jmp    802462 <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  802407:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80240a:	89 d0                	mov    %edx,%eax
  80240c:	01 c0                	add    %eax,%eax
  80240e:	01 d0                	add    %edx,%eax
  802410:	c1 e0 02             	shl    $0x2,%eax
  802413:	05 48 10 81 00       	add    $0x811048,%eax
  802418:	8a 00                	mov    (%eax),%al
  80241a:	84 c0                	test   %al,%al
  80241c:	74 34                	je     802452 <sget+0xf8>
  80241e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802421:	89 d0                	mov    %edx,%eax
  802423:	01 c0                	add    %eax,%eax
  802425:	01 d0                	add    %edx,%eax
  802427:	c1 e0 02             	shl    $0x2,%eax
  80242a:	05 44 10 81 00       	add    $0x811044,%eax
  80242f:	8b 00                	mov    (%eax),%eax
  802431:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802434:	76 1c                	jbe    802452 <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  802436:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802439:	89 d0                	mov    %edx,%eax
  80243b:	01 c0                	add    %eax,%eax
  80243d:	01 d0                	add    %edx,%eax
  80243f:	c1 e0 02             	shl    $0x2,%eax
  802442:	05 44 10 81 00       	add    $0x811044,%eax
  802447:	8b 00                	mov    (%eax),%eax
  802449:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  80244c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80244f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802452:	ff 45 e8             	incl   -0x18(%ebp)
  802455:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  80245c:	0f 8e 6e ff ff ff    	jle    8023d0 <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  802462:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  802469:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  80246d:	74 7d                	je     8024ec <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  80246f:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802476:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802479:	89 d0                	mov    %edx,%eax
  80247b:	01 c0                	add    %eax,%eax
  80247d:	01 d0                	add    %edx,%eax
  80247f:	c1 e0 02             	shl    $0x2,%eax
  802482:	05 40 10 81 00       	add    $0x811040,%eax
  802487:	8b 10                	mov    (%eax),%edx
  802489:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80248c:	01 d0                	add    %edx,%eax
  80248e:	48                   	dec    %eax
  80248f:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802492:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802495:	ba 00 00 00 00       	mov    $0x0,%edx
  80249a:	f7 75 b8             	divl   -0x48(%ebp)
  80249d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8024a0:	29 d0                	sub    %edx,%eax
  8024a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  8024a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a8:	89 d0                	mov    %edx,%eax
  8024aa:	01 c0                	add    %eax,%eax
  8024ac:	01 d0                	add    %edx,%eax
  8024ae:	c1 e0 02             	shl    $0x2,%eax
  8024b1:	05 48 10 81 00       	add    $0x811048,%eax
  8024b6:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  8024b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024bc:	89 d0                	mov    %edx,%eax
  8024be:	01 c0                	add    %eax,%eax
  8024c0:	01 d0                	add    %edx,%eax
  8024c2:	c1 e0 02             	shl    $0x2,%eax
  8024c5:	05 44 10 81 00       	add    $0x811044,%eax
  8024ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  8024d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024d3:	89 d0                	mov    %edx,%eax
  8024d5:	01 c0                	add    %eax,%eax
  8024d7:	01 d0                	add    %edx,%eax
  8024d9:	c1 e0 02             	shl    $0x2,%eax
  8024dc:	05 40 10 81 00       	add    $0x811040,%eax
  8024e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024e7:	e9 2d 01 00 00       	jmp    802619 <sget+0x2bf>
    }
    else if (worstIdx != -1)
  8024ec:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8024f0:	0f 84 ce 00 00 00    	je     8025c4 <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  8024f6:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  8024fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802500:	89 d0                	mov    %edx,%eax
  802502:	01 c0                	add    %eax,%eax
  802504:	01 d0                	add    %edx,%eax
  802506:	c1 e0 02             	shl    $0x2,%eax
  802509:	05 40 10 81 00       	add    $0x811040,%eax
  80250e:	8b 10                	mov    (%eax),%edx
  802510:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802513:	01 d0                	add    %edx,%eax
  802515:	48                   	dec    %eax
  802516:	89 45 bc             	mov    %eax,-0x44(%ebp)
  802519:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80251c:	ba 00 00 00 00       	mov    $0x0,%edx
  802521:	f7 75 c0             	divl   -0x40(%ebp)
  802524:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802527:	29 d0                	sub    %edx,%eax
  802529:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  80252c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80252f:	89 d0                	mov    %edx,%eax
  802531:	01 c0                	add    %eax,%eax
  802533:	01 d0                	add    %edx,%eax
  802535:	c1 e0 02             	shl    $0x2,%eax
  802538:	05 44 10 81 00       	add    $0x811044,%eax
  80253d:	8b 00                	mov    (%eax),%eax
  80253f:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802542:	75 47                	jne    80258b <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  802544:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802547:	89 d0                	mov    %edx,%eax
  802549:	01 c0                	add    %eax,%eax
  80254b:	01 d0                	add    %edx,%eax
  80254d:	c1 e0 02             	shl    $0x2,%eax
  802550:	05 48 10 81 00       	add    $0x811048,%eax
  802555:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  802558:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80255b:	89 d0                	mov    %edx,%eax
  80255d:	01 c0                	add    %eax,%eax
  80255f:	01 d0                	add    %edx,%eax
  802561:	c1 e0 02             	shl    $0x2,%eax
  802564:	05 44 10 81 00       	add    $0x811044,%eax
  802569:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  80256f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802572:	89 d0                	mov    %edx,%eax
  802574:	01 c0                	add    %eax,%eax
  802576:	01 d0                	add    %edx,%eax
  802578:	c1 e0 02             	shl    $0x2,%eax
  80257b:	05 40 10 81 00       	add    $0x811040,%eax
  802580:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802586:	e9 8e 00 00 00       	jmp    802619 <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  80258b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80258e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802591:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802594:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802597:	89 d0                	mov    %edx,%eax
  802599:	01 c0                	add    %eax,%eax
  80259b:	01 d0                	add    %edx,%eax
  80259d:	c1 e0 02             	shl    $0x2,%eax
  8025a0:	05 40 10 81 00       	add    $0x811040,%eax
  8025a5:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  8025a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025aa:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8025ad:	89 c2                	mov    %eax,%edx
  8025af:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8025b2:	89 c8                	mov    %ecx,%eax
  8025b4:	01 c0                	add    %eax,%eax
  8025b6:	01 c8                	add    %ecx,%eax
  8025b8:	c1 e0 02             	shl    $0x2,%eax
  8025bb:	05 44 10 81 00       	add    $0x811044,%eax
  8025c0:	89 10                	mov    %edx,(%eax)
  8025c2:	eb 55                	jmp    802619 <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  8025c4:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8025cb:	8b 15 88 50 83 00    	mov    0x835088,%edx
  8025d1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8025d4:	01 d0                	add    %edx,%eax
  8025d6:	48                   	dec    %eax
  8025d7:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8025da:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8025dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8025e2:	f7 75 cc             	divl   -0x34(%ebp)
  8025e5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8025e8:	29 d0                	sub    %edx,%eax
  8025ea:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  8025ed:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8025f0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8025f3:	01 d0                	add    %edx,%eax
  8025f5:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8025fa:	76 0a                	jbe    802606 <sget+0x2ac>
            return NULL;
  8025fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802601:	e9 ab 00 00 00       	jmp    8026b1 <sget+0x357>
        va = start;
  802606:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802609:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  80260c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80260f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802612:	01 d0                	add    %edx,%eax
  802614:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802619:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802620:	eb 5e                	jmp    802680 <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  802622:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802625:	89 d0                	mov    %edx,%eax
  802627:	01 c0                	add    %eax,%eax
  802629:	01 d0                	add    %edx,%eax
  80262b:	c1 e0 02             	shl    $0x2,%eax
  80262e:	05 48 50 80 00       	add    $0x805048,%eax
  802633:	8a 00                	mov    (%eax),%al
  802635:	84 c0                	test   %al,%al
  802637:	75 44                	jne    80267d <sget+0x323>
        {
            uhp_allocs[i].va = va;
  802639:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80263c:	89 d0                	mov    %edx,%eax
  80263e:	01 c0                	add    %eax,%eax
  802640:	01 d0                	add    %edx,%eax
  802642:	c1 e0 02             	shl    $0x2,%eax
  802645:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  80264b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80264e:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  802650:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802653:	89 d0                	mov    %edx,%eax
  802655:	01 c0                	add    %eax,%eax
  802657:	01 d0                	add    %edx,%eax
  802659:	c1 e0 02             	shl    $0x2,%eax
  80265c:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802662:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802665:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  802667:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80266a:	89 d0                	mov    %edx,%eax
  80266c:	01 c0                	add    %eax,%eax
  80266e:	01 d0                	add    %edx,%eax
  802670:	c1 e0 02             	shl    $0x2,%eax
  802673:	05 48 50 80 00       	add    $0x805048,%eax
  802678:	c6 00 01             	movb   $0x1,(%eax)
            break;
  80267b:	eb 0c                	jmp    802689 <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80267d:	ff 45 e0             	incl   -0x20(%ebp)
  802680:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802687:	7e 99                	jle    802622 <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  802689:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80268c:	83 ec 04             	sub    $0x4,%esp
  80268f:	50                   	push   %eax
  802690:	ff 75 0c             	pushl  0xc(%ebp)
  802693:	ff 75 08             	pushl  0x8(%ebp)
  802696:	e8 bf 0b 00 00       	call   80325a <sys_get_shared_object>
  80269b:	83 c4 10             	add    $0x10,%esp
  80269e:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  8026a1:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8026a5:	79 07                	jns    8026ae <sget+0x354>
        return NULL;
  8026a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ac:	eb 03                	jmp    8026b1 <sget+0x357>
    return (void*)va;
  8026ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8026b1:	c9                   	leave  
  8026b2:	c3                   	ret    

008026b3 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8026b3:	55                   	push   %ebp
  8026b4:	89 e5                	mov    %esp,%ebp
  8026b6:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8026b9:	e8 f8 f0 ff ff       	call   8017b6 <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  8026be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026c2:	75 13                	jne    8026d7 <realloc+0x24>
		return malloc(new_size);
  8026c4:	83 ec 0c             	sub    $0xc,%esp
  8026c7:	ff 75 0c             	pushl  0xc(%ebp)
  8026ca:	e8 c4 f1 ff ff       	call   801893 <malloc>
  8026cf:	83 c4 10             	add    $0x10,%esp
  8026d2:	e9 f4 05 00 00       	jmp    802ccb <realloc+0x618>
	if (new_size == 0)
  8026d7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8026db:	75 18                	jne    8026f5 <realloc+0x42>
	{
		free(virtual_address);
  8026dd:	83 ec 0c             	sub    $0xc,%esp
  8026e0:	ff 75 08             	pushl  0x8(%ebp)
  8026e3:	e8 0b f5 ff ff       	call   801bf3 <free>
  8026e8:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8026eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8026f0:	e9 d6 05 00 00       	jmp    802ccb <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  8026f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f8:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  8026fb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026fe:	85 c0                	test   %eax,%eax
  802700:	79 74                	jns    802776 <realloc+0xc3>
  802702:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  802709:	77 6b                	ja     802776 <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  80270b:	83 ec 0c             	sub    $0xc,%esp
  80270e:	ff 75 0c             	pushl  0xc(%ebp)
  802711:	e8 7d f1 ff ff       	call   801893 <malloc>
  802716:	83 c4 10             	add    $0x10,%esp
  802719:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  80271c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  802720:	75 0a                	jne    80272c <realloc+0x79>
			return NULL;
  802722:	b8 00 00 00 00       	mov    $0x0,%eax
  802727:	e9 9f 05 00 00       	jmp    802ccb <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  80272c:	83 ec 0c             	sub    $0xc,%esp
  80272f:	ff 75 08             	pushl  0x8(%ebp)
  802732:	e8 e0 11 00 00       	call   803917 <get_block_size>
  802737:	83 c4 10             	add    $0x10,%esp
  80273a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  80273d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802740:	8b 45 0c             	mov    0xc(%ebp),%eax
  802743:	39 d0                	cmp    %edx,%eax
  802745:	76 02                	jbe    802749 <realloc+0x96>
  802747:	89 d0                	mov    %edx,%eax
  802749:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  80274c:	83 ec 04             	sub    $0x4,%esp
  80274f:	ff 75 c0             	pushl  -0x40(%ebp)
  802752:	ff 75 08             	pushl  0x8(%ebp)
  802755:	ff 75 c8             	pushl  -0x38(%ebp)
  802758:	e8 56 eb ff ff       	call   8012b3 <memmove>
  80275d:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  802760:	83 ec 0c             	sub    $0xc,%esp
  802763:	ff 75 08             	pushl  0x8(%ebp)
  802766:	e8 88 f4 ff ff       	call   801bf3 <free>
  80276b:	83 c4 10             	add    $0x10,%esp
		return newptr;
  80276e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802771:	e9 55 05 00 00       	jmp    802ccb <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  802776:	a1 30 51 83 00       	mov    0x835130,%eax
  80277b:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  80277e:	72 09                	jb     802789 <realloc+0xd6>
  802780:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  802787:	76 0a                	jbe    802793 <realloc+0xe0>
		return NULL;
  802789:	b8 00 00 00 00       	mov    $0x0,%eax
  80278e:	e9 38 05 00 00       	jmp    802ccb <realloc+0x618>
	uint32 oldsz = 0;
  802793:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  80279a:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8027a1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8027a8:	eb 50                	jmp    8027fa <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  8027aa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027ad:	89 d0                	mov    %edx,%eax
  8027af:	01 c0                	add    %eax,%eax
  8027b1:	01 d0                	add    %edx,%eax
  8027b3:	c1 e0 02             	shl    $0x2,%eax
  8027b6:	05 48 50 80 00       	add    $0x805048,%eax
  8027bb:	8a 00                	mov    (%eax),%al
  8027bd:	84 c0                	test   %al,%al
  8027bf:	74 36                	je     8027f7 <realloc+0x144>
  8027c1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027c4:	89 d0                	mov    %edx,%eax
  8027c6:	01 c0                	add    %eax,%eax
  8027c8:	01 d0                	add    %edx,%eax
  8027ca:	c1 e0 02             	shl    $0x2,%eax
  8027cd:	05 40 50 80 00       	add    $0x805040,%eax
  8027d2:	8b 00                	mov    (%eax),%eax
  8027d4:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8027d7:	75 1e                	jne    8027f7 <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  8027d9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027dc:	89 d0                	mov    %edx,%eax
  8027de:	01 c0                	add    %eax,%eax
  8027e0:	01 d0                	add    %edx,%eax
  8027e2:	c1 e0 02             	shl    $0x2,%eax
  8027e5:	05 44 50 80 00       	add    $0x805044,%eax
  8027ea:	8b 00                	mov    (%eax),%eax
  8027ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  8027ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  8027f5:	eb 0c                	jmp    802803 <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8027f7:	ff 45 ec             	incl   -0x14(%ebp)
  8027fa:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802801:	7e a7                	jle    8027aa <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  802803:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802807:	75 0a                	jne    802813 <realloc+0x160>
		return NULL;
  802809:	b8 00 00 00 00       	mov    $0x0,%eax
  80280e:	e9 b8 04 00 00       	jmp    802ccb <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  802813:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  80281a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80281d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802820:	01 d0                	add    %edx,%eax
  802822:	48                   	dec    %eax
  802823:	89 45 b8             	mov    %eax,-0x48(%ebp)
  802826:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802829:	ba 00 00 00 00       	mov    $0x0,%edx
  80282e:	f7 75 bc             	divl   -0x44(%ebp)
  802831:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802834:	29 d0                	sub    %edx,%eax
  802836:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  802839:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80283c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80283f:	75 08                	jne    802849 <realloc+0x196>
		return virtual_address;
  802841:	8b 45 08             	mov    0x8(%ebp),%eax
  802844:	e9 82 04 00 00       	jmp    802ccb <realloc+0x618>
	if (req < oldsz)
  802849:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80284c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80284f:	0f 83 cd 02 00 00    	jae    802b22 <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  802855:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802858:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  80285b:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  80285e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802861:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802864:	01 d0                	add    %edx,%eax
  802866:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  802869:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80286c:	89 d0                	mov    %edx,%eax
  80286e:	01 c0                	add    %eax,%eax
  802870:	01 d0                	add    %edx,%eax
  802872:	c1 e0 02             	shl    $0x2,%eax
  802875:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  80287b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80287e:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  802880:	83 ec 08             	sub    $0x8,%esp
  802883:	ff 75 b0             	pushl  -0x50(%ebp)
  802886:	ff 75 ac             	pushl  -0x54(%ebp)
  802889:	e8 e3 0c 00 00       	call   803571 <sys_free_user_mem>
  80288e:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  802891:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802898:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80289f:	eb 64                	jmp    802905 <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  8028a1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028a4:	89 d0                	mov    %edx,%eax
  8028a6:	01 c0                	add    %eax,%eax
  8028a8:	01 d0                	add    %edx,%eax
  8028aa:	c1 e0 02             	shl    $0x2,%eax
  8028ad:	05 48 10 81 00       	add    $0x811048,%eax
  8028b2:	8a 00                	mov    (%eax),%al
  8028b4:	84 c0                	test   %al,%al
  8028b6:	75 4a                	jne    802902 <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  8028b8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028bb:	89 d0                	mov    %edx,%eax
  8028bd:	01 c0                	add    %eax,%eax
  8028bf:	01 d0                	add    %edx,%eax
  8028c1:	c1 e0 02             	shl    $0x2,%eax
  8028c4:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  8028ca:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8028cd:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  8028cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028d2:	89 d0                	mov    %edx,%eax
  8028d4:	01 c0                	add    %eax,%eax
  8028d6:	01 d0                	add    %edx,%eax
  8028d8:	c1 e0 02             	shl    $0x2,%eax
  8028db:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  8028e1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028e4:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  8028e6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028e9:	89 d0                	mov    %edx,%eax
  8028eb:	01 c0                	add    %eax,%eax
  8028ed:	01 d0                	add    %edx,%eax
  8028ef:	c1 e0 02             	shl    $0x2,%eax
  8028f2:	05 48 10 81 00       	add    $0x811048,%eax
  8028f7:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  8028fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028fd:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  802900:	eb 0c                	jmp    80290e <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802902:	ff 45 e4             	incl   -0x1c(%ebp)
  802905:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  80290c:	7e 93                	jle    8028a1 <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  80290e:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802912:	0f 84 8d 01 00 00    	je     802aa5 <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802918:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80291f:	e9 74 01 00 00       	jmp    802a98 <realloc+0x3e5>
			{
				if (k == fidx) continue;
  802924:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802927:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80292a:	0f 84 64 01 00 00    	je     802a94 <realloc+0x3e1>
				if (uhp_frees[k].free)
  802930:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802933:	89 d0                	mov    %edx,%eax
  802935:	01 c0                	add    %eax,%eax
  802937:	01 d0                	add    %edx,%eax
  802939:	c1 e0 02             	shl    $0x2,%eax
  80293c:	05 48 10 81 00       	add    $0x811048,%eax
  802941:	8a 00                	mov    (%eax),%al
  802943:	84 c0                	test   %al,%al
  802945:	0f 84 4a 01 00 00    	je     802a95 <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  80294b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80294e:	89 d0                	mov    %edx,%eax
  802950:	01 c0                	add    %eax,%eax
  802952:	01 d0                	add    %edx,%eax
  802954:	c1 e0 02             	shl    $0x2,%eax
  802957:	05 40 10 81 00       	add    $0x811040,%eax
  80295c:	8b 08                	mov    (%eax),%ecx
  80295e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802961:	89 d0                	mov    %edx,%eax
  802963:	01 c0                	add    %eax,%eax
  802965:	01 d0                	add    %edx,%eax
  802967:	c1 e0 02             	shl    $0x2,%eax
  80296a:	05 44 10 81 00       	add    $0x811044,%eax
  80296f:	8b 00                	mov    (%eax),%eax
  802971:	01 c1                	add    %eax,%ecx
  802973:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802976:	89 d0                	mov    %edx,%eax
  802978:	01 c0                	add    %eax,%eax
  80297a:	01 d0                	add    %edx,%eax
  80297c:	c1 e0 02             	shl    $0x2,%eax
  80297f:	05 40 10 81 00       	add    $0x811040,%eax
  802984:	8b 00                	mov    (%eax),%eax
  802986:	39 c1                	cmp    %eax,%ecx
  802988:	75 7a                	jne    802a04 <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  80298a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80298d:	89 d0                	mov    %edx,%eax
  80298f:	01 c0                	add    %eax,%eax
  802991:	01 d0                	add    %edx,%eax
  802993:	c1 e0 02             	shl    $0x2,%eax
  802996:	05 40 10 81 00       	add    $0x811040,%eax
  80299b:	8b 10                	mov    (%eax),%edx
  80299d:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  8029a0:	89 c8                	mov    %ecx,%eax
  8029a2:	01 c0                	add    %eax,%eax
  8029a4:	01 c8                	add    %ecx,%eax
  8029a6:	c1 e0 02             	shl    $0x2,%eax
  8029a9:	05 40 10 81 00       	add    $0x811040,%eax
  8029ae:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  8029b0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029b3:	89 d0                	mov    %edx,%eax
  8029b5:	01 c0                	add    %eax,%eax
  8029b7:	01 d0                	add    %edx,%eax
  8029b9:	c1 e0 02             	shl    $0x2,%eax
  8029bc:	05 44 10 81 00       	add    $0x811044,%eax
  8029c1:	8b 08                	mov    (%eax),%ecx
  8029c3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8029c6:	89 d0                	mov    %edx,%eax
  8029c8:	01 c0                	add    %eax,%eax
  8029ca:	01 d0                	add    %edx,%eax
  8029cc:	c1 e0 02             	shl    $0x2,%eax
  8029cf:	05 44 10 81 00       	add    $0x811044,%eax
  8029d4:	8b 00                	mov    (%eax),%eax
  8029d6:	01 c1                	add    %eax,%ecx
  8029d8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029db:	89 d0                	mov    %edx,%eax
  8029dd:	01 c0                	add    %eax,%eax
  8029df:	01 d0                	add    %edx,%eax
  8029e1:	c1 e0 02             	shl    $0x2,%eax
  8029e4:	05 44 10 81 00       	add    $0x811044,%eax
  8029e9:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  8029eb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8029ee:	89 d0                	mov    %edx,%eax
  8029f0:	01 c0                	add    %eax,%eax
  8029f2:	01 d0                	add    %edx,%eax
  8029f4:	c1 e0 02             	shl    $0x2,%eax
  8029f7:	05 48 10 81 00       	add    $0x811048,%eax
  8029fc:	c6 00 00             	movb   $0x0,(%eax)
  8029ff:	e9 91 00 00 00       	jmp    802a95 <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802a04:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a07:	89 d0                	mov    %edx,%eax
  802a09:	01 c0                	add    %eax,%eax
  802a0b:	01 d0                	add    %edx,%eax
  802a0d:	c1 e0 02             	shl    $0x2,%eax
  802a10:	05 40 10 81 00       	add    $0x811040,%eax
  802a15:	8b 08                	mov    (%eax),%ecx
  802a17:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a1a:	89 d0                	mov    %edx,%eax
  802a1c:	01 c0                	add    %eax,%eax
  802a1e:	01 d0                	add    %edx,%eax
  802a20:	c1 e0 02             	shl    $0x2,%eax
  802a23:	05 44 10 81 00       	add    $0x811044,%eax
  802a28:	8b 00                	mov    (%eax),%eax
  802a2a:	01 c1                	add    %eax,%ecx
  802a2c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a2f:	89 d0                	mov    %edx,%eax
  802a31:	01 c0                	add    %eax,%eax
  802a33:	01 d0                	add    %edx,%eax
  802a35:	c1 e0 02             	shl    $0x2,%eax
  802a38:	05 40 10 81 00       	add    $0x811040,%eax
  802a3d:	8b 00                	mov    (%eax),%eax
  802a3f:	39 c1                	cmp    %eax,%ecx
  802a41:	75 52                	jne    802a95 <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  802a43:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a46:	89 d0                	mov    %edx,%eax
  802a48:	01 c0                	add    %eax,%eax
  802a4a:	01 d0                	add    %edx,%eax
  802a4c:	c1 e0 02             	shl    $0x2,%eax
  802a4f:	05 44 10 81 00       	add    $0x811044,%eax
  802a54:	8b 08                	mov    (%eax),%ecx
  802a56:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a59:	89 d0                	mov    %edx,%eax
  802a5b:	01 c0                	add    %eax,%eax
  802a5d:	01 d0                	add    %edx,%eax
  802a5f:	c1 e0 02             	shl    $0x2,%eax
  802a62:	05 44 10 81 00       	add    $0x811044,%eax
  802a67:	8b 00                	mov    (%eax),%eax
  802a69:	01 c1                	add    %eax,%ecx
  802a6b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a6e:	89 d0                	mov    %edx,%eax
  802a70:	01 c0                	add    %eax,%eax
  802a72:	01 d0                	add    %edx,%eax
  802a74:	c1 e0 02             	shl    $0x2,%eax
  802a77:	05 44 10 81 00       	add    $0x811044,%eax
  802a7c:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802a7e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a81:	89 d0                	mov    %edx,%eax
  802a83:	01 c0                	add    %eax,%eax
  802a85:	01 d0                	add    %edx,%eax
  802a87:	c1 e0 02             	shl    $0x2,%eax
  802a8a:	05 48 10 81 00       	add    $0x811048,%eax
  802a8f:	c6 00 00             	movb   $0x0,(%eax)
  802a92:	eb 01                	jmp    802a95 <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  802a94:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802a95:	ff 45 e0             	incl   -0x20(%ebp)
  802a98:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802a9f:	0f 8e 7f fe ff ff    	jle    802924 <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  802aa5:	a1 30 51 83 00       	mov    0x835130,%eax
  802aaa:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802aad:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  802ab4:	eb 53                	jmp    802b09 <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  802ab6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802ab9:	89 d0                	mov    %edx,%eax
  802abb:	01 c0                	add    %eax,%eax
  802abd:	01 d0                	add    %edx,%eax
  802abf:	c1 e0 02             	shl    $0x2,%eax
  802ac2:	05 48 50 80 00       	add    $0x805048,%eax
  802ac7:	8a 00                	mov    (%eax),%al
  802ac9:	84 c0                	test   %al,%al
  802acb:	74 39                	je     802b06 <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802acd:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802ad0:	89 d0                	mov    %edx,%eax
  802ad2:	01 c0                	add    %eax,%eax
  802ad4:	01 d0                	add    %edx,%eax
  802ad6:	c1 e0 02             	shl    $0x2,%eax
  802ad9:	05 40 50 80 00       	add    $0x805040,%eax
  802ade:	8b 08                	mov    (%eax),%ecx
  802ae0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802ae3:	89 d0                	mov    %edx,%eax
  802ae5:	01 c0                	add    %eax,%eax
  802ae7:	01 d0                	add    %edx,%eax
  802ae9:	c1 e0 02             	shl    $0x2,%eax
  802aec:	05 44 50 80 00       	add    $0x805044,%eax
  802af1:	8b 00                	mov    (%eax),%eax
  802af3:	01 c8                	add    %ecx,%eax
  802af5:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  802af8:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802afb:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802afe:	76 06                	jbe    802b06 <realloc+0x453>
  802b00:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802b03:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802b06:	ff 45 d8             	incl   -0x28(%ebp)
  802b09:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  802b10:	7e a4                	jle    802ab6 <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  802b12:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b15:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  802b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1d:	e9 a9 01 00 00       	jmp    802ccb <realloc+0x618>
	}
	uint32 end = va + oldsz;
  802b22:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b28:	01 d0                	add    %edx,%eax
  802b2a:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  802b2d:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802b34:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  802b3b:	eb 57                	jmp    802b94 <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  802b3d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802b40:	89 d0                	mov    %edx,%eax
  802b42:	01 c0                	add    %eax,%eax
  802b44:	01 d0                	add    %edx,%eax
  802b46:	c1 e0 02             	shl    $0x2,%eax
  802b49:	05 48 10 81 00       	add    $0x811048,%eax
  802b4e:	8a 00                	mov    (%eax),%al
  802b50:	84 c0                	test   %al,%al
  802b52:	74 3d                	je     802b91 <realloc+0x4de>
  802b54:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802b57:	89 d0                	mov    %edx,%eax
  802b59:	01 c0                	add    %eax,%eax
  802b5b:	01 d0                	add    %edx,%eax
  802b5d:	c1 e0 02             	shl    $0x2,%eax
  802b60:	05 40 10 81 00       	add    $0x811040,%eax
  802b65:	8b 00                	mov    (%eax),%eax
  802b67:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802b6a:	75 25                	jne    802b91 <realloc+0x4de>
  802b6c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802b6f:	89 d0                	mov    %edx,%eax
  802b71:	01 c0                	add    %eax,%eax
  802b73:	01 d0                	add    %edx,%eax
  802b75:	c1 e0 02             	shl    $0x2,%eax
  802b78:	05 44 10 81 00       	add    $0x811044,%eax
  802b7d:	8b 10                	mov    (%eax),%edx
  802b7f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b82:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802b85:	39 c2                	cmp    %eax,%edx
  802b87:	72 08                	jb     802b91 <realloc+0x4de>
		{
			adjIdx = j; break;
  802b89:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802b8c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802b8f:	eb 0c                	jmp    802b9d <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802b91:	ff 45 d0             	incl   -0x30(%ebp)
  802b94:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  802b9b:	7e a0                	jle    802b3d <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  802b9d:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  802ba1:	0f 84 d6 00 00 00    	je     802c7d <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  802ba7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802baa:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802bad:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  802bb0:	83 ec 08             	sub    $0x8,%esp
  802bb3:	ff 75 a0             	pushl  -0x60(%ebp)
  802bb6:	ff 75 a4             	pushl  -0x5c(%ebp)
  802bb9:	e8 cf 09 00 00       	call   80358d <sys_allocate_user_mem>
  802bbe:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  802bc1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bc4:	89 d0                	mov    %edx,%eax
  802bc6:	01 c0                	add    %eax,%eax
  802bc8:	01 d0                	add    %edx,%eax
  802bca:	c1 e0 02             	shl    $0x2,%eax
  802bcd:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802bd3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802bd6:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  802bd8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802bdb:	89 d0                	mov    %edx,%eax
  802bdd:	01 c0                	add    %eax,%eax
  802bdf:	01 d0                	add    %edx,%eax
  802be1:	c1 e0 02             	shl    $0x2,%eax
  802be4:	05 40 10 81 00       	add    $0x811040,%eax
  802be9:	8b 10                	mov    (%eax),%edx
  802beb:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802bee:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802bf1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802bf4:	89 d0                	mov    %edx,%eax
  802bf6:	01 c0                	add    %eax,%eax
  802bf8:	01 d0                	add    %edx,%eax
  802bfa:	c1 e0 02             	shl    $0x2,%eax
  802bfd:	05 40 10 81 00       	add    $0x811040,%eax
  802c02:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  802c04:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802c07:	89 d0                	mov    %edx,%eax
  802c09:	01 c0                	add    %eax,%eax
  802c0b:	01 d0                	add    %edx,%eax
  802c0d:	c1 e0 02             	shl    $0x2,%eax
  802c10:	05 44 10 81 00       	add    $0x811044,%eax
  802c15:	8b 00                	mov    (%eax),%eax
  802c17:	2b 45 a0             	sub    -0x60(%ebp),%eax
  802c1a:	89 c2                	mov    %eax,%edx
  802c1c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  802c1f:	89 c8                	mov    %ecx,%eax
  802c21:	01 c0                	add    %eax,%eax
  802c23:	01 c8                	add    %ecx,%eax
  802c25:	c1 e0 02             	shl    $0x2,%eax
  802c28:	05 44 10 81 00       	add    $0x811044,%eax
  802c2d:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  802c2f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802c32:	89 d0                	mov    %edx,%eax
  802c34:	01 c0                	add    %eax,%eax
  802c36:	01 d0                	add    %edx,%eax
  802c38:	c1 e0 02             	shl    $0x2,%eax
  802c3b:	05 44 10 81 00       	add    $0x811044,%eax
  802c40:	8b 00                	mov    (%eax),%eax
  802c42:	85 c0                	test   %eax,%eax
  802c44:	75 14                	jne    802c5a <realloc+0x5a7>
  802c46:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802c49:	89 d0                	mov    %edx,%eax
  802c4b:	01 c0                	add    %eax,%eax
  802c4d:	01 d0                	add    %edx,%eax
  802c4f:	c1 e0 02             	shl    $0x2,%eax
  802c52:	05 48 10 81 00       	add    $0x811048,%eax
  802c57:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  802c5a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c5d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c60:	01 c2                	add    %eax,%edx
  802c62:	a1 88 50 83 00       	mov    0x835088,%eax
  802c67:	39 c2                	cmp    %eax,%edx
  802c69:	76 0d                	jbe    802c78 <realloc+0x5c5>
  802c6b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c6e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c71:	01 d0                	add    %edx,%eax
  802c73:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  802c78:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7b:	eb 4e                	jmp    802ccb <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  802c7d:	83 ec 0c             	sub    $0xc,%esp
  802c80:	ff 75 0c             	pushl  0xc(%ebp)
  802c83:	e8 0b ec ff ff       	call   801893 <malloc>
  802c88:	83 c4 10             	add    $0x10,%esp
  802c8b:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  802c8e:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  802c92:	75 07                	jne    802c9b <realloc+0x5e8>
		return NULL;
  802c94:	b8 00 00 00 00       	mov    $0x0,%eax
  802c99:	eb 30                	jmp    802ccb <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  802c9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c9e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ca1:	39 d0                	cmp    %edx,%eax
  802ca3:	76 02                	jbe    802ca7 <realloc+0x5f4>
  802ca5:	89 d0                	mov    %edx,%eax
  802ca7:	8b 55 9c             	mov    -0x64(%ebp),%edx
  802caa:	83 ec 04             	sub    $0x4,%esp
  802cad:	50                   	push   %eax
  802cae:	52                   	push   %edx
  802caf:	ff 75 cc             	pushl  -0x34(%ebp)
  802cb2:	e8 cf 06 00 00       	call   803386 <sys_move_user_mem>
  802cb7:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  802cba:	83 ec 0c             	sub    $0xc,%esp
  802cbd:	ff 75 08             	pushl  0x8(%ebp)
  802cc0:	e8 2e ef ff ff       	call   801bf3 <free>
  802cc5:	83 c4 10             	add    $0x10,%esp
	return newptr;
  802cc8:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  802ccb:	c9                   	leave  
  802ccc:	c3                   	ret    

00802ccd <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802ccd:	55                   	push   %ebp
  802cce:	89 e5                	mov    %esp,%ebp
  802cd0:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  802cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd6:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  802cd9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802cdd:	0f 84 33 03 00 00    	je     803016 <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  802ce3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ce6:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  802ceb:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  802cee:	83 ec 08             	sub    $0x8,%esp
  802cf1:	ff 75 08             	pushl  0x8(%ebp)
  802cf4:	ff 75 d8             	pushl  -0x28(%ebp)
  802cf7:	e8 7d 05 00 00       	call   803279 <sys_delete_shared_object>
  802cfc:	83 c4 10             	add    $0x10,%esp
  802cff:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  802d02:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802d06:	0f 88 0d 03 00 00    	js     803019 <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802d0c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802d13:	e9 ef 02 00 00       	jmp    803007 <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802d18:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d1b:	89 d0                	mov    %edx,%eax
  802d1d:	01 c0                	add    %eax,%eax
  802d1f:	01 d0                	add    %edx,%eax
  802d21:	c1 e0 02             	shl    $0x2,%eax
  802d24:	05 48 50 80 00       	add    $0x805048,%eax
  802d29:	8a 00                	mov    (%eax),%al
  802d2b:	84 c0                	test   %al,%al
  802d2d:	0f 84 d1 02 00 00    	je     803004 <sfree+0x337>
  802d33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d36:	89 d0                	mov    %edx,%eax
  802d38:	01 c0                	add    %eax,%eax
  802d3a:	01 d0                	add    %edx,%eax
  802d3c:	c1 e0 02             	shl    $0x2,%eax
  802d3f:	05 40 50 80 00       	add    $0x805040,%eax
  802d44:	8b 00                	mov    (%eax),%eax
  802d46:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802d49:	0f 85 b5 02 00 00    	jne    803004 <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  802d4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d52:	89 d0                	mov    %edx,%eax
  802d54:	01 c0                	add    %eax,%eax
  802d56:	01 d0                	add    %edx,%eax
  802d58:	c1 e0 02             	shl    $0x2,%eax
  802d5b:	05 44 50 80 00       	add    $0x805044,%eax
  802d60:	8b 00                	mov    (%eax),%eax
  802d62:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  802d65:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d68:	89 d0                	mov    %edx,%eax
  802d6a:	01 c0                	add    %eax,%eax
  802d6c:	01 d0                	add    %edx,%eax
  802d6e:	c1 e0 02             	shl    $0x2,%eax
  802d71:	05 48 50 80 00       	add    $0x805048,%eax
  802d76:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  802d79:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802d80:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802d87:	eb 64                	jmp    802ded <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  802d89:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d8c:	89 d0                	mov    %edx,%eax
  802d8e:	01 c0                	add    %eax,%eax
  802d90:	01 d0                	add    %edx,%eax
  802d92:	c1 e0 02             	shl    $0x2,%eax
  802d95:	05 48 10 81 00       	add    $0x811048,%eax
  802d9a:	8a 00                	mov    (%eax),%al
  802d9c:	84 c0                	test   %al,%al
  802d9e:	75 4a                	jne    802dea <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  802da0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802da3:	89 d0                	mov    %edx,%eax
  802da5:	01 c0                	add    %eax,%eax
  802da7:	01 d0                	add    %edx,%eax
  802da9:	c1 e0 02             	shl    $0x2,%eax
  802dac:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  802db2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802db5:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  802db7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802dba:	89 d0                	mov    %edx,%eax
  802dbc:	01 c0                	add    %eax,%eax
  802dbe:	01 d0                	add    %edx,%eax
  802dc0:	c1 e0 02             	shl    $0x2,%eax
  802dc3:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  802dc9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802dcc:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  802dce:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802dd1:	89 d0                	mov    %edx,%eax
  802dd3:	01 c0                	add    %eax,%eax
  802dd5:	01 d0                	add    %edx,%eax
  802dd7:	c1 e0 02             	shl    $0x2,%eax
  802dda:	05 48 10 81 00       	add    $0x811048,%eax
  802ddf:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  802de2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802de5:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  802de8:	eb 0c                	jmp    802df6 <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802dea:	ff 45 ec             	incl   -0x14(%ebp)
  802ded:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802df4:	7e 93                	jle    802d89 <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  802df6:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802dfa:	0f 84 8d 01 00 00    	je     802f8d <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802e00:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802e07:	e9 74 01 00 00       	jmp    802f80 <sfree+0x2b3>
				{
					if (k == fidx) continue;
  802e0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e0f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802e12:	0f 84 64 01 00 00    	je     802f7c <sfree+0x2af>
					if (uhp_frees[k].free)
  802e18:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e1b:	89 d0                	mov    %edx,%eax
  802e1d:	01 c0                	add    %eax,%eax
  802e1f:	01 d0                	add    %edx,%eax
  802e21:	c1 e0 02             	shl    $0x2,%eax
  802e24:	05 48 10 81 00       	add    $0x811048,%eax
  802e29:	8a 00                	mov    (%eax),%al
  802e2b:	84 c0                	test   %al,%al
  802e2d:	0f 84 4a 01 00 00    	je     802f7d <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802e33:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e36:	89 d0                	mov    %edx,%eax
  802e38:	01 c0                	add    %eax,%eax
  802e3a:	01 d0                	add    %edx,%eax
  802e3c:	c1 e0 02             	shl    $0x2,%eax
  802e3f:	05 40 10 81 00       	add    $0x811040,%eax
  802e44:	8b 08                	mov    (%eax),%ecx
  802e46:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e49:	89 d0                	mov    %edx,%eax
  802e4b:	01 c0                	add    %eax,%eax
  802e4d:	01 d0                	add    %edx,%eax
  802e4f:	c1 e0 02             	shl    $0x2,%eax
  802e52:	05 44 10 81 00       	add    $0x811044,%eax
  802e57:	8b 00                	mov    (%eax),%eax
  802e59:	01 c1                	add    %eax,%ecx
  802e5b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e5e:	89 d0                	mov    %edx,%eax
  802e60:	01 c0                	add    %eax,%eax
  802e62:	01 d0                	add    %edx,%eax
  802e64:	c1 e0 02             	shl    $0x2,%eax
  802e67:	05 40 10 81 00       	add    $0x811040,%eax
  802e6c:	8b 00                	mov    (%eax),%eax
  802e6e:	39 c1                	cmp    %eax,%ecx
  802e70:	75 7a                	jne    802eec <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  802e72:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e75:	89 d0                	mov    %edx,%eax
  802e77:	01 c0                	add    %eax,%eax
  802e79:	01 d0                	add    %edx,%eax
  802e7b:	c1 e0 02             	shl    $0x2,%eax
  802e7e:	05 40 10 81 00       	add    $0x811040,%eax
  802e83:	8b 10                	mov    (%eax),%edx
  802e85:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802e88:	89 c8                	mov    %ecx,%eax
  802e8a:	01 c0                	add    %eax,%eax
  802e8c:	01 c8                	add    %ecx,%eax
  802e8e:	c1 e0 02             	shl    $0x2,%eax
  802e91:	05 40 10 81 00       	add    $0x811040,%eax
  802e96:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  802e98:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e9b:	89 d0                	mov    %edx,%eax
  802e9d:	01 c0                	add    %eax,%eax
  802e9f:	01 d0                	add    %edx,%eax
  802ea1:	c1 e0 02             	shl    $0x2,%eax
  802ea4:	05 44 10 81 00       	add    $0x811044,%eax
  802ea9:	8b 08                	mov    (%eax),%ecx
  802eab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802eae:	89 d0                	mov    %edx,%eax
  802eb0:	01 c0                	add    %eax,%eax
  802eb2:	01 d0                	add    %edx,%eax
  802eb4:	c1 e0 02             	shl    $0x2,%eax
  802eb7:	05 44 10 81 00       	add    $0x811044,%eax
  802ebc:	8b 00                	mov    (%eax),%eax
  802ebe:	01 c1                	add    %eax,%ecx
  802ec0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ec3:	89 d0                	mov    %edx,%eax
  802ec5:	01 c0                	add    %eax,%eax
  802ec7:	01 d0                	add    %edx,%eax
  802ec9:	c1 e0 02             	shl    $0x2,%eax
  802ecc:	05 44 10 81 00       	add    $0x811044,%eax
  802ed1:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802ed3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ed6:	89 d0                	mov    %edx,%eax
  802ed8:	01 c0                	add    %eax,%eax
  802eda:	01 d0                	add    %edx,%eax
  802edc:	c1 e0 02             	shl    $0x2,%eax
  802edf:	05 48 10 81 00       	add    $0x811048,%eax
  802ee4:	c6 00 00             	movb   $0x0,(%eax)
  802ee7:	e9 91 00 00 00       	jmp    802f7d <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802eec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802eef:	89 d0                	mov    %edx,%eax
  802ef1:	01 c0                	add    %eax,%eax
  802ef3:	01 d0                	add    %edx,%eax
  802ef5:	c1 e0 02             	shl    $0x2,%eax
  802ef8:	05 40 10 81 00       	add    $0x811040,%eax
  802efd:	8b 08                	mov    (%eax),%ecx
  802eff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f02:	89 d0                	mov    %edx,%eax
  802f04:	01 c0                	add    %eax,%eax
  802f06:	01 d0                	add    %edx,%eax
  802f08:	c1 e0 02             	shl    $0x2,%eax
  802f0b:	05 44 10 81 00       	add    $0x811044,%eax
  802f10:	8b 00                	mov    (%eax),%eax
  802f12:	01 c1                	add    %eax,%ecx
  802f14:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f17:	89 d0                	mov    %edx,%eax
  802f19:	01 c0                	add    %eax,%eax
  802f1b:	01 d0                	add    %edx,%eax
  802f1d:	c1 e0 02             	shl    $0x2,%eax
  802f20:	05 40 10 81 00       	add    $0x811040,%eax
  802f25:	8b 00                	mov    (%eax),%eax
  802f27:	39 c1                	cmp    %eax,%ecx
  802f29:	75 52                	jne    802f7d <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  802f2b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f2e:	89 d0                	mov    %edx,%eax
  802f30:	01 c0                	add    %eax,%eax
  802f32:	01 d0                	add    %edx,%eax
  802f34:	c1 e0 02             	shl    $0x2,%eax
  802f37:	05 44 10 81 00       	add    $0x811044,%eax
  802f3c:	8b 08                	mov    (%eax),%ecx
  802f3e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f41:	89 d0                	mov    %edx,%eax
  802f43:	01 c0                	add    %eax,%eax
  802f45:	01 d0                	add    %edx,%eax
  802f47:	c1 e0 02             	shl    $0x2,%eax
  802f4a:	05 44 10 81 00       	add    $0x811044,%eax
  802f4f:	8b 00                	mov    (%eax),%eax
  802f51:	01 c1                	add    %eax,%ecx
  802f53:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f56:	89 d0                	mov    %edx,%eax
  802f58:	01 c0                	add    %eax,%eax
  802f5a:	01 d0                	add    %edx,%eax
  802f5c:	c1 e0 02             	shl    $0x2,%eax
  802f5f:	05 44 10 81 00       	add    $0x811044,%eax
  802f64:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802f66:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f69:	89 d0                	mov    %edx,%eax
  802f6b:	01 c0                	add    %eax,%eax
  802f6d:	01 d0                	add    %edx,%eax
  802f6f:	c1 e0 02             	shl    $0x2,%eax
  802f72:	05 48 10 81 00       	add    $0x811048,%eax
  802f77:	c6 00 00             	movb   $0x0,(%eax)
  802f7a:	eb 01                	jmp    802f7d <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  802f7c:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802f7d:	ff 45 e8             	incl   -0x18(%ebp)
  802f80:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802f87:	0f 8e 7f fe ff ff    	jle    802e0c <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  802f8d:	a1 30 51 83 00       	mov    0x835130,%eax
  802f92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802f95:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802f9c:	eb 53                	jmp    802ff1 <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  802f9e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fa1:	89 d0                	mov    %edx,%eax
  802fa3:	01 c0                	add    %eax,%eax
  802fa5:	01 d0                	add    %edx,%eax
  802fa7:	c1 e0 02             	shl    $0x2,%eax
  802faa:	05 48 50 80 00       	add    $0x805048,%eax
  802faf:	8a 00                	mov    (%eax),%al
  802fb1:	84 c0                	test   %al,%al
  802fb3:	74 39                	je     802fee <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802fb5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fb8:	89 d0                	mov    %edx,%eax
  802fba:	01 c0                	add    %eax,%eax
  802fbc:	01 d0                	add    %edx,%eax
  802fbe:	c1 e0 02             	shl    $0x2,%eax
  802fc1:	05 40 50 80 00       	add    $0x805040,%eax
  802fc6:	8b 08                	mov    (%eax),%ecx
  802fc8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fcb:	89 d0                	mov    %edx,%eax
  802fcd:	01 c0                	add    %eax,%eax
  802fcf:	01 d0                	add    %edx,%eax
  802fd1:	c1 e0 02             	shl    $0x2,%eax
  802fd4:	05 44 50 80 00       	add    $0x805044,%eax
  802fd9:	8b 00                	mov    (%eax),%eax
  802fdb:	01 c8                	add    %ecx,%eax
  802fdd:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  802fe0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fe3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802fe6:	76 06                	jbe    802fee <sfree+0x321>
  802fe8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802feb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802fee:	ff 45 e0             	incl   -0x20(%ebp)
  802ff1:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802ff8:	7e a4                	jle    802f9e <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  802ffa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ffd:	a3 88 50 83 00       	mov    %eax,0x835088
			break;
  803002:	eb 16                	jmp    80301a <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  803004:	ff 45 f4             	incl   -0xc(%ebp)
  803007:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  80300e:	0f 8e 04 fd ff ff    	jle    802d18 <sfree+0x4b>
  803014:	eb 04                	jmp    80301a <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  803016:	90                   	nop
  803017:	eb 01                	jmp    80301a <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  803019:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  80301a:	c9                   	leave  
  80301b:	c3                   	ret    

0080301c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80301c:	55                   	push   %ebp
  80301d:	89 e5                	mov    %esp,%ebp
  80301f:	57                   	push   %edi
  803020:	56                   	push   %esi
  803021:	53                   	push   %ebx
  803022:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  803025:	8b 45 08             	mov    0x8(%ebp),%eax
  803028:	8b 55 0c             	mov    0xc(%ebp),%edx
  80302b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80302e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803031:	8b 7d 18             	mov    0x18(%ebp),%edi
  803034:	8b 75 1c             	mov    0x1c(%ebp),%esi
  803037:	cd 30                	int    $0x30
  803039:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80303c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80303f:	83 c4 10             	add    $0x10,%esp
  803042:	5b                   	pop    %ebx
  803043:	5e                   	pop    %esi
  803044:	5f                   	pop    %edi
  803045:	5d                   	pop    %ebp
  803046:	c3                   	ret    

00803047 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  803047:	55                   	push   %ebp
  803048:	89 e5                	mov    %esp,%ebp
  80304a:	83 ec 04             	sub    $0x4,%esp
  80304d:	8b 45 10             	mov    0x10(%ebp),%eax
  803050:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  803053:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803056:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80305a:	8b 45 08             	mov    0x8(%ebp),%eax
  80305d:	6a 00                	push   $0x0
  80305f:	51                   	push   %ecx
  803060:	52                   	push   %edx
  803061:	ff 75 0c             	pushl  0xc(%ebp)
  803064:	50                   	push   %eax
  803065:	6a 00                	push   $0x0
  803067:	e8 b0 ff ff ff       	call   80301c <syscall>
  80306c:	83 c4 18             	add    $0x18,%esp
}
  80306f:	90                   	nop
  803070:	c9                   	leave  
  803071:	c3                   	ret    

00803072 <sys_cgetc>:

int
sys_cgetc(void)
{
  803072:	55                   	push   %ebp
  803073:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  803075:	6a 00                	push   $0x0
  803077:	6a 00                	push   $0x0
  803079:	6a 00                	push   $0x0
  80307b:	6a 00                	push   $0x0
  80307d:	6a 00                	push   $0x0
  80307f:	6a 02                	push   $0x2
  803081:	e8 96 ff ff ff       	call   80301c <syscall>
  803086:	83 c4 18             	add    $0x18,%esp
}
  803089:	c9                   	leave  
  80308a:	c3                   	ret    

0080308b <sys_lock_cons>:

void sys_lock_cons(void)
{
  80308b:	55                   	push   %ebp
  80308c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80308e:	6a 00                	push   $0x0
  803090:	6a 00                	push   $0x0
  803092:	6a 00                	push   $0x0
  803094:	6a 00                	push   $0x0
  803096:	6a 00                	push   $0x0
  803098:	6a 03                	push   $0x3
  80309a:	e8 7d ff ff ff       	call   80301c <syscall>
  80309f:	83 c4 18             	add    $0x18,%esp
}
  8030a2:	90                   	nop
  8030a3:	c9                   	leave  
  8030a4:	c3                   	ret    

008030a5 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8030a5:	55                   	push   %ebp
  8030a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8030a8:	6a 00                	push   $0x0
  8030aa:	6a 00                	push   $0x0
  8030ac:	6a 00                	push   $0x0
  8030ae:	6a 00                	push   $0x0
  8030b0:	6a 00                	push   $0x0
  8030b2:	6a 04                	push   $0x4
  8030b4:	e8 63 ff ff ff       	call   80301c <syscall>
  8030b9:	83 c4 18             	add    $0x18,%esp
}
  8030bc:	90                   	nop
  8030bd:	c9                   	leave  
  8030be:	c3                   	ret    

008030bf <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8030bf:	55                   	push   %ebp
  8030c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8030c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c8:	6a 00                	push   $0x0
  8030ca:	6a 00                	push   $0x0
  8030cc:	6a 00                	push   $0x0
  8030ce:	52                   	push   %edx
  8030cf:	50                   	push   %eax
  8030d0:	6a 08                	push   $0x8
  8030d2:	e8 45 ff ff ff       	call   80301c <syscall>
  8030d7:	83 c4 18             	add    $0x18,%esp
}
  8030da:	c9                   	leave  
  8030db:	c3                   	ret    

008030dc <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8030dc:	55                   	push   %ebp
  8030dd:	89 e5                	mov    %esp,%ebp
  8030df:	56                   	push   %esi
  8030e0:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8030e1:	8b 75 18             	mov    0x18(%ebp),%esi
  8030e4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8030e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8030ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f0:	56                   	push   %esi
  8030f1:	53                   	push   %ebx
  8030f2:	51                   	push   %ecx
  8030f3:	52                   	push   %edx
  8030f4:	50                   	push   %eax
  8030f5:	6a 09                	push   $0x9
  8030f7:	e8 20 ff ff ff       	call   80301c <syscall>
  8030fc:	83 c4 18             	add    $0x18,%esp
}
  8030ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803102:	5b                   	pop    %ebx
  803103:	5e                   	pop    %esi
  803104:	5d                   	pop    %ebp
  803105:	c3                   	ret    

00803106 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  803106:	55                   	push   %ebp
  803107:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  803109:	6a 00                	push   $0x0
  80310b:	6a 00                	push   $0x0
  80310d:	6a 00                	push   $0x0
  80310f:	6a 00                	push   $0x0
  803111:	ff 75 08             	pushl  0x8(%ebp)
  803114:	6a 0a                	push   $0xa
  803116:	e8 01 ff ff ff       	call   80301c <syscall>
  80311b:	83 c4 18             	add    $0x18,%esp
}
  80311e:	c9                   	leave  
  80311f:	c3                   	ret    

00803120 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  803120:	55                   	push   %ebp
  803121:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  803123:	6a 00                	push   $0x0
  803125:	6a 00                	push   $0x0
  803127:	6a 00                	push   $0x0
  803129:	ff 75 0c             	pushl  0xc(%ebp)
  80312c:	ff 75 08             	pushl  0x8(%ebp)
  80312f:	6a 0b                	push   $0xb
  803131:	e8 e6 fe ff ff       	call   80301c <syscall>
  803136:	83 c4 18             	add    $0x18,%esp
}
  803139:	c9                   	leave  
  80313a:	c3                   	ret    

0080313b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80313b:	55                   	push   %ebp
  80313c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80313e:	6a 00                	push   $0x0
  803140:	6a 00                	push   $0x0
  803142:	6a 00                	push   $0x0
  803144:	6a 00                	push   $0x0
  803146:	6a 00                	push   $0x0
  803148:	6a 0c                	push   $0xc
  80314a:	e8 cd fe ff ff       	call   80301c <syscall>
  80314f:	83 c4 18             	add    $0x18,%esp
}
  803152:	c9                   	leave  
  803153:	c3                   	ret    

00803154 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  803154:	55                   	push   %ebp
  803155:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  803157:	6a 00                	push   $0x0
  803159:	6a 00                	push   $0x0
  80315b:	6a 00                	push   $0x0
  80315d:	6a 00                	push   $0x0
  80315f:	6a 00                	push   $0x0
  803161:	6a 0d                	push   $0xd
  803163:	e8 b4 fe ff ff       	call   80301c <syscall>
  803168:	83 c4 18             	add    $0x18,%esp
}
  80316b:	c9                   	leave  
  80316c:	c3                   	ret    

0080316d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80316d:	55                   	push   %ebp
  80316e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  803170:	6a 00                	push   $0x0
  803172:	6a 00                	push   $0x0
  803174:	6a 00                	push   $0x0
  803176:	6a 00                	push   $0x0
  803178:	6a 00                	push   $0x0
  80317a:	6a 0e                	push   $0xe
  80317c:	e8 9b fe ff ff       	call   80301c <syscall>
  803181:	83 c4 18             	add    $0x18,%esp
}
  803184:	c9                   	leave  
  803185:	c3                   	ret    

00803186 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  803186:	55                   	push   %ebp
  803187:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  803189:	6a 00                	push   $0x0
  80318b:	6a 00                	push   $0x0
  80318d:	6a 00                	push   $0x0
  80318f:	6a 00                	push   $0x0
  803191:	6a 00                	push   $0x0
  803193:	6a 0f                	push   $0xf
  803195:	e8 82 fe ff ff       	call   80301c <syscall>
  80319a:	83 c4 18             	add    $0x18,%esp
}
  80319d:	c9                   	leave  
  80319e:	c3                   	ret    

0080319f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80319f:	55                   	push   %ebp
  8031a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8031a2:	6a 00                	push   $0x0
  8031a4:	6a 00                	push   $0x0
  8031a6:	6a 00                	push   $0x0
  8031a8:	6a 00                	push   $0x0
  8031aa:	ff 75 08             	pushl  0x8(%ebp)
  8031ad:	6a 10                	push   $0x10
  8031af:	e8 68 fe ff ff       	call   80301c <syscall>
  8031b4:	83 c4 18             	add    $0x18,%esp
}
  8031b7:	c9                   	leave  
  8031b8:	c3                   	ret    

008031b9 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8031b9:	55                   	push   %ebp
  8031ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8031bc:	6a 00                	push   $0x0
  8031be:	6a 00                	push   $0x0
  8031c0:	6a 00                	push   $0x0
  8031c2:	6a 00                	push   $0x0
  8031c4:	6a 00                	push   $0x0
  8031c6:	6a 11                	push   $0x11
  8031c8:	e8 4f fe ff ff       	call   80301c <syscall>
  8031cd:	83 c4 18             	add    $0x18,%esp
}
  8031d0:	90                   	nop
  8031d1:	c9                   	leave  
  8031d2:	c3                   	ret    

008031d3 <sys_cputc>:

void
sys_cputc(const char c)
{
  8031d3:	55                   	push   %ebp
  8031d4:	89 e5                	mov    %esp,%ebp
  8031d6:	83 ec 04             	sub    $0x4,%esp
  8031d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031dc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8031df:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8031e3:	6a 00                	push   $0x0
  8031e5:	6a 00                	push   $0x0
  8031e7:	6a 00                	push   $0x0
  8031e9:	6a 00                	push   $0x0
  8031eb:	50                   	push   %eax
  8031ec:	6a 01                	push   $0x1
  8031ee:	e8 29 fe ff ff       	call   80301c <syscall>
  8031f3:	83 c4 18             	add    $0x18,%esp
}
  8031f6:	90                   	nop
  8031f7:	c9                   	leave  
  8031f8:	c3                   	ret    

008031f9 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8031f9:	55                   	push   %ebp
  8031fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8031fc:	6a 00                	push   $0x0
  8031fe:	6a 00                	push   $0x0
  803200:	6a 00                	push   $0x0
  803202:	6a 00                	push   $0x0
  803204:	6a 00                	push   $0x0
  803206:	6a 14                	push   $0x14
  803208:	e8 0f fe ff ff       	call   80301c <syscall>
  80320d:	83 c4 18             	add    $0x18,%esp
}
  803210:	90                   	nop
  803211:	c9                   	leave  
  803212:	c3                   	ret    

00803213 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  803213:	55                   	push   %ebp
  803214:	89 e5                	mov    %esp,%ebp
  803216:	83 ec 04             	sub    $0x4,%esp
  803219:	8b 45 10             	mov    0x10(%ebp),%eax
  80321c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80321f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803222:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803226:	8b 45 08             	mov    0x8(%ebp),%eax
  803229:	6a 00                	push   $0x0
  80322b:	51                   	push   %ecx
  80322c:	52                   	push   %edx
  80322d:	ff 75 0c             	pushl  0xc(%ebp)
  803230:	50                   	push   %eax
  803231:	6a 15                	push   $0x15
  803233:	e8 e4 fd ff ff       	call   80301c <syscall>
  803238:	83 c4 18             	add    $0x18,%esp
}
  80323b:	c9                   	leave  
  80323c:	c3                   	ret    

0080323d <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80323d:	55                   	push   %ebp
  80323e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  803240:	8b 55 0c             	mov    0xc(%ebp),%edx
  803243:	8b 45 08             	mov    0x8(%ebp),%eax
  803246:	6a 00                	push   $0x0
  803248:	6a 00                	push   $0x0
  80324a:	6a 00                	push   $0x0
  80324c:	52                   	push   %edx
  80324d:	50                   	push   %eax
  80324e:	6a 16                	push   $0x16
  803250:	e8 c7 fd ff ff       	call   80301c <syscall>
  803255:	83 c4 18             	add    $0x18,%esp
}
  803258:	c9                   	leave  
  803259:	c3                   	ret    

0080325a <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80325a:	55                   	push   %ebp
  80325b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80325d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803260:	8b 55 0c             	mov    0xc(%ebp),%edx
  803263:	8b 45 08             	mov    0x8(%ebp),%eax
  803266:	6a 00                	push   $0x0
  803268:	6a 00                	push   $0x0
  80326a:	51                   	push   %ecx
  80326b:	52                   	push   %edx
  80326c:	50                   	push   %eax
  80326d:	6a 17                	push   $0x17
  80326f:	e8 a8 fd ff ff       	call   80301c <syscall>
  803274:	83 c4 18             	add    $0x18,%esp
}
  803277:	c9                   	leave  
  803278:	c3                   	ret    

00803279 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  803279:	55                   	push   %ebp
  80327a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80327c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80327f:	8b 45 08             	mov    0x8(%ebp),%eax
  803282:	6a 00                	push   $0x0
  803284:	6a 00                	push   $0x0
  803286:	6a 00                	push   $0x0
  803288:	52                   	push   %edx
  803289:	50                   	push   %eax
  80328a:	6a 18                	push   $0x18
  80328c:	e8 8b fd ff ff       	call   80301c <syscall>
  803291:	83 c4 18             	add    $0x18,%esp
}
  803294:	c9                   	leave  
  803295:	c3                   	ret    

00803296 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  803296:	55                   	push   %ebp
  803297:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  803299:	8b 45 08             	mov    0x8(%ebp),%eax
  80329c:	6a 00                	push   $0x0
  80329e:	ff 75 14             	pushl  0x14(%ebp)
  8032a1:	ff 75 10             	pushl  0x10(%ebp)
  8032a4:	ff 75 0c             	pushl  0xc(%ebp)
  8032a7:	50                   	push   %eax
  8032a8:	6a 19                	push   $0x19
  8032aa:	e8 6d fd ff ff       	call   80301c <syscall>
  8032af:	83 c4 18             	add    $0x18,%esp
}
  8032b2:	c9                   	leave  
  8032b3:	c3                   	ret    

008032b4 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8032b4:	55                   	push   %ebp
  8032b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8032b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ba:	6a 00                	push   $0x0
  8032bc:	6a 00                	push   $0x0
  8032be:	6a 00                	push   $0x0
  8032c0:	6a 00                	push   $0x0
  8032c2:	50                   	push   %eax
  8032c3:	6a 1a                	push   $0x1a
  8032c5:	e8 52 fd ff ff       	call   80301c <syscall>
  8032ca:	83 c4 18             	add    $0x18,%esp
}
  8032cd:	90                   	nop
  8032ce:	c9                   	leave  
  8032cf:	c3                   	ret    

008032d0 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8032d0:	55                   	push   %ebp
  8032d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8032d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d6:	6a 00                	push   $0x0
  8032d8:	6a 00                	push   $0x0
  8032da:	6a 00                	push   $0x0
  8032dc:	6a 00                	push   $0x0
  8032de:	50                   	push   %eax
  8032df:	6a 1b                	push   $0x1b
  8032e1:	e8 36 fd ff ff       	call   80301c <syscall>
  8032e6:	83 c4 18             	add    $0x18,%esp
}
  8032e9:	c9                   	leave  
  8032ea:	c3                   	ret    

008032eb <sys_getenvid>:

int32 sys_getenvid(void)
{
  8032eb:	55                   	push   %ebp
  8032ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8032ee:	6a 00                	push   $0x0
  8032f0:	6a 00                	push   $0x0
  8032f2:	6a 00                	push   $0x0
  8032f4:	6a 00                	push   $0x0
  8032f6:	6a 00                	push   $0x0
  8032f8:	6a 05                	push   $0x5
  8032fa:	e8 1d fd ff ff       	call   80301c <syscall>
  8032ff:	83 c4 18             	add    $0x18,%esp
}
  803302:	c9                   	leave  
  803303:	c3                   	ret    

00803304 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  803304:	55                   	push   %ebp
  803305:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  803307:	6a 00                	push   $0x0
  803309:	6a 00                	push   $0x0
  80330b:	6a 00                	push   $0x0
  80330d:	6a 00                	push   $0x0
  80330f:	6a 00                	push   $0x0
  803311:	6a 06                	push   $0x6
  803313:	e8 04 fd ff ff       	call   80301c <syscall>
  803318:	83 c4 18             	add    $0x18,%esp
}
  80331b:	c9                   	leave  
  80331c:	c3                   	ret    

0080331d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80331d:	55                   	push   %ebp
  80331e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  803320:	6a 00                	push   $0x0
  803322:	6a 00                	push   $0x0
  803324:	6a 00                	push   $0x0
  803326:	6a 00                	push   $0x0
  803328:	6a 00                	push   $0x0
  80332a:	6a 07                	push   $0x7
  80332c:	e8 eb fc ff ff       	call   80301c <syscall>
  803331:	83 c4 18             	add    $0x18,%esp
}
  803334:	c9                   	leave  
  803335:	c3                   	ret    

00803336 <sys_exit_env>:


void sys_exit_env(void)
{
  803336:	55                   	push   %ebp
  803337:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  803339:	6a 00                	push   $0x0
  80333b:	6a 00                	push   $0x0
  80333d:	6a 00                	push   $0x0
  80333f:	6a 00                	push   $0x0
  803341:	6a 00                	push   $0x0
  803343:	6a 1c                	push   $0x1c
  803345:	e8 d2 fc ff ff       	call   80301c <syscall>
  80334a:	83 c4 18             	add    $0x18,%esp
}
  80334d:	90                   	nop
  80334e:	c9                   	leave  
  80334f:	c3                   	ret    

00803350 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  803350:	55                   	push   %ebp
  803351:	89 e5                	mov    %esp,%ebp
  803353:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  803356:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803359:	8d 50 04             	lea    0x4(%eax),%edx
  80335c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80335f:	6a 00                	push   $0x0
  803361:	6a 00                	push   $0x0
  803363:	6a 00                	push   $0x0
  803365:	52                   	push   %edx
  803366:	50                   	push   %eax
  803367:	6a 1d                	push   $0x1d
  803369:	e8 ae fc ff ff       	call   80301c <syscall>
  80336e:	83 c4 18             	add    $0x18,%esp
	return result;
  803371:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803374:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803377:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80337a:	89 01                	mov    %eax,(%ecx)
  80337c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80337f:	8b 45 08             	mov    0x8(%ebp),%eax
  803382:	c9                   	leave  
  803383:	c2 04 00             	ret    $0x4

00803386 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  803386:	55                   	push   %ebp
  803387:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  803389:	6a 00                	push   $0x0
  80338b:	6a 00                	push   $0x0
  80338d:	ff 75 10             	pushl  0x10(%ebp)
  803390:	ff 75 0c             	pushl  0xc(%ebp)
  803393:	ff 75 08             	pushl  0x8(%ebp)
  803396:	6a 13                	push   $0x13
  803398:	e8 7f fc ff ff       	call   80301c <syscall>
  80339d:	83 c4 18             	add    $0x18,%esp
	return ;
  8033a0:	90                   	nop
}
  8033a1:	c9                   	leave  
  8033a2:	c3                   	ret    

008033a3 <sys_rcr2>:
uint32 sys_rcr2()
{
  8033a3:	55                   	push   %ebp
  8033a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8033a6:	6a 00                	push   $0x0
  8033a8:	6a 00                	push   $0x0
  8033aa:	6a 00                	push   $0x0
  8033ac:	6a 00                	push   $0x0
  8033ae:	6a 00                	push   $0x0
  8033b0:	6a 1e                	push   $0x1e
  8033b2:	e8 65 fc ff ff       	call   80301c <syscall>
  8033b7:	83 c4 18             	add    $0x18,%esp
}
  8033ba:	c9                   	leave  
  8033bb:	c3                   	ret    

008033bc <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8033bc:	55                   	push   %ebp
  8033bd:	89 e5                	mov    %esp,%ebp
  8033bf:	83 ec 04             	sub    $0x4,%esp
  8033c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8033c8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8033cc:	6a 00                	push   $0x0
  8033ce:	6a 00                	push   $0x0
  8033d0:	6a 00                	push   $0x0
  8033d2:	6a 00                	push   $0x0
  8033d4:	50                   	push   %eax
  8033d5:	6a 1f                	push   $0x1f
  8033d7:	e8 40 fc ff ff       	call   80301c <syscall>
  8033dc:	83 c4 18             	add    $0x18,%esp
	return ;
  8033df:	90                   	nop
}
  8033e0:	c9                   	leave  
  8033e1:	c3                   	ret    

008033e2 <rsttst>:
void rsttst()
{
  8033e2:	55                   	push   %ebp
  8033e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8033e5:	6a 00                	push   $0x0
  8033e7:	6a 00                	push   $0x0
  8033e9:	6a 00                	push   $0x0
  8033eb:	6a 00                	push   $0x0
  8033ed:	6a 00                	push   $0x0
  8033ef:	6a 21                	push   $0x21
  8033f1:	e8 26 fc ff ff       	call   80301c <syscall>
  8033f6:	83 c4 18             	add    $0x18,%esp
	return ;
  8033f9:	90                   	nop
}
  8033fa:	c9                   	leave  
  8033fb:	c3                   	ret    

008033fc <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8033fc:	55                   	push   %ebp
  8033fd:	89 e5                	mov    %esp,%ebp
  8033ff:	83 ec 04             	sub    $0x4,%esp
  803402:	8b 45 14             	mov    0x14(%ebp),%eax
  803405:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803408:	8b 55 18             	mov    0x18(%ebp),%edx
  80340b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80340f:	52                   	push   %edx
  803410:	50                   	push   %eax
  803411:	ff 75 10             	pushl  0x10(%ebp)
  803414:	ff 75 0c             	pushl  0xc(%ebp)
  803417:	ff 75 08             	pushl  0x8(%ebp)
  80341a:	6a 20                	push   $0x20
  80341c:	e8 fb fb ff ff       	call   80301c <syscall>
  803421:	83 c4 18             	add    $0x18,%esp
	return ;
  803424:	90                   	nop
}
  803425:	c9                   	leave  
  803426:	c3                   	ret    

00803427 <chktst>:
void chktst(uint32 n)
{
  803427:	55                   	push   %ebp
  803428:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80342a:	6a 00                	push   $0x0
  80342c:	6a 00                	push   $0x0
  80342e:	6a 00                	push   $0x0
  803430:	6a 00                	push   $0x0
  803432:	ff 75 08             	pushl  0x8(%ebp)
  803435:	6a 22                	push   $0x22
  803437:	e8 e0 fb ff ff       	call   80301c <syscall>
  80343c:	83 c4 18             	add    $0x18,%esp
	return ;
  80343f:	90                   	nop
}
  803440:	c9                   	leave  
  803441:	c3                   	ret    

00803442 <inctst>:

void inctst()
{
  803442:	55                   	push   %ebp
  803443:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803445:	6a 00                	push   $0x0
  803447:	6a 00                	push   $0x0
  803449:	6a 00                	push   $0x0
  80344b:	6a 00                	push   $0x0
  80344d:	6a 00                	push   $0x0
  80344f:	6a 23                	push   $0x23
  803451:	e8 c6 fb ff ff       	call   80301c <syscall>
  803456:	83 c4 18             	add    $0x18,%esp
	return ;
  803459:	90                   	nop
}
  80345a:	c9                   	leave  
  80345b:	c3                   	ret    

0080345c <gettst>:
uint32 gettst()
{
  80345c:	55                   	push   %ebp
  80345d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80345f:	6a 00                	push   $0x0
  803461:	6a 00                	push   $0x0
  803463:	6a 00                	push   $0x0
  803465:	6a 00                	push   $0x0
  803467:	6a 00                	push   $0x0
  803469:	6a 24                	push   $0x24
  80346b:	e8 ac fb ff ff       	call   80301c <syscall>
  803470:	83 c4 18             	add    $0x18,%esp
}
  803473:	c9                   	leave  
  803474:	c3                   	ret    

00803475 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  803475:	55                   	push   %ebp
  803476:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803478:	6a 00                	push   $0x0
  80347a:	6a 00                	push   $0x0
  80347c:	6a 00                	push   $0x0
  80347e:	6a 00                	push   $0x0
  803480:	6a 00                	push   $0x0
  803482:	6a 25                	push   $0x25
  803484:	e8 93 fb ff ff       	call   80301c <syscall>
  803489:	83 c4 18             	add    $0x18,%esp
  80348c:	a3 80 50 83 00       	mov    %eax,0x835080
	return uheapPlaceStrategy ;
  803491:	a1 80 50 83 00       	mov    0x835080,%eax
}
  803496:	c9                   	leave  
  803497:	c3                   	ret    

00803498 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803498:	55                   	push   %ebp
  803499:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80349b:	8b 45 08             	mov    0x8(%ebp),%eax
  80349e:	a3 80 50 83 00       	mov    %eax,0x835080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8034a3:	6a 00                	push   $0x0
  8034a5:	6a 00                	push   $0x0
  8034a7:	6a 00                	push   $0x0
  8034a9:	6a 00                	push   $0x0
  8034ab:	ff 75 08             	pushl  0x8(%ebp)
  8034ae:	6a 26                	push   $0x26
  8034b0:	e8 67 fb ff ff       	call   80301c <syscall>
  8034b5:	83 c4 18             	add    $0x18,%esp
	return ;
  8034b8:	90                   	nop
}
  8034b9:	c9                   	leave  
  8034ba:	c3                   	ret    

008034bb <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8034bb:	55                   	push   %ebp
  8034bc:	89 e5                	mov    %esp,%ebp
  8034be:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8034bf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8034c2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8034c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034cb:	6a 00                	push   $0x0
  8034cd:	53                   	push   %ebx
  8034ce:	51                   	push   %ecx
  8034cf:	52                   	push   %edx
  8034d0:	50                   	push   %eax
  8034d1:	6a 27                	push   $0x27
  8034d3:	e8 44 fb ff ff       	call   80301c <syscall>
  8034d8:	83 c4 18             	add    $0x18,%esp
}
  8034db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8034de:	c9                   	leave  
  8034df:	c3                   	ret    

008034e0 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8034e0:	55                   	push   %ebp
  8034e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8034e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e9:	6a 00                	push   $0x0
  8034eb:	6a 00                	push   $0x0
  8034ed:	6a 00                	push   $0x0
  8034ef:	52                   	push   %edx
  8034f0:	50                   	push   %eax
  8034f1:	6a 28                	push   $0x28
  8034f3:	e8 24 fb ff ff       	call   80301c <syscall>
  8034f8:	83 c4 18             	add    $0x18,%esp
}
  8034fb:	c9                   	leave  
  8034fc:	c3                   	ret    

008034fd <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8034fd:	55                   	push   %ebp
  8034fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  803500:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803503:	8b 55 0c             	mov    0xc(%ebp),%edx
  803506:	8b 45 08             	mov    0x8(%ebp),%eax
  803509:	6a 00                	push   $0x0
  80350b:	51                   	push   %ecx
  80350c:	ff 75 10             	pushl  0x10(%ebp)
  80350f:	52                   	push   %edx
  803510:	50                   	push   %eax
  803511:	6a 29                	push   $0x29
  803513:	e8 04 fb ff ff       	call   80301c <syscall>
  803518:	83 c4 18             	add    $0x18,%esp
}
  80351b:	c9                   	leave  
  80351c:	c3                   	ret    

0080351d <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80351d:	55                   	push   %ebp
  80351e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803520:	6a 00                	push   $0x0
  803522:	6a 00                	push   $0x0
  803524:	ff 75 10             	pushl  0x10(%ebp)
  803527:	ff 75 0c             	pushl  0xc(%ebp)
  80352a:	ff 75 08             	pushl  0x8(%ebp)
  80352d:	6a 12                	push   $0x12
  80352f:	e8 e8 fa ff ff       	call   80301c <syscall>
  803534:	83 c4 18             	add    $0x18,%esp
	return ;
  803537:	90                   	nop
}
  803538:	c9                   	leave  
  803539:	c3                   	ret    

0080353a <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80353a:	55                   	push   %ebp
  80353b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80353d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803540:	8b 45 08             	mov    0x8(%ebp),%eax
  803543:	6a 00                	push   $0x0
  803545:	6a 00                	push   $0x0
  803547:	6a 00                	push   $0x0
  803549:	52                   	push   %edx
  80354a:	50                   	push   %eax
  80354b:	6a 2a                	push   $0x2a
  80354d:	e8 ca fa ff ff       	call   80301c <syscall>
  803552:	83 c4 18             	add    $0x18,%esp
	return;
  803555:	90                   	nop
}
  803556:	c9                   	leave  
  803557:	c3                   	ret    

00803558 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  803558:	55                   	push   %ebp
  803559:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80355b:	6a 00                	push   $0x0
  80355d:	6a 00                	push   $0x0
  80355f:	6a 00                	push   $0x0
  803561:	6a 00                	push   $0x0
  803563:	6a 00                	push   $0x0
  803565:	6a 2b                	push   $0x2b
  803567:	e8 b0 fa ff ff       	call   80301c <syscall>
  80356c:	83 c4 18             	add    $0x18,%esp
}
  80356f:	c9                   	leave  
  803570:	c3                   	ret    

00803571 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803571:	55                   	push   %ebp
  803572:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  803574:	6a 00                	push   $0x0
  803576:	6a 00                	push   $0x0
  803578:	6a 00                	push   $0x0
  80357a:	ff 75 0c             	pushl  0xc(%ebp)
  80357d:	ff 75 08             	pushl  0x8(%ebp)
  803580:	6a 2d                	push   $0x2d
  803582:	e8 95 fa ff ff       	call   80301c <syscall>
  803587:	83 c4 18             	add    $0x18,%esp
	return;
  80358a:	90                   	nop
}
  80358b:	c9                   	leave  
  80358c:	c3                   	ret    

0080358d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80358d:	55                   	push   %ebp
  80358e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  803590:	6a 00                	push   $0x0
  803592:	6a 00                	push   $0x0
  803594:	6a 00                	push   $0x0
  803596:	ff 75 0c             	pushl  0xc(%ebp)
  803599:	ff 75 08             	pushl  0x8(%ebp)
  80359c:	6a 2c                	push   $0x2c
  80359e:	e8 79 fa ff ff       	call   80301c <syscall>
  8035a3:	83 c4 18             	add    $0x18,%esp
	return ;
  8035a6:	90                   	nop
}
  8035a7:	c9                   	leave  
  8035a8:	c3                   	ret    

008035a9 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8035a9:	55                   	push   %ebp
  8035aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8035ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035af:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b2:	6a 00                	push   $0x0
  8035b4:	6a 00                	push   $0x0
  8035b6:	6a 00                	push   $0x0
  8035b8:	52                   	push   %edx
  8035b9:	50                   	push   %eax
  8035ba:	6a 2e                	push   $0x2e
  8035bc:	e8 5b fa ff ff       	call   80301c <syscall>
  8035c1:	83 c4 18             	add    $0x18,%esp
}
  8035c4:	90                   	nop
  8035c5:	c9                   	leave  
  8035c6:	c3                   	ret    

008035c7 <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8035c7:	55                   	push   %ebp
  8035c8:	89 e5                	mov    %esp,%ebp
  8035ca:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  8035cd:	81 7d 08 80 d0 81 00 	cmpl   $0x81d080,0x8(%ebp)
  8035d4:	72 09                	jb     8035df <to_page_va+0x18>
  8035d6:	81 7d 08 80 50 83 00 	cmpl   $0x835080,0x8(%ebp)
  8035dd:	72 14                	jb     8035f3 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  8035df:	83 ec 04             	sub    $0x4,%esp
  8035e2:	68 b8 4b 80 00       	push   $0x804bb8
  8035e7:	6a 15                	push   $0x15
  8035e9:	68 e3 4b 80 00       	push   $0x804be3
  8035ee:	e8 10 d0 ff ff       	call   800603 <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8035f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f6:	ba 80 d0 81 00       	mov    $0x81d080,%edx
  8035fb:	29 d0                	sub    %edx,%eax
  8035fd:	c1 f8 02             	sar    $0x2,%eax
  803600:	89 c2                	mov    %eax,%edx
  803602:	89 d0                	mov    %edx,%eax
  803604:	c1 e0 02             	shl    $0x2,%eax
  803607:	01 d0                	add    %edx,%eax
  803609:	c1 e0 02             	shl    $0x2,%eax
  80360c:	01 d0                	add    %edx,%eax
  80360e:	c1 e0 02             	shl    $0x2,%eax
  803611:	01 d0                	add    %edx,%eax
  803613:	89 c1                	mov    %eax,%ecx
  803615:	c1 e1 08             	shl    $0x8,%ecx
  803618:	01 c8                	add    %ecx,%eax
  80361a:	89 c1                	mov    %eax,%ecx
  80361c:	c1 e1 10             	shl    $0x10,%ecx
  80361f:	01 c8                	add    %ecx,%eax
  803621:	01 c0                	add    %eax,%eax
  803623:	01 d0                	add    %edx,%eax
  803625:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  803628:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80362b:	c1 e0 0c             	shl    $0xc,%eax
  80362e:	89 c2                	mov    %eax,%edx
  803630:	a1 84 50 83 00       	mov    0x835084,%eax
  803635:	01 d0                	add    %edx,%eax
}
  803637:	c9                   	leave  
  803638:	c3                   	ret    

00803639 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  803639:	55                   	push   %ebp
  80363a:	89 e5                	mov    %esp,%ebp
  80363c:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  80363f:	a1 84 50 83 00       	mov    0x835084,%eax
  803644:	8b 55 08             	mov    0x8(%ebp),%edx
  803647:	29 c2                	sub    %eax,%edx
  803649:	89 d0                	mov    %edx,%eax
  80364b:	c1 e8 0c             	shr    $0xc,%eax
  80364e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  803651:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803655:	78 09                	js     803660 <to_page_info+0x27>
  803657:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  80365e:	7e 14                	jle    803674 <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  803660:	83 ec 04             	sub    $0x4,%esp
  803663:	68 fc 4b 80 00       	push   $0x804bfc
  803668:	6a 21                	push   $0x21
  80366a:	68 e3 4b 80 00       	push   $0x804be3
  80366f:	e8 8f cf ff ff       	call   800603 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  803674:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803677:	89 d0                	mov    %edx,%eax
  803679:	01 c0                	add    %eax,%eax
  80367b:	01 d0                	add    %edx,%eax
  80367d:	c1 e0 02             	shl    $0x2,%eax
  803680:	05 80 d0 81 00       	add    $0x81d080,%eax
}
  803685:	c9                   	leave  
  803686:	c3                   	ret    

00803687 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803687:	55                   	push   %ebp
  803688:	89 e5                	mov    %esp,%ebp
  80368a:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  80368d:	8b 45 08             	mov    0x8(%ebp),%eax
  803690:	05 00 00 00 02       	add    $0x2000000,%eax
  803695:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803698:	73 16                	jae    8036b0 <initialize_dynamic_allocator+0x29>
  80369a:	68 20 4c 80 00       	push   $0x804c20
  80369f:	68 46 4c 80 00       	push   $0x804c46
  8036a4:	6a 2f                	push   $0x2f
  8036a6:	68 e3 4b 80 00       	push   $0x804be3
  8036ab:	e8 53 cf ff ff       	call   800603 <_panic>
	dynAllocStart = daStart;
  8036b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b3:	a3 84 50 83 00       	mov    %eax,0x835084
	dynAllocEnd = daEnd;
  8036b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036bb:	a3 60 d0 81 00       	mov    %eax,0x81d060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8036c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8036c7:	eb 36                	jmp    8036ff <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  8036c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036cc:	c1 e0 04             	shl    $0x4,%eax
  8036cf:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8036d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036dd:	c1 e0 04             	shl    $0x4,%eax
  8036e0:	05 a4 50 83 00       	add    $0x8350a4,%eax
  8036e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ee:	c1 e0 04             	shl    $0x4,%eax
  8036f1:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8036f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8036fc:	ff 45 f4             	incl   -0xc(%ebp)
  8036ff:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  803703:	7e c4                	jle    8036c9 <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  803705:	c7 05 68 d0 81 00 00 	movl   $0x0,0x81d068
  80370c:	00 00 00 
  80370f:	c7 05 6c d0 81 00 00 	movl   $0x0,0x81d06c
  803716:	00 00 00 
  803719:	c7 05 74 d0 81 00 00 	movl   $0x0,0x81d074
  803720:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803723:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80372a:	e9 1b 01 00 00       	jmp    80384a <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  80372f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803732:	89 d0                	mov    %edx,%eax
  803734:	01 c0                	add    %eax,%eax
  803736:	01 d0                	add    %edx,%eax
  803738:	c1 e0 02             	shl    $0x2,%eax
  80373b:	05 88 d0 81 00       	add    $0x81d088,%eax
  803740:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  803745:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803748:	89 d0                	mov    %edx,%eax
  80374a:	01 c0                	add    %eax,%eax
  80374c:	01 d0                	add    %edx,%eax
  80374e:	c1 e0 02             	shl    $0x2,%eax
  803751:	05 8a d0 81 00       	add    $0x81d08a,%eax
  803756:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  80375b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80375e:	89 d0                	mov    %edx,%eax
  803760:	01 c0                	add    %eax,%eax
  803762:	01 d0                	add    %edx,%eax
  803764:	c1 e0 02             	shl    $0x2,%eax
  803767:	05 80 d0 81 00       	add    $0x81d080,%eax
  80376c:	8b 00                	mov    (%eax),%eax
  80376e:	85 c0                	test   %eax,%eax
  803770:	74 2b                	je     80379d <initialize_dynamic_allocator+0x116>
  803772:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803775:	89 d0                	mov    %edx,%eax
  803777:	01 c0                	add    %eax,%eax
  803779:	01 d0                	add    %edx,%eax
  80377b:	c1 e0 02             	shl    $0x2,%eax
  80377e:	05 80 d0 81 00       	add    $0x81d080,%eax
  803783:	8b 10                	mov    (%eax),%edx
  803785:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803788:	89 c8                	mov    %ecx,%eax
  80378a:	01 c0                	add    %eax,%eax
  80378c:	01 c8                	add    %ecx,%eax
  80378e:	c1 e0 02             	shl    $0x2,%eax
  803791:	05 84 d0 81 00       	add    $0x81d084,%eax
  803796:	8b 00                	mov    (%eax),%eax
  803798:	89 42 04             	mov    %eax,0x4(%edx)
  80379b:	eb 18                	jmp    8037b5 <initialize_dynamic_allocator+0x12e>
  80379d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037a0:	89 d0                	mov    %edx,%eax
  8037a2:	01 c0                	add    %eax,%eax
  8037a4:	01 d0                	add    %edx,%eax
  8037a6:	c1 e0 02             	shl    $0x2,%eax
  8037a9:	05 84 d0 81 00       	add    $0x81d084,%eax
  8037ae:	8b 00                	mov    (%eax),%eax
  8037b0:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  8037b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037b8:	89 d0                	mov    %edx,%eax
  8037ba:	01 c0                	add    %eax,%eax
  8037bc:	01 d0                	add    %edx,%eax
  8037be:	c1 e0 02             	shl    $0x2,%eax
  8037c1:	05 84 d0 81 00       	add    $0x81d084,%eax
  8037c6:	8b 00                	mov    (%eax),%eax
  8037c8:	85 c0                	test   %eax,%eax
  8037ca:	74 2a                	je     8037f6 <initialize_dynamic_allocator+0x16f>
  8037cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037cf:	89 d0                	mov    %edx,%eax
  8037d1:	01 c0                	add    %eax,%eax
  8037d3:	01 d0                	add    %edx,%eax
  8037d5:	c1 e0 02             	shl    $0x2,%eax
  8037d8:	05 84 d0 81 00       	add    $0x81d084,%eax
  8037dd:	8b 10                	mov    (%eax),%edx
  8037df:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8037e2:	89 c8                	mov    %ecx,%eax
  8037e4:	01 c0                	add    %eax,%eax
  8037e6:	01 c8                	add    %ecx,%eax
  8037e8:	c1 e0 02             	shl    $0x2,%eax
  8037eb:	05 80 d0 81 00       	add    $0x81d080,%eax
  8037f0:	8b 00                	mov    (%eax),%eax
  8037f2:	89 02                	mov    %eax,(%edx)
  8037f4:	eb 18                	jmp    80380e <initialize_dynamic_allocator+0x187>
  8037f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037f9:	89 d0                	mov    %edx,%eax
  8037fb:	01 c0                	add    %eax,%eax
  8037fd:	01 d0                	add    %edx,%eax
  8037ff:	c1 e0 02             	shl    $0x2,%eax
  803802:	05 80 d0 81 00       	add    $0x81d080,%eax
  803807:	8b 00                	mov    (%eax),%eax
  803809:	a3 68 d0 81 00       	mov    %eax,0x81d068
  80380e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803811:	89 d0                	mov    %edx,%eax
  803813:	01 c0                	add    %eax,%eax
  803815:	01 d0                	add    %edx,%eax
  803817:	c1 e0 02             	shl    $0x2,%eax
  80381a:	05 80 d0 81 00       	add    $0x81d080,%eax
  80381f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803825:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803828:	89 d0                	mov    %edx,%eax
  80382a:	01 c0                	add    %eax,%eax
  80382c:	01 d0                	add    %edx,%eax
  80382e:	c1 e0 02             	shl    $0x2,%eax
  803831:	05 84 d0 81 00       	add    $0x81d084,%eax
  803836:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80383c:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803841:	48                   	dec    %eax
  803842:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803847:	ff 45 f0             	incl   -0x10(%ebp)
  80384a:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  803851:	0f 8e d8 fe ff ff    	jle    80372f <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803857:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  80385e:	e9 9d 00 00 00       	jmp    803900 <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  803863:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803869:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  80386c:	89 c8                	mov    %ecx,%eax
  80386e:	01 c0                	add    %eax,%eax
  803870:	01 c8                	add    %ecx,%eax
  803872:	c1 e0 02             	shl    $0x2,%eax
  803875:	05 80 d0 81 00       	add    $0x81d080,%eax
  80387a:	89 10                	mov    %edx,(%eax)
  80387c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80387f:	89 d0                	mov    %edx,%eax
  803881:	01 c0                	add    %eax,%eax
  803883:	01 d0                	add    %edx,%eax
  803885:	c1 e0 02             	shl    $0x2,%eax
  803888:	05 80 d0 81 00       	add    $0x81d080,%eax
  80388d:	8b 00                	mov    (%eax),%eax
  80388f:	85 c0                	test   %eax,%eax
  803891:	74 1c                	je     8038af <initialize_dynamic_allocator+0x228>
  803893:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803899:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  80389c:	89 c8                	mov    %ecx,%eax
  80389e:	01 c0                	add    %eax,%eax
  8038a0:	01 c8                	add    %ecx,%eax
  8038a2:	c1 e0 02             	shl    $0x2,%eax
  8038a5:	05 80 d0 81 00       	add    $0x81d080,%eax
  8038aa:	89 42 04             	mov    %eax,0x4(%edx)
  8038ad:	eb 16                	jmp    8038c5 <initialize_dynamic_allocator+0x23e>
  8038af:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038b2:	89 d0                	mov    %edx,%eax
  8038b4:	01 c0                	add    %eax,%eax
  8038b6:	01 d0                	add    %edx,%eax
  8038b8:	c1 e0 02             	shl    $0x2,%eax
  8038bb:	05 80 d0 81 00       	add    $0x81d080,%eax
  8038c0:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  8038c5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038c8:	89 d0                	mov    %edx,%eax
  8038ca:	01 c0                	add    %eax,%eax
  8038cc:	01 d0                	add    %edx,%eax
  8038ce:	c1 e0 02             	shl    $0x2,%eax
  8038d1:	05 80 d0 81 00       	add    $0x81d080,%eax
  8038d6:	a3 68 d0 81 00       	mov    %eax,0x81d068
  8038db:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038de:	89 d0                	mov    %edx,%eax
  8038e0:	01 c0                	add    %eax,%eax
  8038e2:	01 d0                	add    %edx,%eax
  8038e4:	c1 e0 02             	shl    $0x2,%eax
  8038e7:	05 84 d0 81 00       	add    $0x81d084,%eax
  8038ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038f2:	a1 74 d0 81 00       	mov    0x81d074,%eax
  8038f7:	40                   	inc    %eax
  8038f8:	a3 74 d0 81 00       	mov    %eax,0x81d074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  8038fd:	ff 4d ec             	decl   -0x14(%ebp)
  803900:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803904:	0f 89 59 ff ff ff    	jns    803863 <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  80390a:	c7 05 44 d0 81 00 01 	movl   $0x1,0x81d044
  803911:	00 00 00 
}
  803914:	90                   	nop
  803915:	c9                   	leave  
  803916:	c3                   	ret    

00803917 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  803917:	55                   	push   %ebp
  803918:	89 e5                	mov    %esp,%ebp
  80391a:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  80391d:	8b 45 08             	mov    0x8(%ebp),%eax
  803920:	83 ec 0c             	sub    $0xc,%esp
  803923:	50                   	push   %eax
  803924:	e8 10 fd ff ff       	call   803639 <to_page_info>
  803929:	83 c4 10             	add    $0x10,%esp
  80392c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  80392f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803932:	8b 40 08             	mov    0x8(%eax),%eax
  803935:	0f b7 c0             	movzwl %ax,%eax
}
  803938:	c9                   	leave  
  803939:	c3                   	ret    

0080393a <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  80393a:	55                   	push   %ebp
  80393b:	89 e5                	mov    %esp,%ebp
  80393d:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803940:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803947:	76 16                	jbe    80395f <alloc_block+0x25>
  803949:	68 5c 4c 80 00       	push   $0x804c5c
  80394e:	68 46 4c 80 00       	push   $0x804c46
  803953:	6a 59                	push   $0x59
  803955:	68 e3 4b 80 00       	push   $0x804be3
  80395a:	e8 a4 cc ff ff       	call   800603 <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  80395f:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803966:	eb 08                	jmp    803970 <alloc_block+0x36>
		allocSize <<= 1;
  803968:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80396b:	01 c0                	add    %eax,%eax
  80396d:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803973:	3b 45 08             	cmp    0x8(%ebp),%eax
  803976:	73 09                	jae    803981 <alloc_block+0x47>
  803978:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  80397f:	76 e7                	jbe    803968 <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  803981:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803988:	eb 03                	jmp    80398d <alloc_block+0x53>
		listIndex++;
  80398a:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  80398d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803990:	ba 08 00 00 00       	mov    $0x8,%edx
  803995:	88 c1                	mov    %al,%cl
  803997:	d3 e2                	shl    %cl,%edx
  803999:	89 d0                	mov    %edx,%eax
  80399b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80399e:	72 ea                	jb     80398a <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8039a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8039a6:	e9 f4 00 00 00       	jmp    803a9f <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  8039ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039ae:	c1 e0 04             	shl    $0x4,%eax
  8039b1:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8039b6:	8b 00                	mov    (%eax),%eax
  8039b8:	85 c0                	test   %eax,%eax
  8039ba:	0f 84 dc 00 00 00    	je     803a9c <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  8039c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039c3:	c1 e0 04             	shl    $0x4,%eax
  8039c6:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8039cb:	8b 00                	mov    (%eax),%eax
  8039cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  8039d0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8039d4:	75 14                	jne    8039ea <alloc_block+0xb0>
  8039d6:	83 ec 04             	sub    $0x4,%esp
  8039d9:	68 7d 4c 80 00       	push   $0x804c7d
  8039de:	6a 6b                	push   $0x6b
  8039e0:	68 e3 4b 80 00       	push   $0x804be3
  8039e5:	e8 19 cc ff ff       	call   800603 <_panic>
  8039ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039ed:	8b 00                	mov    (%eax),%eax
  8039ef:	85 c0                	test   %eax,%eax
  8039f1:	74 10                	je     803a03 <alloc_block+0xc9>
  8039f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039f6:	8b 00                	mov    (%eax),%eax
  8039f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039fb:	8b 52 04             	mov    0x4(%edx),%edx
  8039fe:	89 50 04             	mov    %edx,0x4(%eax)
  803a01:	eb 14                	jmp    803a17 <alloc_block+0xdd>
  803a03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a06:	8b 40 04             	mov    0x4(%eax),%eax
  803a09:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a0c:	c1 e2 04             	shl    $0x4,%edx
  803a0f:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803a15:	89 02                	mov    %eax,(%edx)
  803a17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a1a:	8b 40 04             	mov    0x4(%eax),%eax
  803a1d:	85 c0                	test   %eax,%eax
  803a1f:	74 0f                	je     803a30 <alloc_block+0xf6>
  803a21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a24:	8b 40 04             	mov    0x4(%eax),%eax
  803a27:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a2a:	8b 12                	mov    (%edx),%edx
  803a2c:	89 10                	mov    %edx,(%eax)
  803a2e:	eb 13                	jmp    803a43 <alloc_block+0x109>
  803a30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a33:	8b 00                	mov    (%eax),%eax
  803a35:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a38:	c1 e2 04             	shl    $0x4,%edx
  803a3b:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803a41:	89 02                	mov    %eax,(%edx)
  803a43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a46:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a4f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a59:	c1 e0 04             	shl    $0x4,%eax
  803a5c:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803a61:	8b 00                	mov    (%eax),%eax
  803a63:	8d 50 ff             	lea    -0x1(%eax),%edx
  803a66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a69:	c1 e0 04             	shl    $0x4,%eax
  803a6c:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803a71:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  803a73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a76:	83 ec 0c             	sub    $0xc,%esp
  803a79:	50                   	push   %eax
  803a7a:	e8 ba fb ff ff       	call   803639 <to_page_info>
  803a7f:	83 c4 10             	add    $0x10,%esp
  803a82:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  803a85:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a88:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803a8c:	48                   	dec    %eax
  803a8d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803a90:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  803a94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a97:	e9 8f 02 00 00       	jmp    803d2b <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803a9c:	ff 45 ec             	incl   -0x14(%ebp)
  803a9f:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803aa3:	0f 8e 02 ff ff ff    	jle    8039ab <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  803aa9:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803aae:	85 c0                	test   %eax,%eax
  803ab0:	75 14                	jne    803ac6 <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  803ab2:	83 ec 04             	sub    $0x4,%esp
  803ab5:	68 9c 4c 80 00       	push   $0x804c9c
  803aba:	6a 77                	push   $0x77
  803abc:	68 e3 4b 80 00       	push   $0x804be3
  803ac1:	e8 3d cb ff ff       	call   800603 <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  803ac6:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803acb:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  803ace:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803ad2:	75 14                	jne    803ae8 <alloc_block+0x1ae>
  803ad4:	83 ec 04             	sub    $0x4,%esp
  803ad7:	68 7d 4c 80 00       	push   $0x804c7d
  803adc:	6a 7a                	push   $0x7a
  803ade:	68 e3 4b 80 00       	push   $0x804be3
  803ae3:	e8 1b cb ff ff       	call   800603 <_panic>
  803ae8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803aeb:	8b 00                	mov    (%eax),%eax
  803aed:	85 c0                	test   %eax,%eax
  803aef:	74 10                	je     803b01 <alloc_block+0x1c7>
  803af1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803af4:	8b 00                	mov    (%eax),%eax
  803af6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803af9:	8b 52 04             	mov    0x4(%edx),%edx
  803afc:	89 50 04             	mov    %edx,0x4(%eax)
  803aff:	eb 0b                	jmp    803b0c <alloc_block+0x1d2>
  803b01:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b04:	8b 40 04             	mov    0x4(%eax),%eax
  803b07:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803b0c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b0f:	8b 40 04             	mov    0x4(%eax),%eax
  803b12:	85 c0                	test   %eax,%eax
  803b14:	74 0f                	je     803b25 <alloc_block+0x1eb>
  803b16:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b19:	8b 40 04             	mov    0x4(%eax),%eax
  803b1c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803b1f:	8b 12                	mov    (%edx),%edx
  803b21:	89 10                	mov    %edx,(%eax)
  803b23:	eb 0a                	jmp    803b2f <alloc_block+0x1f5>
  803b25:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b28:	8b 00                	mov    (%eax),%eax
  803b2a:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803b2f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b38:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b3b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b42:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803b47:	48                   	dec    %eax
  803b48:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  803b4d:	83 ec 0c             	sub    $0xc,%esp
  803b50:	ff 75 dc             	pushl  -0x24(%ebp)
  803b53:	e8 6f fa ff ff       	call   8035c7 <to_page_va>
  803b58:	83 c4 10             	add    $0x10,%esp
  803b5b:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  803b5e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803b61:	83 ec 0c             	sub    $0xc,%esp
  803b64:	50                   	push   %eax
  803b65:	e8 a0 dc ff ff       	call   80180a <get_page>
  803b6a:	83 c4 10             	add    $0x10,%esp
  803b6d:	85 c0                	test   %eax,%eax
  803b6f:	74 14                	je     803b85 <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  803b71:	83 ec 04             	sub    $0x4,%esp
  803b74:	68 c4 4c 80 00       	push   $0x804cc4
  803b79:	6a 7f                	push   $0x7f
  803b7b:	68 e3 4b 80 00       	push   $0x804be3
  803b80:	e8 7e ca ff ff       	call   800603 <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  803b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b88:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803b8b:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  803b8f:	b8 00 10 00 00       	mov    $0x1000,%eax
  803b94:	ba 00 00 00 00       	mov    $0x0,%edx
  803b99:	f7 75 f4             	divl   -0xc(%ebp)
  803b9c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803b9f:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803ba3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803baa:	e9 a7 00 00 00       	jmp    803c56 <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  803baf:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803bb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bb5:	01 d0                	add    %edx,%eax
  803bb7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  803bba:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803bbe:	75 17                	jne    803bd7 <alloc_block+0x29d>
  803bc0:	83 ec 04             	sub    $0x4,%esp
  803bc3:	68 ec 4c 80 00       	push   $0x804cec
  803bc8:	68 88 00 00 00       	push   $0x88
  803bcd:	68 e3 4b 80 00       	push   $0x804be3
  803bd2:	e8 2c ca ff ff       	call   800603 <_panic>
  803bd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bda:	c1 e0 04             	shl    $0x4,%eax
  803bdd:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803be2:	8b 10                	mov    (%eax),%edx
  803be4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803be7:	89 10                	mov    %edx,(%eax)
  803be9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bec:	8b 00                	mov    (%eax),%eax
  803bee:	85 c0                	test   %eax,%eax
  803bf0:	74 15                	je     803c07 <alloc_block+0x2cd>
  803bf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bf5:	c1 e0 04             	shl    $0x4,%eax
  803bf8:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803bfd:	8b 00                	mov    (%eax),%eax
  803bff:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c02:	89 50 04             	mov    %edx,0x4(%eax)
  803c05:	eb 11                	jmp    803c18 <alloc_block+0x2de>
  803c07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c0a:	c1 e0 04             	shl    $0x4,%eax
  803c0d:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803c13:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c16:	89 02                	mov    %eax,(%edx)
  803c18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c1b:	c1 e0 04             	shl    $0x4,%eax
  803c1e:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803c24:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c27:	89 02                	mov    %eax,(%edx)
  803c29:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c2c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c36:	c1 e0 04             	shl    $0x4,%eax
  803c39:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803c3e:	8b 00                	mov    (%eax),%eax
  803c40:	8d 50 01             	lea    0x1(%eax),%edx
  803c43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c46:	c1 e0 04             	shl    $0x4,%eax
  803c49:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803c4e:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c53:	01 45 e8             	add    %eax,-0x18(%ebp)
  803c56:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  803c5d:	0f 86 4c ff ff ff    	jbe    803baf <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  803c63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c66:	c1 e0 04             	shl    $0x4,%eax
  803c69:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803c6e:	8b 00                	mov    (%eax),%eax
  803c70:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  803c73:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803c77:	75 17                	jne    803c90 <alloc_block+0x356>
  803c79:	83 ec 04             	sub    $0x4,%esp
  803c7c:	68 7d 4c 80 00       	push   $0x804c7d
  803c81:	68 8d 00 00 00       	push   $0x8d
  803c86:	68 e3 4b 80 00       	push   $0x804be3
  803c8b:	e8 73 c9 ff ff       	call   800603 <_panic>
  803c90:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803c93:	8b 00                	mov    (%eax),%eax
  803c95:	85 c0                	test   %eax,%eax
  803c97:	74 10                	je     803ca9 <alloc_block+0x36f>
  803c99:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803c9c:	8b 00                	mov    (%eax),%eax
  803c9e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803ca1:	8b 52 04             	mov    0x4(%edx),%edx
  803ca4:	89 50 04             	mov    %edx,0x4(%eax)
  803ca7:	eb 14                	jmp    803cbd <alloc_block+0x383>
  803ca9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803cac:	8b 40 04             	mov    0x4(%eax),%eax
  803caf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803cb2:	c1 e2 04             	shl    $0x4,%edx
  803cb5:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803cbb:	89 02                	mov    %eax,(%edx)
  803cbd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803cc0:	8b 40 04             	mov    0x4(%eax),%eax
  803cc3:	85 c0                	test   %eax,%eax
  803cc5:	74 0f                	je     803cd6 <alloc_block+0x39c>
  803cc7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803cca:	8b 40 04             	mov    0x4(%eax),%eax
  803ccd:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803cd0:	8b 12                	mov    (%edx),%edx
  803cd2:	89 10                	mov    %edx,(%eax)
  803cd4:	eb 13                	jmp    803ce9 <alloc_block+0x3af>
  803cd6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803cd9:	8b 00                	mov    (%eax),%eax
  803cdb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803cde:	c1 e2 04             	shl    $0x4,%edx
  803ce1:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803ce7:	89 02                	mov    %eax,(%edx)
  803ce9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803cec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803cf2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803cf5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cff:	c1 e0 04             	shl    $0x4,%eax
  803d02:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803d07:	8b 00                	mov    (%eax),%eax
  803d09:	8d 50 ff             	lea    -0x1(%eax),%edx
  803d0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d0f:	c1 e0 04             	shl    $0x4,%eax
  803d12:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803d17:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  803d19:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d1c:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803d20:	48                   	dec    %eax
  803d21:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803d24:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  803d28:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  803d2b:	c9                   	leave  
  803d2c:	c3                   	ret    

00803d2d <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803d2d:	55                   	push   %ebp
  803d2e:	89 e5                	mov    %esp,%ebp
  803d30:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803d33:	8b 55 08             	mov    0x8(%ebp),%edx
  803d36:	a1 84 50 83 00       	mov    0x835084,%eax
  803d3b:	39 c2                	cmp    %eax,%edx
  803d3d:	72 0c                	jb     803d4b <free_block+0x1e>
  803d3f:	8b 55 08             	mov    0x8(%ebp),%edx
  803d42:	a1 60 d0 81 00       	mov    0x81d060,%eax
  803d47:	39 c2                	cmp    %eax,%edx
  803d49:	72 19                	jb     803d64 <free_block+0x37>
  803d4b:	68 10 4d 80 00       	push   $0x804d10
  803d50:	68 46 4c 80 00       	push   $0x804c46
  803d55:	68 98 00 00 00       	push   $0x98
  803d5a:	68 e3 4b 80 00       	push   $0x804be3
  803d5f:	e8 9f c8 ff ff       	call   800603 <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803d64:	8b 45 08             	mov    0x8(%ebp),%eax
  803d67:	83 ec 0c             	sub    $0xc,%esp
  803d6a:	50                   	push   %eax
  803d6b:	e8 c9 f8 ff ff       	call   803639 <to_page_info>
  803d70:	83 c4 10             	add    $0x10,%esp
  803d73:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  803d76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d79:	8b 40 08             	mov    0x8(%eax),%eax
  803d7c:	0f b7 c0             	movzwl %ax,%eax
  803d7f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  803d82:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803d89:	eb 03                	jmp    803d8e <free_block+0x61>
		listIndex++;
  803d8b:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d91:	ba 08 00 00 00       	mov    $0x8,%edx
  803d96:	88 c1                	mov    %al,%cl
  803d98:	d3 e2                	shl    %cl,%edx
  803d9a:	89 d0                	mov    %edx,%eax
  803d9c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803d9f:	72 ea                	jb     803d8b <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  803da1:	8b 45 08             	mov    0x8(%ebp),%eax
  803da4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  803da7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803dab:	75 17                	jne    803dc4 <free_block+0x97>
  803dad:	83 ec 04             	sub    $0x4,%esp
  803db0:	68 ec 4c 80 00       	push   $0x804cec
  803db5:	68 a2 00 00 00       	push   $0xa2
  803dba:	68 e3 4b 80 00       	push   $0x804be3
  803dbf:	e8 3f c8 ff ff       	call   800603 <_panic>
  803dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dc7:	c1 e0 04             	shl    $0x4,%eax
  803dca:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803dcf:	8b 10                	mov    (%eax),%edx
  803dd1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dd4:	89 10                	mov    %edx,(%eax)
  803dd6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dd9:	8b 00                	mov    (%eax),%eax
  803ddb:	85 c0                	test   %eax,%eax
  803ddd:	74 15                	je     803df4 <free_block+0xc7>
  803ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803de2:	c1 e0 04             	shl    $0x4,%eax
  803de5:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803dea:	8b 00                	mov    (%eax),%eax
  803dec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803def:	89 50 04             	mov    %edx,0x4(%eax)
  803df2:	eb 11                	jmp    803e05 <free_block+0xd8>
  803df4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803df7:	c1 e0 04             	shl    $0x4,%eax
  803dfa:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803e00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e03:	89 02                	mov    %eax,(%edx)
  803e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e08:	c1 e0 04             	shl    $0x4,%eax
  803e0b:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803e11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e14:	89 02                	mov    %eax,(%edx)
  803e16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e19:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e23:	c1 e0 04             	shl    $0x4,%eax
  803e26:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803e2b:	8b 00                	mov    (%eax),%eax
  803e2d:	8d 50 01             	lea    0x1(%eax),%edx
  803e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e33:	c1 e0 04             	shl    $0x4,%eax
  803e36:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803e3b:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  803e3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e40:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803e44:	40                   	inc    %eax
  803e45:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e48:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  803e4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e4f:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803e53:	0f b7 c8             	movzwl %ax,%ecx
  803e56:	b8 00 10 00 00       	mov    $0x1000,%eax
  803e5b:	ba 00 00 00 00       	mov    $0x0,%edx
  803e60:	f7 75 e8             	divl   -0x18(%ebp)
  803e63:	39 c1                	cmp    %eax,%ecx
  803e65:	0f 85 ed 01 00 00    	jne    804058 <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e6e:	c1 e0 04             	shl    $0x4,%eax
  803e71:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803e76:	8b 00                	mov    (%eax),%eax
  803e78:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803e7b:	eb 2a                	jmp    803ea7 <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  803e7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e80:	83 ec 0c             	sub    $0xc,%esp
  803e83:	50                   	push   %eax
  803e84:	e8 b0 f7 ff ff       	call   803639 <to_page_info>
  803e89:	83 c4 10             	add    $0x10,%esp
  803e8c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803e8f:	75 06                	jne    803e97 <free_block+0x16a>
				tmp = b;
  803e91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e94:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803e97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e9a:	c1 e0 04             	shl    $0x4,%eax
  803e9d:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803ea2:	8b 00                	mov    (%eax),%eax
  803ea4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803ea7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803eab:	74 07                	je     803eb4 <free_block+0x187>
  803ead:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803eb0:	8b 00                	mov    (%eax),%eax
  803eb2:	eb 05                	jmp    803eb9 <free_block+0x18c>
  803eb4:	b8 00 00 00 00       	mov    $0x0,%eax
  803eb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ebc:	c1 e2 04             	shl    $0x4,%edx
  803ebf:	81 c2 a8 50 83 00    	add    $0x8350a8,%edx
  803ec5:	89 02                	mov    %eax,(%edx)
  803ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eca:	c1 e0 04             	shl    $0x4,%eax
  803ecd:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803ed2:	8b 00                	mov    (%eax),%eax
  803ed4:	85 c0                	test   %eax,%eax
  803ed6:	75 a5                	jne    803e7d <free_block+0x150>
  803ed8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803edc:	75 9f                	jne    803e7d <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  803ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ee1:	c1 e0 04             	shl    $0x4,%eax
  803ee4:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803ee9:	8b 00                	mov    (%eax),%eax
  803eeb:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  803eee:	e9 cc 00 00 00       	jmp    803fbf <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  803ef3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ef6:	8b 00                	mov    (%eax),%eax
  803ef8:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  803efb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803efe:	83 ec 0c             	sub    $0xc,%esp
  803f01:	50                   	push   %eax
  803f02:	e8 32 f7 ff ff       	call   803639 <to_page_info>
  803f07:	83 c4 10             	add    $0x10,%esp
  803f0a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803f0d:	0f 85 a6 00 00 00    	jne    803fb9 <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  803f13:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803f17:	75 17                	jne    803f30 <free_block+0x203>
  803f19:	83 ec 04             	sub    $0x4,%esp
  803f1c:	68 7d 4c 80 00       	push   $0x804c7d
  803f21:	68 b5 00 00 00       	push   $0xb5
  803f26:	68 e3 4b 80 00       	push   $0x804be3
  803f2b:	e8 d3 c6 ff ff       	call   800603 <_panic>
  803f30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f33:	8b 00                	mov    (%eax),%eax
  803f35:	85 c0                	test   %eax,%eax
  803f37:	74 10                	je     803f49 <free_block+0x21c>
  803f39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f3c:	8b 00                	mov    (%eax),%eax
  803f3e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803f41:	8b 52 04             	mov    0x4(%edx),%edx
  803f44:	89 50 04             	mov    %edx,0x4(%eax)
  803f47:	eb 14                	jmp    803f5d <free_block+0x230>
  803f49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f4c:	8b 40 04             	mov    0x4(%eax),%eax
  803f4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803f52:	c1 e2 04             	shl    $0x4,%edx
  803f55:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803f5b:	89 02                	mov    %eax,(%edx)
  803f5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f60:	8b 40 04             	mov    0x4(%eax),%eax
  803f63:	85 c0                	test   %eax,%eax
  803f65:	74 0f                	je     803f76 <free_block+0x249>
  803f67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f6a:	8b 40 04             	mov    0x4(%eax),%eax
  803f6d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803f70:	8b 12                	mov    (%edx),%edx
  803f72:	89 10                	mov    %edx,(%eax)
  803f74:	eb 13                	jmp    803f89 <free_block+0x25c>
  803f76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f79:	8b 00                	mov    (%eax),%eax
  803f7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803f7e:	c1 e2 04             	shl    $0x4,%edx
  803f81:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803f87:	89 02                	mov    %eax,(%edx)
  803f89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f8c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f95:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f9f:	c1 e0 04             	shl    $0x4,%eax
  803fa2:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803fa7:	8b 00                	mov    (%eax),%eax
  803fa9:	8d 50 ff             	lea    -0x1(%eax),%edx
  803fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803faf:	c1 e0 04             	shl    $0x4,%eax
  803fb2:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803fb7:	89 10                	mov    %edx,(%eax)
			b = next;
  803fb9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803fbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  803fbf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803fc3:	0f 85 2a ff ff ff    	jne    803ef3 <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  803fc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803fcc:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  803fd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803fd5:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  803fdb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803fdf:	75 17                	jne    803ff8 <free_block+0x2cb>
  803fe1:	83 ec 04             	sub    $0x4,%esp
  803fe4:	68 ec 4c 80 00       	push   $0x804cec
  803fe9:	68 bc 00 00 00       	push   $0xbc
  803fee:	68 e3 4b 80 00       	push   $0x804be3
  803ff3:	e8 0b c6 ff ff       	call   800603 <_panic>
  803ff8:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803ffe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804001:	89 10                	mov    %edx,(%eax)
  804003:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804006:	8b 00                	mov    (%eax),%eax
  804008:	85 c0                	test   %eax,%eax
  80400a:	74 0d                	je     804019 <free_block+0x2ec>
  80400c:	a1 68 d0 81 00       	mov    0x81d068,%eax
  804011:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804014:	89 50 04             	mov    %edx,0x4(%eax)
  804017:	eb 08                	jmp    804021 <free_block+0x2f4>
  804019:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80401c:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  804021:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804024:	a3 68 d0 81 00       	mov    %eax,0x81d068
  804029:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80402c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804033:	a1 74 d0 81 00       	mov    0x81d074,%eax
  804038:	40                   	inc    %eax
  804039:	a3 74 d0 81 00       	mov    %eax,0x81d074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  80403e:	83 ec 0c             	sub    $0xc,%esp
  804041:	ff 75 ec             	pushl  -0x14(%ebp)
  804044:	e8 7e f5 ff ff       	call   8035c7 <to_page_va>
  804049:	83 c4 10             	add    $0x10,%esp
  80404c:	83 ec 0c             	sub    $0xc,%esp
  80404f:	50                   	push   %eax
  804050:	e8 fe d7 ff ff       	call   801853 <return_page>
  804055:	83 c4 10             	add    $0x10,%esp
	}
}
  804058:	90                   	nop
  804059:	c9                   	leave  
  80405a:	c3                   	ret    
  80405b:	90                   	nop

0080405c <__udivdi3>:
  80405c:	55                   	push   %ebp
  80405d:	57                   	push   %edi
  80405e:	56                   	push   %esi
  80405f:	53                   	push   %ebx
  804060:	83 ec 1c             	sub    $0x1c,%esp
  804063:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804067:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80406b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80406f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804073:	89 ca                	mov    %ecx,%edx
  804075:	89 f8                	mov    %edi,%eax
  804077:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80407b:	85 f6                	test   %esi,%esi
  80407d:	75 2d                	jne    8040ac <__udivdi3+0x50>
  80407f:	39 cf                	cmp    %ecx,%edi
  804081:	77 65                	ja     8040e8 <__udivdi3+0x8c>
  804083:	89 fd                	mov    %edi,%ebp
  804085:	85 ff                	test   %edi,%edi
  804087:	75 0b                	jne    804094 <__udivdi3+0x38>
  804089:	b8 01 00 00 00       	mov    $0x1,%eax
  80408e:	31 d2                	xor    %edx,%edx
  804090:	f7 f7                	div    %edi
  804092:	89 c5                	mov    %eax,%ebp
  804094:	31 d2                	xor    %edx,%edx
  804096:	89 c8                	mov    %ecx,%eax
  804098:	f7 f5                	div    %ebp
  80409a:	89 c1                	mov    %eax,%ecx
  80409c:	89 d8                	mov    %ebx,%eax
  80409e:	f7 f5                	div    %ebp
  8040a0:	89 cf                	mov    %ecx,%edi
  8040a2:	89 fa                	mov    %edi,%edx
  8040a4:	83 c4 1c             	add    $0x1c,%esp
  8040a7:	5b                   	pop    %ebx
  8040a8:	5e                   	pop    %esi
  8040a9:	5f                   	pop    %edi
  8040aa:	5d                   	pop    %ebp
  8040ab:	c3                   	ret    
  8040ac:	39 ce                	cmp    %ecx,%esi
  8040ae:	77 28                	ja     8040d8 <__udivdi3+0x7c>
  8040b0:	0f bd fe             	bsr    %esi,%edi
  8040b3:	83 f7 1f             	xor    $0x1f,%edi
  8040b6:	75 40                	jne    8040f8 <__udivdi3+0x9c>
  8040b8:	39 ce                	cmp    %ecx,%esi
  8040ba:	72 0a                	jb     8040c6 <__udivdi3+0x6a>
  8040bc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8040c0:	0f 87 9e 00 00 00    	ja     804164 <__udivdi3+0x108>
  8040c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8040cb:	89 fa                	mov    %edi,%edx
  8040cd:	83 c4 1c             	add    $0x1c,%esp
  8040d0:	5b                   	pop    %ebx
  8040d1:	5e                   	pop    %esi
  8040d2:	5f                   	pop    %edi
  8040d3:	5d                   	pop    %ebp
  8040d4:	c3                   	ret    
  8040d5:	8d 76 00             	lea    0x0(%esi),%esi
  8040d8:	31 ff                	xor    %edi,%edi
  8040da:	31 c0                	xor    %eax,%eax
  8040dc:	89 fa                	mov    %edi,%edx
  8040de:	83 c4 1c             	add    $0x1c,%esp
  8040e1:	5b                   	pop    %ebx
  8040e2:	5e                   	pop    %esi
  8040e3:	5f                   	pop    %edi
  8040e4:	5d                   	pop    %ebp
  8040e5:	c3                   	ret    
  8040e6:	66 90                	xchg   %ax,%ax
  8040e8:	89 d8                	mov    %ebx,%eax
  8040ea:	f7 f7                	div    %edi
  8040ec:	31 ff                	xor    %edi,%edi
  8040ee:	89 fa                	mov    %edi,%edx
  8040f0:	83 c4 1c             	add    $0x1c,%esp
  8040f3:	5b                   	pop    %ebx
  8040f4:	5e                   	pop    %esi
  8040f5:	5f                   	pop    %edi
  8040f6:	5d                   	pop    %ebp
  8040f7:	c3                   	ret    
  8040f8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8040fd:	89 eb                	mov    %ebp,%ebx
  8040ff:	29 fb                	sub    %edi,%ebx
  804101:	89 f9                	mov    %edi,%ecx
  804103:	d3 e6                	shl    %cl,%esi
  804105:	89 c5                	mov    %eax,%ebp
  804107:	88 d9                	mov    %bl,%cl
  804109:	d3 ed                	shr    %cl,%ebp
  80410b:	89 e9                	mov    %ebp,%ecx
  80410d:	09 f1                	or     %esi,%ecx
  80410f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804113:	89 f9                	mov    %edi,%ecx
  804115:	d3 e0                	shl    %cl,%eax
  804117:	89 c5                	mov    %eax,%ebp
  804119:	89 d6                	mov    %edx,%esi
  80411b:	88 d9                	mov    %bl,%cl
  80411d:	d3 ee                	shr    %cl,%esi
  80411f:	89 f9                	mov    %edi,%ecx
  804121:	d3 e2                	shl    %cl,%edx
  804123:	8b 44 24 08          	mov    0x8(%esp),%eax
  804127:	88 d9                	mov    %bl,%cl
  804129:	d3 e8                	shr    %cl,%eax
  80412b:	09 c2                	or     %eax,%edx
  80412d:	89 d0                	mov    %edx,%eax
  80412f:	89 f2                	mov    %esi,%edx
  804131:	f7 74 24 0c          	divl   0xc(%esp)
  804135:	89 d6                	mov    %edx,%esi
  804137:	89 c3                	mov    %eax,%ebx
  804139:	f7 e5                	mul    %ebp
  80413b:	39 d6                	cmp    %edx,%esi
  80413d:	72 19                	jb     804158 <__udivdi3+0xfc>
  80413f:	74 0b                	je     80414c <__udivdi3+0xf0>
  804141:	89 d8                	mov    %ebx,%eax
  804143:	31 ff                	xor    %edi,%edi
  804145:	e9 58 ff ff ff       	jmp    8040a2 <__udivdi3+0x46>
  80414a:	66 90                	xchg   %ax,%ax
  80414c:	8b 54 24 08          	mov    0x8(%esp),%edx
  804150:	89 f9                	mov    %edi,%ecx
  804152:	d3 e2                	shl    %cl,%edx
  804154:	39 c2                	cmp    %eax,%edx
  804156:	73 e9                	jae    804141 <__udivdi3+0xe5>
  804158:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80415b:	31 ff                	xor    %edi,%edi
  80415d:	e9 40 ff ff ff       	jmp    8040a2 <__udivdi3+0x46>
  804162:	66 90                	xchg   %ax,%ax
  804164:	31 c0                	xor    %eax,%eax
  804166:	e9 37 ff ff ff       	jmp    8040a2 <__udivdi3+0x46>
  80416b:	90                   	nop

0080416c <__umoddi3>:
  80416c:	55                   	push   %ebp
  80416d:	57                   	push   %edi
  80416e:	56                   	push   %esi
  80416f:	53                   	push   %ebx
  804170:	83 ec 1c             	sub    $0x1c,%esp
  804173:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804177:	8b 74 24 34          	mov    0x34(%esp),%esi
  80417b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80417f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804183:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804187:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80418b:	89 f3                	mov    %esi,%ebx
  80418d:	89 fa                	mov    %edi,%edx
  80418f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804193:	89 34 24             	mov    %esi,(%esp)
  804196:	85 c0                	test   %eax,%eax
  804198:	75 1a                	jne    8041b4 <__umoddi3+0x48>
  80419a:	39 f7                	cmp    %esi,%edi
  80419c:	0f 86 a2 00 00 00    	jbe    804244 <__umoddi3+0xd8>
  8041a2:	89 c8                	mov    %ecx,%eax
  8041a4:	89 f2                	mov    %esi,%edx
  8041a6:	f7 f7                	div    %edi
  8041a8:	89 d0                	mov    %edx,%eax
  8041aa:	31 d2                	xor    %edx,%edx
  8041ac:	83 c4 1c             	add    $0x1c,%esp
  8041af:	5b                   	pop    %ebx
  8041b0:	5e                   	pop    %esi
  8041b1:	5f                   	pop    %edi
  8041b2:	5d                   	pop    %ebp
  8041b3:	c3                   	ret    
  8041b4:	39 f0                	cmp    %esi,%eax
  8041b6:	0f 87 ac 00 00 00    	ja     804268 <__umoddi3+0xfc>
  8041bc:	0f bd e8             	bsr    %eax,%ebp
  8041bf:	83 f5 1f             	xor    $0x1f,%ebp
  8041c2:	0f 84 ac 00 00 00    	je     804274 <__umoddi3+0x108>
  8041c8:	bf 20 00 00 00       	mov    $0x20,%edi
  8041cd:	29 ef                	sub    %ebp,%edi
  8041cf:	89 fe                	mov    %edi,%esi
  8041d1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8041d5:	89 e9                	mov    %ebp,%ecx
  8041d7:	d3 e0                	shl    %cl,%eax
  8041d9:	89 d7                	mov    %edx,%edi
  8041db:	89 f1                	mov    %esi,%ecx
  8041dd:	d3 ef                	shr    %cl,%edi
  8041df:	09 c7                	or     %eax,%edi
  8041e1:	89 e9                	mov    %ebp,%ecx
  8041e3:	d3 e2                	shl    %cl,%edx
  8041e5:	89 14 24             	mov    %edx,(%esp)
  8041e8:	89 d8                	mov    %ebx,%eax
  8041ea:	d3 e0                	shl    %cl,%eax
  8041ec:	89 c2                	mov    %eax,%edx
  8041ee:	8b 44 24 08          	mov    0x8(%esp),%eax
  8041f2:	d3 e0                	shl    %cl,%eax
  8041f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8041f8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8041fc:	89 f1                	mov    %esi,%ecx
  8041fe:	d3 e8                	shr    %cl,%eax
  804200:	09 d0                	or     %edx,%eax
  804202:	d3 eb                	shr    %cl,%ebx
  804204:	89 da                	mov    %ebx,%edx
  804206:	f7 f7                	div    %edi
  804208:	89 d3                	mov    %edx,%ebx
  80420a:	f7 24 24             	mull   (%esp)
  80420d:	89 c6                	mov    %eax,%esi
  80420f:	89 d1                	mov    %edx,%ecx
  804211:	39 d3                	cmp    %edx,%ebx
  804213:	0f 82 87 00 00 00    	jb     8042a0 <__umoddi3+0x134>
  804219:	0f 84 91 00 00 00    	je     8042b0 <__umoddi3+0x144>
  80421f:	8b 54 24 04          	mov    0x4(%esp),%edx
  804223:	29 f2                	sub    %esi,%edx
  804225:	19 cb                	sbb    %ecx,%ebx
  804227:	89 d8                	mov    %ebx,%eax
  804229:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80422d:	d3 e0                	shl    %cl,%eax
  80422f:	89 e9                	mov    %ebp,%ecx
  804231:	d3 ea                	shr    %cl,%edx
  804233:	09 d0                	or     %edx,%eax
  804235:	89 e9                	mov    %ebp,%ecx
  804237:	d3 eb                	shr    %cl,%ebx
  804239:	89 da                	mov    %ebx,%edx
  80423b:	83 c4 1c             	add    $0x1c,%esp
  80423e:	5b                   	pop    %ebx
  80423f:	5e                   	pop    %esi
  804240:	5f                   	pop    %edi
  804241:	5d                   	pop    %ebp
  804242:	c3                   	ret    
  804243:	90                   	nop
  804244:	89 fd                	mov    %edi,%ebp
  804246:	85 ff                	test   %edi,%edi
  804248:	75 0b                	jne    804255 <__umoddi3+0xe9>
  80424a:	b8 01 00 00 00       	mov    $0x1,%eax
  80424f:	31 d2                	xor    %edx,%edx
  804251:	f7 f7                	div    %edi
  804253:	89 c5                	mov    %eax,%ebp
  804255:	89 f0                	mov    %esi,%eax
  804257:	31 d2                	xor    %edx,%edx
  804259:	f7 f5                	div    %ebp
  80425b:	89 c8                	mov    %ecx,%eax
  80425d:	f7 f5                	div    %ebp
  80425f:	89 d0                	mov    %edx,%eax
  804261:	e9 44 ff ff ff       	jmp    8041aa <__umoddi3+0x3e>
  804266:	66 90                	xchg   %ax,%ax
  804268:	89 c8                	mov    %ecx,%eax
  80426a:	89 f2                	mov    %esi,%edx
  80426c:	83 c4 1c             	add    $0x1c,%esp
  80426f:	5b                   	pop    %ebx
  804270:	5e                   	pop    %esi
  804271:	5f                   	pop    %edi
  804272:	5d                   	pop    %ebp
  804273:	c3                   	ret    
  804274:	3b 04 24             	cmp    (%esp),%eax
  804277:	72 06                	jb     80427f <__umoddi3+0x113>
  804279:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80427d:	77 0f                	ja     80428e <__umoddi3+0x122>
  80427f:	89 f2                	mov    %esi,%edx
  804281:	29 f9                	sub    %edi,%ecx
  804283:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804287:	89 14 24             	mov    %edx,(%esp)
  80428a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80428e:	8b 44 24 04          	mov    0x4(%esp),%eax
  804292:	8b 14 24             	mov    (%esp),%edx
  804295:	83 c4 1c             	add    $0x1c,%esp
  804298:	5b                   	pop    %ebx
  804299:	5e                   	pop    %esi
  80429a:	5f                   	pop    %edi
  80429b:	5d                   	pop    %ebp
  80429c:	c3                   	ret    
  80429d:	8d 76 00             	lea    0x0(%esi),%esi
  8042a0:	2b 04 24             	sub    (%esp),%eax
  8042a3:	19 fa                	sbb    %edi,%edx
  8042a5:	89 d1                	mov    %edx,%ecx
  8042a7:	89 c6                	mov    %eax,%esi
  8042a9:	e9 71 ff ff ff       	jmp    80421f <__umoddi3+0xb3>
  8042ae:	66 90                	xchg   %ax,%ax
  8042b0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8042b4:	72 ea                	jb     8042a0 <__umoddi3+0x134>
  8042b6:	89 d9                	mov    %ebx,%ecx
  8042b8:	e9 62 ff ff ff       	jmp    80421f <__umoddi3+0xb3>
