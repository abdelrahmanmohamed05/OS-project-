
obj/user/ef_tst_sharing_2slave1:     file format elf32-i386


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
  800031:	e8 58 02 00 00       	call   80028e <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Slave program1: Read the 2 shared variables, edit the 3rd one, and exit
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 34             	sub    $0x34,%esp
//#else
//	panic("make sure to enable the kernel heap: USE_KHEAP=1");
//#endif
//	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80003f:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)

	uint32 *x,*y,*z, *expectedVA;
	int freeFrames, diff, expected;
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 0d 31 00 00       	call   803158 <sys_getparentenvid>
  80004b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//GET: z then y then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	//sys_lock_cons();
	sys_lock_cons();
  80004e:	e8 73 2e 00 00       	call   802ec6 <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  800053:	e8 1e 2f 00 00       	call   802f76 <sys_calculate_free_frames>
  800058:	89 45 ec             	mov    %eax,-0x14(%ebp)
		z = sget(parentenvID,"z");
  80005b:	83 ec 08             	sub    $0x8,%esp
  80005e:	68 00 41 80 00       	push   $0x804100
  800063:	ff 75 f0             	pushl  -0x10(%ebp)
  800066:	e8 2a 21 00 00       	call   802195 <sget>
  80006b:	83 c4 10             	add    $0x10,%esp
  80006e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		expectedVA = (uint32*)(pagealloc_start + 0 * PAGE_SIZE);
  800071:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800074:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (z != expectedVA) panic("Get(): Returned address is not correct. Expected = %x, Actual = %x\nMake sure that you align the allocation on 4KB boundary", expectedVA, z);
  800077:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80007a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80007d:	74 1a                	je     800099 <_main+0x61>
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	ff 75 e8             	pushl  -0x18(%ebp)
  800085:	ff 75 e4             	pushl  -0x1c(%ebp)
  800088:	68 04 41 80 00       	push   $0x804104
  80008d:	6a 20                	push   $0x20
  80008f:	68 7f 41 80 00       	push   $0x80417f
  800094:	e8 a5 03 00 00       	call   80043e <_panic>
		expected = 1 ; /*1table*/
  800099:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8000a0:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000a3:	e8 ce 2e 00 00       	call   802f76 <sys_calculate_free_frames>
  8000a8:	29 c3                	sub    %eax,%ebx
  8000aa:	89 d8                	mov    %ebx,%eax
  8000ac:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  8000af:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000b2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8000b5:	74 24                	je     8000db <_main+0xa3>
  8000b7:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000ba:	e8 b7 2e 00 00       	call   802f76 <sys_calculate_free_frames>
  8000bf:	29 c3                	sub    %eax,%ebx
  8000c1:	89 d8                	mov    %ebx,%eax
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	ff 75 e0             	pushl  -0x20(%ebp)
  8000c9:	50                   	push   %eax
  8000ca:	68 a0 41 80 00       	push   $0x8041a0
  8000cf:	6a 23                	push   $0x23
  8000d1:	68 7f 41 80 00       	push   $0x80417f
  8000d6:	e8 63 03 00 00       	call   80043e <_panic>
	}
	sys_unlock_cons();
  8000db:	e8 00 2e 00 00       	call   802ee0 <sys_unlock_cons>
	//sys_unlock_cons();

	sys_lock_cons();
  8000e0:	e8 e1 2d 00 00       	call   802ec6 <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  8000e5:	e8 8c 2e 00 00       	call   802f76 <sys_calculate_free_frames>
  8000ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
		y = sget(parentenvID,"y");
  8000ed:	83 ec 08             	sub    $0x8,%esp
  8000f0:	68 38 42 80 00       	push   $0x804238
  8000f5:	ff 75 f0             	pushl  -0x10(%ebp)
  8000f8:	e8 98 20 00 00       	call   802195 <sget>
  8000fd:	83 c4 10             	add    $0x10,%esp
  800100:	89 45 d8             	mov    %eax,-0x28(%ebp)
		expectedVA = (uint32*)(pagealloc_start + 1 * PAGE_SIZE);
  800103:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800106:	05 00 10 00 00       	add    $0x1000,%eax
  80010b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (y != expectedVA) panic("Get(): Returned address is not correct. Expected = %x, Actual = %x\nMake sure that you align the allocation on 4KB boundary", expectedVA, y);
  80010e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800111:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800114:	74 1a                	je     800130 <_main+0xf8>
  800116:	83 ec 0c             	sub    $0xc,%esp
  800119:	ff 75 d8             	pushl  -0x28(%ebp)
  80011c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80011f:	68 04 41 80 00       	push   $0x804104
  800124:	6a 2d                	push   $0x2d
  800126:	68 7f 41 80 00       	push   $0x80417f
  80012b:	e8 0e 03 00 00       	call   80043e <_panic>
		expected = 0 ;
  800130:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800137:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80013a:	e8 37 2e 00 00       	call   802f76 <sys_calculate_free_frames>
  80013f:	29 c3                	sub    %eax,%ebx
  800141:	89 d8                	mov    %ebx,%eax
  800143:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800146:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800149:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80014c:	74 24                	je     800172 <_main+0x13a>
  80014e:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800151:	e8 20 2e 00 00       	call   802f76 <sys_calculate_free_frames>
  800156:	29 c3                	sub    %eax,%ebx
  800158:	89 d8                	mov    %ebx,%eax
  80015a:	83 ec 0c             	sub    $0xc,%esp
  80015d:	ff 75 e0             	pushl  -0x20(%ebp)
  800160:	50                   	push   %eax
  800161:	68 a0 41 80 00       	push   $0x8041a0
  800166:	6a 30                	push   $0x30
  800168:	68 7f 41 80 00       	push   $0x80417f
  80016d:	e8 cc 02 00 00       	call   80043e <_panic>
	}
	sys_unlock_cons();
  800172:	e8 69 2d 00 00       	call   802ee0 <sys_unlock_cons>
	//sys_unlock_cons();

	if (*y != 20) panic("Get(): Shared Variable is not created or got correctly") ;
  800177:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80017a:	8b 00                	mov    (%eax),%eax
  80017c:	83 f8 14             	cmp    $0x14,%eax
  80017f:	74 14                	je     800195 <_main+0x15d>
  800181:	83 ec 04             	sub    $0x4,%esp
  800184:	68 3c 42 80 00       	push   $0x80423c
  800189:	6a 35                	push   $0x35
  80018b:	68 7f 41 80 00       	push   $0x80417f
  800190:	e8 a9 02 00 00       	call   80043e <_panic>

	sys_lock_cons();
  800195:	e8 2c 2d 00 00       	call   802ec6 <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  80019a:	e8 d7 2d 00 00       	call   802f76 <sys_calculate_free_frames>
  80019f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		x = sget(parentenvID,"x");
  8001a2:	83 ec 08             	sub    $0x8,%esp
  8001a5:	68 73 42 80 00       	push   $0x804273
  8001aa:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ad:	e8 e3 1f 00 00       	call   802195 <sget>
  8001b2:	83 c4 10             	add    $0x10,%esp
  8001b5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		expectedVA = (uint32*)(pagealloc_start + 2 * PAGE_SIZE);
  8001b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001bb:	05 00 20 00 00       	add    $0x2000,%eax
  8001c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (x != expectedVA) panic("Get(): Returned address is not correct. Expected = %x, Actual = %x\nMake sure that you align the allocation on 4KB boundary", expectedVA, x);
  8001c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8001c6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8001c9:	74 1a                	je     8001e5 <_main+0x1ad>
  8001cb:	83 ec 0c             	sub    $0xc,%esp
  8001ce:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001d1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001d4:	68 04 41 80 00       	push   $0x804104
  8001d9:	6a 3c                	push   $0x3c
  8001db:	68 7f 41 80 00       	push   $0x80417f
  8001e0:	e8 59 02 00 00       	call   80043e <_panic>
		expected = 0 ;
  8001e5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8001ec:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8001ef:	e8 82 2d 00 00       	call   802f76 <sys_calculate_free_frames>
  8001f4:	29 c3                	sub    %eax,%ebx
  8001f6:	89 d8                	mov    %ebx,%eax
  8001f8:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  8001fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001fe:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800201:	74 24                	je     800227 <_main+0x1ef>
  800203:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800206:	e8 6b 2d 00 00       	call   802f76 <sys_calculate_free_frames>
  80020b:	29 c3                	sub    %eax,%ebx
  80020d:	89 d8                	mov    %ebx,%eax
  80020f:	83 ec 0c             	sub    $0xc,%esp
  800212:	ff 75 e0             	pushl  -0x20(%ebp)
  800215:	50                   	push   %eax
  800216:	68 a0 41 80 00       	push   $0x8041a0
  80021b:	6a 3f                	push   $0x3f
  80021d:	68 7f 41 80 00       	push   $0x80417f
  800222:	e8 17 02 00 00       	call   80043e <_panic>
	}
	sys_unlock_cons();
  800227:	e8 b4 2c 00 00       	call   802ee0 <sys_unlock_cons>
	//sys_unlock_cons();

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  80022c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80022f:	8b 00                	mov    (%eax),%eax
  800231:	83 f8 0a             	cmp    $0xa,%eax
  800234:	74 14                	je     80024a <_main+0x212>
  800236:	83 ec 04             	sub    $0x4,%esp
  800239:	68 3c 42 80 00       	push   $0x80423c
  80023e:	6a 44                	push   $0x44
  800240:	68 7f 41 80 00       	push   $0x80417f
  800245:	e8 f4 01 00 00       	call   80043e <_panic>

	sys_lock_cons();
  80024a:	e8 77 2c 00 00       	call   802ec6 <sys_lock_cons>
	{
		*z = *x + *y ;
  80024f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800252:	8b 10                	mov    (%eax),%edx
  800254:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800257:	8b 00                	mov    (%eax),%eax
  800259:	01 c2                	add    %eax,%edx
  80025b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80025e:	89 10                	mov    %edx,(%eax)
	}
	sys_unlock_cons();
  800260:	e8 7b 2c 00 00       	call   802ee0 <sys_unlock_cons>

	if (*z != 30) panic("Get(): Shared Variable is not created or got correctly") ;
  800265:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800268:	8b 00                	mov    (%eax),%eax
  80026a:	83 f8 1e             	cmp    $0x1e,%eax
  80026d:	74 14                	je     800283 <_main+0x24b>
  80026f:	83 ec 04             	sub    $0x4,%esp
  800272:	68 3c 42 80 00       	push   $0x80423c
  800277:	6a 4c                	push   $0x4c
  800279:	68 7f 41 80 00       	push   $0x80417f
  80027e:	e8 bb 01 00 00       	call   80043e <_panic>

	//To indicate that it's completed successfully
	inctst();
  800283:	e8 f5 2f 00 00       	call   80327d <inctst>

	return;
  800288:	90                   	nop
}
  800289:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80028c:	c9                   	leave  
  80028d:	c3                   	ret    

0080028e <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80028e:	55                   	push   %ebp
  80028f:	89 e5                	mov    %esp,%ebp
  800291:	57                   	push   %edi
  800292:	56                   	push   %esi
  800293:	53                   	push   %ebx
  800294:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800297:	e8 a3 2e 00 00       	call   80313f <sys_getenvindex>
  80029c:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80029f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002a2:	89 d0                	mov    %edx,%eax
  8002a4:	c1 e0 03             	shl    $0x3,%eax
  8002a7:	01 d0                	add    %edx,%eax
  8002a9:	c1 e0 02             	shl    $0x2,%eax
  8002ac:	01 d0                	add    %edx,%eax
  8002ae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002b5:	01 d0                	add    %edx,%eax
  8002b7:	c1 e0 03             	shl    $0x3,%eax
  8002ba:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002bf:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002c4:	a1 20 50 80 00       	mov    0x805020,%eax
  8002c9:	8a 40 20             	mov    0x20(%eax),%al
  8002cc:	84 c0                	test   %al,%al
  8002ce:	74 0d                	je     8002dd <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8002d0:	a1 20 50 80 00       	mov    0x805020,%eax
  8002d5:	83 c0 20             	add    $0x20,%eax
  8002d8:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002dd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002e1:	7e 0a                	jle    8002ed <libmain+0x5f>
		binaryname = argv[0];
  8002e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e6:	8b 00                	mov    (%eax),%eax
  8002e8:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  8002ed:	83 ec 08             	sub    $0x8,%esp
  8002f0:	ff 75 0c             	pushl  0xc(%ebp)
  8002f3:	ff 75 08             	pushl  0x8(%ebp)
  8002f6:	e8 3d fd ff ff       	call   800038 <_main>
  8002fb:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8002fe:	a1 00 50 80 00       	mov    0x805000,%eax
  800303:	85 c0                	test   %eax,%eax
  800305:	0f 84 01 01 00 00    	je     80040c <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80030b:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800311:	bb 70 43 80 00       	mov    $0x804370,%ebx
  800316:	ba 0e 00 00 00       	mov    $0xe,%edx
  80031b:	89 c7                	mov    %eax,%edi
  80031d:	89 de                	mov    %ebx,%esi
  80031f:	89 d1                	mov    %edx,%ecx
  800321:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800323:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800326:	b9 56 00 00 00       	mov    $0x56,%ecx
  80032b:	b0 00                	mov    $0x0,%al
  80032d:	89 d7                	mov    %edx,%edi
  80032f:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800331:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800338:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80033b:	83 ec 08             	sub    $0x8,%esp
  80033e:	50                   	push   %eax
  80033f:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800345:	50                   	push   %eax
  800346:	e8 2a 30 00 00       	call   803375 <sys_utilities>
  80034b:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80034e:	e8 73 2b 00 00       	call   802ec6 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800353:	83 ec 0c             	sub    $0xc,%esp
  800356:	68 90 42 80 00       	push   $0x804290
  80035b:	e8 ac 03 00 00       	call   80070c <cprintf>
  800360:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800363:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800366:	85 c0                	test   %eax,%eax
  800368:	74 18                	je     800382 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80036a:	e8 24 30 00 00       	call   803393 <sys_get_optimal_num_faults>
  80036f:	83 ec 08             	sub    $0x8,%esp
  800372:	50                   	push   %eax
  800373:	68 b8 42 80 00       	push   $0x8042b8
  800378:	e8 8f 03 00 00       	call   80070c <cprintf>
  80037d:	83 c4 10             	add    $0x10,%esp
  800380:	eb 59                	jmp    8003db <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800382:	a1 20 50 80 00       	mov    0x805020,%eax
  800387:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  80038d:	a1 20 50 80 00       	mov    0x805020,%eax
  800392:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800398:	83 ec 04             	sub    $0x4,%esp
  80039b:	52                   	push   %edx
  80039c:	50                   	push   %eax
  80039d:	68 dc 42 80 00       	push   $0x8042dc
  8003a2:	e8 65 03 00 00       	call   80070c <cprintf>
  8003a7:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003aa:	a1 20 50 80 00       	mov    0x805020,%eax
  8003af:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  8003b5:	a1 20 50 80 00       	mov    0x805020,%eax
  8003ba:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  8003c0:	a1 20 50 80 00       	mov    0x805020,%eax
  8003c5:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8003cb:	51                   	push   %ecx
  8003cc:	52                   	push   %edx
  8003cd:	50                   	push   %eax
  8003ce:	68 04 43 80 00       	push   $0x804304
  8003d3:	e8 34 03 00 00       	call   80070c <cprintf>
  8003d8:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003db:	a1 20 50 80 00       	mov    0x805020,%eax
  8003e0:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  8003e6:	83 ec 08             	sub    $0x8,%esp
  8003e9:	50                   	push   %eax
  8003ea:	68 5c 43 80 00       	push   $0x80435c
  8003ef:	e8 18 03 00 00       	call   80070c <cprintf>
  8003f4:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8003f7:	83 ec 0c             	sub    $0xc,%esp
  8003fa:	68 90 42 80 00       	push   $0x804290
  8003ff:	e8 08 03 00 00       	call   80070c <cprintf>
  800404:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800407:	e8 d4 2a 00 00       	call   802ee0 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80040c:	e8 1f 00 00 00       	call   800430 <exit>
}
  800411:	90                   	nop
  800412:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800415:	5b                   	pop    %ebx
  800416:	5e                   	pop    %esi
  800417:	5f                   	pop    %edi
  800418:	5d                   	pop    %ebp
  800419:	c3                   	ret    

0080041a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80041a:	55                   	push   %ebp
  80041b:	89 e5                	mov    %esp,%ebp
  80041d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800420:	83 ec 0c             	sub    $0xc,%esp
  800423:	6a 00                	push   $0x0
  800425:	e8 e1 2c 00 00       	call   80310b <sys_destroy_env>
  80042a:	83 c4 10             	add    $0x10,%esp
}
  80042d:	90                   	nop
  80042e:	c9                   	leave  
  80042f:	c3                   	ret    

00800430 <exit>:

void
exit(void)
{
  800430:	55                   	push   %ebp
  800431:	89 e5                	mov    %esp,%ebp
  800433:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800436:	e8 36 2d 00 00       	call   803171 <sys_exit_env>
}
  80043b:	90                   	nop
  80043c:	c9                   	leave  
  80043d:	c3                   	ret    

0080043e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80043e:	55                   	push   %ebp
  80043f:	89 e5                	mov    %esp,%ebp
  800441:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800444:	8d 45 10             	lea    0x10(%ebp),%eax
  800447:	83 c0 04             	add    $0x4,%eax
  80044a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80044d:	a1 38 51 83 00       	mov    0x835138,%eax
  800452:	85 c0                	test   %eax,%eax
  800454:	74 16                	je     80046c <_panic+0x2e>
		cprintf("%s: ", argv0);
  800456:	a1 38 51 83 00       	mov    0x835138,%eax
  80045b:	83 ec 08             	sub    $0x8,%esp
  80045e:	50                   	push   %eax
  80045f:	68 d4 43 80 00       	push   $0x8043d4
  800464:	e8 a3 02 00 00       	call   80070c <cprintf>
  800469:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80046c:	a1 04 50 80 00       	mov    0x805004,%eax
  800471:	83 ec 0c             	sub    $0xc,%esp
  800474:	ff 75 0c             	pushl  0xc(%ebp)
  800477:	ff 75 08             	pushl  0x8(%ebp)
  80047a:	50                   	push   %eax
  80047b:	68 dc 43 80 00       	push   $0x8043dc
  800480:	6a 74                	push   $0x74
  800482:	e8 b2 02 00 00       	call   800739 <cprintf_colored>
  800487:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80048a:	8b 45 10             	mov    0x10(%ebp),%eax
  80048d:	83 ec 08             	sub    $0x8,%esp
  800490:	ff 75 f4             	pushl  -0xc(%ebp)
  800493:	50                   	push   %eax
  800494:	e8 04 02 00 00       	call   80069d <vcprintf>
  800499:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80049c:	83 ec 08             	sub    $0x8,%esp
  80049f:	6a 00                	push   $0x0
  8004a1:	68 04 44 80 00       	push   $0x804404
  8004a6:	e8 f2 01 00 00       	call   80069d <vcprintf>
  8004ab:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004ae:	e8 7d ff ff ff       	call   800430 <exit>

	// should not return here
	while (1) ;
  8004b3:	eb fe                	jmp    8004b3 <_panic+0x75>

008004b5 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004b5:	55                   	push   %ebp
  8004b6:	89 e5                	mov    %esp,%ebp
  8004b8:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8004bb:	a1 20 50 80 00       	mov    0x805020,%eax
  8004c0:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c9:	39 c2                	cmp    %eax,%edx
  8004cb:	74 14                	je     8004e1 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8004cd:	83 ec 04             	sub    $0x4,%esp
  8004d0:	68 08 44 80 00       	push   $0x804408
  8004d5:	6a 26                	push   $0x26
  8004d7:	68 54 44 80 00       	push   $0x804454
  8004dc:	e8 5d ff ff ff       	call   80043e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8004e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8004e8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004ef:	e9 c5 00 00 00       	jmp    8005b9 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8004f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004f7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800501:	01 d0                	add    %edx,%eax
  800503:	8b 00                	mov    (%eax),%eax
  800505:	85 c0                	test   %eax,%eax
  800507:	75 08                	jne    800511 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800509:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80050c:	e9 a5 00 00 00       	jmp    8005b6 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800511:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800518:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80051f:	eb 69                	jmp    80058a <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800521:	a1 20 50 80 00       	mov    0x805020,%eax
  800526:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80052c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80052f:	89 d0                	mov    %edx,%eax
  800531:	01 c0                	add    %eax,%eax
  800533:	01 d0                	add    %edx,%eax
  800535:	c1 e0 03             	shl    $0x3,%eax
  800538:	01 c8                	add    %ecx,%eax
  80053a:	8a 40 04             	mov    0x4(%eax),%al
  80053d:	84 c0                	test   %al,%al
  80053f:	75 46                	jne    800587 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800541:	a1 20 50 80 00       	mov    0x805020,%eax
  800546:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80054c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80054f:	89 d0                	mov    %edx,%eax
  800551:	01 c0                	add    %eax,%eax
  800553:	01 d0                	add    %edx,%eax
  800555:	c1 e0 03             	shl    $0x3,%eax
  800558:	01 c8                	add    %ecx,%eax
  80055a:	8b 00                	mov    (%eax),%eax
  80055c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80055f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800562:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800567:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800569:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80056c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800573:	8b 45 08             	mov    0x8(%ebp),%eax
  800576:	01 c8                	add    %ecx,%eax
  800578:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80057a:	39 c2                	cmp    %eax,%edx
  80057c:	75 09                	jne    800587 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80057e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800585:	eb 15                	jmp    80059c <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800587:	ff 45 e8             	incl   -0x18(%ebp)
  80058a:	a1 20 50 80 00       	mov    0x805020,%eax
  80058f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800595:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800598:	39 c2                	cmp    %eax,%edx
  80059a:	77 85                	ja     800521 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80059c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005a0:	75 14                	jne    8005b6 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8005a2:	83 ec 04             	sub    $0x4,%esp
  8005a5:	68 60 44 80 00       	push   $0x804460
  8005aa:	6a 3a                	push   $0x3a
  8005ac:	68 54 44 80 00       	push   $0x804454
  8005b1:	e8 88 fe ff ff       	call   80043e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005b6:	ff 45 f0             	incl   -0x10(%ebp)
  8005b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005bc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005bf:	0f 8c 2f ff ff ff    	jl     8004f4 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8005c5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005cc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8005d3:	eb 26                	jmp    8005fb <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8005d5:	a1 20 50 80 00       	mov    0x805020,%eax
  8005da:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8005e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005e3:	89 d0                	mov    %edx,%eax
  8005e5:	01 c0                	add    %eax,%eax
  8005e7:	01 d0                	add    %edx,%eax
  8005e9:	c1 e0 03             	shl    $0x3,%eax
  8005ec:	01 c8                	add    %ecx,%eax
  8005ee:	8a 40 04             	mov    0x4(%eax),%al
  8005f1:	3c 01                	cmp    $0x1,%al
  8005f3:	75 03                	jne    8005f8 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8005f5:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005f8:	ff 45 e0             	incl   -0x20(%ebp)
  8005fb:	a1 20 50 80 00       	mov    0x805020,%eax
  800600:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800606:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800609:	39 c2                	cmp    %eax,%edx
  80060b:	77 c8                	ja     8005d5 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80060d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800610:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800613:	74 14                	je     800629 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800615:	83 ec 04             	sub    $0x4,%esp
  800618:	68 b4 44 80 00       	push   $0x8044b4
  80061d:	6a 44                	push   $0x44
  80061f:	68 54 44 80 00       	push   $0x804454
  800624:	e8 15 fe ff ff       	call   80043e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800629:	90                   	nop
  80062a:	c9                   	leave  
  80062b:	c3                   	ret    

0080062c <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80062c:	55                   	push   %ebp
  80062d:	89 e5                	mov    %esp,%ebp
  80062f:	53                   	push   %ebx
  800630:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800633:	8b 45 0c             	mov    0xc(%ebp),%eax
  800636:	8b 00                	mov    (%eax),%eax
  800638:	8d 48 01             	lea    0x1(%eax),%ecx
  80063b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80063e:	89 0a                	mov    %ecx,(%edx)
  800640:	8b 55 08             	mov    0x8(%ebp),%edx
  800643:	88 d1                	mov    %dl,%cl
  800645:	8b 55 0c             	mov    0xc(%ebp),%edx
  800648:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80064c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80064f:	8b 00                	mov    (%eax),%eax
  800651:	3d ff 00 00 00       	cmp    $0xff,%eax
  800656:	75 30                	jne    800688 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800658:	8b 15 3c 51 83 00    	mov    0x83513c,%edx
  80065e:	a0 64 d0 81 00       	mov    0x81d064,%al
  800663:	0f b6 c0             	movzbl %al,%eax
  800666:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800669:	8b 09                	mov    (%ecx),%ecx
  80066b:	89 cb                	mov    %ecx,%ebx
  80066d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800670:	83 c1 08             	add    $0x8,%ecx
  800673:	52                   	push   %edx
  800674:	50                   	push   %eax
  800675:	53                   	push   %ebx
  800676:	51                   	push   %ecx
  800677:	e8 06 28 00 00       	call   802e82 <sys_cputs>
  80067c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80067f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800682:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800688:	8b 45 0c             	mov    0xc(%ebp),%eax
  80068b:	8b 40 04             	mov    0x4(%eax),%eax
  80068e:	8d 50 01             	lea    0x1(%eax),%edx
  800691:	8b 45 0c             	mov    0xc(%ebp),%eax
  800694:	89 50 04             	mov    %edx,0x4(%eax)
}
  800697:	90                   	nop
  800698:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80069b:	c9                   	leave  
  80069c:	c3                   	ret    

0080069d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80069d:	55                   	push   %ebp
  80069e:	89 e5                	mov    %esp,%ebp
  8006a0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006a6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006ad:	00 00 00 
	b.cnt = 0;
  8006b0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006b7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006ba:	ff 75 0c             	pushl  0xc(%ebp)
  8006bd:	ff 75 08             	pushl  0x8(%ebp)
  8006c0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006c6:	50                   	push   %eax
  8006c7:	68 2c 06 80 00       	push   $0x80062c
  8006cc:	e8 5a 02 00 00       	call   80092b <vprintfmt>
  8006d1:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8006d4:	8b 15 3c 51 83 00    	mov    0x83513c,%edx
  8006da:	a0 64 d0 81 00       	mov    0x81d064,%al
  8006df:	0f b6 c0             	movzbl %al,%eax
  8006e2:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8006e8:	52                   	push   %edx
  8006e9:	50                   	push   %eax
  8006ea:	51                   	push   %ecx
  8006eb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006f1:	83 c0 08             	add    $0x8,%eax
  8006f4:	50                   	push   %eax
  8006f5:	e8 88 27 00 00       	call   802e82 <sys_cputs>
  8006fa:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8006fd:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
	return b.cnt;
  800704:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80070a:	c9                   	leave  
  80070b:	c3                   	ret    

0080070c <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80070c:	55                   	push   %ebp
  80070d:	89 e5                	mov    %esp,%ebp
  80070f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800712:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	va_start(ap, fmt);
  800719:	8d 45 0c             	lea    0xc(%ebp),%eax
  80071c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80071f:	8b 45 08             	mov    0x8(%ebp),%eax
  800722:	83 ec 08             	sub    $0x8,%esp
  800725:	ff 75 f4             	pushl  -0xc(%ebp)
  800728:	50                   	push   %eax
  800729:	e8 6f ff ff ff       	call   80069d <vcprintf>
  80072e:	83 c4 10             	add    $0x10,%esp
  800731:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800734:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800737:	c9                   	leave  
  800738:	c3                   	ret    

00800739 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800739:	55                   	push   %ebp
  80073a:	89 e5                	mov    %esp,%ebp
  80073c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80073f:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	curTextClr = (textClr << 8) ; //set text color by the given value
  800746:	8b 45 08             	mov    0x8(%ebp),%eax
  800749:	c1 e0 08             	shl    $0x8,%eax
  80074c:	a3 3c 51 83 00       	mov    %eax,0x83513c
	va_start(ap, fmt);
  800751:	8d 45 0c             	lea    0xc(%ebp),%eax
  800754:	83 c0 04             	add    $0x4,%eax
  800757:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80075a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80075d:	83 ec 08             	sub    $0x8,%esp
  800760:	ff 75 f4             	pushl  -0xc(%ebp)
  800763:	50                   	push   %eax
  800764:	e8 34 ff ff ff       	call   80069d <vcprintf>
  800769:	83 c4 10             	add    $0x10,%esp
  80076c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80076f:	c7 05 3c 51 83 00 00 	movl   $0x700,0x83513c
  800776:	07 00 00 

	return cnt;
  800779:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80077c:	c9                   	leave  
  80077d:	c3                   	ret    

0080077e <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80077e:	55                   	push   %ebp
  80077f:	89 e5                	mov    %esp,%ebp
  800781:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800784:	e8 3d 27 00 00       	call   802ec6 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800789:	8d 45 0c             	lea    0xc(%ebp),%eax
  80078c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80078f:	8b 45 08             	mov    0x8(%ebp),%eax
  800792:	83 ec 08             	sub    $0x8,%esp
  800795:	ff 75 f4             	pushl  -0xc(%ebp)
  800798:	50                   	push   %eax
  800799:	e8 ff fe ff ff       	call   80069d <vcprintf>
  80079e:	83 c4 10             	add    $0x10,%esp
  8007a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007a4:	e8 37 27 00 00       	call   802ee0 <sys_unlock_cons>
	return cnt;
  8007a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007ac:	c9                   	leave  
  8007ad:	c3                   	ret    

008007ae <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007ae:	55                   	push   %ebp
  8007af:	89 e5                	mov    %esp,%ebp
  8007b1:	53                   	push   %ebx
  8007b2:	83 ec 14             	sub    $0x14,%esp
  8007b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007c1:	8b 45 18             	mov    0x18(%ebp),%eax
  8007c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007cc:	77 55                	ja     800823 <printnum+0x75>
  8007ce:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007d1:	72 05                	jb     8007d8 <printnum+0x2a>
  8007d3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007d6:	77 4b                	ja     800823 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007d8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007db:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007de:	8b 45 18             	mov    0x18(%ebp),%eax
  8007e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e6:	52                   	push   %edx
  8007e7:	50                   	push   %eax
  8007e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8007eb:	ff 75 f0             	pushl  -0x10(%ebp)
  8007ee:	e8 a5 36 00 00       	call   803e98 <__udivdi3>
  8007f3:	83 c4 10             	add    $0x10,%esp
  8007f6:	83 ec 04             	sub    $0x4,%esp
  8007f9:	ff 75 20             	pushl  0x20(%ebp)
  8007fc:	53                   	push   %ebx
  8007fd:	ff 75 18             	pushl  0x18(%ebp)
  800800:	52                   	push   %edx
  800801:	50                   	push   %eax
  800802:	ff 75 0c             	pushl  0xc(%ebp)
  800805:	ff 75 08             	pushl  0x8(%ebp)
  800808:	e8 a1 ff ff ff       	call   8007ae <printnum>
  80080d:	83 c4 20             	add    $0x20,%esp
  800810:	eb 1a                	jmp    80082c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800812:	83 ec 08             	sub    $0x8,%esp
  800815:	ff 75 0c             	pushl  0xc(%ebp)
  800818:	ff 75 20             	pushl  0x20(%ebp)
  80081b:	8b 45 08             	mov    0x8(%ebp),%eax
  80081e:	ff d0                	call   *%eax
  800820:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800823:	ff 4d 1c             	decl   0x1c(%ebp)
  800826:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80082a:	7f e6                	jg     800812 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80082c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80082f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800834:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800837:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80083a:	53                   	push   %ebx
  80083b:	51                   	push   %ecx
  80083c:	52                   	push   %edx
  80083d:	50                   	push   %eax
  80083e:	e8 65 37 00 00       	call   803fa8 <__umoddi3>
  800843:	83 c4 10             	add    $0x10,%esp
  800846:	05 14 47 80 00       	add    $0x804714,%eax
  80084b:	8a 00                	mov    (%eax),%al
  80084d:	0f be c0             	movsbl %al,%eax
  800850:	83 ec 08             	sub    $0x8,%esp
  800853:	ff 75 0c             	pushl  0xc(%ebp)
  800856:	50                   	push   %eax
  800857:	8b 45 08             	mov    0x8(%ebp),%eax
  80085a:	ff d0                	call   *%eax
  80085c:	83 c4 10             	add    $0x10,%esp
}
  80085f:	90                   	nop
  800860:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800863:	c9                   	leave  
  800864:	c3                   	ret    

