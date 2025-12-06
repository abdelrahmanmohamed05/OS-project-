
obj/user/tst_sharing_2slave1:     file format elf32-i386


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
  800031:	e8 7c 02 00 00       	call   8002b2 <libmain>
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
  80005c:	68 20 41 80 00       	push   $0x804120
  800061:	6a 0d                	push   $0xd
  800063:	68 3c 41 80 00       	push   $0x80413c
  800068:	e8 f5 03 00 00       	call   800462 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80006d:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)

	uint32 *x,*y,*z, *expectedVA;
	int freeFrames, diff, expected;
	int32 parentenvID = sys_getparentenvid();
  800074:	e8 03 31 00 00       	call   80317c <sys_getparentenvid>
  800079:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//GET: z then y then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	//sys_lock_cons();
	sys_lock_cons();
  80007c:	e8 69 2e 00 00       	call   802eea <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  800081:	e8 14 2f 00 00       	call   802f9a <sys_calculate_free_frames>
  800086:	89 45 ec             	mov    %eax,-0x14(%ebp)
		z = sget(parentenvID,"z");
  800089:	83 ec 08             	sub    $0x8,%esp
  80008c:	68 57 41 80 00       	push   $0x804157
  800091:	ff 75 f0             	pushl  -0x10(%ebp)
  800094:	e8 20 21 00 00       	call   8021b9 <sget>
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
  8000b6:	68 5c 41 80 00       	push   $0x80415c
  8000bb:	6a 21                	push   $0x21
  8000bd:	68 3c 41 80 00       	push   $0x80413c
  8000c2:	e8 9b 03 00 00       	call   800462 <_panic>
		expected = 1 ; /*1table*/
  8000c7:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8000ce:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000d1:	e8 c4 2e 00 00       	call   802f9a <sys_calculate_free_frames>
  8000d6:	29 c3                	sub    %eax,%ebx
  8000d8:	89 d8                	mov    %ebx,%eax
  8000da:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  8000dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000e0:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8000e3:	74 24                	je     800109 <_main+0xd1>
  8000e5:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000e8:	e8 ad 2e 00 00       	call   802f9a <sys_calculate_free_frames>
  8000ed:	29 c3                	sub    %eax,%ebx
  8000ef:	89 d8                	mov    %ebx,%eax
  8000f1:	83 ec 0c             	sub    $0xc,%esp
  8000f4:	ff 75 e0             	pushl  -0x20(%ebp)
  8000f7:	50                   	push   %eax
  8000f8:	68 d8 41 80 00       	push   $0x8041d8
  8000fd:	6a 24                	push   $0x24
  8000ff:	68 3c 41 80 00       	push   $0x80413c
  800104:	e8 59 03 00 00       	call   800462 <_panic>
	}
	sys_unlock_cons();
  800109:	e8 f6 2d 00 00       	call   802f04 <sys_unlock_cons>
	//sys_unlock_cons();

	//sys_lock_cons();
	sys_lock_cons();
  80010e:	e8 d7 2d 00 00       	call   802eea <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  800113:	e8 82 2e 00 00       	call   802f9a <sys_calculate_free_frames>
  800118:	89 45 ec             	mov    %eax,-0x14(%ebp)
		y = sget(parentenvID,"y");
  80011b:	83 ec 08             	sub    $0x8,%esp
  80011e:	68 70 42 80 00       	push   $0x804270
  800123:	ff 75 f0             	pushl  -0x10(%ebp)
  800126:	e8 8e 20 00 00       	call   8021b9 <sget>
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		expectedVA = (uint32*)(pagealloc_start + 1 * PAGE_SIZE);
  800131:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800134:	05 00 10 00 00       	add    $0x1000,%eax
  800139:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (y != expectedVA) panic("Get(): Returned address is not correct. Expected = %x, Actual = %x\nMake sure that you align the allocation on 4KB boundary", expectedVA, y);
  80013c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80013f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800142:	74 1a                	je     80015e <_main+0x126>
  800144:	83 ec 0c             	sub    $0xc,%esp
  800147:	ff 75 d8             	pushl  -0x28(%ebp)
  80014a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80014d:	68 5c 41 80 00       	push   $0x80415c
  800152:	6a 2f                	push   $0x2f
  800154:	68 3c 41 80 00       	push   $0x80413c
  800159:	e8 04 03 00 00       	call   800462 <_panic>
		expected = 0 ;
  80015e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800165:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800168:	e8 2d 2e 00 00       	call   802f9a <sys_calculate_free_frames>
  80016d:	29 c3                	sub    %eax,%ebx
  80016f:	89 d8                	mov    %ebx,%eax
  800171:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800174:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800177:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80017a:	74 24                	je     8001a0 <_main+0x168>
  80017c:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80017f:	e8 16 2e 00 00       	call   802f9a <sys_calculate_free_frames>
  800184:	29 c3                	sub    %eax,%ebx
  800186:	89 d8                	mov    %ebx,%eax
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	ff 75 e0             	pushl  -0x20(%ebp)
  80018e:	50                   	push   %eax
  80018f:	68 d8 41 80 00       	push   $0x8041d8
  800194:	6a 32                	push   $0x32
  800196:	68 3c 41 80 00       	push   $0x80413c
  80019b:	e8 c2 02 00 00       	call   800462 <_panic>
	}
	sys_unlock_cons();
  8001a0:	e8 5f 2d 00 00       	call   802f04 <sys_unlock_cons>
	//sys_unlock_cons();

	if (*y != 20) panic("Get(): Shared Variable is not created or got correctly") ;
  8001a5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001a8:	8b 00                	mov    (%eax),%eax
  8001aa:	83 f8 14             	cmp    $0x14,%eax
  8001ad:	74 14                	je     8001c3 <_main+0x18b>
  8001af:	83 ec 04             	sub    $0x4,%esp
  8001b2:	68 74 42 80 00       	push   $0x804274
  8001b7:	6a 37                	push   $0x37
  8001b9:	68 3c 41 80 00       	push   $0x80413c
  8001be:	e8 9f 02 00 00       	call   800462 <_panic>

	//sys_lock_cons();
	sys_lock_cons();
  8001c3:	e8 22 2d 00 00       	call   802eea <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  8001c8:	e8 cd 2d 00 00       	call   802f9a <sys_calculate_free_frames>
  8001cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
		x = sget(parentenvID,"x");
  8001d0:	83 ec 08             	sub    $0x8,%esp
  8001d3:	68 ab 42 80 00       	push   $0x8042ab
  8001d8:	ff 75 f0             	pushl  -0x10(%ebp)
  8001db:	e8 d9 1f 00 00       	call   8021b9 <sget>
  8001e0:	83 c4 10             	add    $0x10,%esp
  8001e3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		expectedVA = (uint32*)(pagealloc_start + 2 * PAGE_SIZE);
  8001e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001e9:	05 00 20 00 00       	add    $0x2000,%eax
  8001ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (x != expectedVA) panic("Get(): Returned address is not correct. Expected = %x, Actual = %x\nMake sure that you align the allocation on 4KB boundary", expectedVA, x);
  8001f1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8001f4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8001f7:	74 1a                	je     800213 <_main+0x1db>
  8001f9:	83 ec 0c             	sub    $0xc,%esp
  8001fc:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001ff:	ff 75 e4             	pushl  -0x1c(%ebp)
  800202:	68 5c 41 80 00       	push   $0x80415c
  800207:	6a 3f                	push   $0x3f
  800209:	68 3c 41 80 00       	push   $0x80413c
  80020e:	e8 4f 02 00 00       	call   800462 <_panic>
		expected = 0 ;
  800213:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80021a:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80021d:	e8 78 2d 00 00       	call   802f9a <sys_calculate_free_frames>
  800222:	29 c3                	sub    %eax,%ebx
  800224:	89 d8                	mov    %ebx,%eax
  800226:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800229:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80022c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80022f:	74 24                	je     800255 <_main+0x21d>
  800231:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800234:	e8 61 2d 00 00       	call   802f9a <sys_calculate_free_frames>
  800239:	29 c3                	sub    %eax,%ebx
  80023b:	89 d8                	mov    %ebx,%eax
  80023d:	83 ec 0c             	sub    $0xc,%esp
  800240:	ff 75 e0             	pushl  -0x20(%ebp)
  800243:	50                   	push   %eax
  800244:	68 d8 41 80 00       	push   $0x8041d8
  800249:	6a 42                	push   $0x42
  80024b:	68 3c 41 80 00       	push   $0x80413c
  800250:	e8 0d 02 00 00       	call   800462 <_panic>
	}
	sys_unlock_cons();
  800255:	e8 aa 2c 00 00       	call   802f04 <sys_unlock_cons>
	//sys_unlock_cons();

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  80025a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80025d:	8b 00                	mov    (%eax),%eax
  80025f:	83 f8 0a             	cmp    $0xa,%eax
  800262:	74 14                	je     800278 <_main+0x240>
  800264:	83 ec 04             	sub    $0x4,%esp
  800267:	68 74 42 80 00       	push   $0x804274
  80026c:	6a 47                	push   $0x47
  80026e:	68 3c 41 80 00       	push   $0x80413c
  800273:	e8 ea 01 00 00       	call   800462 <_panic>

	*z = *x + *y ;
  800278:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80027b:	8b 10                	mov    (%eax),%edx
  80027d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800280:	8b 00                	mov    (%eax),%eax
  800282:	01 c2                	add    %eax,%edx
  800284:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800287:	89 10                	mov    %edx,(%eax)
	if (*z != 30) panic("Get(): Shared Variable is not created or got correctly") ;
  800289:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80028c:	8b 00                	mov    (%eax),%eax
  80028e:	83 f8 1e             	cmp    $0x1e,%eax
  800291:	74 14                	je     8002a7 <_main+0x26f>
  800293:	83 ec 04             	sub    $0x4,%esp
  800296:	68 74 42 80 00       	push   $0x804274
  80029b:	6a 4a                	push   $0x4a
  80029d:	68 3c 41 80 00       	push   $0x80413c
  8002a2:	e8 bb 01 00 00       	call   800462 <_panic>

	//To indicate that it's completed successfully
	inctst();
  8002a7:	e8 f5 2f 00 00       	call   8032a1 <inctst>

	return;
  8002ac:	90                   	nop
}
  8002ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002b0:	c9                   	leave  
  8002b1:	c3                   	ret    

008002b2 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002b2:	55                   	push   %ebp
  8002b3:	89 e5                	mov    %esp,%ebp
  8002b5:	57                   	push   %edi
  8002b6:	56                   	push   %esi
  8002b7:	53                   	push   %ebx
  8002b8:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8002bb:	e8 a3 2e 00 00       	call   803163 <sys_getenvindex>
  8002c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002c6:	89 d0                	mov    %edx,%eax
  8002c8:	c1 e0 03             	shl    $0x3,%eax
  8002cb:	01 d0                	add    %edx,%eax
  8002cd:	c1 e0 02             	shl    $0x2,%eax
  8002d0:	01 d0                	add    %edx,%eax
  8002d2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002d9:	01 d0                	add    %edx,%eax
  8002db:	c1 e0 03             	shl    $0x3,%eax
  8002de:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002e3:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002e8:	a1 20 50 80 00       	mov    0x805020,%eax
  8002ed:	8a 40 20             	mov    0x20(%eax),%al
  8002f0:	84 c0                	test   %al,%al
  8002f2:	74 0d                	je     800301 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8002f4:	a1 20 50 80 00       	mov    0x805020,%eax
  8002f9:	83 c0 20             	add    $0x20,%eax
  8002fc:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800301:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800305:	7e 0a                	jle    800311 <libmain+0x5f>
		binaryname = argv[0];
  800307:	8b 45 0c             	mov    0xc(%ebp),%eax
  80030a:	8b 00                	mov    (%eax),%eax
  80030c:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  800311:	83 ec 08             	sub    $0x8,%esp
  800314:	ff 75 0c             	pushl  0xc(%ebp)
  800317:	ff 75 08             	pushl  0x8(%ebp)
  80031a:	e8 19 fd ff ff       	call   800038 <_main>
  80031f:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800322:	a1 00 50 80 00       	mov    0x805000,%eax
  800327:	85 c0                	test   %eax,%eax
  800329:	0f 84 01 01 00 00    	je     800430 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80032f:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800335:	bb a8 43 80 00       	mov    $0x8043a8,%ebx
  80033a:	ba 0e 00 00 00       	mov    $0xe,%edx
  80033f:	89 c7                	mov    %eax,%edi
  800341:	89 de                	mov    %ebx,%esi
  800343:	89 d1                	mov    %edx,%ecx
  800345:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800347:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80034a:	b9 56 00 00 00       	mov    $0x56,%ecx
  80034f:	b0 00                	mov    $0x0,%al
  800351:	89 d7                	mov    %edx,%edi
  800353:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800355:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80035c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80035f:	83 ec 08             	sub    $0x8,%esp
  800362:	50                   	push   %eax
  800363:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800369:	50                   	push   %eax
  80036a:	e8 2a 30 00 00       	call   803399 <sys_utilities>
  80036f:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800372:	e8 73 2b 00 00       	call   802eea <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800377:	83 ec 0c             	sub    $0xc,%esp
  80037a:	68 c8 42 80 00       	push   $0x8042c8
  80037f:	e8 ac 03 00 00       	call   800730 <cprintf>
  800384:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800387:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80038a:	85 c0                	test   %eax,%eax
  80038c:	74 18                	je     8003a6 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80038e:	e8 24 30 00 00       	call   8033b7 <sys_get_optimal_num_faults>
  800393:	83 ec 08             	sub    $0x8,%esp
  800396:	50                   	push   %eax
  800397:	68 f0 42 80 00       	push   $0x8042f0
  80039c:	e8 8f 03 00 00       	call   800730 <cprintf>
  8003a1:	83 c4 10             	add    $0x10,%esp
  8003a4:	eb 59                	jmp    8003ff <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003a6:	a1 20 50 80 00       	mov    0x805020,%eax
  8003ab:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  8003b1:	a1 20 50 80 00       	mov    0x805020,%eax
  8003b6:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8003bc:	83 ec 04             	sub    $0x4,%esp
  8003bf:	52                   	push   %edx
  8003c0:	50                   	push   %eax
  8003c1:	68 14 43 80 00       	push   $0x804314
  8003c6:	e8 65 03 00 00       	call   800730 <cprintf>
  8003cb:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003ce:	a1 20 50 80 00       	mov    0x805020,%eax
  8003d3:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  8003d9:	a1 20 50 80 00       	mov    0x805020,%eax
  8003de:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  8003e4:	a1 20 50 80 00       	mov    0x805020,%eax
  8003e9:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8003ef:	51                   	push   %ecx
  8003f0:	52                   	push   %edx
  8003f1:	50                   	push   %eax
  8003f2:	68 3c 43 80 00       	push   $0x80433c
  8003f7:	e8 34 03 00 00       	call   800730 <cprintf>
  8003fc:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003ff:	a1 20 50 80 00       	mov    0x805020,%eax
  800404:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  80040a:	83 ec 08             	sub    $0x8,%esp
  80040d:	50                   	push   %eax
  80040e:	68 94 43 80 00       	push   $0x804394
  800413:	e8 18 03 00 00       	call   800730 <cprintf>
  800418:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80041b:	83 ec 0c             	sub    $0xc,%esp
  80041e:	68 c8 42 80 00       	push   $0x8042c8
  800423:	e8 08 03 00 00       	call   800730 <cprintf>
  800428:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80042b:	e8 d4 2a 00 00       	call   802f04 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800430:	e8 1f 00 00 00       	call   800454 <exit>
}
  800435:	90                   	nop
  800436:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800439:	5b                   	pop    %ebx
  80043a:	5e                   	pop    %esi
  80043b:	5f                   	pop    %edi
  80043c:	5d                   	pop    %ebp
  80043d:	c3                   	ret    

0080043e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80043e:	55                   	push   %ebp
  80043f:	89 e5                	mov    %esp,%ebp
  800441:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800444:	83 ec 0c             	sub    $0xc,%esp
  800447:	6a 00                	push   $0x0
  800449:	e8 e1 2c 00 00       	call   80312f <sys_destroy_env>
  80044e:	83 c4 10             	add    $0x10,%esp
}
  800451:	90                   	nop
  800452:	c9                   	leave  
  800453:	c3                   	ret    

00800454 <exit>:

void
exit(void)
{
  800454:	55                   	push   %ebp
  800455:	89 e5                	mov    %esp,%ebp
  800457:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80045a:	e8 36 2d 00 00       	call   803195 <sys_exit_env>
}
  80045f:	90                   	nop
  800460:	c9                   	leave  
  800461:	c3                   	ret    

00800462 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800462:	55                   	push   %ebp
  800463:	89 e5                	mov    %esp,%ebp
  800465:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800468:	8d 45 10             	lea    0x10(%ebp),%eax
  80046b:	83 c0 04             	add    $0x4,%eax
  80046e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800471:	a1 38 51 83 00       	mov    0x835138,%eax
  800476:	85 c0                	test   %eax,%eax
  800478:	74 16                	je     800490 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80047a:	a1 38 51 83 00       	mov    0x835138,%eax
  80047f:	83 ec 08             	sub    $0x8,%esp
  800482:	50                   	push   %eax
  800483:	68 0c 44 80 00       	push   $0x80440c
  800488:	e8 a3 02 00 00       	call   800730 <cprintf>
  80048d:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800490:	a1 04 50 80 00       	mov    0x805004,%eax
  800495:	83 ec 0c             	sub    $0xc,%esp
  800498:	ff 75 0c             	pushl  0xc(%ebp)
  80049b:	ff 75 08             	pushl  0x8(%ebp)
  80049e:	50                   	push   %eax
  80049f:	68 14 44 80 00       	push   $0x804414
  8004a4:	6a 74                	push   $0x74
  8004a6:	e8 b2 02 00 00       	call   80075d <cprintf_colored>
  8004ab:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8004b1:	83 ec 08             	sub    $0x8,%esp
  8004b4:	ff 75 f4             	pushl  -0xc(%ebp)
  8004b7:	50                   	push   %eax
  8004b8:	e8 04 02 00 00       	call   8006c1 <vcprintf>
  8004bd:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004c0:	83 ec 08             	sub    $0x8,%esp
  8004c3:	6a 00                	push   $0x0
  8004c5:	68 3c 44 80 00       	push   $0x80443c
  8004ca:	e8 f2 01 00 00       	call   8006c1 <vcprintf>
  8004cf:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004d2:	e8 7d ff ff ff       	call   800454 <exit>

	// should not return here
	while (1) ;
  8004d7:	eb fe                	jmp    8004d7 <_panic+0x75>

008004d9 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004d9:	55                   	push   %ebp
  8004da:	89 e5                	mov    %esp,%ebp
  8004dc:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8004df:	a1 20 50 80 00       	mov    0x805020,%eax
  8004e4:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ed:	39 c2                	cmp    %eax,%edx
  8004ef:	74 14                	je     800505 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8004f1:	83 ec 04             	sub    $0x4,%esp
  8004f4:	68 40 44 80 00       	push   $0x804440
  8004f9:	6a 26                	push   $0x26
  8004fb:	68 8c 44 80 00       	push   $0x80448c
  800500:	e8 5d ff ff ff       	call   800462 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800505:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80050c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800513:	e9 c5 00 00 00       	jmp    8005dd <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800518:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80051b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800522:	8b 45 08             	mov    0x8(%ebp),%eax
  800525:	01 d0                	add    %edx,%eax
  800527:	8b 00                	mov    (%eax),%eax
  800529:	85 c0                	test   %eax,%eax
  80052b:	75 08                	jne    800535 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80052d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800530:	e9 a5 00 00 00       	jmp    8005da <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800535:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80053c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800543:	eb 69                	jmp    8005ae <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800545:	a1 20 50 80 00       	mov    0x805020,%eax
  80054a:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800550:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800553:	89 d0                	mov    %edx,%eax
  800555:	01 c0                	add    %eax,%eax
  800557:	01 d0                	add    %edx,%eax
  800559:	c1 e0 03             	shl    $0x3,%eax
  80055c:	01 c8                	add    %ecx,%eax
  80055e:	8a 40 04             	mov    0x4(%eax),%al
  800561:	84 c0                	test   %al,%al
  800563:	75 46                	jne    8005ab <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800565:	a1 20 50 80 00       	mov    0x805020,%eax
  80056a:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800570:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800573:	89 d0                	mov    %edx,%eax
  800575:	01 c0                	add    %eax,%eax
  800577:	01 d0                	add    %edx,%eax
  800579:	c1 e0 03             	shl    $0x3,%eax
  80057c:	01 c8                	add    %ecx,%eax
  80057e:	8b 00                	mov    (%eax),%eax
  800580:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800583:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800586:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80058b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80058d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800590:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800597:	8b 45 08             	mov    0x8(%ebp),%eax
  80059a:	01 c8                	add    %ecx,%eax
  80059c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80059e:	39 c2                	cmp    %eax,%edx
  8005a0:	75 09                	jne    8005ab <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8005a2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005a9:	eb 15                	jmp    8005c0 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005ab:	ff 45 e8             	incl   -0x18(%ebp)
  8005ae:	a1 20 50 80 00       	mov    0x805020,%eax
  8005b3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005bc:	39 c2                	cmp    %eax,%edx
  8005be:	77 85                	ja     800545 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005c0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005c4:	75 14                	jne    8005da <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8005c6:	83 ec 04             	sub    $0x4,%esp
  8005c9:	68 98 44 80 00       	push   $0x804498
  8005ce:	6a 3a                	push   $0x3a
  8005d0:	68 8c 44 80 00       	push   $0x80448c
  8005d5:	e8 88 fe ff ff       	call   800462 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005da:	ff 45 f0             	incl   -0x10(%ebp)
  8005dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005e0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005e3:	0f 8c 2f ff ff ff    	jl     800518 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8005e9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005f0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8005f7:	eb 26                	jmp    80061f <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8005f9:	a1 20 50 80 00       	mov    0x805020,%eax
  8005fe:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800604:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800607:	89 d0                	mov    %edx,%eax
  800609:	01 c0                	add    %eax,%eax
  80060b:	01 d0                	add    %edx,%eax
  80060d:	c1 e0 03             	shl    $0x3,%eax
  800610:	01 c8                	add    %ecx,%eax
  800612:	8a 40 04             	mov    0x4(%eax),%al
  800615:	3c 01                	cmp    $0x1,%al
  800617:	75 03                	jne    80061c <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800619:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80061c:	ff 45 e0             	incl   -0x20(%ebp)
  80061f:	a1 20 50 80 00       	mov    0x805020,%eax
  800624:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80062a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80062d:	39 c2                	cmp    %eax,%edx
  80062f:	77 c8                	ja     8005f9 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800631:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800634:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800637:	74 14                	je     80064d <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800639:	83 ec 04             	sub    $0x4,%esp
  80063c:	68 ec 44 80 00       	push   $0x8044ec
  800641:	6a 44                	push   $0x44
  800643:	68 8c 44 80 00       	push   $0x80448c
  800648:	e8 15 fe ff ff       	call   800462 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80064d:	90                   	nop
  80064e:	c9                   	leave  
  80064f:	c3                   	ret    

00800650 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800650:	55                   	push   %ebp
  800651:	89 e5                	mov    %esp,%ebp
  800653:	53                   	push   %ebx
  800654:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800657:	8b 45 0c             	mov    0xc(%ebp),%eax
  80065a:	8b 00                	mov    (%eax),%eax
  80065c:	8d 48 01             	lea    0x1(%eax),%ecx
  80065f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800662:	89 0a                	mov    %ecx,(%edx)
  800664:	8b 55 08             	mov    0x8(%ebp),%edx
  800667:	88 d1                	mov    %dl,%cl
  800669:	8b 55 0c             	mov    0xc(%ebp),%edx
  80066c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800670:	8b 45 0c             	mov    0xc(%ebp),%eax
  800673:	8b 00                	mov    (%eax),%eax
  800675:	3d ff 00 00 00       	cmp    $0xff,%eax
  80067a:	75 30                	jne    8006ac <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80067c:	8b 15 3c 51 83 00    	mov    0x83513c,%edx
  800682:	a0 64 d0 81 00       	mov    0x81d064,%al
  800687:	0f b6 c0             	movzbl %al,%eax
  80068a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80068d:	8b 09                	mov    (%ecx),%ecx
  80068f:	89 cb                	mov    %ecx,%ebx
  800691:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800694:	83 c1 08             	add    $0x8,%ecx
  800697:	52                   	push   %edx
  800698:	50                   	push   %eax
  800699:	53                   	push   %ebx
  80069a:	51                   	push   %ecx
  80069b:	e8 06 28 00 00       	call   802ea6 <sys_cputs>
  8006a0:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006af:	8b 40 04             	mov    0x4(%eax),%eax
  8006b2:	8d 50 01             	lea    0x1(%eax),%edx
  8006b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006b8:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006bb:	90                   	nop
  8006bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006bf:	c9                   	leave  
  8006c0:	c3                   	ret    

008006c1 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006c1:	55                   	push   %ebp
  8006c2:	89 e5                	mov    %esp,%ebp
  8006c4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006ca:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006d1:	00 00 00 
	b.cnt = 0;
  8006d4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006db:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006de:	ff 75 0c             	pushl  0xc(%ebp)
  8006e1:	ff 75 08             	pushl  0x8(%ebp)
  8006e4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006ea:	50                   	push   %eax
  8006eb:	68 50 06 80 00       	push   $0x800650
  8006f0:	e8 5a 02 00 00       	call   80094f <vprintfmt>
  8006f5:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8006f8:	8b 15 3c 51 83 00    	mov    0x83513c,%edx
  8006fe:	a0 64 d0 81 00       	mov    0x81d064,%al
  800703:	0f b6 c0             	movzbl %al,%eax
  800706:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80070c:	52                   	push   %edx
  80070d:	50                   	push   %eax
  80070e:	51                   	push   %ecx
  80070f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800715:	83 c0 08             	add    $0x8,%eax
  800718:	50                   	push   %eax
  800719:	e8 88 27 00 00       	call   802ea6 <sys_cputs>
  80071e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800721:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
	return b.cnt;
  800728:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80072e:	c9                   	leave  
  80072f:	c3                   	ret    

00800730 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800730:	55                   	push   %ebp
  800731:	89 e5                	mov    %esp,%ebp
  800733:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800736:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	va_start(ap, fmt);
  80073d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800740:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800743:	8b 45 08             	mov    0x8(%ebp),%eax
  800746:	83 ec 08             	sub    $0x8,%esp
  800749:	ff 75 f4             	pushl  -0xc(%ebp)
  80074c:	50                   	push   %eax
  80074d:	e8 6f ff ff ff       	call   8006c1 <vcprintf>
  800752:	83 c4 10             	add    $0x10,%esp
  800755:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800758:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80075b:	c9                   	leave  
  80075c:	c3                   	ret    

0080075d <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80075d:	55                   	push   %ebp
  80075e:	89 e5                	mov    %esp,%ebp
  800760:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800763:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	curTextClr = (textClr << 8) ; //set text color by the given value
  80076a:	8b 45 08             	mov    0x8(%ebp),%eax
  80076d:	c1 e0 08             	shl    $0x8,%eax
  800770:	a3 3c 51 83 00       	mov    %eax,0x83513c
	va_start(ap, fmt);
  800775:	8d 45 0c             	lea    0xc(%ebp),%eax
  800778:	83 c0 04             	add    $0x4,%eax
  80077b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80077e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800781:	83 ec 08             	sub    $0x8,%esp
  800784:	ff 75 f4             	pushl  -0xc(%ebp)
  800787:	50                   	push   %eax
  800788:	e8 34 ff ff ff       	call   8006c1 <vcprintf>
  80078d:	83 c4 10             	add    $0x10,%esp
  800790:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800793:	c7 05 3c 51 83 00 00 	movl   $0x700,0x83513c
  80079a:	07 00 00 

	return cnt;
  80079d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007a0:	c9                   	leave  
  8007a1:	c3                   	ret    

008007a2 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007a2:	55                   	push   %ebp
  8007a3:	89 e5                	mov    %esp,%ebp
  8007a5:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007a8:	e8 3d 27 00 00       	call   802eea <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007ad:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b6:	83 ec 08             	sub    $0x8,%esp
  8007b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8007bc:	50                   	push   %eax
  8007bd:	e8 ff fe ff ff       	call   8006c1 <vcprintf>
  8007c2:	83 c4 10             	add    $0x10,%esp
  8007c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007c8:	e8 37 27 00 00       	call   802f04 <sys_unlock_cons>
	return cnt;
  8007cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007d0:	c9                   	leave  
  8007d1:	c3                   	ret    

008007d2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007d2:	55                   	push   %ebp
  8007d3:	89 e5                	mov    %esp,%ebp
  8007d5:	53                   	push   %ebx
  8007d6:	83 ec 14             	sub    $0x14,%esp
  8007d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8007dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007df:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007e5:	8b 45 18             	mov    0x18(%ebp),%eax
  8007e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ed:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007f0:	77 55                	ja     800847 <printnum+0x75>
  8007f2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007f5:	72 05                	jb     8007fc <printnum+0x2a>
  8007f7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007fa:	77 4b                	ja     800847 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007fc:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007ff:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800802:	8b 45 18             	mov    0x18(%ebp),%eax
  800805:	ba 00 00 00 00       	mov    $0x0,%edx
  80080a:	52                   	push   %edx
  80080b:	50                   	push   %eax
  80080c:	ff 75 f4             	pushl  -0xc(%ebp)
  80080f:	ff 75 f0             	pushl  -0x10(%ebp)
  800812:	e8 a5 36 00 00       	call   803ebc <__udivdi3>
  800817:	83 c4 10             	add    $0x10,%esp
  80081a:	83 ec 04             	sub    $0x4,%esp
  80081d:	ff 75 20             	pushl  0x20(%ebp)
  800820:	53                   	push   %ebx
  800821:	ff 75 18             	pushl  0x18(%ebp)
  800824:	52                   	push   %edx
  800825:	50                   	push   %eax
  800826:	ff 75 0c             	pushl  0xc(%ebp)
  800829:	ff 75 08             	pushl  0x8(%ebp)
  80082c:	e8 a1 ff ff ff       	call   8007d2 <printnum>
  800831:	83 c4 20             	add    $0x20,%esp
  800834:	eb 1a                	jmp    800850 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800836:	83 ec 08             	sub    $0x8,%esp
  800839:	ff 75 0c             	pushl  0xc(%ebp)
  80083c:	ff 75 20             	pushl  0x20(%ebp)
  80083f:	8b 45 08             	mov    0x8(%ebp),%eax
  800842:	ff d0                	call   *%eax
  800844:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800847:	ff 4d 1c             	decl   0x1c(%ebp)
  80084a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80084e:	7f e6                	jg     800836 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800850:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800853:	bb 00 00 00 00       	mov    $0x0,%ebx
  800858:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80085b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80085e:	53                   	push   %ebx
  80085f:	51                   	push   %ecx
  800860:	52                   	push   %edx
  800861:	50                   	push   %eax
  800862:	e8 65 37 00 00       	call   803fcc <__umoddi3>
  800867:	83 c4 10             	add    $0x10,%esp
  80086a:	05 54 47 80 00       	add    $0x804754,%eax
  80086f:	8a 00                	mov    (%eax),%al
  800871:	0f be c0             	movsbl %al,%eax
  800874:	83 ec 08             	sub    $0x8,%esp
  800877:	ff 75 0c             	pushl  0xc(%ebp)
  80087a:	50                   	push   %eax
  80087b:	8b 45 08             	mov    0x8(%ebp),%eax
  80087e:	ff d0                	call   *%eax
  800880:	83 c4 10             	add    $0x10,%esp
}
  800883:	90                   	nop
  800884:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800887:	c9                   	leave  
  800888:	c3                   	ret    

00800889 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800889:	55                   	push   %ebp
  80088a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80088c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800890:	7e 1c                	jle    8008ae <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800892:	8b 45 08             	mov    0x8(%ebp),%eax
  800895:	8b 00                	mov    (%eax),%eax
  800897:	8d 50 08             	lea    0x8(%eax),%edx
  80089a:	8b 45 08             	mov    0x8(%ebp),%eax
  80089d:	89 10                	mov    %edx,(%eax)
  80089f:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a2:	8b 00                	mov    (%eax),%eax
  8008a4:	83 e8 08             	sub    $0x8,%eax
  8008a7:	8b 50 04             	mov    0x4(%eax),%edx
  8008aa:	8b 00                	mov    (%eax),%eax
  8008ac:	eb 40                	jmp    8008ee <getuint+0x65>
	else if (lflag)
  8008ae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008b2:	74 1e                	je     8008d2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b7:	8b 00                	mov    (%eax),%eax
  8008b9:	8d 50 04             	lea    0x4(%eax),%edx
  8008bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bf:	89 10                	mov    %edx,(%eax)
  8008c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c4:	8b 00                	mov    (%eax),%eax
  8008c6:	83 e8 04             	sub    $0x4,%eax
  8008c9:	8b 00                	mov    (%eax),%eax
  8008cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d0:	eb 1c                	jmp    8008ee <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d5:	8b 00                	mov    (%eax),%eax
  8008d7:	8d 50 04             	lea    0x4(%eax),%edx
  8008da:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dd:	89 10                	mov    %edx,(%eax)
  8008df:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e2:	8b 00                	mov    (%eax),%eax
  8008e4:	83 e8 04             	sub    $0x4,%eax
  8008e7:	8b 00                	mov    (%eax),%eax
  8008e9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008ee:	5d                   	pop    %ebp
  8008ef:	c3                   	ret    