00800865 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800865:	55                   	push   %ebp
  800866:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800868:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80086c:	7e 1c                	jle    80088a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80086e:	8b 45 08             	mov    0x8(%ebp),%eax
  800871:	8b 00                	mov    (%eax),%eax
  800873:	8d 50 08             	lea    0x8(%eax),%edx
  800876:	8b 45 08             	mov    0x8(%ebp),%eax
  800879:	89 10                	mov    %edx,(%eax)
  80087b:	8b 45 08             	mov    0x8(%ebp),%eax
  80087e:	8b 00                	mov    (%eax),%eax
  800880:	83 e8 08             	sub    $0x8,%eax
  800883:	8b 50 04             	mov    0x4(%eax),%edx
  800886:	8b 00                	mov    (%eax),%eax
  800888:	eb 40                	jmp    8008ca <getuint+0x65>
	else if (lflag)
  80088a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80088e:	74 1e                	je     8008ae <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800890:	8b 45 08             	mov    0x8(%ebp),%eax
  800893:	8b 00                	mov    (%eax),%eax
  800895:	8d 50 04             	lea    0x4(%eax),%edx
  800898:	8b 45 08             	mov    0x8(%ebp),%eax
  80089b:	89 10                	mov    %edx,(%eax)
  80089d:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a0:	8b 00                	mov    (%eax),%eax
  8008a2:	83 e8 04             	sub    $0x4,%eax
  8008a5:	8b 00                	mov    (%eax),%eax
  8008a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ac:	eb 1c                	jmp    8008ca <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b1:	8b 00                	mov    (%eax),%eax
  8008b3:	8d 50 04             	lea    0x4(%eax),%edx
  8008b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b9:	89 10                	mov    %edx,(%eax)
  8008bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008be:	8b 00                	mov    (%eax),%eax
  8008c0:	83 e8 04             	sub    $0x4,%eax
  8008c3:	8b 00                	mov    (%eax),%eax
  8008c5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008ca:	5d                   	pop    %ebp
  8008cb:	c3                   	ret    

008008cc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008cc:	55                   	push   %ebp
  8008cd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008cf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008d3:	7e 1c                	jle    8008f1 <getint+0x25>
		return va_arg(*ap, long long);
  8008d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d8:	8b 00                	mov    (%eax),%eax
  8008da:	8d 50 08             	lea    0x8(%eax),%edx
  8008dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e0:	89 10                	mov    %edx,(%eax)
  8008e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e5:	8b 00                	mov    (%eax),%eax
  8008e7:	83 e8 08             	sub    $0x8,%eax
  8008ea:	8b 50 04             	mov    0x4(%eax),%edx
  8008ed:	8b 00                	mov    (%eax),%eax
  8008ef:	eb 38                	jmp    800929 <getint+0x5d>
	else if (lflag)
  8008f1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008f5:	74 1a                	je     800911 <getint+0x45>
		return va_arg(*ap, long);
  8008f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fa:	8b 00                	mov    (%eax),%eax
  8008fc:	8d 50 04             	lea    0x4(%eax),%edx
  8008ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800902:	89 10                	mov    %edx,(%eax)
  800904:	8b 45 08             	mov    0x8(%ebp),%eax
  800907:	8b 00                	mov    (%eax),%eax
  800909:	83 e8 04             	sub    $0x4,%eax
  80090c:	8b 00                	mov    (%eax),%eax
  80090e:	99                   	cltd   
  80090f:	eb 18                	jmp    800929 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800911:	8b 45 08             	mov    0x8(%ebp),%eax
  800914:	8b 00                	mov    (%eax),%eax
  800916:	8d 50 04             	lea    0x4(%eax),%edx
  800919:	8b 45 08             	mov    0x8(%ebp),%eax
  80091c:	89 10                	mov    %edx,(%eax)
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	8b 00                	mov    (%eax),%eax
  800923:	83 e8 04             	sub    $0x4,%eax
  800926:	8b 00                	mov    (%eax),%eax
  800928:	99                   	cltd   
}
  800929:	5d                   	pop    %ebp
  80092a:	c3                   	ret    

0080092b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80092b:	55                   	push   %ebp
  80092c:	89 e5                	mov    %esp,%ebp
  80092e:	56                   	push   %esi
  80092f:	53                   	push   %ebx
  800930:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800933:	eb 17                	jmp    80094c <vprintfmt+0x21>
			if (ch == '\0')
  800935:	85 db                	test   %ebx,%ebx
  800937:	0f 84 c1 03 00 00    	je     800cfe <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80093d:	83 ec 08             	sub    $0x8,%esp
  800940:	ff 75 0c             	pushl  0xc(%ebp)
  800943:	53                   	push   %ebx
  800944:	8b 45 08             	mov    0x8(%ebp),%eax
  800947:	ff d0                	call   *%eax
  800949:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80094c:	8b 45 10             	mov    0x10(%ebp),%eax
  80094f:	8d 50 01             	lea    0x1(%eax),%edx
  800952:	89 55 10             	mov    %edx,0x10(%ebp)
  800955:	8a 00                	mov    (%eax),%al
  800957:	0f b6 d8             	movzbl %al,%ebx
  80095a:	83 fb 25             	cmp    $0x25,%ebx
  80095d:	75 d6                	jne    800935 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80095f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800963:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80096a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800971:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800978:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80097f:	8b 45 10             	mov    0x10(%ebp),%eax
  800982:	8d 50 01             	lea    0x1(%eax),%edx
  800985:	89 55 10             	mov    %edx,0x10(%ebp)
  800988:	8a 00                	mov    (%eax),%al
  80098a:	0f b6 d8             	movzbl %al,%ebx
  80098d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800990:	83 f8 5b             	cmp    $0x5b,%eax
  800993:	0f 87 3d 03 00 00    	ja     800cd6 <vprintfmt+0x3ab>
  800999:	8b 04 85 38 47 80 00 	mov    0x804738(,%eax,4),%eax
  8009a0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009a2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009a6:	eb d7                	jmp    80097f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009a8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009ac:	eb d1                	jmp    80097f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009ae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009b8:	89 d0                	mov    %edx,%eax
  8009ba:	c1 e0 02             	shl    $0x2,%eax
  8009bd:	01 d0                	add    %edx,%eax
  8009bf:	01 c0                	add    %eax,%eax
  8009c1:	01 d8                	add    %ebx,%eax
  8009c3:	83 e8 30             	sub    $0x30,%eax
  8009c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009cc:	8a 00                	mov    (%eax),%al
  8009ce:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009d1:	83 fb 2f             	cmp    $0x2f,%ebx
  8009d4:	7e 3e                	jle    800a14 <vprintfmt+0xe9>
  8009d6:	83 fb 39             	cmp    $0x39,%ebx
  8009d9:	7f 39                	jg     800a14 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009db:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009de:	eb d5                	jmp    8009b5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e3:	83 c0 04             	add    $0x4,%eax
  8009e6:	89 45 14             	mov    %eax,0x14(%ebp)
  8009e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ec:	83 e8 04             	sub    $0x4,%eax
  8009ef:	8b 00                	mov    (%eax),%eax
  8009f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009f4:	eb 1f                	jmp    800a15 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009fa:	79 83                	jns    80097f <vprintfmt+0x54>
				width = 0;
  8009fc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a03:	e9 77 ff ff ff       	jmp    80097f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a08:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a0f:	e9 6b ff ff ff       	jmp    80097f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a14:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a15:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a19:	0f 89 60 ff ff ff    	jns    80097f <vprintfmt+0x54>
				width = precision, precision = -1;
  800a1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a22:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a25:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a2c:	e9 4e ff ff ff       	jmp    80097f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a31:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a34:	e9 46 ff ff ff       	jmp    80097f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a39:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3c:	83 c0 04             	add    $0x4,%eax
  800a3f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a42:	8b 45 14             	mov    0x14(%ebp),%eax
  800a45:	83 e8 04             	sub    $0x4,%eax
  800a48:	8b 00                	mov    (%eax),%eax
  800a4a:	83 ec 08             	sub    $0x8,%esp
  800a4d:	ff 75 0c             	pushl  0xc(%ebp)
  800a50:	50                   	push   %eax
  800a51:	8b 45 08             	mov    0x8(%ebp),%eax
  800a54:	ff d0                	call   *%eax
  800a56:	83 c4 10             	add    $0x10,%esp
			break;
  800a59:	e9 9b 02 00 00       	jmp    800cf9 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a61:	83 c0 04             	add    $0x4,%eax
  800a64:	89 45 14             	mov    %eax,0x14(%ebp)
  800a67:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6a:	83 e8 04             	sub    $0x4,%eax
  800a6d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a6f:	85 db                	test   %ebx,%ebx
  800a71:	79 02                	jns    800a75 <vprintfmt+0x14a>
				err = -err;
  800a73:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a75:	83 fb 64             	cmp    $0x64,%ebx
  800a78:	7f 0b                	jg     800a85 <vprintfmt+0x15a>
  800a7a:	8b 34 9d 80 45 80 00 	mov    0x804580(,%ebx,4),%esi
  800a81:	85 f6                	test   %esi,%esi
  800a83:	75 19                	jne    800a9e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a85:	53                   	push   %ebx
  800a86:	68 25 47 80 00       	push   $0x804725
  800a8b:	ff 75 0c             	pushl  0xc(%ebp)
  800a8e:	ff 75 08             	pushl  0x8(%ebp)
  800a91:	e8 70 02 00 00       	call   800d06 <printfmt>
  800a96:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a99:	e9 5b 02 00 00       	jmp    800cf9 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a9e:	56                   	push   %esi
  800a9f:	68 2e 47 80 00       	push   $0x80472e
  800aa4:	ff 75 0c             	pushl  0xc(%ebp)
  800aa7:	ff 75 08             	pushl  0x8(%ebp)
  800aaa:	e8 57 02 00 00       	call   800d06 <printfmt>
  800aaf:	83 c4 10             	add    $0x10,%esp
			break;
  800ab2:	e9 42 02 00 00       	jmp    800cf9 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ab7:	8b 45 14             	mov    0x14(%ebp),%eax
  800aba:	83 c0 04             	add    $0x4,%eax
  800abd:	89 45 14             	mov    %eax,0x14(%ebp)
  800ac0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac3:	83 e8 04             	sub    $0x4,%eax
  800ac6:	8b 30                	mov    (%eax),%esi
  800ac8:	85 f6                	test   %esi,%esi
  800aca:	75 05                	jne    800ad1 <vprintfmt+0x1a6>
				p = "(null)";
  800acc:	be 31 47 80 00       	mov    $0x804731,%esi
			if (width > 0 && padc != '-')
  800ad1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ad5:	7e 6d                	jle    800b44 <vprintfmt+0x219>
  800ad7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800adb:	74 67                	je     800b44 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800add:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ae0:	83 ec 08             	sub    $0x8,%esp
  800ae3:	50                   	push   %eax
  800ae4:	56                   	push   %esi
  800ae5:	e8 1e 03 00 00       	call   800e08 <strnlen>
  800aea:	83 c4 10             	add    $0x10,%esp
  800aed:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800af0:	eb 16                	jmp    800b08 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800af2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800af6:	83 ec 08             	sub    $0x8,%esp
  800af9:	ff 75 0c             	pushl  0xc(%ebp)
  800afc:	50                   	push   %eax
  800afd:	8b 45 08             	mov    0x8(%ebp),%eax
  800b00:	ff d0                	call   *%eax
  800b02:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b05:	ff 4d e4             	decl   -0x1c(%ebp)
  800b08:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b0c:	7f e4                	jg     800af2 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b0e:	eb 34                	jmp    800b44 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b10:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b14:	74 1c                	je     800b32 <vprintfmt+0x207>
  800b16:	83 fb 1f             	cmp    $0x1f,%ebx
  800b19:	7e 05                	jle    800b20 <vprintfmt+0x1f5>
  800b1b:	83 fb 7e             	cmp    $0x7e,%ebx
  800b1e:	7e 12                	jle    800b32 <vprintfmt+0x207>
					putch('?', putdat);
  800b20:	83 ec 08             	sub    $0x8,%esp
  800b23:	ff 75 0c             	pushl  0xc(%ebp)
  800b26:	6a 3f                	push   $0x3f
  800b28:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2b:	ff d0                	call   *%eax
  800b2d:	83 c4 10             	add    $0x10,%esp
  800b30:	eb 0f                	jmp    800b41 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b32:	83 ec 08             	sub    $0x8,%esp
  800b35:	ff 75 0c             	pushl  0xc(%ebp)
  800b38:	53                   	push   %ebx
  800b39:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3c:	ff d0                	call   *%eax
  800b3e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b41:	ff 4d e4             	decl   -0x1c(%ebp)
  800b44:	89 f0                	mov    %esi,%eax
  800b46:	8d 70 01             	lea    0x1(%eax),%esi
  800b49:	8a 00                	mov    (%eax),%al
  800b4b:	0f be d8             	movsbl %al,%ebx
  800b4e:	85 db                	test   %ebx,%ebx
  800b50:	74 24                	je     800b76 <vprintfmt+0x24b>
  800b52:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b56:	78 b8                	js     800b10 <vprintfmt+0x1e5>
  800b58:	ff 4d e0             	decl   -0x20(%ebp)
  800b5b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b5f:	79 af                	jns    800b10 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b61:	eb 13                	jmp    800b76 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b63:	83 ec 08             	sub    $0x8,%esp
  800b66:	ff 75 0c             	pushl  0xc(%ebp)
  800b69:	6a 20                	push   $0x20
  800b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6e:	ff d0                	call   *%eax
  800b70:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b73:	ff 4d e4             	decl   -0x1c(%ebp)
  800b76:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b7a:	7f e7                	jg     800b63 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b7c:	e9 78 01 00 00       	jmp    800cf9 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b81:	83 ec 08             	sub    $0x8,%esp
  800b84:	ff 75 e8             	pushl  -0x18(%ebp)
  800b87:	8d 45 14             	lea    0x14(%ebp),%eax
  800b8a:	50                   	push   %eax
  800b8b:	e8 3c fd ff ff       	call   8008cc <getint>
  800b90:	83 c4 10             	add    $0x10,%esp
  800b93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b96:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b9f:	85 d2                	test   %edx,%edx
  800ba1:	79 23                	jns    800bc6 <vprintfmt+0x29b>
				putch('-', putdat);
  800ba3:	83 ec 08             	sub    $0x8,%esp
  800ba6:	ff 75 0c             	pushl  0xc(%ebp)
  800ba9:	6a 2d                	push   $0x2d
  800bab:	8b 45 08             	mov    0x8(%ebp),%eax
  800bae:	ff d0                	call   *%eax
  800bb0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bb9:	f7 d8                	neg    %eax
  800bbb:	83 d2 00             	adc    $0x0,%edx
  800bbe:	f7 da                	neg    %edx
  800bc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bc3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bc6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bcd:	e9 bc 00 00 00       	jmp    800c8e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bd2:	83 ec 08             	sub    $0x8,%esp
  800bd5:	ff 75 e8             	pushl  -0x18(%ebp)
  800bd8:	8d 45 14             	lea    0x14(%ebp),%eax
  800bdb:	50                   	push   %eax
  800bdc:	e8 84 fc ff ff       	call   800865 <getuint>
  800be1:	83 c4 10             	add    $0x10,%esp
  800be4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bea:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bf1:	e9 98 00 00 00       	jmp    800c8e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800bf6:	83 ec 08             	sub    $0x8,%esp
  800bf9:	ff 75 0c             	pushl  0xc(%ebp)
  800bfc:	6a 58                	push   $0x58
  800bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800c01:	ff d0                	call   *%eax
  800c03:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c06:	83 ec 08             	sub    $0x8,%esp
  800c09:	ff 75 0c             	pushl  0xc(%ebp)
  800c0c:	6a 58                	push   $0x58
  800c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c11:	ff d0                	call   *%eax
  800c13:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c16:	83 ec 08             	sub    $0x8,%esp
  800c19:	ff 75 0c             	pushl  0xc(%ebp)
  800c1c:	6a 58                	push   $0x58
  800c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c21:	ff d0                	call   *%eax
  800c23:	83 c4 10             	add    $0x10,%esp
			break;
  800c26:	e9 ce 00 00 00       	jmp    800cf9 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c2b:	83 ec 08             	sub    $0x8,%esp
  800c2e:	ff 75 0c             	pushl  0xc(%ebp)
  800c31:	6a 30                	push   $0x30
  800c33:	8b 45 08             	mov    0x8(%ebp),%eax
  800c36:	ff d0                	call   *%eax
  800c38:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c3b:	83 ec 08             	sub    $0x8,%esp
  800c3e:	ff 75 0c             	pushl  0xc(%ebp)
  800c41:	6a 78                	push   $0x78
  800c43:	8b 45 08             	mov    0x8(%ebp),%eax
  800c46:	ff d0                	call   *%eax
  800c48:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c4b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c4e:	83 c0 04             	add    $0x4,%eax
  800c51:	89 45 14             	mov    %eax,0x14(%ebp)
  800c54:	8b 45 14             	mov    0x14(%ebp),%eax
  800c57:	83 e8 04             	sub    $0x4,%eax
  800c5a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c5f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c66:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c6d:	eb 1f                	jmp    800c8e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c6f:	83 ec 08             	sub    $0x8,%esp
  800c72:	ff 75 e8             	pushl  -0x18(%ebp)
  800c75:	8d 45 14             	lea    0x14(%ebp),%eax
  800c78:	50                   	push   %eax
  800c79:	e8 e7 fb ff ff       	call   800865 <getuint>
  800c7e:	83 c4 10             	add    $0x10,%esp
  800c81:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c84:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c87:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c8e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c95:	83 ec 04             	sub    $0x4,%esp
  800c98:	52                   	push   %edx
  800c99:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c9c:	50                   	push   %eax
  800c9d:	ff 75 f4             	pushl  -0xc(%ebp)
  800ca0:	ff 75 f0             	pushl  -0x10(%ebp)
  800ca3:	ff 75 0c             	pushl  0xc(%ebp)
  800ca6:	ff 75 08             	pushl  0x8(%ebp)
  800ca9:	e8 00 fb ff ff       	call   8007ae <printnum>
  800cae:	83 c4 20             	add    $0x20,%esp
			break;
  800cb1:	eb 46                	jmp    800cf9 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cb3:	83 ec 08             	sub    $0x8,%esp
  800cb6:	ff 75 0c             	pushl  0xc(%ebp)
  800cb9:	53                   	push   %ebx
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	ff d0                	call   *%eax
  800cbf:	83 c4 10             	add    $0x10,%esp
			break;
  800cc2:	eb 35                	jmp    800cf9 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800cc4:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
			break;
  800ccb:	eb 2c                	jmp    800cf9 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800ccd:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
			break;
  800cd4:	eb 23                	jmp    800cf9 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cd6:	83 ec 08             	sub    $0x8,%esp
  800cd9:	ff 75 0c             	pushl  0xc(%ebp)
  800cdc:	6a 25                	push   $0x25
  800cde:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce1:	ff d0                	call   *%eax
  800ce3:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ce6:	ff 4d 10             	decl   0x10(%ebp)
  800ce9:	eb 03                	jmp    800cee <vprintfmt+0x3c3>
  800ceb:	ff 4d 10             	decl   0x10(%ebp)
  800cee:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf1:	48                   	dec    %eax
  800cf2:	8a 00                	mov    (%eax),%al
  800cf4:	3c 25                	cmp    $0x25,%al
  800cf6:	75 f3                	jne    800ceb <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800cf8:	90                   	nop
		}
	}
  800cf9:	e9 35 fc ff ff       	jmp    800933 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800cfe:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800cff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d02:	5b                   	pop    %ebx
  800d03:	5e                   	pop    %esi
  800d04:	5d                   	pop    %ebp
  800d05:	c3                   	ret    

00800d06 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
  800d09:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d0c:	8d 45 10             	lea    0x10(%ebp),%eax
  800d0f:	83 c0 04             	add    $0x4,%eax
  800d12:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d15:	8b 45 10             	mov    0x10(%ebp),%eax
  800d18:	ff 75 f4             	pushl  -0xc(%ebp)
  800d1b:	50                   	push   %eax
  800d1c:	ff 75 0c             	pushl  0xc(%ebp)
  800d1f:	ff 75 08             	pushl  0x8(%ebp)
  800d22:	e8 04 fc ff ff       	call   80092b <vprintfmt>
  800d27:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d2a:	90                   	nop
  800d2b:	c9                   	leave  
  800d2c:	c3                   	ret    

00800d2d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d2d:	55                   	push   %ebp
  800d2e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d33:	8b 40 08             	mov    0x8(%eax),%eax
  800d36:	8d 50 01             	lea    0x1(%eax),%edx
  800d39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d42:	8b 10                	mov    (%eax),%edx
  800d44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d47:	8b 40 04             	mov    0x4(%eax),%eax
  800d4a:	39 c2                	cmp    %eax,%edx
  800d4c:	73 12                	jae    800d60 <sprintputch+0x33>
		*b->buf++ = ch;
  800d4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d51:	8b 00                	mov    (%eax),%eax
  800d53:	8d 48 01             	lea    0x1(%eax),%ecx
  800d56:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d59:	89 0a                	mov    %ecx,(%edx)
  800d5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5e:	88 10                	mov    %dl,(%eax)
}
  800d60:	90                   	nop
  800d61:	5d                   	pop    %ebp
  800d62:	c3                   	ret    

00800d63 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d63:	55                   	push   %ebp
  800d64:	89 e5                	mov    %esp,%ebp
  800d66:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d69:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d72:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d75:	8b 45 08             	mov    0x8(%ebp),%eax
  800d78:	01 d0                	add    %edx,%eax
  800d7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d84:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d88:	74 06                	je     800d90 <vsnprintf+0x2d>
  800d8a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d8e:	7f 07                	jg     800d97 <vsnprintf+0x34>
		return -E_INVAL;
  800d90:	b8 03 00 00 00       	mov    $0x3,%eax
  800d95:	eb 20                	jmp    800db7 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d97:	ff 75 14             	pushl  0x14(%ebp)
  800d9a:	ff 75 10             	pushl  0x10(%ebp)
  800d9d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800da0:	50                   	push   %eax
  800da1:	68 2d 0d 80 00       	push   $0x800d2d
  800da6:	e8 80 fb ff ff       	call   80092b <vprintfmt>
  800dab:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800db1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800db7:	c9                   	leave  
  800db8:	c3                   	ret    

00800db9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800db9:	55                   	push   %ebp
  800dba:	89 e5                	mov    %esp,%ebp
  800dbc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800dbf:	8d 45 10             	lea    0x10(%ebp),%eax
  800dc2:	83 c0 04             	add    $0x4,%eax
  800dc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800dc8:	8b 45 10             	mov    0x10(%ebp),%eax
  800dcb:	ff 75 f4             	pushl  -0xc(%ebp)
  800dce:	50                   	push   %eax
  800dcf:	ff 75 0c             	pushl  0xc(%ebp)
  800dd2:	ff 75 08             	pushl  0x8(%ebp)
  800dd5:	e8 89 ff ff ff       	call   800d63 <vsnprintf>
  800dda:	83 c4 10             	add    $0x10,%esp
  800ddd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800de0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800de3:	c9                   	leave  
  800de4:	c3                   	ret    

00800de5 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800de5:	55                   	push   %ebp
  800de6:	89 e5                	mov    %esp,%ebp
  800de8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800deb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800df2:	eb 06                	jmp    800dfa <strlen+0x15>
		n++;
  800df4:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800df7:	ff 45 08             	incl   0x8(%ebp)
  800dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfd:	8a 00                	mov    (%eax),%al
  800dff:	84 c0                	test   %al,%al
  800e01:	75 f1                	jne    800df4 <strlen+0xf>
		n++;
	return n;
  800e03:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e06:	c9                   	leave  
  800e07:	c3                   	ret    

00800e08 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e08:	55                   	push   %ebp
  800e09:	89 e5                	mov    %esp,%ebp
  800e0b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e0e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e15:	eb 09                	jmp    800e20 <strnlen+0x18>
		n++;
  800e17:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e1a:	ff 45 08             	incl   0x8(%ebp)
  800e1d:	ff 4d 0c             	decl   0xc(%ebp)
  800e20:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e24:	74 09                	je     800e2f <strnlen+0x27>
  800e26:	8b 45 08             	mov    0x8(%ebp),%eax
  800e29:	8a 00                	mov    (%eax),%al
  800e2b:	84 c0                	test   %al,%al
  800e2d:	75 e8                	jne    800e17 <strnlen+0xf>
		n++;
	return n;
  800e2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e32:	c9                   	leave  
  800e33:	c3                   	ret    

00800e34 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e34:	55                   	push   %ebp
  800e35:	89 e5                	mov    %esp,%ebp
  800e37:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e40:	90                   	nop
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
  800e44:	8d 50 01             	lea    0x1(%eax),%edx
  800e47:	89 55 08             	mov    %edx,0x8(%ebp)
  800e4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e4d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e50:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e53:	8a 12                	mov    (%edx),%dl
  800e55:	88 10                	mov    %dl,(%eax)
  800e57:	8a 00                	mov    (%eax),%al
  800e59:	84 c0                	test   %al,%al
  800e5b:	75 e4                	jne    800e41 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e60:	c9                   	leave  
  800e61:	c3                   	ret    

00800e62 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e62:	55                   	push   %ebp
  800e63:	89 e5                	mov    %esp,%ebp
  800e65:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e68:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e6e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e75:	eb 1f                	jmp    800e96 <strncpy+0x34>
		*dst++ = *src;
  800e77:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7a:	8d 50 01             	lea    0x1(%eax),%edx
  800e7d:	89 55 08             	mov    %edx,0x8(%ebp)
  800e80:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e83:	8a 12                	mov    (%edx),%dl
  800e85:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8a:	8a 00                	mov    (%eax),%al
  800e8c:	84 c0                	test   %al,%al
  800e8e:	74 03                	je     800e93 <strncpy+0x31>
			src++;
  800e90:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e93:	ff 45 fc             	incl   -0x4(%ebp)
  800e96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e99:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e9c:	72 d9                	jb     800e77 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ea1:	c9                   	leave  
  800ea2:	c3                   	ret    

00800ea3 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800eaf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb3:	74 30                	je     800ee5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800eb5:	eb 16                	jmp    800ecd <strlcpy+0x2a>
			*dst++ = *src++;
  800eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eba:	8d 50 01             	lea    0x1(%eax),%edx
  800ebd:	89 55 08             	mov    %edx,0x8(%ebp)
  800ec0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ec6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ec9:	8a 12                	mov    (%edx),%dl
  800ecb:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ecd:	ff 4d 10             	decl   0x10(%ebp)
  800ed0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed4:	74 09                	je     800edf <strlcpy+0x3c>
  800ed6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed9:	8a 00                	mov    (%eax),%al
  800edb:	84 c0                	test   %al,%al
  800edd:	75 d8                	jne    800eb7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800edf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ee5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eeb:	29 c2                	sub    %eax,%edx
  800eed:	89 d0                	mov    %edx,%eax
}
  800eef:	c9                   	leave  
  800ef0:	c3                   	ret    

00800ef1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ef1:	55                   	push   %ebp
  800ef2:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ef4:	eb 06                	jmp    800efc <strcmp+0xb>
		p++, q++;
  800ef6:	ff 45 08             	incl   0x8(%ebp)
  800ef9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800efc:	8b 45 08             	mov    0x8(%ebp),%eax
  800eff:	8a 00                	mov    (%eax),%al
  800f01:	84 c0                	test   %al,%al
  800f03:	74 0e                	je     800f13 <strcmp+0x22>
  800f05:	8b 45 08             	mov    0x8(%ebp),%eax
  800f08:	8a 10                	mov    (%eax),%dl
  800f0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0d:	8a 00                	mov    (%eax),%al
  800f0f:	38 c2                	cmp    %al,%dl
  800f11:	74 e3                	je     800ef6 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
  800f16:	8a 00                	mov    (%eax),%al
  800f18:	0f b6 d0             	movzbl %al,%edx
  800f1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1e:	8a 00                	mov    (%eax),%al
  800f20:	0f b6 c0             	movzbl %al,%eax
  800f23:	29 c2                	sub    %eax,%edx
  800f25:	89 d0                	mov    %edx,%eax
}
  800f27:	5d                   	pop    %ebp
  800f28:	c3                   	ret    

00800f29 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f29:	55                   	push   %ebp
  800f2a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f2c:	eb 09                	jmp    800f37 <strncmp+0xe>
		n--, p++, q++;
  800f2e:	ff 4d 10             	decl   0x10(%ebp)
  800f31:	ff 45 08             	incl   0x8(%ebp)
  800f34:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f37:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f3b:	74 17                	je     800f54 <strncmp+0x2b>
  800f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f40:	8a 00                	mov    (%eax),%al
  800f42:	84 c0                	test   %al,%al
  800f44:	74 0e                	je     800f54 <strncmp+0x2b>
  800f46:	8b 45 08             	mov    0x8(%ebp),%eax
  800f49:	8a 10                	mov    (%eax),%dl
  800f4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4e:	8a 00                	mov    (%eax),%al
  800f50:	38 c2                	cmp    %al,%dl
  800f52:	74 da                	je     800f2e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f54:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f58:	75 07                	jne    800f61 <strncmp+0x38>
		return 0;
  800f5a:	b8 00 00 00 00       	mov    $0x0,%eax
  800f5f:	eb 14                	jmp    800f75 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
  800f64:	8a 00                	mov    (%eax),%al
  800f66:	0f b6 d0             	movzbl %al,%edx
  800f69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6c:	8a 00                	mov    (%eax),%al
  800f6e:	0f b6 c0             	movzbl %al,%eax
  800f71:	29 c2                	sub    %eax,%edx
  800f73:	89 d0                	mov    %edx,%eax
}
  800f75:	5d                   	pop    %ebp
  800f76:	c3                   	ret    

00800f77 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f77:	55                   	push   %ebp
  800f78:	89 e5                	mov    %esp,%ebp
  800f7a:	83 ec 04             	sub    $0x4,%esp
  800f7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f80:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f83:	eb 12                	jmp    800f97 <strchr+0x20>
		if (*s == c)
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
  800f88:	8a 00                	mov    (%eax),%al
  800f8a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f8d:	75 05                	jne    800f94 <strchr+0x1d>
			return (char *) s;
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	eb 11                	jmp    800fa5 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f94:	ff 45 08             	incl   0x8(%ebp)
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	8a 00                	mov    (%eax),%al
  800f9c:	84 c0                	test   %al,%al
  800f9e:	75 e5                	jne    800f85 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fa0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fa5:	c9                   	leave  
  800fa6:	c3                   	ret    

00800fa7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fa7:	55                   	push   %ebp
  800fa8:	89 e5                	mov    %esp,%ebp
  800faa:	83 ec 04             	sub    $0x4,%esp
  800fad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fb3:	eb 0d                	jmp    800fc2 <strfind+0x1b>
		if (*s == c)
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fbd:	74 0e                	je     800fcd <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fbf:	ff 45 08             	incl   0x8(%ebp)
  800fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc5:	8a 00                	mov    (%eax),%al
  800fc7:	84 c0                	test   %al,%al
  800fc9:	75 ea                	jne    800fb5 <strfind+0xe>
  800fcb:	eb 01                	jmp    800fce <strfind+0x27>
		if (*s == c)
			break;
  800fcd:	90                   	nop
	return (char *) s;
  800fce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fd1:	c9                   	leave  
  800fd2:	c3                   	ret    

00800fd3 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800fd3:	55                   	push   %ebp
  800fd4:	89 e5                	mov    %esp,%ebp
  800fd6:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800fdf:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800fe3:	76 63                	jbe    801048 <memset+0x75>
		uint64 data_block = c;
  800fe5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe8:	99                   	cltd   
  800fe9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fec:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ff2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ff5:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800ff9:	c1 e0 08             	shl    $0x8,%eax
  800ffc:	09 45 f0             	or     %eax,-0x10(%ebp)
  800fff:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801002:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801005:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801008:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80100c:	c1 e0 10             	shl    $0x10,%eax
  80100f:	09 45 f0             	or     %eax,-0x10(%ebp)
  801012:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801015:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801018:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80101b:	89 c2                	mov    %eax,%edx
  80101d:	b8 00 00 00 00       	mov    $0x0,%eax
  801022:	09 45 f0             	or     %eax,-0x10(%ebp)
  801025:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801028:	eb 18                	jmp    801042 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80102a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80102d:	8d 41 08             	lea    0x8(%ecx),%eax
  801030:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801033:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801036:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801039:	89 01                	mov    %eax,(%ecx)
  80103b:	89 51 04             	mov    %edx,0x4(%ecx)
  80103e:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801042:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801046:	77 e2                	ja     80102a <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801048:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80104c:	74 23                	je     801071 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  80104e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801051:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801054:	eb 0e                	jmp    801064 <memset+0x91>
			*p8++ = (uint8)c;
  801056:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801059:	8d 50 01             	lea    0x1(%eax),%edx
  80105c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80105f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801062:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801064:	8b 45 10             	mov    0x10(%ebp),%eax
  801067:	8d 50 ff             	lea    -0x1(%eax),%edx
  80106a:	89 55 10             	mov    %edx,0x10(%ebp)
  80106d:	85 c0                	test   %eax,%eax
  80106f:	75 e5                	jne    801056 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801071:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801074:	c9                   	leave  
  801075:	c3                   	ret    

00801076 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801076:	55                   	push   %ebp
  801077:	89 e5                	mov    %esp,%ebp
  801079:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80107c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801088:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80108c:	76 24                	jbe    8010b2 <memcpy+0x3c>
		while(n >= 8){
  80108e:	eb 1c                	jmp    8010ac <memcpy+0x36>
			*d64 = *s64;
  801090:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801093:	8b 50 04             	mov    0x4(%eax),%edx
  801096:	8b 00                	mov    (%eax),%eax
  801098:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80109b:	89 01                	mov    %eax,(%ecx)
  80109d:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8010a0:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8010a4:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8010a8:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8010ac:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010b0:	77 de                	ja     801090 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8010b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010b6:	74 31                	je     8010e9 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8010b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8010be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8010c4:	eb 16                	jmp    8010dc <memcpy+0x66>
			*d8++ = *s8++;
  8010c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010c9:	8d 50 01             	lea    0x1(%eax),%edx
  8010cc:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8010cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010d2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010d5:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8010d8:	8a 12                	mov    (%edx),%dl
  8010da:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8010dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8010df:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010e2:	89 55 10             	mov    %edx,0x10(%ebp)
  8010e5:	85 c0                	test   %eax,%eax
  8010e7:	75 dd                	jne    8010c6 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8010e9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010ec:	c9                   	leave  
  8010ed:	c3                   	ret    

008010ee <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010ee:	55                   	push   %ebp
  8010ef:	89 e5                	mov    %esp,%ebp
  8010f1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801100:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801103:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801106:	73 50                	jae    801158 <memmove+0x6a>
  801108:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80110b:	8b 45 10             	mov    0x10(%ebp),%eax
  80110e:	01 d0                	add    %edx,%eax
  801110:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801113:	76 43                	jbe    801158 <memmove+0x6a>
		s += n;
  801115:	8b 45 10             	mov    0x10(%ebp),%eax
  801118:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80111b:	8b 45 10             	mov    0x10(%ebp),%eax
  80111e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801121:	eb 10                	jmp    801133 <memmove+0x45>
			*--d = *--s;
  801123:	ff 4d f8             	decl   -0x8(%ebp)
  801126:	ff 4d fc             	decl   -0x4(%ebp)
  801129:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80112c:	8a 10                	mov    (%eax),%dl
  80112e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801131:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801133:	8b 45 10             	mov    0x10(%ebp),%eax
  801136:	8d 50 ff             	lea    -0x1(%eax),%edx
  801139:	89 55 10             	mov    %edx,0x10(%ebp)
  80113c:	85 c0                	test   %eax,%eax
  80113e:	75 e3                	jne    801123 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801140:	eb 23                	jmp    801165 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801142:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801145:	8d 50 01             	lea    0x1(%eax),%edx
  801148:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80114b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80114e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801151:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801154:	8a 12                	mov    (%edx),%dl
  801156:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801158:	8b 45 10             	mov    0x10(%ebp),%eax
  80115b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80115e:	89 55 10             	mov    %edx,0x10(%ebp)
  801161:	85 c0                	test   %eax,%eax
  801163:	75 dd                	jne    801142 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801165:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801168:	c9                   	leave  
  801169:	c3                   	ret    

0080116a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80116a:	55                   	push   %ebp
  80116b:	89 e5                	mov    %esp,%ebp
  80116d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801170:	8b 45 08             	mov    0x8(%ebp),%eax
  801173:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801176:	8b 45 0c             	mov    0xc(%ebp),%eax
  801179:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80117c:	eb 2a                	jmp    8011a8 <memcmp+0x3e>
		if (*s1 != *s2)
  80117e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801181:	8a 10                	mov    (%eax),%dl
  801183:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801186:	8a 00                	mov    (%eax),%al
  801188:	38 c2                	cmp    %al,%dl
  80118a:	74 16                	je     8011a2 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80118c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80118f:	8a 00                	mov    (%eax),%al
  801191:	0f b6 d0             	movzbl %al,%edx
  801194:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801197:	8a 00                	mov    (%eax),%al
  801199:	0f b6 c0             	movzbl %al,%eax
  80119c:	29 c2                	sub    %eax,%edx
  80119e:	89 d0                	mov    %edx,%eax
  8011a0:	eb 18                	jmp    8011ba <memcmp+0x50>
		s1++, s2++;
  8011a2:	ff 45 fc             	incl   -0x4(%ebp)
  8011a5:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ab:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011ae:	89 55 10             	mov    %edx,0x10(%ebp)
  8011b1:	85 c0                	test   %eax,%eax
  8011b3:	75 c9                	jne    80117e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011ba:	c9                   	leave  
  8011bb:	c3                   	ret    

008011bc <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011bc:	55                   	push   %ebp
  8011bd:	89 e5                	mov    %esp,%ebp
  8011bf:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c8:	01 d0                	add    %edx,%eax
  8011ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011cd:	eb 15                	jmp    8011e4 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	8a 00                	mov    (%eax),%al
  8011d4:	0f b6 d0             	movzbl %al,%edx
  8011d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011da:	0f b6 c0             	movzbl %al,%eax
  8011dd:	39 c2                	cmp    %eax,%edx
  8011df:	74 0d                	je     8011ee <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011e1:	ff 45 08             	incl   0x8(%ebp)
  8011e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011ea:	72 e3                	jb     8011cf <memfind+0x13>
  8011ec:	eb 01                	jmp    8011ef <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011ee:	90                   	nop
	return (void *) s;
  8011ef:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011f2:	c9                   	leave  
  8011f3:	c3                   	ret    

008011f4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011f4:	55                   	push   %ebp
  8011f5:	89 e5                	mov    %esp,%ebp
  8011f7:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801201:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801208:	eb 03                	jmp    80120d <strtol+0x19>
		s++;
  80120a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80120d:	8b 45 08             	mov    0x8(%ebp),%eax
  801210:	8a 00                	mov    (%eax),%al
  801212:	3c 20                	cmp    $0x20,%al
  801214:	74 f4                	je     80120a <strtol+0x16>
  801216:	8b 45 08             	mov    0x8(%ebp),%eax
  801219:	8a 00                	mov    (%eax),%al
  80121b:	3c 09                	cmp    $0x9,%al
  80121d:	74 eb                	je     80120a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80121f:	8b 45 08             	mov    0x8(%ebp),%eax
  801222:	8a 00                	mov    (%eax),%al
  801224:	3c 2b                	cmp    $0x2b,%al
  801226:	75 05                	jne    80122d <strtol+0x39>
		s++;
  801228:	ff 45 08             	incl   0x8(%ebp)
  80122b:	eb 13                	jmp    801240 <strtol+0x4c>
	else if (*s == '-')
  80122d:	8b 45 08             	mov    0x8(%ebp),%eax
  801230:	8a 00                	mov    (%eax),%al
  801232:	3c 2d                	cmp    $0x2d,%al
  801234:	75 0a                	jne    801240 <strtol+0x4c>
		s++, neg = 1;
  801236:	ff 45 08             	incl   0x8(%ebp)
  801239:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801240:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801244:	74 06                	je     80124c <strtol+0x58>
  801246:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80124a:	75 20                	jne    80126c <strtol+0x78>
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	8a 00                	mov    (%eax),%al
  801251:	3c 30                	cmp    $0x30,%al
  801253:	75 17                	jne    80126c <strtol+0x78>
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	40                   	inc    %eax
  801259:	8a 00                	mov    (%eax),%al
  80125b:	3c 78                	cmp    $0x78,%al
  80125d:	75 0d                	jne    80126c <strtol+0x78>
		s += 2, base = 16;
  80125f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801263:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80126a:	eb 28                	jmp    801294 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80126c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801270:	75 15                	jne    801287 <strtol+0x93>
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
  801275:	8a 00                	mov    (%eax),%al
  801277:	3c 30                	cmp    $0x30,%al
  801279:	75 0c                	jne    801287 <strtol+0x93>
		s++, base = 8;
  80127b:	ff 45 08             	incl   0x8(%ebp)
  80127e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801285:	eb 0d                	jmp    801294 <strtol+0xa0>
	else if (base == 0)
  801287:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80128b:	75 07                	jne    801294 <strtol+0xa0>
		base = 10;
  80128d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801294:	8b 45 08             	mov    0x8(%ebp),%eax
  801297:	8a 00                	mov    (%eax),%al
  801299:	3c 2f                	cmp    $0x2f,%al
  80129b:	7e 19                	jle    8012b6 <strtol+0xc2>
  80129d:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a0:	8a 00                	mov    (%eax),%al
  8012a2:	3c 39                	cmp    $0x39,%al
  8012a4:	7f 10                	jg     8012b6 <strtol+0xc2>
			dig = *s - '0';
  8012a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a9:	8a 00                	mov    (%eax),%al
  8012ab:	0f be c0             	movsbl %al,%eax
  8012ae:	83 e8 30             	sub    $0x30,%eax
  8012b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012b4:	eb 42                	jmp    8012f8 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b9:	8a 00                	mov    (%eax),%al
  8012bb:	3c 60                	cmp    $0x60,%al
  8012bd:	7e 19                	jle    8012d8 <strtol+0xe4>
  8012bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c2:	8a 00                	mov    (%eax),%al
  8012c4:	3c 7a                	cmp    $0x7a,%al
  8012c6:	7f 10                	jg     8012d8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cb:	8a 00                	mov    (%eax),%al
  8012cd:	0f be c0             	movsbl %al,%eax
  8012d0:	83 e8 57             	sub    $0x57,%eax
  8012d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012d6:	eb 20                	jmp    8012f8 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012db:	8a 00                	mov    (%eax),%al
  8012dd:	3c 40                	cmp    $0x40,%al
  8012df:	7e 39                	jle    80131a <strtol+0x126>
  8012e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e4:	8a 00                	mov    (%eax),%al
  8012e6:	3c 5a                	cmp    $0x5a,%al
  8012e8:	7f 30                	jg     80131a <strtol+0x126>
			dig = *s - 'A' + 10;
  8012ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ed:	8a 00                	mov    (%eax),%al
  8012ef:	0f be c0             	movsbl %al,%eax
  8012f2:	83 e8 37             	sub    $0x37,%eax
  8012f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012fb:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012fe:	7d 19                	jge    801319 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801300:	ff 45 08             	incl   0x8(%ebp)
  801303:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801306:	0f af 45 10          	imul   0x10(%ebp),%eax
  80130a:	89 c2                	mov    %eax,%edx
  80130c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80130f:	01 d0                	add    %edx,%eax
  801311:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801314:	e9 7b ff ff ff       	jmp    801294 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801319:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80131a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80131e:	74 08                	je     801328 <strtol+0x134>
		*endptr = (char *) s;
  801320:	8b 45 0c             	mov    0xc(%ebp),%eax
  801323:	8b 55 08             	mov    0x8(%ebp),%edx
  801326:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801328:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80132c:	74 07                	je     801335 <strtol+0x141>
  80132e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801331:	f7 d8                	neg    %eax
  801333:	eb 03                	jmp    801338 <strtol+0x144>
  801335:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801338:	c9                   	leave  
  801339:	c3                   	ret    

0080133a <ltostr>:

void
ltostr(long value, char *str)
{
  80133a:	55                   	push   %ebp
  80133b:	89 e5                	mov    %esp,%ebp
  80133d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801340:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801347:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80134e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801352:	79 13                	jns    801367 <ltostr+0x2d>
	{
		neg = 1;
  801354:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80135b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801361:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801364:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
  80136a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80136f:	99                   	cltd   
  801370:	f7 f9                	idiv   %ecx
  801372:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801375:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801378:	8d 50 01             	lea    0x1(%eax),%edx
  80137b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80137e:	89 c2                	mov    %eax,%edx
  801380:	8b 45 0c             	mov    0xc(%ebp),%eax
  801383:	01 d0                	add    %edx,%eax
  801385:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801388:	83 c2 30             	add    $0x30,%edx
  80138b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80138d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801390:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801395:	f7 e9                	imul   %ecx
  801397:	c1 fa 02             	sar    $0x2,%edx
  80139a:	89 c8                	mov    %ecx,%eax
  80139c:	c1 f8 1f             	sar    $0x1f,%eax
  80139f:	29 c2                	sub    %eax,%edx
  8013a1:	89 d0                	mov    %edx,%eax
  8013a3:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013aa:	75 bb                	jne    801367 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013b6:	48                   	dec    %eax
  8013b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013be:	74 3d                	je     8013fd <ltostr+0xc3>
		start = 1 ;
  8013c0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013c7:	eb 34                	jmp    8013fd <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8013c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cf:	01 d0                	add    %edx,%eax
  8013d1:	8a 00                	mov    (%eax),%al
  8013d3:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013dc:	01 c2                	add    %eax,%edx
  8013de:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e4:	01 c8                	add    %ecx,%eax
  8013e6:	8a 00                	mov    (%eax),%al
  8013e8:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f0:	01 c2                	add    %eax,%edx
  8013f2:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013f5:	88 02                	mov    %al,(%edx)
		start++ ;
  8013f7:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013fa:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801400:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801403:	7c c4                	jl     8013c9 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801405:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801408:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140b:	01 d0                	add    %edx,%eax
  80140d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801410:	90                   	nop
  801411:	c9                   	leave  
  801412:	c3                   	ret    

00801413 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801413:	55                   	push   %ebp
  801414:	89 e5                	mov    %esp,%ebp
  801416:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801419:	ff 75 08             	pushl  0x8(%ebp)
  80141c:	e8 c4 f9 ff ff       	call   800de5 <strlen>
  801421:	83 c4 04             	add    $0x4,%esp
  801424:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801427:	ff 75 0c             	pushl  0xc(%ebp)
  80142a:	e8 b6 f9 ff ff       	call   800de5 <strlen>
  80142f:	83 c4 04             	add    $0x4,%esp
  801432:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801435:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80143c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801443:	eb 17                	jmp    80145c <strcconcat+0x49>
		final[s] = str1[s] ;
  801445:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801448:	8b 45 10             	mov    0x10(%ebp),%eax
  80144b:	01 c2                	add    %eax,%edx
  80144d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801450:	8b 45 08             	mov    0x8(%ebp),%eax
  801453:	01 c8                	add    %ecx,%eax
  801455:	8a 00                	mov    (%eax),%al
  801457:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801459:	ff 45 fc             	incl   -0x4(%ebp)
  80145c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80145f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801462:	7c e1                	jl     801445 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801464:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80146b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801472:	eb 1f                	jmp    801493 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801474:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801477:	8d 50 01             	lea    0x1(%eax),%edx
  80147a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80147d:	89 c2                	mov    %eax,%edx
  80147f:	8b 45 10             	mov    0x10(%ebp),%eax
  801482:	01 c2                	add    %eax,%edx
  801484:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801487:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148a:	01 c8                	add    %ecx,%eax
  80148c:	8a 00                	mov    (%eax),%al
  80148e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801490:	ff 45 f8             	incl   -0x8(%ebp)
  801493:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801496:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801499:	7c d9                	jl     801474 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80149b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80149e:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a1:	01 d0                	add    %edx,%eax
  8014a3:	c6 00 00             	movb   $0x0,(%eax)
}
  8014a6:	90                   	nop
  8014a7:	c9                   	leave  
  8014a8:	c3                   	ret    

008014a9 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014a9:	55                   	push   %ebp
  8014aa:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8014af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8014b8:	8b 00                	mov    (%eax),%eax
  8014ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c4:	01 d0                	add    %edx,%eax
  8014c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014cc:	eb 0c                	jmp    8014da <strsplit+0x31>
			*string++ = 0;
  8014ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d1:	8d 50 01             	lea    0x1(%eax),%edx
  8014d4:	89 55 08             	mov    %edx,0x8(%ebp)
  8014d7:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014da:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dd:	8a 00                	mov    (%eax),%al
  8014df:	84 c0                	test   %al,%al
  8014e1:	74 18                	je     8014fb <strsplit+0x52>
  8014e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e6:	8a 00                	mov    (%eax),%al
  8014e8:	0f be c0             	movsbl %al,%eax
  8014eb:	50                   	push   %eax
  8014ec:	ff 75 0c             	pushl  0xc(%ebp)
  8014ef:	e8 83 fa ff ff       	call   800f77 <strchr>
  8014f4:	83 c4 08             	add    $0x8,%esp
  8014f7:	85 c0                	test   %eax,%eax
  8014f9:	75 d3                	jne    8014ce <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fe:	8a 00                	mov    (%eax),%al
  801500:	84 c0                	test   %al,%al
  801502:	74 5a                	je     80155e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801504:	8b 45 14             	mov    0x14(%ebp),%eax
  801507:	8b 00                	mov    (%eax),%eax
  801509:	83 f8 0f             	cmp    $0xf,%eax
  80150c:	75 07                	jne    801515 <strsplit+0x6c>
		{
			return 0;
  80150e:	b8 00 00 00 00       	mov    $0x0,%eax
  801513:	eb 66                	jmp    80157b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801515:	8b 45 14             	mov    0x14(%ebp),%eax
  801518:	8b 00                	mov    (%eax),%eax
  80151a:	8d 48 01             	lea    0x1(%eax),%ecx
  80151d:	8b 55 14             	mov    0x14(%ebp),%edx
  801520:	89 0a                	mov    %ecx,(%edx)
  801522:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801529:	8b 45 10             	mov    0x10(%ebp),%eax
  80152c:	01 c2                	add    %eax,%edx
  80152e:	8b 45 08             	mov    0x8(%ebp),%eax
  801531:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801533:	eb 03                	jmp    801538 <strsplit+0x8f>
			string++;
  801535:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801538:	8b 45 08             	mov    0x8(%ebp),%eax
  80153b:	8a 00                	mov    (%eax),%al
  80153d:	84 c0                	test   %al,%al
  80153f:	74 8b                	je     8014cc <strsplit+0x23>
  801541:	8b 45 08             	mov    0x8(%ebp),%eax
  801544:	8a 00                	mov    (%eax),%al
  801546:	0f be c0             	movsbl %al,%eax
  801549:	50                   	push   %eax
  80154a:	ff 75 0c             	pushl  0xc(%ebp)
  80154d:	e8 25 fa ff ff       	call   800f77 <strchr>
  801552:	83 c4 08             	add    $0x8,%esp
  801555:	85 c0                	test   %eax,%eax
  801557:	74 dc                	je     801535 <strsplit+0x8c>
			string++;
	}
  801559:	e9 6e ff ff ff       	jmp    8014cc <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80155e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80155f:	8b 45 14             	mov    0x14(%ebp),%eax
  801562:	8b 00                	mov    (%eax),%eax
  801564:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80156b:	8b 45 10             	mov    0x10(%ebp),%eax
  80156e:	01 d0                	add    %edx,%eax
  801570:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801576:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80157b:	c9                   	leave  
  80157c:	c3                   	ret    

0080157d <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80157d:	55                   	push   %ebp
  80157e:	89 e5                	mov    %esp,%ebp
  801580:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801583:	8b 45 08             	mov    0x8(%ebp),%eax
  801586:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801589:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801590:	eb 4a                	jmp    8015dc <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801592:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801595:	8b 45 08             	mov    0x8(%ebp),%eax
  801598:	01 c2                	add    %eax,%edx
  80159a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80159d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a0:	01 c8                	add    %ecx,%eax
  8015a2:	8a 00                	mov    (%eax),%al
  8015a4:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8015a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ac:	01 d0                	add    %edx,%eax
  8015ae:	8a 00                	mov    (%eax),%al
  8015b0:	3c 40                	cmp    $0x40,%al
  8015b2:	7e 25                	jle    8015d9 <str2lower+0x5c>
  8015b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ba:	01 d0                	add    %edx,%eax
  8015bc:	8a 00                	mov    (%eax),%al
  8015be:	3c 5a                	cmp    $0x5a,%al
  8015c0:	7f 17                	jg     8015d9 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8015c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c8:	01 d0                	add    %edx,%eax
  8015ca:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8015d0:	01 ca                	add    %ecx,%edx
  8015d2:	8a 12                	mov    (%edx),%dl
  8015d4:	83 c2 20             	add    $0x20,%edx
  8015d7:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8015d9:	ff 45 fc             	incl   -0x4(%ebp)
  8015dc:	ff 75 0c             	pushl  0xc(%ebp)
  8015df:	e8 01 f8 ff ff       	call   800de5 <strlen>
  8015e4:	83 c4 04             	add    $0x4,%esp
  8015e7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015ea:	7f a6                	jg     801592 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8015ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8015ef:	c9                   	leave  
  8015f0:	c3                   	ret    

008015f1 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8015f1:	55                   	push   %ebp
  8015f2:	89 e5                	mov    %esp,%ebp
  8015f4:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8015f7:	a1 08 50 80 00       	mov    0x805008,%eax
  8015fc:	85 c0                	test   %eax,%eax
  8015fe:	74 42                	je     801642 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801600:	83 ec 08             	sub    $0x8,%esp
  801603:	68 00 00 00 82       	push   $0x82000000
  801608:	68 00 00 00 80       	push   $0x80000000
  80160d:	e8 b0 1e 00 00       	call   8034c2 <initialize_dynamic_allocator>
  801612:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801615:	e8 96 1c 00 00       	call   8032b0 <sys_get_uheap_strategy>
  80161a:	a3 80 50 83 00       	mov    %eax,0x835080
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  80161f:	a1 60 d0 81 00       	mov    0x81d060,%eax
  801624:	05 00 10 00 00       	add    $0x1000,%eax
  801629:	a3 30 51 83 00       	mov    %eax,0x835130
		uheapPageAllocBreak = uheapPageAllocStart;
  80162e:	a1 30 51 83 00       	mov    0x835130,%eax
  801633:	a3 88 50 83 00       	mov    %eax,0x835088

		__firstTimeFlag = 0;
  801638:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  80163f:	00 00 00 
	}
}
  801642:	90                   	nop
  801643:	c9                   	leave  
  801644:	c3                   	ret    

00801645 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801645:	55                   	push   %ebp
  801646:	89 e5                	mov    %esp,%ebp
  801648:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  80164b:	8b 45 08             	mov    0x8(%ebp),%eax
  80164e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801654:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801659:	83 ec 08             	sub    $0x8,%esp
  80165c:	68 06 04 00 00       	push   $0x406
  801661:	50                   	push   %eax
  801662:	e8 93 18 00 00       	call   802efa <__sys_allocate_page>
  801667:	83 c4 10             	add    $0x10,%esp
  80166a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80166d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801671:	79 14                	jns    801687 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801673:	83 ec 04             	sub    $0x4,%esp
  801676:	68 a8 48 80 00       	push   $0x8048a8
  80167b:	6a 1f                	push   $0x1f
  80167d:	68 e4 48 80 00       	push   $0x8048e4
  801682:	e8 b7 ed ff ff       	call   80043e <_panic>
	return 0;
  801687:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80168c:	c9                   	leave  
  80168d:	c3                   	ret    

0080168e <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
  801691:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801694:	8b 45 08             	mov    0x8(%ebp),%eax
  801697:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80169a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80169d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016a2:	83 ec 0c             	sub    $0xc,%esp
  8016a5:	50                   	push   %eax
  8016a6:	e8 96 18 00 00       	call   802f41 <__sys_unmap_frame>
  8016ab:	83 c4 10             	add    $0x10,%esp
  8016ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8016b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016b5:	79 14                	jns    8016cb <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8016b7:	83 ec 04             	sub    $0x4,%esp
  8016ba:	68 f0 48 80 00       	push   $0x8048f0
  8016bf:	6a 2a                	push   $0x2a
  8016c1:	68 e4 48 80 00       	push   $0x8048e4
  8016c6:	e8 73 ed ff ff       	call   80043e <_panic>
}
  8016cb:	90                   	nop
  8016cc:	c9                   	leave  
  8016cd:	c3                   	ret    