008008f0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008f0:	55                   	push   %ebp
  8008f1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008f3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008f7:	7e 1c                	jle    800915 <getint+0x25>
		return va_arg(*ap, long long);
  8008f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fc:	8b 00                	mov    (%eax),%eax
  8008fe:	8d 50 08             	lea    0x8(%eax),%edx
  800901:	8b 45 08             	mov    0x8(%ebp),%eax
  800904:	89 10                	mov    %edx,(%eax)
  800906:	8b 45 08             	mov    0x8(%ebp),%eax
  800909:	8b 00                	mov    (%eax),%eax
  80090b:	83 e8 08             	sub    $0x8,%eax
  80090e:	8b 50 04             	mov    0x4(%eax),%edx
  800911:	8b 00                	mov    (%eax),%eax
  800913:	eb 38                	jmp    80094d <getint+0x5d>
	else if (lflag)
  800915:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800919:	74 1a                	je     800935 <getint+0x45>
		return va_arg(*ap, long);
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	8b 00                	mov    (%eax),%eax
  800920:	8d 50 04             	lea    0x4(%eax),%edx
  800923:	8b 45 08             	mov    0x8(%ebp),%eax
  800926:	89 10                	mov    %edx,(%eax)
  800928:	8b 45 08             	mov    0x8(%ebp),%eax
  80092b:	8b 00                	mov    (%eax),%eax
  80092d:	83 e8 04             	sub    $0x4,%eax
  800930:	8b 00                	mov    (%eax),%eax
  800932:	99                   	cltd   
  800933:	eb 18                	jmp    80094d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800935:	8b 45 08             	mov    0x8(%ebp),%eax
  800938:	8b 00                	mov    (%eax),%eax
  80093a:	8d 50 04             	lea    0x4(%eax),%edx
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	89 10                	mov    %edx,(%eax)
  800942:	8b 45 08             	mov    0x8(%ebp),%eax
  800945:	8b 00                	mov    (%eax),%eax
  800947:	83 e8 04             	sub    $0x4,%eax
  80094a:	8b 00                	mov    (%eax),%eax
  80094c:	99                   	cltd   
}
  80094d:	5d                   	pop    %ebp
  80094e:	c3                   	ret    

0080094f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80094f:	55                   	push   %ebp
  800950:	89 e5                	mov    %esp,%ebp
  800952:	56                   	push   %esi
  800953:	53                   	push   %ebx
  800954:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800957:	eb 17                	jmp    800970 <vprintfmt+0x21>
			if (ch == '\0')
  800959:	85 db                	test   %ebx,%ebx
  80095b:	0f 84 c1 03 00 00    	je     800d22 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800961:	83 ec 08             	sub    $0x8,%esp
  800964:	ff 75 0c             	pushl  0xc(%ebp)
  800967:	53                   	push   %ebx
  800968:	8b 45 08             	mov    0x8(%ebp),%eax
  80096b:	ff d0                	call   *%eax
  80096d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800970:	8b 45 10             	mov    0x10(%ebp),%eax
  800973:	8d 50 01             	lea    0x1(%eax),%edx
  800976:	89 55 10             	mov    %edx,0x10(%ebp)
  800979:	8a 00                	mov    (%eax),%al
  80097b:	0f b6 d8             	movzbl %al,%ebx
  80097e:	83 fb 25             	cmp    $0x25,%ebx
  800981:	75 d6                	jne    800959 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800983:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800987:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80098e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800995:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80099c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a6:	8d 50 01             	lea    0x1(%eax),%edx
  8009a9:	89 55 10             	mov    %edx,0x10(%ebp)
  8009ac:	8a 00                	mov    (%eax),%al
  8009ae:	0f b6 d8             	movzbl %al,%ebx
  8009b1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009b4:	83 f8 5b             	cmp    $0x5b,%eax
  8009b7:	0f 87 3d 03 00 00    	ja     800cfa <vprintfmt+0x3ab>
  8009bd:	8b 04 85 78 47 80 00 	mov    0x804778(,%eax,4),%eax
  8009c4:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009c6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009ca:	eb d7                	jmp    8009a3 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009cc:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009d0:	eb d1                	jmp    8009a3 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009d2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009d9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009dc:	89 d0                	mov    %edx,%eax
  8009de:	c1 e0 02             	shl    $0x2,%eax
  8009e1:	01 d0                	add    %edx,%eax
  8009e3:	01 c0                	add    %eax,%eax
  8009e5:	01 d8                	add    %ebx,%eax
  8009e7:	83 e8 30             	sub    $0x30,%eax
  8009ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8009f0:	8a 00                	mov    (%eax),%al
  8009f2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009f5:	83 fb 2f             	cmp    $0x2f,%ebx
  8009f8:	7e 3e                	jle    800a38 <vprintfmt+0xe9>
  8009fa:	83 fb 39             	cmp    $0x39,%ebx
  8009fd:	7f 39                	jg     800a38 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009ff:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a02:	eb d5                	jmp    8009d9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a04:	8b 45 14             	mov    0x14(%ebp),%eax
  800a07:	83 c0 04             	add    $0x4,%eax
  800a0a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a0d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a10:	83 e8 04             	sub    $0x4,%eax
  800a13:	8b 00                	mov    (%eax),%eax
  800a15:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a18:	eb 1f                	jmp    800a39 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a1a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a1e:	79 83                	jns    8009a3 <vprintfmt+0x54>
				width = 0;
  800a20:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a27:	e9 77 ff ff ff       	jmp    8009a3 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a2c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a33:	e9 6b ff ff ff       	jmp    8009a3 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a38:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a39:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a3d:	0f 89 60 ff ff ff    	jns    8009a3 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a43:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a46:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a49:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a50:	e9 4e ff ff ff       	jmp    8009a3 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a55:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a58:	e9 46 ff ff ff       	jmp    8009a3 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a60:	83 c0 04             	add    $0x4,%eax
  800a63:	89 45 14             	mov    %eax,0x14(%ebp)
  800a66:	8b 45 14             	mov    0x14(%ebp),%eax
  800a69:	83 e8 04             	sub    $0x4,%eax
  800a6c:	8b 00                	mov    (%eax),%eax
  800a6e:	83 ec 08             	sub    $0x8,%esp
  800a71:	ff 75 0c             	pushl  0xc(%ebp)
  800a74:	50                   	push   %eax
  800a75:	8b 45 08             	mov    0x8(%ebp),%eax
  800a78:	ff d0                	call   *%eax
  800a7a:	83 c4 10             	add    $0x10,%esp
			break;
  800a7d:	e9 9b 02 00 00       	jmp    800d1d <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a82:	8b 45 14             	mov    0x14(%ebp),%eax
  800a85:	83 c0 04             	add    $0x4,%eax
  800a88:	89 45 14             	mov    %eax,0x14(%ebp)
  800a8b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8e:	83 e8 04             	sub    $0x4,%eax
  800a91:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a93:	85 db                	test   %ebx,%ebx
  800a95:	79 02                	jns    800a99 <vprintfmt+0x14a>
				err = -err;
  800a97:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a99:	83 fb 64             	cmp    $0x64,%ebx
  800a9c:	7f 0b                	jg     800aa9 <vprintfmt+0x15a>
  800a9e:	8b 34 9d c0 45 80 00 	mov    0x8045c0(,%ebx,4),%esi
  800aa5:	85 f6                	test   %esi,%esi
  800aa7:	75 19                	jne    800ac2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800aa9:	53                   	push   %ebx
  800aaa:	68 65 47 80 00       	push   $0x804765
  800aaf:	ff 75 0c             	pushl  0xc(%ebp)
  800ab2:	ff 75 08             	pushl  0x8(%ebp)
  800ab5:	e8 70 02 00 00       	call   800d2a <printfmt>
  800aba:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800abd:	e9 5b 02 00 00       	jmp    800d1d <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ac2:	56                   	push   %esi
  800ac3:	68 6e 47 80 00       	push   $0x80476e
  800ac8:	ff 75 0c             	pushl  0xc(%ebp)
  800acb:	ff 75 08             	pushl  0x8(%ebp)
  800ace:	e8 57 02 00 00       	call   800d2a <printfmt>
  800ad3:	83 c4 10             	add    $0x10,%esp
			break;
  800ad6:	e9 42 02 00 00       	jmp    800d1d <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800adb:	8b 45 14             	mov    0x14(%ebp),%eax
  800ade:	83 c0 04             	add    $0x4,%eax
  800ae1:	89 45 14             	mov    %eax,0x14(%ebp)
  800ae4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae7:	83 e8 04             	sub    $0x4,%eax
  800aea:	8b 30                	mov    (%eax),%esi
  800aec:	85 f6                	test   %esi,%esi
  800aee:	75 05                	jne    800af5 <vprintfmt+0x1a6>
				p = "(null)";
  800af0:	be 71 47 80 00       	mov    $0x804771,%esi
			if (width > 0 && padc != '-')
  800af5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800af9:	7e 6d                	jle    800b68 <vprintfmt+0x219>
  800afb:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800aff:	74 67                	je     800b68 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b01:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b04:	83 ec 08             	sub    $0x8,%esp
  800b07:	50                   	push   %eax
  800b08:	56                   	push   %esi
  800b09:	e8 1e 03 00 00       	call   800e2c <strnlen>
  800b0e:	83 c4 10             	add    $0x10,%esp
  800b11:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b14:	eb 16                	jmp    800b2c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b16:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b1a:	83 ec 08             	sub    $0x8,%esp
  800b1d:	ff 75 0c             	pushl  0xc(%ebp)
  800b20:	50                   	push   %eax
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	ff d0                	call   *%eax
  800b26:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b29:	ff 4d e4             	decl   -0x1c(%ebp)
  800b2c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b30:	7f e4                	jg     800b16 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b32:	eb 34                	jmp    800b68 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b34:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b38:	74 1c                	je     800b56 <vprintfmt+0x207>
  800b3a:	83 fb 1f             	cmp    $0x1f,%ebx
  800b3d:	7e 05                	jle    800b44 <vprintfmt+0x1f5>
  800b3f:	83 fb 7e             	cmp    $0x7e,%ebx
  800b42:	7e 12                	jle    800b56 <vprintfmt+0x207>
					putch('?', putdat);
  800b44:	83 ec 08             	sub    $0x8,%esp
  800b47:	ff 75 0c             	pushl  0xc(%ebp)
  800b4a:	6a 3f                	push   $0x3f
  800b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4f:	ff d0                	call   *%eax
  800b51:	83 c4 10             	add    $0x10,%esp
  800b54:	eb 0f                	jmp    800b65 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b56:	83 ec 08             	sub    $0x8,%esp
  800b59:	ff 75 0c             	pushl  0xc(%ebp)
  800b5c:	53                   	push   %ebx
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	ff d0                	call   *%eax
  800b62:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b65:	ff 4d e4             	decl   -0x1c(%ebp)
  800b68:	89 f0                	mov    %esi,%eax
  800b6a:	8d 70 01             	lea    0x1(%eax),%esi
  800b6d:	8a 00                	mov    (%eax),%al
  800b6f:	0f be d8             	movsbl %al,%ebx
  800b72:	85 db                	test   %ebx,%ebx
  800b74:	74 24                	je     800b9a <vprintfmt+0x24b>
  800b76:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b7a:	78 b8                	js     800b34 <vprintfmt+0x1e5>
  800b7c:	ff 4d e0             	decl   -0x20(%ebp)
  800b7f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b83:	79 af                	jns    800b34 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b85:	eb 13                	jmp    800b9a <vprintfmt+0x24b>
				putch(' ', putdat);
  800b87:	83 ec 08             	sub    $0x8,%esp
  800b8a:	ff 75 0c             	pushl  0xc(%ebp)
  800b8d:	6a 20                	push   $0x20
  800b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b92:	ff d0                	call   *%eax
  800b94:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b97:	ff 4d e4             	decl   -0x1c(%ebp)
  800b9a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b9e:	7f e7                	jg     800b87 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ba0:	e9 78 01 00 00       	jmp    800d1d <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ba5:	83 ec 08             	sub    $0x8,%esp
  800ba8:	ff 75 e8             	pushl  -0x18(%ebp)
  800bab:	8d 45 14             	lea    0x14(%ebp),%eax
  800bae:	50                   	push   %eax
  800baf:	e8 3c fd ff ff       	call   8008f0 <getint>
  800bb4:	83 c4 10             	add    $0x10,%esp
  800bb7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bba:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bc0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bc3:	85 d2                	test   %edx,%edx
  800bc5:	79 23                	jns    800bea <vprintfmt+0x29b>
				putch('-', putdat);
  800bc7:	83 ec 08             	sub    $0x8,%esp
  800bca:	ff 75 0c             	pushl  0xc(%ebp)
  800bcd:	6a 2d                	push   $0x2d
  800bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd2:	ff d0                	call   *%eax
  800bd4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bda:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bdd:	f7 d8                	neg    %eax
  800bdf:	83 d2 00             	adc    $0x0,%edx
  800be2:	f7 da                	neg    %edx
  800be4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bea:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bf1:	e9 bc 00 00 00       	jmp    800cb2 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bf6:	83 ec 08             	sub    $0x8,%esp
  800bf9:	ff 75 e8             	pushl  -0x18(%ebp)
  800bfc:	8d 45 14             	lea    0x14(%ebp),%eax
  800bff:	50                   	push   %eax
  800c00:	e8 84 fc ff ff       	call   800889 <getuint>
  800c05:	83 c4 10             	add    $0x10,%esp
  800c08:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c0b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c0e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c15:	e9 98 00 00 00       	jmp    800cb2 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c1a:	83 ec 08             	sub    $0x8,%esp
  800c1d:	ff 75 0c             	pushl  0xc(%ebp)
  800c20:	6a 58                	push   $0x58
  800c22:	8b 45 08             	mov    0x8(%ebp),%eax
  800c25:	ff d0                	call   *%eax
  800c27:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c2a:	83 ec 08             	sub    $0x8,%esp
  800c2d:	ff 75 0c             	pushl  0xc(%ebp)
  800c30:	6a 58                	push   $0x58
  800c32:	8b 45 08             	mov    0x8(%ebp),%eax
  800c35:	ff d0                	call   *%eax
  800c37:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c3a:	83 ec 08             	sub    $0x8,%esp
  800c3d:	ff 75 0c             	pushl  0xc(%ebp)
  800c40:	6a 58                	push   $0x58
  800c42:	8b 45 08             	mov    0x8(%ebp),%eax
  800c45:	ff d0                	call   *%eax
  800c47:	83 c4 10             	add    $0x10,%esp
			break;
  800c4a:	e9 ce 00 00 00       	jmp    800d1d <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c4f:	83 ec 08             	sub    $0x8,%esp
  800c52:	ff 75 0c             	pushl  0xc(%ebp)
  800c55:	6a 30                	push   $0x30
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	ff d0                	call   *%eax
  800c5c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c5f:	83 ec 08             	sub    $0x8,%esp
  800c62:	ff 75 0c             	pushl  0xc(%ebp)
  800c65:	6a 78                	push   $0x78
  800c67:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6a:	ff d0                	call   *%eax
  800c6c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c6f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c72:	83 c0 04             	add    $0x4,%eax
  800c75:	89 45 14             	mov    %eax,0x14(%ebp)
  800c78:	8b 45 14             	mov    0x14(%ebp),%eax
  800c7b:	83 e8 04             	sub    $0x4,%eax
  800c7e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c80:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c83:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c8a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c91:	eb 1f                	jmp    800cb2 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c93:	83 ec 08             	sub    $0x8,%esp
  800c96:	ff 75 e8             	pushl  -0x18(%ebp)
  800c99:	8d 45 14             	lea    0x14(%ebp),%eax
  800c9c:	50                   	push   %eax
  800c9d:	e8 e7 fb ff ff       	call   800889 <getuint>
  800ca2:	83 c4 10             	add    $0x10,%esp
  800ca5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cab:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cb2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cb9:	83 ec 04             	sub    $0x4,%esp
  800cbc:	52                   	push   %edx
  800cbd:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cc0:	50                   	push   %eax
  800cc1:	ff 75 f4             	pushl  -0xc(%ebp)
  800cc4:	ff 75 f0             	pushl  -0x10(%ebp)
  800cc7:	ff 75 0c             	pushl  0xc(%ebp)
  800cca:	ff 75 08             	pushl  0x8(%ebp)
  800ccd:	e8 00 fb ff ff       	call   8007d2 <printnum>
  800cd2:	83 c4 20             	add    $0x20,%esp
			break;
  800cd5:	eb 46                	jmp    800d1d <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cd7:	83 ec 08             	sub    $0x8,%esp
  800cda:	ff 75 0c             	pushl  0xc(%ebp)
  800cdd:	53                   	push   %ebx
  800cde:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce1:	ff d0                	call   *%eax
  800ce3:	83 c4 10             	add    $0x10,%esp
			break;
  800ce6:	eb 35                	jmp    800d1d <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800ce8:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
			break;
  800cef:	eb 2c                	jmp    800d1d <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800cf1:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
			break;
  800cf8:	eb 23                	jmp    800d1d <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cfa:	83 ec 08             	sub    $0x8,%esp
  800cfd:	ff 75 0c             	pushl  0xc(%ebp)
  800d00:	6a 25                	push   $0x25
  800d02:	8b 45 08             	mov    0x8(%ebp),%eax
  800d05:	ff d0                	call   *%eax
  800d07:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d0a:	ff 4d 10             	decl   0x10(%ebp)
  800d0d:	eb 03                	jmp    800d12 <vprintfmt+0x3c3>
  800d0f:	ff 4d 10             	decl   0x10(%ebp)
  800d12:	8b 45 10             	mov    0x10(%ebp),%eax
  800d15:	48                   	dec    %eax
  800d16:	8a 00                	mov    (%eax),%al
  800d18:	3c 25                	cmp    $0x25,%al
  800d1a:	75 f3                	jne    800d0f <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d1c:	90                   	nop
		}
	}
  800d1d:	e9 35 fc ff ff       	jmp    800957 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d22:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d23:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d26:	5b                   	pop    %ebx
  800d27:	5e                   	pop    %esi
  800d28:	5d                   	pop    %ebp
  800d29:	c3                   	ret    

00800d2a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
  800d2d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d30:	8d 45 10             	lea    0x10(%ebp),%eax
  800d33:	83 c0 04             	add    $0x4,%eax
  800d36:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d39:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3c:	ff 75 f4             	pushl  -0xc(%ebp)
  800d3f:	50                   	push   %eax
  800d40:	ff 75 0c             	pushl  0xc(%ebp)
  800d43:	ff 75 08             	pushl  0x8(%ebp)
  800d46:	e8 04 fc ff ff       	call   80094f <vprintfmt>
  800d4b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d4e:	90                   	nop
  800d4f:	c9                   	leave  
  800d50:	c3                   	ret    

00800d51 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d51:	55                   	push   %ebp
  800d52:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d57:	8b 40 08             	mov    0x8(%eax),%eax
  800d5a:	8d 50 01             	lea    0x1(%eax),%edx
  800d5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d60:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d66:	8b 10                	mov    (%eax),%edx
  800d68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6b:	8b 40 04             	mov    0x4(%eax),%eax
  800d6e:	39 c2                	cmp    %eax,%edx
  800d70:	73 12                	jae    800d84 <sprintputch+0x33>
		*b->buf++ = ch;
  800d72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d75:	8b 00                	mov    (%eax),%eax
  800d77:	8d 48 01             	lea    0x1(%eax),%ecx
  800d7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d7d:	89 0a                	mov    %ecx,(%edx)
  800d7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d82:	88 10                	mov    %dl,(%eax)
}
  800d84:	90                   	nop
  800d85:	5d                   	pop    %ebp
  800d86:	c3                   	ret    

00800d87 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d87:	55                   	push   %ebp
  800d88:	89 e5                	mov    %esp,%ebp
  800d8a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d90:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d96:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d99:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9c:	01 d0                	add    %edx,%eax
  800d9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800da1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800da8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dac:	74 06                	je     800db4 <vsnprintf+0x2d>
  800dae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800db2:	7f 07                	jg     800dbb <vsnprintf+0x34>
		return -E_INVAL;
  800db4:	b8 03 00 00 00       	mov    $0x3,%eax
  800db9:	eb 20                	jmp    800ddb <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dbb:	ff 75 14             	pushl  0x14(%ebp)
  800dbe:	ff 75 10             	pushl  0x10(%ebp)
  800dc1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dc4:	50                   	push   %eax
  800dc5:	68 51 0d 80 00       	push   $0x800d51
  800dca:	e8 80 fb ff ff       	call   80094f <vprintfmt>
  800dcf:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dd5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ddb:	c9                   	leave  
  800ddc:	c3                   	ret    

00800ddd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800de3:	8d 45 10             	lea    0x10(%ebp),%eax
  800de6:	83 c0 04             	add    $0x4,%eax
  800de9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800dec:	8b 45 10             	mov    0x10(%ebp),%eax
  800def:	ff 75 f4             	pushl  -0xc(%ebp)
  800df2:	50                   	push   %eax
  800df3:	ff 75 0c             	pushl  0xc(%ebp)
  800df6:	ff 75 08             	pushl  0x8(%ebp)
  800df9:	e8 89 ff ff ff       	call   800d87 <vsnprintf>
  800dfe:	83 c4 10             	add    $0x10,%esp
  800e01:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e04:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e07:	c9                   	leave  
  800e08:	c3                   	ret    

00800e09 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e09:	55                   	push   %ebp
  800e0a:	89 e5                	mov    %esp,%ebp
  800e0c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e0f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e16:	eb 06                	jmp    800e1e <strlen+0x15>
		n++;
  800e18:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e1b:	ff 45 08             	incl   0x8(%ebp)
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	8a 00                	mov    (%eax),%al
  800e23:	84 c0                	test   %al,%al
  800e25:	75 f1                	jne    800e18 <strlen+0xf>
		n++;
	return n;
  800e27:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e2a:	c9                   	leave  
  800e2b:	c3                   	ret    

00800e2c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e2c:	55                   	push   %ebp
  800e2d:	89 e5                	mov    %esp,%ebp
  800e2f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e32:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e39:	eb 09                	jmp    800e44 <strnlen+0x18>
		n++;
  800e3b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e3e:	ff 45 08             	incl   0x8(%ebp)
  800e41:	ff 4d 0c             	decl   0xc(%ebp)
  800e44:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e48:	74 09                	je     800e53 <strnlen+0x27>
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	8a 00                	mov    (%eax),%al
  800e4f:	84 c0                	test   %al,%al
  800e51:	75 e8                	jne    800e3b <strnlen+0xf>
		n++;
	return n;
  800e53:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e56:	c9                   	leave  
  800e57:	c3                   	ret    

00800e58 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e58:	55                   	push   %ebp
  800e59:	89 e5                	mov    %esp,%ebp
  800e5b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e61:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e64:	90                   	nop
  800e65:	8b 45 08             	mov    0x8(%ebp),%eax
  800e68:	8d 50 01             	lea    0x1(%eax),%edx
  800e6b:	89 55 08             	mov    %edx,0x8(%ebp)
  800e6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e71:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e74:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e77:	8a 12                	mov    (%edx),%dl
  800e79:	88 10                	mov    %dl,(%eax)
  800e7b:	8a 00                	mov    (%eax),%al
  800e7d:	84 c0                	test   %al,%al
  800e7f:	75 e4                	jne    800e65 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e81:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e84:	c9                   	leave  
  800e85:	c3                   	ret    

00800e86 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e86:	55                   	push   %ebp
  800e87:	89 e5                	mov    %esp,%ebp
  800e89:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e92:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e99:	eb 1f                	jmp    800eba <strncpy+0x34>
		*dst++ = *src;
  800e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9e:	8d 50 01             	lea    0x1(%eax),%edx
  800ea1:	89 55 08             	mov    %edx,0x8(%ebp)
  800ea4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea7:	8a 12                	mov    (%edx),%dl
  800ea9:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800eab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eae:	8a 00                	mov    (%eax),%al
  800eb0:	84 c0                	test   %al,%al
  800eb2:	74 03                	je     800eb7 <strncpy+0x31>
			src++;
  800eb4:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800eb7:	ff 45 fc             	incl   -0x4(%ebp)
  800eba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ebd:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ec0:	72 d9                	jb     800e9b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ec2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ec5:	c9                   	leave  
  800ec6:	c3                   	ret    

00800ec7 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ec7:	55                   	push   %ebp
  800ec8:	89 e5                	mov    %esp,%ebp
  800eca:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ed3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed7:	74 30                	je     800f09 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ed9:	eb 16                	jmp    800ef1 <strlcpy+0x2a>
			*dst++ = *src++;
  800edb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ede:	8d 50 01             	lea    0x1(%eax),%edx
  800ee1:	89 55 08             	mov    %edx,0x8(%ebp)
  800ee4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ee7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eea:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800eed:	8a 12                	mov    (%edx),%dl
  800eef:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ef1:	ff 4d 10             	decl   0x10(%ebp)
  800ef4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef8:	74 09                	je     800f03 <strlcpy+0x3c>
  800efa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efd:	8a 00                	mov    (%eax),%al
  800eff:	84 c0                	test   %al,%al
  800f01:	75 d8                	jne    800edb <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f03:	8b 45 08             	mov    0x8(%ebp),%eax
  800f06:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f09:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0f:	29 c2                	sub    %eax,%edx
  800f11:	89 d0                	mov    %edx,%eax
}
  800f13:	c9                   	leave  
  800f14:	c3                   	ret    

00800f15 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f15:	55                   	push   %ebp
  800f16:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f18:	eb 06                	jmp    800f20 <strcmp+0xb>
		p++, q++;
  800f1a:	ff 45 08             	incl   0x8(%ebp)
  800f1d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	8a 00                	mov    (%eax),%al
  800f25:	84 c0                	test   %al,%al
  800f27:	74 0e                	je     800f37 <strcmp+0x22>
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	8a 10                	mov    (%eax),%dl
  800f2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f31:	8a 00                	mov    (%eax),%al
  800f33:	38 c2                	cmp    %al,%dl
  800f35:	74 e3                	je     800f1a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f37:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3a:	8a 00                	mov    (%eax),%al
  800f3c:	0f b6 d0             	movzbl %al,%edx
  800f3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f42:	8a 00                	mov    (%eax),%al
  800f44:	0f b6 c0             	movzbl %al,%eax
  800f47:	29 c2                	sub    %eax,%edx
  800f49:	89 d0                	mov    %edx,%eax
}
  800f4b:	5d                   	pop    %ebp
  800f4c:	c3                   	ret    

00800f4d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f4d:	55                   	push   %ebp
  800f4e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f50:	eb 09                	jmp    800f5b <strncmp+0xe>
		n--, p++, q++;
  800f52:	ff 4d 10             	decl   0x10(%ebp)
  800f55:	ff 45 08             	incl   0x8(%ebp)
  800f58:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f5b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f5f:	74 17                	je     800f78 <strncmp+0x2b>
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
  800f64:	8a 00                	mov    (%eax),%al
  800f66:	84 c0                	test   %al,%al
  800f68:	74 0e                	je     800f78 <strncmp+0x2b>
  800f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6d:	8a 10                	mov    (%eax),%dl
  800f6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f72:	8a 00                	mov    (%eax),%al
  800f74:	38 c2                	cmp    %al,%dl
  800f76:	74 da                	je     800f52 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f78:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7c:	75 07                	jne    800f85 <strncmp+0x38>
		return 0;
  800f7e:	b8 00 00 00 00       	mov    $0x0,%eax
  800f83:	eb 14                	jmp    800f99 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
  800f88:	8a 00                	mov    (%eax),%al
  800f8a:	0f b6 d0             	movzbl %al,%edx
  800f8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f90:	8a 00                	mov    (%eax),%al
  800f92:	0f b6 c0             	movzbl %al,%eax
  800f95:	29 c2                	sub    %eax,%edx
  800f97:	89 d0                	mov    %edx,%eax
}
  800f99:	5d                   	pop    %ebp
  800f9a:	c3                   	ret    

00800f9b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f9b:	55                   	push   %ebp
  800f9c:	89 e5                	mov    %esp,%ebp
  800f9e:	83 ec 04             	sub    $0x4,%esp
  800fa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fa7:	eb 12                	jmp    800fbb <strchr+0x20>
		if (*s == c)
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	8a 00                	mov    (%eax),%al
  800fae:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fb1:	75 05                	jne    800fb8 <strchr+0x1d>
			return (char *) s;
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	eb 11                	jmp    800fc9 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fb8:	ff 45 08             	incl   0x8(%ebp)
  800fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbe:	8a 00                	mov    (%eax),%al
  800fc0:	84 c0                	test   %al,%al
  800fc2:	75 e5                	jne    800fa9 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fc9:	c9                   	leave  
  800fca:	c3                   	ret    

00800fcb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fcb:	55                   	push   %ebp
  800fcc:	89 e5                	mov    %esp,%ebp
  800fce:	83 ec 04             	sub    $0x4,%esp
  800fd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fd7:	eb 0d                	jmp    800fe6 <strfind+0x1b>
		if (*s == c)
  800fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdc:	8a 00                	mov    (%eax),%al
  800fde:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fe1:	74 0e                	je     800ff1 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fe3:	ff 45 08             	incl   0x8(%ebp)
  800fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe9:	8a 00                	mov    (%eax),%al
  800feb:	84 c0                	test   %al,%al
  800fed:	75 ea                	jne    800fd9 <strfind+0xe>
  800fef:	eb 01                	jmp    800ff2 <strfind+0x27>
		if (*s == c)
			break;
  800ff1:	90                   	nop
	return (char *) s;
  800ff2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ff5:	c9                   	leave  
  800ff6:	c3                   	ret    

00800ff7 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800ff7:	55                   	push   %ebp
  800ff8:	89 e5                	mov    %esp,%ebp
  800ffa:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  801000:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801003:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801007:	76 63                	jbe    80106c <memset+0x75>
		uint64 data_block = c;
  801009:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100c:	99                   	cltd   
  80100d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801010:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801013:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801016:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801019:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80101d:	c1 e0 08             	shl    $0x8,%eax
  801020:	09 45 f0             	or     %eax,-0x10(%ebp)
  801023:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801026:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801029:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80102c:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801030:	c1 e0 10             	shl    $0x10,%eax
  801033:	09 45 f0             	or     %eax,-0x10(%ebp)
  801036:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801039:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80103c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80103f:	89 c2                	mov    %eax,%edx
  801041:	b8 00 00 00 00       	mov    $0x0,%eax
  801046:	09 45 f0             	or     %eax,-0x10(%ebp)
  801049:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80104c:	eb 18                	jmp    801066 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80104e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801051:	8d 41 08             	lea    0x8(%ecx),%eax
  801054:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801057:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80105a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80105d:	89 01                	mov    %eax,(%ecx)
  80105f:	89 51 04             	mov    %edx,0x4(%ecx)
  801062:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801066:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80106a:	77 e2                	ja     80104e <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80106c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801070:	74 23                	je     801095 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801072:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801075:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801078:	eb 0e                	jmp    801088 <memset+0x91>
			*p8++ = (uint8)c;
  80107a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80107d:	8d 50 01             	lea    0x1(%eax),%edx
  801080:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801083:	8b 55 0c             	mov    0xc(%ebp),%edx
  801086:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801088:	8b 45 10             	mov    0x10(%ebp),%eax
  80108b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80108e:	89 55 10             	mov    %edx,0x10(%ebp)
  801091:	85 c0                	test   %eax,%eax
  801093:	75 e5                	jne    80107a <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801095:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801098:	c9                   	leave  
  801099:	c3                   	ret    