008016ce <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8016ce:	55                   	push   %ebp
  8016cf:	89 e5                	mov    %esp,%ebp
  8016d1:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8016d4:	e8 18 ff ff ff       	call   8015f1 <uheap_init>
	if (size == 0) return NULL ;
  8016d9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016dd:	75 0a                	jne    8016e9 <malloc+0x1b>
  8016df:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e4:	e9 43 03 00 00       	jmp    801a2c <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  8016e9:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8016f0:	77 13                	ja     801705 <malloc+0x37>
    {
        return alloc_block(size);
  8016f2:	83 ec 0c             	sub    $0xc,%esp
  8016f5:	ff 75 08             	pushl  0x8(%ebp)
  8016f8:	e8 78 20 00 00       	call   803775 <alloc_block>
  8016fd:	83 c4 10             	add    $0x10,%esp
  801700:	e9 27 03 00 00       	jmp    801a2c <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801705:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  80170c:	8b 55 08             	mov    0x8(%ebp),%edx
  80170f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801712:	01 d0                	add    %edx,%eax
  801714:	48                   	dec    %eax
  801715:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801718:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80171b:	ba 00 00 00 00       	mov    $0x0,%edx
  801720:	f7 75 dc             	divl   -0x24(%ebp)
  801723:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801726:	29 d0                	sub    %edx,%eax
  801728:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  80172b:	a1 40 d0 81 00       	mov    0x81d040,%eax
  801730:	85 c0                	test   %eax,%eax
  801732:	75 0a                	jne    80173e <malloc+0x70>
    {
        uhp_inited = 1;
  801734:	c7 05 40 d0 81 00 01 	movl   $0x1,0x81d040
  80173b:	00 00 00 
    }

    int exactIdx = -1;
  80173e:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801745:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  80174c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801753:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80175a:	e9 85 00 00 00       	jmp    8017e4 <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  80175f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801762:	89 d0                	mov    %edx,%eax
  801764:	01 c0                	add    %eax,%eax
  801766:	01 d0                	add    %edx,%eax
  801768:	c1 e0 02             	shl    $0x2,%eax
  80176b:	05 48 10 81 00       	add    $0x811048,%eax
  801770:	8a 00                	mov    (%eax),%al
  801772:	84 c0                	test   %al,%al
  801774:	74 20                	je     801796 <malloc+0xc8>
  801776:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801779:	89 d0                	mov    %edx,%eax
  80177b:	01 c0                	add    %eax,%eax
  80177d:	01 d0                	add    %edx,%eax
  80177f:	c1 e0 02             	shl    $0x2,%eax
  801782:	05 44 10 81 00       	add    $0x811044,%eax
  801787:	8b 00                	mov    (%eax),%eax
  801789:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80178c:	75 08                	jne    801796 <malloc+0xc8>
        {
            exactIdx = i;
  80178e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801791:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801794:	eb 5b                	jmp    8017f1 <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801796:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801799:	89 d0                	mov    %edx,%eax
  80179b:	01 c0                	add    %eax,%eax
  80179d:	01 d0                	add    %edx,%eax
  80179f:	c1 e0 02             	shl    $0x2,%eax
  8017a2:	05 48 10 81 00       	add    $0x811048,%eax
  8017a7:	8a 00                	mov    (%eax),%al
  8017a9:	84 c0                	test   %al,%al
  8017ab:	74 34                	je     8017e1 <malloc+0x113>
  8017ad:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017b0:	89 d0                	mov    %edx,%eax
  8017b2:	01 c0                	add    %eax,%eax
  8017b4:	01 d0                	add    %edx,%eax
  8017b6:	c1 e0 02             	shl    $0x2,%eax
  8017b9:	05 44 10 81 00       	add    $0x811044,%eax
  8017be:	8b 00                	mov    (%eax),%eax
  8017c0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8017c3:	76 1c                	jbe    8017e1 <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  8017c5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017c8:	89 d0                	mov    %edx,%eax
  8017ca:	01 c0                	add    %eax,%eax
  8017cc:	01 d0                	add    %edx,%eax
  8017ce:	c1 e0 02             	shl    $0x2,%eax
  8017d1:	05 44 10 81 00       	add    $0x811044,%eax
  8017d6:	8b 00                	mov    (%eax),%eax
  8017d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  8017db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017de:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8017e1:	ff 45 e8             	incl   -0x18(%ebp)
  8017e4:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8017eb:	0f 8e 6e ff ff ff    	jle    80175f <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  8017f1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  8017f8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8017fc:	74 7d                	je     80187b <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  8017fe:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801805:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801808:	89 d0                	mov    %edx,%eax
  80180a:	01 c0                	add    %eax,%eax
  80180c:	01 d0                	add    %edx,%eax
  80180e:	c1 e0 02             	shl    $0x2,%eax
  801811:	05 40 10 81 00       	add    $0x811040,%eax
  801816:	8b 10                	mov    (%eax),%edx
  801818:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80181b:	01 d0                	add    %edx,%eax
  80181d:	48                   	dec    %eax
  80181e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801821:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801824:	ba 00 00 00 00       	mov    $0x0,%edx
  801829:	f7 75 bc             	divl   -0x44(%ebp)
  80182c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80182f:	29 d0                	sub    %edx,%eax
  801831:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801834:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801837:	89 d0                	mov    %edx,%eax
  801839:	01 c0                	add    %eax,%eax
  80183b:	01 d0                	add    %edx,%eax
  80183d:	c1 e0 02             	shl    $0x2,%eax
  801840:	05 48 10 81 00       	add    $0x811048,%eax
  801845:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801848:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80184b:	89 d0                	mov    %edx,%eax
  80184d:	01 c0                	add    %eax,%eax
  80184f:	01 d0                	add    %edx,%eax
  801851:	c1 e0 02             	shl    $0x2,%eax
  801854:	05 44 10 81 00       	add    $0x811044,%eax
  801859:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  80185f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801862:	89 d0                	mov    %edx,%eax
  801864:	01 c0                	add    %eax,%eax
  801866:	01 d0                	add    %edx,%eax
  801868:	c1 e0 02             	shl    $0x2,%eax
  80186b:	05 40 10 81 00       	add    $0x811040,%eax
  801870:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801876:	e9 2d 01 00 00       	jmp    8019a8 <malloc+0x2da>
    }
    else if (worstIdx != -1)
  80187b:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80187f:	0f 84 ce 00 00 00    	je     801953 <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  801885:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80188c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80188f:	89 d0                	mov    %edx,%eax
  801891:	01 c0                	add    %eax,%eax
  801893:	01 d0                	add    %edx,%eax
  801895:	c1 e0 02             	shl    $0x2,%eax
  801898:	05 40 10 81 00       	add    $0x811040,%eax
  80189d:	8b 10                	mov    (%eax),%edx
  80189f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8018a2:	01 d0                	add    %edx,%eax
  8018a4:	48                   	dec    %eax
  8018a5:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8018a8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8018ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8018b0:	f7 75 c4             	divl   -0x3c(%ebp)
  8018b3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8018b6:	29 d0                	sub    %edx,%eax
  8018b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  8018bb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018be:	89 d0                	mov    %edx,%eax
  8018c0:	01 c0                	add    %eax,%eax
  8018c2:	01 d0                	add    %edx,%eax
  8018c4:	c1 e0 02             	shl    $0x2,%eax
  8018c7:	05 44 10 81 00       	add    $0x811044,%eax
  8018cc:	8b 00                	mov    (%eax),%eax
  8018ce:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8018d1:	75 47                	jne    80191a <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  8018d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018d6:	89 d0                	mov    %edx,%eax
  8018d8:	01 c0                	add    %eax,%eax
  8018da:	01 d0                	add    %edx,%eax
  8018dc:	c1 e0 02             	shl    $0x2,%eax
  8018df:	05 48 10 81 00       	add    $0x811048,%eax
  8018e4:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  8018e7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018ea:	89 d0                	mov    %edx,%eax
  8018ec:	01 c0                	add    %eax,%eax
  8018ee:	01 d0                	add    %edx,%eax
  8018f0:	c1 e0 02             	shl    $0x2,%eax
  8018f3:	05 44 10 81 00       	add    $0x811044,%eax
  8018f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  8018fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801901:	89 d0                	mov    %edx,%eax
  801903:	01 c0                	add    %eax,%eax
  801905:	01 d0                	add    %edx,%eax
  801907:	c1 e0 02             	shl    $0x2,%eax
  80190a:	05 40 10 81 00       	add    $0x811040,%eax
  80190f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801915:	e9 8e 00 00 00       	jmp    8019a8 <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  80191a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80191d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801920:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801923:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801926:	89 d0                	mov    %edx,%eax
  801928:	01 c0                	add    %eax,%eax
  80192a:	01 d0                	add    %edx,%eax
  80192c:	c1 e0 02             	shl    $0x2,%eax
  80192f:	05 40 10 81 00       	add    $0x811040,%eax
  801934:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  801936:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801939:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80193c:	89 c2                	mov    %eax,%edx
  80193e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801941:	89 c8                	mov    %ecx,%eax
  801943:	01 c0                	add    %eax,%eax
  801945:	01 c8                	add    %ecx,%eax
  801947:	c1 e0 02             	shl    $0x2,%eax
  80194a:	05 44 10 81 00       	add    $0x811044,%eax
  80194f:	89 10                	mov    %edx,(%eax)
  801951:	eb 55                	jmp    8019a8 <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  801953:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  80195a:	8b 15 88 50 83 00    	mov    0x835088,%edx
  801960:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801963:	01 d0                	add    %edx,%eax
  801965:	48                   	dec    %eax
  801966:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801969:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80196c:	ba 00 00 00 00       	mov    $0x0,%edx
  801971:	f7 75 d0             	divl   -0x30(%ebp)
  801974:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801977:	29 d0                	sub    %edx,%eax
  801979:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  80197c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80197f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801982:	01 d0                	add    %edx,%eax
  801984:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801989:	76 0a                	jbe    801995 <malloc+0x2c7>
            return NULL;
  80198b:	b8 00 00 00 00       	mov    $0x0,%eax
  801990:	e9 97 00 00 00       	jmp    801a2c <malloc+0x35e>
        va = start;
  801995:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801998:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  80199b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80199e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019a1:	01 d0                	add    %edx,%eax
  8019a3:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8019a8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8019af:	eb 5e                	jmp    801a0f <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  8019b1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019b4:	89 d0                	mov    %edx,%eax
  8019b6:	01 c0                	add    %eax,%eax
  8019b8:	01 d0                	add    %edx,%eax
  8019ba:	c1 e0 02             	shl    $0x2,%eax
  8019bd:	05 48 50 80 00       	add    $0x805048,%eax
  8019c2:	8a 00                	mov    (%eax),%al
  8019c4:	84 c0                	test   %al,%al
  8019c6:	75 44                	jne    801a0c <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  8019c8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019cb:	89 d0                	mov    %edx,%eax
  8019cd:	01 c0                	add    %eax,%eax
  8019cf:	01 d0                	add    %edx,%eax
  8019d1:	c1 e0 02             	shl    $0x2,%eax
  8019d4:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  8019da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019dd:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  8019df:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019e2:	89 d0                	mov    %edx,%eax
  8019e4:	01 c0                	add    %eax,%eax
  8019e6:	01 d0                	add    %edx,%eax
  8019e8:	c1 e0 02             	shl    $0x2,%eax
  8019eb:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8019f1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019f4:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  8019f6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019f9:	89 d0                	mov    %edx,%eax
  8019fb:	01 c0                	add    %eax,%eax
  8019fd:	01 d0                	add    %edx,%eax
  8019ff:	c1 e0 02             	shl    $0x2,%eax
  801a02:	05 48 50 80 00       	add    $0x805048,%eax
  801a07:	c6 00 01             	movb   $0x1,(%eax)
            break;
  801a0a:	eb 0c                	jmp    801a18 <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801a0c:	ff 45 e0             	incl   -0x20(%ebp)
  801a0f:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801a16:	7e 99                	jle    8019b1 <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  801a18:	83 ec 08             	sub    $0x8,%esp
  801a1b:	ff 75 d4             	pushl  -0x2c(%ebp)
  801a1e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a21:	e8 a2 19 00 00       	call   8033c8 <sys_allocate_user_mem>
  801a26:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  801a29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801a2c:	c9                   	leave  
  801a2d:	c3                   	ret    

00801a2e <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801a2e:	55                   	push   %ebp
  801a2f:	89 e5                	mov    %esp,%ebp
  801a31:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  801a34:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a38:	0f 84 fa 03 00 00    	je     801e38 <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a41:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  801a44:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a47:	85 c0                	test   %eax,%eax
  801a49:	79 1c                	jns    801a67 <free+0x39>
  801a4b:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  801a52:	77 13                	ja     801a67 <free+0x39>
    {
        free_block(virtual_address);
  801a54:	83 ec 0c             	sub    $0xc,%esp
  801a57:	ff 75 08             	pushl  0x8(%ebp)
  801a5a:	e8 09 21 00 00       	call   803b68 <free_block>
  801a5f:	83 c4 10             	add    $0x10,%esp
        return;
  801a62:	e9 d2 03 00 00       	jmp    801e39 <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  801a67:	a1 30 51 83 00       	mov    0x835130,%eax
  801a6c:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  801a6f:	72 09                	jb     801a7a <free+0x4c>
  801a71:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  801a78:	76 17                	jbe    801a91 <free+0x63>
        panic("free: invalid address");
  801a7a:	83 ec 04             	sub    $0x4,%esp
  801a7d:	68 2d 49 80 00       	push   $0x80492d
  801a82:	68 9b 00 00 00       	push   $0x9b
  801a87:	68 e4 48 80 00       	push   $0x8048e4
  801a8c:	e8 ad e9 ff ff       	call   80043e <_panic>

    uint32 size = 0;
  801a91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  801a98:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801a9f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801aa6:	eb 50                	jmp    801af8 <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  801aa8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801aab:	89 d0                	mov    %edx,%eax
  801aad:	01 c0                	add    %eax,%eax
  801aaf:	01 d0                	add    %edx,%eax
  801ab1:	c1 e0 02             	shl    $0x2,%eax
  801ab4:	05 48 50 80 00       	add    $0x805048,%eax
  801ab9:	8a 00                	mov    (%eax),%al
  801abb:	84 c0                	test   %al,%al
  801abd:	74 36                	je     801af5 <free+0xc7>
  801abf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ac2:	89 d0                	mov    %edx,%eax
  801ac4:	01 c0                	add    %eax,%eax
  801ac6:	01 d0                	add    %edx,%eax
  801ac8:	c1 e0 02             	shl    $0x2,%eax
  801acb:	05 40 50 80 00       	add    $0x805040,%eax
  801ad0:	8b 00                	mov    (%eax),%eax
  801ad2:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801ad5:	75 1e                	jne    801af5 <free+0xc7>
        {
            size = uhp_allocs[i].size;
  801ad7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ada:	89 d0                	mov    %edx,%eax
  801adc:	01 c0                	add    %eax,%eax
  801ade:	01 d0                	add    %edx,%eax
  801ae0:	c1 e0 02             	shl    $0x2,%eax
  801ae3:	05 44 50 80 00       	add    $0x805044,%eax
  801ae8:	8b 00                	mov    (%eax),%eax
  801aea:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  801aed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801af0:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  801af3:	eb 0c                	jmp    801b01 <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801af5:	ff 45 ec             	incl   -0x14(%ebp)
  801af8:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  801aff:	7e a7                	jle    801aa8 <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  801b01:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801b05:	74 06                	je     801b0d <free+0xdf>
  801b07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b0b:	75 17                	jne    801b24 <free+0xf6>
        panic("free: unknown block");
  801b0d:	83 ec 04             	sub    $0x4,%esp
  801b10:	68 43 49 80 00       	push   $0x804943
  801b15:	68 a9 00 00 00       	push   $0xa9
  801b1a:	68 e4 48 80 00       	push   $0x8048e4
  801b1f:	e8 1a e9 ff ff       	call   80043e <_panic>

    uhp_allocs[idx].used = 0;
  801b24:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b27:	89 d0                	mov    %edx,%eax
  801b29:	01 c0                	add    %eax,%eax
  801b2b:	01 d0                	add    %edx,%eax
  801b2d:	c1 e0 02             	shl    $0x2,%eax
  801b30:	05 48 50 80 00       	add    $0x805048,%eax
  801b35:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  801b38:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801b3f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801b46:	eb 64                	jmp    801bac <free+0x17e>
    {
        if (!uhp_frees[i].free)
  801b48:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b4b:	89 d0                	mov    %edx,%eax
  801b4d:	01 c0                	add    %eax,%eax
  801b4f:	01 d0                	add    %edx,%eax
  801b51:	c1 e0 02             	shl    $0x2,%eax
  801b54:	05 48 10 81 00       	add    $0x811048,%eax
  801b59:	8a 00                	mov    (%eax),%al
  801b5b:	84 c0                	test   %al,%al
  801b5d:	75 4a                	jne    801ba9 <free+0x17b>
        {
            uhp_frees[i].va = va;
  801b5f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b62:	89 d0                	mov    %edx,%eax
  801b64:	01 c0                	add    %eax,%eax
  801b66:	01 d0                	add    %edx,%eax
  801b68:	c1 e0 02             	shl    $0x2,%eax
  801b6b:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  801b71:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b74:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  801b76:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b79:	89 d0                	mov    %edx,%eax
  801b7b:	01 c0                	add    %eax,%eax
  801b7d:	01 d0                	add    %edx,%eax
  801b7f:	c1 e0 02             	shl    $0x2,%eax
  801b82:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  801b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b8b:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  801b8d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b90:	89 d0                	mov    %edx,%eax
  801b92:	01 c0                	add    %eax,%eax
  801b94:	01 d0                	add    %edx,%eax
  801b96:	c1 e0 02             	shl    $0x2,%eax
  801b99:	05 48 10 81 00       	add    $0x811048,%eax
  801b9e:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  801ba1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ba4:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  801ba7:	eb 0c                	jmp    801bb5 <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801ba9:	ff 45 e4             	incl   -0x1c(%ebp)
  801bac:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  801bb3:	7e 93                	jle    801b48 <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  801bb5:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  801bb9:	0f 84 f1 01 00 00    	je     801db0 <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801bbf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801bc6:	e9 d8 01 00 00       	jmp    801da3 <free+0x375>
        {
            if (i == fidx) continue;
  801bcb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bce:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801bd1:	0f 84 c8 01 00 00    	je     801d9f <free+0x371>
            if (uhp_frees[i].free)
  801bd7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bda:	89 d0                	mov    %edx,%eax
  801bdc:	01 c0                	add    %eax,%eax
  801bde:	01 d0                	add    %edx,%eax
  801be0:	c1 e0 02             	shl    $0x2,%eax
  801be3:	05 48 10 81 00       	add    $0x811048,%eax
  801be8:	8a 00                	mov    (%eax),%al
  801bea:	84 c0                	test   %al,%al
  801bec:	0f 84 ae 01 00 00    	je     801da0 <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  801bf2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bf5:	89 d0                	mov    %edx,%eax
  801bf7:	01 c0                	add    %eax,%eax
  801bf9:	01 d0                	add    %edx,%eax
  801bfb:	c1 e0 02             	shl    $0x2,%eax
  801bfe:	05 40 10 81 00       	add    $0x811040,%eax
  801c03:	8b 08                	mov    (%eax),%ecx
  801c05:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c08:	89 d0                	mov    %edx,%eax
  801c0a:	01 c0                	add    %eax,%eax
  801c0c:	01 d0                	add    %edx,%eax
  801c0e:	c1 e0 02             	shl    $0x2,%eax
  801c11:	05 44 10 81 00       	add    $0x811044,%eax
  801c16:	8b 00                	mov    (%eax),%eax
  801c18:	01 c1                	add    %eax,%ecx
  801c1a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c1d:	89 d0                	mov    %edx,%eax
  801c1f:	01 c0                	add    %eax,%eax
  801c21:	01 d0                	add    %edx,%eax
  801c23:	c1 e0 02             	shl    $0x2,%eax
  801c26:	05 40 10 81 00       	add    $0x811040,%eax
  801c2b:	8b 00                	mov    (%eax),%eax
  801c2d:	39 c1                	cmp    %eax,%ecx
  801c2f:	0f 85 a8 00 00 00    	jne    801cdd <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  801c35:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c38:	89 d0                	mov    %edx,%eax
  801c3a:	01 c0                	add    %eax,%eax
  801c3c:	01 d0                	add    %edx,%eax
  801c3e:	c1 e0 02             	shl    $0x2,%eax
  801c41:	05 40 10 81 00       	add    $0x811040,%eax
  801c46:	8b 10                	mov    (%eax),%edx
  801c48:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  801c4b:	89 c8                	mov    %ecx,%eax
  801c4d:	01 c0                	add    %eax,%eax
  801c4f:	01 c8                	add    %ecx,%eax
  801c51:	c1 e0 02             	shl    $0x2,%eax
  801c54:	05 40 10 81 00       	add    $0x811040,%eax
  801c59:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801c5b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c5e:	89 d0                	mov    %edx,%eax
  801c60:	01 c0                	add    %eax,%eax
  801c62:	01 d0                	add    %edx,%eax
  801c64:	c1 e0 02             	shl    $0x2,%eax
  801c67:	05 44 10 81 00       	add    $0x811044,%eax
  801c6c:	8b 08                	mov    (%eax),%ecx
  801c6e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c71:	89 d0                	mov    %edx,%eax
  801c73:	01 c0                	add    %eax,%eax
  801c75:	01 d0                	add    %edx,%eax
  801c77:	c1 e0 02             	shl    $0x2,%eax
  801c7a:	05 44 10 81 00       	add    $0x811044,%eax
  801c7f:	8b 00                	mov    (%eax),%eax
  801c81:	01 c1                	add    %eax,%ecx
  801c83:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c86:	89 d0                	mov    %edx,%eax
  801c88:	01 c0                	add    %eax,%eax
  801c8a:	01 d0                	add    %edx,%eax
  801c8c:	c1 e0 02             	shl    $0x2,%eax
  801c8f:	05 44 10 81 00       	add    $0x811044,%eax
  801c94:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801c96:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c99:	89 d0                	mov    %edx,%eax
  801c9b:	01 c0                	add    %eax,%eax
  801c9d:	01 d0                	add    %edx,%eax
  801c9f:	c1 e0 02             	shl    $0x2,%eax
  801ca2:	05 48 10 81 00       	add    $0x811048,%eax
  801ca7:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801caa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801cad:	89 d0                	mov    %edx,%eax
  801caf:	01 c0                	add    %eax,%eax
  801cb1:	01 d0                	add    %edx,%eax
  801cb3:	c1 e0 02             	shl    $0x2,%eax
  801cb6:	05 40 10 81 00       	add    $0x811040,%eax
  801cbb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801cc1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801cc4:	89 d0                	mov    %edx,%eax
  801cc6:	01 c0                	add    %eax,%eax
  801cc8:	01 d0                	add    %edx,%eax
  801cca:	c1 e0 02             	shl    $0x2,%eax
  801ccd:	05 44 10 81 00       	add    $0x811044,%eax
  801cd2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801cd8:	e9 c3 00 00 00       	jmp    801da0 <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  801cdd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ce0:	89 d0                	mov    %edx,%eax
  801ce2:	01 c0                	add    %eax,%eax
  801ce4:	01 d0                	add    %edx,%eax
  801ce6:	c1 e0 02             	shl    $0x2,%eax
  801ce9:	05 40 10 81 00       	add    $0x811040,%eax
  801cee:	8b 08                	mov    (%eax),%ecx
  801cf0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801cf3:	89 d0                	mov    %edx,%eax
  801cf5:	01 c0                	add    %eax,%eax
  801cf7:	01 d0                	add    %edx,%eax
  801cf9:	c1 e0 02             	shl    $0x2,%eax
  801cfc:	05 44 10 81 00       	add    $0x811044,%eax
  801d01:	8b 00                	mov    (%eax),%eax
  801d03:	01 c1                	add    %eax,%ecx
  801d05:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d08:	89 d0                	mov    %edx,%eax
  801d0a:	01 c0                	add    %eax,%eax
  801d0c:	01 d0                	add    %edx,%eax
  801d0e:	c1 e0 02             	shl    $0x2,%eax
  801d11:	05 40 10 81 00       	add    $0x811040,%eax
  801d16:	8b 00                	mov    (%eax),%eax
  801d18:	39 c1                	cmp    %eax,%ecx
  801d1a:	0f 85 80 00 00 00    	jne    801da0 <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801d20:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d23:	89 d0                	mov    %edx,%eax
  801d25:	01 c0                	add    %eax,%eax
  801d27:	01 d0                	add    %edx,%eax
  801d29:	c1 e0 02             	shl    $0x2,%eax
  801d2c:	05 44 10 81 00       	add    $0x811044,%eax
  801d31:	8b 08                	mov    (%eax),%ecx
  801d33:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d36:	89 d0                	mov    %edx,%eax
  801d38:	01 c0                	add    %eax,%eax
  801d3a:	01 d0                	add    %edx,%eax
  801d3c:	c1 e0 02             	shl    $0x2,%eax
  801d3f:	05 44 10 81 00       	add    $0x811044,%eax
  801d44:	8b 00                	mov    (%eax),%eax
  801d46:	01 c1                	add    %eax,%ecx
  801d48:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d4b:	89 d0                	mov    %edx,%eax
  801d4d:	01 c0                	add    %eax,%eax
  801d4f:	01 d0                	add    %edx,%eax
  801d51:	c1 e0 02             	shl    $0x2,%eax
  801d54:	05 44 10 81 00       	add    $0x811044,%eax
  801d59:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801d5b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d5e:	89 d0                	mov    %edx,%eax
  801d60:	01 c0                	add    %eax,%eax
  801d62:	01 d0                	add    %edx,%eax
  801d64:	c1 e0 02             	shl    $0x2,%eax
  801d67:	05 48 10 81 00       	add    $0x811048,%eax
  801d6c:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801d6f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d72:	89 d0                	mov    %edx,%eax
  801d74:	01 c0                	add    %eax,%eax
  801d76:	01 d0                	add    %edx,%eax
  801d78:	c1 e0 02             	shl    $0x2,%eax
  801d7b:	05 40 10 81 00       	add    $0x811040,%eax
  801d80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801d86:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d89:	89 d0                	mov    %edx,%eax
  801d8b:	01 c0                	add    %eax,%eax
  801d8d:	01 d0                	add    %edx,%eax
  801d8f:	c1 e0 02             	shl    $0x2,%eax
  801d92:	05 44 10 81 00       	add    $0x811044,%eax
  801d97:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801d9d:	eb 01                	jmp    801da0 <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  801d9f:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801da0:	ff 45 e0             	incl   -0x20(%ebp)
  801da3:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801daa:	0f 8e 1b fe ff ff    	jle    801bcb <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  801db0:	a1 30 51 83 00       	mov    0x835130,%eax
  801db5:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801db8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801dbf:	eb 53                	jmp    801e14 <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  801dc1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801dc4:	89 d0                	mov    %edx,%eax
  801dc6:	01 c0                	add    %eax,%eax
  801dc8:	01 d0                	add    %edx,%eax
  801dca:	c1 e0 02             	shl    $0x2,%eax
  801dcd:	05 48 50 80 00       	add    $0x805048,%eax
  801dd2:	8a 00                	mov    (%eax),%al
  801dd4:	84 c0                	test   %al,%al
  801dd6:	74 39                	je     801e11 <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  801dd8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801ddb:	89 d0                	mov    %edx,%eax
  801ddd:	01 c0                	add    %eax,%eax
  801ddf:	01 d0                	add    %edx,%eax
  801de1:	c1 e0 02             	shl    $0x2,%eax
  801de4:	05 40 50 80 00       	add    $0x805040,%eax
  801de9:	8b 08                	mov    (%eax),%ecx
  801deb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801dee:	89 d0                	mov    %edx,%eax
  801df0:	01 c0                	add    %eax,%eax
  801df2:	01 d0                	add    %edx,%eax
  801df4:	c1 e0 02             	shl    $0x2,%eax
  801df7:	05 44 50 80 00       	add    $0x805044,%eax
  801dfc:	8b 00                	mov    (%eax),%eax
  801dfe:	01 c8                	add    %ecx,%eax
  801e00:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  801e03:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e06:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801e09:	76 06                	jbe    801e11 <free+0x3e3>
  801e0b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e0e:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801e11:	ff 45 d8             	incl   -0x28(%ebp)
  801e14:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  801e1b:	7e a4                	jle    801dc1 <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  801e1d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e20:	a3 88 50 83 00       	mov    %eax,0x835088

    sys_free_user_mem(va, size);
  801e25:	83 ec 08             	sub    $0x8,%esp
  801e28:	ff 75 f4             	pushl  -0xc(%ebp)
  801e2b:	ff 75 d4             	pushl  -0x2c(%ebp)
  801e2e:	e8 79 15 00 00       	call   8033ac <sys_free_user_mem>
  801e33:	83 c4 10             	add    $0x10,%esp
  801e36:	eb 01                	jmp    801e39 <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  801e38:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  801e39:	c9                   	leave  
  801e3a:	c3                   	ret    

00801e3b <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801e3b:	55                   	push   %ebp
  801e3c:	89 e5                	mov    %esp,%ebp
  801e3e:	83 ec 68             	sub    $0x68,%esp
  801e41:	8b 45 10             	mov    0x10(%ebp),%eax
  801e44:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801e47:	e8 a5 f7 ff ff       	call   8015f1 <uheap_init>
	if (size == 0) return NULL ;
  801e4c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e50:	75 0a                	jne    801e5c <smalloc+0x21>
  801e52:	b8 00 00 00 00       	mov    $0x0,%eax
  801e57:	e9 37 03 00 00       	jmp    802193 <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801e5c:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801e63:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e66:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e69:	01 d0                	add    %edx,%eax
  801e6b:	48                   	dec    %eax
  801e6c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801e6f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e72:	ba 00 00 00 00       	mov    $0x0,%edx
  801e77:	f7 75 dc             	divl   -0x24(%ebp)
  801e7a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e7d:	29 d0                	sub    %edx,%eax
  801e7f:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  801e82:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801e89:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801e90:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801e97:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801e9e:	e9 85 00 00 00       	jmp    801f28 <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801ea3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ea6:	89 d0                	mov    %edx,%eax
  801ea8:	01 c0                	add    %eax,%eax
  801eaa:	01 d0                	add    %edx,%eax
  801eac:	c1 e0 02             	shl    $0x2,%eax
  801eaf:	05 48 10 81 00       	add    $0x811048,%eax
  801eb4:	8a 00                	mov    (%eax),%al
  801eb6:	84 c0                	test   %al,%al
  801eb8:	74 20                	je     801eda <smalloc+0x9f>
  801eba:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ebd:	89 d0                	mov    %edx,%eax
  801ebf:	01 c0                	add    %eax,%eax
  801ec1:	01 d0                	add    %edx,%eax
  801ec3:	c1 e0 02             	shl    $0x2,%eax
  801ec6:	05 44 10 81 00       	add    $0x811044,%eax
  801ecb:	8b 00                	mov    (%eax),%eax
  801ecd:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801ed0:	75 08                	jne    801eda <smalloc+0x9f>
        {
            exactIdx = i;
  801ed2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ed5:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801ed8:	eb 5b                	jmp    801f35 <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801eda:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801edd:	89 d0                	mov    %edx,%eax
  801edf:	01 c0                	add    %eax,%eax
  801ee1:	01 d0                	add    %edx,%eax
  801ee3:	c1 e0 02             	shl    $0x2,%eax
  801ee6:	05 48 10 81 00       	add    $0x811048,%eax
  801eeb:	8a 00                	mov    (%eax),%al
  801eed:	84 c0                	test   %al,%al
  801eef:	74 34                	je     801f25 <smalloc+0xea>
  801ef1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ef4:	89 d0                	mov    %edx,%eax
  801ef6:	01 c0                	add    %eax,%eax
  801ef8:	01 d0                	add    %edx,%eax
  801efa:	c1 e0 02             	shl    $0x2,%eax
  801efd:	05 44 10 81 00       	add    $0x811044,%eax
  801f02:	8b 00                	mov    (%eax),%eax
  801f04:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801f07:	76 1c                	jbe    801f25 <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  801f09:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f0c:	89 d0                	mov    %edx,%eax
  801f0e:	01 c0                	add    %eax,%eax
  801f10:	01 d0                	add    %edx,%eax
  801f12:	c1 e0 02             	shl    $0x2,%eax
  801f15:	05 44 10 81 00       	add    $0x811044,%eax
  801f1a:	8b 00                	mov    (%eax),%eax
  801f1c:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801f1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f22:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801f25:	ff 45 e8             	incl   -0x18(%ebp)
  801f28:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801f2f:	0f 8e 6e ff ff ff    	jle    801ea3 <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  801f35:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801f3c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801f40:	74 7d                	je     801fbf <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801f42:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801f49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f4c:	89 d0                	mov    %edx,%eax
  801f4e:	01 c0                	add    %eax,%eax
  801f50:	01 d0                	add    %edx,%eax
  801f52:	c1 e0 02             	shl    $0x2,%eax
  801f55:	05 40 10 81 00       	add    $0x811040,%eax
  801f5a:	8b 10                	mov    (%eax),%edx
  801f5c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801f5f:	01 d0                	add    %edx,%eax
  801f61:	48                   	dec    %eax
  801f62:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801f65:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801f68:	ba 00 00 00 00       	mov    $0x0,%edx
  801f6d:	f7 75 bc             	divl   -0x44(%ebp)
  801f70:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801f73:	29 d0                	sub    %edx,%eax
  801f75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801f78:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f7b:	89 d0                	mov    %edx,%eax
  801f7d:	01 c0                	add    %eax,%eax
  801f7f:	01 d0                	add    %edx,%eax
  801f81:	c1 e0 02             	shl    $0x2,%eax
  801f84:	05 48 10 81 00       	add    $0x811048,%eax
  801f89:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801f8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f8f:	89 d0                	mov    %edx,%eax
  801f91:	01 c0                	add    %eax,%eax
  801f93:	01 d0                	add    %edx,%eax
  801f95:	c1 e0 02             	shl    $0x2,%eax
  801f98:	05 44 10 81 00       	add    $0x811044,%eax
  801f9d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801fa3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fa6:	89 d0                	mov    %edx,%eax
  801fa8:	01 c0                	add    %eax,%eax
  801faa:	01 d0                	add    %edx,%eax
  801fac:	c1 e0 02             	shl    $0x2,%eax
  801faf:	05 40 10 81 00       	add    $0x811040,%eax
  801fb4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fba:	e9 2d 01 00 00       	jmp    8020ec <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  801fbf:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801fc3:	0f 84 ce 00 00 00    	je     802097 <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  801fc9:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  801fd0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fd3:	89 d0                	mov    %edx,%eax
  801fd5:	01 c0                	add    %eax,%eax
  801fd7:	01 d0                	add    %edx,%eax
  801fd9:	c1 e0 02             	shl    $0x2,%eax
  801fdc:	05 40 10 81 00       	add    $0x811040,%eax
  801fe1:	8b 10                	mov    (%eax),%edx
  801fe3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801fe6:	01 d0                	add    %edx,%eax
  801fe8:	48                   	dec    %eax
  801fe9:	89 45 c0             	mov    %eax,-0x40(%ebp)
  801fec:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801fef:	ba 00 00 00 00       	mov    $0x0,%edx
  801ff4:	f7 75 c4             	divl   -0x3c(%ebp)
  801ff7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801ffa:	29 d0                	sub    %edx,%eax
  801ffc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  801fff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802002:	89 d0                	mov    %edx,%eax
  802004:	01 c0                	add    %eax,%eax
  802006:	01 d0                	add    %edx,%eax
  802008:	c1 e0 02             	shl    $0x2,%eax
  80200b:	05 44 10 81 00       	add    $0x811044,%eax
  802010:	8b 00                	mov    (%eax),%eax
  802012:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802015:	75 47                	jne    80205e <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  802017:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80201a:	89 d0                	mov    %edx,%eax
  80201c:	01 c0                	add    %eax,%eax
  80201e:	01 d0                	add    %edx,%eax
  802020:	c1 e0 02             	shl    $0x2,%eax
  802023:	05 48 10 81 00       	add    $0x811048,%eax
  802028:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  80202b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80202e:	89 d0                	mov    %edx,%eax
  802030:	01 c0                	add    %eax,%eax
  802032:	01 d0                	add    %edx,%eax
  802034:	c1 e0 02             	shl    $0x2,%eax
  802037:	05 44 10 81 00       	add    $0x811044,%eax
  80203c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  802042:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802045:	89 d0                	mov    %edx,%eax
  802047:	01 c0                	add    %eax,%eax
  802049:	01 d0                	add    %edx,%eax
  80204b:	c1 e0 02             	shl    $0x2,%eax
  80204e:	05 40 10 81 00       	add    $0x811040,%eax
  802053:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802059:	e9 8e 00 00 00       	jmp    8020ec <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  80205e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802061:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802064:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802067:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80206a:	89 d0                	mov    %edx,%eax
  80206c:	01 c0                	add    %eax,%eax
  80206e:	01 d0                	add    %edx,%eax
  802070:	c1 e0 02             	shl    $0x2,%eax
  802073:	05 40 10 81 00       	add    $0x811040,%eax
  802078:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  80207a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80207d:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802080:	89 c2                	mov    %eax,%edx
  802082:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802085:	89 c8                	mov    %ecx,%eax
  802087:	01 c0                	add    %eax,%eax
  802089:	01 c8                	add    %ecx,%eax
  80208b:	c1 e0 02             	shl    $0x2,%eax
  80208e:	05 44 10 81 00       	add    $0x811044,%eax
  802093:	89 10                	mov    %edx,(%eax)
  802095:	eb 55                	jmp    8020ec <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  802097:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  80209e:	8b 15 88 50 83 00    	mov    0x835088,%edx
  8020a4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8020a7:	01 d0                	add    %edx,%eax
  8020a9:	48                   	dec    %eax
  8020aa:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8020ad:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8020b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8020b5:	f7 75 d0             	divl   -0x30(%ebp)
  8020b8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8020bb:	29 d0                	sub    %edx,%eax
  8020bd:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  8020c0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8020c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020c6:	01 d0                	add    %edx,%eax
  8020c8:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8020cd:	76 0a                	jbe    8020d9 <smalloc+0x29e>
            return NULL;
  8020cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d4:	e9 ba 00 00 00       	jmp    802193 <smalloc+0x358>
        va = start;
  8020d9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8020dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  8020df:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8020e2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020e5:	01 d0                	add    %edx,%eax
  8020e7:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8020ec:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8020f3:	eb 5e                	jmp    802153 <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  8020f5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020f8:	89 d0                	mov    %edx,%eax
  8020fa:	01 c0                	add    %eax,%eax
  8020fc:	01 d0                	add    %edx,%eax
  8020fe:	c1 e0 02             	shl    $0x2,%eax
  802101:	05 48 50 80 00       	add    $0x805048,%eax
  802106:	8a 00                	mov    (%eax),%al
  802108:	84 c0                	test   %al,%al
  80210a:	75 44                	jne    802150 <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  80210c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80210f:	89 d0                	mov    %edx,%eax
  802111:	01 c0                	add    %eax,%eax
  802113:	01 d0                	add    %edx,%eax
  802115:	c1 e0 02             	shl    $0x2,%eax
  802118:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  80211e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802121:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  802123:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802126:	89 d0                	mov    %edx,%eax
  802128:	01 c0                	add    %eax,%eax
  80212a:	01 d0                	add    %edx,%eax
  80212c:	c1 e0 02             	shl    $0x2,%eax
  80212f:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802135:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802138:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  80213a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80213d:	89 d0                	mov    %edx,%eax
  80213f:	01 c0                	add    %eax,%eax
  802141:	01 d0                	add    %edx,%eax
  802143:	c1 e0 02             	shl    $0x2,%eax
  802146:	05 48 50 80 00       	add    $0x805048,%eax
  80214b:	c6 00 01             	movb   $0x1,(%eax)
            break;
  80214e:	eb 0c                	jmp    80215c <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802150:	ff 45 e0             	incl   -0x20(%ebp)
  802153:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80215a:	7e 99                	jle    8020f5 <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  80215c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80215f:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  802163:	52                   	push   %edx
  802164:	50                   	push   %eax
  802165:	ff 75 d4             	pushl  -0x2c(%ebp)
  802168:	ff 75 08             	pushl  0x8(%ebp)
  80216b:	e8 de 0e 00 00       	call   80304e <sys_create_shared_object>
  802170:	83 c4 10             	add    $0x10,%esp
  802173:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  802176:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  80217a:	75 07                	jne    802183 <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  80217c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802181:	eb 10                	jmp    802193 <smalloc+0x358>
    if (r < 0)
  802183:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  802187:	79 07                	jns    802190 <smalloc+0x355>
        return NULL;
  802189:	b8 00 00 00 00       	mov    $0x0,%eax
  80218e:	eb 03                	jmp    802193 <smalloc+0x358>
    return (void*)va;
  802190:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  802193:	c9                   	leave  
  802194:	c3                   	ret    

00802195 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802195:	55                   	push   %ebp
  802196:	89 e5                	mov    %esp,%ebp
  802198:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80219b:	e8 51 f4 ff ff       	call   8015f1 <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  8021a0:	83 ec 08             	sub    $0x8,%esp
  8021a3:	ff 75 0c             	pushl  0xc(%ebp)
  8021a6:	ff 75 08             	pushl  0x8(%ebp)
  8021a9:	e8 ca 0e 00 00       	call   803078 <sys_size_of_shared_object>
  8021ae:	83 c4 10             	add    $0x10,%esp
  8021b1:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  8021b4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8021b8:	7f 0a                	jg     8021c4 <sget+0x2f>
        return NULL;
  8021ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8021bf:	e9 28 03 00 00       	jmp    8024ec <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  8021c4:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8021cb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8021ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8021d1:	01 d0                	add    %edx,%eax
  8021d3:	48                   	dec    %eax
  8021d4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8021d7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8021da:	ba 00 00 00 00       	mov    $0x0,%edx
  8021df:	f7 75 d8             	divl   -0x28(%ebp)
  8021e2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8021e5:	29 d0                	sub    %edx,%eax
  8021e7:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  8021ea:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  8021f1:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  8021f8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8021ff:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802206:	e9 85 00 00 00       	jmp    802290 <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  80220b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80220e:	89 d0                	mov    %edx,%eax
  802210:	01 c0                	add    %eax,%eax
  802212:	01 d0                	add    %edx,%eax
  802214:	c1 e0 02             	shl    $0x2,%eax
  802217:	05 48 10 81 00       	add    $0x811048,%eax
  80221c:	8a 00                	mov    (%eax),%al
  80221e:	84 c0                	test   %al,%al
  802220:	74 20                	je     802242 <sget+0xad>
  802222:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802225:	89 d0                	mov    %edx,%eax
  802227:	01 c0                	add    %eax,%eax
  802229:	01 d0                	add    %edx,%eax
  80222b:	c1 e0 02             	shl    $0x2,%eax
  80222e:	05 44 10 81 00       	add    $0x811044,%eax
  802233:	8b 00                	mov    (%eax),%eax
  802235:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802238:	75 08                	jne    802242 <sget+0xad>
        {
            exactIdx = i;
  80223a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80223d:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  802240:	eb 5b                	jmp    80229d <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  802242:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802245:	89 d0                	mov    %edx,%eax
  802247:	01 c0                	add    %eax,%eax
  802249:	01 d0                	add    %edx,%eax
  80224b:	c1 e0 02             	shl    $0x2,%eax
  80224e:	05 48 10 81 00       	add    $0x811048,%eax
  802253:	8a 00                	mov    (%eax),%al
  802255:	84 c0                	test   %al,%al
  802257:	74 34                	je     80228d <sget+0xf8>
  802259:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80225c:	89 d0                	mov    %edx,%eax
  80225e:	01 c0                	add    %eax,%eax
  802260:	01 d0                	add    %edx,%eax
  802262:	c1 e0 02             	shl    $0x2,%eax
  802265:	05 44 10 81 00       	add    $0x811044,%eax
  80226a:	8b 00                	mov    (%eax),%eax
  80226c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80226f:	76 1c                	jbe    80228d <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  802271:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802274:	89 d0                	mov    %edx,%eax
  802276:	01 c0                	add    %eax,%eax
  802278:	01 d0                	add    %edx,%eax
  80227a:	c1 e0 02             	shl    $0x2,%eax
  80227d:	05 44 10 81 00       	add    $0x811044,%eax
  802282:	8b 00                	mov    (%eax),%eax
  802284:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  802287:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80228a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80228d:	ff 45 e8             	incl   -0x18(%ebp)
  802290:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802297:	0f 8e 6e ff ff ff    	jle    80220b <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  80229d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  8022a4:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8022a8:	74 7d                	je     802327 <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  8022aa:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8022b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022b4:	89 d0                	mov    %edx,%eax
  8022b6:	01 c0                	add    %eax,%eax
  8022b8:	01 d0                	add    %edx,%eax
  8022ba:	c1 e0 02             	shl    $0x2,%eax
  8022bd:	05 40 10 81 00       	add    $0x811040,%eax
  8022c2:	8b 10                	mov    (%eax),%edx
  8022c4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8022c7:	01 d0                	add    %edx,%eax
  8022c9:	48                   	dec    %eax
  8022ca:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8022cd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8022d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8022d5:	f7 75 b8             	divl   -0x48(%ebp)
  8022d8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8022db:	29 d0                	sub    %edx,%eax
  8022dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  8022e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e3:	89 d0                	mov    %edx,%eax
  8022e5:	01 c0                	add    %eax,%eax
  8022e7:	01 d0                	add    %edx,%eax
  8022e9:	c1 e0 02             	shl    $0x2,%eax
  8022ec:	05 48 10 81 00       	add    $0x811048,%eax
  8022f1:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  8022f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022f7:	89 d0                	mov    %edx,%eax
  8022f9:	01 c0                	add    %eax,%eax
  8022fb:	01 d0                	add    %edx,%eax
  8022fd:	c1 e0 02             	shl    $0x2,%eax
  802300:	05 44 10 81 00       	add    $0x811044,%eax
  802305:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  80230b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80230e:	89 d0                	mov    %edx,%eax
  802310:	01 c0                	add    %eax,%eax
  802312:	01 d0                	add    %edx,%eax
  802314:	c1 e0 02             	shl    $0x2,%eax
  802317:	05 40 10 81 00       	add    $0x811040,%eax
  80231c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802322:	e9 2d 01 00 00       	jmp    802454 <sget+0x2bf>
    }
    else if (worstIdx != -1)
  802327:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80232b:	0f 84 ce 00 00 00    	je     8023ff <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  802331:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  802338:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80233b:	89 d0                	mov    %edx,%eax
  80233d:	01 c0                	add    %eax,%eax
  80233f:	01 d0                	add    %edx,%eax
  802341:	c1 e0 02             	shl    $0x2,%eax
  802344:	05 40 10 81 00       	add    $0x811040,%eax
  802349:	8b 10                	mov    (%eax),%edx
  80234b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80234e:	01 d0                	add    %edx,%eax
  802350:	48                   	dec    %eax
  802351:	89 45 bc             	mov    %eax,-0x44(%ebp)
  802354:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802357:	ba 00 00 00 00       	mov    $0x0,%edx
  80235c:	f7 75 c0             	divl   -0x40(%ebp)
  80235f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802362:	29 d0                	sub    %edx,%eax
  802364:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  802367:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80236a:	89 d0                	mov    %edx,%eax
  80236c:	01 c0                	add    %eax,%eax
  80236e:	01 d0                	add    %edx,%eax
  802370:	c1 e0 02             	shl    $0x2,%eax
  802373:	05 44 10 81 00       	add    $0x811044,%eax
  802378:	8b 00                	mov    (%eax),%eax
  80237a:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80237d:	75 47                	jne    8023c6 <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  80237f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802382:	89 d0                	mov    %edx,%eax
  802384:	01 c0                	add    %eax,%eax
  802386:	01 d0                	add    %edx,%eax
  802388:	c1 e0 02             	shl    $0x2,%eax
  80238b:	05 48 10 81 00       	add    $0x811048,%eax
  802390:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  802393:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802396:	89 d0                	mov    %edx,%eax
  802398:	01 c0                	add    %eax,%eax
  80239a:	01 d0                	add    %edx,%eax
  80239c:	c1 e0 02             	shl    $0x2,%eax
  80239f:	05 44 10 81 00       	add    $0x811044,%eax
  8023a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  8023aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023ad:	89 d0                	mov    %edx,%eax
  8023af:	01 c0                	add    %eax,%eax
  8023b1:	01 d0                	add    %edx,%eax
  8023b3:	c1 e0 02             	shl    $0x2,%eax
  8023b6:	05 40 10 81 00       	add    $0x811040,%eax
  8023bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023c1:	e9 8e 00 00 00       	jmp    802454 <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  8023c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8023c9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8023cc:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8023cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023d2:	89 d0                	mov    %edx,%eax
  8023d4:	01 c0                	add    %eax,%eax
  8023d6:	01 d0                	add    %edx,%eax
  8023d8:	c1 e0 02             	shl    $0x2,%eax
  8023db:	05 40 10 81 00       	add    $0x811040,%eax
  8023e0:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  8023e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023e5:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8023e8:	89 c2                	mov    %eax,%edx
  8023ea:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8023ed:	89 c8                	mov    %ecx,%eax
  8023ef:	01 c0                	add    %eax,%eax
  8023f1:	01 c8                	add    %ecx,%eax
  8023f3:	c1 e0 02             	shl    $0x2,%eax
  8023f6:	05 44 10 81 00       	add    $0x811044,%eax
  8023fb:	89 10                	mov    %edx,(%eax)
  8023fd:	eb 55                	jmp    802454 <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  8023ff:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802406:	8b 15 88 50 83 00    	mov    0x835088,%edx
  80240c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80240f:	01 d0                	add    %edx,%eax
  802411:	48                   	dec    %eax
  802412:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802415:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802418:	ba 00 00 00 00       	mov    $0x0,%edx
  80241d:	f7 75 cc             	divl   -0x34(%ebp)
  802420:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802423:	29 d0                	sub    %edx,%eax
  802425:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  802428:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80242b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80242e:	01 d0                	add    %edx,%eax
  802430:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802435:	76 0a                	jbe    802441 <sget+0x2ac>
            return NULL;
  802437:	b8 00 00 00 00       	mov    $0x0,%eax
  80243c:	e9 ab 00 00 00       	jmp    8024ec <sget+0x357>
        va = start;
  802441:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802444:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  802447:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80244a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80244d:	01 d0                	add    %edx,%eax
  80244f:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802454:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80245b:	eb 5e                	jmp    8024bb <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  80245d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802460:	89 d0                	mov    %edx,%eax
  802462:	01 c0                	add    %eax,%eax
  802464:	01 d0                	add    %edx,%eax
  802466:	c1 e0 02             	shl    $0x2,%eax
  802469:	05 48 50 80 00       	add    $0x805048,%eax
  80246e:	8a 00                	mov    (%eax),%al
  802470:	84 c0                	test   %al,%al
  802472:	75 44                	jne    8024b8 <sget+0x323>
        {
            uhp_allocs[i].va = va;
  802474:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802477:	89 d0                	mov    %edx,%eax
  802479:	01 c0                	add    %eax,%eax
  80247b:	01 d0                	add    %edx,%eax
  80247d:	c1 e0 02             	shl    $0x2,%eax
  802480:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  802486:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802489:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  80248b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80248e:	89 d0                	mov    %edx,%eax
  802490:	01 c0                	add    %eax,%eax
  802492:	01 d0                	add    %edx,%eax
  802494:	c1 e0 02             	shl    $0x2,%eax
  802497:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  80249d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8024a0:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  8024a2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024a5:	89 d0                	mov    %edx,%eax
  8024a7:	01 c0                	add    %eax,%eax
  8024a9:	01 d0                	add    %edx,%eax
  8024ab:	c1 e0 02             	shl    $0x2,%eax
  8024ae:	05 48 50 80 00       	add    $0x805048,%eax
  8024b3:	c6 00 01             	movb   $0x1,(%eax)
            break;
  8024b6:	eb 0c                	jmp    8024c4 <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8024b8:	ff 45 e0             	incl   -0x20(%ebp)
  8024bb:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8024c2:	7e 99                	jle    80245d <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  8024c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024c7:	83 ec 04             	sub    $0x4,%esp
  8024ca:	50                   	push   %eax
  8024cb:	ff 75 0c             	pushl  0xc(%ebp)
  8024ce:	ff 75 08             	pushl  0x8(%ebp)
  8024d1:	e8 bf 0b 00 00       	call   803095 <sys_get_shared_object>
  8024d6:	83 c4 10             	add    $0x10,%esp
  8024d9:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  8024dc:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8024e0:	79 07                	jns    8024e9 <sget+0x354>
        return NULL;
  8024e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e7:	eb 03                	jmp    8024ec <sget+0x357>
    return (void*)va;
  8024e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8024ec:	c9                   	leave  
  8024ed:	c3                   	ret    

008024ee <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8024ee:	55                   	push   %ebp
  8024ef:	89 e5                	mov    %esp,%ebp
  8024f1:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8024f4:	e8 f8 f0 ff ff       	call   8015f1 <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  8024f9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024fd:	75 13                	jne    802512 <realloc+0x24>
		return malloc(new_size);
  8024ff:	83 ec 0c             	sub    $0xc,%esp
  802502:	ff 75 0c             	pushl  0xc(%ebp)
  802505:	e8 c4 f1 ff ff       	call   8016ce <malloc>
  80250a:	83 c4 10             	add    $0x10,%esp
  80250d:	e9 f4 05 00 00       	jmp    802b06 <realloc+0x618>
	if (new_size == 0)
  802512:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802516:	75 18                	jne    802530 <realloc+0x42>
	{
		free(virtual_address);
  802518:	83 ec 0c             	sub    $0xc,%esp
  80251b:	ff 75 08             	pushl  0x8(%ebp)
  80251e:	e8 0b f5 ff ff       	call   801a2e <free>
  802523:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802526:	b8 00 00 00 00       	mov    $0x0,%eax
  80252b:	e9 d6 05 00 00       	jmp    802b06 <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  802530:	8b 45 08             	mov    0x8(%ebp),%eax
  802533:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  802536:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802539:	85 c0                	test   %eax,%eax
  80253b:	79 74                	jns    8025b1 <realloc+0xc3>
  80253d:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  802544:	77 6b                	ja     8025b1 <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  802546:	83 ec 0c             	sub    $0xc,%esp
  802549:	ff 75 0c             	pushl  0xc(%ebp)
  80254c:	e8 7d f1 ff ff       	call   8016ce <malloc>
  802551:	83 c4 10             	add    $0x10,%esp
  802554:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  802557:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80255b:	75 0a                	jne    802567 <realloc+0x79>
			return NULL;
  80255d:	b8 00 00 00 00       	mov    $0x0,%eax
  802562:	e9 9f 05 00 00       	jmp    802b06 <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  802567:	83 ec 0c             	sub    $0xc,%esp
  80256a:	ff 75 08             	pushl  0x8(%ebp)
  80256d:	e8 e0 11 00 00       	call   803752 <get_block_size>
  802572:	83 c4 10             	add    $0x10,%esp
  802575:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  802578:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80257b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80257e:	39 d0                	cmp    %edx,%eax
  802580:	76 02                	jbe    802584 <realloc+0x96>
  802582:	89 d0                	mov    %edx,%eax
  802584:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  802587:	83 ec 04             	sub    $0x4,%esp
  80258a:	ff 75 c0             	pushl  -0x40(%ebp)
  80258d:	ff 75 08             	pushl  0x8(%ebp)
  802590:	ff 75 c8             	pushl  -0x38(%ebp)
  802593:	e8 56 eb ff ff       	call   8010ee <memmove>
  802598:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  80259b:	83 ec 0c             	sub    $0xc,%esp
  80259e:	ff 75 08             	pushl  0x8(%ebp)
  8025a1:	e8 88 f4 ff ff       	call   801a2e <free>
  8025a6:	83 c4 10             	add    $0x10,%esp
		return newptr;
  8025a9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8025ac:	e9 55 05 00 00       	jmp    802b06 <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  8025b1:	a1 30 51 83 00       	mov    0x835130,%eax
  8025b6:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  8025b9:	72 09                	jb     8025c4 <realloc+0xd6>
  8025bb:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  8025c2:	76 0a                	jbe    8025ce <realloc+0xe0>
		return NULL;
  8025c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c9:	e9 38 05 00 00       	jmp    802b06 <realloc+0x618>
	uint32 oldsz = 0;
  8025ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  8025d5:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8025dc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8025e3:	eb 50                	jmp    802635 <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  8025e5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025e8:	89 d0                	mov    %edx,%eax
  8025ea:	01 c0                	add    %eax,%eax
  8025ec:	01 d0                	add    %edx,%eax
  8025ee:	c1 e0 02             	shl    $0x2,%eax
  8025f1:	05 48 50 80 00       	add    $0x805048,%eax
  8025f6:	8a 00                	mov    (%eax),%al
  8025f8:	84 c0                	test   %al,%al
  8025fa:	74 36                	je     802632 <realloc+0x144>
  8025fc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025ff:	89 d0                	mov    %edx,%eax
  802601:	01 c0                	add    %eax,%eax
  802603:	01 d0                	add    %edx,%eax
  802605:	c1 e0 02             	shl    $0x2,%eax
  802608:	05 40 50 80 00       	add    $0x805040,%eax
  80260d:	8b 00                	mov    (%eax),%eax
  80260f:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  802612:	75 1e                	jne    802632 <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  802614:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802617:	89 d0                	mov    %edx,%eax
  802619:	01 c0                	add    %eax,%eax
  80261b:	01 d0                	add    %edx,%eax
  80261d:	c1 e0 02             	shl    $0x2,%eax
  802620:	05 44 50 80 00       	add    $0x805044,%eax
  802625:	8b 00                	mov    (%eax),%eax
  802627:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  80262a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80262d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802630:	eb 0c                	jmp    80263e <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802632:	ff 45 ec             	incl   -0x14(%ebp)
  802635:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  80263c:	7e a7                	jle    8025e5 <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  80263e:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802642:	75 0a                	jne    80264e <realloc+0x160>
		return NULL;
  802644:	b8 00 00 00 00       	mov    $0x0,%eax
  802649:	e9 b8 04 00 00       	jmp    802b06 <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  80264e:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  802655:	8b 55 0c             	mov    0xc(%ebp),%edx
  802658:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80265b:	01 d0                	add    %edx,%eax
  80265d:	48                   	dec    %eax
  80265e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  802661:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802664:	ba 00 00 00 00       	mov    $0x0,%edx
  802669:	f7 75 bc             	divl   -0x44(%ebp)
  80266c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80266f:	29 d0                	sub    %edx,%eax
  802671:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  802674:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802677:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80267a:	75 08                	jne    802684 <realloc+0x196>
		return virtual_address;
  80267c:	8b 45 08             	mov    0x8(%ebp),%eax
  80267f:	e9 82 04 00 00       	jmp    802b06 <realloc+0x618>
	if (req < oldsz)
  802684:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802687:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80268a:	0f 83 cd 02 00 00    	jae    80295d <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  802690:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802693:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  802696:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  802699:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80269c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80269f:	01 d0                	add    %edx,%eax
  8026a1:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  8026a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026a7:	89 d0                	mov    %edx,%eax
  8026a9:	01 c0                	add    %eax,%eax
  8026ab:	01 d0                	add    %edx,%eax
  8026ad:	c1 e0 02             	shl    $0x2,%eax
  8026b0:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8026b6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8026b9:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  8026bb:	83 ec 08             	sub    $0x8,%esp
  8026be:	ff 75 b0             	pushl  -0x50(%ebp)
  8026c1:	ff 75 ac             	pushl  -0x54(%ebp)
  8026c4:	e8 e3 0c 00 00       	call   8033ac <sys_free_user_mem>
  8026c9:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  8026cc:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8026d3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8026da:	eb 64                	jmp    802740 <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  8026dc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026df:	89 d0                	mov    %edx,%eax
  8026e1:	01 c0                	add    %eax,%eax
  8026e3:	01 d0                	add    %edx,%eax
  8026e5:	c1 e0 02             	shl    $0x2,%eax
  8026e8:	05 48 10 81 00       	add    $0x811048,%eax
  8026ed:	8a 00                	mov    (%eax),%al
  8026ef:	84 c0                	test   %al,%al
  8026f1:	75 4a                	jne    80273d <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  8026f3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026f6:	89 d0                	mov    %edx,%eax
  8026f8:	01 c0                	add    %eax,%eax
  8026fa:	01 d0                	add    %edx,%eax
  8026fc:	c1 e0 02             	shl    $0x2,%eax
  8026ff:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  802705:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802708:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  80270a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80270d:	89 d0                	mov    %edx,%eax
  80270f:	01 c0                	add    %eax,%eax
  802711:	01 d0                	add    %edx,%eax
  802713:	c1 e0 02             	shl    $0x2,%eax
  802716:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  80271c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80271f:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  802721:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802724:	89 d0                	mov    %edx,%eax
  802726:	01 c0                	add    %eax,%eax
  802728:	01 d0                	add    %edx,%eax
  80272a:	c1 e0 02             	shl    $0x2,%eax
  80272d:	05 48 10 81 00       	add    $0x811048,%eax
  802732:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  802735:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802738:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  80273b:	eb 0c                	jmp    802749 <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  80273d:	ff 45 e4             	incl   -0x1c(%ebp)
  802740:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  802747:	7e 93                	jle    8026dc <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  802749:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  80274d:	0f 84 8d 01 00 00    	je     8028e0 <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802753:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80275a:	e9 74 01 00 00       	jmp    8028d3 <realloc+0x3e5>
			{
				if (k == fidx) continue;
  80275f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802762:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802765:	0f 84 64 01 00 00    	je     8028cf <realloc+0x3e1>
				if (uhp_frees[k].free)
  80276b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80276e:	89 d0                	mov    %edx,%eax
  802770:	01 c0                	add    %eax,%eax
  802772:	01 d0                	add    %edx,%eax
  802774:	c1 e0 02             	shl    $0x2,%eax
  802777:	05 48 10 81 00       	add    $0x811048,%eax
  80277c:	8a 00                	mov    (%eax),%al
  80277e:	84 c0                	test   %al,%al
  802780:	0f 84 4a 01 00 00    	je     8028d0 <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802786:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802789:	89 d0                	mov    %edx,%eax
  80278b:	01 c0                	add    %eax,%eax
  80278d:	01 d0                	add    %edx,%eax
  80278f:	c1 e0 02             	shl    $0x2,%eax
  802792:	05 40 10 81 00       	add    $0x811040,%eax
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
  8027ba:	05 40 10 81 00       	add    $0x811040,%eax
  8027bf:	8b 00                	mov    (%eax),%eax
  8027c1:	39 c1                	cmp    %eax,%ecx
  8027c3:	75 7a                	jne    80283f <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  8027c5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027c8:	89 d0                	mov    %edx,%eax
  8027ca:	01 c0                	add    %eax,%eax
  8027cc:	01 d0                	add    %edx,%eax
  8027ce:	c1 e0 02             	shl    $0x2,%eax
  8027d1:	05 40 10 81 00       	add    $0x811040,%eax
  8027d6:	8b 10                	mov    (%eax),%edx
  8027d8:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  8027db:	89 c8                	mov    %ecx,%eax
  8027dd:	01 c0                	add    %eax,%eax
  8027df:	01 c8                	add    %ecx,%eax
  8027e1:	c1 e0 02             	shl    $0x2,%eax
  8027e4:	05 40 10 81 00       	add    $0x811040,%eax
  8027e9:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  8027eb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027ee:	89 d0                	mov    %edx,%eax
  8027f0:	01 c0                	add    %eax,%eax
  8027f2:	01 d0                	add    %edx,%eax
  8027f4:	c1 e0 02             	shl    $0x2,%eax
  8027f7:	05 44 10 81 00       	add    $0x811044,%eax
  8027fc:	8b 08                	mov    (%eax),%ecx
  8027fe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802801:	89 d0                	mov    %edx,%eax
  802803:	01 c0                	add    %eax,%eax
  802805:	01 d0                	add    %edx,%eax
  802807:	c1 e0 02             	shl    $0x2,%eax
  80280a:	05 44 10 81 00       	add    $0x811044,%eax
  80280f:	8b 00                	mov    (%eax),%eax
  802811:	01 c1                	add    %eax,%ecx
  802813:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802816:	89 d0                	mov    %edx,%eax
  802818:	01 c0                	add    %eax,%eax
  80281a:	01 d0                	add    %edx,%eax
  80281c:	c1 e0 02             	shl    $0x2,%eax
  80281f:	05 44 10 81 00       	add    $0x811044,%eax
  802824:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802826:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802829:	89 d0                	mov    %edx,%eax
  80282b:	01 c0                	add    %eax,%eax
  80282d:	01 d0                	add    %edx,%eax
  80282f:	c1 e0 02             	shl    $0x2,%eax
  802832:	05 48 10 81 00       	add    $0x811048,%eax
  802837:	c6 00 00             	movb   $0x0,(%eax)
  80283a:	e9 91 00 00 00       	jmp    8028d0 <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  80283f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802842:	89 d0                	mov    %edx,%eax
  802844:	01 c0                	add    %eax,%eax
  802846:	01 d0                	add    %edx,%eax
  802848:	c1 e0 02             	shl    $0x2,%eax
  80284b:	05 40 10 81 00       	add    $0x811040,%eax
  802850:	8b 08                	mov    (%eax),%ecx
  802852:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802855:	89 d0                	mov    %edx,%eax
  802857:	01 c0                	add    %eax,%eax
  802859:	01 d0                	add    %edx,%eax
  80285b:	c1 e0 02             	shl    $0x2,%eax
  80285e:	05 44 10 81 00       	add    $0x811044,%eax
  802863:	8b 00                	mov    (%eax),%eax
  802865:	01 c1                	add    %eax,%ecx
  802867:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80286a:	89 d0                	mov    %edx,%eax
  80286c:	01 c0                	add    %eax,%eax
  80286e:	01 d0                	add    %edx,%eax
  802870:	c1 e0 02             	shl    $0x2,%eax
  802873:	05 40 10 81 00       	add    $0x811040,%eax
  802878:	8b 00                	mov    (%eax),%eax
  80287a:	39 c1                	cmp    %eax,%ecx
  80287c:	75 52                	jne    8028d0 <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  80287e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802881:	89 d0                	mov    %edx,%eax
  802883:	01 c0                	add    %eax,%eax
  802885:	01 d0                	add    %edx,%eax
  802887:	c1 e0 02             	shl    $0x2,%eax
  80288a:	05 44 10 81 00       	add    $0x811044,%eax
  80288f:	8b 08                	mov    (%eax),%ecx
  802891:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802894:	89 d0                	mov    %edx,%eax
  802896:	01 c0                	add    %eax,%eax
  802898:	01 d0                	add    %edx,%eax
  80289a:	c1 e0 02             	shl    $0x2,%eax
  80289d:	05 44 10 81 00       	add    $0x811044,%eax
  8028a2:	8b 00                	mov    (%eax),%eax
  8028a4:	01 c1                	add    %eax,%ecx
  8028a6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028a9:	89 d0                	mov    %edx,%eax
  8028ab:	01 c0                	add    %eax,%eax
  8028ad:	01 d0                	add    %edx,%eax
  8028af:	c1 e0 02             	shl    $0x2,%eax
  8028b2:	05 44 10 81 00       	add    $0x811044,%eax
  8028b7:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  8028b9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028bc:	89 d0                	mov    %edx,%eax
  8028be:	01 c0                	add    %eax,%eax
  8028c0:	01 d0                	add    %edx,%eax
  8028c2:	c1 e0 02             	shl    $0x2,%eax
  8028c5:	05 48 10 81 00       	add    $0x811048,%eax
  8028ca:	c6 00 00             	movb   $0x0,(%eax)
  8028cd:	eb 01                	jmp    8028d0 <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  8028cf:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  8028d0:	ff 45 e0             	incl   -0x20(%ebp)
  8028d3:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8028da:	0f 8e 7f fe ff ff    	jle    80275f <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  8028e0:	a1 30 51 83 00       	mov    0x835130,%eax
  8028e5:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  8028e8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8028ef:	eb 53                	jmp    802944 <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  8028f1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8028f4:	89 d0                	mov    %edx,%eax
  8028f6:	01 c0                	add    %eax,%eax
  8028f8:	01 d0                	add    %edx,%eax
  8028fa:	c1 e0 02             	shl    $0x2,%eax
  8028fd:	05 48 50 80 00       	add    $0x805048,%eax
  802902:	8a 00                	mov    (%eax),%al
  802904:	84 c0                	test   %al,%al
  802906:	74 39                	je     802941 <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802908:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80290b:	89 d0                	mov    %edx,%eax
  80290d:	01 c0                	add    %eax,%eax
  80290f:	01 d0                	add    %edx,%eax
  802911:	c1 e0 02             	shl    $0x2,%eax
  802914:	05 40 50 80 00       	add    $0x805040,%eax
  802919:	8b 08                	mov    (%eax),%ecx
  80291b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80291e:	89 d0                	mov    %edx,%eax
  802920:	01 c0                	add    %eax,%eax
  802922:	01 d0                	add    %edx,%eax
  802924:	c1 e0 02             	shl    $0x2,%eax
  802927:	05 44 50 80 00       	add    $0x805044,%eax
  80292c:	8b 00                	mov    (%eax),%eax
  80292e:	01 c8                	add    %ecx,%eax
  802930:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  802933:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802936:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802939:	76 06                	jbe    802941 <realloc+0x453>
  80293b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80293e:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802941:	ff 45 d8             	incl   -0x28(%ebp)
  802944:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  80294b:	7e a4                	jle    8028f1 <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  80294d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802950:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  802955:	8b 45 08             	mov    0x8(%ebp),%eax
  802958:	e9 a9 01 00 00       	jmp    802b06 <realloc+0x618>
	}
	uint32 end = va + oldsz;
  80295d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802960:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802963:	01 d0                	add    %edx,%eax
  802965:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  802968:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  80296f:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  802976:	eb 57                	jmp    8029cf <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  802978:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80297b:	89 d0                	mov    %edx,%eax
  80297d:	01 c0                	add    %eax,%eax
  80297f:	01 d0                	add    %edx,%eax
  802981:	c1 e0 02             	shl    $0x2,%eax
  802984:	05 48 10 81 00       	add    $0x811048,%eax
  802989:	8a 00                	mov    (%eax),%al
  80298b:	84 c0                	test   %al,%al
  80298d:	74 3d                	je     8029cc <realloc+0x4de>
  80298f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802992:	89 d0                	mov    %edx,%eax
  802994:	01 c0                	add    %eax,%eax
  802996:	01 d0                	add    %edx,%eax
  802998:	c1 e0 02             	shl    $0x2,%eax
  80299b:	05 40 10 81 00       	add    $0x811040,%eax
  8029a0:	8b 00                	mov    (%eax),%eax
  8029a2:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029a5:	75 25                	jne    8029cc <realloc+0x4de>
  8029a7:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8029aa:	89 d0                	mov    %edx,%eax
  8029ac:	01 c0                	add    %eax,%eax
  8029ae:	01 d0                	add    %edx,%eax
  8029b0:	c1 e0 02             	shl    $0x2,%eax
  8029b3:	05 44 10 81 00       	add    $0x811044,%eax
  8029b8:	8b 10                	mov    (%eax),%edx
  8029ba:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8029bd:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8029c0:	39 c2                	cmp    %eax,%edx
  8029c2:	72 08                	jb     8029cc <realloc+0x4de>
		{
			adjIdx = j; break;
  8029c4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8029c7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8029ca:	eb 0c                	jmp    8029d8 <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8029cc:	ff 45 d0             	incl   -0x30(%ebp)
  8029cf:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  8029d6:	7e a0                	jle    802978 <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  8029d8:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  8029dc:	0f 84 d6 00 00 00    	je     802ab8 <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  8029e2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8029e5:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8029e8:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  8029eb:	83 ec 08             	sub    $0x8,%esp
  8029ee:	ff 75 a0             	pushl  -0x60(%ebp)
  8029f1:	ff 75 a4             	pushl  -0x5c(%ebp)
  8029f4:	e8 cf 09 00 00       	call   8033c8 <sys_allocate_user_mem>
  8029f9:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  8029fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029ff:	89 d0                	mov    %edx,%eax
  802a01:	01 c0                	add    %eax,%eax
  802a03:	01 d0                	add    %edx,%eax
  802a05:	c1 e0 02             	shl    $0x2,%eax
  802a08:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802a0e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a11:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  802a13:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a16:	89 d0                	mov    %edx,%eax
  802a18:	01 c0                	add    %eax,%eax
  802a1a:	01 d0                	add    %edx,%eax
  802a1c:	c1 e0 02             	shl    $0x2,%eax
  802a1f:	05 40 10 81 00       	add    $0x811040,%eax
  802a24:	8b 10                	mov    (%eax),%edx
  802a26:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802a29:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802a2c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a2f:	89 d0                	mov    %edx,%eax
  802a31:	01 c0                	add    %eax,%eax
  802a33:	01 d0                	add    %edx,%eax
  802a35:	c1 e0 02             	shl    $0x2,%eax
  802a38:	05 40 10 81 00       	add    $0x811040,%eax
  802a3d:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  802a3f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a42:	89 d0                	mov    %edx,%eax
  802a44:	01 c0                	add    %eax,%eax
  802a46:	01 d0                	add    %edx,%eax
  802a48:	c1 e0 02             	shl    $0x2,%eax
  802a4b:	05 44 10 81 00       	add    $0x811044,%eax
  802a50:	8b 00                	mov    (%eax),%eax
  802a52:	2b 45 a0             	sub    -0x60(%ebp),%eax
  802a55:	89 c2                	mov    %eax,%edx
  802a57:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  802a5a:	89 c8                	mov    %ecx,%eax
  802a5c:	01 c0                	add    %eax,%eax
  802a5e:	01 c8                	add    %ecx,%eax
  802a60:	c1 e0 02             	shl    $0x2,%eax
  802a63:	05 44 10 81 00       	add    $0x811044,%eax
  802a68:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  802a6a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a6d:	89 d0                	mov    %edx,%eax
  802a6f:	01 c0                	add    %eax,%eax
  802a71:	01 d0                	add    %edx,%eax
  802a73:	c1 e0 02             	shl    $0x2,%eax
  802a76:	05 44 10 81 00       	add    $0x811044,%eax
  802a7b:	8b 00                	mov    (%eax),%eax
  802a7d:	85 c0                	test   %eax,%eax
  802a7f:	75 14                	jne    802a95 <realloc+0x5a7>
  802a81:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a84:	89 d0                	mov    %edx,%eax
  802a86:	01 c0                	add    %eax,%eax
  802a88:	01 d0                	add    %edx,%eax
  802a8a:	c1 e0 02             	shl    $0x2,%eax
  802a8d:	05 48 10 81 00       	add    $0x811048,%eax
  802a92:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  802a95:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a98:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a9b:	01 c2                	add    %eax,%edx
  802a9d:	a1 88 50 83 00       	mov    0x835088,%eax
  802aa2:	39 c2                	cmp    %eax,%edx
  802aa4:	76 0d                	jbe    802ab3 <realloc+0x5c5>
  802aa6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802aa9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802aac:	01 d0                	add    %edx,%eax
  802aae:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  802ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab6:	eb 4e                	jmp    802b06 <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  802ab8:	83 ec 0c             	sub    $0xc,%esp
  802abb:	ff 75 0c             	pushl  0xc(%ebp)
  802abe:	e8 0b ec ff ff       	call   8016ce <malloc>
  802ac3:	83 c4 10             	add    $0x10,%esp
  802ac6:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  802ac9:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  802acd:	75 07                	jne    802ad6 <realloc+0x5e8>
		return NULL;
  802acf:	b8 00 00 00 00       	mov    $0x0,%eax
  802ad4:	eb 30                	jmp    802b06 <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  802ad6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ad9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802adc:	39 d0                	cmp    %edx,%eax
  802ade:	76 02                	jbe    802ae2 <realloc+0x5f4>
  802ae0:	89 d0                	mov    %edx,%eax
  802ae2:	8b 55 9c             	mov    -0x64(%ebp),%edx
  802ae5:	83 ec 04             	sub    $0x4,%esp
  802ae8:	50                   	push   %eax
  802ae9:	52                   	push   %edx
  802aea:	ff 75 cc             	pushl  -0x34(%ebp)
  802aed:	e8 cf 06 00 00       	call   8031c1 <sys_move_user_mem>
  802af2:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  802af5:	83 ec 0c             	sub    $0xc,%esp
  802af8:	ff 75 08             	pushl  0x8(%ebp)
  802afb:	e8 2e ef ff ff       	call   801a2e <free>
  802b00:	83 c4 10             	add    $0x10,%esp
	return newptr;
  802b03:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  802b06:	c9                   	leave  
  802b07:	c3                   	ret    

00802b08 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802b08:	55                   	push   %ebp
  802b09:	89 e5                	mov    %esp,%ebp
  802b0b:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  802b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b11:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  802b14:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802b18:	0f 84 33 03 00 00    	je     802e51 <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  802b1e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b21:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  802b26:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  802b29:	83 ec 08             	sub    $0x8,%esp
  802b2c:	ff 75 08             	pushl  0x8(%ebp)
  802b2f:	ff 75 d8             	pushl  -0x28(%ebp)
  802b32:	e8 7d 05 00 00       	call   8030b4 <sys_delete_shared_object>
  802b37:	83 c4 10             	add    $0x10,%esp
  802b3a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  802b3d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802b41:	0f 88 0d 03 00 00    	js     802e54 <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802b47:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802b4e:	e9 ef 02 00 00       	jmp    802e42 <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802b53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b56:	89 d0                	mov    %edx,%eax
  802b58:	01 c0                	add    %eax,%eax
  802b5a:	01 d0                	add    %edx,%eax
  802b5c:	c1 e0 02             	shl    $0x2,%eax
  802b5f:	05 48 50 80 00       	add    $0x805048,%eax
  802b64:	8a 00                	mov    (%eax),%al
  802b66:	84 c0                	test   %al,%al
  802b68:	0f 84 d1 02 00 00    	je     802e3f <sfree+0x337>
  802b6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b71:	89 d0                	mov    %edx,%eax
  802b73:	01 c0                	add    %eax,%eax
  802b75:	01 d0                	add    %edx,%eax
  802b77:	c1 e0 02             	shl    $0x2,%eax
  802b7a:	05 40 50 80 00       	add    $0x805040,%eax
  802b7f:	8b 00                	mov    (%eax),%eax
  802b81:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802b84:	0f 85 b5 02 00 00    	jne    802e3f <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  802b8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b8d:	89 d0                	mov    %edx,%eax
  802b8f:	01 c0                	add    %eax,%eax
  802b91:	01 d0                	add    %edx,%eax
  802b93:	c1 e0 02             	shl    $0x2,%eax
  802b96:	05 44 50 80 00       	add    $0x805044,%eax
  802b9b:	8b 00                	mov    (%eax),%eax
  802b9d:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  802ba0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ba3:	89 d0                	mov    %edx,%eax
  802ba5:	01 c0                	add    %eax,%eax
  802ba7:	01 d0                	add    %edx,%eax
  802ba9:	c1 e0 02             	shl    $0x2,%eax
  802bac:	05 48 50 80 00       	add    $0x805048,%eax
  802bb1:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  802bb4:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802bbb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802bc2:	eb 64                	jmp    802c28 <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  802bc4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bc7:	89 d0                	mov    %edx,%eax
  802bc9:	01 c0                	add    %eax,%eax
  802bcb:	01 d0                	add    %edx,%eax
  802bcd:	c1 e0 02             	shl    $0x2,%eax
  802bd0:	05 48 10 81 00       	add    $0x811048,%eax
  802bd5:	8a 00                	mov    (%eax),%al
  802bd7:	84 c0                	test   %al,%al
  802bd9:	75 4a                	jne    802c25 <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  802bdb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bde:	89 d0                	mov    %edx,%eax
  802be0:	01 c0                	add    %eax,%eax
  802be2:	01 d0                	add    %edx,%eax
  802be4:	c1 e0 02             	shl    $0x2,%eax
  802be7:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  802bed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802bf0:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  802bf2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bf5:	89 d0                	mov    %edx,%eax
  802bf7:	01 c0                	add    %eax,%eax
  802bf9:	01 d0                	add    %edx,%eax
  802bfb:	c1 e0 02             	shl    $0x2,%eax
  802bfe:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  802c04:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c07:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  802c09:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c0c:	89 d0                	mov    %edx,%eax
  802c0e:	01 c0                	add    %eax,%eax
  802c10:	01 d0                	add    %edx,%eax
  802c12:	c1 e0 02             	shl    $0x2,%eax
  802c15:	05 48 10 81 00       	add    $0x811048,%eax
  802c1a:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  802c1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c20:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  802c23:	eb 0c                	jmp    802c31 <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802c25:	ff 45 ec             	incl   -0x14(%ebp)
  802c28:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802c2f:	7e 93                	jle    802bc4 <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  802c31:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802c35:	0f 84 8d 01 00 00    	je     802dc8 <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802c3b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802c42:	e9 74 01 00 00       	jmp    802dbb <sfree+0x2b3>
				{
					if (k == fidx) continue;
  802c47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c4a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c4d:	0f 84 64 01 00 00    	je     802db7 <sfree+0x2af>
					if (uhp_frees[k].free)
  802c53:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c56:	89 d0                	mov    %edx,%eax
  802c58:	01 c0                	add    %eax,%eax
  802c5a:	01 d0                	add    %edx,%eax
  802c5c:	c1 e0 02             	shl    $0x2,%eax
  802c5f:	05 48 10 81 00       	add    $0x811048,%eax
  802c64:	8a 00                	mov    (%eax),%al
  802c66:	84 c0                	test   %al,%al
  802c68:	0f 84 4a 01 00 00    	je     802db8 <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802c6e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c71:	89 d0                	mov    %edx,%eax
  802c73:	01 c0                	add    %eax,%eax
  802c75:	01 d0                	add    %edx,%eax
  802c77:	c1 e0 02             	shl    $0x2,%eax
  802c7a:	05 40 10 81 00       	add    $0x811040,%eax
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
  802ca2:	05 40 10 81 00       	add    $0x811040,%eax
  802ca7:	8b 00                	mov    (%eax),%eax
  802ca9:	39 c1                	cmp    %eax,%ecx
  802cab:	75 7a                	jne    802d27 <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  802cad:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cb0:	89 d0                	mov    %edx,%eax
  802cb2:	01 c0                	add    %eax,%eax
  802cb4:	01 d0                	add    %edx,%eax
  802cb6:	c1 e0 02             	shl    $0x2,%eax
  802cb9:	05 40 10 81 00       	add    $0x811040,%eax
  802cbe:	8b 10                	mov    (%eax),%edx
  802cc0:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802cc3:	89 c8                	mov    %ecx,%eax
  802cc5:	01 c0                	add    %eax,%eax
  802cc7:	01 c8                	add    %ecx,%eax
  802cc9:	c1 e0 02             	shl    $0x2,%eax
  802ccc:	05 40 10 81 00       	add    $0x811040,%eax
  802cd1:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  802cd3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cd6:	89 d0                	mov    %edx,%eax
  802cd8:	01 c0                	add    %eax,%eax
  802cda:	01 d0                	add    %edx,%eax
  802cdc:	c1 e0 02             	shl    $0x2,%eax
  802cdf:	05 44 10 81 00       	add    $0x811044,%eax
  802ce4:	8b 08                	mov    (%eax),%ecx
  802ce6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ce9:	89 d0                	mov    %edx,%eax
  802ceb:	01 c0                	add    %eax,%eax
  802ced:	01 d0                	add    %edx,%eax
  802cef:	c1 e0 02             	shl    $0x2,%eax
  802cf2:	05 44 10 81 00       	add    $0x811044,%eax
  802cf7:	8b 00                	mov    (%eax),%eax
  802cf9:	01 c1                	add    %eax,%ecx
  802cfb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cfe:	89 d0                	mov    %edx,%eax
  802d00:	01 c0                	add    %eax,%eax
  802d02:	01 d0                	add    %edx,%eax
  802d04:	c1 e0 02             	shl    $0x2,%eax
  802d07:	05 44 10 81 00       	add    $0x811044,%eax
  802d0c:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802d0e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d11:	89 d0                	mov    %edx,%eax
  802d13:	01 c0                	add    %eax,%eax
  802d15:	01 d0                	add    %edx,%eax
  802d17:	c1 e0 02             	shl    $0x2,%eax
  802d1a:	05 48 10 81 00       	add    $0x811048,%eax
  802d1f:	c6 00 00             	movb   $0x0,(%eax)
  802d22:	e9 91 00 00 00       	jmp    802db8 <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802d27:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d2a:	89 d0                	mov    %edx,%eax
  802d2c:	01 c0                	add    %eax,%eax
  802d2e:	01 d0                	add    %edx,%eax
  802d30:	c1 e0 02             	shl    $0x2,%eax
  802d33:	05 40 10 81 00       	add    $0x811040,%eax
  802d38:	8b 08                	mov    (%eax),%ecx
  802d3a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d3d:	89 d0                	mov    %edx,%eax
  802d3f:	01 c0                	add    %eax,%eax
  802d41:	01 d0                	add    %edx,%eax
  802d43:	c1 e0 02             	shl    $0x2,%eax
  802d46:	05 44 10 81 00       	add    $0x811044,%eax
  802d4b:	8b 00                	mov    (%eax),%eax
  802d4d:	01 c1                	add    %eax,%ecx
  802d4f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d52:	89 d0                	mov    %edx,%eax
  802d54:	01 c0                	add    %eax,%eax
  802d56:	01 d0                	add    %edx,%eax
  802d58:	c1 e0 02             	shl    $0x2,%eax
  802d5b:	05 40 10 81 00       	add    $0x811040,%eax
  802d60:	8b 00                	mov    (%eax),%eax
  802d62:	39 c1                	cmp    %eax,%ecx
  802d64:	75 52                	jne    802db8 <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  802d66:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d69:	89 d0                	mov    %edx,%eax
  802d6b:	01 c0                	add    %eax,%eax
  802d6d:	01 d0                	add    %edx,%eax
  802d6f:	c1 e0 02             	shl    $0x2,%eax
  802d72:	05 44 10 81 00       	add    $0x811044,%eax
  802d77:	8b 08                	mov    (%eax),%ecx
  802d79:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d7c:	89 d0                	mov    %edx,%eax
  802d7e:	01 c0                	add    %eax,%eax
  802d80:	01 d0                	add    %edx,%eax
  802d82:	c1 e0 02             	shl    $0x2,%eax
  802d85:	05 44 10 81 00       	add    $0x811044,%eax
  802d8a:	8b 00                	mov    (%eax),%eax
  802d8c:	01 c1                	add    %eax,%ecx
  802d8e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d91:	89 d0                	mov    %edx,%eax
  802d93:	01 c0                	add    %eax,%eax
  802d95:	01 d0                	add    %edx,%eax
  802d97:	c1 e0 02             	shl    $0x2,%eax
  802d9a:	05 44 10 81 00       	add    $0x811044,%eax
  802d9f:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802da1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802da4:	89 d0                	mov    %edx,%eax
  802da6:	01 c0                	add    %eax,%eax
  802da8:	01 d0                	add    %edx,%eax
  802daa:	c1 e0 02             	shl    $0x2,%eax
  802dad:	05 48 10 81 00       	add    $0x811048,%eax
  802db2:	c6 00 00             	movb   $0x0,(%eax)
  802db5:	eb 01                	jmp    802db8 <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  802db7:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802db8:	ff 45 e8             	incl   -0x18(%ebp)
  802dbb:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802dc2:	0f 8e 7f fe ff ff    	jle    802c47 <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  802dc8:	a1 30 51 83 00       	mov    0x835130,%eax
  802dcd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802dd0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802dd7:	eb 53                	jmp    802e2c <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  802dd9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ddc:	89 d0                	mov    %edx,%eax
  802dde:	01 c0                	add    %eax,%eax
  802de0:	01 d0                	add    %edx,%eax
  802de2:	c1 e0 02             	shl    $0x2,%eax
  802de5:	05 48 50 80 00       	add    $0x805048,%eax
  802dea:	8a 00                	mov    (%eax),%al
  802dec:	84 c0                	test   %al,%al
  802dee:	74 39                	je     802e29 <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802df0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802df3:	89 d0                	mov    %edx,%eax
  802df5:	01 c0                	add    %eax,%eax
  802df7:	01 d0                	add    %edx,%eax
  802df9:	c1 e0 02             	shl    $0x2,%eax
  802dfc:	05 40 50 80 00       	add    $0x805040,%eax
  802e01:	8b 08                	mov    (%eax),%ecx
  802e03:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e06:	89 d0                	mov    %edx,%eax
  802e08:	01 c0                	add    %eax,%eax
  802e0a:	01 d0                	add    %edx,%eax
  802e0c:	c1 e0 02             	shl    $0x2,%eax
  802e0f:	05 44 50 80 00       	add    $0x805044,%eax
  802e14:	8b 00                	mov    (%eax),%eax
  802e16:	01 c8                	add    %ecx,%eax
  802e18:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  802e1b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e1e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802e21:	76 06                	jbe    802e29 <sfree+0x321>
  802e23:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e26:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802e29:	ff 45 e0             	incl   -0x20(%ebp)
  802e2c:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802e33:	7e a4                	jle    802dd9 <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  802e35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e38:	a3 88 50 83 00       	mov    %eax,0x835088
			break;
  802e3d:	eb 16                	jmp    802e55 <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802e3f:	ff 45 f4             	incl   -0xc(%ebp)
  802e42:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  802e49:	0f 8e 04 fd ff ff    	jle    802b53 <sfree+0x4b>
  802e4f:	eb 04                	jmp    802e55 <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  802e51:	90                   	nop
  802e52:	eb 01                	jmp    802e55 <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  802e54:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  802e55:	c9                   	leave  
  802e56:	c3                   	ret    

00802e57 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802e57:	55                   	push   %ebp
  802e58:	89 e5                	mov    %esp,%ebp
  802e5a:	57                   	push   %edi
  802e5b:	56                   	push   %esi
  802e5c:	53                   	push   %ebx
  802e5d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802e60:	8b 45 08             	mov    0x8(%ebp),%eax
  802e63:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e66:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802e69:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802e6c:	8b 7d 18             	mov    0x18(%ebp),%edi
  802e6f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802e72:	cd 30                	int    $0x30
  802e74:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802e77:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802e7a:	83 c4 10             	add    $0x10,%esp
  802e7d:	5b                   	pop    %ebx
  802e7e:	5e                   	pop    %esi
  802e7f:	5f                   	pop    %edi
  802e80:	5d                   	pop    %ebp
  802e81:	c3                   	ret    

00802e82 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802e82:	55                   	push   %ebp
  802e83:	89 e5                	mov    %esp,%ebp
  802e85:	83 ec 04             	sub    $0x4,%esp
  802e88:	8b 45 10             	mov    0x10(%ebp),%eax
  802e8b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802e8e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802e91:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802e95:	8b 45 08             	mov    0x8(%ebp),%eax
  802e98:	6a 00                	push   $0x0
  802e9a:	51                   	push   %ecx
  802e9b:	52                   	push   %edx
  802e9c:	ff 75 0c             	pushl  0xc(%ebp)
  802e9f:	50                   	push   %eax
  802ea0:	6a 00                	push   $0x0
  802ea2:	e8 b0 ff ff ff       	call   802e57 <syscall>
  802ea7:	83 c4 18             	add    $0x18,%esp
}
  802eaa:	90                   	nop
  802eab:	c9                   	leave  
  802eac:	c3                   	ret    

00802ead <sys_cgetc>:

int
sys_cgetc(void)
{
  802ead:	55                   	push   %ebp
  802eae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802eb0:	6a 00                	push   $0x0
  802eb2:	6a 00                	push   $0x0
  802eb4:	6a 00                	push   $0x0
  802eb6:	6a 00                	push   $0x0
  802eb8:	6a 00                	push   $0x0
  802eba:	6a 02                	push   $0x2
  802ebc:	e8 96 ff ff ff       	call   802e57 <syscall>
  802ec1:	83 c4 18             	add    $0x18,%esp
}
  802ec4:	c9                   	leave  
  802ec5:	c3                   	ret    

00802ec6 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802ec6:	55                   	push   %ebp
  802ec7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802ec9:	6a 00                	push   $0x0
  802ecb:	6a 00                	push   $0x0
  802ecd:	6a 00                	push   $0x0
  802ecf:	6a 00                	push   $0x0
  802ed1:	6a 00                	push   $0x0
  802ed3:	6a 03                	push   $0x3
  802ed5:	e8 7d ff ff ff       	call   802e57 <syscall>
  802eda:	83 c4 18             	add    $0x18,%esp
}
  802edd:	90                   	nop
  802ede:	c9                   	leave  
  802edf:	c3                   	ret    

00802ee0 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802ee0:	55                   	push   %ebp
  802ee1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802ee3:	6a 00                	push   $0x0
  802ee5:	6a 00                	push   $0x0
  802ee7:	6a 00                	push   $0x0
  802ee9:	6a 00                	push   $0x0
  802eeb:	6a 00                	push   $0x0
  802eed:	6a 04                	push   $0x4
  802eef:	e8 63 ff ff ff       	call   802e57 <syscall>
  802ef4:	83 c4 18             	add    $0x18,%esp
}
  802ef7:	90                   	nop
  802ef8:	c9                   	leave  
  802ef9:	c3                   	ret    

00802efa <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802efa:	55                   	push   %ebp
  802efb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802efd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f00:	8b 45 08             	mov    0x8(%ebp),%eax
  802f03:	6a 00                	push   $0x0
  802f05:	6a 00                	push   $0x0
  802f07:	6a 00                	push   $0x0
  802f09:	52                   	push   %edx
  802f0a:	50                   	push   %eax
  802f0b:	6a 08                	push   $0x8
  802f0d:	e8 45 ff ff ff       	call   802e57 <syscall>
  802f12:	83 c4 18             	add    $0x18,%esp
}
  802f15:	c9                   	leave  
  802f16:	c3                   	ret    

00802f17 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802f17:	55                   	push   %ebp
  802f18:	89 e5                	mov    %esp,%ebp
  802f1a:	56                   	push   %esi
  802f1b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802f1c:	8b 75 18             	mov    0x18(%ebp),%esi
  802f1f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802f22:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802f25:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f28:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2b:	56                   	push   %esi
  802f2c:	53                   	push   %ebx
  802f2d:	51                   	push   %ecx
  802f2e:	52                   	push   %edx
  802f2f:	50                   	push   %eax
  802f30:	6a 09                	push   $0x9
  802f32:	e8 20 ff ff ff       	call   802e57 <syscall>
  802f37:	83 c4 18             	add    $0x18,%esp
}
  802f3a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802f3d:	5b                   	pop    %ebx
  802f3e:	5e                   	pop    %esi
  802f3f:	5d                   	pop    %ebp
  802f40:	c3                   	ret    

00802f41 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802f41:	55                   	push   %ebp
  802f42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802f44:	6a 00                	push   $0x0
  802f46:	6a 00                	push   $0x0
  802f48:	6a 00                	push   $0x0
  802f4a:	6a 00                	push   $0x0
  802f4c:	ff 75 08             	pushl  0x8(%ebp)
  802f4f:	6a 0a                	push   $0xa
  802f51:	e8 01 ff ff ff       	call   802e57 <syscall>
  802f56:	83 c4 18             	add    $0x18,%esp
}
  802f59:	c9                   	leave  
  802f5a:	c3                   	ret    

00802f5b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802f5b:	55                   	push   %ebp
  802f5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802f5e:	6a 00                	push   $0x0
  802f60:	6a 00                	push   $0x0
  802f62:	6a 00                	push   $0x0
  802f64:	ff 75 0c             	pushl  0xc(%ebp)
  802f67:	ff 75 08             	pushl  0x8(%ebp)
  802f6a:	6a 0b                	push   $0xb
  802f6c:	e8 e6 fe ff ff       	call   802e57 <syscall>
  802f71:	83 c4 18             	add    $0x18,%esp
}
  802f74:	c9                   	leave  
  802f75:	c3                   	ret    

00802f76 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802f76:	55                   	push   %ebp
  802f77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802f79:	6a 00                	push   $0x0
  802f7b:	6a 00                	push   $0x0
  802f7d:	6a 00                	push   $0x0
  802f7f:	6a 00                	push   $0x0
  802f81:	6a 00                	push   $0x0
  802f83:	6a 0c                	push   $0xc
  802f85:	e8 cd fe ff ff       	call   802e57 <syscall>
  802f8a:	83 c4 18             	add    $0x18,%esp
}
  802f8d:	c9                   	leave  
  802f8e:	c3                   	ret    

00802f8f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802f8f:	55                   	push   %ebp
  802f90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802f92:	6a 00                	push   $0x0
  802f94:	6a 00                	push   $0x0
  802f96:	6a 00                	push   $0x0
  802f98:	6a 00                	push   $0x0
  802f9a:	6a 00                	push   $0x0
  802f9c:	6a 0d                	push   $0xd
  802f9e:	e8 b4 fe ff ff       	call   802e57 <syscall>
  802fa3:	83 c4 18             	add    $0x18,%esp
}
  802fa6:	c9                   	leave  
  802fa7:	c3                   	ret    

00802fa8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802fa8:	55                   	push   %ebp
  802fa9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802fab:	6a 00                	push   $0x0
  802fad:	6a 00                	push   $0x0
  802faf:	6a 00                	push   $0x0
  802fb1:	6a 00                	push   $0x0
  802fb3:	6a 00                	push   $0x0
  802fb5:	6a 0e                	push   $0xe
  802fb7:	e8 9b fe ff ff       	call   802e57 <syscall>
  802fbc:	83 c4 18             	add    $0x18,%esp
}
  802fbf:	c9                   	leave  
  802fc0:	c3                   	ret    

00802fc1 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802fc1:	55                   	push   %ebp
  802fc2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802fc4:	6a 00                	push   $0x0
  802fc6:	6a 00                	push   $0x0
  802fc8:	6a 00                	push   $0x0
  802fca:	6a 00                	push   $0x0
  802fcc:	6a 00                	push   $0x0
  802fce:	6a 0f                	push   $0xf
  802fd0:	e8 82 fe ff ff       	call   802e57 <syscall>
  802fd5:	83 c4 18             	add    $0x18,%esp
}
  802fd8:	c9                   	leave  
  802fd9:	c3                   	ret    