0080109a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80109a:	55                   	push   %ebp
  80109b:	89 e5                	mov    %esp,%ebp
  80109d:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8010a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8010a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8010ac:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010b0:	76 24                	jbe    8010d6 <memcpy+0x3c>
		while(n >= 8){
  8010b2:	eb 1c                	jmp    8010d0 <memcpy+0x36>
			*d64 = *s64;
  8010b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010b7:	8b 50 04             	mov    0x4(%eax),%edx
  8010ba:	8b 00                	mov    (%eax),%eax
  8010bc:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010bf:	89 01                	mov    %eax,(%ecx)
  8010c1:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8010c4:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8010c8:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8010cc:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8010d0:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010d4:	77 de                	ja     8010b4 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8010d6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010da:	74 31                	je     80110d <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8010dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010df:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8010e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8010e8:	eb 16                	jmp    801100 <memcpy+0x66>
			*d8++ = *s8++;
  8010ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010ed:	8d 50 01             	lea    0x1(%eax),%edx
  8010f0:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8010f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010f6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010f9:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8010fc:	8a 12                	mov    (%edx),%dl
  8010fe:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801100:	8b 45 10             	mov    0x10(%ebp),%eax
  801103:	8d 50 ff             	lea    -0x1(%eax),%edx
  801106:	89 55 10             	mov    %edx,0x10(%ebp)
  801109:	85 c0                	test   %eax,%eax
  80110b:	75 dd                	jne    8010ea <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80110d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801110:	c9                   	leave  
  801111:	c3                   	ret    

00801112 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801112:	55                   	push   %ebp
  801113:	89 e5                	mov    %esp,%ebp
  801115:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801118:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80111e:	8b 45 08             	mov    0x8(%ebp),%eax
  801121:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801124:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801127:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80112a:	73 50                	jae    80117c <memmove+0x6a>
  80112c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80112f:	8b 45 10             	mov    0x10(%ebp),%eax
  801132:	01 d0                	add    %edx,%eax
  801134:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801137:	76 43                	jbe    80117c <memmove+0x6a>
		s += n;
  801139:	8b 45 10             	mov    0x10(%ebp),%eax
  80113c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80113f:	8b 45 10             	mov    0x10(%ebp),%eax
  801142:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801145:	eb 10                	jmp    801157 <memmove+0x45>
			*--d = *--s;
  801147:	ff 4d f8             	decl   -0x8(%ebp)
  80114a:	ff 4d fc             	decl   -0x4(%ebp)
  80114d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801150:	8a 10                	mov    (%eax),%dl
  801152:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801155:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801157:	8b 45 10             	mov    0x10(%ebp),%eax
  80115a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80115d:	89 55 10             	mov    %edx,0x10(%ebp)
  801160:	85 c0                	test   %eax,%eax
  801162:	75 e3                	jne    801147 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801164:	eb 23                	jmp    801189 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801166:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801169:	8d 50 01             	lea    0x1(%eax),%edx
  80116c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80116f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801172:	8d 4a 01             	lea    0x1(%edx),%ecx
  801175:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801178:	8a 12                	mov    (%edx),%dl
  80117a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80117c:	8b 45 10             	mov    0x10(%ebp),%eax
  80117f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801182:	89 55 10             	mov    %edx,0x10(%ebp)
  801185:	85 c0                	test   %eax,%eax
  801187:	75 dd                	jne    801166 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80118c:	c9                   	leave  
  80118d:	c3                   	ret    

0080118e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80118e:	55                   	push   %ebp
  80118f:	89 e5                	mov    %esp,%ebp
  801191:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801194:	8b 45 08             	mov    0x8(%ebp),%eax
  801197:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80119a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011a0:	eb 2a                	jmp    8011cc <memcmp+0x3e>
		if (*s1 != *s2)
  8011a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a5:	8a 10                	mov    (%eax),%dl
  8011a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011aa:	8a 00                	mov    (%eax),%al
  8011ac:	38 c2                	cmp    %al,%dl
  8011ae:	74 16                	je     8011c6 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011b3:	8a 00                	mov    (%eax),%al
  8011b5:	0f b6 d0             	movzbl %al,%edx
  8011b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011bb:	8a 00                	mov    (%eax),%al
  8011bd:	0f b6 c0             	movzbl %al,%eax
  8011c0:	29 c2                	sub    %eax,%edx
  8011c2:	89 d0                	mov    %edx,%eax
  8011c4:	eb 18                	jmp    8011de <memcmp+0x50>
		s1++, s2++;
  8011c6:	ff 45 fc             	incl   -0x4(%ebp)
  8011c9:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8011cf:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011d2:	89 55 10             	mov    %edx,0x10(%ebp)
  8011d5:	85 c0                	test   %eax,%eax
  8011d7:	75 c9                	jne    8011a2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011de:	c9                   	leave  
  8011df:	c3                   	ret    

008011e0 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011e0:	55                   	push   %ebp
  8011e1:	89 e5                	mov    %esp,%ebp
  8011e3:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ec:	01 d0                	add    %edx,%eax
  8011ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011f1:	eb 15                	jmp    801208 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f6:	8a 00                	mov    (%eax),%al
  8011f8:	0f b6 d0             	movzbl %al,%edx
  8011fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fe:	0f b6 c0             	movzbl %al,%eax
  801201:	39 c2                	cmp    %eax,%edx
  801203:	74 0d                	je     801212 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801205:	ff 45 08             	incl   0x8(%ebp)
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
  80120b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80120e:	72 e3                	jb     8011f3 <memfind+0x13>
  801210:	eb 01                	jmp    801213 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801212:	90                   	nop
	return (void *) s;
  801213:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801216:	c9                   	leave  
  801217:	c3                   	ret    

00801218 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801218:	55                   	push   %ebp
  801219:	89 e5                	mov    %esp,%ebp
  80121b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80121e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801225:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80122c:	eb 03                	jmp    801231 <strtol+0x19>
		s++;
  80122e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
  801234:	8a 00                	mov    (%eax),%al
  801236:	3c 20                	cmp    $0x20,%al
  801238:	74 f4                	je     80122e <strtol+0x16>
  80123a:	8b 45 08             	mov    0x8(%ebp),%eax
  80123d:	8a 00                	mov    (%eax),%al
  80123f:	3c 09                	cmp    $0x9,%al
  801241:	74 eb                	je     80122e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801243:	8b 45 08             	mov    0x8(%ebp),%eax
  801246:	8a 00                	mov    (%eax),%al
  801248:	3c 2b                	cmp    $0x2b,%al
  80124a:	75 05                	jne    801251 <strtol+0x39>
		s++;
  80124c:	ff 45 08             	incl   0x8(%ebp)
  80124f:	eb 13                	jmp    801264 <strtol+0x4c>
	else if (*s == '-')
  801251:	8b 45 08             	mov    0x8(%ebp),%eax
  801254:	8a 00                	mov    (%eax),%al
  801256:	3c 2d                	cmp    $0x2d,%al
  801258:	75 0a                	jne    801264 <strtol+0x4c>
		s++, neg = 1;
  80125a:	ff 45 08             	incl   0x8(%ebp)
  80125d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801264:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801268:	74 06                	je     801270 <strtol+0x58>
  80126a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80126e:	75 20                	jne    801290 <strtol+0x78>
  801270:	8b 45 08             	mov    0x8(%ebp),%eax
  801273:	8a 00                	mov    (%eax),%al
  801275:	3c 30                	cmp    $0x30,%al
  801277:	75 17                	jne    801290 <strtol+0x78>
  801279:	8b 45 08             	mov    0x8(%ebp),%eax
  80127c:	40                   	inc    %eax
  80127d:	8a 00                	mov    (%eax),%al
  80127f:	3c 78                	cmp    $0x78,%al
  801281:	75 0d                	jne    801290 <strtol+0x78>
		s += 2, base = 16;
  801283:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801287:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80128e:	eb 28                	jmp    8012b8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801290:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801294:	75 15                	jne    8012ab <strtol+0x93>
  801296:	8b 45 08             	mov    0x8(%ebp),%eax
  801299:	8a 00                	mov    (%eax),%al
  80129b:	3c 30                	cmp    $0x30,%al
  80129d:	75 0c                	jne    8012ab <strtol+0x93>
		s++, base = 8;
  80129f:	ff 45 08             	incl   0x8(%ebp)
  8012a2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012a9:	eb 0d                	jmp    8012b8 <strtol+0xa0>
	else if (base == 0)
  8012ab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012af:	75 07                	jne    8012b8 <strtol+0xa0>
		base = 10;
  8012b1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bb:	8a 00                	mov    (%eax),%al
  8012bd:	3c 2f                	cmp    $0x2f,%al
  8012bf:	7e 19                	jle    8012da <strtol+0xc2>
  8012c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c4:	8a 00                	mov    (%eax),%al
  8012c6:	3c 39                	cmp    $0x39,%al
  8012c8:	7f 10                	jg     8012da <strtol+0xc2>
			dig = *s - '0';
  8012ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cd:	8a 00                	mov    (%eax),%al
  8012cf:	0f be c0             	movsbl %al,%eax
  8012d2:	83 e8 30             	sub    $0x30,%eax
  8012d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012d8:	eb 42                	jmp    80131c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012da:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dd:	8a 00                	mov    (%eax),%al
  8012df:	3c 60                	cmp    $0x60,%al
  8012e1:	7e 19                	jle    8012fc <strtol+0xe4>
  8012e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e6:	8a 00                	mov    (%eax),%al
  8012e8:	3c 7a                	cmp    $0x7a,%al
  8012ea:	7f 10                	jg     8012fc <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ef:	8a 00                	mov    (%eax),%al
  8012f1:	0f be c0             	movsbl %al,%eax
  8012f4:	83 e8 57             	sub    $0x57,%eax
  8012f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012fa:	eb 20                	jmp    80131c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ff:	8a 00                	mov    (%eax),%al
  801301:	3c 40                	cmp    $0x40,%al
  801303:	7e 39                	jle    80133e <strtol+0x126>
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
  801308:	8a 00                	mov    (%eax),%al
  80130a:	3c 5a                	cmp    $0x5a,%al
  80130c:	7f 30                	jg     80133e <strtol+0x126>
			dig = *s - 'A' + 10;
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	8a 00                	mov    (%eax),%al
  801313:	0f be c0             	movsbl %al,%eax
  801316:	83 e8 37             	sub    $0x37,%eax
  801319:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80131c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80131f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801322:	7d 19                	jge    80133d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801324:	ff 45 08             	incl   0x8(%ebp)
  801327:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80132a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80132e:	89 c2                	mov    %eax,%edx
  801330:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801333:	01 d0                	add    %edx,%eax
  801335:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801338:	e9 7b ff ff ff       	jmp    8012b8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80133d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80133e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801342:	74 08                	je     80134c <strtol+0x134>
		*endptr = (char *) s;
  801344:	8b 45 0c             	mov    0xc(%ebp),%eax
  801347:	8b 55 08             	mov    0x8(%ebp),%edx
  80134a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80134c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801350:	74 07                	je     801359 <strtol+0x141>
  801352:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801355:	f7 d8                	neg    %eax
  801357:	eb 03                	jmp    80135c <strtol+0x144>
  801359:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80135c:	c9                   	leave  
  80135d:	c3                   	ret    

0080135e <ltostr>:

void
ltostr(long value, char *str)
{
  80135e:	55                   	push   %ebp
  80135f:	89 e5                	mov    %esp,%ebp
  801361:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801364:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80136b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801372:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801376:	79 13                	jns    80138b <ltostr+0x2d>
	{
		neg = 1;
  801378:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80137f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801382:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801385:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801388:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80138b:	8b 45 08             	mov    0x8(%ebp),%eax
  80138e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801393:	99                   	cltd   
  801394:	f7 f9                	idiv   %ecx
  801396:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801399:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80139c:	8d 50 01             	lea    0x1(%eax),%edx
  80139f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013a2:	89 c2                	mov    %eax,%edx
  8013a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a7:	01 d0                	add    %edx,%eax
  8013a9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013ac:	83 c2 30             	add    $0x30,%edx
  8013af:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013b4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013b9:	f7 e9                	imul   %ecx
  8013bb:	c1 fa 02             	sar    $0x2,%edx
  8013be:	89 c8                	mov    %ecx,%eax
  8013c0:	c1 f8 1f             	sar    $0x1f,%eax
  8013c3:	29 c2                	sub    %eax,%edx
  8013c5:	89 d0                	mov    %edx,%eax
  8013c7:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013ce:	75 bb                	jne    80138b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013da:	48                   	dec    %eax
  8013db:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013de:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013e2:	74 3d                	je     801421 <ltostr+0xc3>
		start = 1 ;
  8013e4:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013eb:	eb 34                	jmp    801421 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8013ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f3:	01 d0                	add    %edx,%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801400:	01 c2                	add    %eax,%edx
  801402:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801405:	8b 45 0c             	mov    0xc(%ebp),%eax
  801408:	01 c8                	add    %ecx,%eax
  80140a:	8a 00                	mov    (%eax),%al
  80140c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80140e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801411:	8b 45 0c             	mov    0xc(%ebp),%eax
  801414:	01 c2                	add    %eax,%edx
  801416:	8a 45 eb             	mov    -0x15(%ebp),%al
  801419:	88 02                	mov    %al,(%edx)
		start++ ;
  80141b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80141e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801421:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801424:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801427:	7c c4                	jl     8013ed <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801429:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80142c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142f:	01 d0                	add    %edx,%eax
  801431:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801434:	90                   	nop
  801435:	c9                   	leave  
  801436:	c3                   	ret    

00801437 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801437:	55                   	push   %ebp
  801438:	89 e5                	mov    %esp,%ebp
  80143a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80143d:	ff 75 08             	pushl  0x8(%ebp)
  801440:	e8 c4 f9 ff ff       	call   800e09 <strlen>
  801445:	83 c4 04             	add    $0x4,%esp
  801448:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80144b:	ff 75 0c             	pushl  0xc(%ebp)
  80144e:	e8 b6 f9 ff ff       	call   800e09 <strlen>
  801453:	83 c4 04             	add    $0x4,%esp
  801456:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801459:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801460:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801467:	eb 17                	jmp    801480 <strcconcat+0x49>
		final[s] = str1[s] ;
  801469:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80146c:	8b 45 10             	mov    0x10(%ebp),%eax
  80146f:	01 c2                	add    %eax,%edx
  801471:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801474:	8b 45 08             	mov    0x8(%ebp),%eax
  801477:	01 c8                	add    %ecx,%eax
  801479:	8a 00                	mov    (%eax),%al
  80147b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80147d:	ff 45 fc             	incl   -0x4(%ebp)
  801480:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801483:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801486:	7c e1                	jl     801469 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801488:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80148f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801496:	eb 1f                	jmp    8014b7 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801498:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80149b:	8d 50 01             	lea    0x1(%eax),%edx
  80149e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014a1:	89 c2                	mov    %eax,%edx
  8014a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a6:	01 c2                	add    %eax,%edx
  8014a8:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ae:	01 c8                	add    %ecx,%eax
  8014b0:	8a 00                	mov    (%eax),%al
  8014b2:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014b4:	ff 45 f8             	incl   -0x8(%ebp)
  8014b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014ba:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014bd:	7c d9                	jl     801498 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014bf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c5:	01 d0                	add    %edx,%eax
  8014c7:	c6 00 00             	movb   $0x0,(%eax)
}
  8014ca:	90                   	nop
  8014cb:	c9                   	leave  
  8014cc:	c3                   	ret    

008014cd <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014cd:	55                   	push   %ebp
  8014ce:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8014d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8014dc:	8b 00                	mov    (%eax),%eax
  8014de:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e8:	01 d0                	add    %edx,%eax
  8014ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014f0:	eb 0c                	jmp    8014fe <strsplit+0x31>
			*string++ = 0;
  8014f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f5:	8d 50 01             	lea    0x1(%eax),%edx
  8014f8:	89 55 08             	mov    %edx,0x8(%ebp)
  8014fb:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801501:	8a 00                	mov    (%eax),%al
  801503:	84 c0                	test   %al,%al
  801505:	74 18                	je     80151f <strsplit+0x52>
  801507:	8b 45 08             	mov    0x8(%ebp),%eax
  80150a:	8a 00                	mov    (%eax),%al
  80150c:	0f be c0             	movsbl %al,%eax
  80150f:	50                   	push   %eax
  801510:	ff 75 0c             	pushl  0xc(%ebp)
  801513:	e8 83 fa ff ff       	call   800f9b <strchr>
  801518:	83 c4 08             	add    $0x8,%esp
  80151b:	85 c0                	test   %eax,%eax
  80151d:	75 d3                	jne    8014f2 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80151f:	8b 45 08             	mov    0x8(%ebp),%eax
  801522:	8a 00                	mov    (%eax),%al
  801524:	84 c0                	test   %al,%al
  801526:	74 5a                	je     801582 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801528:	8b 45 14             	mov    0x14(%ebp),%eax
  80152b:	8b 00                	mov    (%eax),%eax
  80152d:	83 f8 0f             	cmp    $0xf,%eax
  801530:	75 07                	jne    801539 <strsplit+0x6c>
		{
			return 0;
  801532:	b8 00 00 00 00       	mov    $0x0,%eax
  801537:	eb 66                	jmp    80159f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801539:	8b 45 14             	mov    0x14(%ebp),%eax
  80153c:	8b 00                	mov    (%eax),%eax
  80153e:	8d 48 01             	lea    0x1(%eax),%ecx
  801541:	8b 55 14             	mov    0x14(%ebp),%edx
  801544:	89 0a                	mov    %ecx,(%edx)
  801546:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80154d:	8b 45 10             	mov    0x10(%ebp),%eax
  801550:	01 c2                	add    %eax,%edx
  801552:	8b 45 08             	mov    0x8(%ebp),%eax
  801555:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801557:	eb 03                	jmp    80155c <strsplit+0x8f>
			string++;
  801559:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80155c:	8b 45 08             	mov    0x8(%ebp),%eax
  80155f:	8a 00                	mov    (%eax),%al
  801561:	84 c0                	test   %al,%al
  801563:	74 8b                	je     8014f0 <strsplit+0x23>
  801565:	8b 45 08             	mov    0x8(%ebp),%eax
  801568:	8a 00                	mov    (%eax),%al
  80156a:	0f be c0             	movsbl %al,%eax
  80156d:	50                   	push   %eax
  80156e:	ff 75 0c             	pushl  0xc(%ebp)
  801571:	e8 25 fa ff ff       	call   800f9b <strchr>
  801576:	83 c4 08             	add    $0x8,%esp
  801579:	85 c0                	test   %eax,%eax
  80157b:	74 dc                	je     801559 <strsplit+0x8c>
			string++;
	}
  80157d:	e9 6e ff ff ff       	jmp    8014f0 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801582:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801583:	8b 45 14             	mov    0x14(%ebp),%eax
  801586:	8b 00                	mov    (%eax),%eax
  801588:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80158f:	8b 45 10             	mov    0x10(%ebp),%eax
  801592:	01 d0                	add    %edx,%eax
  801594:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80159a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80159f:	c9                   	leave  
  8015a0:	c3                   	ret    

008015a1 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015a1:	55                   	push   %ebp
  8015a2:	89 e5                	mov    %esp,%ebp
  8015a4:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8015a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015aa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8015ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015b4:	eb 4a                	jmp    801600 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8015b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bc:	01 c2                	add    %eax,%edx
  8015be:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c4:	01 c8                	add    %ecx,%eax
  8015c6:	8a 00                	mov    (%eax),%al
  8015c8:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8015ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d0:	01 d0                	add    %edx,%eax
  8015d2:	8a 00                	mov    (%eax),%al
  8015d4:	3c 40                	cmp    $0x40,%al
  8015d6:	7e 25                	jle    8015fd <str2lower+0x5c>
  8015d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015de:	01 d0                	add    %edx,%eax
  8015e0:	8a 00                	mov    (%eax),%al
  8015e2:	3c 5a                	cmp    $0x5a,%al
  8015e4:	7f 17                	jg     8015fd <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8015e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ec:	01 d0                	add    %edx,%eax
  8015ee:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8015f4:	01 ca                	add    %ecx,%edx
  8015f6:	8a 12                	mov    (%edx),%dl
  8015f8:	83 c2 20             	add    $0x20,%edx
  8015fb:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8015fd:	ff 45 fc             	incl   -0x4(%ebp)
  801600:	ff 75 0c             	pushl  0xc(%ebp)
  801603:	e8 01 f8 ff ff       	call   800e09 <strlen>
  801608:	83 c4 04             	add    $0x4,%esp
  80160b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80160e:	7f a6                	jg     8015b6 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801610:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801613:	c9                   	leave  
  801614:	c3                   	ret    

00801615 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801615:	55                   	push   %ebp
  801616:	89 e5                	mov    %esp,%ebp
  801618:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  80161b:	a1 08 50 80 00       	mov    0x805008,%eax
  801620:	85 c0                	test   %eax,%eax
  801622:	74 42                	je     801666 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801624:	83 ec 08             	sub    $0x8,%esp
  801627:	68 00 00 00 82       	push   $0x82000000
  80162c:	68 00 00 00 80       	push   $0x80000000
  801631:	e8 b0 1e 00 00       	call   8034e6 <initialize_dynamic_allocator>
  801636:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801639:	e8 96 1c 00 00       	call   8032d4 <sys_get_uheap_strategy>
  80163e:	a3 80 50 83 00       	mov    %eax,0x835080
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801643:	a1 60 d0 81 00       	mov    0x81d060,%eax
  801648:	05 00 10 00 00       	add    $0x1000,%eax
  80164d:	a3 30 51 83 00       	mov    %eax,0x835130
		uheapPageAllocBreak = uheapPageAllocStart;
  801652:	a1 30 51 83 00       	mov    0x835130,%eax
  801657:	a3 88 50 83 00       	mov    %eax,0x835088

		__firstTimeFlag = 0;
  80165c:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  801663:	00 00 00 
	}
}
  801666:	90                   	nop
  801667:	c9                   	leave  
  801668:	c3                   	ret    

00801669 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801669:	55                   	push   %ebp
  80166a:	89 e5                	mov    %esp,%ebp
  80166c:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  80166f:	8b 45 08             	mov    0x8(%ebp),%eax
  801672:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801675:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801678:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80167d:	83 ec 08             	sub    $0x8,%esp
  801680:	68 06 04 00 00       	push   $0x406
  801685:	50                   	push   %eax
  801686:	e8 93 18 00 00       	call   802f1e <__sys_allocate_page>
  80168b:	83 c4 10             	add    $0x10,%esp
  80168e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801691:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801695:	79 14                	jns    8016ab <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801697:	83 ec 04             	sub    $0x4,%esp
  80169a:	68 e8 48 80 00       	push   $0x8048e8
  80169f:	6a 1f                	push   $0x1f
  8016a1:	68 24 49 80 00       	push   $0x804924
  8016a6:	e8 b7 ed ff ff       	call   800462 <_panic>
	return 0;
  8016ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016b0:	c9                   	leave  
  8016b1:	c3                   	ret    

008016b2 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8016b2:	55                   	push   %ebp
  8016b3:	89 e5                	mov    %esp,%ebp
  8016b5:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8016b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016c6:	83 ec 0c             	sub    $0xc,%esp
  8016c9:	50                   	push   %eax
  8016ca:	e8 96 18 00 00       	call   802f65 <__sys_unmap_frame>
  8016cf:	83 c4 10             	add    $0x10,%esp
  8016d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8016d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016d9:	79 14                	jns    8016ef <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8016db:	83 ec 04             	sub    $0x4,%esp
  8016de:	68 30 49 80 00       	push   $0x804930
  8016e3:	6a 2a                	push   $0x2a
  8016e5:	68 24 49 80 00       	push   $0x804924
  8016ea:	e8 73 ed ff ff       	call   800462 <_panic>
}
  8016ef:	90                   	nop
  8016f0:	c9                   	leave  
  8016f1:	c3                   	ret    

008016f2 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8016f2:	55                   	push   %ebp
  8016f3:	89 e5                	mov    %esp,%ebp
  8016f5:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8016f8:	e8 18 ff ff ff       	call   801615 <uheap_init>
	if (size == 0) return NULL ;
  8016fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801701:	75 0a                	jne    80170d <malloc+0x1b>
  801703:	b8 00 00 00 00       	mov    $0x0,%eax
  801708:	e9 43 03 00 00       	jmp    801a50 <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  80170d:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801714:	77 13                	ja     801729 <malloc+0x37>
    {
        return alloc_block(size);
  801716:	83 ec 0c             	sub    $0xc,%esp
  801719:	ff 75 08             	pushl  0x8(%ebp)
  80171c:	e8 78 20 00 00       	call   803799 <alloc_block>
  801721:	83 c4 10             	add    $0x10,%esp
  801724:	e9 27 03 00 00       	jmp    801a50 <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801729:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801730:	8b 55 08             	mov    0x8(%ebp),%edx
  801733:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801736:	01 d0                	add    %edx,%eax
  801738:	48                   	dec    %eax
  801739:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80173c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80173f:	ba 00 00 00 00       	mov    $0x0,%edx
  801744:	f7 75 dc             	divl   -0x24(%ebp)
  801747:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80174a:	29 d0                	sub    %edx,%eax
  80174c:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  80174f:	a1 40 d0 81 00       	mov    0x81d040,%eax
  801754:	85 c0                	test   %eax,%eax
  801756:	75 0a                	jne    801762 <malloc+0x70>
    {
        uhp_inited = 1;
  801758:	c7 05 40 d0 81 00 01 	movl   $0x1,0x81d040
  80175f:	00 00 00 
    }

    int exactIdx = -1;
  801762:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801769:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801770:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801777:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80177e:	e9 85 00 00 00       	jmp    801808 <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801783:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801786:	89 d0                	mov    %edx,%eax
  801788:	01 c0                	add    %eax,%eax
  80178a:	01 d0                	add    %edx,%eax
  80178c:	c1 e0 02             	shl    $0x2,%eax
  80178f:	05 48 10 81 00       	add    $0x811048,%eax
  801794:	8a 00                	mov    (%eax),%al
  801796:	84 c0                	test   %al,%al
  801798:	74 20                	je     8017ba <malloc+0xc8>
  80179a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80179d:	89 d0                	mov    %edx,%eax
  80179f:	01 c0                	add    %eax,%eax
  8017a1:	01 d0                	add    %edx,%eax
  8017a3:	c1 e0 02             	shl    $0x2,%eax
  8017a6:	05 44 10 81 00       	add    $0x811044,%eax
  8017ab:	8b 00                	mov    (%eax),%eax
  8017ad:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8017b0:	75 08                	jne    8017ba <malloc+0xc8>
        {
            exactIdx = i;
  8017b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  8017b8:	eb 5b                	jmp    801815 <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  8017ba:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017bd:	89 d0                	mov    %edx,%eax
  8017bf:	01 c0                	add    %eax,%eax
  8017c1:	01 d0                	add    %edx,%eax
  8017c3:	c1 e0 02             	shl    $0x2,%eax
  8017c6:	05 48 10 81 00       	add    $0x811048,%eax
  8017cb:	8a 00                	mov    (%eax),%al
  8017cd:	84 c0                	test   %al,%al
  8017cf:	74 34                	je     801805 <malloc+0x113>
  8017d1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017d4:	89 d0                	mov    %edx,%eax
  8017d6:	01 c0                	add    %eax,%eax
  8017d8:	01 d0                	add    %edx,%eax
  8017da:	c1 e0 02             	shl    $0x2,%eax
  8017dd:	05 44 10 81 00       	add    $0x811044,%eax
  8017e2:	8b 00                	mov    (%eax),%eax
  8017e4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8017e7:	76 1c                	jbe    801805 <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  8017e9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017ec:	89 d0                	mov    %edx,%eax
  8017ee:	01 c0                	add    %eax,%eax
  8017f0:	01 d0                	add    %edx,%eax
  8017f2:	c1 e0 02             	shl    $0x2,%eax
  8017f5:	05 44 10 81 00       	add    $0x811044,%eax
  8017fa:	8b 00                	mov    (%eax),%eax
  8017fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  8017ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801802:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801805:	ff 45 e8             	incl   -0x18(%ebp)
  801808:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  80180f:	0f 8e 6e ff ff ff    	jle    801783 <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  801815:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  80181c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801820:	74 7d                	je     80189f <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801822:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801829:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80182c:	89 d0                	mov    %edx,%eax
  80182e:	01 c0                	add    %eax,%eax
  801830:	01 d0                	add    %edx,%eax
  801832:	c1 e0 02             	shl    $0x2,%eax
  801835:	05 40 10 81 00       	add    $0x811040,%eax
  80183a:	8b 10                	mov    (%eax),%edx
  80183c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80183f:	01 d0                	add    %edx,%eax
  801841:	48                   	dec    %eax
  801842:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801845:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801848:	ba 00 00 00 00       	mov    $0x0,%edx
  80184d:	f7 75 bc             	divl   -0x44(%ebp)
  801850:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801853:	29 d0                	sub    %edx,%eax
  801855:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801858:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80185b:	89 d0                	mov    %edx,%eax
  80185d:	01 c0                	add    %eax,%eax
  80185f:	01 d0                	add    %edx,%eax
  801861:	c1 e0 02             	shl    $0x2,%eax
  801864:	05 48 10 81 00       	add    $0x811048,%eax
  801869:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  80186c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80186f:	89 d0                	mov    %edx,%eax
  801871:	01 c0                	add    %eax,%eax
  801873:	01 d0                	add    %edx,%eax
  801875:	c1 e0 02             	shl    $0x2,%eax
  801878:	05 44 10 81 00       	add    $0x811044,%eax
  80187d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801883:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801886:	89 d0                	mov    %edx,%eax
  801888:	01 c0                	add    %eax,%eax
  80188a:	01 d0                	add    %edx,%eax
  80188c:	c1 e0 02             	shl    $0x2,%eax
  80188f:	05 40 10 81 00       	add    $0x811040,%eax
  801894:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80189a:	e9 2d 01 00 00       	jmp    8019cc <malloc+0x2da>
    }
    else if (worstIdx != -1)
  80189f:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8018a3:	0f 84 ce 00 00 00    	je     801977 <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  8018a9:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8018b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018b3:	89 d0                	mov    %edx,%eax
  8018b5:	01 c0                	add    %eax,%eax
  8018b7:	01 d0                	add    %edx,%eax
  8018b9:	c1 e0 02             	shl    $0x2,%eax
  8018bc:	05 40 10 81 00       	add    $0x811040,%eax
  8018c1:	8b 10                	mov    (%eax),%edx
  8018c3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8018c6:	01 d0                	add    %edx,%eax
  8018c8:	48                   	dec    %eax
  8018c9:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8018cc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8018cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d4:	f7 75 c4             	divl   -0x3c(%ebp)
  8018d7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8018da:	29 d0                	sub    %edx,%eax
  8018dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  8018df:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018e2:	89 d0                	mov    %edx,%eax
  8018e4:	01 c0                	add    %eax,%eax
  8018e6:	01 d0                	add    %edx,%eax
  8018e8:	c1 e0 02             	shl    $0x2,%eax
  8018eb:	05 44 10 81 00       	add    $0x811044,%eax
  8018f0:	8b 00                	mov    (%eax),%eax
  8018f2:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8018f5:	75 47                	jne    80193e <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  8018f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018fa:	89 d0                	mov    %edx,%eax
  8018fc:	01 c0                	add    %eax,%eax
  8018fe:	01 d0                	add    %edx,%eax
  801900:	c1 e0 02             	shl    $0x2,%eax
  801903:	05 48 10 81 00       	add    $0x811048,%eax
  801908:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  80190b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80190e:	89 d0                	mov    %edx,%eax
  801910:	01 c0                	add    %eax,%eax
  801912:	01 d0                	add    %edx,%eax
  801914:	c1 e0 02             	shl    $0x2,%eax
  801917:	05 44 10 81 00       	add    $0x811044,%eax
  80191c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  801922:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801925:	89 d0                	mov    %edx,%eax
  801927:	01 c0                	add    %eax,%eax
  801929:	01 d0                	add    %edx,%eax
  80192b:	c1 e0 02             	shl    $0x2,%eax
  80192e:	05 40 10 81 00       	add    $0x811040,%eax
  801933:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801939:	e9 8e 00 00 00       	jmp    8019cc <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  80193e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801941:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801944:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801947:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80194a:	89 d0                	mov    %edx,%eax
  80194c:	01 c0                	add    %eax,%eax
  80194e:	01 d0                	add    %edx,%eax
  801950:	c1 e0 02             	shl    $0x2,%eax
  801953:	05 40 10 81 00       	add    $0x811040,%eax
  801958:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  80195a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80195d:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801960:	89 c2                	mov    %eax,%edx
  801962:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801965:	89 c8                	mov    %ecx,%eax
  801967:	01 c0                	add    %eax,%eax
  801969:	01 c8                	add    %ecx,%eax
  80196b:	c1 e0 02             	shl    $0x2,%eax
  80196e:	05 44 10 81 00       	add    $0x811044,%eax
  801973:	89 10                	mov    %edx,(%eax)
  801975:	eb 55                	jmp    8019cc <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  801977:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  80197e:	8b 15 88 50 83 00    	mov    0x835088,%edx
  801984:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801987:	01 d0                	add    %edx,%eax
  801989:	48                   	dec    %eax
  80198a:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80198d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801990:	ba 00 00 00 00       	mov    $0x0,%edx
  801995:	f7 75 d0             	divl   -0x30(%ebp)
  801998:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80199b:	29 d0                	sub    %edx,%eax
  80199d:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  8019a0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8019a3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019a6:	01 d0                	add    %edx,%eax
  8019a8:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8019ad:	76 0a                	jbe    8019b9 <malloc+0x2c7>
            return NULL;
  8019af:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b4:	e9 97 00 00 00       	jmp    801a50 <malloc+0x35e>
        va = start;
  8019b9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8019bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  8019bf:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8019c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019c5:	01 d0                	add    %edx,%eax
  8019c7:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8019cc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8019d3:	eb 5e                	jmp    801a33 <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  8019d5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019d8:	89 d0                	mov    %edx,%eax
  8019da:	01 c0                	add    %eax,%eax
  8019dc:	01 d0                	add    %edx,%eax
  8019de:	c1 e0 02             	shl    $0x2,%eax
  8019e1:	05 48 50 80 00       	add    $0x805048,%eax
  8019e6:	8a 00                	mov    (%eax),%al
  8019e8:	84 c0                	test   %al,%al
  8019ea:	75 44                	jne    801a30 <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  8019ec:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019ef:	89 d0                	mov    %edx,%eax
  8019f1:	01 c0                	add    %eax,%eax
  8019f3:	01 d0                	add    %edx,%eax
  8019f5:	c1 e0 02             	shl    $0x2,%eax
  8019f8:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  8019fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a01:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  801a03:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a06:	89 d0                	mov    %edx,%eax
  801a08:	01 c0                	add    %eax,%eax
  801a0a:	01 d0                	add    %edx,%eax
  801a0c:	c1 e0 02             	shl    $0x2,%eax
  801a0f:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  801a15:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a18:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  801a1a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a1d:	89 d0                	mov    %edx,%eax
  801a1f:	01 c0                	add    %eax,%eax
  801a21:	01 d0                	add    %edx,%eax
  801a23:	c1 e0 02             	shl    $0x2,%eax
  801a26:	05 48 50 80 00       	add    $0x805048,%eax
  801a2b:	c6 00 01             	movb   $0x1,(%eax)
            break;
  801a2e:	eb 0c                	jmp    801a3c <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801a30:	ff 45 e0             	incl   -0x20(%ebp)
  801a33:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801a3a:	7e 99                	jle    8019d5 <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  801a3c:	83 ec 08             	sub    $0x8,%esp
  801a3f:	ff 75 d4             	pushl  -0x2c(%ebp)
  801a42:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a45:	e8 a2 19 00 00       	call   8033ec <sys_allocate_user_mem>
  801a4a:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  801a4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801a50:	c9                   	leave  
  801a51:	c3                   	ret    

00801a52 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
  801a55:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  801a58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a5c:	0f 84 fa 03 00 00    	je     801e5c <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  801a62:	8b 45 08             	mov    0x8(%ebp),%eax
  801a65:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  801a68:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a6b:	85 c0                	test   %eax,%eax
  801a6d:	79 1c                	jns    801a8b <free+0x39>
  801a6f:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  801a76:	77 13                	ja     801a8b <free+0x39>
    {
        free_block(virtual_address);
  801a78:	83 ec 0c             	sub    $0xc,%esp
  801a7b:	ff 75 08             	pushl  0x8(%ebp)
  801a7e:	e8 09 21 00 00       	call   803b8c <free_block>
  801a83:	83 c4 10             	add    $0x10,%esp
        return;
  801a86:	e9 d2 03 00 00       	jmp    801e5d <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  801a8b:	a1 30 51 83 00       	mov    0x835130,%eax
  801a90:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  801a93:	72 09                	jb     801a9e <free+0x4c>
  801a95:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  801a9c:	76 17                	jbe    801ab5 <free+0x63>
        panic("free: invalid address");
  801a9e:	83 ec 04             	sub    $0x4,%esp
  801aa1:	68 6d 49 80 00       	push   $0x80496d
  801aa6:	68 9b 00 00 00       	push   $0x9b
  801aab:	68 24 49 80 00       	push   $0x804924
  801ab0:	e8 ad e9 ff ff       	call   800462 <_panic>

    uint32 size = 0;
  801ab5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  801abc:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801ac3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801aca:	eb 50                	jmp    801b1c <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  801acc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801acf:	89 d0                	mov    %edx,%eax
  801ad1:	01 c0                	add    %eax,%eax
  801ad3:	01 d0                	add    %edx,%eax
  801ad5:	c1 e0 02             	shl    $0x2,%eax
  801ad8:	05 48 50 80 00       	add    $0x805048,%eax
  801add:	8a 00                	mov    (%eax),%al
  801adf:	84 c0                	test   %al,%al
  801ae1:	74 36                	je     801b19 <free+0xc7>
  801ae3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ae6:	89 d0                	mov    %edx,%eax
  801ae8:	01 c0                	add    %eax,%eax
  801aea:	01 d0                	add    %edx,%eax
  801aec:	c1 e0 02             	shl    $0x2,%eax
  801aef:	05 40 50 80 00       	add    $0x805040,%eax
  801af4:	8b 00                	mov    (%eax),%eax
  801af6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801af9:	75 1e                	jne    801b19 <free+0xc7>
        {
            size = uhp_allocs[i].size;
  801afb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801afe:	89 d0                	mov    %edx,%eax
  801b00:	01 c0                	add    %eax,%eax
  801b02:	01 d0                	add    %edx,%eax
  801b04:	c1 e0 02             	shl    $0x2,%eax
  801b07:	05 44 50 80 00       	add    $0x805044,%eax
  801b0c:	8b 00                	mov    (%eax),%eax
  801b0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  801b11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b14:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  801b17:	eb 0c                	jmp    801b25 <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801b19:	ff 45 ec             	incl   -0x14(%ebp)
  801b1c:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  801b23:	7e a7                	jle    801acc <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  801b25:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801b29:	74 06                	je     801b31 <free+0xdf>
  801b2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b2f:	75 17                	jne    801b48 <free+0xf6>
        panic("free: unknown block");
  801b31:	83 ec 04             	sub    $0x4,%esp
  801b34:	68 83 49 80 00       	push   $0x804983
  801b39:	68 a9 00 00 00       	push   $0xa9
  801b3e:	68 24 49 80 00       	push   $0x804924
  801b43:	e8 1a e9 ff ff       	call   800462 <_panic>

    uhp_allocs[idx].used = 0;
  801b48:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b4b:	89 d0                	mov    %edx,%eax
  801b4d:	01 c0                	add    %eax,%eax
  801b4f:	01 d0                	add    %edx,%eax
  801b51:	c1 e0 02             	shl    $0x2,%eax
  801b54:	05 48 50 80 00       	add    $0x805048,%eax
  801b59:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  801b5c:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801b63:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801b6a:	eb 64                	jmp    801bd0 <free+0x17e>
    {
        if (!uhp_frees[i].free)
  801b6c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b6f:	89 d0                	mov    %edx,%eax
  801b71:	01 c0                	add    %eax,%eax
  801b73:	01 d0                	add    %edx,%eax
  801b75:	c1 e0 02             	shl    $0x2,%eax
  801b78:	05 48 10 81 00       	add    $0x811048,%eax
  801b7d:	8a 00                	mov    (%eax),%al
  801b7f:	84 c0                	test   %al,%al
  801b81:	75 4a                	jne    801bcd <free+0x17b>
        {
            uhp_frees[i].va = va;
  801b83:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b86:	89 d0                	mov    %edx,%eax
  801b88:	01 c0                	add    %eax,%eax
  801b8a:	01 d0                	add    %edx,%eax
  801b8c:	c1 e0 02             	shl    $0x2,%eax
  801b8f:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  801b95:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b98:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  801b9a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b9d:	89 d0                	mov    %edx,%eax
  801b9f:	01 c0                	add    %eax,%eax
  801ba1:	01 d0                	add    %edx,%eax
  801ba3:	c1 e0 02             	shl    $0x2,%eax
  801ba6:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  801bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801baf:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  801bb1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801bb4:	89 d0                	mov    %edx,%eax
  801bb6:	01 c0                	add    %eax,%eax
  801bb8:	01 d0                	add    %edx,%eax
  801bba:	c1 e0 02             	shl    $0x2,%eax
  801bbd:	05 48 10 81 00       	add    $0x811048,%eax
  801bc2:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  801bc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bc8:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  801bcb:	eb 0c                	jmp    801bd9 <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801bcd:	ff 45 e4             	incl   -0x1c(%ebp)
  801bd0:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  801bd7:	7e 93                	jle    801b6c <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  801bd9:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  801bdd:	0f 84 f1 01 00 00    	je     801dd4 <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801be3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801bea:	e9 d8 01 00 00       	jmp    801dc7 <free+0x375>
        {
            if (i == fidx) continue;
  801bef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bf2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801bf5:	0f 84 c8 01 00 00    	je     801dc3 <free+0x371>
            if (uhp_frees[i].free)
  801bfb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bfe:	89 d0                	mov    %edx,%eax
  801c00:	01 c0                	add    %eax,%eax
  801c02:	01 d0                	add    %edx,%eax
  801c04:	c1 e0 02             	shl    $0x2,%eax
  801c07:	05 48 10 81 00       	add    $0x811048,%eax
  801c0c:	8a 00                	mov    (%eax),%al
  801c0e:	84 c0                	test   %al,%al
  801c10:	0f 84 ae 01 00 00    	je     801dc4 <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  801c16:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c19:	89 d0                	mov    %edx,%eax
  801c1b:	01 c0                	add    %eax,%eax
  801c1d:	01 d0                	add    %edx,%eax
  801c1f:	c1 e0 02             	shl    $0x2,%eax
  801c22:	05 40 10 81 00       	add    $0x811040,%eax
  801c27:	8b 08                	mov    (%eax),%ecx
  801c29:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c2c:	89 d0                	mov    %edx,%eax
  801c2e:	01 c0                	add    %eax,%eax
  801c30:	01 d0                	add    %edx,%eax
  801c32:	c1 e0 02             	shl    $0x2,%eax
  801c35:	05 44 10 81 00       	add    $0x811044,%eax
  801c3a:	8b 00                	mov    (%eax),%eax
  801c3c:	01 c1                	add    %eax,%ecx
  801c3e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c41:	89 d0                	mov    %edx,%eax
  801c43:	01 c0                	add    %eax,%eax
  801c45:	01 d0                	add    %edx,%eax
  801c47:	c1 e0 02             	shl    $0x2,%eax
  801c4a:	05 40 10 81 00       	add    $0x811040,%eax
  801c4f:	8b 00                	mov    (%eax),%eax
  801c51:	39 c1                	cmp    %eax,%ecx
  801c53:	0f 85 a8 00 00 00    	jne    801d01 <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  801c59:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c5c:	89 d0                	mov    %edx,%eax
  801c5e:	01 c0                	add    %eax,%eax
  801c60:	01 d0                	add    %edx,%eax
  801c62:	c1 e0 02             	shl    $0x2,%eax
  801c65:	05 40 10 81 00       	add    $0x811040,%eax
  801c6a:	8b 10                	mov    (%eax),%edx
  801c6c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  801c6f:	89 c8                	mov    %ecx,%eax
  801c71:	01 c0                	add    %eax,%eax
  801c73:	01 c8                	add    %ecx,%eax
  801c75:	c1 e0 02             	shl    $0x2,%eax
  801c78:	05 40 10 81 00       	add    $0x811040,%eax
  801c7d:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801c7f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c82:	89 d0                	mov    %edx,%eax
  801c84:	01 c0                	add    %eax,%eax
  801c86:	01 d0                	add    %edx,%eax
  801c88:	c1 e0 02             	shl    $0x2,%eax
  801c8b:	05 44 10 81 00       	add    $0x811044,%eax
  801c90:	8b 08                	mov    (%eax),%ecx
  801c92:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c95:	89 d0                	mov    %edx,%eax
  801c97:	01 c0                	add    %eax,%eax
  801c99:	01 d0                	add    %edx,%eax
  801c9b:	c1 e0 02             	shl    $0x2,%eax
  801c9e:	05 44 10 81 00       	add    $0x811044,%eax
  801ca3:	8b 00                	mov    (%eax),%eax
  801ca5:	01 c1                	add    %eax,%ecx
  801ca7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801caa:	89 d0                	mov    %edx,%eax
  801cac:	01 c0                	add    %eax,%eax
  801cae:	01 d0                	add    %edx,%eax
  801cb0:	c1 e0 02             	shl    $0x2,%eax
  801cb3:	05 44 10 81 00       	add    $0x811044,%eax
  801cb8:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801cba:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801cbd:	89 d0                	mov    %edx,%eax
  801cbf:	01 c0                	add    %eax,%eax
  801cc1:	01 d0                	add    %edx,%eax
  801cc3:	c1 e0 02             	shl    $0x2,%eax
  801cc6:	05 48 10 81 00       	add    $0x811048,%eax
  801ccb:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801cce:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801cd1:	89 d0                	mov    %edx,%eax
  801cd3:	01 c0                	add    %eax,%eax
  801cd5:	01 d0                	add    %edx,%eax
  801cd7:	c1 e0 02             	shl    $0x2,%eax
  801cda:	05 40 10 81 00       	add    $0x811040,%eax
  801cdf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801ce5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ce8:	89 d0                	mov    %edx,%eax
  801cea:	01 c0                	add    %eax,%eax
  801cec:	01 d0                	add    %edx,%eax
  801cee:	c1 e0 02             	shl    $0x2,%eax
  801cf1:	05 44 10 81 00       	add    $0x811044,%eax
  801cf6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801cfc:	e9 c3 00 00 00       	jmp    801dc4 <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  801d01:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d04:	89 d0                	mov    %edx,%eax
  801d06:	01 c0                	add    %eax,%eax
  801d08:	01 d0                	add    %edx,%eax
  801d0a:	c1 e0 02             	shl    $0x2,%eax
  801d0d:	05 40 10 81 00       	add    $0x811040,%eax
  801d12:	8b 08                	mov    (%eax),%ecx
  801d14:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d17:	89 d0                	mov    %edx,%eax
  801d19:	01 c0                	add    %eax,%eax
  801d1b:	01 d0                	add    %edx,%eax
  801d1d:	c1 e0 02             	shl    $0x2,%eax
  801d20:	05 44 10 81 00       	add    $0x811044,%eax
  801d25:	8b 00                	mov    (%eax),%eax
  801d27:	01 c1                	add    %eax,%ecx
  801d29:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d2c:	89 d0                	mov    %edx,%eax
  801d2e:	01 c0                	add    %eax,%eax
  801d30:	01 d0                	add    %edx,%eax
  801d32:	c1 e0 02             	shl    $0x2,%eax
  801d35:	05 40 10 81 00       	add    $0x811040,%eax
  801d3a:	8b 00                	mov    (%eax),%eax
  801d3c:	39 c1                	cmp    %eax,%ecx
  801d3e:	0f 85 80 00 00 00    	jne    801dc4 <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801d44:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d47:	89 d0                	mov    %edx,%eax
  801d49:	01 c0                	add    %eax,%eax
  801d4b:	01 d0                	add    %edx,%eax
  801d4d:	c1 e0 02             	shl    $0x2,%eax
  801d50:	05 44 10 81 00       	add    $0x811044,%eax
  801d55:	8b 08                	mov    (%eax),%ecx
  801d57:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d5a:	89 d0                	mov    %edx,%eax
  801d5c:	01 c0                	add    %eax,%eax
  801d5e:	01 d0                	add    %edx,%eax
  801d60:	c1 e0 02             	shl    $0x2,%eax
  801d63:	05 44 10 81 00       	add    $0x811044,%eax
  801d68:	8b 00                	mov    (%eax),%eax
  801d6a:	01 c1                	add    %eax,%ecx
  801d6c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d6f:	89 d0                	mov    %edx,%eax
  801d71:	01 c0                	add    %eax,%eax
  801d73:	01 d0                	add    %edx,%eax
  801d75:	c1 e0 02             	shl    $0x2,%eax
  801d78:	05 44 10 81 00       	add    $0x811044,%eax
  801d7d:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801d7f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d82:	89 d0                	mov    %edx,%eax
  801d84:	01 c0                	add    %eax,%eax
  801d86:	01 d0                	add    %edx,%eax
  801d88:	c1 e0 02             	shl    $0x2,%eax
  801d8b:	05 48 10 81 00       	add    $0x811048,%eax
  801d90:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801d93:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d96:	89 d0                	mov    %edx,%eax
  801d98:	01 c0                	add    %eax,%eax
  801d9a:	01 d0                	add    %edx,%eax
  801d9c:	c1 e0 02             	shl    $0x2,%eax
  801d9f:	05 40 10 81 00       	add    $0x811040,%eax
  801da4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801daa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801dad:	89 d0                	mov    %edx,%eax
  801daf:	01 c0                	add    %eax,%eax
  801db1:	01 d0                	add    %edx,%eax
  801db3:	c1 e0 02             	shl    $0x2,%eax
  801db6:	05 44 10 81 00       	add    $0x811044,%eax
  801dbb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801dc1:	eb 01                	jmp    801dc4 <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  801dc3:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801dc4:	ff 45 e0             	incl   -0x20(%ebp)
  801dc7:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801dce:	0f 8e 1b fe ff ff    	jle    801bef <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  801dd4:	a1 30 51 83 00       	mov    0x835130,%eax
  801dd9:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801ddc:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801de3:	eb 53                	jmp    801e38 <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  801de5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801de8:	89 d0                	mov    %edx,%eax
  801dea:	01 c0                	add    %eax,%eax
  801dec:	01 d0                	add    %edx,%eax
  801dee:	c1 e0 02             	shl    $0x2,%eax
  801df1:	05 48 50 80 00       	add    $0x805048,%eax
  801df6:	8a 00                	mov    (%eax),%al
  801df8:	84 c0                	test   %al,%al
  801dfa:	74 39                	je     801e35 <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  801dfc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801dff:	89 d0                	mov    %edx,%eax
  801e01:	01 c0                	add    %eax,%eax
  801e03:	01 d0                	add    %edx,%eax
  801e05:	c1 e0 02             	shl    $0x2,%eax
  801e08:	05 40 50 80 00       	add    $0x805040,%eax
  801e0d:	8b 08                	mov    (%eax),%ecx
  801e0f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e12:	89 d0                	mov    %edx,%eax
  801e14:	01 c0                	add    %eax,%eax
  801e16:	01 d0                	add    %edx,%eax
  801e18:	c1 e0 02             	shl    $0x2,%eax
  801e1b:	05 44 50 80 00       	add    $0x805044,%eax
  801e20:	8b 00                	mov    (%eax),%eax
  801e22:	01 c8                	add    %ecx,%eax
  801e24:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  801e27:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e2a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801e2d:	76 06                	jbe    801e35 <free+0x3e3>
  801e2f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e32:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801e35:	ff 45 d8             	incl   -0x28(%ebp)
  801e38:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  801e3f:	7e a4                	jle    801de5 <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  801e41:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e44:	a3 88 50 83 00       	mov    %eax,0x835088

    sys_free_user_mem(va, size);
  801e49:	83 ec 08             	sub    $0x8,%esp
  801e4c:	ff 75 f4             	pushl  -0xc(%ebp)
  801e4f:	ff 75 d4             	pushl  -0x2c(%ebp)
  801e52:	e8 79 15 00 00       	call   8033d0 <sys_free_user_mem>
  801e57:	83 c4 10             	add    $0x10,%esp
  801e5a:	eb 01                	jmp    801e5d <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  801e5c:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  801e5d:	c9                   	leave  
  801e5e:	c3                   	ret    

00801e5f <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801e5f:	55                   	push   %ebp
  801e60:	89 e5                	mov    %esp,%ebp
  801e62:	83 ec 68             	sub    $0x68,%esp
  801e65:	8b 45 10             	mov    0x10(%ebp),%eax
  801e68:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801e6b:	e8 a5 f7 ff ff       	call   801615 <uheap_init>
	if (size == 0) return NULL ;
  801e70:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e74:	75 0a                	jne    801e80 <smalloc+0x21>
  801e76:	b8 00 00 00 00       	mov    $0x0,%eax
  801e7b:	e9 37 03 00 00       	jmp    8021b7 <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801e80:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801e87:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e8a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e8d:	01 d0                	add    %edx,%eax
  801e8f:	48                   	dec    %eax
  801e90:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801e93:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e96:	ba 00 00 00 00       	mov    $0x0,%edx
  801e9b:	f7 75 dc             	divl   -0x24(%ebp)
  801e9e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ea1:	29 d0                	sub    %edx,%eax
  801ea3:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  801ea6:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801ead:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801eb4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801ebb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801ec2:	e9 85 00 00 00       	jmp    801f4c <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801ec7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801eca:	89 d0                	mov    %edx,%eax
  801ecc:	01 c0                	add    %eax,%eax
  801ece:	01 d0                	add    %edx,%eax
  801ed0:	c1 e0 02             	shl    $0x2,%eax
  801ed3:	05 48 10 81 00       	add    $0x811048,%eax
  801ed8:	8a 00                	mov    (%eax),%al
  801eda:	84 c0                	test   %al,%al
  801edc:	74 20                	je     801efe <smalloc+0x9f>
  801ede:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ee1:	89 d0                	mov    %edx,%eax
  801ee3:	01 c0                	add    %eax,%eax
  801ee5:	01 d0                	add    %edx,%eax
  801ee7:	c1 e0 02             	shl    $0x2,%eax
  801eea:	05 44 10 81 00       	add    $0x811044,%eax
  801eef:	8b 00                	mov    (%eax),%eax
  801ef1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801ef4:	75 08                	jne    801efe <smalloc+0x9f>
        {
            exactIdx = i;
  801ef6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ef9:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801efc:	eb 5b                	jmp    801f59 <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801efe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f01:	89 d0                	mov    %edx,%eax
  801f03:	01 c0                	add    %eax,%eax
  801f05:	01 d0                	add    %edx,%eax
  801f07:	c1 e0 02             	shl    $0x2,%eax
  801f0a:	05 48 10 81 00       	add    $0x811048,%eax
  801f0f:	8a 00                	mov    (%eax),%al
  801f11:	84 c0                	test   %al,%al
  801f13:	74 34                	je     801f49 <smalloc+0xea>
  801f15:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f18:	89 d0                	mov    %edx,%eax
  801f1a:	01 c0                	add    %eax,%eax
  801f1c:	01 d0                	add    %edx,%eax
  801f1e:	c1 e0 02             	shl    $0x2,%eax
  801f21:	05 44 10 81 00       	add    $0x811044,%eax
  801f26:	8b 00                	mov    (%eax),%eax
  801f28:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801f2b:	76 1c                	jbe    801f49 <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  801f2d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f30:	89 d0                	mov    %edx,%eax
  801f32:	01 c0                	add    %eax,%eax
  801f34:	01 d0                	add    %edx,%eax
  801f36:	c1 e0 02             	shl    $0x2,%eax
  801f39:	05 44 10 81 00       	add    $0x811044,%eax
  801f3e:	8b 00                	mov    (%eax),%eax
  801f40:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801f43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f46:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801f49:	ff 45 e8             	incl   -0x18(%ebp)
  801f4c:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801f53:	0f 8e 6e ff ff ff    	jle    801ec7 <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  801f59:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801f60:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801f64:	74 7d                	je     801fe3 <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801f66:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801f6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f70:	89 d0                	mov    %edx,%eax
  801f72:	01 c0                	add    %eax,%eax
  801f74:	01 d0                	add    %edx,%eax
  801f76:	c1 e0 02             	shl    $0x2,%eax
  801f79:	05 40 10 81 00       	add    $0x811040,%eax
  801f7e:	8b 10                	mov    (%eax),%edx
  801f80:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801f83:	01 d0                	add    %edx,%eax
  801f85:	48                   	dec    %eax
  801f86:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801f89:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801f8c:	ba 00 00 00 00       	mov    $0x0,%edx
  801f91:	f7 75 bc             	divl   -0x44(%ebp)
  801f94:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801f97:	29 d0                	sub    %edx,%eax
  801f99:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801f9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f9f:	89 d0                	mov    %edx,%eax
  801fa1:	01 c0                	add    %eax,%eax
  801fa3:	01 d0                	add    %edx,%eax
  801fa5:	c1 e0 02             	shl    $0x2,%eax
  801fa8:	05 48 10 81 00       	add    $0x811048,%eax
  801fad:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801fb0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fb3:	89 d0                	mov    %edx,%eax
  801fb5:	01 c0                	add    %eax,%eax
  801fb7:	01 d0                	add    %edx,%eax
  801fb9:	c1 e0 02             	shl    $0x2,%eax
  801fbc:	05 44 10 81 00       	add    $0x811044,%eax
  801fc1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801fc7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fca:	89 d0                	mov    %edx,%eax
  801fcc:	01 c0                	add    %eax,%eax
  801fce:	01 d0                	add    %edx,%eax
  801fd0:	c1 e0 02             	shl    $0x2,%eax
  801fd3:	05 40 10 81 00       	add    $0x811040,%eax
  801fd8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fde:	e9 2d 01 00 00       	jmp    802110 <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  801fe3:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801fe7:	0f 84 ce 00 00 00    	je     8020bb <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  801fed:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  801ff4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ff7:	89 d0                	mov    %edx,%eax
  801ff9:	01 c0                	add    %eax,%eax
  801ffb:	01 d0                	add    %edx,%eax
  801ffd:	c1 e0 02             	shl    $0x2,%eax
  802000:	05 40 10 81 00       	add    $0x811040,%eax
  802005:	8b 10                	mov    (%eax),%edx
  802007:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80200a:	01 d0                	add    %edx,%eax
  80200c:	48                   	dec    %eax
  80200d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802010:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802013:	ba 00 00 00 00       	mov    $0x0,%edx
  802018:	f7 75 c4             	divl   -0x3c(%ebp)
  80201b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80201e:	29 d0                	sub    %edx,%eax
  802020:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  802023:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802026:	89 d0                	mov    %edx,%eax
  802028:	01 c0                	add    %eax,%eax
  80202a:	01 d0                	add    %edx,%eax
  80202c:	c1 e0 02             	shl    $0x2,%eax
  80202f:	05 44 10 81 00       	add    $0x811044,%eax
  802034:	8b 00                	mov    (%eax),%eax
  802036:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802039:	75 47                	jne    802082 <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  80203b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80203e:	89 d0                	mov    %edx,%eax
  802040:	01 c0                	add    %eax,%eax
  802042:	01 d0                	add    %edx,%eax
  802044:	c1 e0 02             	shl    $0x2,%eax
  802047:	05 48 10 81 00       	add    $0x811048,%eax
  80204c:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  80204f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802052:	89 d0                	mov    %edx,%eax
  802054:	01 c0                	add    %eax,%eax
  802056:	01 d0                	add    %edx,%eax
  802058:	c1 e0 02             	shl    $0x2,%eax
  80205b:	05 44 10 81 00       	add    $0x811044,%eax
  802060:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  802066:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802069:	89 d0                	mov    %edx,%eax
  80206b:	01 c0                	add    %eax,%eax
  80206d:	01 d0                	add    %edx,%eax
  80206f:	c1 e0 02             	shl    $0x2,%eax
  802072:	05 40 10 81 00       	add    $0x811040,%eax
  802077:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80207d:	e9 8e 00 00 00       	jmp    802110 <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  802082:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802085:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802088:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80208b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80208e:	89 d0                	mov    %edx,%eax
  802090:	01 c0                	add    %eax,%eax
  802092:	01 d0                	add    %edx,%eax
  802094:	c1 e0 02             	shl    $0x2,%eax
  802097:	05 40 10 81 00       	add    $0x811040,%eax
  80209c:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  80209e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020a1:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8020a4:	89 c2                	mov    %eax,%edx
  8020a6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8020a9:	89 c8                	mov    %ecx,%eax
  8020ab:	01 c0                	add    %eax,%eax
  8020ad:	01 c8                	add    %ecx,%eax
  8020af:	c1 e0 02             	shl    $0x2,%eax
  8020b2:	05 44 10 81 00       	add    $0x811044,%eax
  8020b7:	89 10                	mov    %edx,(%eax)
  8020b9:	eb 55                	jmp    802110 <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  8020bb:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  8020c2:	8b 15 88 50 83 00    	mov    0x835088,%edx
  8020c8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8020cb:	01 d0                	add    %edx,%eax
  8020cd:	48                   	dec    %eax
  8020ce:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8020d1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8020d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8020d9:	f7 75 d0             	divl   -0x30(%ebp)
  8020dc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8020df:	29 d0                	sub    %edx,%eax
  8020e1:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  8020e4:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8020e7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020ea:	01 d0                	add    %edx,%eax
  8020ec:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8020f1:	76 0a                	jbe    8020fd <smalloc+0x29e>
            return NULL;
  8020f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f8:	e9 ba 00 00 00       	jmp    8021b7 <smalloc+0x358>
        va = start;
  8020fd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802100:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  802103:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802106:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802109:	01 d0                	add    %edx,%eax
  80210b:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802110:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802117:	eb 5e                	jmp    802177 <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  802119:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80211c:	89 d0                	mov    %edx,%eax
  80211e:	01 c0                	add    %eax,%eax
  802120:	01 d0                	add    %edx,%eax
  802122:	c1 e0 02             	shl    $0x2,%eax
  802125:	05 48 50 80 00       	add    $0x805048,%eax
  80212a:	8a 00                	mov    (%eax),%al
  80212c:	84 c0                	test   %al,%al
  80212e:	75 44                	jne    802174 <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  802130:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802133:	89 d0                	mov    %edx,%eax
  802135:	01 c0                	add    %eax,%eax
  802137:	01 d0                	add    %edx,%eax
  802139:	c1 e0 02             	shl    $0x2,%eax
  80213c:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  802142:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802145:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  802147:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80214a:	89 d0                	mov    %edx,%eax
  80214c:	01 c0                	add    %eax,%eax
  80214e:	01 d0                	add    %edx,%eax
  802150:	c1 e0 02             	shl    $0x2,%eax
  802153:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802159:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80215c:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  80215e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802161:	89 d0                	mov    %edx,%eax
  802163:	01 c0                	add    %eax,%eax
  802165:	01 d0                	add    %edx,%eax
  802167:	c1 e0 02             	shl    $0x2,%eax
  80216a:	05 48 50 80 00       	add    $0x805048,%eax
  80216f:	c6 00 01             	movb   $0x1,(%eax)
            break;
  802172:	eb 0c                	jmp    802180 <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802174:	ff 45 e0             	incl   -0x20(%ebp)
  802177:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80217e:	7e 99                	jle    802119 <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  802180:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802183:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  802187:	52                   	push   %edx
  802188:	50                   	push   %eax
  802189:	ff 75 d4             	pushl  -0x2c(%ebp)
  80218c:	ff 75 08             	pushl  0x8(%ebp)
  80218f:	e8 de 0e 00 00       	call   803072 <sys_create_shared_object>
  802194:	83 c4 10             	add    $0x10,%esp
  802197:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  80219a:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  80219e:	75 07                	jne    8021a7 <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  8021a0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8021a5:	eb 10                	jmp    8021b7 <smalloc+0x358>
    if (r < 0)
  8021a7:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  8021ab:	79 07                	jns    8021b4 <smalloc+0x355>
        return NULL;
  8021ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b2:	eb 03                	jmp    8021b7 <smalloc+0x358>
    return (void*)va;
  8021b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8021b7:	c9                   	leave  
  8021b8:	c3                   	ret    

008021b9 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8021b9:	55                   	push   %ebp
  8021ba:	89 e5                	mov    %esp,%ebp
  8021bc:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8021bf:	e8 51 f4 ff ff       	call   801615 <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  8021c4:	83 ec 08             	sub    $0x8,%esp
  8021c7:	ff 75 0c             	pushl  0xc(%ebp)
  8021ca:	ff 75 08             	pushl  0x8(%ebp)
  8021cd:	e8 ca 0e 00 00       	call   80309c <sys_size_of_shared_object>
  8021d2:	83 c4 10             	add    $0x10,%esp
  8021d5:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  8021d8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8021dc:	7f 0a                	jg     8021e8 <sget+0x2f>
        return NULL;
  8021de:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e3:	e9 28 03 00 00       	jmp    802510 <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  8021e8:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8021ef:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8021f2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8021f5:	01 d0                	add    %edx,%eax
  8021f7:	48                   	dec    %eax
  8021f8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8021fb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8021fe:	ba 00 00 00 00       	mov    $0x0,%edx
  802203:	f7 75 d8             	divl   -0x28(%ebp)
  802206:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802209:	29 d0                	sub    %edx,%eax
  80220b:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  80220e:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  802215:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  80221c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802223:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80222a:	e9 85 00 00 00       	jmp    8022b4 <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  80222f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802232:	89 d0                	mov    %edx,%eax
  802234:	01 c0                	add    %eax,%eax
  802236:	01 d0                	add    %edx,%eax
  802238:	c1 e0 02             	shl    $0x2,%eax
  80223b:	05 48 10 81 00       	add    $0x811048,%eax
  802240:	8a 00                	mov    (%eax),%al
  802242:	84 c0                	test   %al,%al
  802244:	74 20                	je     802266 <sget+0xad>
  802246:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802249:	89 d0                	mov    %edx,%eax
  80224b:	01 c0                	add    %eax,%eax
  80224d:	01 d0                	add    %edx,%eax
  80224f:	c1 e0 02             	shl    $0x2,%eax
  802252:	05 44 10 81 00       	add    $0x811044,%eax
  802257:	8b 00                	mov    (%eax),%eax
  802259:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80225c:	75 08                	jne    802266 <sget+0xad>
        {
            exactIdx = i;
  80225e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802261:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  802264:	eb 5b                	jmp    8022c1 <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  802266:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802269:	89 d0                	mov    %edx,%eax
  80226b:	01 c0                	add    %eax,%eax
  80226d:	01 d0                	add    %edx,%eax
  80226f:	c1 e0 02             	shl    $0x2,%eax
  802272:	05 48 10 81 00       	add    $0x811048,%eax
  802277:	8a 00                	mov    (%eax),%al
  802279:	84 c0                	test   %al,%al
  80227b:	74 34                	je     8022b1 <sget+0xf8>
  80227d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802280:	89 d0                	mov    %edx,%eax
  802282:	01 c0                	add    %eax,%eax
  802284:	01 d0                	add    %edx,%eax
  802286:	c1 e0 02             	shl    $0x2,%eax
  802289:	05 44 10 81 00       	add    $0x811044,%eax
  80228e:	8b 00                	mov    (%eax),%eax
  802290:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802293:	76 1c                	jbe    8022b1 <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  802295:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802298:	89 d0                	mov    %edx,%eax
  80229a:	01 c0                	add    %eax,%eax
  80229c:	01 d0                	add    %edx,%eax
  80229e:	c1 e0 02             	shl    $0x2,%eax
  8022a1:	05 44 10 81 00       	add    $0x811044,%eax
  8022a6:	8b 00                	mov    (%eax),%eax
  8022a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  8022ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8022b1:	ff 45 e8             	incl   -0x18(%ebp)
  8022b4:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8022bb:	0f 8e 6e ff ff ff    	jle    80222f <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  8022c1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  8022c8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8022cc:	74 7d                	je     80234b <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  8022ce:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8022d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022d8:	89 d0                	mov    %edx,%eax
  8022da:	01 c0                	add    %eax,%eax
  8022dc:	01 d0                	add    %edx,%eax
  8022de:	c1 e0 02             	shl    $0x2,%eax
  8022e1:	05 40 10 81 00       	add    $0x811040,%eax
  8022e6:	8b 10                	mov    (%eax),%edx
  8022e8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8022eb:	01 d0                	add    %edx,%eax
  8022ed:	48                   	dec    %eax
  8022ee:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8022f1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8022f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8022f9:	f7 75 b8             	divl   -0x48(%ebp)
  8022fc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8022ff:	29 d0                	sub    %edx,%eax
  802301:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  802304:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802307:	89 d0                	mov    %edx,%eax
  802309:	01 c0                	add    %eax,%eax
  80230b:	01 d0                	add    %edx,%eax
  80230d:	c1 e0 02             	shl    $0x2,%eax
  802310:	05 48 10 81 00       	add    $0x811048,%eax
  802315:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  802318:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80231b:	89 d0                	mov    %edx,%eax
  80231d:	01 c0                	add    %eax,%eax
  80231f:	01 d0                	add    %edx,%eax
  802321:	c1 e0 02             	shl    $0x2,%eax
  802324:	05 44 10 81 00       	add    $0x811044,%eax
  802329:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  80232f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802332:	89 d0                	mov    %edx,%eax
  802334:	01 c0                	add    %eax,%eax
  802336:	01 d0                	add    %edx,%eax
  802338:	c1 e0 02             	shl    $0x2,%eax
  80233b:	05 40 10 81 00       	add    $0x811040,%eax
  802340:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802346:	e9 2d 01 00 00       	jmp    802478 <sget+0x2bf>
    }
    else if (worstIdx != -1)
  80234b:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80234f:	0f 84 ce 00 00 00    	je     802423 <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  802355:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  80235c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80235f:	89 d0                	mov    %edx,%eax
  802361:	01 c0                	add    %eax,%eax
  802363:	01 d0                	add    %edx,%eax
  802365:	c1 e0 02             	shl    $0x2,%eax
  802368:	05 40 10 81 00       	add    $0x811040,%eax
  80236d:	8b 10                	mov    (%eax),%edx
  80236f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802372:	01 d0                	add    %edx,%eax
  802374:	48                   	dec    %eax
  802375:	89 45 bc             	mov    %eax,-0x44(%ebp)
  802378:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80237b:	ba 00 00 00 00       	mov    $0x0,%edx
  802380:	f7 75 c0             	divl   -0x40(%ebp)
  802383:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802386:	29 d0                	sub    %edx,%eax
  802388:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  80238b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80238e:	89 d0                	mov    %edx,%eax
  802390:	01 c0                	add    %eax,%eax
  802392:	01 d0                	add    %edx,%eax
  802394:	c1 e0 02             	shl    $0x2,%eax
  802397:	05 44 10 81 00       	add    $0x811044,%eax
  80239c:	8b 00                	mov    (%eax),%eax
  80239e:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8023a1:	75 47                	jne    8023ea <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  8023a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023a6:	89 d0                	mov    %edx,%eax
  8023a8:	01 c0                	add    %eax,%eax
  8023aa:	01 d0                	add    %edx,%eax
  8023ac:	c1 e0 02             	shl    $0x2,%eax
  8023af:	05 48 10 81 00       	add    $0x811048,%eax
  8023b4:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  8023b7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023ba:	89 d0                	mov    %edx,%eax
  8023bc:	01 c0                	add    %eax,%eax
  8023be:	01 d0                	add    %edx,%eax
  8023c0:	c1 e0 02             	shl    $0x2,%eax
  8023c3:	05 44 10 81 00       	add    $0x811044,%eax
  8023c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  8023ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023d1:	89 d0                	mov    %edx,%eax
  8023d3:	01 c0                	add    %eax,%eax
  8023d5:	01 d0                	add    %edx,%eax
  8023d7:	c1 e0 02             	shl    $0x2,%eax
  8023da:	05 40 10 81 00       	add    $0x811040,%eax
  8023df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023e5:	e9 8e 00 00 00       	jmp    802478 <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  8023ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8023ed:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8023f0:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8023f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023f6:	89 d0                	mov    %edx,%eax
  8023f8:	01 c0                	add    %eax,%eax
  8023fa:	01 d0                	add    %edx,%eax
  8023fc:	c1 e0 02             	shl    $0x2,%eax
  8023ff:	05 40 10 81 00       	add    $0x811040,%eax
  802404:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  802406:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802409:	2b 45 d0             	sub    -0x30(%ebp),%eax
  80240c:	89 c2                	mov    %eax,%edx
  80240e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802411:	89 c8                	mov    %ecx,%eax
  802413:	01 c0                	add    %eax,%eax
  802415:	01 c8                	add    %ecx,%eax
  802417:	c1 e0 02             	shl    $0x2,%eax
  80241a:	05 44 10 81 00       	add    $0x811044,%eax
  80241f:	89 10                	mov    %edx,(%eax)
  802421:	eb 55                	jmp    802478 <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  802423:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80242a:	8b 15 88 50 83 00    	mov    0x835088,%edx
  802430:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802433:	01 d0                	add    %edx,%eax
  802435:	48                   	dec    %eax
  802436:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802439:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80243c:	ba 00 00 00 00       	mov    $0x0,%edx
  802441:	f7 75 cc             	divl   -0x34(%ebp)
  802444:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802447:	29 d0                	sub    %edx,%eax
  802449:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  80244c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80244f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802452:	01 d0                	add    %edx,%eax
  802454:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802459:	76 0a                	jbe    802465 <sget+0x2ac>
            return NULL;
  80245b:	b8 00 00 00 00       	mov    $0x0,%eax
  802460:	e9 ab 00 00 00       	jmp    802510 <sget+0x357>
        va = start;
  802465:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802468:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  80246b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80246e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802471:	01 d0                	add    %edx,%eax
  802473:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802478:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80247f:	eb 5e                	jmp    8024df <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  802481:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802484:	89 d0                	mov    %edx,%eax
  802486:	01 c0                	add    %eax,%eax
  802488:	01 d0                	add    %edx,%eax
  80248a:	c1 e0 02             	shl    $0x2,%eax
  80248d:	05 48 50 80 00       	add    $0x805048,%eax
  802492:	8a 00                	mov    (%eax),%al
  802494:	84 c0                	test   %al,%al
  802496:	75 44                	jne    8024dc <sget+0x323>
        {
            uhp_allocs[i].va = va;
  802498:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80249b:	89 d0                	mov    %edx,%eax
  80249d:	01 c0                	add    %eax,%eax
  80249f:	01 d0                	add    %edx,%eax
  8024a1:	c1 e0 02             	shl    $0x2,%eax
  8024a4:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  8024aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024ad:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  8024af:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024b2:	89 d0                	mov    %edx,%eax
  8024b4:	01 c0                	add    %eax,%eax
  8024b6:	01 d0                	add    %edx,%eax
  8024b8:	c1 e0 02             	shl    $0x2,%eax
  8024bb:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8024c1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8024c4:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  8024c6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024c9:	89 d0                	mov    %edx,%eax
  8024cb:	01 c0                	add    %eax,%eax
  8024cd:	01 d0                	add    %edx,%eax
  8024cf:	c1 e0 02             	shl    $0x2,%eax
  8024d2:	05 48 50 80 00       	add    $0x805048,%eax
  8024d7:	c6 00 01             	movb   $0x1,(%eax)
            break;
  8024da:	eb 0c                	jmp    8024e8 <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8024dc:	ff 45 e0             	incl   -0x20(%ebp)
  8024df:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8024e6:	7e 99                	jle    802481 <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  8024e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024eb:	83 ec 04             	sub    $0x4,%esp
  8024ee:	50                   	push   %eax
  8024ef:	ff 75 0c             	pushl  0xc(%ebp)
  8024f2:	ff 75 08             	pushl  0x8(%ebp)
  8024f5:	e8 bf 0b 00 00       	call   8030b9 <sys_get_shared_object>
  8024fa:	83 c4 10             	add    $0x10,%esp
  8024fd:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  802500:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802504:	79 07                	jns    80250d <sget+0x354>
        return NULL;
  802506:	b8 00 00 00 00       	mov    $0x0,%eax
  80250b:	eb 03                	jmp    802510 <sget+0x357>
    return (void*)va;
  80250d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  802510:	c9                   	leave  
  802511:	c3                   	ret    

00802512 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802512:	55                   	push   %ebp
  802513:	89 e5                	mov    %esp,%ebp
  802515:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802518:	e8 f8 f0 ff ff       	call   801615 <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  80251d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802521:	75 13                	jne    802536 <realloc+0x24>
		return malloc(new_size);
  802523:	83 ec 0c             	sub    $0xc,%esp
  802526:	ff 75 0c             	pushl  0xc(%ebp)
  802529:	e8 c4 f1 ff ff       	call   8016f2 <malloc>
  80252e:	83 c4 10             	add    $0x10,%esp
  802531:	e9 f4 05 00 00       	jmp    802b2a <realloc+0x618>
	if (new_size == 0)
  802536:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80253a:	75 18                	jne    802554 <realloc+0x42>
	{
		free(virtual_address);
  80253c:	83 ec 0c             	sub    $0xc,%esp
  80253f:	ff 75 08             	pushl  0x8(%ebp)
  802542:	e8 0b f5 ff ff       	call   801a52 <free>
  802547:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80254a:	b8 00 00 00 00       	mov    $0x0,%eax
  80254f:	e9 d6 05 00 00       	jmp    802b2a <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  802554:	8b 45 08             	mov    0x8(%ebp),%eax
  802557:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  80255a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80255d:	85 c0                	test   %eax,%eax
  80255f:	79 74                	jns    8025d5 <realloc+0xc3>
  802561:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  802568:	77 6b                	ja     8025d5 <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  80256a:	83 ec 0c             	sub    $0xc,%esp
  80256d:	ff 75 0c             	pushl  0xc(%ebp)
  802570:	e8 7d f1 ff ff       	call   8016f2 <malloc>
  802575:	83 c4 10             	add    $0x10,%esp
  802578:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  80257b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80257f:	75 0a                	jne    80258b <realloc+0x79>
			return NULL;
  802581:	b8 00 00 00 00       	mov    $0x0,%eax
  802586:	e9 9f 05 00 00       	jmp    802b2a <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  80258b:	83 ec 0c             	sub    $0xc,%esp
  80258e:	ff 75 08             	pushl  0x8(%ebp)
  802591:	e8 e0 11 00 00       	call   803776 <get_block_size>
  802596:	83 c4 10             	add    $0x10,%esp
  802599:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  80259c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80259f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025a2:	39 d0                	cmp    %edx,%eax
  8025a4:	76 02                	jbe    8025a8 <realloc+0x96>
  8025a6:	89 d0                	mov    %edx,%eax
  8025a8:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  8025ab:	83 ec 04             	sub    $0x4,%esp
  8025ae:	ff 75 c0             	pushl  -0x40(%ebp)
  8025b1:	ff 75 08             	pushl  0x8(%ebp)
  8025b4:	ff 75 c8             	pushl  -0x38(%ebp)
  8025b7:	e8 56 eb ff ff       	call   801112 <memmove>
  8025bc:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  8025bf:	83 ec 0c             	sub    $0xc,%esp
  8025c2:	ff 75 08             	pushl  0x8(%ebp)
  8025c5:	e8 88 f4 ff ff       	call   801a52 <free>
  8025ca:	83 c4 10             	add    $0x10,%esp
		return newptr;
  8025cd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8025d0:	e9 55 05 00 00       	jmp    802b2a <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  8025d5:	a1 30 51 83 00       	mov    0x835130,%eax
  8025da:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  8025dd:	72 09                	jb     8025e8 <realloc+0xd6>
  8025df:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  8025e6:	76 0a                	jbe    8025f2 <realloc+0xe0>
		return NULL;
  8025e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ed:	e9 38 05 00 00       	jmp    802b2a <realloc+0x618>
	uint32 oldsz = 0;
  8025f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  8025f9:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802600:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802607:	eb 50                	jmp    802659 <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802609:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80260c:	89 d0                	mov    %edx,%eax
  80260e:	01 c0                	add    %eax,%eax
  802610:	01 d0                	add    %edx,%eax
  802612:	c1 e0 02             	shl    $0x2,%eax
  802615:	05 48 50 80 00       	add    $0x805048,%eax
  80261a:	8a 00                	mov    (%eax),%al
  80261c:	84 c0                	test   %al,%al
  80261e:	74 36                	je     802656 <realloc+0x144>
  802620:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802623:	89 d0                	mov    %edx,%eax
  802625:	01 c0                	add    %eax,%eax
  802627:	01 d0                	add    %edx,%eax
  802629:	c1 e0 02             	shl    $0x2,%eax
  80262c:	05 40 50 80 00       	add    $0x805040,%eax
  802631:	8b 00                	mov    (%eax),%eax
  802633:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  802636:	75 1e                	jne    802656 <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  802638:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80263b:	89 d0                	mov    %edx,%eax
  80263d:	01 c0                	add    %eax,%eax
  80263f:	01 d0                	add    %edx,%eax
  802641:	c1 e0 02             	shl    $0x2,%eax
  802644:	05 44 50 80 00       	add    $0x805044,%eax
  802649:	8b 00                	mov    (%eax),%eax
  80264b:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  80264e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802651:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802654:	eb 0c                	jmp    802662 <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802656:	ff 45 ec             	incl   -0x14(%ebp)
  802659:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802660:	7e a7                	jle    802609 <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  802662:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802666:	75 0a                	jne    802672 <realloc+0x160>
		return NULL;
  802668:	b8 00 00 00 00       	mov    $0x0,%eax
  80266d:	e9 b8 04 00 00       	jmp    802b2a <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  802672:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  802679:	8b 55 0c             	mov    0xc(%ebp),%edx
  80267c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80267f:	01 d0                	add    %edx,%eax
  802681:	48                   	dec    %eax
  802682:	89 45 b8             	mov    %eax,-0x48(%ebp)
  802685:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802688:	ba 00 00 00 00       	mov    $0x0,%edx
  80268d:	f7 75 bc             	divl   -0x44(%ebp)
  802690:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802693:	29 d0                	sub    %edx,%eax
  802695:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  802698:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80269b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80269e:	75 08                	jne    8026a8 <realloc+0x196>
		return virtual_address;
  8026a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a3:	e9 82 04 00 00       	jmp    802b2a <realloc+0x618>
	if (req < oldsz)
  8026a8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8026ab:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8026ae:	0f 83 cd 02 00 00    	jae    802981 <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  8026b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b7:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  8026ba:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  8026bd:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8026c0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8026c3:	01 d0                	add    %edx,%eax
  8026c5:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  8026c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026cb:	89 d0                	mov    %edx,%eax
  8026cd:	01 c0                	add    %eax,%eax
  8026cf:	01 d0                	add    %edx,%eax
  8026d1:	c1 e0 02             	shl    $0x2,%eax
  8026d4:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8026da:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8026dd:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  8026df:	83 ec 08             	sub    $0x8,%esp
  8026e2:	ff 75 b0             	pushl  -0x50(%ebp)
  8026e5:	ff 75 ac             	pushl  -0x54(%ebp)
  8026e8:	e8 e3 0c 00 00       	call   8033d0 <sys_free_user_mem>
  8026ed:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  8026f0:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8026f7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8026fe:	eb 64                	jmp    802764 <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  802700:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802703:	89 d0                	mov    %edx,%eax
  802705:	01 c0                	add    %eax,%eax
  802707:	01 d0                	add    %edx,%eax
  802709:	c1 e0 02             	shl    $0x2,%eax
  80270c:	05 48 10 81 00       	add    $0x811048,%eax
  802711:	8a 00                	mov    (%eax),%al
  802713:	84 c0                	test   %al,%al
  802715:	75 4a                	jne    802761 <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  802717:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80271a:	89 d0                	mov    %edx,%eax
  80271c:	01 c0                	add    %eax,%eax
  80271e:	01 d0                	add    %edx,%eax
  802720:	c1 e0 02             	shl    $0x2,%eax
  802723:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  802729:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80272c:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  80272e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802731:	89 d0                	mov    %edx,%eax
  802733:	01 c0                	add    %eax,%eax
  802735:	01 d0                	add    %edx,%eax
  802737:	c1 e0 02             	shl    $0x2,%eax
  80273a:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  802740:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802743:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  802745:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802748:	89 d0                	mov    %edx,%eax
  80274a:	01 c0                	add    %eax,%eax
  80274c:	01 d0                	add    %edx,%eax
  80274e:	c1 e0 02             	shl    $0x2,%eax
  802751:	05 48 10 81 00       	add    $0x811048,%eax
  802756:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  802759:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80275c:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  80275f:	eb 0c                	jmp    80276d <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802761:	ff 45 e4             	incl   -0x1c(%ebp)
  802764:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  80276b:	7e 93                	jle    802700 <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  80276d:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802771:	0f 84 8d 01 00 00    	je     802904 <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802777:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80277e:	e9 74 01 00 00       	jmp    8028f7 <realloc+0x3e5>
			{
				if (k == fidx) continue;
  802783:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802786:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802789:	0f 84 64 01 00 00    	je     8028f3 <realloc+0x3e1>
				if (uhp_frees[k].free)
  80278f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802792:	89 d0                	mov    %edx,%eax
  802794:	01 c0                	add    %eax,%eax
  802796:	01 d0                	add    %edx,%eax
  802798:	c1 e0 02             	shl    $0x2,%eax
  80279b:	05 48 10 81 00       	add    $0x811048,%eax
  8027a0:	8a 00                	mov    (%eax),%al
  8027a2:	84 c0                	test   %al,%al
  8027a4:	0f 84 4a 01 00 00    	je     8028f4 <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  8027aa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027ad:	89 d0                	mov    %edx,%eax
  8027af:	01 c0                	add    %eax,%eax
  8027b1:	01 d0                	add    %edx,%eax
  8027b3:	c1 e0 02             	shl    $0x2,%eax
  8027b6:	05 40 10 81 00       	add    $0x811040,%eax
  8027bb:	8b 08                	mov    (%eax),%ecx
  8027bd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027c0:	89 d0                	mov    %edx,%eax
  8027c2:	01 c0                	add    %eax,%eax
  8027c4:	01 d0                	add    %edx,%eax
  8027c6:	c1 e0 02             	shl    $0x2,%eax
  8027c9:	05 44 10 81 00       	add    $0x811044,%eax
  8027ce:	8b 00                	mov    (%eax),%eax
  8027d0:	01 c1                	add    %eax,%ecx
  8027d2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027d5:	89 d0                	mov    %edx,%eax
  8027d7:	01 c0                	add    %eax,%eax
  8027d9:	01 d0                	add    %edx,%eax
  8027db:	c1 e0 02             	shl    $0x2,%eax
  8027de:	05 40 10 81 00       	add    $0x811040,%eax
  8027e3:	8b 00                	mov    (%eax),%eax
  8027e5:	39 c1                	cmp    %eax,%ecx
  8027e7:	75 7a                	jne    802863 <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  8027e9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027ec:	89 d0                	mov    %edx,%eax
  8027ee:	01 c0                	add    %eax,%eax
  8027f0:	01 d0                	add    %edx,%eax
  8027f2:	c1 e0 02             	shl    $0x2,%eax
  8027f5:	05 40 10 81 00       	add    $0x811040,%eax
  8027fa:	8b 10                	mov    (%eax),%edx
  8027fc:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  8027ff:	89 c8                	mov    %ecx,%eax
  802801:	01 c0                	add    %eax,%eax
  802803:	01 c8                	add    %ecx,%eax
  802805:	c1 e0 02             	shl    $0x2,%eax
  802808:	05 40 10 81 00       	add    $0x811040,%eax
  80280d:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  80280f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802812:	89 d0                	mov    %edx,%eax
  802814:	01 c0                	add    %eax,%eax
  802816:	01 d0                	add    %edx,%eax
  802818:	c1 e0 02             	shl    $0x2,%eax
  80281b:	05 44 10 81 00       	add    $0x811044,%eax
  802820:	8b 08                	mov    (%eax),%ecx
  802822:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802825:	89 d0                	mov    %edx,%eax
  802827:	01 c0                	add    %eax,%eax
  802829:	01 d0                	add    %edx,%eax
  80282b:	c1 e0 02             	shl    $0x2,%eax
  80282e:	05 44 10 81 00       	add    $0x811044,%eax
  802833:	8b 00                	mov    (%eax),%eax
  802835:	01 c1                	add    %eax,%ecx
  802837:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80283a:	89 d0                	mov    %edx,%eax
  80283c:	01 c0                	add    %eax,%eax
  80283e:	01 d0                	add    %edx,%eax
  802840:	c1 e0 02             	shl    $0x2,%eax
  802843:	05 44 10 81 00       	add    $0x811044,%eax
  802848:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  80284a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80284d:	89 d0                	mov    %edx,%eax
  80284f:	01 c0                	add    %eax,%eax
  802851:	01 d0                	add    %edx,%eax
  802853:	c1 e0 02             	shl    $0x2,%eax
  802856:	05 48 10 81 00       	add    $0x811048,%eax
  80285b:	c6 00 00             	movb   $0x0,(%eax)
  80285e:	e9 91 00 00 00       	jmp    8028f4 <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802863:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802866:	89 d0                	mov    %edx,%eax
  802868:	01 c0                	add    %eax,%eax
  80286a:	01 d0                	add    %edx,%eax
  80286c:	c1 e0 02             	shl    $0x2,%eax
  80286f:	05 40 10 81 00       	add    $0x811040,%eax
  802874:	8b 08                	mov    (%eax),%ecx
  802876:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802879:	89 d0                	mov    %edx,%eax
  80287b:	01 c0                	add    %eax,%eax
  80287d:	01 d0                	add    %edx,%eax
  80287f:	c1 e0 02             	shl    $0x2,%eax
  802882:	05 44 10 81 00       	add    $0x811044,%eax
  802887:	8b 00                	mov    (%eax),%eax
  802889:	01 c1                	add    %eax,%ecx
  80288b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80288e:	89 d0                	mov    %edx,%eax
  802890:	01 c0                	add    %eax,%eax
  802892:	01 d0                	add    %edx,%eax
  802894:	c1 e0 02             	shl    $0x2,%eax
  802897:	05 40 10 81 00       	add    $0x811040,%eax
  80289c:	8b 00                	mov    (%eax),%eax
  80289e:	39 c1                	cmp    %eax,%ecx
  8028a0:	75 52                	jne    8028f4 <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  8028a2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028a5:	89 d0                	mov    %edx,%eax
  8028a7:	01 c0                	add    %eax,%eax
  8028a9:	01 d0                	add    %edx,%eax
  8028ab:	c1 e0 02             	shl    $0x2,%eax
  8028ae:	05 44 10 81 00       	add    $0x811044,%eax
  8028b3:	8b 08                	mov    (%eax),%ecx
  8028b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028b8:	89 d0                	mov    %edx,%eax
  8028ba:	01 c0                	add    %eax,%eax
  8028bc:	01 d0                	add    %edx,%eax
  8028be:	c1 e0 02             	shl    $0x2,%eax
  8028c1:	05 44 10 81 00       	add    $0x811044,%eax
  8028c6:	8b 00                	mov    (%eax),%eax
  8028c8:	01 c1                	add    %eax,%ecx
  8028ca:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028cd:	89 d0                	mov    %edx,%eax
  8028cf:	01 c0                	add    %eax,%eax
  8028d1:	01 d0                	add    %edx,%eax
  8028d3:	c1 e0 02             	shl    $0x2,%eax
  8028d6:	05 44 10 81 00       	add    $0x811044,%eax
  8028db:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  8028dd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028e0:	89 d0                	mov    %edx,%eax
  8028e2:	01 c0                	add    %eax,%eax
  8028e4:	01 d0                	add    %edx,%eax
  8028e6:	c1 e0 02             	shl    $0x2,%eax
  8028e9:	05 48 10 81 00       	add    $0x811048,%eax
  8028ee:	c6 00 00             	movb   $0x0,(%eax)
  8028f1:	eb 01                	jmp    8028f4 <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  8028f3:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  8028f4:	ff 45 e0             	incl   -0x20(%ebp)
  8028f7:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8028fe:	0f 8e 7f fe ff ff    	jle    802783 <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  802904:	a1 30 51 83 00       	mov    0x835130,%eax
  802909:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  80290c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  802913:	eb 53                	jmp    802968 <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  802915:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802918:	89 d0                	mov    %edx,%eax
  80291a:	01 c0                	add    %eax,%eax
  80291c:	01 d0                	add    %edx,%eax
  80291e:	c1 e0 02             	shl    $0x2,%eax
  802921:	05 48 50 80 00       	add    $0x805048,%eax
  802926:	8a 00                	mov    (%eax),%al
  802928:	84 c0                	test   %al,%al
  80292a:	74 39                	je     802965 <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  80292c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80292f:	89 d0                	mov    %edx,%eax
  802931:	01 c0                	add    %eax,%eax
  802933:	01 d0                	add    %edx,%eax
  802935:	c1 e0 02             	shl    $0x2,%eax
  802938:	05 40 50 80 00       	add    $0x805040,%eax
  80293d:	8b 08                	mov    (%eax),%ecx
  80293f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802942:	89 d0                	mov    %edx,%eax
  802944:	01 c0                	add    %eax,%eax
  802946:	01 d0                	add    %edx,%eax
  802948:	c1 e0 02             	shl    $0x2,%eax
  80294b:	05 44 50 80 00       	add    $0x805044,%eax
  802950:	8b 00                	mov    (%eax),%eax
  802952:	01 c8                	add    %ecx,%eax
  802954:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  802957:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80295a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80295d:	76 06                	jbe    802965 <realloc+0x453>
  80295f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802962:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802965:	ff 45 d8             	incl   -0x28(%ebp)
  802968:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  80296f:	7e a4                	jle    802915 <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  802971:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802974:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  802979:	8b 45 08             	mov    0x8(%ebp),%eax
  80297c:	e9 a9 01 00 00       	jmp    802b2a <realloc+0x618>
	}
	uint32 end = va + oldsz;
  802981:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802984:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802987:	01 d0                	add    %edx,%eax
  802989:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  80298c:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802993:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  80299a:	eb 57                	jmp    8029f3 <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  80299c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80299f:	89 d0                	mov    %edx,%eax
  8029a1:	01 c0                	add    %eax,%eax
  8029a3:	01 d0                	add    %edx,%eax
  8029a5:	c1 e0 02             	shl    $0x2,%eax
  8029a8:	05 48 10 81 00       	add    $0x811048,%eax
  8029ad:	8a 00                	mov    (%eax),%al
  8029af:	84 c0                	test   %al,%al
  8029b1:	74 3d                	je     8029f0 <realloc+0x4de>
  8029b3:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8029b6:	89 d0                	mov    %edx,%eax
  8029b8:	01 c0                	add    %eax,%eax
  8029ba:	01 d0                	add    %edx,%eax
  8029bc:	c1 e0 02             	shl    $0x2,%eax
  8029bf:	05 40 10 81 00       	add    $0x811040,%eax
  8029c4:	8b 00                	mov    (%eax),%eax
  8029c6:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029c9:	75 25                	jne    8029f0 <realloc+0x4de>
  8029cb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8029ce:	89 d0                	mov    %edx,%eax
  8029d0:	01 c0                	add    %eax,%eax
  8029d2:	01 d0                	add    %edx,%eax
  8029d4:	c1 e0 02             	shl    $0x2,%eax
  8029d7:	05 44 10 81 00       	add    $0x811044,%eax
  8029dc:	8b 10                	mov    (%eax),%edx
  8029de:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8029e1:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8029e4:	39 c2                	cmp    %eax,%edx
  8029e6:	72 08                	jb     8029f0 <realloc+0x4de>
		{
			adjIdx = j; break;
  8029e8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8029eb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8029ee:	eb 0c                	jmp    8029fc <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8029f0:	ff 45 d0             	incl   -0x30(%ebp)
  8029f3:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  8029fa:	7e a0                	jle    80299c <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  8029fc:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  802a00:	0f 84 d6 00 00 00    	je     802adc <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  802a06:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a09:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802a0c:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  802a0f:	83 ec 08             	sub    $0x8,%esp
  802a12:	ff 75 a0             	pushl  -0x60(%ebp)
  802a15:	ff 75 a4             	pushl  -0x5c(%ebp)
  802a18:	e8 cf 09 00 00       	call   8033ec <sys_allocate_user_mem>
  802a1d:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  802a20:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a23:	89 d0                	mov    %edx,%eax
  802a25:	01 c0                	add    %eax,%eax
  802a27:	01 d0                	add    %edx,%eax
  802a29:	c1 e0 02             	shl    $0x2,%eax
  802a2c:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802a32:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a35:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  802a37:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a3a:	89 d0                	mov    %edx,%eax
  802a3c:	01 c0                	add    %eax,%eax
  802a3e:	01 d0                	add    %edx,%eax
  802a40:	c1 e0 02             	shl    $0x2,%eax
  802a43:	05 40 10 81 00       	add    $0x811040,%eax
  802a48:	8b 10                	mov    (%eax),%edx
  802a4a:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802a4d:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802a50:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a53:	89 d0                	mov    %edx,%eax
  802a55:	01 c0                	add    %eax,%eax
  802a57:	01 d0                	add    %edx,%eax
  802a59:	c1 e0 02             	shl    $0x2,%eax
  802a5c:	05 40 10 81 00       	add    $0x811040,%eax
  802a61:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  802a63:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a66:	89 d0                	mov    %edx,%eax
  802a68:	01 c0                	add    %eax,%eax
  802a6a:	01 d0                	add    %edx,%eax
  802a6c:	c1 e0 02             	shl    $0x2,%eax
  802a6f:	05 44 10 81 00       	add    $0x811044,%eax
  802a74:	8b 00                	mov    (%eax),%eax
  802a76:	2b 45 a0             	sub    -0x60(%ebp),%eax
  802a79:	89 c2                	mov    %eax,%edx
  802a7b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  802a7e:	89 c8                	mov    %ecx,%eax
  802a80:	01 c0                	add    %eax,%eax
  802a82:	01 c8                	add    %ecx,%eax
  802a84:	c1 e0 02             	shl    $0x2,%eax
  802a87:	05 44 10 81 00       	add    $0x811044,%eax
  802a8c:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  802a8e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a91:	89 d0                	mov    %edx,%eax
  802a93:	01 c0                	add    %eax,%eax
  802a95:	01 d0                	add    %edx,%eax
  802a97:	c1 e0 02             	shl    $0x2,%eax
  802a9a:	05 44 10 81 00       	add    $0x811044,%eax
  802a9f:	8b 00                	mov    (%eax),%eax
  802aa1:	85 c0                	test   %eax,%eax
  802aa3:	75 14                	jne    802ab9 <realloc+0x5a7>
  802aa5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802aa8:	89 d0                	mov    %edx,%eax
  802aaa:	01 c0                	add    %eax,%eax
  802aac:	01 d0                	add    %edx,%eax
  802aae:	c1 e0 02             	shl    $0x2,%eax
  802ab1:	05 48 10 81 00       	add    $0x811048,%eax
  802ab6:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  802ab9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802abc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802abf:	01 c2                	add    %eax,%edx
  802ac1:	a1 88 50 83 00       	mov    0x835088,%eax
  802ac6:	39 c2                	cmp    %eax,%edx
  802ac8:	76 0d                	jbe    802ad7 <realloc+0x5c5>
  802aca:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802acd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ad0:	01 d0                	add    %edx,%eax
  802ad2:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  802ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  802ada:	eb 4e                	jmp    802b2a <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  802adc:	83 ec 0c             	sub    $0xc,%esp
  802adf:	ff 75 0c             	pushl  0xc(%ebp)
  802ae2:	e8 0b ec ff ff       	call   8016f2 <malloc>
  802ae7:	83 c4 10             	add    $0x10,%esp
  802aea:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  802aed:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  802af1:	75 07                	jne    802afa <realloc+0x5e8>
		return NULL;
  802af3:	b8 00 00 00 00       	mov    $0x0,%eax
  802af8:	eb 30                	jmp    802b2a <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  802afa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802afd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b00:	39 d0                	cmp    %edx,%eax
  802b02:	76 02                	jbe    802b06 <realloc+0x5f4>
  802b04:	89 d0                	mov    %edx,%eax
  802b06:	8b 55 9c             	mov    -0x64(%ebp),%edx
  802b09:	83 ec 04             	sub    $0x4,%esp
  802b0c:	50                   	push   %eax
  802b0d:	52                   	push   %edx
  802b0e:	ff 75 cc             	pushl  -0x34(%ebp)
  802b11:	e8 cf 06 00 00       	call   8031e5 <sys_move_user_mem>
  802b16:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  802b19:	83 ec 0c             	sub    $0xc,%esp
  802b1c:	ff 75 08             	pushl  0x8(%ebp)
  802b1f:	e8 2e ef ff ff       	call   801a52 <free>
  802b24:	83 c4 10             	add    $0x10,%esp
	return newptr;
  802b27:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  802b2a:	c9                   	leave  
  802b2b:	c3                   	ret    

00802b2c <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802b2c:	55                   	push   %ebp
  802b2d:	89 e5                	mov    %esp,%ebp
  802b2f:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  802b32:	8b 45 08             	mov    0x8(%ebp),%eax
  802b35:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  802b38:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802b3c:	0f 84 33 03 00 00    	je     802e75 <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  802b42:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b45:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  802b4a:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  802b4d:	83 ec 08             	sub    $0x8,%esp
  802b50:	ff 75 08             	pushl  0x8(%ebp)
  802b53:	ff 75 d8             	pushl  -0x28(%ebp)
  802b56:	e8 7d 05 00 00       	call   8030d8 <sys_delete_shared_object>
  802b5b:	83 c4 10             	add    $0x10,%esp
  802b5e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  802b61:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802b65:	0f 88 0d 03 00 00    	js     802e78 <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802b6b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802b72:	e9 ef 02 00 00       	jmp    802e66 <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802b77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b7a:	89 d0                	mov    %edx,%eax
  802b7c:	01 c0                	add    %eax,%eax
  802b7e:	01 d0                	add    %edx,%eax
  802b80:	c1 e0 02             	shl    $0x2,%eax
  802b83:	05 48 50 80 00       	add    $0x805048,%eax
  802b88:	8a 00                	mov    (%eax),%al
  802b8a:	84 c0                	test   %al,%al
  802b8c:	0f 84 d1 02 00 00    	je     802e63 <sfree+0x337>
  802b92:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b95:	89 d0                	mov    %edx,%eax
  802b97:	01 c0                	add    %eax,%eax
  802b99:	01 d0                	add    %edx,%eax
  802b9b:	c1 e0 02             	shl    $0x2,%eax
  802b9e:	05 40 50 80 00       	add    $0x805040,%eax
  802ba3:	8b 00                	mov    (%eax),%eax
  802ba5:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802ba8:	0f 85 b5 02 00 00    	jne    802e63 <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  802bae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bb1:	89 d0                	mov    %edx,%eax
  802bb3:	01 c0                	add    %eax,%eax
  802bb5:	01 d0                	add    %edx,%eax
  802bb7:	c1 e0 02             	shl    $0x2,%eax
  802bba:	05 44 50 80 00       	add    $0x805044,%eax
  802bbf:	8b 00                	mov    (%eax),%eax
  802bc1:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  802bc4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bc7:	89 d0                	mov    %edx,%eax
  802bc9:	01 c0                	add    %eax,%eax
  802bcb:	01 d0                	add    %edx,%eax
  802bcd:	c1 e0 02             	shl    $0x2,%eax
  802bd0:	05 48 50 80 00       	add    $0x805048,%eax
  802bd5:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  802bd8:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802bdf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802be6:	eb 64                	jmp    802c4c <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  802be8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802beb:	89 d0                	mov    %edx,%eax
  802bed:	01 c0                	add    %eax,%eax
  802bef:	01 d0                	add    %edx,%eax
  802bf1:	c1 e0 02             	shl    $0x2,%eax
  802bf4:	05 48 10 81 00       	add    $0x811048,%eax
  802bf9:	8a 00                	mov    (%eax),%al
  802bfb:	84 c0                	test   %al,%al
  802bfd:	75 4a                	jne    802c49 <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  802bff:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c02:	89 d0                	mov    %edx,%eax
  802c04:	01 c0                	add    %eax,%eax
  802c06:	01 d0                	add    %edx,%eax
  802c08:	c1 e0 02             	shl    $0x2,%eax
  802c0b:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  802c11:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c14:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  802c16:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c19:	89 d0                	mov    %edx,%eax
  802c1b:	01 c0                	add    %eax,%eax
  802c1d:	01 d0                	add    %edx,%eax
  802c1f:	c1 e0 02             	shl    $0x2,%eax
  802c22:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  802c28:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c2b:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  802c2d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c30:	89 d0                	mov    %edx,%eax
  802c32:	01 c0                	add    %eax,%eax
  802c34:	01 d0                	add    %edx,%eax
  802c36:	c1 e0 02             	shl    $0x2,%eax
  802c39:	05 48 10 81 00       	add    $0x811048,%eax
  802c3e:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  802c41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c44:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  802c47:	eb 0c                	jmp    802c55 <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802c49:	ff 45 ec             	incl   -0x14(%ebp)
  802c4c:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802c53:	7e 93                	jle    802be8 <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  802c55:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802c59:	0f 84 8d 01 00 00    	je     802dec <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802c5f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802c66:	e9 74 01 00 00       	jmp    802ddf <sfree+0x2b3>
				{
					if (k == fidx) continue;
  802c6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c6e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c71:	0f 84 64 01 00 00    	je     802ddb <sfree+0x2af>
					if (uhp_frees[k].free)
  802c77:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c7a:	89 d0                	mov    %edx,%eax
  802c7c:	01 c0                	add    %eax,%eax
  802c7e:	01 d0                	add    %edx,%eax
  802c80:	c1 e0 02             	shl    $0x2,%eax
  802c83:	05 48 10 81 00       	add    $0x811048,%eax
  802c88:	8a 00                	mov    (%eax),%al
  802c8a:	84 c0                	test   %al,%al
  802c8c:	0f 84 4a 01 00 00    	je     802ddc <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802c92:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c95:	89 d0                	mov    %edx,%eax
  802c97:	01 c0                	add    %eax,%eax
  802c99:	01 d0                	add    %edx,%eax
  802c9b:	c1 e0 02             	shl    $0x2,%eax
  802c9e:	05 40 10 81 00       	add    $0x811040,%eax
  802ca3:	8b 08                	mov    (%eax),%ecx
  802ca5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ca8:	89 d0                	mov    %edx,%eax
  802caa:	01 c0                	add    %eax,%eax
  802cac:	01 d0                	add    %edx,%eax
  802cae:	c1 e0 02             	shl    $0x2,%eax
  802cb1:	05 44 10 81 00       	add    $0x811044,%eax
  802cb6:	8b 00                	mov    (%eax),%eax
  802cb8:	01 c1                	add    %eax,%ecx
  802cba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cbd:	89 d0                	mov    %edx,%eax
  802cbf:	01 c0                	add    %eax,%eax
  802cc1:	01 d0                	add    %edx,%eax
  802cc3:	c1 e0 02             	shl    $0x2,%eax
  802cc6:	05 40 10 81 00       	add    $0x811040,%eax
  802ccb:	8b 00                	mov    (%eax),%eax
  802ccd:	39 c1                	cmp    %eax,%ecx
  802ccf:	75 7a                	jne    802d4b <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  802cd1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cd4:	89 d0                	mov    %edx,%eax
  802cd6:	01 c0                	add    %eax,%eax
  802cd8:	01 d0                	add    %edx,%eax
  802cda:	c1 e0 02             	shl    $0x2,%eax
  802cdd:	05 40 10 81 00       	add    $0x811040,%eax
  802ce2:	8b 10                	mov    (%eax),%edx
  802ce4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802ce7:	89 c8                	mov    %ecx,%eax
  802ce9:	01 c0                	add    %eax,%eax
  802ceb:	01 c8                	add    %ecx,%eax
  802ced:	c1 e0 02             	shl    $0x2,%eax
  802cf0:	05 40 10 81 00       	add    $0x811040,%eax
  802cf5:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  802cf7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cfa:	89 d0                	mov    %edx,%eax
  802cfc:	01 c0                	add    %eax,%eax
  802cfe:	01 d0                	add    %edx,%eax
  802d00:	c1 e0 02             	shl    $0x2,%eax
  802d03:	05 44 10 81 00       	add    $0x811044,%eax
  802d08:	8b 08                	mov    (%eax),%ecx
  802d0a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d0d:	89 d0                	mov    %edx,%eax
  802d0f:	01 c0                	add    %eax,%eax
  802d11:	01 d0                	add    %edx,%eax
  802d13:	c1 e0 02             	shl    $0x2,%eax
  802d16:	05 44 10 81 00       	add    $0x811044,%eax
  802d1b:	8b 00                	mov    (%eax),%eax
  802d1d:	01 c1                	add    %eax,%ecx
  802d1f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d22:	89 d0                	mov    %edx,%eax
  802d24:	01 c0                	add    %eax,%eax
  802d26:	01 d0                	add    %edx,%eax
  802d28:	c1 e0 02             	shl    $0x2,%eax
  802d2b:	05 44 10 81 00       	add    $0x811044,%eax
  802d30:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802d32:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d35:	89 d0                	mov    %edx,%eax
  802d37:	01 c0                	add    %eax,%eax
  802d39:	01 d0                	add    %edx,%eax
  802d3b:	c1 e0 02             	shl    $0x2,%eax
  802d3e:	05 48 10 81 00       	add    $0x811048,%eax
  802d43:	c6 00 00             	movb   $0x0,(%eax)
  802d46:	e9 91 00 00 00       	jmp    802ddc <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802d4b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d4e:	89 d0                	mov    %edx,%eax
  802d50:	01 c0                	add    %eax,%eax
  802d52:	01 d0                	add    %edx,%eax
  802d54:	c1 e0 02             	shl    $0x2,%eax
  802d57:	05 40 10 81 00       	add    $0x811040,%eax
  802d5c:	8b 08                	mov    (%eax),%ecx
  802d5e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d61:	89 d0                	mov    %edx,%eax
  802d63:	01 c0                	add    %eax,%eax
  802d65:	01 d0                	add    %edx,%eax
  802d67:	c1 e0 02             	shl    $0x2,%eax
  802d6a:	05 44 10 81 00       	add    $0x811044,%eax
  802d6f:	8b 00                	mov    (%eax),%eax
  802d71:	01 c1                	add    %eax,%ecx
  802d73:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d76:	89 d0                	mov    %edx,%eax
  802d78:	01 c0                	add    %eax,%eax
  802d7a:	01 d0                	add    %edx,%eax
  802d7c:	c1 e0 02             	shl    $0x2,%eax
  802d7f:	05 40 10 81 00       	add    $0x811040,%eax
  802d84:	8b 00                	mov    (%eax),%eax
  802d86:	39 c1                	cmp    %eax,%ecx
  802d88:	75 52                	jne    802ddc <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  802d8a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d8d:	89 d0                	mov    %edx,%eax
  802d8f:	01 c0                	add    %eax,%eax
  802d91:	01 d0                	add    %edx,%eax
  802d93:	c1 e0 02             	shl    $0x2,%eax
  802d96:	05 44 10 81 00       	add    $0x811044,%eax
  802d9b:	8b 08                	mov    (%eax),%ecx
  802d9d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802da0:	89 d0                	mov    %edx,%eax
  802da2:	01 c0                	add    %eax,%eax
  802da4:	01 d0                	add    %edx,%eax
  802da6:	c1 e0 02             	shl    $0x2,%eax
  802da9:	05 44 10 81 00       	add    $0x811044,%eax
  802dae:	8b 00                	mov    (%eax),%eax
  802db0:	01 c1                	add    %eax,%ecx
  802db2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802db5:	89 d0                	mov    %edx,%eax
  802db7:	01 c0                	add    %eax,%eax
  802db9:	01 d0                	add    %edx,%eax
  802dbb:	c1 e0 02             	shl    $0x2,%eax
  802dbe:	05 44 10 81 00       	add    $0x811044,%eax
  802dc3:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802dc5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802dc8:	89 d0                	mov    %edx,%eax
  802dca:	01 c0                	add    %eax,%eax
  802dcc:	01 d0                	add    %edx,%eax
  802dce:	c1 e0 02             	shl    $0x2,%eax
  802dd1:	05 48 10 81 00       	add    $0x811048,%eax
  802dd6:	c6 00 00             	movb   $0x0,(%eax)
  802dd9:	eb 01                	jmp    802ddc <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  802ddb:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802ddc:	ff 45 e8             	incl   -0x18(%ebp)
  802ddf:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802de6:	0f 8e 7f fe ff ff    	jle    802c6b <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  802dec:	a1 30 51 83 00       	mov    0x835130,%eax
  802df1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802df4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802dfb:	eb 53                	jmp    802e50 <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  802dfd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e00:	89 d0                	mov    %edx,%eax
  802e02:	01 c0                	add    %eax,%eax
  802e04:	01 d0                	add    %edx,%eax
  802e06:	c1 e0 02             	shl    $0x2,%eax
  802e09:	05 48 50 80 00       	add    $0x805048,%eax
  802e0e:	8a 00                	mov    (%eax),%al
  802e10:	84 c0                	test   %al,%al
  802e12:	74 39                	je     802e4d <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802e14:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e17:	89 d0                	mov    %edx,%eax
  802e19:	01 c0                	add    %eax,%eax
  802e1b:	01 d0                	add    %edx,%eax
  802e1d:	c1 e0 02             	shl    $0x2,%eax
  802e20:	05 40 50 80 00       	add    $0x805040,%eax
  802e25:	8b 08                	mov    (%eax),%ecx
  802e27:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e2a:	89 d0                	mov    %edx,%eax
  802e2c:	01 c0                	add    %eax,%eax
  802e2e:	01 d0                	add    %edx,%eax
  802e30:	c1 e0 02             	shl    $0x2,%eax
  802e33:	05 44 50 80 00       	add    $0x805044,%eax
  802e38:	8b 00                	mov    (%eax),%eax
  802e3a:	01 c8                	add    %ecx,%eax
  802e3c:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  802e3f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e42:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802e45:	76 06                	jbe    802e4d <sfree+0x321>
  802e47:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802e4d:	ff 45 e0             	incl   -0x20(%ebp)
  802e50:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802e57:	7e a4                	jle    802dfd <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  802e59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e5c:	a3 88 50 83 00       	mov    %eax,0x835088
			break;
  802e61:	eb 16                	jmp    802e79 <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802e63:	ff 45 f4             	incl   -0xc(%ebp)
  802e66:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  802e6d:	0f 8e 04 fd ff ff    	jle    802b77 <sfree+0x4b>
  802e73:	eb 04                	jmp    802e79 <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  802e75:	90                   	nop
  802e76:	eb 01                	jmp    802e79 <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  802e78:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  802e79:	c9                   	leave  
  802e7a:	c3                   	ret    

00802e7b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802e7b:	55                   	push   %ebp
  802e7c:	89 e5                	mov    %esp,%ebp
  802e7e:	57                   	push   %edi
  802e7f:	56                   	push   %esi
  802e80:	53                   	push   %ebx
  802e81:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802e84:	8b 45 08             	mov    0x8(%ebp),%eax
  802e87:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e8a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802e8d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802e90:	8b 7d 18             	mov    0x18(%ebp),%edi
  802e93:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802e96:	cd 30                	int    $0x30
  802e98:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802e9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802e9e:	83 c4 10             	add    $0x10,%esp
  802ea1:	5b                   	pop    %ebx
  802ea2:	5e                   	pop    %esi
  802ea3:	5f                   	pop    %edi
  802ea4:	5d                   	pop    %ebp
  802ea5:	c3                   	ret    

00802ea6 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802ea6:	55                   	push   %ebp
  802ea7:	89 e5                	mov    %esp,%ebp
  802ea9:	83 ec 04             	sub    $0x4,%esp
  802eac:	8b 45 10             	mov    0x10(%ebp),%eax
  802eaf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802eb2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802eb5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebc:	6a 00                	push   $0x0
  802ebe:	51                   	push   %ecx
  802ebf:	52                   	push   %edx
  802ec0:	ff 75 0c             	pushl  0xc(%ebp)
  802ec3:	50                   	push   %eax
  802ec4:	6a 00                	push   $0x0
  802ec6:	e8 b0 ff ff ff       	call   802e7b <syscall>
  802ecb:	83 c4 18             	add    $0x18,%esp
}
  802ece:	90                   	nop
  802ecf:	c9                   	leave  
  802ed0:	c3                   	ret    

00802ed1 <sys_cgetc>:

int
sys_cgetc(void)
{
  802ed1:	55                   	push   %ebp
  802ed2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802ed4:	6a 00                	push   $0x0
  802ed6:	6a 00                	push   $0x0
  802ed8:	6a 00                	push   $0x0
  802eda:	6a 00                	push   $0x0
  802edc:	6a 00                	push   $0x0
  802ede:	6a 02                	push   $0x2
  802ee0:	e8 96 ff ff ff       	call   802e7b <syscall>
  802ee5:	83 c4 18             	add    $0x18,%esp
}
  802ee8:	c9                   	leave  
  802ee9:	c3                   	ret    

00802eea <sys_lock_cons>:

void sys_lock_cons(void)
{
  802eea:	55                   	push   %ebp
  802eeb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802eed:	6a 00                	push   $0x0
  802eef:	6a 00                	push   $0x0
  802ef1:	6a 00                	push   $0x0
  802ef3:	6a 00                	push   $0x0
  802ef5:	6a 00                	push   $0x0
  802ef7:	6a 03                	push   $0x3
  802ef9:	e8 7d ff ff ff       	call   802e7b <syscall>
  802efe:	83 c4 18             	add    $0x18,%esp
}
  802f01:	90                   	nop
  802f02:	c9                   	leave  
  802f03:	c3                   	ret    

00802f04 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802f04:	55                   	push   %ebp
  802f05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802f07:	6a 00                	push   $0x0
  802f09:	6a 00                	push   $0x0
  802f0b:	6a 00                	push   $0x0
  802f0d:	6a 00                	push   $0x0
  802f0f:	6a 00                	push   $0x0
  802f11:	6a 04                	push   $0x4
  802f13:	e8 63 ff ff ff       	call   802e7b <syscall>
  802f18:	83 c4 18             	add    $0x18,%esp
}
  802f1b:	90                   	nop
  802f1c:	c9                   	leave  
  802f1d:	c3                   	ret    

00802f1e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802f1e:	55                   	push   %ebp
  802f1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802f21:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f24:	8b 45 08             	mov    0x8(%ebp),%eax
  802f27:	6a 00                	push   $0x0
  802f29:	6a 00                	push   $0x0
  802f2b:	6a 00                	push   $0x0
  802f2d:	52                   	push   %edx
  802f2e:	50                   	push   %eax
  802f2f:	6a 08                	push   $0x8
  802f31:	e8 45 ff ff ff       	call   802e7b <syscall>
  802f36:	83 c4 18             	add    $0x18,%esp
}
  802f39:	c9                   	leave  
  802f3a:	c3                   	ret    

00802f3b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802f3b:	55                   	push   %ebp
  802f3c:	89 e5                	mov    %esp,%ebp
  802f3e:	56                   	push   %esi
  802f3f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802f40:	8b 75 18             	mov    0x18(%ebp),%esi
  802f43:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802f46:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802f49:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4f:	56                   	push   %esi
  802f50:	53                   	push   %ebx
  802f51:	51                   	push   %ecx
  802f52:	52                   	push   %edx
  802f53:	50                   	push   %eax
  802f54:	6a 09                	push   $0x9
  802f56:	e8 20 ff ff ff       	call   802e7b <syscall>
  802f5b:	83 c4 18             	add    $0x18,%esp
}
  802f5e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802f61:	5b                   	pop    %ebx
  802f62:	5e                   	pop    %esi
  802f63:	5d                   	pop    %ebp
  802f64:	c3                   	ret    

00802f65 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802f65:	55                   	push   %ebp
  802f66:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802f68:	6a 00                	push   $0x0
  802f6a:	6a 00                	push   $0x0
  802f6c:	6a 00                	push   $0x0
  802f6e:	6a 00                	push   $0x0
  802f70:	ff 75 08             	pushl  0x8(%ebp)
  802f73:	6a 0a                	push   $0xa
  802f75:	e8 01 ff ff ff       	call   802e7b <syscall>
  802f7a:	83 c4 18             	add    $0x18,%esp
}
  802f7d:	c9                   	leave  
  802f7e:	c3                   	ret    

00802f7f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802f7f:	55                   	push   %ebp
  802f80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802f82:	6a 00                	push   $0x0
  802f84:	6a 00                	push   $0x0
  802f86:	6a 00                	push   $0x0
  802f88:	ff 75 0c             	pushl  0xc(%ebp)
  802f8b:	ff 75 08             	pushl  0x8(%ebp)
  802f8e:	6a 0b                	push   $0xb
  802f90:	e8 e6 fe ff ff       	call   802e7b <syscall>
  802f95:	83 c4 18             	add    $0x18,%esp
}
  802f98:	c9                   	leave  
  802f99:	c3                   	ret    

00802f9a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802f9a:	55                   	push   %ebp
  802f9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802f9d:	6a 00                	push   $0x0
  802f9f:	6a 00                	push   $0x0
  802fa1:	6a 00                	push   $0x0
  802fa3:	6a 00                	push   $0x0
  802fa5:	6a 00                	push   $0x0
  802fa7:	6a 0c                	push   $0xc
  802fa9:	e8 cd fe ff ff       	call   802e7b <syscall>
  802fae:	83 c4 18             	add    $0x18,%esp
}
  802fb1:	c9                   	leave  
  802fb2:	c3                   	ret    

00802fb3 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802fb3:	55                   	push   %ebp
  802fb4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802fb6:	6a 00                	push   $0x0
  802fb8:	6a 00                	push   $0x0
  802fba:	6a 00                	push   $0x0
  802fbc:	6a 00                	push   $0x0
  802fbe:	6a 00                	push   $0x0
  802fc0:	6a 0d                	push   $0xd
  802fc2:	e8 b4 fe ff ff       	call   802e7b <syscall>
  802fc7:	83 c4 18             	add    $0x18,%esp
}
  802fca:	c9                   	leave  
  802fcb:	c3                   	ret    

00802fcc <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802fcc:	55                   	push   %ebp
  802fcd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802fcf:	6a 00                	push   $0x0
  802fd1:	6a 00                	push   $0x0
  802fd3:	6a 00                	push   $0x0
  802fd5:	6a 00                	push   $0x0
  802fd7:	6a 00                	push   $0x0
  802fd9:	6a 0e                	push   $0xe
  802fdb:	e8 9b fe ff ff       	call   802e7b <syscall>
  802fe0:	83 c4 18             	add    $0x18,%esp
}
  802fe3:	c9                   	leave  
  802fe4:	c3                   	ret    

00802fe5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802fe5:	55                   	push   %ebp
  802fe6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802fe8:	6a 00                	push   $0x0
  802fea:	6a 00                	push   $0x0
  802fec:	6a 00                	push   $0x0
  802fee:	6a 00                	push   $0x0
  802ff0:	6a 00                	push   $0x0
  802ff2:	6a 0f                	push   $0xf
  802ff4:	e8 82 fe ff ff       	call   802e7b <syscall>
  802ff9:	83 c4 18             	add    $0x18,%esp
}
  802ffc:	c9                   	leave  
  802ffd:	c3                   	ret    

00802ffe <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802ffe:	55                   	push   %ebp
  802fff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  803001:	6a 00                	push   $0x0
  803003:	6a 00                	push   $0x0
  803005:	6a 00                	push   $0x0
  803007:	6a 00                	push   $0x0
  803009:	ff 75 08             	pushl  0x8(%ebp)
  80300c:	6a 10                	push   $0x10
  80300e:	e8 68 fe ff ff       	call   802e7b <syscall>
  803013:	83 c4 18             	add    $0x18,%esp
}
  803016:	c9                   	leave  
  803017:	c3                   	ret    