00802fda <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802fda:	55                   	push   %ebp
  802fdb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802fdd:	6a 00                	push   $0x0
  802fdf:	6a 00                	push   $0x0
  802fe1:	6a 00                	push   $0x0
  802fe3:	6a 00                	push   $0x0
  802fe5:	ff 75 08             	pushl  0x8(%ebp)
  802fe8:	6a 10                	push   $0x10
  802fea:	e8 68 fe ff ff       	call   802e57 <syscall>
  802fef:	83 c4 18             	add    $0x18,%esp
}
  802ff2:	c9                   	leave  
  802ff3:	c3                   	ret    

00802ff4 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802ff4:	55                   	push   %ebp
  802ff5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802ff7:	6a 00                	push   $0x0
  802ff9:	6a 00                	push   $0x0
  802ffb:	6a 00                	push   $0x0
  802ffd:	6a 00                	push   $0x0
  802fff:	6a 00                	push   $0x0
  803001:	6a 11                	push   $0x11
  803003:	e8 4f fe ff ff       	call   802e57 <syscall>
  803008:	83 c4 18             	add    $0x18,%esp
}
  80300b:	90                   	nop
  80300c:	c9                   	leave  
  80300d:	c3                   	ret    

0080300e <sys_cputc>:

void
sys_cputc(const char c)
{
  80300e:	55                   	push   %ebp
  80300f:	89 e5                	mov    %esp,%ebp
  803011:	83 ec 04             	sub    $0x4,%esp
  803014:	8b 45 08             	mov    0x8(%ebp),%eax
  803017:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80301a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80301e:	6a 00                	push   $0x0
  803020:	6a 00                	push   $0x0
  803022:	6a 00                	push   $0x0
  803024:	6a 00                	push   $0x0
  803026:	50                   	push   %eax
  803027:	6a 01                	push   $0x1
  803029:	e8 29 fe ff ff       	call   802e57 <syscall>
  80302e:	83 c4 18             	add    $0x18,%esp
}
  803031:	90                   	nop
  803032:	c9                   	leave  
  803033:	c3                   	ret    