00803018 <sys_scarce_memory>:

void sys_scarce_memory()
{
  803018:	55                   	push   %ebp
  803019:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80301b:	6a 00                	push   $0x0
  80301d:	6a 00                	push   $0x0
  80301f:	6a 00                	push   $0x0
  803021:	6a 00                	push   $0x0
  803023:	6a 00                	push   $0x0
  803025:	6a 11                	push   $0x11
  803027:	e8 4f fe ff ff       	call   802e7b <syscall>
  80302c:	83 c4 18             	add    $0x18,%esp
}
  80302f:	90                   	nop
  803030:	c9                   	leave  
  803031:	c3                   	ret    

00803032 <sys_cputc>:

void
sys_cputc(const char c)
{
  803032:	55                   	push   %ebp
  803033:	89 e5                	mov    %esp,%ebp
  803035:	83 ec 04             	sub    $0x4,%esp
  803038:	8b 45 08             	mov    0x8(%ebp),%eax
  80303b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80303e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803042:	6a 00                	push   $0x0
  803044:	6a 00                	push   $0x0
  803046:	6a 00                	push   $0x0
  803048:	6a 00                	push   $0x0
  80304a:	50                   	push   %eax
  80304b:	6a 01                	push   $0x1
  80304d:	e8 29 fe ff ff       	call   802e7b <syscall>
  803052:	83 c4 18             	add    $0x18,%esp
}
  803055:	90                   	nop
  803056:	c9                   	leave  
  803057:	c3                   	ret    

00803058 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  803058:	55                   	push   %ebp
  803059:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80305b:	6a 00                	push   $0x0
  80305d:	6a 00                	push   $0x0
  80305f:	6a 00                	push   $0x0
  803061:	6a 00                	push   $0x0
  803063:	6a 00                	push   $0x0
  803065:	6a 14                	push   $0x14
  803067:	e8 0f fe ff ff       	call   802e7b <syscall>
  80306c:	83 c4 18             	add    $0x18,%esp
}
  80306f:	90                   	nop
  803070:	c9                   	leave  
  803071:	c3                   	ret    

00803072 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  803072:	55                   	push   %ebp
  803073:	89 e5                	mov    %esp,%ebp
  803075:	83 ec 04             	sub    $0x4,%esp
  803078:	8b 45 10             	mov    0x10(%ebp),%eax
  80307b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80307e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803081:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803085:	8b 45 08             	mov    0x8(%ebp),%eax
  803088:	6a 00                	push   $0x0
  80308a:	51                   	push   %ecx
  80308b:	52                   	push   %edx
  80308c:	ff 75 0c             	pushl  0xc(%ebp)
  80308f:	50                   	push   %eax
  803090:	6a 15                	push   $0x15
  803092:	e8 e4 fd ff ff       	call   802e7b <syscall>
  803097:	83 c4 18             	add    $0x18,%esp
}
  80309a:	c9                   	leave  
  80309b:	c3                   	ret    

0080309c <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80309c:	55                   	push   %ebp
  80309d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80309f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a5:	6a 00                	push   $0x0
  8030a7:	6a 00                	push   $0x0
  8030a9:	6a 00                	push   $0x0
  8030ab:	52                   	push   %edx
  8030ac:	50                   	push   %eax
  8030ad:	6a 16                	push   $0x16
  8030af:	e8 c7 fd ff ff       	call   802e7b <syscall>
  8030b4:	83 c4 18             	add    $0x18,%esp
}
  8030b7:	c9                   	leave  
  8030b8:	c3                   	ret    

008030b9 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8030b9:	55                   	push   %ebp
  8030ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8030bc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8030bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c5:	6a 00                	push   $0x0
  8030c7:	6a 00                	push   $0x0
  8030c9:	51                   	push   %ecx
  8030ca:	52                   	push   %edx
  8030cb:	50                   	push   %eax
  8030cc:	6a 17                	push   $0x17
  8030ce:	e8 a8 fd ff ff       	call   802e7b <syscall>
  8030d3:	83 c4 18             	add    $0x18,%esp
}
  8030d6:	c9                   	leave  
  8030d7:	c3                   	ret    

008030d8 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8030d8:	55                   	push   %ebp
  8030d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8030db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030de:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e1:	6a 00                	push   $0x0
  8030e3:	6a 00                	push   $0x0
  8030e5:	6a 00                	push   $0x0
  8030e7:	52                   	push   %edx
  8030e8:	50                   	push   %eax
  8030e9:	6a 18                	push   $0x18
  8030eb:	e8 8b fd ff ff       	call   802e7b <syscall>
  8030f0:	83 c4 18             	add    $0x18,%esp
}
  8030f3:	c9                   	leave  
  8030f4:	c3                   	ret    

008030f5 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8030f5:	55                   	push   %ebp
  8030f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8030f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fb:	6a 00                	push   $0x0
  8030fd:	ff 75 14             	pushl  0x14(%ebp)
  803100:	ff 75 10             	pushl  0x10(%ebp)
  803103:	ff 75 0c             	pushl  0xc(%ebp)
  803106:	50                   	push   %eax
  803107:	6a 19                	push   $0x19
  803109:	e8 6d fd ff ff       	call   802e7b <syscall>
  80310e:	83 c4 18             	add    $0x18,%esp
}
  803111:	c9                   	leave  
  803112:	c3                   	ret    

00803113 <sys_run_env>:

void sys_run_env(int32 envId)
{
  803113:	55                   	push   %ebp
  803114:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  803116:	8b 45 08             	mov    0x8(%ebp),%eax
  803119:	6a 00                	push   $0x0
  80311b:	6a 00                	push   $0x0
  80311d:	6a 00                	push   $0x0
  80311f:	6a 00                	push   $0x0
  803121:	50                   	push   %eax
  803122:	6a 1a                	push   $0x1a
  803124:	e8 52 fd ff ff       	call   802e7b <syscall>
  803129:	83 c4 18             	add    $0x18,%esp
}
  80312c:	90                   	nop
  80312d:	c9                   	leave  
  80312e:	c3                   	ret    

0080312f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80312f:	55                   	push   %ebp
  803130:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  803132:	8b 45 08             	mov    0x8(%ebp),%eax
  803135:	6a 00                	push   $0x0
  803137:	6a 00                	push   $0x0
  803139:	6a 00                	push   $0x0
  80313b:	6a 00                	push   $0x0
  80313d:	50                   	push   %eax
  80313e:	6a 1b                	push   $0x1b
  803140:	e8 36 fd ff ff       	call   802e7b <syscall>
  803145:	83 c4 18             	add    $0x18,%esp
}
  803148:	c9                   	leave  
  803149:	c3                   	ret    

0080314a <sys_getenvid>:

int32 sys_getenvid(void)
{
  80314a:	55                   	push   %ebp
  80314b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80314d:	6a 00                	push   $0x0
  80314f:	6a 00                	push   $0x0
  803151:	6a 00                	push   $0x0
  803153:	6a 00                	push   $0x0
  803155:	6a 00                	push   $0x0
  803157:	6a 05                	push   $0x5
  803159:	e8 1d fd ff ff       	call   802e7b <syscall>
  80315e:	83 c4 18             	add    $0x18,%esp
}
  803161:	c9                   	leave  
  803162:	c3                   	ret    

00803163 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  803163:	55                   	push   %ebp
  803164:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  803166:	6a 00                	push   $0x0
  803168:	6a 00                	push   $0x0
  80316a:	6a 00                	push   $0x0
  80316c:	6a 00                	push   $0x0
  80316e:	6a 00                	push   $0x0
  803170:	6a 06                	push   $0x6
  803172:	e8 04 fd ff ff       	call   802e7b <syscall>
  803177:	83 c4 18             	add    $0x18,%esp
}
  80317a:	c9                   	leave  
  80317b:	c3                   	ret    

0080317c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80317c:	55                   	push   %ebp
  80317d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80317f:	6a 00                	push   $0x0
  803181:	6a 00                	push   $0x0
  803183:	6a 00                	push   $0x0
  803185:	6a 00                	push   $0x0
  803187:	6a 00                	push   $0x0
  803189:	6a 07                	push   $0x7
  80318b:	e8 eb fc ff ff       	call   802e7b <syscall>
  803190:	83 c4 18             	add    $0x18,%esp
}
  803193:	c9                   	leave  
  803194:	c3                   	ret    

00803195 <sys_exit_env>:


void sys_exit_env(void)
{
  803195:	55                   	push   %ebp
  803196:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  803198:	6a 00                	push   $0x0
  80319a:	6a 00                	push   $0x0
  80319c:	6a 00                	push   $0x0
  80319e:	6a 00                	push   $0x0
  8031a0:	6a 00                	push   $0x0
  8031a2:	6a 1c                	push   $0x1c
  8031a4:	e8 d2 fc ff ff       	call   802e7b <syscall>
  8031a9:	83 c4 18             	add    $0x18,%esp
}
  8031ac:	90                   	nop
  8031ad:	c9                   	leave  
  8031ae:	c3                   	ret    