00803034 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  803034:	55                   	push   %ebp
  803035:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  803037:	6a 00                	push   $0x0
  803039:	6a 00                	push   $0x0
  80303b:	6a 00                	push   $0x0
  80303d:	6a 00                	push   $0x0
  80303f:	6a 00                	push   $0x0
  803041:	6a 14                	push   $0x14
  803043:	e8 0f fe ff ff       	call   802e57 <syscall>
  803048:	83 c4 18             	add    $0x18,%esp
}
  80304b:	90                   	nop
  80304c:	c9                   	leave  
  80304d:	c3                   	ret    

0080304e <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80304e:	55                   	push   %ebp
  80304f:	89 e5                	mov    %esp,%ebp
  803051:	83 ec 04             	sub    $0x4,%esp
  803054:	8b 45 10             	mov    0x10(%ebp),%eax
  803057:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80305a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80305d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803061:	8b 45 08             	mov    0x8(%ebp),%eax
  803064:	6a 00                	push   $0x0
  803066:	51                   	push   %ecx
  803067:	52                   	push   %edx
  803068:	ff 75 0c             	pushl  0xc(%ebp)
  80306b:	50                   	push   %eax
  80306c:	6a 15                	push   $0x15
  80306e:	e8 e4 fd ff ff       	call   802e57 <syscall>
  803073:	83 c4 18             	add    $0x18,%esp
}
  803076:	c9                   	leave  
  803077:	c3                   	ret    

00803078 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  803078:	55                   	push   %ebp
  803079:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80307b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80307e:	8b 45 08             	mov    0x8(%ebp),%eax
  803081:	6a 00                	push   $0x0
  803083:	6a 00                	push   $0x0
  803085:	6a 00                	push   $0x0
  803087:	52                   	push   %edx
  803088:	50                   	push   %eax
  803089:	6a 16                	push   $0x16
  80308b:	e8 c7 fd ff ff       	call   802e57 <syscall>
  803090:	83 c4 18             	add    $0x18,%esp
}
  803093:	c9                   	leave  
  803094:	c3                   	ret    

00803095 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  803095:	55                   	push   %ebp
  803096:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  803098:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80309b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80309e:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a1:	6a 00                	push   $0x0
  8030a3:	6a 00                	push   $0x0
  8030a5:	51                   	push   %ecx
  8030a6:	52                   	push   %edx
  8030a7:	50                   	push   %eax
  8030a8:	6a 17                	push   $0x17
  8030aa:	e8 a8 fd ff ff       	call   802e57 <syscall>
  8030af:	83 c4 18             	add    $0x18,%esp
}
  8030b2:	c9                   	leave  
  8030b3:	c3                   	ret    

008030b4 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8030b4:	55                   	push   %ebp
  8030b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8030b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bd:	6a 00                	push   $0x0
  8030bf:	6a 00                	push   $0x0
  8030c1:	6a 00                	push   $0x0
  8030c3:	52                   	push   %edx
  8030c4:	50                   	push   %eax
  8030c5:	6a 18                	push   $0x18
  8030c7:	e8 8b fd ff ff       	call   802e57 <syscall>
  8030cc:	83 c4 18             	add    $0x18,%esp
}
  8030cf:	c9                   	leave  
  8030d0:	c3                   	ret    

008030d1 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8030d1:	55                   	push   %ebp
  8030d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8030d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d7:	6a 00                	push   $0x0
  8030d9:	ff 75 14             	pushl  0x14(%ebp)
  8030dc:	ff 75 10             	pushl  0x10(%ebp)
  8030df:	ff 75 0c             	pushl  0xc(%ebp)
  8030e2:	50                   	push   %eax
  8030e3:	6a 19                	push   $0x19
  8030e5:	e8 6d fd ff ff       	call   802e57 <syscall>
  8030ea:	83 c4 18             	add    $0x18,%esp
}
  8030ed:	c9                   	leave  
  8030ee:	c3                   	ret    

008030ef <sys_run_env>:

void sys_run_env(int32 envId)
{
  8030ef:	55                   	push   %ebp
  8030f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8030f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f5:	6a 00                	push   $0x0
  8030f7:	6a 00                	push   $0x0
  8030f9:	6a 00                	push   $0x0
  8030fb:	6a 00                	push   $0x0
  8030fd:	50                   	push   %eax
  8030fe:	6a 1a                	push   $0x1a
  803100:	e8 52 fd ff ff       	call   802e57 <syscall>
  803105:	83 c4 18             	add    $0x18,%esp
}
  803108:	90                   	nop
  803109:	c9                   	leave  
  80310a:	c3                   	ret    

0080310b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80310b:	55                   	push   %ebp
  80310c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80310e:	8b 45 08             	mov    0x8(%ebp),%eax
  803111:	6a 00                	push   $0x0
  803113:	6a 00                	push   $0x0
  803115:	6a 00                	push   $0x0
  803117:	6a 00                	push   $0x0
  803119:	50                   	push   %eax
  80311a:	6a 1b                	push   $0x1b
  80311c:	e8 36 fd ff ff       	call   802e57 <syscall>
  803121:	83 c4 18             	add    $0x18,%esp
}
  803124:	c9                   	leave  
  803125:	c3                   	ret    

00803126 <sys_getenvid>:

int32 sys_getenvid(void)
{
  803126:	55                   	push   %ebp
  803127:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  803129:	6a 00                	push   $0x0
  80312b:	6a 00                	push   $0x0
  80312d:	6a 00                	push   $0x0
  80312f:	6a 00                	push   $0x0
  803131:	6a 00                	push   $0x0
  803133:	6a 05                	push   $0x5
  803135:	e8 1d fd ff ff       	call   802e57 <syscall>
  80313a:	83 c4 18             	add    $0x18,%esp
}
  80313d:	c9                   	leave  
  80313e:	c3                   	ret    

0080313f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80313f:	55                   	push   %ebp
  803140:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  803142:	6a 00                	push   $0x0
  803144:	6a 00                	push   $0x0
  803146:	6a 00                	push   $0x0
  803148:	6a 00                	push   $0x0
  80314a:	6a 00                	push   $0x0
  80314c:	6a 06                	push   $0x6
  80314e:	e8 04 fd ff ff       	call   802e57 <syscall>
  803153:	83 c4 18             	add    $0x18,%esp
}
  803156:	c9                   	leave  
  803157:	c3                   	ret    

00803158 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  803158:	55                   	push   %ebp
  803159:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80315b:	6a 00                	push   $0x0
  80315d:	6a 00                	push   $0x0
  80315f:	6a 00                	push   $0x0
  803161:	6a 00                	push   $0x0
  803163:	6a 00                	push   $0x0
  803165:	6a 07                	push   $0x7
  803167:	e8 eb fc ff ff       	call   802e57 <syscall>
  80316c:	83 c4 18             	add    $0x18,%esp
}
  80316f:	c9                   	leave  
  803170:	c3                   	ret    

00803171 <sys_exit_env>:


void sys_exit_env(void)
{
  803171:	55                   	push   %ebp
  803172:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  803174:	6a 00                	push   $0x0
  803176:	6a 00                	push   $0x0
  803178:	6a 00                	push   $0x0
  80317a:	6a 00                	push   $0x0
  80317c:	6a 00                	push   $0x0
  80317e:	6a 1c                	push   $0x1c
  803180:	e8 d2 fc ff ff       	call   802e57 <syscall>
  803185:	83 c4 18             	add    $0x18,%esp
}
  803188:	90                   	nop
  803189:	c9                   	leave  
  80318a:	c3                   	ret    