008031af <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8031af:	55                   	push   %ebp
  8031b0:	89 e5                	mov    %esp,%ebp
  8031b2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8031b5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8031b8:	8d 50 04             	lea    0x4(%eax),%edx
  8031bb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8031be:	6a 00                	push   $0x0
  8031c0:	6a 00                	push   $0x0
  8031c2:	6a 00                	push   $0x0
  8031c4:	52                   	push   %edx
  8031c5:	50                   	push   %eax
  8031c6:	6a 1d                	push   $0x1d
  8031c8:	e8 ae fc ff ff       	call   802e7b <syscall>
  8031cd:	83 c4 18             	add    $0x18,%esp
	return result;
  8031d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8031d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8031d6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8031d9:	89 01                	mov    %eax,(%ecx)
  8031db:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8031de:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e1:	c9                   	leave  
  8031e2:	c2 04 00             	ret    $0x4

008031e5 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8031e5:	55                   	push   %ebp
  8031e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8031e8:	6a 00                	push   $0x0
  8031ea:	6a 00                	push   $0x0
  8031ec:	ff 75 10             	pushl  0x10(%ebp)
  8031ef:	ff 75 0c             	pushl  0xc(%ebp)
  8031f2:	ff 75 08             	pushl  0x8(%ebp)
  8031f5:	6a 13                	push   $0x13
  8031f7:	e8 7f fc ff ff       	call   802e7b <syscall>
  8031fc:	83 c4 18             	add    $0x18,%esp
	return ;
  8031ff:	90                   	nop
}
  803200:	c9                   	leave  
  803201:	c3                   	ret    

00803202 <sys_rcr2>:
uint32 sys_rcr2()
{
  803202:	55                   	push   %ebp
  803203:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  803205:	6a 00                	push   $0x0
  803207:	6a 00                	push   $0x0
  803209:	6a 00                	push   $0x0
  80320b:	6a 00                	push   $0x0
  80320d:	6a 00                	push   $0x0
  80320f:	6a 1e                	push   $0x1e
  803211:	e8 65 fc ff ff       	call   802e7b <syscall>
  803216:	83 c4 18             	add    $0x18,%esp
}
  803219:	c9                   	leave  
  80321a:	c3                   	ret    

0080321b <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80321b:	55                   	push   %ebp
  80321c:	89 e5                	mov    %esp,%ebp
  80321e:	83 ec 04             	sub    $0x4,%esp
  803221:	8b 45 08             	mov    0x8(%ebp),%eax
  803224:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803227:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80322b:	6a 00                	push   $0x0
  80322d:	6a 00                	push   $0x0
  80322f:	6a 00                	push   $0x0
  803231:	6a 00                	push   $0x0
  803233:	50                   	push   %eax
  803234:	6a 1f                	push   $0x1f
  803236:	e8 40 fc ff ff       	call   802e7b <syscall>
  80323b:	83 c4 18             	add    $0x18,%esp
	return ;
  80323e:	90                   	nop
}
  80323f:	c9                   	leave  
  803240:	c3                   	ret    

00803241 <rsttst>:
void rsttst()
{
  803241:	55                   	push   %ebp
  803242:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803244:	6a 00                	push   $0x0
  803246:	6a 00                	push   $0x0
  803248:	6a 00                	push   $0x0
  80324a:	6a 00                	push   $0x0
  80324c:	6a 00                	push   $0x0
  80324e:	6a 21                	push   $0x21
  803250:	e8 26 fc ff ff       	call   802e7b <syscall>
  803255:	83 c4 18             	add    $0x18,%esp
	return ;
  803258:	90                   	nop
}
  803259:	c9                   	leave  
  80325a:	c3                   	ret    

0080325b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80325b:	55                   	push   %ebp
  80325c:	89 e5                	mov    %esp,%ebp
  80325e:	83 ec 04             	sub    $0x4,%esp
  803261:	8b 45 14             	mov    0x14(%ebp),%eax
  803264:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803267:	8b 55 18             	mov    0x18(%ebp),%edx
  80326a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80326e:	52                   	push   %edx
  80326f:	50                   	push   %eax
  803270:	ff 75 10             	pushl  0x10(%ebp)
  803273:	ff 75 0c             	pushl  0xc(%ebp)
  803276:	ff 75 08             	pushl  0x8(%ebp)
  803279:	6a 20                	push   $0x20
  80327b:	e8 fb fb ff ff       	call   802e7b <syscall>
  803280:	83 c4 18             	add    $0x18,%esp
	return ;
  803283:	90                   	nop
}
  803284:	c9                   	leave  
  803285:	c3                   	ret    

00803286 <chktst>:
void chktst(uint32 n)
{
  803286:	55                   	push   %ebp
  803287:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803289:	6a 00                	push   $0x0
  80328b:	6a 00                	push   $0x0
  80328d:	6a 00                	push   $0x0
  80328f:	6a 00                	push   $0x0
  803291:	ff 75 08             	pushl  0x8(%ebp)
  803294:	6a 22                	push   $0x22
  803296:	e8 e0 fb ff ff       	call   802e7b <syscall>
  80329b:	83 c4 18             	add    $0x18,%esp
	return ;
  80329e:	90                   	nop
}
  80329f:	c9                   	leave  
  8032a0:	c3                   	ret    

008032a1 <inctst>:

void inctst()
{
  8032a1:	55                   	push   %ebp
  8032a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8032a4:	6a 00                	push   $0x0
  8032a6:	6a 00                	push   $0x0
  8032a8:	6a 00                	push   $0x0
  8032aa:	6a 00                	push   $0x0
  8032ac:	6a 00                	push   $0x0
  8032ae:	6a 23                	push   $0x23
  8032b0:	e8 c6 fb ff ff       	call   802e7b <syscall>
  8032b5:	83 c4 18             	add    $0x18,%esp
	return ;
  8032b8:	90                   	nop
}
  8032b9:	c9                   	leave  
  8032ba:	c3                   	ret    

008032bb <gettst>:
uint32 gettst()
{
  8032bb:	55                   	push   %ebp
  8032bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8032be:	6a 00                	push   $0x0
  8032c0:	6a 00                	push   $0x0
  8032c2:	6a 00                	push   $0x0
  8032c4:	6a 00                	push   $0x0
  8032c6:	6a 00                	push   $0x0
  8032c8:	6a 24                	push   $0x24
  8032ca:	e8 ac fb ff ff       	call   802e7b <syscall>
  8032cf:	83 c4 18             	add    $0x18,%esp
}
  8032d2:	c9                   	leave  
  8032d3:	c3                   	ret    

008032d4 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8032d4:	55                   	push   %ebp
  8032d5:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8032d7:	6a 00                	push   $0x0
  8032d9:	6a 00                	push   $0x0
  8032db:	6a 00                	push   $0x0
  8032dd:	6a 00                	push   $0x0
  8032df:	6a 00                	push   $0x0
  8032e1:	6a 25                	push   $0x25
  8032e3:	e8 93 fb ff ff       	call   802e7b <syscall>
  8032e8:	83 c4 18             	add    $0x18,%esp
  8032eb:	a3 80 50 83 00       	mov    %eax,0x835080
	return uheapPlaceStrategy ;
  8032f0:	a1 80 50 83 00       	mov    0x835080,%eax
}
  8032f5:	c9                   	leave  
  8032f6:	c3                   	ret    

008032f7 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8032f7:	55                   	push   %ebp
  8032f8:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8032fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fd:	a3 80 50 83 00       	mov    %eax,0x835080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803302:	6a 00                	push   $0x0
  803304:	6a 00                	push   $0x0
  803306:	6a 00                	push   $0x0
  803308:	6a 00                	push   $0x0
  80330a:	ff 75 08             	pushl  0x8(%ebp)
  80330d:	6a 26                	push   $0x26
  80330f:	e8 67 fb ff ff       	call   802e7b <syscall>
  803314:	83 c4 18             	add    $0x18,%esp
	return ;
  803317:	90                   	nop
}
  803318:	c9                   	leave  
  803319:	c3                   	ret    

0080331a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80331a:	55                   	push   %ebp
  80331b:	89 e5                	mov    %esp,%ebp
  80331d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80331e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803321:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803324:	8b 55 0c             	mov    0xc(%ebp),%edx
  803327:	8b 45 08             	mov    0x8(%ebp),%eax
  80332a:	6a 00                	push   $0x0
  80332c:	53                   	push   %ebx
  80332d:	51                   	push   %ecx
  80332e:	52                   	push   %edx
  80332f:	50                   	push   %eax
  803330:	6a 27                	push   $0x27
  803332:	e8 44 fb ff ff       	call   802e7b <syscall>
  803337:	83 c4 18             	add    $0x18,%esp
}
  80333a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80333d:	c9                   	leave  
  80333e:	c3                   	ret    

0080333f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80333f:	55                   	push   %ebp
  803340:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803342:	8b 55 0c             	mov    0xc(%ebp),%edx
  803345:	8b 45 08             	mov    0x8(%ebp),%eax
  803348:	6a 00                	push   $0x0
  80334a:	6a 00                	push   $0x0
  80334c:	6a 00                	push   $0x0
  80334e:	52                   	push   %edx
  80334f:	50                   	push   %eax
  803350:	6a 28                	push   $0x28
  803352:	e8 24 fb ff ff       	call   802e7b <syscall>
  803357:	83 c4 18             	add    $0x18,%esp
}
  80335a:	c9                   	leave  
  80335b:	c3                   	ret    

0080335c <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80335c:	55                   	push   %ebp
  80335d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80335f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803362:	8b 55 0c             	mov    0xc(%ebp),%edx
  803365:	8b 45 08             	mov    0x8(%ebp),%eax
  803368:	6a 00                	push   $0x0
  80336a:	51                   	push   %ecx
  80336b:	ff 75 10             	pushl  0x10(%ebp)
  80336e:	52                   	push   %edx
  80336f:	50                   	push   %eax
  803370:	6a 29                	push   $0x29
  803372:	e8 04 fb ff ff       	call   802e7b <syscall>
  803377:	83 c4 18             	add    $0x18,%esp
}
  80337a:	c9                   	leave  
  80337b:	c3                   	ret    

0080337c <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80337c:	55                   	push   %ebp
  80337d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80337f:	6a 00                	push   $0x0
  803381:	6a 00                	push   $0x0
  803383:	ff 75 10             	pushl  0x10(%ebp)
  803386:	ff 75 0c             	pushl  0xc(%ebp)
  803389:	ff 75 08             	pushl  0x8(%ebp)
  80338c:	6a 12                	push   $0x12
  80338e:	e8 e8 fa ff ff       	call   802e7b <syscall>
  803393:	83 c4 18             	add    $0x18,%esp
	return ;
  803396:	90                   	nop
}
  803397:	c9                   	leave  
  803398:	c3                   	ret    

00803399 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  803399:	55                   	push   %ebp
  80339a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80339c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80339f:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a2:	6a 00                	push   $0x0
  8033a4:	6a 00                	push   $0x0
  8033a6:	6a 00                	push   $0x0
  8033a8:	52                   	push   %edx
  8033a9:	50                   	push   %eax
  8033aa:	6a 2a                	push   $0x2a
  8033ac:	e8 ca fa ff ff       	call   802e7b <syscall>
  8033b1:	83 c4 18             	add    $0x18,%esp
	return;
  8033b4:	90                   	nop
}
  8033b5:	c9                   	leave  
  8033b6:	c3                   	ret    

008033b7 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8033b7:	55                   	push   %ebp
  8033b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8033ba:	6a 00                	push   $0x0
  8033bc:	6a 00                	push   $0x0
  8033be:	6a 00                	push   $0x0
  8033c0:	6a 00                	push   $0x0
  8033c2:	6a 00                	push   $0x0
  8033c4:	6a 2b                	push   $0x2b
  8033c6:	e8 b0 fa ff ff       	call   802e7b <syscall>
  8033cb:	83 c4 18             	add    $0x18,%esp
}
  8033ce:	c9                   	leave  
  8033cf:	c3                   	ret    

008033d0 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8033d0:	55                   	push   %ebp
  8033d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8033d3:	6a 00                	push   $0x0
  8033d5:	6a 00                	push   $0x0
  8033d7:	6a 00                	push   $0x0
  8033d9:	ff 75 0c             	pushl  0xc(%ebp)
  8033dc:	ff 75 08             	pushl  0x8(%ebp)
  8033df:	6a 2d                	push   $0x2d
  8033e1:	e8 95 fa ff ff       	call   802e7b <syscall>
  8033e6:	83 c4 18             	add    $0x18,%esp
	return;
  8033e9:	90                   	nop
}
  8033ea:	c9                   	leave  
  8033eb:	c3                   	ret    

008033ec <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8033ec:	55                   	push   %ebp
  8033ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8033ef:	6a 00                	push   $0x0
  8033f1:	6a 00                	push   $0x0
  8033f3:	6a 00                	push   $0x0
  8033f5:	ff 75 0c             	pushl  0xc(%ebp)
  8033f8:	ff 75 08             	pushl  0x8(%ebp)
  8033fb:	6a 2c                	push   $0x2c
  8033fd:	e8 79 fa ff ff       	call   802e7b <syscall>
  803402:	83 c4 18             	add    $0x18,%esp
	return ;
  803405:	90                   	nop
}
  803406:	c9                   	leave  
  803407:	c3                   	ret    

00803408 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  803408:	55                   	push   %ebp
  803409:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80340b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80340e:	8b 45 08             	mov    0x8(%ebp),%eax
  803411:	6a 00                	push   $0x0
  803413:	6a 00                	push   $0x0
  803415:	6a 00                	push   $0x0
  803417:	52                   	push   %edx
  803418:	50                   	push   %eax
  803419:	6a 2e                	push   $0x2e
  80341b:	e8 5b fa ff ff       	call   802e7b <syscall>
  803420:	83 c4 18             	add    $0x18,%esp
}
  803423:	90                   	nop
  803424:	c9                   	leave  
  803425:	c3                   	ret    

00803426 <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  803426:	55                   	push   %ebp
  803427:	89 e5                	mov    %esp,%ebp
  803429:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  80342c:	81 7d 08 80 d0 81 00 	cmpl   $0x81d080,0x8(%ebp)
  803433:	72 09                	jb     80343e <to_page_va+0x18>
  803435:	81 7d 08 80 50 83 00 	cmpl   $0x835080,0x8(%ebp)
  80343c:	72 14                	jb     803452 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  80343e:	83 ec 04             	sub    $0x4,%esp
  803441:	68 98 49 80 00       	push   $0x804998
  803446:	6a 15                	push   $0x15
  803448:	68 c3 49 80 00       	push   $0x8049c3
  80344d:	e8 10 d0 ff ff       	call   800462 <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803452:	8b 45 08             	mov    0x8(%ebp),%eax
  803455:	ba 80 d0 81 00       	mov    $0x81d080,%edx
  80345a:	29 d0                	sub    %edx,%eax
  80345c:	c1 f8 02             	sar    $0x2,%eax
  80345f:	89 c2                	mov    %eax,%edx
  803461:	89 d0                	mov    %edx,%eax
  803463:	c1 e0 02             	shl    $0x2,%eax
  803466:	01 d0                	add    %edx,%eax
  803468:	c1 e0 02             	shl    $0x2,%eax
  80346b:	01 d0                	add    %edx,%eax
  80346d:	c1 e0 02             	shl    $0x2,%eax
  803470:	01 d0                	add    %edx,%eax
  803472:	89 c1                	mov    %eax,%ecx
  803474:	c1 e1 08             	shl    $0x8,%ecx
  803477:	01 c8                	add    %ecx,%eax
  803479:	89 c1                	mov    %eax,%ecx
  80347b:	c1 e1 10             	shl    $0x10,%ecx
  80347e:	01 c8                	add    %ecx,%eax
  803480:	01 c0                	add    %eax,%eax
  803482:	01 d0                	add    %edx,%eax
  803484:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  803487:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80348a:	c1 e0 0c             	shl    $0xc,%eax
  80348d:	89 c2                	mov    %eax,%edx
  80348f:	a1 84 50 83 00       	mov    0x835084,%eax
  803494:	01 d0                	add    %edx,%eax
}
  803496:	c9                   	leave  
  803497:	c3                   	ret    

00803498 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  803498:	55                   	push   %ebp
  803499:	89 e5                	mov    %esp,%ebp
  80349b:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  80349e:	a1 84 50 83 00       	mov    0x835084,%eax
  8034a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8034a6:	29 c2                	sub    %eax,%edx
  8034a8:	89 d0                	mov    %edx,%eax
  8034aa:	c1 e8 0c             	shr    $0xc,%eax
  8034ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  8034b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034b4:	78 09                	js     8034bf <to_page_info+0x27>
  8034b6:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  8034bd:	7e 14                	jle    8034d3 <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  8034bf:	83 ec 04             	sub    $0x4,%esp
  8034c2:	68 dc 49 80 00       	push   $0x8049dc
  8034c7:	6a 21                	push   $0x21
  8034c9:	68 c3 49 80 00       	push   $0x8049c3
  8034ce:	e8 8f cf ff ff       	call   800462 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  8034d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034d6:	89 d0                	mov    %edx,%eax
  8034d8:	01 c0                	add    %eax,%eax
  8034da:	01 d0                	add    %edx,%eax
  8034dc:	c1 e0 02             	shl    $0x2,%eax
  8034df:	05 80 d0 81 00       	add    $0x81d080,%eax
}
  8034e4:	c9                   	leave  
  8034e5:	c3                   	ret    

008034e6 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8034e6:	55                   	push   %ebp
  8034e7:	89 e5                	mov    %esp,%ebp
  8034e9:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8034ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ef:	05 00 00 00 02       	add    $0x2000000,%eax
  8034f4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8034f7:	73 16                	jae    80350f <initialize_dynamic_allocator+0x29>
  8034f9:	68 00 4a 80 00       	push   $0x804a00
  8034fe:	68 26 4a 80 00       	push   $0x804a26
  803503:	6a 2f                	push   $0x2f
  803505:	68 c3 49 80 00       	push   $0x8049c3
  80350a:	e8 53 cf ff ff       	call   800462 <_panic>
	dynAllocStart = daStart;
  80350f:	8b 45 08             	mov    0x8(%ebp),%eax
  803512:	a3 84 50 83 00       	mov    %eax,0x835084
	dynAllocEnd = daEnd;
  803517:	8b 45 0c             	mov    0xc(%ebp),%eax
  80351a:	a3 60 d0 81 00       	mov    %eax,0x81d060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  80351f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803526:	eb 36                	jmp    80355e <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  803528:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80352b:	c1 e0 04             	shl    $0x4,%eax
  80352e:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803533:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803539:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80353c:	c1 e0 04             	shl    $0x4,%eax
  80353f:	05 a4 50 83 00       	add    $0x8350a4,%eax
  803544:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80354a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354d:	c1 e0 04             	shl    $0x4,%eax
  803550:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803555:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  80355b:	ff 45 f4             	incl   -0xc(%ebp)
  80355e:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  803562:	7e c4                	jle    803528 <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  803564:	c7 05 68 d0 81 00 00 	movl   $0x0,0x81d068
  80356b:	00 00 00 
  80356e:	c7 05 6c d0 81 00 00 	movl   $0x0,0x81d06c
  803575:	00 00 00 
  803578:	c7 05 74 d0 81 00 00 	movl   $0x0,0x81d074
  80357f:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803582:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803589:	e9 1b 01 00 00       	jmp    8036a9 <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  80358e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803591:	89 d0                	mov    %edx,%eax
  803593:	01 c0                	add    %eax,%eax
  803595:	01 d0                	add    %edx,%eax
  803597:	c1 e0 02             	shl    $0x2,%eax
  80359a:	05 88 d0 81 00       	add    $0x81d088,%eax
  80359f:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  8035a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035a7:	89 d0                	mov    %edx,%eax
  8035a9:	01 c0                	add    %eax,%eax
  8035ab:	01 d0                	add    %edx,%eax
  8035ad:	c1 e0 02             	shl    $0x2,%eax
  8035b0:	05 8a d0 81 00       	add    $0x81d08a,%eax
  8035b5:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  8035ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035bd:	89 d0                	mov    %edx,%eax
  8035bf:	01 c0                	add    %eax,%eax
  8035c1:	01 d0                	add    %edx,%eax
  8035c3:	c1 e0 02             	shl    $0x2,%eax
  8035c6:	05 80 d0 81 00       	add    $0x81d080,%eax
  8035cb:	8b 00                	mov    (%eax),%eax
  8035cd:	85 c0                	test   %eax,%eax
  8035cf:	74 2b                	je     8035fc <initialize_dynamic_allocator+0x116>
  8035d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035d4:	89 d0                	mov    %edx,%eax
  8035d6:	01 c0                	add    %eax,%eax
  8035d8:	01 d0                	add    %edx,%eax
  8035da:	c1 e0 02             	shl    $0x2,%eax
  8035dd:	05 80 d0 81 00       	add    $0x81d080,%eax
  8035e2:	8b 10                	mov    (%eax),%edx
  8035e4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8035e7:	89 c8                	mov    %ecx,%eax
  8035e9:	01 c0                	add    %eax,%eax
  8035eb:	01 c8                	add    %ecx,%eax
  8035ed:	c1 e0 02             	shl    $0x2,%eax
  8035f0:	05 84 d0 81 00       	add    $0x81d084,%eax
  8035f5:	8b 00                	mov    (%eax),%eax
  8035f7:	89 42 04             	mov    %eax,0x4(%edx)
  8035fa:	eb 18                	jmp    803614 <initialize_dynamic_allocator+0x12e>
  8035fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035ff:	89 d0                	mov    %edx,%eax
  803601:	01 c0                	add    %eax,%eax
  803603:	01 d0                	add    %edx,%eax
  803605:	c1 e0 02             	shl    $0x2,%eax
  803608:	05 84 d0 81 00       	add    $0x81d084,%eax
  80360d:	8b 00                	mov    (%eax),%eax
  80360f:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803614:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803617:	89 d0                	mov    %edx,%eax
  803619:	01 c0                	add    %eax,%eax
  80361b:	01 d0                	add    %edx,%eax
  80361d:	c1 e0 02             	shl    $0x2,%eax
  803620:	05 84 d0 81 00       	add    $0x81d084,%eax
  803625:	8b 00                	mov    (%eax),%eax
  803627:	85 c0                	test   %eax,%eax
  803629:	74 2a                	je     803655 <initialize_dynamic_allocator+0x16f>
  80362b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80362e:	89 d0                	mov    %edx,%eax
  803630:	01 c0                	add    %eax,%eax
  803632:	01 d0                	add    %edx,%eax
  803634:	c1 e0 02             	shl    $0x2,%eax
  803637:	05 84 d0 81 00       	add    $0x81d084,%eax
  80363c:	8b 10                	mov    (%eax),%edx
  80363e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803641:	89 c8                	mov    %ecx,%eax
  803643:	01 c0                	add    %eax,%eax
  803645:	01 c8                	add    %ecx,%eax
  803647:	c1 e0 02             	shl    $0x2,%eax
  80364a:	05 80 d0 81 00       	add    $0x81d080,%eax
  80364f:	8b 00                	mov    (%eax),%eax
  803651:	89 02                	mov    %eax,(%edx)
  803653:	eb 18                	jmp    80366d <initialize_dynamic_allocator+0x187>
  803655:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803658:	89 d0                	mov    %edx,%eax
  80365a:	01 c0                	add    %eax,%eax
  80365c:	01 d0                	add    %edx,%eax
  80365e:	c1 e0 02             	shl    $0x2,%eax
  803661:	05 80 d0 81 00       	add    $0x81d080,%eax
  803666:	8b 00                	mov    (%eax),%eax
  803668:	a3 68 d0 81 00       	mov    %eax,0x81d068
  80366d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803670:	89 d0                	mov    %edx,%eax
  803672:	01 c0                	add    %eax,%eax
  803674:	01 d0                	add    %edx,%eax
  803676:	c1 e0 02             	shl    $0x2,%eax
  803679:	05 80 d0 81 00       	add    $0x81d080,%eax
  80367e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803684:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803687:	89 d0                	mov    %edx,%eax
  803689:	01 c0                	add    %eax,%eax
  80368b:	01 d0                	add    %edx,%eax
  80368d:	c1 e0 02             	shl    $0x2,%eax
  803690:	05 84 d0 81 00       	add    $0x81d084,%eax
  803695:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80369b:	a1 74 d0 81 00       	mov    0x81d074,%eax
  8036a0:	48                   	dec    %eax
  8036a1:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  8036a6:	ff 45 f0             	incl   -0x10(%ebp)
  8036a9:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  8036b0:	0f 8e d8 fe ff ff    	jle    80358e <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  8036b6:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  8036bd:	e9 9d 00 00 00       	jmp    80375f <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  8036c2:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8036c8:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  8036cb:	89 c8                	mov    %ecx,%eax
  8036cd:	01 c0                	add    %eax,%eax
  8036cf:	01 c8                	add    %ecx,%eax
  8036d1:	c1 e0 02             	shl    $0x2,%eax
  8036d4:	05 80 d0 81 00       	add    $0x81d080,%eax
  8036d9:	89 10                	mov    %edx,(%eax)
  8036db:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036de:	89 d0                	mov    %edx,%eax
  8036e0:	01 c0                	add    %eax,%eax
  8036e2:	01 d0                	add    %edx,%eax
  8036e4:	c1 e0 02             	shl    $0x2,%eax
  8036e7:	05 80 d0 81 00       	add    $0x81d080,%eax
  8036ec:	8b 00                	mov    (%eax),%eax
  8036ee:	85 c0                	test   %eax,%eax
  8036f0:	74 1c                	je     80370e <initialize_dynamic_allocator+0x228>
  8036f2:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8036f8:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  8036fb:	89 c8                	mov    %ecx,%eax
  8036fd:	01 c0                	add    %eax,%eax
  8036ff:	01 c8                	add    %ecx,%eax
  803701:	c1 e0 02             	shl    $0x2,%eax
  803704:	05 80 d0 81 00       	add    $0x81d080,%eax
  803709:	89 42 04             	mov    %eax,0x4(%edx)
  80370c:	eb 16                	jmp    803724 <initialize_dynamic_allocator+0x23e>
  80370e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803711:	89 d0                	mov    %edx,%eax
  803713:	01 c0                	add    %eax,%eax
  803715:	01 d0                	add    %edx,%eax
  803717:	c1 e0 02             	shl    $0x2,%eax
  80371a:	05 80 d0 81 00       	add    $0x81d080,%eax
  80371f:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803724:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803727:	89 d0                	mov    %edx,%eax
  803729:	01 c0                	add    %eax,%eax
  80372b:	01 d0                	add    %edx,%eax
  80372d:	c1 e0 02             	shl    $0x2,%eax
  803730:	05 80 d0 81 00       	add    $0x81d080,%eax
  803735:	a3 68 d0 81 00       	mov    %eax,0x81d068
  80373a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80373d:	89 d0                	mov    %edx,%eax
  80373f:	01 c0                	add    %eax,%eax
  803741:	01 d0                	add    %edx,%eax
  803743:	c1 e0 02             	shl    $0x2,%eax
  803746:	05 84 d0 81 00       	add    $0x81d084,%eax
  80374b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803751:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803756:	40                   	inc    %eax
  803757:	a3 74 d0 81 00       	mov    %eax,0x81d074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  80375c:	ff 4d ec             	decl   -0x14(%ebp)
  80375f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803763:	0f 89 59 ff ff ff    	jns    8036c2 <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  803769:	c7 05 44 d0 81 00 01 	movl   $0x1,0x81d044
  803770:	00 00 00 
}
  803773:	90                   	nop
  803774:	c9                   	leave  
  803775:	c3                   	ret    

00803776 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  803776:	55                   	push   %ebp
  803777:	89 e5                	mov    %esp,%ebp
  803779:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  80377c:	8b 45 08             	mov    0x8(%ebp),%eax
  80377f:	83 ec 0c             	sub    $0xc,%esp
  803782:	50                   	push   %eax
  803783:	e8 10 fd ff ff       	call   803498 <to_page_info>
  803788:	83 c4 10             	add    $0x10,%esp
  80378b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  80378e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803791:	8b 40 08             	mov    0x8(%eax),%eax
  803794:	0f b7 c0             	movzwl %ax,%eax
}
  803797:	c9                   	leave  
  803798:	c3                   	ret    

00803799 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803799:	55                   	push   %ebp
  80379a:	89 e5                	mov    %esp,%ebp
  80379c:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  80379f:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8037a6:	76 16                	jbe    8037be <alloc_block+0x25>
  8037a8:	68 3c 4a 80 00       	push   $0x804a3c
  8037ad:	68 26 4a 80 00       	push   $0x804a26
  8037b2:	6a 59                	push   $0x59
  8037b4:	68 c3 49 80 00       	push   $0x8049c3
  8037b9:	e8 a4 cc ff ff       	call   800462 <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  8037be:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  8037c5:	eb 08                	jmp    8037cf <alloc_block+0x36>
		allocSize <<= 1;
  8037c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ca:	01 c0                	add    %eax,%eax
  8037cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  8037cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037d5:	73 09                	jae    8037e0 <alloc_block+0x47>
  8037d7:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  8037de:	76 e7                	jbe    8037c7 <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  8037e0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  8037e7:	eb 03                	jmp    8037ec <alloc_block+0x53>
		listIndex++;
  8037e9:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  8037ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037ef:	ba 08 00 00 00       	mov    $0x8,%edx
  8037f4:	88 c1                	mov    %al,%cl
  8037f6:	d3 e2                	shl    %cl,%edx
  8037f8:	89 d0                	mov    %edx,%eax
  8037fa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8037fd:	72 ea                	jb     8037e9 <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8037ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803802:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803805:	e9 f4 00 00 00       	jmp    8038fe <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  80380a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80380d:	c1 e0 04             	shl    $0x4,%eax
  803810:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803815:	8b 00                	mov    (%eax),%eax
  803817:	85 c0                	test   %eax,%eax
  803819:	0f 84 dc 00 00 00    	je     8038fb <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  80381f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803822:	c1 e0 04             	shl    $0x4,%eax
  803825:	05 a0 50 83 00       	add    $0x8350a0,%eax
  80382a:	8b 00                	mov    (%eax),%eax
  80382c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  80382f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803833:	75 14                	jne    803849 <alloc_block+0xb0>
  803835:	83 ec 04             	sub    $0x4,%esp
  803838:	68 5d 4a 80 00       	push   $0x804a5d
  80383d:	6a 6b                	push   $0x6b
  80383f:	68 c3 49 80 00       	push   $0x8049c3
  803844:	e8 19 cc ff ff       	call   800462 <_panic>
  803849:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80384c:	8b 00                	mov    (%eax),%eax
  80384e:	85 c0                	test   %eax,%eax
  803850:	74 10                	je     803862 <alloc_block+0xc9>
  803852:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803855:	8b 00                	mov    (%eax),%eax
  803857:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80385a:	8b 52 04             	mov    0x4(%edx),%edx
  80385d:	89 50 04             	mov    %edx,0x4(%eax)
  803860:	eb 14                	jmp    803876 <alloc_block+0xdd>
  803862:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803865:	8b 40 04             	mov    0x4(%eax),%eax
  803868:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80386b:	c1 e2 04             	shl    $0x4,%edx
  80386e:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803874:	89 02                	mov    %eax,(%edx)
  803876:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803879:	8b 40 04             	mov    0x4(%eax),%eax
  80387c:	85 c0                	test   %eax,%eax
  80387e:	74 0f                	je     80388f <alloc_block+0xf6>
  803880:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803883:	8b 40 04             	mov    0x4(%eax),%eax
  803886:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803889:	8b 12                	mov    (%edx),%edx
  80388b:	89 10                	mov    %edx,(%eax)
  80388d:	eb 13                	jmp    8038a2 <alloc_block+0x109>
  80388f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803892:	8b 00                	mov    (%eax),%eax
  803894:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803897:	c1 e2 04             	shl    $0x4,%edx
  80389a:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  8038a0:	89 02                	mov    %eax,(%edx)
  8038a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038b8:	c1 e0 04             	shl    $0x4,%eax
  8038bb:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8038c0:	8b 00                	mov    (%eax),%eax
  8038c2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8038c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038c8:	c1 e0 04             	shl    $0x4,%eax
  8038cb:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8038d0:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  8038d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038d5:	83 ec 0c             	sub    $0xc,%esp
  8038d8:	50                   	push   %eax
  8038d9:	e8 ba fb ff ff       	call   803498 <to_page_info>
  8038de:	83 c4 10             	add    $0x10,%esp
  8038e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  8038e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038e7:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8038eb:	48                   	dec    %eax
  8038ec:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8038ef:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  8038f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f6:	e9 8f 02 00 00       	jmp    803b8a <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8038fb:	ff 45 ec             	incl   -0x14(%ebp)
  8038fe:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803902:	0f 8e 02 ff ff ff    	jle    80380a <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  803908:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80390d:	85 c0                	test   %eax,%eax
  80390f:	75 14                	jne    803925 <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  803911:	83 ec 04             	sub    $0x4,%esp
  803914:	68 7c 4a 80 00       	push   $0x804a7c
  803919:	6a 77                	push   $0x77
  80391b:	68 c3 49 80 00       	push   $0x8049c3
  803920:	e8 3d cb ff ff       	call   800462 <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  803925:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80392a:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  80392d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803931:	75 14                	jne    803947 <alloc_block+0x1ae>
  803933:	83 ec 04             	sub    $0x4,%esp
  803936:	68 5d 4a 80 00       	push   $0x804a5d
  80393b:	6a 7a                	push   $0x7a
  80393d:	68 c3 49 80 00       	push   $0x8049c3
  803942:	e8 1b cb ff ff       	call   800462 <_panic>
  803947:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80394a:	8b 00                	mov    (%eax),%eax
  80394c:	85 c0                	test   %eax,%eax
  80394e:	74 10                	je     803960 <alloc_block+0x1c7>
  803950:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803953:	8b 00                	mov    (%eax),%eax
  803955:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803958:	8b 52 04             	mov    0x4(%edx),%edx
  80395b:	89 50 04             	mov    %edx,0x4(%eax)
  80395e:	eb 0b                	jmp    80396b <alloc_block+0x1d2>
  803960:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803963:	8b 40 04             	mov    0x4(%eax),%eax
  803966:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  80396b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80396e:	8b 40 04             	mov    0x4(%eax),%eax
  803971:	85 c0                	test   %eax,%eax
  803973:	74 0f                	je     803984 <alloc_block+0x1eb>
  803975:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803978:	8b 40 04             	mov    0x4(%eax),%eax
  80397b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80397e:	8b 12                	mov    (%edx),%edx
  803980:	89 10                	mov    %edx,(%eax)
  803982:	eb 0a                	jmp    80398e <alloc_block+0x1f5>
  803984:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803987:	8b 00                	mov    (%eax),%eax
  803989:	a3 68 d0 81 00       	mov    %eax,0x81d068
  80398e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803991:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803997:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80399a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039a1:	a1 74 d0 81 00       	mov    0x81d074,%eax
  8039a6:	48                   	dec    %eax
  8039a7:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  8039ac:	83 ec 0c             	sub    $0xc,%esp
  8039af:	ff 75 dc             	pushl  -0x24(%ebp)
  8039b2:	e8 6f fa ff ff       	call   803426 <to_page_va>
  8039b7:	83 c4 10             	add    $0x10,%esp
  8039ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  8039bd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8039c0:	83 ec 0c             	sub    $0xc,%esp
  8039c3:	50                   	push   %eax
  8039c4:	e8 a0 dc ff ff       	call   801669 <get_page>
  8039c9:	83 c4 10             	add    $0x10,%esp
  8039cc:	85 c0                	test   %eax,%eax
  8039ce:	74 14                	je     8039e4 <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  8039d0:	83 ec 04             	sub    $0x4,%esp
  8039d3:	68 a4 4a 80 00       	push   $0x804aa4
  8039d8:	6a 7f                	push   $0x7f
  8039da:	68 c3 49 80 00       	push   $0x8049c3
  8039df:	e8 7e ca ff ff       	call   800462 <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  8039e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039e7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8039ea:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  8039ee:	b8 00 10 00 00       	mov    $0x1000,%eax
  8039f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8039f8:	f7 75 f4             	divl   -0xc(%ebp)
  8039fb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8039fe:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803a02:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803a09:	e9 a7 00 00 00       	jmp    803ab5 <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  803a0e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803a11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a14:	01 d0                	add    %edx,%eax
  803a16:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  803a19:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803a1d:	75 17                	jne    803a36 <alloc_block+0x29d>
  803a1f:	83 ec 04             	sub    $0x4,%esp
  803a22:	68 cc 4a 80 00       	push   $0x804acc
  803a27:	68 88 00 00 00       	push   $0x88
  803a2c:	68 c3 49 80 00       	push   $0x8049c3
  803a31:	e8 2c ca ff ff       	call   800462 <_panic>
  803a36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a39:	c1 e0 04             	shl    $0x4,%eax
  803a3c:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803a41:	8b 10                	mov    (%eax),%edx
  803a43:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a46:	89 10                	mov    %edx,(%eax)
  803a48:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a4b:	8b 00                	mov    (%eax),%eax
  803a4d:	85 c0                	test   %eax,%eax
  803a4f:	74 15                	je     803a66 <alloc_block+0x2cd>
  803a51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a54:	c1 e0 04             	shl    $0x4,%eax
  803a57:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803a5c:	8b 00                	mov    (%eax),%eax
  803a5e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a61:	89 50 04             	mov    %edx,0x4(%eax)
  803a64:	eb 11                	jmp    803a77 <alloc_block+0x2de>
  803a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a69:	c1 e0 04             	shl    $0x4,%eax
  803a6c:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803a72:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a75:	89 02                	mov    %eax,(%edx)
  803a77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a7a:	c1 e0 04             	shl    $0x4,%eax
  803a7d:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803a83:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a86:	89 02                	mov    %eax,(%edx)
  803a88:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a8b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a95:	c1 e0 04             	shl    $0x4,%eax
  803a98:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803a9d:	8b 00                	mov    (%eax),%eax
  803a9f:	8d 50 01             	lea    0x1(%eax),%edx
  803aa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803aa5:	c1 e0 04             	shl    $0x4,%eax
  803aa8:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803aad:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ab2:	01 45 e8             	add    %eax,-0x18(%ebp)
  803ab5:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  803abc:	0f 86 4c ff ff ff    	jbe    803a0e <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  803ac2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ac5:	c1 e0 04             	shl    $0x4,%eax
  803ac8:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803acd:	8b 00                	mov    (%eax),%eax
  803acf:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  803ad2:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803ad6:	75 17                	jne    803aef <alloc_block+0x356>
  803ad8:	83 ec 04             	sub    $0x4,%esp
  803adb:	68 5d 4a 80 00       	push   $0x804a5d
  803ae0:	68 8d 00 00 00       	push   $0x8d
  803ae5:	68 c3 49 80 00       	push   $0x8049c3
  803aea:	e8 73 c9 ff ff       	call   800462 <_panic>
  803aef:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803af2:	8b 00                	mov    (%eax),%eax
  803af4:	85 c0                	test   %eax,%eax
  803af6:	74 10                	je     803b08 <alloc_block+0x36f>
  803af8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803afb:	8b 00                	mov    (%eax),%eax
  803afd:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803b00:	8b 52 04             	mov    0x4(%edx),%edx
  803b03:	89 50 04             	mov    %edx,0x4(%eax)
  803b06:	eb 14                	jmp    803b1c <alloc_block+0x383>
  803b08:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b0b:	8b 40 04             	mov    0x4(%eax),%eax
  803b0e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b11:	c1 e2 04             	shl    $0x4,%edx
  803b14:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803b1a:	89 02                	mov    %eax,(%edx)
  803b1c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b1f:	8b 40 04             	mov    0x4(%eax),%eax
  803b22:	85 c0                	test   %eax,%eax
  803b24:	74 0f                	je     803b35 <alloc_block+0x39c>
  803b26:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b29:	8b 40 04             	mov    0x4(%eax),%eax
  803b2c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803b2f:	8b 12                	mov    (%edx),%edx
  803b31:	89 10                	mov    %edx,(%eax)
  803b33:	eb 13                	jmp    803b48 <alloc_block+0x3af>
  803b35:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b38:	8b 00                	mov    (%eax),%eax
  803b3a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b3d:	c1 e2 04             	shl    $0x4,%edx
  803b40:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803b46:	89 02                	mov    %eax,(%edx)
  803b48:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b4b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b51:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b54:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b5e:	c1 e0 04             	shl    $0x4,%eax
  803b61:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803b66:	8b 00                	mov    (%eax),%eax
  803b68:	8d 50 ff             	lea    -0x1(%eax),%edx
  803b6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b6e:	c1 e0 04             	shl    $0x4,%eax
  803b71:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803b76:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  803b78:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b7b:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803b7f:	48                   	dec    %eax
  803b80:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803b83:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  803b87:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  803b8a:	c9                   	leave  
  803b8b:	c3                   	ret    

00803b8c <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803b8c:	55                   	push   %ebp
  803b8d:	89 e5                	mov    %esp,%ebp
  803b8f:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803b92:	8b 55 08             	mov    0x8(%ebp),%edx
  803b95:	a1 84 50 83 00       	mov    0x835084,%eax
  803b9a:	39 c2                	cmp    %eax,%edx
  803b9c:	72 0c                	jb     803baa <free_block+0x1e>
  803b9e:	8b 55 08             	mov    0x8(%ebp),%edx
  803ba1:	a1 60 d0 81 00       	mov    0x81d060,%eax
  803ba6:	39 c2                	cmp    %eax,%edx
  803ba8:	72 19                	jb     803bc3 <free_block+0x37>
  803baa:	68 f0 4a 80 00       	push   $0x804af0
  803baf:	68 26 4a 80 00       	push   $0x804a26
  803bb4:	68 98 00 00 00       	push   $0x98
  803bb9:	68 c3 49 80 00       	push   $0x8049c3
  803bbe:	e8 9f c8 ff ff       	call   800462 <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  803bc6:	83 ec 0c             	sub    $0xc,%esp
  803bc9:	50                   	push   %eax
  803bca:	e8 c9 f8 ff ff       	call   803498 <to_page_info>
  803bcf:	83 c4 10             	add    $0x10,%esp
  803bd2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  803bd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bd8:	8b 40 08             	mov    0x8(%eax),%eax
  803bdb:	0f b7 c0             	movzwl %ax,%eax
  803bde:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  803be1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803be8:	eb 03                	jmp    803bed <free_block+0x61>
		listIndex++;
  803bea:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bf0:	ba 08 00 00 00       	mov    $0x8,%edx
  803bf5:	88 c1                	mov    %al,%cl
  803bf7:	d3 e2                	shl    %cl,%edx
  803bf9:	89 d0                	mov    %edx,%eax
  803bfb:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803bfe:	72 ea                	jb     803bea <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  803c00:	8b 45 08             	mov    0x8(%ebp),%eax
  803c03:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  803c06:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c0a:	75 17                	jne    803c23 <free_block+0x97>
  803c0c:	83 ec 04             	sub    $0x4,%esp
  803c0f:	68 cc 4a 80 00       	push   $0x804acc
  803c14:	68 a2 00 00 00       	push   $0xa2
  803c19:	68 c3 49 80 00       	push   $0x8049c3
  803c1e:	e8 3f c8 ff ff       	call   800462 <_panic>
  803c23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c26:	c1 e0 04             	shl    $0x4,%eax
  803c29:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803c2e:	8b 10                	mov    (%eax),%edx
  803c30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c33:	89 10                	mov    %edx,(%eax)
  803c35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c38:	8b 00                	mov    (%eax),%eax
  803c3a:	85 c0                	test   %eax,%eax
  803c3c:	74 15                	je     803c53 <free_block+0xc7>
  803c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c41:	c1 e0 04             	shl    $0x4,%eax
  803c44:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803c49:	8b 00                	mov    (%eax),%eax
  803c4b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c4e:	89 50 04             	mov    %edx,0x4(%eax)
  803c51:	eb 11                	jmp    803c64 <free_block+0xd8>
  803c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c56:	c1 e0 04             	shl    $0x4,%eax
  803c59:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803c5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c62:	89 02                	mov    %eax,(%edx)
  803c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c67:	c1 e0 04             	shl    $0x4,%eax
  803c6a:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803c70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c73:	89 02                	mov    %eax,(%edx)
  803c75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c78:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c82:	c1 e0 04             	shl    $0x4,%eax
  803c85:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803c8a:	8b 00                	mov    (%eax),%eax
  803c8c:	8d 50 01             	lea    0x1(%eax),%edx
  803c8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c92:	c1 e0 04             	shl    $0x4,%eax
  803c95:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803c9a:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  803c9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c9f:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803ca3:	40                   	inc    %eax
  803ca4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803ca7:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  803cab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cae:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803cb2:	0f b7 c8             	movzwl %ax,%ecx
  803cb5:	b8 00 10 00 00       	mov    $0x1000,%eax
  803cba:	ba 00 00 00 00       	mov    $0x0,%edx
  803cbf:	f7 75 e8             	divl   -0x18(%ebp)
  803cc2:	39 c1                	cmp    %eax,%ecx
  803cc4:	0f 85 ed 01 00 00    	jne    803eb7 <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ccd:	c1 e0 04             	shl    $0x4,%eax
  803cd0:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803cd5:	8b 00                	mov    (%eax),%eax
  803cd7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803cda:	eb 2a                	jmp    803d06 <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  803cdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cdf:	83 ec 0c             	sub    $0xc,%esp
  803ce2:	50                   	push   %eax
  803ce3:	e8 b0 f7 ff ff       	call   803498 <to_page_info>
  803ce8:	83 c4 10             	add    $0x10,%esp
  803ceb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803cee:	75 06                	jne    803cf6 <free_block+0x16a>
				tmp = b;
  803cf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cf3:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cf9:	c1 e0 04             	shl    $0x4,%eax
  803cfc:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803d01:	8b 00                	mov    (%eax),%eax
  803d03:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803d06:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d0a:	74 07                	je     803d13 <free_block+0x187>
  803d0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d0f:	8b 00                	mov    (%eax),%eax
  803d11:	eb 05                	jmp    803d18 <free_block+0x18c>
  803d13:	b8 00 00 00 00       	mov    $0x0,%eax
  803d18:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d1b:	c1 e2 04             	shl    $0x4,%edx
  803d1e:	81 c2 a8 50 83 00    	add    $0x8350a8,%edx
  803d24:	89 02                	mov    %eax,(%edx)
  803d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d29:	c1 e0 04             	shl    $0x4,%eax
  803d2c:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803d31:	8b 00                	mov    (%eax),%eax
  803d33:	85 c0                	test   %eax,%eax
  803d35:	75 a5                	jne    803cdc <free_block+0x150>
  803d37:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d3b:	75 9f                	jne    803cdc <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  803d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d40:	c1 e0 04             	shl    $0x4,%eax
  803d43:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803d48:	8b 00                	mov    (%eax),%eax
  803d4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  803d4d:	e9 cc 00 00 00       	jmp    803e1e <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  803d52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d55:	8b 00                	mov    (%eax),%eax
  803d57:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  803d5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d5d:	83 ec 0c             	sub    $0xc,%esp
  803d60:	50                   	push   %eax
  803d61:	e8 32 f7 ff ff       	call   803498 <to_page_info>
  803d66:	83 c4 10             	add    $0x10,%esp
  803d69:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803d6c:	0f 85 a6 00 00 00    	jne    803e18 <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  803d72:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d76:	75 17                	jne    803d8f <free_block+0x203>
  803d78:	83 ec 04             	sub    $0x4,%esp
  803d7b:	68 5d 4a 80 00       	push   $0x804a5d
  803d80:	68 b5 00 00 00       	push   $0xb5
  803d85:	68 c3 49 80 00       	push   $0x8049c3
  803d8a:	e8 d3 c6 ff ff       	call   800462 <_panic>
  803d8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d92:	8b 00                	mov    (%eax),%eax
  803d94:	85 c0                	test   %eax,%eax
  803d96:	74 10                	je     803da8 <free_block+0x21c>
  803d98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d9b:	8b 00                	mov    (%eax),%eax
  803d9d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803da0:	8b 52 04             	mov    0x4(%edx),%edx
  803da3:	89 50 04             	mov    %edx,0x4(%eax)
  803da6:	eb 14                	jmp    803dbc <free_block+0x230>
  803da8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dab:	8b 40 04             	mov    0x4(%eax),%eax
  803dae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803db1:	c1 e2 04             	shl    $0x4,%edx
  803db4:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803dba:	89 02                	mov    %eax,(%edx)
  803dbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dbf:	8b 40 04             	mov    0x4(%eax),%eax
  803dc2:	85 c0                	test   %eax,%eax
  803dc4:	74 0f                	je     803dd5 <free_block+0x249>
  803dc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dc9:	8b 40 04             	mov    0x4(%eax),%eax
  803dcc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803dcf:	8b 12                	mov    (%edx),%edx
  803dd1:	89 10                	mov    %edx,(%eax)
  803dd3:	eb 13                	jmp    803de8 <free_block+0x25c>
  803dd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dd8:	8b 00                	mov    (%eax),%eax
  803dda:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ddd:	c1 e2 04             	shl    $0x4,%edx
  803de0:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803de6:	89 02                	mov    %eax,(%edx)
  803de8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803deb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803df1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803df4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dfe:	c1 e0 04             	shl    $0x4,%eax
  803e01:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803e06:	8b 00                	mov    (%eax),%eax
  803e08:	8d 50 ff             	lea    -0x1(%eax),%edx
  803e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e0e:	c1 e0 04             	shl    $0x4,%eax
  803e11:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803e16:	89 10                	mov    %edx,(%eax)
			b = next;
  803e18:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  803e1e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803e22:	0f 85 2a ff ff ff    	jne    803d52 <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  803e28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e2b:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  803e31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e34:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  803e3a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803e3e:	75 17                	jne    803e57 <free_block+0x2cb>
  803e40:	83 ec 04             	sub    $0x4,%esp
  803e43:	68 cc 4a 80 00       	push   $0x804acc
  803e48:	68 bc 00 00 00       	push   $0xbc
  803e4d:	68 c3 49 80 00       	push   $0x8049c3
  803e52:	e8 0b c6 ff ff       	call   800462 <_panic>
  803e57:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803e5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e60:	89 10                	mov    %edx,(%eax)
  803e62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e65:	8b 00                	mov    (%eax),%eax
  803e67:	85 c0                	test   %eax,%eax
  803e69:	74 0d                	je     803e78 <free_block+0x2ec>
  803e6b:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803e70:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e73:	89 50 04             	mov    %edx,0x4(%eax)
  803e76:	eb 08                	jmp    803e80 <free_block+0x2f4>
  803e78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e7b:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803e80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e83:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803e88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e8b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e92:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803e97:	40                   	inc    %eax
  803e98:	a3 74 d0 81 00       	mov    %eax,0x81d074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  803e9d:	83 ec 0c             	sub    $0xc,%esp
  803ea0:	ff 75 ec             	pushl  -0x14(%ebp)
  803ea3:	e8 7e f5 ff ff       	call   803426 <to_page_va>
  803ea8:	83 c4 10             	add    $0x10,%esp
  803eab:	83 ec 0c             	sub    $0xc,%esp
  803eae:	50                   	push   %eax
  803eaf:	e8 fe d7 ff ff       	call   8016b2 <return_page>
  803eb4:	83 c4 10             	add    $0x10,%esp
	}
}
  803eb7:	90                   	nop
  803eb8:	c9                   	leave  
  803eb9:	c3                   	ret    
  803eba:	66 90                	xchg   %ax,%ax

00803ebc <__udivdi3>:
  803ebc:	55                   	push   %ebp
  803ebd:	57                   	push   %edi
  803ebe:	56                   	push   %esi
  803ebf:	53                   	push   %ebx
  803ec0:	83 ec 1c             	sub    $0x1c,%esp
  803ec3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803ec7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803ecb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803ecf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803ed3:	89 ca                	mov    %ecx,%edx
  803ed5:	89 f8                	mov    %edi,%eax
  803ed7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803edb:	85 f6                	test   %esi,%esi
  803edd:	75 2d                	jne    803f0c <__udivdi3+0x50>
  803edf:	39 cf                	cmp    %ecx,%edi
  803ee1:	77 65                	ja     803f48 <__udivdi3+0x8c>
  803ee3:	89 fd                	mov    %edi,%ebp
  803ee5:	85 ff                	test   %edi,%edi
  803ee7:	75 0b                	jne    803ef4 <__udivdi3+0x38>
  803ee9:	b8 01 00 00 00       	mov    $0x1,%eax
  803eee:	31 d2                	xor    %edx,%edx
  803ef0:	f7 f7                	div    %edi
  803ef2:	89 c5                	mov    %eax,%ebp
  803ef4:	31 d2                	xor    %edx,%edx
  803ef6:	89 c8                	mov    %ecx,%eax
  803ef8:	f7 f5                	div    %ebp
  803efa:	89 c1                	mov    %eax,%ecx
  803efc:	89 d8                	mov    %ebx,%eax
  803efe:	f7 f5                	div    %ebp
  803f00:	89 cf                	mov    %ecx,%edi
  803f02:	89 fa                	mov    %edi,%edx
  803f04:	83 c4 1c             	add    $0x1c,%esp
  803f07:	5b                   	pop    %ebx
  803f08:	5e                   	pop    %esi
  803f09:	5f                   	pop    %edi
  803f0a:	5d                   	pop    %ebp
  803f0b:	c3                   	ret    
  803f0c:	39 ce                	cmp    %ecx,%esi
  803f0e:	77 28                	ja     803f38 <__udivdi3+0x7c>
  803f10:	0f bd fe             	bsr    %esi,%edi
  803f13:	83 f7 1f             	xor    $0x1f,%edi
  803f16:	75 40                	jne    803f58 <__udivdi3+0x9c>
  803f18:	39 ce                	cmp    %ecx,%esi
  803f1a:	72 0a                	jb     803f26 <__udivdi3+0x6a>
  803f1c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803f20:	0f 87 9e 00 00 00    	ja     803fc4 <__udivdi3+0x108>
  803f26:	b8 01 00 00 00       	mov    $0x1,%eax
  803f2b:	89 fa                	mov    %edi,%edx
  803f2d:	83 c4 1c             	add    $0x1c,%esp
  803f30:	5b                   	pop    %ebx
  803f31:	5e                   	pop    %esi
  803f32:	5f                   	pop    %edi
  803f33:	5d                   	pop    %ebp
  803f34:	c3                   	ret    
  803f35:	8d 76 00             	lea    0x0(%esi),%esi
  803f38:	31 ff                	xor    %edi,%edi
  803f3a:	31 c0                	xor    %eax,%eax
  803f3c:	89 fa                	mov    %edi,%edx
  803f3e:	83 c4 1c             	add    $0x1c,%esp
  803f41:	5b                   	pop    %ebx
  803f42:	5e                   	pop    %esi
  803f43:	5f                   	pop    %edi
  803f44:	5d                   	pop    %ebp
  803f45:	c3                   	ret    
  803f46:	66 90                	xchg   %ax,%ax
  803f48:	89 d8                	mov    %ebx,%eax
  803f4a:	f7 f7                	div    %edi
  803f4c:	31 ff                	xor    %edi,%edi
  803f4e:	89 fa                	mov    %edi,%edx
  803f50:	83 c4 1c             	add    $0x1c,%esp
  803f53:	5b                   	pop    %ebx
  803f54:	5e                   	pop    %esi
  803f55:	5f                   	pop    %edi
  803f56:	5d                   	pop    %ebp
  803f57:	c3                   	ret    
  803f58:	bd 20 00 00 00       	mov    $0x20,%ebp
  803f5d:	89 eb                	mov    %ebp,%ebx
  803f5f:	29 fb                	sub    %edi,%ebx
  803f61:	89 f9                	mov    %edi,%ecx
  803f63:	d3 e6                	shl    %cl,%esi
  803f65:	89 c5                	mov    %eax,%ebp
  803f67:	88 d9                	mov    %bl,%cl
  803f69:	d3 ed                	shr    %cl,%ebp
  803f6b:	89 e9                	mov    %ebp,%ecx
  803f6d:	09 f1                	or     %esi,%ecx
  803f6f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803f73:	89 f9                	mov    %edi,%ecx
  803f75:	d3 e0                	shl    %cl,%eax
  803f77:	89 c5                	mov    %eax,%ebp
  803f79:	89 d6                	mov    %edx,%esi
  803f7b:	88 d9                	mov    %bl,%cl
  803f7d:	d3 ee                	shr    %cl,%esi
  803f7f:	89 f9                	mov    %edi,%ecx
  803f81:	d3 e2                	shl    %cl,%edx
  803f83:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f87:	88 d9                	mov    %bl,%cl
  803f89:	d3 e8                	shr    %cl,%eax
  803f8b:	09 c2                	or     %eax,%edx
  803f8d:	89 d0                	mov    %edx,%eax
  803f8f:	89 f2                	mov    %esi,%edx
  803f91:	f7 74 24 0c          	divl   0xc(%esp)
  803f95:	89 d6                	mov    %edx,%esi
  803f97:	89 c3                	mov    %eax,%ebx
  803f99:	f7 e5                	mul    %ebp
  803f9b:	39 d6                	cmp    %edx,%esi
  803f9d:	72 19                	jb     803fb8 <__udivdi3+0xfc>
  803f9f:	74 0b                	je     803fac <__udivdi3+0xf0>
  803fa1:	89 d8                	mov    %ebx,%eax
  803fa3:	31 ff                	xor    %edi,%edi
  803fa5:	e9 58 ff ff ff       	jmp    803f02 <__udivdi3+0x46>
  803faa:	66 90                	xchg   %ax,%ax
  803fac:	8b 54 24 08          	mov    0x8(%esp),%edx
  803fb0:	89 f9                	mov    %edi,%ecx
  803fb2:	d3 e2                	shl    %cl,%edx
  803fb4:	39 c2                	cmp    %eax,%edx
  803fb6:	73 e9                	jae    803fa1 <__udivdi3+0xe5>
  803fb8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803fbb:	31 ff                	xor    %edi,%edi
  803fbd:	e9 40 ff ff ff       	jmp    803f02 <__udivdi3+0x46>
  803fc2:	66 90                	xchg   %ax,%ax
  803fc4:	31 c0                	xor    %eax,%eax
  803fc6:	e9 37 ff ff ff       	jmp    803f02 <__udivdi3+0x46>
  803fcb:	90                   	nop

00803fcc <__umoddi3>:
  803fcc:	55                   	push   %ebp
  803fcd:	57                   	push   %edi
  803fce:	56                   	push   %esi
  803fcf:	53                   	push   %ebx
  803fd0:	83 ec 1c             	sub    $0x1c,%esp
  803fd3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803fd7:	8b 74 24 34          	mov    0x34(%esp),%esi
  803fdb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803fdf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803fe3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803fe7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803feb:	89 f3                	mov    %esi,%ebx
  803fed:	89 fa                	mov    %edi,%edx
  803fef:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ff3:	89 34 24             	mov    %esi,(%esp)
  803ff6:	85 c0                	test   %eax,%eax
  803ff8:	75 1a                	jne    804014 <__umoddi3+0x48>
  803ffa:	39 f7                	cmp    %esi,%edi
  803ffc:	0f 86 a2 00 00 00    	jbe    8040a4 <__umoddi3+0xd8>
  804002:	89 c8                	mov    %ecx,%eax
  804004:	89 f2                	mov    %esi,%edx
  804006:	f7 f7                	div    %edi
  804008:	89 d0                	mov    %edx,%eax
  80400a:	31 d2                	xor    %edx,%edx
  80400c:	83 c4 1c             	add    $0x1c,%esp
  80400f:	5b                   	pop    %ebx
  804010:	5e                   	pop    %esi
  804011:	5f                   	pop    %edi
  804012:	5d                   	pop    %ebp
  804013:	c3                   	ret    
  804014:	39 f0                	cmp    %esi,%eax
  804016:	0f 87 ac 00 00 00    	ja     8040c8 <__umoddi3+0xfc>
  80401c:	0f bd e8             	bsr    %eax,%ebp
  80401f:	83 f5 1f             	xor    $0x1f,%ebp
  804022:	0f 84 ac 00 00 00    	je     8040d4 <__umoddi3+0x108>
  804028:	bf 20 00 00 00       	mov    $0x20,%edi
  80402d:	29 ef                	sub    %ebp,%edi
  80402f:	89 fe                	mov    %edi,%esi
  804031:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804035:	89 e9                	mov    %ebp,%ecx
  804037:	d3 e0                	shl    %cl,%eax
  804039:	89 d7                	mov    %edx,%edi
  80403b:	89 f1                	mov    %esi,%ecx
  80403d:	d3 ef                	shr    %cl,%edi
  80403f:	09 c7                	or     %eax,%edi
  804041:	89 e9                	mov    %ebp,%ecx
  804043:	d3 e2                	shl    %cl,%edx
  804045:	89 14 24             	mov    %edx,(%esp)
  804048:	89 d8                	mov    %ebx,%eax
  80404a:	d3 e0                	shl    %cl,%eax
  80404c:	89 c2                	mov    %eax,%edx
  80404e:	8b 44 24 08          	mov    0x8(%esp),%eax
  804052:	d3 e0                	shl    %cl,%eax
  804054:	89 44 24 04          	mov    %eax,0x4(%esp)
  804058:	8b 44 24 08          	mov    0x8(%esp),%eax
  80405c:	89 f1                	mov    %esi,%ecx
  80405e:	d3 e8                	shr    %cl,%eax
  804060:	09 d0                	or     %edx,%eax
  804062:	d3 eb                	shr    %cl,%ebx
  804064:	89 da                	mov    %ebx,%edx
  804066:	f7 f7                	div    %edi
  804068:	89 d3                	mov    %edx,%ebx
  80406a:	f7 24 24             	mull   (%esp)
  80406d:	89 c6                	mov    %eax,%esi
  80406f:	89 d1                	mov    %edx,%ecx
  804071:	39 d3                	cmp    %edx,%ebx
  804073:	0f 82 87 00 00 00    	jb     804100 <__umoddi3+0x134>
  804079:	0f 84 91 00 00 00    	je     804110 <__umoddi3+0x144>
  80407f:	8b 54 24 04          	mov    0x4(%esp),%edx
  804083:	29 f2                	sub    %esi,%edx
  804085:	19 cb                	sbb    %ecx,%ebx
  804087:	89 d8                	mov    %ebx,%eax
  804089:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80408d:	d3 e0                	shl    %cl,%eax
  80408f:	89 e9                	mov    %ebp,%ecx
  804091:	d3 ea                	shr    %cl,%edx
  804093:	09 d0                	or     %edx,%eax
  804095:	89 e9                	mov    %ebp,%ecx
  804097:	d3 eb                	shr    %cl,%ebx
  804099:	89 da                	mov    %ebx,%edx
  80409b:	83 c4 1c             	add    $0x1c,%esp
  80409e:	5b                   	pop    %ebx
  80409f:	5e                   	pop    %esi
  8040a0:	5f                   	pop    %edi
  8040a1:	5d                   	pop    %ebp
  8040a2:	c3                   	ret    
  8040a3:	90                   	nop
  8040a4:	89 fd                	mov    %edi,%ebp
  8040a6:	85 ff                	test   %edi,%edi
  8040a8:	75 0b                	jne    8040b5 <__umoddi3+0xe9>
  8040aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8040af:	31 d2                	xor    %edx,%edx
  8040b1:	f7 f7                	div    %edi
  8040b3:	89 c5                	mov    %eax,%ebp
  8040b5:	89 f0                	mov    %esi,%eax
  8040b7:	31 d2                	xor    %edx,%edx
  8040b9:	f7 f5                	div    %ebp
  8040bb:	89 c8                	mov    %ecx,%eax
  8040bd:	f7 f5                	div    %ebp
  8040bf:	89 d0                	mov    %edx,%eax
  8040c1:	e9 44 ff ff ff       	jmp    80400a <__umoddi3+0x3e>
  8040c6:	66 90                	xchg   %ax,%ax
  8040c8:	89 c8                	mov    %ecx,%eax
  8040ca:	89 f2                	mov    %esi,%edx
  8040cc:	83 c4 1c             	add    $0x1c,%esp
  8040cf:	5b                   	pop    %ebx
  8040d0:	5e                   	pop    %esi
  8040d1:	5f                   	pop    %edi
  8040d2:	5d                   	pop    %ebp
  8040d3:	c3                   	ret    
  8040d4:	3b 04 24             	cmp    (%esp),%eax
  8040d7:	72 06                	jb     8040df <__umoddi3+0x113>
  8040d9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8040dd:	77 0f                	ja     8040ee <__umoddi3+0x122>
  8040df:	89 f2                	mov    %esi,%edx
  8040e1:	29 f9                	sub    %edi,%ecx
  8040e3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8040e7:	89 14 24             	mov    %edx,(%esp)
  8040ea:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8040ee:	8b 44 24 04          	mov    0x4(%esp),%eax
  8040f2:	8b 14 24             	mov    (%esp),%edx
  8040f5:	83 c4 1c             	add    $0x1c,%esp
  8040f8:	5b                   	pop    %ebx
  8040f9:	5e                   	pop    %esi
  8040fa:	5f                   	pop    %edi
  8040fb:	5d                   	pop    %ebp
  8040fc:	c3                   	ret    
  8040fd:	8d 76 00             	lea    0x0(%esi),%esi
  804100:	2b 04 24             	sub    (%esp),%eax
  804103:	19 fa                	sbb    %edi,%edx
  804105:	89 d1                	mov    %edx,%ecx
  804107:	89 c6                	mov    %eax,%esi
  804109:	e9 71 ff ff ff       	jmp    80407f <__umoddi3+0xb3>
  80410e:	66 90                	xchg   %ax,%ax
  804110:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804114:	72 ea                	jb     804100 <__umoddi3+0x134>
  804116:	89 d9                	mov    %ebx,%ecx
  804118:	e9 62 ff ff ff       	jmp    80407f <__umoddi3+0xb3>