0080318b <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80318b:	55                   	push   %ebp
  80318c:	89 e5                	mov    %esp,%ebp
  80318e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  803191:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803194:	8d 50 04             	lea    0x4(%eax),%edx
  803197:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80319a:	6a 00                	push   $0x0
  80319c:	6a 00                	push   $0x0
  80319e:	6a 00                	push   $0x0
  8031a0:	52                   	push   %edx
  8031a1:	50                   	push   %eax
  8031a2:	6a 1d                	push   $0x1d
  8031a4:	e8 ae fc ff ff       	call   802e57 <syscall>
  8031a9:	83 c4 18             	add    $0x18,%esp
	return result;
  8031ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8031af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8031b2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8031b5:	89 01                	mov    %eax,(%ecx)
  8031b7:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8031ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bd:	c9                   	leave  
  8031be:	c2 04 00             	ret    $0x4

008031c1 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8031c1:	55                   	push   %ebp
  8031c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8031c4:	6a 00                	push   $0x0
  8031c6:	6a 00                	push   $0x0
  8031c8:	ff 75 10             	pushl  0x10(%ebp)
  8031cb:	ff 75 0c             	pushl  0xc(%ebp)
  8031ce:	ff 75 08             	pushl  0x8(%ebp)
  8031d1:	6a 13                	push   $0x13
  8031d3:	e8 7f fc ff ff       	call   802e57 <syscall>
  8031d8:	83 c4 18             	add    $0x18,%esp
	return ;
  8031db:	90                   	nop
}
  8031dc:	c9                   	leave  
  8031dd:	c3                   	ret    

008031de <sys_rcr2>:
uint32 sys_rcr2()
{
  8031de:	55                   	push   %ebp
  8031df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8031e1:	6a 00                	push   $0x0
  8031e3:	6a 00                	push   $0x0
  8031e5:	6a 00                	push   $0x0
  8031e7:	6a 00                	push   $0x0
  8031e9:	6a 00                	push   $0x0
  8031eb:	6a 1e                	push   $0x1e
  8031ed:	e8 65 fc ff ff       	call   802e57 <syscall>
  8031f2:	83 c4 18             	add    $0x18,%esp
}
  8031f5:	c9                   	leave  
  8031f6:	c3                   	ret    

008031f7 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8031f7:	55                   	push   %ebp
  8031f8:	89 e5                	mov    %esp,%ebp
  8031fa:	83 ec 04             	sub    $0x4,%esp
  8031fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803200:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803203:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  803207:	6a 00                	push   $0x0
  803209:	6a 00                	push   $0x0
  80320b:	6a 00                	push   $0x0
  80320d:	6a 00                	push   $0x0
  80320f:	50                   	push   %eax
  803210:	6a 1f                	push   $0x1f
  803212:	e8 40 fc ff ff       	call   802e57 <syscall>
  803217:	83 c4 18             	add    $0x18,%esp
	return ;
  80321a:	90                   	nop
}
  80321b:	c9                   	leave  
  80321c:	c3                   	ret    

0080321d <rsttst>:
void rsttst()
{
  80321d:	55                   	push   %ebp
  80321e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803220:	6a 00                	push   $0x0
  803222:	6a 00                	push   $0x0
  803224:	6a 00                	push   $0x0
  803226:	6a 00                	push   $0x0
  803228:	6a 00                	push   $0x0
  80322a:	6a 21                	push   $0x21
  80322c:	e8 26 fc ff ff       	call   802e57 <syscall>
  803231:	83 c4 18             	add    $0x18,%esp
	return ;
  803234:	90                   	nop
}
  803235:	c9                   	leave  
  803236:	c3                   	ret    

00803237 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  803237:	55                   	push   %ebp
  803238:	89 e5                	mov    %esp,%ebp
  80323a:	83 ec 04             	sub    $0x4,%esp
  80323d:	8b 45 14             	mov    0x14(%ebp),%eax
  803240:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803243:	8b 55 18             	mov    0x18(%ebp),%edx
  803246:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80324a:	52                   	push   %edx
  80324b:	50                   	push   %eax
  80324c:	ff 75 10             	pushl  0x10(%ebp)
  80324f:	ff 75 0c             	pushl  0xc(%ebp)
  803252:	ff 75 08             	pushl  0x8(%ebp)
  803255:	6a 20                	push   $0x20
  803257:	e8 fb fb ff ff       	call   802e57 <syscall>
  80325c:	83 c4 18             	add    $0x18,%esp
	return ;
  80325f:	90                   	nop
}
  803260:	c9                   	leave  
  803261:	c3                   	ret    

00803262 <chktst>:
void chktst(uint32 n)
{
  803262:	55                   	push   %ebp
  803263:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803265:	6a 00                	push   $0x0
  803267:	6a 00                	push   $0x0
  803269:	6a 00                	push   $0x0
  80326b:	6a 00                	push   $0x0
  80326d:	ff 75 08             	pushl  0x8(%ebp)
  803270:	6a 22                	push   $0x22
  803272:	e8 e0 fb ff ff       	call   802e57 <syscall>
  803277:	83 c4 18             	add    $0x18,%esp
	return ;
  80327a:	90                   	nop
}
  80327b:	c9                   	leave  
  80327c:	c3                   	ret    

0080327d <inctst>:

void inctst()
{
  80327d:	55                   	push   %ebp
  80327e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803280:	6a 00                	push   $0x0
  803282:	6a 00                	push   $0x0
  803284:	6a 00                	push   $0x0
  803286:	6a 00                	push   $0x0
  803288:	6a 00                	push   $0x0
  80328a:	6a 23                	push   $0x23
  80328c:	e8 c6 fb ff ff       	call   802e57 <syscall>
  803291:	83 c4 18             	add    $0x18,%esp
	return ;
  803294:	90                   	nop
}
  803295:	c9                   	leave  
  803296:	c3                   	ret    

00803297 <gettst>:
uint32 gettst()
{
  803297:	55                   	push   %ebp
  803298:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80329a:	6a 00                	push   $0x0
  80329c:	6a 00                	push   $0x0
  80329e:	6a 00                	push   $0x0
  8032a0:	6a 00                	push   $0x0
  8032a2:	6a 00                	push   $0x0
  8032a4:	6a 24                	push   $0x24
  8032a6:	e8 ac fb ff ff       	call   802e57 <syscall>
  8032ab:	83 c4 18             	add    $0x18,%esp
}
  8032ae:	c9                   	leave  
  8032af:	c3                   	ret    

008032b0 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8032b0:	55                   	push   %ebp
  8032b1:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8032b3:	6a 00                	push   $0x0
  8032b5:	6a 00                	push   $0x0
  8032b7:	6a 00                	push   $0x0
  8032b9:	6a 00                	push   $0x0
  8032bb:	6a 00                	push   $0x0
  8032bd:	6a 25                	push   $0x25
  8032bf:	e8 93 fb ff ff       	call   802e57 <syscall>
  8032c4:	83 c4 18             	add    $0x18,%esp
  8032c7:	a3 80 50 83 00       	mov    %eax,0x835080
	return uheapPlaceStrategy ;
  8032cc:	a1 80 50 83 00       	mov    0x835080,%eax
}
  8032d1:	c9                   	leave  
  8032d2:	c3                   	ret    

008032d3 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8032d3:	55                   	push   %ebp
  8032d4:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8032d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d9:	a3 80 50 83 00       	mov    %eax,0x835080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8032de:	6a 00                	push   $0x0
  8032e0:	6a 00                	push   $0x0
  8032e2:	6a 00                	push   $0x0
  8032e4:	6a 00                	push   $0x0
  8032e6:	ff 75 08             	pushl  0x8(%ebp)
  8032e9:	6a 26                	push   $0x26
  8032eb:	e8 67 fb ff ff       	call   802e57 <syscall>
  8032f0:	83 c4 18             	add    $0x18,%esp
	return ;
  8032f3:	90                   	nop
}
  8032f4:	c9                   	leave  
  8032f5:	c3                   	ret    

008032f6 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8032f6:	55                   	push   %ebp
  8032f7:	89 e5                	mov    %esp,%ebp
  8032f9:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8032fa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8032fd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803300:	8b 55 0c             	mov    0xc(%ebp),%edx
  803303:	8b 45 08             	mov    0x8(%ebp),%eax
  803306:	6a 00                	push   $0x0
  803308:	53                   	push   %ebx
  803309:	51                   	push   %ecx
  80330a:	52                   	push   %edx
  80330b:	50                   	push   %eax
  80330c:	6a 27                	push   $0x27
  80330e:	e8 44 fb ff ff       	call   802e57 <syscall>
  803313:	83 c4 18             	add    $0x18,%esp
}
  803316:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803319:	c9                   	leave  
  80331a:	c3                   	ret    

0080331b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80331b:	55                   	push   %ebp
  80331c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80331e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803321:	8b 45 08             	mov    0x8(%ebp),%eax
  803324:	6a 00                	push   $0x0
  803326:	6a 00                	push   $0x0
  803328:	6a 00                	push   $0x0
  80332a:	52                   	push   %edx
  80332b:	50                   	push   %eax
  80332c:	6a 28                	push   $0x28
  80332e:	e8 24 fb ff ff       	call   802e57 <syscall>
  803333:	83 c4 18             	add    $0x18,%esp
}
  803336:	c9                   	leave  
  803337:	c3                   	ret    

00803338 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  803338:	55                   	push   %ebp
  803339:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80333b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80333e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803341:	8b 45 08             	mov    0x8(%ebp),%eax
  803344:	6a 00                	push   $0x0
  803346:	51                   	push   %ecx
  803347:	ff 75 10             	pushl  0x10(%ebp)
  80334a:	52                   	push   %edx
  80334b:	50                   	push   %eax
  80334c:	6a 29                	push   $0x29
  80334e:	e8 04 fb ff ff       	call   802e57 <syscall>
  803353:	83 c4 18             	add    $0x18,%esp
}
  803356:	c9                   	leave  
  803357:	c3                   	ret    

00803358 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  803358:	55                   	push   %ebp
  803359:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80335b:	6a 00                	push   $0x0
  80335d:	6a 00                	push   $0x0
  80335f:	ff 75 10             	pushl  0x10(%ebp)
  803362:	ff 75 0c             	pushl  0xc(%ebp)
  803365:	ff 75 08             	pushl  0x8(%ebp)
  803368:	6a 12                	push   $0x12
  80336a:	e8 e8 fa ff ff       	call   802e57 <syscall>
  80336f:	83 c4 18             	add    $0x18,%esp
	return ;
  803372:	90                   	nop
}
  803373:	c9                   	leave  
  803374:	c3                   	ret    

00803375 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  803375:	55                   	push   %ebp
  803376:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  803378:	8b 55 0c             	mov    0xc(%ebp),%edx
  80337b:	8b 45 08             	mov    0x8(%ebp),%eax
  80337e:	6a 00                	push   $0x0
  803380:	6a 00                	push   $0x0
  803382:	6a 00                	push   $0x0
  803384:	52                   	push   %edx
  803385:	50                   	push   %eax
  803386:	6a 2a                	push   $0x2a
  803388:	e8 ca fa ff ff       	call   802e57 <syscall>
  80338d:	83 c4 18             	add    $0x18,%esp
	return;
  803390:	90                   	nop
}
  803391:	c9                   	leave  
  803392:	c3                   	ret    

00803393 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  803393:	55                   	push   %ebp
  803394:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  803396:	6a 00                	push   $0x0
  803398:	6a 00                	push   $0x0
  80339a:	6a 00                	push   $0x0
  80339c:	6a 00                	push   $0x0
  80339e:	6a 00                	push   $0x0
  8033a0:	6a 2b                	push   $0x2b
  8033a2:	e8 b0 fa ff ff       	call   802e57 <syscall>
  8033a7:	83 c4 18             	add    $0x18,%esp
}
  8033aa:	c9                   	leave  
  8033ab:	c3                   	ret    

008033ac <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8033ac:	55                   	push   %ebp
  8033ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8033af:	6a 00                	push   $0x0
  8033b1:	6a 00                	push   $0x0
  8033b3:	6a 00                	push   $0x0
  8033b5:	ff 75 0c             	pushl  0xc(%ebp)
  8033b8:	ff 75 08             	pushl  0x8(%ebp)
  8033bb:	6a 2d                	push   $0x2d
  8033bd:	e8 95 fa ff ff       	call   802e57 <syscall>
  8033c2:	83 c4 18             	add    $0x18,%esp
	return;
  8033c5:	90                   	nop
}
  8033c6:	c9                   	leave  
  8033c7:	c3                   	ret    

008033c8 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8033c8:	55                   	push   %ebp
  8033c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8033cb:	6a 00                	push   $0x0
  8033cd:	6a 00                	push   $0x0
  8033cf:	6a 00                	push   $0x0
  8033d1:	ff 75 0c             	pushl  0xc(%ebp)
  8033d4:	ff 75 08             	pushl  0x8(%ebp)
  8033d7:	6a 2c                	push   $0x2c
  8033d9:	e8 79 fa ff ff       	call   802e57 <syscall>
  8033de:	83 c4 18             	add    $0x18,%esp
	return ;
  8033e1:	90                   	nop
}
  8033e2:	c9                   	leave  
  8033e3:	c3                   	ret    

008033e4 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8033e4:	55                   	push   %ebp
  8033e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8033e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ed:	6a 00                	push   $0x0
  8033ef:	6a 00                	push   $0x0
  8033f1:	6a 00                	push   $0x0
  8033f3:	52                   	push   %edx
  8033f4:	50                   	push   %eax
  8033f5:	6a 2e                	push   $0x2e
  8033f7:	e8 5b fa ff ff       	call   802e57 <syscall>
  8033fc:	83 c4 18             	add    $0x18,%esp
}
  8033ff:	90                   	nop
  803400:	c9                   	leave  
  803401:	c3                   	ret    

00803402 <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  803402:	55                   	push   %ebp
  803403:	89 e5                	mov    %esp,%ebp
  803405:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  803408:	81 7d 08 80 d0 81 00 	cmpl   $0x81d080,0x8(%ebp)
  80340f:	72 09                	jb     80341a <to_page_va+0x18>
  803411:	81 7d 08 80 50 83 00 	cmpl   $0x835080,0x8(%ebp)
  803418:	72 14                	jb     80342e <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  80341a:	83 ec 04             	sub    $0x4,%esp
  80341d:	68 58 49 80 00       	push   $0x804958
  803422:	6a 15                	push   $0x15
  803424:	68 83 49 80 00       	push   $0x804983
  803429:	e8 10 d0 ff ff       	call   80043e <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  80342e:	8b 45 08             	mov    0x8(%ebp),%eax
  803431:	ba 80 d0 81 00       	mov    $0x81d080,%edx
  803436:	29 d0                	sub    %edx,%eax
  803438:	c1 f8 02             	sar    $0x2,%eax
  80343b:	89 c2                	mov    %eax,%edx
  80343d:	89 d0                	mov    %edx,%eax
  80343f:	c1 e0 02             	shl    $0x2,%eax
  803442:	01 d0                	add    %edx,%eax
  803444:	c1 e0 02             	shl    $0x2,%eax
  803447:	01 d0                	add    %edx,%eax
  803449:	c1 e0 02             	shl    $0x2,%eax
  80344c:	01 d0                	add    %edx,%eax
  80344e:	89 c1                	mov    %eax,%ecx
  803450:	c1 e1 08             	shl    $0x8,%ecx
  803453:	01 c8                	add    %ecx,%eax
  803455:	89 c1                	mov    %eax,%ecx
  803457:	c1 e1 10             	shl    $0x10,%ecx
  80345a:	01 c8                	add    %ecx,%eax
  80345c:	01 c0                	add    %eax,%eax
  80345e:	01 d0                	add    %edx,%eax
  803460:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  803463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803466:	c1 e0 0c             	shl    $0xc,%eax
  803469:	89 c2                	mov    %eax,%edx
  80346b:	a1 84 50 83 00       	mov    0x835084,%eax
  803470:	01 d0                	add    %edx,%eax
}
  803472:	c9                   	leave  
  803473:	c3                   	ret    

00803474 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  803474:	55                   	push   %ebp
  803475:	89 e5                	mov    %esp,%ebp
  803477:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  80347a:	a1 84 50 83 00       	mov    0x835084,%eax
  80347f:	8b 55 08             	mov    0x8(%ebp),%edx
  803482:	29 c2                	sub    %eax,%edx
  803484:	89 d0                	mov    %edx,%eax
  803486:	c1 e8 0c             	shr    $0xc,%eax
  803489:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  80348c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803490:	78 09                	js     80349b <to_page_info+0x27>
  803492:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  803499:	7e 14                	jle    8034af <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  80349b:	83 ec 04             	sub    $0x4,%esp
  80349e:	68 9c 49 80 00       	push   $0x80499c
  8034a3:	6a 21                	push   $0x21
  8034a5:	68 83 49 80 00       	push   $0x804983
  8034aa:	e8 8f cf ff ff       	call   80043e <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  8034af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034b2:	89 d0                	mov    %edx,%eax
  8034b4:	01 c0                	add    %eax,%eax
  8034b6:	01 d0                	add    %edx,%eax
  8034b8:	c1 e0 02             	shl    $0x2,%eax
  8034bb:	05 80 d0 81 00       	add    $0x81d080,%eax
}
  8034c0:	c9                   	leave  
  8034c1:	c3                   	ret    

008034c2 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8034c2:	55                   	push   %ebp
  8034c3:	89 e5                	mov    %esp,%ebp
  8034c5:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8034c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034cb:	05 00 00 00 02       	add    $0x2000000,%eax
  8034d0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8034d3:	73 16                	jae    8034eb <initialize_dynamic_allocator+0x29>
  8034d5:	68 c0 49 80 00       	push   $0x8049c0
  8034da:	68 e6 49 80 00       	push   $0x8049e6
  8034df:	6a 2f                	push   $0x2f
  8034e1:	68 83 49 80 00       	push   $0x804983
  8034e6:	e8 53 cf ff ff       	call   80043e <_panic>
	dynAllocStart = daStart;
  8034eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ee:	a3 84 50 83 00       	mov    %eax,0x835084
	dynAllocEnd = daEnd;
  8034f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034f6:	a3 60 d0 81 00       	mov    %eax,0x81d060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8034fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803502:	eb 36                	jmp    80353a <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  803504:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803507:	c1 e0 04             	shl    $0x4,%eax
  80350a:	05 a0 50 83 00       	add    $0x8350a0,%eax
  80350f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803518:	c1 e0 04             	shl    $0x4,%eax
  80351b:	05 a4 50 83 00       	add    $0x8350a4,%eax
  803520:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803526:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803529:	c1 e0 04             	shl    $0x4,%eax
  80352c:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803531:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803537:	ff 45 f4             	incl   -0xc(%ebp)
  80353a:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  80353e:	7e c4                	jle    803504 <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  803540:	c7 05 68 d0 81 00 00 	movl   $0x0,0x81d068
  803547:	00 00 00 
  80354a:	c7 05 6c d0 81 00 00 	movl   $0x0,0x81d06c
  803551:	00 00 00 
  803554:	c7 05 74 d0 81 00 00 	movl   $0x0,0x81d074
  80355b:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  80355e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803565:	e9 1b 01 00 00       	jmp    803685 <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  80356a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80356d:	89 d0                	mov    %edx,%eax
  80356f:	01 c0                	add    %eax,%eax
  803571:	01 d0                	add    %edx,%eax
  803573:	c1 e0 02             	shl    $0x2,%eax
  803576:	05 88 d0 81 00       	add    $0x81d088,%eax
  80357b:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  803580:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803583:	89 d0                	mov    %edx,%eax
  803585:	01 c0                	add    %eax,%eax
  803587:	01 d0                	add    %edx,%eax
  803589:	c1 e0 02             	shl    $0x2,%eax
  80358c:	05 8a d0 81 00       	add    $0x81d08a,%eax
  803591:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  803596:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803599:	89 d0                	mov    %edx,%eax
  80359b:	01 c0                	add    %eax,%eax
  80359d:	01 d0                	add    %edx,%eax
  80359f:	c1 e0 02             	shl    $0x2,%eax
  8035a2:	05 80 d0 81 00       	add    $0x81d080,%eax
  8035a7:	8b 00                	mov    (%eax),%eax
  8035a9:	85 c0                	test   %eax,%eax
  8035ab:	74 2b                	je     8035d8 <initialize_dynamic_allocator+0x116>
  8035ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035b0:	89 d0                	mov    %edx,%eax
  8035b2:	01 c0                	add    %eax,%eax
  8035b4:	01 d0                	add    %edx,%eax
  8035b6:	c1 e0 02             	shl    $0x2,%eax
  8035b9:	05 80 d0 81 00       	add    $0x81d080,%eax
  8035be:	8b 10                	mov    (%eax),%edx
  8035c0:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8035c3:	89 c8                	mov    %ecx,%eax
  8035c5:	01 c0                	add    %eax,%eax
  8035c7:	01 c8                	add    %ecx,%eax
  8035c9:	c1 e0 02             	shl    $0x2,%eax
  8035cc:	05 84 d0 81 00       	add    $0x81d084,%eax
  8035d1:	8b 00                	mov    (%eax),%eax
  8035d3:	89 42 04             	mov    %eax,0x4(%edx)
  8035d6:	eb 18                	jmp    8035f0 <initialize_dynamic_allocator+0x12e>
  8035d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035db:	89 d0                	mov    %edx,%eax
  8035dd:	01 c0                	add    %eax,%eax
  8035df:	01 d0                	add    %edx,%eax
  8035e1:	c1 e0 02             	shl    $0x2,%eax
  8035e4:	05 84 d0 81 00       	add    $0x81d084,%eax
  8035e9:	8b 00                	mov    (%eax),%eax
  8035eb:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  8035f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035f3:	89 d0                	mov    %edx,%eax
  8035f5:	01 c0                	add    %eax,%eax
  8035f7:	01 d0                	add    %edx,%eax
  8035f9:	c1 e0 02             	shl    $0x2,%eax
  8035fc:	05 84 d0 81 00       	add    $0x81d084,%eax
  803601:	8b 00                	mov    (%eax),%eax
  803603:	85 c0                	test   %eax,%eax
  803605:	74 2a                	je     803631 <initialize_dynamic_allocator+0x16f>
  803607:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80360a:	89 d0                	mov    %edx,%eax
  80360c:	01 c0                	add    %eax,%eax
  80360e:	01 d0                	add    %edx,%eax
  803610:	c1 e0 02             	shl    $0x2,%eax
  803613:	05 84 d0 81 00       	add    $0x81d084,%eax
  803618:	8b 10                	mov    (%eax),%edx
  80361a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80361d:	89 c8                	mov    %ecx,%eax
  80361f:	01 c0                	add    %eax,%eax
  803621:	01 c8                	add    %ecx,%eax
  803623:	c1 e0 02             	shl    $0x2,%eax
  803626:	05 80 d0 81 00       	add    $0x81d080,%eax
  80362b:	8b 00                	mov    (%eax),%eax
  80362d:	89 02                	mov    %eax,(%edx)
  80362f:	eb 18                	jmp    803649 <initialize_dynamic_allocator+0x187>
  803631:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803634:	89 d0                	mov    %edx,%eax
  803636:	01 c0                	add    %eax,%eax
  803638:	01 d0                	add    %edx,%eax
  80363a:	c1 e0 02             	shl    $0x2,%eax
  80363d:	05 80 d0 81 00       	add    $0x81d080,%eax
  803642:	8b 00                	mov    (%eax),%eax
  803644:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803649:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80364c:	89 d0                	mov    %edx,%eax
  80364e:	01 c0                	add    %eax,%eax
  803650:	01 d0                	add    %edx,%eax
  803652:	c1 e0 02             	shl    $0x2,%eax
  803655:	05 80 d0 81 00       	add    $0x81d080,%eax
  80365a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803660:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803663:	89 d0                	mov    %edx,%eax
  803665:	01 c0                	add    %eax,%eax
  803667:	01 d0                	add    %edx,%eax
  803669:	c1 e0 02             	shl    $0x2,%eax
  80366c:	05 84 d0 81 00       	add    $0x81d084,%eax
  803671:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803677:	a1 74 d0 81 00       	mov    0x81d074,%eax
  80367c:	48                   	dec    %eax
  80367d:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803682:	ff 45 f0             	incl   -0x10(%ebp)
  803685:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  80368c:	0f 8e d8 fe ff ff    	jle    80356a <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803692:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  803699:	e9 9d 00 00 00       	jmp    80373b <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  80369e:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8036a4:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  8036a7:	89 c8                	mov    %ecx,%eax
  8036a9:	01 c0                	add    %eax,%eax
  8036ab:	01 c8                	add    %ecx,%eax
  8036ad:	c1 e0 02             	shl    $0x2,%eax
  8036b0:	05 80 d0 81 00       	add    $0x81d080,%eax
  8036b5:	89 10                	mov    %edx,(%eax)
  8036b7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036ba:	89 d0                	mov    %edx,%eax
  8036bc:	01 c0                	add    %eax,%eax
  8036be:	01 d0                	add    %edx,%eax
  8036c0:	c1 e0 02             	shl    $0x2,%eax
  8036c3:	05 80 d0 81 00       	add    $0x81d080,%eax
  8036c8:	8b 00                	mov    (%eax),%eax
  8036ca:	85 c0                	test   %eax,%eax
  8036cc:	74 1c                	je     8036ea <initialize_dynamic_allocator+0x228>
  8036ce:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8036d4:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  8036d7:	89 c8                	mov    %ecx,%eax
  8036d9:	01 c0                	add    %eax,%eax
  8036db:	01 c8                	add    %ecx,%eax
  8036dd:	c1 e0 02             	shl    $0x2,%eax
  8036e0:	05 80 d0 81 00       	add    $0x81d080,%eax
  8036e5:	89 42 04             	mov    %eax,0x4(%edx)
  8036e8:	eb 16                	jmp    803700 <initialize_dynamic_allocator+0x23e>
  8036ea:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036ed:	89 d0                	mov    %edx,%eax
  8036ef:	01 c0                	add    %eax,%eax
  8036f1:	01 d0                	add    %edx,%eax
  8036f3:	c1 e0 02             	shl    $0x2,%eax
  8036f6:	05 80 d0 81 00       	add    $0x81d080,%eax
  8036fb:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803700:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803703:	89 d0                	mov    %edx,%eax
  803705:	01 c0                	add    %eax,%eax
  803707:	01 d0                	add    %edx,%eax
  803709:	c1 e0 02             	shl    $0x2,%eax
  80370c:	05 80 d0 81 00       	add    $0x81d080,%eax
  803711:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803716:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803719:	89 d0                	mov    %edx,%eax
  80371b:	01 c0                	add    %eax,%eax
  80371d:	01 d0                	add    %edx,%eax
  80371f:	c1 e0 02             	shl    $0x2,%eax
  803722:	05 84 d0 81 00       	add    $0x81d084,%eax
  803727:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80372d:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803732:	40                   	inc    %eax
  803733:	a3 74 d0 81 00       	mov    %eax,0x81d074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803738:	ff 4d ec             	decl   -0x14(%ebp)
  80373b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80373f:	0f 89 59 ff ff ff    	jns    80369e <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  803745:	c7 05 44 d0 81 00 01 	movl   $0x1,0x81d044
  80374c:	00 00 00 
}
  80374f:	90                   	nop
  803750:	c9                   	leave  
  803751:	c3                   	ret    

00803752 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  803752:	55                   	push   %ebp
  803753:	89 e5                	mov    %esp,%ebp
  803755:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803758:	8b 45 08             	mov    0x8(%ebp),%eax
  80375b:	83 ec 0c             	sub    $0xc,%esp
  80375e:	50                   	push   %eax
  80375f:	e8 10 fd ff ff       	call   803474 <to_page_info>
  803764:	83 c4 10             	add    $0x10,%esp
  803767:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  80376a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80376d:	8b 40 08             	mov    0x8(%eax),%eax
  803770:	0f b7 c0             	movzwl %ax,%eax
}
  803773:	c9                   	leave  
  803774:	c3                   	ret    

00803775 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803775:	55                   	push   %ebp
  803776:	89 e5                	mov    %esp,%ebp
  803778:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  80377b:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803782:	76 16                	jbe    80379a <alloc_block+0x25>
  803784:	68 fc 49 80 00       	push   $0x8049fc
  803789:	68 e6 49 80 00       	push   $0x8049e6
  80378e:	6a 59                	push   $0x59
  803790:	68 83 49 80 00       	push   $0x804983
  803795:	e8 a4 cc ff ff       	call   80043e <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  80379a:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  8037a1:	eb 08                	jmp    8037ab <alloc_block+0x36>
		allocSize <<= 1;
  8037a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a6:	01 c0                	add    %eax,%eax
  8037a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  8037ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ae:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037b1:	73 09                	jae    8037bc <alloc_block+0x47>
  8037b3:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  8037ba:	76 e7                	jbe    8037a3 <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  8037bc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  8037c3:	eb 03                	jmp    8037c8 <alloc_block+0x53>
		listIndex++;
  8037c5:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  8037c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037cb:	ba 08 00 00 00       	mov    $0x8,%edx
  8037d0:	88 c1                	mov    %al,%cl
  8037d2:	d3 e2                	shl    %cl,%edx
  8037d4:	89 d0                	mov    %edx,%eax
  8037d6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8037d9:	72 ea                	jb     8037c5 <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8037db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037de:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8037e1:	e9 f4 00 00 00       	jmp    8038da <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  8037e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037e9:	c1 e0 04             	shl    $0x4,%eax
  8037ec:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8037f1:	8b 00                	mov    (%eax),%eax
  8037f3:	85 c0                	test   %eax,%eax
  8037f5:	0f 84 dc 00 00 00    	je     8038d7 <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  8037fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037fe:	c1 e0 04             	shl    $0x4,%eax
  803801:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803806:	8b 00                	mov    (%eax),%eax
  803808:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  80380b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80380f:	75 14                	jne    803825 <alloc_block+0xb0>
  803811:	83 ec 04             	sub    $0x4,%esp
  803814:	68 1d 4a 80 00       	push   $0x804a1d
  803819:	6a 6b                	push   $0x6b
  80381b:	68 83 49 80 00       	push   $0x804983
  803820:	e8 19 cc ff ff       	call   80043e <_panic>
  803825:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803828:	8b 00                	mov    (%eax),%eax
  80382a:	85 c0                	test   %eax,%eax
  80382c:	74 10                	je     80383e <alloc_block+0xc9>
  80382e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803831:	8b 00                	mov    (%eax),%eax
  803833:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803836:	8b 52 04             	mov    0x4(%edx),%edx
  803839:	89 50 04             	mov    %edx,0x4(%eax)
  80383c:	eb 14                	jmp    803852 <alloc_block+0xdd>
  80383e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803841:	8b 40 04             	mov    0x4(%eax),%eax
  803844:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803847:	c1 e2 04             	shl    $0x4,%edx
  80384a:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803850:	89 02                	mov    %eax,(%edx)
  803852:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803855:	8b 40 04             	mov    0x4(%eax),%eax
  803858:	85 c0                	test   %eax,%eax
  80385a:	74 0f                	je     80386b <alloc_block+0xf6>
  80385c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80385f:	8b 40 04             	mov    0x4(%eax),%eax
  803862:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803865:	8b 12                	mov    (%edx),%edx
  803867:	89 10                	mov    %edx,(%eax)
  803869:	eb 13                	jmp    80387e <alloc_block+0x109>
  80386b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80386e:	8b 00                	mov    (%eax),%eax
  803870:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803873:	c1 e2 04             	shl    $0x4,%edx
  803876:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  80387c:	89 02                	mov    %eax,(%edx)
  80387e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803881:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803887:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80388a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803891:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803894:	c1 e0 04             	shl    $0x4,%eax
  803897:	05 ac 50 83 00       	add    $0x8350ac,%eax
  80389c:	8b 00                	mov    (%eax),%eax
  80389e:	8d 50 ff             	lea    -0x1(%eax),%edx
  8038a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038a4:	c1 e0 04             	shl    $0x4,%eax
  8038a7:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8038ac:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  8038ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038b1:	83 ec 0c             	sub    $0xc,%esp
  8038b4:	50                   	push   %eax
  8038b5:	e8 ba fb ff ff       	call   803474 <to_page_info>
  8038ba:	83 c4 10             	add    $0x10,%esp
  8038bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  8038c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038c3:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8038c7:	48                   	dec    %eax
  8038c8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8038cb:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  8038cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038d2:	e9 8f 02 00 00       	jmp    803b66 <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8038d7:	ff 45 ec             	incl   -0x14(%ebp)
  8038da:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8038de:	0f 8e 02 ff ff ff    	jle    8037e6 <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  8038e4:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8038e9:	85 c0                	test   %eax,%eax
  8038eb:	75 14                	jne    803901 <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  8038ed:	83 ec 04             	sub    $0x4,%esp
  8038f0:	68 3c 4a 80 00       	push   $0x804a3c
  8038f5:	6a 77                	push   $0x77
  8038f7:	68 83 49 80 00       	push   $0x804983
  8038fc:	e8 3d cb ff ff       	call   80043e <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  803901:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803906:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  803909:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80390d:	75 14                	jne    803923 <alloc_block+0x1ae>
  80390f:	83 ec 04             	sub    $0x4,%esp
  803912:	68 1d 4a 80 00       	push   $0x804a1d
  803917:	6a 7a                	push   $0x7a
  803919:	68 83 49 80 00       	push   $0x804983
  80391e:	e8 1b cb ff ff       	call   80043e <_panic>
  803923:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803926:	8b 00                	mov    (%eax),%eax
  803928:	85 c0                	test   %eax,%eax
  80392a:	74 10                	je     80393c <alloc_block+0x1c7>
  80392c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80392f:	8b 00                	mov    (%eax),%eax
  803931:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803934:	8b 52 04             	mov    0x4(%edx),%edx
  803937:	89 50 04             	mov    %edx,0x4(%eax)
  80393a:	eb 0b                	jmp    803947 <alloc_block+0x1d2>
  80393c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80393f:	8b 40 04             	mov    0x4(%eax),%eax
  803942:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803947:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80394a:	8b 40 04             	mov    0x4(%eax),%eax
  80394d:	85 c0                	test   %eax,%eax
  80394f:	74 0f                	je     803960 <alloc_block+0x1eb>
  803951:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803954:	8b 40 04             	mov    0x4(%eax),%eax
  803957:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80395a:	8b 12                	mov    (%edx),%edx
  80395c:	89 10                	mov    %edx,(%eax)
  80395e:	eb 0a                	jmp    80396a <alloc_block+0x1f5>
  803960:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803963:	8b 00                	mov    (%eax),%eax
  803965:	a3 68 d0 81 00       	mov    %eax,0x81d068
  80396a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80396d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803973:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803976:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80397d:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803982:	48                   	dec    %eax
  803983:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  803988:	83 ec 0c             	sub    $0xc,%esp
  80398b:	ff 75 dc             	pushl  -0x24(%ebp)
  80398e:	e8 6f fa ff ff       	call   803402 <to_page_va>
  803993:	83 c4 10             	add    $0x10,%esp
  803996:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  803999:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80399c:	83 ec 0c             	sub    $0xc,%esp
  80399f:	50                   	push   %eax
  8039a0:	e8 a0 dc ff ff       	call   801645 <get_page>
  8039a5:	83 c4 10             	add    $0x10,%esp
  8039a8:	85 c0                	test   %eax,%eax
  8039aa:	74 14                	je     8039c0 <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  8039ac:	83 ec 04             	sub    $0x4,%esp
  8039af:	68 64 4a 80 00       	push   $0x804a64
  8039b4:	6a 7f                	push   $0x7f
  8039b6:	68 83 49 80 00       	push   $0x804983
  8039bb:	e8 7e ca ff ff       	call   80043e <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  8039c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039c3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8039c6:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  8039ca:	b8 00 10 00 00       	mov    $0x1000,%eax
  8039cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8039d4:	f7 75 f4             	divl   -0xc(%ebp)
  8039d7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8039da:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  8039de:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8039e5:	e9 a7 00 00 00       	jmp    803a91 <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  8039ea:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8039ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039f0:	01 d0                	add    %edx,%eax
  8039f2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  8039f5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8039f9:	75 17                	jne    803a12 <alloc_block+0x29d>
  8039fb:	83 ec 04             	sub    $0x4,%esp
  8039fe:	68 8c 4a 80 00       	push   $0x804a8c
  803a03:	68 88 00 00 00       	push   $0x88
  803a08:	68 83 49 80 00       	push   $0x804983
  803a0d:	e8 2c ca ff ff       	call   80043e <_panic>
  803a12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a15:	c1 e0 04             	shl    $0x4,%eax
  803a18:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803a1d:	8b 10                	mov    (%eax),%edx
  803a1f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a22:	89 10                	mov    %edx,(%eax)
  803a24:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a27:	8b 00                	mov    (%eax),%eax
  803a29:	85 c0                	test   %eax,%eax
  803a2b:	74 15                	je     803a42 <alloc_block+0x2cd>
  803a2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a30:	c1 e0 04             	shl    $0x4,%eax
  803a33:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803a38:	8b 00                	mov    (%eax),%eax
  803a3a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a3d:	89 50 04             	mov    %edx,0x4(%eax)
  803a40:	eb 11                	jmp    803a53 <alloc_block+0x2de>
  803a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a45:	c1 e0 04             	shl    $0x4,%eax
  803a48:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803a4e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a51:	89 02                	mov    %eax,(%edx)
  803a53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a56:	c1 e0 04             	shl    $0x4,%eax
  803a59:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803a5f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a62:	89 02                	mov    %eax,(%edx)
  803a64:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a67:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a71:	c1 e0 04             	shl    $0x4,%eax
  803a74:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803a79:	8b 00                	mov    (%eax),%eax
  803a7b:	8d 50 01             	lea    0x1(%eax),%edx
  803a7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a81:	c1 e0 04             	shl    $0x4,%eax
  803a84:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803a89:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a8e:	01 45 e8             	add    %eax,-0x18(%ebp)
  803a91:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  803a98:	0f 86 4c ff ff ff    	jbe    8039ea <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  803a9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803aa1:	c1 e0 04             	shl    $0x4,%eax
  803aa4:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803aa9:	8b 00                	mov    (%eax),%eax
  803aab:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  803aae:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803ab2:	75 17                	jne    803acb <alloc_block+0x356>
  803ab4:	83 ec 04             	sub    $0x4,%esp
  803ab7:	68 1d 4a 80 00       	push   $0x804a1d
  803abc:	68 8d 00 00 00       	push   $0x8d
  803ac1:	68 83 49 80 00       	push   $0x804983
  803ac6:	e8 73 c9 ff ff       	call   80043e <_panic>
  803acb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803ace:	8b 00                	mov    (%eax),%eax
  803ad0:	85 c0                	test   %eax,%eax
  803ad2:	74 10                	je     803ae4 <alloc_block+0x36f>
  803ad4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803ad7:	8b 00                	mov    (%eax),%eax
  803ad9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803adc:	8b 52 04             	mov    0x4(%edx),%edx
  803adf:	89 50 04             	mov    %edx,0x4(%eax)
  803ae2:	eb 14                	jmp    803af8 <alloc_block+0x383>
  803ae4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803ae7:	8b 40 04             	mov    0x4(%eax),%eax
  803aea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803aed:	c1 e2 04             	shl    $0x4,%edx
  803af0:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803af6:	89 02                	mov    %eax,(%edx)
  803af8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803afb:	8b 40 04             	mov    0x4(%eax),%eax
  803afe:	85 c0                	test   %eax,%eax
  803b00:	74 0f                	je     803b11 <alloc_block+0x39c>
  803b02:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b05:	8b 40 04             	mov    0x4(%eax),%eax
  803b08:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803b0b:	8b 12                	mov    (%edx),%edx
  803b0d:	89 10                	mov    %edx,(%eax)
  803b0f:	eb 13                	jmp    803b24 <alloc_block+0x3af>
  803b11:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b14:	8b 00                	mov    (%eax),%eax
  803b16:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b19:	c1 e2 04             	shl    $0x4,%edx
  803b1c:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803b22:	89 02                	mov    %eax,(%edx)
  803b24:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b27:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b2d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b30:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b3a:	c1 e0 04             	shl    $0x4,%eax
  803b3d:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803b42:	8b 00                	mov    (%eax),%eax
  803b44:	8d 50 ff             	lea    -0x1(%eax),%edx
  803b47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b4a:	c1 e0 04             	shl    $0x4,%eax
  803b4d:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803b52:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  803b54:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b57:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803b5b:	48                   	dec    %eax
  803b5c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803b5f:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  803b63:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  803b66:	c9                   	leave  
  803b67:	c3                   	ret    

00803b68 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803b68:	55                   	push   %ebp
  803b69:	89 e5                	mov    %esp,%ebp
  803b6b:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803b6e:	8b 55 08             	mov    0x8(%ebp),%edx
  803b71:	a1 84 50 83 00       	mov    0x835084,%eax
  803b76:	39 c2                	cmp    %eax,%edx
  803b78:	72 0c                	jb     803b86 <free_block+0x1e>
  803b7a:	8b 55 08             	mov    0x8(%ebp),%edx
  803b7d:	a1 60 d0 81 00       	mov    0x81d060,%eax
  803b82:	39 c2                	cmp    %eax,%edx
  803b84:	72 19                	jb     803b9f <free_block+0x37>
  803b86:	68 b0 4a 80 00       	push   $0x804ab0
  803b8b:	68 e6 49 80 00       	push   $0x8049e6
  803b90:	68 98 00 00 00       	push   $0x98
  803b95:	68 83 49 80 00       	push   $0x804983
  803b9a:	e8 9f c8 ff ff       	call   80043e <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  803ba2:	83 ec 0c             	sub    $0xc,%esp
  803ba5:	50                   	push   %eax
  803ba6:	e8 c9 f8 ff ff       	call   803474 <to_page_info>
  803bab:	83 c4 10             	add    $0x10,%esp
  803bae:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  803bb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bb4:	8b 40 08             	mov    0x8(%eax),%eax
  803bb7:	0f b7 c0             	movzwl %ax,%eax
  803bba:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  803bbd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803bc4:	eb 03                	jmp    803bc9 <free_block+0x61>
		listIndex++;
  803bc6:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bcc:	ba 08 00 00 00       	mov    $0x8,%edx
  803bd1:	88 c1                	mov    %al,%cl
  803bd3:	d3 e2                	shl    %cl,%edx
  803bd5:	89 d0                	mov    %edx,%eax
  803bd7:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803bda:	72 ea                	jb     803bc6 <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  803bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  803bdf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  803be2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803be6:	75 17                	jne    803bff <free_block+0x97>
  803be8:	83 ec 04             	sub    $0x4,%esp
  803beb:	68 8c 4a 80 00       	push   $0x804a8c
  803bf0:	68 a2 00 00 00       	push   $0xa2
  803bf5:	68 83 49 80 00       	push   $0x804983
  803bfa:	e8 3f c8 ff ff       	call   80043e <_panic>
  803bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c02:	c1 e0 04             	shl    $0x4,%eax
  803c05:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803c0a:	8b 10                	mov    (%eax),%edx
  803c0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c0f:	89 10                	mov    %edx,(%eax)
  803c11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c14:	8b 00                	mov    (%eax),%eax
  803c16:	85 c0                	test   %eax,%eax
  803c18:	74 15                	je     803c2f <free_block+0xc7>
  803c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c1d:	c1 e0 04             	shl    $0x4,%eax
  803c20:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803c25:	8b 00                	mov    (%eax),%eax
  803c27:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c2a:	89 50 04             	mov    %edx,0x4(%eax)
  803c2d:	eb 11                	jmp    803c40 <free_block+0xd8>
  803c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c32:	c1 e0 04             	shl    $0x4,%eax
  803c35:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803c3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c3e:	89 02                	mov    %eax,(%edx)
  803c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c43:	c1 e0 04             	shl    $0x4,%eax
  803c46:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803c4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c4f:	89 02                	mov    %eax,(%edx)
  803c51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c54:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c5e:	c1 e0 04             	shl    $0x4,%eax
  803c61:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803c66:	8b 00                	mov    (%eax),%eax
  803c68:	8d 50 01             	lea    0x1(%eax),%edx
  803c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c6e:	c1 e0 04             	shl    $0x4,%eax
  803c71:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803c76:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  803c78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c7b:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803c7f:	40                   	inc    %eax
  803c80:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c83:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  803c87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c8a:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803c8e:	0f b7 c8             	movzwl %ax,%ecx
  803c91:	b8 00 10 00 00       	mov    $0x1000,%eax
  803c96:	ba 00 00 00 00       	mov    $0x0,%edx
  803c9b:	f7 75 e8             	divl   -0x18(%ebp)
  803c9e:	39 c1                	cmp    %eax,%ecx
  803ca0:	0f 85 ed 01 00 00    	jne    803e93 <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ca9:	c1 e0 04             	shl    $0x4,%eax
  803cac:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803cb1:	8b 00                	mov    (%eax),%eax
  803cb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803cb6:	eb 2a                	jmp    803ce2 <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  803cb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cbb:	83 ec 0c             	sub    $0xc,%esp
  803cbe:	50                   	push   %eax
  803cbf:	e8 b0 f7 ff ff       	call   803474 <to_page_info>
  803cc4:	83 c4 10             	add    $0x10,%esp
  803cc7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803cca:	75 06                	jne    803cd2 <free_block+0x16a>
				tmp = b;
  803ccc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ccf:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cd5:	c1 e0 04             	shl    $0x4,%eax
  803cd8:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803cdd:	8b 00                	mov    (%eax),%eax
  803cdf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803ce2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803ce6:	74 07                	je     803cef <free_block+0x187>
  803ce8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ceb:	8b 00                	mov    (%eax),%eax
  803ced:	eb 05                	jmp    803cf4 <free_block+0x18c>
  803cef:	b8 00 00 00 00       	mov    $0x0,%eax
  803cf4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803cf7:	c1 e2 04             	shl    $0x4,%edx
  803cfa:	81 c2 a8 50 83 00    	add    $0x8350a8,%edx
  803d00:	89 02                	mov    %eax,(%edx)
  803d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d05:	c1 e0 04             	shl    $0x4,%eax
  803d08:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803d0d:	8b 00                	mov    (%eax),%eax
  803d0f:	85 c0                	test   %eax,%eax
  803d11:	75 a5                	jne    803cb8 <free_block+0x150>
  803d13:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d17:	75 9f                	jne    803cb8 <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  803d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d1c:	c1 e0 04             	shl    $0x4,%eax
  803d1f:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803d24:	8b 00                	mov    (%eax),%eax
  803d26:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  803d29:	e9 cc 00 00 00       	jmp    803dfa <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  803d2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d31:	8b 00                	mov    (%eax),%eax
  803d33:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  803d36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d39:	83 ec 0c             	sub    $0xc,%esp
  803d3c:	50                   	push   %eax
  803d3d:	e8 32 f7 ff ff       	call   803474 <to_page_info>
  803d42:	83 c4 10             	add    $0x10,%esp
  803d45:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803d48:	0f 85 a6 00 00 00    	jne    803df4 <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  803d4e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d52:	75 17                	jne    803d6b <free_block+0x203>
  803d54:	83 ec 04             	sub    $0x4,%esp
  803d57:	68 1d 4a 80 00       	push   $0x804a1d
  803d5c:	68 b5 00 00 00       	push   $0xb5
  803d61:	68 83 49 80 00       	push   $0x804983
  803d66:	e8 d3 c6 ff ff       	call   80043e <_panic>
  803d6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d6e:	8b 00                	mov    (%eax),%eax
  803d70:	85 c0                	test   %eax,%eax
  803d72:	74 10                	je     803d84 <free_block+0x21c>
  803d74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d77:	8b 00                	mov    (%eax),%eax
  803d79:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d7c:	8b 52 04             	mov    0x4(%edx),%edx
  803d7f:	89 50 04             	mov    %edx,0x4(%eax)
  803d82:	eb 14                	jmp    803d98 <free_block+0x230>
  803d84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d87:	8b 40 04             	mov    0x4(%eax),%eax
  803d8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d8d:	c1 e2 04             	shl    $0x4,%edx
  803d90:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803d96:	89 02                	mov    %eax,(%edx)
  803d98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d9b:	8b 40 04             	mov    0x4(%eax),%eax
  803d9e:	85 c0                	test   %eax,%eax
  803da0:	74 0f                	je     803db1 <free_block+0x249>
  803da2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803da5:	8b 40 04             	mov    0x4(%eax),%eax
  803da8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803dab:	8b 12                	mov    (%edx),%edx
  803dad:	89 10                	mov    %edx,(%eax)
  803daf:	eb 13                	jmp    803dc4 <free_block+0x25c>
  803db1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803db4:	8b 00                	mov    (%eax),%eax
  803db6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803db9:	c1 e2 04             	shl    $0x4,%edx
  803dbc:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803dc2:	89 02                	mov    %eax,(%edx)
  803dc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dc7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dd0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dda:	c1 e0 04             	shl    $0x4,%eax
  803ddd:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803de2:	8b 00                	mov    (%eax),%eax
  803de4:	8d 50 ff             	lea    -0x1(%eax),%edx
  803de7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dea:	c1 e0 04             	shl    $0x4,%eax
  803ded:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803df2:	89 10                	mov    %edx,(%eax)
			b = next;
  803df4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803df7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  803dfa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803dfe:	0f 85 2a ff ff ff    	jne    803d2e <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  803e04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e07:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  803e0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e10:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  803e16:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803e1a:	75 17                	jne    803e33 <free_block+0x2cb>
  803e1c:	83 ec 04             	sub    $0x4,%esp
  803e1f:	68 8c 4a 80 00       	push   $0x804a8c
  803e24:	68 bc 00 00 00       	push   $0xbc
  803e29:	68 83 49 80 00       	push   $0x804983
  803e2e:	e8 0b c6 ff ff       	call   80043e <_panic>
  803e33:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803e39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e3c:	89 10                	mov    %edx,(%eax)
  803e3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e41:	8b 00                	mov    (%eax),%eax
  803e43:	85 c0                	test   %eax,%eax
  803e45:	74 0d                	je     803e54 <free_block+0x2ec>
  803e47:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803e4c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e4f:	89 50 04             	mov    %edx,0x4(%eax)
  803e52:	eb 08                	jmp    803e5c <free_block+0x2f4>
  803e54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e57:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803e5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e5f:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803e64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e67:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e6e:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803e73:	40                   	inc    %eax
  803e74:	a3 74 d0 81 00       	mov    %eax,0x81d074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  803e79:	83 ec 0c             	sub    $0xc,%esp
  803e7c:	ff 75 ec             	pushl  -0x14(%ebp)
  803e7f:	e8 7e f5 ff ff       	call   803402 <to_page_va>
  803e84:	83 c4 10             	add    $0x10,%esp
  803e87:	83 ec 0c             	sub    $0xc,%esp
  803e8a:	50                   	push   %eax
  803e8b:	e8 fe d7 ff ff       	call   80168e <return_page>
  803e90:	83 c4 10             	add    $0x10,%esp
	}
}
  803e93:	90                   	nop
  803e94:	c9                   	leave  
  803e95:	c3                   	ret    
  803e96:	66 90                	xchg   %ax,%ax

00803e98 <__udivdi3>:
  803e98:	55                   	push   %ebp
  803e99:	57                   	push   %edi
  803e9a:	56                   	push   %esi
  803e9b:	53                   	push   %ebx
  803e9c:	83 ec 1c             	sub    $0x1c,%esp
  803e9f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803ea3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803ea7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803eab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803eaf:	89 ca                	mov    %ecx,%edx
  803eb1:	89 f8                	mov    %edi,%eax
  803eb3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803eb7:	85 f6                	test   %esi,%esi
  803eb9:	75 2d                	jne    803ee8 <__udivdi3+0x50>
  803ebb:	39 cf                	cmp    %ecx,%edi
  803ebd:	77 65                	ja     803f24 <__udivdi3+0x8c>
  803ebf:	89 fd                	mov    %edi,%ebp
  803ec1:	85 ff                	test   %edi,%edi
  803ec3:	75 0b                	jne    803ed0 <__udivdi3+0x38>
  803ec5:	b8 01 00 00 00       	mov    $0x1,%eax
  803eca:	31 d2                	xor    %edx,%edx
  803ecc:	f7 f7                	div    %edi
  803ece:	89 c5                	mov    %eax,%ebp
  803ed0:	31 d2                	xor    %edx,%edx
  803ed2:	89 c8                	mov    %ecx,%eax
  803ed4:	f7 f5                	div    %ebp
  803ed6:	89 c1                	mov    %eax,%ecx
  803ed8:	89 d8                	mov    %ebx,%eax
  803eda:	f7 f5                	div    %ebp
  803edc:	89 cf                	mov    %ecx,%edi
  803ede:	89 fa                	mov    %edi,%edx
  803ee0:	83 c4 1c             	add    $0x1c,%esp
  803ee3:	5b                   	pop    %ebx
  803ee4:	5e                   	pop    %esi
  803ee5:	5f                   	pop    %edi
  803ee6:	5d                   	pop    %ebp
  803ee7:	c3                   	ret    
  803ee8:	39 ce                	cmp    %ecx,%esi
  803eea:	77 28                	ja     803f14 <__udivdi3+0x7c>
  803eec:	0f bd fe             	bsr    %esi,%edi
  803eef:	83 f7 1f             	xor    $0x1f,%edi
  803ef2:	75 40                	jne    803f34 <__udivdi3+0x9c>
  803ef4:	39 ce                	cmp    %ecx,%esi
  803ef6:	72 0a                	jb     803f02 <__udivdi3+0x6a>
  803ef8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803efc:	0f 87 9e 00 00 00    	ja     803fa0 <__udivdi3+0x108>
  803f02:	b8 01 00 00 00       	mov    $0x1,%eax
  803f07:	89 fa                	mov    %edi,%edx
  803f09:	83 c4 1c             	add    $0x1c,%esp
  803f0c:	5b                   	pop    %ebx
  803f0d:	5e                   	pop    %esi
  803f0e:	5f                   	pop    %edi
  803f0f:	5d                   	pop    %ebp
  803f10:	c3                   	ret    
  803f11:	8d 76 00             	lea    0x0(%esi),%esi
  803f14:	31 ff                	xor    %edi,%edi
  803f16:	31 c0                	xor    %eax,%eax
  803f18:	89 fa                	mov    %edi,%edx
  803f1a:	83 c4 1c             	add    $0x1c,%esp
  803f1d:	5b                   	pop    %ebx
  803f1e:	5e                   	pop    %esi
  803f1f:	5f                   	pop    %edi
  803f20:	5d                   	pop    %ebp
  803f21:	c3                   	ret    
  803f22:	66 90                	xchg   %ax,%ax
  803f24:	89 d8                	mov    %ebx,%eax
  803f26:	f7 f7                	div    %edi
  803f28:	31 ff                	xor    %edi,%edi
  803f2a:	89 fa                	mov    %edi,%edx
  803f2c:	83 c4 1c             	add    $0x1c,%esp
  803f2f:	5b                   	pop    %ebx
  803f30:	5e                   	pop    %esi
  803f31:	5f                   	pop    %edi
  803f32:	5d                   	pop    %ebp
  803f33:	c3                   	ret    
  803f34:	bd 20 00 00 00       	mov    $0x20,%ebp
  803f39:	89 eb                	mov    %ebp,%ebx
  803f3b:	29 fb                	sub    %edi,%ebx
  803f3d:	89 f9                	mov    %edi,%ecx
  803f3f:	d3 e6                	shl    %cl,%esi
  803f41:	89 c5                	mov    %eax,%ebp
  803f43:	88 d9                	mov    %bl,%cl
  803f45:	d3 ed                	shr    %cl,%ebp
  803f47:	89 e9                	mov    %ebp,%ecx
  803f49:	09 f1                	or     %esi,%ecx
  803f4b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803f4f:	89 f9                	mov    %edi,%ecx
  803f51:	d3 e0                	shl    %cl,%eax
  803f53:	89 c5                	mov    %eax,%ebp
  803f55:	89 d6                	mov    %edx,%esi
  803f57:	88 d9                	mov    %bl,%cl
  803f59:	d3 ee                	shr    %cl,%esi
  803f5b:	89 f9                	mov    %edi,%ecx
  803f5d:	d3 e2                	shl    %cl,%edx
  803f5f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f63:	88 d9                	mov    %bl,%cl
  803f65:	d3 e8                	shr    %cl,%eax
  803f67:	09 c2                	or     %eax,%edx
  803f69:	89 d0                	mov    %edx,%eax
  803f6b:	89 f2                	mov    %esi,%edx
  803f6d:	f7 74 24 0c          	divl   0xc(%esp)
  803f71:	89 d6                	mov    %edx,%esi
  803f73:	89 c3                	mov    %eax,%ebx
  803f75:	f7 e5                	mul    %ebp
  803f77:	39 d6                	cmp    %edx,%esi
  803f79:	72 19                	jb     803f94 <__udivdi3+0xfc>
  803f7b:	74 0b                	je     803f88 <__udivdi3+0xf0>
  803f7d:	89 d8                	mov    %ebx,%eax
  803f7f:	31 ff                	xor    %edi,%edi
  803f81:	e9 58 ff ff ff       	jmp    803ede <__udivdi3+0x46>
  803f86:	66 90                	xchg   %ax,%ax
  803f88:	8b 54 24 08          	mov    0x8(%esp),%edx
  803f8c:	89 f9                	mov    %edi,%ecx
  803f8e:	d3 e2                	shl    %cl,%edx
  803f90:	39 c2                	cmp    %eax,%edx
  803f92:	73 e9                	jae    803f7d <__udivdi3+0xe5>
  803f94:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803f97:	31 ff                	xor    %edi,%edi
  803f99:	e9 40 ff ff ff       	jmp    803ede <__udivdi3+0x46>
  803f9e:	66 90                	xchg   %ax,%ax
  803fa0:	31 c0                	xor    %eax,%eax
  803fa2:	e9 37 ff ff ff       	jmp    803ede <__udivdi3+0x46>
  803fa7:	90                   	nop

00803fa8 <__umoddi3>:
  803fa8:	55                   	push   %ebp
  803fa9:	57                   	push   %edi
  803faa:	56                   	push   %esi
  803fab:	53                   	push   %ebx
  803fac:	83 ec 1c             	sub    $0x1c,%esp
  803faf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803fb3:	8b 74 24 34          	mov    0x34(%esp),%esi
  803fb7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803fbb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803fbf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803fc3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803fc7:	89 f3                	mov    %esi,%ebx
  803fc9:	89 fa                	mov    %edi,%edx
  803fcb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803fcf:	89 34 24             	mov    %esi,(%esp)
  803fd2:	85 c0                	test   %eax,%eax
  803fd4:	75 1a                	jne    803ff0 <__umoddi3+0x48>
  803fd6:	39 f7                	cmp    %esi,%edi
  803fd8:	0f 86 a2 00 00 00    	jbe    804080 <__umoddi3+0xd8>
  803fde:	89 c8                	mov    %ecx,%eax
  803fe0:	89 f2                	mov    %esi,%edx
  803fe2:	f7 f7                	div    %edi
  803fe4:	89 d0                	mov    %edx,%eax
  803fe6:	31 d2                	xor    %edx,%edx
  803fe8:	83 c4 1c             	add    $0x1c,%esp
  803feb:	5b                   	pop    %ebx
  803fec:	5e                   	pop    %esi
  803fed:	5f                   	pop    %edi
  803fee:	5d                   	pop    %ebp
  803fef:	c3                   	ret    
  803ff0:	39 f0                	cmp    %esi,%eax
  803ff2:	0f 87 ac 00 00 00    	ja     8040a4 <__umoddi3+0xfc>
  803ff8:	0f bd e8             	bsr    %eax,%ebp
  803ffb:	83 f5 1f             	xor    $0x1f,%ebp
  803ffe:	0f 84 ac 00 00 00    	je     8040b0 <__umoddi3+0x108>
  804004:	bf 20 00 00 00       	mov    $0x20,%edi
  804009:	29 ef                	sub    %ebp,%edi
  80400b:	89 fe                	mov    %edi,%esi
  80400d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804011:	89 e9                	mov    %ebp,%ecx
  804013:	d3 e0                	shl    %cl,%eax
  804015:	89 d7                	mov    %edx,%edi
  804017:	89 f1                	mov    %esi,%ecx
  804019:	d3 ef                	shr    %cl,%edi
  80401b:	09 c7                	or     %eax,%edi
  80401d:	89 e9                	mov    %ebp,%ecx
  80401f:	d3 e2                	shl    %cl,%edx
  804021:	89 14 24             	mov    %edx,(%esp)
  804024:	89 d8                	mov    %ebx,%eax
  804026:	d3 e0                	shl    %cl,%eax
  804028:	89 c2                	mov    %eax,%edx
  80402a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80402e:	d3 e0                	shl    %cl,%eax
  804030:	89 44 24 04          	mov    %eax,0x4(%esp)
  804034:	8b 44 24 08          	mov    0x8(%esp),%eax
  804038:	89 f1                	mov    %esi,%ecx
  80403a:	d3 e8                	shr    %cl,%eax
  80403c:	09 d0                	or     %edx,%eax
  80403e:	d3 eb                	shr    %cl,%ebx
  804040:	89 da                	mov    %ebx,%edx
  804042:	f7 f7                	div    %edi
  804044:	89 d3                	mov    %edx,%ebx
  804046:	f7 24 24             	mull   (%esp)
  804049:	89 c6                	mov    %eax,%esi
  80404b:	89 d1                	mov    %edx,%ecx
  80404d:	39 d3                	cmp    %edx,%ebx
  80404f:	0f 82 87 00 00 00    	jb     8040dc <__umoddi3+0x134>
  804055:	0f 84 91 00 00 00    	je     8040ec <__umoddi3+0x144>
  80405b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80405f:	29 f2                	sub    %esi,%edx
  804061:	19 cb                	sbb    %ecx,%ebx
  804063:	89 d8                	mov    %ebx,%eax
  804065:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804069:	d3 e0                	shl    %cl,%eax
  80406b:	89 e9                	mov    %ebp,%ecx
  80406d:	d3 ea                	shr    %cl,%edx
  80406f:	09 d0                	or     %edx,%eax
  804071:	89 e9                	mov    %ebp,%ecx
  804073:	d3 eb                	shr    %cl,%ebx
  804075:	89 da                	mov    %ebx,%edx
  804077:	83 c4 1c             	add    $0x1c,%esp
  80407a:	5b                   	pop    %ebx
  80407b:	5e                   	pop    %esi
  80407c:	5f                   	pop    %edi
  80407d:	5d                   	pop    %ebp
  80407e:	c3                   	ret    
  80407f:	90                   	nop
  804080:	89 fd                	mov    %edi,%ebp
  804082:	85 ff                	test   %edi,%edi
  804084:	75 0b                	jne    804091 <__umoddi3+0xe9>
  804086:	b8 01 00 00 00       	mov    $0x1,%eax
  80408b:	31 d2                	xor    %edx,%edx
  80408d:	f7 f7                	div    %edi
  80408f:	89 c5                	mov    %eax,%ebp
  804091:	89 f0                	mov    %esi,%eax
  804093:	31 d2                	xor    %edx,%edx
  804095:	f7 f5                	div    %ebp
  804097:	89 c8                	mov    %ecx,%eax
  804099:	f7 f5                	div    %ebp
  80409b:	89 d0                	mov    %edx,%eax
  80409d:	e9 44 ff ff ff       	jmp    803fe6 <__umoddi3+0x3e>
  8040a2:	66 90                	xchg   %ax,%ax
  8040a4:	89 c8                	mov    %ecx,%eax
  8040a6:	89 f2                	mov    %esi,%edx
  8040a8:	83 c4 1c             	add    $0x1c,%esp
  8040ab:	5b                   	pop    %ebx
  8040ac:	5e                   	pop    %esi
  8040ad:	5f                   	pop    %edi
  8040ae:	5d                   	pop    %ebp
  8040af:	c3                   	ret    
  8040b0:	3b 04 24             	cmp    (%esp),%eax
  8040b3:	72 06                	jb     8040bb <__umoddi3+0x113>
  8040b5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8040b9:	77 0f                	ja     8040ca <__umoddi3+0x122>
  8040bb:	89 f2                	mov    %esi,%edx
  8040bd:	29 f9                	sub    %edi,%ecx
  8040bf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8040c3:	89 14 24             	mov    %edx,(%esp)
  8040c6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8040ca:	8b 44 24 04          	mov    0x4(%esp),%eax
  8040ce:	8b 14 24             	mov    (%esp),%edx
  8040d1:	83 c4 1c             	add    $0x1c,%esp
  8040d4:	5b                   	pop    %ebx
  8040d5:	5e                   	pop    %esi
  8040d6:	5f                   	pop    %edi
  8040d7:	5d                   	pop    %ebp
  8040d8:	c3                   	ret    
  8040d9:	8d 76 00             	lea    0x0(%esi),%esi
  8040dc:	2b 04 24             	sub    (%esp),%eax
  8040df:	19 fa                	sbb    %edi,%edx
  8040e1:	89 d1                	mov    %edx,%ecx
  8040e3:	89 c6                	mov    %eax,%esi
  8040e5:	e9 71 ff ff ff       	jmp    80405b <__umoddi3+0xb3>
  8040ea:	66 90                	xchg   %ax,%ax
  8040ec:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8040f0:	72 ea                	jb     8040dc <__umoddi3+0x134>
  8040f2:	89 d9                	mov    %ebx,%ecx
  8040f4:	e9 62 ff ff ff       	jmp    80405b <__umoddi3+0xb3>
